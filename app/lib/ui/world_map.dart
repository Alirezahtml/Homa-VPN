import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets.dart' show CountryFlag;

/// The home page's world, drawn for real: every country's own official
/// outline from one compact vector file (assets/map/world.bin, generated
/// from Natural Earth's admin-0 country polygons — public-domain data,
/// 50 m resolution), carried onto a silver globe. Nothing is stretched,
/// nothing squeezed: the outlines are the official ones, projected the
/// way a ball seen from space is — the orthographic view, turned so the
/// chosen country faces the viewer.
///
/// The globe is where the home's story is told: the chosen country lit
/// in the connection's light, a glowing pin at its anchor with a floating
/// card that names it, and the great-circle paths from it to the world's
/// hubs burning slow while the VPN carries the traffic. Off, the globe
/// rests — the battery too. Nothing is tapped, nothing is dragged.

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
        final code =
            String.fromCharCode(d.getUint8(o)) +
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

/// A place on the sphere, in degrees: the latitude and longitude the
/// globe's math works in. A country's anchor and the connection hubs
/// both speak this language.
@immutable
class GlobePlace {
  const GlobePlace(this.latDeg, this.lonDeg);

  final double latDeg;
  final double lonDeg;

  /// The place's unit vector: x toward (0°E, 0°N), y toward 90°E, z
  /// toward the north pole.
  (double, double, double) get unit {
    final lat = latDeg * math.pi / 180;
    final lon = lonDeg * math.pi / 180;
    final cosLat = math.cos(lat);
    return (cosLat * math.cos(lon), cosLat * math.sin(lon), math.sin(lat));
  }

  /// The central angle to [other], in degrees — how far apart two places
  /// really are over the sphere's skin.
  double angleTo(GlobePlace other) {
    final (ax, ay, az) = unit;
    final (bx, by, bz) = other.unit;
    final d = (ax * bx + ay * by + az * bz).clamp(-1.0, 1.0);
    return math.acos(d) * 180 / math.pi;
  }
}

/// The anchor of a country in the world file, as a place on the sphere:
/// the file's equirectangular units turned back into latitude and
/// longitude.
GlobePlace globePlaceOf(WorldCountry c) => GlobePlace(
  90 - c.anchorY / WorldMap.height * 180,
  c.anchorX / WorldMap.width * 360 - 180,
);

/// The flat map's projection: the standard Web Mercator every atlas and
/// every phone's map speaks. North stays north-up, shapes keep the
/// proportions the eye expects from a real map — nothing squeezed flat
/// by a 2:1 ribbon, nothing pulled wide at the top of the world. The
/// file's points arrive in equirectangular degrees; the world's edge is
/// the projection's own ±85.0511°, the same cut Google's and Apple's
/// maps draw, so the borders land exactly where a standard map puts
/// them.
const mercatorMaxLat = 85.0511287798066;

/// A latitude's row on the Mercator map: 0 at the south edge, [mapH]
/// the north one. Latitudes past the projection's own edge clamp to it.
double mercatorYOfLat(double latDeg, double mapH) {
  final lat = latDeg.clamp(-mercatorMaxLat, mercatorMaxLat);
  final rad = lat * math.pi / 180;
  return mapH *
      (0.5 - math.log(math.tan(math.pi / 4 + rad / 2)) / (2 * math.pi));
}

/// A point of the world file (its equirectangular units) on a Mercator
/// map of the given size: x runs linear, y bends by the projection.
double mercatorYOfWorldY(double yEq, double mapH) =>
    mercatorYOfLat(90 - yEq / WorldMap.height * 180, mapH);

/// One point of one ring, on the unit sphere: the three numbers every
/// projection reads. Built once from the world file, never again.
@immutable
class GlobeRing {
  const GlobeRing(this.xyz);

  /// x,y,z per point, in one flat list.
  final Float64List xyz;

  int get points => xyz.length ~/ 3;
}

/// One country ready for the globe: its code, its anchor's unit vector,
/// and its rings on the unit sphere.
@immutable
class GlobeCountry {
  const GlobeCountry(this.code, this.anchor, this.rings);

  final String code;
  final (double, double, double) anchor;
  final List<GlobeRing> rings;
}

/// The world turned to unit vectors, once per loaded file — the same
/// list identity reads back the same geometry, so a rebuilt page never
/// pays the work again.
abstract final class GlobeGeometry {
  static List<WorldCountry>? _from;
  static List<GlobeCountry>? _built;

  static List<GlobeCountry> of(List<WorldCountry> countries) {
    if (identical(_from, countries) && _built != null) return _built!;
    _built = [
      for (final c in countries)
        GlobeCountry(c.code, globePlaceOf(c).unit, [
          for (final ring in c.rings) GlobeRing(_unitVectors(ring)),
        ]),
    ];
    _from = countries;
    return _built!;
  }

  /// The ring's points, as unit vectors on the sphere.
  static Float64List _unitVectors(List<ui.Offset> ring) {
    final out = Float64List(ring.length * 3);
    for (var i = 0; i < ring.length; i++) {
      final place = GlobePlace(
        90 - ring[i].dy / WorldMap.height * 180,
        ring[i].dx / WorldMap.width * 360 - 180,
      ).unit;
      out[i * 3] = place.$1;
      out[i * 3 + 1] = place.$2;
      out[i * 3 + 2] = place.$3;
    }
    return out;
  }
}

/// The view's own frame: the three unit vectors a sphere point's screen
/// seat and depth come from, once the globe has turned so (lat0, lon0)
/// faces the viewer.
///
/// - v points at the viewer's place on the sphere: a point's dot with it
///   is its depth — front when positive, behind the limb when not.
/// - u1 is the screen's right, u2 the screen's up: a point's screen seat
///   is (dot u1, dot u2), drawn with y flipped.
@immutable
class GlobeView {
  const GlobeView._(this.u1, this.u2, this.v);

  /// The screen's right, the screen's up, and the direction the viewer
  /// looks down, each a unit vector in the sphere's own frame.
  final (double, double, double) u1;
  final (double, double, double) u2;
  final (double, double, double) v;

  factory GlobeView.ofDeg(double lat0Deg, double lon0Deg) {
    final lat = lat0Deg * math.pi / 180;
    final lon = lon0Deg * math.pi / 180;
    final cosLat = math.cos(lat);
    final sinLat = math.sin(lat);
    final cosLon = math.cos(lon);
    final sinLon = math.sin(lon);
    // The viewer stands over (lat0, lon0): v is that place's own vector.
    final v = (cosLat * cosLon, cosLat * sinLon, sinLat);
    // The screen's right runs along the parallel; the screen's up runs
    // toward the pole from it. Orthographic, north up, always.
    final u1 = (-sinLon, cosLon, 0.0);
    final u2 = (-sinLat * cosLon, -sinLat * sinLon, cosLat);
    return GlobeView._(u1, u2, v);
  }

  /// Where the unit-sphere point (x, y, z) sits on screen — right and up
  /// in sphere radii — and how deep it is (z: 1 dead center, 0 at the
  /// limb, negative behind the ball).
  (double, double, double) project(double x, double y, double z) => (
    x * u1.$1 + y * u1.$2 + z * u1.$3,
    x * u2.$1 + y * u2.$2 + z * u2.$3,
    x * v.$1 + y * v.$2 + z * v.$3,
  );

  /// Where a point at [r] sphere radii along (x, y, z) sits — the lifted
  /// points the connection paths fly at.
  (double, double, double) projectLifted(
    double x,
    double y,
    double z,
    double r,
  ) => project(x * r, y * r, z * r);
}

/// The world's hubs the connection paths reach for: the great exchange
/// points the internet's own roads meet at, lat and lon in degrees. The
/// globe lights the three nearest the chosen country.
const globeHubs = <GlobePlace>[
  GlobePlace(50.11, 8.68), // Frankfurt
  GlobePlace(52.37, 4.90), // Amsterdam
  GlobePlace(51.51, -0.13), // London
  GlobePlace(48.86, 2.35), // Paris
  GlobePlace(59.33, 18.07), // Stockholm
  GlobePlace(40.71, -74.01), // New York
  GlobePlace(39.04, -77.49), // Ashburn
  GlobePlace(-23.55, -46.63), // São Paulo
  GlobePlace(1.35, 103.82), // Singapore
  GlobePlace(35.68, 139.69), // Tokyo
  GlobePlace(-33.87, 151.21), // Sydney
  GlobePlace(19.08, 72.88), // Mumbai
  GlobePlace(25.20, 55.27), // Dubai
  GlobePlace(-26.20, 28.05), // Johannesburg
];

/// The [count] hubs nearest [from], nearest first — the connection's
/// roads leave for the exchanges closest to the country it leaves from.
List<GlobePlace> nearestHubs(GlobePlace from, int count) {
  final scored = [for (final hub in globeHubs) (hub.angleTo(from), hub)]
    ..sort((a, b) => a.$1.compareTo(b.$1));
  return [for (final s in scored.take(count)) s.$2];
}

/// A great-circle path between two unit vectors, sampled [steps] times,
/// lifted off the sphere so the path reads as a flight, not a seam: it
/// rises to [lift] radii at the middle and lands at both ends.
List<(double, double, double)> greatCirclePath(
  (double, double, double) a,
  (double, double, double) b, {
  int steps = 48,
  double lift = 0.10,
}) {
  final dot = (a.$1 * b.$1 + a.$2 * b.$2 + a.$3 * b.$3).clamp(-1.0, 1.0);
  final omega = math.acos(dot);
  final sinOmega = math.sin(omega);
  final out = <(double, double, double)>[];
  if (sinOmega < 1e-6 || omega < 1e-6) return out;
  for (var i = 0; i <= steps; i++) {
    final t = i / steps;
    final wa = math.sin((1 - t) * omega) / sinOmega;
    final wb = math.sin(t * omega) / sinOmega;
    var x = wa * a.$1 + wb * b.$1;
    var y = wa * a.$2 + wb * b.$2;
    var z = wa * a.$3 + wb * b.$3;
    // The rise: highest over the middle of the flight, zero at both
    // ends, so the path sits on the sphere where it leaves and arrives.
    final r = 1.0 + lift * math.sin(math.pi * t);
    final len = math.sqrt(x * x + y * y + z * z);
    if (len < 1e-9) continue;
    out.add((x / len * r, y / len * r, z / len * r));
  }
  return out;
}

