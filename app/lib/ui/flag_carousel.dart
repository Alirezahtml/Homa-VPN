import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/core_api.dart' show CoreApiException;
import '../core/core_controller.dart';
import '../core/models.dart';
import '../core/remote_flags.dart' show bundledFlags;
import '../l10n/app_localizations.dart';
import 'widgets.dart';

/// The home page's country wheel: the locations' flags in one horizontal,
/// draggable row, the chosen one larger in the middle and its name under
/// it. The list is the core's real one (Mozilla's server list), and
/// choosing a country moves the VPN there — the servers page follows,
/// since it reads the same choice back.
class FlagCarousel extends StatefulWidget {
  const FlagCarousel({
    super.key,
    required this.core,
    required this.text,
    required this.muted,
    required this.card,
    required this.border,
    required this.accent,
    this.onOpenServers,
  });

  final CoreController core;
  final Color text;
  final Color muted;
  final Color card;
  final Color border;
  final Color accent;
  final VoidCallback? onOpenServers;

  @override
  State<FlagCarousel> createState() => _FlagCarouselState();
}

class _FlagCarouselState extends State<FlagCarousel> {
  List<Location>? _locations;
  late final PageController _controller;
  bool _moving = false;

  /// The choice the core reports ('' recommended, 'fastest', or a code),
  /// lower-cased; the wheel keeps its page on it.
  String get _selection => (widget.core.status?.selection ?? '').toLowerCase();

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.24);
    _load();
    widget.core.addListener(_followSoon);
  }

  @override
  void dispose() {
    widget.core.removeListener(_followSoon);
    _controller.dispose();
    super.dispose();
  }

  void _followSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _follow();
    });
  }

  Future<void> _load() async {
    try {
      final list = await widget.core.call((api) => api.locations());
      if (!mounted) return;
      setState(() => _locations = list.locations);
      _followSoon();
    } on CoreApiException {
      // The servers page says why; the wheel stays empty until it answers.
    } on Exception {
      // The core is gone; the shell shows it.
    }
  }

  /// The locations in wheel order: Mozilla's recommended first (its own
  /// mark on the wheel), then the countries by name.
  List<Location> _entries(AppLocalizations l) {
    final all = _locations ?? const <Location>[];
    final recommended = all
        .where((loc) => isRecommendedPlace(loc.code))
        .toList();
    final countries = [
      for (final loc in all)
        if (!isRecommendedPlace(loc.code)) loc,
    ]..sort(
      (a, b) => nameSortKey(
        l.localeName,
        locationName(l, a.code, a.name),
      ).compareTo(nameSortKey(l.localeName, locationName(l, b.code, b.name))),
    );
    return [...recommended, ...countries];
  }

  int _indexOf(List<Location> entries, String selection) {
    if (selection == 'fastest') return -1; // no country owns this choice
    if (selection.isEmpty) {
      return entries.indexWhere((loc) => isRecommendedPlace(loc.code));
    }
    return entries.indexWhere((loc) => loc.code.toLowerCase() == selection);
  }

  /// Moves the wheel to the page of the core's current choice, when the
  /// choice changed somewhere else (the servers page, a reconnect).
  void _follow() {
    final l = AppLocalizations.of(context);
    final entries = _entries(l);
    if (entries.isEmpty || _moving || !_controller.hasClients) return;
    final index = _indexOf(entries, _selection);
    if (index < 0) return;
    final page = _controller.page?.round() ?? -1;
    if (page != index) {
      _moving = true;
      _controller
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() => _moving = false);
    }
  }

  Future<void> _choose(Location loc) async {
    // The recommended location is the empty choice; the rest are codes.
    final value = isRecommendedPlace(loc.code) ? '' : loc.code;
    await runShowingErrors(context, () => widget.core.setLocation(value));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = _entries(l);
    if (_locations == null || entries.isEmpty) {
      return const SizedBox(height: 132);
    }
    final index = _indexOf(entries, _selection);
    final centered = index >= 0 ? entries[index] : null;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [_wheel(entries, dark), _name(l, centered, dark)],
    );
  }

  Widget _wheel(List<Location> entries, bool dark) {
    final accent = widget.accent;
    return SizedBox(
      // The halo breathes behind the chosen card, so it needs headroom.
      height: 116,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // The halo: a very soft light behind the chosen country, in the
          // state's color, fading into the black theme.
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final glow = _haloStrength();
              return IgnorePointer(
                child: Container(
                  width: 150 + 26 * glow,
                  height: 86 + 16 * glow,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withValues(alpha: (dark ? 0.20 : 0.13) * glow),
                        accent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          PageView.builder(
            controller: _controller,
            // The list repeats, so the wheel has no ends to bump into.
            itemCount: entries.length * _repeats,
            padEnds: false,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (page) {
              final loc = entries[page % entries.length];
              final chosen = isRecommendedPlace(loc.code)
                  ? ''
                  : loc.code.toLowerCase();
              if (!_moving && chosen != _selection) {
                unawaited(_choose(loc));
              }
            },
            itemBuilder: (context, page) {
              final loc = entries[page % entries.length];
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  // How close this page sits to the middle: the middle one
                  // is full size, its neighbors shrink away.
                  var distance = 1.0;
                  if (_controller.hasClients &&
                      _controller.position.haveDimensions) {
                    distance = ((_controller.page ?? page.toDouble()) - page)
                        .abs()
                        .clamp(0.0, 1.0);
                  }
                  return Center(
                    child: _FlagCard(
                      location: loc,
                      distance: distance,
                      accent: accent,
                      dark: dark,
                      border: widget.border,
                      onTap: () => unawaited(_choose(loc)),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// 1 while the wheel rests on a country, fading to 0 while it spins, so
  /// the halo follows the chosen card instead of smearing over the drag.
  double _haloStrength() {
    if (!_controller.hasClients || !_controller.position.haveDimensions) {
      return 0;
    }
    final page = _controller.page ?? 0.0;
    return (1.0 - (page - page.roundToDouble()).abs() * 2).clamp(0.0, 1.0);
  }

  /// The chosen country's name under the flags, in white, arriving with a
  /// slide; the fastest choice has no country, and keeps its own line
  /// empty rather than naming another.
  Widget _name(AppLocalizations l, Location? centered, bool dark) =>
      SizedBox(
        height: 30,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.45),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: Text(
            centered == null
                ? (_selection == 'fastest' ? l.modeFastest : '')
                : locationName(l, centered.code, centered.name),
            key: ValueKey(centered?.code ?? _selection),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? Colors.white : widget.text,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.2,
            ),
          ),
        ),
      );
}

/// One card of the wheel. The chosen one, in the middle: bigger, inside a
/// glass frame with rounded corners and a fine glowing border. The others:
/// smaller cards with a little depth and less opacity, so the row reads
/// like a wheel of flags.
class _FlagCard extends StatelessWidget {
  const _FlagCard({
    required this.location,
    required this.distance,
    required this.accent,
    required this.dark,
    required this.border,
    required this.onTap,
  });

  final Location location;

  /// 0 in the middle, 1 at a full page away.
  final double distance;
  final Color accent;
  final bool dark;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chosen = distance < 0.5;
    final width = 66.0 - 18.0 * distance;
    final height = width * 3 / 4;
    final radius = 13.0 - 3.0 * distance;
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: chosen
                ? accent.withValues(alpha: 0.95)
                : border.withValues(alpha: dark ? 0.6 : 0.5),
            width: chosen ? 1.5 : 0.7,
          ),
          boxShadow: chosen
              ? [
                  // The fine glow around the chosen flag, over a soft drop
                  // shadow; nothing louder, the theme stays black.
                  BoxShadow(
                    color: accent.withValues(alpha: dark ? 0.40 : 0.30),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.55 : 0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  // Depth for the smaller cards: they float a little
                  // lower than the chosen one.
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.45 : 0.16),
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        // The glass: a light sweep on the chosen card, a darker one on the
        // neighbors, so the row carries depth without leaving the theme.
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: chosen
                ? [
                    Colors.white.withValues(alpha: dark ? 0.20 : 0.26),
                    Colors.white.withValues(alpha: 0.02),
                  ]
                : [
                    Colors.white.withValues(alpha: dark ? 0.04 : 0.08),
                    Colors.black.withValues(alpha: dark ? 0.28 : 0.10),
                  ],
          ),
        ),
        child: Opacity(
          // The chosen one is fully there; the others step back.
          opacity: 1.0 - 0.30 * distance,
          child: _content(scheme, width),
        ),
      ),
    );
  }

  /// The card's content, full bleed: a real country's flag, or Mozilla's
  /// own mark on its tile for the recommended location — the corners as
  /// rounded as the flags' card.
  Widget _content(ColorScheme scheme, double width) {
    final code = location.code;
    if (isRecommendedPlace(code)) {
      return Container(
        color: scheme.primaryContainer,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/brand/mozilla_logo.svg',
          width: width * 0.30,
          height: width * 0.34,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            scheme.onPrimaryContainer,
            BlendMode.srcIn,
          ),
        ),
      );
    }
    if (bundledFlags.contains(code.toLowerCase())) {
      return SvgPicture.asset(
        'assets/flags/${code.toLowerCase()}.svg',
        width: width,
        height: width * 3 / 4,
        fit: BoxFit.cover,
      );
    }
    // Not carried: from the core, the code until it arrives.
    return CountryFlag(code: code, width: width);
  }
}

/// How many copies of the wheel the page view carries, so either end can
/// still scroll: enough to reach either end from any start, then some.
const _repeats = 5;
