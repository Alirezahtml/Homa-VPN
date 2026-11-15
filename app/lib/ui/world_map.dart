import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The home page's world, drawn for real: every country's own official
/// outline from one compact vector file (assets/map/world.bin, generated
/// from Natural Earth's admin-0 country polygons — public-domain data,
/// 50 m resolution), the graticule over the oceans, and the chosen
/// country lit in the connection's color with a breathing halo at its
/// anchor. While the VPN carries the traffic the map breathes; off, it
/// rests — the battery too. Nothing is tapped, nothing moves.

/// One country of the world file: its ISO code, where its anchor sits on
/// the map (the same units as [WorldMap.width]), and its outline rings.
@immutable
class WorldCountry {
  const WorldCountry(this.code, this.anchorX, this.anchorY, this.rings);

  final String code;
  final double anchorX;
  final double anchorY;
  final List<List<ui.Offset>> rings;
}

/// The parsed `assets/map/world.bin`: the whole world in ~400 KB, every
/// border at Natural Earth's 50 m fidelity.
///
/// The file's own format (magic `ZWM1`, generation in scripts/):
/// a u16 count, then per country a two-letter code, u16 x and y anchor
/// (the y half scale, undone here), a u8 ring count, and each ring a u16
/// point count followed by u16 x,y pairs (the y again half scale).
/// A country's rings carry its holes with it: the painter fills with an
/// even-odd rule, so an enclave reads as its own land.
abstract final class WorldMap {
  static const double width = 65535;
  static const double height = width / 2;

  static Future<List<WorldCountry>>? _loading;

  /// Reads and parses the world once per run — the same future while it
  /// reads, so a rebuilt page never waits again; the caller paints with it.
  static Future<List<WorldCountry>> load() => _loading ??= _read();

  static Future<List<WorldCountry>> _read() async {
    final data = await rootBundle.load('assets/map/world.bin');
    return _parse(data);
  }

  static List<WorldCountry> _parse(ByteData d) {
    try {
      if (d.lengthInBytes < 7) return const [];
      if (d.getUint8(0) != 0x5A ||
          d.getUint8(1) != 0x57 ||
          d.getUint8(2) != 0x4D ||
          d.getUint8(3) != 0x31) {
        return const [];
      }
      var o = 4;
      final count = d.getUint16(o, Endian.little);
      o += 2;
      final out = <WorldCountry>[];
      for (var c = 0; c < count; c++) {
        final code = String.fromCharCode(d.getUint8(o)) +
            String.fromCharCode(d.getUint8(o + 1));
        o += 2;
        final ax = d.getUint16(o, Endian.little).toDouble();
        final ay = d.getUint16(o + 2, Endian.little) * 0.5;
        o += 4;
        final ringCount = d.getUint8(o);
        o += 1;
        final rings = <List<ui.Offset>>[];
        for (var r = 0; r < ringCount; r++) {
          final points = d.getUint16(o, Endian.little);
          o += 2;
          final ring = <ui.Offset>[];
          for (var p = 0; p < points; p++) {
            final x = d.getUint16(o, Endian.little).toDouble();
            final y = d.getUint16(o + 2, Endian.little) * 0.5;
            o += 4;
            ring.add(ui.Offset(x, y));
          }
          rings.add(ring);
        }
        out.add(WorldCountry(code, ax, ay, rings));
      }
      return out;
    } on RangeError {
      // A truncated file: an empty world, quietly, rather than a crash.
      return const [];
    }
  }
}

/// One country's ready geometry: its code, where its anchor sits on the
/// drawn map (already scaled), and its outline path — every ring of it,
/// outer rings and holes together, filled by an even-odd rule so an
/// enclave (Lesotho in South Africa, San Marino in Italy) reads through.
@immutable
class WorldShape {
  const WorldShape(this.code, this.path, this.anchor);

  final String code;
  final ui.Path path;
  final ui.Offset anchor;
}

