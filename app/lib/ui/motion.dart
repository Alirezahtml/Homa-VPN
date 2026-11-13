/// The Homa motion system: the moving parts of the Maximalism design.
///
/// Everything here is smooth by design and polite to the battery:
/// - the endless animations (the aurora, the island's sweep, the shimmers,
///   the pulses) pause when the app leaves the screen and honor the
///   system's reduce-motion setting (`MediaQuery.disableAnimations`);
/// - the entrance animations run once and never re-run on a refresh, so a
///   status update repaints text, not the whole page.
///
/// Animation inventory (the design's 50+ motions):
///  1. Aurora blob 1 drift          2. Aurora blob 2 drift
///  3. Aurora blob 3 drift          4. Aurora star drift
///  5. Aurora star twinkle          6. Aurora state-color crossfade
///  7. Reveal fade                  8. Reveal slide-up
///  9. Reveal scale                10. Reveal index stagger
/// 11. Pressable press scale       12. Pressable release spring
/// 13. CountUp value tween         14. CountUp curve
/// 15. Shimmer highlight sweep     16. Shimmer fade at the ends
/// 17. PulsingDot scale            18. PulsingDot opacity
/// 19. SlideToConnect knob drag    20. SlideToConnect track fill
/// 21. SlideToConnect snap-back    22. SlideToConnect confirm spring
/// 23. SlideToConnect success ring 24. SlideToConnect success fade
/// 25. SlideToConnect icon morph   26. SlideToConnect label slide
/// 27. SlideToConnect label fade   28. SlideToConnect knob glow
/// 29. SlideToConnect idle shimmer 30. SlideToConnect busy spinner
/// 31. SlideToConnect focus ring   32. SlideToConnect state crossfade
/// 33. DynamicIsland width change  34. DynamicIsland height change
/// 35. DynamicIsland color morph   36. DynamicIsland border sweep
/// 37. DynamicIsland label swap    38. DynamicIsland timer tick
/// 39. DynamicIsland dot pulse     40. DynamicIsland details expand
/// 41. DynamicIsland rates fade    42. DynamicIsland sparkline
/// 43. DynamicIsland delay tint    44. DynamicIsland entrance
/// 45. State-label AnimatedSwitcher (overview) 46. Card press lift
/// 47. Quota ring count-up         48. Panel entrance
/// 49. PageTitle entrance          50. SettingsGroup tile stagger
/// 51. Servers page card stagger   52. Welcome page stagger
/// 53. Tab switch cross-fade       54. Mode pill slide (existed, tuned)
/// 55. Pill nav light slide        56. Pill icon fill and lift
/// 57. Pill press sink             58. Pill label brighten
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/models.dart';
import 'format.dart';

/// The shared 0→1 tween: one instance, so a parent's rebuild never
/// restarts a finished entrance (TweenAnimationBuilder compares identity).
final Tween<double> _unit = Tween<double>(begin: 0, end: 1);

/// Whether the system asks for less motion.
bool _still(BuildContext context) => MediaQuery.of(context).disableAnimations;

// ---------------------------------------------------------------------------
// Aurora: the drifting lights behind the home pages.
// ---------------------------------------------------------------------------

/// Three soft lights and a field of tiny stars that drift around the
/// state's color. One ticker for the whole page; paused while the app is
/// hidden (the tray, a locked phone) so an endless animation never burns a
/// core in the background.
class Aurora extends StatefulWidget {
  const Aurora({
    super.key,
    required this.accent,
    required this.second,
    required this.third,
    required this.dark,
    this.stars = true,
  });

  /// The connection state's color: the first light follows it.
  final Color accent;
  final Color second;
  final Color third;
  final bool dark;
  final bool stars;

  @override
  State<Aurora> createState() => _AuroraState();
}

