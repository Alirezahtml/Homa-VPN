import 'dart:async';

import 'package:flutter/material.dart';

import '../core/core_api.dart' show CoreApiException;
import '../core/core_controller.dart';
import '../core/models.dart';
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
      return const SizedBox(height: 108);
    }
    final index = _indexOf(entries, _selection);
    final centered = index >= 0 ? entries[index] : null;
    return Column(
      children: [_wheel(entries), _name(l, centered)],
    );
  }

  Widget _wheel(List<Location> entries) => SizedBox(
    height: 78,
    child: PageView.builder(
      controller: _controller,
      // The list repeats, so the wheel has no ends to bump into.
      itemCount: entries.length * _repeats,
      padEnds: false,
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
            // How close this page sits to the middle: the middle one is
            // full size, its neighbors shrink away.
            var distance = 1.0;
            if (_controller.hasClients &&
                _controller.position.haveDimensions) {
              distance = ((_controller.page ?? page.toDouble()) - page)
                  .abs()
                  .clamp(0.0, 1.0);
            }
            final scale = 1.0 - 0.34 * distance;
            final opacity = 1.0 - 0.45 * distance;
            final chosen =
                !isRecommendedPlace(loc.code) &&
                loc.code.toLowerCase() == _selection;
            final recommended =
                isRecommendedPlace(loc.code) && _selection.isEmpty;
            return Center(
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => unawaited(_choose(loc)),
                    child: Container(
                      width: 54,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: chosen || recommended
                              ? widget.accent
                              : widget.border,
                          width: chosen || recommended ? 2 : 0.5,
                        ),
                      ),
                      child: CountryFlag(code: loc.code, width: 54),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );

  /// The chosen country's name under the flags; the fastest choice has no
  /// country, and keeps its own line empty rather than naming another.
  Widget _name(AppLocalizations l, Location? centered) => SizedBox(
    height: 28,
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Text(
        centered == null
            ? (_selection == 'fastest' ? l.modeFastest : '')
            : locationName(l, centered.code, centered.name),
        key: ValueKey(centered?.code ?? _selection),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: widget.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

/// How many copies of the wheel the page view carries, so either end can
/// still scroll: enough to reach either end from any start, then some.
const _repeats = 5;
