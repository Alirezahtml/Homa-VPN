import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_controller.dart';
import 'package:arman_vpn/l10n/app_localizations.dart';
import 'package:arman_vpn/ui/app.dart';
import 'package:arman_vpn/ui/design.dart';
import 'package:arman_vpn/ui/settings_page.dart';

import 'settle.dart' show settle, quietAudio;
import 'widget_test.dart' show FakeApi, stillMotion;

void main() {
  // The design picker: five real designs, and the two reference ones
  // each carry a whole palette the whole app wears.
  testWidgets('the design picker offers five designs', (tester) async {
    stillMotion(tester);
    quietAudio(tester);
    tester.view.physicalSize = const Size(400, 1500);
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

    await tester.tap(find.text('Settings'));
    await settle(tester);
    // The settings open as the groups' list; the General group's row
    // opens the section's page, where the home design's row lives.
    await tester.tap(find.text('General').last);
    await settle(tester);
    final row = find.text('Home design');
    await tester.ensureVisible(row);
    await settle(tester);
    await tester.tap(row);
    await settle(tester);

    for (final name in ['Aether', 'Zed']) {
      final card = find.text(name);
      await tester.ensureVisible(card);
      await settle(tester);
      expect(card, findsOneWidget, reason: name);
    }

    // A tap on the zed's card: the home design follows, and the whole
    // app's look with it — the resolved design is the zed's palette.
    final zed = find.text('Zed');
    await tester.ensureVisible(zed);
    await settle(tester);
    await tester.tap(zed);
    await settle(tester);
    // The choice went in, past the settings' own list of known designs.
    expect(settings.homeDesign, 'zed');
    expect(AppDesign.resolve(settings.homeDesign).key, 'zed');
    expect(AppDesign.resolve('aether').key, 'aether');
    // The four looks that left land on the monochrome again.
    expect(AppDesign.resolve('aurora').key, 'mono');
    expect(AppDesign.resolve('neon').key, 'mono');
    expect(AppDesign.resolve('dusk').key, 'mono');
    expect(AppDesign.resolve('sage').key, 'mono');
    // The three older homes keep the monochrome.
    expect(AppDesign.resolve('wheel').key, 'mono');
    expect(AppDesign.resolve('bento').key, 'mono');
    expect(AppDesign.resolve('pixel').key, 'mono');
    expect(AppDesign.resolve('whatever-else').key, 'mono');

    // The design's own light stands in when no accent is picked.
    expect(AppDesign.resolveFor(settings, true), isNotNull);

    // The design name the settings row reads back.
    settings.update(homeDesign: 'aether');
    await settle(tester);
    final l = AppLocalizations.of(tester.element(find.text('Language')));
    expect(designName(l, settings), 'Aether');

    await tester.pumpWidget(const SizedBox());
    core.dispose();
  });
}
