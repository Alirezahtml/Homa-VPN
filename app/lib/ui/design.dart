import 'package:flutter/material.dart';

import '../app_settings.dart';

/// The app's design themes — complete looks the whole app wears.
///
/// A design is not the home page's layout (that is the home design: the
/// wheel, the tiles, the compact card). A design is the color, the
/// surfaces, the shadows, and the light of EVERY page: the settings, the
/// servers, the accounts, the dialogs, the pill navigation, the home
/// itself. Choosing one restyles the app in place; nothing else moves.
///
/// The Soft Neumorphism look is extracted whole from FoxyVPN's own
/// Compose theme (the Warm Porcelain day and the Matte Obsidian night,
/// with their dual tactile shadows and the sunset-orange light) — the
/// same palette, the same shadows, carried into this app's widgets.
abstract final class AppDesign {
  /// The design for this build of the page, set once per build by
  /// [resolveFor] in the app's builder — the one place the design and
  /// the accent are decided together, so they never disagree.
  static DesignTheme current = DesignTheme.mono;

  /// The designs in menu order.
  static const List<DesignTheme> all = [
    DesignTheme.mono,
    DesignTheme.neu,
    DesignTheme.glass,
  ];

  /// The design a settings key asks for; an unknown key keeps the
  /// monochrome design.
  static DesignTheme resolve(String key) => switch (key) {
        'neu' => DesignTheme.neu,
        'glass' => DesignTheme.glass,
        _ => DesignTheme.mono,
      };

  /// Sets [current] from [settings] and returns the design's own accent
  /// when the design carries one and the user has not picked an accent
  /// of their own — the design's light takes the app's buttons, toggles
  /// and state colors everywhere.
  static Color? resolveFor(AppSettings settings) {
    current = resolve(settings.designKey);
    if (settings.accentKey.isNotEmpty) return null; // the user's own light
    return current.accentFor(
      WidgetsBinding
          .instance.platformDispatcher.platformBrightness ==
          Brightness.dark,
    );
  }
}

/// One complete look: the colors of both modes, the card's own
/// decoration, and how the home page's hero fades.
class DesignTheme {
  const DesignTheme._(
    this.key, {
    required this.day,
    required this.night,
    this.hasOwnAccent = false,
  });

  /// The key that lives in app-settings.json.
  final String key;

  final DesignLook day;
  final DesignLook night;

  /// Whether the design carries a light of its own (the neumorphism's
  /// sunset orange, the glass's royal blue); the monochrome design does
  /// not — its lights stay full contrast.
  final bool hasOwnAccent;

  static const mono = DesignTheme._(
    'mono',
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

  /// Soft Neumorphism — FoxyVPN's tactile look: Warm Porcelain by day
  /// (#E6E9EF with white and mist dual shadows), Matte Obsidian by night
  /// (#1D1F24 with charcoal and ink dual shadows), the sunset-orange
  /// light over both. Cards are extruded: the light comes from up-left,
  /// the shade sits down-right, and a card reads as a button you could
  /// press into the page.
  static const neu = DesignTheme._(
    'neu',
    hasOwnAccent: true,
    day: DesignLook(
      scaffold: Color(0xFFE6E9EF),
      scaffoldBottom: Color(0xFFE0E4EC),
      surface: Color(0xFFECEFF4),
      surfaceHigh: Color(0xFFDDE2EB),
      containerHighest: Color(0xFFD8DEE8),
      ink: Color(0xFF181B22),
      muted: Color(0xFF525B6C),
      outline: Color(0xFFC2C9D6),
      accent: Color(0xFFF25613),
      // The dual tactile shadow: light up-left, shade down-right.
      cardShadow: [
        BoxShadow(
          color: Color(0xFFFFFFFF),
          blurRadius: 16,
          offset: Offset(-7, -7),
        ),
        BoxShadow(
          color: Color(0x66C2C9D6),
          blurRadius: 18,
          offset: Offset(7, 7),
        ),
      ],
      homeTop: Color(0xFFE9ECF2),
      homeBottom: Color(0xFFDFE3EC),
      homeCard: Color(0xFFECEFF4),
      homeCardBorder: Color(0xFFD3D9E3),
    ),
    night: DesignLook(
      scaffold: Color(0xFF1D1F24),
      scaffoldBottom: Color(0xFF17191E),
      surface: Color(0xFF23262D),
      surfaceHigh: Color(0xFF2A2E37),
      containerHighest: Color(0xFF282C34),
      ink: Color(0xFFF4F6FA),
      muted: Color(0xFF9BA3B2),
      outline: Color(0xFF2C303A),
      accent: Color(0xFFFF5E1A),
      cardShadow: [
        BoxShadow(
          color: Color(0x552F343F),
          blurRadius: 16,
          offset: Offset(-7, -7),
        ),
        BoxShadow(
          color: Color(0xB30D0E12),
          blurRadius: 18,
          offset: Offset(7, 7),
        ),
      ],
      homeTop: Color(0xFF1E2127),
      homeBottom: Color(0xFF16181D),
      homeCard: Color(0xFF23262D),
      homeCardBorder: Color(0xFF2F343F),
    ),
  );

  /// Aurora Glass — a deep night sky with the aurora's own blue light,
  /// frosted surfaces over it; by day, a cool porcelain sky with soft
  /// blue frost. Cards read as panes of glass resting on the sky.
  static const glass = DesignTheme._(
    'glass',
    hasOwnAccent: true,
    day: DesignLook(
      scaffold: Color(0xFFF3F5FB),
      scaffoldBottom: Color(0xFFE7EBF5),
      surface: Color(0xFFF8FAFF),
      surfaceHigh: Color(0xFFEDF1F9),
      containerHighest: Color(0xFFE6EBF5),
      ink: Color(0xFF10131A),
      muted: Color(0xFF5A6478),
      outline: Color(0xFFD9DFEA),
      accent: Color(0xFF4F6BFF),
      cardShadow: [
        BoxShadow(
          color: Color(0x1A4F6BFF),
          blurRadius: 22,
          offset: Offset(0, 8),
        ),
      ],
      homeTop: Color(0xFFF5F7FD),
      homeBottom: Color(0xFFE7EBF6),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFDCE2EE),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0B1020),
      scaffoldBottom: Color(0xFF060915),
      surface: Color(0xFF141A2E),
      surfaceHigh: Color(0xFF1B2238),
      containerHighest: Color(0xFF182036),
      ink: Color(0xFFEEF2FF),
      muted: Color(0xFF98A2C0),
      outline: Color(0xFF262E48),
      accent: Color(0xFF6E8BFF),
      cardShadow: [
        BoxShadow(
          color: Color(0x336E8BFF),
          blurRadius: 24,
          offset: Offset(0, 10),
        ),
      ],
      homeTop: Color(0xFF0C1224),
      homeBottom: Color(0xFF070A16),
      homeCard: Color(0xFF141A2E),
      homeCardBorder: Color(0xFF262E48),
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
