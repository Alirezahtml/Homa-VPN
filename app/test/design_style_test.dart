import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_controller.dart';
import 'package:arman_vpn/ui/app.dart';
import 'package:arman_vpn/ui/design_style.dart';

import 'settle.dart' show settle, quietAudio;
import 'widget_test.dart' show FakeApi, stillMotion;

void main() {
  // The structural side of the designs: what each reference design's
  // port carries — the aether's iOS shapes, the zed's expressive ones —
  // and what the monochrome keeps.
  test('the designs carry the references\' structures', () {
    final aetherDark = DesignStyle.resolve('aether', true);
    expect(aetherDark.nav, NavVariant.curvedNotch);
    expect(aetherDark.header, HeaderVariant.ios);
    expect(aetherDark.group, GroupVariant.iosTable);
    expect(aetherDark.iconBadge, true);
    expect(aetherDark.cardRadius, 16);
    expect(aetherDark.switchTrack, const Color(0xFF34C759));
    expect(aetherDark.connected, const Color(0xFF34C759));
    expect(aetherDark.navActive, const Color(0xFF007AFF));
    final aetherLight = DesignStyle.resolve('aether', false);
    // AetherST's own light nav: the porcelain with the system blue.
    expect(aetherLight.navBackground, const Color(0xFFF2F3F7));
    expect(aetherLight.navActive, const Color(0xFF0A6CFF));

    final zed = DesignStyle.resolve('zed', false);
    expect(zed.nav, NavVariant.floatingDock);
    expect(zed.header, HeaderVariant.zed);
    expect(zed.group, GroupVariant.bento);
    expect(zed.cardRadius, 26);
    expect(zed.dialogRadius, 28);
    expect(zed.connected, const Color(0xFF7A5CFF));

    // The gazette's print: the section bar, the section front, the
    // ruled paper box, the small dialog.
    final gazette = DesignStyle.resolve('gazette', false);
    expect(gazette.nav, NavVariant.gazetteRuled);
    expect(gazette.header, HeaderVariant.gazette);
    expect(gazette.group, GroupVariant.gazetteRules);
    expect(gazette.dialogRadius, 6);

    // Material You: the M3 bar, the large title, the filled tonal card.
    final pixel = DesignStyle.resolve('pixel', true);
    expect(pixel.nav, NavVariant.m3Bar);
    expect(pixel.header, HeaderVariant.m3);
    expect(pixel.group, GroupVariant.m3Card);
    expect(pixel.cardRadius, 28);
    expect(pixel.dialogRadius, 28);

    // The system's own: the tab bar, the compact bold bar, the grouped
    // table, the rounded alert, the green switch.
    final ios = DesignStyle.resolve('ios', true);
    expect(ios.nav, NavVariant.cupertinoBar);
    expect(ios.header, HeaderVariant.ios);
    expect(ios.group, GroupVariant.iosTable);
    expect(ios.dialogRadius, 14);
    expect(ios.switchTrack, const Color(0xFF30D158));
    expect(ios.navActive, const Color(0xFF0A84FF));

    // The box's own: the tile dock, the squircle header, the tinted
    // very-round card, the tangerine's light.
    final bento = DesignStyle.resolve('bento', true);
    expect(bento.nav, NavVariant.bentoDock);
    expect(bento.header, HeaderVariant.bento);
    expect(bento.group, GroupVariant.bentoBoard);
    expect(bento.fx, FxMood.pop);
    expect(bento.cardRadius, 24);
    expect(bento.dialogRadius, 24);
    expect(bento.connected, const Color(0xFF57CC8D));
    expect(bento.navActive, const Color(0xFFFF8B5E));
    final bentoLight = DesignStyle.resolve('bento', false);
    expect(bentoLight.navActive, const Color(0xFFE05D2A));
    expect(bentoLight.scroll, ScrollMood.springy);

    // The monochrome keeps the shapes it always had, and the looks that
    // left land on its structure as they land on its palette.
    for (final key in ['mono', 'wheel', 'aurora', 'whatever-else']) {
      final style = DesignStyle.resolve(key, true);
      expect(style.nav, NavVariant.glassPill, reason: key);
      expect(style.cardRadius, 24, reason: key);
    }
  });

  testWidgets('the aether wears the curved notch bar', (tester) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final api = FakeApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings()..update(homeDesign: 'aether');
    await tester.pumpWidget(VpnApp(core: core, settings: settings));
    core.start();
    await settle(tester);
    expect(find.byType(AetherCurvedNav), findsOneWidget);
    expect(find.byType(ZedDockNav), findsNothing);
    // The nav rides with its two names.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });

  testWidgets('the zed wears the floating dock and the FABs', (tester) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final api = FakeApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings()..update(homeDesign: 'zed');
    await tester.pumpWidget(VpnApp(core: core, settings: settings));
    core.start();
    await settle(tester);
    expect(find.byType(ZedDockNav), findsOneWidget);
    expect(find.byType(AetherCurvedNav), findsNothing);
    // The draggable tool cluster rides the home (ZedSecure's FABs).
    expect(find.byType(ZedFabCluster), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });

  testWidgets('the monochrome keeps its own glass pill', (tester) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final api = FakeApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    final settings = AppSettings();
    await tester.pumpWidget(VpnApp(core: core, settings: settings));
    core.start();
    await settle(tester);
    expect(find.byType(AetherCurvedNav), findsNothing);
    expect(find.byType(ZedDockNav), findsNothing);
    expect(find.byType(ZedFabCluster), findsNothing);

    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });
}
