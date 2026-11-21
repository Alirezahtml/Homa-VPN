import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart'
    show NavigatorObserver, Route;

/// The app's own sounds: nine short cues the ear adds to what the hand
/// already feels. A tap for pills, pages and presses; two notes rising
/// and falling for the switches; a soft swell for the connect that has
/// begun, a rising arpeggio for the one that carried, a falling one for
/// the tunnel that rests, two muted pulses for the way that is blocked;
/// a double ping for the lock. The settings' sound switch decides
/// whether any of them are heard.
enum SoundCue {
  tap,
  toggleOn,
  toggleOff,
  connecting,
  connect,
  disconnect,
  error,
  lock,
  wheelTick,
}

/// The connection's voice: the cues that say what the tunnel itself is
/// doing. A new one of these hushes every voice before it speaks — the
/// state changed, and the old state's note has nothing to add. The
/// little voices (the taps, the switches) only hush each other, so a
/// touch never cuts the connection's sentence short.
const _eventCues = {
  SoundCue.connecting,
  SoundCue.connect,
  SoundCue.disconnect,
  SoundCue.error,
};

/// The player: every cue's sound sits preloaded in its own pool, so the
/// first tap answers as fast as the haptic does. A platform without the
/// audio plugin (Linux's build) goes silent for good instead of throwing
/// on every press — sound is garnish, never an error.
abstract final class AppSounds {
  static const _files = {
    SoundCue.tap: 'sounds/tap.wav',
    SoundCue.toggleOn: 'sounds/toggleOn.wav',
    SoundCue.toggleOff: 'sounds/toggleOff.wav',
    SoundCue.connecting: 'sounds/connecting.wav',
    SoundCue.connect: 'sounds/connect.wav',
    SoundCue.disconnect: 'sounds/disconnect.wav',
    SoundCue.error: 'sounds/error.wav',
    SoundCue.lock: 'sounds/lock.wav',
    SoundCue.wheelTick: 'sounds/wheelTick.wav',
  };

  static final Map<SoundCue, AudioPool> _pools = {};
  static final Set<SoundCue> _warming = {};

  /// The voices still sounding, by cue: a new voice stops the old ones
  /// instead of stacking on them — one voice at a time. Each entry is
  /// the stop function the pool's start handed back.
  static final Map<SoundCue, StopFunction> _playing = {};

  /// Mirrors the settings' sound switch; the app sets it on every build.
  static bool enabled = false;

  /// True once the platform proved it has no audio plugin: no more
  /// attempts, no noise in the logs.
  static bool _giveUp = false;

  /// Preloads every cue's pool; called once when the app starts.
  static void warmup() {
    for (final cue in SoundCue.values) {
      _ensure(cue);
    }
  }

  static void _ensure(SoundCue cue) {
    if (_pools.containsKey(cue) || _giveUp || _warming.contains(cue)) return;
    _warming.add(cue);
    _build(cue);
  }

  static Future<void> _build(SoundCue cue) async {
    try {
      final pool = await AudioPool.create(
        source: AssetSource(_files[cue]!),
        maxPlayers: 3,
      );
      _pools[cue] = pool;
    } catch (_) {
      // No audio plugin on this platform (Linux): stay silent everywhere.
      _giveUp = true;
    } finally {
      _warming.remove(cue);
    }
  }

  /// The cue itself, if the setting allows and the platform can.
  static void play(SoundCue cue) {
    if (!enabled || _giveUp) return;
    _ensure(cue);
    final pool = _pools[cue];
    if (pool == null) return;
    unawaited(_start(pool, cue));
  }

  /// One voice: the event cues hush everything before they speak, the
  /// little ones only hush each other. Failures swallowed — a sound
  /// that cannot play is never an error the app should carry.
  static Future<void> _start(AudioPool pool, SoundCue cue) async {
    try {
      await _hush(cue);
      final stop = await pool.start();
      _playing[cue] = stop;
    } catch (_) {
      // The next note plays; nothing to report.
    }
  }

  /// Stops every voice this one may not speak over.
  static Future<void> _hush(SoundCue cue) async {
    final event = _eventCues.contains(cue);
    for (final other in _playing.keys.toList()) {
      if (other == cue) continue;
      if (!event && !_eventCues.contains(other)) {
        // A little voice over an event's voice is allowed to share the
        // air: the tap rides under the connect's chord, never over it.
        continue;
      }
      final stop = _playing.remove(other);
      if (stop == null) continue;
      try {
        await stop();
      } catch (_) {
        // An already-silent voice has nothing left to stop.
      }
    }
  }
}

/// Every page's arrival and leaving carries the soft tap — the ear's
/// own way of hearing which section the app just opened, whatever
/// opened it (the pills, the lock, the dialogs, the deep links).
class SoundRoutes extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppSounds.play(SoundCue.tap);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppSounds.play(SoundCue.tap);
  }
}
