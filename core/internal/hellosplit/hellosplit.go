// Package hellosplit sends the TLS ClientHello of the program's connections
// to Mozilla across several TCP segments, so that a network filtering by
// server name, whose inspection does not put segments back together, does
// not read the name. The server gets the same bytes and the name stays the
// real one (Mozilla's proxy refuses any other). It can also go out as two TLS
// records, for an inspection that does put segments together but reads only the
// first record.
//
// network.hello_split chooses how (Set); by default the choice is auto: the
// hello goes out whole, and when TLS itself keeps dying with two whole
// hellos — a filter that reads the name — the name goes out cut for a while,
// without a hand on the settings.
package hellosplit

import (
	"encoding/binary"
	"errors"
	"net"
	"sync/atomic"
	"time"

	"github.com/armanlife/arman-vpn-client/core/internal/logx"
)

// The network.hello_split choices. Auto leaves the hello whole and lets the
// tunnel's own answers decide: when TLS itself keeps dying on a network (a
// filter that reads the name), the name goes out cut for a while, so the
// tunnel gets through without a hand on the settings. SNI cuts the name
// after its first letter; FirstByte cuts the record after its first byte;
// Record makes two records of the hello, cut after the name's first letter.
const (
	Off       = "off"
	Auto      = "auto"
	SNI       = "sni"
	FirstByte = "first-byte"
	Record    = "record"
)

// autoHold is how long an auto escalation keeps the name cut: as long as
// the transports' own failure memory, so the whole answer set turns over
// together before the network is asked again with the hello whole.
const autoHold = 30 * time.Minute

// nowFunc stands for the clock, so a test can hold the escalation's age.
var nowFunc = time.Now

// configured is network.hello_split; nil means Auto.
var configured atomic.Pointer[string]

// escalatedUntil is when the auto escalation ends, as unix nanoseconds
// (0 while no escalation stands).
var escalatedUntil atomic.Int64

// NoteSuspectedFilter records that TLS itself died twice in a row with two
// whole hellos on this network — the signature of a filter reading the
// name. In auto mode the next connections cut the name, for autoHold. A
// hand-picked way (off, sni, first-byte, record) is never overridden.
func NoteSuspectedFilter() {
	if current() != Auto {
		return
	}
	escalatedUntil.Store(nowFunc().Add(autoHold).UnixNano())
}

// autoEscalated reports whether an auto escalation still stands.
func autoEscalated() bool {
	return nowFunc().UnixNano() < escalatedUntil.Load()
}

// Valid reports whether mode is a network.hello_split choice (empty means
// Auto).
func Valid(mode string) bool {
	switch mode {
	case "", Off, Auto, SNI, FirstByte, Record:
		return true
	}
	return false
}

// Set installs network.hello_split for the connections opened from now on.
func Set(mode string) {
	if mode == "" {
		mode = Auto
	}
	configured.Store(&mode)
}

// current is the way a new connection sends its ClientHello.
func current() string {
	if mode := configured.Load(); mode != nil {
		return *mode
	}
	return Auto
}

// effective is the way a hello goes out now: the chosen one, or — in auto —
// the name cut while an escalation stands.
func effective() string {
	way := current()
	if way == Auto {
		if autoEscalated() {
			return SNI
		}
		return Off
	}
	return way
}

// Wrap returns conn, a new connection about to start TLS, sending its
// ClientHello in the way chosen. Anything that is not a ClientHello passes
// untouched.
func Wrap(conn net.Conn) net.Conn {
	way := effective()
	if way == Off {
		return conn
	}
	return &splitConn{Conn: conn, way: way}
}

// splitConn splits the ClientHellos written to it.
type splitConn struct {
	net.Conn
	way string
}

