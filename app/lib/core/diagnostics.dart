import 'package:flutter/material.dart';

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
