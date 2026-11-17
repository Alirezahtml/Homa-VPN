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
import 'sound.dart' show AppSounds, SoundCue;
import 'widgets.dart';

/// The home page's country wheel: the locations' flags in one horizontal,
/// draggable row, the chosen one larger in the middle, over a glass shelf
/// it reflects in — the chosen country's own name lives on the globe's
/// floating card, so the wheel carries no second copy of it. The list is
/// the core's real one (Mozilla's server list), and choosing a country
/// moves the VPN there — the servers page follows, since it reads the
/// same choice back.
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
    this.onOpenServers,
    this.animated = false,
    this.still = false,
    this.showName = false,
    this.favorites = const [],
    this.onToggleFavorite,
  });

  final CoreController core;
  final Color text;
  final Color muted;
  final Color card;
  final Color border;
  final VoidCallback? onOpenServers;

  /// The connection's own wish: the wheel's glow breathes while the VPN
  /// carries the traffic (or is making its way up), and holds one pose
  /// when it is off — an endless animation redraws every frame, and the
  /// phone's battery pays for a light nobody is watching.
  final bool animated;

  /// The battery saver's word: the wheel's glow rests — the halo and the
  /// shelf hold one pose — while the flags themselves still answer the
  /// hand. Nothing the choosing needs is touched.
  final bool still;

  /// Whether the chosen country's name shows under the wheel: the flat
  /// map kinds carry it there, where no floating card names the country;
  /// the ball kinds name it on their own card, so the wheel carries no
  /// second copy of it for them.
  final bool showName;

  /// The countries the user pinned: they lead the wheel and wear a star.
  final List<String> favorites;

  /// Long-pressing a country's card pins or unpins it. Null (a place
  /// without the settings at hand) keeps the press quiet.
  final void Function(String code)? onToggleFavorite;

  @override
  State<FlagCarousel> createState() => _FlagCarouselState();
}

