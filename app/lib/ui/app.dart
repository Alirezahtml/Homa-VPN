import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_api.dart';
import '../core/core_controller.dart';
import '../core/models.dart';
import '../l10n/app_localizations.dart';
import 'about_page.dart';
import 'accent.dart';
import 'announcement_panel.dart';
import 'accounts_page.dart';
import 'app_lock.dart';
import 'design.dart';
import 'focus_ring.dart';
import 'format.dart';
import 'logs_page.dart';
import 'mobile_shell.dart';
import 'overview_page.dart';
import 'port_dialog.dart';
import 'servers_page.dart';
import 'settings_page.dart';
import 'sound.dart' show AppSounds, SoundCue, SoundRoutes;
import 'welcome_page.dart';
import 'widgets.dart';

ThemeData _theme(Brightness brightness, Locale locale, Color? accent) {
  final dark = brightness == Brightness.dark;
  // The app's one design (the monochrome): the surfaces, the ink and the
  // outlines come from it — the exact colors this theme always had.
  final look = AppDesign.current.look(dark);
  // The monochrome scheme: pure black and white with neutral grays
  // between — no hue anywhere, in either mode. A chosen accent takes the
  // scheme's lights (buttons, toggles, progress) only; the surfaces and
  // the ink stay monochrome, and the containers keep their neutral gray.
  final scheme = dark
      ? ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
          tertiary: Colors.white,
          onTertiary: Colors.black,
          primaryContainer: const Color(0xFF2A2A2A),
          onPrimaryContainer: Colors.white,
          secondaryContainer: const Color(0xFF1E1E1E),
          onSecondaryContainer: Colors.white,
          tertiaryContainer: const Color(0xFF1E1E1E),
          onTertiaryContainer: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          onSurfaceVariant: Color(0xFF9E9E9E),
          outline: const Color(0xFF3A3A3A),
          outlineVariant: Color(0xFF262626),
          inverseSurface: Colors.white,
          onInverseSurface: Colors.black,
          inversePrimary: const Color(0xFF0A0A0A),
          surfaceTint: Colors.transparent,
          surfaceContainerHighest: Color(0xFF161616),
          surfaceContainerHigh: Color(0xFF1A1A1A),
          surfaceContainer: Color(0xFF111111),
          surfaceContainerLow: Color(0xFF0C0C0C),
          surfaceContainerLowest: Colors.black,
        )
      : ColorScheme.light(
          primary: const Color(0xFF0A0A0A),
          onPrimary: Colors.white,
          secondary: const Color(0xFF0A0A0A),
          onSecondary: Colors.white,
          tertiary: const Color(0xFF0A0A0A),
          onTertiary: Colors.white,
          primaryContainer: const Color(0xFFE8E8E8),
          onPrimaryContainer: const Color(0xFF0A0A0A),
          secondaryContainer: const Color(0xFFF0F0F0),
          onSecondaryContainer: const Color(0xFF0A0A0A),
          tertiaryContainer: const Color(0xFFF0F0F0),
          onTertiaryContainer: const Color(0xFF0A0A0A),
          surface: Colors.white,
          onSurface: const Color(0xFF0A0A0A),
          onSurfaceVariant: const Color(0xFF6B6B6B),
          outline: const Color(0xFFC9C9C9),
          outlineVariant: Color(0xFFE4E4E4),
          inverseSurface: const Color(0xFF0A0A0A),
          onInverseSurface: Colors.white,
          inversePrimary: Colors.white,
          surfaceTint: Colors.transparent,
          surfaceContainerHighest: Color(0xFFEFEFEF),
          surfaceContainerHigh: Color(0xFFF2F2F2),
          surfaceContainer: Color(0xFFF6F6F6),
          surfaceContainerLow: Color(0xFFF9F9F9),
          surfaceContainerLowest: Colors.white,
        );
  // Every language reads in its own bundled face — Inter's Latin,
  // Cyrillic and Greek for most of them, Vazirmatn for the Persian and
  // the Arabic, Noto Sans SC and TC for the two Chinese, Noto Sans
  // Bengali for Bengali — and falls back through the app's other faces
  // before the phone's.
  final font = languageFont(AppSettings.languageFor(locale));
  final fallbacks = fontFallbacks(font);
  // The display's own voice: the titles, the state word and the stat
  // values wear the face that says "this app" — Space Grotesk for the
  // Latin languages, the language's own face for the rest.
  final display = displayFont(AppSettings.languageFor(locale));
  final displayFallback = displayFallbacks(display);
  final lit = accent == null ? null : accentForTheme(accent, dark);
  final effective = lit == null
      ? scheme
      : scheme.copyWith(
          primary: lit,
          onPrimary: AppAccent.onAccent(lit),
          secondary: lit,
          onSecondary: AppAccent.onAccent(lit),
          tertiary: lit,
          onTertiary: AppAccent.onAccent(lit),
          inversePrimary: dark ? AppAccent.onAccent(lit) : lit,
        );
  final theme = ThemeData(
    colorScheme: effective,
    fontFamily: font,
    fontFamilyFallback: fallbacks,
    extensions: [
      HomaTypefaces(display: display, displayFallback: displayFallback),
    ],
    scaffoldBackgroundColor: look.scaffold,
    // Pixel-grade surfaces: one generous radius for every card, list and
    // dialog, so the whole app reads as one system.
    cardTheme: CardThemeData(
      elevation: 0,
      color: look.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: effective.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: look.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: look.scaffold,
      foregroundColor: effective.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: effective.onSurface,
        fontFamily: display,
        fontFamilyFallback: displayFallback,
      ),
    ),
    listTileTheme: ListTileThemeData(iconColor: effective.onSurfaceVariant),
    dividerTheme: DividerThemeData(
      thickness: 1,
      color: effective.outlineVariant.withValues(alpha: 0.5),
    ),
    // Pages arrive with a soft fade and a lift, everywhere.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _HomaTransitionsBuilder(),
        TargetPlatform.windows: _HomaTransitionsBuilder(),
        TargetPlatform.linux: _HomaTransitionsBuilder(),
        TargetPlatform.macOS: _HomaTransitionsBuilder(),
      },
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
  return theme.copyWith(
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: dark ? look.scaffoldBottom : look.scaffoldBottom,
      // NavigationRail replaces DefaultTextStyle, so retain the resolved
      // platform font instead of letting a null family choose a fallback.
      selectedLabelTextStyle: theme.textTheme.labelLarge!.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: effective.onSurface,
      ),
      unselectedLabelTextStyle: theme.textTheme.labelLarge!.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        color: effective.onSurfaceVariant,
      ),
      selectedIconTheme: IconThemeData(
        size: 24,
        color: effective.onSecondaryContainer,
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
        color: effective.onSurfaceVariant,
      ),
    ),
  );
}

