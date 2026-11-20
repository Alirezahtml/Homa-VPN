/// The Homa motion system: the moving parts of the monochrome design.
///
/// Light by design and polite to the battery:
/// - nothing here loops forever; the one repeated motion (the slider's
///   busy spinner) pauses when the app leaves the screen, and every
///   animation honors the system's reduce-motion setting
///   (`MediaQuery.disableAnimations`);
/// - the entrance animations run once and never re-run on a refresh, so
///   a status update repaints text, not the whole page.
///
/// Inventory:
/// - Reveal: a fade-and-lift entrance, staggered by index.
/// - Pressable: a quiet sink-in on press.
/// - CountUp: a number that lands on its value.
/// - Shimmer: the light sweep on the slider's hint.
/// - SlideToConnect: the power control; the knob snaps back when let go
///   early, commits with a bloom ring and a haptic.
/// - DrawCheck: a checkmark that strokes itself in, once.
/// - PulseHalo: two soft rings that breathe outward around the connected
///   orb; still under reduce-motion and the battery saver.
/// - CrossfadeText: a word that glides to its next self (the state's
///   word), never a hard swap.
/// - Shake: a small horizontal wiggle, replayed on demand — the wrong
///   password's own word.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design.dart';

/// The shared 0→1 tween: one instance, so a parent's rebuild never
/// restarts a finished entrance (TweenAnimationBuilder compares identity).
final Tween<double> _unit = Tween<double>(begin: 0, end: 1);

/// Whether the system asks for less motion.
bool _still(BuildContext context) => MediaQuery.of(context).disableAnimations;

// ---------------------------------------------------------------------------
// Reveal: the one-time entrance.
// ---------------------------------------------------------------------------

/// Fades, slides and scales its child in once; [index] staggers siblings.
/// A rebuild with the same [index] never replays it (the tween is shared).
/// The entrance itself wears the design's own voice: the monochrome's
/// fade-and-lift, the paper's flat ink fade (the print does not move,
/// it develops), Material's emphasized grow, and the bento's spring pop.
class Reveal extends StatelessWidget {
  const Reveal({super.key, required this.child, this.index = 0});

  final Widget child;

  /// The slot in the page: 0 first, 1 next, and so on.
  final int index;

  @override
  Widget build(BuildContext context) {
    final still = _still(context);
    if (still) return child;
    // The design's own entrance: how far the child travels, how much it
    // grows from, and whether the arrival overshoots (the bento's pop).
    final key = AppDesign.current.key;
    final (lift, from, spring) = switch (key) {
      'gazette' => (0.0, 0.995, false), // the ink develops in place
      'pixel' => (10.0, 0.96, false), // the emphasized entrance
      'zed' => (14.0, 0.97, true), // the spring pop
      'aether' || 'ios' => (10.0, 0.99, false), // the soft rise
      _ => (14.0, 0.985, false), // the fade-and-lift
    };
    final curve = Interval(
      math.min(index * 0.07, 0.45),
      1,
      curve: spring ? Curves.easeOutBack : Curves.easeOutCubic,
    );
    return TweenAnimationBuilder(
      tween: _unit,
      duration: Duration(milliseconds: 420 + math.min(index, 8) * 60),
      curve: curve,
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0, 1).toDouble(),
        child: Transform.translate(
          offset: Offset(0, lift * (1 - v)),
          child: Transform.scale(scale: from + (1.0 - from) * v, child: child),
        ),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Pressable: the press feel.
// ---------------------------------------------------------------------------

/// Scales its child down while a pointer is down and back with a spring
/// when it goes up. A [Listener], so it never swallows the taps, drags or
/// scrolls of the widgets inside.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.depth = 0.035});

  final Widget child;

  /// How much it sinks, as a share of its size.
  final double depth;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) => AnimatedScale(
    scale: _down ? 1 - widget.depth : 1,
    duration: _down
        ? const Duration(milliseconds: 90)
        : const Duration(milliseconds: 260),
    curve: _down ? Curves.easeOut : Curves.easeOutBack,
    child: Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: widget.child,
    ),
  );
}

// ---------------------------------------------------------------------------
// CountUp: numbers that travel.
// ---------------------------------------------------------------------------

/// Shows [format] of [value], tweened from the previous value: the quota
/// percentage and the data amount glide instead of jump.
class CountUp extends StatefulWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.format,
    this.style,
  });

  final double value;
  final String Function(double value) format;

  /// The text's style; the size also sets the Text's default.
  final TextStyle? style;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  late Tween<double> _tween = Tween(begin: widget.value, end: widget.value);

  @override
  void didUpdateWidget(CountUp old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _tween = Tween(begin: _tween.end ?? widget.value, end: widget.value);
    }
  }

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder(
    tween: _tween,
    duration: _still(context)
        ? Duration.zero
        : const Duration(milliseconds: 480),
    curve: Curves.easeOutCubic,
    builder: (context, v, _) => Text(widget.format(v), style: widget.style),
  );
}

// ---------------------------------------------------------------------------
// Shimmer: the moving light.
// ---------------------------------------------------------------------------

