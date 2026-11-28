import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../core/core_controller.dart';
import '../l10n/app_localizations.dart';
import '../app_info.dart';
import 'about_page.dart';
import 'accounts_page.dart';
import 'format.dart' show formatBytes;
import 'servers_page.dart';
import 'ur_kit.dart';
import 'widgets.dart' show languageNames, languageStyle;
import 'whats_new.dart' show showWhatsNew, whatsNewSections;

/// The URnetwork settings screen, ported as it ships.
///
/// The original's layout: the big headline, the sections one under the
/// other with their twelve-point labels, each row a full-width tap that
/// answers with the soft bounce, the switches the app's own 36×20, the
/// links in the pink and the labels in the muted ink. The rows carry the
/// app's real settings; the deep pages (the servers, the accounts, the
/// about) open as they always have.
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

          // General: the language, and the switches the app really has.
          UrEntrance(index: 2, child: _SectionLabel(l.urSectionGeneral)),
          UrEntrance(
            index: 2,
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
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Appearance: the navigation style, the original's own picker —
          // the row shows the live choice and the sheet applies at once.
          UrEntrance(index: 3, child: _SectionLabel(l.urSectionAppearance)),
          UrEntrance(
            index: 3,
            child: ListenableBuilder(
              listenable: settings,
              builder: (context, _) => _Card(
                children: [
                  _NavRow(
                    icon: Icons.style_rounded,
                    label: l.urNavStyle,
                    value: switch (urNavStyleFor(settings.urNavStyle)) {
                      UrNavStyle.morphing => l.urNavMorphing,
                      UrNavStyle.neon => l.urNavNeon,
                      UrNavStyle.bubble => l.urNavBubble,
                      UrNavStyle.capsule => l.urNavCapsule,
                    },
                    onTap: () => showUrNavStylePicker(context, settings),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      l.urNavStyleNote,
                      style: const TextStyle(
                          fontSize: 12.5, color: UrTokens.faint),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // About: the version (with its what's-new when this build has
          // one), and the app's own page.
          UrEntrance(index: 4, child: _SectionLabel(l.urSectionAbout)),
          UrEntrance(
            index: 4,
            child: _Card(
              children: [
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
  final ValueChanged<bool> onChanged;

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
          UrSwitch(checked: value, onToggle: () => onChanged(!value)),
        ],
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
