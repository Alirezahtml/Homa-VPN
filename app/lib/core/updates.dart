import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../app_info.dart';
import '../app_settings.dart';
import 'android_core.dart';
import 'announcements.dart';
import 'core_api.dart';
import 'core_controller.dart';
import 'models.dart';

/// The release's APKs, one per processor type (scripts/build-android.ps1,
/// .github/workflows/build.yml); others get the universal one.
const _apkAbis = {'arm64-v8a', 'armeabi-v7a', 'x86_64'};

/// Where an Android update stands. The phone's core does not update itself,
/// so the app downloads the release's APK on its own and hands it to the
/// system's installer, which asks the user; Android's rule to install
/// packages may need a permission first (the "unknown apps" page).
enum ApkState {
  /// Nothing found, or the check said this version is the newest.
  idle,

  /// The package is coming; [Updates.apkProgress] says how far.
  downloading,

  /// The package is complete; the installer can ask.
  ready,

  /// The installer's permission is missing; the notice offers its page.
  permission,

  /// The download or the hand to the installer failed; the notice offers
  /// another try.
  failed,
}

/// Where the Download button goes: the release's file for this copy of the
/// app, which the browser downloads at once (no page to choose from): on a
/// phone the APK for its processor; on Windows the installer for an
/// installed copy (its uninstaller is beside it) and the zip for a portable
/// one; on macOS the disk image; on Linux the archive for the processor.
Future<String> downloadUrl(
  Release release, {
  String? os,
  String? abi,
  bool? installed,
  String? platformVersion,
}) async {
  final system = os ?? Platform.operatingSystem;
  if (release.downloads.isNotEmpty) {
    final String key;
    switch (system) {
      case 'android':
        final cpu = abi ?? await AndroidCore.abi().catchError((Object _) => '');
        key = release.downloads.containsKey(cpu) ? cpu : 'universal';
      case 'windows':
        final dir = File(Platform.resolvedExecutable).parent.path;
        final setup =
            installed ??
            File('$dir${Platform.pathSeparator}unins000.exe').existsSync();
        key = setup ? 'installer-x64' : 'archive-x64';
      case 'macos':
        key = 'installer';
      default:
        key = archiveKey(system, platformVersion ?? Platform.version);
    }
    final asset = release.downloads[key];
    if (asset == null) {
      throw const FormatException('No download for this system');
    }
    return asset.url;
  }
  if (!release.url.contains('/releases/tag/')) return release.url;
  final String name;
  if (Platform.isAndroid) {
    final abi = await AndroidCore.abi().catchError((Object _) => '');
    name = apkName(abi);
  } else if (Platform.isWindows) {
    final dir = File(Platform.resolvedExecutable).parent.path;
    final installed = File('$dir${Platform.pathSeparator}unins000.exe');
    name = windowsName(installed: installed.existsSync());
  } else if (Platform.isMacOS) {
    name = 'macOS.dmg';
  } else if (Platform.isLinux) {
    name = linuxName(Platform.version);
  } else {
    return release.url;
  }
  return releaseFileUrl(release.url, name);
}

/// The APK's name part for processor [abi].
String apkName(String abi) =>
    'Android-${_apkAbis.contains(abi) ? abi : 'universal'}.apk';

/// The Windows file's name part: the installer, or the portable zip.
String windowsName({required bool installed}) =>
    installed ? 'Windows-Setup-x64.exe' : 'Windows-x64.zip';

/// The file `Homa-VPN-<version>-[name]` in the release whose page is
/// [releaseUrl] (".../releases/tag/v1.2.3"): its versioned name, so the
/// downloaded file says which version it is.
String releaseFileUrl(String releaseUrl, String name) {
  final tag = releaseUrl.substring(releaseUrl.lastIndexOf('/') + 1);
  final version = tag.replaceFirst(RegExp('^[vV]'), '');
  return '${releaseUrl.replaceFirst('/releases/tag/', '/releases/download/')}'
      '/Homa-VPN-$version-$name';
}

/// The APK for processor [abi] in the release whose page is [releaseUrl].
String apkUrl(String releaseUrl, String abi) =>
    releaseFileUrl(releaseUrl, apkName(abi));