/// A light that sweeps across a text (or any child) — the connecting
/// state's signature. Still under reduce-motion.
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    required this.color,
    this.base,
  });

  final Widget child;

  /// The moving highlight's color; the base color the child starts with.
  final Color color;
  final Color? base;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Monochrome build: the light does not sweep on its own; the text
    // keeps its base color and nothing repaints between interactions.
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final x = _c.value * 2 - 0.5;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              widget.color.withValues(alpha: 0.9),
              Colors.transparent,
            ],
            stops: [
              math.max(x - 0.35, -0.2),
              x.clamp(-0.2, 1.2),
              math.min(x + 0.35, 1.2),
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// SlideToConnect: the power control.
// ---------------------------------------------------------------------------

/// The phone's power control: a knob that travels a lit track. Sliding it
/// to the far side (or tapping it) turns the VPN on or off; letting go
/// early springs it back with a soft bounce. The track fills as it
/// travels, the icon morphs at the threshold, a ring blooms when it
/// commits.
class SlideToConnect extends StatefulWidget {
  const SlideToConnect({
    super.key,
    required this.on,
    required this.busy,
    required this.accent,
    required this.dark,
    required this.card,
    required this.border,
    required this.text,
    required this.muted,
    required this.labelConnect,
    required this.labelDisconnect,
    required this.labelOn,
    required this.labelBusy,
    required this.tooltip,
    required this.onPressed,
    this.autofocus = false,
    this.haptic = true,
  });

  final bool on;
  final bool busy;
  final Color accent;
  final bool dark;
  final Color card;
  final Color border;
  final Color text;
  final Color muted;

  /// The track's hint while off and while on; [labelOn] is the state's own
  /// word ("Connected"), which stays in the track while connected so the
  /// state reads there and not only above. While [busy] the track carries
  /// [labelBusy] instead — the connection being made has a word of its
  /// own here, not a bar that suddenly lost its words.
  final String labelConnect;
  final String labelDisconnect;
  final String labelOn;

  /// The word in the track while the connection is being made
  /// ("Connecting…"). Empty falls back to [labelConnect].
  final String labelBusy;
  final String tooltip;
  final VoidCallback onPressed;
  final bool autofocus;

  /// Whether the commit carries its haptic. The app's own vibration
  /// setting arrives here; off, the knob still blooms but stays silent.
  final bool haptic;

  @override
  State<SlideToConnect> createState() => _SlideToConnectState();
}

class _SlideToConnectState extends State<SlideToConnect>
    with TickerProviderStateMixin {
  /// The knob's place: 0 = the "off" end, 1 = the "on" end.
  late double _p = widget.on ? 1 : 0;

  late final AnimationController _snap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: _p,
  );
  late final AnimationController _bloom = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  /// The busy light: the track's border and shadow breathe while the
  /// connection is being made, and hold one pose every other moment —
  /// the one repeated motion besides the spinner, gone the second the
  /// state lands.
  late final AnimationController _busy = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  static const _threshold = 0.72;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _snap.addListener(() => setState(() => _p = _snap.value));
    if (widget.busy) _busy.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.on && !_still(context) && !_idle.isAnimating) _idle.stop();
  }

  @override
  void didUpdateWidget(SlideToConnect old) {
    super.didUpdateWidget(old);
    if (widget.on != old.on && !_dragging) {
      // The state moved by itself (the tray, the widget, a test): follow.
      _snap.animateTo(
        widget.on ? 1 : 0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
      );
    }
    // Monochrome build: no idle shimmer; the track rests until touched.
    _idle.stop();
    // The breath follows the busy state, not the widget's identity.
    if (widget.busy && !_busy.isAnimating) {
      _busy.repeat(reverse: true);
    } else if (!widget.busy && _busy.isAnimating) {
      _busy.stop();
      _busy.value = 0;
    }
  }

  @override
  void dispose() {
    _snap.dispose();
    _bloom.dispose();
    _idle.dispose();
    _busy.dispose();
    super.dispose();
  }

  void _commit() {
    if (widget.haptic) HapticFeedback.mediumImpact();
    _bloom.forward(from: 0);
    widget.onPressed();
  }

  static const knobSize = 62.0;

  /// The knob's side margin inside the track: the button rests within the
  /// ring, with air around it, instead of riding past its ends.
  static const knobInset = 8.0;

  /// The knob's travel: this box's width, less the knob and its margins.
  double get _travel {
    final box = context.findRenderObject();
    return box is RenderBox && box.hasSize
        ? math.max(box.size.width - 2 * knobInset - knobSize, 1.0)
        : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // The switch: a track the full width, its ends fully round, and the
    // knob resting inside it between margins.
    const height = 78.0;
    const knob = knobSize;
    const inset = knobInset;
    final dir = rtl ? -1.0 : 1.0;
    return AnimatedOpacity(
      // The busy dim follows with a breath instead of a jump: the button
      // settles into its working look, it does not blink into it the
      // moment the state moves.
      opacity: w.busy ? 0.75 : 1,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      child: Tooltip(
        message: w.tooltip,
        child: Focus(
          autofocus: w.autofocus,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: w.busy ? null : _commit,
            onHorizontalDragStart: w.busy
                ? null
                : (_) {
                    HapticFeedback.selectionClick();
                    setState(() => _dragging = true);
                  },
            onHorizontalDragUpdate: w.busy
                ? null
                : (d) => setState(
                    () => _p = (_p + dir * d.primaryDelta! / _travel).clamp(
                      0.0,
                      1.0,
                    ),
                  ),
            onHorizontalDragEnd: w.busy
                ? null
                : (d) {
                    setState(() => _dragging = false);
                    final v = (d.primaryVelocity ?? 0) * dir;
                    final crossed = w.on
                        ? _p < 1 - _threshold
                        : _p > _threshold;
                    if (crossed || v.abs() > 900) {
                      _snap.animateTo(
                        w.on ? 0 : 1,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      );
                      _commit();
                    } else {
                      _snap.animateTo(
                        w.on ? 1 : 0,
                        duration: const Duration(milliseconds: 460),
                        curve: Curves.elasticOut,
                      );
                    }
                  },
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: AnimatedBuilder(
                animation: Listenable.merge([_bloom, _idle, _busy]),
                builder: (context, child) {
                  final bloom = _bloom.value;
                  final shimmer = _idle.value;
                  final breath = _busy.value;
                  final p = _p.clamp(0.0, 1.0);
                  // The track's word: off → the connect hint, busy → the
                  // connection's own word, on → the state's word. An empty
                  // word falls back to the hint, so the track never stands
                  // with nothing to say.
                  final word = w.busy
                      ? (w.labelBusy.isEmpty ? w.labelConnect : w.labelBusy)
                      : w.on
                      ? (w.labelOn.isEmpty ? w.labelConnect : w.labelOn)
                      : w.labelConnect;
                  // The knob's own mark-ink when it carries: the face the
                  // knob wears then is the accent itself — and a light
                  // accent (the night monochrome's white, the gazette's
                  // cream) drowns a white mark in white. The mark reads the
                  // face it stands on: dark ink on a light accent, white on
                  // a dark one. This was the lock's disappearance — the
                  // icon never left, it only stopped contrasting.
                  final markInk =
                      ThemeData.estimateBrightnessForColor(w.accent) ==
                          Brightness.light
                      ? const Color(0xFF17130E)
                      : Colors.white;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // The track: the whole switch, its ends fully round.
                      // The knob rests inside it — a button in a ring, not
                      // one hanging past the ring's edge. While busy its
                      // border and shadow breathe with the connection's
                      // own rhythm, and hold one pose every other moment.
                      PositionedDirectional(
                        start: 0,
                        end: 0,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height / 2),
                            color: w.card,
                            border: Border.all(
                              color: Color.lerp(
                                w.border,
                                w.accent.withValues(
                                  alpha: 0.55 + 0.25 * breath,
                                ),
                                p,
                              )!,
                              width: 1.3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: w.accent.withValues(
                                  alpha:
                                      0.10 +
                                      0.20 * p +
                                      0.08 * breath * (w.busy ? 1 : 0),
                                ),
                                blurRadius: 18 + 14 * p,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(height / 2),
                            child: Stack(
                              children: [
                                // The fill that follows the knob.
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: FractionallySizedBox(
                                    widthFactor: p,
                                    heightFactor: 1,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            w.accent.withValues(alpha: 0.16),
                                            w.accent.withValues(alpha: 0.38),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // The idle light that wanders the track.
                                if (!w.on && !_dragging)
                                  Align(
                                    alignment: AlignmentDirectional(
                                      2 * shimmer - 1,
                                      0,
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            w.accent.withValues(alpha: 0),
                                            w.accent.withValues(alpha: 0.14),
                                            w.accent.withValues(alpha: 0),
                                          ],
                                        ),
                                      ),
                                      child: const SizedBox(
                                        width: 56,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                // The hint label. The knob at rest covers
                                // the track's first [inset + knob] pixels, so
                                // the label starts a little past it; the same
                                // room is kept on the other side, so the words
                                // sit exactly in the middle of what is left —
                                // in every language, reading either way. While
                                // connected the label stays: the state's own
                                // word ("Connected") in the track, not an
                                // empty bar. While busy the connection's own
                                // word stands in — steady, not fading with
                                // the drag — so nothing vanishes under the
                                // user's finger. A long translation shrinks
                                // to fit rather than ellipsizing.
                                PositionedDirectional(
                                  start: knob + inset + 4,
                                  end: knob + inset + 4,
                                  top: 0,
                                  bottom: 0,
                                  child: AnimatedOpacity(
                                    // The words hold with the finger almost
                                    // the whole slide now and melt only as
                                    // the knob arrives at their side — the
                                    // old curve had them gone by half the
                                    // travel, and the track read emptied
                                    // under the drag. The animation chases
                                    // every retarget, so the walk itself
                                    // reads as one smooth pursuit.
                                    opacity: w.busy
                                        ? 1
                                        : w.on
                                        ? 1
                                        : ((0.95 - p) / 0.4).clamp(0.0, 1.0),
                                    duration: const Duration(
                                      milliseconds: 180,
                                    ),
                                    curve: Curves.easeOut,
                                    child: Transform.translate(
                                      offset: Offset(-14 * p * dir, 0),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 220,
                                            ),
                                            switchInCurve: Curves.easeOutCubic,
                                            switchOutCurve: Curves.easeInCubic,
                                            // The track's word walks between
                                            // its three selves — the connect
                                            // hint, "Connecting…", the
                                            // state's word — the old lifting
                                            // while the new settles in place.
                                            // Never a hard swap: the word the
                                            // finger just read stays readable
                                            // until the next one is there.
                                            transitionBuilder: (child, anim) =>
                                                FadeTransition(
                                                  opacity: anim,
                                                  child: child,
                                                ),
                                            child: Shimmer(
                                              key: ValueKey(word),
                                              color: Colors.white.withValues(
                                                alpha: w.dark ? 0.85 : 0.5,
                                              ),
                                              child: Text(
                                                word,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: w.muted,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15.5,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // The success ring and the knob, inside the track:
                      // the margins keep air between the button and the
                      // ring, on both ends and above and below.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: inset),
                        child: Align(
                          alignment: AlignmentDirectional(2 * p - 1, 0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              if (bloom > 0 && bloom < 1)
                                IgnorePointer(
                                  child: Container(
                                    width: knob + 16,
                                    height: knob + 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: w.accent.withValues(
                                          alpha: 0.55 * (1 - bloom),
                                        ),
                                        width: 2.5 - 1.5 * bloom,
                                      ),
                                    ),
                                  ),
                                ),
                              Transform.scale(
                                scale: _dragging ? 1.06 : 1,
                                child: Container(
                                  width: knob,
                                  height: knob,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: w.on
                                          ? [
                                              Color.lerp(
                                                w.accent,
                                                Colors.white,
                                                0.30,
                                              )!,
                                              w.accent,
                                            ]
                                          : [
                                              Color.lerp(
                                                w.card,
                                                w.accent,
                                                0.10 + 0.25 * p,
                                              )!,
                                              Color.lerp(
                                                w.card,
                                                w.accent,
                                                0.04 + 0.16 * p,
                                              )!,
                                            ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: w.on ? 0.45 : 0.18 + 0.2 * p,
                                      ),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: w.accent.withValues(
                                          alpha: 0.35 + 0.25 * p,
                                        ),
                                        blurRadius: 12 + 10 * p,
                                        offset: Offset(0, 4 + 2 * p),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    // One morph for all of the knob's
                                    // selves: the spinner grows in as the
                                    // mark shrinks out, and back — no
                                    // hard swap anywhere in the state's
                                    // walk (off → connecting → on).
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 260,
                                      ),
                                      switchInCurve: Curves.easeOutCubic,
                                      switchOutCurve: Curves.easeInCubic,
                                      // A fade-through: the old mark
                                      // shrinks a shade as it leaves
                                      // while the new one grows the
                                      // last of its way in, both
                                      // always partly there — the
                                      // knob's mark never blinks out
                                      // between its two selves.
                                      transitionBuilder: (child, anim) =>
                                          FadeTransition(
                                            opacity: anim,
                                            child: ScaleTransition(
                                              scale: Tween(
                                                begin: 0.86,
                                                end: 1.0,
                                              ).animate(anim),
                                              child: child,
                                            ),
                                          ),
                                      child: w.busy
                                          ? SizedBox.square(
                                              key: const ValueKey('busy'),
                                              dimension: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.2,
                                                color: w.on
                                                    ? markInk
                                                    : w.accent,
                                              ),
                                            )
                                          : Icon(
                                              key: ValueKey(
                                                'mark-${_p > _threshold || w.on}',
                                              ),
                                              _p > _threshold || w.on
                                                  ? Icons.lock_open_rounded
                                                  : Icons
                                                        .power_settings_new_rounded,
                                              size: 26,
                                              color: w.on
                                                  ? markInk
                                                  : Color.lerp(
                                                      w.muted,
                                                      w.accent,
                                                      p * 0.9,
                                                    )!,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DrawCheck: the check that draws itself.
// ---------------------------------------------------------------------------

/// A checkmark that strokes itself in, once — the connection's own arrival
/// mark. Still under reduce-motion (there it is simply there).
class DrawCheck extends StatelessWidget {
  const DrawCheck({
    super.key,
    required this.color,
    this.size = 20,
    this.strokeWidth = 2.6,
  });

  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final still = _still(context);
    return TweenAnimationBuilder(
      tween: _unit,
      duration: still ? Duration.zero : const Duration(milliseconds: 560),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => CustomPaint(
        size: Size.square(size),
        painter: _CheckPainter(color: color, strokeWidth: strokeWidth, t: v),
      ),
    );
  }
}

/// The check's own path: short arm down-right, long arm up-right, trimmed
/// by [t] along its length.
class _CheckPainter extends CustomPainter {
  _CheckPainter({
    required this.color,
    required this.strokeWidth,
    required this.t,
  });

  final Color color;
  final double strokeWidth;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    final inset = strokeWidth;
    final path = Path()
      ..moveTo(
        box.left + inset + size.width * 0.06,
        box.center.dy + size.height * 0.10,
      )
      ..lineTo(
        box.left + size.width * 0.40,
        box.bottom - inset - size.height * 0.10,
      )
      ..lineTo(
        box.right - inset - size.width * 0.06,
        box.top + inset + size.height * 0.16,
      );
    final metric = path.computeMetrics().first;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      metric.extractPath(0, metric.length * t.clamp(0, 1)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) =>
      old.color != color || old.t != t || old.strokeWidth != strokeWidth;
}

// ---------------------------------------------------------------------------
// PulseHalo: the connected orb's breath.
// ---------------------------------------------------------------------------

/// Two soft rings that grow out of the child and fade — the connected
/// state's breath. Repeating, but the one polite loop: it stops dead under
/// reduce-motion ([still]) and when [paused] (the battery saver), where a
/// quiet static ring keeps the light without the motion.
class PulseHalo extends StatefulWidget {
  const PulseHalo({
    super.key,
    required this.child,
    required this.color,
    this.baseSize = 148,
    this.grow = 92,
    this.paused = false,
  });

  final Widget child;

  /// The ring's color; each ring carries it at a falling alpha.
  final Color color;

  /// The rings' starting diameter (the disc they grow from) and how far
  /// past it they reach.
  final double baseSize;
  final double grow;

  /// The battery saver's word: true holds a static ring, no loop.
  final bool paused;

  @override
  State<PulseHalo> createState() => _PulseHaloState();
}

class _PulseHaloState extends State<PulseHalo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.paused) _c.repeat();
  }

  @override
  void didUpdateWidget(PulseHalo old) {
    super.didUpdateWidget(old);
    if (widget.paused != old.paused) {
      if (widget.paused) {
        _c.stop();
      } else {
        _c.repeat();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = _still(context) || widget.paused;
    if (still) {
      // The quiet light: one static ring, no loop, no repaint.
      return Stack(
        alignment: Alignment.center,
        children: [_ring(0.16, 0.25), widget.child],
      );
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Two rings half a period apart, each dying as it grows.
            _ring(t, (1 - t) * 0.30),
            _ring((t + 0.5) % 1, (1 - (t + 0.5) % 1) * 0.30),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }

  Widget _ring(double t, double alpha) => Container(
    width: widget.baseSize + widget.grow * t,
    height: widget.baseSize + widget.grow * t,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: widget.color.withValues(alpha: alpha),
        width: 1.4,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// CrossfadeText: a word that glides to its next self.
// ---------------------------------------------------------------------------

/// Slides and fades between the word's own values — the state's word
/// ("Connecting", "Connected") never hard-swaps; the old lifts away while
/// the new settles in. The size is the Text's own.
class CrossfadeText extends StatelessWidget {
  const CrossfadeText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return Text(text, style: style, textAlign: textAlign);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 340),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (current, past) => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (final entry in past) IgnorePointer(child: entry),
          ?current,
        ],
      ),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.35),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: Text(
        text,
        key: ValueKey(text),
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shake: the wrong word's wiggle.
// ---------------------------------------------------------------------------

/// Shakes its child horizontally, [trigger] times — bump [trigger] to play
/// the wiggle again. The wrong password's own reply: the field shakes,
/// the words say why. Reduce-motion holds the wiggle at rest — the
/// controller still runs, the paint simply never moves.
class Shake extends StatefulWidget {
  const Shake({
    super.key,
    required this.child,
    required this.trigger,
    this.reaches = 8,
  });

  final Widget child;

  /// A counter: every new value replays the shake once.
  final int trigger;

  /// How far the wiggle reaches, in logical pixels.
  final double reaches;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void initState() {
    super.initState();
    if (widget.trigger > 0) _play();
  }

  @override
  void didUpdateWidget(Shake old) {
    super.didUpdateWidget(old);
    if (widget.trigger != old.trigger) _play();
  }

  void _play() {
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = _still(context);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        // Three decaying swings around the rest: sin over a half-wave
        // each. Reduce-motion keeps the paint still; nothing moves.
        final dx = still
            ? 0.0
            : math.sin(t * math.pi * 6) * (1 - t) * widget.reaches;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// The motion appendix: thirty more pieces, one vocabulary.
//
// The same rules the first nine keep: nothing loops without asking — every
// repeated motion takes a `paused` word (the battery saver's) and lies
// still under the system's reduce-motion setting; every entrance runs
// once, never re-run by a parent's rebuild; the on-demand wiggles replay
// only when their trigger really changes.
// ---------------------------------------------------------------------------

/// Whether motion rests here: the system's reduce-motion word, public for
/// the glass and the pages' own moving pieces.
bool motionStill(BuildContext context) => _still(context);

/// The shared entrance engine: one controller, an optional wait before it
/// runs, and the reduce-motion shortcut that lands the child where it
/// ends. The page's widgets build their own tweens on top of it.
class _Entrance extends StatefulWidget {
  const _Entrance({
    required this.build,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 380),
    this.curve = Curves.easeOutCubic,
  });

  /// The child drawn from the animation: the tween's own stage.
  final Widget Function(BuildContext context, Animation<double> animation)
  build;

  /// The wait before the entrance, so a page's pieces land one after
  /// another instead of all at once.
  final int delay;
  final Duration duration;
  final Curve curve;

  @override
  State<_Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<_Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..value = 1;

  late final CurvedAnimation _a = CurvedAnimation(
    parent: _c,
    curve: widget.curve,
  );
  bool _ran = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _run();
  }

  void _run() {
    if (_ran) return;
    _ran = true;
    if (_still(context)) return; // value stands at 1: the child, landed.
    _c.value = 0;
    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _c.forward();
      });
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _a);
}

/// 1. PopIn: the child lands with one small overshoot — the pop a good
/// badge makes. Under reduce-motion it simply is.
class PopIn extends StatelessWidget {
  const PopIn({
    super.key,
    required this.child,
    this.delay = 0,
    this.from = 0.72,
  });

  final Widget child;
  final int delay;
  final double from;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return _Entrance(
      delay: delay,
      duration: const Duration(milliseconds: 460),
      curve: Curves.easeOutBack,
      build:
          (context, a) => ScaleTransition(
            scale: a.drive(Tween<double>(begin: from, end: 1)),
            child: FadeTransition(opacity: a, child: child),
          ),
    );
  }
}

/// 2. SlideFadeIn: the child arrives from a direction — up from a list's
/// row, in from the page's own edge. Reduce-motion: it is simply there.
enum MotionFrom { up, down, start, end }

class SlideFadeIn extends StatelessWidget {
  const SlideFadeIn({
    super.key,
    required this.child,
    this.from = MotionFrom.up,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 360),
    this.distance = 18,
  });

  final Widget child;
  final MotionFrom from;
  final int delay;
  final Duration duration;
  final double distance;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    final offset = switch (from) {
      MotionFrom.up => Offset(0, distance),
      MotionFrom.down => Offset(0, -distance),
      MotionFrom.start => Offset(distance, 0),
      MotionFrom.end => Offset(-distance, 0),
    };
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final begin = rtl ? Offset(-offset.dx, offset.dy) : offset;
    return _Entrance(
      delay: delay,
      duration: duration,
      build:
          (context, a) => SlideTransition(
            position: a.drive(Tween<Offset>(begin: begin, end: Offset.zero)),
            child: FadeTransition(opacity: a, child: child),
          ),
    );
  }
}

/// 3. StaggerIn: the children cascade in — each one waits for the one
/// before it, the way a well-set list lands.
class StaggerIn extends StatelessWidget {
  const StaggerIn({
    super.key,
    required this.children,
    this.step = 70,
    this.from = MotionFrom.up,
  });

  final List<Widget> children;
  final int step;
  final MotionFrom from;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, child) in children.indexed)
          SlideFadeIn(from: from, delay: i * step, child: child),
      ],
    );
  }
}

/// 4. ScaleSwap: when the child's identity changes, the old folds away
/// and the new unfolds — one breath, no hard swap. Reduce-motion: the
/// plain change.
class ScaleSwap extends StatelessWidget {
  const ScaleSwap({super.key, required this.child, this.duration = 280});

  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder:
          (child, a) => ScaleTransition(
            scale: a.drive(Tween<double>(begin: 0.86, end: 1)),
            child: FadeTransition(opacity: a, child: child),
          ),
      child: KeyedSubtree(key: ValueKey(child), child: child),
    );
  }
}

/// 5. SlideSwap: the word (or row) glides to its next self — the old
/// leaves by one door, the new enters by the other.
class SlideSwap extends StatelessWidget {
  const SlideSwap({super.key, required this.child, this.up = true});

  final Widget child;

  /// The travel's direction: a rising value climbs.
  final bool up;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, a) {
        final incoming = child.key == ValueKey(this.child);
        final begin = incoming
            ? Offset(0, up ? 0.7 : -0.7)
            : Offset(0, up ? -0.7 : 0.7);
        return ClipRect(
          child: SlideTransition(
            position: a.drive(
              Tween<Offset>(
                begin: begin,
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: FadeTransition(opacity: a, child: child),
          ),
        );
      },
      child: KeyedSubtree(key: ValueKey(child), child: child),
    );
  }
}

/// 6. FadeThrough: the content fades out through its own middle and the
/// next fades in — the material's own patient change.
class FadeThrough extends StatelessWidget {
  const FadeThrough({super.key, required this.child, this.duration = 260});

  final Widget child;
  final int duration;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return AnimatedSwitcher(
      duration: Duration(milliseconds: duration),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder:
          (child, a) => FadeTransition(opacity: a, child: child),
      child: KeyedSubtree(key: ValueKey(child), child: child),
    );
  }
}

