import 'package:flutter/material.dart';

import '../app_settings.dart';

/// The app's one design — the monochrome the app was drawn in.
///
/// The App Design picker (the soft neumorphism and the aurora glass
/// extracted from a reference app) has left: the looks it carried were
/// guests, and the app wears its own look again. What stays here is the
/// palette every page reads — the surfaces, the inks, the outlines of
/// both modes — so the pages keep one place where their colors live.
abstract final class AppDesign {
  /// The design for this build of the page, set once per build by
  /// [resolveFor] in the app's builder — the one place the design and
  /// the accent are decided together, so they never disagree.
  static DesignTheme current = DesignTheme.mono;

  /// Sets [current] (always the monochrome now) and returns the design's
  /// own accent, which is none: the user's own accent, or full contrast.
  static Color? resolveFor(AppSettings settings) {
    current = DesignTheme.mono;
    return null;
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

  /// The key that lives in code reads ('mono' — the one design).
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
