import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

/// What the window's close button does.
enum CloseAction { ask, tray, quit }

/// How a new account signs in: with the email and password form or through
/// the in-app browser on supported platforms.
enum SignInMethod { api, browser }

/// The app's own preferences (language, theme, close button), kept in
/// `app-settings.json` in the data folder beside the core's files. The VPN
/// settings belong to the core.
class AppSettings extends ChangeNotifier {
  AppSettings({this.file});

  final File? file;

  /// A language code (`en`, `fa`, `zh`, `ru`), or empty for the system
  /// language.
  String language = '';
  ThemeMode themeMode = ThemeMode.system;
  CloseAction closeAction = CloseAction.ask;

  /// True until the user finished the welcome page.
  bool firstRun = false;

  /// Android's first-run routing suggestion, prepared before the welcome
  /// page opens. Empty means no region; null keeps desktop suggestions.
  /// This is derived locally for this run and is not saved as a preference.
  String? firstRunRegion;

  /// Shows the public IP (the address websites see). Off by default: the
  /// location is shown by its country either way.
  bool showPublicIp = false;

  /// How a new account signs in (the accounts page's row).
  SignInMethod signInMethod = SignInMethod.api;

  /// When the user closed the "account running out" notice; it stays away
  /// for a day after.
  DateTime? lowQuotaDismissedAt;

  /// The newer version whose notice the user closed; a later one shows.
  String dismissedUpdate = '';

  /// The newer version the phone's own notification already announced, so
  /// one release says itself once: the hourly look that finds the same
  /// release again says nothing.
  String updateNotifiedVersion = '';

  /// The last successful look for a newer version, and the newer version it
  /// found ("" for none) with its page, so the notice outlasts a restart.
  DateTime? updateCheckedAt;
  String updateVersion = '';
  String updateUrl = '';
  Map<String, Object?> updateDetails = const {};
  List<Map<String, Object?>> announcementCache = const [];
  Map<String, int> announcementSeen = const {};
  Map<String, int> announcementAcknowledged = const {};
  Future<void> _saveTail = Future.value();

  /// Starts the app in the tray when the user signs in to Windows; on
  /// unless the user turned it off.
  bool autostart = true;

  /// Connects by itself when started with the computer ([autostart]); off
  /// until the user turns it on. The core decides how (Daemon.AutoConnect).
  bool autoConnect = false;

  /// A short vibration when the connection goes on or off; on unless the
  /// user turned it off.
  bool hapticFeedback = true;

  /// The app's own sounds — the tap, the switches' two notes, the
  /// connection's rising and falling notes, the lock's ping — the ear's
  /// own confirmation for every section of the app; on unless the user
  /// turns them off.
  bool soundFeedback = true;

  /// Locks the app again after a while away: 0 never re-locks, 1 asks the
  /// password right away on return, 5 and 15 are whole minutes. Only when
  /// a lock stands at all (the accounts page's app password).
  int lockBackgroundMin = 0;

  /// The rate's unit: true shows bits (Mbps), false the familiar KB/s.
  bool rateBits = false;

  /// Keeps the phone's screen awake while the VPN is on; off unless the
  /// user turned it on.
  bool keepScreenOn = false;

  /// The home page's live traffic cards (up and down now); on unless the
  /// user turned them off.
  bool showTraffic = true;

  /// The home page's card when TUN mode refused a program's call or game
  /// (UDP); on unless the user turned it off.
  bool udpNotice = true;

  /// A newer version downloads by itself on a phone and the installer asks
  /// at once; on unless the user turned it off. Off, the About page and the
  /// home page's notice still offer it by hand.
  bool autoInstallApk = true;

  /// The accent the user picked for the app's lights (the connected state,
  /// the buttons, the sliders): one of [AppAccent.presets]' keys, 'custom'
  /// for [customAccent], or '' for the monochrome design.
  String accentKey = '';

  /// The user's own accent, as ARGB, when [accentKey] is 'custom' (the hex
  /// the accent sheet asks for; the full Custom color page is gone).
  int customAccent = 0xFF60A5FA;

