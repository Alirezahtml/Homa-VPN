import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../l10n/app_localizations.dart';
import 'design.dart';
import 'motion.dart';
import 'sound.dart' show AppSounds, SoundCue;

/// The structural half of every design: the palette (which [DesignTheme]
/// carries) says what the app's colors are; the style says how every
/// page's chrome is BUILT — the navigation's shape, the pushed page's
/// header, the grouped cards' rounding and dividers, the rows' badges and
/// switches, the dialogs' round, and the state's own colors.
///
/// The shapes were drawn on the two reference designs the picker carries:
/// the aether wears AetherST's iOS structure (the grouped tables, the
/// curved notch bar with the sliding circle button, the inset dividers,
/// the system's own state colors), and the zed wears ZedSecure's
/// expressive structure (the floating dock pill, the very-round bento
/// cards, the big display headers, the violet-and-lime lights). The
/// monochrome keeps the app's own shapes.
enum NavVariant {
  /// The monochrome's floating glass pill.
  glassPill,

  /// AetherST's curved notch bar: the floating bar with a curved cutout
  /// and a round blue button that slides to the chosen tab.
  curvedNotch,

  /// ZedSecure's floating dock: a very-round pill hovering over the
  /// content, the chosen tab's icon in the brand's own circle.
  floatingDock,
}

enum HeaderVariant {
  /// The Material app bar the monochrome pushes its pages under.
  material,

  /// AetherST's iOS page: a compact bold bar and a chevron back.
  ios,

  /// ZedSecure's page header: a round back button and a big display
  /// title living in the page itself, no bar above.
  zed,
}

enum GroupVariant {
  /// The monochrome's flat bordered card.
  flat,

  /// AetherST's iOS grouped table: the raised card, the hairline inset
  /// dividers, the rows breathing 16 inside.
  iosTable,

  /// ZedSecure's bento: the very-round card with generous padding.
  bento,
}

class DesignStyle {
  const DesignStyle._({
    required this.nav,
    required this.header,
    required this.group,
    required this.cardRadius,
    required this.listRadius,
    required this.dialogRadius,
    required this.iconBadge,
    required this.connected,
    required this.scanning,
    required this.danger,
    required this.navBackground,
    required this.navActive,
    required this.navInactive,
    required this.switchTrack,
  });

