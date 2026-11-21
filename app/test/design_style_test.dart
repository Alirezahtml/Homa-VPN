import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_controller.dart';
import 'package:arman_vpn/ui/app.dart';
import 'package:arman_vpn/ui/design_style.dart';

import 'settle.dart' show settle, quietAudio;
import 'widget_test.dart' show FakeApi, stillMotion;

void main() {
  // The structural side of the designs: what each design's port
  // carries — and what the monochrome keeps. The two looks that left
  // (the aether, the zed) walk their users to the designs that wear
  // their structure: the aether's tables on the ios, the zed's bento on
  // the bento; the style resolve itself lands them on the monochrome.
  test('the designs carry their own structures', () {
    expect(AppSettings.homeDesignFor('aether'), 'ios');
    expect(AppSettings.homeDesignFor('zed'), 'bento');
    expect(DesignStyle.resolve('aether', true).nav, NavVariant.glassPill);
    expect(DesignStyle.resolve('zed', false).nav, NavVariant.glassPill);

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

  testWidgets('the ios wears the system\'s tab bar', (tester) async {
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
    final settings = AppSettings()..update(homeDesign: 'ios');
    await tester.pumpWidget(VpnApp(core: core, settings: settings));
    core.start();
    await settle(tester);
    expect(find.byType(CupertinoBarNav), findsOneWidget);
    // The nav rides with its two names.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsWidgets);

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

    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });
}
