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
        GlobeCountry(
          c.code,
          globePlaceOf(c).unit,
          [
            for (final ring in c.rings)
              GlobeRing(_unitVectors(ring)),
          ],
        ),
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
  ) =>
      project(x * r, y * r, z * r);
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
  final scored = [
    for (final hub in globeHubs) (hub.angleTo(from), hub),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
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

/// The home page's globe: the world's own outlines carried onto a silver
/// ball, turned so the chosen country faces the viewer. The chosen
/// country is lit in the connection's light; a glowing pin stands at its
/// anchor, and a floating glass card names it. From the anchor, the
/// great-circle paths to the nearest hubs burn slow in the same light
/// while the VPN carries the traffic — off, everything rests.
class WorldGlobe extends StatefulWidget {
  const WorldGlobe({
    super.key,
    required this.countries,
    required this.accent,
    required this.selected,
    required this.animated,
    required this.dark,
    required this.label,
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

  /// Whether the app's night is on: the silver reads darker over it.
  final bool dark;

  /// The chosen country's name, for the floating card; '' hides it.
  final String label;

  @override
  State<WorldGlobe> createState() => _WorldGlobeState();
}

class _WorldGlobeState extends State<WorldGlobe>
    with SingleTickerProviderStateMixin {
  /// The breath: the pin's rings, the card's bob, the paths' stream.
  late final AnimationController _breath =
      AnimationController(vsync: this, duration: const Duration(seconds: 5));

  /// The globe's turn: from the view it rests on to the chosen country's.
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  /// The view the spin starts from, and the one it lands on, in degrees.
  double _fromLat = 25, _fromLon = 10;
  double _toLat = 25, _toLon = 10;
  double _currentLat = 25, _currentLon = 10;

  /// Whether a turn ever landed: the world file arrives after the first
  /// frame, so the first real turn happens when it does.
  bool _turned = false;

  @override
  void initState() {
    super.initState();
    _breath.value = 0.5;
    if (widget.animated) _breath.repeat(reverse: true);
    _turnTo(widget.selected, animate: false);
  }

  @override
  void didUpdateWidget(WorldGlobe old) {
    super.didUpdateWidget(old);
    if (old.animated != widget.animated) {
      if (widget.animated) {
        _breath.repeat(reverse: true);
      } else {
        _breath.stop();
      }
    }
    if (old.selected != widget.selected ||
        (!_turned && widget.countries.isNotEmpty)) {
      _turnTo(widget.selected, animate: old.selected == widget.selected);
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
    final place = _placeOfVector(country.anchor);
    _fromLat = _currentLat;
    _fromLon = _currentLon;
    _toLat = place.$1;
    _toLon = place.$2;
    // The long way around is never worth it: if the turn crosses more
    // than half the world, come the other way.
    var dLon = _toLon - _fromLon;
    while (dLon > 180) {
      dLon -= 360;
    }
    while (dLon < -180) {
      dLon += 360;
    }
    _toLon = _fromLon + dLon;
    if (animate && widget.countries.isNotEmpty) {
      _spin.forward(from: 0);
    } else {
      _currentLat = _toLat;
      _currentLon = _toLon;
      _spin.value = 1.0;
    }
  }

  /// A unit vector back to its own lat and lon, in degrees.
  static (double, double) _placeOfVector((double, double, double) v) {
    final lat = math.asin(v.$3.clamp(-1.0, 1.0)) * 180 / math.pi;
    final lon = math.atan2(v.$2, v.$1) * 180 / math.pi;
    return (lat, lon);
  }

  /// The world at the view now on screen: built once per turn, redrawn
  /// cheaply on every frame after. The turn is the expensive thing (every
  /// point of every border moves); the breath is not, so the cache turns
  /// with the globe and the breath only re-lights what is already built.
  _RotatedWorld? _cache;

  @override
  void dispose() {
    _breath.dispose();
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.countries.isEmpty) return const SizedBox.expand();
    return IgnorePointer(
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
                AnimatedBuilder(
                  animation: Listenable.merge([_breath, _spin]),
                  builder: (context, _) {
                    // The turn, eased: the globe arrives at the chosen
                    // country instead of snapping to it.
                    final t = Curves.easeInOutCubic.transform(
                      _spin.value.clamp(0.0, 1.0),
                    );
                    _currentLat = _fromLat + (_toLat - _fromLat) * t;
                    _currentLon = _fromLon + (_toLon - _fromLon) * t;
                    final geometry = GlobeGeometry.of(widget.countries);
                    final radius = d / 2 * 0.94;
                    final center =
                        Offset(box.maxWidth / 2, box.maxHeight / 2);
                    final world = _worldFor(
                      geometry,
                      radius,
                      center,
                    );
                    return CustomPaint(
                      size: Size(box.maxWidth, box.maxHeight),
                      painter: _GlobePainter(
                        world: world,
                        accent: widget.accent,
                        dark: widget.dark,
                        breath: widget.animated ? _breath.value : 0.5,
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
                    child: _FloatingCard(
                      countries: GlobeGeometry.of(widget.countries),
                      selected: widget.selected,
                      label: widget.label,
                      accent: widget.accent,
                      dark: widget.dark,
                      animated: widget.animated,
                      breath: _breath,
                      spin: _spin,
                      fromLat: _fromLat,
                      fromLon: _fromLon,
                      toLat: _toLat,
                      toLon: _toLon,
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
/// it never drifts off the country it names.
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
    required this.fromLat,
    required this.fromLon,
    required this.toLat,
    required this.toLon,
  });

  final List<GlobeCountry> countries;
  final String selected;
  final String label;
  final Color accent;
  final bool dark;
  final bool animated;
  final Animation<double> breath;
  final Animation<double> spin;
  final double fromLat;
  final double fromLon;
  final double toLat;
  final double toLon;

  @override
  Widget build(BuildContext context) {
    // The same turn the painter paints, so the card sits over its pin.
    final t = Curves.easeInOutCubic.transform(spin.value.clamp(0.0, 1.0));
    final lat = fromLat + (toLat - fromLat) * t;
    final lon = fromLon + (toLon - fromLon) * t;
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
        // from the page's own size, the way the painter reads them.
        final d = math.min(box.maxWidth * 1.16, box.maxHeight * 1.28);
        final radius = d / 2 * 0.94;
        const cardW = 168.0;
        final dx = x * radius;
        final dy = -y * radius;
        // Above the pin: the card's own stem points down at it.
        const lift = 58.0;
        final left = (box.maxWidth / 2 + dx - cardW / 2)
            .clamp(12.0, math.max(12.0, box.maxWidth - cardW - 12))
            .toDouble();
        final top =
            (box.maxHeight / 2 + dy - lift).clamp(10.0, box.maxHeight - 120);
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
                    child: _cardBody(context),
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
        // The pane: glass over the globe, the country's flag and name.
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 168,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: dark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.white.withValues(alpha: 0.82),
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

  /// The chosen country: its outline and its fill when it lies wholly
  /// in view (the fill is empty when it half crosses the limb).
  final ui.Path litStroke;
  final ui.Path litFill;

  /// The chosen country's anchor, on screen; null when behind the ball.
  final Offset? anchor;

  /// The chosen country's roads, one path per hub, only their front-of-
  /// ball runs.
  final List<ui.Path> roads;

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
          final z = ring.xyz[i * 3] * view.v.$1 +
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
        final z = ring.xyz[i * 3] * view.v.$1 +
            ring.xyz[i * 3 + 1] * view.v.$2 +
            ring.xyz[i * 3 + 2] * view.v.$3;
        if (z > 0) {
          final p = view.project(
            ring.xyz[i * 3],
            ring.xyz[i * 3 + 1],
            ring.xyz[i * 3 + 2],
          );
          final q = Offset(center.dx + p.$1 * radius, center.dy - p.$2 * radius);
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

/// The painter: the ball of silver, the land, the lit country, the pin,
/// and the roads. Everything is already projected ([_RotatedWorld]); a
/// frame only lights it.
class _GlobePainter extends CustomPainter {
  _GlobePainter({
    required this.world,
    required this.accent,
    required this.dark,
    required this.breath,
  });

  final _RotatedWorld world;
  final Color accent;
  final bool dark;
  final double breath;

  @override
  void paint(Canvas canvas, Size size) {
    final center = world.center;
    final radius = world.radius;

    // The ball: silver metal — a light high on the upper left, falling
    // away to a dark limb — the way a steel ball reads under a lamp. In
    // the day theme the metal is lighter; the same shape reads in both.
    final ball = Paint()
      ..shader = ui.Gradient.radial(
        center + Offset(-radius * 0.36, -radius * 0.42),
        radius * 1.75,
        dark
            ? [
                const Color(0xFF9AA3B2),
                const Color(0xFF4A5160),
                const Color(0xFF20242E),
                const Color(0xFF0B0D12),
              ]
            : [
                const Color(0xFFF4F6FA),
                const Color(0xFFC3C9D6),
                const Color(0xFF8C93A3),
                const Color(0xFF5D6371),
              ],
        const [0.0, 0.35, 0.72, 1.0],
      );
    canvas.drawCircle(center, radius, ball);

    final breathe = 0.5 - 0.5 * math.cos(2 * math.pi * breath);

    // The land: outlines for every visible country, fills for the ones
    // that lie wholly in view — quiet, so the page's own words stay
    // readable over the metal.
    canvas.drawPath(
      world.landFill,
      Paint()
        ..style = PaintingStyle.fill
        ..isAntiAlias = true
        ..color = dark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.black.withValues(alpha: 0.08),
    );
    canvas.drawPath(
      world.landStroke,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..isAntiAlias = true
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = (dark ? Colors.white : Colors.black)
            .withValues(alpha: dark ? 0.34 : 0.42),
    );

    // The roads first, under the lit country: wide soft glow, a bright
    // core, and — while the globe breathes — a comet of light gliding
    // each road round and round.
    for (final road in world.roads) {
      canvas.drawPath(
        road,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.2
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..color = accent.withValues(alpha: dark ? 0.34 : 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawPath(
        road,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..color = accent.withValues(
            alpha: (dark ? 0.85 : 0.60) * (0.7 + 0.3 * breathe),
          ),
      );
      if (breathe > 0.05 && breath > 0.0) {
        final run = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(alpha: dark ? 0.85 : 0.5);
        for (final m in road.computeMetrics()) {
          if (m.length < 24) continue;
          // One comet per road: a short bright dash gliding the whole
          // length over the breath's period.
          final t = (breath * m.length * 2) % m.length;
          final head = (t + math.min(24.0, m.length * 0.18))
              .clamp(0.0, m.length);
          if (head > t) canvas.drawPath(m.extractPath(t, head), run);
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

    // The pin at the chosen country's anchor: a soft bloom, two rings
    // swelling with the breath, and the bright seed they swell around.
    final anchor = world.anchor;
    if (anchor != null) {
      canvas.drawCircle(
        anchor,
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
          anchor,
          r * (0.85 + 0.3 * breathe),
          Paint()
            ..color = accent.withValues(alpha: a * (dark ? 1.0 : 0.75))
            ..isAntiAlias = true,
        );
      }
      canvas.drawCircle(
        anchor,
        3.4 + 1.2 * breathe,
        Paint()
          ..color = dark ? Colors.white : Colors.black
          ..isAntiAlias = true,
      );
      canvas.drawCircle(
        anchor,
        2.0,
        Paint()..color = accent..isAntiAlias = true,
      );
    }

    // The limb's atmosphere, last: a ring of the state's light hugging
    // the edge from inside — the globe's edge reads lit, not cut.
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
  }

  @override
  bool shouldRepaint(_GlobePainter old) =>
      old.world != world ||
      old.accent != accent ||
      old.dark != dark ||
      (old.breath - breath).abs() > 0.003;
}

/// The chosen country's anchor, back in degrees, for the hub search.
GlobePlace globePlaceOfVector((double, double, double) v) {
  final lat = math.asin(v.$3.clamp(-1.0, 1.0)) * 180 / math.pi;
  final lon = math.atan2(v.$2, v.$1) * 180 / math.pi;
  return GlobePlace(lat, lon);
}
