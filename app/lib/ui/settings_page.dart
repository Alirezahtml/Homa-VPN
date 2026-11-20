import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_api.dart';
import '../core/core_controller.dart';
import '../core/models.dart';
import '../core/ports.dart';
import '../core/tun_service.dart';
import '../desktop/desktop_bridge.dart';
import '../l10n/app_localizations.dart';
import '../platform.dart';
import 'accent.dart';
import 'app_usage_page.dart';
import 'bypass_apps_page.dart';
import 'connection_mode.dart';
import '../core/diagnostics.dart';
import 'design.dart';
import 'design_style.dart';
import 'format.dart';
import 'motion.dart';
import 'port_dialog.dart';
import 'relay_test_dialog.dart';
import 'widgets.dart';
import 'world_map.dart' show GlobePalette, GlobeStyle, MapKind;

/// The makers' social row and the rest of the page: this file's own state.

/// The program file the user picks in the system's open dialog (title, the
/// kind of file); tests replace it.
Future<String?> Function(String title, String label) pickProgramFile = (
  title,
  label,
) => DesktopBridge.pickProgram(title: title, label: label);

/// The DNS presets the web dashboard offers (core/internal/service/web/app.js).
const _dnsPresets = <String, List<String>>{
  'system': [],
  'auto': [
    'https://1.1.1.1/dns-query',
    'https://8.8.8.8/dns-query',
    'https://9.9.9.9/dns-query',
  ],
  'cloudflare': ['https://1.1.1.1/dns-query', 'https://1.0.0.1/dns-query'],
  'google': ['https://8.8.8.8/dns-query', 'https://8.8.4.4/dns-query'],
  'quad9': ['https://9.9.9.9/dns-query', 'https://149.112.112.112/dns-query'],
  'cloudflare_dot': ['tls://1.1.1.1', 'tls://1.0.0.1'],
};

/// The host part of a DoT line (tls://host): a server name.
final RegExp _dnsHostRe = RegExp(
  r'^[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?$',
);

/// The app's preferences and the core's settings (config.json, edited
/// through the API so that every field the app does not show is kept).
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.core,
    required this.settings,
    this.section,
    this.opening,
    this.onOpenLogs,
  });

  final CoreController core;
  final AppSettings settings;

  /// Opens the logs, which the computer's side menu has too: a row beside
  /// Advanced, which would otherwise stand alone.
  final VoidCallback? onOpenLogs;

  /// The section open at first, with the way back to the list (the
  /// computer's home page opens Connection).
  final SettingsSection? opening;

  /// Shows only this section, on a page of its own (Android's settings).
  final SettingsSection? section;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// The groups of settings, each on its own page.
enum SettingsSection {
  general,
  appearance,
  connection,
  relay,
  upstreamProxy,
  fragment,
  dns,
  routing,
  tun,
  advanced,
}

/// A section's icon and name.
typedef SettingsEntry = (SettingsSection, IconData, String);

/// The sections in the order a computer's list shows them, by group with its
/// title; TUN settings where the computer has the TUN mode ([tun]). Servers,
/// accounts, logs, and About are in the side menu there; the phone's list has
/// them among these groups.
List<(String, List<SettingsEntry>)> settingsGroups(
  AppLocalizations l, {
  bool tun = false,
}) => [
  (
    l.sectionGeneral,
    [
      (SettingsSection.general, Icons.tune_rounded, l.sectionGeneral),
      (
        SettingsSection.appearance,
        Icons.palette_rounded,
        l.sectionAppearance,
      ),
      (SettingsSection.connection, Icons.computer_rounded, l.sectionConnection),
      (SettingsSection.routing, Icons.alt_route_rounded, l.sectionRouting),
      (SettingsSection.dns, Icons.dns_rounded, l.sectionDns),
      if (tun) (SettingsSection.tun, Icons.vpn_lock_rounded, l.sectionTun),
    ],
  ),
  (
    l.sectionBypass,
    [
      (SettingsSection.relay, Icons.cloud_outlined, l.apiRelay),
      (SettingsSection.fragment, Icons.content_cut_rounded, l.tlsFragment),
      (SettingsSection.upstreamProxy, Icons.lan_outlined, l.upstreamProxy),
    ],
  ),
  // The app's port and the web dashboard: computers only.
  if (!Platform.isAndroid)
    (
      l.groupApp,
      [(SettingsSection.advanced, Icons.build_outlined, l.sectionAdvanced)],
    ),
];

