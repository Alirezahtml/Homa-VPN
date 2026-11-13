import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_controller.dart';
import '../l10n/app_localizations.dart';
import 'about_page.dart';
import 'announcement_panel.dart';
import 'accounts_page.dart';
import 'logs_page.dart';
import 'motion.dart';
import 'overview_page.dart';
import 'servers_page.dart';
import 'settings_page.dart';
import 'widgets.dart';

/// The phone layout: two tabs, Home and Settings, as phone apps have. The
/// rest (accounts, servers, each group of settings, logs, about) opens as a
/// page of its own with the system's back button.
class MobileShell extends StatefulWidget {
  const MobileShell({
    super.key,
    required this.core,
    required this.settings,
    required this.banner,
    this.noCore,
  });

  final CoreController core;
  final AppSettings settings;

  /// Shown above the page when the core stopped answering.
  final Widget? banner;

  /// Shown in place of the pages until the core first answers.
  final Widget? noCore;

  @override
  State<MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends State<MobileShell> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    AndroidCore.homeRequests.addListener(_openHome);
  }

  void _openHome() => setState(() => _tab = 0);

  @override
  void dispose() {
    AndroidCore.homeRequests.removeListener(_openHome);
    super.dispose();
  }

  /// Opens [page] under a top bar named [title]; it follows the core.
  void _push(String title, Widget Function() page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ListenableBuilder(
          listenable: widget.core,
          builder: (context, _) => Scaffold(
            appBar: AppBar(title: Text(title)),
            body: SafeArea(
              top: false,
              child: OwnTopBar(child: _readable(page())),
            ),
          ),
        ),
      ),
    );
  }

  /// [page] no wider than a line can be read on a tablet; the home page
  /// keeps the whole width for its colors and limits its own content.
  static Widget _readable(Widget page) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: page,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final core = widget.core;
    final settings = widget.settings;
    void openServers() =>
        _push(l.navServers, () => ServersPage(core: core, settings: settings));
    void openAccounts() => _push(
      l.navAccounts,
      () => AccountsPage(core: core, settings: settings),
    );
    void openConnection() => _push(
      l.sectionConnection,
      () => SettingsPage(
        core: core,
        settings: settings,
        section: SettingsSection.connection,
      ),
    );
    void openUpstreamProxy() => _push(
      l.upstreamProxy,
      () => SettingsPage(
        core: core,
        settings: settings,
        section: SettingsSection.upstreamProxy,
      ),
    );
    final page =
        widget.noCore ??
        (_tab == 0
            ? OverviewPage(
                core: core,
                settings: settings,
                onOpenServers: openServers,
                onOpenAccounts: openAccounts,
                onOpenConnection: openConnection,
                onOpenUpstreamProxy: openUpstreamProxy,
                phone: true,
              )
            : _readable(
                _SettingsList(
                  onOpenServers: openServers,
                  onOpenAccounts: openAccounts,
                  push: _push,
                  core: core,
                  settings: settings,
                ),
              ));
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _tab = 0);
      },
      child: Scaffold(
        // The pages run under the floating pill; the gradient and the lists
        // keep going behind it instead of stopping at a bar's edge.
        extendBody: true,
        body: SafeArea(
          // The home page's hero reaches under the status bar.
          top: _tab != 0 || widget.noCore != null || widget.banner != null,
          child: AnnouncementOverlay(
            settings: settings,
            onOpenUpdates: () =>
                _push(l.checkUpdates, () => AboutPage(core: core)),
            child: Column(
              children: [
                ?widget.banner,
                Expanded(
                  // The tabs cross-fade with a slight lift instead of
                  // jumping.
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.03),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(
                        '$_tab-${widget.noCore != null}-'
                        '${widget.banner != null}',
                      ),
                      child: page,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _FloatingPillNav(
          index: _tab,
          onSelect: (i) => setState(() => _tab = i),
        ),
      ),
    );
  }
}

/// The floating pill navigation: the app's tabs in a rounded, floating
/// glass pill instead of a bar glued to the screen's bottom edge. The
/// selection is a light that slides between the two halves; the chosen
/// icon fills and lifts. It floats over the page, which scrolls beneath
/// it (the shell's `extendBody`).
class _FloatingPillNav extends StatelessWidget {
  const _FloatingPillNav({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? Midnight.idle : Theme.of(context).colorScheme.primary;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        // heightFactor: the slot takes the pill's own height, not the
        // screen's; a wide window centers the pill under its page.
        child: Align(
          heightFactor: 1,
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: dark
                    // The night glass: the pill is of the page it floats
                    // over, the midnight gradient showing through.
                    ? const Color(0xB3121330)
                    : Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.4 : 0.16),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  // The state's light under the pill, as on the home page.
                  BoxShadow(
                    color: accent.withValues(alpha: dark ? 0.18 : 0.12),
                    blurRadius: 34,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(31),
                child: Stack(
                  children: [
                    // The selection's light slides between the halves.
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 340),
                      curve: Curves.easeOutCubic,
                      // Alignment is not direction-aware: in the right-to-
                      // left languages the first tab is at the right.
                      alignment: Alignment(
                        (index == 0 ? -1 : 1) *
                            (Directionality.of(context) == TextDirection.rtl
                                ? -1
                                : 1),
                        0,
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.lerp(accent, Colors.white, 0.18)!,
                                  accent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.45),
                                  blurRadius: 16,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _pillItem(
                          context,
                          i: 0,
                          outline: Icons.home_outlined,
                          filled: Icons.home_rounded,
                          label: l.navHome,
                        ),
                        _pillItem(
                          context,
                          i: 1,
                          outline: Icons.settings_outlined,
                          filled: Icons.settings_rounded,
                          label: l.navSettings,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// One tab of the pill: its icon fills and lifts when chosen, its name
  /// brightens; the press sinks it a little (Pressable).
  Widget _pillItem(
    BuildContext context, {
    required int i,
    required IconData outline,
    required IconData filled,
    required String label,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final selected = index == i;
    final idle = dark ? Midnight.muted : const Color(0xFF646C92);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!selected) {
            HapticFeedback.selectionClick();
            onSelect(i);
          }
        },
        child: Pressable(
          depth: 0.05,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: selected ? 1.12 : 1.0,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.7, end: 1.0).animate(anim),
                        child: child,
                      ),
                    ),
                    child: Icon(
                      selected ? filled : outline,
                      key: ValueKey(selected),
                      size: 22,
                      color: selected ? Colors.white : idle,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? Colors.white : idle,
                    fontFamily: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.fontFamily,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The Settings tab: what the app manages, the groups of settings, and the
/// app's own pages.
class _SettingsList extends StatelessWidget {
  const _SettingsList({
    required this.onOpenServers,
    required this.onOpenAccounts,
    required this.push,
    required this.core,
    required this.settings,
  });

  final VoidCallback onOpenServers;
  final VoidCallback onOpenAccounts;
  final void Function(String title, Widget Function() page) push;
  final CoreController core;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget group(String title, List<Widget> tiles) =>
        SettingsGroup(title: title, tiles: tiles);
    Widget tile(IconData icon, String title, VoidCallback onTap) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      // Mirrors itself in right-to-left languages.
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
    Widget section(SettingsSection section, IconData icon, String name) => tile(
      icon,
      name,
      () => push(
        name,
        () => SettingsPage(core: core, settings: settings, section: section),
      ),
    );
    return ListView(
      padding: pagePadding(context) + const EdgeInsets.only(bottom: 96),
      children: [
        PageTitle(l.settingsTitle),
        // Language and theme first, what someone looks for before anything
        // else, with which country and account; then how the traffic goes,
        // what helps when Mozilla is blocked, and the app itself.
        group(l.sectionGeneral, [
          section(
            SettingsSection.general,
            Icons.tune_rounded,
            l.sectionGeneral,
          ),
          tile(Icons.public_rounded, l.navServers, onOpenServers),
          tile(Icons.people_outline_rounded, l.navAccounts, onOpenAccounts),
        ]),
        group(l.groupNetwork, [
          section(
            SettingsSection.connection,
            Icons.vpn_lock_outlined,
            l.sectionConnection,
          ),
          section(
            SettingsSection.routing,
            Icons.alt_route_rounded,
            l.sectionRouting,
          ),
          section(SettingsSection.dns, Icons.dns_rounded, l.sectionDns),
        ]),
        group(l.sectionBypass, [
          section(SettingsSection.relay, Icons.cloud_outlined, l.apiRelay),
          section(
            SettingsSection.fragment,
            Icons.content_cut_rounded,
            l.tlsFragment,
          ),
          section(
            SettingsSection.upstreamProxy,
            Icons.lan_outlined,
            l.upstreamProxy,
          ),
        ]),
        group(l.groupApp, [
          // The app's port and the web dashboard: computers only (a narrow
          // window shows this layout too).
          if (!Platform.isAndroid)
            section(
              SettingsSection.advanced,
              Icons.build_outlined,
              l.sectionAdvanced,
            ),
          tile(
            Icons.receipt_long_outlined,
            l.navLogs,
            () => push(l.navLogs, () => LogsPage(core: core)),
          ),
          tile(
            Icons.info_outline_rounded,
            l.navAbout,
            () => push(l.navAbout, () => AboutPage(core: core)),
          ),
        ]),
      ],
    );
  }
}
