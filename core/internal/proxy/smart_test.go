package proxy

import (
        "errors"
        "slices"
        "testing"
        "time"
)

var errTest = errors.New("did not connect")

// The smart transport, with no memory at all: HTTP/3, the fastest one.
func TestSmartTransportStartsOnH3(t *testing.T) {
        resetSmart(t)
        if got := SmartTransport(); got != "h3" {
                t.Errorf("SmartTransport() = %q, want \"h3\" (nothing has failed yet)", got)
        }
}

// A fresh HTTP/3 failure moves the choice to HTTP/2, a fresh HTTP/2
// failure on top of it to HTTP/1.1; an answer clears the memory again.
func TestSmartTransportRemembersFailures(t *testing.T) {
        resetSmart(t)
        NoteTransport("h3", errTest)
        if got := SmartTransport(); got != "h2" {
                t.Errorf("after an HTTP/3 failure: SmartTransport() = %q, want \"h2\"", got)
        }
        NoteTransport("h2", errTest)
        if got := SmartTransport(); got != "h1" {
                t.Errorf("after HTTP/3 and HTTP/2 failures: SmartTransport() = %q, want \"h1\"", got)
        }
        NoteTransport("h2", nil)
        if got := SmartTransport(); got != "h2" {
                t.Errorf("HTTP/2 answered, HTTP/3's failure is fresh: SmartTransport() = %q, want \"h2\"", got)
        }
        // Both fresh: the one that survives networks that cut long
        // connections.
        NoteTransport("h2", errTest)
        if got := SmartTransport(); got != "h1" {
                t.Errorf("after HTTP/3 and HTTP/2 failures: SmartTransport() = %q, want \"h1\"", got)
        }
        NoteTransport("h3", nil)
        if got := SmartTransport(); got != "h3" {
                t.Errorf("after HTTP/3 answered: SmartTransport() = %q, want \"h3\"", got)
        }
}

// The failure's memory is short: after it goes stale, the transport is
// tried again.
func TestSmartTransportForgetsOldFailures(t *testing.T) {
        resetSmart(t)
        NoteTransport("h3", errTest)
        smart.mu.Lock()
        smart.h3FailAt = time.Now().Add(-2 * smartFailureMemory)
        smart.mu.Unlock()
        if got := SmartTransport(); got != "h3" {
                t.Errorf("a stale failure: SmartTransport() = %q, want \"h3\" (tried again)", got)
        }
}

// The smart IP version: both families race until one connects; the one
// that connected is used alone until it fails, then the race again.
func TestSmartIPVersionRemembersTheWinner(t *testing.T) {
        resetSmart(t)
        SetUpstreamIPVersion("smart")
        t.Cleanup(func() { SetUpstreamIPVersion("auto") })

        if got := upstreamSteps(); !slices.Equal(got, []string{stepBoth}) {
                t.Errorf("no answer yet: upstreamSteps() = %v, want [%s] (the race)", got, stepBoth)
        }
        noteSmartFamily(stepIPv6)
        if got := upstreamSteps(); !slices.Equal(got, []string{stepIPv6}) {
                t.Errorf("IPv6 connected last: upstreamSteps() = %v, want [%s]", got, stepIPv6)
        }
        clearSmartFamily()
        if got := upstreamSteps(); !slices.Equal(got, []string{stepBoth}) {
                t.Errorf("the road failed: upstreamSteps() = %v, want [%s] (the race again)", got, stepBoth)
        }
        // A family the memory holds is only ever "4" or "6"; anything else
        // is dropped.
        noteSmartFamily("x")
        if got := smartFamily(); got != "" {
                t.Errorf("noteSmartFamily(\"x\") left %q, want none", got)
        }
}

// resetSmart hands the test an empty memory, and puts one back when the
// test is over: the memory is global, and other tests read it. The
// fields are swapped under the lock — the struct itself carries a
// mutex, and a copy of it would be a copy of a lock (go vet).
func resetSmart(t *testing.T) {
        t.Helper()
        smart.mu.Lock()
        h3, h2, family := smart.h3FailAt, smart.h2FailAt, smart.family
        smart.h3FailAt, smart.h2FailAt, smart.family = time.Time{}, time.Time{}, ""
        smart.mu.Unlock()
        t.Cleanup(func() {
                smart.mu.Lock()
                smart.h3FailAt, smart.h2FailAt, smart.family = h3, h2, family
                smart.mu.Unlock()
        })
}
