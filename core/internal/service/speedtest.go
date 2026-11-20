package service

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"sort"
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
//
// Each measurement — the latency probes, the download, the upload — runs
// on its own connection: a leg that ends in a deadline or an early body
// close never poisons the leg that follows, which is exactly what the
// multiplexed http2 layer did when the two legs shared one connection
// (the upload answered "http2: response body closed" and the panel read
// zeros). Every leg here speaks plain HTTP/1.1: a bandwidth test wants
// one open stream, not a multiplexer's bookkeeping.
const (
	speedTestHost        = "speed.cloudflare.com"
	speedTestDownDefault = 25 << 20 // 25 MiB
	speedTestUpDefault   = 8 << 20  // 8 MiB
	speedTestDownMax     = 64 << 20
	speedTestUpMax       = 32 << 20
	speedTestDirTimeout  = 20 * time.Second
	speedTestDialTimeout = 15 * time.Second
	speedTestTick        = 250 * time.Millisecond
	speedTestProbes      = 5
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
	LatencyMS     int64  `json:"latency_ms,omitempty"`
	JitterMS      int64  `json:"jitter_ms,omitempty"`
	TotalMS       int64  `json:"total_ms"`
	Error         string `json:"error,omitempty"`
}

// speedCountingBody counts what the transport reads from the body, and
// answers Read after the test's deadline.
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

// dialSpeedConn opens one plain TCP path to the measuring host: through
// the engine's own tunnel opening when the proxy runs (through=true), or
// straight out when it does not. The engine's own dial carries no extra
// timeout of ours — the controller owns its patience — the raw dial waits
// [speedTestDialTimeout] at the most.
func (d *Daemon) dialSpeedConn(parent context.Context) (net.Conn, bool, error) {
	if engine := d.currentEngine(); engine != nil {
		controller, release, err := d.useController(engine, wakeForTest)
		if err != nil {
			return nil, true, err
		}
		conn, err := controller.OpenTunnel(net.JoinHostPort(speedTestHost, "443"))
		release()
		if err != nil {
			return nil, true, err
		}
		return conn, true, nil
	}
	var dialer net.Dialer
	ctx, cancel := context.WithTimeout(parent, speedTestDialTimeout)
	defer cancel()
	raw, err := dialer.DialContext(ctx, "tcp", net.JoinHostPort(speedTestHost, "443"))
	if err != nil {
		return nil, false, err
	}
	return raw, false, nil
}

// speedTLS wraps [conn] in the measuring host's TLS — the certificate
// check runs as usual, the tunnel only forwards bytes — and speaks
// HTTP/1.1 only: with no h2 in the offer, no multiplexer stands between
// the legs and their bytes. The handshake keeps [parent]'s cancel too.
func speedTLS(parent context.Context, conn net.Conn) (*tls.Conn, error) {
	tlsConn := tls.Client(conn, &tls.Config{
		ServerName: speedTestHost,
		MinVersion: tls.VersionTLS12,
		// HTTP/1.1, said twice: in the handshake's own offer and in
		// the transport's protocol map (speedClient). One plain
		// stream per measurement.
		NextProtos: []string{"http/1.1"},
	})
	if err := tlsConn.HandshakeContext(parent); err != nil {
		conn.Close()
		return nil, err
	}
	return tlsConn, nil
}

// speedClient answers an HTTP client over [tlsConn]. The transport maps
// no protocols (the http2 layer's off switch), and keeps the connection
// alive only when [reuse] says so: the two legs each take a fresh
// connection and never reuse it, while the latency probes ride one
// connection so their runs measure the path, not five handshakes.
func speedClient(tlsConn *tls.Conn, reuse bool) *http.Client {
	return &http.Client{
		Transport: &http.Transport{
			DialTLSContext: func(context.Context, string, string) (net.Conn, error) {
				return tlsConn, nil
			},
			TLSNextProto:      map[string]func(string, *tls.Conn) http.RoundTripper{},
			DisableKeepAlives: !reuse,
			IdleConnTimeout:   5 * time.Second,
		},
	}
}

// probeLatency rides [conn] — one TLS connection, five empty GETs — and
// answers the runs' median as the delay and their wander as the jitter.
// A probe that lands nowhere just leaves the runs shorter; with none
// landing, ok says false and the panel shows no delay for the test.
func probeLatency(parent context.Context, conn net.Conn) (latencyMS, jitterMS int64, ok bool) {
	tlsConn, err := speedTLS(parent, conn)
	if err != nil {
		return 0, 0, false
	}
	defer tlsConn.Close()
	client := speedClient(tlsConn, true)
	var runs []int64
	for i := 0; i < speedTestProbes && parent.Err() == nil; i++ {
		ctx, cancel := context.WithTimeout(parent, speedTestDialTimeout)
		req, err := http.NewRequestWithContext(ctx, http.MethodGet,
			fmt.Sprintf("https://%s/__down?bytes=0", speedTestHost), nil)
		if err != nil {
			cancel()
			continue
		}
		start := time.Now()
		resp, err := client.Do(req)
		cancel()
		if err != nil {
			continue
		}
		io.Copy(io.Discard, io.LimitReader(resp.Body, 4096))
		resp.Body.Close()
		runs = append(runs, max(1, time.Since(start).Milliseconds()))
	}
	if len(runs) == 0 {
		return 0, 0, false
	}
	sort.Slice(runs, func(i, j int) bool { return runs[i] < runs[j] })
	latencyMS = runs[len(runs)/2]
	var wander int64
	for i := 1; i < len(runs); i++ {
		d := runs[i] - runs[i-1]
		if d < 0 {
			d = -d
		}
		wander += d
	}
	jitterMS = wander / max(1, int64(len(runs)-1))
	return latencyMS, jitterMS, true
}

