import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../app_info.dart';
import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_controller.dart';
import '../core/diagnostics.dart' show showDiagnostics;
import '../l10n/app_localizations.dart';
import 'about_page.dart';
import 'accounts_page.dart';
import 'app_usage_page.dart' show AppUsagePage;
import 'format.dart' show formatBytes;
import 'logs_page.dart' show LogsPage;
import 'servers_page.dart';
import 'settings_page.dart'
    show
        SettingsPage,
        SettingsSection,
        accentName,
        designName,
        mapKindName,
        mapStyleName,
        showAccentPicker,
        showDesignPicker;
import 'ur_kit.dart';
import 'ur_dns.dart' show UrDnsPage;
import 'widgets.dart'
    show languageNames, languageStyle, runShowingErrors, showToast;
import 'whats_new.dart' show showWhatsNew, whatsNewSections;
import 'world_map.dart' show GlobeStyle, MapKind;

/// The URnetwork settings screen, ported as it ships — and carrying every
/// option the app really has.
///
/// The original's layout: the big headline, the sections one under the
/// other with their twelve-point labels, each row a full-width tap that
/// answers with the soft bounce, the switches the app's own 36×20, the
/// links in the pink and the labels in the muted ink. The rows carry the
/// app's real settings: the servers and the accounts, the protection (the
/// kill switch and the system's always-on guard), the general switches
/// from the boot connect to the data limit, the appearance (the home's
/// design — the classic layouts and this one —, the theme's mode, the
/// accent, and the map's kind and style), the network's and the bypass
/// sections (each on the page it always had), the battery guide, and the
/// app's own pages — the usage, the logs, the version's story.
class UrSettingsPage extends StatelessWidget {
  const UrSettingsPage({
    super.key,
    required this.core,
    required this.settings,
    required this.push,
  });

  final CoreController core;
  final AppSettings settings;
  final void Function(String title, Widget page) push;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      color: UrTokens.bg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          Text(l.navSettings, style: urTitleStyle(context)),
          const SizedBox(height: 24),

