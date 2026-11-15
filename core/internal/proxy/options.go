package proxy

import "time"

const (
	defaultUpstreamConnections = 2

	// APIRequestTimeout bounds a single control plane API call (FxA,
	// Guardian, Remote Settings); the shared client adds its own safety
	// timeout on top, and FxA calls extend it while solving the Fastly
	// anti-bot challenge.
	APIRequestTimeout = 15 * time.Second
)