/// The kinds the settings offer for the home's map: the whole world the
/// same real borders draw, but carried differently.
///
/// - [MapKind.classic]: the flat map as it always was — the quiet ink
///   over the page, the graticule, the chosen country lit.
/// - [MapKind.flat]: the same flat projection, a modern finish — the
///   land tinted in the connection's light, a deeper shadow, a stronger
///   lit country.
/// - [MapKind.globe]: the metal ball, turned so the chosen country
///   faces the viewer.
/// - [MapKind.hud]: the GTA design's own map — the game's HUD plate:
///   the deep water, the slate land, the neon coast, the amber radar
///   grid and the sweep that walks the world while the tunnel carries.
///
/// The night, the terrain and the satellite's earth were here before,
/// and left: three ways to paint one world was the picker's whole
/// point, and the three that read best are the three that stayed. A
/// settings file that still names one of them lands on its nearest
/// survivor (app_settings.dart reads the saved kind back).
enum MapKind { classic, flat, globe, hud }

/// The flat map's finishes: how its land and its water take their
/// color, whatever theme carries them.
enum FlatFinish { classic, modern, night, terrain, hud }

/// The looks the settings offer for the home's map: six ways to paint
/// the same real world. Every style carries its own metal, its own land,
/// its own sky — the connection's light and the pin stay the accent's
/// own, whatever the style.
enum GlobeStyle { silver, midnight, ocean, mono, aurora, satellite }

/// One style's colors: the ball's four gradient stops, the land's fill
/// and edge, the faint coordinate grid on the metal, the sky's stars,
/// the light that lands on the ball, and the halo outside the limb.
@immutable
class GlobePalette {
  const GlobePalette({
    required this.ball,
    required this.landFill,
    required this.landStroke,
    required this.graticule,
    required this.stars,
    required this.starAlpha,
    required this.specular,
    required this.halo,
    required this.shadow,
  });

  /// The ball's radial gradient, light source to dark limb: four stops.
  final List<Color> ball;

  /// The land's fill (every visible country) and its outline.
  final Color landFill;
  final Color landStroke;

  /// The faint grid of meridians and parallels on the ball.
  final Color graticule;

  /// The sky behind the ball: its color and how strong the stars are.
  final Color stars;
  final double starAlpha;

  /// The lamp's own light, high on the ball's upper left.
  final Color specular;

  /// The halo hugging the ball from outside.
  final Color halo;

  /// The land's shadow on the ball, a breath of depth.
  final Color shadow;

  /// The palette for [style] over [dark].
  static GlobePalette of(GlobeStyle style, bool dark) => switch (style) {
    GlobeStyle.midnight => _midnight,
    GlobeStyle.ocean => dark ? _oceanNight : _oceanDay,
    GlobeStyle.mono => dark ? _monoNight : _monoDay,
    GlobeStyle.aurora => _aurora,
    GlobeStyle.satellite => dark ? _satelliteNight : _satelliteDay,
    _ => dark ? _silverNight : _silverDay,
  };

  // The satellite's earth: the ocean carries the ball (deep blue, lit
  // where the light lands), the land reads green with a sandy coast, and
  // the day sky is nearly empty — the photo does not change with the
  // app's theme, only its depth does.
  static const _satelliteNight = GlobePalette(
    ball: [
      Color(0xFF2E6FB0),
      Color(0xFF1C4E8C),
      Color(0xFF0E3158),
      Color(0xFF071C33),
    ],
    landFill: Color(0x6B4E8A55),
    landStroke: Color(0xA8D9C98A),
    graticule: Color(0x12FFFFFF),
    stars: Color(0xFFEAF2FF),
    starAlpha: 0.30,
    specular: Color(0x2EBFD8FF),
    halo: Color(0xFF4A7FC0),
    shadow: Color(0x4A001020),
  );

  static const _satelliteDay = GlobePalette(
    ball: [
      Color(0xFF3B7FC0),
      Color(0xFF27609E),
      Color(0xFF16406E),
      Color(0xFF0B2440),
    ],
    landFill: Color(0x7D57975E),
    landStroke: Color(0x99E3D39A),
    graticule: Color(0x10FFFFFF),
    stars: Color(0xFF12253F),
    starAlpha: 0.06,
    specular: Color(0x47D8EAFF),
    halo: Color(0xFF5B8CC9),
    shadow: Color(0x33041E30),
  );

  static const _silverNight = GlobePalette(
    ball: [
      Color(0xFF9AA3B2),
      Color(0xFF4A5160),
      Color(0xFF20242E),
      Color(0xFF0B0D12),
    ],
    landFill: Color(0x1AFFFFFF),
    landStroke: Color(0x57FFFFFF),
    graticule: Color(0x12FFFFFF),
    stars: Color(0xFFFFFFFF),
    starAlpha: 0.38,
    specular: Color(0x1AFFFFFF),
    halo: Color(0xFF8FA0BC),
    shadow: Color(0x40000000),
  );

  static const _silverDay = GlobePalette(
    ball: [
      Color(0xFFF4F6FA),
      Color(0xFFC3C9D6),
      Color(0xFF8C93A3),
      Color(0xFF5D6371),
    ],
    landFill: Color(0x14000000),
    landStroke: Color(0x6B000000),
    graticule: Color(0x0F000000),
    stars: Color(0xFF3A4664),
    starAlpha: 0.10,
    specular: Color(0x80FFFFFF),
    halo: Color(0xFF9FB0CC),
    shadow: Color(0x2E000000),
  );

  static const _midnight = GlobePalette(
    ball: [
      Color(0xFF31406E),
      Color(0xFF1D2748),
      Color(0xFF111830),
      Color(0xFF070B18),
    ],
    landFill: Color(0x249EC5F2),
    landStroke: Color(0x8C9EC5F2),
    graticule: Color(0x1A7FA8E0),
    stars: Color(0xFFE8F0FF),
    starAlpha: 0.72,
    specular: Color(0x24BFD4FF),
    halo: Color(0xFF5F7FC0),
    shadow: Color(0x52000000),
  );

  static const _oceanNight = GlobePalette(
    ball: [
      Color(0xFF1E5F8A),
      Color(0xFF14486E),
      Color(0xFF0B2B45),
      Color(0xFF05131F),
    ],
    landFill: Color(0x333ECFA0),
    landStroke: Color(0x809FE8CE),
    graticule: Color(0x14BFEBFF),
    stars: Color(0xFFDFF3FF),
    starAlpha: 0.42,
    specular: Color(0x1ECFEAFF),
    halo: Color(0xFF3E88B8),
    shadow: Color(0x4A001020),
  );

  static const _oceanDay = GlobePalette(
    ball: [
      Color(0xFF7EC3E8),
      Color(0xFF4E9BC8),
      Color(0xFF2F6F9E),
      Color(0xFF1B4568),
    ],
    landFill: Color(0x4D2FA37E),
    landStroke: Color(0x73134A38),
    graticule: Color(0x14FFFFFF),
    stars: Color(0xFF0A3550),
    starAlpha: 0.08,
    specular: Color(0x59FFFFFF),
    halo: Color(0xFF63A3CC),
    shadow: Color(0x33041E30),
  );

  static const _monoNight = GlobePalette(
    ball: [
      Color(0xFF3C3C3C),
      Color(0xFF242424),
      Color(0xFF141414),
      Color(0xFF060606),
    ],
    landFill: Color(0x1FFFFFFF),
    landStroke: Color(0x99FFFFFF),
    graticule: Color(0x14FFFFFF),
    stars: Color(0xFFFFFFFF),
    starAlpha: 0.52,
    specular: Color(0x24FFFFFF),
    halo: Color(0xFF7E7E7E),
    shadow: Color(0x59000000),
  );

  static const _monoDay = GlobePalette(
    ball: [
      Color(0xFFFFFFFF),
      Color(0xFFF2F2F2),
      Color(0xFFD9D9D9),
      Color(0xFFB9B9B9),
    ],
    landFill: Color(0x1A000000),
    landStroke: Color(0x8C000000),
    graticule: Color(0x14000000),
    stars: Color(0xFF2A2A2A),
    starAlpha: 0.10,
    specular: Color(0x40FFFFFF),
    halo: Color(0xFFA8A8A8),
    shadow: Color(0x33000000),
  );

  static const _aurora = GlobePalette(
    ball: [
      Color(0xFF3A2B6B),
      Color(0xFF271E4E),
      Color(0xFF160F30),
      Color(0xFF0A0618),
    ],
    landFill: Color(0x214EF0C0),
    landStroke: Color(0x997CF5D6),
    graticule: Color(0x1F9B8CFF),
    stars: Color(0xFFF2EFFF),
    starAlpha: 0.75,
    specular: Color(0x29D5C8FF),
    halo: Color(0xFF8A6FD0),
    shadow: Color(0x52060018),
  );
}

/// The sky's own stars: one fixed field, the same every night, twinkling
/// with the globe's breath. Positions in the unit square, never rebuilt.
final _stars = () {
  final rnd = math.Random(7);
  return [
    for (var i = 0; i < 110; i++)
      (
        rnd.nextDouble(),
        rnd.nextDouble(),
        0.4 + rnd.nextDouble() * 1.1,
        rnd.nextDouble(),
      ),
  ];
}();