// runSpeedTest measures the path's delay (five probes), then download,
// then upload, reporting progress ticks as they happen. Each leg dials
// its own connection and owns its own failure: a leg that hits its
// deadline keeps the bytes it carried (they still speak), and the test
// fails only when nothing was measured at all. A nil emit (the
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

	// The first dial says whether the test runs through the tunnel at
	// all: with no engine and no raw path, there is nothing to measure
	// and the test ends here.
	first, through, dialErr := d.dialSpeedConn(parent)
	result.ThroughTunnel = through
	if dialErr != nil {
		result.Error = logx.Err(dialErr)
		result.TotalMS = time.Since(started).Milliseconds()
		logx.Info("speed test through_tunnel=%t error=%s ms=%d",
			result.ThroughTunnel, result.Error, result.TotalMS)
		return result
	}

	counters := struct {
		down counting64
		up   counting64
	}{}
	var legStart atomic.Int64 // the running leg's start, unix nanoseconds
	var wg sync.WaitGroup
	stop := make(chan struct{})
	wg.Add(1)
	go func() { // one progress tick every speedTestTick while a leg runs
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
	defer func() {
		close(stop)
		wg.Wait()
	}()

	// The path's own delay, before the big transfers move anything:
	// the probes ride the first connection, and the answer stands in
	// the result whether or not the legs go on to carry bytes.
	if latency, jitter, ok := probeLatency(parent, first); ok {
		result.LatencyMS = latency
		result.JitterMS = jitter
	}

	// Download: one streaming GET on its own connection, counted as the
	// body arrives. A deadline the leg ran into is not a failure — the
	// bytes it carried still answer what the path delivers. The leg's
	// own failure waits in [downErr]: it becomes the test's error only
	// when the upload measures nothing either.
	var downErr, upErr error
	if conn, _, err := d.dialSpeedConn(parent); err != nil {
		downErr = err
	} else if tlsConn, err := speedTLS(parent, conn); err != nil {
		downErr = err
	} else {
		legCtx, legStop := context.WithTimeout(parent, speedTestDirTimeout)
		req, _ := http.NewRequestWithContext(legCtx, http.MethodGet,
			fmt.Sprintf("https://%s/__down?bytes=%d", speedTestHost, downBytes), nil)
		downStart := time.Now()
		legStart.Store(downStart.UnixNano())
		if resp, err := speedClient(tlsConn, false).Do(req); err != nil {
			if counters.down.get() == 0 && parent.Err() == nil {
				downErr = err
			}
		} else {
			body := speedCountingBody{ReadCloser: resp.Body, n: &counters.down}
			io.Copy(io.Discard, body)
			resp.Body.Close()
			result.DownBytes = counters.down.get()
			if result.DownBytes > 0 {
				result.DownBPS = result.DownBytes * int64(time.Second) /
					max(1, int64(time.Since(downStart)))
			}
		}
		legStop()
		tlsConn.Close()
	}

	// Upload: one POST of zeros on its own connection, counted as the
	// transport takes the body. Whatever the download leg did, this
	// leg's connection is fresh, so the test's two halves stand
	// separate — the upload never inherits the download's wounds.
	if conn, _, err := d.dialSpeedConn(parent); err != nil {
		upErr = err
	} else if tlsConn, err := speedTLS(parent, conn); err != nil {
		upErr = err
	} else {
		payload := make([]byte, min(upBytes, 1<<20))
		legCtx, legStop := context.WithTimeout(parent, speedTestDirTimeout)
		bodyReader := &speedCountingReader{r: newZeroReader(payload, upBytes), n: &counters.up}
		req, _ := http.NewRequestWithContext(legCtx, http.MethodPost,
			"https://"+speedTestHost+"/__up", bodyReader)
		req.ContentLength = upBytes
		upStart := time.Now()
		legStart.Store(upStart.UnixNano())
		if resp, err := speedClient(tlsConn, false).Do(req); err != nil {
			if counters.up.get() == 0 && parent.Err() == nil {
				upErr = err
			}
		} else {
			io.Copy(io.Discard, io.LimitReader(resp.Body, 4096))
			resp.Body.Close()
			result.UpBytes = counters.up.get()
			if result.UpBytes > 0 {
				result.UpBPS = result.UpBytes * int64(time.Second) /
					max(1, int64(time.Since(upStart)))
			}
		}
		legStop()
		tlsConn.Close()
	}

	// The test's own error only when nothing was measured at all: one
	// leg's wound does not erase the other leg's numbers.
	if result.DownBytes == 0 && result.UpBytes == 0 {
		if parent.Err() != nil {
			result.Error = "the test was stopped"
		} else if downErr != nil {
			result.Error = logx.Err(downErr)
		} else if upErr != nil {
			result.Error = logx.Err(upErr)
		} else {
			result.Error = "no bytes were measured"
		}
	}
	result.OK = result.DownBPS > 0 || result.UpBPS > 0
	result.TotalMS = time.Since(started).Milliseconds()
	logx.Info("speed test through_tunnel=%t down=%d bps up=%d bps latency=%d ms jitter=%d ms ms=%d",
		result.ThroughTunnel, result.DownBPS, result.UpBPS,
		result.LatencyMS, result.JitterMS, result.TotalMS)
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
