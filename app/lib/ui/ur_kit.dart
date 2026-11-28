import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// URnetwork's own widgets, ported as they ship.
///
/// The values are the original's: the switch is a 36×20 track with a 2 dp
/// stroke and a 6 dp thumb, the labels walk in with the app-wide entrance,
/// and every press answers with the soft bounce. The navigation is the
/// classic bar alone: the other looks the original's repository carries —
/// the morphing pill, the neon glow, the bubbles, the capsule — left with
/// their picker.

/// URnetwork's palette, the tokens the ported pieces draw with.
abstract final class UrTokens {
  /// The screens' background (Black).
  static const bg = Color(0xFF101010);

  /// Tinted containers and cards (OffBlack).
  static const bgTinted = Color(0xFF1C1C1C);

  /// Primary text (OffWhite) and the secondary and tertiary inks.
  static const ink = Color(0xFFF8F8F8);
  static const muted = Color(0xFF989898);
  static const faint = Color(0xFF5A5A5A);

  /// Hairlines and card outlines (white at twelve percent).
  static const border = Color(0x1FFFFFFF);

  /// The selected tab's pink (Pink300) and the button's blue (Blue400).
  static const pink = Color(0xFFED8FFF);
  static const blue = Color(0xFF638BFC);

  /// The bottom bar's surface: the elevated black.
  static const surface = Color(0xFF1C1C1C);
}

/// The headline the ported screens carry, the original's top bar title:
/// twenty-four, bold, centered. Latin reads in Space Grotesk, Persian and
/// Arabic fall through to Vazirmatn.
TextStyle urTitleStyle(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  final latin = code != 'fa' && code != 'ar';
  return TextStyle(
    fontSize: 24,
    height: 1.0,
    fontWeight: FontWeight.w700,
    fontFamily: latin ? 'SpaceGrotesk' : 'Vazirmatn',
    color: UrTokens.ink,
  );
}

/// The press feedback: while the pointer is down the child eases to a
/// touch of its size and springs back on release, the app-wide soft bounce.
class UrPressable extends StatefulWidget {
  const UrPressable({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.96,
    this.haptic = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final bool haptic;

  @override
  State<UrPressable> createState() => _UrPressableState();
}

class _UrPressableState extends State<UrPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    value: 1,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _set(bool down) {
    if (!mounted) return;
    _c.animateTo(down ? widget.scaleDown : 1,
        curve: down ? Curves.easeOutCubic : Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (_) => _set(false),
      onTap: widget.onTap == null
          ? null
          : () {
              if (widget.haptic) HapticFeedback.selectionClick();
              widget.onTap!();
            },
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) =>
            Transform.scale(scale: _c.value, child: child),
        child: widget.child,
      ),
    );
  }
}

/// The entrance every section and card walks in with: it starts a touch
/// below its place and settles up into it, later siblings a beat later,
/// the stagger capped so long lists never queue behind their delays.
class UrEntrance extends StatefulWidget {
  const UrEntrance({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<UrEntrance> createState() => _UrEntranceState();
}

class _UrEntranceState extends State<UrEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 340),
  );
  late final Animation<double> _a = CurvedAnimation(
    parent: _c,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: (widget.index * 45).clamp(0, 360).toInt()),
      () {
        if (mounted) _c.forward();
      },
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (context, child) => Opacity(
        opacity: _a.value.clamp(0.0, 1.0).toDouble(),
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - _a.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// The app's switch, the original's own: a 36×20 track drawn with a 2 dp
/// stroke, the thumb a 6 dp circle that rides the track's width, the
/// checked state a filled Blue400 track with a background-colored thumb.
class UrSwitch extends StatelessWidget {
  const UrSwitch({super.key, required this.checked, required this.onToggle});

  final bool checked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    const width = 36.0;
    const height = 20.0;
    const gap = 4.0;
    const stroke = 2.0;
    final thumbRadius = height / 2 - gap;
    final track = UrTokens.blue;
    final thumb = checked ? UrTokens.bg : UrTokens.blue;
    final target = checked
        ? width - thumbRadius - gap
        : thumbRadius + gap;

    return Semantics(
      toggled: checked,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onToggle,
        child: Container(
          // the 48 dp square the original reserves for the touch target
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: target),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            builder: (context, x, _) => CustomPaint(
              size: const Size(width, height),
              painter: _UrSwitchPainter(
                x: x,
                thumbRadius: thumbRadius,
                stroke: stroke,
                track: track,
                fill: checked ? track : Colors.transparent,
                thumb: thumb,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UrSwitchPainter extends CustomPainter {
  const _UrSwitchPainter({
    required this.x,
    required this.thumbRadius,
    required this.stroke,
    required this.track,
    required this.fill,
    required this.thumb,
  });

  final double x;
  final double thumbRadius;
  final double stroke;
  final Color track;
  final Color fill;
  final Color thumb;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(10),
    );
    if (fill.a > 0) canvas.drawRRect(r, Paint()..color = fill);
    canvas.drawRRect(
      r,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    canvas.drawCircle(Offset(x, size.height / 2), thumbRadius,
        Paint()..color = thumb);
  }

  @override
  bool shouldRepaint(_UrSwitchPainter old) =>
      old.x != x || old.fill != fill || old.thumb != thumb;
}

// ---------------------------------------------------------------------------
// The navigation.
// ---------------------------------------------------------------------------

/// One bar tab: the icon and its label.
class UrNavItem {
  const UrNavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// The classic bottom bar: a full-width bar at the screen's foot, each tab
/// an icon over its name, the chosen one in the pink. Plain and quiet —
/// the bar never floats, never glows, never morphs; the page's content
/// reads over it nowhere.
class UrNavBar extends StatelessWidget {
  const UrNavBar({
    super.key,
    required this.items,
    required this.index,
    required this.onSelect,
  });

  final List<UrNavItem> items;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: UrTokens.surface,
        border: Border(top: BorderSide(color: UrTokens.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(child: _tab(context, i)),
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int i) {
    final selected = i == index;
    return UrPressable(
      scaleDown: 0.94,
      haptic: true,
      onTap: () => onSelect(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              items[i].icon,
              size: 24,
              color: selected ? UrTokens.pink : UrTokens.muted,
            ),
            const SizedBox(height: 3),
            Text(
              items[i].label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                letterSpacing: 0.2,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? UrTokens.pink : UrTokens.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
