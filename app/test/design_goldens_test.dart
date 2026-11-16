// Renders the phone's home in each of its three designs (the wheel, the
// tiles, the compact card), in both themes and both states, as golden
// images — real pixels of the design, for a look that no assertion can
// give. Refresh with:
//   flutter test --update-goldens test/design_goldens_test.dart
//
// Not for CI (its Flutter renders text a shade differently); a golden
// run is a local affair.
@Skip(
  'Golden images depend on the exact Flutter build rendering the text; '
  'they are for a local look at the design (flutter test '
  '--update-goldens test/design_goldens_test.dart), not for CI, which runs '
  'another Flutter version.',
)
library;

import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_controller.dart';
import 'package:arman_vpn/ui/app.dart';
import 'package:arman_vpn/ui/world_map.dart' show WorldMap;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arman_vpn/core/models.dart' show LocationList;

import 'settle.dart' show quietAudio, settle;
import 'widget_test.dart' show FakeApi, stillMotion;

/// The core's own list: Mozilla's recommended location as a place of its
/// own (code REC), then real countries — the shape the wheel is built
/// for, unlike the widget tests' bare three.
class DesignApi extends FakeApi {
  @override
  Future<LocationList> locations() async => LocationList.fromJson({
        'locations': [
          {
            'code': 'REC',
            'name': 'Recomended Location',
            'recommended': true,
            'ping_ms': 70,
          },
          {'code': 'US', 'name': 'United States', 'ping_ms': 208},
          {'code': 'DE', 'name': 'Germany', 'ping_ms': 90},
          {'code': 'JP', 'name': 'Japan', 'ping_ms': 240},
          {'code': 'NL', 'name': 'Netherlands', 'ping_ms': 180},
        ],
      });
}

void main() {
  setUpAll(() async {
    Future<void> load(String family, List<String> files) async {
      final loader = FontLoader(family);
      for (final f in files) {
        loader.addFont(rootBundle.load('assets/fonts/$f'));
      }
      await loader.load();
    }

    await load('Inter', [
      'Inter/Inter-Regular.ttf',
      'Inter/Inter-Medium.ttf',
      'Inter/Inter-SemiBold.ttf',
      'Inter/Inter-Bold.ttf',
    ]);
    await load('Vazirmatn', [
      'Vazirmatn-Regular.ttf',
      'Vazirmatn-Medium.ttf',
      'Vazirmatn-SemiBold.ttf',
      'Vazirmatn-Bold.ttf',
    ]);
    await load('SpaceGrotesk', [
      'SpaceGrotesk/SpaceGrotesk-Regular.ttf',
      'SpaceGrotesk/SpaceGrotesk-Medium.ttf',
      'SpaceGrotesk/SpaceGrotesk-SemiBold.ttf',
      'SpaceGrotesk/SpaceGrotesk-Bold.ttf',
    ]);
  });

  Future<void> phone(
    WidgetTester tester, {
    required String name,
    ThemeMode theme = ThemeMode.dark,
    bool connected = true,
    String language = 'en',
    String design = 'wheel',
  }) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.view.platformDispatcher.platformBrightnessTestValue = theme ==
            ThemeMode.dark
        ? Brightness.dark
        : Brightness.light;
    addTearDown(tester.view.reset);

    final api = DesignApi()
      ..systemProxySupported = false
      ..on = connected
      ..online = connected
      // A chosen country, as a user's own pick would be: the wheel rests
      // on it, the map lights it.
      ..location = connected ? 'US' : '';
    // The world behind the switch reads its vector file through the real
    // event loop, outside the test's fake clock: load it first, so the
    // map paints in the golden rather than waiting forever.
    await tester.runAsync(() async {
      await WorldMap.load();
    });
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings()
      ..themeMode = theme
      ..language = language
      ..homeDesign = design;
    await tester.pumpWidget(
      Directionality(
        textDirection: language == 'fa' ? TextDirection.rtl : TextDirection.ltr,
        child: VpnApp(core: core, settings: settings),
      ),
    );
    core.start();
    await settle(tester);

    // The brand images decode through the real event loop, outside the
    // test's fake clock: flush it, then rebuild with the images ready.
    final context = tester.element(find.byType(VpnApp));
    await tester.runAsync(() async {
      await precacheImage(const AssetImage('assets/wordmark.png'), context);
      await precacheImage(
        const AssetImage('assets/wordmark_dark.png'),
        context,
      );
      await precacheImage(const AssetImage('assets/logo.png'), context);
      await precacheImage(const AssetImage('assets/logo_dark.png'), context);
    });
    await settle(tester);

    await expectLater(
      find.byType(VpnApp),
      matchesGoldenFile('goldens/design_$name.png'),
    );
    await tester.pumpWidget(const SizedBox());
    core.dispose();
  }

  testWidgets('design wheel, dark, connected', (tester) async {
    await phone(tester, name: 'wheel_dark');
  });

  testWidgets('design wheel, dark, disconnected', (tester) async {
    await phone(tester, name: 'wheel_dark_off', connected: false);
  });

  testWidgets('design wheel, light, connected', (tester) async {
    await phone(tester, name: 'wheel_light', theme: ThemeMode.light);
  });

  testWidgets('design wheel, Persian, connected', (tester) async {
    await phone(tester, name: 'wheel_fa', language: 'fa');
  });

  testWidgets('design bento, dark, connected', (tester) async {
    await phone(tester, name: 'bento_dark', design: 'bento');
  });

  testWidgets('design bento, light, disconnected', (tester) async {
    await phone(
      tester,
      name: 'bento_light_off',
      design: 'bento',
      theme: ThemeMode.light,
      connected: false,
    );
  });

  testWidgets('design pixel, dark, connected', (tester) async {
    await phone(tester, name: 'pixel_dark', design: 'pixel');
  });

  testWidgets('design pixel, Persian, connected', (tester) async {
    await phone(tester, name: 'pixel_fa', design: 'pixel', language: 'fa');
  });

  testWidgets('design aurora, dark, connected', (tester) async {
    await phone(tester, name: 'aurora_dark', design: 'aurora');
  });

  testWidgets('design aurora, light, disconnected', (tester) async {
    await phone(
      tester,
      name: 'aurora_light_off',
      design: 'aurora',
      theme: ThemeMode.light,
      connected: false,
    );
  });

  testWidgets('design neon, dark, connected', (tester) async {
    await phone(tester, name: 'neon_dark', design: 'neon');
  });

  testWidgets('design neon, Persian, disconnected', (tester) async {
    await phone(
      tester,
      name: 'neon_fa_off',
      design: 'neon',
      language: 'fa',
      connected: false,
    );
  });

  testWidgets('design dusk, dark, connected', (tester) async {
    await phone(tester, name: 'dusk_dark', design: 'dusk');
  });

  testWidgets('design dusk, light, connected', (tester) async {
    await phone(tester, name: 'dusk_light', design: 'dusk', theme: ThemeMode.light);
  });

  testWidgets('design sage, dark, connected', (tester) async {
    await phone(tester, name: 'sage_dark', design: 'sage');
  });

  testWidgets('design sage, Persian, disconnected', (tester) async {
    await phone(
      tester,
      name: 'sage_fa_off',
      design: 'sage',
      language: 'fa',
      connected: false,
    );
  });
}
