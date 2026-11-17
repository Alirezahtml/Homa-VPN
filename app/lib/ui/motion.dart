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
class Reveal extends StatelessWidget {
  const Reveal({super.key, required this.child, this.index = 0});

  final Widget child;

  /// The slot in the page: 0 first, 1 next, and so on.
  final int index;

  @override
  Widget build(BuildContext context) {
    final still = _still(context);
    if (still) return child;
    final curve = Interval(
      math.min(index * 0.07, 0.45),
      1,
      curve: Curves.easeOutCubic,
    );
    return TweenAnimationBuilder(
      tween: _unit,
      duration: Duration(milliseconds: 420 + math.min(index, 8) * 60),
      curve: curve,
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0, 1),
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - v)),
          child: Transform.scale(scale: 0.985 + 0.015 * v, child: child),
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
    return Opacity(
      opacity: w.busy ? 0.75 : 1,
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
                                  child: Opacity(
                                    opacity: w.busy
                                        ? 1
                                        : w.on
                                        ? 1
                                        : (1 - p * 2.1).clamp(0, 1),
                                    child: Transform.translate(
                                      offset: Offset(-14 * p * dir, 0),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Shimmer(
                                            color: Colors.white.withValues(
                                              alpha: w.dark ? 0.85 : 0.5,
                                            ),
                                            child: Text(
                                              // Busy: the connection's own
                                              // word ("Connecting…"); on:
                                              // the state's word; off: the
                                              // connect hint.
                                              w.busy
                                                  ? (w.labelBusy.isEmpty
                                                        ? w.labelConnect
                                                        : w.labelBusy)
                                                  : w.on
                                                  ? w.labelOn
                                                  : w.labelConnect,
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
                                                    ? Colors.white
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
                                                  ? Colors.white
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