  /// The style for the design the app currently wears, in [dark].
  factory DesignStyle.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return resolve(AppDesign.current.key, dark);
  }

  /// The style for [key] in [dark] — the one place the theme's builder
  /// (which has no context) and the widgets both read, so they never
  /// disagree.
  static DesignStyle resolve(String key, bool dark) => switch (key) {
    'aether' => _aether(dark),
    'zed' => _zed(dark),
    _ => _mono(dark),
  };

  final NavVariant nav;
  final HeaderVariant header;
  final GroupVariant group;

  /// The round of the cards that hold settings' groups and panels.
  final double cardRadius;

  /// The round of the small cards the lists wear (the locations' tiles).
  final double listRadius;

  /// The round of the dialogs.
  final double dialogRadius;

  /// The rows' icons sit in colored rounded badges (the iOS Settings
  /// table's own way) instead of the neutral box.
  final bool iconBadge;

  /// The state's own colors — the tunnel carried, the tunnel reaching,
  /// the way blocked.
  final Color connected;
  final Color scanning;
  final Color danger;

  final Color navBackground;
  final Color navActive;
  final Color navInactive;

  /// The switches' track when they carry.
  final Color switchTrack;

  static DesignStyle _mono(bool dark) => DesignStyle._(
    nav: NavVariant.glassPill,
    header: HeaderVariant.material,
    group: GroupVariant.flat,
    cardRadius: 24,
    listRadius: 16,
    dialogRadius: 24,
    iconBadge: false,
    connected: dark ? const Color(0xFF34C759) : const Color(0xFF1E9E6B),
    scanning: dark ? const Color(0xFFFF9500) : const Color(0xFFC77D1E),
    danger: dark ? const Color(0xFFFF3B30) : const Color(0xFFC0392B),
    navBackground: dark ? const Color(0xFF141414) : Colors.white,
    navActive: dark ? Colors.white : const Color(0xFF0A0A0A),
    navInactive: dark ? const Color(0xFF9E9E9E) : const Color(0xFF6B6B6B),
    switchTrack: dark ? Colors.white : const Color(0xFF0A0A0A),
  );

  /// AetherST's own palette (its Color.kt): the system's state colors in
  /// both modes, the nav in the raised surface with the system blue.
  static DesignStyle _aether(bool dark) => DesignStyle._(
    nav: NavVariant.curvedNotch,
    header: HeaderVariant.ios,
    group: GroupVariant.iosTable,
    cardRadius: 16,
    listRadius: 16,
    dialogRadius: 20,
    iconBadge: true,
    connected: dark ? const Color(0xFF34C759) : const Color(0xFF1E9E6B),
    scanning: dark ? const Color(0xFFFF9500) : const Color(0xFFC77D1E),
    danger: dark ? const Color(0xFFFF3B30) : const Color(0xFFC0392B),
    navBackground: dark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F3F7),
    navActive: dark ? const Color(0xFF007AFF) : const Color(0xFF0A6CFF),
    navInactive: dark ? const Color(0xFF8E8E93) : const Color(0xFF8A8A95),
    // The iOS switch: green when it carries.
    switchTrack: dark ? const Color(0xFF34C759) : const Color(0xFF1E9E6B),
  );

  /// ZedSecure's own palette (its Color.kt and Gradients.kt): the violet
  /// carrying, the cyan reaching, the rose blocking, the lime's good
  /// news — and the very-round bento shapes (its Shape.kt).
  static DesignStyle _zed(bool dark) => DesignStyle._(
    nav: NavVariant.floatingDock,
    header: HeaderVariant.zed,
    group: GroupVariant.bento,
    cardRadius: 26,
    listRadius: 26,
    dialogRadius: 28,
    iconBadge: false,
    connected: const Color(0xFF7A5CFF),
    scanning: const Color(0xFF37E0D8),
    danger: const Color(0xFFC4326B),
    navBackground: dark ? const Color(0xFF1E1535) : Colors.white,
    navActive: const Color(0xFF7A5CFF),
    navInactive: dark ? const Color(0xFFA99BC8) : const Color(0xFF6E6488),
    switchTrack: const Color(0xFF7A5CFF),
  );

  /// The row's icon badge: the iOS table's colored rounded squares (the
  /// aether), the round neutral tile (the others). The color is decided
  /// by the icon itself, so a row always wears the same badge.
  Widget badge(BuildContext context, IconData icon) {
    if (!iconBadge) {
      final scheme = Theme.of(context).colorScheme;
      return Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: scheme.onSurface),
      );
    }
    // The iOS Settings badge palette, in AetherST's own hues.
    const badgeColors = [
      Color(0xFF007AFF),
      Color(0xFF34C759),
      Color(0xFFFF9500),
      Color(0xFFAF52DE),
      Color(0xFFFF3B30),
      Color(0xFF64D2FF),
      Color(0xFFFF2D55),
      Color(0xFF5E5CE6),
    ];
    final color = badgeColors[icon.codePoint % badgeColors.length];
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }
}

/// The aether's bottom navigation — AetherST's CurvedNavBar: a floating
/// bar whose top edge dips into a curved notch, and a round blue button
/// holding the chosen tab's icon that slides between the tabs with a
/// bounce. The tab under the button keeps only its name; the others keep
/// icon and name.
class AetherCurvedNav extends StatelessWidget {
  const AetherCurvedNav({
    super.key,
    required this.index,
    required this.onSelect,
  });

  final int index;
  final ValueChanged<int> onSelect;

  // AetherST's own measures (its MainScreen.kt).
  static const double _barHeight = 90;
  static const double _buttonSize = 56;
  // The circle's real center: the button sits a breath below the bar's
  // top (top: 6 below), so its center is 6 + its radius — the notch and
  // the button read the same number, or the curve wanders off the
  // circle and the name hides under the button's glow.
  static const double _buttonCenterY = 34;
  static const double _barTop = 20;
  static const double _itemBottomPadding = 12;