class _AuroraState extends State<Aurora> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 36),
    value: 0.13,
  );
  late AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: _onState);
  }

  void _onState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.resumed) {
      if (!_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_still(context)) {
      return CustomPaint(
        painter: _AuroraPainter(
          t: 0.13,
          accent: widget.accent,
          second: widget.second,
          third: widget.third,
          dark: widget.dark,
          stars: widget.stars,
        ),
      );
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _AuroraPainter(
          t: _c.value,
          accent: widget.accent,
          second: widget.second,
          third: widget.third,
          dark: widget.dark,
          stars: widget.stars,
        ),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.t,
    required this.accent,
    required this.second,
    required this.third,
    required this.dark,
    required this.stars,
  });

  final double t;
  final Color accent;
  final Color second;
  final Color third;
  final bool dark;
  final bool stars;

  @override
  void paint(Canvas canvas, Size size) {
    final a = t * 2 * math.pi;
    void blob(double cx, double cy, double r, Color color, double alpha) {
      final rect = Rect.fromCircle(
        center: Offset(cx * size.width, cy * size.height),
        radius: r * size.shortestSide,
      );
      canvas.drawCircle(
        rect.center,
        r * size.shortestSide,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ).createShader(rect),
      );
    }

    // The lights: the state's color near the top, the two accents lower.
    blob(
      0.22 + 0.08 * math.sin(a),
      0.16 + 0.06 * math.cos(a * 1.3),
      0.46,
      accent,
      dark ? 0.24 : 0.16,
    );
    blob(
      0.86 + 0.05 * math.cos(a * 0.8),
      0.42 + 0.09 * math.sin(a * 1.1),
      0.40,
      second,
      dark ? 0.14 : 0.13,
    );
    blob(
      0.42 + 0.10 * math.sin(a * 0.6 + 1.2),
      0.96 + 0.04 * math.cos(a * 0.9),
      0.44,
      third,
      dark ? 0.12 : 0.10,
    );
    if (!stars) return;
    // Tiny stars: a fixed field per seed, drifting up and twinkling.
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 42; i++) {
      final r1 = math.Random(i * 7 + 1).nextDouble();
      final r2 = math.Random(i * 13 + 5).nextDouble();
      final r3 = math.Random(i * 29 + 11).nextDouble();
      final x = (r1 + 0.004 * math.sin(a * 2 + i)) * size.width;
      final y = ((r2 - t * (0.016 + r3 * 0.022)) % 1 + 1) % 1 * size.height;
      final tw = 0.5 + 0.5 * math.sin(a * 3 + i * 1.7);
      paint.color = Colors.white.withValues(alpha: (dark ? 0.16 : 0.10) * tw);
      canvas.drawCircle(Offset(x, y), 0.7 + r3 * 1.3, paint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.t != t || old.accent != accent || old.dark != dark;
}

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
    if (!_still(context) && !_c.isAnimating) _c.repeat();
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
// PulsingDot: the live status.
// ---------------------------------------------------------------------------

/// The island's status dot: a soft, slow pulse while the connection is
/// alive; a steady point otherwise.
class PulsingDot extends StatefulWidget {
  const PulsingDot({
    super.key,
    required this.color,
    required this.active,
    this.size = 9,
  });

  final Color color;
  final bool active;
  final double size;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.active && !_still(context) && !_c.isAnimating) _c.repeat();
  }

  @override
  void didUpdateWidget(PulsingDot old) {
    super.didUpdateWidget(old);
    final run = widget.active && !_still(context);
    if (!run) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.55),
            blurRadius: 7,
            spreadRadius: 0.5,
          ),
        ],
      ),
    );
    if (!widget.active || _still(context)) return dot;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final v = _c.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1 + v * 1.5,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.35 * (1 - v)),
                ),
              ),
            ),
            Transform.scale(
              scale: 1 + 0.12 * math.sin(v * math.pi),
              child: child,
            ),
          ],
        );
      },
      child: dot,
    );
  }
}

// ---------------------------------------------------------------------------
// Sparkline: the traffic history.
// ---------------------------------------------------------------------------

/// The last seconds of throughput as a small filled curve.
class Sparkline extends StatelessWidget {
  const Sparkline({super.key, required this.samples, required this.color});

  final List<double> samples;