/// 7. FlipCounter: the number's digits roll like an odometer's — each one
/// that changed travels up to its next self. Tabular figures make the
/// columns stand still while the digits travel. Reduce-motion: the plain
/// text.
class FlipCounter extends StatelessWidget {
  const FlipCounter({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 420),
  });

  final String text;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return Text(text, style: style);
    final chars = text.characters.toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, ch) in chars.indexed)
          ClipRect(
            child: AnimatedSwitcher(
              duration: duration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, a) {
                final incoming = child.key == ValueKey('$i-$ch');
                // Both runs travel up: the arriving digit climbs from
                // below, the leaving one climbs out the top.
                final begin = incoming
                    ? const Offset(0, 0.62)
                    : const Offset(0, -0.62);
                return ClipRect(
                  child: SlideTransition(
                    position: a.drive(
                      Tween<Offset>(
                        begin: begin,
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutCubic)),
                    ),
                    child: FadeTransition(opacity: a, child: child),
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey('$i-$ch'),
                child: Text(ch, style: style),
              ),
            ),
          ),
      ],
    );
  }
}

/// 8. TickerNumber: a live number that walks to its target instead of
/// jumping — the rates' own pace. The builder draws the walked value.
class TickerNumber extends StatefulWidget {
  const TickerNumber({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 320),
  });

  final int value;
  final Widget Function(BuildContext context, int value) builder;
  final Duration duration;

  @override
  State<TickerNumber> createState() => _TickerNumberState();
}

