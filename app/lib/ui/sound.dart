import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart'
    show NavigatorObserver, Route;

/// The app's own sounds: six short cues the ear adds to what the hand
/// already feels. A tap for pills, pages and presses; two notes rising
/// and falling for the switches; a small arpeggio for the connection's
/// coming up and going down; a double ping for the lock. The settings'
/// sound switch decides whether any of them are heard.
enum SoundCue { tap, toggleOn, toggleOff, connect, disconnect, lock }

/// The player: every cue's sound sits preloaded in its own pool, so the
/// first tap answers as fast as the haptic does. A platform without the
/// audio plugin (Linux's build) goes silent for good instead of throwing
/// on every press — sound is garnish, never an error.
abstract final class AppSounds {
  static const _files = {
    SoundCue.tap: 'sounds/tap.wav',
    SoundCue.toggleOn: 'sounds/toggleOn.wav',
    SoundCue.toggleOff: 'sounds/toggleOff.wav',
    SoundCue.connect: 'sounds/connect.wav',
    SoundCue.disconnect: 'sounds/disconnect.wav',
    SoundCue.lock: 'sounds/lock.wav',
  };

  static final Map<SoundCue, AudioPool> _pools = {};
  static final Set<SoundCue> _warming = {};

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
    pool.start().catchError((Object _) {});
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