/// The satellite's own clouds: one fixed field of soft white wisps, the
/// same every look, painted inside the ball over the land. Positions in
/// the unit square (they map onto the ball's circle), never rebuilt.
final _clouds = () {
  final rnd = math.Random(11);
  return [
    for (var i = 0; i < 26; i++)
      (
        rnd.nextDouble(),
        rnd.nextDouble(),
        0.05 + rnd.nextDouble() * 0.09,
        0.05 + rnd.nextDouble() * 0.09,
      ),
  ];
}();

/// A flight between two unit vectors, as (lat, lon) in degrees: the
/// camera rides the great circle the two sit on, so a long turn arcs
/// over the sphere instead of swinging through a pole the way a line
/// between two latitudes would. The vectors are the unit ones the
/// geometry already carries; [t] runs 0 to 1.
(double, double) slerpDeg(
  (double, double, double) a,
  (double, double, double) b,
  double t,
) {
  final dot = (a.$1 * b.$1 + a.$2 * b.$2 + a.$3 * b.$3).clamp(-1.0, 1.0);
  final omega = math.acos(dot);
  if (omega < 1e-9) {
    return (
      math.asin(b.$3.clamp(-1.0, 1.0)) * 180 / math.pi,
      math.atan2(b.$2, b.$1) * 180 / math.pi,
    );
  }
  final sinOmega = math.sin(omega);
  final wa = math.sin((1 - t) * omega) / sinOmega;
  final wb = math.sin(t * omega) / sinOmega;
  final x = wa * a.$1 + wb * b.$1;
  final y = wa * a.$2 + wb * b.$2;
  final z = wa * a.$3 + wb * b.$3;
  return (
    math.asin(z.clamp(-1.0, 1.0)) * 180 / math.pi,
    math.atan2(y, x) * 180 / math.pi,
  );
}

/// The home page's globe: the world's own outlines carried onto a metal
/// ball, turned so the chosen country faces the viewer. The chosen
/// country is lit in the connection's light; a glowing pin stands at its
/// anchor, and a floating glass card names it. From the anchor, the
/// great-circle paths to the nearest hubs burn slow in the same light
/// while the VPN carries the traffic — off, everything rests.
///
/// The map has the settings' own looks ([GlobeStyle]); it zooms under two
/// fingers, a double tap steps in and back out, and a change of country
/// is a small flight: the camera pulls back, the ball turns, and the pin
/// drops as the roads draw themselves to the hubs.
class WorldGlobe extends StatefulWidget {
  const WorldGlobe({
    super.key,
    required this.countries,
    required this.accent,
    required this.selected,
    required this.animated,
    required this.dark,
    required this.label,
    this.style = GlobeStyle.silver,
    this.still = false,
  });

  /// The world, from [WorldMap.load]; empty until it arrives.
  final List<WorldCountry> countries;

  /// The state's light: the chosen country, its pin and its paths wear it.
  final Color accent;

  /// The chosen country's ISO code, upper-case; '' for none.
  final String selected;

  /// Whether the globe breathes: the pin's rings swell and the paths
  /// stream while the VPN carries the traffic; off, everything holds
  /// still.
  final bool animated;

  /// Whether the app's night is on: the metal reads darker over it.
  final bool dark;

  /// The chosen country's name, for the floating card; '' hides it.
  final String label;

  /// The map's look, from the settings; silver unless said otherwise.
  final GlobeStyle style;

  /// The battery saver's word: the globe rests — no breath, no comets —
  /// whatever the connection says. A turn to a new country still plays.
  final bool still;

  @override
  State<WorldGlobe> createState() => _WorldGlobeState();
}

class _WorldGlobeState extends State<WorldGlobe>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Four clocks live here — breath, turn, arrival, zoom — so the plural
  // mixin: the single one would raise at the first build, where the
  // AnimatedBuilder reads them all at once.
  /// The breath: the pin's rings, the card's bob, the paths' stream.
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  /// The globe's turn: from the view it rests on to the chosen country's.
  /// A small flight now — the camera pulls back a breath, the ball turns,
  /// and the arrival plays when the flight lands.
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  /// The arrival: the pin drops with a bounce, its rings burst, and the
  /// roads draw themselves out to the hubs. It plays when the turn lands.
  late final AnimationController _arrive = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  /// The double tap's zoom: from wherever the map is to one step in (or
  /// back out to the whole ball).
  late final AnimationController _zoomAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  /// The flight the camera rides: the view it starts from and the one it
  /// lands on, as unit vectors on the sphere — slerped every frame, so a
  /// long turn rides the great circle instead of swinging through a pole.
  (double, double, double) _fromVec = (1.0, 0.0, 0.0);
  (double, double, double) _toVec = (1.0, 0.0, 0.0);
  double _currentLat = 25, _currentLon = 10;

  /// Whether a turn ever landed: the world file arrives after the first
  /// frame, so the first real turn happens when it does.
  bool _turned = false;

  /// The map's zoom: the whole ball at 1, a closer look up to 1.9. Two
  /// fingers set it directly; a double tap steps it with the animation.
  static const double _zoomMin = 1.0;
  static const double _zoomMax = 1.9;
  double _zoom = 1.0;
  double _zoomFrom = 1.0, _zoomTo = 1.0;

  /// The zoom a pinch started from, so the two fingers write an absolute
  /// scale rather than fighting the last frame's.
  double _zoomAtPinch = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _breath.value = 0.5;
    _setBreathing();
    _spin.addStatusListener((status) {
      // The flight lands: the pin drops, the roads draw out.
      if (status == AnimationStatus.completed) {
        _arrive.forward(from: 0);
      }
    });
    _zoomAnim.addListener(() {
      final t = Curves.easeOutCubic.transform(_zoomAnim.value);
      setState(() => _zoom = _zoomFrom + (_zoomTo - _zoomFrom) * t);
    });
    _turnTo(widget.selected, animate: false);
  }

  /// Whether the breath should run: the connection's own wish, and the
  /// battery saver's veto. A hidden window stops it either way.
  bool get _breathWanted => widget.animated && !widget.still;

  void _setBreathing() {
    if (_breathWanted) {
      if (!_breath.isAnimating) _breath.repeat(reverse: true);
    } else {
      _breath.stop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _breath.stop();
    } else if (state == AppLifecycleState.resumed) {
      _setBreathing();
    }
  }

  @override
  void didUpdateWidget(WorldGlobe old) {
    super.didUpdateWidget(old);
    if (old.animated != widget.animated || old.still != widget.still) {
      _setBreathing();
    }
    if (old.selected != widget.selected ||
        (!_turned && widget.countries.isNotEmpty)) {
      // A country changed, or the world just arrived: both fly — the
      // first so the change never snaps, the second so the globe's very
      // first facing of the chosen country reads as a gentle turn, not
      // an appearance.
      _turnTo(widget.selected, animate: true);
    }
  }

  /// Turns the globe so [code]'s country faces the viewer; an unknown or
  /// empty code keeps the view where it is.
  void _turnTo(String code, {required bool animate}) {
    GlobeCountry? country;
    if (code.length == 2) {
      final geometry = GlobeGeometry.of(widget.countries);
      for (final c in geometry) {
        if (c.code == code) {
          country = c;
          break;
        }
      }
    }
    if (country == null) return;
    _turned = true;
    // The flight starts from wherever the camera rests now — even the
    // middle of a turn already flying — and rides the great circle to
    // the new country's own anchor. The ride's length is the journey's:
    // a short hop is a quick, light turn; a long one gets the room to
    // read as a journey, both at the same even pace.
    _fromVec = GlobePlace(_currentLat, _currentLon).unit;
    _toVec = country.anchor;
    if (animate && widget.countries.isNotEmpty) {
      // How far the flight goes: the two views' great-circle angle, read
      // straight off the unit vectors.
      final (ax, ay, az) = _fromVec;
      final (bx, by, bz) = _toVec;
      final dot = (ax * bx + ay * by + az * bz).clamp(-1.0, 1.0);
      final angle = math.acos(dot) * 180 / math.pi;
      _spin.duration = Duration(
        milliseconds: (700 + 900 * angle / 180).round().clamp(700, 1600),
      );
      _arrive.reset();
      _spin.forward(from: 0);
    } else {
      final (lat, lon) = slerpDeg(_fromVec, _toVec, 1.0);
      _currentLat = lat;
      _currentLon = lon;
      _spin.value = 1.0;
    }
  }

  // The map's zoom, by hand: two fingers pinch the ball closer or set it
  // back; a double tap steps in, and again steps out. The gesture lives
  // on a layer that only answers where the page's own widgets do not sit,
  // so a drag on the slider or the cards never becomes a zoom.
  static const _kZoomStep = 1.5;

  void _onScaleStart(ScaleStartDetails details) {
    _zoomAtPinch = _zoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // One finger belongs to the page (its scroll); only a second one
    // means "zoom".
    if (details.pointerCount < 2) return;
    final next = (_zoomAtPinch * details.scale)
        .clamp(_zoomMin, _zoomMax)
        .toDouble();
    if ((next - _zoom).abs() > 0.002) {
      setState(() => _zoom = next);
    }
  }

  void _onDoubleTap() {
    _zoomFrom = _zoom;
    _zoomTo = _zoom > 1.05 ? _zoomMin : _kZoomStep;
    _zoomAnim.forward(from: 0);
  }

  /// The world at the view now on screen: built once per turn, redrawn
  /// cheaply on every frame after. The turn is the expensive thing (every
  /// point of every border moves); the breath is not, so the cache turns
  /// with the globe and the breath only re-lights what is already built.
  /// The zoom never rebuilds: it scales what is already built.
  _RotatedWorld? _cache;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _breath.dispose();
    _spin.dispose();
    _arrive.dispose();
    _zoomAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.countries.isEmpty) return const SizedBox.expand();
    // The map answers the hand where the page's own widgets do not sit:
    // the pinch and the double tap live on a quiet layer under the
    // content, so the slider and the cards keep their own gestures.
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onDoubleTap: _onDoubleTap,
      child: LayoutBuilder(
        builder: (context, box) {
          if (box.maxWidth <= 0 || box.maxHeight <= 0) {
            return const SizedBox.expand();
          }
          // The ball is the page's own width, a hair wider, and as tall
          // as the page allows: its limb may run off the sides — a planet
          // the home stands on — but the poles stay inside the page.
          final d = math.min(box.maxWidth * 1.16, box.maxHeight * 1.28);
          return SizedBox.expand(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // A near-invisible ground: it lets the pinch and the
                // double tap reach the map through the page's empty
                // spaces, without ever painting anything.
                const Positioned.fill(
                  child: ColoredBox(color: Color(0x01000000)),
                ),
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _breath,
                    _spin,
                    _arrive,
                    _zoomAnim,
                  ]),
                  builder: (context, _) {
                    // The turn, eased: the camera rides the great circle
                    // between the two views, so the globe arrives at the
                    // chosen country instead of snapping to it — and the
                    // ride arcs over the sphere, never through a pole.
                    final spinT = _spin.value.clamp(0.0, 1.0);
                    final t = Curves.easeInOutCubic.transform(spinT);
                    final (lat, lon) = slerpDeg(_fromVec, _toVec, t);
                    _currentLat = lat;
                    _currentLon = lon;
                    final geometry = GlobeGeometry.of(widget.countries);
                    final radius = d / 2 * 0.94;
                    final center = Offset(box.maxWidth / 2, box.maxHeight / 2);
                    final world = _worldFor(geometry, radius, center);
                    // The camera: the user's zoom, and the flight's own
                    // pull-back — a breath of distance while the ball
                    // turns, landing as the arrival begins.
                    final flight = 1.0 - 0.06 * math.sin(math.pi * spinT);
                    final zoom = _zoom * flight;
                    return CustomPaint(
                      size: Size(box.maxWidth, box.maxHeight),
                      painter: _GlobePainter(
                        world: world,
                        accent: widget.accent,
                        palette: GlobePalette.of(widget.style, widget.dark),
                        dark: widget.dark,
                        breath: widget.animated && !widget.still
                            ? _breath.value
                            : 0.5,
                        animated: widget.animated && !widget.still,
                        arrive: _arrive.value,
                        zoom: zoom,
                        clouds: widget.style == GlobeStyle.satellite,
                      ),
                    );
                  },
                ),
                // The chosen country's floating card, over the globe,
                // under the page's own content.
                if (widget.label.isNotEmpty &&
                    widget.selected.length == 2 &&
                    widget.countries.isNotEmpty)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: _FloatingCard(
                        countries: GlobeGeometry.of(widget.countries),
                        selected: widget.selected,
                        label: widget.label,
                        accent: widget.accent,
                        dark: widget.dark,
                        animated: widget.animated && !widget.still,
                        breath: _breath,
                        spin: _spin,
                        fromVec: _fromVec,
                        toVec: _toVec,
                        zoom: _zoom,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// The world as drawn now — the cached one when nothing but the breath
  /// moved, a fresh build when the turn, the size, or the choice changed.
  _RotatedWorld _worldFor(
    List<GlobeCountry> geometry,
    double radius,
    Offset center,
  ) {
    final old = _cache;
    if (old != null &&
        identical(old.geometry, geometry) &&
        old.selected == widget.selected &&
        old.radius == radius &&
        old.center == center &&
        (old.lat - _currentLat).abs() < 0.02 &&
        (old.lon - _currentLon).abs() < 0.02) {
      return old;
    }
    final built = _RotatedWorld.build(
      geometry: geometry,
      selected: widget.selected,
      lat: _currentLat,
      lon: _currentLon,
      radius: radius,
      center: center,
    );
    _cache = built;
    return built;
  }
}