/// A group in a list of settings: its title over a card of its rows.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The design's card, as the Panel wears it: flat and bordered — or
    // the design's own table: the aether's iOS group (tighter round, the
    // hairline inset divider), the zed's very-round bento card, the
    // gazette's ruled paper box, the pixel's big filled tonal card.
    final style = DesignStyle.of(context);
    final look = AppDesign.current.look(
      theme.brightness == Brightness.dark,
    );
    final iosTable = style.group == GroupVariant.iosTable;
    final gazetteRules = style.group == GroupVariant.gazetteRules;
    final m3Card = style.group == GroupVariant.m3Card;
    Widget card = Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      // The pixel's filled card carries the tonal surface instead of the
      // page's card color — the shape speaks, not the line; the gazette's
      // ruled box keeps no fill at all (the rules carry it), so the page's
      // own paper shows through.
      color: m3Card ? look.containerHighest : (gazetteRules ? null : look.surface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(style.cardRadius),
        side: look.cardShadow.isEmpty
            ? (m3Card
                  ? BorderSide.none
                  : BorderSide(
                      color: gazetteRules
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.85)
                          : theme.colorScheme.outlineVariant.withValues(
                              alpha: iosTable ? 0.35 : 0.5,
                            ),
                      width: gazetteRules ? 1.1 : 1,
                    ))
            : BorderSide.none,
      ),
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            // The line stops where the row's text starts (the icon
            // badge plus the row's own padding) — the iOS table's own
            // hairline, thinner than the flat card's. The pixel's filled
            // card parts its rows with the faintest of lines — the big
            // shape carries the grouping, not the rules.
            if (i > 0)
              Divider(
                height: 1,
                thickness: iosTable ? 0.5 : (m3Card ? 0.5 : 1),
                indent: iosTable ? 58 : 68,
                color: m3Card
                    ? theme.colorScheme.outlineVariant.withValues(alpha: 0.25)
                    : null,
              ),
            // Each tile arrives a beat after the one above it.
            Reveal(index: i, child: tiles[i]),
          ],
        ],
      ),
    );
    if (look.cardShadow.isNotEmpty) {
      card = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(style.cardRadius),
          boxShadow: look.cardShadow,
        ),
        child: card,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 20, 8, 8),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        card,
      ],
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  /// The section shown; null for the list of sections.
  late SettingsSection? _open = widget.section ?? widget.opening;

  /// The core's config.json as raw JSON; null until read.
  Map<String, Object?>? _config;
  bool _saving = false;
  String? _dnsPreset;

  CoreController get _core => widget.core;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await _core.settings();
      if (mounted) setState(() => _config = config);
    } on CoreApiException catch (e) {
      if (mounted) showError(context, e.message);
    } on CoreUnavailable {
      // The shell shows the problem.
    }
  }

  /// A value at [path] in the config, such as ['proxy', 'transport'].
  Object? _get(List<String> path) {
    Object? node = _config;
    for (final key in path) {
      if (node is! Map<String, Object?>) return null;
      node = node[key];
    }
    return node;
  }

  String _str(List<String> path) => _get(path) as String? ?? '';

  bool _bool(List<String> path) => _get(path) == true;

  /// A whole number at [path]: the config's ints come back as `int` (the
  /// core's JSON), but a tolerant read keeps a stray double from raising.
  int _int(List<String> path) => switch (_get(path)) {
    final num n => n.toInt(),
    _ => 0,
  };

  List<String> _list(List<String> path) => [
    for (final v in (_get(path) as List<Object?>? ?? const [])) '$v',
  ];

  /// Saves [values] (path → value) through the core and reads the config
  /// again; true when the core accepted it.
  Future<bool> _save(Map<List<String>, Object?> values) async {
    setState(() => _saving = true);
    final ok = await runShowingErrors(
      context,
      () => _core.editSettings((config) {
        values.forEach((path, value) {
          var node = config;
          for (final key in path.take(path.length - 1)) {
            node = switch (node[key]) {
              final Map<String, Object?> m => m,
              _ => node[key] = <String, Object?>{},
            };
          }
          node[path.last] = value;
        });
      }),
    );
    if (!mounted) return ok;
    setState(() => _saving = false);
    if (ok) {
      await _load();
      if (mounted) _toast(AppLocalizations.of(context).saved);
    }
    return ok;
  }

  /// The confirmation lands as the iOS-style note (widgets.dart), not a
  /// snack bar: a soft pill with a mark that draws itself.
  void _toast(String text) => showToast(context, text);

  /// Removes the TUN service; in TUN mode the core first goes back to proxy
  /// only, so the computer is not left without its connection mode.
  Future<void> _removeTunService() async {
    final l = AppLocalizations.of(context);
    if (_core.status?.tunMode ?? false) {
      if (!await runShowingErrors(
        context,
        () => _core.setSystemProxy('clear'),
      )) {
        return;
      }
    }
    final result = await _core.removeTunService(prompt: l.tunRemovePrompt);
    if (!mounted) return;
    switch (result) {
      case TunServiceDone():
        showError(context, l.tunServiceRemoved);
      case TunServiceCancelled():
        break;
      case TunServiceFailed(:final error):
        showError(context, l.tunRemoveFailed(error));
    }
  }

  Future<void> _changePort(
    String listen,
    Future<void> Function(int port) apply,
  ) async {
    final port = await showPortDialog(context, current: listen);
    if (port == null || !mounted) return;
    final ok = await runShowingErrors(context, () => apply(port));
    if (!mounted || !ok) return;
    // A moved API answers at its new address after a moment.
    await Future<void>.delayed(const Duration(seconds: 1));
    await _load();
    if (mounted) _toast(AppLocalizations.of(context).saved);
  }

  /// Android changes only the UI language. Desktop also offers the routing
  /// most of its speakers want (Persian: Iran, Chinese: China, Russian: Russia).
  Future<void> _pickLanguage(String language) async {
    widget.settings.update(language: language);
    if (Platform.isAndroid) return;
    final region = AppSettings.regionForLanguage(language);
    if (region == null ||
        (_bool(['routing', 'enabled']) &&
            _str(['routing', 'region']) == region)) {
      return;
    }
    // Let the page rebuild in the new language first.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    final country = regionName(l, region);
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.alt_route_rounded),
        title: Text(l.routingSuggestTitle(country)),
        content: SizedBox(
          width: 380,
          child: Text(l.routingSuggestBody(country)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.yes),
          ),
        ],
      ),
    );
    if (yes == true && mounted) {
      await _save({
        ['routing', 'enabled']: true,
        ['routing', 'region']: region,
      });
    }
  }

  /// The TUN settings have something to show: the programs that skip the
  /// VPN (Windows and Linux).
  bool get _hasTunSection {
    final status = _core.status;
    return (status?.tunSupported ?? false) &&
        (status?.tun?.programsSupported ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = widget.settings;
    final groups = settingsGroups(l, tun: _hasTunSection);
    final sections = [for (final group in groups) ...group.$2];
    // A page of its own shows its section. The TUN mode went away (another
    // core): back to the list.
    final open =
        widget.section ?? (sections.any((e) => e.$1 == _open) ? _open : null);
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) {
        if (open == null) {
          final onOpenLogs = widget.onOpenLogs;
          Widget row(IconData icon, String name, VoidCallback onTap) =>
              ListTile(
                leading: IconBox(icon: icon),
                title: Text(name),
                // Mirrors itself in right-to-left languages.
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: onTap,
              );
          return ListView(
            padding: pagePadding(context),
            children: [
              PageTitle(l.settingsTitle),
              for (final (title, entries) in groups)
                SettingsGroup(
                  title: title,
                  tiles: [
                    for (final (section, icon, name) in entries)
                      row(icon, name, () => setState(() => _open = section)),
                    if (onOpenLogs != null &&
                        entries.last.$1 == SettingsSection.advanced)
                      row(Icons.receipt_long_outlined, l.navLogs, onOpenLogs),
                  ],
                ),
            ],
          );
        }
        final fixed = widget.section != null;
        // A page of its own has the title in its top bar.
        final title = fixed ? '' : sections.firstWhere((e) => e.$1 == open).$3;
        final page = ListView(
          padding: fixed
              ? pagePadding(context)
              : const EdgeInsets.fromLTRB(20, 16, 28, 28),
          children: [
            if (!fixed)
              Row(
                children: [
                  IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                    icon: const BackButtonIcon(),
                    onPressed: () => setState(() => _open = null),
                  ),
                  const SizedBox(width: 4),
                  Text(title, style: theme.textTheme.headlineSmall),
                ],
              ),
            if (!fixed) const SizedBox(height: 16),
            if (open == SettingsSection.general)
              _general(l, s)
            else if (open == SettingsSection.appearance)
              _appearance(l, s)
            else if (_config == null)
              const LinearProgressIndicator()
            else
              switch (open) {
                SettingsSection.connection => _connection(l),
                SettingsSection.relay => _bypass(l),
                SettingsSection.upstreamProxy => _upstreamProxy(l),
                SettingsSection.fragment => _fragment(l),
                SettingsSection.routing => _routing(l),
                SettingsSection.tun => _tun(l),
                SettingsSection.dns => _dns(l),
                _ => _advanced(l),
              },
          ],
        );
        if (fixed) return page;
        // Esc goes back to the list of sections, like the back arrow.
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () =>
                setState(() => _open = null),
          },
          child: Focus(autofocus: true, child: page),
        );
      },
    );
  }

  Widget _general(AppLocalizations l, AppSettings s) => Panel(
    title: l.sectionGeneral,
    icon: Icons.tune_rounded,
    child: Column(
      children: [
        _Choice<String>(
          icon: Icons.translate_rounded,
          title: l.language,
          value: s.language,
          onChanged: _pickLanguage,
          options: [
            ('', l.languageSystem, null),
            for (final code in AppSettings.supportedLanguages)
              (code, languageNames[code]!, languageStyle(code)),
          ],
        ),
        _Choice<ThemeMode>(
          icon: Icons.brightness_6_outlined,
          title: l.theme,
          value: s.themeMode,
          onChanged: (v) => s.update(themeMode: v),
          options: [
            (ThemeMode.system, l.themeSystem, null),
            (ThemeMode.light, l.themeLight, null),
            (ThemeMode.dark, l.themeDark, null),
          ],
        ),
        // The one personalization the design keeps: the accent behind the
        // app's lights, monochrome by default. The surfaces never change.
        _Row(
          icon: Icons.palette_outlined,
          label: l.accentColor,
          value: accentName(context, s),
          child: _AccentSwatch(settings: s),
          onTap: () => showAccentPicker(context, s),
        ),
        // The home page's own design: the wheel, the tiles, or the
        // compact card — each a real layout, each with the real list and
        // the real switch. The choice holds across starts.
        _Row(
          icon: Icons.dashboard_outlined,
          label: l.designTitle,
          value: designName(l, s),
          child: const Icon(Icons.chevron_right_rounded),
          onTap: () => showDesignPicker(context, s),
        ),
        if (!Platform.isAndroid)
          _Choice<CloseAction>(
            icon: Icons.close_rounded,
            title: l.closeBehavior,
            value: s.closeAction,
            onChanged: (v) => s.update(closeAction: v),
            options: [
              (CloseAction.ask, l.closeAsk, null),
              (CloseAction.tray, l.closeTray, null),
              (CloseAction.quit, l.closeQuit, null),
            ],
          ),
        _Row(
          icon: Icons.visibility_outlined,
          label: l.showPublicIp,
          child: AppSwitch(
            value: s.showPublicIp,
            onChanged: (v) => s.update(showPublicIp: v),
          ),
        ),
        // A short vibration when the connection goes on or off.
        _Row(
          icon: Icons.vibration_rounded,
          label: l.hapticFeedback,
          child: AppSwitch(
            value: s.hapticFeedback,
            onChanged: (v) => s.update(hapticFeedback: v),
          ),
        ),
        // A short sound on the same turns — the ear's own confirmation,
        // for the phone out of sight.
        _Row(
          icon: Icons.music_note_outlined,
          label: l.soundFeedback,
          value: l.soundFeedbackHint,
          child: AppSwitch(
            value: s.soundFeedback,
            onChanged: (v) => s.update(soundFeedback: v),
          ),
        ),
        // The live rates' unit: bytes (KB/s) or bits (Mbps).
        _Choice<bool>(
          icon: Icons.numbers_rounded,
          title: l.rateUnit,
          value: s.rateBits,
          onChanged: (v) => s.update(rateBits: v),
          options: [(false, 'KB/s', null), (true, 'Mbps', null)],
        ),
        // The lock's own caretaker: with a password standing, the app can
        // ask for it again after a while away. Hidden until a lock stands.
        if (s.lockHash.isNotEmpty)
          _Choice<int>(
            icon: Icons.lock_clock_rounded,
            title: l.lockInBackground,
            value: s.lockBackgroundMin,
            onChanged: (v) => s.update(lockBackgroundMin: v),
            options: [
              (0, l.lockBgNever, null),
              (1, l.lockBgNow, null),
              (5, l.lockBgMin5, null),
              (15, l.lockBgMin15, null),
            ],
          ),
        // The screen stays awake while the VPN carries the traffic.
        if (Platform.isAndroid)
          _Row(
            icon: Icons.screen_lock_portrait_rounded,
            label: l.keepScreenOn,
            child: AppSwitch(
              value: s.keepScreenOn,
              onChanged: (v) => s.update(keepScreenOn: v),
            ),
          ),
        // The home page's live traffic cards.
        _Row(
          icon: Icons.swap_vert_rounded,
          label: l.showTraffic,
          child: AppSwitch(
            value: s.showTraffic,
            onChanged: (v) => s.update(showTraffic: v),
          ),
        ),
        if (Platform.isAndroid)
          ValueListenableBuilder(
            valueListenable: AndroidCore.showSpeed,
            builder: (context, on, _) => _Row(
              icon: Icons.speed_rounded,
              label: l.speedInNotification,
              child: AppSwitch(
                value: on,
                onChanged: (v) => runShowingErrors(
                  context,
                  () => AndroidCore.setShowSpeed(v),
                ),
              ),
            ),
          ),
        // The notification's country flag: the country's own SVG flag as
        // the card's art — off leaves the name alone.
        if (Platform.isAndroid)
          ValueListenableBuilder(
            valueListenable: AndroidCore.notifFlag,
            builder: (context, on, _) => _Row(
              icon: Icons.flag_outlined,
              label: l.notifFlag,
              value: l.notifFlagHint,
              child: AppSwitch(
                value: on,
                onChanged: (v) => runShowingErrors(
                  context,
                  () => AndroidCore.setNotifFlag(v),
                ),
              ),
            ),
          ),
        // A phone updates itself: the newer version downloads in the
        // background, and the system's installer asks before it installs.
        if (Platform.isAndroid) ...[
          _Row(
            icon: Icons.system_update_rounded,
            label: l.autoInstallApk,
            value: l.autoInstallApkHint,
            child: AppSwitch(
              value: s.autoInstallApk,
              onChanged: (v) => s.update(autoInstallApk: v),
            ),
          ),
          // Connect when the phone starts (the BootReceiver): the VPN
          // permission must already be granted, which a first connect does.
          ValueListenableBuilder(
            valueListenable: AndroidCore.autoConnectBoot,
            builder: (context, on, _) => _Row(
              icon: Icons.restart_alt_rounded,
              label: l.connectAtBoot,
              value: l.connectAtBootHint,
              child: AppSwitch(
                value: on,
                onChanged: (v) => runShowingErrors(
                  context,
                  () => AndroidCore.setAutoConnectBoot(v),
                ),
              ),
            ),
          ),
          // Connect when the app itself opens: the VPN comes up as the
          // home page does, with the location last chosen.
          _Row(
            icon: Icons.flash_on_rounded,
            label: l.connectOnOpen,
            value: l.connectOnOpenHint,
            child: AppSwitch(
              value: s.connectOnOpen,
              onChanged: (v) => s.update(connectOnOpen: v),
            ),
          ),
        ],
        // Gaming: the connection's real delay and quality at a glance, and
        // the notification's live speed; it promises nothing about ping.
        _Row(
          icon: Icons.sports_esports_rounded,
          label: l.gamingProfile,
          value: l.gamingProfileHint,
          child: AppSwitch(
            value: s.gamingProfile,
            onChanged: (v) {
              s.update(gamingProfile: v);
              if (v && Platform.isAndroid && !AndroidCore.showSpeed.value) {
                runShowingErrors(
                  context,
                  () => AndroidCore.setShowSpeed(true),
                );
              }
            },
          ),
        ),
        _Row(
          icon: Icons.healing_rounded,
          label: l.diagnosticsRun,
          value: l.diagnosticsHint,
          child: IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () => showDiagnostics(context, widget.core),
          ),
        ),
        // The log's own detail: every step written down, for a report to
        // read. Real — the core's verbose flag, read live — and a little
        // heavier on the battery while it stays on.
        _Row(
          icon: Icons.bug_report_outlined,
          label: l.verboseLogging,
          value: l.verboseLoggingHint,
          child: AppSwitch(
            value: _bool(['logging', 'verbose']),
            onChanged: _saving
                ? null
                : (v) => _save({
                    ['logging', 'verbose']: v,
                  }),
          ),
        ),
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          _Row(
            icon: Icons.power_settings_new_rounded,
            label: l.startOnBoot,
            child: AppSwitch(
              value: s.autostart,
              onChanged: (v) => s.update(autostart: v),
            ),
          ),
        // Only with the start at sign-in: dimmed without it.
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          Opacity(
            opacity: s.autostart ? 1 : 0.5,
            child: _Row(
              icon: Icons.link_rounded,
              label: l.connectOnStartup,
              child: AppSwitch(
                value: s.autoConnect,
                onChanged: s.autostart ? (v) => s.update(autoConnect: v) : null,
              ),
            ),
          ),
        // The caretaker: it follows the switches below and only them.
        _Row(
          icon: Icons.auto_mode_rounded,
          label: l.autoReconnect,
          value: Platform.isAndroid ? l.autoReconnectHint : l.androidOnlyHint,
          child: AppSwitch(
            value: Platform.isAndroid && s.autoReconnect,
            onChanged: Platform.isAndroid
                ? (v) => s.update(autoReconnect: v)
                : null,
          ),
        ),
        _Row(
          icon: Icons.hourglass_empty_rounded,
          label: l.idleDisconnect,
          value: l.idleDisconnectHint,
          child: AppSwitch(
            value: s.idleDisconnect,
            onChanged: (v) => s.update(idleDisconnect: v),
          ),
        ),
        // The wait before the idle hang-up: dimmed while it is off.
        Opacity(
          opacity: s.idleDisconnect ? 1 : 0.5,
          child: _Choice<int>(
            icon: Icons.timer_outlined,
            title: l.idleTimeout,
            value: s.idleTimeoutMin,
            onChanged: s.idleDisconnect
                ? (v) => s.update(idleTimeoutMin: v)
                : null,
            options: [
              (5, l.minutes5, null),
              (10, l.minutes10, null),
              (15, l.minutes15, null),
              (30, l.minutes30, null),
              (60, l.minutes60, null),
            ],
          ),
        ),
        _Row(
          icon: Icons.data_saver_off_rounded,
          label: l.dataLimit,
          value: l.dataLimitHint,
          child: AppSwitch(
            value: s.dataLimit,
            onChanged: (v) => s.update(dataLimit: v),
          ),
        ),
        // The session's data budget: dimmed while it is off.
        Opacity(
          opacity: s.dataLimit ? 1 : 0.5,
          child: _Choice<int>(
            icon: Icons.save_alt_rounded,
            title: l.dataLimitAmount,
            value: s.dataLimitMb,
            onChanged: s.dataLimit ? (v) => s.update(dataLimitMb: v) : null,
            options: [
              (256, l.mb256, null),
              (512, l.mb512, null),
              (1024, l.mb1024, null),
              (2048, l.mb2048, null),
              (5120, l.mb5120, null),
              (10240, l.mb10240, null),
              (25600, l.mb25600, null),
              (51200, l.mb51200, null),
              (102400, l.mb102400, null),
            ],
          ),
        ),
      ],
    ),
  );

  /// The home's look: the map's own kinds (the flat map as it always
  /// was, its modern finish, the metal ball), the ball's styles, and
  /// the battery saver that puts the map's motion to rest while the
  /// connection stays as it is.
  Widget _appearance(AppLocalizations l, AppSettings s) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Panel(
        title: l.mapKind,
        icon: Icons.map_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.mapKindHint, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final kind in MapKind.values)
                  _MapKindTile(
                    kind: kind,
                    name: mapKindName(l, kind),
                    dark: Theme.of(context).brightness == Brightness.dark,
                    selected: s.mapKind == kind.name,
                    onTap: () => s.update(mapKind: kind.name),
                  ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Panel(
        title: l.mapStyle,
        icon: Icons.public_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.mapStyleGlobeHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 14,
              children: [
                for (final style in GlobeStyle.values)
                  _GlobeStyleTile(
                    style: style,
                    name: mapStyleName(l, style),
                    dark: Theme.of(context).brightness == Brightness.dark,
                    selected: s.mapStyle == style.name,
                    onTap: () => s.update(mapStyle: style.name),
                  ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Panel(
        title: l.batterySaver,
        icon: Icons.battery_saver_rounded,
        child: _Row(
          icon: Icons.motion_photos_paused_rounded,
          label: l.batterySaver,
          value: l.batterySaverHint,
          child: AppSwitch(
            value: s.batterySaver,
            onChanged: (v) => s.update(batterySaver: v),
          ),
        ),
      ),
      if (Platform.isAndroid) ...[
        const SizedBox(height: 12),
        // The OEMs' battery killers: the one panel that keeps the tunnel
        // alive after the screen locks.
        Panel(
          title: l.batteryWizardTitle,
          icon: Icons.battery_alert_rounded,
          child: const _BatteryWizard(),
        ),
        const SizedBox(height: 12),
        Panel(
          title: l.usageTitle,
          icon: Icons.pie_chart_rounded,
          child: _Row(
            icon: Icons.apps_rounded,
            label: l.usageTitle,
            value: l.usageRowHint,
            child: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AppUsagePage(),
              ),
            ),
          ),
        ),
      ],
    ],
  );

  Widget _connection(AppLocalizations l) {
    final status = _core.status;
    final proxyListen = _str(['proxy', 'listen']);
    final port = portOf(proxyListen) ?? 10810;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Under no condition may the traffic slip past the VPN: the kill
        // switch holds it when the path breaks, and Android's own
        // always-on guard blocks everything without the VPN.
        if (Platform.isAndroid) ...[
          Panel(
            title: l.protection,
            icon: Icons.shield_outlined,
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: AndroidCore.killSwitch,
                  builder: (context, on, _) => Column(
                    children: [
                      _Row(
                        icon: Icons.gpp_good_outlined,
                        label: l.killSwitch,
                        value: l.killSwitchHint,
                        child: AppSwitch(
                          value: on,
                          onChanged: (v) => runShowingErrors(
                            context,
                            () => AndroidCore.setKillSwitch(v),
                          ),
                        ),
                      ),
                      // The guard's own word while it stands: what the
                      // switch actually holds back, in one line.
                      AnimatedSize(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        child: on
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.verified_outlined,
                                      size: 15,
                                      color: StatusColors.good,
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        l.killSwitchGuarded,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                _Row(
                  icon: Icons.verified_user_outlined,
                  label: l.alwaysOnVpn,
                  value: l.alwaysOnVpnHint,
                  child: const Icon(
                    Icons.open_in_new_rounded,
                    size: 20,
                  ),
                  onTap: () => AndroidCore.openVpnSettings(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        // How the app reaches Mozilla.
        Panel(
          title: l.sectionConnection,
          icon: Icons.cloud_outlined,
          child: Column(
            children: [
              // The location, measured: the core starts on the server its
              // own latency test says is fastest (proxy.country "fastest"),
              // and the wheel and the servers page read the choice back.
              // Off, the recommended location stands as it always did.
              _Row(
                icon: Icons.travel_explore_rounded,
                label: l.smartLocation,
                value: l.smartLocationHint,
                child: AppSwitch(
                  value: _str(['proxy', 'country']) == 'fastest',
                  onChanged: _saving
                      ? null
                      : (v) => _save({
                          ['proxy', 'country']: v ? 'fastest' : '',
                        }),
                ),
              ),
              // Apps' own QUIC rides the tunnel too: one less thing to
              // think about for calls and games.
              _Row(
                icon: Icons.bolt_rounded,
                label: l.quicPass,
                value: l.quicPassHint,
                child: AppSwitch(
                  value: _bool(['tun', 'quic']),
                  onChanged: _saving
                      ? null
                      : (v) => _save({['tun', 'quic']: v}),
                ),
              ),
              _Choice<String>(
                icon: Icons.http_rounded,
                title: l.transport,
                value: switch (_str(['proxy', 'transport'])) {
                  'h3' => 'h3',
                  'h1' => 'h1',
                  _ => 'h2',
                },
                onChanged: _saving
                    ? null
                    : (v) => _save({
                        ['proxy', 'transport']: v,
                      }),
                // In the order of the protocols; HTTP/2 stays the default.
                options: [
                  // A TLS connection per site connection: for networks
                  // that slow or cut long connections.
                  ('h1', l.transportH1, null),
                  ('h2', l.transportH2, null),
                  ('h3', l.transportH3, null),
                ],
              ),
              // The connection to Mozilla's servers alone: the sign-in and
              // the DNS keep their own way.
              _Choice<String>(
                icon: Icons.lan_outlined,
                title: l.ipVersion,
                value: switch (_str(['proxy', 'ip_version'])) {
                  final v
                      when const [
                        'dual',
                        'ipv6_first',
                        'ipv4',
                        'ipv6',
                      ].contains(v) =>
                    v,
                  _ => 'auto',
                },
                onChanged: _saving
                    ? null
                    : (v) => _save({
                        ['proxy', 'ip_version']: v,
                      }),
                options: [
                  ('auto', l.ipVersionAuto, null),
                  ('dual', l.ipVersionDual, null),
                  ('ipv6_first', l.ipVersionV6First, null),
                  ('ipv4', l.ipVersionV4, null),
                  ('ipv6', l.ipVersionV6, null),
                ],
              ),
              // tun.mtu: the VPN interface's MTU (the phone's VPN, the
              // computer's TUN); empty keeps each one's own.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: _TextSetting(
                  label: l.tunMtu,
                  hint: l.tunMtuHint,
                  // Unset, the field shows this device's own MTU: the
                  // phone's VPN 1500, the computer's TUN 9000.
                  value: switch (_get(['tun', 'mtu'])) {
                    final num n when n > 0 => '${n.toInt()}',
                    _ => Platform.isAndroid ? '1500' : '9000',
                  },
                  validator: (v) {
                    final n = int.tryParse(v.trim());
                    return v.trim().isEmpty ||
                            (n != null && n >= 1280 && n <= 9000)
                        ? null
                        : l.tunMtuInvalid;
                  },
                  onSave: (v) => _save({
                    ['tun', 'mtu']: int.tryParse(v.trim()) ?? 0,
                  }),
                ),
              ),
              // The phone never sleeps (the core turns it off there).
              if (!Platform.isAndroid) _sleepChoice(l),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // The speed's own panel: how the tunnel carries the traffic.
        // The parallel tunnels are the core's real pool — several
        // sessions to Mozilla at once, the traffic split between them —
        // and the connection limit keeps one busy app from carrying the
        // whole phone through the VPN. Both are numbers the core reads
        // live; nothing here is a promise.
        Panel(
          title: l.speedTitle,
          icon: Icons.speed_rounded,
          child: Column(
            children: [
              _Choice<int>(
                icon: Icons.multiple_stop_rounded,
                title: l.parallelTunnels,
                value: switch (_int(['proxy', 'upstream_connections'])) {
                  2 => 2,
                  4 => 4,
                  8 => 8,
                  _ => 1,
                },
                onChanged: _saving
                    ? null
                    : (v) => _save({
                        ['proxy', 'upstream_connections']: v,
                      }),
                options: [
                  (1, l.tunnels1, null),
                  (2, l.tunnels2, null),
                  (4, l.tunnels4, null),
                  (8, l.tunnels8, null),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l.parallelTunnelsHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              _Choice<int>(
                icon: Icons.device_hub_rounded,
                title: l.connectionCap,
                value: switch (_int(['proxy', 'max_connections'])) {
                  128 => 128,
                  512 => 512,
                  1024 => 1024,
                  0 => 0,
                  _ => 256,
                },
                onChanged: _saving
                    ? null
                    : (v) => _save({
                        ['proxy', 'max_connections']: v,
                      }),
                options: [
                  (0, l.capNone, null),
                  (128, '128', null),
                  (256, '256', null),
                  (512, '512', null),
                  (1024, '1024', null),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l.connectionCapHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              // Apps' own QUIC (UDP to port 443) rides the tunnel instead
              // of being refused: a call or a game keeps its UDP speed
              // instead of falling back to TCP. A real pass of the core's
              // TUN settings, off until asked for.
              _Row(
                icon: Icons.bolt_rounded,
                label: l.quicPass,
                value: l.quicPassHint,
                child: AppSwitch(
                  value: _bool(['tun', 'quic']),
                  onChanged: _saving
                      ? null
                      : (v) => _save({['tun', 'quic']: v}),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Where apps on this device (and the network) connect.
        Panel(
          title: l.localProxy,
          icon: Icons.computer_rounded,
          child: Column(
            children: [
              if (Platform.isAndroid)
                ValueListenableBuilder(
                  valueListenable: AndroidCore.mode,
                  builder: (context, mode, _) => _Choice<String>(
                    icon: Icons.vpn_lock_outlined,
                    title: l.connectionMode,
                    value: mode,
                    onChanged: (v) =>
                        runShowingErrors(context, () => AndroidCore.setMode(v)),
                    options: [
                      ('vpn', l.modeVpn, null),
                      ('proxy', l.modeProxyOnly, null),
                    ],
                  ),
                ),
              // Proxy only, and what else this computer has: a desktop
              // without a system proxy setting may still have TUN.
              if (status != null &&
                  (status.systemProxySupported || status.tunSupported))
                _Choice<String>(
                  icon: Icons.tune_rounded,
                  title: l.connectionMode,
                  value: connectionModeShown(status),
                  onChanged: _core.installingTun
                      ? null
                      : (v) => chooseConnectionMode(context, _core, v),
                  options: [
                    ('clear', l.modeProxy, null),
                    if (status.systemProxySupported)
                      ('set', l.systemProxy, null),
                    if (status.tunSupported) ('tun', l.modeTun, null),
                  ],
                ),
              _PortRow(
                icon: Icons.call_split_rounded,
                label: l.proxyPort,
                listen: proxyListen,
                onChange: () => _changePort(proxyListen, _core.setProxyPort),
              ),
              // Who may connect: this device only, or other devices too (all
              // interfaces). A login is optional either way; the core warns
              // in its log when the proxy is open to the network without one.
              _Choice<bool>(
                icon: Icons.share_outlined,
                title: l.listenAddress,
                value: sharedWithLan(proxyListen),
                onChanged: _saving
                    ? null
                    : (all) => _save({
                        ['proxy', 'listen']: all
                            ? '0.0.0.0:$port'
                            : '127.0.0.1:$port',
                      }),
                options: [
                  (false, l.listenLocal, null),
                  (true, l.listenAll, null),
                ],
              ),
              _Expand(
                icon: Icons.key_outlined,
                title: l.proxyLogin,
                children: [
                  // Both are saved together: the core takes both or neither.
                  _ProxyLogin(
                    username: _str(['proxy', 'username']),
                    password: _str(['proxy', 'password']),
                    onSave: (username, password) => _save({
                      ['proxy', 'username']: username,
                      ['proxy', 'password']: password,
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Getting past a network that filters Mozilla: the user's own relay
  /// for the sign-in, accounts, and server list (network.api_relay). The
  /// core hides its name with Encrypted Client Hello by itself where the
  /// relay's name has a key (network.api_relay_ech, config.json only).
  /// Personal and shared relays have independent switches. A personal
  /// relay needs an address; shared recovery is available without one.
  Widget _bypass(AppLocalizations l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Panel(
        title: l.sharedRelay,
        icon: Icons.groups_outlined,
        trailing: Semantics(
          label: l.sharedRelay,
          child: AppSwitch(
            value: _bool(['network', 'shared_relay_enabled']),
            onChanged: _saving
                ? null
                : (on) => _save({
                    ['network', 'shared_relay_enabled']: on,
                  }),
          ),
        ),
        child: Text(
          l.sharedRelayHint,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      const SizedBox(height: 16),
      Panel(
        title: l.personalRelay,
        icon: Icons.shield_outlined,
        trailing: Semantics(
          label: l.apiRelayUse,
          child: AppSwitch(
            value:
                _bool(['network', 'api_relay_enabled']) &&
                _str(['network', 'api_relay']).isNotEmpty,
            onChanged: _saving || _str(['network', 'api_relay']).isEmpty
                ? null
                : (on) => _save({
                    ['network', 'api_relay_enabled']: on,
                  }),
          ),
        ),
        child: _TextSetting(
          label: l.apiRelay,
          hint: l.apiRelayHint,
          value: _str(['network', 'api_relay']),
          validator: (v) {
            final u = Uri.tryParse(v.trim());
            return v.trim().isEmpty ||
                    (u != null && u.scheme == 'https' && u.host.isNotEmpty)
                ? null
                : l.apiRelayInvalid;
          },
          onSave: (v) => _save({
            ['network', 'api_relay']: v.trim(),
          }),
          testLabel: l.testRelay,
          onTest: (v) => showRelayTestDialog(context, _core, v.trim()),
        ),
      ),
    ],
  );

  /// The way to Mozilla through the user's own SOCKS5 proxy, for a network
  /// that blocks or slows it (network.upstream_proxy).
  Widget _upstreamProxy(AppLocalizations l) => _UpstreamProxy(
    enabled: _bool(['network', 'upstream_proxy_enabled']),
    address: _str(['network', 'upstream_proxy']),
    username: _str(['network', 'upstream_proxy_username']),
    password: _str(['network', 'upstream_proxy_password']),
    ownListen: _str(['proxy', 'listen']),
    onSave: (enabled, address, username, password) => _save({
      ['network', 'upstream_proxy_enabled']: enabled,
      ['network', 'upstream_proxy']: address,
      ['network', 'upstream_proxy_username']: username,
      ['network', 'upstream_proxy_password']: password,
    }),
    onTurnOff: () => _save({
      ['network', 'upstream_proxy_enabled']: false,
    }),
  );

  /// How the TLS connections to Mozilla and the relay start, for a network
  /// that filters by server name (network.hello_split).
  Widget _fragment(AppLocalizations l) {
    final mode = _str(['network', 'hello_split']);
    return Panel(
      title: l.tlsFragment,
      icon: Icons.content_cut_rounded,
      child: RadioGroup<String>(
        // The core's own default is auto now: a fresh install, or a line
        // left empty, reads as auto.
        groupValue: mode.isEmpty || mode == 'auto' ? 'auto' : mode,
        onChanged: (v) {
          if (v == null || _saving) return;
          _save({
            ['network', 'hello_split']: v,
          });
        },
        child: Column(
          children: [
            for (final (value, label, hint) in [
              ('auto', l.tlsFragmentAuto, l.tlsFragmentAutoHint),
              ('off', l.tlsFragmentOff, l.tlsFragmentOffHint),
              (
                'first-byte',
                l.tlsFragmentFirstByte,
                l.tlsFragmentFirstByteHint,
              ),
              ('sni', l.tlsFragmentSni, l.tlsFragmentSniHint),
              ('record', l.tlsFragmentRecord, l.tlsFragmentRecordHint),
            ])
              RadioListTile<String>(
                value: value,
                title: Text(label),
                subtitle: Text(hint),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }

  Widget _routing(AppLocalizations l) {
    final on = _bool(['routing', 'enabled']);
    final region = _str(['routing', 'region']);
    // Separate sections: the switch and country, the rules, the geo
    // files, and the destination test.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Panel(
          title: l.sectionRouting,
          icon: Icons.alt_route_rounded,
          child: Column(
            children: [
              _Choice<String>(
                icon: Icons.flag_outlined,
                title: l.region,
                value: AppSettings.regions.contains(region) ? region : '',
                onChanged: _saving || !on
                    ? null
                    : (v) => _save({
                        ['routing', 'region']: v,
                      }),
                options: [
                  for (final r in AppSettings.regions)
                    (r, regionName(l, r), null),
                ],
              ),
              if (Platform.isAndroid)
                FutureBuilder<AppRouting>(
                  future: AndroidCore.appRouting(),
                  builder: (context, snap) {
                    final r = snap.data;
                    final chosen = (r?.onlyChosen ?? false
                            ? r?.only.length
                            : r?.bypass.length) ??
                        0;
                    return _Row(
                      icon: Icons.apps_rounded,
                      label: l.bypassApps,
                      value: chosen > 0
                          ? l.bypassAppsCount('$chosen')
                          : '',
                      child: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BypassAppsPage(
                            region: on && region.isNotEmpty
                                ? regionName(l, region)
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              _Row(
                icon: Icons.alt_route_rounded,
                label: l.routingDirect,
                child: AppSwitch(
                  value: on,
                  onChanged: _saving
                      ? null
                      : (v) => _save({
                          ['routing', 'enabled']: v,
                        }),
                ),
              ),
              // A shortcut for one Block rule, which the list shows too.
              _Row(
                icon: Icons.block_rounded,
                label: l.blockAds,
                child: AppSwitch(
                  value: on && _blocksAds,
                  onChanged: _saving || !on ? null : _setBlockAds,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Panel(
          title: l.rulesTitle,
          icon: Icons.rule_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The region's rules are in the Direct list itself: the user can
              // change or remove them; another region replaces them.
              _TextSetting(
                label: l.directRules,
                hint: l.directRulesHint,
                value: _list(['routing', 'direct']).join('\n'),
                multiline: true,
                onSave: (v) => _save({
                  ['routing', 'direct']: _lines(v),
                }),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: _saving ? null : _restoreRegionRules,
                  icon: const Icon(Icons.restore_rounded, size: 18),
                  label: Text(l.restoreRegionRules),
                ),
              ),
              const SizedBox(height: 16),
              _TextSetting(
                label: l.blockRules,
                hint: l.blockRulesHint,
                value: _list(['routing', 'block']).join('\n'),
                multiline: true,
                onSave: (v) => _save({
                  ['routing', 'block']: _lines(v),
                }),
              ),
              _Expand(
                title: l.ruleSyntaxTitle,
                children: const [_RuleSyntax()],
              ),
              const Divider(height: 24),
              _Row(
                icon: Icons.travel_explore_rounded,
                label: l.resolveDomains,
                child: AppSwitch(
                  value: _bool(['routing', 'resolve_domains']),
                  onChanged: _saving
                      ? null
                      : (v) => _save({
                          ['routing', 'resolve_domains']: v,
                        }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Panel(
          title: l.routingLists,
          icon: Icons.public_rounded,
          child: _RoutingLists(
            // Read again after the source changes.
            key: ValueKey(_str(['routing', 'geosite_url'])),
            core: _core,
            onSource: (geosite, geoip) => _save({
              ['routing', 'geosite_url']: geosite,
              ['routing', 'geoip_url']: geoip,
            }),
          ),
        ),
        const SizedBox(height: 16),
        Panel(
          title: l.testDestination,
          icon: Icons.science_outlined,
          child: _DestinationTest(core: _core),
        ),
      ],
    );
  }

  /// The Block rule for ads, in both geo sources.
  static const _adsRule = 'geosite:category-ads-all';

  bool _isAdsRule(String rule) => rule.trim().toLowerCase() == _adsRule;

  bool get _blocksAds => _list(['routing', 'block']).any(_isAdsRule);

  Future<void> _setBlockAds(bool on) => _save({
    ['routing', 'block']: [
      for (final r in _list(['routing', 'block']))
        if (!_isAdsRule(r)) r,
      if (on) _adsRule,
    ],
  });

  /// Puts the region's rules back in the Direct list, before the user's
  /// own (the ones removed come back; nothing else changes).
  Future<void> _restoreRegionRules() async {
    RoutingInfo? info;
    final ok = await runShowingErrors(context, () async {
      info = await _core.call((api) => api.routing());
    });
    final presets = info?.regionRules;
    if (!ok || presets == null || !mounted) return;
    final current = _list(['routing', 'direct']);
    final seen = {for (final r in presets) r.toLowerCase()};
    await _save({
      ['routing', 'direct']: [
        ...presets,
        for (final r in current)
          if (!seen.contains(r.trim().toLowerCase())) r,
      ],
    });
  }

  /// The programs that skip the VPN (the core's tun.programs), in order;
  /// path is where one was chosen from ("" for a name typed by hand). Only
  /// the name decides, so one that moved still matches.
  List<({String name, bool udpOnly, String path})> get _programs => [
    for (final p in (_get(['tun', 'programs']) as List<Object?>? ?? const []))
      if (p is Map<String, Object?> && p['name'] is String)
        (
          name: p['name'] as String,
          udpOnly: p['udp_only'] == true,
          path: p['path'] as String? ?? '',
        ),
  ];

  Future<bool> _savePrograms(
    List<({String name, bool udpOnly, String path})> programs,
  ) => _save({
    ['tun', 'programs']: [
      for (final p in programs)
        {
          'name': p.name,
          if (p.udpOnly) 'udp_only': true,
          if (p.path.isNotEmpty) 'path': p.path,
        },
    ],
  });

  /// Adds a program by its file name (or a pattern with *), all its traffic
  /// skipping the VPN, with where it was chosen from; one already there
  /// stays as it is.
  Future<void> _addProgramNamed(String name, {String path = ''}) async {
    name = name.trim().split(RegExp(r'[/\\]')).last;
    final programs = _programs;
    if (name.isEmpty ||
        programs.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      return;
    }
    await _savePrograms([
      ...programs,
      (name: name, udpOnly: false, path: path.trim()),
    ]);
  }

  /// A program from the system's open dialog.
  Future<void> _addProgramFile() async {
    final l = AppLocalizations.of(context);
    String? path;
    try {
      path = await pickProgramFile(l.addProgram, l.programFiles);
    } on PlatformException catch (e) {
      if (mounted) showError(context, e.message ?? e.code);
      return;
    }
    if (path != null && mounted) await _addProgramNamed(path, path: path);
  }

  /// A program from the ones running now, which the core lists.
  Future<void> _addRunningProgram() async {
    List<RunningProgram>? running;
    final ok = await runShowingErrors(context, () async {
      running = await _core.call((api) => api.runningPrograms());
    });
    final list = running;
    if (!ok || list == null || !mounted) return;
    final picked = await showDialog<RunningProgram>(
      context: context,
      builder: (_) => _RunningProgramsDialog(
        programs: list,
        added: {for (final p in _programs) p.name.toLowerCase()},
      ),
    );
    if (picked != null && mounted) {
      await _addProgramNamed(picked.name, path: picked.path);
    }
  }

  /// A program by a name the user types, * for any text.
  Future<void> _addProgramByName() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _ProgramNameDialog(),
    );
    if (name != null && mounted) await _addProgramNamed(name);
  }

  /// Asks first: a click by mistake would cost the administrator's prompt
  /// to put the service back.
  Future<void> _confirmRemoveTunService() async {
    final l = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.delete_outline_rounded, color: colors.error),
        title: Text(l.removeTunService),
        content: SizedBox(width: 380, child: Text(l.removeTunServiceHint)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.remove),
          ),
        ],
      ),
    );
    if (yes == true && mounted) await _removeTunService();
  }

  Widget _tun(AppLocalizations l) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final s = widget.settings;
    final tun = _core.status?.tun;
    final programsHere = tun?.programsSupported ?? false;
    final programs = _programs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (programsHere) ...[
          Panel(
            title: l.sectionTun,
            icon: Icons.vpn_lock_rounded,
            // The home page's card when a program's call or game was
            // refused.
            child: _Row(
              icon: Icons.call_rounded,
              label: l.udpNoticeSetting,
              child: AppSwitch(
                value: s.udpNotice,
                onChanged: (v) => s.update(udpNotice: v),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Panel(
            title: l.tunPrograms,
            icon: Icons.apps_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.tunProgramsHint,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
                const SizedBox(height: 8),
                if (programs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                    child: Text(
                      l.tunProgramsEmpty,
                      style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                    ),
                  ),
                for (final p in programs)
                  _ProgramRow(
                    name: p.name,
                    path: p.path,
                    udpOnly: p.udpOnly,
                    onMode: _saving
                        ? null
                        : (udpOnly) => _savePrograms([
                            for (final q in programs)
                              q.name == p.name
                                  ? (
                                      name: q.name,
                                      udpOnly: udpOnly,
                                      path: q.path,
                                    )
                                  : q,
                          ]),
                    onRemove: _saving
                        ? null
                        : () => _savePrograms([
                            for (final q in programs)
                              if (q.name != p.name) q,
                          ]),
                  ),
                // Three ways: what runs now (the names the TUN sees), a
                // file, or a name with *.
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: MenuAnchor(
                    menuChildren: [
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.apps_rounded),
                        onPressed: _addRunningProgram,
                        child: Text(l.addRunningProgram),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.folder_open_rounded),
                        onPressed: _addProgramFile,
                        child: Text(l.addProgramFile),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.edit_rounded),
                        onPressed: _addProgramByName,
                        child: Text(l.addProgramName),
                      ),
                    ],
                    builder: (context, menu, _) => TextButton.icon(
                      onPressed: _saving
                          ? null
                          : () => menu.isOpen ? menu.close() : menu.open(),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l.addProgram),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _dns(AppLocalizations l) {
    final servers = _list(['dns', 'servers']);
    final saved =
        _dnsPresets.entries
            .where((e) => e.value.join(',') == servers.join(','))
            .firstOrNull
            ?.key ??
        'custom';
    final preset = _dnsPreset ?? saved;
    final names = {
      'system': l.dnsSystem,
      'auto': l.dnsAuto,
      'cloudflare': 'Cloudflare',
      'google': 'Google',
      'quad9': 'Quad9',
      'cloudflare_dot': 'Cloudflare (DNS over TLS)',
      'custom': l.dnsManual,
    };
    return Panel(
      title: l.sectionDns,
      icon: Icons.dns_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Choice<String>(
            icon: Icons.dns_outlined,
            title: l.dnsPreset,
            value: preset,
            onChanged: _saving
                ? null
                : (v) {
                    setState(() => _dnsPreset = v);
                    if (v != 'custom') {
                      _save({
                        ['dns', 'servers']: _dnsPresets[v]!,
                      }).then((_) {
                        if (mounted) setState(() => _dnsPreset = null);
                      });
                    }
                  },
            options: [for (final e in names.entries) (e.key, e.value, null)],
          ),
          if (preset == 'custom') ...[
            const SizedBox(height: 16),
            // The manual DNS: the addresses the tunnel's resolver asks
            // first, one per line — a plain IP, an https:// address (DNS
            // over HTTPS), or a server name (DNS over TLS). The lines
            // read back with what each one is, so the list is never a
            // pile of strings; a line the core could not use says so
            // before it is saved.
            _TextSetting(
              label: l.dnsManual,
              hint: l.dnsManualHint,
              value: servers.join('\n'),
              multiline: true,
              validator: (v) {
                for (final line in _lines(v)) {
                  if (_dnsKind(line) == null) return l.dnsManualInvalid;
                }
                return null;
              },
              onSave: (v) async {
                await _save({
                  ['dns', 'servers']: _lines(v),
                });
                if (mounted) setState(() => _dnsPreset = null);
              },
            ),
            if (servers.isNotEmpty) ...[
              const SizedBox(height: 10),
              // What each saved line is: the address, and the kind of
              // resolver it names — plain, DoH, or DoT.
              for (final server in servers)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 4,
                    bottom: 5,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.network_check_rounded, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          server,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Pill(
                        switch (_dnsKind(server)) {
                          'doh' => 'DoH',
                          'dot' => 'DoT',
                          _ => 'IP',
                        },
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
            ],
            // A tap of the common resolvers, for a start without typing.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (name, addr) in const [
                  ('1.1.1.1', '1.1.1.1'),
                  ('8.8.8.8', '8.8.8.8'),
                  ('9.9.9.9', '9.9.9.9'),
                  ('DoH · Cloudflare', 'https://1.1.1.1/dns-query'),
                  ('DoH · Google', 'https://8.8.8.8/dns-query'),
                  ('DoT · Cloudflare', 'tls://1.1.1.1'),
                ])
                  ActionChip(
                    label: Text(name, style: Theme.of(context).textTheme.labelSmall),
                    tooltip: addr,
                    onPressed: _saving
                        ? null
                        : () {
                            final next = {
                              ...servers.where((s) => s != addr),
                              addr,
                            }.toList();
                            _save({
                              ['dns', 'servers']: next,
                            }).then((_) {
                              if (mounted) setState(() => _dnsPreset = null);
                            });
                          },
                  ),
              ],
            ),
          ],
          _Row(
            icon: Icons.settings_backup_restore_rounded,
            label: l.dnsFallback,
            child: AppSwitch(
              value: _bool(['dns', 'fallback_to_system']),
              onChanged: _saving
                  ? null
                  : (v) => _save({
                      ['dns', 'fallback_to_system']: v,
                    }),
            ),
          ),
          const Divider(height: 24),
          _DnsTest(core: _core, servers: servers),
        ],
      ),
    );
  }

  /// What kind of resolver a DNS line names, in the core's own formats
  /// (core/internal/config/config.go): 'doh' for an https:// URL, 'dot'
  /// for a tls://host, 'ip' for a plain IP[:port] — null when the line is
  /// none of them (a typo, a scheme the core has no use for).
  String? _dnsKind(String line) {
    final v = line.trim();
    if (v.isEmpty) return null;
    final lower = v.toLowerCase();
    if (lower.startsWith('https://') || lower.startsWith('http://')) {
      final uri = Uri.tryParse(v);
      return uri != null && uri.host.isNotEmpty ? 'doh' : null;
    }
    if (lower.startsWith('tls://')) {
      final host = v.substring(6).trim();
      return _dnsHostRe.hasMatch(host) ? 'dot' : null;
    }
    // A plain IP, with an optional :port after it.
    var host = v;
    final colon = v.lastIndexOf(':');
    if (colon > 0 && !v.contains(']')) host = v.substring(0, colon);
    return InternetAddress.tryParse(host) != null ? 'ip' : null;
  }

  /// After how long without traffic the connection to Mozilla sleeps.
  Widget _sleepChoice(AppLocalizations l) {
    final current = _shortDuration(_str(['proxy', 'idle_sleep']));
    final options = [
      ('0s', l.sleepNever, null),
      for (final m in const [5, 15, 30]) ('${m}m', l.sleepMinutes(m), null),
      ('1h', l.sleepHour, null),
    ];
    return _Choice<String>(
      icon: Icons.bedtime_outlined,
      title: l.idleSleep,
      value: current,
      onChanged: _saving
          ? null
          : (v) => _save({
              ['proxy', 'idle_sleep']: v,
            }),
      options: [
        ...options,
        // A value set elsewhere (the dashboard) stays visible.
        if (!options.any((o) => o.$1 == current)) (current, current, null),
      ],
    );
  }

  Widget _advanced(AppLocalizations l) {
    final theme = Theme.of(context);
    final error = theme.colorScheme.error;
    final appListen = _str(['dashboard', 'listen']);
    final dashboard = CoreLocator.listenUri(appListen).replace(path: '/app/');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PortRow(
                icon: Icons.hub_outlined,
                label: l.appPort,
                listen: appListen,
                onChange: () => _changePort(appListen, _core.setAppPort),
              ),
              _Row(
                icon: Icons.dashboard_outlined,
                label: l.webDashboard,
                // An address reads left to right in a right-to-left language.
                value: ltr('$dashboard'),
                child: const Icon(Icons.open_in_new_rounded, size: 20),
                onTap: () => runShowingErrors(
                  context,
                  () async => openUrl('${await _core.dashboardLink()}'),
                ),
              ),
            ],
          ),
        ),
        // The TUN mode's service, which no uninstaller removes from a
        // portable copy on Windows, or on Linux and macOS: here, out of the
        // way, red, and asked first, since it is rarely meant.
        if (_core.status?.tun?.installed ?? false) ...[
          const SizedBox(height: 16),
          Panel(
            title: l.removeTunService,
            icon: Icons.delete_outline_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.removeTunServiceHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: error,
                      side: BorderSide(color: error),
                    ),
                    onPressed: _core.removingTun || _core.installingTun
                        ? null
                        : _confirmRemoveTunService,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(l.remove),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Non-empty trimmed lines.
List<String> _lines(String text) => [
  for (final line in text.split('\n'))
    if (line.trim().isNotEmpty) line.trim(),
];

/// Go's "1h0m0s" as "1h", "15m0s" as "15m".
String _shortDuration(String go) {
  var s = go;
  if (s.endsWith('m0s')) s = s.substring(0, s.length - 2);
  if (s.endsWith('h0m')) s = s.substring(0, s.length - 2);
  return s;
}

/// The values to choose from in a dialog in the middle of the window, one
/// radio button each, with its line from [hints]; null when cancelled.
Future<T?> _pickOne<T>(
  BuildContext context, {
  required String title,
  required T value,
  required List<(T, String, TextStyle?)> options,
  List<String>? hints,
}) => showDialog<T>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(title),
    contentPadding: const EdgeInsets.symmetric(vertical: 12),
    content: SizedBox(
      width: 360,
      child: SingleChildScrollView(
        child: RadioGroup<T>(
          groupValue: value,
          onChanged: (v) => Navigator.pop(context, v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, (v, label, style)) in options.indexed)
                RadioListTile<T>(
                  value: v,
                  title: Text(label, style: style),
                  subtitle: hints == null ? null : Text(hints[i]),
                ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context).cancel),
      ),
    ],
  ),
);

/// A program that skips the VPN: its file name and the path it was chosen
/// from, left to right from the left in every language (file names read
/// so), then how much of it skips the VPN, which a tap changes, and a
/// remove button.
class _ProgramRow extends StatelessWidget {
  const _ProgramRow({
    required this.name,
    required this.path,
    required this.udpOnly,
    required this.onMode,
    required this.onRemove,
  });

  final String name;
  final String path;
  final bool udpOnly;
  final ValueChanged<bool>? onMode;
  final VoidCallback? onRemove;

  Future<void> _chooseMode(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final picked = await _pickOne<bool>(
      context,
      title: ltr(name),
      value: udpOnly,
      options: [(false, l.tunProgramAll, null), (true, l.tunProgramUdp, null)],
      hints: [l.tunProgramAllHint, l.tunProgramUdpHint],
    );
    if (picked != null && picked != udpOnly) onMode?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Icon(Icons.apps_rounded, color: muted),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                Text(
                  name,
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.bodyLarge,
                ),
                if (path.isNotEmpty)
                  Tooltip(
                    message: path,
                    child: Text(
                      path,
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onMode == null ? null : () => _chooseMode(context),
            child: Text(udpOnly ? l.tunProgramUdp : l.tunProgramAll),
          ),
          IconButton(
            tooltip: l.remove,
            icon: const Icon(Icons.close_rounded),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

/// A choice among a few values, shown as the current one; a tap opens the
/// values in a dialog in the middle of the window (not a menu at the
/// control), one radio button each.
class _Choice<T> extends StatelessWidget {
  const _Choice({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final T value;

  /// Each value with its label and the label's style (a language in its
  /// own font).
  final List<(T, String, TextStyle?)> options;
  final ValueChanged<T>? onChanged;

  Future<void> _open(BuildContext context) async {
    final picked = await _pickOne<T>(
      context,
      title: title,
      value: value,
      options: options,
    );
    if (picked != null && picked != value) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final current = options.where((o) => o.$1 == value).firstOrNull;
    return _Row(
      icon: icon,
      label: title,
      value: current?.$2 ?? '',
      onTap: onChanged == null ? null : () => _open(context),
    );
  }
}

/// A setting as one row, as in Hiddify: its icon, its name with the
/// current value under it, and a switch (or nothing) at the end. A tap
/// opens the choices, the port dialog, or the page it names.
class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    this.value,
    this.child,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final value = this.value;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            IconBox(icon: icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodyLarge),
                  if (value != null && value.isNotEmpty)
                    Text(
                      value,
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                    ),
                ],
              ),
            ),
            if (child case final child?) ...[const SizedBox(width: 12), child],
          ],
        ),
      ),
    );
  }
}

/// The programs running now, to pick one that skips the VPN, by the file
/// name the TUN sees, with a search; the ones already chosen are marked.
class _RunningProgramsDialog extends StatefulWidget {
  const _RunningProgramsDialog({required this.programs, required this.added});

  final List<RunningProgram> programs;

  /// The chosen programs' names, in lower case.
  final Set<String> added;

  @override
  State<_RunningProgramsDialog> createState() => _RunningProgramsDialogState();
}

class _RunningProgramsDialogState extends State<_RunningProgramsDialog> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final q = _query.trim().toLowerCase();
    final shown = [
      for (final p in widget.programs)
        if (q.isEmpty ||
            p.name.toLowerCase().contains(q) ||
            p.path.toLowerCase().contains(q))
          p,
    ];
    return AlertDialog(
      title: Text(l.addProgram),
      contentPadding: const EdgeInsets.only(top: 12),
      content: SizedBox(
        width: 480,
        height: 420,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                autofocus: true,
                // Program names read left to right, from the left.
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: l.search,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: widget.programs.isEmpty
                  ? Center(
                      child: Text(
                        l.runningProgramsEmpty,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                    )
                  // Names and paths read left to right, from the left, in
                  // every language.
                  : Directionality(
                      textDirection: TextDirection.ltr,
                      child: ListView(
                        children: [
                          for (final p in shown)
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              leading: Icon(
                                widget.added.contains(p.name.toLowerCase())
                                    ? Icons.check_rounded
                                    : Icons.apps_rounded,
                              ),
                              title: Text(p.name),
                              subtitle: Tooltip(
                                message: p.path,
                                child: Text(
                                  p.path,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              enabled: !widget.added.contains(
                                p.name.toLowerCase(),
                              ),
                              onTap: () => Navigator.pop(context, p),
                            ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
      ],
    );
  }
}

/// A program's file name typed by hand, or a pattern with *.
class _ProgramNameDialog extends StatefulWidget {
  const _ProgramNameDialog();

  @override
  State<_ProgramNameDialog> createState() => _ProgramNameDialogState();
}

class _ProgramNameDialogState extends State<_ProgramNameDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.addProgram),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _controller,
          autofocus: true,
          // A file name reads left to right, from the left, in every
          // language.
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'steam.exe',
            helperText: l.programNameHint,
            helperMaxLines: 3,
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty ? null : _submit,
          child: Text(l.addProgram),
        ),
      ],
    );
  }
}

/// A collapsed group of settings.
class _Expand extends StatelessWidget {
  const _Expand({required this.title, required this.children, this.icon});

  final String title;
  final List<Widget> children;

  /// Lines the group up with the rows (_Row) above it.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: icon == null
            ? EdgeInsets.zero
            : const EdgeInsetsDirectional.only(start: 4),
        leading: icon == null
            ? null
            : Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        title: Text(
          title,
          style: icon == null
              ? theme.textTheme.titleSmall
              : theme.textTheme.bodyLarge,
        ),
        childrenPadding: const EdgeInsets.only(top: 8, bottom: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// A text setting with its own Save button, enabled once the text changes.
class _TextSetting extends StatefulWidget {
  const _TextSetting({
    required this.label,
    required this.value,
    required this.onSave,
    this.hint,
    this.multiline = false,
    this.validator,
    this.testLabel,
    this.onTest,
  });

  final String label;
  final String value;
  final Future<void> Function(String value) onSave;
  final String? hint;
  final bool multiline;
  final String? Function(String value)? validator;
  final String? testLabel;
  final Future<void> Function(String value)? onTest;

  @override
  State<_TextSetting> createState() => _TextSettingState();
}

class _TextSettingState extends State<_TextSetting> {
  late final _controller = TextEditingController(text: widget.value);
  String? _error;
  bool _saving = false;

  @override
  void didUpdateWidget(_TextSetting old) {
    super.didUpdateWidget(old);
    // A saved value comes back from the core; keep unsaved typing. A field
    // emptied and saved shows what the empty value stands for (MTU: this
    // device's own).
    if (old.value != widget.value &&
        (_controller.text == old.value || _controller.text.trim().isEmpty)) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _dirty => _controller.text != widget.value;

  Future<void> _submit() async {
    final error = widget.validator?.call(_controller.text);
    setState(() => _error = error);
    if (error != null || !_dirty) return;
    setState(() => _saving = true);
    await widget.onSave(_controller.text);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final field = TextField(
      controller: _controller,
      minLines: widget.multiline ? 3 : 1,
      maxLines: widget.multiline ? 8 : 1,
      textDirection: TextDirection.ltr,
      style: widget.multiline
          ? const TextStyle(fontFamily: 'Consolas', fontSize: 13)
          : null,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.hint,
        helperMaxLines: 6,
        errorText: _error,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => setState(() => _error = null),
      onSubmitted: widget.multiline ? null : (_) => _submit(),
    );
    final button = _saving
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : FilledButton(onPressed: _dirty ? _submit : null, child: Text(l.save));
    // The button goes under the field, which keeps the whole width.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        field,
        const SizedBox(height: 8),
        Row(
          children: [
            if (widget.onTest != null)
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    onPressed: _saving || _controller.text.trim().isEmpty
                        ? null
                        : () {
                            final error = widget.validator?.call(
                              _controller.text,
                            );
                            setState(() => _error = error);
                            if (error == null) {
                              FocusScope.of(context).unfocus();
                              widget.onTest!(_controller.text);
                            }
                          },
                    icon: const Icon(Icons.health_and_safety_outlined),
                    label: Text(widget.testLabel ?? ''),
                  ),
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: 8),
            button,
          ],
        ),
      ],
    );
  }
}

/// The proxy's username and password, saved together with one button: the
/// core accepts both or neither, never one alone.
class _ProxyLogin extends StatefulWidget {
  const _ProxyLogin({
    required this.username,
    required this.password,
    required this.onSave,
  });

  final String username;
  final String password;
  final Future<void> Function(String username, String password) onSave;

  @override
  State<_ProxyLogin> createState() => _ProxyLoginState();
}

class _ProxyLoginState extends State<_ProxyLogin> {
  late final _user = TextEditingController(text: widget.username);
  late final _pass = TextEditingController(text: widget.password);
  bool _show = false;
  bool _saving = false;
  String? _error;

  @override
  void didUpdateWidget(_ProxyLogin old) {
    super.didUpdateWidget(old);
    // Saved values come back from the core; keep unsaved typing.
    if (old.username != widget.username && _user.text == old.username) {
      _user.text = widget.username;
    }
    if (old.password != widget.password && _pass.text == old.password) {
      _pass.text = widget.password;
    }
  }

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool get _dirty =>
      _user.text.trim() != widget.username || _pass.text != widget.password;

  Future<void> _submit() async {
    final user = _user.text.trim();
    final pass = _pass.text;
    if (user.isEmpty != pass.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).loginBothOrNone);
      return;
    }
    if (!_dirty) return;
    setState(() => _saving = true);
    await widget.onSave(user, pass);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    void changed(String _) => setState(() => _error = null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.proxyLoginHint, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        TextField(
          controller: _user,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: l.proxyUsername,
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          onChanged: changed,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _pass,
          obscureText: !_show,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            labelText: l.proxyPassword,
            errorText: _error,
            isDense: true,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _show ? Icons.visibility_off : Icons.visibility,
                size: 18,
              ),
              onPressed: () => setState(() => _show = !_show),
            ),
          ),
          onChanged: changed,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: _saving
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : FilledButton(
                  onPressed: _dirty ? _submit : null,
                  child: Text(l.save),
                ),
        ),
      ],
    );
  }
}

/// The upstream proxy's card: a switch, and the address, port, and login, saved
/// together. Off keeps them; on needs an address. What a paste may bring goes by
/// itself: spaces, a scheme, the port with the address.
class _UpstreamProxy extends StatefulWidget {
  const _UpstreamProxy({
    required this.enabled,
    required this.address,
    required this.username,
    required this.password,
    required this.ownListen,
    required this.onSave,
    required this.onTurnOff,
  });

  /// network.upstream_proxy_enabled.
  final bool enabled;

  /// network.upstream_proxy: host:port.
  final String address;
  final String username;
  final String password;

  /// This app's own proxy (proxy.listen), which cannot be the upstream one.
  final String ownListen;
  final Future<void> Function(
    bool enabled,
    String address,
    String username,
    String password,
  )
  onSave;
  final Future<void> Function() onTurnOff;

  @override
  State<_UpstreamProxy> createState() => _UpstreamProxyState();
}

class _UpstreamProxyState extends State<_UpstreamProxy> {
  late final _host = TextEditingController(
    text: splitAddress(widget.address).$1,
  );
  late final _port = TextEditingController(
    text: splitAddress(widget.address).$2,
  );
  late final _user = TextEditingController(text: widget.username);
  late final _pass = TextEditingController(text: widget.password);
  bool _show = false;
  bool _saving = false;
  String? _hostError;
  String? _portError;
  String? _loginError;

  @override
  void didUpdateWidget(_UpstreamProxy old) {
    super.didUpdateWidget(old);
    // Saved values come back from the core; keep unsaved typing.
    if (old.address != widget.address &&
        joinAddress(_host.text, _port.text) == old.address) {
      final (host, port) = splitAddress(widget.address);
      _host.text = host;
      _port.text = port;
    }
    if (old.username != widget.username && _user.text == old.username) {
      _user.text = widget.username;
    }
    if (old.password != widget.password && _pass.text == old.password) {
      _pass.text = widget.password;
    }
  }

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool get _dirty =>
      joinAddress(_host.text, _port.text) != widget.address ||
      _user.text.trim() != widget.username ||
      _pass.text.trim() != widget.password;

  // A field left as it is keeps its caret: the user may go on typing.
  void _clean(TextEditingController field, String text) {
    if (field.text == text) return;
    field.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Saves the fields; [turnOn] also turns the proxy on, which needs an address.
  Future<void> _submit({bool turnOn = false}) async {
    final l = AppLocalizations.of(context);
    // The port may have come with the address.
    final (host, withHost) = splitAddress(_host.text);
    final port = withHost.isNotEmpty ? withHost : _port.text;
    final user = _user.text.trim();
    final pass = _pass.text.trim();
    final number = int.tryParse(port);
    const loopback = {'127.0.0.1', 'localhost', '::1', '0.0.0.0', '::'};
    final empty = !turnOn && host.isEmpty && port.isEmpty;
    setState(() {
      _clean(_host, host);
      _clean(_port, port);
      _clean(_user, user);
      _clean(_pass, pass);
      _hostError = empty
          ? null
          : host.isEmpty
          ? l.upstreamProxyInvalid
          : loopback.contains(host) && number == portOf(widget.ownListen)
          ? l.upstreamProxyOwn
          : null;
      _portError = empty || (number != null && number >= 1 && number <= 65535)
          ? null
          : l.upstreamProxyInvalidPort;
      _loginError = user.isEmpty != pass.isEmpty ? l.loginBothOrNone : null;
    });
    if (_hostError != null || _portError != null || _loginError != null) return;
    if (!turnOn && !_dirty) return;
    setState(() => _saving = true);
    await widget.onSave(
      turnOn || widget.enabled,
      joinAddress(host, port),
      user,
      pass,
    );
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _toggle(bool on) async {
    if (on) return _submit(turnOn: true);
    setState(() {
      _clearErrors();
      _saving = true;
    });
    await widget.onTurnOff();
    if (mounted) setState(() => _saving = false);
  }

  void _clearErrors() {
    _hostError = null;
    _portError = null;
    _loginError = null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    void changed(String _) => setState(_clearErrors);
    // Fainter than the theme's hints, which pass for values here: Save would stay
    // off under what looks like a filled-in address.
    final example = TextStyle(
      color: Theme.of(context).colorScheme.onSurfaceVariant
          .withValues(alpha: 0.45),
    );
    // An address reads left to right in a right-to-left language too: the host,
    // then the port, as in 127.0.0.1:1080. Tab goes in that order.
    return Panel(
      title: l.upstreamProxy,
      icon: Icons.lan_outlined,
      trailing: Semantics(
        label: l.upstreamProxy,
        child: AppSwitch(
          value: widget.enabled,
          onChanged: _saving ? null : _toggle,
        ),
      ),
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.upstreamProxyHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _host,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    decoration: InputDecoration(
                      labelText: l.upstreamProxyAddress,
                      hintText: '127.0.0.1',
                      hintStyle: example,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorText: _hostError,
                      errorMaxLines: 3,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: changed,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _port,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: l.upstreamProxyPort,
                      hintText: '1080',
                      hintStyle: example,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      errorText: _portError,
                      errorMaxLines: 4,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: changed,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _user,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: l.proxyUsername,
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              onChanged: changed,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pass,
              obscureText: !_show,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: l.proxyPassword,
                errorText: _loginError,
                isDense: true,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _show ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _show = !_show),
                ),
              ),
              onChanged: changed,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : FilledButton(
                      onPressed: _dirty ? _submit : null,
                      child: Text(l.save),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A port setting: the current port and a button that changes it.
class _PortRow extends StatelessWidget {
  const _PortRow({
    required this.icon,
    required this.label,
    required this.listen,
    required this.onChange,
  });

  final IconData icon;
  final String label;
  final String listen;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) => _Row(
    icon: icon,
    label: label,
    value: '${portOf(listen) ?? '—'}',
    onTap: listen.isEmpty ? null : onChange,
  );
}

/// The routing lists: their state and Update now.
class _RoutingLists extends StatefulWidget {
  const _RoutingLists({super.key, required this.core, required this.onSource});

  final CoreController core;

  /// Saves another list set (its two URLs); the core downloads it.
  final Future<bool> Function(String geosite, String geoip) onSource;

  @override
  State<_RoutingLists> createState() => _RoutingListsState();
}

class _RoutingListsState extends State<_RoutingLists> {
  RoutingInfo? _info;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _read();
  }

  Future<void> _read() async {
    try {
      final info = await widget.core.call((api) => api.routing());
      if (mounted) setState(() => _info = info);
    } on Exception {
      // Shown as unknown.
    }
  }

  Future<void> _update() async {
    final l = AppLocalizations.of(context);
    setState(() => _updating = true);
    try {
      final info = await widget.core.call((api) => api.updateRoutingLists());
      if (!mounted) return;
      setState(() => _info = info);
      showError(context, l.listsUpdated);
    } on CoreApiException catch (e) {
      if (mounted) showError(context, e.message);
    } on CoreUnavailable catch (e) {
      if (mounted) showError(context, describeProblem(l, e));
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final info = _info;
    // When the files were updated ("5 days ago": the oldest), and their
    // names and size.
    final files =
        info?.lists ?? const <({String name, int size, DateTime? updatedAt})>[];
    final dates = [
      for (final f in files)
        if (f.updatedAt != null) f.updatedAt!,
    ]..sort();
    final lines = [
      if (info != null && info.error.isNotEmpty) info.error,
      if (dates.isNotEmpty) l.listsUpdatedAgo(formatSince(l, dates.first)),
      if (files.isNotEmpty)
        [
          ltr(files.map((f) => f.name).join(', ')),
          formatBytes(files.fold(0, (sum, f) => sum + f.size)),
        ].join(' · '),
    ];
    final sources = info?.sources ?? const [];
    // A tap downloads the lists again.
    final lists = _Row(
      icon: Icons.folder_outlined,
      label: l.updateLists,
      value: lines.join('\n'),
      onTap: _updating ? null : _update,
      child: _updating
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.download_rounded),
    );
    if (info == null || sources.isEmpty) return lists;
    return Column(
      children: [
        // Where the lists come from, as in v2rayNG; the country picks its
        // usual one by itself.
        _Choice<String>(
          icon: Icons.cloud_outlined,
          title: l.listSource,
          value: info.source,
          onChanged: (id) {
            final s = sources.firstWhere((s) => s.id == id);
            widget.onSource(s.geositeUrl, s.geoipUrl);
          },
          options: [
            for (final s in sources) (s.id, s.name, null),
            if (info.source.isEmpty) ('', l.listSourceCustom, null),
          ],
        ),
        lists,
      ],
    );
  }
}

/// A rule as written, left to right in a small monospace box.
class _RuleChip extends StatelessWidget {
  const _RuleChip(this.rule);

  final String rule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          rule,
          style: theme.textTheme.bodySmall?.copyWith(
            fontFamily: 'Consolas',
            fontFamilyFallback: const ['monospace'],
          ),
        ),
      ),
    );
  }
}

/// The rules the chosen country adds by itself, so they are no surprise.
/// How to write a rule, one example per kind.
class _RuleSyntax extends StatelessWidget {
  const _RuleSyntax();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    // The rules are English, so the guide reads left to right in every
    // language: the rule first, then what it means (in the app's own
    // direction).
    final direction = Directionality.of(context);
    final examples = [
      ('domain:example.com', l.ruleDomain),
      ('full:www.example.com', l.ruleFull),
      ('keyword:bank', l.ruleKeyword),
      ('geosite:ir', l.ruleGeosite),
      ('geoip:ir', l.ruleGeoip),
      ('1.2.3.4  10.0.0.0/8', l.ruleIp),
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.rulesSyntaxTitle,
            textDirection: direction,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          for (final (rule, what) in examples)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Wrap(
                textDirection: TextDirection.ltr,
                spacing: 8,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _RuleChip(rule),
                  Text(what, textDirection: direction, style: small),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Where a destination goes, and which rule decides it.
class _DestinationTest extends StatefulWidget {
  const _DestinationTest({required this.core});

  final CoreController core;

  @override
  State<_DestinationTest> createState() => _DestinationTestState();
}

class _DestinationTestState extends State<_DestinationTest> {
  final _target = TextEditingController();
  DestinationTest? _result;
  bool _testing = false;

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    final target = _target.text.trim();
    if (target.isEmpty) return;
    final l = AppLocalizations.of(context);
    setState(() => _testing = true);
    try {
      final result = await widget.core.call(
        (api) => api.testDestination(target),
      );
      if (mounted) setState(() => _result = result);
    } on CoreApiException catch (e) {
      if (mounted) showError(context, e.message);
    } on CoreUnavailable catch (e) {
      if (mounted) showError(context, describeProblem(l, e));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = _result;
    final (text, color) = switch (r?.route) {
      'direct' => (l.routeDirect, StatusColors.good),
      'block' => (l.routeBlock, StatusColors.bad),
      _ => (l.routeProxy, theme.colorScheme.primary),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _target,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: l.testDestination,
                  hintText: l.destinationHint,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _test(),
              ),
            ),
            const SizedBox(width: 12),
            _testing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton.tonal(onPressed: _test, child: Text(l.check)),
          ],
        ),
        if (r != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Pill(text, color: color),
              if (r.rule.isNotEmpty)
                Text(l.ruleMatched(r.rule), style: theme.textTheme.bodySmall),
              if (r.resolved.isNotEmpty)
                Text('→ ${r.resolved}', style: theme.textTheme.bodySmall),
              if (r.portRefused)
                Text(
                  l.portRefusedNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: StatusColors.bad,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Resolves the program's own names through the chosen DNS servers and the
/// system's, side by side.
class _DnsTest extends StatefulWidget {
  const _DnsTest({required this.core, required this.servers});

  final CoreController core;
  final List<String> servers;

  @override
  State<_DnsTest> createState() => _DnsTestState();
}

class _DnsTestState extends State<_DnsTest> {
  List<DnsTestHost>? _results;
  bool _testing = false;

  Future<void> _test() async {
    final l = AppLocalizations.of(context);
    setState(() => _testing = true);
    try {
      final results = await widget.core.call(
        (api) => api.testDns(widget.servers),
      );
      if (mounted) setState(() => _results = results);
    } on CoreApiException catch (e) {
      if (mounted) showError(context, e.message);
    } on CoreUnavailable catch (e) {
      if (mounted) showError(context, describeProblem(l, e));
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final results = _results;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: _testing ? null : _test,
            icon: _testing
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow_rounded, size: 18),
            label: Text(l.testDns),
          ),
        ),
        if (results != null && results.isNotEmpty) ...[
          const SizedBox(height: 12),
          _DnsSummary(results: results),
          const SizedBox(height: 8),
          for (final r in results)
            Directionality(
              textDirection: TextDirection.ltr,
              child: _DnsResultRow(result: r),
            ),
        ],
      ],
    );
  }
}

/// Whether the network's DNS answered [r] with a filtering address (the
/// core decides). Other differences are normal: large services answer by
/// location.
bool _filteredAnswer(DnsTestHost r) => r.filtered;

/// A DNS server's name for people: the well-known ones by their company.
String _dnsServerName(String source) {
  if (source.isEmpty || source == 'system') return '';
  const known = {
    '1.1.1.1': 'Cloudflare',
    '1.0.0.1': 'Cloudflare',
    '8.8.8.8': 'Google',
    '8.8.4.4': 'Google',
    '9.9.9.9': 'Quad9',
    '149.112.112.112': 'Quad9',
  };
  for (final e in known.entries) {
    if (source.contains(e.key)) return e.value;
  }
  return Uri.tryParse(source)?.host.isNotEmpty == true
      ? Uri.parse(source).host
      : source;
}

/// The test in one line: whether the chosen servers answered, through
/// which, and whether the network's own DNS answered otherwise.
class _DnsSummary extends StatelessWidget {
  const _DnsSummary({required this.results});

  final List<DnsTestHost> results;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final failed = results.where((r) => r.error.isNotEmpty).length;
    final differs = results.where(_filteredAnswer).length;
    final server = results
        .map((r) => _dnsServerName(r.source))
        .firstWhere((n) => n.isNotEmpty, orElse: () => '');
    final (icon, color, title) = failed > 0
        ? (
            Icons.error_outline_rounded,
            StatusColors.bad,
            l.dnsSummaryFailed(failed),
          )
        : differs > 0
        ? (Icons.shield_outlined, StatusColors.busy, l.dnsSummaryOk)
        : (Icons.verified_outlined, StatusColors.good, l.dnsSummaryOk);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [title, if (server.isNotEmpty) l.dnsVia(server)].join(' · '),
                  style: theme.textTheme.titleSmall,
                ),
                if (differs > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    l.dnsSummaryDiffers(differs),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One name of the test: what it is for, the address found and how fast,
/// and the network's own DNS beside it when it answered otherwise.
class _DnsResultRow extends StatelessWidget {
  const _DnsResultRow({required this.result});

  final DnsTestHost result;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = result;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final ok = r.error.isEmpty;
    final filtered = _filteredAnswer(r);
    String addrs(List<String> a) => a.isEmpty
        ? '—'
        : [a.first, if (a.length > 1) '+${a.length - 1}'].join(' ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              !ok
                  ? Icons.cancel_rounded
                  : filtered
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_rounded,
              size: 18,
              color: !ok
                  ? StatusColors.bad
                  : filtered
                  ? StatusColors.busy
                  : StatusColors.good,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.role.isNotEmpty ? r.role : r.host,
                  style: theme.textTheme.titleSmall,
                ),
                Text(ltr(r.host), style: muted),
                const SizedBox(height: 4),
                Text(
                  ok
                      ? '${l.dnsAnswer} ${ltr(addrs(r.addrs))}'
                      : '${l.dnsAnswer} ${r.error}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ok ? null : StatusColors.bad,
                  ),
                ),
                // The network's own answer when it differs; a warning only
                // when it is a filtering address.
                if (r.differs && r.systemAddrs.isNotEmpty)
                  Text(
                    [
                      '${l.dnsNetworkAnswer} ${ltr(addrs(r.systemAddrs))}',
                      if (filtered) l.dnsFiltered,
                    ].join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: filtered
                          ? StatusColors.busy
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (ok)
            Text(
              l.milliseconds(r.ms),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// The accent the row names, in the row's language: the monochrome design
/// or the chosen one's name.
String accentName(BuildContext context, AppSettings s) {
  final l = AppLocalizations.of(context);
  if (s.accentKey == 'custom') return l.accentCustom;
  return accentPresetNames(l)[s.accentKey] ?? l.accentMono;
}

/// The presets' names in the user's language, by their settings key.
Map<String, String> accentPresetNames(AppLocalizations l) => {
  'ember': l.accentEmber,
  'gold': l.accentGold,
  'emerald': l.accentEmerald,
  'sapphire': l.accentSapphire,
  'amethyst': l.accentAmethyst,
  'rose': l.accentRose,
};

/// The row's little preview: the current accent as a ring, gray when the
/// design is its monochrome self.
class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // The light the app actually wears — the picked accent, or the home
    // design's own light — not only what the settings carry.
    final accent = AppAccent.current;
    final color = accent ?? (dark ? Colors.white : Colors.black);
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1.5,
        ),
      ),
    );
  }
}

/// The accent picker: the monochrome design first, then the curated
/// colors, then a custom one by its hex — all as clean round swatches in
/// a sheet that follows the theme. The sheet may take the screen and
/// scrolls the rest, so every color is reached on any phone.
Future<void> showAccentPicker(BuildContext context, AppSettings s) async {
  final l = AppLocalizations.of(context);
  final dark = Theme.of(context).brightness == Brightness.dark;
  final names = accentPresetNames(l);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    // The sheet grows past the default fraction: the whole list fits on
    // most phones, and the small ones scroll instead of cutting colors.
    isScrollControlled: true,
    backgroundColor: dark ? const Color(0xFF111111) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        // Listens to the settings, so the checkmarks move as soon as a
        // swatch is chosen.
        child: ListenableBuilder(
          listenable: s,
          builder: (context, _) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(
                l.accentColor,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              // The unpicked choice: the design's own light when the home
              // design carries one (the four looks do), the monochrome's
              // full contrast when it does not.
              _AccentTile(
                label: AppDesign.current.accentFor(dark) != null
                    ? l.accentDesign
                    : l.accentMono,
                color: AppDesign.current.accentFor(dark) ??
                    (dark ? Colors.white : Colors.black),
                selected: s.accentKey.isEmpty,
                onTap: () => s.update(accentKey: ''),
              ),
              for (final (key, color) in AppAccent.presets)
                _AccentTile(
                  label: names[key] ?? key,
                  color: color,
                  selected: s.accentKey == key,
                  onTap: () => s.update(accentKey: key),
                ),
              _AccentTile(
                label: l.accentCustom,
                color: Color(s.customAccent),
                selected: s.accentKey == 'custom',
                onTap: () async {
                  final hex = await _askAccentHex(context, s);
                  if (hex != null && context.mounted) {
                    s.update(accentKey: 'custom', customAccent: hex);
                  }
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

class _AccentTile extends StatelessWidget {
  const _AccentTile({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: AppAccent.onAccent(color),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
            if (selected)
              Icon(
                Icons.check_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

/// Asks for a custom accent by its hex (#RRGGBB or RRGGBB); returns it as
/// ARGB, or null when the sheet was dismissed or the text was not one.
Future<int?> _askAccentHex(BuildContext context, AppSettings s) async {
  final controller = TextEditingController(
    text: (s.customAccent & 0xFFFFFF).toRadixString(16).padLeft(6, '0'),
  );
  final l = AppLocalizations.of(context);
  final dark = Theme.of(context).brightness == Brightness.dark;
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.accentCustom),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            textDirection: TextDirection.ltr,
            maxLength: 7,
            decoration: InputDecoration(
              hintText: '#3ECF8E',
              counterText: '',
              prefixText: '# ',
            ),
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final color = _hexColor(controller.text);
              return Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color ?? (dark ? Colors.white : Colors.black),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () {
            final argb = _hexArgb(controller.text);
            if (argb != null) Navigator.pop(context, argb);
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ),
  );
}

/// The color in [text] (#RRGGBB or RRGGBB), or null when it is not one.
Color? _hexColor(String text) {
  final argb = _hexArgb(text);
  return argb == null ? null : Color(argb);
}

/// The color in [text] as its ARGB integer, or null when it is not one.
int? _hexArgb(String text) {
  final hex = text.trim().replaceFirst('#', '');
  if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) return null;
  return 0xFF000000 | int.parse(hex, radix: 16);
}

/// The row's name for the design the settings carry, in the row's
/// language.
String designName(AppLocalizations l, AppSettings s) => switch (s.homeDesign) {
  'bento' => l.designBento,
  'pixel' => l.designPixel,
  'ios' => l.designIos,
  'aether' => l.designAether,
  'zed' => l.designZed,
  'gazette' => l.designGazette,
  _ => l.designWheel,
};

/// The home design picker: the six real layouts the home page has —
/// the wheel, the tiles, the compact card, and the looks that carry
/// a whole palette of their own (the aether's iOS status card, the
/// zed's gradient blob, the gazette's front page) — each as a card with a small mock-up of itself
/// drawn in the theme's own ink, its name, and a word about what it is.
/// A tap chooses; the home page follows at once (the app's root rebuilds
/// on the settings), and with the two, the whole app's palette follows
/// with it.
Future<void> showDesignPicker(BuildContext context, AppSettings s) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context).designTitle),
      content: SizedBox(
        width: 460,
        child: ListenableBuilder(
          listenable: s,
          // Five designs now: five cards do not always fit a phone's
          // dialog, so the column scrolls.
          builder: (context, _) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final kind in [
                  'wheel',
                  'bento',
                  'pixel',
                  'ios',
                  'aether',
                  'zed',
                  'gazette',
                ]) ...[
                  _DesignCard(
                    kind: kind,
                    selected: s.homeDesign == kind,
                    onTap: () => s.update(homeDesign: kind),
                  ),
                  if (kind != 'gazette') const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    ),
  );
}

/// One design's card: the mock-up on top, the name and the description
/// under it, the chosen one framed in the accent.
class _DesignCard extends StatelessWidget {
  const _DesignCard({
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  final String kind;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accent = AppAccent.current;
    final scheme = theme.colorScheme;
    final (name, desc) = switch (kind) {
      'bento' => (l.designBento, l.designBentoDesc),
      'pixel' => (l.designPixel, l.designPixelDesc),
      'ios' => (l.designIos, l.designIosDesc),
      'aether' => (l.designAether, l.designAetherDesc),
      'zed' => (l.designZed, l.designZedDesc),
      'gazette' => (l.designGazette, l.designGazetteDesc),
      _ => (l.designWheel, l.designWheelDesc),
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? (accent ?? scheme.primary).withValues(alpha: 0.9)
                : scheme.outlineVariant,
            width: selected ? 1.6 : 1,
          ),
          color: selected
              ? (accent ?? scheme.primary).withValues(alpha: 0.07)
              : null,
        ),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 92,
              child: _DesignMockup(kind: kind, dark: theme.brightness == Brightness.dark, accent: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                color: accent ?? scheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

/// A small drawing of one design, made of the parts it lays out: the
/// wheel's flags in their arc, the tiles' bar and grid, the compact
/// card's chip and orb. In the theme's ink, the state's color on the
/// chosen part — a thumbnail, honest about the layout it names.
class _DesignMockup extends StatelessWidget {
  const _DesignMockup({
    required this.kind,
    required this.dark,
    required this.accent,
  });

  final String kind;
  final bool dark;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ink = dark ? const Color(0xFF3A3A3A) : const Color(0xFFC9C9C9);
    final lit = accent ?? (dark ? Colors.white : const Color(0xFF0A0A0A));
    Widget tile({double w = 16, double h = 12, Color? color, double r = 4}) =>
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
            color: color ?? ink,
            border: color == null
                ? Border.all(color: scheme.outlineVariant, width: 0.5)
                : null,
          ),
        );
    switch (kind) {
      case 'bento':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                tile(w: 22, h: 22, color: lit, r: 11),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tile(w: 34, h: 7),
                    const SizedBox(height: 3),
                    tile(w: 24, h: 5, color: ink.withValues(alpha: 0.5)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                tile(w: 26, h: 20),
                const SizedBox(width: 5),
                tile(w: 26, h: 20),
              ],
            ),
          ],
        );
      case 'pixel':
        // Material You: the big tonal card, the pill indicator's bar
        // under it — the shape speaks, not the line.
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
              ),
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lit,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // The M3 bar: the pill indicator around the chosen icon.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 26,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: lit.withValues(alpha: 0.25),
                  ),
                  child: Center(child: tile(w: 8, h: 8, color: lit, r: 4)),
                ),
                const SizedBox(width: 10),
                tile(w: 10, h: 10, r: 5),
              ],
            ),
          ],
        );
      case 'ios':
        // The system's own: the raised rounded card with the state's
        // word, and the tab bar's hairline with the tinted tab under it.
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 44,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: scheme.surface,
                border: Border.all(color: scheme.outlineVariant, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lit,
                        ),
                      ),
                      const SizedBox(width: 4),
                      tile(w: 22, h: 5),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.5),
                      color: lit,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // The tab bar's own line, the chosen tab tinted over it.
            SizedBox(
              width: 76,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      tile(w: 10, h: 10, color: lit, r: 5),
                      const SizedBox(height: 2),
                      tile(w: 14, h: 3, color: lit.withValues(alpha: 0.5)),
                    ],
                  ),
                  Column(
                    children: [
                      tile(w: 10, h: 10),
                      const SizedBox(height: 2),
                      tile(w: 14, h: 3),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      case 'aether':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 44,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: scheme.surface,
                border: Border.all(color: scheme.outlineVariant, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lit,
                        ),
                      ),
                      const SizedBox(width: 4),
                      tile(w: 22, h: 5),
                    ],
                  ),
                  const Spacer(),
                  tile(w: 30, h: 9, color: ink.withValues(alpha: 0.6)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: lit,
              ),
              child: const Center(child: SizedBox.shrink()),
            ),
          ],
        );
      case 'zed':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  startAngle: 0.6,
                  endAngle: 0.6 + 2 * math.pi,
                  colors: [
                    scheme.primary,
                    lit.withValues(alpha: 0.75),
                    lit,
                  ],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.power_settings_new_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 7),
            tile(w: 40, h: 7),
          ],
        );
      case 'gazette':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The masthead: the thick rule, the fine rule, the name.
            Container(height: 2.4, color: lit),
            const SizedBox(height: 2),
            Container(height: 1, color: ink.withValues(alpha: 0.55)),
            const SizedBox(height: 6),
            Center(child: tile(w: 30, h: 6, color: ink.withValues(alpha: 0.8))),
            const SizedBox(height: 6),
            Container(height: 1, color: ink.withValues(alpha: 0.55)),
            const SizedBox(height: 6),
            // The headline with the stamp beside it.
            Row(
              children: [
                tile(w: 42, h: 10, color: lit),
                const Spacer(),
                Container(
                  width: 22,
                  height: 14,
                  transform: Matrix4.rotationZ(-0.1),
                  transformAlignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: lit, width: 1.2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(height: 1, color: ink.withValues(alpha: 0.35)),
            const SizedBox(height: 6),
            // The numbers in their ruled columns.
            Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0)
                    Container(width: 1, height: 12, color: ink.withValues(alpha: 0.35)),
                  Expanded(child: Center(child: tile(w: 14, h: 8))),
                ],
              ],
            ),
          ],
        );
      default: // The wheel.
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 46,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        lit.withValues(alpha: 0.25),
                        lit.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    tile(w: 13, h: 9, color: ink.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    tile(w: 22, h: 16, color: lit),
                    const SizedBox(width: 4),
                    tile(w: 13, h: 9, color: ink.withValues(alpha: 0.6)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            tile(w: 30, h: 5, color: ink.withValues(alpha: 0.8)),
          ],
        );
    }
  }
}