class _FlagCarouselState extends State<FlagCarousel>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<Location>? _locations;
  PageController? _controller;
  bool _moving = false;

  /// The page the landing spring last played for, so it plays once per
  /// arrival, not on every scroll tick.
  int _lastSpring = -1;

  /// The choice's landing: one short swell when another country arrives
  /// at the middle — the card rises past its size, holds a beat, and
  /// eases back — the wheel says “this one” instead of only stopping.
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
  );
  late final Animation<double> _settlePulse = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 38,
    ),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 14),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: 0.0,
      ).chain(CurveTween(curve: Curves.easeInOutCubic)),
      weight: 48,
    ),
  ]).animate(_settle);

  /// The wheel's own slow breath (2.8 s out, 2.8 s back): the halo behind
  /// the chosen country and the glow on its card swell and shrink with
  /// it, so the wheel feels alive even while nothing is dragged. It waits
  /// for [initState] to say whether it may run — the battery saver holds
  /// it still.
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  /// The choice the core reports ('' recommended, 'fastest', or a code),
  /// lower-cased; the wheel keeps its page on it.
  String get _selection => (widget.core.status?.selection ?? '').toLowerCase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    widget.core.addListener(_followSoon);
    _setBreathing();
    // The cards size themselves by their page's distance from the
    // middle, which the controller only knows once the page view has
    // laid out. At rest nothing scrolls and nothing notifies, so the
    // first build's fallback (all cards alike) would stay: rebuild after
    // the first frame, and the wheel reads as a wheel before any touch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  /// Whether the wheel's own glow should breathe: the connection's wish
  /// first — nothing breathes while the VPN is off — then the battery
  /// saver's veto.
  bool get _breathWanted => widget.animated && !widget.still;

  void _setBreathing() {
    if (_breathWanted) {
      if (!_breath.isAnimating) _breath.repeat(reverse: true);
    } else {
      _breath.stop();
    }
  }

  @override
  void didUpdateWidget(FlagCarousel old) {
    super.didUpdateWidget(old);
    if (old.still != widget.still || old.animated != widget.animated) {
      _setBreathing();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A hidden window stops the breath: an endless animation redraws
    // every frame, and the orb's own note says one of those kept a CPU
    // core busy even with the window hidden in the tray.
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _breath.stop();
    } else if (state == AppLifecycleState.resumed) {
      _setBreathing();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.core.removeListener(_followSoon);
    _controller?.dispose();
    _breath.dispose();
    _settle.dispose();
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
      // One breath later, one more pass: the first frame lays the page
      // view out, but the cards read their size and fade from the
      // controller's page, which has no dimensions until the layout is
      // done — left alone, the wheel would sit on that first answer,
      // every card equal-sized and the outermost cut by the screen's
      // edge, until something else repainted.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
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
    final recommended = all
        .where((loc) => isRecommendedPlace(loc.code))
        .toList();
    final countries =
        [
          for (final loc in all)
            if (!isRecommendedPlace(loc.code)) loc,
        ]..sort(
          (a, b) => nameSortKey(l.localeName, locationName(l, a.code, a.name))
              .compareTo(
                nameSortKey(l.localeName, locationName(l, b.code, b.name)),
              ),
        );
    final favorites = [
      for (final code in widget.favorites)
        for (final loc in countries)
          if (loc.code.toLowerCase() == code.toLowerCase()) loc,
    ];
    final rest = [
      for (final loc in countries)
        if (!favorites.any(
          (f) => f.code.toLowerCase() == loc.code.toLowerCase(),
        ))
          loc,
    ];
    return [...recommended, ...favorites, ...rest];
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
      // The wheel followed a choice made somewhere else: its arrival
      // lands with the same spring a drag's does.
      if (target != _lastSpring) {
        _lastSpring = target;
        _settle.forward(from: 0);
      }
    }
  }

  Future<void> _choose(Location loc) async {
    // A small tick at the choice: the wheel says it heard the finger.
    HapticFeedback.selectionClick();
    AppSounds.play(SoundCue.tap);
    // The recommended location is the empty choice; the rest are codes.
    final value = isRecommendedPlace(loc.code) ? '' : loc.code;
    await runShowingErrors(context, () => widget.core.setLocation(value));
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries(AppLocalizations.of(context));
    if (_locations == null || entries.isEmpty) {
      // No countries yet: the wheel keeps its own room while the core
      // answers, the name's seat with it.
      return SizedBox(height: widget.showName ? 226 : 190);
    }
    final l = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final index = _indexOf(entries, _selection);
    final centered = index >= 0 ? entries[index] : null;
    return Column(
      children: [
        _wheel(entries, dark),
        // The position markers ride up toward the flags: tucked into the
        // wheel's own shelf, a breath under the chosen card, so the lit
        // pill reads as part of the flags it points at, not a row under
        // them.
        Transform.translate(
          offset: const Offset(0, -24),
          child: _indicators(entries, dark),
        ),
        // The chosen country's name under the flags — only where the
        // home's map is one of the flat kinds, which have no floating
        // card of their own to say it.
        if (widget.showName) _name(l, centered, dark),
      ],
    );
  }

  Widget _wheel(List<Location> entries, bool dark) {
    final controller = _controller;
    if (controller == null) return const SizedBox(height: 178);
    return SizedBox(
      // The halo and the shelf breathe behind the chosen card, so the
      // wheel carries its own headroom below and above. The whole wheel
      // fades out toward the screen's own edges — the last thing a flag
      // meets is a dissolve, never the viewport's hard cut.
      height: 178,
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(255, 255, 255, 0),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 0),
          ],
          stops: [0, 0.065, 0.935, 1],
        ).createShader(bounds),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // The halo: a soft blue light behind the chosen country — the
            // wheel's own aurora, breathing on its own clock, and following
            // the wheel as it spins (it fades out over the drag rather than
            // smearing across it).
            AnimatedBuilder(
              animation: Listenable.merge([controller, _breath]),
              builder: (context, _) {
                final glow = _haloStrength();
                final breathe = _breath.value;
                final blue = _FlagCard.glowBlue(dark);
                return IgnorePointer(
                  child: Transform.translate(
                    offset: Offset(0, -8 * (1.0 - glow)),
                    child: Transform.scale(
                      scale: 1.0 + 0.07 * breathe * glow,
                      child: Container(
                        width: 236 + 30 * glow + 12 * breathe * glow,
                        height: 142 + 20 * glow + 8 * breathe * glow,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              blue.withValues(
                                alpha:
                                    (dark ? 0.40 : 0.22) *
                                    glow *
                                    (0.75 + 0.25 * breathe),
                              ),
                              blue.withValues(
                                alpha:
                                    (dark ? 0.16 : 0.09) *
                                    glow *
                                    (0.75 + 0.25 * breathe),
                              ),
                              blue.withValues(alpha: 0.0),
                            ],
                            stops: const [0, 0.5, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // The page view itself never clips: the dissolve above does
            // the edge work, and every flag leaves whole.
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
                // A new country at the middle lands with its spring.
                if (page != _lastSpring) {
                  _lastSpring = page;
                  _settle.forward(from: 0);
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
                        settle: _settlePulse,
                        dark: dark,
                        border: widget.border,
                        // The card never grows past its own page's slot: a
                        // narrow window shrinks the whole wheel instead of
                        // letting the chosen flag ride over its neighbors.
                        slot:
                            controller.hasClients &&
                                controller.position.haveDimensions
                            ? controller.position.viewportDimension * 0.26 - 6
                            : 100.0,
                        onTap: () => unawaited(_choose(loc)),
                        onLongPress: widget.onToggleFavorite == null
                            ? null
                            : () => widget.onToggleFavorite!(loc.code),
                        favorite: widget.favorites.any(
                          (code) =>
                              code.toLowerCase() == loc.code.toLowerCase(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
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

  /// The position markers under the wheel: one dot per country, in a
  /// sliding window when the list is long, the chosen one a lit pill of
  /// the wheel's own blue — the carousel's quiet “you are here”.
  Widget _indicators(List<Location> entries, bool dark) {
    final controller = _controller;
    if (controller == null) return const SizedBox(height: 10);
    const maxDots = 9;
    return SizedBox(
      height: 12,
      child: Directionality(
        // The wheel's pages run one way whatever the language reads:
        // the dots keep the same order, so the pill travels with the
        // drag, not against it.
        textDirection: TextDirection.ltr,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final count = entries.length;
            if (count == 0) return const SizedBox.shrink();
            final page =
                controller.hasClients && controller.position.haveDimensions
                ? (controller.page ?? 0.0)
                : _base(entries).toDouble();
            final active = page.round() % count;
            final window = math.min(count, maxDots);
            final start = (active - window ~/ 2).clamp(0, count - window);
            final blue = _FlagCard.glowBlue(dark);
            final ink = dark ? Colors.white : const Color(0xFF0A0A0A);
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = start; i < start + window; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: i == active ? 18 : 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: i == active
                            ? blue
                            : ink.withValues(
                                alpha: (i - active).abs() <= 1 ? 0.30 : 0.13,
                              ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: i == active
                            ? [
                                BoxShadow(
                                  color: blue.withValues(
                                    alpha: dark ? 0.50 : 0.35,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : const [],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// The chosen country's name under the flags, arriving with a soft
  /// rise and a settled growth — never a pop: the old word fades out
  /// where it stands while the new one rises into its place, so the
  /// change reads as one name turning into another.
  Widget _name(AppLocalizations l, Location? centered, bool dark) => SizedBox(
    // The name's seat now carries the capsule's own padding too: a
    // breath taller than the bare word ever needed.
    height: 42,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 340),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.35),
            end: Offset.zero,
          ).animate(anim),
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(anim),
            child: child,
          ),
        ),
      ),
      layoutBuilder: (current, previous) =>
          Stack(alignment: Alignment.center, children: [...previous, ?current]),
      child: StatusCapsule(
        dark: dark,
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
    ),
  );
}

/// One card of the wheel. The chosen one, in the middle: bigger and the
/// wheel's whole point — a glass frame around the flag, the frame's own
/// blue glow breathing behind it, over a shelf it faintly reflects in.
/// The others: clearly smaller cards that sink in an arc and turn a few
/// degrees toward the middle, each with a little depth and less opacity,
/// so the row reads as a wheel of flags with one lit at its center.
///
/// The card shows the flag whole: its frame is the flag's own 3:2, so no
/// country loses its edge to a crop. A card a few pages out fades away
/// before it reaches the screen's edge — the wheel never hands the user
/// half a flag — and the chosen one lands with a short spring.
class _FlagCard extends StatelessWidget {
  const _FlagCard({
    required this.location,
    required this.distance,
    required this.side,
    required this.breath,
    required this.settle,
    required this.dark,
    required this.border,
    required this.slot,
    required this.onTap,
    this.onLongPress,
    this.favorite = false,
  });

  final Location location;

  /// 0 in the middle, growing to 2.5 a few pages away.
  final double distance;

  /// -1 when this page sits left of the middle, +1 right of it, 0 unknown.
  final double side;

  /// The wheel's breath: only the chosen card moves with it.
  final Animation<double> breath;

  /// The landing spring: one swell-and-settle when a choice arrives.
  final Animation<double> settle;

  final bool dark;
  final Color border;

  /// The widest the card may grow: its page's own slot. The chosen flag
  /// fills it; the neighbors never reach it.
  final double slot;

  final VoidCallback onTap;

  /// A long-press pins or unpins this country (null keeps it quiet).
  final VoidCallback? onLongPress;

  /// Whether the user pinned this country: a small star rides the card.
  final bool favorite;

  /// The wheel's glow: the one blue the halo, the frame and the markers
  /// share — the aurora light the chosen flag stands in.
  static Color glowBlue(bool dark) =>
      dark ? const Color(0xFF3D6BFF) : const Color(0xFF2F5BE8);

  /// The fade of a card this far from the middle: whole while it rides
  /// beside the chosen one, gone before its box can reach the screen's
  /// edge — the wheel's page is 0.26 of the viewport wide, so the edge
  /// sits under a page and nine-tenths; a card still visible there is a
  /// half-cut flag. A smooth step, so the leaving is a dissolve, not a
  /// pop.
  static double edgeFade(double distance) {
    const start = 1.0, end = 1.55;
    if (distance <= start) return 1;
    if (distance >= end) return 0;
    final t = (distance - start) / (end - start);
    final smooth = t * t * (3 - 2 * t);
    return 1.0 - smooth;
  }

  @override
  Widget build(BuildContext context) {
    final chosen = distance < 0.5;
    // The size falls away from the middle exponentially, so the drop is
    // steep beside the chosen card and gentle far out: the chosen flag
    // fills its whole slot, the next ones read clearly smaller — a wheel
    // with one lit card at its center, not a ladder of equals. The frame
    // is the flag's own 3:2: the art fits whole.
    final width = math.min(slot, 44.0 + 62.0 * math.exp(-0.85 * distance));
    final height = width * 2 / 3;
    final radius = 9.0 + 9.0 * math.exp(-1.1 * distance);
    // The arc: the neighbors sit a touch lower the further they are, so
    // the row bends gently — a wheel in perspective, not a scatter: a
    // deep dip and a wide turn read as a mess of flags, not a wheel.
    final dip = 2.0 + 6.0 * math.min(1.0, distance);
    // The turn: the neighbors face the middle by a few degrees, in
    // perspective — a hair of it, barely there: enough for depth, too
    // little for the smearing a cover flow brings.
    final turn = -0.03 * math.min(1.2, distance) * side;
    // The whole card's alpha: the wheel's step back, times the edge
    // fade that dissolves the outermost pages.
    final alpha =
        (1.0 - 0.30 * math.min(1.25, distance)) * _FlagCard.edgeFade(distance);
    final scheme = Theme.of(context).colorScheme;

    // The whole card steps back with its distance — frame and all: the
    // opacity used to take only the flag, and the card's white frame
    // stayed behind it at full ink, a ghost card floating at the wheel's
    // edges. The chosen one is fully there; the others step back, and the
    // outermost dissolve before the screen's edge cuts them.
    final card = Opacity(
      opacity: alpha.clamp(0.0, 1.0),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: chosen
                  ? _FlagCard.glowBlue(dark).withValues(alpha: 0.95)
                  : border.withValues(alpha: dark ? 0.6 : 0.5),
              width: chosen ? 1.5 : 0.7,
            ),
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
                      Colors.black.withValues(alpha: dark ? 0.20 : 0.07),
                    ],
            ),
          ),
          child: favorite
              ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _content(scheme, width),
                    PositionedDirectional(
                      top: -5,
                      end: -5,
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: glowBlue(dark),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: dark ? Colors.black : Colors.white,
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.star_rounded,
                          size: 9,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : _content(scheme, width),
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

    // The chosen card: it breathes with the wheel's own clock, lands
    // with a short spring, and sits inside a glass frame — a ring of
    // frosted glass around the flag, the frame's own blue light glowing
    // behind it — and on a glass shelf, a soft pool of light under it,
    // NOT a mirrored flag: a reflected second flag read as one flag cut
    // in half, the wheel's oldest complaint, so the shelf carries only
    // light, never art.
    final blue = _FlagCard.glowBlue(dark);
    final framed = Container(
      // The glass frame: a bezel of frosted glass around the flag — the
      // sweep comes from up-left, the fine white edge holds the shape.
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius + 4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: dark ? 0.26 : 0.60),
            Colors.white.withValues(alpha: dark ? 0.04 : 0.16),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: dark ? 0.30 : 0.55),
          width: 1,
        ),
        boxShadow: [
          // The blue light: a tight ring of it, then a wide, very soft
          // bloom — the halo on the card itself, so the frame reads as
          // lit from within, whatever the theme behind it.
          BoxShadow(
            color: blue.withValues(alpha: dark ? 0.55 : 0.34),
            blurRadius: 26,
            spreadRadius: 1.5,
          ),
          BoxShadow(
            color: blue.withValues(alpha: dark ? 0.22 : 0.12),
            blurRadius: 58,
            spreadRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.45 : 0.16),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: card,
    );
    return AnimatedBuilder(
      animation: Listenable.merge([breath, settle]),
      builder: (context, _) => Transform.translate(
        offset: Offset(0, -2.5 * breath.value),
        child: Transform.scale(
          scale: (1.0 + 0.015 * breath.value) * (1.0 + 0.05 * settle.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              framed,
              const SizedBox(height: 6),
              _ShelfGleam(width: width + 6, accent: blue, dark: dark),
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
          // The mark reads at half the card's width: smaller, its knot's
          // rings shrink to a scatter of dots nobody can name.
          width: width * 0.50,
          height: width * 0.50,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            scheme.onPrimaryContainer,
            BlendMode.srcIn,
          ),
        ),
      );
    }
    if (bundledFlags.contains(code.toLowerCase())) {
      // The boundary keeps the flag's raster while the wheel's breath
      // recomposes the frame around it: the art repaints only when it
      // really changes, not on every tick. The frame is 3:2, the flag's
      // own shape: no country is cropped to fit.
      return RepaintBoundary(
        child: SvgPicture.asset(
          'assets/flags/${code.toLowerCase()}.svg',
          width: width,
          height: width * 2 / 3,
          fit: BoxFit.contain,
        ),
      );
    }
    // Not carried: from the core, the code until it arrives.
    return CountryFlag(code: code, width: width);
  }
}

/// The glass shelf under the chosen flag: a soft pool of the state's
/// light — a lens of accent fading downward and outward, like a lamp
/// standing on glass. It carries no art at all: the shelf can never
/// read as a second, half-drawn flag, whatever the screen's scale.
class _ShelfGleam extends StatelessWidget {
  const _ShelfGleam({
    required this.width,
    required this.accent,
    required this.dark,
  });

  final double width;
  final Color accent;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final h = width * 0.16;
    return SizedBox(
      width: width,
      height: h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(2),
            bottom: Radius.circular(h / 2),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accent.withValues(alpha: dark ? 0.34 : 0.26),
              accent.withValues(alpha: dark ? 0.10 : 0.07),
              accent.withValues(alpha: 0.0),
            ],
            stops: const [0, 0.45, 1],
          ),
        ),
        // A lens shape, not a rectangle: the light gathers at the middle
        // and thins toward the ends, the way a reflection of a lamp does.
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color.fromRGBO(255, 255, 255, 0),
              const Color.fromRGBO(255, 255, 255, 1),
              const Color.fromRGBO(255, 255, 255, 0),
            ],
            stops: const [0, 0.5, 1],
          ).createShader(bounds),
          child: const SizedBox.expand(),
        ),
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
    final recommended = all
        .where((loc) => isRecommendedPlace(loc.code))
        .toList();
    final countries =
        [
          for (final loc in all)
            if (!isRecommendedPlace(loc.code)) loc,
        ]..sort(
          (a, b) => nameSortKey(l.localeName, locationName(l, a.code, a.name))
              .compareTo(
                nameSortKey(l.localeName, locationName(l, b.code, b.name)),
              ),
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
    AppSounds.play(SoundCue.tap);
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
    // The tile is the flag's own 3:2: the art fits whole, never cropped.
    final h = w * 2 / 3;
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
          // The strip's tiles are smaller than the wheel's cards: the
          // knot still takes near half the tile, or it reads as noise.
          width: width * 0.45,
          height: width * 0.45,
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
        height: width * 2 / 3,
        fit: BoxFit.contain,
      );
    }
    return CountryFlag(code: code, width: width);
  }
}