/// The floating card that names the chosen country: a pane of glass with
/// the country's flag and its name, hanging over the pin it belongs to,
/// bobbing with the globe's breath. It follows the globe's own turn, so
/// it never drifts off the country it names, and it zooms with the map —
/// its seat scales, its glass keeps its size. A new country's card
/// crossfades over the old one's, while the ball turns under them.
class _FloatingCard extends StatelessWidget {
  const _FloatingCard({
    required this.countries,
    required this.selected,
    required this.label,
    required this.accent,
    required this.dark,
    required this.animated,
    required this.breath,
    required this.spin,
    required this.fromVec,
    required this.toVec,
    required this.zoom,
  });

  final List<GlobeCountry> countries;
  final String selected;
  final String label;
  final Color accent;
  final bool dark;
  final bool animated;
  final Animation<double> breath;
  final Animation<double> spin;

  /// The flight the camera rides — the same two vectors the painter's
  /// turn reads, so the card sits over its pin the whole way.
  final (double, double, double) fromVec;
  final (double, double, double) toVec;

  /// The map's own zoom: the seat under the card scales with it.
  final double zoom;

  @override
  Widget build(BuildContext context) {
    // The same turn the painter paints, so the card sits over its pin.
    final t = Curves.easeInOutCubic.transform(spin.value.clamp(0.0, 1.0));
    final (lat, lon) = slerpDeg(fromVec, toVec, t);
    final view = GlobeView.ofDeg(lat, lon);
    GlobeCountry? country;
    for (final c in countries) {
      if (c.code == selected) {
        country = c;
        break;
      }
    }
    if (country == null) return const SizedBox.shrink();
    final (x, y, z) = view.project(
      country.anchor.$1,
      country.anchor.$2,
      country.anchor.$3,
    );
    // The card hangs over the pin, a little above it, but never off the
    // screen: it clamps to the page the globe fills.
    return LayoutBuilder(
      builder: (context, box) {
        // The same ball the painter paints: its center and radius come
        // from the page's own size, the way the painter reads them — and
        // the seat scales with the map's zoom and the flight's own
        // pull-back, exactly as the ball does.
        final d = math.min(box.maxWidth * 1.16, box.maxHeight * 1.28);
        final spinT = spin.value.clamp(0.0, 1.0);
        final flight = 1.0 - 0.06 * math.sin(math.pi * spinT);
        final radius = d / 2 * 0.94 * zoom * flight;
        const cardW = 168.0;
        final dx = x * radius;
        final dy = -y * radius;
        // Above the pin: the card's own stem points down at it.
        const lift = 58.0;
        final left = (box.maxWidth / 2 + dx - cardW / 2)
            .clamp(12.0, math.max(12.0, box.maxWidth - cardW - 12))
            .toDouble();
        final top = (box.maxHeight / 2 + dy - lift).clamp(
          10.0,
          box.maxHeight - 120,
        );
        return Stack(
          children: [
            AnimatedBuilder(
              animation: breath,
              builder: (context, _) {
                final bob = animated ? breath.value : 0.5;
                return Positioned(
                  left: left,
                  top: top - 3.0 * bob,
                  child: Opacity(
                    // The card is there for the country the globe shows;
                    // a country rolling over the limb takes its card with
                    // it, quietly, before it can hang in space.
                    opacity: z > 0.08 ? 1.0 : 0.0,
                    // One country's card melts into the next's while the
                    // ball turns: no flag swaps in place without a word.
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 340),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.92, end: 1.0).animate(anim),
                          child: child,
                        ),
                      ),
                      child: KeyedSubtree(
                        key: ValueKey(selected),
                        child: _cardBody(context),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _cardBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // The pane: the country's flag and name on its own glass. The
        // glass used to be a real blur (a BackdropFilter) — a saveLayer
        // the slow GPUs, Mali and MediaTek, pay for on every frame the
        // map breathes, and the battery with it. The fill alone carries
        // the pane now, a shade firmer so it still reads as glass over
        // the ball.
        Container(
          width: 168,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: dark
                ? Colors.white.withValues(alpha: 0.14)
                : Colors.white.withValues(alpha: 0.88),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.9),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: dark ? 0.30 : 0.22),
                blurRadius: 22,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              CountryFlag(code: selected, width: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark ? Colors.white : scheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        // The stem: the card points down at its pin, a hair of light.
        Container(
          width: 1.4,
          height: 12,
          color: accent.withValues(alpha: dark ? 0.85 : 0.6),
        ),
      ],
    );
  }
}

/// The world at one view and one size: every visible country's outline
/// merged into the paths the painter draws — the land's strokes and the
/// wholly-visible land's fills, the chosen country's own lit shape, its
/// anchor's seat on screen, and the visible runs of its roads. Built
/// once per turn; a frame only draws it.
class _RotatedWorld {
  const _RotatedWorld({
    required this.geometry,
    required this.selected,
    required this.lat,
    required this.lon,
    required this.radius,
    required this.center,
    required this.landStroke,
    required this.landFill,
    required this.litStroke,
    required this.litFill,
    required this.litWhole,
    required this.anchor,
    required this.roads,
    required this.graticule,
    required this.hubs,
  });

  final List<GlobeCountry> geometry;
  final String selected;
  final double lat;
  final double lon;
  final double radius;
  final Offset center;

  /// Every visible country but the chosen one: the outlines stroked,
  /// the wholly-visible shapes filled (one path each, even-odd).
  final ui.Path landStroke;
  final ui.Path landFill;

  /// The chosen country: its outline, its fill when it lies wholly in
  /// view, and whether that fill is there at all (a country half over
  /// the limb has no fill to draw).
  final ui.Path litStroke;
  final ui.Path litFill;
  final bool litWhole;

  /// The chosen country's anchor, on screen; null when behind the ball.
  final Offset? anchor;

  /// The chosen country's roads, one path per hub, only their front-of-
  /// ball runs.
  final List<ui.Path> roads;

  /// The faint coordinate grid: the meridians and parallels' front-of-
  /// ball runs, one path for them all.
  final ui.Path graticule;

  /// The world's exchange hubs, on screen — only the ones facing the
  /// viewer. Small lights on the metal, wherever the globe is turned.
  final List<Offset> hubs;

  /// Projects the whole world at the view (lat, lon): every country's
  /// rings become screen paths, roads included.
  factory _RotatedWorld.build({
    required List<GlobeCountry> geometry,
    required String selected,
    required double lat,
    required double lon,
    required double radius,
    required Offset center,
  }) {
    final view = GlobeView.ofDeg(lat, lon);
    final landStroke = ui.Path()..fillType = ui.PathFillType.evenOdd;
    final landFill = ui.Path()..fillType = ui.PathFillType.evenOdd;
    final litStroke = ui.Path()..fillType = ui.PathFillType.evenOdd;
    final litFill = ui.Path()..fillType = ui.PathFillType.evenOdd;
    var litWhole = false;
    Offset? anchor;

    for (final c in geometry) {
      final isChosen = c.code == selected && selected.length == 2;
      var whole = true;
      var any = false;
      for (final ring in c.rings) {
        for (var i = 0; i < ring.points; i++) {
          final z =
              ring.xyz[i * 3] * view.v.$1 +
              ring.xyz[i * 3 + 1] * view.v.$2 +
              ring.xyz[i * 3 + 2] * view.v.$3;
          if (z > 0) {
            any = true;
          } else {
            whole = false;
          }
        }
      }
      if (!any) continue; // wholly behind the ball: not there

      if (whole) {
        final shape = _ringPath(c.rings, view, center, radius);
        (isChosen ? litFill : landFill).addPath(shape, ui.Offset.zero);
        (isChosen ? litStroke : landStroke).addPath(shape, ui.Offset.zero);
        if (isChosen) litWhole = true;
      } else {
        // Half over the limb: stroke only the visible runs, so no edge
        // lies about where the land ends.
        final runs = _visibleRuns(c.rings, view, center, radius);
        (isChosen ? litStroke : landStroke).addPath(runs, ui.Offset.zero);
      }
      if (isChosen) {
        final p = view.project(c.anchor.$1, c.anchor.$2, c.anchor.$3);
        if (p.$3 > 0) {
          anchor = Offset(center.dx + p.$1 * radius, center.dy - p.$2 * radius);
        }
      }
    }

    // The roads: great circles from the chosen anchor to the three
    // nearest hubs, lifted over the ball, drawn where they stand in
    // front of it.
    final roads = <ui.Path>[];
    final chosen = anchor != null
        ? geometry.where((c) => c.code == selected).firstOrNull
        : null;
    if (chosen != null) {
      final from = globePlaceOfVector(chosen.anchor);
      for (final hub in nearestHubs(from, 3)) {
        final samples = greatCirclePath(chosen.anchor, hub.unit);
        final road = ui.Path();
        var pen = false;
        for (final s in samples) {
          final p = view.project(s.$1, s.$2, s.$3);
          if (p.$3 > 0) {
            final q = Offset(
              center.dx + p.$1 * radius,
              center.dy - p.$2 * radius,
            );
            if (pen) {
              road.lineTo(q.dx, q.dy);
            } else {
              road.moveTo(q.dx, q.dy);
              pen = true;
            }
          } else {
            pen = false;
          }
        }
        roads.add(road);
      }
    }

    // The coordinate grid: meridians every thirty degrees, parallels
    // every thirty, projected and kept only where the ball faces the
    // viewer — the metal's own faint graph paper.
    final graticule = ui.Path();
    void line(Iterable<(double, double)> samples) {
      var pen = false;
      for (final (latDeg, lonDeg) in samples) {
        final (ux, uy, uz) = GlobePlace(latDeg, lonDeg).unit;
        final p = view.project(ux, uy, uz);
        if (p.$3 > 0) {
          final q = Offset(
            center.dx + p.$1 * radius,
            center.dy - p.$2 * radius,
          );
          if (pen) {
            graticule.lineTo(q.dx, q.dy);
          } else {
            graticule.moveTo(q.dx, q.dy);
            pen = true;
          }
        } else {
          pen = false;
        }
      }
    }

    for (var lon = -150; lon <= 180; lon += 30) {
      line([
        for (var lat = -84; lat <= 84; lat += 4)
          (lat.toDouble(), lon.toDouble()),
      ]);
    }
    for (var lat = -60; lat <= 60; lat += 30) {
      line([
        for (var lon = -180; lon <= 180; lon += 4)
          (lat.toDouble(), lon.toDouble()),
      ]);
    }

    // The hubs, on screen: small lights where the internet's roads
    // gather, whatever country the traffic leaves from.
    final hubs = <Offset>[];
    for (final hub in globeHubs) {
      final (hx, hy, hz) = hub.unit;
      final p = view.project(hx, hy, hz);
      if (p.$3 > 0) {
        hubs.add(Offset(center.dx + p.$1 * radius, center.dy - p.$2 * radius));
      }
    }

    return _RotatedWorld(
      geometry: geometry,
      selected: selected,
      lat: lat,
      lon: lon,
      radius: radius,
      center: center,
      landStroke: landStroke,
      landFill: landFill,
      litStroke: litStroke,
      litFill: litFill,
      litWhole: litWhole,
      anchor: anchor,
      roads: roads,
      graticule: graticule,
      hubs: hubs,
    );
  }

  /// The rings as one closed path (even-odd: the holes read through).
  static ui.Path _ringPath(
    List<GlobeRing> rings,
    GlobeView view,
    Offset center,
    double radius,
  ) {
    final path = ui.Path();
    for (final ring in rings) {
      final p = view.project(ring.xyz[0], ring.xyz[1], ring.xyz[2]);
      path.moveTo(center.dx + p.$1 * radius, center.dy - p.$2 * radius);
      for (var i = 1; i < ring.points; i++) {
        final q = view.project(
          ring.xyz[i * 3],
          ring.xyz[i * 3 + 1],
          ring.xyz[i * 3 + 2],
        );
        path.lineTo(center.dx + q.$1 * radius, center.dy - q.$2 * radius);
      }
      path.close();
    }
    return path;
  }

  /// Only the visible runs of the rings: the outline breaks where it
  /// slips behind the limb.
  static ui.Path _visibleRuns(
    List<GlobeRing> rings,
    GlobeView view,
    Offset center,
    double radius,
  ) {
    final path = ui.Path();
    var pen = false;
    for (final ring in rings) {
      for (var i = 0; i < ring.points; i++) {
        final z =
            ring.xyz[i * 3] * view.v.$1 +
            ring.xyz[i * 3 + 1] * view.v.$2 +
            ring.xyz[i * 3 + 2] * view.v.$3;
        if (z > 0) {
          final p = view.project(
            ring.xyz[i * 3],
            ring.xyz[i * 3 + 1],
            ring.xyz[i * 3 + 2],
          );
          final q = Offset(
            center.dx + p.$1 * radius,
            center.dy - p.$2 * radius,
          );
          if (pen) {
            path.lineTo(q.dx, q.dy);
          } else {
            path.moveTo(q.dx, q.dy);
            pen = true;
          }
        } else {
          pen = false;
        }
      }
      pen = false;
    }
    return path;
  }
}

/// The painter: the sky's stars, the ball of metal in the style's own
/// colors, the coordinate grid, the land, the lit country, the pin, and
/// the roads. Everything is already projected ([_RotatedWorld]); a frame
/// only lights it. The zoom is a scale of the canvas around the ball's
/// center — the world is never rebuilt for it.
class _GlobePainter extends CustomPainter {
  _GlobePainter({
    required this.world,
    required this.accent,
    required this.palette,
    required this.dark,
    required this.breath,
    required this.animated,
    required this.arrive,
    required this.zoom,
    this.clouds = false,
  });

  final _RotatedWorld world;
  final Color accent;
  final GlobePalette palette;
  final bool dark;
  final double breath;

  /// Whether the breath runs (the connection is up and the battery saver
  /// is off): the comets fly only then.
  final bool animated;

  /// The arrival: 0 at the flight's landing, 1 when the pin has dropped
  /// and the roads have drawn themselves out. 1 when nothing arrived.
  final double arrive;

  /// The camera: the map's zoom (user's zoom, times the flight's own
  /// pull-back). The world stays as built; the canvas scales.
  final double zoom;

  /// The satellite's own clouds: soft wisps inside the ball, over the
  /// land. Only the satellite's look carries them.
  final bool clouds;

  @override
  void paint(Canvas canvas, Size size) {
    final center = world.center;
    final radius = world.radius;
    final breathe = 0.5 - 0.5 * math.cos(2 * math.pi * breath);

    // The sky first, behind everything: the style's own stars, twinkling
    // on the breath's clock. The ball covers the ones it hides.
    if (palette.starAlpha > 0.01) {
      final star = Paint()..isAntiAlias = true;
      for (final (x, y, r, phase) in _stars) {
        final twinkle =
            0.55 + 0.45 * math.sin(2 * math.pi * (breath * 1.4 + phase));
        star.color = palette.stars.withValues(
          alpha: palette.starAlpha * twinkle * (0.5 + 0.5 * r),
        );
        canvas.drawCircle(
          Offset(x * size.width, y * size.height),
          r * 0.9,
          star,
        );
      }
    }

    // Everything of the ball scales with the camera: one transform
    // around the ball's center carries the zoom, so a pinch never
    // rebuilds the world.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(zoom);
    canvas.translate(-center.dx, -center.dy);

    // The halo outside the limb: a breath of light leaving the ball, the
    // state's own color mixed into the style's own.
    final haloColor = Color.lerp(palette.halo, accent, 0.35)!;
    canvas.drawCircle(
      center,
      radius + radius * 0.06,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          radius * 1.06,
          [
            haloColor.withValues(alpha: 0.0),
            haloColor.withValues(alpha: dark ? 0.20 : 0.13),
            haloColor.withValues(alpha: 0.0),
          ],
          const [0.62, 0.9, 1.0],
        ),
    );

    // The ball: the style's metal — a light high on the upper left,
    // falling away to a dark limb — the way a ball reads under a lamp.
    final ball = Paint()
      ..shader = ui.Gradient.radial(
        center + Offset(-radius * 0.36, -radius * 0.42),
        radius * 1.75,
        palette.ball,
        const [0.0, 0.35, 0.72, 1.0],
      );
    canvas.drawCircle(center, radius, ball);

    // The lamp's own light: a small, quiet bloom where the light lands.
    canvas.drawCircle(
      center + Offset(-radius * 0.38, -radius * 0.44),
      radius * 0.42,
      Paint()
        ..shader = ui.Gradient.radial(
          center + Offset(-radius * 0.38, -radius * 0.44),
          radius * 0.42,
          [
            palette.specular.withValues(alpha: 0.9),
            palette.specular.withValues(alpha: 0.0),
          ],
        ),
    );

    // The coordinate grid, under the land: the metal's own faint graph
    // paper, meridians and parallels together.
    canvas.drawPath(
      world.graticule,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.7
        ..isAntiAlias = true
        ..color = palette.graticule,
    );

    // The land: a breath of shadow first — the relief reads lifted off
    // the metal — then the fills, then the outlines for every visible
    // country. Quiet, so the page's own words stay readable over it.
    canvas.drawPath(
      world.landFill,
      Paint()
        ..style = PaintingStyle.fill
        ..isAntiAlias = true
        ..color = palette.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.6),
    );
    canvas.save();
    canvas.translate(0, -1.4);
    canvas.drawPath(
      world.landFill,
      Paint()
        ..style = PaintingStyle.fill
        ..isAntiAlias = true
        ..color = palette.landFill,
    );
    canvas.restore();
    canvas.drawPath(
      world.landStroke,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = palette.landStroke,
    );

    // The satellite's clouds: soft white wisps laid over the land, only
    // where the ball faces the viewer — the earth as it reads from
    // orbit. They hold still, so they cost one draw, not a clock.
    if (clouds) {
      canvas.save();
      canvas.clipPath(
        ui.Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      );
      for (final (x, y, rx, ry) in _clouds) {
        final seat = Offset(
          center.dx + (x * 2 - 1) * radius * 0.86,
          center.dy + (y * 2 - 1) * radius * 0.86,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: seat,
            width: rx * 2 * radius * 0.55,
            height: ry * 2 * radius * 0.30,
          ),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.10)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9)
            ..isAntiAlias = true,
        );
      }
      canvas.restore();
    }

    // The roads first, under the lit country: wide soft glow, a bright
    // core, and — while the globe breathes — a comet of light gliding
    // each road round and round. A fresh arrival draws the core on, from
    // the country out to the hubs.
    final roadGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..color = accent.withValues(alpha: dark ? 0.34 : 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final roadCore = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..color = accent.withValues(
        alpha: (dark ? 0.85 : 0.60) * (0.7 + 0.3 * breathe),
      );
    final run = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: dark ? 0.85 : 0.5);
    for (final road in world.roads) {
      canvas.drawPath(road, roadGlow);
      if (arrive < 1.0) {
        // The road draws itself: the arrival's clock carries the pen
        // from the chosen country out to the hub.
        for (final m in road.computeMetrics()) {
          if (m.length < 8) continue;
          final head =
              m.length * Curves.easeOutCubic.transform(arrive.clamp(0.0, 1.0));
          canvas.drawPath(m.extractPath(0, head), roadCore);
          canvas.drawPath(m.extractPath(0, head), run);
        }
      } else {
        canvas.drawPath(road, roadCore);
        if (animated) {
          for (final m in road.computeMetrics()) {
            if (m.length < 24) continue;
            // One comet per road: a short bright dash gliding the whole
            // length over the breath's period.
            final t = (breath * m.length * 2) % m.length;
            final head = (t + math.min(24.0, m.length * 0.18)).clamp(
              0.0,
              m.length,
            );
            if (head > t) canvas.drawPath(m.extractPath(t, head), run);
          }
        }
      }
    }

    // The chosen country, lit: the state's light fills it and holds its
    // edge.
    if (world.litWhole) {
      canvas.drawPath(
        world.litFill,
        Paint()
          ..color = accent.withValues(alpha: dark ? 0.34 : 0.26)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true,
      );
    }
    canvas.drawPath(
      world.litStroke,
      Paint()
        ..color = accent.withValues(alpha: dark ? 0.95 : 0.80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    // The hubs: small lights where the world's roads gather. The three
    // the traffic reaches for read a touch brighter than the rest.
    for (var i = 0; i < world.hubs.length; i++) {
      final seat = world.hubs[i];
      final near = i < 3;
      canvas.drawCircle(
        seat,
        near ? 4.6 : 2.6,
        Paint()
          ..color = accent.withValues(alpha: near ? 0.16 : 0.10)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
          ..isAntiAlias = true,
      );
      canvas.drawCircle(
        seat,
        near ? 1.7 : 1.15,
        Paint()
          ..color = (dark ? Colors.white : Colors.black).withValues(
            alpha: near ? 0.75 : 0.42,
          )
          ..isAntiAlias = true,
      );
    }

    // The limb's atmosphere, last inside the ball: a ring of the state's
    // light hugging the edge from inside — the globe's edge reads lit,
    // not cut.
    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [
            accent.withValues(alpha: 0.0),
            accent.withValues(alpha: dark ? 0.55 : 0.35),
          ],
          const [0.72, 1.0],
        ),
    );
    canvas.restore();

    // The pin at the chosen country's anchor, on the scaled ball: a soft
    // bloom, two rings swelling with the breath, the bright seed they
    // swell around — and, on a fresh arrival, the seed drops the last
    // stretch with a bounce while a ring bursts outward from the pin.
    final anchor = world.anchor;
    if (anchor != null) {
      final seat = Offset(
        center.dx + (anchor.dx - center.dx) * zoom,
        center.dy + (anchor.dy - center.dy) * zoom,
      );
      final drop = Curves.elasticOut.transform(arrive.clamp(0.0, 1.0));
      final seedSeat = seat.translate(0, 10 * (1 - drop));
      final burst = arrive < 1.0 ? 1.0 - arrive : 0.0;
      if (burst > 0) {
        canvas.drawCircle(
          seat,
          14 + 26 * (1 - burst),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.4 * burst
            ..color = accent.withValues(alpha: 0.55 * burst)
            ..isAntiAlias = true,
        );
      }
      canvas.drawCircle(
        seedSeat,
        20 * (0.9 + 0.25 * breathe),
        Paint()
          ..color = accent.withValues(
            alpha: (dark ? 0.38 : 0.26) * (0.45 + 0.55 * breathe),
          )
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
          ..isAntiAlias = true,
      );
      for (final (r, a) in [(22.0, 0.30), (13.0, 0.55)]) {
        canvas.drawCircle(
          seedSeat,
          r * (0.85 + 0.3 * breathe),
          Paint()
            ..color = accent.withValues(alpha: a * (dark ? 1.0 : 0.75))
            ..isAntiAlias = true,
        );
      }
      canvas.drawCircle(
        seedSeat,
        3.4 + 1.2 * breathe,
        Paint()
          ..color = dark ? Colors.white : Colors.black
          ..isAntiAlias = true,
      );
      canvas.drawCircle(
        seedSeat,
        2.0,
        Paint()
          ..color = accent
          ..isAntiAlias = true,
      );
    }
  }

  @override
  bool shouldRepaint(_GlobePainter old) =>
      old.world != world ||
      old.accent != accent ||
      old.palette != palette ||
      old.dark != dark ||
      old.animated != animated ||
      old.clouds != clouds ||
      (old.breath - breath).abs() > 0.003 ||
      (old.arrive - arrive).abs() > 0.003 ||
      (old.zoom - zoom).abs() > 0.001;
}

