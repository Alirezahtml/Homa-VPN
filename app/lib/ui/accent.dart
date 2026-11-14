import 'package:flutter/material.dart';

import '../app_settings.dart';

/// The app's accent, the one personalization the design keeps: the
/// monochrome look stays (surfaces, ink, borders), and the user's color
/// takes the lights — the connected state, the buttons, the sliders' fill.
/// Empty (the default) is the monochrome design itself: white on the
/// night, black on the day.
abstract final class AppAccent {
  /// The chosen accent for this build of the page, or null for the
  /// monochrome design. Set once per build by [resolve].
  static Color? current;

  /// The curated accents, in menu order: the key goes into the settings,
  /// the colors read on both the black night and the white day.
  static const List<(String, Color)> presets = [
    ('ember', Color(0xFFFF7A45)),
    ('gold', Color(0xFFF2B33D)),
    ('emerald', Color(0xFF3ECF8E)),
    ('sapphire', Color(0xFF5B9DFF)),
    ('amethyst', Color(0xFFA78BFA)),
    ('rose', Color(0xFFFB7185)),
  ];

  /// The accent a [settings] asks for: null for the monochrome design.
  static Color? resolve(AppSettings settings) {
    if (settings.accentKey == 'custom') {
      return Color(settings.customAccent);
    }
    for (final (key, color) in presets) {
      if (key == settings.accentKey) return color;
    }
    return null;
  }

  /// The ink that reads on [accent]: black on the bright accents, white on
  /// the deep ones — for the text inside a filled button or knob.
  static Color onAccent(Color accent) =>
      accent.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

/// Returns [color] pushed toward [blend]'s brightness, so an accent reads
/// the same in both themes without losing its hue.
Color accentForTheme(Color color, bool dark) {
  final base = dark ? Colors.white : Colors.black;
  return Color.lerp(color, base, dark ? 0.08 : 0.14)!;
}
