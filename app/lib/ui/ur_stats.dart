import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_controller.dart';
import '../core/models.dart';
import '../l10n/app_localizations.dart';
import 'bypass_apps_page.dart' show BypassAppsPage;
import 'format.dart';
import 'settings_page.dart' show dnsPresets;
import 'ur_dns.dart' show UrDnsPage;
import 'ur_kit.dart';
import 'widgets.dart' show runShowingErrors;

/// The connect drawer's statistics sections, ported as the original ships
/// them — the cards under the fold (stats/ConnectStatsSections.kt): the
/// client statistics with the transfer chart, the transports bar and the
/// address families under it, the split apps row, the local statistics with
/// the split rules' count, the custom DNS summary, and the ad and tracker
/// blocker's own panel.
///
/// Every number here is one the app's core already reports or a setting it
/// already keeps: the transports read the proxy's connections
/// (`GET /api/connections`, the carrier each open one rides), the address
/// families read the exit's addresses, the local traffic reads the traffic
/// counter's direct side, the DNS rows read `dns.servers` and
/// `dns.fallback_to_system`, and the blocker reads the routing block list.
/// Nothing of the core's own is touched: the writes go through the settings
/// API the section pages always used.

/// The carriers' brand colors, the original's own mapping
/// (stats/TransportStatusPresentation.kt): H3 the green, HTTP/1 and HTTP/2
/// the pale blue, the queued bucket the muted gray — coral is deliberately
/// left out so the bar never reads as the blocked chart.
const _h3Color = Color(0xFF87FB67); // Green300
const _h1Color = Color(0xFFD6E6F4); // BlueLight (Blue200)
const _h2Color = Color(0xFFA4C4F4); // Blue300, between the two blues
const _queuedColor = Color(0xFF5A5A5A);

/// The status rows' green: the dot and the word when a row is on (the
/// original's Green300, shared with the DNS page).
const urStatusGreen = Color(0xFF87FB67); // Green300

/// The bar's own measures: eight points tall, one second of tween, the
/// legend's dot at six.
const _barHeight = 8.0;
const _tweenMs = Duration(milliseconds: 1000);

/// One carrier's share of the open connections: the label it shows and its
/// share in the whole.
class TransportShare {
  const TransportShare(this.label, this.color, this.count, this.used);

  final String label;
  final Color color;
  final int count;
  final bool used;
}

/// The carriers the proxy's connections ride, in the original's stable
/// order: the ones with traffic first (largest share first within the bar's
/// geometry), the ones without carried by the unused footer.
List<TransportShare> transportShares(
  List<ProxyConnection> connections,
  String configured,
) {
  final counts = <String, int>{};
  var open = 0;
  for (final c in connections) {
    if (!c.open) continue;
    open++;
    final t = c.transport.trim().toLowerCase();
    counts[t] = (counts[t] ?? 0) + 1;
  }
  // The carriers in the original's stable order; the core names h2 and h3,
  // and the configured h1 shows in the footer until a connection rides it.
  const order = ['h3', 'h2', 'h1'];
  final shares = <TransportShare>[];
  for (final t in order) {
    final n = counts[t] ?? 0;
    shares.add(
      TransportShare(
        t.toUpperCase(),
        switch (t) {
          'h3' => _h3Color,
          'h2' => _h2Color,
          _ => _h1Color,
        },
        n,
        n > 0,
      ),
    );
  }
  // Anything else the core names later lands in the queued bucket.
  final known = order.toSet();
  var other = 0;
  for (final e in counts.entries) {
    if (!known.contains(e.key)) other += e.value;
  }
  if (other > 0) {
    shares.add(TransportShare('Q', _queuedColor, other, true));
  }
  // The configured carrier with no connection yet: the footer's hollow dot.
  if (open == 0 && configured.isNotEmpty) {
    for (var i = 0; i < shares.length; i++) {
      if (shares[i].label == configured.toUpperCase()) {
        shares[i] = TransportShare(
          shares[i].label,
          shares[i].color,
          0,
          false,
        );
      }
    }
  }
  return shares;
}

