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
import 'gazette.dart' show PaperCard;
import 'sound.dart' show AppSounds, SoundCue;
import 'widgets.dart';

/// The ways the designs show their countries. The old home had one
/// horizontal strip that every look shared; these are each design's own
/// presentation, the way each design's cards, headers and navigation are
/// its own:
///
/// - the wheel's home keeps its three-dimensional wheel (the carousel);
/// - the bento's board spreads the countries as a grid of tiles;
/// - the pixel lays the countries out as Material You's filter chips;
/// - the ios snaps through big circular medals, the dock's own emphasis;
/// - the gazette prints the countries the way a paper prints its
///   region index: ruled columns, serif names, dot leaders, the ping
///   at the line's end.
///
/// Every presentation answers the same three duties the wheel does: it
/// reads the core's real list, it follows a choice made somewhere else
/// (the servers page, a shortcut), and it moves the connection when a
/// country is tapped.
///
/// The choices' machinery the presentations share: the list's load, the
/// entries in their presentation order (the recommended place, then the
/// pinned countries, then the rest by name), the core's own selection,
/// and the tap that moves the tunnel.
mixin FlagChoices<T extends StatefulWidget> on State<T> {
  List<Location>? locations;

  CoreController get core;

  /// The countries the user pinned: they lead the list.
  List<String> get favorites;

  /// Long-pressing a country pins or unpins it; null keeps the press
  /// quiet (a place without the settings at hand).
  void Function(String code)? get onToggleFavorite;

  /// The presentation's own move to the core's choice, when the choice
  /// was made somewhere else. The wheels animate to a page; the rails
  /// scroll; the grids have nothing to move — the choice's highlight
  /// alone answers.
  void follow();

  String get selection => (core.status?.selection ?? '').toLowerCase();

  void flagChoicesInitState() {
    load();
    core.addListener(_followSoon);
  }

  void flagChoicesDispose() {
    core.removeListener(_followSoon);
  }

  void _followSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) follow();
    });
  }

  Future<void> load() async {
    try {
      final list = await core.call((api) => api.locations());
      if (!mounted) return;
      setState(() => locations = list.locations);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) follow();
      });
    } on CoreApiException {
      // The servers page says why; the presentation stays empty until
      // the core answers.
    } on Exception {
      // The core is gone; the shell shows it.
    }
  }

  /// The locations in presentation order: the recommended place first,
  /// then the pinned countries, then the rest by name.
  List<Location> entriesFor(AppLocalizations l, List<Location> all) {
    final recommended = all.where((loc) => isRecommendedPlace(loc.code));
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
    final pinned = [
      for (final code in favorites)
        for (final loc in countries)
          if (loc.code.toLowerCase() == code.toLowerCase()) loc,
    ];
    final rest = [
      for (final loc in countries)
        if (!pinned.any((f) => f.code.toLowerCase() == loc.code.toLowerCase()))
          loc,
    ];
    return [...recommended, ...pinned, ...rest];
  }

  List<Location> entryList(AppLocalizations l) =>
      entriesFor(l, locations ?? const <Location>[]);

  /// Where the core's own choice stands in the entries; -1 when the
  /// choice is the fastest (no country owns it).
  int indexOf(List<Location> entries, String selection) {
    if (selection == 'fastest') return -1;
    if (selection.isEmpty) {
      return entries.indexWhere((loc) => isRecommendedPlace(loc.code));
    }
    return entries.indexWhere((loc) => loc.code.toLowerCase() == selection);
  }

  Future<void> choose(Location loc) async {
    HapticFeedback.selectionClick();
    AppSounds.play(SoundCue.tap);
    final value = isRecommendedPlace(loc.code) ? '' : loc.code;
    await runShowingErrors(context, () => core.setLocation(value));
  }
}

/// The flag's art, cropped to its box: the recommended place carries
/// Mozilla's mark on its container, the bundled flags paint their plate,
/// and the rest ask the core for theirs.
Widget flagArt(BuildContext context, String code, double w, double h,
    {bool cover = false}) {
  if (isRecommendedPlace(code)) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.primaryContainer,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/brand/mozilla_logo.svg',
        width: h * 0.62,
        height: h * 0.62,
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
      width: w,
      height: h,
      fit: cover ? BoxFit.cover : BoxFit.contain,
    );
  }
  return CountryFlag(code: code, width: w);
}

/// The row flag's round for a shape, the small plate's own cut.
double styleSmallRound(FlagShape shape) => switch (shape) {
  FlagShape.rounded => 8,
  FlagShape.plate => 2,
  FlagShape.circle => 15,
};

/// The bento board's grid of countries: the flags as tiles on the board,
/// the chosen one framed in the accent with its own check, the pinned
/// ones wearing their star — the board the bento design's home opens
/// with. The tiles that fit stand on the page; the last cell says the
/// rest are on the servers page, a tap away.
class FlagBoard extends StatefulWidget {
  const FlagBoard({
    super.key,
    required this.core,
    required this.accent,
    required this.border,
    this.favorites = const [],
    this.onToggleFavorite,
    this.onOpenServers,
    this.columns = 4,
    this.rows = 2,
  });

  final CoreController core;
  final Color accent;
  final Color border;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;
  final VoidCallback? onOpenServers;
  final int columns;
  final int rows;

  @override
  State<FlagBoard> createState() => _FlagBoardState();
}

class _FlagBoardState extends State<FlagBoard> with FlagChoices {
  @override
  CoreController get core => widget.core;
  @override
  List<String> get favorites => widget.favorites;
  @override
  void Function(String code)? get onToggleFavorite => widget.onToggleFavorite;
  @override
  void follow() {}

  @override
  void initState() {
    super.initState();
    flagChoicesInitState();
  }