/// The name of one map style, in the app's own language.
String mapStyleName(AppLocalizations l, GlobeStyle style) => switch (style) {
  GlobeStyle.midnight => l.mapMidnight,
  GlobeStyle.ocean => l.mapOcean,
  GlobeStyle.mono => l.mapMono,
  GlobeStyle.aurora => l.mapAurora,
  GlobeStyle.satellite => l.mapKindSatellite,
  _ => l.mapSilver,
};

/// One map style's tile: a small preview of the real palette — the same
/// [GlobePalette] the home's globe paints with — and the style's name
/// under it; the chosen one carries the accent's own frame.
class _GlobeStyleTile extends StatelessWidget {
  const _GlobeStyleTile({
    required this.style,
    required this.name,
    required this.dark,
    required this.selected,
    required this.onTap,
  });

  final GlobeStyle style;
  final String name;
  final bool dark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = selected ? theme.colorScheme.primary : Colors.transparent;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: accent, width: 2),
            ),
            child: SizedBox.square(
              dimension: 62,
              child: CustomPaint(
                painter: _GlobePreviewPainter(
                  palette: GlobePalette.of(style, dark),
                  dark: dark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The style's preview: the ball's own gradient, a breath of land, the
/// coordinate grid's arc, and the limb's light — small, but the same
/// colors the home's globe wears.
class _GlobePreviewPainter extends CustomPainter {
  _GlobePreviewPainter({required this.palette, required this.dark});

  final GlobePalette palette;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.46;

    // The ball, in the style's own metal.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = ui.Gradient.radial(
          center + Offset(-radius * 0.34, -radius * 0.4),
          radius * 1.7,
          palette.ball,
          const [0.0, 0.35, 0.72, 1.0],
        ),
    );

    // The land: two quiet shapes, enough to read as a map at this size.
    final land = Paint()..color = palette.landFill..isAntiAlias = true;
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = palette.landStroke
      ..isAntiAlias = true;
    final path = ui.Path()
      ..addOval(
        Rect.fromCenter(
          center: center + Offset(-radius * 0.22, -radius * 0.1),
          width: radius * 0.95,
          height: radius * 0.62,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: center + Offset(radius * 0.34, radius * 0.36),
          width: radius * 0.6,
          height: radius * 0.4,
        ),
      );
    canvas.drawPath(path, land);
    canvas.drawPath(path, edge);

    // A meridian and a parallel: the grid's own breath.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.99),
      math.pi * 0.15,
      math.pi * 1.7,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = palette.graticule,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.62),
      math.pi * 1.1,
      math.pi * 1.4,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = palette.graticule,
    );

    // The limb's light, in the style's own halo.
    canvas.drawCircle(
      center,
      radius - 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..shader = ui.Gradient.radial(
          center,
          radius,
          [
            palette.halo.withValues(alpha: 0.0),
            palette.halo.withValues(alpha: dark ? 0.6 : 0.4),
          ],
          const [0.7, 1.0],
        ),
    );
  }

  @override
  bool shouldRepaint(_GlobePreviewPainter old) =>
      old.palette != palette || old.dark != dark;
}

