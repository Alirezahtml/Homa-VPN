import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_settings.dart';
import 'app_info.dart';
import 'core/android_core.dart';
import 'core/core_api.dart';
import 'core/core_controller.dart';
import 'core/updates.dart';
import 'core/core_process.dart';
import 'core/ports.dart';
import 'core/tun_service.dart';
import 'desktop/desktop_integration.dart';
import 'l10n/app_localizations.dart';
import 'ui/app.dart';
import 'ui/whats_new.dart';

/// The desktop app starts the core as its child process (`-app`) and stops
/// it on quit. Arguments: `--data-dir=<path>` (default: see
/// [CoreLocator.dataDir]) and `--core=<path>` (default:
/// [CoreProcess.executableFrom], `core\arman-vpn-core.exe` beside the app).
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) return runAndroid();
  final dataDir = CoreLocator.dataDir(args);
  final settings = await AppSettings.load(dataDir);
  final process = CoreProcess(
    executable: CoreProcess.executableFrom(args),
    dataDir: dataDir,
  );
  final core = CoreController(
    process.connect,
    appSettings: settings,
    moveStoppedCore: (port) async {
      final listen = await CoreLocator.dashboardListen(dataDir);
      await CoreLocator.setDashboardListen(dataDir, withPort(listen, port));
      process.retryNow();
    },
    retryStoppedCore: () async => process.retryNow(),
    // The TUN mode's service, beside the core.
    tunService: Platform.isWindows || Platform.isLinux || Platform.isMacOS
        ? TunService.besideCore(process.executable)
        : null,
  )..start();
  // Back in front: the core tries again at once, not after a wait.
  AppLifecycleListener(
    onResume: core.retryNow,
    onShow: () => core.onScreen = true,
    onHide: () => core.onScreen = false,
  );
  final navigatorKey = GlobalKey<NavigatorState>();
  // Before the desktop's: a version installed at the start goes first.
  Updates.start(core, settings, args: args);
  // A version just installed shows its What's New once, after the first
  // frame, so it lands on a drawn page instead of a blank one.
  if (whatsNewPending(settings)) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentState?.overlay?.context;
      if (context != null && context.mounted) {
        showWhatsNew(context, settings);
      }
    });
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopIntegration(
      core: core,
      settings: settings,
      process: process,
      navigatorKey: navigatorKey,
      // --hidden: a new version that its update started in the tray.
      startHidden: args.contains('--autostart') || args.contains('--hidden'),
      autostarted: args.contains('--autostart'),
      manageAutostart: !args.any((a) => a.startsWith('--data-dir=')),
    ).start();
  }
  runApp(VpnApp(core: core, settings: settings, navigatorKey: navigatorKey));
}

/// Android: the core runs in this app's process, in a foreground service
/// that keeps the proxy up while the UI is closed.
Future<void> runAndroid() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidCore.listenForHomeRequests();
  // Edge to edge: the home page's hero colors the status bar.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  final dataDir = await AndroidCore.dataDir();
  final settings = await AppSettings.load(dataDir);
  await AndroidCore.loadMode();
  // The connection safety switches live on the Android side (CoreService.kt);
  // the kill switch rides in with loadMode, the boot choice loads here.
  await AndroidCore.loadAutoConnectBoot();
  await AndroidCore.prepareFirstRunRouting(
    settings,
    systemCountry:
        WidgetsBinding.instance.platformDispatcher.locale.countryCode,
  );
  final core = CoreController(
    AndroidCore(dataDir).connect,
    turnOn: AndroidCore.setOn,
    appSettings: settings,
  )..start();
  final navigatorKey = GlobalKey<NavigatorState>();
  AppLifecycleListener(
    onResume: core.retryNow,
    onShow: () => core.onScreen = true,
    onHide: () => core.onScreen = false,
  );
  Updates.start(core, settings);
  // A newer version announces itself on the phone's own bell: one
  // notification per release (the settings keep the count), in the
  // language the app wears. The home page carries the notice too, but a
  // release that lands while the app is in the hand should say so at
  // once, not wait for the next look at the page.
  Updates.available.addListener(() {
    final release = Updates.available.value;
    if (release == null || !newerVersion(release.version, appVersion)) {
      return;
    }
    if (release.version == settings.updateNotifiedVersion) return;
    settings.update(updateNotifiedVersion: release.version);
    final l = lookupAppLocalizations(
      AppSettings.localeOf(
        AppSettings.languageFor(
          WidgetsBinding.instance.platformDispatcher.locale,
        ),
      ),
    );
    unawaited(
      AndroidCore.notifyUpdate(
        l.appTitle,
        release.mandatory
            ? l.updateRequired(release.version)
            : l.updateAvailable(release.version),
      ),
    );
  });
  // A version just installed shows its What's New once, after the first
  // frame, so it lands on a drawn home page instead of a blank one.
  if (whatsNewPending(settings)) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = navigatorKey.currentState?.overlay?.context;
      if (context != null && context.mounted) {
        showWhatsNew(context, settings);
      }
    });
  }
  runApp(VpnApp(core: core, settings: settings, navigatorKey: navigatorKey));
}
