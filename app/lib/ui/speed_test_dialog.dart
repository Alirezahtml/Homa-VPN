import 'dart:async';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'widgets.dart' show typefacesOf;
import 'format.dart';
import '../core/core_controller.dart';
import '../core/speed_test.dart';

/// Opens the speed test: what the tunnel carries, measured by a real
/// download and upload through the tunnel's own path. With the proxy off
/// the same transfers measure the raw network, and the dialog says which.
Future<void> showSpeedTest(BuildContext context, CoreController core) {
  return showDialog<void>(
    context: context,
    builder: (context) => _SpeedTestDialog(core: core),
  );
}

class _SpeedTestDialog extends StatefulWidget {
  const _SpeedTestDialog({required this.core});

  final CoreController core;

  @override
  State<_SpeedTestDialog> createState() => _SpeedTestDialogState();
}

class _SpeedTestDialogState extends State<_SpeedTestDialog> {
  bool _running = false;
  String? _error;
  SpeedTestResult? _result;
  int _downBytes = 0;
  int _downBps = 0;
  int _upBytes = 0;
  int _upBps = 0;
  bool _upPhase = false;

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
      _result = null;
      _downBytes = _downBps = _upBytes = _upBps = 0;
      _upPhase = false;
    });
    try {
      final result = await widget.core.call(
        (api) => api.testSpeed(
          onProgress: (progress) {
            if (!mounted) return;
            if (progress.dir == 'down') {
              _downBytes = progress.bytes;
              _downBps = progress.bps;
            } else if (progress.dir == 'up') {
              _upPhase = true;
              _upBytes = progress.bytes;
              _upBps = progress.bps;
            }
            setState(() {});
          },
        ),
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _running = false;
      });
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
    final result = _result;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.speed_rounded),
          const SizedBox(width: 10),
          Expanded(child: Text(l.speedTestTitle)),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_running) ...[
              _leg(l, l.statDown, _downBytes, _downBps, !_upPhase),
              const SizedBox(height: 10),
              _leg(l, l.statUp, _upBytes, _upBps, _upPhase),
              const SizedBox(height: 6),
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ] else if (_error != null) ...[
              Text(l.speedTestFailed, style: TextStyle(color: scheme.error)),
              const SizedBox(height: 6),
              Text(_error!, style: theme.textTheme.bodySmall),
            ] else if (result != null) ...[
              if (result.error.isNotEmpty)
                Text(result.error, style: TextStyle(color: scheme.error)),
              _big(l.statDown, result.downBps),
              _big(l.statUp, result.upBps),
              const SizedBox(height: 8),
              Text(
                result.throughTunnel ? l.speedTestThrough : l.speedTestDirect,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ] else
              Text(l.speedTestHint, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _running ? null : _run,
          child: Text(
            _result == null && _error == null ? l.speedTestRun : l.diagnosticsAgain,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }

  Widget _leg(AppLocalizations l, String label, int bytes, int bps, bool active) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          label == l.statDown ? Icons.south_rounded : Icons.north_rounded,
          size: 16,
          color: active ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          formatRate(bps),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
            color: bps > 0 ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _big(String label, int bps) {
    final theme = Theme.of(context);
    final typefaces = typefacesOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            formatRate(bps),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              fontFamily: typefaces.display,
            ),
          ),
        ],
      ),
    );
  }
}