/// The local proxy for GitHub requests, on networks that block GitHub: the
/// VPN's own while it runs without a proxy login; null otherwise.
String? updateProxy(CoreStatus? status) {
  final proxy = status?.proxy;
  if (status?.state.phase != Phase.running || proxy == null) return null;
  if (proxy.loginRequired) return null;
  return CoreLocator.listenUri(proxy.listen).authority;
}

/// Looks for a newer release on GitHub daily: the app looks a minute
/// after it starts, and then every hour, whether a day has passed since
/// the last look that worked. What it finds is kept in the settings, so the
/// home page shows it after a restart too; the computer also shows a
/// notification while the window is in the tray. The About page looks at
/// once, whenever asked. Android's daily check uses stable, while
/// About asks for latest without delaying its next daily check.
///
/// The desktop apps (Windows, Linux, macOS) install it themselves (their
/// core: core/internal/update): Update downloads it through the VPN while it
/// runs, and the app closes and opens again as the new version. With
/// automatic updates (on unless turned off), a version found downloads in
/// the background and installs the next time the app starts. When the core
/// cannot install it, and on Android, whose core does not update, the notice
/// opens the download.
abstract final class Updates {
  /// How long a successful look holds.
  static const every = Duration(days: 1);

  /// The newer release, once one was found.
  static final available = ValueNotifier<Release?>(null);
  static final announcements = ValueNotifier<AnnouncementStore?>(null);

  /// The Android update's own state, progress, and why it failed; the
  /// notice on the home page and the About page read them.
  static final apkState = ValueNotifier<ApkState>(ApkState.idle);
  static final apkProgress = ValueNotifier<double?>(null);
  static final apkError = ValueNotifier<String>('');

  /// The app installs a downloaded version at its start (automatic
  /// updates) and quits in a moment, so it does not connect first.
  static final installingAtStart = ValueNotifier<bool>(false);

  /// Why the app's last request to install failed, when the core could not
  /// say it in its status.
  static final failure = ValueNotifier<String?>(null);

  /// The notice of what the last update did was closed.
  static final resultSeen = ValueNotifier<bool>(false);

  /// Quits the app (the desktop's Quit), once an install has started.
  static Future<void> Function()? quitApp;

  /// Whether the window is in the tray: the new version starts there too.
  static bool Function() windowHidden = () => false;

  static Timer? _first;
  static Timer? _timer;
  static CoreController? _core;
  static AppSettings? _settings;

  /// The app's arguments that its next start keeps (core/internal/update
  /// AppArgs, and a copy's own --data-dir).
  static List<String> _startArgs = const [];

  /// The version the user asked to install: it installs once downloaded.
  static String? _wanted;

  /// Whether the first status since the start was looked at.
  static bool _started = false;

  /// The versions automatic updates asked to download in this run, so a
  /// failed one waits for the next start.
  static final _downloadsAsked = <String>{};

  /// The Android update's package on the phone, once downloaded.
  static String? _apkFile;

  /// The Android version this run already took up, so a status tick or a
  /// found release does not start it twice.
  static String? _apkAsked;

  /// Whether the package that just arrived installs by itself (the
  /// automatic way) or waits for the user's tap.
  static bool _apkAutoInstall = false;

  /// Starts looking. [args] are the app's own (`--autostart`, `--hidden`,
  /// `--data-dir=`), which a new version installed at the start keeps; an
  /// install from the Update button keeps `--data-dir=`.
  static void start(
    CoreController core,
    AppSettings settings, {
    List<String> args = const [],
  }) {
    if (githubRepo.isEmpty || _timer != null) return;
    _core = core;
    _settings = settings;
    announcements.value = AnnouncementStore(settings, version: appVersion);
    _startArgs = [
      for (final a in args)
        if (a == '--autostart' ||
            a == '--hidden' ||
            a.startsWith('--data-dir='))
          a,
    ];
    // A version found earlier, unless this app is already that one.
    if (newerVersion(settings.updateVersion, appVersion)) {
      available.value = settings.updateDetails.isEmpty
          ? Release(settings.updateVersion, settings.updateUrl)
          : releaseFromJson(settings.updateDetails);
    }
    // The folder keeps only what a download needs. Any package present
    // at the start is a leftover of an update already handed to the
    // installer — the new version is running now, the old one is gone,
    // and the package would only sit on the storage. It goes.
    unawaited(_cleanupApks());
    core.addListener(_onStatus);
    _first = Timer(const Duration(minutes: 1), _due);
    _timer = Timer.periodic(const Duration(hours: 1), (_) => _due());
  }

