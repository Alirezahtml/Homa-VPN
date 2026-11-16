import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../app_info.dart' show appVersion;
import 'android_core.dart';
import 'core_controller.dart';
import 'models.dart';
import '../l10n/app_localizations.dart';

/// One tap's checkup: the connection (a real test through the tunnel), the
/// DNS (the core resolves the same names a browser would, and flags a
/// filtering block page), and the tunnel's state, with the exit country
/// beside the chosen one. Nothing sensitive is stored: the results live in
/// the dialog, and the core's logs keep what they already keep.
Future<void> showDiagnostics(BuildContext context, CoreController core) {
  return showDialog<void>(
    context: context,
    builder: (context) => _DiagnosticsDialog(core: core),
  );
}

class _DiagnosticsDialog extends StatefulWidget {
  const _DiagnosticsDialog({required this.core});

  final CoreController core;

  @override
  State<_DiagnosticsDialog> createState() => _DiagnosticsDialogState();
}

class _DiagnosticsDialogState extends State<_DiagnosticsDialog> {
  bool _running = true;
  String? _error;
  ConnectionTest? _test;
  List<DnsTestHost>? _dns;
  CoreStatus? _status;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
      _test = null;
      _dns = null;
    });
    try {
      final status = await widget.core.call((api) => api.status());
      if (!mounted) return;
      setState(() => _status = status);
      // The tunnel carries the test: without it the test says so (409).
      if (status.proxyOn && status.state.phase == Phase.running) {
        final test = await widget.core.call((api) => api.test());
        if (!mounted) return;
        setState(() => _test = test);
      }
      final dns = await widget.core.call(
        (api) => api.testDns(const []),
      );
      if (!mounted) return;
      setState(() => _dns = dns);
      _running = false;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _running = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final status = _status;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.healing_rounded),
          const SizedBox(width: 10),
          Expanded(child: Text(l.diagnosticsRun)),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: _running
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null)
                    Text(_error!, style: TextStyle(color: scheme.error)),
                  if (status != null) ...[
                    _line(
                      l.diagnosticsTunnel,
                      status.proxyOn && status.state.phase == Phase.running
                          ? l.diagnosticsTunnelUp
                          : l.diagnosticsTunnelDown,
                      status.proxyOn && status.state.phase == Phase.running
                          ? scheme.primary
                          : scheme.error,
                    ),
                    if (status.exit?.countryName case final exit?)
                      _line(l.diagnosticsExit, exit, scheme.onSurface),
                    if (status.exitMismatch
                        case final mismatch? when mismatch.exitCountryCode.isNotEmpty)
                      _line(
                        l.diagnosticsMismatch,
                        '${mismatch.chosenCountryName} → ${mismatch.exitCountryName}',
                        scheme.error,
                      ),
                  ],
                  if (_test case final test?) ...[
                    const SizedBox(height: 8),
                    _line(
                      l.diagnosticsConnection,
                      test.ok
                          ? '${l.diagnosticsPassed} · ${l.milliseconds(test.responseMs)}'
                          : '${l.diagnosticsFailed}: ${test.error}',
                      test.ok ? scheme.primary : scheme.error,
                    ),
                  ],
                  if (_dns case final dns? when dns.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    for (final host in dns)
                      _line(
                        host.host,
                        host.filtered
                            ? l.diagnosticsDnsFiltered
                            : host.addrs.isNotEmpty
                            ? l.diagnosticsDnsOk
                            : l.noAnswer,
                        host.filtered
                            ? scheme.error
                            : host.addrs.isNotEmpty
                            ? scheme.primary
                            : scheme.error,
                      ),
                  ],
                  const SizedBox(height: 8),
                  Text(l.diagnosticsPrivacy, style: theme.textTheme.bodySmall),
                ],
              ),
      ),
      actions: [
        if (!_running && status != null)
          TextButton(
            onPressed: () => _share(context, l),
            child: Text(l.shareReport),
          ),
        TextButton(
          onPressed: _running ? null : _run,
          child: Text(l.diagnosticsAgain),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }

  /// The results as one plain-text report the user can send: the state,
  /// the exit, the connection test, and the DNS answers. Nothing personal:
  /// no account, no email, no addresses — the same lines the dialog shows.
  Future<void> _share(BuildContext context, AppLocalizations l) async {
    final status = _status;
    final test = _test;
    final dns = _dns;
    final lines = <String>[
      'Homa VPN $appVersion',
      if (status != null)
        '${l.diagnosticsTunnel}: '
            '${status.proxyOn && status.state.phase == Phase.running ? l.diagnosticsTunnelUp : l.diagnosticsTunnelDown}',
      if (status?.exit?.countryName case final exit?) '${l.diagnosticsExit}: $exit',
      if (test != null)
        '${l.diagnosticsConnection}: '
            '${test.ok ? l.diagnosticsPassed : l.diagnosticsFailed}'
            '${test.ok ? ' · ${l.milliseconds(test.responseMs)}' : ''}',
      if (dns != null)
        for (final host in dns)
          '${host.host}: '
              '${host.filtered ? l.diagnosticsDnsFiltered : host.addrs.isNotEmpty ? l.diagnosticsDnsOk : l.noAnswer}',
    ];
    final report = lines.join('\n');
    var sent = false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      sent = await AndroidCore.shareText(
        report,
        AppLocalizations.of(context).shareReport,
      );
    }
    if (!sent) {
      await Clipboard.setData(ClipboardData(text: report));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).shareReportCopied)),
        );
      }
    }
  }

  Widget _line(String label, String value, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          textAlign: TextAlign.end,
        ),
      ],
    ),
  );
}
