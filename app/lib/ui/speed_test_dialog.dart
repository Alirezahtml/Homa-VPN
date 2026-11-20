import 'dart:async';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'glass.dart';
import 'widgets.dart' show typefacesOf;
import 'format.dart';
import 'motion.dart';
import '../core/core_controller.dart';
import '../core/speed_test.dart';

/// Opens the speed test: what the tunnel really carries, measured by a
/// real download and upload through the tunnel's own path. With the proxy
/// off the same transfers measure the raw network, and the panel says
/// which. The panel itself is a sheet of glass over the page — the test's
/// numbers land on it with the app's own motion.
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
  Timer? _clock;
  Duration _legElapsed = Duration.zero;

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
      _result = null;
      _downBytes = _downBps = _upBytes = _upBps = 0;
      _upPhase = false;
      _legElapsed = Duration.zero;
    });
    // The leg's clock: the sweep of the measuring leg, honest time.
    _clock = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted || !_running) return;
      setState(() => _legElapsed += const Duration(milliseconds: 100));
    });
    try {
      final result = await widget.core.call(
        (api) => api.testSpeed(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() {
              if (progress.dir == 'down') {
                _downBytes = progress.bytes;
                _downBps = progress.bps;
              } else if (progress.dir == 'up') {
                if (!_upPhase) {
                  _upPhase = true;
                  _legElapsed = Duration.zero;
                }
                _upBytes = progress.bytes;
                _upBps = progress.bps;
              }
            });
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
    } finally {
      _clock?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final result = _result;
    // One leg's sweep runs 20 seconds at the most (the core's own cap);
    // the arc shows the honest time, never a made-up share of the speed.
    final sweep = (_legElapsed.inMilliseconds / 20000).clamp(0.0, 1.0);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: LiquidGlass(
        blur: true,
        radius: 24,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconSpin(
                  child: Icon(
                    Icons.speed_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.speedTestTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (_running)
                  SweepLoader(color: scheme.primary, size: 18)
                else
                  CloseButton(onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: 16),
            if (_running) ...[
              _leg(
                l,
                l.statDown,
                _downBytes,
                _downBps,
                !_upPhase,
                Icons.south_rounded,
              ),
              const SizedBox(height: 10),
              _leg(l, l.statUp, _upBytes, _upBps, _upPhase, Icons.north_rounded),
              const SizedBox(height: 10),
              MeterArc(value: sweep, color: scheme.primary, stroke: 5),
              const SizedBox(height: 4),
            ] else if (_error != null) ...[
              Wobble(
                trigger: _error.hashCode,
                child: Text(
                  l.speedTestFailed,
                  style: TextStyle(color: scheme.error),
                ),
              ),
              const SizedBox(height: 6),
              Text(_error!, style: theme.textTheme.bodySmall),
            ] else if (result != null) ...[
              if (result.error.isNotEmpty)
                Text(result.error, style: TextStyle(color: scheme.error)),
              _big(l.statDown, result.downBps, Icons.south_rounded),
              const SizedBox(height: 8),
              _big(l.statUp, result.upBps, Icons.north_rounded),
              const SizedBox(height: 10),
              FadeThrough(
                child: Text(
                  result.throughTunnel
                      ? l.speedTestThrough
                      : l.speedTestDirect,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ] else
              Text(
                l.speedTestHint,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_running)
                  TextButton(
                    onPressed: _run,
                    child: Text(
                      _result == null && _error == null
                          ? l.speedTestRun
                          : l.diagnosticsAgain,
                    ),
                  ),
                if (_running)
                  TextButton(
                    onPressed: null,
                    child: TypeDots(color: scheme.onSurfaceVariant),
                  ),
                const SizedBox(width: 4),
                if (!_running)
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      MaterialLocalizations.of(context).closeButtonLabel,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _leg(
    AppLocalizations l,
    String label,
    int bytes,
    int bps,
    bool active,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final typefaces = typefacesOf(context);
    final live = active && _running;
    return LiquidGlass(
      radius: 16,
      accent: live ? scheme.primary : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          RadarPing(
            active: live,
            color: scheme.primary,
            child: Icon(
              icon,
              size: 18,
              color: live ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: live ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          TickerNumber(
            value: bps,
            builder:
                (context, v) => Text(
                  formatRate(v),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w800,
                    fontFamily: typefaces.display,
                    color: live
                        ? scheme.primary
                        : bps > 0
                        ? null
                        : scheme.onSurfaceVariant,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _big(String label, int bps, IconData icon) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final typefaces = typefacesOf(context);
    return LiquidGlass(
      radius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          FlipCounter(
            text: formatRate(bps),
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
