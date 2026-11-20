import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/core_api.dart' show CoreApiException;
import '../core/core_controller.dart';
import '../core/models.dart';
import '../core/remote_flags.dart' show bundledFlags;
import '../l10n/app_localizations.dart';
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
/// - the aether offers the system's capsule options in one rail;
/// - the ios snaps through big circular medals, the dock's own emphasis;
/// - the zed keeps a board in its bento cell, paged, with its dots;
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
  FlagShape.squircle => 10,
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
    return GridView.count(
      crossAxisCount: widget.columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.92,
      children: [
        for (var i = 0; i < visible.length; i++)
          _BoardTile(
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
        if (showAll)
          _BoardTile.all(
            accent: widget.accent,
            border: widget.border,
            dark: dark,
            label: l.flagAllPlaces,
            onTap: widget.onOpenServers,
          ),
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
              Expanded(
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

/// The system's own options: the countries as capsules in one rail, the
/// chosen one filled with the accent's blue — the aether's voice for a
/// choice among many. The rail scrolls in the system's bounce and
/// follows a choice made on the servers page.
class FlagCapsules extends StatefulWidget {
  const FlagCapsules({
    super.key,
    required this.core,
    required this.border,
    required this.accent,
    this.favorites = const [],
    this.onToggleFavorite,
  });

  final CoreController core;
  final Color border;
  final Color accent;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;

  @override
  State<FlagCapsules> createState() => _FlagCapsulesState();
}

class _FlagCapsulesState extends State<FlagCapsules> with FlagChoices {
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
    final width = _rail.position.viewportDimension;
    final target = (index * 132.0 - width / 2 + 66.0)
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
      return const SizedBox(height: 46);
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    final chosenIndex = indexOf(entries, selection);
    return SizedBox(
      height: 46,
      child: ListView.separated(
        controller: _rail,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
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
                height: 42,
                padding: const EdgeInsetsDirectional.fromSTEB(5, 4, 14, 4),
                decoration: BoxDecoration(
                  color: chosen
                      ? widget.accent
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(
                    color: chosen
                        ? widget.accent
                        : widget.border.withValues(alpha: dark ? 0.55 : 0.5),
                    width: chosen ? 1.4 : 1,
                  ),
                  boxShadow: chosen
                      ? [
                          BoxShadow(
                            color: widget.accent.withValues(
                              alpha: dark ? 0.35 : 0.24,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: flagArt(context, loc.code, 30, 30, cover: true),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      locationName(l, loc.code, loc.name),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: chosen ? FontWeight.w700 : FontWeight.w600,
                        color: chosen
                            ? (widget.accent.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white)
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
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
      height: 116,
      child: PageView.builder(
        controller: _controller,
        clipBehavior: Clip.none,
        onPageChanged: (page) {
          // A follow's own landing answers the same event, and the page
          // the choice already owns says nothing new: only the finger's
          // arrival at a new country moves the tunnel.
          if (!_moving && page >= 0 && page < entries.length) {
            final loc = entries[page];
            final chosen = isRecommendedPlace(loc.code)
                ? ''
                : loc.code.toLowerCase();
            if (chosen != selection) choose(loc);
          }
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
    );
  }
}

/// The zed's board: the countries in their bento cell, paged — two rows
/// of tiles a page, the page indicator's dots under them, the chosen
/// tile glowing the violet's own light. The pages snap with the
/// expressive spring, and a choice made on the servers page walks the
/// board to its own page.
class FlagPager extends StatefulWidget {
  const FlagPager({
    super.key,
    required this.core,
    required this.border,
    required this.accent,
    this.favorites = const [],
    this.onToggleFavorite,
  });

  final CoreController core;
  final Color border;
  final Color accent;
  final List<String> favorites;
  final void Function(String code)? onToggleFavorite;

  @override
  State<FlagPager> createState() => _FlagPagerState();
}

class _FlagPagerState extends State<FlagPager> with FlagChoices {
  PageController? _controller;
  bool _moving = false;
  int _page = 0;

  @override
  CoreController get core => widget.core;
  @override
  List<String> get favorites => widget.favorites;
  @override
  void Function(String code)? get onToggleFavorite => widget.onToggleFavorite;

  static const _perPage = 8;

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
    final target = index ~/ _perPage;
    if ((controller.page ?? -1).round() != target) {
      _moving = true;
      controller
          .animateToPage(
            target,
            duration: const Duration(milliseconds: 380),
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
      return const SizedBox(height: 148);
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = DesignStyle.of(context);
    final scheme = Theme.of(context).colorScheme;
    final chosenIndex = indexOf(entries, selection);
    final pages = (entries.length + _perPage - 1) ~/ _perPage;
    if (_controller == null) {
      final start = chosenIndex < 0 ? 0 : chosenIndex ~/ _perPage;
      _controller = PageController(initialPage: start);
      // The dots read the page from here, not from the controller's own
      // initial page: the first landing must light the right dot.
      _page = start;
    }
    return Column(
      children: [
        SizedBox(
          height: 118,
          child: PageView.builder(
            controller: _controller,
            clipBehavior: Clip.none,
            onPageChanged: (page) => setState(() => _page = page),
            itemBuilder: (context, p) {
              final start = p * _perPage;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.45,
                  children: [
                    for (var i = start;
                        i < start + _perPage && i < entries.length;
                        i++)
                      _PagerTile(
                        location: entries[i],
                        chosen: i == chosenIndex,
                        accent: widget.accent,
                        border: widget.border,
                        dark: dark,
                        round: styleSmallRound(style.flagShape),
                        onTap: () => choose(entries[i]),
                        onLongPress: widget.onToggleFavorite == null
                            ? null
                            : () => widget.onToggleFavorite!(entries[i].code),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var p = 0; p < pages; p++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: p == _page ? 16 : 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: p == _page
                      ? widget.accent
                      : scheme.outlineVariant.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// One tile of the zed's board page: the design's own cut, the chosen
/// one framed and lit from beneath.
class _PagerTile extends StatelessWidget {
  const _PagerTile({
    required this.location,
    required this.chosen,
    required this.accent,
    required this.border,
    required this.dark,
    required this.round,
    required this.onTap,
    this.onLongPress,
  });

  final Location location;
  final bool chosen;
  final Color accent;
  final Color border;
  final bool dark;
  final double round;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final edge = chosen
        ? accent.withValues(alpha: 0.95)
        : border.withValues(alpha: dark ? 0.5 : 0.45);
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: chosen
                ? accent.withValues(alpha: dark ? 0.2 : 0.12)
                : Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHigh.withValues(
                    alpha: dark ? 0.55 : 0.85,
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: edge, width: chosen ? 1.6 : 1),
            boxShadow: chosen
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: dark ? 0.3 : 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(round),
            child: SizedBox(
              width: 42,
              height: 29,
              child: flagArt(context, location.code, 42, 29),
            ),
          ),
        ),
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
          LayoutBuilder(
            builder: (context, box) {
              final tileW = (box.maxWidth - 18) / 2;
              return SizedBox(
                height: _rowHeight * (scrollable ? _visibleRows : rows),
                child: GridView.count(
                  controller: scrollable ? _columns : null,
                  crossAxisCount: 2,
                  shrinkWrap: !scrollable,
                  physics: scrollable
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  childAspectRatio: tileW / _rowHeight,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 18,
                  padding: EdgeInsets.zero,
                  children: [
                    for (var i = 0; i < entries.length; i++)
                      _RegionRow(
                        location: entries[i],
                        chosen: i == chosenIndex,
                        pinned: favorites.any(
                          (f) =>
                              f.toLowerCase() == entries[i].code.toLowerCase(),
                        ),
                        ink: widget.text,
                        muted: widget.muted,
                        accent: widget.accent,
                        display: widget.display,
                        displayFallback: widget.displayFallback,
                        onTap: () => choose(entries[i]),
                        onLongPress: widget.onToggleFavorite == null
                            ? null
                            : () => widget.onToggleFavorite!(entries[i].code),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