/// The chosen country's anchor, back in degrees, for the hub search.
GlobePlace globePlaceOfVector((double, double, double) v) {
  final lat = math.asin(v.$3.clamp(-1.0, 1.0)) * 180 / math.pi;
  final lon = math.atan2(v.$2, v.$1) * 180 / math.pi;
  return GlobePlace(lat, lon);
}

/// One country's ready flat geometry: its code, its outline path (every
/// ring, outer and holes together, even-odd filled), and its anchor's
/// seat on the drawn map.
@immutable
class WorldShape {
  const WorldShape(this.code, this.path, this.anchor);

  final String code;
  final ui.Path path;
  final ui.Offset anchor;
}

/// One design's own map colors, when the design carries a palette: the
/// water, the land, the coast's ink and the grid — so the world wears
/// the design the page wears, instead of the neutral ink every look
/// shared. The monochrome and the homes without a palette keep the
/// quiet ink; a design that stands gets a world of its own.
@immutable
class MapSkin {
  const MapSkin({
    required this.water,
    required this.waterFade,
    required this.land,
    required this.edge,
    required this.grid,
  });

  /// The water's wash and its fade at the map's own top and bottom.
  final Color water;
  final Color waterFade;

  /// The land's fill and the coastlines' ink.
  final Color land;
  final Color edge;

