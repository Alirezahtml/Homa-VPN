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
import 'design.dart';
import 'design_style.dart';
import 'sound.dart' show AppSounds, SoundCue;
import 'widgets.dart';

/// The shape a flag card wears, in the design's own cut — the border
/// shape the InkWell's splash follows, the container's decoration the
/// art clips to, and whether the art fills by cropping (the medal's
/// square, whose circle cuts the plate's sides) or fits whole.
ShapeBorder flagCutShape(DesignStyle design, double w, double h) =>
    switch (design.flagShape) {
      FlagShape.rounded => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(design.flagRound),
      ),
      FlagShape.plate => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      FlagShape.squircle => ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(h * 0.42),
      ),
      FlagShape.circle => const CircleBorder(),
    };

/// The plain box a flag paints in: the design's cut with the edge's
/// hairline around it.
Decoration flagCutDecoration(
  DesignStyle design,
  double w,
  double h,
  Color edge, {
  double weight = 0.7,
}) => switch (design.flagShape) {
  FlagShape.rounded => BoxDecoration(
    borderRadius: BorderRadius.circular(design.flagRound),
    border: Border.all(color: edge, width: weight),
  ),
  FlagShape.plate => BoxDecoration(
    borderRadius: BorderRadius.circular(3),
    border: Border.all(color: edge, width: weight),
  ),
  FlagShape.squircle => ShapeDecoration(
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(h * 0.42),
      side: BorderSide(color: edge, width: weight),
    ),
  ),
  FlagShape.circle => BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: edge, width: weight),
  ),
};

