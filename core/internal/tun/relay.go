package tun

import (
	"context"
	"errors"
	"io"
	"net"
	"sync"
	"time"

	"golang.org/x/net/proxy"
)

// Dialer opens a connection to target ("host:port") through the proxy.
type Dialer func(ctx context.Context, target string) (net.Conn, error)

// dialTimeout bounds connecting through the proxy, which may first wake
// and connect to Mozilla.
const dialTimeout = 30 * time.Second

// SOCKS5Dialer dials through the SOCKS5 proxy at addr, with its login if
// user is not empty.
func SOCKS5Dialer(addr, user, password string) (Dialer, error) {
	var auth *proxy.Auth
	if user != "" {
		auth = &proxy.Auth{User: user, Password: password}
	}
	d, err := proxy.SOCKS5("tcp", addr, auth, &net.Dialer{Timeout: dialTimeout})
	if err != nil {
		return nil, err
	}
	cd, ok := d.(proxy.ContextDialer)
	if !ok {
		return nil, errors.New("the SOCKS5 dialer cannot take a context")
	}
	return func(ctx context.Context, target string) (net.Conn, error) {
		return cd.DialContext(ctx, "tcp", target)
	}, nil
}

// closeWriter is a connection that can end its sending half.
type closeWriter interface{ CloseWrite() error }

// relayBuffer is one copy's window: 64 KB, the same size the proxy's own
// relays carry. A bigger window keeps a fast path filled between reads —
// the loop's traffic rides at the pipe's own pace, not the default 32 KB
// read-by-read.
const relayBufferSize = 64 * 1024

var relayBufferPool = sync.Pool{
	New: func() any { return make([]byte, relayBufferSize) },
}

// Relay copies between a and b until both directions end, passing on each
// end of stream as a half close, then closes both.
func Relay(a, b net.Conn) {
	var wg sync.WaitGroup
	copyHalf := func(dst, src net.Conn) {
		defer wg.Done()
		buf := relayBufferPool.Get().([]byte)
		_, _ = io.CopyBuffer(dst, src, buf)
		relayBufferPool.Put(buf)
		if cw, ok := dst.(closeWriter); ok {
			_ = cw.CloseWrite()
		} else {
			_ = dst.Close()
		}
	}
	wg.Add(2)
	go copyHalf(a, b)
	go copyHalf(b, a)
	wg.Wait()
	_ = a.Close()
	_ = b.Close()
}