  /// The graticule's ink (the painter carries its own alpha).
  final Color grid;

  /// The design's own world: null keeps the monochrome's quiet ink —
  /// the homes that carry no palette read it, and any key that is not
  /// one of the designs that stand lands there too.
  static MapSkin? forDesign(String key, bool dark) => switch (key) {
    'aether' => dark
        ? const MapSkin(
            water: Color(0xFF0D1420),
            waterFade: Color(0xFF080C13),
            land: Color(0xFF1D2430),
            edge: Color(0xFF33415A),
            grid: Color(0xFF33415A),
          )
        : const MapSkin(
            water: Color(0xFFE3E9F2),
            waterFade: Color(0xFFEDF0F6),
            land: Color(0xFFFDFEFF),
            edge: Color(0xFFC7D1E0),
            grid: Color(0xFFC7D1E0),
          ),
    'zed' => dark
        ? const MapSkin(
            water: Color(0xFF0D0A1E),
            waterFade: Color(0xFF070511),
            land: Color(0xFF1A1230),
            edge: Color(0xFF37275C),
            grid: Color(0xFF37275C),
          )
        : const MapSkin(
            water: Color(0xFFE7E1F5),
            waterFade: Color(0xFFEFEBF9),
            land: Color(0xFFFDFBFF),
            edge: Color(0xFFCDC2E8),
            grid: Color(0xFFCDC2E8),
          ),
    'gazette' => dark
        ? const MapSkin(
            water: Color(0xFF131009),
            waterFade: Color(0xFF0C0A06),
            land: Color(0xFF221D13),
            edge: Color(0xFF463B26),
            grid: Color(0xFF463B26),
          )
        : const MapSkin(
            water: Color(0xFFEBE1C9),
            waterFade: Color(0xFFF1E9D6),
            land: Color(0xFFFBF5E2),
            edge: Color(0xFFC2B48E),
            grid: Color(0xFFC2B48E),
          ),
    'pixel' => dark
        ? const MapSkin(
            water: Color(0xFF0C121A),
            waterFade: Color(0xFF070B10),
            land: Color(0xFF1A2430),
            edge: Color(0xFF2D3E52),
            grid: Color(0xFF2D3E52),
          )
        : const MapSkin(
            water: Color(0xFFE1EAF5),
            waterFade: Color(0xFFEBF1F8),
            land: Color(0xFFF7FAFD),
            edge: Color(0xFFC1CFE2),
            grid: Color(0xFFC1CFE2),
          ),
    'ios' => dark
        ? const MapSkin(
            water: Color(0xFF0C0C10),
            waterFade: Color(0xFF070709),
            land: Color(0xFF1C1C22),
            edge: Color(0xFF33333C),
            grid: Color(0xFF33333C),
          )
        : const MapSkin(
            water: Color(0xFFE5E5EB),
            waterFade: Color(0xFFEEEFF2),
            land: Color(0xFFFBFBFD),
            edge: Color(0xFFC8C8D0),
            grid: Color(0xFFC8C8D0),
          ),
    'bento' => dark
        ? const MapSkin(
            water: Color(0xFF100E0B),
            waterFade: Color(0xFF0A0907),
            land: Color(0xFF201C16),
            edge: Color(0xFF3B332A),
            grid: Color(0xFF3B332A),
          )
        : const MapSkin(
            water: Color(0xFFEDE4D1),
            waterFade: Color(0xFFF3ECDC),
            land: Color(0xFFFFFDF4),
            edge: Color(0xFFD6C9AC),
            grid: Color(0xFFD6C9AC),
          ),
    'gta' => dark
        ? const MapSkin(
            water: Color(0xFF0A0E1D),
            waterFade: Color(0xFF050812),
            land: Color(0xFF171D33),
            edge: Color(0xFF39406B),
            grid: Color(0xFFFFB84D),
          )
        : const MapSkin(
            water: Color(0xFFEDE2C9),
            waterFade: Color(0xFFF3EAD5),
            land: Color(0xFFFFF7E4),
            edge: Color(0xFFD8C2A0),
            grid: Color(0xFFB97A14),
          ),
    _ => null,
  };
}