/// The transports bar, the original's own: an empty rounded track with the
/// carriers' segments over it, hairline separators between neighbors, the
/// legend's dot and percent for the used ones, and the unused footer's
/// hollow dots for the enabled ones that carried nothing.
class UrTransportBar extends StatelessWidget {
  const UrTransportBar({super.key, required this.shares});

  final List<TransportShare> shares;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final open = shares.fold<int>(0, (n, s) => n + s.count);
    final used = shares.where((s) => s.used).toList();
    final unused = shares.where((s) => !s.used).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // the title row: the word and the caret, the card's own style
        Row(
          children: [
            Expanded(
              child: Text(
                l.urTransports,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: UrTokens.muted,
                ),
              ),
            ),
            Text(
              open > 0 ? l.connectionsOpen(open) : l.urNoData,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: UrTokens.faint,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // the bar: the track, then one clip holding every segment, so the
        // separators never leave the rounded ends
        ClipRRect(
          borderRadius: BorderRadius.circular(_barHeight / 2),
          child: SizedBox(
            height: _barHeight,
            width: double.infinity,
            child: Row(
              children: [
                for (final s in used)
                  Expanded(
                    flex: s.count,
                    child: ColoredBox(color: s.color),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        // the legend: dot, name, percent for every carrier with traffic
        if (used.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              for (final s in used)
                _legendItem(
                  dot: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: s.color,
                    ),
                  ),
                  label: s.label,
                  value: '${(s.count * 100 / open).round()}%',
                  valueColor: UrTokens.muted,
                ),
            ],
          ),
        // the unused footer: the word, then a hollow dot per idle carrier
        if (unused.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  l.urTransportUnused,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: UrTokens.faint,
                  ),
                ),
                for (final s in unused)
                  _legendItem(
                    dot: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: s.color.withValues(alpha: 0.6)),
                      ),
                    ),
                    label: s.label,
                    value: '',
                    valueColor: UrTokens.faint,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _legendItem({
    required Widget dot,
    required String label,
    required String value,
    required Color valueColor,
  }) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot,
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: UrTokens.ink,
            ),
          ),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ],
        ],
      );
}

/// The address families, the original's three columns under the transports:
/// Dualstack, IPv4 and IPv6, each either lit when the exit carries that
/// family or dimmed out with the word for disconnected. The columns rank:
/// dualstack carries both, and the two singles tie below it.
class UrIpFamilyRow extends StatelessWidget {
  const UrIpFamilyRow({super.key, required this.exit});

  final ExitInfo? exit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final v4 = exit != null && exit!.ipv4.isNotEmpty;
    final v6 = exit != null && exit!.ipv6.isNotEmpty;
    // the tier: the best family with an address is lit, the rest dimmed
    final dual = v4 && v6;
    final best = dual ? 0 : (v4 || v6 ? 1 : 2);

    Widget column(String label, bool on, int rank) {
      // the tier decides the ink: lit, dimmed, or dimmed out
      final color = rank == best
          ? UrTokens.ink
          : on
          ? UrTokens.muted
          : UrTokens.faint;
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedSwitcher(
              duration: _tweenMs,
              child: Text(
                on ? l.stateConnected : l.stateOff,
                key: ValueKey(on),
                style: TextStyle(
                  fontSize: 11.5,
                  color: on ? color : UrTokens.faint,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        column(l.urIpFamilyDual, dual, 0),
        const SizedBox(width: 8),
        column(l.urIpFamilyV4, v4, 1),
        const SizedBox(width: 8),
        column(l.urIpFamilyV6, v6, 1),
      ],
    );
  }
}

/// The split apps row, the original's own panel: the count of the chosen
/// apps (the phone's per-app proxy keeps) and the caret to the page. With
/// nothing chosen the starter line stands in place of a zero.
class UrSplitPanel extends StatelessWidget {
  const UrSplitPanel({super.key, this.push});