/// The name of one map kind, in the app's own language.
String mapKindName(AppLocalizations l, MapKind kind) => switch (kind) {
  MapKind.globe => l.mapKindGlobe,
  MapKind.flat => l.mapKindFlat,
  _ => l.mapKindClassic,
};

/// One map kind's tile: a small preview of the way the home's world is
/// carried — the flat map's quiet ink, its modern finish, the metal
/// ball — and the kind's name under it; the
/// chosen one carries the accent's own frame.
class _MapKindTile extends StatelessWidget {
  const _MapKindTile({
    required this.kind,
    required this.name,
    required this.dark,
    required this.selected,
    required this.onTap,
  });

  final MapKind kind;
  final String name;
  final bool dark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = selected ? theme.colorScheme.primary : Colors.transparent;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: accent, width: 2),
            ),
            child: SizedBox.square(
              dimension: 62,
              child: CustomPaint(
                painter: _MapKindPreviewPainter(kind: kind, dark: dark),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The kind's preview: a small map the kind's own way. The flat kinds
/// draw a small world (land shapes, a graticule, the lit country's
/// halo); the ball kinds draw a small sphere (the metal's gradient or
/// the satellite's oceans, the land's breath, the limb's light).
class _MapKindPreviewPainter extends CustomPainter {
  _MapKindPreviewPainter({required this.kind, required this.dark});

  final MapKind kind;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final ink = dark ? Colors.white : const Color(0xFF0A0A0A);
    final sphere = kind == MapKind.globe;

    // The land's small shapes: a hint of continents, drawn as blobs so a
    // preview reads as a world at 62 px without the real borders.
    final landPaint = Paint()
      ..color = sphere
          ? ink.withValues(alpha: dark ? 0.30 : 0.18)
          : ink.withValues(alpha: dark ? 0.24 : 0.16)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    if (!sphere) {
      // The flat kinds: a rounded map card, its graticule, the land, the
      // lit country's halo — the classic's quiet ink, or the modern
      // finish's shadow and stronger lit country.
      final modern = kind == MapKind.flat;
      final rect = Rect.fromCenter(
        center: c,
        width: size.width * 0.86,
        height: size.height * 0.5,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(7));
      if (modern) {
        canvas.drawRRect(
          rrect,
          Paint()
            ..color = (dark ? Colors.black : ink).withValues(
              alpha: dark ? 0.30 : 0.09,
            )
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.2),
        );
      }
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = ink.withValues(alpha: dark ? 0.05 : 0.04)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
      // The graticule: three meridians, one parallel.
      final grid = Paint()
        ..color = ink.withValues(alpha: dark ? 0.09 : 0.08)
        ..strokeWidth = 0.6;
      for (var i = 1; i <= 2; i++) {
        final x = rect.left + rect.width * i / 3;
        canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), grid);
      }
      canvas.drawLine(
        Offset(rect.left, c.dy),
        Offset(rect.right, c.dy),
        grid,
      );
      // A hint of continents: three blobs wide of the middle.
      _ellipse(canvas, rect.left + rect.width * 0.18, c.dy, 6.5, 4.0, landPaint);
      _ellipse(
        canvas,
        rect.left + rect.width * 0.46,
        c.dy - 2,
        4.0,
        3.0,
        landPaint,
      );
      _ellipse(
        canvas,
        rect.left + rect.width * 0.74,
        c.dy + 1,
        5.5,
        3.5,
        landPaint,
      );
      // The lit country: a small halo on the first blob, brighter where
      // the modern finish carries its own shadow.
      canvas.drawCircle(
        Offset(rect.left + rect.width * 0.18, c.dy - 1),
        7.5,
        Paint()
          ..color = ink.withValues(alpha: modern ? 0.34 : 0.20)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
          ..isAntiAlias = true,
      );
      canvas.drawCircle(
        Offset(rect.left + rect.width * 0.18, c.dy - 1),
        1.8,
        Paint()
          ..color = ink.withValues(alpha: dark ? 0.9 : 0.7)
          ..isAntiAlias = true,
      );
      return;
    }

    // The ball: its own gradient, the land, the limb.
    final radius = size.width * 0.42;
    final ball = Paint()
      ..shader = ui.Gradient.radial(
        c + Offset(-radius * 0.36, -radius * 0.4),
        radius * 1.7,
        dark
            ? const [
                Color(0xFF9AA3B2),
                Color(0xFF4A5160),
                Color(0xFF20242E),
                Color(0xFF0B0D12),
              ]
            : const [
                Color(0xFFF4F6FA),
                Color(0xFFC3C9D6),
                Color(0xFF8C93A3),
                Color(0xFF5D6371),
              ],
        const [0.0, 0.35, 0.72, 1.0],
      );
    canvas.drawCircle(c, radius, ball);
    // The land: a breath of continents on the ball's face.
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: c, radius: radius)),
    );
    canvas.drawCircle(
      c + Offset(-radius * 0.30, -radius * 0.10),
      radius * 0.30,
      landPaint,
    );
    _ellipse(
      canvas,
      c.dx + radius * 0.18,
      c.dy - radius * 0.34,
      radius * 0.16,
      radius * 0.10,
      landPaint,
    );
    _ellipse(
      canvas,
      c.dx + radius * 0.10,
      c.dy + radius * 0.30,
      radius * 0.22,
      radius * 0.12,
      landPaint,
    );
    canvas.restore();
    // The limb's light.
    canvas.drawCircle(
      c,
      radius - 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..shader = ui.Gradient.radial(
          c,
          radius,
          [
            (dark ? const Color(0xFF8FA0BC) : const Color(0xFF9FB0CC))
                .withValues(alpha: 0.0),
            (dark ? const Color(0xFF8FA0BC) : const Color(0xFF9FB0CC))
                .withValues(alpha: dark ? 0.6 : 0.4),
          ],
          const [0.7, 1.0],
        ),
    );
  }

  /// An oval at (cx, cy) with the radii [rx] and [ry] — the blobs the
  /// previews read as continents.
  void _ellipse(
    Canvas canvas,
    double cx,
    double cy,
    double rx,
    double ry,
    Paint paint,
  ) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_MapKindPreviewPainter old) =>
      old.kind != kind || old.dark != dark;
}

