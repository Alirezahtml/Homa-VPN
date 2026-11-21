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
/// The shapes were drawn on the designs the picker carries: the ios
/// wears the system's own structure (the grouped tables, the tab bar
/// glued to the edge, the inset dividers, the system's state colors),
/// the bento its lunch box, the gazette its press, the pixel Material
/// You, the gta the game's HUD. The monochrome keeps the app's own
/// shapes.
enum NavVariant {
  /// The monochrome's floating glass pill.
  glassPill,

  /// The bento's tile dock: floating rounded-square tiles, each tab its
  /// own cell — the chosen cell fills with the tangerine and lifts.
  bentoDock,

  /// The gazette's section bar: a paper strip ruled like the masthead,
  /// the tabs set as sections — the chosen one carries the print's own
  /// bullet and its ink underline.
  gazetteRuled,

  /// The iOS tab bar: glued to the screen's edge, the hairline on top,
  /// icon over label, the chosen tab tinted the system blue.
  cupertinoBar,

  /// Material 3's navigation bar: the full-width tonal surface, the
  /// chosen tab's icon riding its own pill indicator, the label under it.
  m3Bar,

  /// The GTA HUD's bottom bar: a dark panel with the amber hairline on
  /// top, each tab a HUD slot — the chosen one wears the amber badge and
  /// its glow, the way the game's own panels light the picked thing.
  gtaRadar,
}

enum HeaderVariant {
  /// The Material app bar the monochrome pushes its pages under.
  material,

  /// The system's iOS page: a compact bold bar and a chevron back.
  ios,

  /// The bento's page header: the squircle back tile and the big title
  /// in the page itself, the box's own calm.
  bento,

  /// The gazette's section front: the back in its ruled square, the
  /// title in the paper's own serif, and the masthead's double rule
  /// under them.
  gazette,

  /// Material 3's large title: a plain back arrow, then the title big in
  /// the page itself.
  m3,

  /// The GTA HUD's page header: the back button in its amber-ruled HUD
  /// square, the title in the display's heavy face, and the HUD's own
  /// rule under them.
  gta,
}

enum GroupVariant {
  /// The monochrome's flat bordered card.
  flat,

  /// The system's iOS grouped table: the raised card, the hairline
  /// inset dividers, the rows breathing 16 inside.
  iosTable,

  /// The bento's own card: the very-round tile on the warm tint, no
  /// line — the fill speaks, the tile carries.
  bentoBoard,

  /// The gazette's ruled box: the paper card's own double rules, no
  /// fill, the rows parted by hairlines — a printed data box.
  gazetteRules,

  /// Material 3's filled card: the big tonal surface with no outline at
  /// all, the shape speaking instead of the line.
  m3Card,

  /// The GTA HUD's panel: the dark raised panel with the amber-steel
  /// hairline and the beveled corners — a screen from the game's own
  /// HUD, holding the rows behind its glass.
  gtaPanel,
}

/// How the flags are cut, everywhere the app shows one — the wheel's
/// cards, the strip's tiles, and the little flag beside every row.
enum FlagShape {
  /// The rounded rectangle: the flag's own 3:2 plate with soft corners.
  rounded,

  /// The circle: the flag cropped to a round medal — the system's own
  /// way in the settings' tables.
  circle,

  /// The printed plate: the paper's near-square cut with the double
  /// rule around it, the engraving's own frame.
  plate,
}

/// How loud the design's surfaces are: the depth of the shadows, the
/// reach of the glows, the weight of the lines. One mood per design,
/// read by every card and control the app paints.
enum FxMood {
  /// The monochrome's glass: the soft shadows and the glass blur.
  glass,

  /// The raised card and the hairline — depth without shadow.
  soft,

  /// Material's tonal depth: the surface's own color speaks, no shadow
  /// and no line.
  tonal,

  /// The printed page: flat ink on flat paper, the rules carrying the
  /// structure.
  print,