  /// Forgets everything, for the next test.
  @visibleForTesting
  static void reset() {
    _first?.cancel();
    _timer?.cancel();
    _core?.removeListener(_onStatus);
    _first = _timer = _core = _settings = _wanted = null;
    _started = false;
    _startArgs = const [];
    _downloadsAsked.clear();
    available.value = null;
    announcements.value?.dispose();
    announcements.value = null;
    installingAtStart.value = false;
    failure.value = null;
    resultSeen.value = false;
    apkState.value = ApkState.idle;
    apkProgress.value = null;
    apkError.value = '';
    _apkFile = _apkAsked = null;
    _apkAutoInstall = false;
    quitApp = null;
    windowHidden = () => false;
  }

  /// Follows the core's update: a version downloaded before installs at
  /// the start (automatic updates), the one the user asked for once it is
  /// downloaded, and a version found downloads by itself.
  static void _onStatus() {
    final core = _core, settings = _settings;
    final update = core?.status?.update;
    if (core == null || settings == null) return;
    if (Platform.isAndroid) {
      // The phone's core says nothing about updates; the app's own
      // download starts with the first status, so the package is there
      // (or on its way) however this run began.
      _downloadApkInBackground();
      return;
    }
    if (update == null) return;
    if (!_started) {
      _started = true;
      // Not right after an update that failed (the old version started
      // again): the next start tries again, so a lasting failure is no loop.
      final justFailed = update.last != null && !update.last!.ok;
      if (update.ready &&
          !justFailed &&
          newerVersion(update.version, appVersion)) {
        installingAtStart.value = true;
        unawaited(
          _install(update.version, _startArgs).then((ok) {
            if (!ok) installingAtStart.value = false;
          }),
        );
        return;
      }
    }
    final wanted = _wanted;
    if (wanted != null && update.version == wanted) {
      if (update.ready) {
        _wanted = null;
        unawaited(_installReady(update));
        return;
      }
      if (update.failed) _wanted = null;
    }
    _downloadInBackground();
  }

  /// With automatic updates, downloads the version found (once per run).
  static void _downloadInBackground() {
    if (Platform.isAndroid) {
      _downloadApkInBackground();
      return;
    }
    final core = _core, settings = _settings;
    final release = available.value;
    final update = core?.status?.update;
    if (core == null || settings == null || release == null || update == null) {
      return;
    }
    if (!newerVersion(release.version, appVersion)) {
      return;
    }
    if (update.downloading || update.installing) return;
    if (update.ready && update.version == release.version) return;
    if (!_downloadsAsked.add(release.version)) return;
    final Map<String, Object?>? source;
    try {
      source = release.installSource();
    } on FormatException catch (e) {
      failure.value = '$e';
      return;
    }
    unawaited(
      core.downloadUpdate(release.version, source: source).catchError((
        Object _,
      ) {
        // The core's status says why.
      }),
    );
  }

  /// The Update button: downloads [release] when needed, then installs it;
  /// the app closes and opens again as the new version. On Android the
  /// system's installer asks instead of the app restarting itself.
  static Future<void> update(Release release) async {
    if (Platform.isAndroid) {
      apkError.value = '';
      _apkAutoInstall = false;
      await installApkUpdate();
      return;
    }
    final core = _core;
    if (core == null) return;
    failure.value = null;
    final current = core.status?.update;
    if (current != null &&
        current.ready &&
        current.version == release.version) {
      await _installReady(current);
      return;
    }
    _wanted = release.version;
    try {
      await core.downloadUpdate(
        release.version,
        source: release.installSource(),
      );
    } on Exception catch (e) {
      _wanted = null;
      failure.value = '$e';
    }
  }

