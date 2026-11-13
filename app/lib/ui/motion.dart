/// The Homa motion system: the moving parts of the design.
///
/// Everything here is smooth by design and polite to the battery:
/// - the endless animations (the shimmers, the pulses) pause when the app
///   leaves the screen and honor the system's reduce-motion setting
///   (`MediaQuery.disableAnimations`);
/// - the entrance animations run once and never re-run on a refresh, so a
///   status update repaints text, not the whole page.
///
/// Motion inventory:
///  1. Reveal fade                  2. Reveal slide-up
///  3. Reveal scale                 4. Reveal index stagger
///  5. Pressable press scale        6. Pressable release spring
///  7. CountUp value tween          8. CountUp curve
///  9. Shimmer highlight sweep     10. Shimmer fade at the ends
/// 11. PulsingDot scale            12. PulsingDot opacity
/// 13. Connect-orb rings breathe   14. State-label crossfade
/// 15. Quota ring count-up        16. Panel entrance
/// 17. PageTitle entrance         18. SettingsGroup tile stagger
/// 19. Servers page card stagger  20. Welcome page stagger
/// 21. Tab switch cross-fade      22. Mode pill slide
/// 23. Page transitions           24. Notice banner progress
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

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
      duration: Duration(milliseconds: 240 + math.min(index, 8) * 30),
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