  /// The highest sample over the whole buffer, so the shape keeps its
  /// scale between frames.
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(64, 20),
    painter: _SparklinePainter(samples: samples, color: color),
  );
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.samples, required this.color});

  final List<double> samples;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) return;
    final max = samples.reduce(math.max);
    if (max <= 0) return;
    final path = Path();
    for (var i = 0; i < samples.length; i++) {
      final x = i / (samples.length - 1) * size.width;
      final y = size.height - (samples[i] / max) * (size.height - 2) - 1;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final rect = Offset.zero & size;
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.0)],
        ).createShader(rect),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.samples != samples;
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
    required this.tooltip,
    required this.onPressed,
    this.autofocus = false,
  });

  final bool on;
  final bool busy;
  final Color accent;
  final bool dark;
  final Color card;
  final Color border;
  final Color text;
  final Color muted;

  /// The track's hint while off and while on.
  final String labelConnect;
  final String labelDisconnect;
  final String tooltip;
  final VoidCallback onPressed;
  final bool autofocus;

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

  static const _threshold = 0.72;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _snap.addListener(() => setState(() => _p = _snap.value));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget.on && !_still(context) && !_idle.isAnimating) _idle.repeat();
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
    final idleRun = !widget.on && !_dragging && !_still(context);
    if (!idleRun) {
      _idle.stop();
    } else if (!_idle.isAnimating) {
      _idle.repeat();
    }
  }

  @override
  void dispose() {
    _snap.dispose();
    _bloom.dispose();
    _idle.dispose();
    super.dispose();
  }

  void _commit() {
    HapticFeedback.mediumImpact();
    _bloom.forward(from: 0);
    widget.onPressed();
  }

  static const knobSize = 62.0;

  /// The knob's travel: this box's width, less the knob itself.
  double get _travel {
    final box = context.findRenderObject();
    return box is RenderBox && box.hasSize
        ? math.max(box.size.width - knobSize, 1.0)
        : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // The knob rides on the track's ends: the track is inset by the knob's
    // radius, and the knob's center runs between those ends.
    const height = 78.0;
    const knob = knobSize;
    const half = knob / 2;
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
                animation: Listenable.merge([_bloom, _idle]),
                builder: (context, child) {
                  final bloom = _bloom.value;
                  final shimmer = _idle.value;
                  final p = _p.clamp(0.0, 1.0);
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // The track: inset so the knob covers its ends.
                      PositionedDirectional(
                        start: half,
                        end: half,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(half),
                            color: w.card,
                            border: Border.all(
                              color: Color.lerp(
                                w.border,
                                w.accent.withValues(alpha: 0.55),
                                p,
                              )!,
                              width: 1.3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: w.accent.withValues(
                                  alpha: 0.10 + 0.20 * p,
                                ),
                                blurRadius: 18 + 14 * p,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(half),
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
                                // The hint label.
                                PositionedDirectional(
                                  start: half + 8,
                                  end: knob,
                                  top: 0,
                                  bottom: 0,
                                  child: Opacity(
                                    opacity: (1 - p * 2.1).clamp(0, 1),
                                    child: Transform.translate(
                                      offset: Offset(-14 * p, 0),
                                      child: Center(
                                        child: Shimmer(
                                          color: Colors.white.withValues(
                                            alpha: w.dark ? 0.85 : 0.5,
                                          ),
                                          child: Text(
                                            w.on
                                                ? w.labelDisconnect
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      // The success ring and the knob, on one line.
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: half),
                        child: Align(
                          alignment: AlignmentDirectional(2 * p - 1, 0),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              if (bloom > 0 && bloom < 1)
                                IgnorePointer(
                                  child: Container(
                                    width: knob + 20,
                                    height: knob + 20,
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
                                    child: w.busy
                                        ? SizedBox.square(
                                            dimension: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              color: w.on
                                                  ? Colors.white
                                                  : w.accent,
                                            ),
                                          )
                                        : AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 220,
                                            ),
                                            switchInCurve: Curves.easeOutBack,
                                            switchOutCurve: Curves.easeIn,
                                            transitionBuilder: (child, anim) =>
                                                ScaleTransition(
                                                  scale: anim,
                                                  child: FadeTransition(
                                                    opacity: anim,
                                                    child: child,
                                                  ),
                                                ),
                                            child: Icon(
                                              _p > _threshold || w.on
                                                  ? Icons.lock_open_rounded
                                                  : Icons
                                                        .power_settings_new_rounded,
                                              key: ValueKey(
                                                _p > _threshold || w.on,
                                              ),
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
// DynamicIsland: the status pill.
// ---------------------------------------------------------------------------

/// The home page's living pill: the state by color and word, and while
/// connected the elapsed time, the live throughput with its history curve,
/// and the real delay. It stretches between states and taps open the
/// details row.
class DynamicIsland extends StatefulWidget {
  const DynamicIsland({
    super.key,
    required this.accent,
    required this.label,
    required this.dark,
    required this.connected,
    required this.busy,
    required this.card,
    required this.border,
    required this.text,
    required this.muted,
    this.startedAt,
    this.traffic,
    this.delayMs,
    this.onTap,
  });

  final Color accent;
  final String label;
  final bool dark;
  final bool connected;
  final bool busy;
  final Color card;
  final Color border;
  final Color text;
  final Color muted;

  /// When the connection started, for the elapsed time.
  final DateTime? startedAt;

  /// The live throughput.
  final Traffic? traffic;

  /// The last test's real delay, when it passed.
  final int? delayMs;
  final VoidCallback? onTap;

  @override
  State<DynamicIsland> createState() => _DynamicIslandState();
}

class _DynamicIslandState extends State<DynamicIsland>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  Timer? _tick;
  List<double> _history = [];
  String _elapsed = '';
  bool _open = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(DynamicIsland old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final run = widget.busy && !_still(context);
    if (!run) {
      _sweep.stop();
    } else if (!_sweep.isAnimating) {
      _sweep.repeat();
    }
    final runTick = widget.connected;
    if (runTick && _tick == null) {
      _sample();
      _tick = Timer.periodic(const Duration(seconds: 1), (_) => _sample());
    } else if (!runTick && _tick != null) {
      _tick?.cancel();
      _tick = null;
      _history = [];
      _elapsed = '';
    }
  }

  void _sample() {
    if (!mounted) return;
    setState(() {
      final t = widget.traffic;
      _history = [..._history.take(31), (t?.downRate ?? 0).toDouble()];
      final start = widget.startedAt;
      if (start != null) {
        final s = DateTime.now().difference(start).inSeconds.clamp(0, 86399);
        _elapsed =
            '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget;
    final connected = w.connected;
    final down = formatRate(w.traffic?.downRate ?? 0);
    final up = formatRate(w.traffic?.upRate ?? 0);
    final delay = w.delayMs;
    final pill = AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: w.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Color.lerp(
            w.border,
            w.accent.withValues(alpha: 0.6),
            connected || w.busy ? 1.0 : 0.25,
          )!,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: w.accent.withValues(
              alpha: connected || w.busy ? 0.22 : 0.08,
            ),
            blurRadius: 16 + (connected ? 8.0 : 0),
            offset: const Offset(0, 6),
          ),
        ],
      ),
      foregroundDecoration: w.busy
          ? BoxDecoration(borderRadius: BorderRadius.circular(24))
          : null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: w.onTap ?? () => setState(() => _open = !_open),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PulsingDot(
                        color: w.accent,
                        active: connected || w.busy,
                        size: 8,
                      ),
                      const SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
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
                          w.label,
                          key: ValueKey(w.label),
                          style: TextStyle(
                            color: w.text,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                      if (connected && _elapsed.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: w.accent.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ltr(_elapsed),
                            style: TextStyle(
                              color: w.text,
                              fontSize: 12.5,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                      if (w.busy) ...[
                        const SizedBox(width: 8),
                        SizedBox.square(
                          dimension: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            color: w.accent,
                          ),
                        ),
                      ],
                      if (connected) ...[
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: _open ? 0.5 : 0,
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 17,
                            color: w.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // The details row: live rates, their curve, the delay.
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    sizeCurve: Curves.easeOutCubic,
                    crossFadeState: _open && connected
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox(width: double.infinity),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _rateLine(
                                Icons.south_rounded,
                                down,
                                w.accent,
                                w.muted,
                              ),
                              const SizedBox(height: 3),
                              _rateLine(
                                Icons.north_rounded,
                                up,
                                w.muted,
                                w.muted,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Sparkline(samples: _history, color: w.accent),
                          if (delay != null) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: w.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                ltr('$delay ms'),
                                style: TextStyle(
                                  color: w.text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // The rotating light on the rim while connecting.
    if (w.busy && !_still(context)) {
      return AnimatedBuilder(
        animation: _sweep,
        builder: (context, child) => CustomPaint(
          foregroundPainter: _SweepBorder(
            angle: _sweep.value * 2 * math.pi,
            color: w.accent,
          ),
          child: child,
        ),
        child: pill,
      );
    }
    return pill;
  }

  Widget _rateLine(IconData icon, String text, Color color, Color muted) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(
          color: muted,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ],
  );
}

/// A rounded-rect rim lit by a light that goes around while connecting.
class _SweepBorder extends CustomPainter {
  _SweepBorder({required this.angle, required this.color});

  final double angle;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.8),
      const Radius.circular(24),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.85),
          color.withValues(alpha: 0),
        ],
        transform: GradientRotation(-angle),
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_SweepBorder old) => old.angle != angle;
}