  /// Installs the downloaded [update] by the core, the app closing and
  /// opening again.
  static Future<bool> _installReady(UpdateState update) =>
      _install(update.version, _restartArgs());

  /// The arguments of the next start after an install now: in the tray if
  /// the window is there, and with this copy's own data folder.
  static List<String> _restartArgs() => [
    if (windowHidden()) '--hidden',
    for (final a in _startArgs)
      if (a.startsWith('--data-dir=')) a,
  ];

  /// Asks the core to install [version], then quits the app; false when the
  /// core refused (the reason in [failure] or the core's status).
  static Future<bool> _install(String version, List<String> args) async {
    final core = _core;
    if (core == null) return false;
    try {
      await core.installUpdate(version, pid, args);
    } on Exception catch (e) {
      failure.value = '$e';
      return false;
    }
    await quitApp?.call();
    return true;
  }

  static Future<void> _due() async {
    final last = _settings?.updateCheckedAt;
    if (last != null && DateTime.now().difference(last) < every) return;
    try {
      found(
        await checkForUpdate(
          proxy: updateProxy(_core?.status),
          onAnnouncements: receiveAnnouncements,
        ),
      );
    } on Exception {
      // No network, or GitHub not reachable: the next hour tries again.
    }
  }

  /// The result of a look that worked, here or on the About page: a newer
  /// [release], or null when this version is the newest.
  static void found(
    Release? release, {
    UpdateCheck check = UpdateCheck.automatic,
    String? os,
  }) {
    final android = (os ?? Platform.operatingSystem) == 'android';
    final previous = available.value;
    // The next scheduled check can recommend an older release than one
    // already found manually. Keep the newer download across restarts.
    if (android &&
        check == UpdateCheck.automatic &&
        previous != null &&
        newerVersion(previous.version, appVersion) &&
        (release == null || newerVersion(previous.version, release.version))) {
      release = release?.mandatory == true && !previous.mandatory
          ? releaseFromJson({...previous.toJson(), 'mandatory': true})
          : previous;
    }
    available.value = release;
    _settings?.update(
      updateCheckedAt: android && check == UpdateCheck.manual
          ? null
          : DateTime.now(),
      updateVersion: release?.version ?? '',
      updateUrl: release?.url ?? '',
      updateDetails: release?.toJson() ?? const {},
    );
    _downloadInBackground();
  }

  static void receiveAnnouncements(List<Announcement> items) =>
      announcements.value?.receive(items);

  /// Android's automatic update, once per run: a package already complete
  /// goes to the installer again; otherwise the version found downloads.
  /// Off by the setting, nothing starts by itself — the notice's own
  /// buttons still work.
  static void _downloadApkInBackground() {
    final settings = _settings;
    final release = available.value;
    if (settings == null || release == null) return;
    if (!newerVersion(release.version, appVersion)) return;
    if (_apkAsked == release.version) return;
    _apkAsked = release.version;
    if (!settings.autoInstallApk) return;
    unawaited(_resumeApk(release));
  }

  /// Takes an Android update up this run: a complete package installs,
  /// otherwise it downloads, installing when that was automatic.
  static Future<void> _resumeApk(Release release) async {
    final existing = await _apkFileFor(release.version);
    if (existing != null && existing.existsSync()) {
      _apkFile = existing.path;
      apkState.value = ApkState.ready;
      await installApkUpdate(auto: true);
      return;
    }
    _apkAutoInstall = true;
    await _downloadApk(release);
  }

  /// Where a version's package lands: the app's own update folder (the
  /// channel answers it; the installer reads it there), named by version,
  /// so a newer package never collides with an older one.
  static Future<File?> _apkFileFor(String version) async {
    final dir = await AndroidCore.updateDir().catchError((Object _) => '');
    if (dir.isEmpty) return null;
    return File(
      '$dir${Platform.pathSeparator}Homa-VPN-$version.apk',
    );
  }

