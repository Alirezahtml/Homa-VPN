import 'package:flutter/material.dart';

import '../app_settings.dart';
import 'accent.dart';

/// The looks the whole app wears, one behind each home design.
///
/// A design is not only the home page's layout (that is the home design:
/// the wheel, the tiles, the compact card, and the looks that joined
/// them). The looks that carry a palette have a complete one of their
/// own: the surfaces, the inks, the outlines of both modes, and a light
/// of their own — the same palette every page reads, from the home to
/// the dialogs to the navigation. The three older homes keep the
/// monochrome.
///
/// The palettes were tuned on the designs the picker carries: the ios
/// on the system's group tables (the raised cards, the sunken page, the
/// system blue).
///
/// The palette reaches the theme in [App]'s builder through [resolveFor],
/// the one place the design and the accent are decided together, so they
/// never disagree.
abstract final class AppDesign {
  /// The design for this build of the page, set once per build by
  /// [resolveFor] in the app's builder.
  static DesignTheme current = DesignTheme.mono;

  /// The design a home design key asks for; the three older homes — and
  /// any key that is not one of the looks that stand — keep the
  /// monochrome. The looks that left (the aurora, the neon, the dusk,
  /// the sage, and the two that retired with them) land here too: the
  /// monochrome, until the user picks one of the looks that stand.
  static DesignTheme resolve(String key) => switch (key) {
    'gazette' => DesignTheme.gazette,
    'pixel' => DesignTheme.pixel,
    'ios' => DesignTheme.ios,
    'bento' => DesignTheme.bento,
    'sky' => DesignTheme.sky,
    'ocean' => DesignTheme.ocean,
    _ => DesignTheme.mono,
  };

  /// Sets [current] from the home design the settings carry, and returns
  /// the light the app wears: the user's own accent when they picked one,
  /// else the design's own light. The monochrome keeps the full
  /// contrast when no accent is picked.
  static Color? resolveFor(AppSettings settings, bool dark) {
    current = resolve(settings.homeDesign);
    final user = AppAccent.resolve(settings);
    if (user != null) {
      return user;
    }
    return current.accentFor(dark);
  }
}

/// One complete look: the colors of both modes, the card's own
/// decoration, and how the home page's hero fades.
class DesignTheme {
  const DesignTheme._({
    required this.key,
    required this.day,
    required this.night,
  });

  /// The home design key the look belongs to ('mono' for the monochrome,
  /// which the three older homes wear).
  final String key;

  final DesignLook day;
  final DesignLook night;

