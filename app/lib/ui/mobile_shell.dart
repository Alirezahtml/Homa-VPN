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
import 'design.dart';
import 'design_style.dart';
import 'logs_page.dart';
import 'motion.dart';
import 'overview_page.dart';
import 'servers_page.dart';
import 'settings_page.dart';
import 'sound.dart' show AppSounds, SoundCue;
import 'ur_kit.dart';
import 'ur_settings.dart';
import 'ur_share.dart';
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
    AndroidCore.shortcutRequests.addListener(_runShortcut);
  }

  void _openHome() => setState(() => _tab = 0);

  /// A launcher shortcut ("connect to Germany"): chooses the country and
  /// turns the VPN on when it is not already. One per shortcut tap: the
  /// same code arriving twice does the work once.
  Future<void> _runShortcut() async {
    final code = AndroidCore.shortcutRequests.value;
    if (code.isEmpty) return;
    AndroidCore.shortcutRequests.value = '';
    try {
      await widget.core.setLocation(code);
      if (!mounted) return;
      final status = widget.core.status;
      if (status != null && !status.proxyOn) {
        await AndroidCore.setOn(true);
      }
    } on Exception {
      // The shell's own error surfacing covers the core's answers; a
      // shortcut that cannot run keeps the app where it was.
    }
  }

  @override
  void dispose() {
    AndroidCore.homeRequests.removeListener(_openHome);
    AndroidCore.shortcutRequests.removeListener(_runShortcut);
    super.dispose();
  }

  /// Opens [page] under a top bar named [title]; it follows the core.
  /// The header the page wears is the design's own: the monochrome keeps
  /// the Material bar, the ios wears the system bar's compact bold title
  /// and chevron.
  void _push(String title, Widget Function() page) {
    final header = DesignStyle.of(context).header;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ListenableBuilder(
          listenable: widget.core,
          builder: (context, _) {
            final body = SafeArea(
              top: false,
              child: OwnTopBar(child: _readable(page())),
            );
            return switch (header) {
              HeaderVariant.material => Scaffold(
                appBar: AppBar(title: Text(title)),
                body: body,
              ),
              HeaderVariant.ios => Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  titleTextStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                body: body,
              ),
              // The bento's box header: the squircle back tile, the big
              // title in the page itself. The column stretches: a header
              // is the page's own width — shrink-wrapped, it would ride
              // the title's width and the back tile would leave its
              // edge for the screen's middle.
              HeaderVariant.bento => Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BentoPageHeader(title: title),
                    Expanded(child: body),
                  ],
                ),
              ),
              // The gazette's section front: the ruled square, the serif
              // title, the masthead's double rule. Stretched: the rules
              // span the page, not the title's width.
              HeaderVariant.gazette => Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GazettePageHeader(title: title),
                    Expanded(child: body),
                  ],
                ),
              ),
              // Material 3's large title: the plain arrow, the big word.
              // Stretched: the header spans the page — shrink-wrapped to
              // the title's width and centered by the column, the back
              // arrow left its edge and landed in the screen's middle.
              HeaderVariant.m3 => Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    M3PageHeader(title: title),
                    Expanded(child: body),
                  ],
                ),
              ),
            };
          },
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
    void openRouting() => _push(
      l.sectionRouting,
      () => SettingsPage(
        core: core,
        settings: settings,
        section: SettingsSection.routing,
      ),
    );
    void openShare() =>
        _push(l.urShare, () => UrSharePage(core: core, settings: settings));
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
                onOpenRouting: openRouting,
                onOpenShare: openShare,
                push: (title, page) => _push(title, () => page),
                phone: true,
              )
            // The ur design: the settings are URnetwork's own screen —
            // the sections, the rows, the app's own switch — the deep
            // pages open as they always have.
            : _readable(
                AppDesign.current.key == 'ur'
                    ? UrSettingsPage(
                        core: core,
                        settings: settings,
                        push: (title, page) => _push(title, () => page),
                      )
                    : _SettingsList(
                        onOpenServers: openServers,
                        onOpenAccounts: openAccounts,
                        push: _push,
                        core: core,
                        settings: settings,
                      ),
              ));
    final nav = _nav(context, settings);
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
                _push(l.checkUpdates, () => AboutPage(core: core, settings: settings)),
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
        bottomNavigationBar: nav,
      ),
    );
  }

  /// The bar at the foot: the ur design carries the classic bar — the
  /// only navigation the design has now; the other designs keep theirs.
  Widget _nav(BuildContext context, AppSettings settings) {
    if (AppDesign.current.key == 'ur') {
      final l = AppLocalizations.of(context);
      return UrNavBar(
        items: [
          UrNavItem(Icons.home_rounded, l.navOverview),
          UrNavItem(Icons.settings_rounded, l.navSettings),
        ],
        index: _tab,
        onSelect: (i) => setState(() => _tab = i),
      );
    }
    return switch (DesignStyle.of(context).nav) {
      NavVariant.bentoDock => BentoDockNav(
        index: _tab,
        onSelect: (i) => setState(() => _tab = i),
      ),
      NavVariant.gazetteRuled => GazetteNav(
        index: _tab,
        onSelect: (i) => setState(() => _tab = i),
      ),
      NavVariant.cupertinoBar => CupertinoBarNav(
        index: _tab,
        onSelect: (i) => setState(() => _tab = i),
      ),
      NavVariant.m3Bar => M3BarNav(
        index: _tab,
        onSelect: (i) => setState(() => _tab = i),
      ),
      NavVariant.glassPill => _FloatingPillNav(
        index: _tab,
        onSelect: (i) => setState(() => _tab = i),
      ),
    };
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
    // The app's one design: the monochrome — the pill keeps its
    // full-contrast light and its own night glass.
    final accent = dark ? Colors.white : const Color(0xFF0A0A0A);
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
                    ? const Color(0xCC0F0F0F)
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
                    // Positioned.fill: the Align's child must know the
                    // pill's height (a bare Align child would have none).
                    Positioned.fill(
                      child: AnimatedAlign(
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
                          heightFactor: 1,
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
    final idle = dark ? Midnight.muted : const Color(0xFF6B6B6B);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!selected) {
            HapticFeedback.selectionClick();
            // The ear hears the section change beside the finger.
            AppSounds.play(SoundCue.tap);
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
                      color: selected
                          ? (dark ? Colors.black : Colors.white)
                          : idle,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected
                        ? (dark ? Colors.black : Colors.white)
                        : idle,
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
    // Every row's icon sits in the same rounded box, so the page reads as
    // one system rather than a pile of buttons.
    Widget tile(IconData icon, String title, VoidCallback onTap) => ListTile(
      leading: IconBox(icon: icon),
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
          section(
            SettingsSection.appearance,
            Icons.palette_rounded,
            l.sectionAppearance,
          ),
          // The one tap the designs ask for: opens the home-design picker
          // (the wheel, the tiles, the looks, and the ur) straight from
          // the settings list.
          tile(
            Icons.style_rounded,
            l.changeUi,
            () => showDesignPicker(context, settings),
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
            () => push(l.navAbout, () => AboutPage(core: core, settings: settings)),
          ),
        ]),
      ],
    );
  }
}
