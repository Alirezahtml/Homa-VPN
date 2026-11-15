package proxy

// The smart choice, behind proxy.transport "smart" and proxy.ip_version
// "smart": how to reach Mozilla is picked by how the network answered
// before, and the answer is kept while it works. The memory lives with
// the process, so a restart measures again.
//
// The transports, in the order the smart choice tries them:
//
//   - HTTP/3 (QUIC over UDP): the fastest where the network carries UDP
//     — no head-of-line blocking, an instant recovery from loss, and the
//     session is up after one round trip;
//   - HTTP/2 (one TLS/TCP connection): while HTTP/3's last failure is
//     fresh — the networks that filter QUIC, as in Iran, still carry it;
//   - HTTP/1.1 (a TLS connection per tunnel): while HTTP/2's last failure
//     is fresh too — the one transport that survives a network that cuts
//     long connections.
//
// The IP families race on the first connection (RFC 8305, both at once,
// the first to connect taken); the family that connected is remembered
// and used alone until it fails, when the race runs again.
//
// Every choice here is a real one, made on real answers: a transport the
// engine could not open the session with, a family whose connection
// failed — none of it is guessed.

import (
        "sync"
        "time"
)

// smartFailureMemory is how long a transport's last failure keeps the
// choice away from it: long enough that an outage is not retried on
// every new session, short enough that a network change, or a filter
// that gave up, is tried again soon.
const smartFailureMemory = 30 * time.Minute

type smartMemory struct {
        mu       sync.Mutex
        h3FailAt time.Time
        h2FailAt time.Time
        // family is the IP family ("4" or "6") that connected last; "" lets
        // both race.
        family string
}

var smart smartMemory

// SmartTransport is the transport a session opens with: HTTP/3 unless
// its last failure is still fresh, then HTTP/2 unless its is, then
// HTTP/1.1.
func SmartTransport() string {
        smart.mu.Lock()
        defer smart.mu.Unlock()
        switch {
        case time.Since(smart.h3FailAt) >= smartFailureMemory:
                return "h3"
        case time.Since(smart.h2FailAt) >= smartFailureMemory:
                return "h2"
        default:
                return "h1"
        }
}

// SmartSnapshot is what the network's own answers picked so far, for the
// status view: the transport the next session would open with and the IP
// family the last connection took ("" while both still race). The same
// real memory SmartTransport reads — nothing is invented for the view.
func SmartSnapshot() (transport, family string) {
        smart.mu.Lock()
        defer smart.mu.Unlock()
        transport = "h3"
        switch {
        case time.Since(smart.h3FailAt) >= smartFailureMemory:
                transport = "h3"
        case time.Since(smart.h2FailAt) >= smartFailureMemory:
                transport = "h2"
        default:
                transport = "h1"
        }
        return transport, smart.family
}

// NoteTransport records how a transport answered on this network: its
// failure keeps it away for smartFailureMemory, its success clears the
// memory. It is safe to call for any transport and any result.
func NoteTransport(transport string, err error) {
        smart.mu.Lock()
        defer smart.mu.Unlock()
        switch transport {
        case "h3":
                if err != nil {
                        smart.h3FailAt = time.Now()
                } else {
                        smart.h3FailAt = time.Time{}
                }
        case "h2":
                if err != nil {
                        smart.h2FailAt = time.Now()
                } else {
                        smart.h2FailAt = time.Time{}
                }
        }
}

// smartFamily is the IP family the last connection went through ("4" or
// "6"), while it worked: "" means both families race.
func smartFamily() string {
        smart.mu.Lock()
        defer smart.mu.Unlock()
        return smart.family
}

// noteSmartFamily remembers the family a connection went through, so
// the next one takes the same road without the race.
func noteSmartFamily(family string) {
        if family != "4" && family != "6" {
                return
        }
        smart.mu.Lock()
        smart.family = family
        smart.mu.Unlock()
}

// clearSmartFamily drops the family's memory: its road failed, and the
// next connection races both families again.
func clearSmartFamily() {
        smart.mu.Lock()
        smart.family = ""
        smart.mu.Unlock()
}
