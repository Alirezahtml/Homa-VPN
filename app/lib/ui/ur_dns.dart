import 'package:flutter/material.dart';

import '../core/core_controller.dart';
import '../l10n/app_localizations.dart';
import '../app_settings.dart';
import 'format.dart';
import 'settings_page.dart' show dnsPresets;
import 'ur_kit.dart';
import 'ur_stats.dart' show urAdsRule, urStatusGreen;
import 'widgets.dart' show runShowingErrors, showToast;

/// The DNS page, the original's own screen ported (stats/DnsSettingsScreen.kt
/// as the screenshots carry it): the custom DNS card with the presets and
/// the manual list, the four status rows the drawer's card shows, the ad and
/// tracker blocker's own switch, and the session's data bar.
///
/// Every row keeps a setting the core already has: `dns.servers` and
/// `dns.fallback_to_system` through the settings API, the ads category
/// through the routing block list, and the data limit through the app's own
/// preferences. Nothing of the core's own is touched.

/// The kind of one server line: the same kinds the classic page names.
enum _DnsKind { doh, dot, plain }

_DnsKind? _dnsKind(String line) {
  final s = line.trim();
  if (s.startsWith('https://')) return _DnsKind.doh;
  if (s.startsWith('tls://')) return _DnsKind.dot;
  // a plain IP the core resolves over UDP
  final host = s.contains(':') && !s.contains(']') ? s.split(':').first : s;
  if (RegExp(r'^\d{1,3}(\.\d{1,3}){3}$').hasMatch(host)) return _DnsKind.plain;
  return null;
}

class UrDnsPage extends StatefulWidget {
  const UrDnsPage({super.key, required this.core, required this.settings});

  final CoreController core;
  final AppSettings settings;

  @override
  State<UrDnsPage> createState() => _UrDnsPageState();
}