func (c *splitConn) Write(p []byte) (int, error) {
	if !isClientHello(p) {
		return c.Conn.Write(p)
	}
	if c.way == Record {
		return c.writeRecords(p)
	}
	segments, err := segments(p, c.way)
	if err != nil {
		logx.Debug("not splitting a ClientHello err=%s", logx.Err(err))
		return c.Conn.Write(p)
	}
	total := 0
	for _, segment := range segments {
		n, err := c.Conn.Write(segment)
		total += n
		if err != nil {
			return total, err
		}
	}
	return total, nil
}

// writeRecords sends p, a whole ClientHello record, as two records. It is
// longer on the wire than p, and reports p's length: TLS counts what it gave.
func (c *splitConn) writeRecords(p []byte) (int, error) {
	out, err := records(p)
	if err != nil {
		logx.Debug("not splitting a ClientHello err=%s", logx.Err(err))
		return c.Conn.Write(p)
	}
	if _, err := c.Conn.Write(out); err != nil {
		return 0, err
	}
	return len(p), nil
}

// records makes two TLS records of p, a whole ClientHello record, cut after
// the first letter of the server's name.
func records(p []byte) ([]byte, error) {
	const headerLen = 5
	if int(binary.BigEndian.Uint16(p[3:])) != len(p)-headerLen {
		return nil, errors.New("not one whole record")
	}
	start, err := nameOffset(p)
	if err != nil {
		return nil, err
	}
	cut := start + 1
	out := make([]byte, 0, len(p)+headerLen)
	out = append(out, p[:3]...)
	out = binary.BigEndian.AppendUint16(out, uint16(cut-headerLen))
	out = append(out, p[headerLen:cut]...)
	out = append(out, p[:3]...)
	out = binary.BigEndian.AppendUint16(out, uint16(len(p)-cut))
	return append(out, p[cut:]...), nil
}

// isClientHello reports whether p starts a TLS handshake record holding a
// ClientHello.
func isClientHello(p []byte) bool {
	return len(p) > 5 && p[0] == 0x16 && p[1] == 0x03 && p[5] == 0x01
}

// segments cuts p, a whole ClientHello record, the given way.
func segments(p []byte, way string) ([][]byte, error) {
	switch way {
	case FirstByte:
		return [][]byte{p[:1], p[1:]}, nil
	case SNI:
		start, err := nameOffset(p)
		if err != nil {
			return nil, err
		}
		return [][]byte{p[:start], p[start : start+1], p[start+1:]}, nil
	}
	return nil, errors.New("unknown way: " + way)
}

// nameOffset finds the first byte of the server name in p, a ClientHello
// record. A hello without a name, or one that does not parse, is an error.
func nameOffset(p []byte) (int, error) {
	errBad := errors.New("not a ClientHello with a server name")
	// Record header (5), handshake header (4), version (2), random (32).
	at := 5 + 4 + 2 + 32
	skip := func(lengthBytes int) bool {
		if at+lengthBytes > len(p) {
			return false
		}
		n := 0
		for _, b := range p[at : at+lengthBytes] {
			n = n<<8 | int(b)
		}
		at += lengthBytes + n
		return at <= len(p)
	}
	// Session ID, cipher suites, compression methods.
	if !skip(1) || !skip(2) || !skip(1) || at+2 > len(p) {
		return 0, errBad
	}
	end := at + 2 + int(binary.BigEndian.Uint16(p[at:]))
	at += 2
	if end > len(p) {
		end = len(p)
	}
	for at+4 <= end {
		kind := binary.BigEndian.Uint16(p[at:])
		size := int(binary.BigEndian.Uint16(p[at+2:]))
		body := at + 4
		if body+size > end {
			return 0, errBad
		}
		if kind == 0 {
			// server_name: list length (2), name type (1), name length (2).
			if size < 6 || p[body+2] != 0 {
				return 0, errBad
			}
			nameLen := int(binary.BigEndian.Uint16(p[body+3:]))
			if nameLen == 0 || body+5+nameLen > end {
				return 0, errBad
			}
			return body + 5, nil
		}
		at = body + size
	}
	return 0, errBad
}
