package service

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestZeroReaderServesExactlyWant(t *testing.T) {
	r := newZeroReader(make([]byte, 1024), 2500)
	var got int
	buf := make([]byte, 700)
	for {
		n, err := r.Read(buf)
		got += n
		if err == io.EOF {
			break
		}
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
	}
	if got != 2500 {
		t.Fatalf("zeroReader served %d bytes, want 2500", got)
	}
}

func TestSpeedCountingReaderCountsWhatTransportTakes(t *testing.T) {
	var counter counting64
	reader := &speedCountingReader{r: bytes.NewReader(make([]byte, 100)), n: &counter}
	out, err := io.ReadAll(reader)
	if err != nil || len(out) != 100 {
		t.Fatalf("read %d bytes, err=%v", len(out), err)
	}
	if counter.get() != 100 {
		t.Fatalf("counter is %d, want 100", counter.get())
	}
}

func TestHandleSpeedTestValidatesAndAnswersWithoutStream(t *testing.T) {
	d := newTestDaemon(t)
	server := httptest.NewServer(newDashboardServer(d).handler())
	defer server.Close()

	req, _ := http.NewRequest(http.MethodPost, server.URL+"/api/speedtest",
		bytes.NewBufferString(`{"down_bytes":1024,"up_bytes":1024}`))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-Local-Token", d.localToken)
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatalf("speed test request failed: %v", err)
	}
	defer res.Body.Close()
	if res.StatusCode != http.StatusOK {
		t.Fatalf("speed test answered HTTP %d", res.StatusCode)
	}
	var result speedTestResult
	body, _ := io.ReadAll(res.Body)
	if json.Unmarshal(body, &result) != nil {
		t.Fatalf("bad result body: %s", body)
	}
	// The proxy is off and the test network cannot reach Cloudflare; the
	// endpoint must still answer a shaped result, not hang or crash.
	if result.TotalMS < 0 {
		t.Fatalf("impossible total time %d", result.TotalMS)
	}
}
