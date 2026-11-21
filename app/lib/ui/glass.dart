/// The liquid glass: the cards' own material — a fill the page breathes
/// through, an edge that catches the light, a sheen that sweeps once, and
/// a quiet light that walks an accent card's rim.
///
/// Three pieces:
/// - [LiquidGlass]: the card's box — the fill and the edge drawn from the
///   design's own look (each of the designs wears its own wash)
///   own glass), and, for the floating pieces that ride over moving
///   content, a real blur of what stands behind;
/// - [GlassSheen]: the one light sweep a glass card makes as it lands;
///   it runs once and never again;
/// - [GlassFlow]: the rim's light that circles an accent card (the
///   connecting card's own edge) — it stands still for the battery saver
///   and the reduce-motion setting, like every loop here.
///
/// The glass is drawn without a backdrop blur where cards sit in the
/// page's own flow: over the page's flat ground the blur paints the same
/// light at a real GPU cost, so the in-flow cards wear the fill and the
/// edge only, and the blur stays for the pieces that truly float.
library;

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'design.dart';
import 'design_style.dart';
import 'motion.dart' show motionStill;

/// The glass's colors on this page, read from the design's own look: the
/// mono's glass is quiet; a design with a palette tints its own
/// violet night's — one recipe, each design's own light.
class Glass {
  const Glass({
    required this.fillTop,
    required this.fillBottom,
    required this.edgeTop,
    required this.edgeBottom,
    required this.surface,
  });

  /// The fill's gradient, from the light's corner to the shade's.
  final Color fillTop;
  final Color fillBottom;

  /// The rim's light and its shade: the edge's two colors.
  final Color edgeTop;
  final Color edgeBottom;

  /// The card's own color under the fill (the design's surface, thinned
  /// so the ground can breathe through).
  final Color surface;

  factory Glass.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    if (dark) {
      return Glass(
        fillTop: Colors.white.withValues(alpha: 0.085),
        fillBottom: Colors.white.withValues(alpha: 0.025),
        edgeTop: Colors.white.withValues(alpha: 0.16),
        edgeBottom: Colors.white.withValues(alpha: 0.05),
        surface: look.surface.withValues(alpha: 0.60),
      );
    }
    return Glass(
      fillTop: Colors.white.withValues(alpha: 0.55),
      fillBottom: Colors.white.withValues(alpha: 0.30),
      edgeTop: Colors.white.withValues(alpha: 0.90),
      edgeBottom: look.outline.withValues(alpha: 0.55),
      surface: look.surface.withValues(alpha: 0.66),
    );
  }

  /// The glass on the look a home palette already holds: the home cards
  /// carry their palette's own card color, not the theme's surface.
  factory Glass.ofLook(DesignLook look, bool dark, Color card) {
    if (dark) {
      return Glass(
        fillTop: Colors.white.withValues(alpha: 0.085),
        fillBottom: Colors.white.withValues(alpha: 0.025),
        edgeTop: Colors.white.withValues(alpha: 0.16),
        edgeBottom: Colors.white.withValues(alpha: 0.05),
        surface: card.withValues(alpha: 0.62),
      );
    }
    return Glass(
      fillTop: Colors.white.withValues(alpha: 0.55),
      fillBottom: Colors.white.withValues(alpha: 0.30),
      edgeTop: Colors.white.withValues(alpha: 0.90),
      edgeBottom: look.outline.withValues(alpha: 0.55),
      surface: card.withValues(alpha: 0.70),
    );
  }
}

/// A card of glass: the fill, the rim's hair of light, and — when [blur]
/// asks — the real blur of what stands behind it. The [accent] tints the
/// fill's light from one corner, the way a state's light washes a card.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.radius,
    this.blur = false,
    this.accent,
    this.padding,
  });

  final Widget child;

  /// The corner's radius; null takes the design's own card radius.
  final double? radius;

  /// True blurs what stands behind (the dialog sheets, the floating
  /// docks). False — the in-flow cards — paints the fill alone.
  final bool blur;

  /// A light the card carries from its corner: the state's own color.
  final Color? accent;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final glass = Glass.of(context);
    final r = radius ?? DesignStyle.of(context).cardRadius;
    final accent = this.accent;
    final content = Padding(
      padding: padding ?? EdgeInsets.zero,
      // The glass's own Material: the rows and tiles inside a glass card
      // paint their backgrounds and splashes on the nearest Material, and
      // the glass's decorated box would stand between them and the page's
      // one — so the card carries its own for them.
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
    Widget box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        color: glass.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: accent == null
              ? [glass.fillTop, glass.fillBottom]
              : [
                  Color.alphaBlend(
                    accent.withValues(alpha: 0.10),
                    glass.fillTop,
                  ),
                  glass.fillBottom,
                ],
        ),
      ),
      child: content,
    );
    if (blur) {
      box = ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: box,
        ),
      );
    }
    // The rim: one hair of light around the card, the light's color at
    // the top falling toward the shade at the bottom. Painted over the
    // card, so the fill's own radius keeps the ring honest.
    return _RimBorder(
      radius: r,
      top: glass.edgeTop,
      bottom: glass.edgeBottom,
      child: box,
    );
  }
}