class _TickerNumberState extends State<TickerNumber>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..value = 1;
  late int _from = widget.value;
  late int _to = widget.value;

  @override
  void didUpdateWidget(TickerNumber old) {
    super.didUpdateWidget(old);
    if (widget.value == _to) return;
    _from = _shown;
    _to = widget.value;
    if (_still(context) || _from == _to) {
      _c.value = 1;
      return;
    }
    _c.forward(from: 0);
  }

  int get _shown => (_from + (_to - _from) * _c.value).round();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => widget.builder(context, _shown),
    );
  }
}

/// 9. PulseDot: the state's own dot, breathing softly — the connecting
/// card's word made visible. Still for the battery saver and the
/// reduce-motion setting.
class PulseDot extends StatefulWidget {
  const PulseDot({
    super.key,
    required this.color,
    this.size = 8,
    this.paused = false,
  });

  final Color color;
  final double size;
  final bool paused;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.paused) _c.repeat();
  }

  @override
  void didUpdateWidget(PulseDot old) {
    super.didUpdateWidget(old);
    if (widget.paused != old.paused) {
      if (widget.paused) {
        _c.stop();
      } else {
        _c.repeat();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context) || widget.paused) {
      return _dot(1, 1);
    }
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => _dot(
            1 - 0.35 * math.sin(_c.value * math.pi),
            1 + 0.28 * math.sin(_c.value * math.pi),
          ),
    );
  }

  Widget _dot(double opacity, double scale) => Opacity(
    opacity: opacity.clamp(0.0, 1.0),
    child: Transform.scale(
      scale: scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
      ),
    ),
  );
}