/// Android's battery-optimization state for this app, with the one-tap
/// ask and the system page for the OEMs' own killers. The tunnel dies
/// after the screen locks on Xiaomi, Samsung, and Huawei unless the user
/// stands the app outside optimization; this is where they do it.
class _BatteryWizard extends StatefulWidget {
  const _BatteryWizard();

  @override
  State<_BatteryWizard> createState() => _BatteryWizardState();
}

class _BatteryWizardState extends State<_BatteryWizard> {
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
    final theme = Theme.of(context);
    final ignored = _ignored;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.batteryWizardBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(l.batteryWizardSteps, style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        Row(
          children: [
            if (ignored == true)
              Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              )
            else if (ignored == false)
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: theme.colorScheme.error,
              )
            else
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                ignored == true ? l.batteryWizardOk : l.batteryWizardState,
                style: theme.textTheme.bodyMedium,
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
              FilledButton.icon(
                onPressed: () async {
                  await AndroidCore.requestIgnoreBattery();
                  if (!mounted) return;
                  await Future<void>.delayed(
                    const Duration(milliseconds: 600),
                  );
                  _refresh();
                },
                icon: const Icon(Icons.battery_saver_rounded),
                label: Text(l.batteryWizardPermit),
              ),
            OutlinedButton.icon(
              onPressed: AndroidCore.openBatterySettings,
              icon: const Icon(Icons.tune_rounded),
              label: Text(l.batteryWizardOpen),
            ),
          ],
        ),
      ],
    );
  }
}
