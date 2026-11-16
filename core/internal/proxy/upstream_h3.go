package proxy

import (
        "context"
        "crypto/tls"
        "errors"
        "fmt"
        "io"
        "net"
        "net/http"
        "net/netip"
        "net/url"
        "strconv"
        "strings"
        "sync"
        "time"

        "github.com/quic-go/quic-go"
        "github.com/quic-go/quic-go/http3"

        "github.com/armanlife/arman-vpn-client/core/internal/controlplane"
        "github.com/armanlife/arman-vpn-client/core/internal/egress"
        "github.com/armanlife/arman-vpn-client/core/internal/logx"
)

var errProxyHTTP3Unavailable = errors.New("proxy did not negotiate HTTP/3")

var upstreamH3TLSSessions = tls.NewLRUClientSessionCache(32)

// The QUIC flow-control windows, in bytes: how much the server may put
// on one stream, and on the whole connection, ahead of what arrived
// here. quic-go grows its windows on its own, but from a 512 KiB start
// that takes round trips to ramp on the long round trip a busy evening
// gives, and stops at 6 MiB — a single tunnel's speed was left behind
// what the network carried. The starts here open fast and the ceilings
// leave room for the growth: a stream may hold 8 MiB, the connection
// 16 MiB, before anything has to wait.
const (
        upstreamH3InitialStreamWindow = 2 << 20
        upstreamH3MaxStreamWindow     = 8 << 20
        upstreamH3InitialConnWindow   = 4 << 20
        upstreamH3MaxConnWindow       = 16 << 20
        // upstreamH3KeepAlivePeriod keeps the network's own UDP mapping alive
        // while the tunnel idles: a carrier's NAT forgets an idle UDP flow in
        // anything from half a minute, and then every packet of the session
        // falls on the floor — the on-and-off the user calls قطع وصل. Half
        // the mapping's shortest patience keeps it; two keepalives also fit
        // inside the idle timeout, so one lost answer no longer ends the
        // session the moment the timer runs out.
        upstreamH3KeepAlivePeriod = 15 * time.Second
        // upstreamH3MaxIdleTimeout rides out a lost keepalive answer instead
        // of quic-go's default, which dies at 30 seconds idle — the same
        // moment the keepalive goes out.
        upstreamH3MaxIdleTimeout = 60 * time.Second
)

// h3ProxySession holds a single QUIC connection used for HTTP/3 CONNECT tunnels.
type h3ProxySession struct {
        conn      *quic.Conn
        udpConn   *net.UDPConn
        rt        *http3.Transport
        proxyHost string
        token     string
        timeout   time.Duration
        tokenMu   sync.RWMutex
        health    sessionFailureTracker
        closeOnce sync.Once
        closeErr  error
}