/// 10. Breathe: the container's own quiet scale, in and out — the orb's
/// patience. Still under the battery saver and reduce-motion.
class Breathe extends StatefulWidget {
  const Breathe({
    super.key,
    required this.child,
    this.amount = 0.025,
    this.period = const Duration(milliseconds: 2400),
    this.paused = false,
  });

  final Widget child;
  final double amount;
  final Duration period;
  final bool paused;

  @override
  State<Breathe> createState() => _BreatheState();
}

class _BreatheState extends State<Breathe> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    if (!widget.paused) _c.repeat();
  }

  @override
  void didUpdateWidget(Breathe old) {
    super.didUpdateWidget(old);
    if (widget.paused != old.paused) {
      if (widget.paused) {
        _c.stop();
      } else {
        _c.repeat();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context) || widget.paused) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => Transform.scale(
            scale: 1 + widget.amount * math.sin(_c.value * math.pi * 2),
            child: widget.child,
          ),
    );
  }
}

/// 11. FloatY: the piece hangs in the air — a slow rise and settle. A
/// resting loop: still for the battery saver and reduce-motion.
class FloatY extends StatefulWidget {
  const FloatY({
    super.key,
    required this.child,
    this.distance = 5,
    this.period = const Duration(milliseconds: 3200),
    this.paused = false,
  });

  final Widget child;
  final double distance;
  final Duration period;
  final bool paused;

  @override
  State<FloatY> createState() => _FloatYState();
}

class _FloatYState extends State<FloatY> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    if (!widget.paused) _c.repeat();
  }

  @override
  void didUpdateWidget(FloatY old) {
    super.didUpdateWidget(old);
    if (widget.paused != old.paused) {
      if (widget.paused) {
        _c.stop();
      } else {
        _c.repeat();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context) || widget.paused) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => Transform.translate(
            offset: Offset(
              0,
              widget.distance * math.sin(_c.value * math.pi * 2),
            ),
            child: widget.child,
          ),
    );
  }
}