/// The rim's hair of light: a rounded stroke whose color falls from the
/// light's color to the shade, painted once and never again.
class _RimBorder extends StatelessWidget {
  const _RimBorder({
    required this.child,
    required this.radius,
    required this.top,
    required this.bottom,
  });

  final Widget child;
  final double radius;
  final Color top;
  final Color bottom;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _RimPainter(
        radius: radius,
        colors: [top, bottom],
      ),
      child: child,
    );
  }
}

class _RimPainter extends CustomPainter {
  _RimPainter({required this.radius, required this.colors, this.rotation});

  final double radius;
  final List<Color> colors;

  /// The gradient's turn, when the rim's light walks (GlassFlow); null
  /// keeps the light where it fell first.
  final double? rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
            transform: rotation == null
                ? null
                : GradientRotation(rotation!),
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.55),
      Radius.circular(math.max(0, radius - 0.55)),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_RimPainter old) =>
      old.rotation != rotation ||
      old.radius != radius ||
      !old.colors.every(colors.contains) ||
      old.colors.length != colors.length;
}

/// The one light sweep a glass card makes as it lands: a narrow band of
/// light crosses the card once and never comes back. Under reduce-motion
/// the band does not travel — the card lands dry.
class GlassSheen extends StatelessWidget {
  const GlassSheen({super.key, required this.child, this.delay = 120});

  final Widget child;

  /// The wait before the sweep, so a page's cards shine one after
  /// another instead of all at once.
  final int delay;

  @override
  Widget build(BuildContext context) {
    if (motionStill(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 980 + delay),
      curve: Curves.linear,
      builder: (context, t, child) {
        // The sweep lives in the last 980ms of the window: the delay
        // holds the band still before it starts.
        final s = ((t * (980 + delay) - delay) / 980).clamp(0.0, 1.0);
        if (s <= 0.001 || s >= 0.999) return child!;
        final width = MediaQuery.sizeOf(context).width;
        return ClipRRect(
          child: Stack(
            children: [
              child!,
              Positioned.fill(
                child: IgnorePointer(
                  child: Transform.translate(
                    offset: Offset(width * (2 * s - 1), 0),
                    child: Transform.rotate(
                      angle: 0.32,
                      child: Container(
                        width: width * 0.6,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(
                                alpha: 0.15 * math.sin(s * math.pi),
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}

/// The rim's quiet light that walks an accent card's edge: a soft point
/// of the card's own color circling the rim while the card asks for it
/// (the connecting card's wait). With the battery saver or reduce-motion
/// it keeps one pose — the light rests where it fell first.
class GlassFlow extends StatefulWidget {
  const GlassFlow({
    super.key,
    required this.child,
    required this.color,
    this.radius,
    this.paused = false,
  });

  final Widget child;

  /// The walking light's color: the state's own.
  final Color color;

  final double? radius;

  /// The battery saver's word: true holds the light still.
  final bool paused;

  @override
  State<GlassFlow> createState() => _GlassFlowState();
}

class _GlassFlowState extends State<GlassFlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5200),
  );

  @override
  void initState() {
    super.initState();
    if (!widget.paused) _c.repeat();
  }

  @override
  void didUpdateWidget(GlassFlow old) {
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
    final r = widget.radius ?? DesignStyle.of(context).cardRadius;
    final still = motionStill(context) || widget.paused;
    if (still) {
      return _rim(-0.6, 0.24, r);
    }
    return AnimatedBuilder(
      animation: _c,
      builder:
          (context, child) => _rim(
            _c.value * math.pi * 2,
            // The light's strength breathes with its walk, so the rim
            // never reads as a hard ring.
            0.20 + 0.14 * math.sin(_c.value * math.pi * 2),
            r,
          ),
      child: widget.child,
    );
  }

  Widget _rim(double rotation, double alpha, double r) => CustomPaint(
    foregroundPainter: _RimPainter(
      radius: r,
      colors: [
        widget.color.withValues(alpha: alpha),
        widget.color.withValues(alpha: alpha * 0.12),
      ],
      rotation: rotation,
    ),
    child: widget.child,
  );
}