  @override
  Widget build(BuildContext context) {
    final style = DesignStyle.of(context);
    final l = AppLocalizations.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final tabs = [
      (Icons.home_rounded, l.navHome),
      (Icons.settings_rounded, l.navSettings),
    ];
    return SafeArea(
      top: false,
      child: SizedBox(
        height: _barHeight,
        width: double.infinity,
        child: Stack(
          children: [
            // The bar itself, with the notch breathing under the circle.
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: index.toDouble()),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutBack,
                builder: (context, value, _) => CustomPaint(
                  painter: _CurvedNotchPainter(
                    position: rtl ? tabs.length - 1 - value : value,
                    tabs: tabs.length,
                    color: style.navBackground,
                    shadow: Colors.black.withValues(alpha: 0.14),
                  ),
                ),
              ),
            ),
            // The round blue button that slides to the chosen tab.
            TweenAnimationBuilder<double>(
              tween: Tween(end: index.toDouble()),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutBack,
              builder: (context, value, _) {
                final visual = rtl ? tabs.length - 1 - value : value;
                return AnimatedAlign(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutBack,
                  // The circle rides inside a box one slot wide (the same
                  // way the zed's dock rides its slots): alignment -1 puts
                  // a full-width child's EDGE at the screen's edge, so the
                  // bare circle would hug the left edge instead of resting
                  // in its tab's own half — the notch and the name wait at
                  // the slot's center, and the button must wait there too.
                  alignment: Alignment(
                    navSlotAlignment(visual, tabs.length),
                    -1,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 1 / tabs.length,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          width: _buttonSize,
                          height: _buttonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: style.navActive,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                            // The glow hugs the circle: a wide halo would
                            // wash the name that sits right under it and
                            // read the tab as nameless.
                            boxShadow: [
                              BoxShadow(
                                color: style.navActive.withValues(alpha: 0.32),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            tabs[index].$1,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // The tabs' own row: the chosen one's name rides under the
            // circle, the others keep icon and name.
            Row(
              children: [
                for (var i = 0; i < tabs.length; i++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (i != index) {
                          HapticFeedback.selectionClick();
                          AppSounds.play(SoundCue.tap);
                          onSelect(i);
                        }
                      },
                      child: SizedBox(
                        height: _barHeight,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: _itemBottomPadding,
                            ),
                            child: i == index
                                // The chosen name sits right under the
                                // circle, so it reads in the page's own ink
                                // — the circle already carries the accent,
                                // and an accent name on the accent's glow
                                // drowned it.
                                ? Text(
                                    tabs[i].$2,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        tabs[i].$1,
                                        size: 23,
                                        color: style.navInactive.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        tabs[i].$2,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w500,
                                          color: style.navInactive,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The bar with its curved notch, drawn as AetherST draws it: two cubic
/// shoulders easing from the bar's top edge down around the circle.
class _CurvedNotchPainter extends CustomPainter {
  const _CurvedNotchPainter({
    required this.position,
    required this.tabs,
    required this.color,
    required this.shadow,
  });

  final double position;
  final int tabs;
  final Color color;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final slot = size.width / tabs;
    final centerX = position * slot + slot / 2;
    final barTop = AetherCurvedNav._barTop;
    final buttonRadius = AetherCurvedNav._buttonSize / 2;
    final notchBottom = AetherCurvedNav._buttonCenterY + buttonRadius + 6;
    const shoulder = 45.0;

    final path = Path()
      ..moveTo(0, barTop)
      ..lineTo(centerX - shoulder, barTop)
      ..cubicTo(
        centerX - 40,
        barTop,
        centerX - 38,
        barTop + 2,
        centerX - 35,
        barTop + 10,
      )
      ..cubicTo(
        centerX - 28,
        barTop + 26,
        centerX - 20,
        notchBottom,
        centerX,
        notchBottom,
      )
      ..cubicTo(
        centerX + 20,
        notchBottom,
        centerX + 28,
        barTop + 26,
        centerX + 35,
        barTop + 10,
      )
      ..cubicTo(
        centerX + 38,
        barTop + 2,
        centerX + 40,
        barTop,
        centerX + shoulder,
        barTop,
      )
      ..lineTo(size.width, barTop)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // The bar's shadow, then the bar itself.
    canvas.drawShadow(path, shadow, 14, true);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CurvedNotchPainter old) =>
      old.position != position ||
      old.tabs != tabs ||
      old.color != color ||
      old.shadow != shadow;
}

/// The zed's bottom navigation — ZedSecure's floating dock (its
/// ExpressivePill bar): a very-round pill hovering over the content, each
/// tab an icon and its name, the chosen one's icon riding in the brand's
/// violet circle with the lime's own underline beneath.
class ZedDockNav extends StatelessWidget {
  const ZedDockNav({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final style = DesignStyle.of(context);
    final l = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final tabs = [
      (Icons.home_rounded, Icons.home_outlined, l.navHome),
      (Icons.settings_rounded, Icons.settings_outlined, l.navSettings),
    ];
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        child: Align(
          heightFactor: 1,
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                color: style.navBackground.withValues(alpha: dark ? 0.96 : 1),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.4 : 0.14),
                    blurRadius: 26,
                    offset: const Offset(0, 10),
                  ),
                  // The violet's own light under the dock.
                  BoxShadow(
                    color: style.navActive.withValues(alpha: 0.22),
                    blurRadius: 30,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: Stack(
                  children: [
                    // The violet circle slides to the chosen tab.
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: index.toDouble()),
                      duration: const Duration(milliseconds: 380),
                      curve: Curves.easeOutBack,
                      builder: (context, value, _) {
                        final visual = rtl ? tabs.length - 1 - value : value;
                        return Align(
                          // Top-aligned, one breath down: the circle must
                          // sit exactly where the chosen tab's icon band
                          // sits — centered on the dock's middle it sank
                          // over the name below and covered it.
                          alignment: Alignment(
                            navSlotAlignment(visual, tabs.length),
                            -1,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: FractionallySizedBox(
                              widthFactor: 1 / tabs.length,
                              child: Center(
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: style.navActive,
                                    // The glow keeps to the circle: a wide
                                    // one washed the name beneath it into
                                    // the violet and read the tab as bare.
                                    boxShadow: [
                                      BoxShadow(
                                        color: style.navActive.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    tabs[index].$1,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < tabs.length; i++)
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (i != index) {
                                  HapticFeedback.selectionClick();
                                  AppSounds.play(SoundCue.tap);
                                  onSelect(i);
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // The chosen tab's icon lives in the
                                  // circle; the others keep theirs bare.
                                  if (i == index)
                                    const SizedBox(height: 44)
                                  else
                                    SizedBox(
                                      height: 44,
                                      child: Icon(
                                        tabs[i].$2,
                                        size: 22,
                                        color: style.navInactive,
                                      ),
                                    ),
                                  const SizedBox(height: 1),
                                  // The name's seat is pinned: the circle
                                  // above and the underline below both read
                                  // their place from the same geometry, so
                                  // the seat must hold its height whatever
                                  // the language's face measures.
                                  SizedBox(
                                    height: 15,
                                    child: Center(
                                      child: Text(
                                        tabs[i].$3,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: i == index
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                          // The chosen name sits under the
                                          // circle, so it reads in the page's
                                          // own ink, not in the violet it
                                          // would drown in; the lime's own
                                          // underline still marks the tab.
                                          color: i == index
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onSurface
                                              : style.navInactive,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  // The lime's own underline rides under
                                  // the chosen tab (ZedSecure's pill bar).
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    height: 3,
                                    width: i == index ? 26 : 0,
                                    decoration: BoxDecoration(
                                      color: i == index
                                          ? zedLime
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The lime light ZedSecure carries for the good news (its Color.kt).
const Color zedLime = Color(0xFFC7F24E);

/// The zed's floating tool cluster — ZedSecure's HomeFabCluster: two
/// round violet FABs (the map of the servers, the speed test) that ride
/// the screen's edge, dragged by hand, snapping back to the nearer edge
/// with the bouncy spring when the finger lets go.
class ZedFabCluster extends StatefulWidget {
  const ZedFabCluster({
    super.key,
    required this.onOpenServers,
    required this.onOpenSpeedTest,
  });

  final VoidCallback onOpenServers;
  final VoidCallback onOpenSpeedTest;

  @override
  State<ZedFabCluster> createState() => _ZedFabClusterState();
}

class _ZedFabClusterState extends State<ZedFabCluster> {
  // ZedSecure's own measures (its HomeFabCluster.kt). The bottom limit
  // clears the dock and its seat, so a cluster left near the screen's
  // foot never lands on the tabs and their names.
  static const double _fabSize = 54;
  static const double _edge = 14;
  static const double _gap = 10;
  static const double _topLimit = 120;
  static const double _bottomLimit = 120;

  bool _atEnd = false;
  double _yFraction = 0.3;
  bool _dragging = false;
  Offset _raw = Offset.zero;

  void _move(bool atEnd, double yFraction) {
    setState(() {
      _atEnd = atEnd;
      _yFraction = yFraction.clamp(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final cluster = _fabSize * 2 + _gap;
    final maxY = math.max(_topLimit, media.height - _bottomLimit - cluster);
    final restX = _atEnd ? media.width - _fabSize - _edge : _edge;
    final restY = _topLimit + _yFraction * math.max(0, maxY - _topLimit);
    // The cluster rides the edge it was left on; while the finger holds
    // it, it follows the finger exactly (no animation), and the moment
    // the finger lets go it springs to the nearer edge with the bounce.
    return Stack(
      children: [
        AnimatedPositioned(
          duration: _dragging
              ? Duration.zero
              : const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          left: _dragging ? _raw.dx : restX,
          top: _dragging ? _raw.dy : restY,
          child: GestureDetector(
            onPanStart: (_) {
              setState(() {
                _dragging = true;
                _raw = Offset(restX, restY);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _raw = Offset(
                  (_raw.dx + details.delta.dx).clamp(
                    0,
                    math.max(0, media.width - _fabSize),
                  ),
                  (_raw.dy + details.delta.dy).clamp(_topLimit, maxY),
                );
              });
            },
            onPanEnd: (_) {
              final center = _raw.dx + _fabSize / 2;
              final fraction = maxY > _topLimit
                  ? ((_raw.dy - _topLimit) / (maxY - _topLimit))
                        .clamp(0, 1)
                        .toDouble()
                  : 0.0;
              setState(() => _dragging = false);
              _move(center > media.width / 2, fraction);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Each fab rises in, one breath after the other — the
                // cluster's own entrance, once, at the page's landing.
                DockRise(
                  index: 0,
                  child: _fab(
                    context,
                    icon: Icons.public_rounded,
                    onTap: widget.onOpenServers,
                  ),
                ),
                const SizedBox(height: _gap),
                DockRise(
                  index: 1,
                  child: _fab(
                    context,
                    icon: Icons.speed_rounded,
                    onTap: widget.onOpenSpeedTest,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fab(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final style = DesignStyle.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: _fabSize,
          height: _fabSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: style.navActive.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                color: style.navActive.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, size: 26, color: Colors.white),
        ),
      ),
    );
  }
}

/// The pushed page's header for the zed: ZedSecure's PageHeader — a round
/// back button and a big display title in the page itself, no bar above.
class ZedPageHeader extends StatelessWidget {
  const ZedPageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The header leads the pushed page under the clock, so it carries
    // the status bar's own inset: without it the back button and the
    // big title start inside the clock's own band.
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(14, top + 6, 22, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed:
                onBack ??
                () => Navigator.of(context, rootNavigator: true).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: theme.colorScheme.onSurfaceVariant,
          ),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// A tiny helper the two navs share: one tab's slot center as a signed
/// alignment, mirrored by the caller for right-to-left.
double navSlotAlignment(double position, int tabs) =>
    tabs < 2 ? 0 : -1 + 2 * (position / (tabs - 1));
