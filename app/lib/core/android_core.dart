import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

import '../app_settings.dart';
import 'core_api.dart';
import 'ports.dart';
import 'speed_test.dart';
import 'remote_flags.dart' show bundledFlags, RemoteFlags;

/// An app installed on the phone.
@immutable
class InstalledApp {
  const InstalledApp(this.package, this.label, {this.launcher = true});

  final String package;
  final String label;

  /// It has a launcher icon; the others are mostly the system's.
  final bool launcher;
}

/// Which apps use the VPN (CoreService.kt), in v2rayN's words: bypass the
/// selected apps ([bypass]), or proxy only the selected apps ([only]).
class AppRouting {
  AppRouting({
    required this.onlyChosen,
    required this.bypass,
    required this.only,
    required this.suggested,
    Set<String>? declined,
  }) : declined = declined ?? {};

  /// Proxy selected apps; otherwise bypass them.
  bool onlyChosen;

  /// Bypass selected apps: these connect directly.
  final Set<String> bypass;

  /// Proxy selected apps: only these use the VPN.
  final Set<String> only;

  /// The routing region's apps (from the core), suggested for bypassing:
  /// the installed ones are checked by themselves (CoreService.suggest),
  /// unless the user unchecked them ([declined]).
  final Set<String> suggested;

  /// The suggested apps the user unchecked: never checked again by
  /// themselves, only by the user or "Suggested apps".
  final Set<String> declined;

  Set<String> get _chosen => onlyChosen ? only : bypass;

  /// Whether [package] is checked in the current mode.
  bool checked(String package) => _chosen.contains(package);

  void toggle(String package, bool on) {
    on ? _chosen.add(package) : _chosen.remove(package);
    if (!onlyChosen && suggested.contains(package)) {
      on ? declined.remove(package) : declined.add(package);
    }
  }

  /// Checks the suggested apps that are installed, also those unchecked
  /// before; returns how many were not checked yet.
  int checkSuggested(Iterable<String> installed) {
    final mine = installed.where(suggested.contains).toSet();
    declined.removeAll(mine);
    final add = mine..removeAll(bypass);
    bypass.addAll(add);
    return add.length;
  }

  /// A key that changes with the choice, to know whether to apply it.
  String get key => [
    onlyChosen,
    ...[bypass, only].map((s) => (s.toList()..sort()).join(',')),
  ].join('|');
}

/// The user did not allow the app to set up a VPN.
class VpnNotAllowed implements Exception {
  const VpnNotAllowed();
}

/// The core on Android: it runs in this app's process. It starts with the
/// proxy off while the UI is open, so settings and accounts work; turned
/// on, a foreground service (android/.../CoreService.kt) keeps it running
/// for other apps while the UI is closed. The UI talks to it through the
/// same HTTP API.
class AndroidCore {
  static const _channel = MethodChannel('app/android');

  /// A Quick Settings long-press returns the existing UI to Home.
  static final homeRequests = ValueNotifier<int>(0);

