import 'package:flutter/material.dart';

import '../app_settings.dart';
import 'accent.dart';

/// The looks the whole app wears, one behind each home design.
///
/// A design is not only the home page's layout (that is the home design:
/// the wheel, the tiles, the compact card, and the four that joined them).
/// Each of the four new designs carries a complete palette of its own: the
/// surfaces, the inks, the outlines of both modes, and a light of its own —
/// the same palette every page reads, from the home to the dialogs to the
/// pill navigation. The three older homes keep the monochrome.
///
/// The palette reaches the theme in [App]'s builder through [resolveFor],
/// the one place the design and the accent are decided together, so they
/// never disagree.
abstract final class AppDesign {
  /// The design for this build of the page, set once per build by
  /// [resolveFor] in the app's builder.
  static DesignTheme current = DesignTheme.mono;

  /// The design a home design key asks for; the three older homes — and
  /// any key that is not one of the four — keep the monochrome.
  static DesignTheme resolve(String key) => switch (key) {
    'aurora' => DesignTheme.aurora,
    'neon' => DesignTheme.neon,
    'dusk' => DesignTheme.dusk,
    'sage' => DesignTheme.sage,
    _ => DesignTheme.mono,
  };

  /// Sets [current] from the home design the settings carry, and returns
  /// the light the app wears: the user's own accent when they picked one,
  /// else the design's own light — the four designs each carry one. The
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

  /// The aurora glass: the northern lights' palette — the deep blue of
  /// the polar night, the icy porcelain of the day, and the teal light
  /// the sky carries. The home's hero wears the light as a wash.
  static const aurora = DesignTheme._(
    key: 'aurora',
    day: DesignLook(
      scaffold: Color(0xFFF1F6FA),
      scaffoldBottom: Color(0xFFE9F0F6),
      surface: Colors.white,
      surfaceHigh: Color(0xFFF5F9FC),
      containerHighest: Color(0xFFEEF4F9),
      ink: Color(0xFF10202F),
      muted: Color(0xFF5C7288),
      outline: Color(0xFFD8E4EE),
      accent: Color(0xFF0D9488),
      cardShadow: [],
      homeTop: Color(0xFFF4F8FB),
      homeBottom: Color(0xFFE9F0F6),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFDCE7F0),
    ),
    night: DesignLook(
      scaffold: Color(0xFF070D16),
      scaffoldBottom: Color(0xFF050A11),
      surface: Color(0xFF0C1522),
      surfaceHigh: Color(0xFF101B2C),
      containerHighest: Color(0xFF0E1826),
      ink: Color(0xFFE8F0FA),
      muted: Color(0xFF8FA3BC),
      outline: Color(0xFF1D2C42),
      accent: Color(0xFF2DD4BF),
      cardShadow: [],
      homeTop: Color(0xFF060C14),
      homeBottom: Color(0xFF040910),
      homeCard: Color(0xFF0D1725),
      homeCardBorder: Color(0xFF1C2B40),
    ),
  );

  /// The neon night: the near-black with a violet cast, the lilac ink of
  /// the day, and the fuchsia light — a look that reads like the city
  /// after dark.
  static const neon = DesignTheme._(
    key: 'neon',
    day: DesignLook(
      scaffold: Color(0xFFFBF7FE),
      scaffoldBottom: Color(0xFFF5EEFB),
      surface: Colors.white,
      surfaceHigh: Color(0xFFF7F1FC),
      containerHighest: Color(0xFFF3EBFA),
      ink: Color(0xFF1D1026),
      muted: Color(0xFF6E5B85),
      outline: Color(0xFFE8DDF2),
      accent: Color(0xFFC026D3),
      cardShadow: [],
      homeTop: Color(0xFFFCF8FE),
      homeBottom: Color(0xFFF5EEFB),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFEBDFF4),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0B060F),
      scaffoldBottom: Color(0xFF080410),
      surface: Color(0xFF140B1E),
      surfaceHigh: Color(0xFF1B0F28),
      containerHighest: Color(0xFF170C22),
      ink: Color(0xFFF4EAFB),
      muted: Color(0xFFA58FC0),
      outline: Color(0xFF2A1838),
      accent: Color(0xFFE879F9),
      cardShadow: [],
      homeTop: Color(0xFF0A0510),
      homeBottom: Color(0xFF070310),
      homeCard: Color(0xFF130A1C),
      homeCardBorder: Color(0xFF251434),
    ),
  );

  /// The sunset dusk: the warm charcoal of the hour after sunset, the
  /// cream of the day, and the amber light — the palette of the horizon
  /// when the sun has just gone.
  static const dusk = DesignTheme._(
    key: 'dusk',
    day: DesignLook(
      scaffold: Color(0xFFFAF5EF),
      scaffoldBottom: Color(0xFFF3EBE1),
      surface: Colors.white,
      surfaceHigh: Color(0xFFF8F2EA),
      containerHighest: Color(0xFFF5EDE3),
      ink: Color(0xFF2A1B0E),
      muted: Color(0xFF7A6753),
      outline: Color(0xFFEAE0D2),
      accent: Color(0xFFD97706),
      cardShadow: [],
      homeTop: Color(0xFFFBF7F1),
      homeBottom: Color(0xFFF3EBE1),
      homeCard: Color(0xFFFFFDFB),
      homeCardBorder: Color(0xFFEDE3D6),
    ),
    night: DesignLook(
      scaffold: Color(0xFF0D0A08),
      scaffoldBottom: Color(0xFF0A0705),
      surface: Color(0xFF181210),
      surfaceHigh: Color(0xFF201713),
      containerHighest: Color(0xFF1B1410),
      ink: Color(0xFFF6EDE4),
      muted: Color(0xFFB3A190),
      outline: Color(0xFF2E221A),
      accent: Color(0xFFFBBF24),
      cardShadow: [],
      homeTop: Color(0xFF0C0907),
      homeBottom: Color(0xFF090604),
      homeCard: Color(0xFF171009),
      homeCardBorder: Color(0xFF2B2015),
    ),
  );

  /// The botanic sage: the deep green of a forest at night, the morning
  /// garden of the day, and the leaf light — the calmest of the four.
  static const sage = DesignTheme._(
    key: 'sage',
    day: DesignLook(
      scaffold: Color(0xFFF3F9F4),
      scaffoldBottom: Color(0xFFE9F2EB),
      surface: Colors.white,
      surfaceHigh: Color(0xFFF2F8F3),
      containerHighest: Color(0xFFEDF5EF),
      ink: Color(0xFF122418),
      muted: Color(0xFF5E7A66),
      outline: Color(0xFFD9E8DD),
      accent: Color(0xFF16A34A),
      cardShadow: [],
      homeTop: Color(0xFFF5FAF6),
      homeBottom: Color(0xFFE9F2EB),
      homeCard: Color(0xFFFFFFFF),
      homeCardBorder: Color(0xFFDFECE2),
    ),
    night: DesignLook(
      scaffold: Color(0xFF081009),
      scaffoldBottom: Color(0xFF060C07),
      surface: Color(0xFF0E1911),
      surfaceHigh: Color(0xFF14231A),
      containerHighest: Color(0xFF101F14),
      ink: Color(0xFFE6F2E9),
      muted: Color(0xFF95AFA0),
      outline: Color(0xFF1D3024),
      accent: Color(0xFF4ADE80),
      cardShadow: [],
      homeTop: Color(0xFF07110B),
      homeBottom: Color(0xFF050A06),
      homeCard: Color(0xFF0D1810),
      homeCardBorder: Color(0xFF1C2E22),
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
