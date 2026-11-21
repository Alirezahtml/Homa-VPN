// The servers list's own presentations: the designs do not share one
// list — each wears its own, the way each wears its own cards, headers
// and flags. The choice's machinery (the search, the delays, the busy
// states) stays the page's; what changes is how the places stand:
//
// - the monochrome's grid of tiles (the page's own default);
// - the ios's inset grouped table — the system settings' own list, the
//   hairline inset separators, the checkmark at the chosen row's end;
// - the gazette's ruled page — the paper's own region index, the serif
//   names, the dot leaders, the delay at every line's end, the chosen
//   line's bullet and red ink;
// - the gta's HUD slots — the dark panels with the amber hairlines, the
//   blip at every row's head, the chosen slot lit;
// - the pixel's tonal cards — Material You's own big filled rows, the
//   state layer speaking, no line at all;
// - the bento's board — the very-round tiles the box lays out, the
//   chosen one framed in the tangerine.
library;

import 'package:flutter/material.dart';

import '../core/models.dart';
import '../l10n/app_localizations.dart';
import 'design.dart';
import 'design_style.dart';
import 'flag_modes.dart' show flagArt, locationName;
import 'motion.dart' show Reveal;
import 'widgets.dart' show CountryFlag, delayColor, typefacesOf;

/// One place as the list reads it: the entry itself, the name in the
/// page's language, and the row's own states (the page's choice, the
/// choice being saved).
class ServerRow {
  const ServerRow({
    required this.location,
    required this.name,
    required this.selected,
    required this.busy,
  });

  final Location location;
  final String name;
  final bool selected;
  final bool busy;
}

/// The servers list, in the design's own presentation. The page hands
/// the rows and the two callbacks; the design decides what a row looks
/// like and how the list scrolls.
Widget serversListFor(
  BuildContext context, {
  required List<ServerRow> rows,
  required ValueChanged<Location> onChoose,
}) {
  final key = AppDesign.current.key;
  return switch (key) {
    'ios' => _IosServerList(rows: rows, onChoose: onChoose),
    'gazette' => _GazetteServerList(rows: rows, onChoose: onChoose),
    'gta' => _GtaServerList(rows: rows, onChoose: onChoose),
    'pixel' => _PixelServerList(rows: rows, onChoose: onChoose),
    'bento' => _BentoServerList(rows: rows, onChoose: onChoose),
    _ => _TileServerList(rows: rows, onChoose: onChoose),
  };
}

// ---------------------------------------------------------------------------
// The monochrome's own grid of tiles — the page's default list.
// ---------------------------------------------------------------------------

class _TileServerList extends StatelessWidget {
  const _TileServerList({required this.rows, required this.onChoose});

  final List<ServerRow> rows;
  final ValueChanged<Location> onChoose;