/// The flat map, in the finish the settings picked — the quiet ink of
/// the classic, the modern tint, the night water, or the terrain's
/// greens. The world is drawn in the standard Web Mercator projection,
/// wider than the page ([scale]), centered where asked, with the
/// graticule over the water and the chosen country lit in the
/// connection's color, its anchor's halo breathing while the VPN
/// carries the traffic.
///
/// [finish] is how the land and water take their color ([FlatFinish]);
/// the borders themselves stay the official ones in every finish.
class WorldMapBackdrop extends StatefulWidget {
  const WorldMapBackdrop({
    super.key,
    required this.countries,
    required this.ink,
    required this.accent,
    required this.selected,
    required this.animated,
    this.finish = FlatFinish.classic,
    this.alignment = Alignment.center,
    this.scale = 1.45,
    this.skin,
  });

  /// The world, from [WorldMap.load]; empty until it arrives.
  final List<WorldCountry> countries;

  /// The theme's ink: the classic's land and edges read in it.
  final Color ink;

  /// The state's color: the chosen country is lit with it.
  final Color accent;

  /// The chosen country's ISO code, upper-case; '' for none.
  final String selected;

  /// Whether the map breathes: the halo and sheen move while the VPN
  /// carries the traffic; off, everything holds still.
  final bool animated;

  /// How the land and water take their color.
  final FlatFinish finish;

  final Alignment alignment;

  /// How much wider than the page the world is drawn: 1 draws it exactly
  /// the page's width, where every continent reads as a squeezed ribbon;
  /// more gives the countries room, and the page clips what runs over.
  final double scale;

  /// The design's own map colors, when the design carries a palette —
  /// the ink-based finishes (the classic, the modern) read them; the
  /// finishes that carry their own palette (the night, the terrain, the
  /// hud) keep theirs.
  final MapSkin? skin;

  @override
  State<WorldMapBackdrop> createState() => _WorldMapBackdropState();
}