/// The backdrop: the map at more than the screen's width — bigger than
/// the page, so the continents are not squeezed into a strip — centered
/// where asked, in the theme's ink with the chosen country lit in the
/// connection's color.
///
/// The [ink] is a light color on the dark theme and a dark one on the
/// day — the same quiet look the old dot picture had, at any resolution
/// now, because the world is drawn, not scaled.
class WorldMapBackdrop extends StatefulWidget {
  const WorldMapBackdrop({
    super.key,
    required this.countries,
    required this.ink,
    required this.accent,
    required this.selected,
    required this.animated,
    this.alignment = Alignment.center,
    this.scale = 1.45,
  });

  /// The world, from [WorldMap.load]; empty until it arrives.
  final List<WorldCountry> countries;

  /// The theme's ink: the land's fills and edges read in it.
  final Color ink;

  /// The state's color: the chosen country is lit with it.
  final Color accent;

  /// The chosen country's ISO code, upper-case; '' for none.
  final String selected;

  /// Whether the map breathes: the halo and sheen move while the VPN
  /// carries the traffic; off, everything holds still.
  final bool animated;

  final Alignment alignment;

  /// How much wider than the page the world is drawn: 1 draws it exactly
  /// the page's width, where every continent reads as a squeezed ribbon;
  /// more gives the countries room, and the page clips what runs over.
  final double scale;

  @override
  State<WorldMapBackdrop> createState() => _WorldMapBackdropState();
}