  /// The brand's light: the surfaces carry a glow of their own.
  glow,

  /// The box's pop: the saturated tiles and the soft shadows — depth
  /// with warmth, no blur of glass, no bloom of light.
  pop,
}

/// How the wheels and strips scroll: each design hands its lists the
/// physics of its own world.
enum ScrollMood {
  /// The wheel's glide: one fling one country, the spring that lands it
  /// softly (the wheel's own page physics).
  glide,

  /// The system's bounce: the light overscroll the iPhone's lists wear.
  bounce,

  /// Material's spring: a touch of the overshoot the M3 lists carry.
  springy,

  /// The press's weight: the paper does not overscroll; a fling dies
  /// against the fold.
  heavy,
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
    required this.flagShape,
    required this.flagRound,
    required this.smallFlagRound,
    required this.fx,
    required this.scroll,
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
    'gazette' => _gazette(dark),
    'pixel' => _pixel(dark),
    'ios' => _ios(dark),
    'bento' => _bento(dark),
    'gta' => _gta(dark),
    _ => _mono(dark),
  };

  final NavVariant nav;
  final HeaderVariant header;
  final GroupVariant group;

  /// The cut every flag wears on this design — the wheel's cards, the
  /// strip's tiles, and the row's little flags all read it.
  final FlagShape flagShape;

  /// The round of the wheel's flag card when the shape is [FlagShape.rounded].
  final double flagRound;

  /// The round of the row's small flag when the shape is
  /// [FlagShape.rounded] — the little plate's corners are softer.
  final double smallFlagRound;

  /// How loud the surfaces are on this design.
  final FxMood fx;

  /// How the wheels and strips scroll on this design.
  final ScrollMood scroll;

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
    flagShape: FlagShape.rounded,
    flagRound: 18,
    smallFlagRound: 5,
    fx: FxMood.glass,
    scroll: ScrollMood.glide,
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

  /// The gazette's structure: the printed page's own — the near-square
  /// ruled boxes (the group wears the paper card's double rules), the
  /// small print's dialog, the section front for the pushed page, and
  /// the paper's own section bar for the navigation. The ink's state
  /// colors: the green stamp carries, the ochre reaches, the red ink
  /// blocks.
  static DesignStyle _gazette(bool dark) => DesignStyle._(
    nav: NavVariant.gazetteRuled,
    header: HeaderVariant.gazette,
    group: GroupVariant.gazetteRules,
    flagShape: FlagShape.plate,
    flagRound: 3,
    smallFlagRound: 2,
    fx: FxMood.print,
    scroll: ScrollMood.heavy,
    cardRadius: 6,
    listRadius: 4,
    dialogRadius: 6,
    iconBadge: false,
    connected: dark ? const Color(0xFF74B089) : const Color(0xFF1F5F3F),
    scanning: dark ? const Color(0xFFC4A24D) : const Color(0xFF8A6D1F),
    danger: dark ? const Color(0xFFD6574A) : const Color(0xFFA8231D),
    navBackground: dark ? const Color(0xFF1C1812) : const Color(0xFFFBF7EC),
    navActive: dark ? const Color(0xFFEDE4CF) : const Color(0xFF1C1712),
    navInactive: dark ? const Color(0xFFA3967F) : const Color(0xFF6E6355),
    switchTrack: dark ? const Color(0xFFEDE4CF) : const Color(0xFF1C1712),
  );

  /// The pixel's structure: Material You's own — the full-width M3 bar
  /// with its pill indicator, the large title, the big filled tonal
  /// cards with no outline (the shape speaks, not the line), and the
  /// tonal state colors (the Google blue carries, the amber reaches,
  /// the M3 red blocks).
  static DesignStyle _pixel(bool dark) => DesignStyle._(
    nav: NavVariant.m3Bar,
    header: HeaderVariant.m3,
    group: GroupVariant.m3Card,
    flagShape: FlagShape.rounded,
    flagRound: 22,
    smallFlagRound: 8,
    fx: FxMood.tonal,
    scroll: ScrollMood.springy,
    cardRadius: 28,
    listRadius: 20,
    dialogRadius: 28,
    iconBadge: false,
    connected: dark ? const Color(0xFFA8C7FA) : const Color(0xFF0B57D0),
    scanning: dark ? const Color(0xFFFCC64B) : const Color(0xFFB45309),
    danger: dark ? const Color(0xFFF2B8B5) : const Color(0xFFB3261E),
    navBackground: dark ? const Color(0xFF161B21) : const Color(0xFFF2F4F9),
    navActive: dark ? const Color(0xFFA8C7FA) : const Color(0xFF0B57D0),
    navInactive: dark ? const Color(0xFF96A0AC) : const Color(0xFF5D6470),
    switchTrack: dark ? const Color(0xFFA8C7FA) : const Color(0xFF0B57D0),
  );

  /// The ios's structure: the system's own — the tab bar glued to the
  /// screen's edge with its hairline, the compact bold page bar, the
  /// grouped tables with their hairline inset dividers, the rounded
  /// alert, and the system's state colors in both modes. The rows'
  /// icons wear the colored badges, the system settings' way.
  static DesignStyle _ios(bool dark) => DesignStyle._(
    nav: NavVariant.cupertinoBar,
    header: HeaderVariant.ios,
    group: GroupVariant.iosTable,
    flagShape: FlagShape.circle,
    flagRound: 16,
    smallFlagRound: 8,
    fx: FxMood.soft,
    scroll: ScrollMood.bounce,
    cardRadius: 16,
    listRadius: 16,
    dialogRadius: 14,
    iconBadge: true,
    connected: dark ? const Color(0xFF30D158) : const Color(0xFF2FB558),
    scanning: dark ? const Color(0xFFFF9F0A) : const Color(0xFFE08900),
    danger: dark ? const Color(0xFFFF453A) : const Color(0xFFE0362B),
    navBackground: dark ? const Color(0xFF1D1D1F) : const Color(0xFFF9F9F9),
    navActive: dark ? const Color(0xFF0A84FF) : const Color(0xFF007AFF),
    navInactive: dark ? const Color(0xFF98989F) : const Color(0xFF999CA1),
    switchTrack: dark ? const Color(0xFF30D158) : const Color(0xFF34C759),
  );

  /// The bento's structure: the lunch box's own — the floating dock of
  /// rounded tiles, the squircle-backed page header, the very-round
  /// tinted cards with no line, the big soft state colors. The
  /// tangerine carries, the amber reaches, the tomato blocks.
  static DesignStyle _bento(bool dark) => DesignStyle._(
    nav: NavVariant.bentoDock,
    header: HeaderVariant.bento,
    group: GroupVariant.bentoBoard,
    flagShape: FlagShape.rounded,
    flagRound: 18,
    smallFlagRound: 6,
    fx: FxMood.pop,
    scroll: ScrollMood.springy,
    cardRadius: 24,
    listRadius: 18,
    dialogRadius: 24,
    iconBadge: false,
    connected: dark ? const Color(0xFF57CC8D) : const Color(0xFF2F9E63),
    scanning: dark ? const Color(0xFFE8B45A) : const Color(0xFFB98216),
    danger: dark ? const Color(0xFFF26B5E) : const Color(0xFFC63D3D),
    navBackground: dark ? const Color(0xFF1C1A18) : Colors.white,
    navActive: dark ? const Color(0xFFFF8B5E) : const Color(0xFFE05D2A),
    navInactive: dark ? const Color(0xFFA39C90) : const Color(0xFF6F6A61),
    switchTrack: dark ? const Color(0xFFFF8B5E) : const Color(0xFFE05D2A),
  );

  /// The gta's structure: the game HUD's own — the dark panels with the
  /// amber hairlines (the group wears the HUD panel), the amber-ruled
  /// page header, the HUD slot bar for the navigation. The radar's
  /// green carries, the amber reaches, the neon red blocks. The flags
  /// are the wheel's circular medals; the glow is the neon's own.
  static DesignStyle _gta(bool dark) => DesignStyle._(
    nav: NavVariant.gtaRadar,
    header: HeaderVariant.gta,
    group: GroupVariant.gtaPanel,
    flagShape: FlagShape.circle,
    flagRound: 16,
    smallFlagRound: 8,
    fx: FxMood.glow,
    scroll: ScrollMood.glide,
    cardRadius: 14,
    listRadius: 12,
    dialogRadius: 16,
    iconBadge: false,
    connected: dark ? const Color(0xFF3ECF6E) : const Color(0xFF1FA050),
    scanning: dark ? const Color(0xFFFFB84D) : const Color(0xFFB97A14),
    danger: dark ? const Color(0xFFFF4D5E) : const Color(0xFFC62F45),
    navBackground: dark ? const Color(0xFF101018) : const Color(0xFFFFFBF2),
    navActive: dark ? const Color(0xFFFFB84D) : const Color(0xFFB97A14),
    navInactive: dark ? const Color(0xFF8E8AA6) : const Color(0xFF7C6E80),
    switchTrack: dark ? const Color(0xFFFFB84D) : const Color(0xFFB97A14),
  );

  /// The row's icon badge: the iOS table's colored rounded squares, or
  /// the round neutral tile. The color is decided by the icon itself,
  /// so a row always wears the same badge.
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
    // The iOS Settings badge palette.
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