  /// The home page's design: 'wheel' (the flags in their wheel), 'bento'
  /// (the tiles), 'pixel' (the compact card), 'ios' (the system's look)
  /// and 'gazette' (the paper). Whatever else lands in the file — the
  /// looks that left among them — reads as the wheel.
  String homeDesign = 'wheel';

  /// The countries the user pinned in the flag wheel: they lead the wheel
  /// (after the recommended places), and the launcher's long-press menu
  /// carries the first four as "connect here" shortcuts. Saved order.
  List<String> favoriteCountries = const [];

  /// The speed test's size: 'light' (a quick 5 MiB / 2 MiB pass),
  /// 'standard' (25 MiB / 8 MiB — the default) or 'full' (64 MiB / 32 MiB,
  /// for a patient line). Whatever else lands in the file reads as the
  /// standard.
  String speedTestSize = 'standard';

  /// The home map's look: one of [GlobeStyle]'s names ('silver',
  /// 'midnight', 'ocean', 'mono', 'aurora'). Whatever else lands in the
  /// file reads as the silver.
  String mapStyle = 'silver';

  /// The home map's kind: 'classic' (the flat map as it always was),
  /// 'globe' (the metal ball), 'flat' (the flat map's modern finish), or
  /// 'hud' (the radar plate — the deep water, the amber grid and the
  /// sweep). The classic carries the default: the map the home has
  /// always stood on. The night, the terrain and the satellite kinds the
  /// picker once offered land here on their nearest survivor when a
  /// settings file still names them.
  String mapKind = 'classic';

  /// The accounts' own display names (account id → name): the rename a
  /// user gives an account, read back wherever its name shows. The
  /// core's own name stays underneath.
  Map<String, String> accountNames = const {};

  /// The accounts' own profile art (account id → [AccountAvatar] key,
  /// 'g0'…'g9'): the look the user picked for the account's avatar.
  Map<String, String> accountAvatars = const {};

  /// The app password's salt and hash (a lock on the app itself, set on
  /// the accounts page): both empty when no password stands. The hash is
  /// SHA-256 over salt+password, 10 rounds repeated.
  String lockSalt = '';
  String lockHash = '';

  /// Whether this run has unlocked the app password already. Not saved:
  /// a fresh start asks again.
  bool lockUnlocked = false;

  /// Puts the map's own motion to rest — the globe's breath, the wheel's
  /// glow — while the connection stays up. Nothing the connection needs
  /// is touched; only the animation goes quiet, and the battery with it.
  bool batterySaver = false;

  /// Connects by itself when the app opens (the phone): the VPN comes up
  /// as the home page does, the way [autoConnect] does at boot. Off until
  /// the user turns it on.
  bool connectOnOpen = false;

  /// Puts the VPN back on by itself when the phone's connection drops
  /// without the user asking; off until the user turns it on.
  bool autoReconnect = false;

  /// Hangs up by itself when no traffic moved for [idleTimeoutMin] minutes
  /// while connected; off until the user turns it on.
  bool idleDisconnect = false;

  /// The idle wait, in whole minutes, before [idleDisconnect] hangs up.
  int idleTimeoutMin = 15;

  /// Ends the session by itself when its traffic reaches [dataLimitMb] MB;
  /// off until the user turns it on.
  bool dataLimit = false;

  /// The session's data limit, in whole megabytes, for [dataLimit].
  int dataLimitMb = 1024;

  /// The columns the Logs page's Connections tab hides (ConnectionsView):
  /// at first all but the time, the destination, the rule, and the
  /// protocol. Kept in this file.
  Set<String> hiddenConnectionColumns = {'inbound', 'traffic', 'duration'};

  /// The version whose What's New page was shown (or seen again): the page
  /// opens once per version, and About can show it again.
  String whatsNewSeen = '';

  /// The gaming profile: the home page shows the connection's live delay
  /// and quality at a glance, and the servers page's smart pick (the
  /// measured fastest) stands out. It promises nothing about ping — it
  /// only surfaces what the connection really measures.
  bool gamingProfile = false;

  /// The app's languages, in the order the language menus list them.
  /// 'zh' is Simplified and 'zh_Hant' Traditional Chinese.
  static const supportedLanguages = [
    'en',
    'fa',
    'zh',
    'zh_Hant',
    'ru',
    'tr',
    'ar',
    // The rest by their own names.
    'az',
    'id',
    'es',
    'fr',
    'hu',
    'pt',
    'vi',
    'bn',
  ];