func newH3ProxySession(proxyURL *url.URL, token string, timeout time.Duration) (*h3ProxySession, error) {
        host := proxyURL.Hostname()
        portStr := proxyURL.Port()
        if portStr == "" {
                portStr = "443"
        }
        port, err := strconv.Atoi(portStr)
        if err != nil {
                return nil, fmt.Errorf("invalid proxy port %q: %w", portStr, err)
        }
        proxyHost := net.JoinHostPort(host, portStr)

        ctx := context.Background()
        cancel := func() {}
        if timeout > 0 {
                ctx, cancel = context.WithTimeout(context.Background(), timeout)
        }
        defer cancel()

        tlsCfg := &tls.Config{
                RootCAs:    upstreamRoots.Load(),
                ServerName: host,
                MinVersion: tls.VersionTLS13,
                NextProtos: []string{"h3"},
                // Resumes TLS on a reconnection; HTTP/2 has its own cache.
                ClientSessionCache: upstreamH3TLSSessions,
        }
        quicCfg := &quic.Config{
                KeepAlivePeriod: upstreamH3KeepAlivePeriod,
                MaxIdleTimeout:  upstreamH3MaxIdleTimeout,
                // The windows a download needs on the long round trip to
                // Mozilla (upstreamH3* above).
                InitialStreamReceiveWindow:     upstreamH3InitialStreamWindow,
                MaxStreamReceiveWindow:         upstreamH3MaxStreamWindow,
                InitialConnectionReceiveWindow: upstreamH3InitialConnWindow,
                MaxConnectionReceiveWindow:     upstreamH3MaxConnWindow,
                // Default InitialPacketSize (1280) is the QUIC payload size;
                // once IP/UDP headers are added it exceeds low-MTU links so every initial packet gets dropped and the handshake times out with no QUIC traffic visible on the wire.
                // Start below the RFC 8899 floor so the handshake succeeds on any path; PMTU discovery grows it back up.
                InitialPacketSize: 1200,
        }

        // dialAll tries ips in turn, sharing budget (0: ctx alone limits it).
        dialAll := func(ips []netip.Addr, budget time.Duration) (*quic.Conn, *net.UDPConn, error) {
                var perAttempt time.Duration
                if budget > 0 {
                        perAttempt = budget / time.Duration(len(ips))
                        if perAttempt < 3*time.Second {
                                perAttempt = 3 * time.Second
                        }
                }
                var lastErr error
                for _, ip := range ips {
                        // Of ip's family, and outside the TUN adapter while the TUN mode
                        // runs.
                        uc, err := egress.ListenUDP(ip)
                        if err != nil {
                                lastErr = err
                                continue
                        }
                        udpAddr := &net.UDPAddr{IP: ip.AsSlice(), Port: port, Zone: ip.Zone()}
                        attemptCtx := ctx
                        attemptCancel := func() {}
                        if perAttempt > 0 {
                                attemptCtx, attemptCancel = context.WithTimeout(ctx, perAttempt)
                        }
                        c, err := quic.Dial(attemptCtx, uc, udpAddr, tlsCfg, quicCfg)
                        attemptCancel()
                        if err != nil {
                                _ = uc.Close()
                                lastErr = fmt.Errorf("dial %s: %w", udpAddr, err)
                                continue
                        }
                        return c, uc, nil
                }
                return nil, nil, lastErr
        }

        // proxy.ip_version's steps (ipversion.go): each one's addresses in
        // turn, a step that another follows taking half the time left.
        steps := upstreamSteps()
        var (
                conn    *quic.Conn
                udpConn *net.UDPConn
                failed  stepError
        )
        for i, step := range steps {
                ips, err := upstreamAddrs(ctx, host, step)
                if err == nil && len(ips) == 0 {
                        err = noAddrsError(host, step)
                }
                if err != nil {
                        failed.note(step, fmt.Errorf("resolve %s: %w", host, err))
                        continue
                }
                budget := timeout
                if i < len(steps)-1 && budget > 0 {
                        budget /= 2
                }
                if conn, udpConn, err = dialAll(ips, budget); err == nil {
                        if i > 0 {
                                logx.Info("Mozilla's server answered over %s after %s failed proxy=%s err=%s", stepName(step), stepName(steps[0]), proxyHost, logx.Err(failed.first))
                        }
                        break
                }
                failed.note(step, err)
                if ctx.Err() != nil {
                        break
                }
        }
        lastErr := failed.err()
        if conn == nil {
                return nil, lastErr
        }

        if conn.ConnectionState().TLS.NegotiatedProtocol != "h3" {
                _ = conn.CloseWithError(0, "")
                _ = udpConn.Close()
                return nil, errProxyHTTP3Unavailable
        }
        logx.Info("upstream HTTP/3 session established proxy=%s remote=%s", proxyHost, conn.RemoteAddr())

        rt := &http3.Transport{
                Dial: func(_ context.Context, addr string, tlsCfg *tls.Config, cfg *quic.Config) (*quic.Conn, error) {
                        return conn, nil
                },
        }

        return &h3ProxySession{
                conn:      conn,
                udpConn:   udpConn,
                rt:        rt,
                proxyHost: proxyHost,
                token:     token,
                timeout:   timeout,
        }, nil
}

func (s *h3ProxySession) OpenTunnel(authority string) (net.Conn, error) {
        reqBody := newTunnelWriteBuffer(defaultTunnelWriteBufSize)
        resp, cancel, err := roundTripWithOpenTimeout(s.timeout, func(ctx context.Context) (*http.Response, error) {
                req, err := http.NewRequestWithContext(ctx, http.MethodConnect, "https://"+authority, reqBody)
                if err != nil {
                        return nil, err
                }
                req.Host = authority
                req.URL.Host = s.proxyHost
                req.Header.Set("Proxy-Authorization", "Bearer "+s.bearerToken())
                // As Firefox's CONNECT; quic-go would otherwise name itself.
                req.Header.Set("User-Agent", controlplane.FirefoxUserAgent())
                return s.rt.RoundTrip(req)
        })
        if err != nil {
                reqBody.failRead(io.ErrClosedPipe)
                return nil, s.health.observe(authority, err)
        }
        if resp.StatusCode < 200 || resp.StatusCode > 299 {
                cancel()
                body, _ := io.ReadAll(io.LimitReader(resp.Body, 2048))
                _ = resp.Body.Close()
                reqBody.failRead(io.ErrClosedPipe)
                return nil, s.health.observe(authority, &proxyConnectHTTPError{
                        statusCode: resp.StatusCode,
                        status:     resp.Status,
                        body:       strings.TrimSpace(string(body)),
                })
        }
        s.health.observe(authority, nil)

        return &tunnelConn{
                reader:  resp.Body,
                writer:  reqBody,
                reqBody: reqBody,
                name:    "h3-connect-stream",
                cancel:  cancel,
        }, nil
}

func (s *h3ProxySession) bearerToken() string {
        s.tokenMu.RLock()
        defer s.tokenMu.RUnlock()
        return s.token
}

func (s *h3ProxySession) UpdateToken(token string) error {
        if strings.TrimSpace(token) == "" {
                return fmt.Errorf("empty proxy session token")
        }
        s.tokenMu.Lock()
        s.token = token
        s.tokenMu.Unlock()
        return nil
}

func (s *h3ProxySession) Close() error {
        s.closeOnce.Do(func() {
                if s.rt != nil {
                        _ = s.rt.Close()
                }
                if s.conn != nil {
                        s.closeErr = s.conn.CloseWithError(0, "")
                }
                if s.udpConn != nil {
                        if closeErr := s.udpConn.Close(); s.closeErr == nil {
                                s.closeErr = closeErr
                        }
                }
        })
        return s.closeErr
}