/// Pages arrive with a soft fade and a lift, on every platform.
class _HomaTransitionsBuilder extends PageTransitionsBuilder {
  const _HomaTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeIn,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class VpnApp extends StatelessWidget {
  const VpnApp({
    super.key,
    required this.core,
    required this.settings,
    this.navigatorKey,
  });

  final CoreController core;
  final AppSettings settings;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: settings,
    builder: (context, _) => MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, _) =>
          AppSettings.localeOf(AppSettings.languageForList(locales)),
      // Every page's arrival and leaving carries its soft tap.
      navigatorObservers: [SoundRoutes()],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // The theme depends on the resolved language for its font.
      builder: (context, child) {
        final locale = Localizations.localeOf(context);
        final dark = switch (settings.themeMode) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system =>
            MediaQuery.platformBrightnessOf(context) == Brightness.dark,
        };
        // The static status colors (the problem boxes, the home's lights)
        // read the same accent the scheme carries; this build is the one
        // place both are decided, so they never disagree. The design is
        // decided here too: its surfaces reach the theme below, and its
        // own light stands in when the user has not picked an accent.
        // The rate's unit is decided beside them: one place, so the home
        // page, the tiles, and the details sheet never disagree.
        AppAccent.current = AppDesign.resolveFor(settings, dark);
        Rates.bits = settings.rateBits;
        // The ear follows the settings' switch, whatever page is open.
        AppSounds.enabled = settings.soundFeedback;
        return Theme(
          data: _theme(
            dark ? Brightness.dark : Brightness.light,
            locale,
            AppAccent.current,
          ),
          // A clear ring around what a remote or the keyboard chose.
          child: FocusRing(
            atStart: Platform.isAndroid && AndroidCore.isTv,
            child: child!,
          ),
        );
      },
      home: Shell(core: core, settings: settings),
    ),
  );
}

