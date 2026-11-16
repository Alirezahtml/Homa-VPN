// Renders the phone's home in both themes and both states, and the
// Persian one, as golden images — real pixels of the design, for a look
// that no assertion can give. Refresh with:
//   flutter test --update-goldens test/golden_home_test.dart
//
// Skipped on CI, whose Flutter renders text a shade differently from the
// build that drew the goldens; a golden run is a local affair.
@Skip(
  'Golden images depend on the exact Flutter build rendering the text; '
  'they are for a local look at the design (flutter test '
  '--update-goldens test/golden_home_test.dart), not for CI, which runs '
  'another Flutter version.',
)
library;

import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_controller.dart';
import 'package:arman_vpn/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'settle.dart' show quietAudio, settle;
import 'widget_test.dart' show FakeApi, stillMotion;

void main() {
  setUpAll(() async {
    Future<void> load(String family, List<String> files) async {
      final loader = FontLoader(family);
      for (final f in files) {
        loader.addFont(
          rootBundle.load('assets/fonts/$f'),
        );
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

    final api = FakeApi()
      ..systemProxySupported = false
      ..on = connected
      ..online = connected;
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings()
      ..themeMode = theme
      ..language = language;
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
      // The home's world is drawn, not an image: the globe's countries
      // come from assets/map/world.bin, which the map's own loader reads.
    });
    await settle(tester);

    await expectLater(
      find.byType(VpnApp),
      matchesGoldenFile('goldens/home_$name.png'),
    );
    await tester.pumpWidget(const SizedBox());
    core.dispose();
  }

  testWidgets('golden phone home, dark, connected', (tester) async {
    await phone(tester, name: 'dark_connected');
  });

  testWidgets('golden phone home, dark, disconnected', (tester) async {
    await phone(tester, name: 'dark_disconnected', connected: false);
  });

  testWidgets('golden phone home, light, connected', (tester) async {
    await phone(tester, name: 'light_connected', theme: ThemeMode.light);
  });

  testWidgets('golden phone home, light, disconnected', (tester) async {
    await phone(
      tester,
      name: 'light_disconnected',
      theme: ThemeMode.light,
      connected: false,
    );
  });

  testWidgets('golden phone home, Persian, connected', (tester) async {
    await phone(tester, name: 'fa_connected', language: 'fa');
  });

  testWidgets('golden phone settings, Persian', (tester) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(tester.view.reset);

    final core = CoreController(
      () async => FakeApi()
        ..systemProxySupported = false
        ..on = false,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings()
      ..themeMode = ThemeMode.dark
      ..language = 'fa';
    await tester.pumpWidget(VpnApp(core: core, settings: settings));
    core.start();
    await settle(tester);
    await tester.tap(find.text('تنظیمات').last);
    await settle(tester);
    await expectLater(
      find.byType(VpnApp),
      matchesGoldenFile('goldens/settings_fa.png'),
    );
    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });

  testWidgets('golden phone servers, dark', (tester) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    tester.view.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    addTearDown(tester.view.reset);

    final core = CoreController(
      () async => FakeApi()..systemProxySupported = false,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings()..themeMode = ThemeMode.dark;
    await tester.pumpWidget(VpnApp(core: core, settings: settings));
    core.start();
    await settle(tester);
    // The home's place card opens the server list.
    await tester.tap(find.byIcon(Icons.chevron_right_rounded).first);
    await settle(tester);
    await expectLater(
      find.byType(VpnApp),
      matchesGoldenFile('goldens/servers_dark.png'),
    );
    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });
}
