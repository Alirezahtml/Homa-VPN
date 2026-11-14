import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/core_api.dart' show CoreApiException;
import '../core/core_controller.dart';
import '../core/models.dart';
import '../core/remote_flags.dart' show bundledFlags;
import '../l10n/app_localizations.dart';
import 'widgets.dart';

/// The home page's country wheel: the locations' flags in one horizontal,
/// draggable row, the chosen one larger in the middle, over a glass shelf
/// it reflects in, its name under it. The list is the core's real one
/// (Mozilla's server list), and choosing a country moves the VPN there —
/// the servers page follows, since it reads the same choice back.
///
/// The motion: the neighbors shrink and sink in an arc away from the
/// middle, each turned a few degrees toward it, so the row reads as a
/// wheel of flags in perspective; the middle's halo and glow breathe on
/// their own clock, even while the wheel rests.
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

class _FlagCarouselState extends State<FlagCarousel>
    with SingleTickerProviderStateMixin {
  List<Location>? _locations;
  PageController? _controller;
  bool _moving = false;

  /// The wheel's own slow breath (2.8 s out, 2.8 s back): the halo behind
  /// the chosen country and the glow on its card swell and shrink with
  /// it, so the wheel feels alive even while nothing is dragged.
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..repeat(reverse: true);

  /// The choice the core reports ('' recommended, 'fastest', or a code),
  /// lower-cased; the wheel keeps its page on it.
  String get _selection => (widget.core.status?.selection ?? '').toLowerCase();

  @override
  void initState() {
    super.initState();
    _load();
    widget.core.addListener(_followSoon);
    // The cards size themselves by their page's distance from the
    // middle, which the controller only knows once the page view has
    // laid out. At rest nothing scrolls and nothing notifies, so the
    // first build's fallback (all cards alike) would stay: rebuild after
    // the first frame, and the wheel reads as a wheel before any touch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    widget.core.removeListener(_followSoon);
    _controller?.dispose();
    _breath.dispose();
    super.dispose();
  }

  /// The first page of the wheel's middle copy: from there either end
  /// of the list is two whole copies away, so the drag never bumps into
  /// the wheel's ends.
  int _base(List<Location> entries) => entries.length * (_repeats ~/ 2);

  void _followSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _follow();
    });
  }

  Future<void> _load() async {
    try {
      final list = await widget.core.call((api) => api.locations());
      if (!mounted) return;
      // The wheel is built once the countries are here: it starts on the
      // core's own choice, in the middle copy, with the chosen country
      // centered (padEnds centers a page view's resting page).
      final l = AppLocalizations.of(context);
      final entries = _entriesFor(l, list.locations);
      final index = _indexOf(entries, _selection);
      _controller = PageController(
        viewportFraction: 0.26,
        initialPage: _base(entries) + (index < 0 ? 0 : index),
      );
      setState(() => _locations = list.locations);
    } on CoreApiException {
      // The servers page says why; the wheel stays empty until it answers.
    } on Exception {
      // The core is gone; the shell shows it.
    }
  }

  /// The locations in wheel order: Mozilla's recommended first (its own
  /// mark on the wheel), then the countries by name.
  List<Location> _entries(AppLocalizations l) =>
      _entriesFor(l, _locations ?? const <Location>[]);

  List<Location> _entriesFor(AppLocalizations l, List<Location> all) {
    final recommended = all.where((loc) => isRecommendedPlace(loc.code)).toList();
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
    final controller = _controller;
    if (controller == null) return;
    final l = AppLocalizations.of(context);
    final entries = _entries(l);
    if (entries.isEmpty || _moving || !controller.hasClients) return;
    final index = _indexOf(entries, _selection);
    if (index < 0) return;
    // The follow goes to the middle copy, so the wheel keeps its ends
    // out of reach from wherever it is followed to.
    final target = _base(entries) + index;
    final page = controller.page?.round() ?? -1;
    if (page != target) {
      _moving = true;
      controller
          .animateToPage(
            target,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() => _moving = false);
    }
  }

  Future<void> _choose(Location loc) async {
    // A small tick at the choice: the wheel says it heard the finger.
    HapticFeedback.selectionClick();
    // The recommended location is the empty choice; the rest are codes.
    final value = isRecommendedPlace(loc.code) ? '' : loc.code;
    await runShowingErrors(context, () => widget.core.setLocation(value));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = _entries(l);
    if (_locations == null || entries.isEmpty) {
      return const SizedBox(height: 152);
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
    final controller = _controller;
    if (controller == null) return const SizedBox(height: 152);
    return SizedBox(
      // The shelf and the halo breathe behind the chosen card, so the
      // wheel carries its own headroom below and above.
      height: 152,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // The halo: a very soft light behind the chosen country, in the
          // state's color, fading into the black theme — breathing on its
          // own clock, and following the wheel as it spins (it fades out
          // over the drag rather than smearing across it).
          AnimatedBuilder(
            animation: Listenable.merge([controller, _breath]),
            builder: (context, _) {
              final glow = _haloStrength();
              final breathe = _breath.value;
              return IgnorePointer(
                child: Transform.translate(
                  offset: Offset(0, -6 * (1.0 - glow)),
                  child: Transform.scale(
                    scale: 1.0 + 0.06 * breathe * glow,
                    child: Container(
                      width: 168 + 34 * glow + 10 * breathe * glow,
                      height: 96 + 20 * glow + 6 * breathe * glow,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accent.withValues(
                              alpha: (dark ? 0.22 : 0.15) * glow *
                                  (0.75 + 0.25 * breathe),
                            ),
                            accent.withValues(
                              alpha: (dark ? 0.10 : 0.06) * glow *
                                  (0.75 + 0.25 * breathe),
                            ),
                            accent.withValues(alpha: 0.0),
                          ],
                          stops: const [0, 0.55, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          PageView.builder(
            controller: controller,
            // The list repeats, so the wheel has no ends to bump into.
            // padEnds is what centers the resting page: the chosen flag
            // stands in the middle, its neighbors peeking on both sides.
            itemCount: entries.length * _repeats,
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
                animation: controller,
                builder: (context, _) {
                  // How far this page sits from the middle, in pages, and
                  // in which direction — the wheel's whole shape (size,
                  // dip, turn, dim) is a function of the two.
                  var distance = 1.0;
                  var side = 0.0;
                  if (controller.hasClients &&
                      controller.position.haveDimensions) {
                    final delta = (controller.page ?? page.toDouble()) - page;
                    distance = delta.abs().clamp(0.0, 2.5);
                    side = delta.sign;
                  }
                  return Center(
                    child: _FlagCard(
                      location: loc,
                      distance: distance,
                      side: side,
                      breath: _breath,
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
    final controller = _controller;
    if (controller == null ||
        !controller.hasClients ||
        !controller.position.haveDimensions) {
      return 0;
    }
    final page = controller.page ?? 0.0;
    return (1.0 - (page - page.roundToDouble()).abs() * 2).clamp(0.0, 1.0);
  }

  /// The chosen country's name under the flags, in white, arriving with a
  /// slide and a small growth; the fastest choice has no country, and
  /// keeps its own line empty rather than naming another.
  Widget _name(AppLocalizations l, Location? centered, bool dark) =>
      SizedBox(
        height: 32,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(anim),
              child: ScaleTransition(
                scale: Tween(begin: 0.94, end: 1.0).animate(anim),
                child: child,
              ),
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
              fontSize: 17,
              letterSpacing: 0.3,
            ),
          ),
        ),
      );
}

/// One card of the wheel. The chosen one, in the middle: bigger, inside a
/// glass frame with rounded corners and a fine glowing border, over a
/// shelf it faintly reflects in. The others: smaller cards that sink in
/// an arc and turn a few degrees toward the middle, each with a little
/// depth and less opacity, so the row reads as a wheel of flags.
class _FlagCard extends StatelessWidget {
  const _FlagCard({
    required this.location,
    required this.distance,
    required this.side,
    required this.breath,
    required this.accent,
    required this.dark,
    required this.border,
    required this.onTap,
  });

  final Location location;

  /// 0 in the middle, growing to 2.5 a few pages away.
  final double distance;

  /// -1 when this page sits left of the middle, +1 right of it, 0 unknown.
  final double side;

  /// The wheel's breath: only the chosen card moves with it.
  final Animation<double> breath;

  final Color accent;
  final bool dark;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chosen = distance < 0.5;
    // The size falls away from the middle exponentially, so the drop is
    // steep beside the chosen card and gentle far out: a wheel, not a
    // ladder.
    final width = 46.0 + 30.0 * math.exp(-1.35 * distance);
    final height = width * 3 / 4;
    final radius = 8.0 + 7.0 * math.exp(-1.35 * distance);
    // The arc: the neighbors sit a touch lower the further they are, so
    // the row bends like a wheel seen a little from above.
    final dip = 3.0 + 9.0 * math.min(1.0, distance);
    // The turn: the neighbors face the middle by a few degrees, in
    // perspective (a hair of it, not a cover flow).
    final turn = -0.07 * math.min(1.2, distance) * side;
    final scheme = Theme.of(context).colorScheme;

    final card = InkWell(
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
            width: chosen ? 1.6 : 0.7,
          ),
          boxShadow: chosen
              ? [
                  // The fine glow around the chosen flag, over a soft drop
                  // shadow; nothing louder, the theme stays black.
                  BoxShadow(
                    color: accent.withValues(alpha: dark ? 0.42 : 0.32),
                    blurRadius: 24,
                    spreadRadius: 1.5,
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
                    Colors.white.withValues(alpha: dark ? 0.22 : 0.28),
                    Colors.white.withValues(alpha: 0.03),
                  ]
                : [
                    Colors.white.withValues(alpha: dark ? 0.04 : 0.08),
                    Colors.black.withValues(alpha: dark ? 0.28 : 0.10),
                  ],
          ),
        ),
        child: Opacity(
          // The chosen one is fully there; the others step back.
          opacity: (1.0 - 0.34 * math.min(1.25, distance)).clamp(0.0, 1.0),
          child: _content(scheme, width),
        ),
      ),
    );

    if (!chosen) {
      return Padding(
        padding: EdgeInsets.only(top: dip),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(turn),
          child: card,
        ),
      );
    }

    // The chosen card: it breathes with the wheel's own clock, and sits
    // on a glass shelf — a faint reflection of the flag under it, fading
    // away within a few pixels.
    return AnimatedBuilder(
      animation: breath,
      builder: (context, _) => Transform.translate(
        offset: Offset(0, -2.5 * breath.value),
        child: Transform.scale(
          scale: 1.0 + 0.015 * breath.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              card,
              const SizedBox(height: 3),
              _Reflection(
                location: location,
                width: width,
                height: height * 0.42,
                scheme: scheme,
              ),
            ],
          ),
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

/// The glass shelf under the chosen flag: the flag again, mirrored and
/// faded to nothing within its own height — a whisper of a reflection,
/// not a second flag.
class _Reflection extends StatelessWidget {
  const _Reflection({
    required this.location,
    required this.width,
    required this.height,
    required this.scheme,
  });

  final Location location;
  final double width;
  final double height;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    Widget? art;
    final code = location.code;
    if (isRecommendedPlace(code)) {
      art = SvgPicture.asset(
        'assets/brand/mozilla_logo.svg',
        width: width * 0.30,
        height: height,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(
          scheme.onPrimaryContainer.withValues(alpha: 0.5),
          BlendMode.srcIn,
        ),
      );
    } else if (bundledFlags.contains(code.toLowerCase())) {
      art = SvgPicture.asset(
        'assets/flags/${code.toLowerCase()}.svg',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
    if (art == null) return const SizedBox.shrink();
    return SizedBox(
      width: width,
      height: height,
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromRGBO(255, 255, 255, 0.30), Color.fromRGBO(0, 0, 0, 0)],
        ).createShader(bounds),
        child: Transform(transform: Matrix4.identity()..scaleByDouble(1.0, -1.0, 1.0, 1.0), child: art),
      ),
    );
  }
}

/// How many copies of the wheel the page view carries, so either end can
/// still scroll: enough to reach either end from any start, then some.
const _repeats = 5;

/// The tiles' strip: the flags as small cards in one horizontal row, the
/// chosen one framed and named under the strip. The same real list and
/// the same choice as the wheel — the strip is the home page's other
/// design, where the flags stand in a row instead of turning.
class FlagStrip extends StatefulWidget {
  const FlagStrip({
    super.key,
    required this.core,
    required this.text,
    required this.border,
    required this.accent,
  });

  final CoreController core;
  final Color text;
  final Color border;
  final Color accent;

  @override
  State<FlagStrip> createState() => _FlagStripState();
}

class _FlagStripState extends State<FlagStrip> {
  List<Location>? _locations;
  final ScrollController _strip = ScrollController();
  bool _moving = false;

  String get _selection => (widget.core.status?.selection ?? '').toLowerCase();

  @override
  void initState() {
    super.initState();
    _load();
    widget.core.addListener(_followSoon);
  }

  @override
  void dispose() {
    widget.core.removeListener(_followSoon);
    _strip.dispose();
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
      // The servers page says why; the strip stays empty until it answers.
    } on Exception {
      // The core is gone; the shell shows it.
    }
  }

  List<Location> _entries(AppLocalizations l) {
    final all = _locations ?? const <Location>[];
    final recommended = all.where((loc) => isRecommendedPlace(loc.code)).toList();
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
    if (selection == 'fastest') return -1;
    if (selection.isEmpty) {
      return entries.indexWhere((loc) => isRecommendedPlace(loc.code));
    }
    return entries.indexWhere((loc) => loc.code.toLowerCase() == selection);
  }

  /// The width one tile takes with its gap beside it.
  static const _tileW = 62.0;

  void _follow() {
    final l = AppLocalizations.of(context);
    final entries = _entries(l);
    if (entries.isEmpty || _moving || !_strip.hasClients) return;
    final index = _indexOf(entries, _selection);
    if (index < 0) return;
    final width = _strip.position.viewportDimension;
    final target = (index * _tileW - width / 2 + _tileW / 2)
        .clamp(0.0, _strip.position.maxScrollExtent)
        .toDouble();
    if ((_strip.offset - target).abs() > 1) {
      _moving = true;
      _strip
          .animateTo(
            target,
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() => _moving = false);
    }
  }

  Future<void> _choose(Location loc) async {
    HapticFeedback.selectionClick();
    final value = isRecommendedPlace(loc.code) ? '' : loc.code;
    await runShowingErrors(context, () => widget.core.setLocation(value));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = _entries(l);
    if (_locations == null || entries.isEmpty) {
      return const SizedBox(height: 96);
    }
    final index = _indexOf(entries, _selection);
    final centered = index >= 0 ? entries[index] : null;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: ListView.separated(
            controller: _strip,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final loc = entries[i];
              final chosen = i == index;
              return _StripTile(
                location: loc,
                chosen: chosen,
                accent: widget.accent,
                dark: dark,
                border: widget.border,
                onTap: () => unawaited(_choose(loc)),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 26,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.4),
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
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One tile of the strip: a small glass card, framed and brighter when it
/// is the chosen country, sitting a shade dimmer otherwise.
class _StripTile extends StatelessWidget {
  const _StripTile({
    required this.location,
    required this.chosen,
    required this.accent,
    required this.dark,
    required this.border,
    required this.onTap,
  });

  final Location location;
  final bool chosen;
  final Color accent;
  final bool dark;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final w = chosen ? 52.0 : 46.0;
    final h = w * 3 / 4;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _FlagStripState._tileW - 10,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          width: w,
          height: h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: chosen
                  ? accent.withValues(alpha: 0.9)
                  : border.withValues(alpha: dark ? 0.5 : 0.45),
              width: chosen ? 1.4 : 0.7,
            ),
            boxShadow: chosen
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: dark ? 0.35 : 0.25),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: dark ? 0.4 : 0.14),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: chosen
                  ? [
                      Colors.white.withValues(alpha: dark ? 0.18 : 0.24),
                      Colors.white.withValues(alpha: 0.02),
                    ]
                  : [
                      Colors.white.withValues(alpha: dark ? 0.04 : 0.08),
                      Colors.black.withValues(alpha: dark ? 0.24 : 0.08),
                    ],
            ),
          ),
          child: Opacity(
            opacity: chosen ? 1.0 : 0.82,
            child: _content(scheme, w),
          ),
        ),
      ),
    );
  }

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
    return CountryFlag(code: code, width: width);
  }
}