/// 12. GlowRing: one ring leaves the piece and dies — the commit's own
/// ripple. Played once; reduce-motion keeps it home.
class GlowRing extends StatefulWidget {
  const GlowRing({super.key, required this.color, this.trigger = 0});

  final Color color;

  /// Bump to play the ring again.
  final int trigger;

  @override
  State<GlowRing> createState() => _GlowRingState();
}

class _GlowRingState extends State<GlowRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void didUpdateWidget(GlowRing old) {
    super.didUpdateWidget(old);
    if (widget.trigger != old.trigger && !_still(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        if (t == 0 || t == 1) return const SizedBox.shrink();
        return Container(
          margin: EdgeInsets.all(24 * t),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withValues(alpha: (1 - t) * 0.55),
              width: 2.4 * (1 - t) + 0.6,
            ),
          ),
        );
      },
    );
  }
}

/// 13. RadarPing: the rings a measuring chip sends out — soft circles
/// leaving the piece while it listens, and stopping when it answers.
class RadarPing extends StatefulWidget {
  const RadarPing({
    super.key,
    required this.child,
    required this.color,
    this.active = false,
  });

  final Widget child;
  final Color color;
  final bool active;

  @override
  State<RadarPing> createState() => _RadarPingState();
}

class _RadarPingState extends State<RadarPing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat();
  }

  @override
  void didUpdateWidget(RadarPing old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      if (widget.active) {
        _c.repeat();
      } else {
        _c.stop();
        _c.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moving = widget.active && !_still(context);
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (widget.active) ...[
          if (moving) ...[
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final t = _c.value;
                return _ring(t, (1 - t) * 0.35);
              },
            ),
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final t = (_c.value + 0.5) % 1;
                return _ring(t, (1 - t) * 0.35);
              },
            ),
          ] else
            // Reduce-motion: one resting ring, no loop.
            _ring(0.15, 0.30),
        ],
        widget.child,
      ],
    );
  }

  Widget _ring(double t, double alpha) => Container(
    width: 34 + 26 * t,
    height: 34 + 26 * t,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: widget.color.withValues(alpha: alpha.clamp(0.0, 1.0)),
        width: 1.2,
      ),
    ),
  );
}

/// 14. OrbitDots: three dots chase each other around the circle while the
/// piece waits. Still — with the saver or reduce-motion — three resting
/// dots.
class OrbitDots extends StatefulWidget {
  const OrbitDots({
    super.key,
    required this.color,
    this.size = 18,
    this.active = true,
  });

  final Color color;
  final double size;
  final bool active;

  @override
  State<OrbitDots> createState() => _OrbitDotsState();
}

class _OrbitDotsState extends State<OrbitDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat();
  }

  @override
  void didUpdateWidget(OrbitDots old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      if (widget.active) {
        _c.repeat();
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spin = _still(context) || !widget.active ? 0.0 : _c.value;
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => SizedBox.square(
            dimension: widget.size,
            child: CustomPaint(
              painter: _OrbitPainter(color: widget.color, turn: spin),
            ),
          ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({required this.color, required this.turn});

  final Color color;
  final double turn;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 1.5;
    for (var i = 0; i < 3; i++) {
      final angle = turn * math.pi * 2 + i * math.pi * 2 / 3;
      final dot = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      canvas.drawCircle(
        dot,
        1.8,
        Paint()..color = color.withValues(alpha: 0.35 + 0.65 * (i / 3)),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.color != color || old.turn != turn;
}

/// 15. TypeDots: the wait's own ellipsis, one dot at a time — "…" that
/// breathes while the work runs.
class TypeDots extends StatefulWidget {
  const TypeDots({
    super.key,
    required this.color,
    this.active = true,
    this.period = const Duration(milliseconds: 1100),
  });

  final Color color;
  final bool active;
  final Duration period;

  @override
  State<TypeDots> createState() => _TypeDotsState();
}

class _TypeDotsState extends State<TypeDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat();
  }

  @override
  void didUpdateWidget(TypeDots old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      if (widget.active) {
        _c.repeat();
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Opacity(
                    opacity: _lit(i),
                    child: Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color,
                      ),
                    ),
                  ),
                ),
            ],
          ),
    );
  }

  double _lit(int i) {
    if (_still(context) || !widget.active) return i == 0 ? 1 : 0.35;
    final t = (_c.value * 3 - i) % 1;
    return 0.35 + 0.65 * (1 - t.abs());
  }
}

/// 16. SweepLoader: the arc that sweeps and spins — the busy word drawn
/// by hand, quiet beside the material spinner's own.
class SweepLoader extends StatefulWidget {
  const SweepLoader({
    super.key,
    required this.color,
    this.size = 16,
    this.stroke = 2,
    this.active = true,
  });

  final Color color;
  final double size;
  final double stroke;
  final bool active;

  @override
  State<SweepLoader> createState() => _SweepLoaderState();
}

class _SweepLoaderState extends State<SweepLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat();
  }

  @override
  void didUpdateWidget(SweepLoader old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      if (widget.active) {
        _c.repeat();
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final turn = _still(context) || !widget.active ? 0.0 : _c.value;
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, _) => SizedBox.square(
            dimension: widget.size,
            child: CustomPaint(
              painter: _SweepPainter(
                color: widget.color,
                turn: turn,
                stroke: widget.stroke,
              ),
            ),
          ),
    );
  }
}

class _SweepPainter extends CustomPainter {
  _SweepPainter({
    required this.color,
    required this.turn,
    required this.stroke,
  });

  final Color color;
  final double turn;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - stroke;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final span = math.pi * (0.6 + 0.4 * math.sin(turn * math.pi * 2));
    canvas.drawArc(
      rect,
      turn * math.pi * 2,
      span,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SweepPainter old) =>
      old.color != color || old.turn != turn;
}

/// 17. WaveProgress: the bar the water fills — a wave rides the level
/// while it moves, and rests when the fill is done or motion sleeps.
class WaveProgress extends StatefulWidget {
  const WaveProgress({
    super.key,
    required this.value,
    required this.color,
    this.height = 6,
    this.radius = 3,
    this.active = true,
  });

  /// The fill's level, 0→1.
  final double value;
  final Color color;
  final double height;
  final double radius;
  final bool active;

  @override
  State<WaveProgress> createState() => _WaveProgressState();
}

class _WaveProgressState extends State<WaveProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat();
  }

  @override
  void didUpdateWidget(WaveProgress old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      if (widget.active) {
        _c.repeat();
      } else {
        _c.stop();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: widget.value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder:
          (context, level, _) => ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: CustomPaint(
              size: Size(double.infinity, widget.height),
              painter: _WavePainter(
                color: widget.color,
                level: level,
                phase: _still(context) || !widget.active ? 0 : _c.value,
              ),
            ),
          ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.color,
    required this.level,
    required this.phase,
  });

  final Color color;
  final double level;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final track =
        Paint()
          ..color = color.withValues(alpha: 0.16)
          ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(size.height / 2),
      ),
      track,
    );
    final top = size.height * (1 - level);
    final path =
        Path()
          ..moveTo(0, top)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, top);
    // The water's own surface: crests that travel while the fill moves.
    for (var x = 0.0; x <= size.width; x += 4) {
      final y =
          top +
          1.4 *
              math.sin(
                (x / size.width) * math.pi * 6 + phase * math.pi * 2,
              );
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.color != color || old.level != level || old.phase != phase;
}

