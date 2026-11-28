import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' as physics;
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../l10n/app_localizations.dart';

/// URnetwork's own widgets, ported as they ship.
///
/// The values are the original's: the switch is a 36×20 track with a 2 dp
/// stroke and a 6 dp thumb, the bars are floating surfaces with the
/// highlight gliding on a spring, the labels walk in with the app-wide
/// entrance, and every press answers with the soft bounce.

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

  /// The bottom bars' surface: the elevated black.
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
  bool _down = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _set(bool down) {
    if (!mounted) return;
    setState(() => _down = down);
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
      Duration(milliseconds: (widget.index * 45).clamp(0, 360)),
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
        opacity: _a.value.clamp(0, 1),
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
    if (fill.alpha > 0) canvas.drawRRect(r, Paint()..color = fill);
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
// The navigation bars.
// ---------------------------------------------------------------------------

/// The bottom bar's four looks, the original's own picker: the morphing
/// pill (the default), the neon glow, the bubbles, and the capsule.
enum UrNavStyle { morphing, neon, bubble, capsule }

/// The style a stored key asks for; anything else reads as the morphing.
UrNavStyle urNavStyleFor(String? key) => switch (key) {
      'neon' => UrNavStyle.neon,
      'bubble' => UrNavStyle.bubble,
      'capsule' => UrNavStyle.capsule,
      _ => UrNavStyle.morphing,
    };

/// One bar tab: the icon and its label.
class UrNavItem {
  const UrNavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// The shared surface every bar floats on: the elevated black, the
/// hairline border, the tall shadow.
Widget _barSurface({required Widget child, double radius = 28}) => DecoratedBox(
      decoration: BoxDecoration(
        color: UrTokens.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: UrTokens.border),
        boxShadow: const [
          BoxShadow(color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );

/// A value that glides between targets on the original's spring: the
/// sliding highlight's damping 0.75 at the medium-low stiffness.
class _SpringBox extends StatefulWidget {
  const _SpringBox({
    required this.index,
    required this.builder,
  });

  final int index;
  final Widget Function(BuildContext context, double position) builder;

  @override
  State<_SpringBox> createState() => _SpringBoxState();
}

class _SpringBoxState extends State<_SpringBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    upperBound: 1e6,
  )..value = widget.index.toDouble();
  late physics.SpringSimulation _sim = _make(widget.index, widget.index);

  physics.SpringSimulation _make(double from, double to) =>
      physics.SpringSimulation(
        const physics.SpringDescription(
          mass: 1,
          stiffness: 400,
          damping: 30,
        ),
        from,
        to,
        0,
      );

  @override
  void didUpdateWidget(_SpringBox old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _sim = _make(_c.value, widget.index.toDouble());
      _c.animateWith(_sim);
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
      builder: (context, _) => widget.builder(context, _c.value),
    );
  }
}

/// The icon's pop: the chosen icon springs up a touch and settles.
class _Pop extends StatefulWidget {
  const _Pop({required this.selected, required this.child, this.amount = 0.14});

  final bool selected;
  final Widget child;
  final double amount;

  @override
  State<_Pop> createState() => _PopState();
}

class _PopState extends State<_Pop> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this)
    ..value = widget.selected ? 1 : 0;
  late physics.SpringSimulation _sim = _make(widget.selected);

  physics.SpringSimulation _make(bool up) => physics.SpringSimulation(
        const physics.SpringDescription(mass: 1, stiffness: 1500, damping: 38),
        _c.value,
        up ? 1 : 0,
        0,
      );

  @override
  void didUpdateWidget(_Pop old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected) {
      _sim = _make(widget.selected);
      _c.animateWith(_sim);
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
      builder: (context, child) => Transform.scale(
        scale: 1 + widget.amount * _c.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// The Morphing navigation bar: a floating rounded pill over the content.
/// The highlight behind the tabs slides from the old tab to the new one
/// with a springy glide, the chosen icon pops up a touch and settles, and
/// each tap lands with a soft haptic tick.
class UrMorphingNavBar extends StatelessWidget {
  const UrMorphingNavBar({
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
    final count = items.length;
    return _barSurface(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // the sliding highlight: one slot wide, gliding between tabs
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, cons) => _SpringBox(
                    index: index,
                    builder: (context, position) => Align(
                      alignment: Alignment(-1 + 2 * position / (count - 1 < 1 ? 1 : count - 1), 0),
                      child: FractionallySizedBox(
                        widthFactor: 1 / count,
                        heightFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: UrTokens.bgTinted,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < count; i++)
                    Expanded(child: _barItem(context, i)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barItem(BuildContext context, int i) {
    final selected = i == index;
    return UrPressable(
      scaleDown: 0.94,
      haptic: true,
      onTap: () => onSelect(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Pop(
              selected: selected,
              child: Icon(
                items[i].icon,
                size: 24,
                color: selected ? UrTokens.pink : UrTokens.muted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              items[i].label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.2,
                color: selected
                    ? UrTokens.pink
                    : UrTokens.muted.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Neon navigation bar: a floating full-width bar of icons only. The
/// selected tab carries a soft neon aura that breathes quietly behind the
/// icon, and the aura glides between tabs with the same springy glide.
class UrNeonGlowNavBar extends StatelessWidget {
  const UrNeonGlowNavBar({
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
    final count = items.length;
    return _barSurface(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, cons) => _SpringBox(
                    index: index,
                    builder: (context, position) => Align(
                      alignment: Alignment(-1 + 2 * position / (count - 1 < 1 ? 1 : count - 1), 0),
                      child: FractionallySizedBox(
                        widthFactor: 1 / count,
                        heightFactor: 1,
                        child: const _NeonAura(),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < count; i++)
                    Expanded(child: _barItem(context, i)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barItem(BuildContext context, int i) {
    final selected = i == index;
    return UrPressable(
      scaleDown: 0.94,
      haptic: true,
      onTap: () => onSelect(i),
      child: SizedBox(
        height: 52,
        child: Center(
          child: _Pop(
            selected: selected,
            amount: 0.16,
            child: Icon(
              items[i].icon,
              size: 24,
              color: selected ? UrTokens.pink : UrTokens.muted,
            ),
          ),
        ),
      ),
    );
  }
}

/// The glow orb: a radial halo of the pink that breathes on a slow cycle.
class _NeonAura extends StatefulWidget {
  const _NeonAura();

  @override
  State<_NeonAura> createState() => _NeonAuraState();
}

class _NeonAuraState extends State<_NeonAura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
    lowerBound: 0.55,
    upperBound: 1,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _NeonAuraPainter(alpha: _c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _NeonAuraPainter extends CustomPainter {
  const _NeonAuraPainter({required this.alpha});
  final double alpha;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final halo = size.shortestSide * 0.92;
    final colors = [
      UrTokens.pink.withValues(alpha: 0.38 * alpha),
      UrTokens.pink.withValues(alpha: 0.12 * alpha),
      Colors.transparent,
    ];
    canvas.drawCircle(
      center,
      halo,
      Paint()
        ..shader = RadialGradient(colors: colors).createShader(
          Rect.fromCircle(center: center, radius: halo),
        ),
    );
  }

  @override
  bool shouldRepaint(_NeonAuraPainter old) => old.alpha != alpha;
}

/// The Bubble navigation bar: a floating bar of round bubbles. The selected
/// bubble inflates with a springy overshoot into a wide pill that carries
/// the tab's name inside it and lifts a touch above its siblings.
class UrBubbleNavBar extends StatelessWidget {
  const UrBubbleNavBar({
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
    return _barSurface(
      radius: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(child: _bubble(context, i)),
          ],
        ),
      ),
    );
  }

  Widget _bubble(BuildContext context, int i) {
    final selected = i == index;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: selected ? 1.0 : 0.0),
        duration: Duration(milliseconds: selected ? 320 : 260),
        curve: selected ? Curves.easeOutBack : Curves.easeOutCubic,
        builder: (context, inflate, child) {
          final label = items[i].label;
          return Transform.translate(
            offset: Offset(0, -6 * inflate),
            child: UrPressable(
              scaleDown: 0.92,
              haptic: true,
              onTap: () => onSelect(i),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? UrTokens.bgTinted
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.92 + 0.16 * inflate,
                        child: Icon(
                          items[i].icon,
                          size: 24,
                          color:
                              selected ? UrTokens.pink : UrTokens.muted,
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: UrTokens.pink,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The Capsule navigation bar: a floating stadium of icons only. The
/// selected icon's circular fill springs in with a small overshoot, the
/// icon pops and settles, and the name pill under the capsule swaps with a
/// soft slide when the tab changes.
class UrCapsuleNavBar extends StatelessWidget {
  const UrCapsuleNavBar({
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _barSurface(
          radius: 50,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < items.length; i++)
                  _capsule(context, i),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: Container(
            key: ValueKey(index),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: UrTokens.bgTinted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              items[index].label,
              style: const TextStyle(fontSize: 11, color: UrTokens.pink),
            ),
          ),
        ),
      ],
    );
  }

  Widget _capsule(BuildContext context, int i) {
    final selected = i == index;
    return UrPressable(
      scaleDown: 0.92,
      haptic: true,
      onTap: () => onSelect(i),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(end: selected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, fill, _) => Opacity(
                opacity: fill,
                child: Transform.scale(
                  scale: fill.clamp(0.01, 1),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: UrTokens.bgTinted,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            _Pop(
              selected: selected,
              amount: 0.18,
              child: Icon(
                items[i].icon,
                size: 24,
                color: selected ? UrTokens.pink : UrTokens.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The bar the shell floats at its foot: the style the settings carry.
class UrNavBar extends StatelessWidget {
  const UrNavBar({
    super.key,
    required this.index,
    required this.onSelect,
    required this.style,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final UrNavStyle style;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = [
      UrNavItem(Icons.home_rounded, l.navOverview),
      UrNavItem(Icons.settings_rounded, l.navSettings),
    ];
    final common = (Widget child) => SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: child,
        );
    return switch (style) {
      UrNavStyle.morphing =>
        common(UrMorphingNavBar(items: items, index: index, onSelect: onSelect)),
      UrNavStyle.neon =>
        common(UrNeonGlowNavBar(items: items, index: index, onSelect: onSelect)),
      UrNavStyle.bubble =>
        common(UrBubbleNavBar(items: items, index: index, onSelect: onSelect)),
      UrNavStyle.capsule =>
        common(UrCapsuleNavBar(items: items, index: index, onSelect: onSelect)),
    };
  }
}

/// The navigation style picker: the four looks the bar wears, each with a
/// line about what it does. A tap applies the style at once, the way the
/// original's sheet does.
Future<void> showUrNavStylePicker(BuildContext context, AppSettings s) async {
  final l = AppLocalizations.of(context);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: const Color(0xFF141414),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: ListenableBuilder(
        listenable: s,
        builder: (context, _) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.urNavStyle, style: urTitleStyle(context).copyWith(fontSize: 18)),
              const SizedBox(height: 4),
              Text(
                l.urNavStyleNote,
                style: const TextStyle(fontSize: 12.5, color: UrTokens.muted),
              ),
              const SizedBox(height: 12),
              for (final style in UrNavStyle.values)
                UrPressable(
                  onTap: () {
                    s.update(urNavStyle: style.name);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: urNavStyleFor(s.urNavStyle) == style
                          ? UrTokens.bgTinted
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: urNavStyleFor(s.urNavStyle) == style
                            ? UrTokens.pink.withValues(alpha: 0.35)
                            : UrTokens.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          switch (style) {
                            UrNavStyle.morphing => Icons.view_carousel_rounded,
                            UrNavStyle.neon => Icons.blur_circular_rounded,
                            UrNavStyle.bubble => Icons.bubble_chart_rounded,
                            UrNavStyle.capsule => Icons.radio_button_checked_rounded,
                          },
                          size: 20,
                          color: urNavStyleFor(s.urNavStyle) == style
                              ? UrTokens.pink
                              : UrTokens.muted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            switch (style) {
                              UrNavStyle.morphing => l.urNavMorphing,
                              UrNavStyle.neon => l.urNavNeon,
                              UrNavStyle.bubble => l.urNavBubble,
                              UrNavStyle.capsule => l.urNavCapsule,
                            },
                            style: const TextStyle(
                                fontSize: 14.5, color: UrTokens.ink),
                          ),
                        ),
                        if (urNavStyleFor(s.urNavStyle) == style)
                          const Icon(Icons.check_rounded,
                              size: 18, color: UrTokens.pink),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