          // Connections: the servers and the accounts, the pages the
          // home's location card opens, as rows of their own.
          UrEntrance(
            index: 1,
            child: _SectionLabel(l.urSectionConnections),
          ),
          UrEntrance(
            index: 1,
            child: _Card(
              children: [
                _NavRow(
                  icon: Icons.public_rounded,
                  label: l.navServers,
                  onTap: () => push(
                    l.navServers,
                    ServersPage(core: core, settings: settings),
                  ),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.group_rounded,
                  label: l.navAccounts,
                  onTap: () => push(
                    l.navAccounts,
                    AccountsPage(core: core, settings: settings),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Protection: the kill switch that holds the traffic when the
          // path breaks, and Android's own always-on guard.
          if (Platform.isAndroid) ...[
            UrEntrance(index: 2, child: _SectionLabel(l.protection)),
            UrEntrance(
              index: 2,
              child: _Card(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: AndroidCore.killSwitch,
                    builder: (context, on, _) => _SwitchRow(
                      label: l.killSwitch,
                      subtitle: l.killSwitchHint,
                      value: on,
                      onChanged: (v) => runShowingErrors(
                        context,
                        () => AndroidCore.setKillSwitch(v),
                      ),
                    ),
                  ),
                  _HairLine(),
                  _NavRow(
                    icon: Icons.verified_user_outlined,
                    label: l.alwaysOnVpn,
                    value: l.alwaysOnVpnHint,
                    onTap: () => runShowingErrors(
                      context,
                      () => AndroidCore.openVpnSettings(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],

          // General: the language, and every switch the app really has —
          // from the boot connect and the auto-install to the idle
          // hang-up and the session's data limit.
          UrEntrance(index: 3, child: _SectionLabel(l.urSectionGeneral)),
          UrEntrance(
            index: 3,
            child: _Card(
              children: [
                _NavRow(
                  icon: Icons.translate_rounded,
                  label: l.language,
                  value: _languageName(settings.language, l),
                  onTap: () => _pickLanguage(context, settings),
                ),
                _SwitchRow(
                  label: l.connectOnOpen,
                  value: settings.connectOnOpen,
                  onChanged: (v) => settings.update(connectOnOpen: v),
                ),
                _SwitchRow(
                  label: l.autoReconnect,
                  value: settings.autoReconnect,
                  onChanged: (v) => settings.update(autoReconnect: v),
                ),
                _SwitchRow(
                  label: l.keepScreenOn,
                  value: settings.keepScreenOn,
                  onChanged: (v) => settings.update(keepScreenOn: v),
                ),
                _SwitchRow(
                  label: l.showTraffic,
                  value: settings.showTraffic,
                  onChanged: (v) => settings.update(showTraffic: v),
                ),
                if (Platform.isAndroid) ...[
                  ValueListenableBuilder<bool>(
                    valueListenable: AndroidCore.showSpeed,
                    builder: (context, on, _) => _SwitchRow(
                      label: l.speedInNotification,
                      value: on,
                      onChanged: (v) => runShowingErrors(
                        context,
                        () => AndroidCore.setShowSpeed(v),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: AndroidCore.notifFlag,
                    builder: (context, on, _) => _SwitchRow(
                      label: l.notifFlag,
                      subtitle: l.notifFlagHint,
                      value: on,
                      onChanged: (v) => runShowingErrors(
                        context,
                        () => AndroidCore.setNotifFlag(v),
                      ),
                    ),
                  ),
                ],
                _SwitchRow(
                  label: l.soundFeedback,
                  value: settings.soundFeedback,
                  onChanged: (v) => settings.update(soundFeedback: v),
                ),
                _SwitchRow(
                  label: l.hapticFeedback,
                  value: settings.hapticFeedback,
                  onChanged: (v) => settings.update(hapticFeedback: v),
                ),
                _SwitchRow(
                  label: l.batterySaver,
                  subtitle: l.urBatterySaverNote,
                  value: settings.batterySaver,
                  onChanged: (v) => settings.update(batterySaver: v),
                ),
                if (Platform.isAndroid)
                  ValueListenableBuilder<bool>(
                    valueListenable: AndroidCore.autoConnectBoot,
                    builder: (context, on, _) => _SwitchRow(
                      label: l.connectAtBoot,
                      subtitle: l.connectAtBootHint,
                      value: on,
                      onChanged: (v) => runShowingErrors(
                        context,
                        () => AndroidCore.setAutoConnectBoot(v),
                      ),
                    ),
                  ),
                _SwitchRow(
                  label: l.autoInstallApk,
                  subtitle: l.autoInstallApkHint,
                  value: settings.autoInstallApk,
                  onChanged: (v) => settings.update(autoInstallApk: v),
                ),
                _SwitchRow(
                  label: l.showPublicIp,
                  value: settings.showPublicIp,
                  onChanged: (v) => settings.update(showPublicIp: v),
                ),
                _SwitchRow(
                  label: l.gamingProfile,
                  subtitle: l.gamingProfileHint,
                  value: settings.gamingProfile,
                  onChanged: (v) {
                    settings.update(gamingProfile: v);
                    if (v &&
                        Platform.isAndroid &&
                        !AndroidCore.showSpeed.value) {
                      runShowingErrors(
                        context,
                        () => AndroidCore.setShowSpeed(true),
                      );
                    }
                  },
                ),
                _ChoiceRow<bool>(
                  icon: Icons.numbers_rounded,
                  title: l.rateUnit,
                  value: settings.rateBits,
                  options: [(false, 'KB/s'), (true, 'Mbps')],
                  onChanged: (v) => settings.update(rateBits: v),
                ),
                _SwitchRow(
                  label: l.idleDisconnect,
                  subtitle: l.idleDisconnectHint,
                  value: settings.idleDisconnect,
                  onChanged: (v) => settings.update(idleDisconnect: v),
                ),
                Opacity(
                  opacity: settings.idleDisconnect ? 1 : 0.5,
                  child: _ChoiceRow<int>(
                    icon: Icons.timer_outlined,
                    title: l.idleTimeout,
                    value: settings.idleTimeoutMin,
                    options: [
                      (5, l.minutes5),
                      (10, l.minutes10),
                      (15, l.minutes15),
                      (30, l.minutes30),
                      (60, l.minutes60),
                    ],
                    onChanged: settings.idleDisconnect
                        ? (v) => settings.update(idleTimeoutMin: v)
                        : null,
                  ),
                ),
                _SwitchRow(
                  label: l.dataLimit,
                  subtitle: l.dataLimitHint,
                  value: settings.dataLimit,
                  onChanged: (v) => settings.update(dataLimit: v),
                ),
                Opacity(
                  opacity: settings.dataLimit ? 1 : 0.5,
                  child: _ChoiceRow<int>(
                    icon: Icons.save_alt_rounded,
                    title: l.dataLimitAmount,
                    value: settings.dataLimitMb,
                    options: [
                      (256, l.mb256),
                      (512, l.mb512),
                      (1024, l.mb1024),
                      (2048, l.mb2048),
                      (5120, l.mb5120),
                      (10240, l.mb10240),
                      (25600, l.mb25600),
                      (51200, l.mb51200),
                      (102400, l.mb102400),
                    ],
                    onChanged: settings.dataLimit
                        ? (v) => settings.update(dataLimitMb: v)
                        : null,
                  ),
                ),
                _VerboseRow(core: core),
                _NavRow(
                  icon: Icons.healing_rounded,
                  label: l.diagnosticsRun,
                  value: l.diagnosticsHint,
                  onTap: () => showDiagnostics(context, core),
                ),
                if (settings.lockHash.isNotEmpty)
                  _ChoiceRow<int>(
                    icon: Icons.lock_clock_rounded,
                    title: l.lockInBackground,
                    value: settings.lockBackgroundMin,
                    options: [
                      (0, l.lockBgNever),
                      (1, l.lockBgNow),
                      (5, l.lockBgMin5),
                      (15, l.lockBgMin15),
                    ],
                    onChanged: (v) => settings.update(lockBackgroundMin: v),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Appearance: the home's own design — the classic layouts and
          // this one, one tap away —, the theme's mode, the accent's
          // light, and the map's kind and style the other homes carry.
          UrEntrance(index: 4, child: _SectionLabel(l.urSectionAppearance)),
          UrEntrance(
            index: 4,
            child: _Card(
              children: [
                _NavRow(
                  icon: Icons.style_rounded,
                  label: l.designTitle,
                  value: designName(l, settings),
                  onTap: () => showDesignPicker(context, settings),
                ),
                _HairLine(),
                _ChoiceRow<ThemeMode>(
                  icon: Icons.brightness_6_outlined,
                  title: l.theme,
                  value: settings.themeMode,
                  options: [
                    (ThemeMode.system, l.themeSystem),
                    (ThemeMode.light, l.themeLight),
                    (ThemeMode.dark, l.themeDark),
                  ],
                  onChanged: (v) => settings.update(themeMode: v),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.palette_outlined,
                  label: l.accentColor,
                  value: accentName(context, settings),
                  onTap: () => showAccentPicker(context, settings),
                ),
                _HairLine(),
                _ChoiceRow<String>(
                  icon: Icons.map_rounded,
                  title: l.mapKind,
                  value: settings.mapKind,
                  options: [
                    for (final kind in MapKind.values)
                      (kind.name, mapKindName(l, kind)),
                  ],
                  onChanged: (v) => settings.update(mapKind: v),
                ),
                _HairLine(),
                _ChoiceRow<String>(
                  icon: Icons.public_rounded,
                  title: l.mapStyle,
                  value: settings.mapStyle,
                  options: [
                    for (final style in GlobeStyle.values)
                      (style.name, mapStyleName(l, style)),
                  ],
                  onChanged: (v) => settings.update(mapStyle: v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Network: how the traffic goes — each section keeps the page
          // it always had, the port opens it as the home does.
          UrEntrance(index: 5, child: _SectionLabel(l.groupNetwork)),
          UrEntrance(
            index: 5,
            child: _Card(
              children: [
                _NavRow(
                  icon: Icons.vpn_lock_outlined,
                  label: l.sectionConnection,
                  onTap: () => push(
                    l.sectionConnection,
                    SettingsPage(
                      core: core,
                      settings: settings,
                      section: SettingsSection.connection,
                    ),
                  ),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.alt_route_rounded,
                  label: l.sectionRouting,
                  onTap: () => push(
                    l.sectionRouting,
                    SettingsPage(
                      core: core,
                      settings: settings,
                      section: SettingsSection.routing,
                    ),
                  ),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.dns_rounded,
                  label: l.sectionDns,
                  onTap: () => push(
                    l.sectionDns,
                    UrDnsPage(core: core, settings: settings),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Bypass: what helps when the way is blocked — the relays, the
          // TLS fragment, the proxy the traffic rides first.
          UrEntrance(index: 6, child: _SectionLabel(l.sectionBypass)),
          UrEntrance(
            index: 6,
            child: _Card(
              children: [
                _NavRow(
                  icon: Icons.cloud_outlined,
                  label: l.apiRelay,
                  onTap: () => push(
                    l.apiRelay,
                    SettingsPage(
                      core: core,
                      settings: settings,
                      section: SettingsSection.relay,
                    ),
                  ),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.content_cut_rounded,
                  label: l.tlsFragment,
                  onTap: () => push(
                    l.tlsFragment,
                    SettingsPage(
                      core: core,
                      settings: settings,
                      section: SettingsSection.fragment,
                    ),
                  ),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.lan_outlined,
                  label: l.upstreamProxy,
                  onTap: () => push(
                    l.upstreamProxy,
                    SettingsPage(
                      core: core,
                      settings: settings,
                      section: SettingsSection.upstreamProxy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Battery: the OEMs' battery killers — the one card that keeps
          // the tunnel alive after the screen locks.
          if (Platform.isAndroid) ...[
            UrEntrance(index: 7, child: _SectionLabel(l.batteryWizardTitle)),
            UrEntrance(index: 7, child: _BatteryCard()),
            const SizedBox(height: 32),
          ],

          // App: the usage, the logs, the version's story and the app's
          // own page.
          UrEntrance(index: 8, child: _SectionLabel(l.groupApp)),
          UrEntrance(
            index: 8,
            child: _Card(
              children: [
                if (Platform.isAndroid) ...[
                  _NavRow(
                    icon: Icons.pie_chart_rounded,
                    label: l.usageTitle,
                    value: l.usageRowHint,
                    onTap: () => push(l.usageTitle, const AppUsagePage()),
                  ),
                  _HairLine(),
                ],
                _NavRow(
                  icon: Icons.receipt_long_outlined,
                  label: l.navLogs,
                  onTap: () => push(l.navLogs, LogsPage(core: core)),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.new_releases_outlined,
                  label: l.urWhatsNew,
                  value: appVersion == '0.0.0' ? '' : appVersion,
                  onTap: whatsNewSections(l, appVersion).isEmpty
                      ? null
                      : () => showWhatsNew(context, settings),
                ),
                _HairLine(),
                _NavRow(
                  icon: Icons.system_update_rounded,
                  label: l.urAboutUpdates,
                  onTap: () => push(
                    l.navAbout,
                    AboutPage(core: core, settings: settings),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _languageName(String code, AppLocalizations l) {
    if (code.isEmpty) return l.languageSystem;
    return languageNames[code] ?? code;
  }

  /// The language sheet: the app's languages in their own names, the
  /// system first. A pick applies at once.
  Future<void> _pickLanguage(BuildContext context, AppSettings s) async {
    final l = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: ListenableBuilder(
          listenable: s,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.language, style: urTitleStyle(context).copyWith(fontSize: 18)),
                  const SizedBox(height: 12),
                  _LangTile(
                    label: l.languageSystem,
                    style: null,
                    selected: s.language.isEmpty,
                    onTap: () {
                      s.update(language: '');
                      Navigator.of(context).pop();
                    },
                  ),
                  for (final code in AppSettings.supportedLanguages)
                    _LangTile(
                      label: languageNames[code] ?? code,
                      style: languageStyle(code),
                      selected: s.language == code,
                      onTap: () {
                        s.update(language: code);
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LangTile extends StatelessWidget {
  const _LangTile({
    required this.label,
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final TextStyle? style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final on = selected;
    return UrPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: on ? UrTokens.bgTinted : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: on
                ? UrTokens.pink.withValues(alpha: 0.35)
                : UrTokens.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: (style ?? const TextStyle()).copyWith(
                  fontSize: 14.5,
                  color: UrTokens.ink,
                ),
              ),
            ),
            if (on)
              const Icon(Icons.check_rounded, size: 18, color: UrTokens.pink),
          ],
        ),
      ),
    );
  }
}

/// The section's twelve-point label, the original's muted ink.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: UrTokens.muted),
        ),
      );
}

/// The tinted card every section's rows sit in, the original's bgTinted at
/// twelve points of radius.
class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: UrTokens.bgTinted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: children),
      );
}

/// The hairline between two rows of one card.
class _HairLine extends StatelessWidget {
  const _HairLine();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: UrTokens.border);
}

/// One row that opens something: the icon in the muted ink, the label, the
/// trailing value, and the caret that says it opens.
class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return UrPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: UrTokens.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 14.5, color: UrTokens.ink),
              ),
            ),
            if (value != null && value!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, color: UrTokens.muted),
                ),
              ),
            ],
            if (onTap != null)
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: UrTokens.muted),
          ],
        ),
      ),
    );
  }
}

/// One switch row: the label (and its note) at the start, the app's own
/// switch at the end, its 48 dp touch target spacing the rows the way the
/// original's do.
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  label,
                  style:
                      const TextStyle(fontSize: 14.5, color: UrTokens.ink),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                        fontSize: 12, color: UrTokens.muted),
                  ),
                ],
                const SizedBox(height: 2),
              ],
            ),
          ),
          UrSwitch(
            checked: value,
            onToggle: () => onChanged?.call(!value),
          ),
        ],
      ),
    );
  }
}

/// One row that picks a value: the current choice's name at the end and a
/// tap that opens the app's own sheet with the options. [onChanged] null
/// reads as off — the row stands still without its caret.
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final T value;
  final List<(T, String)> options;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final current = options.firstWhere(
      (o) => o.$1 == value,
      orElse: () => (value, ''),
    );
    return _NavRow(
      icon: icon,
      label: title,
      value: current.$2,
      onTap: onChanged == null ? null : () => _pick(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: urTitleStyle(context).copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final (v, name) in options)
                  _LangTile(
                    label: name,
                    style: null,
                    selected: v == value,
                    onTap: () => Navigator.of(context).pop(v),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (picked != null) onChanged!(picked);
  }
}

/// The core's verbose logging: the flag lives in the core's own config,
/// read once at the page's arrival and written through the API — the same
/// walk the section pages take, nothing of the core's own touched.
class _VerboseRow extends StatefulWidget {
  const _VerboseRow({required this.core});

  final CoreController core;

  @override
  State<_VerboseRow> createState() => _VerboseRowState();
}

class _VerboseRowState extends State<_VerboseRow> {
  bool? _verbose;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await widget.core.settings();
      if (!mounted) return;
      final logging = config['logging'];
      setState(() {
        _verbose = logging is Map<String, Object?>
            ? logging['verbose'] == true
            : false;
      });
    } on Exception {
      if (!mounted) return;
      setState(() => _verbose = null);
    }
  }

  Future<void> _toggle(bool v) async {
    if (_saving) return;
    setState(() => _saving = true);
    final ok = await runShowingErrors(
      context,
      () => widget.core.editSettings((config) {
        final logging = switch (config['logging']) {
          final Map<String, Object?> m => m,
          _ => <String, Object?>{},
        };
        logging['verbose'] = v;
        config['logging'] = logging;
      }),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      await _load();
      if (mounted) {
        showToast(context, AppLocalizations.of(context).saved);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _SwitchRow(
      label: l.verboseLogging,
      subtitle: l.verboseLoggingHint,
      value: _verbose ?? false,
      onChanged: _verbose == null ? null : (v) => _toggle(v),
    );
  }
}

/// The greens and reds the design paints its states with — the battery
/// card's exemption mark and the warning beside it.
const _green = Color(0xFF31D70B);
const _red = Color(0xFFFF6C58);

/// The battery guide: the OEMs' battery killers — what state the system's
/// exemption stands in, and the two doors, the system's permit dialog and
/// the battery settings.
class _BatteryCard extends StatefulWidget {
  const _BatteryCard();

  @override
  State<_BatteryCard> createState() => _BatteryCardState();
}

class _BatteryCardState extends State<_BatteryCard> {
  bool? _ignored;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final ignored = await AndroidCore.batteryIgnored();
    if (!mounted) return;
    setState(() => _ignored = ignored);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ignored = _ignored;
    return Container(
      decoration: BoxDecoration(
        color: UrTokens.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.batteryWizardBody,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.35,
              color: UrTokens.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.batteryWizardSteps,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: UrTokens.muted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (ignored == true)
                const Icon(Icons.check_circle_rounded, size: 18, color: _green)
              else if (ignored == false)
                const Icon(Icons.warning_amber_rounded, size: 18, color: _red)
              else
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ignored == true ? l.batteryWizardOk : l.batteryWizardState,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: UrTokens.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (ignored != true)
                _PillButton(
                  fill: true,
                  icon: Icons.battery_saver_rounded,
                  label: l.batteryWizardPermit,
                  onTap: () async {
                    await AndroidCore.requestIgnoreBattery();
                    if (!mounted) return;
                    await Future<void>.delayed(
                      const Duration(milliseconds: 600),
                    );
                    _refresh();
                  },
                ),
              _PillButton(
                fill: false,
                icon: Icons.tune_rounded,
                label: l.batteryWizardOpen,
                onTap: AndroidCore.openBatterySettings,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The card's two actions: the filled pill for the permit, the hairline
/// outline for the system's settings — the app's own press under both.
class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.fill,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool fill;
  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return UrPressable(
      onTap: () => onTap(),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill ? UrTokens.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: fill ? null : Border.all(color: UrTokens.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: fill ? Colors.white : UrTokens.muted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fill ? Colors.white : UrTokens.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The session's traffic as the original's usage bar: one twelve-point bar
/// at six points of radius, the send in the blue and the receive in the
/// faint ink, each share never smaller than one and a half percent so a
/// one-sided session still reads.
class UrUsageCard extends StatelessWidget {
  const UrUsageCard({super.key, required this.up, required this.down});

  final int up;
  final int down;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final total = up + down;
    // the 1.5 percent floor the original inflates a small share with
    double share(int bytes) =>
        total <= 0 ? 0 : (bytes / total).clamp(0.015, 1.0).toDouble();
    final upShare = share(up);
    final downShare = share(down);
    final sum = upShare + downShare;

    return Container(
      decoration: BoxDecoration(
        color: UrTokens.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.urUsageTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: UrTokens.muted,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(
                    flex: (upShare / sum * 1000).round().clamp(1, 1000).toInt(),
                    child: ColoredBox(color: UrTokens.blue),
                  ),
                  Expanded(
                    flex: (downShare / sum * 1000).round().clamp(1, 1000).toInt(),
                    child:
                        ColoredBox(color: UrTokens.faint.withValues(alpha: 0.55)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _legendDot(UrTokens.blue),
              const SizedBox(width: 6),
              Text('${l.urSpeedUp} ${formatBytes(up)}',
                  style: const TextStyle(
                      fontSize: 12.5, color: UrTokens.muted)),
              const SizedBox(width: 14),
              _legendDot(UrTokens.faint),
              const SizedBox(width: 6),
              Text('${l.urSpeedDown} ${formatBytes(down)}',
                  style: const TextStyle(
                      fontSize: 12.5, color: UrTokens.muted)),
              const Spacer(),
              Text(l.urUsageTotal,
                  style: const TextStyle(
                      fontSize: 12.5, color: UrTokens.faint)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
