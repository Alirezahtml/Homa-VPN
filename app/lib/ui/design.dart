import 'package:flutter/material.dart';

import '../app_settings.dart';
import 'accent.dart';

/// The looks the whole app wears, one behind each home design.
///
/// A design is not only the home page's layout (that is the home design:
/// the wheel, the tiles, the compact card, and the two that joined them).
/// Each of the two reference designs carries a complete palette of its
/// own: the surfaces, the inks, the outlines of both modes, and a light
/// of its own — the same palette every page reads, from the home to the
/// dialogs to the pill navigation. The three older homes keep the
/// monochrome.
///
/// The palettes were drawn from the two reference designs the picker
/// carries: the aether, tuned on the AetherST client's iOS group tables
/// (the raised cards, the sunken page, the system blue), and the zed,
/// tuned on the ZedSecure client's expressive bento (the violet night,
/// the pink and lime lights, the very round cards).
///
/// The palette reaches the theme in [App]'s builder through [resolveFor],
/// the one place the design and the accent are decided together, so they
/// never disagree.
abstract final class AppDesign {
  /// The design for this build of the page, set once per build by
  /// [resolveFor] in the app's builder.
  static DesignTheme current = DesignTheme.mono;

  /// The design a home design key asks for; the three older homes — and
  /// any key that is not one of the two — keep the monochrome. The four
  /// looks that left (the aurora, the neon, the dusk, the sage) land
  /// here too: the monochrome, until the user picks one of the looks
  /// that stand.
  static DesignTheme resolve(String key) => switch (key) {
    'aether' => DesignTheme.aether,
    'zed' => DesignTheme.zed,
    _ => DesignTheme.mono,
  };

  /// Sets [current] from the home design the settings carry, and returns
  /// the light the app wears: the user's own accent when they picked one,
  /// else the design's own light — the two designs each carry one. The
  /// monochrome keeps the full contrast when no accent is picked.
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

  /// The aether: the iOS-tuned look AetherST wears — the grouped tables
  /// of the system settings, the raised card on the sunken page, and the
  /// system blue for the light. The day is the grouped porcelain; the
  /// night is the true black under the raised gray cards.
  static const aether = DesignTheme._(
    key: 'aether',
    day: DesignLook(
      scaffold: Color(0xFFF2F3F7),
      scaffoldBottom: Color(0xFFEAECF1),
      surface: Colors.white,
      surfaceHigh: Color(0xFFF7F8FA),
      containerHighest: Color(0xFFECECF1),
      ink: Color(0xFF1A1A1F),
      muted: Color(0xFF5A5A63),
      outline: Color(0xFFDCDCE2),
      accent: Color(0xFF0A6CFF),
      cardShadow: [],
      homeTop: Color(0xFFF4F5F9),
      homeBottom: Color(0xFFEAECF1),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFDCDCE2),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0A0A0D),
      scaffoldBottom: Color(0xFF050507),
      surface: Color(0xFF1C1C1E),
      surfaceHigh: Color(0xFF232326),
      containerHighest: Color(0xFF2C2C2E),
      ink: Color(0xFFECECF1),
      muted: Color(0xFF8E8E93),
      outline: Color(0xFF38383D),
      accent: Color(0xFF0A84FF),
      cardShadow: [],
      homeTop: Color(0xFF0A0A0D),
      homeBottom: Color(0xFF050507),
      homeCard: Color(0xFF1C1C1E),
      homeCardBorder: Color(0xFF2C2C2E),
    ),
  );

  /// The zed: the expressive bento ZedSecure wears — the violet night
  /// with the pink and lime lights, the very round cards. The day is the
  /// pale violet porcelain; the night is the deep violet-black the
  /// brand's gradient lights up.
  static const zed = DesignTheme._(
    key: 'zed',
    day: DesignLook(
      scaffold: Color(0xFFF5F3FA),
      scaffoldBottom: Color(0xFFEEEBF6),
      surface: Colors.white,
      surfaceHigh: Color(0xFFF8F6FC),
      containerHighest: Color(0xFFF1EDF9),
      ink: Color(0xFF1D1533),
      muted: Color(0xFF6E6488),
      outline: Color(0xFFE2DBF0),
      accent: Color(0xFF5646D6),
      cardShadow: [],
      homeTop: Color(0xFFF7F5FB),
      homeBottom: Color(0xFFEEEBF6),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFE2DBF0),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0C0817),
      scaffoldBottom: Color(0xFF080510),
      surface: Color(0xFF17102A),
      surfaceHigh: Color(0xFF1E1535),
      containerHighest: Color(0xFF191129),
      ink: Color(0xFFEFE9FB),
      muted: Color(0xFFA99BC8),
      outline: Color(0xFF2B2044),
      accent: Color(0xFF7A5CFF),
      cardShadow: [],
      homeTop: Color(0xFF0C0817),
      homeBottom: Color(0xFF070410),
      homeCard: Color(0xFF150E24),
      homeCardBorder: Color(0xFF271C3D),
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