class _WorldMapBackdropState extends State<WorldMapBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath =
      AnimationController(vsync: this, duration: const Duration(seconds: 4));

  /// The countries' paths, built once for the map's size on screen: the
  /// outlines are the expensive part (the official borders carry about a
  /// hundred thousand points), and the breath must not rebuild them —
  /// only redraw the paths it already has.
  List<WorldShape>? _shapes;
  List<WorldCountry>? _builtFrom;
  double? _builtForW;

  void _ensureShapes(double mapW, double mapH) {
    if (widget.countries.isEmpty) return;
    if (identical(_builtFrom, widget.countries) && _builtForW == mapW) return;
    final sx = mapW / WorldMap.width;
    final sy = mapH / WorldMap.height;
    _shapes = [
      for (final c in widget.countries)
        WorldShape(
          c.code,
          _pathOf(c, sx, sy),
          ui.Offset(c.anchorX * sx, c.anchorY * sy),
        ),
    ];
    _builtFrom = widget.countries;
    _builtForW = mapW;
  }

  /// The country's whole outline, one path for every ring — the fill
  /// runs with an even-odd rule, so a hole shows the country around it.
  static ui.Path _pathOf(WorldCountry c, double sx, double sy) {
    final path = ui.Path();
    for (final ring in c.rings) {
      if (ring.isEmpty) continue;
      path.moveTo(ring.first.dx * sx, ring.first.dy * sy);
      for (var i = 1; i < ring.length; i++) {
        path.lineTo(ring[i].dx * sx, ring[i].dy * sy);
      }
      path.close();
    }
    path.fillType = ui.PathFillType.evenOdd;
    return path;
  }

  @override
  void initState() {
    super.initState();
    _breath.value = 0.5;
    if (widget.animated) _breath.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(WorldMapBackdrop old) {
    super.didUpdateWidget(old);
    if (old.animated != widget.animated) {
      if (widget.animated) {
        _breath.repeat(reverse: true);
      } else {
        _breath.stop();
      }
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, box) {
          if (box.maxWidth <= 0 || widget.countries.isEmpty) {
            return const SizedBox.expand();
          }
          // The world is 2:1: it is drawn wider than the page (scale),
          // floats where asked, and what runs over the page's edge is
          // clipped — bigger countries, no squeezed ribbon, no bleed.
          final mapW = box.maxWidth * widget.scale;
          final mapH = mapW / 2;
          _ensureShapes(mapW, mapH);
          return SizedBox.expand(
            child: ClipRect(
              child: Align(
                alignment: widget.alignment,
                child: SizedBox(
                  width: mapW,
                  height: mapH,
                  child: AnimatedBuilder(
                    animation: _breath,
                    builder: (context, _) => CustomPaint(
                      size: Size(mapW, mapH),
                      painter: _WorldPainter(
                        shapes: _shapes ?? const <WorldShape>[],
                        ink: widget.ink,
                        accent: widget.accent,
                        selected: widget.selected,
                        t: widget.animated ? _breath.value : 0.5,
                      ),
                    ),
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

/// The painter: the graticule, the land, the lit country, its anchor's
/// halo, and a quiet sheen that follows the breath. The paths arrive
/// built ([WorldShape]); a frame only draws them.
class _WorldPainter extends CustomPainter {
  _WorldPainter({
    required this.shapes,
    required this.ink,
    required this.accent,
    required this.selected,
    required this.t,
  });

  final List<WorldShape> shapes;
  final Color ink;
  final Color accent;
  final String selected;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // A light ink on the night, a dark one on the day — the map's quiet
    // is a matter of alpha, not hue, in either theme. The land sits a
    // shade above the graticule, so a country reads as a shape, not as
    // noise.
    final dark = ink.computeLuminance() > 0.5;
    final landInk = ink.withValues(alpha: dark ? 0.20 : 0.14);
    final lineInk = ink.withValues(alpha: dark ? 0.32 : 0.26);

    // The graticule: every 30 degrees, thinner than the land's edge.
    final grid = Paint()
      ..color = ink.withValues(alpha: dark ? 0.055 : 0.05)
      ..strokeWidth = 0.6;
    for (var lon = 0; lon <= 6; lon++) {
      final x = lon / 6 * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var lat = 0; lat <= 3; lat++) {
      final y = lat / 3 * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // The chosen country, found once: it is lit while the rest stays ink.
    WorldShape? chosen;
    if (selected.length == 2) {
      for (final s in shapes) {
        if (s.code == selected) {
          chosen = s;
          break;
        }
      }
    }

    final land = Paint()
      ..color = landInk
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final edge = Paint()
      ..color = lineInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..isAntiAlias = true
      // Rounded joins and caps: the coastlines' corners meet smoothly —
      // the map reads clean at any zoom, never as a jagged wire.
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    for (final s in shapes) {
      if (identical(s, chosen)) continue;
      canvas.drawPath(s.path, land);
      canvas.drawPath(s.path, edge);
    }

    // The breath every moving part below reads: 0 at rest's start, 1 at
    // its peak, back and forth over the controller's period.
    final breathe = 0.5 - 0.5 * math.cos(2 * math.pi * t);

    if (chosen != null) {
      // The lit country: a fill in the state's color, soft, over an edge
      // more present than the ink's own.
      final fill = Paint()
        ..color = accent.withValues(alpha: dark ? 0.30 : 0.22)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      final litEdge = Paint()
        ..color = accent.withValues(alpha: dark ? 0.85 : 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(chosen.path, fill);
      canvas.drawPath(chosen.path, litEdge);
      // The anchor's halo: a soft bloom of light first — blurred, so it
      // glows rather than rings — then three rings that swell and shrink
      // with the breath, and the dot at the middle of them.
      final anchor = chosen.anchor;
      canvas.drawCircle(
        anchor,
        26 * (0.9 + 0.25 * breathe),
        Paint()
          ..color = accent.withValues(
            alpha: (dark ? 0.30 : 0.20) * (0.45 + 0.55 * breathe),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
          ..isAntiAlias = true,
      );
      for (final (r, a) in [
        (30.0, 0.14),
        (20.0, 0.24),
        (12.0, 0.40),
      ]) {
        canvas.drawCircle(
          anchor,
          r * (0.85 + 0.3 * breathe),
          Paint()
            ..color = accent.withValues(
              alpha: a * (dark ? 1.0 : 0.7) * (0.5 + 0.5 * breathe),
            )
            ..isAntiAlias = true,
        );
      }
      canvas.drawCircle(
        anchor,
        3.0 + 1.4 * breathe,
        Paint()
          ..color = accent.withValues(alpha: dark ? 0.9 : 0.75)
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(_WorldPainter old) =>
      old.selected != selected ||
      old.accent != accent ||
      old.ink != ink ||
      old.shapes != shapes ||
      (old.t - t).abs() > 0.003;
}