class Shell extends StatefulWidget {
  const Shell({super.key, required this.core, required this.settings});

  final CoreController core;
  final AppSettings settings;

  @override
  State<Shell> createState() => _ShellState();
}

enum _Page { overview, servers, accounts, settings, logs, about }

/// The tunnel's phase as the ear reads it: resting, being made, or
/// carrying — the three states the connection's own cues speak.
enum _CuePhase { rest, connecting, up }

class _ShellState extends State<Shell> with WidgetsBindingObserver {
  _Page _page = _Page.overview;

  /// The settings section the home page opened (Connection), until another
  /// page is chosen.
  SettingsSection? _settingsOpening;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // The sounds' pools preload here, so the first tap answers as fast
    // as the first haptic does.
    AppSounds.warmup();
    AndroidCore.homeRequests.addListener(_openHome);
    // The notification's flag art: whenever the core reports a new exit
    // country (or, while connecting, a chosen one), the UI renders that
    // flag's SVG and hands it to the service. The shell is the one place
    // alive whatever page is showing, so the hook lives here.
    widget.core.addListener(_syncFlagArt);
    _syncFlagArt();
    // The open's own connect: when the user asked for it, the VPN comes
    // up as the home page does. It waits for the core's first answers
    // (the status and the accounts arrive together), and plays once.
    widget.core.addListener(_maybeConnectOnOpen);
    // The connection's own cue: a sound and a light haptic when the VPN
    // comes up or goes down — whichever page is open, whoever asked.
    widget.core.addListener(_connectionCue);
  }

  /// Whether the open's own connect already had its one chance.
  bool _connectOnOpenDone = false;

  /// The connect-on-open setting's one shot: the core is answering, the
  /// welcome is finished, there is an account to connect with, and the
  /// VPN is neither up nor already coming up. Then it connects, quietly
  /// — a failure leaves the home page to say what went wrong, as it does
  /// after a hand's own connect.
  void _maybeConnectOnOpen() {
    if (_connectOnOpenDone || !Platform.isAndroid) return;
    final settings = widget.settings;
    final core = widget.core;
    if (!settings.connectOnOpen || settings.firstRun) return;
    final status = core.status;
    final accounts = core.accounts?.accounts ?? const [];
    if (status == null || core.accounts == null || accounts.isEmpty) {
      return; // the core's first answers are still on their way
    }
    _connectOnOpenDone = true;
    final comingUp = status.proxyOn ||
        status.connectPending ||
        status.autoConnecting ||
        core.switchingProxy;
    if (comingUp) return; // nothing to bring up
    Future<void>.microtask(() async {
      try {
        await core.setOn(true);
      } on Exception {
        // The home page reports a failed start on its own; a silent
        // catch only keeps the shell from turning it into a crash.
      }
    });
  }

  void _openHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() {
      _page = _Page.overview;
      _settingsOpening = null;
    });
  }

  /// The connection's phase the cue last saw: null until the core's
  /// first status lands, so the app's very first answers never ring.
  _CuePhase? _cuePhase;

  /// Whether the tunnel was up before the connecting that is running
  /// now: a handover's brief dip (up → connecting → up) must never ring
  /// twice, so its re-arrival stays quiet.
  bool _cueDip = false;

  /// The connection's own cue: each turn of the tunnel carries its own
  /// note (the setting asks for it) and a light haptic. The user's own
  /// connect already hums through the slider's commit, so the haptic
  /// here stays light — a click on top of the commit's knock, and the
  /// only feedback an automatic reconnect ever gives. The phases:
  ///
  /// - rest → connecting: the soft swell, the work has begun;
  /// - connecting → up: the rising chord, the tunnel carries;
  /// - up → rest: the falling chord, the tunnel rests;
  /// - connecting → rest: the start gave up — the blocked way's note,
  ///   unless the dip was a handover's, which only falls quietly;
  /// - up → connecting: nothing yet (a handover mid-flight).
  void _connectionCue() {
    final status = widget.core.status;
    if (status == null) return;
    final phase = status.proxyOn
        ? _CuePhase.up
        : status.connectPending
        ? _CuePhase.connecting
        : _CuePhase.rest;
    final before = _cuePhase;
    _cuePhase = phase;
    if (before == null || before == phase) return;
    SoundCue? cue;
    switch ((before, phase)) {
      case (_CuePhase.rest, _CuePhase.connecting):
        // The work has begun: the soft swell.
        cue = SoundCue.connecting;
      case (_CuePhase.connecting, _CuePhase.up):
        // The tunnel carries: the rising chord — quiet when it is only
        // a handover's dip coming back.
        if (_cueDip) {
          _cueDip = false;
        } else {
          cue = SoundCue.connect;
        }
      case (_CuePhase.up, _CuePhase.rest):
        // The tunnel rests: the falling chord.
        cue = SoundCue.disconnect;
      case (_CuePhase.connecting, _CuePhase.rest):
        // The start gave up: the blocked way's note — a handover that
        // failed only falls, the way any tunnel coming down does.
        _cueDip = false;
        cue = SoundCue.error;
      case (_CuePhase.up, _CuePhase.connecting):
        // A handover mid-flight: nothing yet; its arrival stays quiet.
        _cueDip = true;
      default:
        // The same phase twice, or rest → rest: nothing to say.
        break;
    }
    if (cue == null) return;
    // The app's own note instead of the system's alert, which a phone
    // keeps to itself. The sound switch gates it in AppSounds itself.
    AppSounds.play(cue);
    if (widget.settings.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  /// When the app went to the background, for the lock's own wait.
  DateTime? _leftAt;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused || AppLifecycleState.hidden:
        _leftAt ??= DateTime.now();
      case AppLifecycleState.resumed:
        final left = _leftAt;
        _leftAt = null;
        _relockAfterAway(left);
      case AppLifecycleState.inactive || AppLifecycleState.detached:
        break;
    }
  }

  /// The lock's own caretaker: with a password standing and the setting
  /// on, a return after the wait asks for the word again. Right away
  /// means any real pause; the minutes mean a whole minute each.
  void _relockAfterAway(DateTime? left) {
    final s = widget.settings;
    if (left == null || s.lockHash.isEmpty || !s.lockUnlocked) return;
    final wait = s.lockBackgroundMin;
    if (wait <= 0) return;
    final away = DateTime.now().difference(left);
    final relock = wait == 1 ? away.inMilliseconds > 0 : away.inMinutes >= wait;
    if (relock && mounted) {
      setState(() => s.lockUnlocked = false);
    }
  }

  /// The country whose flag the notification should carry: the one the
  /// traffic really leaves from when it is known, else the one chosen.
  void _syncFlagArt() {
    if (!Platform.isAndroid) return;
    final status = widget.core.status;
    final code = status?.exit?.countryCode.isNotEmpty == true
        ? status!.exit!.countryCode
        : status?.selection ?? '';
    if (code.length == 2) {
      AndroidCore.syncNotifFlag(code);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AndroidCore.homeRequests.removeListener(_openHome);
    widget.core.removeListener(_syncFlagArt);
    widget.core.removeListener(_maybeConnectOnOpen);
    widget.core.removeListener(_connectionCue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.core,
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final core = widget.core;
      final status = core.status;
      final needsAttention = (core.accounts?.accounts ?? const [])
          .where((a) => a.enabled && a.needsSignIn)
          .length;
      // The app's own password: the lock the app opens behind, set on
      // the accounts page. Everything else — the welcome, the pages, the
      // core's answers — waits behind the word.
      if (widget.settings.lockHash.isNotEmpty &&
          !widget.settings.lockUnlocked) {
        return LockPage(
          settings: widget.settings,
          onUnlocked: () => setState(() {}),
        );
      }
      if (widget.settings.firstRun && status != null) {
        return WelcomePage(core: core, settings: widget.settings);
      }
      final pages = [
        _Page.overview,
        _Page.servers,
        _Page.accounts,
        _Page.settings,
        _Page.logs,
        _Page.about,
      ];
      final page = pages.contains(_page) ? _page : _Page.overview;
      Widget accountsIcon(IconData icon) => Badge(
        isLabelVisible: needsAttention > 0,
        label: Text('$needsAttention'),
        child: Icon(icon),
      );
      // Each page's icons and name, for the side menu and the bottom bar.
      final items = [
        for (final page in pages)
          switch (page) {
            _Page.overview => (
              const Icon(Icons.dashboard_outlined),
              const Icon(Icons.dashboard_rounded),
              l.navOverview,
            ),
            _Page.servers => (
              const Icon(Icons.public_outlined),
              const Icon(Icons.public_rounded),
              l.navServers,
            ),
            _Page.accounts => (
              accountsIcon(Icons.people_outline_rounded),
              accountsIcon(Icons.people_rounded),
              l.navAccounts,
            ),
            _Page.settings => (
              const Icon(Icons.settings_outlined),
              const Icon(Icons.settings_rounded),
              l.navSettings,
            ),
            _Page.logs => (
              const Icon(Icons.receipt_long_outlined),
              const Icon(Icons.receipt_long_rounded),
              l.navLogs,
            ),
            _Page.about => (
              const Icon(Icons.info_outline_rounded),
              const Icon(Icons.info_rounded),
              l.navAbout,
            ),
          },
      ];
      final content = Column(
        children: [
          if (core.unavailable != null && status != null) const _LostBanner(),
          Expanded(
            child: status == null
                ? _NoCore(core: core)
                : switch (page) {
                    // Its cards open the pages beside it.
                    _Page.overview => OverviewPage(
                      core: core,
                      settings: widget.settings,
                      onOpenServers: () =>
                          setState(() => _page = _Page.servers),
                      onOpenAccounts: () =>
                          setState(() => _page = _Page.accounts),
                      onOpenConnection: () => setState(() {
                        _page = _Page.settings;
                        _settingsOpening = SettingsSection.connection;
                      }),
                      onOpenUpstreamProxy: () => setState(() {
                        _page = _Page.settings;
                        _settingsOpening = SettingsSection.upstreamProxy;
                      }),
                    ),
                    _Page.servers => ServersPage(
                      core: core,
                      settings: widget.settings,
                    ),
                    _Page.accounts => AccountsPage(
                      core: core,
                      settings: widget.settings,
                    ),
                    _Page.settings => SettingsPage(
                      key: ValueKey(_settingsOpening),
                      core: core,
                      settings: widget.settings,
                      opening: _settingsOpening,
                      onOpenLogs: () => setState(() => _page = _Page.logs),
                    ),
                    _Page.logs => LogsPage(
                      core: core,
                      settings: widget.settings,
                    ),
                    _Page.about => AboutPage(core: core),
                  },
          ),
        ],
      );
      void select(int i) => setState(() {
        _page = pages[i];
        _settingsOpening = null;
      });
      // Android (a phone, or a tablet in either orientation) and a narrow
      // window: the phone layout, Home and Settings. The computer layout
      // offers computer-only choices, such as Windows' system proxy.
      if (Platform.isAndroid || MediaQuery.sizeOf(context).width < 640) {
        return _KeepScreenOn(
          core: core,
          settings: widget.settings,
          child: MobileShell(
            core: core,
            settings: widget.settings,
            banner: core.unavailable != null && status != null
                ? const _LostBanner()
                : null,
            noCore: status == null ? _NoCore(core: core) : null,
          ),
        );
      }
      return Scaffold(
        body: AnnouncementOverlay(
          settings: widget.settings,
          onOpenUpdates: () => setState(() => _page = _Page.about),
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: pages.indexOf(page),
                onDestinationSelected: select,
                // Icons with their names beside them.
                extended: true,
                minExtendedWidth: 190,
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    children: [
                      const AppLogo(size: 34),
                      const SizedBox(width: 10),
                      Text(
                        l.appTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                destinations: [
                  for (final (icon, selected, label) in items)
                    NavigationRailDestination(
                      icon: icon,
                      selectedIcon: selected,
                      label: Text(label),
                    ),
                ],
                // The traffic at the bottom of the menu; in a short window the
                // pages above it scroll rather than run under it.
                trailing: _TrafficPanel(traffic: status?.traffic),
                trailingAtBottom: true,
                scrollable: true,
              ),
              // A maximized window: the pages stay as wide as reads well; the
              // home page, centered by itself, keeps its colors to the edges.
              Expanded(
                child: page == _Page.overview || status == null
                    ? content
                    : Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: content,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Applies the keep-awake setting: the phone's screen stays on while the
/// VPN carries the traffic, when the setting asks for it. The flag goes to
/// the window once per change, not once per build.
class _KeepScreenOn extends StatefulWidget {
  const _KeepScreenOn({
    required this.core,
    required this.settings,
    required this.child,
  });

  final CoreController core;
  final AppSettings settings;
  final Widget child;

  @override
  State<_KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<_KeepScreenOn> {
  bool _applied = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.core.status;
    final want =
        widget.settings.keepScreenOn &&
        status != null &&
        status.proxyOn &&
        status.state.phase == Phase.running;
    if (want != _applied) {
      _applied = want;
      AndroidCore.setKeepScreenOn(want);
    }
    return widget.child;
  }
}

/// The side menu's traffic: the speed now and the total since the core
/// started, through Mozilla, up and down.
class _TrafficPanel extends StatelessWidget {
  const _TrafficPanel({required this.traffic});

  final Traffic? traffic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = traffic;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: SizedBox(
        width: 166,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TrafficCard(
              title: l.liveTraffic,
              up: formatRate(t?.upRate ?? 0),
              down: formatRate(t?.downRate ?? 0),
            ),
            const SizedBox(height: 8),
            _TrafficCard(
              title: l.totalTraffic,
              up: formatBytes(t?.up ?? 0),
              down: formatBytes(t?.down ?? 0),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrafficCard extends StatelessWidget {
  const _TrafficCard({
    required this.title,
    required this.up,
    required this.down,
  });

  final String title;
  final String up;
  final String down;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = theme.textTheme.bodySmall?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    Widget line(IconData icon, Color color, String text) => Row(
      children: [
        Icon(icon, size: 14, color: color),
        const Spacer(),
        Text(text, style: value),
      ],
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          line(Icons.arrow_upward_rounded, StatusColors.good, up),
          line(Icons.arrow_downward_rounded, theme.colorScheme.primary, down),
        ],
      ),
    );
  }
}

class _LostBanner extends StatelessWidget {
  const _LostBanner();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: StatusColors.bad.withValues(alpha: 0.14),
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
    child: Row(
      children: [
        Icon(Icons.link_off_rounded, size: 18, color: StatusColors.bad),
        const SizedBox(width: 10),
        Expanded(child: Text(AppLocalizations.of(context).coreLost)),
      ],
    ),
  );
}

class _NoCore extends StatelessWidget {
  const _NoCore({required this.core});

  final CoreController core;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final midnight = midnightTheme(Theme.of(context));
    final problem = core.unavailable;
    final portTaken =
        problem != null &&
        (problem.problem == CoreProblem.portInUse ||
            problem.problem == CoreProblem.refused);
    // The boot and the error share the home's night look: the wait for the
    // core is part of the app, not a gray gap before it.
    return Theme(
      data: midnight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Midnight.top, Midnight.bottom],
          ),
        ),
        child: Center(
          // The buttons clear the floating pill navigation beneath.
          child: Padding(
            padding: const EdgeInsets.only(bottom: 96),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (problem == null ||
                      problem.problem == CoreProblem.starting) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(l.startingCore, style: midnight.textTheme.titleMedium),
                  ] else ...[
                    const Icon(
                      Icons.power_off_rounded,
                      size: 48,
                      color: Midnight.muted,
                    ),
                    const SizedBox(height: 16),
                    Text(l.cantReachCore, style: midnight.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      describeProblem(l, problem),
                      textAlign: TextAlign.center,
                      style: midnight.textTheme.bodyMedium?.copyWith(
                        color: Midnight.muted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        if (portTaken && core.moveStoppedCore != null)
                          FilledButton.icon(
                            onPressed: () async {
                              final port = await showPortDialog(
                                context,
                                taken: problem.detail,
                              );
                              if (port != null && context.mounted) {
                                await runShowingErrors(
                                  context,
                                  () => core.setAppPort(port),
                                );
                              }
                            },
                            icon: const Icon(Icons.settings_ethernet_rounded),
                            label: Text(l.changePort),
                          ),
                        FilledButton.tonalIcon(
                          onPressed: core.retry,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(l.retry),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
