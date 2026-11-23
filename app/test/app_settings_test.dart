import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_process.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('app_settings_'));

  test(
    'announcement history and cache survive rapid successive saves',
    () async {
      final settings = AppSettings(file: File('${dir.path}/app-settings.json'));
      settings.update(
        announcementCache: [
          {'id': 'sample', 'enabled': true},
        ],
      );
      settings.update(announcementSeen: {'sample': 1});
      settings.update(announcementAcknowledged: {'sample': 1});
      final deadline = DateTime.now().add(const Duration(seconds: 3));
      AppSettings saved;
      do {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        saved = await AppSettings.load(dir.path);
      } while (saved.announcementAcknowledged.isEmpty &&
          DateTime.now().isBefore(deadline));
      expect(saved.announcementCache.single['id'], 'sample');
      expect(saved.announcementSeen, {'sample': 1});
      expect(saved.announcementAcknowledged, {'sample': 1});
    },
  );
  tearDown(() => dir.deleteSync(recursive: true));

  test('defaults without a file', () async {
    final s = await AppSettings.load(dir.path);
    expect(s.language, '');
    expect(s.locale, isNull);
    expect(s.themeMode, ThemeMode.system);
    expect(s.closeAction, CloseAction.ask);
    expect(s.signInMethod, SignInMethod.api);
    expect(s.firstRun, isTrue);
    // Starting with Windows is on until the user turns it off.
    expect(s.autostart, isTrue);
    // Connecting by itself is the user's choice.
    expect(s.autoConnect, isFalse);
  });

  test('saves and loads the choices', () async {
    final s = await AppSettings.load(dir.path);
    s.update(
      language: 'fa',
      themeMode: ThemeMode.dark,
      closeAction: CloseAction.tray,
      signInMethod: SignInMethod.browser,
      firstRun: false,
      autostart: false,
      autoConnect: true,
    );
    // update saves in the background.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final again = await AppSettings.load(dir.path);
    expect(again.locale, const Locale('fa'));
    expect(again.themeMode, ThemeMode.dark);
    expect(again.closeAction, CloseAction.tray);
    expect(again.signInMethod, SignInMethod.browser);
    expect(again.firstRun, isFalse);
    expect(again.autostart, isFalse);
    expect(again.autoConnect, isTrue);
  });

  test('maps languages to routing regions', () {
    expect(AppSettings.regionForLanguage('fa'), 'ir');
    expect(AppSettings.regionForLanguage('zh'), 'cn');
    expect(AppSettings.regionForLanguage('ru'), 'ru');
    expect(AppSettings.regionForLanguage('en'), isNull);
    expect(AppSettings.suggestedRegion('en', 'TR'), 'tr');
    expect(AppSettings.suggestedRegion('en', 'US'), '');
    expect(AppSettings.suggestedRegion('fa', 'DE'), 'ir');
  });

  test('country detection covers every supported routing region', () {
    for (final region in AppSettings.regions.where(
      (region) => region.isNotEmpty,
    )) {
      expect(AppSettings.regionForCountries([region.toUpperCase()]), region);
      expect(AppSettings.regionForCountries(['', ' $region ']), region);
    }
    expect(AppSettings.regionForCountries([null, '', 'IR']), 'ir');
    expect(AppSettings.regionForCountries(['invalid', 'TR', 'IR']), 'tr');
    expect(AppSettings.regionForCountries(['US', 'IR', 'IR']), '');
    expect(AppSettings.regionForCountries(['DE', 'CN']), '');
    expect(AppSettings.regionForCountries([null, '', '']), '');
  });

  test('ignores unknown values', () async {
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"language": "xx", "theme": "neon", "close": 7}');
    final s = await AppSettings.load(dir.path);
    expect(s.language, '');
    expect(s.themeMode, ThemeMode.system);
    expect(s.closeAction, CloseAction.ask);
    expect(s.signInMethod, SignInMethod.api);
  });

  test('the sounds switch survives a restart', () async {
    // The switch ships on; the user turns it off; the next load keeps
    // it off; turning it back on keeps everything else standing. The
    // save rides a queued tail, so each step waits for the file.
    Future<AppSettings> loadWith(bool value) async {
      final deadline = DateTime.now().add(const Duration(seconds: 3));
      var s = await AppSettings.load(dir.path);
      while (s.soundFeedback != value && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        s = await AppSettings.load(dir.path);
      }
      return s;
    }

    final s = await AppSettings.load(dir.path);
    expect(s.soundFeedback, true);
    s.update(soundFeedback: false);
    final off = await loadWith(false);
    expect(off.soundFeedback, false);
    off.update(soundFeedback: true);
    final on = await loadWith(true);
    expect(on.soundFeedback, true);
  });

  test('the designs that left land their holders on the wheel', () async {
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"home_design": "aurora"}');
    var s = await AppSettings.load(dir.path);
    expect(s.homeDesign, 'wheel');
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"home_design": "sage"}');
    s = await AppSettings.load(dir.path);
    expect(s.homeDesign, 'wheel');
    // The looks that left walk their users to the design that wears
    // their structure: the aether to the ios, the zed to the bento.
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"home_design": "aether"}');
    s = await AppSettings.load(dir.path);
    expect(s.homeDesign, 'ios');
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"home_design": "zed"}');
    s = await AppSettings.load(dir.path);
    expect(s.homeDesign, 'bento');
  });

  test('the two new looks stand on their own keys', () async {
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"home_design": "sky"}');
    var s = await AppSettings.load(dir.path);
    expect(s.homeDesign, 'sky');
    File('${dir.path}/app-settings.json')
        .writeAsStringSync('{"home_design": "ocean"}');
    s = await AppSettings.load(dir.path);
    expect(s.homeDesign, 'ocean');
  });


  test('takes the core executable from --core', () {
    expect(
      CoreProcess.executableFrom(['--core=C:/bin/core.exe']),
      'C:/bin/core.exe',
    );
    expect(
      CoreProcess.executableFrom(const []),
      endsWith(
        Platform.isWindows ? r'core\arman-vpn-core.exe' : 'core/arman-vpn-core',
      ),
    );
  });
}