  @override
  void dispose() {
    flagChoicesDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (locations == null || entries.isEmpty) {
      return SizedBox(height: widget.rows * 86.0);
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = DesignStyle.of(context);
    final chosenIndex = indexOf(entries, selection);
    // The cells the board holds: the countries that fit, then the tile
    // that says the whole list lives on the servers page.
    final cellCount = widget.columns * widget.rows;
    final showAll = entries.length > cellCount - 1;
    final visible = showAll
        ? entries.take(cellCount - 1).toList()
        : entries.toList();
    // The board is plain rows of plain cells — no grid viewport anywhere,
    // because the home measures itself through IntrinsicHeight and a
    // viewport cannot answer intrinsics. The cells share the row by
    // weight, so the board fills whatever width the home gives it — and
    // a short last row spreads wider instead of leaving dead seats.
    final cells = <Widget Function()>[
      for (var i = 0; i < visible.length; i++)
        () => Expanded(
              child: _BoardTile(
                location: visible[i],
                chosen: i == chosenIndex,
                pinned: favorites.any(
                  (f) => f.toLowerCase() == visible[i].code.toLowerCase(),
                ),
                accent: widget.accent,
                border: widget.border,
                dark: dark,
                round: style.flagRound,
                onTap: () => choose(visible[i]),
                onLongPress: widget.onToggleFavorite == null
                    ? null
                    : () => widget.onToggleFavorite!(visible[i].code),
              ),
            ),
      if (showAll)
        () => Expanded(
              child: _BoardTile.all(
                accent: widget.accent,
                border: widget.border,
                dark: dark,
                label: l.flagAllPlaces,
                onTap: widget.onOpenServers,
              ),
            ),
    ];
    final rows = (cells.length + widget.columns - 1) ~/ widget.columns;
    return Column(
      children: [
        for (var r = 0; r < rows; r++) ...[
          if (r > 0) const SizedBox(height: 10),
          Row(
            children: [
              for (var c = r * widget.columns;
                  c < (r + 1) * widget.columns && c < cells.length;
                  c++) ...[
                if (c > r * widget.columns) const SizedBox(width: 10),
                cells[c](),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// One tile of the board: the flag on its rounded plate, the name under
/// it, the chosen one framed and the pinned one starred.
class _BoardTile extends StatelessWidget {
  const _BoardTile({
    required this.location,
    required this.chosen,
    required this.pinned,
    required this.accent,
    required this.border,
    required this.dark,
    required this.round,
    required this.onTap,
    this.onLongPress,
  }) : _allLabel = null;

  const _BoardTile.all({
    required this.accent,
    required this.border,
    required this.dark,
    required String label,
    this.onTap,
  }) : location = null,
       onLongPress = null,
       chosen = false,
       pinned = false,
       round = 20,
       _allLabel = label;

  final Location? location;
  final bool chosen;
  final bool pinned;
  final Color accent;
  final Color border;
  final bool dark;
  final double round;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? _allLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = AppLocalizations.of(context);
    final isAll = location == null;
    final name = isAll
        ? (_allLabel ?? '')
        : locationName(l, location!.code, location!.name);
    final edge = chosen
        ? accent.withValues(alpha: 0.95)
        : border.withValues(alpha: dark ? 0.55 : 0.5);
    final fill = chosen
        ? accent.withValues(alpha: dark ? 0.16 : 0.10)
        : scheme.surfaceContainerHigh.withValues(alpha: dark ? 0.55 : 0.8);
    final idleInk = scheme.onSurfaceVariant;
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: edge, width: chosen ? 1.6 : 1),
          ),
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // The flag area keeps its own fixed height: the tile's
              // height is its content's, and a flex child could not
              // answer the home's intrinsic measure with an unbounded
              // room to expand into.
              SizedBox(
                height: 34,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        round.clamp(4.0, 16.0),
                      ),
                      child: SizedBox(
                        width: 46,
                        height: 31,
                        child: isAll
                            ? Icon(
                                Icons.grid_view_rounded,
                                size: 22,
                                color: chosen ? accent : idleInk,
                              )
                            : flagArt(context, location!.code, 46, 31),
                      ),
                    ),
                    if (pinned)
                      PositionedDirectional(
                        top: 0,
                        end: 0,
                        child: Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: accent,
                        ),
                      ),
                    if (chosen)
                      PositionedDirectional(
                        bottom: 0,
                        end: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accent,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: accent.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  height: 1.1,
                  fontWeight: chosen ? FontWeight.w700 : FontWeight.w600,
                  color: chosen ? accent : (isAll ? idleInk : null),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Material You's own options: the countries as filter chips, the chosen
/// one lifted into the selected state with its check — the pixel's way
/// of laying a choice out. One rail, the rail scrolls, and it follows a
/// choice made somewhere else.
class FlagChips extends StatefulWidget {
  const FlagChips({
    super.key,
    required this.core,
    required this.border,
    this.favorites = const [],
    this.onToggleFavorite,
  });

  final CoreController core;
  final Color border;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;

  @override
  State<FlagChips> createState() => _FlagChipsState();
}

class _FlagChipsState extends State<FlagChips> with FlagChoices {
  final ScrollController _rail = ScrollController();

  @override
  CoreController get core => widget.core;
  @override
  List<String> get favorites => widget.favorites;
  @override
  void Function(String code)? get onToggleFavorite => widget.onToggleFavorite;

  @override
  void initState() {
    super.initState();
    flagChoicesInitState();
  }

  @override
  void dispose() {
    flagChoicesDispose();
    _rail.dispose();
    super.dispose();
  }

  @override
  void follow() {
    if (!_rail.hasClients) return;
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    final index = indexOf(entries, selection);
    if (index < 0) return;
    // The chips' widths walk with their names; the walk to the chosen
    // one estimates by the rail's own share, close enough to center it.
    final width = _rail.position.viewportDimension;
    final estimate = width / 2 - 64.0;
    final target = (index * 118.0 - estimate)
        .clamp(0.0, _rail.position.maxScrollExtent)
        .toDouble();
    if ((_rail.offset - target).abs() > 1) {
      _rail.animateTo(
        target,
        duration: const Duration(milliseconds: 340),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (locations == null || entries.isEmpty) {
      return const SizedBox(height: 44);
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final chosenIndex = indexOf(entries, selection);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _rail,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        physics: switch (DesignStyle.of(context).scroll) {
          ScrollMood.springy => const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          ScrollMood.heavy => const ClampingScrollPhysics(),
          _ => const BouncingScrollPhysics(),
        },
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final loc = entries[i];
          final chosen = i == chosenIndex;
          return RepaintBoundary(
            child: GestureDetector(
              onTap: () => choose(loc),
              onLongPress: widget.onToggleFavorite == null
                  ? null
                  : () => widget.onToggleFavorite!(loc.code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 40,
                padding: const EdgeInsetsDirectional.fromSTEB(6, 4, 12, 4),
                decoration: BoxDecoration(
                  color: chosen
                      ? scheme.secondaryContainer
                      : scheme.surfaceContainerHigh.withValues(
                          alpha: dark ? 0.6 : 0.85,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: chosen
                        ? scheme.secondaryContainer
                        : widget.border.withValues(alpha: dark ? 0.5 : 0.45),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 24,
                            height: 17,
                            child: flagArt(context, loc.code, 24, 17),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      locationName(l, loc.code, loc.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: chosen ? FontWeight.w700 : FontWeight.w600,
                        color: chosen
                            ? scheme.onSecondaryContainer
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    if (chosen) ...[
                      const SizedBox(width: 5),
                      Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: scheme.onSecondaryContainer,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The system's big medals: the countries as circular flags the page
/// snaps through, the middle one standing forward the dock's own way —
/// the ios's deck. One fling carries one medal; the chosen medal's ring
/// wears the accent, and its name stands under it.
class FlagMedalDeck extends StatefulWidget {
  const FlagMedalDeck({
    super.key,
    required this.core,
    required this.border,
    required this.accent,
    required this.muted,
    this.favorites = const [],
    this.onToggleFavorite,
  });

  final CoreController core;
  final Color border;
  final Color accent;
  final Color muted;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;

  @override
  State<FlagMedalDeck> createState() => _FlagMedalDeckState();
}

class _FlagMedalDeckState extends State<FlagMedalDeck> with FlagChoices {
  PageController? _controller;
  bool _moving = false;

  /// The page the finger last snapped to: the dots' own truth — they
  /// follow the deck's motion, not the tunnel's round trip.
  int _page = 0;

  @override
  CoreController get core => widget.core;
  @override
  List<String> get favorites => widget.favorites;
  @override
  void Function(String code)? get onToggleFavorite => widget.onToggleFavorite;

  @override
  void initState() {
    super.initState();
    flagChoicesInitState();
  }

  @override
  void dispose() {
    flagChoicesDispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void follow() {
    final controller = _controller;
    if (controller == null || !controller.hasClients || _moving) return;
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    final index = indexOf(entries, selection);
    if (index < 0) return;
    if ((controller.page ?? -1).round() != index) {
      _moving = true;
      controller
          .animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          )
          .whenComplete(() => _moving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (locations == null || entries.isEmpty) {
      return const SizedBox(height: 128);
    }
    final index = indexOf(entries, selection);
    if (_controller == null) {
      _controller = PageController(
        viewportFraction: 0.24,
        initialPage: index < 0 ? 0 : index,
      );
      // The emphasis reads the controller's page, which has no value
      // until the view lays out: one frame later the deck paints its
      // middle standing forward.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 138,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              // The deck is finite: without a count the page view would
              // build the pages past the end and the builder would read
              // past the list.
              itemCount: entries.length,
              clipBehavior: Clip.none,
              onPageChanged: (page) {
                // The system's own tick: every medal the finger snaps
                // to answers with the selection's click, the dock's own
                // way of saying the page turned.
                HapticFeedback.selectionClick();
                // A follow's own landing answers the same event, and
                // the page the choice already owns says nothing new:
                // only the finger's arrival at a new country moves the
                // tunnel.
                if (!_moving && page >= 0 && page < entries.length) {
                  final loc = entries[page];
                  final chosen = isRecommendedPlace(loc.code)
                      ? ''
                      : loc.code.toLowerCase();
                  if (chosen != selection) choose(loc);
                }
                setState(() => _page = page);
              },
        itemBuilder: (context, i) {
          final loc = entries[i];
          final distance =
              ((_controller?.page ?? index.toDouble()) - i)
                  .abs()
                  .clamp(0.0, 3.0);
          return Center(
            child: GestureDetector(
              onTap: () => choose(loc),
              onLongPress: widget.onToggleFavorite == null
                  ? null
                  : () => widget.onToggleFavorite!(loc.code),
              child: Transform.scale(
                scale: 1.0 - distance * 0.13,
                child: Opacity(
                  opacity: (0.55 + 0.45 * (1.0 - distance / 3)).clamp(0.0, 1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: i == index
                                ? widget.accent
                                : widget.border.withValues(
                                    alpha: dark ? 0.55 : 0.5,
                                  ),
                            width: i == index ? 2.2 : 1,
                          ),
                          boxShadow: i == index
                              ? [
                                  BoxShadow(
                                    color: widget.accent.withValues(
                                      alpha: dark ? 0.3 : 0.2,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: flagArt(context, loc.code, 78, 78, cover: true),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        locationName(l, loc.code, loc.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: i == index
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: i == index ? widget.accent : widget.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
              ),
          ),
          // The deck's dots: the system's own page dots — the chosen
          // one elongated and lit the accent's blue, the rest the quiet
          // gray, each turning with the snap. A long list shows a
          // window around the current page, the ellipses standing where
          // the window does not reach.
          if (entries.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (entries.length <= 9)
                    for (var d = 0; d < entries.length; d++) _dot(context, d)
                  else ...[
                    for (var d = 0; d < entries.length; d++)
                      if (d == 0 || d == entries.length - 1 ||
                          (d >= _page - 2 && d <= _page + 2))
                        _dot(context, d)
                      else if (d == 1 && _page > 3 ||
                          d == entries.length - 2 &&
                              _page < entries.length - 4)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            '…',
                            style: TextStyle(
                              fontSize: 10,
                              height: 1,
                              color: widget.muted.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// One of the deck's dots: the chosen page's elongated pill in the
  /// accent, the rest the round quiet gray.
  Widget _dot(BuildContext context, int d) {
    final chosen = d == _page;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      width: chosen ? 16 : 5.5,
      height: 5.5,
      decoration: BoxDecoration(
        color: chosen
            ? widget.accent
            : widget.muted.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

/// The gazette's region index: the countries printed the way a paper
/// prints its own index — the ruled box, the section's label under its
/// rule, the columns of serif names with their dot leaders, and the
/// measured delay at every line's end. The chosen line wears the print's
/// bullet and the red ink; the pinned lines carry the star's asterisk.
/// The box keeps the paper's weight: it scrolls only when the list is
/// longer than its columns can hold, and the scroll dies against the
/// fold.
class GazetteRegionBox extends StatefulWidget {
  const GazetteRegionBox({
    super.key,
    required this.core,
    required this.text,
    required this.muted,
    required this.rule,
    required this.paper,
    required this.accent,
    required this.display,
    required this.displayFallback,
    this.favorites = const [],
    this.onToggleFavorite,
  });

  final CoreController core;
  final Color text;
  final Color muted;
  final Color rule;
  final Color paper;
  final Color accent;
  final String display;
  final List<String> displayFallback;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;

  @override
  State<GazetteRegionBox> createState() => _GazetteRegionBoxState();
}

class _GazetteRegionBoxState extends State<GazetteRegionBox>
    with FlagChoices {
  final ScrollController _columns = ScrollController();

  @override
  CoreController get core => widget.core;
  @override
  List<String> get favorites => widget.favorites;
  @override
  void Function(String code)? get onToggleFavorite => widget.onToggleFavorite;

  static const _rowHeight = 34.0;
  static const _visibleRows = 5;

  @override
  void initState() {
    super.initState();
    flagChoicesInitState();
  }

  @override
  void dispose() {
    flagChoicesDispose();
    _columns.dispose();
    super.dispose();
  }

  @override
  void follow() {
    if (!_columns.hasClients) return;
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    final index = indexOf(entries, selection);
    if (index < 0) return;
    final row = index ~/ 2;
    final target = (row * _rowHeight - 40)
        .clamp(0.0, _columns.position.maxScrollExtent)
        .toDouble();
    if ((_columns.offset - target).abs() > 1) {
      _columns.animateTo(
        target,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (locations == null || entries.isEmpty) {
      return SizedBox(
        height: _rowHeight * _visibleRows + 40,
        child: PaperCard(
          ink: widget.text,
          rule: widget.rule,
          paper: widget.paper,
          child: const SizedBox.expand(),
        ),
      );
    }
    final chosenIndex = indexOf(entries, selection);
    final rows = (entries.length + 1) ~/ 2;
    final scrollable = rows > _visibleRows;
    // The box shows what its columns hold; a longer list scrolls inside
    // its own rules, the way a long index does.
    return PaperCard(
      ink: widget.text,
      rule: widget.rule,
      paper: widget.paper,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The section's own label: the small caps word, the bullet
          // before it, and the rule that closes the line — the paper's
          // way of opening any list.
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accent,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l.gazetteRegions.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  color: widget.text,
                  fontFamily: widget.display,
                  fontFamilyFallback: widget.displayFallback,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Divider(
                  color: widget.rule,
                  thickness: 1,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // The columns are plain rows of paired lines — no grid viewport
          // and no LayoutBuilder anywhere, because the home measures
          // itself through IntrinsicHeight and neither of the two can
          // answer intrinsics. A longer list scrolls in its own fixed
          // seat, the way a long index does.
          SizedBox(
            height: _rowHeight * (scrollable ? _visibleRows : rows),
            child: scrollable
                ? SingleChildScrollView(
                    controller: _columns,
                    physics: const ClampingScrollPhysics(),
                    child: _rowsColumn(l, entries, chosenIndex),
                  )
                : _rowsColumn(l, entries, chosenIndex),
          ),
        ],
      ),
    );
  }

  Widget _rowsColumn(
    AppLocalizations l,
    List<Location> entries,
    int chosenIndex,
  ) {
    final pairs = (entries.length + 1) ~/ 2;
    return Column(
      children: [
        for (var r = 0; r < pairs; r++)
          SizedBox(
            height: _rowHeight,
            child: Row(
              children: [
                Expanded(
                  child: _RegionRow(
                    location: entries[r * 2],
                    chosen: r * 2 == chosenIndex,
                    pinned: favorites.any(
                      (f) =>
                          f.toLowerCase() ==
                          entries[r * 2].code.toLowerCase(),
                    ),
                    ink: widget.text,
                    muted: widget.muted,
                    accent: widget.accent,
                    display: widget.display,
                    displayFallback: widget.displayFallback,
                    onTap: () => choose(entries[r * 2]),
                    onLongPress: widget.onToggleFavorite == null
                        ? null
                        : () => widget.onToggleFavorite!(entries[r * 2].code),
                  ),
                ),
                // The column rule between the two listings: the paper's
                // own hairline between its columns.
                Container(width: 1, height: _rowHeight - 10, color: widget.rule),
                const SizedBox(width: 17),
                if (r * 2 + 1 < entries.length)
                  Expanded(
                    child: _RegionRow(
                      location: entries[r * 2 + 1],
                      chosen: r * 2 + 1 == chosenIndex,
                      pinned: favorites.any(
                        (f) =>
                            f.toLowerCase() ==
                            entries[r * 2 + 1].code.toLowerCase(),
                      ),
                      ink: widget.text,
                      muted: widget.muted,
                      accent: widget.accent,
                      display: widget.display,
                      displayFallback: widget.displayFallback,
                      onTap: () => choose(entries[r * 2 + 1]),
                      onLongPress: widget.onToggleFavorite == null
                          ? null
                          : () =>
                                widget.onToggleFavorite!(entries[r * 2 + 1].code),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }
}

/// One line of the region index: the serif name, the dot leader, the
/// delay at the end — and the chosen line's bullet and red ink.
class _RegionRow extends StatelessWidget {
  const _RegionRow({
    required this.location,
    required this.chosen,
    required this.pinned,
    required this.ink,
    required this.muted,
    required this.accent,
    required this.display,
    required this.displayFallback,
    required this.onTap,
    this.onLongPress,
  });

  final Location location;
  final bool chosen;
  final bool pinned;
  final Color ink;
  final Color muted;
  final Color accent;
  final String display;
  final List<String> displayFallback;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final name = locationName(l, location.code, location.name);
    final lineInk = chosen ? accent : ink;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 34,
        child: Row(
          children: [
            // The chosen line's bullet: the print's own mark before the
            // name; the others keep the room empty so the column reads
            // aligned.
            SizedBox(
              width: 12,
              child: chosen
                  ? Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent,
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              flex: 5,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.1,
                  fontWeight: chosen ? FontWeight.w700 : FontWeight.w500,
                  color: lineInk,
                  fontFamily: display,
                  fontFamilyFallback: displayFallback,
                ),
              ),
            ),
            if (pinned)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 4, end: 2),
                child: Text(
                  '*',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                    fontFamily: display,
                    fontFamilyFallback: displayFallback,
                  ),
                ),
              ),
            // The dot leader: the paper's own thread from the name to
            // the figure.
            Expanded(
              flex: 2,
              child: Divider(
                color: muted.withValues(alpha: 0.4),
                thickness: 1,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              location.answered ? '${location.pingMs}' : '—',
              style: TextStyle(
                fontSize: 12.5,
                fontFeatures: const [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w600,
                color: chosen ? accent : muted,
                fontFamily: display,
                fontFamilyFallback: displayFallback,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The GTA design's weapon wheel: the countries as the game's own
/// radial dial — the circular medals seated around a dark HUD disc, the
/// full circle of sector dividers, the top seat's own lit wedge (the
/// game lights the weapon the thumb points at), and the center screen
/// carrying the active country's flag, its name and the counter in the
/// display's heavy face, with the counter's own dial arc around them —
/// the ammo gauge the game shows under the weapon's name.
///
/// A drag turns the dial; every seat it passes answers with the tick and
/// a click of the finger's own haptic. A release with speed behind it
/// throws the dial a seat or two further, the flick the game's wheel
/// answers with. A tap on a medal, a sector or the center screen picks
/// the country: the wedge flashes, the medal pulses, the tap's sound
/// lands — the way picking a weapon lands in the game.
///
/// The wheel opens the way the game's does: it pops in — a quick scale
/// from three quarters with a soft overshoot — and the wedge's light
/// arrives a breath later, so the disc reads first and the choice's
/// light lands on top of it.
///
/// The ring holds a fixed spread of seats — the game's own spacing. A
/// country list longer than the ring turns the dial into a drum: the
/// seats keep their places, the countries flow through them, and the
/// wheel reads clean at any count, from five medals to ninety. While
/// the tunnel carries, the rim's own glow breathes; the battery saver's
/// stillness holds it at one light.
class FlagWeaponWheel extends StatefulWidget {
  const FlagWeaponWheel({
    super.key,
    required this.core,
    required this.accent,
    this.favorites = const [],
    this.onToggleFavorite,
    this.onOpenServers,
    this.animated = false,
    this.still = false,
  });

  final CoreController core;
  final Color accent;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;
  final VoidCallback? onOpenServers;

  /// Whether the wheel's own lights may move: the home hands it the
  /// connection's state, so the rim breathes only while the tunnel
  /// carries (or is on its way).
  final bool animated;

  /// The battery saver's stillness: one pose, no breath, whatever the
  /// connection says.
  final bool still;

  @override
  State<FlagWeaponWheel> createState() => _FlagWeaponWheelState();
}

class _FlagWeaponWheelState extends State<FlagWeaponWheel>
    with FlagChoices, TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey(debugLabel: 'gta-weapon-wheel');

  @override
  CoreController get core => widget.core;
  @override
  List<String> get favorites => widget.favorites;
  @override
  void Function(String code)? get onToggleFavorite => widget.onToggleFavorite;

  /// The drag's settle: the dial's glide to the seat it lands on.
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
  );
  Animation<double>? _motion;
  double _turn = 0;
  int _active = 0;
  double? _lastPointerAngle;
  Duration? _lastDragAt;

  /// The drag's own momentum (rad/s, smoothed) — the release's flick.
  double _omega = 0;
  String? _followedSel;
  int _followedCount = -1;

  /// The opening: the wheel's pop, the way the game's wheel arrives —
  /// a quick scale with a soft overshoot.
  late final AnimationController _open = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 430),
  );
  late final Animation<double> _openScale = Tween<double>(
    begin: 0.72,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _open, curve: Curves.easeOutBack));
  late final Animation<double> _openFade = Tween<double>(begin: 0, end: 1)
      .animate(
        CurvedAnimation(
          parent: _open,
          curve: const Interval(0, 0.55, curve: Curves.easeOut),
        ),
      );

  /// The pick's confirm: one quick swell of the chosen medal and the
  /// wedge's light — the tap's own answer, then quiet.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  /// The rim's breath while the tunnel carries: a slow two-second
  /// swell, running only when the home allows it.
  AnimationController? _breathe;

  @override
  void initState() {
    super.initState();
    flagChoicesInitState();
    _settle.addListener(() {
      final anim = _motion;
      if (anim == null) return;
      setState(() => _turn = anim.value);
    });
    _settle.addStatusListener((status) {
      if (status == AnimationStatus.completed) _motion = null;
    });
    _pulse.addListener(() => setState(() {}));
    _open.forward();
    // The breath's controller is made here directly, not through
    // [_syncBreathe]'s setState — a state's initState cannot call
    // setState; the first build reads the field it sets.
    if (widget.animated && !widget.still) {
      _breathe = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2100),
      )..repeat(reverse: true);
      _breathe!.addListener(() => setState(() {}));
    }
  }

  @override
  void didUpdateWidget(covariant FlagWeaponWheel old) {
    super.didUpdateWidget(old);
    if (old.animated != widget.animated || old.still != widget.still) {
      _syncBreathe();
    }
  }

  /// The breath's controller, made only when the home allows movement —
  /// a repeating controller costs frames, so the battery saver (and the
  /// resting tunnel) keep the wheel at one light and no controller.
  void _syncBreathe() {
    final wanted = widget.animated && !widget.still;
    if (wanted && _breathe == null) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2100),
      )..repeat(reverse: true);
      controller.addListener(() => setState(() {}));
      setState(() => _breathe = controller);
    } else if (!wanted && _breathe != null) {
      final controller = _breathe!;
      setState(() => _breathe = null);
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _settle.dispose();
    _open.dispose();
    _pulse.dispose();
    _breathe?.dispose();
    flagChoicesDispose();
    super.dispose();
  }

  double _stepFor(int n) => n <= 0
      ? math.pi / 4
      : n <= _ringSeats
      ? 2 * math.pi / n
      : 2 * math.pi / _ringSeats;

  int _mod(int i, int n) => i % n;

  double _wrap(double a) {
    while (a > math.pi) {
      a -= 2 * math.pi;
    }
    while (a < -math.pi) {
      a += 2 * math.pi;
    }
    return a;
  }

  /// The ring: the seat positions the countries flow through — the game's
  /// own spread. A list longer than the ring turns the dial into a drum:
  /// the seats keep their places and their spacing, the countries pass
  /// through them as the dial turns, and the wheel reads clean at any
  /// count — no seat ever leans on its neighbor.
  static const int _ringSeats = 16;

  /// The front arc: a seat past it fades out before it would wrap.
  static const double _arc = math.pi * 0.62;

  /// The dial's position in seat units: how far the ring has turned,
  /// entry 0's seat as the origin. Every seat the wheel shows reads its
  /// place from this one number, so the whole wheel stays of one mind.
  double _phi(int n) => -_turn / _stepFor(n);

  /// Turns the dial so the entry [idx] lands on the top seat, the short
  /// way round the list — the seats between here and there, not the
  /// whole count, is the distance the dial travels. A far jump slides
  /// through the seats between, the drum's own way of getting somewhere.
  void _animateTo(int idx, int n) {
    final step = _stepFor(n);
    final phi = -_turn / step;
    // The top seat holds the entry round(phi) mod n, so the dial's
    // target is phi = idx + k * n — the k that keeps the travel short.
    var slots = idx - phi;
    final half = n / 2;
    while (slots > half) {
      slots -= n;
    }
    while (slots <= -half) {
      slots += n;
    }
    if (slots.abs() < 0.0005) {
      setState(() => _active = _mod(idx, n));
      return;
    }
    final far = slots.abs() > 1.05;
    _settle.duration = Duration(
      milliseconds: far
          ? (340 + 90 * slots.abs().round()).clamp(340, 760)
          : 460,
    );
    _motion = Tween<double>(
      begin: _turn,
      end: _turn + slots * step,
    ).animate(
      CurvedAnimation(
        parent: _settle,
        curve: far ? Curves.easeOutCubic : Curves.easeOutBack,
      ),
    );
    _active = _mod(idx, n);
    _settle
      ..reset()
      ..forward();
  }

  /// The seat the dial holds at the top right now: the entry the notch
  /// names. Every seat the dial passes answers with the tick.
  void _syncActive() {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    final top = _mod(_phi(entries.length).round(), entries.length);
    if (top != _active) {
      setState(() => _active = top);
      HapticFeedback.selectionClick();
      AppSounds.play(SoundCue.wheelTick);
    }
  }

  @override
  void follow() {
    final sel = selection;
    final count = locations?.length ?? -1;
    if (sel == _followedSel && count == _followedCount) return;
    _followedSel = sel;
    _followedCount = count;
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    final idx = indexOf(entries, sel);
    if (idx < 0) return;
    _animateTo(idx, entries.length);
  }

  Offset _centerOf() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return Offset.zero;
    return box.size.center(Offset.zero) + box.localToGlobal(Offset.zero);
  }

  void _panStart(DragStartDetails d) {
    _settle.stop();
    _motion = null;
    _omega = 0;
    _lastDragAt = null;
    final v = d.globalPosition - _centerOf();
    if (v.distance < 8) {
      _lastPointerAngle = null;
      return;
    }
    _lastPointerAngle = math.atan2(v.dx, -v.dy);
  }

  void _panUpdate(DragUpdateDetails d) {
    final last = _lastPointerAngle;
    if (last == null) return;
    final v = d.globalPosition - _centerOf();
    if (v.distance < 8) return;
    final a = math.atan2(v.dx, -v.dy);
    final delta = _wrap(a - last);
    setState(() => _turn += delta);
    _lastPointerAngle = a;
    // The drag's own momentum: the pointer's angular speed, smoothed —
    // the release reads it and throws the dial the way a flick does.
    final at = d.sourceTimeStamp;
    final prev = _lastDragAt;
    if (at != null && prev != null) {
      final dt = at - prev;
      if (dt > Duration.zero && dt < const Duration(milliseconds: 120)) {
        final inst = delta / (dt.inMicroseconds / 1e6);
        _omega = _omega * 0.6 + inst * 0.4;
      }
    }
    _lastDragAt = at;
    _syncActive();
  }

  void _panEnd(DragEndDetails d) {
    _lastPointerAngle = null;
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    // The flick: the momentum carries the dial a seat or two past the
    // finger before the settle takes over — the wheel answers the hand's
    // speed, the way the game's dial does.
    final step = _stepFor(entries.length);
    final phi = -_turn / step + (_omega * 0.14) / step;
    _animateTo(phi.round(), entries.length);
    _omega = 0;
  }

  /// The pick: the dial walks the choice to the top seat, the tunnel
  /// follows, and the wheel answers — the medal's swell, the wedge's
  /// flash, the tap's sound and the finger's own knock.
  void _pick(int i, List<Location> entries) {
    if (i < 0 || i >= entries.length) return;
    _animateTo(i, entries.length);
    HapticFeedback.mediumImpact();
    AppSounds.play(SoundCue.tap);
    _pulse
      ..reset()
      ..forward();
    choose(entries[i]);
  }

  void _tap(TapUpDetails d) {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (entries.isEmpty) return;
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(d.globalPosition);
    final c = box.size.center(Offset.zero);
    final v = local - c;
    final n = entries.length;
    // The center screen: the active country's own button.
    if (v.distance <= 76) {
      _pick(_mod(_phi(n).round(), n), entries);
      return;
    }
    // A sector: the wedge the plate lights under the top seat. A tap
    // lands anywhere in the slice — the medal at its edge or the space
    // beside it — the way a tap picks the weapon in the game.
    final step = _stepFor(n);
    final phi = _phi(n);
    final drift = (phi.round() - phi) * step;
    final pa = math.atan2(v.dx, -v.dy);
    final j = ((pa - drift) / step).round();
    final angle = drift + j * step;
    final radius = math.min(box.size.width, 352.0) / 2 - 16;
    if (angle.abs() > _arc + step / 2) return;
    if (v.distance > radius + 46) return;
    _pick(_mod(phi.round() + j, n), entries);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = entryList(l);
    if (locations == null || entries.isEmpty) {
      return const SizedBox(height: 348);
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = DesignStyle.of(context);
    final amber = style.navActive;
    final look = AppDesign.current.look(dark);
    final n = entries.length;
    final step = _stepFor(n);
    final phi = -_turn / step;
    final top = phi.round();
    final drift = (top - phi) * step;
    final chosenIndex = indexOf(entries, selection);
    final active = entries[_mod(top, n)];
    final jMax = (_arc / step).ceil();
    final breathe = _breathe?.value ?? 0;
    final pulse = _pulse.isAnimating ? 1.0 - _pulse.value : 0.0;
    final alive = widget.animated && !widget.still;

    // The seats the dial shows: each ring position j seats the entry
    // (top + j) — the drum's own feed — and the arc's ends fade out
    // before they would wrap.
    List<Widget> seats(double radius, Offset center) {
      final out = <Widget>[];
      for (var j = -jMax; j <= jMax; j++) {
        final angle = drift + j * step;
        if (angle.abs() > _arc) continue;
        final i = top + j;
        if (n <= _ringSeats && (i < 0 || i >= n)) continue;
        final idx = _mod(i, n);
        out.add(
          _seat(
            context,
            entries[idx],
            angle: angle,
            radius: radius,
            center: center,
            amber: amber,
            dark: dark,
            border: look.homeCardBorder,
            activeSeat: j == 0,
            chosenSeat: idx == chosenIndex,
            pinned: widget.favorites.any(
              (f) => f.toLowerCase() == entries[idx].code.toLowerCase(),
            ),
          ),
        );
      }
      return out;
    }

    Widget wheel(double size) {
      final radius = size / 2 - 16;
      final center = Offset(size / 2, size / 2 + 3);
      return GestureDetector(
        key: _key,
        behavior: HitTestBehavior.opaque,
        onPanStart: _panStart,
        onPanUpdate: _panUpdate,
        onPanEnd: _panEnd,
        onTapUp: _tap,
        child: SizedBox(
          width: size,
          height: size + 6,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // The HUD disc: the dial's own plate — the rim, the full
              // circle of sector dividers, the ticks, the top seat's lit
              // wedge and the notch, and the rim's own breath while the
              // tunnel carries.
              Positioned.fill(
                child: CustomPaint(
                  painter: _WheelHudPainter(
                    step: step,
                    drift: drift,
                    amber: amber,
                    dark: dark,
                    panel: look.homeCard,
                    ink: look.ink,
                    breath: alive ? breathe : 0,
                    alive: alive,
                  ),
                ),
              ),
              // The medals: the drum feeds them through the ring —
              // the seats keep their spread whatever the list's
              // length, the countries pass through them as the
              // dial turns.
              ...seats(radius, center),
              // The center screen: the active country's flag, its
              // name, and the counter with its own dial arc — the
              // gauge the game hangs under the weapon's name.
              Positioned.fromRect(
                rect: Rect.fromCircle(center: center, radius: 66),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _pick(_mod(top, n), entries),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: dark
                            ? [
                                const Color(0xFF181826),
                                const Color(0xFF0D0D16),
                              ]
                            : [
                                Colors.white,
                                const Color(0xFFF7F3E8),
                              ],
                        stops: const [0.55, 1],
                      ),
                      border: Border.all(
                        color: amber.withValues(alpha: 0.8),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: dark ? 0.55 : 0.16,
                          ),
                          blurRadius: 16,
                        ),
                        if (alive)
                          BoxShadow(
                            color: amber.withValues(
                              alpha: 0.16 + 0.14 * breathe,
                            ),
                            blurRadius: 18 + 10 * breathe,
                          ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // The counter's dial: the gauge arc around the
                        // screen, the amber light walking to the active
                        // seat's share of the list.
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _CenterDialPainter(
                              progress: n <= 1 ? 1 : (top % n + 1) / n,
                              amber: amber,
                              dark: dark,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: amber.withValues(alpha: 0.55),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: flagArt(
                                    context,
                                    active.code,
                                    42,
                                    42,
                                    cover: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                locationName(l, active.code, active.name),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  height: 1.15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                  color: dark ? Colors.white : look.ink,
                                  fontFamily: 'GtaHud',
                                  fontFamilyFallback: const [
                                    'Vazirmatn',
                                    'Inter',
                                  ],
                                ),
                              ),
                              Text(
                                '${_mod(top, n) + 1} / $n',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 17,
                                  height: 1.2,
                                  letterSpacing: 1.4,
                                  color: amber,
                                  fontFamily: 'GtaHud',
                                  fontFamilyFallback: const [
                                    'Vazirmatn',
                                    'Inter',
                                  ],
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: SizedBox(
        height: 372,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, box) {
            final size = math.min(box.maxWidth, 352.0);
            // The opening: the whole wheel pops the way the game's own
            // wheel arrives — the scale eases out past one and settles.
            return Center(
              child: FadeTransition(
                opacity: _openFade,
                child: ScaleTransition(
                  scale: _openScale,
                  child: Transform.scale(
                    // The pick's own swell: the wheel breathes once under
                    // the finger, the light lands with it.
                    scale: 1 + 0.02 * pulse,
                    child: wheel(size),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _seat(
    BuildContext context,
    Location loc, {
    required double angle,
    required double radius,
    required Offset center,
    required Color amber,
    required bool dark,
    required Color border,
    required bool activeSeat,
    required bool chosenSeat,
    required bool pinned,
  }) {
    // The seat's own reach: the medal's presence fades past the front
    // arc, so the wrap to the back happens unseen.
    final t = (1 - angle.abs() / _arc).clamp(0.0, 1.0);
    if (t <= 0.04) return const SizedBox.shrink();
    final pos = center + Offset(math.sin(angle), -math.cos(angle)) * radius;
    final size = 42.0 + 9.0 * t;
    final ring = chosenSeat
        ? widget.accent
        : activeSeat
        ? amber
        : border;
    final ringWidth = chosenSeat ? 2.6 : (activeSeat ? 2.2 : 1.0);
    final lit = chosenSeat || activeSeat;
    final glow = lit
        ? [
            // The medal's own light, doubled on the chosen one — the
            // game's selected weapon reads brighter than its seats.
            BoxShadow(
              color: (chosenSeat ? widget.accent : amber).withValues(
                alpha: 0.42 * (0.4 + 0.6 * t),
              ),
              blurRadius: 15,
            ),
            if (chosenSeat)
              BoxShadow(
                color: widget.accent.withValues(alpha: 0.22),
                blurRadius: 26,
              ),
          ]
        : null;
    final plate = dark
        ? Colors.black.withValues(alpha: 0.52)
        : Colors.white.withValues(alpha: 0.86);
    return Positioned(
      left: pos.dx - (size + 10) / 2,
      top: pos.dy - (size + 10) / 2,
      width: size + 10,
      height: size + 10,
      child: Opacity(
        opacity: (0.22 + 0.78 * t).clamp(0.0, 1.0),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            final l = AppLocalizations.of(context);
            final entries = entryList(l);
            _pick(entries.indexOf(loc), entries);
          },
          onLongPress: widget.onToggleFavorite == null
              ? null
              : () => widget.onToggleFavorite!(loc.code),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size + 10,
                height: size + 10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: plate,
                  border: Border.all(color: ring, width: ringWidth),
                  boxShadow: glow,
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: flagArt(context, loc.code, size, size, cover: true),
                  ),
                ),
              ),
              // The active seat's hairline: the white inner ring the
              // game draws around the weapon the thumb holds.
              if (activeSeat || chosenSeat)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      margin: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.55),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              if (pinned)
                PositionedDirectional(
                  top: -2,
                  end: -2,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: amber,
                      border: Border.all(
                        color: dark ? Colors.black : Colors.white,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 9,
                      color: amber.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The dial's own plate, painted once behind the medals: the dark disc,
/// the amber rim, the full circle of sector dividers, the tick marks the
/// HUD wears, the top seat's lit wedge — the game's own answer to the
/// thumb, its white light over the amber — and the notch that marks the
/// top seat, the one the center screen answers for. While the tunnel
/// carries, the rim's own glow breathes around the dial.
class _WheelHudPainter extends CustomPainter {
  const _WheelHudPainter({
    required this.step,
    required this.drift,
    required this.amber,
    required this.dark,
    required this.panel,
    required this.ink,
    required this.breath,
    required this.alive,
  });

  /// One seat's angle on the ring, and where the top seat stands right
  /// now (its drift from the notch). Every rotating detail reads them.
  final double step;
  final double drift;
  final Color amber;
  final bool dark;
  final Color panel;
  final Color ink;

  /// The breath's phase (0..1) and whether the rim may breathe at all.
  final double breath;
  final bool alive;

  Offset _dir(double a) => Offset(math.sin(a), -math.cos(a));

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 6;
    // The disc: the HUD's dark glass, a touch lighter at the middle —
    // the game's own translucent wheel.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [
            panel.withValues(alpha: dark ? 0.94 : 0.98),
            panel.withValues(alpha: dark ? 0.78 : 0.90),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    // The rim's outer glow: the wheel's halo, breathing only while the
    // tunnel carries (the game's wheel lights the disc it sits on).
    if (alive) {
      canvas.drawCircle(
        c,
        r + 3,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 + 2.5 * breath
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9)
          ..color = amber.withValues(alpha: 0.10 + 0.12 * breath),
      );
    }
    // The sector dividers: the full circle of thin lines the game draws
    // between its weapons' seats — every boundary the drum can carry,
    // from the center's ring to the rim, turning with the dial.
    if (step > 0.05) {
      final divider = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = (dark ? Colors.white : Colors.black).withValues(
          alpha: dark ? 0.16 : 0.10,
        );
      final count = (2 * math.pi / step).round();
      for (var k = 0; k < count; k++) {
        final a = drift + (k + 0.5) * step;
        canvas.drawLine(c + _dir(a) * 78, c + _dir(a) * (r - 2), divider);
      }
    }
    // The wedge: the top seat's own sector, lit the way the game lights
    // the weapon the thumb points at — the white light over the sector,
    // the amber's own glow deepening toward the rim, its two edges drawn
    // and its own bright arc on the ring. It rides with the dial, so the
    // light follows the drag.
    final a0 = drift - step / 2;
    final sweep = step.clamp(0.14, math.pi / 2);
    final wedgeRect = Rect.fromCircle(center: c, radius: r - 1.5);
    final wedge = Path()
      ..moveTo(c.dx, c.dy)
      ..arcTo(wedgeRect, a0 - math.pi / 2, sweep, false)
      ..close();
    // The white light first: the game's sector overlay, brightest at the
    // rim so the wedge reads as one lit slice.
    canvas.drawPath(
      wedge,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: dark ? 0.02 : 0.0),
            Colors.white.withValues(alpha: dark ? 0.13 : 0.20),
          ],
          stops: const [0.25, 1],
        ).createShader(wedgeRect),
    );
    // The amber under it: the HUD's own light.
    canvas.drawPath(
      wedge,
      Paint()
        ..shader = RadialGradient(
          colors: [
            amber.withValues(alpha: 0.02),
            amber.withValues(alpha: dark ? 0.28 : 0.18),
          ],
          stops: const [0.12, 1],
        ).createShader(wedgeRect),
    );
    final wedgeEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = amber.withValues(alpha: dark ? 0.5 : 0.36);
    canvas.drawLine(c + _dir(a0) * 78, c + _dir(a0) * (r - 2), wedgeEdge);
    canvas.drawLine(
      c + _dir(a0 + sweep) * 78,
      c + _dir(a0 + sweep) * (r - 2),
      wedgeEdge,
    );
    canvas.drawArc(
      wedgeRect,
      a0 - math.pi / 2,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4
        ..strokeCap = StrokeCap.round
        ..color = amber.withValues(alpha: dark ? 0.95 : 0.82),
    );
    // The rim: the dial's amber edge, the wheel's own light.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..color = amber.withValues(alpha: dark ? 0.88 : 0.72),
    );
    // The inner hairline: the plate's quiet edge, where the dividers
    // begin.
    canvas.drawCircle(
      c,
      78,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = ink.withValues(alpha: dark ? 0.16 : 0.14),
    );
    // The tick marks: the HUD's own rim graduations, the cardinals
    // longer and lit.
    final tick = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = ink.withValues(alpha: dark ? 0.28 : 0.24);
    final tickLit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..color = amber.withValues(alpha: dark ? 0.8 : 0.62);
    for (var i = 0; i < 28; i++) {
      final a = i * 2 * math.pi / 28;
      final dir = _dir(a);
      final inner = r - (i % 7 == 0 ? 15.0 : 10.0);
      canvas.drawLine(
        c + dir * inner,
        c + dir * (r - 4),
        i % 7 == 0 ? tickLit : tick,
      );
    }
    // The selection notch: the amber arc and the small triangle that
    // mark the top seat — the seat the center screen names.
    final notch = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.4
      ..strokeCap = StrokeCap.round
      ..color = amber.withValues(alpha: dark ? 0.95 : 0.85);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r - 2),
      -math.pi / 2 - 0.16,
      0.32,
      false,
      notch,
    );
    final tip = c + Offset(0, -(r - 12));
    final left = c + Offset(-7, -(r - 2));
    final right = c + Offset(7, -(r - 2));
    canvas.drawPath(
      Path()
        ..moveTo(left.dx, left.dy)
        ..lineTo(tip.dx, tip.dy)
        ..lineTo(right.dx, right.dy)
        ..close(),
      Paint()..color = amber.withValues(alpha: dark ? 0.95 : 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant _WheelHudPainter old) =>
      old.step != step ||
      (old.drift - drift).abs() > 0.0006 ||
      old.amber != amber ||
      old.dark != dark ||
      old.panel != panel ||
      old.ink != ink ||
      (old.breath - breath).abs() > 0.004 ||
      old.alive != alive;
}

/// The center screen's own dial: the counter's gauge — a quiet track
/// round the screen, and the amber arc that walks to the active seat's
/// share of the list, the ammo gauge the game hangs under the weapon's
/// name.
class _CenterDialPainter extends CustomPainter {
  const _CenterDialPainter({
    required this.progress,
    required this.amber,
    required this.dark,
  });

  /// The active seat's share (0..1], drawn from the top, clockwise.
  final double progress;
  final Color amber;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 2.5;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = (dark ? Colors.white : Colors.black).withValues(
          alpha: dark ? 0.14 : 0.10,
        ),
    );
    final clamped = progress.clamp(0.02, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * clamped,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..color = amber.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant _CenterDialPainter old) =>
      old.progress != progress ||
      old.amber != amber ||
      old.dark != dark;
}
