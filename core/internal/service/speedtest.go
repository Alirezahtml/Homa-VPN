package service

import (
        "context"
        "crypto/tls"
        "encoding/json"
        "fmt"
        "io"
        "net"
        "net/http"
        "sync"
        "sync/atomic"
        "time"

        "github.com/armanlife/arman-vpn-client/core/internal/logx"
)

// The speed test measures what the tunnel really carries: it downloads and
// uploads from speed.cloudflare.com through the same path a client flow
// takes (the engine's own tunnel opening), so the numbers say what the
// user's apps would see. With the proxy off, the same two transfers go
// out directly, so the user can compare the raw network with the tunnel.
const (
        speedTestHost        = "speed.cloudflare.com"
        speedTestDownDefault = 25 << 20 // 25 MiB
        speedTestUpDefault   = 8 << 20  // 8 MiB
        speedTestDownMax     = 64 << 20
        speedTestUpMax       = 32 << 20
        speedTestDirTimeout  = 20 * time.Second
        speedTestTick        = 250 * time.Millisecond
)

type speedTestProgress struct {
        Type  string `json:"type"`
        Dir   string `json:"dir"`
        Bytes int64  `json:"bytes"`
        BPS   int64  `json:"bps"`
}

type speedTestResult struct {
        OK            bool   `json:"ok"`
        ThroughTunnel bool   `json:"through_tunnel"`
        DownBPS       int64  `json:"down_bps"`
        UpBPS         int64  `json:"up_bps"`
        DownBytes     int64  `json:"down_bytes"`
        UpBytes       int64  `json:"up_bytes"`
        TotalMS       int64  `json:"total_ms"`
        Error         string `json:"error,omitempty"`
}

// speedCountingBody counts what the transport reads from or writes to the
// body, and answers Read after the test's deadline.
type speedCountingBody struct {
        io.ReadCloser
        n *counting64
}

func (b speedCountingBody) Read(p []byte) (int, error) {
        n, err := b.ReadCloser.Read(p)
        b.n.add(int64(n))
        return n, err
}

// speedCountingReader is the upload's body: every byte the transport takes
// from it counts as sent.
type speedCountingReader struct {
        r  io.Reader
        n  *counting64
        up bool
}

func (r *speedCountingReader) Read(p []byte) (int, error) {
        n, err := r.r.Read(p)
        r.n.add(int64(n))
        return n, err
}

// counting64 is one shared counter the progress ticker reads.
type counting64 struct {
        mu sync.Mutex
        n  int64
}

func (c *counting64) add(n int64) { c.mu.Lock(); c.n += n; c.mu.Unlock() }
func (c *counting64) get() int64 {
        c.mu.Lock()
        defer c.mu.Unlock()
        return c.n
}