  final void Function(String title, Widget page)? push;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        AndroidCore.selectedAppsCount,
        AndroidCore.appRoutingMode,
      ]),
      builder: (context, _) {
        final n = AndroidCore.selectedAppsCount.value;
        final text = n > 0 ? l.bypassAppsCount('$n') : l.urSplitStarter;
        return UrPressable(
          onTap: push == null
              ? null
              : () => push!(l.bypassApps, BypassAppsPage()),
          child: Container(
            decoration: BoxDecoration(
              color: UrTokens.bgTinted,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: UrTokens.ink,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: UrTokens.faint,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The local statistics card: the traffic that walked around the tunnel
/// (the counter's direct side, sampled into its own mirrored chart) and the
/// split rules' count under it. The samples come from the status the
/// controller already polls — no second poller of its own.
class UrLocalStatsCard extends StatefulWidget {
  const UrLocalStatsCard({super.key, required this.core, this.push});

  final CoreController core;
  final void Function(String title, Widget page)? push;

  @override
  State<UrLocalStatsCard> createState() => _UrLocalStatsCardState();
}

class _UrLocalStatsCardState extends State<UrLocalStatsCard> {
  final List<List<double>> _samples = [];
  int? _lastUp;
  int? _lastDown;
  DateTime? _lastAt;
  int _directUp = 0;
  int _directDown = 0;

  @override
  void initState() {
    super.initState();
    widget.core.addListener(_sample);
  }

  @override
  void dispose() {
    widget.core.removeListener(_sample);
    super.dispose();
  }

  /// One sample per status walk: the direct counter's delta over the time
  /// the walk took, in bytes a second.
  void _sample() {
    final traffic = widget.core.status?.traffic;
    if (traffic == null) return;
    final now = DateTime.now();
    final up = traffic.directUp;
    final down = traffic.directDown;
    final at = _lastAt;
    if (_lastUp != null && _lastDown != null && at != null) {
      final dt = now.difference(at).inMilliseconds / 1000;
      if (dt > 0.3) {
        final upRate = math.max(0, up - _lastUp!) / dt;
        final downRate = math.max(0, down - _lastDown!) / dt;
        setState(() {
          _samples.add([upRate, downRate]);
          if (_samples.length > 60) _samples.removeAt(0);
          _directUp = up;
          _directDown = down;
        });
      }
    }
    _lastUp = up;
    _lastDown = down;
    _lastAt = now;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final count = AndroidCore.selectedAppsCount.value;
    return _StatsCard(
      title: l.urStatsLocal,
      onTap: widget.push == null
          ? null
          : () => widget.push!(l.bypassApps, BypassAppsPage()),
      children: [
        if (_samples.length < 2)
          SizedBox(
            height: 72,
            child: Center(
              child: Text(
                l.urNoData,
                style: const TextStyle(fontSize: 12.5, color: UrTokens.muted),
              ),
            ),
          )
        else
          SizedBox(
            height: 72,
            child: CustomPaint(
              size: Size.infinite,
              painter: _DirectPainter(samples: _samples),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              l.urDirectTraffic,
              style: const TextStyle(fontSize: 13.5, color: UrTokens.muted),
            ),
            const Spacer(),
            Text(
              '${ltr(formatBytes(_directUp))} ↑ · ${ltr(formatBytes(_directDown))} ↓',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: UrTokens.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l.urSplitRulesCount(count),
          style: const TextStyle(fontSize: 14, color: UrTokens.ink),
        ),
      ],
    );
  }
}

/// The direct traffic's own mirrored chart, the client chart's shape at the
/// smaller height: the send above the center line, the receive below it,
/// each scaled to its own window peak.
class _DirectPainter extends CustomPainter {
  _DirectPainter({required this.samples});

  final List<List<double>> samples;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.height / 2;
    canvas.drawLine(
      Offset(0, center),
      Offset(size.width, center),
      Paint()
        ..color = UrTokens.border
        ..strokeWidth = 1,
    );
    if (samples.length < 2) return;

    double peak(int i) {
      var p = 1.0;
      for (final s in samples) {
        p = math.max(p, s[i]);
      }
      return p;
    }

    final room = center - 6;

    void draw(int i, double peak, Color color, bool above) {
      final line = Path();
      final fill = Path();
      final n = samples.length;
      for (var k = 0; k < n; k++) {
        final x = size.width * k / (n - 1);
        final v = (samples[k][i] / peak).clamp(0.0, 1.0).toDouble();
        final y = above ? center - v * room : center + v * room;
        if (k == 0) {
          line.moveTo(x, y);
          fill.moveTo(x, center);
        } else {
          line.lineTo(x, y);
        }
        fill.lineTo(x, y);
      }
      fill.lineTo(size.width, center);
      fill.close();
      canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.10));
      canvas.drawPath(
        line,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }

    draw(0, peak(0), UrTokens.blue, true);
    draw(1, peak(1), UrTokens.faint, false);
  }

  @override
  bool shouldRepaint(_DirectPainter old) => old.samples != samples;
}

/// The custom DNS summary card: what the settings select as one line, then
/// the four status rows — DNS over HTTPS, DNS over TLS, the unencrypted
/// ones, and the local fallback — dot, word, and on or off at the end.
class UrDnsCard extends StatefulWidget {
  const UrDnsCard({super.key, required this.core, required this.settings, this.push});

  final CoreController core;
  final AppSettings settings;
  final void Function(String title, Widget page)? push;

  @override
  State<UrDnsCard> createState() => _UrDnsCardState();
}

class _UrDnsCardState extends State<UrDnsCard> {
  Map<String, Object?>? _config;

  @override
  void initState() {
    super.initState();
    _read();
  }

  Future<void> _read() async {
    try {
      final config = await widget.core.settings();
      if (!mounted) return;
      setState(() => _config = config);
    } on Exception {
      // The next open reads again.
    }
  }

  @override
  void didUpdateWidget(UrDnsCard old) {
    super.didUpdateWidget(old);
    // the drawer rebuilds on every status walk; a return from the DNS page
    // lands here too, so the summary reads the servers again
    _read();
  }

  List<String> _servers() => [
    for (final v in (_at(['dns', 'servers']) as List<Object?>? ?? const []))
      '$v',
  ];

  Object? _at(List<String> path) {
    Object? node = _config;
    for (final key in path) {
      if (node is! Map<String, Object?>) return null;
      node = node[key];
    }
    return node;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final config = _config;
    final servers = _servers();
    final doh = servers.any((s) => s.startsWith('https://'));
    final dot = servers.any((s) => s.startsWith('tls://'));
    final plain = servers.any(
      (s) => !s.startsWith('https://') && !s.startsWith('tls://'),
    );
    final local = _at(['dns', 'fallback_to_system']) == true;
    // the summary line: the preset the list matches, or Custom
    final presetKey = dnsPresets.entries
        .where((e) => e.value.join(',') == servers.join(','))
        .firstOrNull
        ?.key;
    final summary = switch (presetKey) {
      'system' => l.dnsSystem,
      'auto' => l.dnsAuto,
      'cloudflare' => 'Cloudflare',
      'google' => 'Google',
      'quad9' => 'Quad9',
      'cloudflare_dot' => 'Cloudflare (DNS over TLS)',
      'adguard' => l.urDnsAdguard,
      _ => servers.isEmpty ? l.dnsSystem : l.dnsCustom,
    };

    return _StatsCard(
      title: l.urDnsCard,
      onTap: widget.push == null
          ? null
          : () => widget.push!(
              l.sectionDns,
              UrDnsPage(core: widget.core, settings: widget.settings),
            ),
      children: [
        Text(
          summary,
          style: const TextStyle(fontSize: 14, color: UrTokens.ink),
        ),
        const SizedBox(height: 10),
        if (config == null)
          Text(
            l.urNoData,
            style: const TextStyle(fontSize: 13.5, color: UrTokens.faint),
          )
        else ...[
          _statusRow(l.urDnsRowDoh, doh),
          const SizedBox(height: 8),
          _statusRow(l.urDnsRowDot, dot),
          const SizedBox(height: 8),
          _statusRow(l.urDnsRowPlain, plain),
          const SizedBox(height: 8),
          _statusRow(l.urDnsRowLocal, local),
        ],
      ],
    );
  }

  /// One status row, the original's own: the six-point dot in the green or
  /// the faint gray, the label, and On or Off at the end.
  Widget _statusRow(String label, bool on) => Row(
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
              style: const TextStyle(fontSize: 14, color: UrTokens.ink),
            ),
          ),
          Text(
            on ? AppLocalizations.of(context).urOn : AppLocalizations.of(context).urOff,
            style: TextStyle(
              fontSize: 14,
              color: on ? urStatusGreen : UrTokens.muted,
            ),
          ),
        ],
      );
}