/// 18. SpringBar: the width that arrives with a spring — the quota bar's
/// own landing, one soft overshoot and settle.
class SpringBar extends StatelessWidget {
  const SpringBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 8,
    this.radius = 4,
    this.track,
  });

  /// The fill's level, 0→1.
  final double value;
  final Color color;
  final double height;
  final double radius;
  final Color? track;

  @override
  Widget build(BuildContext context) {
    final level = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        color: track ?? color.withValues(alpha: 0.14),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: level),
            duration: const Duration(milliseconds: 720),
            curve: Curves.easeOutBack,
            builder:
                (context, v, _) => FractionallySizedBox(
                  widthFactor: v.clamp(0.0, 1.0),
                  child: Container(color: color),
                ),
          ),
        ),
      ),
    );
  }
}

/// 19. MeterArc: the arc that walks to its value — the speed test's own
/// needle, drawn without a needle.
class MeterArc extends StatelessWidget {
  const MeterArc({
    super.key,
    required this.value,
    required this.color,
    this.stroke = 8,
    this.track,
    this.child,
    this.duration = const Duration(milliseconds: 900),
    this.curve = Curves.easeOutCubic,
  });

  /// The level, 0→1.
  final double value;
  final Color color;
  final double stroke;
  final Color? track;
  final Widget? child;

  /// The walk's own time and ease: the caller that retargets every
  /// hundred milliseconds (the speed test's honest sweep) asks for a
  /// short linear walk, or the needle spends its run catching up with
  /// the value it was given.
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.clamp(0.0, 1.0)),
      duration: duration,
      curve: curve,
      builder:
          (context, v, child) => CustomPaint(
            painter: _ArcPainter(
              color: color,
              value: v,
              stroke: stroke,
              track: track ?? color.withValues(alpha: 0.14),
            ),
            child: child,
          ),
      child: child,
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.color,
    required this.value,
    required this.stroke,
    required this.track,
  });

  final Color color;
  final double value;
  final double stroke;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - stroke;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final trackPaint =
        Paint()
          ..color = track
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round;
    // The arc runs the circle's top: from the left horizon, over the
    // noon, to the right.
    canvas.drawArc(rect, -math.pi, math.pi, false, trackPaint);
    if (value <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi,
      math.pi * value,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.color != color || old.value != value;
}

/// 20. IconSpin: the icon turns in — a half-turn and a fade, the way a
/// refreshed state announces itself.
class IconSpin extends StatelessWidget {
  const IconSpin({super.key, required this.child, this.turns = 0.5});

  final Widget child;
  final double turns;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder:
          (child, a) => FadeTransition(
            opacity: a,
            child: AnimatedBuilder(
              animation: a,
              builder:
                  (context, _) => RotationTransition(
                    turns: AlwaysStoppedAnimation(turns * (1 - a.value)),
                    child: child,
                  ),
            ),
          ),
      child: KeyedSubtree(key: ValueKey(child), child: child),
    );
  }
}

/// 21. ShimmerText: the word the light walks across — once for an
/// announcement, and again while [active] asks.
class ShimmerText extends StatefulWidget {
  const ShimmerText({
    super.key,
    required this.child,
    required this.color,
    this.active = false,
    this.once = true,
  });

  final Widget child;
  final Color color;

  /// True keeps the light walking while it shows; false lets it pass
  /// once and be done.
  final bool active;
  final bool once;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active || !widget.once) {
      _c.repeat();
    } else {
      _c.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(ShimmerText old) {
    super.didUpdateWidget(old);
    if (widget.active != old.active) {
      if (widget.active || !widget.once) {
        _c.repeat();
      } else {
        _c.stop();
        _c.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, child) => ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback:
                (bounds) => LinearGradient(
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                  colors: [
                    Colors.transparent,
                    widget.color.withValues(alpha: 0.65),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(
                  bounds.translate(bounds.width * (2 * _c.value - 1), 0),
                ),
            child: child,
          ),
      child: widget.child,
    );
  }
}

/// 22. CheckBloom: the ring of light blooms out from under the piece —
/// the answer's own entrance (the drawn check rides on top of it).
class CheckBloom extends StatelessWidget {
  const CheckBloom({
    super.key,
    required this.child,
    required this.color,
    this.size = 44,
  });

  final Widget child;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return _Entrance(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      build:
          (context, a) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size + size * 0.9 * a.value,
                height: size + size * 0.9 * a.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: (1 - a.value) * 0.5),
                    width: 1.6,
                  ),
                ),
              ),
              child,
            ],
          ),
    );
  }
}

/// 23. LiftHover: the card rises to the pointer — a small lift and a
/// shadow, the desktop's own invitation. Nothing moves without a pointer.
class LiftHover extends StatefulWidget {
  const LiftHover({super.key, required this.child, this.height = 2});

  final Widget child;
  final double height;

  @override
  State<LiftHover> createState() => _LiftHoverState();
}

class _LiftHoverState extends State<LiftHover> {
  bool _over = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _over = true),
      onExit: (_) => setState(() => _over = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _over ? -widget.height : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: _over
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : const [],
        ),
        child: widget.child,
      ),
    );
  }
}

/// 24. TiltHover: the card leans to the pointer — a parallax the desktop
/// knows from the glass panels of its best apps.
class TiltHover extends StatefulWidget {
  const TiltHover({super.key, required this.child, this.angle = 0.03});

  final Widget child;
  final double angle;

  @override
  State<TiltHover> createState() => _TiltHoverState();
}

class _TiltHoverState extends State<TiltHover> {
  Offset _lean = Offset.zero;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return widget.child;
    return MouseRegion(
      onHover: (event) {
        final box = context.findRenderObject()! as RenderBox;
        final size = box.size;
        final local = event.localPosition;
        setState(() {
          _lean = Offset(
            (local.dx / size.width - 0.5) * -2,
            (local.dy / size.height - 0.5) * 2,
          );
        });
      },
      onExit: (_) => setState(() => _lean = Offset.zero),
      child: TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(end: _lean),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        builder:
            (context, lean, child) => Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(widget.angle * lean.dy)
                    ..rotateY(widget.angle * lean.dx),
              child: child,
            ),
        child: widget.child,
      ),
    );
  }
}

/// 25. Wobble: the piece rocks once — a small no that asks to be seen.
/// Bump [trigger] to play it again.
class Wobble extends StatefulWidget {
  const Wobble({super.key, required this.child, this.trigger = 0});

  final Widget child;
  final int trigger;

  @override
  State<Wobble> createState() => _WobbleState();
}