// runSpeedTest measures download, then upload, reporting progress ticks as
// they happen. The tunnel conn, when on, is the engine's own opening, so
// the transfers are accounted like any client's traffic. A nil emit (the
// dashboard's answer without the stream) keeps the test's numbers but
// never speaks: the ticker's notes go nowhere instead of crashing on the
// call.
func (d *Daemon) runSpeedTest(parent context.Context, downBytes, upBytes int64, emit func(speedTestProgress)) speedTestResult {
        if emit == nil {
                emit = func(speedTestProgress) {}
        }
        started := time.Now()
        result := speedTestResult{ThroughTunnel: true}
        if downBytes <= 0 {
                downBytes = speedTestDownDefault
        }
        if upBytes <= 0 {
                upBytes = speedTestUpDefault
        }
        downBytes = min(downBytes, speedTestDownMax)
        upBytes = min(upBytes, speedTestUpMax)

        engine := d.currentEngine()
        var conn net.Conn
        if engine != nil {
                controller, release, err := d.useController(engine, wakeForTest)
                if err == nil {
                        conn, err = controller.OpenTunnel(net.JoinHostPort(speedTestHost, "443"))
                        release()
                        if err != nil {
                                conn = nil
                                result.Error = logx.Err(err)
                        }
                } else {
                        result.Error = logx.Err(err)
                }
        }
        if conn == nil {
                result.ThroughTunnel = false
                if result.Error != "" {
                        result.TotalMS = time.Since(started).Milliseconds()
                        return result
                }
                // The proxy is off: the same transfers go out directly, so the
                // numbers still mean something (the raw network's own speed).
                var dialer net.Dialer
                raw, err := dialer.DialContext(parent, "tcp", net.JoinHostPort(speedTestHost, "443"))
                if err != nil {
                        result.Error = logx.Err(err)
                        result.TotalMS = time.Since(started).Milliseconds()
                        return result
                }
                conn = raw
        }
        defer conn.Close()

        // TLS to the measuring host over the tunnel; the tunnel only forwards
        // bytes, so the handshake and the certificate check run here as usual.
        tlsConn := tls.Client(conn, &tls.Config{ServerName: speedTestHost, MinVersion: tls.VersionTLS12})
        if err := tlsConn.HandshakeContext(parent); err != nil {
                result.Error = logx.Err(err)
                result.TotalMS = time.Since(started).Milliseconds()
                return result
        }
        transport := &http.Transport{
                // One TLS connection carries both legs, one after the other.
                DialTLSContext: func(context.Context, string, string) (net.Conn, error) { return tlsConn, nil },
        }
        client := &http.Client{Transport: transport}

        counters := struct {
                down counting64
                up   counting64
        }{}
        var legStart atomic.Int64 // the running leg's start, unix nanoseconds
        var wg sync.WaitGroup
        stop := make(chan struct{})
        wg.Add(1)
        go func() { // one progress tick every speedTestTick while either leg runs
                defer wg.Done()
                ticker := time.NewTicker(speedTestTick)
                defer ticker.Stop()
                for {
                        select {
                        case <-stop:
                                return
                        case <-ticker.C:
                                start := time.Unix(0, legStart.Load())
                                seconds := max(1, int64(time.Since(start).Seconds()))
                                if down := counters.down.get(); down > 0 {
                                        emit(speedTestProgress{"progress", "down", down, down / seconds})
                                }
                                if up := counters.up.get(); up > 0 {
                                        emit(speedTestProgress{"progress", "up", up, up / seconds})
                                }
                        }
                }
        }()

        // Download: one streaming GET, counted as the body arrives.
        legCtx, legStop := context.WithTimeout(parent, speedTestDirTimeout)
        req, _ := http.NewRequestWithContext(legCtx, http.MethodGet,
                fmt.Sprintf("https://%s/__down?bytes=%d", speedTestHost, downBytes), nil)
        downStart := time.Now()
        legStart.Store(downStart.UnixNano())
        if resp, err := client.Do(req); err != nil {
                result.Error = logx.Err(err)
        } else {
                body := speedCountingBody{ReadCloser: resp.Body, n: &counters.down}
                _, copyErr := io.Copy(io.Discard, body)
                resp.Body.Close()
                result.DownBytes = counters.down.get()
                if copyErr == nil && result.DownBytes > 0 {
                        result.DownBPS = result.DownBytes * int64(time.Second) / max(1, int64(time.Since(downStart)))
                }
        }
        legStop()

        // Upload: one POST of zeros, counted as the transport takes the body.
        payload := make([]byte, min(upBytes, 1<<20))
        legCtx, legStop = context.WithTimeout(parent, speedTestDirTimeout)
        bodyReader := &speedCountingReader{r: newZeroReader(payload, upBytes), n: &counters.up}
        req, _ = http.NewRequestWithContext(legCtx, http.MethodPost,
                "https://"+speedTestHost+"/__up", bodyReader)
        req.ContentLength = upBytes
        upStart := time.Now()
        legStart.Store(upStart.UnixNano())
        if resp, err := client.Do(req); err != nil {
                result.Error = logx.Err(err)
        } else {
                io.Copy(io.Discard, io.LimitReader(resp.Body, 4096))
                resp.Body.Close()
                result.UpBytes = counters.up.get()
                if result.UpBytes > 0 {
                        result.UpBPS = result.UpBytes * int64(time.Second) / max(1, int64(time.Since(upStart)))
                }
        }
        legStop()
        close(stop)
        wg.Wait()

        if result.DownBytes == 0 && result.UpBytes == 0 && result.Error == "" {
                result.Error = "no bytes were measured"
        }
        result.OK = result.Error == "" && (result.DownBPS > 0 || result.UpBPS > 0)
        result.TotalMS = time.Since(started).Milliseconds()
        logx.Info("speed test through_tunnel=%t down=%d bps up=%d bps ms=%d",
                result.ThroughTunnel, result.DownBPS, result.UpBPS, result.TotalMS)
        return result
}

// newZeroReader answers len(payload) bytes at a time until want is served.
type zeroReader struct {
        payload []byte
        want    int64
}

func newZeroReader(payload []byte, want int64) *zeroReader {
        return &zeroReader{payload: payload, want: want}
}

func (r *zeroReader) Read(p []byte) (int, error) {
        if r.want <= 0 {
                return 0, io.EOF
        }
        n := min(int64(len(p)), int64(len(r.payload)), r.want)
        copy(p, r.payload[:n])
        r.want -= n
        return int(n), nil
}

func (s *dashboardServer) handleSpeedTest(w http.ResponseWriter, r *http.Request) {
        var in struct {
                DownBytes int64 `json:"down_bytes"`
                UpBytes   int64 `json:"up_bytes"`
                Stream    bool  `json:"stream"`
        }
        if !readJSON(w, r, &in) {
                return
        }
        ctx, cancel := context.WithCancel(r.Context())
        defer cancel()
        var emit func(speedTestProgress)
        encoder := json.NewEncoder(w)
        if in.Stream {
                w.Header().Set("Content-Type", "application/x-ndjson")
                w.Header().Set("Cache-Control", "no-store")
                emit = func(p speedTestProgress) {
                        if encoder.Encode(map[string]any{"type": p.Type, "progress": p}) != nil {
                                cancel()
                                return
                        }
                        if f, ok := w.(http.Flusher); ok {
                                f.Flush()
                        }
                }
        }
        result := s.d.runSpeedTest(ctx, in.DownBytes, in.UpBytes, emit)
        if in.Stream {
                encoder.Encode(map[string]any{"type": "result", "result": result})
                return
        }
        writeJSON(w, http.StatusOK, result)
}