/// The ad and tracker blocker's own panel under the custom DNS summary: the
/// switch that fills the routing block list with the ads category, beside
/// any DNS choice.
class UrBlockerPanel extends StatefulWidget {
  const UrBlockerPanel({super.key, required this.core});

  final CoreController core;

  @override
  State<UrBlockerPanel> createState() => _UrBlockerPanelState();
}

/// The block rule the ads category rides: the same rule the classic
/// settings' switch fills.
const urAdsRule = 'geosite:category-ads-all';

class _UrBlockerPanelState extends State<UrBlockerPanel> {
  bool? _on;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _read();
  }

  Future<void> _read() async {
    try {
      final config = await widget.core.settings();
      if (!mounted) return;
      final block = switch (config['routing']) {
        final Map<String, Object?> m => m['block'],
        _ => null,
      };
      setState(() {
        _on = block is List<Object?> &&
            block.any((r) => '$r'.trim().toLowerCase() == urAdsRule);
      });
    } on Exception {
      if (!mounted) return;
      setState(() => _on = null);
    }
  }

  Future<void> _toggle(bool v) async {
    if (_saving) return;
    setState(() => _saving = true);
    final ok = await runShowingErrors(
      context,
      () => widget.core.editSettings((config) {
        final routing = switch (config['routing']) {
          final Map<String, Object?> m => m,
          _ => <String, Object?>{},
        };
        final block = [
          for (final r in (routing['block'] as List<Object?>? ?? const []))
            if ('$r'.trim().toLowerCase() != urAdsRule) r,
          if (v) urAdsRule,
        ];
        routing['block'] = block;
        config['routing'] = routing;
      }),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) _read();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: UrTokens.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  l.urDnsBlocker,
                  style: const TextStyle(fontSize: 14.5, color: UrTokens.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  l.urDnsBlockerNote,
                  style: const TextStyle(fontSize: 12, color: UrTokens.muted),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(width: 12),
          UrSwitch(
            checked: _on ?? false,
            onToggle: _on == null ? () {} : () => _toggle(!_on!),
          ),
        ],
      ),
    );
  }
}

/// The stats card's shell, the original's own: the tinted card, the muted
/// title with the caret at the end, the children under it — the whole card
/// one tap when a page stands behind it.
class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.title,
    required this.children,
    this.onTap,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      decoration: BoxDecoration(
        color: UrTokens.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: UrTokens.muted,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: UrTokens.faint,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
    if (onTap == null) return body;
    // the card itself one tap: the soft bounce, then the page
    return UrPressable(onTap: onTap, child: body);
  }
}