class _WobbleState extends State<Wobble> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  @override
  void didUpdateWidget(Wobble old) {
    super.didUpdateWidget(old);
    if (widget.trigger != old.trigger && !_still(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, child) =>
              _c.value == 0 || _c.value == 1
                  ? child!
                  : Transform.rotate(
                    angle:
                        math.sin(_c.value * math.pi * 4) *
                        0.05 *
                        (1 - _c.value),
                    child: child,
                  ),
      child: widget.child,
    );
  }
}

/// 26. Heartbeat: the double pulse — the piece beats twice, once, when
/// the news needs the eye. Bump [trigger] to play it again.
class Heartbeat extends StatefulWidget {
  const Heartbeat({super.key, required this.child, this.trigger = 0});

  final Widget child;
  final int trigger;

  @override
  State<Heartbeat> createState() => _HeartbeatState();
}

class _HeartbeatState extends State<Heartbeat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
  );

  @override
  void didUpdateWidget(Heartbeat old) {
    super.didUpdateWidget(old);
    if (widget.trigger != old.trigger && !_still(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, child) =>
              _c.value == 0 || _c.value == 1
                  ? child!
                  : Transform.scale(
                    scale: 1 + 0.06 * math.sin(_c.value * math.pi * 4),
                    child: child,
                  ),
      child: widget.child,
    );
  }
}

/// 27. AuroraShift: the hero's wash of color drifts, very slowly — the
/// light of the two designs' tops, alive but at rest for the saver.
class AuroraShift extends StatefulWidget {
  const AuroraShift({
    super.key,
    required this.child,
    required this.colors,
    this.period = const Duration(milliseconds: 9000),
    this.paused = false,
  });

  final Widget child;
  final List<Color> colors;
  final Duration period;
  final bool paused;

  @override
  State<AuroraShift> createState() => _AuroraShiftState();
}

class _AuroraShiftState extends State<AuroraShift>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void initState() {
    super.initState();
    if (!widget.paused) _c.repeat();
  }

  @override
  void didUpdateWidget(AuroraShift old) {
    super.didUpdateWidget(old);
    if (widget.paused != old.paused) {
      if (widget.paused) {
        _c.stop();
      } else {
        _c.repeat();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context) || widget.paused) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, child) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.colors,
                transform: GradientRotation(_c.value * math.pi * 2),
              ),
            ),
            child: child,
          ),
      child: widget.child,
    );
  }
}

/// 28. DockRise: the dock's pieces rise in — each one a breath after the
/// one before, with the spring a floating bar arrives with.
class DockRise extends StatelessWidget {
  const DockRise({
    super.key,
    required this.child,
    this.index = 0,
    this.step = 60,
  });

  final Widget child;

  /// The piece's seat in the dock: later seats rise later.
  final int index;
  final int step;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return _Entrance(
      delay: index * step,
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeOutBack,
      build:
          (context, a) => SlideTransition(
            position: a.drive(
              Tween<Offset>(
                begin: const Offset(0, 0.6),
                end: Offset.zero,
              ),
            ),
            child: ScaleTransition(
              scale: a.drive(Tween<double>(begin: 0.88, end: 1)),
              child: FadeTransition(opacity: a, child: child),
            ),
          ),
    );
  }
}

/// 29. PageGlide: a pushed page arrives by gliding — a short rise and a
/// fade, once, the way the shell's own push should feel. Reduce-motion:
/// the page is simply there.
class PageGlide extends StatelessWidget {
  const PageGlide({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (_still(context)) return child;
    return _Entrance(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      build:
          (context, a) => SlideTransition(
            position: a.drive(
              Tween<Offset>(
                begin: const Offset(0, 0.025),
                end: Offset.zero,
              ),
            ),
            child: FadeTransition(opacity: a, child: child),
          ),
    );
  }
}

/// 30. SectionSweep: the quiet line that runs along a section's edge
/// while it saves — a word for "working" without a spinner's noise.
class SectionSweep extends StatefulWidget {
  const SectionSweep({
    super.key,
    required this.child,
    required this.color,
    this.busy = false,
  });

  final Widget child;
  final Color color;
  final bool busy;

  @override
  State<SectionSweep> createState() => _SectionSweepState();
}

class _SectionSweepState extends State<SectionSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.busy) _c.repeat();
  }

  @override
  void didUpdateWidget(SectionSweep old) {
    super.didUpdateWidget(old);
    if (widget.busy != old.busy) {
      if (widget.busy) {
        _c.repeat();
      } else {
        _c.stop();
        _c.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        // The line's own walk: alignment carries it from edge to edge
        // inside the section, so nothing paints over the neighbors.
        final walk = -1.0 + 2.0 * _c.value;
        return Stack(
          children: [
            child!,
            if (widget.busy)
              PositionedDirectional(
                top: 0,
                start: 0,
                end: 0,
                child: Align(
                  alignment: Alignment(walk, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            widget.color,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
// ---------------------------------------------------------------------------
// SmoothEnter: the section that breathes in instead of snapping.
// ---------------------------------------------------------------------------

/// The section whose arrival reads as one motion: the content fades and
/// lifts in while the space it needs grows beneath the page, and walks
/// back out the same way. The connected section's home was the abrupt
/// one — the cards snapped up between two frames, dry and sudden; this
/// hands the same section its own entrance. Under reduce-motion the
/// change keeps its honest instant.
class SmoothEnter extends StatelessWidget {
  const SmoothEnter({
    super.key,
    required this.show,
    required this.shown,
    required this.hidden,
  });

  /// Which of the two faces stands: the [shown] child when true, the
  /// [hidden] child when false — the crossfade and the size walk run
  /// between them, in both directions.
  final bool show;

  /// The face the section wears while [show] stands.
  final Widget shown;

  /// The face the section wears otherwise (the hints, the problem boxes).
  final Widget hidden;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.of(context).disableAnimations;
    final duration = still ? Duration.zero : const Duration(milliseconds: 380);
    // The size walks through SizeTransition (a fractional seat, laid out
    // from the parent's constraint) instead of AnimatedSize — under an
    // IntrinsicHeight the measured child can re-declare its size in the
    // middle of the layout pass, and an AnimatedSize would restart its
    // own controller there (a render object mutated in its own
    // performLayout). The fraction asks no such second answer: it grows
    // from the height the parent already granted.
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => SizeTransition(
        sizeFactor: anim,
        axis: Axis.vertical,
        // The seat's top: the child sits at the growth's start, so the
        // section never drifts while its height walks.
        alignment: const Alignment(0, -1),
        child: FadeTransition(opacity: anim, child: child),
      ),
      // Both faces pin to the seat's top while the crossfade runs, so
      // the section never drifts as its height walks.
      layoutBuilder: (currentChild, previousChildren) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[...previousChildren, ?currentChild],
      ),
      child: show
          ? KeyedSubtree(key: const ValueKey('enter-shown'), child: shown)
          : KeyedSubtree(key: const ValueKey('enter-hidden'), child: hidden),
    );
  }
}