class _WorldMapBackdropState extends State<WorldMapBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

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
    _shapes = [
      for (final c in widget.countries)
        WorldShape(
          c.code,
          _pathOf(c, sx, mapH),
          ui.Offset(c.anchorX * sx, mercatorYOfWorldY(c.anchorY, mapH)),
        ),
    ];
    _builtFrom = widget.countries;
    _builtForW = mapW;
  }

  /// The country's whole outline, one path for every ring — the fill
  /// runs with an even-odd rule, so a hole shows the country around it.
  /// Every point bends onto the Mercator map: x linear, y by the
  /// projection, so the shapes land where a standard map draws them.
  static ui.Path _pathOf(WorldCountry c, double sx, double mapH) {
    final path = ui.Path();
    for (final ring in c.rings) {
      if (ring.isEmpty) continue;
      path.moveTo(ring.first.dx * sx, mercatorYOfWorldY(ring.first.dy, mapH));
      for (var i = 1; i < ring.length; i++) {
        path.lineTo(ring[i].dx * sx, mercatorYOfWorldY(ring[i].dy, mapH));
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
          // The Mercator world is its own width tall (the standard
          // ±85° cut): it is drawn wider than the page (scale), floats
          // where asked, and what runs over the page's edge is clipped
          // — bigger countries, real proportions, no bleed.
          final mapW = box.maxWidth * widget.scale;
          final mapH = mapW;
          _ensureShapes(mapW, mapH);
          return SizedBox.expand(
            child: ClipRect(
              child: Align(
                alignment: widget.alignment,
                child: SizedBox(
                  width: mapW,
                  height: mapH,
                  // The world's south edge dissolves instead of stopping:
                  // the projection cuts at 85°, where Antarctica fills the
                  // map's last rows, and a straight line of land against
                  // the page's own gradient reads as a hard border — the
                  // last rows melt out, the coastlines above them keep
                  // their place (no settled country's anchor sits in the
                  // band the fade takes).
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, 0),
                      ],
                      stops: [0, 0.84, 1],
                    ).createShader(bounds),
                    child: AnimatedBuilder(
                      animation: _breath,
                      builder: (context, _) => CustomPaint(
                        size: Size(mapW, mapH),
                        painter: _WorldPainter(
                          shapes: _shapes ?? const <WorldShape>[],
                          ink: widget.ink,
                          accent: widget.accent,
                          selected: widget.selected,
                          finish: widget.finish,
                          skin: widget.skin,
                          t: widget.animated ? _breath.value : 0.5,
                        ),
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

/// The flat map's painter: the water, the graticule, the land, the lit
/// country, its anchor's halo, and a quiet sheen that follows the
/// breath. The paths arrive built ([WorldShape]); a frame only draws
/// them.
class _WorldPainter extends CustomPainter {
  _WorldPainter({
    required this.shapes,
    required this.ink,
    required this.accent,
    required this.selected,
    required this.finish,
    required this.t,
    this.skin,
  });

  final List<WorldShape> shapes;
  final Color ink;
  final Color accent;
  final String selected;

  /// How the land and water take their color.
  final FlatFinish finish;

  /// The design's own map colors, when the design carries a palette.
  final MapSkin? skin;
  final double t;

  /// The ink-based finishes: the ones the design's own map colors can
  /// carry (the night, the terrain and the hud paint themselves).
  bool get _inked =>
      finish == FlatFinish.classic || finish == FlatFinish.modern;

  @override
  void paint(Canvas canvas, Size size) {
    // A light ink on the night, a dark one on the day — the classic's
    // quiet is a matter of alpha, not hue, in either theme. The finishes
    // carry their own land and water instead: the night's deep water and
    // slate land, the terrain's greens over soft blue, the hud's slate
    // over the deep water. In every finish the land sits a shade above
    // the graticule, so a country reads as a shape, not as noise. The
    // design's own skin recolors the ink-based finishes, so the world
    // wears the design the page wears.
    final dark = ink.computeLuminance() > 0.5;
    final modern = finish == FlatFinish.modern;
    final hud = finish == FlatFinish.hud;
    final (landColor, lineInk) = skin != null && _inked
        ? (skin!.land, skin!.edge)
        : switch (finish) {
            FlatFinish.classic => (
              ink.withValues(alpha: dark ? 0.20 : 0.14),
              ink.withValues(alpha: dark ? 0.32 : 0.26),
            ),
            FlatFinish.modern => (
              Color.alphaBlend(
                accent.withValues(alpha: dark ? 0.10 : 0.07),
                ink.withValues(alpha: dark ? 0.20 : 0.14),
              ),
              ink.withValues(alpha: dark ? 0.32 : 0.26),
            ),
            FlatFinish.night => (
              dark ? const Color(0xFF1D2A45) : const Color(0xFF25335A),
              dark ? const Color(0xFF42567F) : const Color(0xFF4E6392),
            ),
            FlatFinish.terrain => (
              dark ? const Color(0xFF33534A) : const Color(0xFF9DBE93),
              dark ? const Color(0xFF517A6A) : const Color(0xFF6F9566),
            ),
            FlatFinish.hud => (
              dark ? const Color(0xFF1D2540) : const Color(0xFFE7DBC0),
              dark ? const Color(0xFF46548A) : const Color(0xFFB49F78),
            ),
          };

    // The water, where the finish paints it: a wash under everything,
    // fading to nothing at the map's own top and bottom, so the world
    // meets the page as a horizon meets the sky — never a hard edge.
    if (finish != FlatFinish.classic || (skin != null && _inked)) {
      final (water, waterFade) = skin != null && _inked
          ? (skin!.water, skin!.waterFade)
          : switch (finish) {
              FlatFinish.night => (
                dark ? const Color(0xFF0A1526) : const Color(0xFF15233D),
                dark ? const Color(0xFF060C18) : const Color(0xFF0B1424),
              ),
              FlatFinish.terrain => (
                dark ? const Color(0xFF123047) : const Color(0xFFB5CFE2),
                dark ? const Color(0xFF0A1D2E) : const Color(0xFFDCE9F2),
              ),
              FlatFinish.hud => (
                dark ? const Color(0xFF0B1122) : const Color(0xFFB9CFDA),
                dark ? const Color(0xFF060A16) : const Color(0xFFDCE8EC),
              ),
              _ => (
                dark ? ink.withValues(alpha: 0.05) : ink.withValues(alpha: 0.035),
                dark ? ink.withValues(alpha: 0.0) : ink.withValues(alpha: 0.0),
              ),
            };
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, 0),
            Offset(0, size.height),
            [waterFade, water, water, waterFade],
            const [0, 0.16, 0.84, 1],
          ),
      );
    }

    // The graticule: meridians every 30 degrees the whole way round, and
    // the parallels at their own rows on the Mercator map — the lines
    // bend with the projection, the way a real atlas draws them, thinner
    // than the land's edge. The hud's radar grid is its own: finer, and
    // in the amber the game's panels wear.
    final hudAmber = dark ? const Color(0xFFFFB84D) : const Color(0xFFB97A14);
    final grid = Paint()
      ..color = hud
          ? hudAmber.withValues(alpha: dark ? 0.11 : 0.16)
          : skin != null && _inked
          ? skin!.grid.withValues(alpha: dark ? 0.10 : 0.14)
          : finish == FlatFinish.classic || finish == FlatFinish.modern
          ? ink.withValues(alpha: dark ? 0.055 : 0.05)
          : (dark ? Colors.white : Colors.black).withValues(alpha: 0.07)
      ..strokeWidth = hud ? 0.7 : 0.6;
    final lonSteps = hud ? 24 : 12;
    for (var lon = 0; lon <= lonSteps; lon++) {
      final x = lon / lonSteps * size.width;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    final parallels = hud
        ? const [75.0, 60.0, 45.0, 30.0, 15.0, 0.0, -15.0, -30.0, -45.0, -60.0, -75.0]
        : const [60.0, 30.0, 0.0, -30.0, -60.0];
    for (final lat in parallels) {
      final y = mercatorYOfLat(lat, size.height);
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

    // The tinted finishes lay a breath of shadow under the land first, so
    // the continents read lifted off the page the way they do on the
    // globe; the classic keeps its quiet. The hud lays the neon instead:
    // the coast glows in the sunset's pink, the night city's own light.
    if (modern || hud) {
      canvas.drawPath(
        _allLand(shapes, chosen),
        Paint()
          ..color = hud
              ? (dark
                      ? const Color(0xFFFF4D8D)
                      : const Color(0xFFD6336C))
                  .withValues(alpha: dark ? 0.30 : 0.18)
              : (dark ? Colors.black : ink).withValues(
                alpha: dark ? 0.34 : 0.10,
              )
          ..style = hud ? PaintingStyle.stroke : PaintingStyle.fill
          ..strokeWidth = hud ? 2.4 : 1.0
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, hud ? 2.6 : 2.4)
          ..isAntiAlias = true,
      );
    }

    final land = Paint()
      ..color = landColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final edge = Paint()
      ..color = lineInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = finish == FlatFinish.classic ? 0.9 : 1.0
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
        ..color = accent.withValues(
          alpha: finish == FlatFinish.classic
              ? (dark ? 0.30 : 0.22)
              : (dark ? 0.36 : 0.28),
        )
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      final litEdge = Paint()
        ..color = accent.withValues(
          alpha: finish == FlatFinish.classic
              ? (dark ? 0.85 : 0.70)
              : (dark ? 0.92 : 0.80),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = finish == FlatFinish.classic ? 1.5 : 1.6
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
      for (final (r, a) in [(30.0, 0.14), (20.0, 0.24), (12.0, 0.40)]) {
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

    // The hud's radar sweep: a band of amber light walking the world
    // top to bottom while the tunnel carries — the radar's own scan,
    // made of the breath the animated map already runs. At rest it
    // holds one quiet line mid-map.
    if (hud) {
      final y = size.height * t;
      final band = Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, y - 30),
          Offset(0, y + 30),
          [
            hudAmber.withValues(alpha: 0.0),
            hudAmber.withValues(alpha: dark ? 0.12 : 0.10),
            hudAmber.withValues(alpha: 0.0),
          ],
        );
      canvas.drawRect(Offset(0, y - 30) & Size(size.width, 60), band);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = hudAmber.withValues(alpha: dark ? 0.26 : 0.20)
          ..strokeWidth = 1.1,
      );
    }
  }

  /// Every country but the chosen one, as one path — the shadow's own
  /// single draw.
  static ui.Path _allLand(List<WorldShape> shapes, WorldShape? chosen) {
    final path = ui.Path()..fillType = ui.PathFillType.evenOdd;
    for (final s in shapes) {
      if (identical(s, chosen)) continue;
      path.addPath(s.path, ui.Offset.zero);
    }
    return path;
  }

  @override
  bool shouldRepaint(_WorldPainter old) =>
      old.selected != selected ||
      old.accent != accent ||
      old.ink != ink ||
      old.finish != finish ||
      old.skin != skin ||
      old.shapes != shapes ||
      (old.t - t).abs() > 0.003;
}

/// The home's world, in the kind the settings picked: the flat map (the
/// classic and the modern finish), the globe (the metal ball), or the
/// hud (the GTA design's own map). A change of kind is a soft crossfade,
/// so the map melts into its next self instead of popping — and a change
/// of design fades it the same way, the world wearing the design's own
/// colors.
class WorldBackdrop extends StatelessWidget {
  const WorldBackdrop({
    super.key,
    required this.kind,
    required this.countries,
    required this.accent,
    required this.selected,
    required this.animated,
    required this.dark,
    required this.label,
    this.style = GlobeStyle.silver,
    this.still = false,
    this.ink,
    this.designKey = 'mono',
  });

  final MapKind kind;
  final List<WorldCountry> countries;
  final Color accent;
  final String selected;
  final bool animated;
  final bool dark;
  final String label;
  final GlobeStyle style;
  final bool still;

  /// The land's own ink — the countries' outlines. Null keeps the
  /// monochrome's; the designs that carry a palette pass their own, so
  /// the map is drawn in the paper's ink, the violet's gray or the
  /// tonal blue-gray instead of the neutral one.
  final Color? ink;

  /// The design the page wears: the key the design's own map colors
  /// ([MapSkin.forDesign]) read from.
  final String designKey;

  @override
  Widget build(BuildContext context) {
    final Widget world;
    if (kind == MapKind.globe) {
      world = WorldGlobe(
        countries: countries,
        accent: accent,
        selected: selected,
        animated: animated,
        dark: dark,
        label: label,
        style: style,
        still: still,
      );
    } else {
      // The design's own world: the palette designs recolor the
      // ink-based finishes, and the hud kind paints the GTA design's
      // own map whatever the design — the game's plate is the game's.
      world = WorldMapBackdrop(
        countries: countries,
        ink: ink ?? (dark ? Colors.white : const Color(0xFF0A0A0A)),
        accent: accent,
        selected: selected,
        animated: animated,
        finish: kind == MapKind.flat
            ? FlatFinish.modern
            : kind == MapKind.hud
            ? FlatFinish.hud
            : FlatFinish.classic,
        scale: kind == MapKind.classic ? 1.45 : 1.32,
        skin: MapSkin.forDesign(designKey, dark),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.985, end: 1.0).animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey('$designKey-$kind'),
        child: world,
      ),
    );
  }
}