  /// Every package left in the update folder goes: an install replaces
  /// the app (Android's own replace of the same package), and a package
  /// left over from it — or from a failed or interrupted one — is only
  /// storage. A download running this very moment is left alone.
  static Future<void> _cleanupApks() async {
    final dir = await AndroidCore.updateDir().catchError((Object _) => '');
    if (dir.isEmpty) return;
    try {
      await for (final item in Directory(dir).list()) {
        if (item is! File || !item.path.endsWith('.apk')) continue;
        try {
          await item.delete();
        } on FileSystemException {
          // Another copy is installing it right now; it goes next start.
        }
      }
    } on FileSystemException {
      // No folder yet, or nothing readable in it: nothing to clean.
    }
  }

  /// Downloads [release]'s APK (this phone's processor, else the universal
  /// one) through the VPN's own proxy when it runs — GitHub is blocked on
  /// some networks. The folder keeps only the newest package.
  static Future<void> _downloadApk(Release release) async {
    File? file;
    try {
      apkState.value = ApkState.downloading;
      apkProgress.value = null;
      apkError.value = '';
      file = await _apkFileFor(release.version);
      if (file == null) {
        throw const HttpException('no folder for the update package');
      }
      await file.parent.create(recursive: true);
      // The last package goes, so an abandoned download never fills the
      // phone: only this version's name stays.
      await for (final old in file.parent.list()) {
        if (old is File &&
            old.path.endsWith('.apk') &&
            old.path != file.path) {
          try {
            await old.delete();
          } on FileSystemException {
            // Another copy is installing it right now; it goes next time.
          }
        }
      }
      final url = await downloadUrl(release);
      final proxy = updateProxy(_core?.status);
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 20)
        ..findProxy = (_) =>
            proxy == null ? 'DIRECT' : 'PROXY $proxy; DIRECT';
      try {
        final req = await client
            .getUrl(Uri.parse(url))
            .timeout(const Duration(seconds: 20));
        req.headers.set(HttpHeaders.userAgentHeader, 'arman-vpn/$appVersion');
        final res = await req.close().timeout(const Duration(seconds: 30));
        if (res.statusCode != 200) {
          throw HttpException('HTTP ${res.statusCode}');
        }
        final total = res.contentLength;
        var done = 0;
        final sink = file.openWrite();
        try {
          await for (final chunk in res.timeout(
            const Duration(seconds: 60),
          )) {
            sink.add(chunk);
            done += chunk.length;
            if (total > 0) {
              apkProgress.value = (done / total).clamp(0.0, 1.0);
            }
          }
          await sink.flush();
        } finally {
          await sink.close();
        }
      } finally {
        client.close(force: true);
      }
      apkProgress.value = 1;
      _apkFile = file.path;
      apkState.value = ApkState.ready;
      if (_apkAutoInstall) {
        _apkAutoInstall = false;
        await installApkUpdate(auto: true);
      }
    } on Exception catch (e) {
      apkState.value = ApkState.failed;
      apkProgress.value = null;
      apkError.value = '$e';
      // A partial package is not a package; the next try starts clean.
      try {
        await file?.delete();
      } on FileSystemException {
        // Already gone.
      }
      _apkFile = null;
    }
  }

  /// Hands the downloaded package to the system's installer, which asks
  /// the user; without the package (or after a failure) it downloads
  /// first. Without the "install unknown apps" permission it goes to
  /// [apkState] = permission: the notice offers Android's own page for it,
  /// and a tap there returns to this. False when no installer answered (a
  /// TV without one): the notice falls back to the download in a browser.
  static Future<bool> installApkUpdate({bool auto = false}) async {
    var path = _apkFile;
    if (path == null || !File(path).existsSync()) {
      final release = available.value;
      if (release == null) return false;
      _apkAutoInstall = auto;
      unawaited(_downloadApk(release));
      return true;
    }
    if (!await AndroidCore.canInstallPackages()) {
      apkState.value = ApkState.permission;
      if (!auto) {
        await AndroidCore.openInstallPermissionSettings();
      }
      return true;
    }
    try {
      if (await AndroidCore.installApk(path)) return true;
    } on Exception catch (e) {
      apkError.value = '$e';
    }
    apkState.value = ApkState.failed;
    return false;
  }
}
