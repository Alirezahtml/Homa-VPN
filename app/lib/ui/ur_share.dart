import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../core/core_controller.dart';
import '../l10n/app_localizations.dart';
import 'ur_kit.dart';
import 'widgets.dart' show showToast;

/// The hotspot share page: this phone's tunnel opened to the devices on
/// its own hotspot.
///
/// The core's proxy listens on the loopback; one settings change opens it
/// on every interface while the share is on, and the page puts the
/// address in the user's hand: turn the hotspot on, connect the other
/// device, set its proxy to this address. The same listener answers the
/// SOCKS5 and the HTTP proxy, so a device without a manual-proxy row can
/// point a SOCKS app at it instead. The share off, the listener closes
/// back to the loopback and the proxy restarts.
class UrSharePage extends StatefulWidget {
  const UrSharePage({
    super.key,
    required this.core,
    required this.settings,
  });

  final CoreController core;
  final AppSettings settings;

  @override
  State<UrSharePage> createState() => _UrSharePageState();
}

class _UrSharePageState extends State<UrSharePage> {
  static const _channel = MethodChannel('app/android');

  bool _busy = false;
  bool _on = false;
  int _port = 10810;
  String? _error;
  String _address = '';

  @override
  void initState() {
    super.initState();
    _read();
  }

  /// Reads the proxy's listen address out of the core's settings and the
  /// hotspot's own address off the interfaces. A core that is not
  /// answering leaves the page readable; the toggle only says what it
  /// could not.
  Future<void> _read() async {
    try {
      final config = await widget.core.call((api) => api.settings());
      final proxy = switch (config['proxy']) {
        final Map<String, Object?> p => p,
        _ => <String, Object?>{},
      };
      final listen = (proxy['listen'] as String?) ?? '127.0.0.1:$_port';
      final colon = listen.lastIndexOf(':');
      final p = colon < 0 ? null : int.tryParse(listen.substring(colon + 1));
      _port = p ?? 10810;
      _on = colon > 0 &&
          (listen.substring(0, colon) == '0.0.0.0' ||
              listen.substring(0, colon) == '::');
    } on Exception catch (e) {
      _error = e.toString();
    }
    final ip = await _hotspotIp();
    if (!mounted) return;
    setState(() {
      _address = ip.isEmpty ? '' : '$ip:$_port';
    });
  }

  /// The address the other devices dial: the hotspot interface's own IPv4
  /// when the phone carries one, else the first local address that is not
  /// the mobile data's or the tunnel's.
  static Future<String> _hotspotIp() async {
    try {
      final candidates = <String>[];
      final list = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final i in list) {
        if (i.addresses.isEmpty) continue;
        final a = i.addresses.first.address;
        final n = i.name.toLowerCase();
        final isHotspot =
            n.startsWith('ap') || n.contains('softap') || n.startsWith('swlan');
        final isCell = n.startsWith('rmnet') ||
            n.startsWith('wwan') ||
            n.startsWith('ccmni') ||
            n.startsWith('seth');
        final isTunnel = n.startsWith('tun') || n.startsWith('utun');
        if (isHotspot) return a;
        if (!isCell && !isTunnel) candidates.add(a);
      }
      return candidates.isEmpty ? '' : candidates.first;
    } on Exception {
      return '';
    }
  }

  Future<void> _setShare(bool on) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final config = await widget.core.call((api) => api.settings());
      final next = Map<String, Object?>.from(config);
      final proxy = Map<String, Object?>.from(switch (config['proxy']) {
        final Map<String, Object?> p => p,
        _ => <String, Object?>{},
      });
      proxy['listen'] = on ? '0.0.0.0:$_port' : '127.0.0.1:$_port';
      next['proxy'] = proxy;
      await widget.core.call((api) => api.saveSettings(next));
      await widget.core.call((api) => api.restartProxy());
      if (!mounted) return;
      setState(() => _on = on);
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _copy() {
    if (_address.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _address));
    showToast(context, AppLocalizations.of(context).urShareCopied);
  }

  Future<void> _openHotspotSettings() async {
    try {
      await _channel.invokeMethod<bool>('openTetherSettings');
    } on Exception {
      // No such handler (a desktop build) or the system refused: the
      // steps below still say where the row lives.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final vpnOn = widget.core.connected &&
        (widget.core.status?.proxyOn ?? false);

    return Container(
      color: UrTokens.bg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Text(l.urShare, style: urTitleStyle(context)),
          const SizedBox(height: 8),
          Text(
            l.urShareDesc,
            style: const TextStyle(fontSize: 13.5, height: 1.5, color: UrTokens.muted),
          ),
          const SizedBox(height: 20),

          // The switch card: the share on and off, the state the core
          // carries.
          UrEntrance(
            index: 1,
            child: Container(
              decoration: BoxDecoration(
                color: UrTokens.bgTinted,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.urShare,
                          style: const TextStyle(
                              fontSize: 14.5, color: UrTokens.ink),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _on ? l.urShareOn : l.urShareNeedsVpn,
                          style: const TextStyle(
                              fontSize: 12, color: UrTokens.muted),
                        ),
                      ],
                    ),
                  ),
                  if (_busy)
                    const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: UrTokens.blue,
                      ),
                    )
                  else
                    UrSwitch(
                      checked: _on,
                      onToggle: () => _setShare(!_on),
                    ),
                ],
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: const TextStyle(
                  fontSize: 12.5, height: 1.4, color: Color(0xFFFF6C58)),
            ),
          ],
          const SizedBox(height: 20),

          // The address: what the other device's proxy row carries.
          UrEntrance(
            index: 2,
            child: Container(
              decoration: BoxDecoration(
                color: UrTokens.bgTinted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _on
                      ? UrTokens.pink.withValues(alpha: 0.35)
                      : UrTokens.border,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.urShareProxy,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: UrTokens.muted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _address.isEmpty ? '192.168.x.x:$_port' : _address,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _address.isEmpty
                                ? UrTokens.muted
                                : UrTokens.ink,
                          ),
                        ),
                      ),
                      UrPressable(
                        onTap: _copy,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: UrTokens.bg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: UrTokens.border),
                          ),
                          child: const Icon(
                            Icons.copy_rounded,
                            size: 18,
                            color: UrTokens.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!vpnOn) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF5C242),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l.urShareNeedsVpn,
                            style: const TextStyle(
                                fontSize: 12, color: UrTokens.muted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // The steps: the walk the other device takes.
          UrEntrance(
            index: 3,
            child: Container(
              decoration: BoxDecoration(
                color: UrTokens.bgTinted,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.urShareSteps,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.7,
                      color: UrTokens.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // The hotspot's own settings, one tap away.
          UrEntrance(
            index: 4,
            child: UrPressable(
              onTap: _openHotspotSettings,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: UrTokens.faint),
                ),
                child: Text(
                  l.urShareOpenHotspot,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: UrTokens.ink,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.urShareNote,
            style: const TextStyle(
                fontSize: 12, height: 1.5, color: UrTokens.faint),
          ),
        ],
      ),
    );
  }
}