  static void listenForHomeRequests() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openHome') homeRequests.value++;
      if (call.method == 'openShortcut') {
        shortcutRequests.value = (call.arguments as Map<Object?, Object?>?)?['country'] as String? ?? '';
      }
    });
  }

  /// A launcher shortcut's country, as the phone's home screen long-press
  /// menu sent it (MainActivity). The home page listens and connects.
  static final shortcutRequests = ValueNotifier<String>('');

  /// The core's data folder inside the app's private storage.
  static Future<String> dataDir() async =>
      await _channel.invokeMethod<String>('dataDir') ?? '';

  /// Only a new installation asks Android for country codes. It does not
  /// read persistent identifiers, change the language, or modify saved routing.
  static Future<void> prepareFirstRunRouting(
    AppSettings settings, {
    String? systemCountry,
  }) async {
    if (!settings.firstRun) return;
    Map<String, String>? countries;
    try {
      countries = await _channel
          .invokeMapMethod<String, String>('routingCountries')
          .timeout(const Duration(seconds: 2));
    } on Exception {
      // No telephony, an unavailable platform service, or a failed call:
      // the system country still supplies a language-independent fallback.
    }
    settings.firstRunRegion = AppSettings.regionForCountries([
      countries?['network_country'],
      countries?['sim_country'],
      systemCountry,
    ]);
  }

  AndroidCore(this._dataDir);

  final String _dataDir;

  /// Dashboard moves this app has made in this run, and when the last one
  /// was: a move takes effect only after the core's own restart pause (5
  /// seconds), so one move waits for it before it decides it did not help.
  int _moves = 0;
  DateTime? _movedAt;
  static const _maxMoves = 3;

  /// Opens a client of the core, starting the core (off) when it does not
  /// run; it throws [CoreUnavailable] until the core answers.
  Future<CoreApi> connect() async {
    if (await _channel.invokeMethod<bool>('isRunning') != true) {
      await _channel.invokeMethod<void>('startCore');
      // The core failed to start (mobile.Mobile.start said why): the error
      // page shows the reason and a Retry, instead of a spinner that would
      // never end.
      final lastError = await _channel.invokeMethod<String>('lastError') ?? '';
      if (lastError.isNotEmpty) {
        // Another program holds the dashboard's address (every client of
        // this family listens on the same default port, and an older one
        // left running keeps it): move this app's dashboard to a free
        // loopback port and let the polls start the core again. Retry
        // alone could never help while the address stays taken.
        if (lastError.contains('already in use') && _moves < _maxMoves) {
          await _freeTheDashboard();
          throw const CoreUnavailable(CoreProblem.starting);
        }
        throw CoreUnavailable(CoreProblem.exited, lastError);
      }
      throw const CoreUnavailable(CoreProblem.starting);
    }
    // A move did its job: the next conflict may move again.
    _moves = 0;
    _movedAt = null;
    try {
      final api = CoreApi(await CoreLocator.locate(_dataDir));
      try {
        await api.status();
        return api;
      } on Exception {
        api.close();
        rethrow;
      }
    } on CoreUnavailable {
      // Started, and its API is still coming up.
      throw const CoreUnavailable(CoreProblem.starting);
    }
  }

  /// Moves the dashboard to a free loopback port in the core's config.json
  /// (the core is not there to ask). It moves at most once per run of the
  /// core's restart pause, so the polls' quick retries do not walk the
  /// whole port range before the core even tried the last address.
  Future<void> _freeTheDashboard() async {
    final now = DateTime.now();
    if (_movedAt != null &&
        now.difference(_movedAt!) < const Duration(seconds: 6)) {
      return;
    }
    final listen = await CoreLocator.dashboardListen(_dataDir);
    final port = await findFreePort(portOf(listen) ?? 10820);
    await CoreLocator.setDashboardListen(_dataDir, withPort(listen, port));
    _movedAt = now;
    _moves++;
  }

  /// Turns the VPN on (asking the user for the VPN permission the first
  /// time) or off. It throws [VpnNotAllowed] when the user refuses.
  static Future<void> setOn(bool on) async {
    try {
      await _channel.invokeMethod<void>('setOn', {'on': on});
    } on PlatformException catch (e) {
      if (e.code == 'vpn_denied') throw const VpnNotAllowed();
      throw CoreApiException(0, e.message ?? e.code);
    }
  }

  /// The connection mode: 'vpn' (every app on the phone) or 'proxy' (only
  /// apps set up to use the local proxy). Read at start ([loadMode]).
  static final mode = ValueNotifier<String>('vpn');

  static Future<void> loadMode() async {
    mode.value = await _channel.invokeMethod<String>('connectionMode') ?? 'vpn';
    showSpeed.value = await _channel.invokeMethod<bool>('showSpeed') ?? false;
    notifFlag.value = await _channel.invokeMethod<bool>('notifFlag') ?? true;
    killSwitch.value = await _channel.invokeMethod<bool>('killSwitch') ?? false;
    isTv = await _channel.invokeMethod<bool>('isTv') ?? false;
  }

  /// Whether this is a TV, worked with a remote: the home page then says
  /// "press" rather than "tap". Read at start ([loadMode]).
  static bool isTv = false;

  /// This process's Java crashes (CrashLog.kt), oldest first; "" while
  /// there are none. The logs page shows them, so a crash report can
  /// name its line — the core's own log does not carry these.
  static Future<String> crashLog() async =>
      await _channel.invokeMethod<String>('crashLog') ?? '';

  /// Whether the notification shows the speed (CoreService.kt reads it).
  static final showSpeed = ValueNotifier<bool>(false);

  static Future<void> setShowSpeed(bool on) async {
    await _channel.invokeMethod<void>('setShowSpeed', {'on': on});
    showSpeed.value = on;
  }

  /// Whether the notification shows the country's flag (CoreService.kt
  /// reads it): on, the country's own SVG flag as the card's art — or the
  /// emoji until the art arrives; off, the country's name alone.
  static final notifFlag = ValueNotifier<bool>(true);

  static Future<void> setNotifFlag(bool on) async {
    await _channel.invokeMethod<void>('setNotifFlag', {'on': on});
    notifFlag.value = on;
  }

  /// Opens the phone's share sheet with a plain-text report (the
  /// diagnostics dialog's answer to "send this to the developer").
  static Future<bool> shareText(String text, String title) async =>
      await _channel.invokeMethod<bool>('shareText', {
        'text': text,
        'title': title,
      }) ??
      false;

  /// Whether Android already stands this app outside battery optimization.
  static Future<bool> batteryIgnored() async =>
      await _channel.invokeMethod<bool>('batteryIgnored') ?? false;

  /// Android's own dialog asking to leave the app out of battery
  /// optimization (its REQUEST_IGNORE_BATTERY_OPTIMIZATIONS permission).
  static Future<bool> requestIgnoreBattery() async =>
      await _channel.invokeMethod<bool>('requestIgnoreBattery') ?? false;

  /// The system's battery-optimization list, where the OEMs' own killers
  /// (Xiaomi, Samsung, Huawei) keep their rules.
  static Future<bool> openBatterySettings() async =>
      await _channel.invokeMethod<bool>('openBatterySettings') ?? false;

  /// Per-app data usage of the last [days] days, the system's own
  /// accounting. The answer's [UsageApps.granted] is false until the user
  /// grants Usage access.
  static Future<UsageApps> usageApps(int days) async {
    final j = await _channel.invokeMethod<Object?>('usageApps', {
      'days': days,
    });
    if (j is Map<Object?, Object?>) {
      return UsageApps.fromJson(Map<String, Object?>.from(j));
    }
    return UsageApps.fromJson(const {});
  }

  /// The system's Usage access page, where the user grants per-app usage.
  static Future<bool> openUsageAccess() async =>
      await _channel.invokeMethod<bool>('openUsageAccess') ?? false;

  /// Publishes [favorites] (country codes) as the launcher's long-press
  /// shortcuts, newest first.
  static Future<void> setShortcuts(List<String> favorites) async {
    await _channel.invokeMethod<void>('setShortcuts', {
      'shortcuts': [
        for (final code in favorites) {'code': code, 'name': code},
      ],
    });
  }

  /// The country whose flag art the service holds; '' for none yet. The
  /// last one is kept so the core's every status change does not render
  /// and send it again.
  static String _lastFlagCode = '';

  /// Renders [code]'s SVG flag (the app's own asset) as a rounded PNG and
  /// hands it to the service for its notification — it keeps the file, so
  /// its headless refreshes carry the art without the UI's help. Called
  /// whenever the exit country (or the chosen one, while connecting)
  /// changes; a code with no bundled SVG sends nothing, and the
  /// notification falls back to the emoji by itself.
  static Future<void> syncNotifFlag(String code) async {
    final lc = code.trim().toLowerCase();
    if (lc.length != 2 || lc == _lastFlagCode) return;
    _lastFlagCode = lc;
    Uint8List? svg;
    try {
      if (bundledFlags.contains(lc)) {
        svg = (await rootBundle.load('assets/flags/$lc.svg'))
            .buffer
            .asUint8List();
      } else {
        // A location Mozilla added later: the core keeps its flag, asked
        // once per run (RemoteFlags), so the notification's art follows
        // the real server list, not the bundle's snapshot of it.
        svg = await RemoteFlags.load(lc);
      }
    } on Exception {
      // The engine was torn down, or the channel had no listener: the
      // notification keeps the emoji — nothing here is worth a crash.
      _lastFlagCode = '';
      return;
    }
    if (svg == null || svg.isEmpty) {
      // Not carried and not fetched yet: the next status change asks again
      // (RemoteFlags caches its own ask, so this stays cheap).
      _lastFlagCode = '';
      return;
    }
    try {
      final png = await _flagPng(svg);
      if (png == null) return;
      await _channel.invokeMethod<void>('setFlagBitmap', {
        'code': lc,
        'bytes': png,
      });
    } on Exception {
      // The engine was torn down, or the channel had no listener: the
      // notification keeps the emoji — nothing here is worth a crash.
      _lastFlagCode = '';
    }
  }

  /// One flag as a rounded PNG: the SVG's picture drawn onto a canvas of
  /// [w] by [h], clipped to the corners the cards carry, so the
  /// notification's own art matches the wheel's own look.
  static Future<Uint8List?> _flagPng(
    Uint8List svg, {
    int w = 176,
    int h = 132,
  }) async {
    final info = await vg.loadPicture(SvgBytesLoader(svg), null);
    try {
      if (info.size.isEmpty || info.size.width <= 0 || info.size.height <= 0) {
        return null;
      }
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      canvas.clipRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
          const ui.Radius.circular(30),
        ),
      );
      final s = math.min(w / info.size.width, h / info.size.height);
      canvas.translate(
        (w - info.size.width * s) / 2,
        (h - info.size.height * s) / 2,
      );
      canvas.scale(s);
      canvas.drawPicture(info.picture);
      final image = await recorder.endRecording().toImage(w, h);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data?.buffer.asUint8List();
    } finally {
      info.picture.dispose();
    }
  }

  /// The kill switch: a broken path keeps the VPN up — the traffic is
  /// held, nothing leaks — while the app puts the path back (the flag
  /// lives on the Android side, in CoreService.kt).
  static final killSwitch = ValueNotifier<bool>(false);

  static Future<void> setKillSwitch(bool on) async {
    await _channel.invokeMethod<void>('setKillSwitch', {'on': on});
    killSwitch.value = on;
  }

  /// Connects when the phone starts (the BootReceiver; the flag lives on
  /// the Android side, in CoreService.kt).
  static final autoConnectBoot = ValueNotifier<bool>(false);

  static Future<void> loadAutoConnectBoot() async {
    autoConnectBoot.value =
        await _channel.invokeMethod<bool>('autoConnectBoot') ?? false;
  }

  static Future<void> setAutoConnectBoot(bool on) async {
    await _channel.invokeMethod<void>('setAutoConnectBoot', {'on': on});
    autoConnectBoot.value = on;
  }

  /// The network's own MTU under the app right now, as the tunnel's
  /// smart sizing computes it (CoreService.kt): the very number the VPN
  /// interface would take — the network's own, plus room for the
  /// tunnel's headers, when the network cannot carry a whole datagram
  /// at the batching size. The batching size's own answer (8500) means
  /// "the network is not the limit".
  static Future<int> smartMtu() async =>
      await _channel.invokeMethod<int>('smartMtu') ?? 0;

  /// The system's VPN page: Android's own "always-on" and its "block
  /// connections without VPN", the strongest guard there is.
  static Future<void> openVpnSettings() async {
    await _channel.invokeMethod<void>('openVpnSettings');
  }

  /// Keeps the phone's screen awake (the window's keep-screen-on flag)
  /// while the VPN is on; the setting's effect (MainActivity.kt).
  static Future<void> setKeepScreenOn(bool on) async {
    try {
      await _channel.invokeMethod<void>('setKeepScreenOn', {'on': on});
    } on PlatformException {
      // A TV or an odd window: the flag is a wish, not a promise.
    }
  }

  /// Keeps the mode; a running proxy switches at once. Switching to the
  /// VPN the first time turns it off and on again, so Android asks for the
  /// VPN permission; it throws [VpnNotAllowed] when the user refuses.
  static Future<void> setMode(String value) async {
    try {
      await _channel.invokeMethod<void>('setConnectionMode', {'mode': value});
      mode.value = value;
    } on PlatformException catch (e) {
      if (e.code != 'vpn_denied') rethrow;
      await setOn(false);
      await _channel.invokeMethod<void>('setConnectionMode', {'mode': value});
      mode.value = value;
      await setOn(true);
    }
  }

  /// Sends this app's WebViews through the proxy at [address]
  /// ("127.0.0.1:port"), or straight out again when it is null. Reports
  /// false when this phone's WebView cannot take a proxy; the views then
  /// connect by themselves.
  static Future<bool> setWebViewProxy(String? address) async =>
      await _channel.invokeMethod<bool>('setWebViewProxy', {
        'address': address,
      }) ??
      false;

  /// Saves [bytes] as a file where the user picks, with the system's
  /// dialog; the file's name, or null when the user backed out.
  static Future<String?> saveFile(
    String name,
    Uint8List bytes, {
    String mime = 'application/zip',
  }) => _channel.invokeMethod<String>('saveFile', {
    'name': name,
    'bytes': bytes,
    'mime': mime,
  });

  /// The bytes of a file the user picks with the system's dialog, or null
  /// when the user backed out. Read to the end: a provider's reported size
  /// can be wrong.
  static Future<Uint8List?> openFile({
    List<String> mimes = const ['application/zip', 'application/octet-stream'],
  }) => _channel.invokeMethod<Uint8List>('openFile', {'mimes': mimes});

  /// The phone's own notification, from the app's side: a newer version
  /// is out. The title and body come in the app's own language; the
  /// system posts what it may — a permission the user kept closed stays
  /// closed, and the notice waits on the home page as always.
  static Future<void> notifyUpdate(String title, String body) =>
      _channel.invokeMethod<void>('notifyUpdate', {
        'title': title,
        'body': body,
      });

  /// The installed apps but this one, the system's too.
  static Future<List<InstalledApp>> installedApps() async {
    final list = await _channel.invokeListMethod<Map<Object?, Object?>>(
      'installedApps',
    );
    return [
      for (final m in list ?? const <Map<Object?, Object?>>[])
        InstalledApp(
          '${m['package']}',
          '${m['label']}',
          launcher: m['launcher'] != false,
        ),
    ];
  }

  /// An app's icon as PNG.
  static Future<Uint8List?> appIcon(String package) =>
      _channel.invokeMethod<Uint8List>('appIcon', {'package': package});

  /// Which apps use the VPN.
  static Future<AppRouting> appRouting() async {
    final m =
        await _channel.invokeMapMethod<String, Object?>('appRouting') ??
        const {};
    Set<String> set(String key) => {
      for (final p in (m[key] as List<Object?>? ?? const [])) '$p',
    };
    return AppRouting(
      onlyChosen: m['mode'] == 'include',
      bypass: set('bypass'),
      only: set('only'),
      suggested: set('region'),
      declined: set('declined'),
    );
  }

  /// Keeps which apps use the VPN; [apply] sets a running VPN up again.
  static Future<void> setAppRouting(AppRouting r, {required bool apply}) =>
      _channel.invokeMethod<void>('setAppRouting', {
        'mode': r.onlyChosen ? 'include' : 'exclude',
        'bypass': r.bypass.toList(),
        'only': r.only.toList(),
        'declined': r.declined.toList(),
        'apply': apply,
      });

  /// The phone's main processor type, such as arm64-v8a.
  static Future<String> abi() async =>
      await _channel.invokeMethod<String>('abi') ?? '';

  /// A folder of this app's own for the downloaded update package: on the
  /// shared storage when there is one (the installer reads it there), else
  /// inside the app's private files. Empty when Android answers nothing.
  static Future<String> updateDir() async =>
      await _channel.invokeMethod<String>('updateDir') ?? '';

  /// Whether this app may install packages (Android 8 asks once, in its
  /// settings); always true before it.
  static Future<bool> canInstallPackages() async =>
      await _channel.invokeMethod<bool>('canInstallPackages') ?? false;

  /// Android's own page for that permission.
  static Future<void> openInstallPermissionSettings() =>
      _channel.invokeMethod<void>('openInstallPermissionSettings');

  /// Hands [path] (an APK inside [updateDir]) to the system's installer,
  /// which asks the user. False when no installer answered (a TV without
  /// one): the notice falls back to the download.
  static Future<bool> installApk(String path) async =>
      await _channel.invokeMethod<bool>('installApk', {'path': path}) ?? false;

  /// Opens [url] in the app that handles it (such as a tg:// link).
  static Future<bool> openUrl(String url) async =>
      await _channel.invokeMethod<bool>('openUrl', {'url': url}) ?? false;
}