  /// The monochrome: full contrast, flat cards, no light of its own —
  /// the accent the user picked (or none) carries the color instead.
  static const mono = DesignTheme._(
    key: 'mono',
    day: DesignLook(
      scaffold: Colors.white,
      scaffoldBottom: Color(0xFFF6F6F6),
      surface: Color(0xFFF7F7F7),
      surfaceHigh: Color(0xFFF2F2F2),
      containerHighest: Color(0xFFEFEFEF),
      ink: Color(0xFF0A0A0A),
      muted: Color(0xFF6B6B6B),
      outline: Color(0xFFE4E4E4),
      accent: null,
      cardShadow: [],
      homeTop: Colors.white,
      homeBottom: Color(0xFFF6F6F6),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFE4E4E4),
    ),
    night: DesignLook(
      scaffold: Colors.black,
      scaffoldBottom: Colors.black,
      surface: Color(0xFF0D0D0D),
      surfaceHigh: Color(0xFF1A1A1A),
      containerHighest: Color(0xFF161616),
      ink: Colors.white,
      muted: Color(0xFF9E9E9E),
      outline: Color(0xFF262626),
      accent: null,
      cardShadow: [],
      homeTop: Color(0xFF0A0A0A),
      homeBottom: Colors.black,
      homeCard: Color(0xFF141414),
      homeCardBorder: Color(0xFF282828),
    ),
  );

  /// The pixel: Material You's own look — the tonal surfaces (the tinted
  /// neutrals, never pure gray), the big filled shapes with no outline,
  /// the Google blue's light. The day is the porcelain with the cool
  /// tint; the night is the deep blue-black the tonal palettes carry.
  static const pixel = DesignTheme._(
    key: 'pixel',
    day: DesignLook(
      scaffold: Color(0xFFF8F9FC),
      scaffoldBottom: Color(0xFFF1F3F8),
      surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFF4F6FA),
      containerHighest: Color(0xFFEDF0F6),
      ink: Color(0xFF191C20),
      muted: Color(0xFF5D6470),
      outline: Color(0xFFDBE0E8),
      accent: Color(0xFF0B57D0),
      cardShadow: [],
      homeTop: Color(0xFFF8F9FC),
      homeBottom: Color(0xFFF1F3F8),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFDBE0E8),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0F1419),
      scaffoldBottom: Color(0xFF0A0E12),
      surface: Color(0xFF171C22),
      surfaceHigh: Color(0xFF1E242B),
      containerHighest: Color(0xFF1A2027),
      ink: Color(0xFFE1E6EC),
      muted: Color(0xFF96A0AC),
      outline: Color(0xFF2A313A),
      accent: Color(0xFFA8C7FA),
      cardShadow: [],
      homeTop: Color(0xFF0F1419),
      homeBottom: Color(0xFF0A0E12),
      homeCard: Color(0xFF171C22),
      homeCardBorder: Color(0xFF2A313A),
    ),
  );

  /// The ios: the system's own look — the grouped porcelain (the page
  /// sits back, the cards stand forward), the true black under the raised
  /// gray cards, and the system blue's light. The shapes are the grouped
  /// tables and the tab bar's; the voice is SF's own clarity.
  static const ios = DesignTheme._(
    key: 'ios',
    day: DesignLook(
      scaffold: Color(0xFFF2F2F7),
      scaffoldBottom: Color(0xFFE9E9EE),
      surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFF7F7FA),
      containerHighest: Color(0xFFEFEFF4),
      ink: Color(0xFF1C1C1E),
      muted: Color(0xFF6C6C70),
      outline: Color(0xFFD8D8DC),
      accent: Color(0xFF007AFF),
      cardShadow: [],
      homeTop: Color(0xFFF2F2F7),
      homeBottom: Color(0xFFE9E9EE),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFD8D8DC),
    ),
    night: DesignLook(
      scaffold: Color(0xFF000000),
      scaffoldBottom: Color(0xFF000000),
      surface: Color(0xFF1C1C1E),
      surfaceHigh: Color(0xFF2C2C2E),
      containerHighest: Color(0xFF242426),
      ink: Color(0xFFF2F2F7),
      muted: Color(0xFF98989F),
      outline: Color(0xFF38383D),
      accent: Color(0xFF0A84FF),
      cardShadow: [],
      homeTop: Color(0xFF000000),
      homeBottom: Color(0xFF000000),
      homeCard: Color(0xFF1C1C1E),
      homeCardBorder: Color(0xFF38383D),
    ),
  );

  /// The gazette: the news sheet's own look — ivory paper, warm ink, the
  /// red ink's light, and the hairline rules of a printed page. The day
  /// is the folded morning paper; the night is the paper printed in
  /// negative, cream ink on dark stock.
  static const gazette = DesignTheme._(
    key: 'gazette',
    day: DesignLook(
      scaffold: Color(0xFFF5F0E4),
      scaffoldBottom: Color(0xFFEDE6D5),
      surface: Color(0xFFFBF7EC),
      surfaceHigh: Color(0xFFF3EDE0),
      containerHighest: Color(0xFFEFE8D8),
      ink: Color(0xFF1C1712),
      muted: Color(0xFF6E6355),
      outline: Color(0xFFCFC4AB),
      accent: Color(0xFFA8231D),
      cardShadow: [],
      homeTop: Color(0xFFF5F0E4),
      homeBottom: Color(0xFFEDE6D5),
      homeCard: Color(0xFFFBF7EC),
      homeCardBorder: Color(0xFFCFC4AB),
    ),
    night: DesignLook(
      scaffold: Color(0xFF14110C),
      scaffoldBottom: Color(0xFF0F0D09),
      surface: Color(0xFF1C1812),
      surfaceHigh: Color(0xFF242016),
      containerHighest: Color(0xFF201B13),
      ink: Color(0xFFEDE4CF),
      muted: Color(0xFFA3967F),
      outline: Color(0xFF3A3426),
      accent: Color(0xFFD6574A),
      cardShadow: [],
      homeTop: Color(0xFF14110C),
      homeBottom: Color(0xFF0F0D09),
      homeCard: Color(0xFF1C1812),
      homeCardBorder: Color(0xFF3A3426),
    ),
  );

  /// The bento: the lunch box's own look — the warm porcelain and the
  /// charcoal ink, the tangerine's light, and the very-round tiles that
  /// each carry their own thing. The day is the lacquered box's light
  /// wood; the night is the charcoal under the box's warm glaze.
  static const bento = DesignTheme._(
    key: 'bento',
    day: DesignLook(
      scaffold: Color(0xFFF5F1E8),
      scaffoldBottom: Color(0xFFEEE8DC),
      surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFF8F5EE),
      containerHighest: Color(0xFFEFEAE0),
      ink: Color(0xFF23201B),
      muted: Color(0xFF6F6A61),
      outline: Color(0xFFE2DCCE),
      accent: Color(0xFFE05D2A),
      cardShadow: [],
      homeTop: Color(0xFFF5F1E8),
      homeBottom: Color(0xFFEEE8DC),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFE2DCCE),
    ),
    night: DesignLook(
      scaffold: Color(0xFF121110),
      scaffoldBottom: Color(0xFF0C0B0A),
      surface: Color(0xFF1C1A18),
      surfaceHigh: Color(0xFF242220),
      containerHighest: Color(0xFF1F1D1B),
      ink: Color(0xFFF1ECE3),
      muted: Color(0xFFA39C90),
      outline: Color(0xFF332F2A),
      accent: Color(0xFFFF8B5E),
      cardShadow: [],
      homeTop: Color(0xFF121110),
      homeBottom: Color(0xFF0C0B0A),
      homeCard: Color(0xFF1C1A18),
      homeCardBorder: Color(0xFF332F2A),
    ),
  );

  /// The sky: the daylight's own look — the paper-blue page, the white
  /// cards floating on their soft blue shade, the deep navy ink and the
  /// sky's own blue carrying. The night is the sky after dark: the navy
  /// under a lighter blue.
  static const sky = DesignTheme._(
    key: 'sky',
    day: DesignLook(
      scaffold: Color(0xFFEFF5FF),
      scaffoldBottom: Color(0xFFE4EEFB),
      surface: Color(0xFFFFFFFF),
      surfaceHigh: Color(0xFFF5F9FF),
      containerHighest: Color(0xFFEAF1FC),
      ink: Color(0xFF0E1E45),
      muted: Color(0xFF6C7C9C),
      outline: Color(0xFFDFE9FA),
      accent: Color(0xFF2F6BFF),
      cardShadow: [
        BoxShadow(
          color: Color(0x162F6BFF),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
      homeTop: Color(0xFFEFF5FF),
      homeBottom: Color(0xFFE4EEFB),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFDFE9FA),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0F1730),
      scaffoldBottom: Color(0xFF0A1124),
      surface: Color(0xFF18223E),
      surfaceHigh: Color(0xFF1F2A4A),
      containerHighest: Color(0xFF1A2440),
      ink: Color(0xFFEAF1FF),
      muted: Color(0xFF93A3C4),
      outline: Color(0xFF2A3760),
      accent: Color(0xFF6D9BFF),
      cardShadow: [],
      homeTop: Color(0xFF0F1730),
      homeBottom: Color(0xFF0A1124),
      homeCard: Color(0xFF18223E),
      homeCardBorder: Color(0xFF2A3760),
    ),
  );

  /// The ocean: the deep water's own look — the navy page in both modes,
  /// the glass tiles standing in it, the foam-white ink and the cyan
  /// carrying. The night is the water one breath deeper: darker still,
  /// the same cyan answering.
  /// The ocean: the deep water's own look — the navy page in both modes,
  /// the glass tiles standing in it, the foam-white ink and the cyan
  /// carrying. The night is the water one breath deeper: darker still,
  /// the same cyan answering.
  static const ocean = DesignTheme._(
    key: 'ocean',
    day: DesignLook(
      scaffold: Color(0xFF081637),
      scaffoldBottom: Color(0xFF050F24),
      surface: Color(0xFF0F224C),
      surfaceHigh: Color(0xFF14295A),
      containerHighest: Color(0xFF122548),
      ink: Color(0xFFF2F6FF),
      muted: Color(0xFF9FB2D8),
      outline: Color(0xFF233B6E),
      accent: Color(0xFF17C3E6),
      cardShadow: [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 22,
          offset: Offset(0, 10),
        ),
      ],
      homeTop: Color(0xFF0A1C42),
      homeBottom: Color(0xFF061026),
      homeCard: Color(0xFF0F224C),
      homeCardBorder: Color(0xFF233B6E),
    ),
    night: DesignLook(
      scaffold: Color(0xFF050E22),
      scaffoldBottom: Color(0xFF030818),
      surface: Color(0xFF0C1D42),
      surfaceHigh: Color(0xFF112450),
      containerHighest: Color(0xFF0F2044),
      ink: Color(0xFFF2F6FF),
      muted: Color(0xFF93A6CE),
      outline: Color(0xFF1E3360),
      accent: Color(0xFF17C3E6),
      cardShadow: [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
      homeTop: Color(0xFF081734),
      homeBottom: Color(0xFF030818),
      homeCard: Color(0xFF0C1D42),
      homeCardBorder: Color(0xFF1E3360),
    ),
  );

  DesignLook look(bool dark) => dark ? night : day;

  /// The design's own light for [dark]; null when the design keeps the
  /// monochrome's full contrast.
  Color? accentFor(bool dark) => look(dark).accent;
}

/// The colors of one design in one mode.
class DesignLook {
  const DesignLook({
    required this.scaffold,
    required this.scaffoldBottom,
    required this.surface,
    required this.surfaceHigh,
    required this.containerHighest,
    required this.ink,
    required this.muted,
    required this.outline,
    required this.accent,
    required this.cardShadow,
    required this.homeTop,
    required this.homeBottom,
    required this.homeCard,
    required this.homeCardBorder,
  });

  final Color scaffold;
  final Color scaffoldBottom;
  final Color surface;
  final Color surfaceHigh;
  final Color containerHighest;
  final Color ink;
  final Color muted;
  final Color outline;

  /// The design's light, or null to keep the monochrome's.
  final Color? accent;

  /// The shadow a card wears on this surface ([] for the flat monochrome).
  final List<BoxShadow> cardShadow;

  final Color homeTop;
  final Color homeBottom;
  final Color homeCard;
  final Color homeCardBorder;
}
