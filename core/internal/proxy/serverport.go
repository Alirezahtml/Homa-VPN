package proxy

import "sync/atomic"

// proxy.server_port, the port every server-list server dials on when it
// is not 0: the server list's own port (443 for the records that omit
// one) carries until a network that only lets one port through names
// its own. The country choice stands; only the port moves.
var upstreamServerPort atomic.Int32

// SetUpstreamServerPort sets proxy.server_port for the candidates built
// from now on. 0 keeps the server list's own port.
func SetUpstreamServerPort(port int) { upstreamServerPort.Store(int32(port)) }

// upstreamPort is the port a server-list candidate dials on: the
// override when one stands, else the record's own (the caller has
// already applied the list's 443 default for the records that omit it).
func upstreamPort(record int) int {
	if p := int(upstreamServerPort.Load()); p > 0 {
		return p
	}
	return record
}