  /// Languages written right to left.
  static const rtlLanguages = {'fa', 'ar'};

  /// The locale of a language code such as 'fa' or 'zh_Hant'.
  static Locale localeOf(String language) {
    final parts = language.split('_');
    return parts.length == 2
        ? Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1])
        : Locale(language);
  }

  /// The app language for the system's [locale]: Traditional Chinese for
  /// the Hant script or Taiwan, Hong Kong, and Macau; else the language
  /// when the app has it; else English.
  static String languageFor(Locale locale) {
    if (locale.languageCode == 'zh') {
      final traditional =
          locale.scriptCode == 'Hant' ||
          const {'TW', 'HK', 'MO'}.contains(locale.countryCode);
      return traditional ? 'zh_Hant' : 'zh';
    }
    return supportedLanguages.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';
  }

  /// The app language for the system's preferred [locales], in order: the
  /// first one the app has; else English (not Flutter's default, the first
  /// language it was built with).
  static String languageForList(List<Locale>? locales) {
    for (final locale in locales ?? const <Locale>[]) {
      if (locale.languageCode == 'zh' ||
          supportedLanguages.contains(locale.languageCode)) {
        return languageFor(locale);
      }
    }
    return 'en';
  }

  /// The core's routing regions (`routing.region`); empty is none.
  static const regions = ['ir', 'cn', 'ru', 'af', 'tr', 'id', 'br', ''];

  /// Prefer the current network country, then the SIM's country, then the
  /// system country. A known unsupported country means no regional bypass:
  /// an Iranian SIM roaming in another country must not imply Iran.
  static String regionForCountries(Iterable<String?> countries) {
    for (final value in countries) {
      final country = (value ?? '').trim().toLowerCase();
      if (!RegExp(r'^[a-z]{2}$').hasMatch(country)) continue;
      return regions.contains(country) ? country : '';
    }
    return '';
  }

  /// The home design a stored key asks for. The keys the app carries
  /// stand (the wheel, the bento, the pixel, the ios, and the gazette);
  /// anything else — the looks that left, or a value a newer
  /// or older build wrote — lands on the wheel: the app's own home,
  /// until the user picks one of the looks that stand. The two looks
  /// that retired (the aether's iOS look, the zed's bento look) walk
  /// their users to the design that wears the same structure: the aether
  /// to the ios, the zed to the bento.
  static String homeDesignFor(String? key) => switch (key) {
    'bento' => 'bento',
    'pixel' => 'pixel',
    'ios' => 'ios',
    'aether' => 'ios',
    'zed' => 'bento',
    'gazette' => 'gazette',
    _ => 'wheel',
  };

  Locale? get locale => language.isEmpty ? null : localeOf(language);

  /// The routing region most users of [language] want: Persian is Iran,
  /// Chinese China, Russian Russia; null when a language says nothing.
  static String? regionForLanguage(String language) => switch (language) {
    'fa' => 'ir',
    'zh' => 'cn',
    'ru' => 'ru',
    'id' => 'id',
    'tr' => 'tr',
    'pt' => 'br',
    _ => null,
  };

  /// The region to offer first: from [language], else from the system's
  /// country ([countryCode], such as IR), else none.
  static String suggestedRegion(String language, String? countryCode) {
    final byLanguage = regionForLanguage(language);
    if (byLanguage != null) return byLanguage;
    final country = (countryCode ?? '').toLowerCase();
    return regions.contains(country) ? country : '';
  }

  static Future<AppSettings> load(String dataDir) async {
    final s = AppSettings(
      file: File('$dataDir${Platform.pathSeparator}app-settings.json'),
    );
    try {
      final j = jsonDecode(await s.file!.readAsString());
      if (j is Map<String, Object?>) {
        if (j['language'] case final String l
            when supportedLanguages.contains(l)) {
          s.language = l;
        }
        s.themeMode =
            ThemeMode.values.asNameMap()[j['theme']] ?? ThemeMode.system;
        s.closeAction =
            CloseAction.values.asNameMap()[j['close']] ?? CloseAction.ask;
        s.firstRun = j['welcome_done'] != true;
        s.showPublicIp = j['show_public_ip'] == true;
        s.signInMethod =
            SignInMethod.values.asNameMap()[j['signin_method']] ??
            s.signInMethod;
        if (j['dismissed_update'] case final String v) s.dismissedUpdate = v;
        if (j['update_notified'] case final String v) {
          s.updateNotifiedVersion = v;
        }
        if (j['update_version'] case final String v) s.updateVersion = v;
        if (j['update_url'] case final String v) s.updateUrl = v;
        if (j['update_details'] case final Map<String, Object?> v) {
          s.updateDetails = v;
        }
        if (j['announcement_cache'] case final List<Object?> v) {
          s.announcementCache = v.whereType<Map<String, Object?>>().toList();
        }
        Map<String, int> history(Object? v) => v is Map<String, Object?>
            ? {
                for (final e in v.entries)
                  if (e.value is int) e.key: e.value! as int,
              }
            : {};
        s.announcementSeen = history(j['announcement_seen']);
        s.announcementAcknowledged = history(j['announcement_acknowledged']);
        s.updateCheckedAt = switch (j['update_checked_at']) {
          final String t => DateTime.tryParse(t),
          _ => null,
        };
        s.lowQuotaDismissedAt = switch (j['low_quota_dismissed_at']) {
          final String t => DateTime.tryParse(t),
          _ => null,
        };
        s.autostart = j['autostart'] != false;
        s.autoConnect = j['auto_connect'] == true;
        s.hapticFeedback = j['haptic_feedback'] != false;
        s.soundFeedback = j['sound_feedback'] != false;
        if (j['lock_background_min'] case final int v) {
          s.lockBackgroundMin = switch (v) { 1 || 5 || 15 => v, _ => 0 };
        }
        if (j['speed_test_size'] case final String v) {
          s.speedTestSize = switch (v) {
            'light' || 'full' => v,
            _ => 'standard',
          };
        }
        s.rateBits = j['rate_bits'] == true;
        s.keepScreenOn = j['keep_screen_on'] == true;
        s.showTraffic = j['show_traffic'] != false;
        s.udpNotice = j['udp_notice'] != false;
        s.autoInstallApk = j['auto_install_apk'] != false;
        if (j['accent'] case final String a) s.accentKey = a;
        if (j['custom_accent'] case final int v) s.customAccent = v;
        if (j['home_design'] case final String d) {
          s.homeDesign = homeDesignFor(d);
        }
        if (j['favorite_countries'] case final List<Object?> codes) {
          s.favoriteCountries = [
            for (final code in codes) if (code is String) code,
          ];
        }
        if (j['map_style'] case final String m) s.mapStyle = m;
        if (j['map_kind'] case final String m) s.mapKind = m;
        if (j['account_names'] case final Map<String, Object?> v) {
          s.accountNames = {
            for (final e in v.entries)
              if (e.value is String) e.key: e.value! as String,
          };
        }
        if (j['account_avatars'] case final Map<String, Object?> v) {
          s.accountAvatars = {
            for (final e in v.entries)
              if (e.value is String) e.key: e.value! as String,
          };
        }
        if (j['lock_salt'] case final String v) s.lockSalt = v;
        if (j['lock_hash'] case final String v) s.lockHash = v;
        s.batterySaver = j['battery_saver'] == true;
        s.connectOnOpen = j['connect_on_open'] == true;
        s.autoReconnect = j['auto_reconnect'] == true;
        s.idleDisconnect = j['idle_disconnect'] == true;
        if (j['idle_timeout_min'] case final int v when v > 0) {
          s.idleTimeoutMin = v.clamp(1, 240);
        }
        s.dataLimit = j['data_limit'] == true;
        if (j['data_limit_mb'] case final int v when v > 0) {
          s.dataLimitMb = v.clamp(16, 1024 * 1024);
        }
        if (j['hidden_connection_columns'] case final List<Object?> v) {
          s.hiddenConnectionColumns = {...v.whereType<String>()};
        }
        if (j['whats_new_seen'] case final String v) s.whatsNewSeen = v;
        s.gamingProfile = j['gaming_profile'] == true;
      }
    } on FileSystemException {
      // First run: defaults, and the welcome page.
      s.firstRun = true;
    } on FormatException {
      // A broken file: defaults, rewritten on the next change.
    }
    return s;
  }

  void update({
    String? language,
    ThemeMode? themeMode,
    CloseAction? closeAction,
    SignInMethod? signInMethod,
    bool? firstRun,
    bool? showPublicIp,
    DateTime? lowQuotaDismissedAt,
    String? dismissedUpdate,
    DateTime? updateCheckedAt,
    String? updateNotifiedVersion,
    String? updateVersion,
    String? updateUrl,
    Map<String, Object?>? updateDetails,
    List<Map<String, Object?>>? announcementCache,
    Map<String, int>? announcementSeen,
    Map<String, int>? announcementAcknowledged,
    bool? autostart,
    bool? autoConnect,
    bool? hapticFeedback,
    bool? soundFeedback,
    int? lockBackgroundMin,
    bool? rateBits,
    bool? keepScreenOn,
    bool? showTraffic,
    bool? udpNotice,
    bool? autoInstallApk,
    String? accentKey,
    int? customAccent,
    List<String>? favoriteCountries,
    String? homeDesign,
    String? speedTestSize,
    String? mapStyle,
    String? mapKind,
    Map<String, String>? accountNames,
    Map<String, String>? accountAvatars,
    String? lockSalt,
    String? lockHash,
    bool? batterySaver,
    bool? connectOnOpen,
    bool? autoReconnect,
    bool? idleDisconnect,
    int? idleTimeoutMin,
    bool? dataLimit,
    int? dataLimitMb,
    Set<String>? hiddenConnectionColumns,
    String? whatsNewSeen,
    bool? gamingProfile,
  }) {
    if (favoriteCountries != null) {
      this.favoriteCountries = List.of(favoriteCountries);
    }
    this.hiddenConnectionColumns =
        hiddenConnectionColumns ?? this.hiddenConnectionColumns;
    this.whatsNewSeen = whatsNewSeen ?? this.whatsNewSeen;
    this.gamingProfile = gamingProfile ?? this.gamingProfile;
    this.udpNotice = udpNotice ?? this.udpNotice;
    this.autostart = autostart ?? this.autostart;
    this.autoConnect = autoConnect ?? this.autoConnect;
    this.hapticFeedback = hapticFeedback ?? this.hapticFeedback;
    this.soundFeedback = soundFeedback ?? this.soundFeedback;
    this.lockBackgroundMin = lockBackgroundMin ?? this.lockBackgroundMin;
    this.rateBits = rateBits ?? this.rateBits;
    this.keepScreenOn = keepScreenOn ?? this.keepScreenOn;
    this.showTraffic = showTraffic ?? this.showTraffic;
    this.autoInstallApk = autoInstallApk ?? this.autoInstallApk;
    this.accentKey = accentKey ?? this.accentKey;
    this.customAccent = customAccent ?? this.customAccent;
    if (homeDesign != null) {
      this.homeDesign = homeDesignFor(homeDesign);
    }
    if (speedTestSize != null) {
      this.speedTestSize = switch (speedTestSize) {
        'light' || 'full' => speedTestSize,
        _ => 'standard',
      };
    }
    if (mapStyle != null) {
      this.mapStyle = switch (mapStyle) {
        'midnight' => 'midnight',
        'ocean' => 'ocean',
        'mono' => 'mono',
        'aurora' => 'aurora',
        'satellite' => 'satellite',
        _ => 'silver',
      };
    }
    if (mapKind != null) {
      this.mapKind = switch (mapKind) {
        'globe' => 'globe',
        // The satellite's earth was a kind once; the ball carries its
        // look closest now.
        'satellite' => 'globe',
        'flat' => 'flat',
        'hud' => 'hud',
        // The night's deep water and the terrain's atlas tint read
        // closest to the modern flat's finish.
        'night' || 'terrain' => 'flat',
        _ => 'classic',
      };
    }
    this.accountNames = accountNames ?? this.accountNames;
    this.accountAvatars = accountAvatars ?? this.accountAvatars;
    this.lockSalt = lockSalt ?? this.lockSalt;
    this.lockHash = lockHash ?? this.lockHash;
    this.batterySaver = batterySaver ?? this.batterySaver;
    this.connectOnOpen = connectOnOpen ?? this.connectOnOpen;
    this.autoReconnect = autoReconnect ?? this.autoReconnect;
    this.idleDisconnect = idleDisconnect ?? this.idleDisconnect;
    this.idleTimeoutMin = idleTimeoutMin ?? this.idleTimeoutMin;
    this.dataLimit = dataLimit ?? this.dataLimit;
    this.dataLimitMb = dataLimitMb ?? this.dataLimitMb;
    this.showPublicIp = showPublicIp ?? this.showPublicIp;
    this.lowQuotaDismissedAt = lowQuotaDismissedAt ?? this.lowQuotaDismissedAt;
    this.dismissedUpdate = dismissedUpdate ?? this.dismissedUpdate;
    this.updateNotifiedVersion =
        updateNotifiedVersion ?? this.updateNotifiedVersion;
    this.updateCheckedAt = updateCheckedAt ?? this.updateCheckedAt;
    this.updateVersion = updateVersion ?? this.updateVersion;
    this.updateUrl = updateUrl ?? this.updateUrl;
    this.updateDetails = updateDetails ?? this.updateDetails;
    this.announcementCache = announcementCache ?? this.announcementCache;
    this.announcementSeen = announcementSeen ?? this.announcementSeen;
    this.announcementAcknowledged =
        announcementAcknowledged ?? this.announcementAcknowledged;
    this.firstRun = firstRun ?? this.firstRun;
    this.language = language ?? this.language;
    this.themeMode = themeMode ?? this.themeMode;
    this.closeAction = closeAction ?? this.closeAction;
    this.signInMethod = signInMethod ?? this.signInMethod;
    notifyListeners();
    _saveTail = _saveTail.then((_) => _save());
  }

  Future<void> _save() async {
    final f = file;
    if (f == null) return;
    try {
      await f.parent.create(recursive: true);
      await f.writeAsString(
        const JsonEncoder.withIndent('  ').convert({
          'language': language,
          'theme': themeMode.name,
          'close': closeAction.name,
          'signin_method': signInMethod.name,
          'welcome_done': !firstRun,
          'show_public_ip': showPublicIp,
          'low_quota_dismissed_at': lowQuotaDismissedAt?.toIso8601String(),
          'dismissed_update': dismissedUpdate,
          'update_checked_at': updateCheckedAt?.toIso8601String(),
          'update_notified': updateNotifiedVersion,
          'update_version': updateVersion,
          'update_url': updateUrl,
          'update_details': updateDetails,
          'announcement_cache': announcementCache,
          'announcement_seen': announcementSeen,
          'announcement_acknowledged': announcementAcknowledged,
          'autostart': autostart,
          'auto_connect': autoConnect,
          'haptic_feedback': hapticFeedback,
          'sound_feedback': soundFeedback,
          'lock_background_min': lockBackgroundMin,
          'rate_bits': rateBits,
          'keep_screen_on': keepScreenOn,
          'show_traffic': showTraffic,
          'udp_notice': udpNotice,
          'auto_install_apk': autoInstallApk,
          'accent': accentKey,
          'custom_accent': customAccent,
          'home_design': homeDesign,
          'speed_test_size': speedTestSize,
          'favorite_countries': favoriteCountries,
          'map_style': mapStyle,
          'map_kind': mapKind,
          'account_names': accountNames,
          'account_avatars': accountAvatars,
          'lock_salt': lockSalt,
          'lock_hash': lockHash,
          'battery_saver': batterySaver,
          'connect_on_open': connectOnOpen,
          'auto_reconnect': autoReconnect,
          'idle_disconnect': idleDisconnect,
          'idle_timeout_min': idleTimeoutMin,
          'data_limit': dataLimit,
          'data_limit_mb': dataLimitMb,
          'hidden_connection_columns': hiddenConnectionColumns.toList(),
          'whats_new_seen': whatsNewSeen,
          'gaming_profile': gamingProfile,
        }),
      );
    } on FileSystemException {
      // Not fatal: the choice holds until the app quits.
    }
  }
}
