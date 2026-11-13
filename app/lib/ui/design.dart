/// Homa's design system: pure black and white, neutral grays only.
///
/// The whole app shares one palette in both themes: dark is black,
/// light is white, and every shade between them is neutral gray. No hue
/// anywhere; states (connected, waiting, error) differ by contrast, weight
/// and an icon, never by color.
///
/// The grid the pages follow: page margin 20 on a phone and 28 on a wide
/// window, 12 between cards, 16 inside a card, 24 between the page's
/// sections.
library;

import 'package:flutter/material.dart';

/// The palette and the shapes every page builds with.
abstract final class Homa {
  // The dark theme: black, with gray surfaces lifted off it.
  static const black = Color(0xFF000000);
  static const cardDark = Color(0xFF151515);
  static const cardAltDark = Color(0xFF1F1F1F);
  static const borderDark = Color(0xFF292929);
  static const borderStrongDark = Color(0xFF3F3F3F);

  // The light theme: white, with gray surfaces pressed into it.
  static const white = Color(0xFFFFFFFF);
  static const cardLight = Color(0xFFFFFFFF);
  static const cardAltLight = Color(0xFFF1F1F1);
  static const borderLight = Color(0xFFE8E8E8);
  static const borderStrongLight = Color(0xFFCFCFCF);

  // Text, in both themes.
  static const inkDark = Color(0xFFFFFFFF);
  static const mutedDark = Color(0xFF9E9E9E);
  static const faintDark = Color(0xFF6E6E6E);
  static const inkLight = Color(0xFF0A0A0A);
  static const mutedLight = Color(0xFF5E5E5E);
  static const faintLight = Color(0xFF9C9C9C);

  /// The page's ink (text and the strongest surface): white at night,
  /// near-black in the day.
  static Color ink(bool dark) => dark ? inkDark : inkLight;

  /// The ink on top of a filled-ink surface (the big button when it is
  /// off): black at night, white in the day.
  static Color onInk(bool dark) => dark ? black : white;

  /// Secondary text.
  static Color muted(bool dark) => dark ? mutedDark : mutedLight;

  /// The faintest text and the quietest icons.
  static Color faint(bool dark) => dark ? faintDark : faintLight;

  /// A card's fill, on the page's background.
  static Color card(bool dark) => dark ? cardDark : cardLight;

  /// A card raised one step (a row inside a card, a chip).
  static Color cardAlt(bool dark) => dark ? cardAltDark : cardAltLight;

  /// A card's hairline border.
  static Color border(bool dark) => dark ? borderDark : borderLight;

  /// A stronger border: the focus of a control.
  static Color borderStrong(bool dark) =>
      dark ? borderStrongDark : borderStrongLight;

  // Shapes.
  static const radiusCard = 24.0;
  static const radiusTile = 18.0;
  static const radiusBox = 14.0;
  static const radiusPill = 999.0;

  // The spacing grid.
  static const gap1 = 4.0;
  static const gap2 = 8.0;
  static const gap3 = 12.0;
  static const gap4 = 16.0;
  static const gap5 = 20.0;
  static const gap6 = 24.0;

  /// The margin around a page's content.
  static EdgeInsets pagePadding(bool wide) =>
      EdgeInsets.fromLTRB(wide ? 28 : 20, 16, wide ? 28 : 20, 24);
}

/// The ambient brightness, set by the app's theme builder whenever it
/// builds the theme: the status inks below read it, so a `StatusColors.good`
/// anywhere in a build resolves to the current theme's ink without passing
/// a context around. There is one window and one theme at a time, so one
/// value serves the whole app.
Brightness _ambient = Brightness.light;

set ambientInk(Brightness brightness) => _ambient = brightness;

/// Whether the app is dark right now, by the theme it last built.
bool get isDarkInk => _ambient == Brightness.dark;

/// The connection's states, in ink: full contrast for connected and for
/// error (an error always travels with a warning icon and its own box),
/// softer for waiting, faintest for off.
abstract final class HomaState {
  /// Connected, working.
  static Color good(bool dark) => Homa.ink(dark);

  /// Connecting, waiting, a soft warning.
  static Color busy(bool dark) =>
      dark ? const Color(0xFFBDBDBD) : const Color(0xFF6B6B6B);

  /// An error: full contrast; the warning icon beside it tells the kind.
  static Color bad(bool dark) => Homa.ink(dark);

  /// Off, or nothing to say.
  static Color idle(bool dark) => Homa.faint(dark);
}

/// A state dot: filled when connected, hollow otherwise; it pulses softly
/// while connecting.
class StateDot extends StatelessWidget {
  const StateDot({super.key, required this.dark, this.kind = StateKind.idle});

  final bool dark;

  /// Which ink the dot carries.
  final StateKind kind;

  @override
  Widget build(BuildContext context) {
    final color = switch (kind) {
      StateKind.good => HomaState.good(dark),
      StateKind.busy => HomaState.busy(dark),
      StateKind.bad => HomaState.bad(dark),
      StateKind.idle => HomaState.idle(dark),
    };
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kind == StateKind.good ? color : Colors.transparent,
        border: kind == StateKind.good ? null : Border.all(color: color, width: 1.6),
      ),
    );
  }
}

enum StateKind { good, busy, bad, idle }

/// One of the home page's rounded cards: [Homa.radiusCard] corners, the
/// card's fill, its hairline border, and a press that sinks a touch.
class HomaCard extends StatelessWidget {
  const HomaCard({
    super.key,
    required this.child,
    this.onTap,
    this.dark = false,
    this.padding = const EdgeInsets.all(Homa.gap4),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool dark;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Material(
    color: Homa.card(dark),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Homa.radiusCard),
      side: BorderSide(color: Homa.border(dark)),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}
