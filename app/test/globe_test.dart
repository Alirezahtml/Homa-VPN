// The globe's own math, verified without pixels: the projection puts the
// chosen place dead center and in front, hides the far side, the rings
// live on the unit sphere, the hubs sort near-first, and a great circle
// lands where it takes off.
import 'dart:math' as math;

import 'package:arman_vpn/ui/world_map.dart';
import 'package:flutter_test/flutter_test.dart';

/// A ring point from a lat and lon, in the world file's own units — the
/// test builds countries the same way the file stores them.
Offset ringPoint(double latDeg, double lonDeg) => Offset(
      (lonDeg + 180) / 360 * WorldMap.width,
      (90 - latDeg) / 180 * WorldMap.height,
    );

/// A one-country world: Finland's ring, in the file's own shape.
List<WorldCountry> finlandWorld() => [
      WorldCountry(
        'FI',
        ringPoint(64.0, 26.0).dx,
        ringPoint(64.0, 26.0).dy,
        [
          [
            for (var i = 0; i < 8; i++) ringPoint(63.0 + i * 0.01, 25.0),
          ],
        ],
      ),
    ];

void main() {
  group('GlobeView', () {
    test('puts the view center dead ahead', () {
      final view = GlobeView.ofDeg(60.17, 24.94); // Helsinki
      final (x, y, z) = GlobePlace(60.17, 24.94).unit;
      final (px, py, pz) = view.project(x, y, z);
      expect(px, closeTo(0, 1e-9));
      expect(py, closeTo(0, 1e-9));
      expect(pz, closeTo(1, 1e-9));
    });

    test('hides the far side of the ball', () {
      final view = GlobeView.ofDeg(60.17, 24.94);
      // The antipode of the view center: behind the ball.
      final lat = 60.17 * math.pi / 180;
      final lon = 24.94 * math.pi / 180;
      final (x, y, z) = view.project(
        -math.cos(lat) * math.cos(lon),
        -math.cos(lat) * math.sin(lon),
        -math.sin(lat),
      );
      expect(z, lessThan(0));
      x;
      y;
    });

    test('the limb is at depth zero', () {
      // The center of the view reads deeper than a point 60 degrees of
      // arc away, and that point still faces the viewer; a point 90
      // degrees away sits exactly at the limb, at depth zero.
      final view = GlobeView.ofDeg(0, 0);
      final (cx, cy, cz) = view.project(1, 0, 0);
      final (lx, ly, lz) = _unit(0, 60);
      final (sx, sy, sz) = view.project(lx, ly, lz);
      final (ex, ey, ez) = _unit(0, 90);
      final (hx, hy, hz) = view.project(ex, ey, ez);
      expect(cz, greaterThan(sz));
      expect(sz, greaterThan(0));
      expect(hz, closeTo(0, 1e-9));
      cx;
      cy;
      sx;
      sy;
      hx;
      hy;
    });

    test('north stays up on screen', () {
      // Screen y grows upward in the projection: a point due north of
      // the view center sits above it.
      final view = GlobeView.ofDeg(20, 0);
      final (ux0, uy0, uz0) = _unit(40, 0);
      final (ux, uy, uz) = view.project(ux0, uy0, uz0);
      final (mx0, my0, mz0) = _unit(20, 0);
      final (mx, my, mz) = view.project(mx0, my0, mz0);
      expect(uy, greaterThan(my));
      ux;
      uz;
      mx;
      mz;
    });
  });

  group('GlobeGeometry', () {
    test('ring points land on the unit sphere', () {
      final geometry = GlobeGeometry.of(finlandWorld());
      final ring = geometry.first.rings.first;
      for (var i = 0; i < ring.points; i++) {
        final x = ring.xyz[i * 3];
        final y = ring.xyz[i * 3 + 1];
        final z = ring.xyz[i * 3 + 2];
        expect(math.sqrt(x * x + y * y + z * z), closeTo(1, 1e-9));
      }
    });

    test('the anchor reads back as the place it came from', () {
      final geometry = GlobeGeometry.of(finlandWorld());
      final place = globePlaceOfVector(geometry.first.anchor);
      expect(place.latDeg, closeTo(64.0, 0.01));
      expect(place.lonDeg, closeTo(26.0, 0.01));
    });
  });

  group('nearestHubs', () {
    test('sorts the hubs nearest first, and takes three', () {
      const finland = GlobePlace(64.0, 26.0);
      final hubs = nearestHubs(finland, 3);
      expect(hubs, hasLength(3));
      // Stockholm is the closest hub to Finland; Sydney is not among
      // the first three of the northern hemisphere.
      final dists = [for (final h in hubs) finland.angleTo(h)];
      expect(dists.first, lessThan(dists.last));
      expect(
        hubs.map((h) => '${h.latDeg.round()},${h.lonDeg.round()}'),
        contains('59,18'), // Stockholm
      );
      expect(
        hubs.map((h) => '${h.latDeg.round()},${h.lonDeg.round()}'),
        isNot(contains('-34,151')), // Sydney
      );
    });
  });

  group('greatCirclePath', () {
    test('takes off and lands on the sphere', () {
      final a = GlobePlace(60.17, 24.94).unit; // Helsinki
      final b = GlobePlace(50.11, 8.68).unit; // Frankfurt
      final path = greatCirclePath(a, b);
      expect(path, isNotEmpty);
      double len((double, double, double) p) =>
          math.sqrt(p.$1 * p.$1 + p.$2 * p.$2 + p.$3 * p.$3);
      // The ends sit on the sphere (no lift), the middle rises above it.
      expect(len(path.first), closeTo(1, 1e-9));
      expect(len(path.last), closeTo(1, 1e-9));
      expect(len(path[path.length ~/ 2]), greaterThan(1.05));
    });

    test('gives nothing when both ends are the same place', () {
      final a = GlobePlace(60.17, 24.94).unit;
      expect(greatCirclePath(a, a), isEmpty);
    });
  });

  group('GlobePlace.angleTo', () {
    test('knows how far apart two places really are', () {
      // Helsinki to Frankfurt, over the sphere: about 15.6 degrees of arc.
      const a = GlobePlace(60.17, 24.94);
      const b = GlobePlace(50.11, 8.68);
      expect(a.angleTo(b), closeTo(15.6, 0.5));
      // And to its own antipode: half the world, 180 degrees.
      const antipode = GlobePlace(-60.17, -155.06);
      expect(a.angleTo(antipode), closeTo(180, 0.01));
    });
  });
}

/// A place's unit vector, as three arguments for [GlobeView.project].
(double, double, double) _unit(double latDeg, double lonDeg) =>
    GlobePlace(latDeg, lonDeg).unit;