/// The glass sweep the flag cards wear: the light from up-left that
/// gives the plate its sheen. The print's mood keeps none — the paper
/// is flat, the ink does not gleam.
Decoration? flagSweep(
  DesignStyle design,
  double w,
  double h,
  bool dark, {
  double top = 0.08,
}) {
  if (design.fx == FxMood.print ||
      design.fx == FxMood.tonal ||
      design.fx == FxMood.pop) {
    return null;
  }
  final colors = [
    Colors.white.withValues(alpha: dark ? top * 0.6 : top),
    Colors.black.withValues(alpha: dark ? 0.20 : 0.07),
  ];
  final gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: colors,
  );
  return switch (design.flagShape) {
    FlagShape.rounded => BoxDecoration(
      borderRadius: BorderRadius.circular(design.flagRound),
      gradient: gradient,
    ),
    FlagShape.plate => BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      gradient: gradient,
    ),
    FlagShape.squircle => ShapeDecoration(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(h * 0.42),
      ),
      gradient: gradient,
    ),
    FlagShape.circle => BoxDecoration(shape: BoxShape.circle, gradient: gradient),
  };
}

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
            // smearing across it). One fixed size: the drag and the breath
            // ride the compositor as a scale over its cached raster, so no
            // tick of the wheel re-lays out or re-draws it.
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
                      scale:
                          (1.0 + 0.127 * glow) * (1.0 + 0.05 * breathe * glow),
                      child: RepaintBoundary(
                        child: Container(
                          width: 236,
                          height: 142,
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
              // The wheel's walk, tuned to read as one glide: the page
              // physics keep the landing on the country (one fling, one
              // place), and the wheel's own settle spring — a touch
              // softer, just critically damped — arrives without the
              // hard ratchet knock.
              physics: const _WheelGlide(),
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
    final scheme = Theme.of(context).colorScheme;
    // The wheel's whole shape, cheapened to what the compositor does
    // free. The card paints ONCE, at the chosen card's own size, inside
    // a boundary of its own — the flag, the glass, the frame and its
    // three blurred lights are rasterized once and kept. Everything the
    // drag and the breath change — the size, the arc's dip, the turn,
    // the fade, the landing's spring — rides over that cached raster as
    // transforms and opacity, layers the compositor moves without
    // re-laying out and without re-drawing a single blur. The wheel
    // spins the way the hand pushes it, whatever phone it stands on.
    final base = math.min(slot, 106.0);
    final width = math.min(slot, 44.0 + 62.0 * math.exp(-0.85 * distance));
    // The card's size falls away from the middle exponentially, so the
    // drop is steep beside the chosen card and gentle far out — the same
    // ladder the layout used to walk, now as a scale over the one size.
    final scale = base <= 0 ? 0.05 : (width / base).clamp(0.05, 1.0);
    // The arc: the neighbors sit a touch lower the further they are, so
    // the row bends gently — a wheel in perspective, not a scatter.
    final dip = 2.0 + 6.0 * math.min(1.0, distance);
    // The turn: the neighbors face the middle by a few degrees, in
    // perspective — a hair of it, barely there: enough for depth, too
    // little for the smearing a cover flow brings.
    final turn = -0.03 * math.min(1.2, distance) * side;
    // The whole card's alpha: the wheel's step back, times the edge
    // fade that dissolves the outermost pages.
    final alpha =
        (1.0 - 0.30 * math.min(1.25, distance)) * _FlagCard.edgeFade(distance);

    return AnimatedBuilder(
      animation: Listenable.merge([breath, settle]),
      builder: (context, _) {
        // The chosen card alone breathes and lands: the others keep one
        // pose, so a page of resting neighbors never ticks with them.
        final alive = chosen ? 1.0 : 0.0;
        return Opacity(
          opacity: alpha.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, dip - 2.5 * breath.value * alive),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(turn),
              child: Transform.scale(
                scale:
                    scale *
                    (1.0 + 0.015 * breath.value * alive) *
                    (1.0 + 0.05 * settle.value * alive),
                child: RepaintBoundary(
                  child: chosen
                      ? _framedCard(DesignStyle.of(context), scheme, base, dark)
                      : _plainCard(DesignStyle.of(context), scheme, base),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// The card's body at the wheel's own size, unframed: a neighbor's
  /// card, one size everywhere and let down by its scale. The cut is
  /// the design's own — the rounded plate, the medal, the squircle or
  /// the printed plate — and the art follows it.
  Widget _plainCard(
    DesignStyle design,
    ColorScheme scheme,
    double base,
  ) {
    final medal = design.flagShape == FlagShape.circle;
    // The medal's box is square: the circle's diameter is the plate's
    // height, and the art crops to fill it.
    final w = medal ? base * 2 / 3 : base;
    final h = base * 2 / 3;
    final edge = border.withValues(alpha: dark ? 0.6 : 0.5);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      customBorder: flagCutShape(design, w, h),
      child: Container(
        width: w,
        height: h,
        clipBehavior: Clip.antiAlias,
        decoration: flagCutDecoration(design, w, h, edge),
        // The glass: a darker sweep on the neighbors, so the row carries
        // depth without leaving the theme. The print and the tonal
        // surface keep none.
        foregroundDecoration: flagSweep(design, w, h, dark),
        child: favorite
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  _content(scheme, w, cover: medal),
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
            : _content(scheme, w, cover: medal),
      ),
    );
  }

  /// The chosen card: it sits inside a glass frame — a ring of frosted
  /// glass around the flag, the frame's own blue light glowing behind
  /// it — and on a glass shelf, a soft pool of light under it, NOT a
  /// mirrored flag: a reflected second flag read as one flag cut in
  /// half, the wheel's oldest complaint, so the shelf carries only
  /// light, never art. The whole thing paints once, at one size.
  ///
  /// The frame itself wears the design's own dress: the monochrome's
  /// frosted bezel and its blue bloom; the system designs' medal ring;
  /// the zed's violet glow; the pixel's quiet tonal edge; and the
  /// paper's double rule, flat, no light at all.
  Widget _framedCard(
    DesignStyle design,
    ColorScheme scheme,
    double base,
    bool dark,
  ) {
    final shape = design.flagShape;
    final medal = shape == FlagShape.circle;
    final w = medal ? base * 2 / 3 : base;
    final h = base * 2 / 3;
    // The frame's light: the monochrome's own blue; every design that
    // carries a palette lights its frame with that palette's ink.
    final light = AppDesign.current.key == 'mono'
        ? _FlagCard.glowBlue(dark)
        : design.navActive;
    final edge = border.withValues(alpha: dark ? 0.6 : 0.5);
    // The favorite's star: the same coin on every design.
    Widget fav(Widget child) => favorite
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              child,
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
        : child;
    final Widget frame;
    var shelf = false;
    switch (design.fx) {
      case FxMood.print:
        // The paper's plate: the double rule in the ink, no shadow, no
        // light — flat, like everything the press makes.
        frame = Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: light.withValues(alpha: 0.9), width: 1.2),
          ),
          child: Container(
            width: w,
            height: h,
            clipBehavior: Clip.antiAlias,
            decoration: flagCutDecoration(
              design,
              w,
              h,
              light.withValues(alpha: 0.55),
              weight: 0.7,
            ),
            child: fav(_content(scheme, w, cover: medal)),
          ),
        );
      case FxMood.soft:
        // The system's medal: the ring of light around the circle, and
        // the soft shadow that lifts it off the page — depth without a
        // bloom.
        frame = Container(
          width: w + 6,
          height: h + 6,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: light.withValues(alpha: 0.85), width: 1.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.40 : 0.16),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: light.withValues(alpha: dark ? 0.30 : 0.18),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: fav(_content(scheme, w, cover: true)),
          ),
        );
      case FxMood.glow:
        // The bento's glow: the frame lit from within, the violet bloom
        // reaching past the squircle's corners, and the shelf of light
        // under it.
        frame = Container(
          width: w + 6,
          height: h + 6,
          padding: const EdgeInsets.all(3),
          decoration: ShapeDecoration(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular((h + 6) * 0.42),
              side: BorderSide(color: light.withValues(alpha: 0.9), width: 1.3),
            ),
            shadows: [
              BoxShadow(
                color: light.withValues(alpha: dark ? 0.50 : 0.32),
                blurRadius: 26,
                spreadRadius: 1.5,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.45 : 0.16),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(h * 0.42),
              ),
            ),
            child: fav(_content(scheme, w)),
          ),
        );
        shelf = true;
      case FxMood.tonal:
        // Material's quiet edge: the tonal surface speaks, the shape
        // carries, the shadow only whispers.
        frame = Container(
          width: w + 4,
          height: h + 4,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.flagRound + 2),
            border: Border.all(
              color: light.withValues(alpha: 0.55),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.38 : 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: flagCutDecoration(design, w, h, edge),
            child: fav(_content(scheme, w, cover: medal)),
          ),
        );
      case FxMood.pop:
        // The box's tile: the flag on its warm plate, the soft shadow
        // under it and the tangerine's breath on the chosen card — the
        // pop carries, no glass and no bloom.
        frame = Container(
          width: w + 6,
          height: h + 6,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.flagRound + 3),
            border: Border.all(color: light.withValues(alpha: 0.9), width: 1.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.42 : 0.14),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: light.withValues(alpha: dark ? 0.22 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: flagCutDecoration(design, w, h, edge),
            child: fav(_content(scheme, w, cover: medal)),
          ),
        );
      case FxMood.glass:
        // The glass frame: a bezel of frosted glass around the flag —
        // the sweep comes from up-left, the fine white edge holds the
        // shape, and the blue light blooms behind it. The shelf under
        // it holds only light.
        frame = Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
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
              BoxShadow(
                color: light.withValues(alpha: dark ? 0.55 : 0.34),
                blurRadius: 26,
                spreadRadius: 1.5,
              ),
              BoxShadow(
                color: light.withValues(alpha: dark ? 0.22 : 0.12),
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
          child: Container(
            width: w,
            height: h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(design.flagRound),
              border: Border.all(color: light.withValues(alpha: 0.95), width: 1.5),
            ),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(design.flagRound),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: dark ? 0.22 : 0.28),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
            ),
            child: fav(_content(scheme, w, cover: medal)),
          ),
        );
        shelf = true;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        frame,
        if (shelf) ...[
          const SizedBox(height: 6),
          _ShelfGleam(width: base + 6, accent: light, dark: dark),
        ],
      ],
    );
  }

  /// The card's content, full bleed: a real country's flag, or Mozilla's
  /// own mark on its tile for the recommended location — the corners as
  /// rounded as the flags' card. [width] is the box's width; [cover]
  /// says the box is the medal's square, the art cropped to fill it.
  Widget _content(ColorScheme scheme, double width, {bool cover = false}) {
    final code = location.code;
    final height = cover ? width : width * 2 / 3;
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
      // really changes, not on every tick. The plate fits the art whole
      // (the flag's own 3:2); the medal crops it to its round.
      return RepaintBoundary(
        child: SvgPicture.asset(
          'assets/flags/${code.toLowerCase()}.svg',
          width: width,
          height: height,
          fit: cover ? BoxFit.cover : BoxFit.contain,
        ),
      );
    }
    // Not carried: from the core, the code until it arrives.
    return CountryFlag(code: code, width: cover ? height : width);
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
    this.showName = true,
  });

  final CoreController core;
  final Color text;
  final Color border;
  final Color accent;

  /// Whether the chosen country's name shows under the strip. The homes
  /// whose own card names the place again — the aether's status card, the
  /// zed's server card — pass false: one page says the place once, the
  /// way a clean layout should.
  final bool showName;

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
      return SizedBox(height: widget.showName ? 96 : 64);
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
            // The strip scrolls in the design's own physics: the system
            // designs' light bounce, the paper's clamped weight that
            // dies against the fold, Material's quicker settle.
            physics: switch (DesignStyle.of(context).scroll) {
              ScrollMood.heavy => const ClampingScrollPhysics(),
              ScrollMood.springy => const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              _ => const BouncingScrollPhysics(),
            },
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
        if (widget.showName) ...[
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
    final design = DesignStyle.of(context);
    final shape = design.flagShape;
    final medal = shape == FlagShape.circle;
    // One size for every tile, always: the chosen one stands out with its
    // own border and glow, and the size's emphasis rides the compositor
    // as a scale. No tile ever changes its layout when the choice moves —
    // the change of flags stays smooth on the phones that have little to
    // give — and each tile keeps its raster in a boundary of its own, so
    // the strip's scroll re-uses it instead of redrawing it. The cut is
    // the design's own: the medal's circle for the system designs, the
    // paper's ruled plate, the squircle for the bento.
    const w = 52.0;
    final h = w * 2 / 3;
    final boxW = medal ? h : w;
    final edge = chosen
        ? accent.withValues(alpha: 0.9)
        : border.withValues(alpha: dark ? 0.5 : 0.45);
    // The mood's own light: the glass and the glow carry a bloom on the
    // chosen tile, the soft keeps a whisper of it, and the print and the
    // tonal surface stand flat — the border alone says chosen.
    final List<BoxShadow> shadows = switch (design.fx) {
      FxMood.print ||
      FxMood.tonal => chosen
          ? [
              BoxShadow(
                color: accent.withValues(alpha: dark ? 0.28 : 0.18),
                blurRadius: 6,
              ),
            ]
          : const [],
      FxMood.pop => chosen
          ? [
              BoxShadow(
                color: accent.withValues(alpha: dark ? 0.30 : 0.20),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.34 : 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
      FxMood.soft => [
          BoxShadow(
            color: chosen
                ? accent.withValues(alpha: dark ? 0.26 : 0.18)
                : Colors.black.withValues(alpha: dark ? 0.30 : 0.10),
            blurRadius: chosen ? 10 : 5,
            offset: chosen ? Offset.zero : const Offset(0, 2),
          ),
        ],
      FxMood.glass || FxMood.glow => chosen
          ? [
              BoxShadow(
                color: accent.withValues(alpha: dark ? 0.35 : 0.25),
                blurRadius: 14,
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
    };
    final Decoration tile = medal
        ? BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: edge, width: chosen ? 1.4 : 0.7),
            boxShadow: shadows,
          )
        : flagCutDecoration(
            design,
            boxW,
            h,
            edge,
            weight: chosen ? 1.4 : 0.7,
          );
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: _FlagStripState._tileW - 10,
          alignment: Alignment.center,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            scale: chosen ? 1.0 : 0.885,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              width: boxW,
              height: h,
              clipBehavior: Clip.antiAlias,
              decoration: tile,
              foregroundDecoration: flagSweep(
                design,
                boxW,
                h,
                dark,
                top: chosen ? 0.24 : 0.08,
              ),
              child: Opacity(
                opacity: chosen ? 1.0 : 0.82,
                child: _content(scheme, boxW, cover: medal),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(ColorScheme scheme, double width, {bool cover = false}) {
    final code = location.code;
    final height = cover ? width : width * 2 / 3;
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
        height: height,
        fit: cover ? BoxFit.cover : BoxFit.contain,
      );
    }
    return CountryFlag(code: code, width: cover ? height : width);
  }
}

/// The wheel's own settle: the page physics' landing, a touch softer and
/// just critically damped — the wheel glides into the chosen flag instead
/// of knocking into it like a ratchet. One fling still carries one
/// country: the page math itself is the parent's own.
class _WheelGlide extends PageScrollPhysics {
  const _WheelGlide({super.parent});

  @override
  _WheelGlide applyTo(ScrollPhysics? ancestor) =>
      _WheelGlide(parent: buildParent(ancestor));

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.55,
        stiffness: 130,
        ratio: 1.0,
      );
}