// ---------------------------------------------------------------------------
// The gazette's furniture: the section bar and the section front.
// ---------------------------------------------------------------------------

/// The gazette's bottom navigation: the paper's own section bar — a strip
/// of the same stock the page prints on, the masthead's double rule on
/// its top edge, the tabs set as the sections' names. The chosen section
/// carries the print's own bullet (a small square of the red ink, the
/// way a column announces itself) and a thin underline growing under its
/// word; a tap presses the new section's name in, a stamp's arrival.
class GazetteNav extends StatelessWidget {
  const GazetteNav({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final style = DesignStyle.of(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = theme.brightness == Brightness.dark;
    final ink = style.navActive;
    final muted = style.navInactive;
    final tabs = [l.navHome, l.navSettings];
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
              decoration: BoxDecoration(
                color: style.navBackground.withValues(alpha: dark ? 0.97 : 1),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.45 : 0.12),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The masthead's double rule rides the bar's top edge:
                  // the thick ink rule, then the hairline under it.
                  Container(height: 2.2, color: ink),
                  Container(height: 0.8, color: muted.withValues(alpha: 0.55)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 9, 8, 9),
                    child: Row(
                      children: [
                        for (var i = 0; i < tabs.length; i++)
                          Expanded(child: _section(context, i, tabs[i])),
                      ],
                    ),
                  ),
                  Container(height: 1, color: muted.withValues(alpha: 0.35)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, int i, String label) {
    final style = DesignStyle.of(context);
    final theme = Theme.of(context);
    final chosen = index == i;
    final ink = style.navActive;
    final muted = style.navInactive;
    final stamp = theme.colorScheme.primary;
    final arabic = _arabicScriptWord(label);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!chosen) {
          HapticFeedback.selectionClick();
          AppSounds.play(SoundCue.tap);
          onSelect(i);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // The print's own bullet: a small square of the red ink,
                // growing in beside the chosen section's word.
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: chosen ? 5 : 0,
                  height: 5,
                  margin: EdgeInsetsDirectional.only(end: chosen ? 6 : 0),
                  decoration: BoxDecoration(
                    color: chosen ? stamp : Colors.transparent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                // The section's word, pressed in when it is chosen — the
                // stamp's own arrival: a quick press and a settle.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.92, end: 1.0).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    label,
                    key: ValueKey('$i-$chosen'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: chosen ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: arabic ? 0 : 0.6,
                      color: chosen ? ink : muted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // The chosen section's underline: a thin ink rule growing to
            // its width, the way a column's head rules itself.
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              height: 1.2,
              width: chosen ? 30 : 0,
              decoration: BoxDecoration(
                color: chosen ? ink : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Whether [text] carries Arabic-script letters — the script the letter
/// tracking would tear apart.
bool _arabicScriptWord(String text) => text.contains(
  RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]'),
);

/// The gazette's pushed-page header: a section front — the back in its
/// ruled square, the title in the paper's own voice, and the masthead's
/// double rule carrying the page under the clock.
class GazettePageHeader extends StatelessWidget {
  const GazettePageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    // The header leads the pushed page under the clock, so it carries
    // the status bar's own inset.
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, top + 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // The back in its ruled square: the paper's own button, the
              // near-square corners and the ink's hairline.
              GestureDetector(
                onTap:
                    onBack ??
                    () => Navigator.of(context, rootNavigator: true).pop(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ink.withValues(alpha: 0.8)),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 15,
                    color: ink,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  // The section's own word above the title: the small,
                  // widely spaced letters the paper tags its sections
                  // with — the Latin takes the tracking, the Arabic
                  // script keeps its joins.
                  AppLocalizations.of(context).gazetteSection,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: _arabicScriptWord(title) ? 0 : 2.4,
                    color: muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 26,
              height: 1.1,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 2.2, color: ink),
          const SizedBox(height: 2),
          Container(height: 0.8, color: muted.withValues(alpha: 0.55)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The ios's furniture: the tab bar and the system's clarity.
// ---------------------------------------------------------------------------

/// The iOS tab bar: glued to the screen's edge — the system's own way —
/// the hairline on top, the icon above its label, the chosen tab tinted
/// the system blue. No splash, no pill: the tint itself is the answer,
/// crossfading with a small scale the way the system's own bars swap
/// their symbols.
class CupertinoBarNav extends StatelessWidget {
  const CupertinoBarNav({
    super.key,
    required this.index,
    required this.onSelect,
  });

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final style = DesignStyle.of(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = theme.brightness == Brightness.dark;
    final tabs = [
      (Icons.home_rounded, Icons.home_outlined, l.navHome),
      (Icons.settings_rounded, Icons.settings_outlined, l.navSettings),
    ];
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: style.navBackground.withValues(alpha: dark ? 0.96 : 0.97),
          border: Border(
            top: BorderSide(
              color: dark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.black.withValues(alpha: 0.10),
              width: 0.5,
            ),
          ),
        ),
        height: 62,
        child: Row(
          children: [
            for (var i = 0; i < tabs.length; i++)
              Expanded(child: _tab(context, i, tabs[i])),
          ],
        ),
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    int i,
    (IconData, IconData, String) tab,
  ) {
    final style = DesignStyle.of(context);
    final chosen = index == i;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!chosen) {
          HapticFeedback.selectionClick();
          AppSounds.play(SoundCue.tap);
          onSelect(i);
        }
      },
      child: Pressable(
        depth: 0.06,
        child: Center(
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The symbol swaps itself: the filled one for the chosen tab,
            // the outline for the rest, crossfading with a small scale —
            // the system's own bar never snaps between its symbols.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween(begin: 0.86, end: 1.0).animate(anim),
                  child: child,
                ),
              ),
              child: Icon(
                chosen ? tab.$1 : tab.$2,
                key: ValueKey('ios-tab-$i-$chosen'),
                size: 24,
                color: chosen ? style.navActive : style.navInactive,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: chosen ? FontWeight.w700 : FontWeight.w500,
                color: chosen ? style.navActive : style.navInactive,
                fontFamily: Theme.of(
                  context,
                ).textTheme.bodyMedium?.fontFamily,
              ),
              child: Text(tab.$3, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The pixel's furniture: the M3 bar and the large title.
// ---------------------------------------------------------------------------

/// Material 3's navigation bar: the full-width tonal surface at the
/// screen's foot, each tab's icon riding its own pill indicator when
/// chosen — the pill grows around the icon while the label takes its
/// weight. The indicator's own color is the light's tonal companion.
class M3BarNav extends StatelessWidget {
  const M3BarNav({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tabs = [
      (Icons.home_rounded, Icons.home_outlined, l.navHome),
      (Icons.settings_rounded, Icons.settings_outlined, l.navSettings),
    ];
    return SafeArea(
      top: false,
      child: Material(
        color: DesignStyle.of(context).navBackground,
        elevation: 0,
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(child: _tab(context, i, tabs[i])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(
    BuildContext context,
    int i,
    (IconData, IconData, String) tab,
  ) {
    final style = DesignStyle.of(context);
    final chosen = index == i;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!chosen) {
          HapticFeedback.selectionClick();
          AppSounds.play(SoundCue.tap);
          onSelect(i);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // The indicator pill: the chosen tab's icon sits inside its own
          // rounded seat, which grows from nothing the M3 way.
          SizedBox(
            height: 32,
            width: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: chosen ? 64 : 0,
                  height: chosen ? 32 : 0,
                  decoration: BoxDecoration(
                    color: style.navActive.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.84, end: 1.0).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Icon(
                    chosen ? tab.$1 : tab.$2,
                    key: ValueKey('m3-tab-$i-$chosen'),
                    size: 24,
                    color: chosen ? style.navActive : style.navInactive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 12,
              fontWeight: chosen ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.2,
              color: chosen ? style.navActive : style.navInactive,
              fontFamily: Theme.of(
                context,
              ).textTheme.bodyMedium?.fontFamily,
            ),
            child: Text(tab.$3, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// Material 3's large title: the plain back arrow, then the title big in
/// the page itself — the bar stays out of the way.
class M3PageHeader extends StatelessWidget {
  const M3PageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4, top + 6, 22, 6),
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
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The bento's furniture: the tile dock and the box's page header.
// ---------------------------------------------------------------------------

/// The bento's bottom navigation: the box's own dock — floating
/// rounded-square tiles, each tab a cell of its own. The chosen tile
/// fills with the tangerine and lifts (its shadow grows, its scale
/// breathes past one), the icon and the word turn the box's light; the
/// resting tiles keep the surface's own fill and the muted ink.
class BentoDockNav extends StatelessWidget {
  const BentoDockNav({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
            child: Row(
              children: [
                for (var i = 0; i < tabs.length; i++)
                  Expanded(child: _cell(context, i, tabs[i].$1, tabs[i].$2, tabs[i].$3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    int i,
    IconData filled,
    IconData outline,
    String label,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = DesignStyle.of(context);
    final chosen = index == i;
    final accent = style.navActive;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: i == 0 ? 10 : 0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!chosen) {
            HapticFeedback.selectionClick();
            AppSounds.play(SoundCue.tap);
            onSelect(i);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          height: 62,
          decoration: BoxDecoration(
            color: chosen ? accent : style.navBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: chosen
                  ? accent
                  : (dark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: chosen
                    ? accent.withValues(alpha: dark ? 0.35 : 0.28)
                    : Colors.black.withValues(alpha: dark ? 0.35 : 0.10),
                blurRadius: chosen ? 16 : 10,
                offset: Offset(0, chosen ? 5 : 3),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: chosen ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    chosen ? filled : outline,
                    size: 21,
                    color: chosen
                        ? (accent.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white)
                        : style.navInactive,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: chosen ? FontWeight.w800 : FontWeight.w600,
                    color: chosen
                        ? (accent.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white)
                        : style.navInactive,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.fontFamily,
                  ),
                  child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The bento's page header: the squircle back tile, then the big title —
/// the box's own calm, no bar above.
class BentoPageHeader extends StatelessWidget {
  const BentoPageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(14, top + 6, 22, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap:
                onBack ??
                () => Navigator.of(context, rootNavigator: true).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 27,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The gta's furniture: the HUD slot bar and the HUD page header.
// ---------------------------------------------------------------------------

/// The GTA HUD's bottom navigation: a dark panel riding over the page,
/// the amber hairline along its top edge, each tab a HUD slot of its
/// own. The chosen slot's badge fills with the amber and glows the way
/// the game's own panels light the picked thing; the label reads in the
/// display's heavy face, like the HUD's own words.
class GtaRadarNav extends StatelessWidget {
  const GtaRadarNav({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tabs = [
      (Icons.home_rounded, Icons.home_outlined, l.navHome),
      (Icons.settings_rounded, Icons.settings_outlined, l.navSettings),
    ];
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Align(
          heightFactor: 1,
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              height: 66,
              decoration: BoxDecoration(
                color: DesignStyle.of(context).navBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: DesignStyle.of(
                    context,
                  ).navActive.withValues(alpha: 0.45),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                  // The amber's own wash under the panel: the HUD's light.
                  BoxShadow(
                    color: DesignStyle.of(
                      context,
                    ).navActive.withValues(alpha: 0.10),
                    blurRadius: 22,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  children: [
                    // The HUD's own top edge: the amber strip the game's
                    // panels wear, thin and exact.
                    Container(
                      height: 2,
                      color: DesignStyle.of(
                        context,
                      ).navActive.withValues(alpha: 0.85),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          for (var i = 0; i < tabs.length; i++)
                            Expanded(
                              child: _slot(
                                context,
                                i,
                                tabs[i].$1,
                                tabs[i].$2,
                                tabs[i].$3,
                              ),
                            ),
                        ],
                      ),
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

  Widget _slot(
    BuildContext context,
    int i,
    IconData filled,
    IconData outline,
    String label,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = DesignStyle.of(context);
    final chosen = index == i;
    final amber = style.navActive;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!chosen) {
          HapticFeedback.selectionClick();
          AppSounds.play(SoundCue.tap);
          onSelect(i);
        }
      },
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          scale: chosen ? 1.0 : 0.94,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The HUD slot: a beveled square badge, amber when chosen,
              // the panel's own surface when resting.
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: chosen
                      ? amber
                      : (dark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.05)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: chosen
                        ? amber
                        : amber.withValues(alpha: dark ? 0.30 : 0.25),
                    width: 1,
                  ),
                  boxShadow: chosen
                      ? [
                          BoxShadow(
                            color: amber.withValues(alpha: 0.45),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ]
                      : const [],
                ),
                child: Icon(
                  chosen ? filled : outline,
                  size: 17,
                  color: chosen
                      ? (amber.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white)
                      : style.navInactive,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: chosen ? style.navActive : style.navInactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The GTA HUD's page header: the back button in its amber-ruled HUD
/// square, the title in the display's heavy face, and the HUD's rule —
/// the thin amber strip over the quiet hairline — under them.
class GtaPageHeader extends StatelessWidget {
  const GtaPageHeader({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = DesignStyle.of(context);
    final amber = style.navActive;
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, top + 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // The HUD's back: the square with the amber rule around it,
              // the way the game's own panels frame their buttons.
              GestureDetector(
                onTap:
                    onBack ??
                    () => Navigator.of(context, rootNavigator: true).pop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: amber.withValues(alpha: 0.55)),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 19,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    letterSpacing: 0.6,
                    color: theme.colorScheme.onSurface,
                    // The HUD's own face: the heavy condensed voice the
                    // game's titles wear — Persian falls through to
                    // Vazirmatn.
                    fontFamily: 'GtaHud',
                    fontFamilyFallback: const ['Vazirmatn', 'Inter'],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // The HUD's rule: the amber strip over the quiet hairline —
          // the game's own panel edge, closing the header.
          Container(height: 2.4, color: amber.withValues(alpha: 0.9)),
          const SizedBox(height: 2),
          Container(height: 0.8, color: amber.withValues(alpha: 0.30)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