  @override
  Widget build(BuildContext context) {
    final style = DesignStyle.of(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        mainAxisExtent: 72,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final row = rows[i];
        return Material(
          color: row.selected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
              : Theme.of(context).colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(style.listRadius),
            side: BorderSide(
              color: row.selected
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7)
                  : Theme.of(context).colorScheme.outlineVariant,
              width: row.selected ? 1.6 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => onChoose(row.location),
            borderRadius: BorderRadius.circular(style.listRadius),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CountryFlag(code: row.location.code, width: 34),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          row.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: row.selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox.square(
                        dimension: 20,
                        child: row.busy
                            ? const Padding(
                                padding: EdgeInsets.all(3),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : row.selected
                            ? Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ServerDelayBadge(location: row.location),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// The ios's inset grouped table.
// ---------------------------------------------------------------------------

class _IosServerList extends StatelessWidget {
  const _IosServerList({required this.rows, required this.onChoose});

  final List<ServerRow> rows;
  final ValueChanged<Location> onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    return Material(
      color: look.homeCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: look.homeCardBorder.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 0.5,
                indent: 56,
                color: look.homeCardBorder.withValues(alpha: 0.55),
              ),
            _iosRow(context, rows[i], dark, look),
          ],
        ],
      ),
    );
  }

  Widget _iosRow(
    BuildContext context,
    ServerRow row,
    bool dark,
    DesignLook look,
  ) {
    final theme = Theme.of(context);
    final style = DesignStyle.of(context);
    final blue = style.navActive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChoose(row.location),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(14, 9, 12, 9),
          child: Row(
            children: [
              ClipOval(
                child: SizedBox.square(
                  dimension: 28,
                  child: flagArt(context, row.location.code, 28, 28,
                      cover: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  row.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: row.selected ? FontWeight.w700 : FontWeight.w500,
                    color: look.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ServerDelayBadge(location: row.location, quiet: true),
              // The chosen row's checkmark, the system's own mark — and
              // a busy row's spinner in its seat while the choice saves.
              const SizedBox(width: 6),
              SizedBox.square(
                dimension: 20,
                child: row.busy
                    ? const Padding(
                        padding: EdgeInsets.all(3),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : row.selected
                    ? Icon(Icons.check_rounded, size: 20, color: blue)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The gazette's ruled page: the paper's own region index.
// ---------------------------------------------------------------------------

class _GazetteServerList extends StatelessWidget {
  const _GazetteServerList({required this.rows, required this.onChoose});

  final List<ServerRow> rows;
  final ValueChanged<Location> onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    final typefaces = typefacesOf(context);
    final style = DesignStyle.of(context);
    final red = style.danger;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: look.homeCardBorder, width: 1.1),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 0.7,
                color: look.homeCardBorder.withValues(alpha: 0.5),
              ),
            _paperRow(context, rows[i], look, typefaces, red),
          ],
        ],
      ),
    );
  }

  Widget _paperRow(
    BuildContext context,
    ServerRow row,
    DesignLook look,
    HomaTypefaces typefaces,
    Color red,
  ) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lineInk = row.selected ? red : look.ink;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChoose(row.location),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              // The chosen line's bullet: the print's own mark.
              SizedBox(
                width: 12,
                child: row.selected
                    ? Center(
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: red,
                          ),
                        ),
                      )
                    : null,
              ),
              Expanded(
                flex: 5,
                child: Text(
                  row.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.1,
                    fontWeight: row.selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: lineInk,
                    fontFamily: typefaces.display,
                    fontFamilyFallback: typefaces.displayFallback,
                  ),
                ),
              ),
              // The dot leader: the paper's own thread to the figure.
              Expanded(
                flex: 2,
                child: Divider(
                  color: look.muted.withValues(alpha: 0.4),
                  thickness: 1,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              // The delay at the line's end, the way the index prints
              // its figures — and the busy row's small press.
              SizedBox.square(
                dimension: 16,
                child: row.busy
                    ? const Padding(
                        padding: EdgeInsets.all(2),
                        child: CircularProgressIndicator(strokeWidth: 1.6),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 6),
              Text(
                row.location.answered
                    ? l.milliseconds(row.location.pingMs)
                    : row.location.pingError.isNotEmpty
                    ? l.noAnswer
                    : '—',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: row.selected
                      ? red
                      : (row.location.answered
                            ? delayColor(row.location.pingMs)
                            : look.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The gta's HUD slots.
// ---------------------------------------------------------------------------

class _GtaServerList extends StatelessWidget {
  const _GtaServerList({required this.rows, required this.onChoose});

  final List<ServerRow> rows;
  final ValueChanged<Location> onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    final style = DesignStyle.of(context);
    final amber = style.navActive;
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == rows.length - 1 ? 0 : 8),
            child: Material(
              color: look.homeCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: rows[i].selected
                      ? amber
                      : look.homeCardBorder.withValues(alpha: 0.9),
                  width: rows[i].selected ? 1.8 : 1.2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: InkWell(
                onTap: () => onChoose(rows[i].location),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    14,
                    11,
                    12,
                    11,
                  ),
                  decoration: BoxDecoration(
                    color: rows[i].selected
                        ? amber.withValues(alpha: dark ? 0.10 : 0.06)
                        : null,
                  ),
                  child: Row(
                    children: [
                      // The slot's blip: the marker disc the map wears,
                      // at every row's head.
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rows[i].selected
                              ? amber
                              : (dark
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.18)),
                          border: Border.all(
                            color: dark
                                ? Colors.black.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.7),
                            width: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rows[i].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: rows[i].selected
                                ? amber
                                : look.ink,
                            fontFamily: 'GtaHud',
                            fontFamilyFallback: const ['Vazirmatn', 'Inter'],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ServerDelayBadge(location: rows[i].location),
                      const SizedBox(width: 6),
                      SizedBox.square(
                        dimension: 20,
                        child: rows[i].busy
                            ? const Padding(
                                padding: EdgeInsets.all(3),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: amber,
                                ),
                              )
                            : rows[i].selected
                            ? Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: amber,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// The pixel's tonal cards.
// ---------------------------------------------------------------------------

class _PixelServerList extends StatelessWidget {
  const _PixelServerList({required this.rows, required this.onChoose});

  final List<ServerRow> rows;
  final ValueChanged<Location> onChoose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == rows.length - 1 ? 0 : 10),
            child: Material(
              color: rows[i].selected
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.10)
                  : Theme.of(context).colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: InkWell(
                onTap: () => onChoose(rows[i].location),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    16,
                    13,
                    14,
                    13,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                        ),
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.all(3),
                        child: flagArt(
                          context,
                          rows[i].location.code,
                          38,
                          28,
                          cover: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rows[i].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: rows[i].selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ServerDelayBadge(location: rows[i].location),
                      const SizedBox(width: 8),
                      SizedBox.square(
                        dimension: 22,
                        child: rows[i].busy
                            ? const Padding(
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : rows[i].selected
                            ? Icon(
                                Icons.check_circle_rounded,
                                size: 22,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// The bento's board of tiles.
// ---------------------------------------------------------------------------

class _BentoServerList extends StatelessWidget {
  const _BentoServerList({required this.rows, required this.onChoose});

  final List<ServerRow> rows;
  final ValueChanged<Location> onChoose;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    final style = DesignStyle.of(context);
    final tangerine = style.navActive;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 92,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final row = rows[i];
        return Material(
          color: look.homeCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: row.selected
                  ? tangerine
                  : look.homeCardBorder.withValues(alpha: 0.8),
              width: row.selected ? 2 : 1.1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: InkWell(
            onTap: () => onChoose(row.location),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: SizedBox.square(
                          dimension: 30,
                          child: flagArt(
                            context,
                            row.location.code,
                            30,
                            30,
                            cover: true,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox.square(
                        dimension: 20,
                        child: row.busy
                            ? const Padding(
                                padding: EdgeInsets.all(3),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : row.selected
                            ? Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: tangerine,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  Text(
                    row.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: row.selected ? tangerine : look.ink,
                    ),
                  ),
                  ServerDelayBadge(location: row.location),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// The shared furniture: the flag, the delay's badge.
// ---------------------------------------------------------------------------

/// The delay's badge, shared by every presentation: the measured figure
/// in its own color, the spinner while the numbers are being made. The
/// quiet cut drops the pill's fill (the ios table wears the bare
/// figure), the loud one keeps it.
class ServerDelayBadge extends StatelessWidget {
  const ServerDelayBadge({
    super.key,
    required this.location,
    this.quiet = false,
  });

  final Location location;
  final bool quiet;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final loc = location;
    final (text, color) = loc.answered
        ? (l.milliseconds(loc.pingMs), delayColor(loc.pingMs))
        : loc.pingError.isNotEmpty
        ? (l.noAnswer, muted)
        : ('—', muted);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: quiet
          ? null
          : BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// The list's entrance: the rows walk in with the page's own reveal.
class ServerListReveal extends StatelessWidget {
  const ServerListReveal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Reveal(index: 2, child: child);
}