class _UrDnsPageState extends State<UrDnsPage> {
  Map<String, Object?>? _config;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await widget.core.settings();
      if (mounted) setState(() => _config = config);
    } on Exception {
      // the shell shows the problem when a save needs it
    }
  }

  Object? _get(List<String> path) {
    Object? node = _config;
    for (final key in path) {
      if (node is! Map<String, Object?>) return null;
      node = node[key];
    }
    return node;
  }

  bool _bool(List<String> path) => _get(path) == true;

  List<String> _servers() => [
    for (final v in (_get(['dns', 'servers']) as List<Object?>? ?? const []))
      '$v',
  ];

  bool get _blocksAds {
    final block = _get(['routing', 'block']);
    return block is List<Object?> &&
        block.any((r) => '$r'.trim().toLowerCase() == urAdsRule);
  }

  /// Saves [values] (path → value) through the core and reads the config
  /// again — the walk the section pages take, nothing else.
  Future<void> _save(Map<List<String>, Object?> values) async {
    if (_saving) return;
    setState(() => _saving = true);
    final ok = await runShowingErrors(
      context,
      () => widget.core.editSettings((config) {
        for (final entry in values.entries) {
          final path = entry.key;
          Map<String, Object?> node = config;
          for (final key in path.take(path.length - 1)) {
            node = switch (node[key]) {
              final Map<String, Object?> m => m,
              _ => node[key] = <String, Object?>{},
            };
          }
          node[path.last] = entry.value;
        }
      }),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      await _load();
      if (mounted) showToast(context, AppLocalizations.of(context).saved);
    }
  }

  Future<void> _setBlockAds(bool on) => _save({
    ['routing', 'block']: [
      for (final r
          in (_get(['routing', 'block']) as List<Object?>? ?? const []))
        if ('$r'.trim().toLowerCase() != urAdsRule) r,
      if (on) urAdsRule,
    ],
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final servers = _servers();
    final presetKey = dnsPresets.entries
        .where((e) => e.value.join(',') == servers.join(','))
        .firstOrNull
        ?.key;
    final preset = presetKey ?? 'custom';
    final names = {
      'system': l.dnsSystem,
      'auto': l.dnsAuto,
      'adguard': l.urDnsAdguard,
      'cloudflare': 'Cloudflare',
      'google': 'Google',
      'quad9': 'Quad9',
      'cloudflare_dot': 'Cloudflare (DNS over TLS)',
      'custom': l.dnsManual,
    };
    final doh = servers.any((s) => _dnsKind(s) == _DnsKind.doh);
    final dot = servers.any((s) => _dnsKind(s) == _DnsKind.dot);
    final plain = servers.any((s) => _dnsKind(s) == _DnsKind.plain);
    final fallback = _bool(['dns', 'fallback_to_system']);

    return Container(
      color: UrTokens.bg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(l.sectionDns, style: urTitleStyle(context)),
          const SizedBox(height: 24),

          // The custom DNS card: the preset row, the status rows, and the
          // manual list under them.
          _SectionLabel(l.urDnsCard),
          _Card(
            children: [
              _NavRow(
                icon: Icons.dns_rounded,
                label: l.dnsPreset,
                value: names[preset] ?? preset,
                onTap: () => _pickPreset(names, presetKey),
              ),
              _HairLine(),
              _statusRow(l.urDnsRowDoh, doh),
              _HairLine(),
              _statusRow(l.urDnsRowDot, dot),
              _HairLine(),
              _statusRow(l.urDnsRowPlain, plain),
              _HairLine(),
              _SwitchRow(
                label: l.urDnsRowLocal,
                subtitle: l.dnsFallback,
                value: fallback,
                onChanged: _saving
                    ? null
                    : (v) => _save({
                        ['dns', 'fallback_to_system']: v,
                      }),
              ),
              _HairLine(),
              // the manual list: one row per server, and the add row
              for (var i = 0; i < servers.length; i++) ...[
                _serverRow(servers[i], i),
                if (i < servers.length - 1) _HairLine(),
              ],
              if (servers.isNotEmpty) _HairLine(),
              _NavRow(
                icon: Icons.add_rounded,
                label: l.dnsManual,
                value: l.dnsManualHint,
                onTap: _addServer,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // The ad and tracker blocker: the same switch the drawer's panel
          // carries, filling the routing block list with the ads category.
          _SectionLabel(l.urDnsBlocker),
          _Card(
            children: [
              _SwitchRow(
                label: l.urDnsBlocker,
                subtitle: l.urDnsBlockerNote,
                value: _blocksAds,
                onChanged: _saving ? null : (v) => _setBlockAds(v),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // The session's data bar: the app's own limit with the session's
          // traffic against it, the used share in the blue and the rest in
          // the faint ink.
          _SectionLabel(l.dataLimit),
          _Card(
            children: [
              _SwitchRow(
                label: l.dataLimit,
                subtitle: l.dataLimitHint,
                value: widget.settings.dataLimit,
                onChanged: (v) => widget.settings.update(dataLimit: v),
              ),
              if (widget.settings.dataLimit) ...[
                _HairLine(),
                _dataBar(),
              ],
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// The data bar: the session's bytes against the limit, the same twelve
  /// point bar the usage card draws.
  Widget _dataBar() {
    final l = AppLocalizations.of(context);
    final limitMb = widget.settings.dataLimitMb;
    final limit = limitMb <= 0 ? 0 : limitMb * 1000 * 1000;
    final traffic = widget.core.status?.traffic;
    final used = traffic == null ? 0 : traffic.up + traffic.down;
    final share = limit <= 0
        ? 0.0
        : (used / limit).clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    flex: (share * 1000).round().clamp(1, 1000).toInt(),
                    child: ColoredBox(color: UrTokens.blue),
                  ),
                  Expanded(
                    flex: 1000 - (share * 1000).round().clamp(1, 1000).toInt(),
                    child: ColoredBox(
                      color: UrTokens.faint.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.usedOf(
                    formatBytes(used),
                    limit <= 0 ? '∞' : formatBytes(limit),
                  ),
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: UrTokens.muted,
                  ),
                ),
              ),
              _NavInline(
                label: l.dataLimitAmount,
                value: limitMb > 0 ? '$limitMb MB' : '',
                onTap: () => _pickLimit(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickLimit() async {
    final l = AppLocalizations.of(context);
    final amounts = [256, 512, 1024, 2048, 5120, 10240, 25600, 51200];
    final picked = await showModalBottomSheet<int>(
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
                  l.dataLimitAmount,
                  style: urTitleStyle(context).copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final mb in amounts)
                  _Tile(
                    label: mb >= 1024
                        ? '${ltr((mb / 1024).toStringAsFixed(mb % 1024 == 0 ? 0 : 1))} GiB'
                        : '$mb MB',
                    selected: widget.settings.dataLimitMb == mb,
                    onTap: () => Navigator.of(context).pop(mb),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (picked != null) widget.settings.update(dataLimitMb: picked);
  }

  /// The preset sheet: the named presets first, the manual entry last.
  Future<void> _pickPreset(Map<String, String> names, String? current) async {
    final l = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<String>(
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
                  l.dnsPreset,
                  style: urTitleStyle(context).copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                for (final key in ['system', 'auto', 'adguard', 'cloudflare',
                    'google', 'quad9', 'cloudflare_dot', 'custom'])
                  _Tile(
                    label: names[key] ?? key,
                    selected: key == current,
                    onTap: () => Navigator.of(context).pop(key),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (picked == null || picked == 'custom' || picked == current) return;
    await _save({
      ['dns', 'servers']: dnsPresets[picked]!,
    });
  }

  /// One server line of the manual list: the kind's word, the line itself,
  /// and the remove icon.
  Widget _serverRow(String server, int index) {
    final l = AppLocalizations.of(context);
    final kind = switch (_dnsKind(server)) {
      _DnsKind.doh => 'DoH',
      _DnsKind.dot => 'DoT',
      _DnsKind.plain => l.dnsSystem,
      null => '',
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 44,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: UrTokens.border,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              kind,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.5, color: UrTokens.muted),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              server,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: UrTokens.ink),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: UrTokens.muted,
            onPressed: _saving
                ? null
                : () => _save({
                    ['dns', 'servers']: [
                      for (var k = 0; k < _servers().length; k++)
                        if (k != index) _servers()[k],
                    ],
                  }),
          ),
        ],
      ),
    );
  }

  /// The add dialog: one line, checked as the classic page checks it.
  Future<void> _addServer() async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    final line = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l.dnsManual, style: const TextStyle(fontSize: 18)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l.dnsManualHint,
            hintStyle: const TextStyle(fontSize: 12, color: UrTokens.muted),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              MaterialLocalizations.of(context).cancelButtonLabel,
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (line == null || line.isEmpty || !mounted) return;
    if (_dnsKind(line) == null) {
      showToast(context, l.dnsManualInvalid);
      return;
    }
    await _save({
      ['dns', 'servers']: [..._servers(), line],
    });
  }

  /// One status row, the drawer card's own shape.
  Widget _statusRow(String label, bool on) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: on ? urStatusGreen : UrTokens.faint.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14.5, color: UrTokens.ink),
            ),
          ),
          Text(
            on ? l.urOn : l.urOff,
            style: TextStyle(
              fontSize: 14,
              color: on ? urStatusGreen : UrTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}

/// The section's twelve-point label, the cards' shell, and the rows — the
/// settings page's own shapes, local to this page.
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

class _HairLine extends StatelessWidget {
  const _HairLine();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: UrTokens.border);
}

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
  Widget build(BuildContext context) => UrPressable(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 12.5, color: UrTokens.muted),
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

/// The limit picker's inline row, without an icon: the word and the value.
class _NavInline extends StatelessWidget {
  const _NavInline({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => UrPressable(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: UrTokens.muted),
            ),
            if (value.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: UrTokens.ink,
                ),
              ),
            ],
            const SizedBox(width: 2),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: UrTokens.muted,
            ),
          ],
        ),
      );
}

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
            onToggle: onChanged == null ? () {} : () => onChanged!(!value),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => UrPressable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: selected ? UrTokens.bgTinted : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? UrTokens.pink.withValues(alpha: 0.35)
                  : UrTokens.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: UrTokens.ink,
                  ),
                ),
              ),
              if (selected)
                const Icon(Icons.check_rounded, size: 18, color: UrTokens.pink),
            ],
          ),
        ),
      );
}
