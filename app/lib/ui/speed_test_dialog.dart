import 'dart:async';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../app_settings.dart';
import 'glass.dart';
import 'widgets.dart' show typefacesOf;
import 'format.dart';
import 'motion.dart';
import '../core/core_controller.dart';
import '../core/speed_test.dart';

/// The speed test's sizes: how much each leg moves before the core calls
/// the direction done — the light pass for a wounded tunnel, the standard
/// pass for most lines, the full pass for a patient one.
class SpeedTestSize {
  const SpeedTestSize._(this.key, this.downBytes, this.upBytes);

  final String key;
  final int downBytes;
  final int upBytes;

  static const light = SpeedTestSize._('light', 5 << 20, 2 << 20);
  static const standard = SpeedTestSize._('standard', 25 << 20, 8 << 20);
  static const full = SpeedTestSize._('full', 64 << 20, 32 << 20);

  static SpeedTestSize forKey(String key) => switch (key) {
    'light' => light,
    'full' => full,
    _ => standard,
  };
}

/// Opens the speed test: what the tunnel really carries, measured by a
/// real download and upload through the tunnel's own path — each on its
/// own connection, so one leg's wound never reaches the other. With the
/// proxy off the same transfers measure the raw network, and the panel
/// says which. [settings], when given, carries the size the user chose
/// last time and takes the next one.
Future<void> showSpeedTest(
  BuildContext context,
  CoreController core, [
  AppSettings? settings,
]) {
  return showDialog<void>(
    context: context,
    builder: (context) => _SpeedTestDialog(core: core, settings: settings),
  );
}

class _SpeedTestDialog extends StatefulWidget {
  const _SpeedTestDialog({required this.core, this.settings});

  final CoreController core;
  final AppSettings? settings;

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

  // The progress events arrive faster than the eye needs; each one
  // repainted the whole panel (the glass shell with it) and the run
  // read heavy. The panel paints ten times a second at most — the
  // numbers always carry the latest bytes, only the repaint waits its
  // turn.
  DateTime _lastPaint = DateTime.fromMillisecondsSinceEpoch(0);
  bool _upPhaseShown = false;

  static const _paintGate = Duration(milliseconds: 100);

  SpeedTestSize get _size =>
      SpeedTestSize.forKey(widget.settings?.speedTestSize ?? 'standard');

  void _pickSize(SpeedTestSize size) {
    widget.settings?.update(speedTestSize: size.key);
    setState(() {});
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _run() async {
    final size = _size;
    setState(() {
      _running = true;
      _error = null;
      _result = null;
      _downBytes = _downBps = _upBytes = _upBps = 0;
      _upPhase = false;
      _upPhaseShown = false;
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
          downBytes: size.downBytes,
          upBytes: size.upBytes,
          onProgress: (progress) {
            if (!mounted) return;
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
            // The phase's flip paints at once (the legs' seats change);
            // the bytes' arrival paints on the gate.
            final now = DateTime.now();
            if ((_upPhase && !_upPhaseShown) ||
                now.difference(_lastPaint) >= _paintGate) {
              _upPhaseShown = _upPhase;
              _lastPaint = now;
              setState(() {});
            }
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
            // The panel's faces share one seat too: the run, the verdict
            // and the idle hint crossfade and lift between themselves
            // instead of snapping. Two keys — the run's face and the
            // idle's face (the verdict and the hint share the idle's, the
            // sizes ride with them) — so the switcher has one walk to do
            // and does it lightly.
            AnimatedSwitcher(
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              child: _running
                  ? SizedBox(
                      width: double.infinity,
                      child: Column(
                        key: const ValueKey('speed-run'),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        _leg(
                          l,
                          l.statDown,
                          _downBytes,
                          _downBps,
                          !_upPhase,
                          Icons.south_rounded,
                        ),
                        const SizedBox(height: 10),
                        _leg(
                          l,
                          l.statUp,
                          _upBytes,
                          _upBps,
                          _upPhase,
                          Icons.north_rounded,
                        ),
                        const SizedBox(height: 10),
                        // The honest sweep: the clock repaints ten times a
                        // second, so the arc asks for a short linear walk —
                        // the old 900-millisecond ease restarted at every
                        // retarget and the needle never caught its value.
                        MeterArc(
                          value: sweep,
                          color: scheme.primary,
                          stroke: 5,
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.linear,
                        ),
                        const SizedBox(height: 4),
                      ],
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        key: const ValueKey('speed-idle'),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        if (_error != null) ...[
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                result.error,
                                style: TextStyle(color: scheme.error),
                              ),
                            ),
                          // The path's own delay, the probes' answer: the
                          // median round trip, and the jitter beside it —
                          // both quiet when the probes found no path to
                          // time.
                          if (result.latencyMs > 0) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _probeCell(
                                    context,
                                    label: l.realDelay,
                                    value: '${result.latencyMs} ms',
                                    icon: Icons.schedule_rounded,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _probeCell(
                                    context,
                                    label: l.speedTestJitter,
                                    value: '${result.jitterMs} ms',
                                    icon: Icons.graphic_eq_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
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
                        // The sizes: how much the legs move. The choice
                        // carries to the next test, so the user picks once.
                        Text(
                          l.speedTestSizesTitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            for (final size in [
                              SpeedTestSize.light,
                              SpeedTestSize.standard,
                              SpeedTestSize.full,
                            ])
                              ChoiceChip(
                                label: Text(sizeLabel(l, size)),
                                selected: _size.key == size.key,
                                visualDensity: VisualDensity.compact,
                                onSelected: (_) => _pickSize(size),
                              ),
                          ],
                        ),
                      ],
                      ),
                    ),
            ),
            const SizedBox(height: 8),
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

  Widget _probeCell(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final typefaces = typefacesOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
              fontWeight: FontWeight.w800,
              fontFamily: typefaces.display,
            ),
          ),
        ],
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

/// The size's word, in the panel's language.
String sizeLabel(AppLocalizations l, SpeedTestSize size) => switch (size.key) {
  'light' => l.speedTestSizeLight,
  'full' => l.speedTestSizeFull,
  _ => l.speedTestSizeStandard,
};
