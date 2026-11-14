import 'dart:io';

import 'package:flutter/material.dart';
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
import 'focus_ring.dart';
import 'format.dart';
import 'logs_page.dart';
import 'mobile_shell.dart';
import 'overview_page.dart';
import 'port_dialog.dart';
import 'servers_page.dart';
import 'settings_page.dart';
import 'welcome_page.dart';
import 'widgets.dart';

ThemeData _theme(Brightness brightness, Locale locale, Color? accent) {
  final dark = brightness == Brightness.dark;
  // The monochrome scheme: pure black and white with neutral grays
  // between — no hue anywhere, in either mode. A chosen accent takes the
  // scheme's lights (buttons, toggles, progress) only; the surfaces and
  // the ink stay monochrome, and the containers keep their neutral gray.
  final scheme = dark
      ? const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
          tertiary: Colors.white,
          onTertiary: Colors.black,
          primaryContainer: Color(0xFF2A2A2A),
          onPrimaryContainer: Colors.white,
          secondaryContainer: Color(0xFF1E1E1E),
          onSecondaryContainer: Colors.white,
          tertiaryContainer: Color(0xFF1E1E1E),
          onTertiaryContainer: Colors.white,
          surface: Colors.black,
          onSurface: Colors.white,
          onSurfaceVariant: Color(0xFF9E9E9E),
          outline: Color(0xFF3A3A3A),
          outlineVariant: Color(0xFF262626),
          inverseSurface: Colors.white,
          onInverseSurface: Colors.black,
          inversePrimary: Color(0xFF0A0A0A),
          surfaceTint: Colors.transparent,
          surfaceContainerHighest: Color(0xFF161616),
          surfaceContainerHigh: Color(0xFF1A1A1A),
          surfaceContainer: Color(0xFF111111),
          surfaceContainerLow: Color(0xFF0C0C0C),
          surfaceContainerLowest: Colors.black,
        )
      : const ColorScheme.light(
          primary: Color(0xFF0A0A0A),
          onPrimary: Colors.white,
          secondary: Color(0xFF0A0A0A),
          onSecondary: Colors.white,
          tertiary: Color(0xFF0A0A0A),
          onTertiary: Colors.white,
          primaryContainer: Color(0xFFE8E8E8),
          onPrimaryContainer: Color(0xFF0A0A0A),
          secondaryContainer: Color(0xFFF0F0F0),
          onSecondaryContainer: Color(0xFF0A0A0A),
          tertiaryContainer: Color(0xFFF0F0F0),
          onTertiaryContainer: Color(0xFF0A0A0A),
          surface: Colors.white,
          onSurface: Color(0xFF0A0A0A),
          onSurfaceVariant: Color(0xFF6B6B6B),
          outline: Color(0xFFC9C9C9),
          outlineVariant: Color(0xFFE4E4E4),
          inverseSurface: Color(0xFF0A0A0A),
          onInverseSurface: Colors.white,
          inversePrimary: Colors.white,
          surfaceTint: Colors.transparent,
          surfaceContainerHighest: Color(0xFFEFEFEF),
          surfaceContainerHigh: Color(0xFFF2F2F2),
          surfaceContainer: Color(0xFFF6F6F6),
          surfaceContainerLow: Color(0xFFF9F9F9),
          surfaceContainerLowest: Colors.white,
        );
  // Bundled Inter for English, Vazirmatn for Persian and Arabic, and the
  // platform's typography for the remaining languages.
  final font = languageFont(locale.languageCode);
  final lit = accent == null ? null : accentForTheme(accent, dark);
  final theme = ThemeData(
    colorScheme: lit == null
        ? scheme
        : scheme.copyWith(
            primary: lit,
            onPrimary: AppAccent.onAccent(lit),
            secondary: lit,
            onSecondary: AppAccent.onAccent(lit),
            tertiary: lit,
            onTertiary: AppAccent.onAccent(lit),
            inversePrimary: dark ? AppAccent.onAccent(lit) : lit,
          ),
    fontFamily: font,
    scaffoldBackgroundColor: dark ? Colors.black : Colors.white,
    // Pixel-grade surfaces: one generous radius for every card, list and
    // dialog, so the whole app reads as one system.
    cardTheme: CardThemeData(
      elevation: 0,
      color: dark ? const Color(0xFF0D0D0D) : const Color(0xFFF7F7F7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: dark ? const Color(0xFF111111) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? Colors.black : Colors.white,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
        fontFamily: font,
      ),
    ),
    listTileTheme: ListTileThemeData(iconColor: scheme.onSurfaceVariant),
    dividerTheme: DividerThemeData(
      thickness: 1,
      color: scheme.outlineVariant.withValues(alpha: 0.5),
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
      backgroundColor: dark ? Colors.black : const Color(0xFFF2F2F2),
      // NavigationRail replaces DefaultTextStyle, so retain the resolved
      // platform font instead of letting a null family choose a fallback.
      selectedLabelTextStyle: theme.textTheme.labelLarge!.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      unselectedLabelTextStyle: theme.textTheme.labelLarge!.copyWith(
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        color: scheme.onSurfaceVariant,
      ),
      selectedIconTheme: IconThemeData(
        size: 24,
        color: scheme.onSecondaryContainer,
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
        color: scheme.onSurfaceVariant,
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
        // place both are decided, so they never disagree.
        AppAccent.current = AppAccent.resolve(settings);
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

class _ShellState extends State<Shell> {
  _Page _page = _Page.overview;

  /// The settings section the home page opened (Connection), until another
  /// page is chosen.
  SettingsSection? _settingsOpening;

  @override
  void initState() {
    super.initState();
    AndroidCore.homeRequests.addListener(_openHome);
  }

  void _openHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() {
      _page = _Page.overview;
      _settingsOpening = null;
    });
  }

  @override
  void dispose() {
    AndroidCore.homeRequests.removeListener(_openHome);
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
