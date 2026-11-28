import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_controller.dart';
import '../core/models.dart';
import '../l10n/app_localizations.dart';
import 'format.dart';
import 'motion.dart';
import 'ur_kit.dart' show UrPressable, UrSwitch, UrTokens;
import 'ur_settings.dart' show UrUsageCard;
import 'ur_stats.dart' show
    UrBlockerPanel,
    UrDnsCard,
    UrIpFamilyRow,
    UrLocalStatsCard,
    UrSplitPanel,
    UrTransportBar;
import 'widgets.dart';

/// The ur home: URnetwork's connect screen, ported as it ships.
///
/// The pieces and their measures are the original's: the 256 dp face whose
/// corners step in like the globe's own outline, the white at four percent
/// over the near-black stock, "Tap to connect" in twenty above the pulse
/// dot (the ring runs one second, then rests three), the provider grid's
/// dots popping in yellow and settling green while the tunnel builds, the
/// five color fields that fly in once it holds, and the status line with
/// its state dot. The drawer is the original's geometry too: the handle,
/// the tinted card with the location row and the Connect button at the
/// peek, the stats below the fold, the whole thing pulling to two thirds
/// of the page.
///
/// Every moving piece paints in one CustomPainter behind a RepaintBoundary,
/// every animation is a one-way walk tied to the state change (only the
/// off-state pulse repeats, and it stops under the battery saver and the
/// system's reduce-motion), and nothing asks the core for a thing it does
/// not already say.

/// URnetwork's own palette, the tokens the original draws with.
abstract final class _Ur {
  /// The screens' background (Black).
  static const bg = Color(0xFF101010);

  /// Bottom sheets' surface (SheetBlack: the black lightened three percent).
  static const sheet = Color(0xFF171717);

  /// Tinted containers: the drawer's cards (OffBlack).
  static const bgTinted = Color(0xFF1C1C1C);

  /// Primary text (OffWhite) and the secondary and tertiary inks.
  static const ink = Color(0xFFF8F8F8);
  static const muted = Color(0xFF989898);
  static const faint = Color(0xFF5A5A5A);

  /// The blues: the button's fill (BlueMedium, Blue400).
  static const blueMedium = Color(0xFF638BFC);

  /// The state colors the original paints with.
  static const pink = Color(0xFFED8FFF); // Pink300, the "Change" link
  static const red = Color(0xFFFF6C58); // Red400, a failed provider
  static const amber = Color(0xFFF5C242); // the connecting dot
  static const green = Color(0xFF87FB67); // Green300, a landed provider
  static const green500 = Color(0xFF31D70B); // the connected dot
  static const yellow = Color(0xFFEFF7BB); // Yellow200, an evaluating dot
  static const blueLight = Color(0xFFD6E6F4); // Blue200, a color field

  /// The face's ground: white at four percent.
  static const face = Color(0x0AFFFFFF);
}

/// The connect face's own shape: the globe's outline, stepped corners and
/// all, read straight from the original's vector and scaled to [size].
Path _urSquircle(double size) {
  final s = size / 256;
  final p = Path();
  p.moveTo(240 * s, 64 * s);
  p.cubicTo(231.16 * s, 64 * s, 224 * s, 56.84 * s, 224 * s, 48 * s);
  p.cubicTo(224 * s, 39.16 * s, 216.84 * s, 32 * s, 208 * s, 32 * s);
  p.cubicTo(199.16 * s, 32 * s, 192 * s, 24.84 * s, 192 * s, 16 * s);
  p.cubicTo(192 * s, 7.16 * s, 184.84 * s, 0, 176 * s, 0);
  p.lineTo(80 * s, 0);
  p.cubicTo(71.16 * s, 0, 64 * s, 7.16 * s, 64 * s, 16 * s);
  p.cubicTo(64 * s, 24.84 * s, 56.84 * s, 32 * s, 48 * s, 32 * s);
  p.cubicTo(39.16 * s, 32 * s, 32 * s, 39.16 * s, 32 * s, 48 * s);
  p.cubicTo(32 * s, 56.84 * s, 24.84 * s, 64 * s, 16 * s, 64 * s);
  p.cubicTo(7.16 * s, 64 * s, 0, 71.16 * s, 0, 80 * s);
  p.lineTo(0, 176 * s);
  p.cubicTo(0, 184.84 * s, 7.16 * s, 192 * s, 16 * s, 192 * s);
  p.cubicTo(24.84 * s, 192 * s, 32 * s, 199.16 * s, 32 * s, 208 * s);
  p.cubicTo(32 * s, 216.84 * s, 39.16 * s, 224 * s, 48 * s, 224 * s);
  p.cubicTo(56.84 * s, 224 * s, 64 * s, 231.16 * s, 64 * s, 240 * s);
  p.cubicTo(64 * s, 248.84 * s, 71.16 * s, 256 * s, 80 * s, 256 * s);
  p.lineTo(176 * s, 256 * s);
  p.cubicTo(184.84 * s, 256 * s, 192 * s, 248.84 * s, 192 * s, 240 * s);
  p.cubicTo(192 * s, 231.16 * s, 199.16 * s, 224 * s, 208 * s, 224 * s);
  p.cubicTo(216.84 * s, 224 * s, 224 * s, 216.84 * s, 224 * s, 208 * s);
  p.cubicTo(224 * s, 199.16 * s, 231.16 * s, 192 * s, 240 * s, 192 * s);
  p.cubicTo(248.84 * s, 192 * s, 256 * s, 184.84 * s, 256 * s, 176 * s);
  p.lineTo(256 * s, 80 * s);
  p.cubicTo(256 * s, 71.16 * s, 248.84 * s, 64 * s, 240 * s, 64 * s);
  p.close();
  return p;
}

class UrHome extends StatefulWidget {
  const UrHome({
    super.key,
    required this.core,
    required this.status,
    required this.settings,
    this.onOpenServers,
    this.onOpenAccounts,
    this.onOpenRouting,
    this.onOpenShare,
    this.push,
  });

  final CoreController core;
  final CoreStatus status;
  final AppSettings settings;
  final VoidCallback? onOpenServers;
  final VoidCallback? onOpenAccounts;
  final VoidCallback? onOpenRouting;
  final VoidCallback? onOpenShare;

  /// Opens a page under the shell's own stack: the drawer's deep cards —
  /// the connections, the per-app split, the DNS page — walk out through
  /// it. Null on the desktop home, where the drawer does not stand.
  final void Function(String title, Widget page)? push;

  @override
  State<UrHome> createState() => _UrHomeState();
}

class _UrHomeState extends State<UrHome> {
  /// The drawer meets the bar: the classic bar sits in the scaffold's own
  /// slot below the page (the shell's safe area ends this page exactly at
  /// the bar's top border), so the sheet's bottom edge lands on that
  /// border and the page's darker ground never shows between the two —
  /// the original's sheet touches the tab bar the same way.
  static const double _navGap = 0;

  /// The drawer's peek: the handle (22 dp), the card's above-the-fold
  /// block (the location row and the Connect button, 122 dp) and the
  /// fold's own 12 dp gap.
  static const double _peekDp = 156;

  /// How much of the page the expanded drawer covers. The original pulls
  /// to two thirds; the port stops a touch lower so the page's face keeps
  /// a seat above the sheet and the bar at the foot never disappears
  /// behind it.
  static const double _expandedFraction = 0.58;

  /// The moment the tunnel came up this session; null while it is down.
  DateTime? _sessionStart;

  /// The speed samples the sparkline draws: (up, down) bytes per second,
  /// one per second at most, the newest last.
  final List<List<double>> _samples = [];
  DateTime _lastSample = DateTime.fromMillisecondsSinceEpoch(0);

  /// Whether the last attempt came down without the tunnel: the status
  /// line's red word, until the next press or a held connection clears it.
  bool _failed = false;
  bool _wasConnecting = false;

  @override
  void initState() {
    super.initState();
    widget.core.addListener(_coreChanged);
    _readSession(widget.status);
  }

  @override
  void didUpdateWidget(UrHome old) {
    super.didUpdateWidget(old);
    _readSession(widget.status);
  }

  @override
  void dispose() {
    widget.core.removeListener(_coreChanged);
    super.dispose();
  }

  void _coreChanged() {
    if (!mounted) return;
    _readSession(widget.core.status);
    setState(() {});
  }

  /// The session's start and the samples' pace: both move only on a state
  /// change, never on a plain refresh.
  void _readSession(CoreStatus? status) {
    if (status == null) return;
    final on = status.proxyOn;
    final running = status.state.phase == Phase.running;
    final confirming = status.connectPending ||
        (on && running && !status.confirmedBy(widget.core.lastTest));
    final connected = on && running && !confirming;
    if (confirming) {
      _wasConnecting = true;
      _failed = false;
    } else if (connected) {
      _wasConnecting = false;
      _failed = false;
    } else if (_wasConnecting && !on) {
      _failed = true;
      _wasConnecting = false;
    }
    if (on && _sessionStart == null) _sessionStart = DateTime.now();
    if (!on) _sessionStart = null;
    final traffic = status.traffic;
    final now = DateTime.now();
    if (traffic != null && now.difference(_lastSample).inMilliseconds >= 900) {
      _lastSample = now;
      _samples.add([
        traffic.upRate.toDouble(),
        traffic.downRate.toDouble(),
      ]);
      if (_samples.length > 60) _samples.removeAt(0);
    }
  }

  Future<void> _toggle(bool on) async {
    await widget.core.setOn(!on);
    // The core handles the initial connection while an attempt is pending.
    if (!on) {
      final status = widget.core.status;
      if (status != null && status.proxyOn && !status.connectPending) {
        unawaited(widget.core.runTest().catchError((_) {}));
      }
    }
  }

  void _press(BuildContext context) {
    final status = widget.status;
    final on = status.proxyOn;
    _failed = false;
    if (status.totalAccounts == 0) {
      if (widget.onOpenAccounts != null) widget.onOpenAccounts!();
      return;
    }
    final l = AppLocalizations.of(context);
    if (!on && status.noNetwork) {
      showError(context, l.noNetwork);
      return;
    }
    runShowingErrors(context, () => _toggle(on));
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final l = AppLocalizations.of(context);

    final running = status.state.phase == Phase.running;
    final on = status.proxyOn;
    final confirming = status.connectPending ||
        (on && running && !status.confirmedBy(widget.core.lastTest));
    final connected = on && running && !confirming;
    final busy = widget.core.switchingProxy || status.connectPending;
    final still = widget.settings.batterySaver ||
        MediaQuery.of(context).disableAnimations;

    final phase = _failed
        ? _Phase.failed
        : confirming
            ? _Phase.connecting
            : connected
                ? _Phase.connected
                : _Phase.off;

    final place = homeLocation(l, status, connected: connected);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: _Ur.bg)),
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, cons) {
                  final height = cons.maxHeight;
                  final double peek =
                      (_peekDp / height).clamp(0.12, 0.42).toDouble();
                  final double sheetPx = peek * height;
                  // The face's room: what the peek leaves, less the page's
                  // own spacing (the top breath, the gap to the status line
                  // and the line's seat).
                  final double room =
                      (height - sheetPx - 16 - 32 - 24 - 12)
                          .clamp(48.0, 256.0)
                          .toDouble();
                  return Stack(
                    children: [
                      // The connect face, centered in the room the peek
                      // leaves — the original's ConnectMainContent.
                      Padding(
                        padding: EdgeInsets.only(bottom: sheetPx),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 16),
                              _ConnectGraphic(
                                size: room,
                                phase: phase,
                                busy: busy,
                                still: still,
                                onPressed: () => _press(context),
                              ),
                              const SizedBox(height: 32),
                              _StatusLine(phase: phase),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      // The drawer: the handle and the location card at the
                      // peek, the stats below the fold.
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: _navGap),
                          child: DraggableScrollableSheet(
                            initialChildSize: peek,
                            minChildSize: peek,
                            maxChildSize: _expandedFraction,
                            snap: true,
                            snapSizes: [peek, _expandedFraction],
                            builder: (context, scrollController) => _UrDrawer(
                              scrollController: scrollController,
                              core: widget.core,
                              settings: widget.settings,
                              status: status,
                              phase: phase,
                              busy: busy,
                              place: place,
                              sessionStart: _sessionStart,
                              samples: _samples,
                              onPress: () => _press(context),
                              onOpenServers: widget.onOpenServers,
                              onOpenRouting: widget.onOpenRouting,
                              onOpenShare: widget.onOpenShare,
                              push: widget.push,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The connect face.
// ---------------------------------------------------------------------------

/// The face's four states, the original's own walk.
enum _Phase { off, connecting, connected, failed }

/// One color field that flies in on connection: the original's five, from
/// their off-canvas seats to their landings, as fractions of the grid's
/// span.
class _ColorField {
  const _ColorField(this.fromX, this.fromY, this.toX, this.toY, this.color);
  final double fromX;
  final double fromY;
  final double toX;
  final double toY;
  final Color color;
}

const List<_ColorField> _colorFields = [
  _ColorField(-1.1, 0.95, 0.4, 0.95, _Ur.red),
  _ColorField(2.55, 3.3, 2.0, 2.0, _Ur.pink),
  _ColorField(3.5, 0.3, 2.25, 0.8, _Ur.green),
  _ColorField(0.8, -1.5, 0.8, 0.05, _Ur.yellow),
  _ColorField(-1.5, 3.0, 0.75, 2.25, _Ur.blueLight),
];

/// The face: the square panel with the stepped corners, the state's walk
/// inside it, and the tap.
class _ConnectGraphic extends StatefulWidget {
  const _ConnectGraphic({
    required this.size,
    required this.phase,
    required this.busy,
    required this.still,
    required this.onPressed,
  });

  final double size;
  final _Phase phase;
  final bool busy;
  final bool still;
  final VoidCallback onPressed;

  @override
  State<_ConnectGraphic> createState() => _ConnectGraphicState();
}

class _ConnectGraphicState extends State<_ConnectGraphic>
    with TickerProviderStateMixin {
  late _Phase _phase = widget.phase;

  /// The off-state pulse: the ring runs a second every four and a half.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  int _pulseGen = 0;
  Timer? _pulseTimer;
  bool _pulseRunning = false;

  /// The provider grid's stagger: the dots pop in yellow and settle green.
  late final AnimationController _grid = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  /// The grid's fade: out once the tunnel holds (a second after it does),
  /// out at once when the attempt dies.
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  Timer? _gridOutTimer;

  /// The color fields' flight, the original's two waves.
  late final AnimationController _fields = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  );
  List<int> _fieldOrder = [0, 1, 2, 3, 4];

  /// The globe's meridians while the tunnel builds.
  late final AnimationController _globe = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  int _globeGen = 0;
  Timer? _globeTimer;

  bool _dotsRed = false;

  /// The grid's dots: 46 seats on the 16-wide lattice, a fixed scatter so
  /// a refresh never reshuffles the picture.
  late final List<(int, int)> _dots = _buildDots();
  static List<(int, int)> _buildDots() {
    final rnd = math.Random(7);
    final seen = <int>{};
    final dots = <(int, int)>[];
    while (dots.length < 46) {
      final x = rnd.nextInt(16);
      final y = rnd.nextInt(16);
      if (!seen.add(y * 16 + x)) continue;
      dots.add((x, y));
    }
    dots.shuffle(math.Random(11));
    return dots;
  }

  @override
  void initState() {
    super.initState();
    _apply(_phase, initial: true);
  }

  @override
  void didUpdateWidget(_ConnectGraphic old) {
    super.didUpdateWidget(old);
    final next = widget.phase;
    if (next != _phase) {
      _apply(next, initial: false);
    } else if (next == _Phase.off) {
      // Only the still flag moved: the pulse stops with it, or resumes.
      if (widget.still && _pulseRunning) {
        _stopPulse();
      } else if (!widget.still && !_pulseRunning) {
        _startPulse();
      }
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _globeTimer?.cancel();
    _gridOutTimer?.cancel();
    _pulse.dispose();
    _grid.dispose();
    _fade.dispose();
    _fields.dispose();
    _globe.dispose();
    super.dispose();
  }

  void _apply(_Phase next, {required bool initial}) {
    final prev = _phase;
    _phase = next;
    switch (next) {
      case _Phase.off:
        _stopPulse();
        if (!widget.still) _startPulse();
        _setGlobe(false);
        _gridOutTimer?.cancel();
        if (!initial) {
          // the dots wash out red, the fields glide back to their seats
          _dotsRed = true;
          _fade.forward();
          _grid
            ..duration = const Duration(milliseconds: 500)
            ..reverse();
          _fields
            ..duration = const Duration(milliseconds: 1000)
            ..reverse();
        }
      case _Phase.connecting:
        _stopPulse();
        _setGlobe(true);
        _gridOutTimer?.cancel();
        _dotsRed = false;
        if (initial) {
          _grid.forward();
        } else if (prev == _Phase.connected) {
          // a fresh evaluation under a held tunnel: the dots come back
          _fade.reverse();
        } else {
          _fade.reset();
          _grid
            ..duration = const Duration(milliseconds: 2200)
            ..forward(from: 0);
          _fields
            ..duration = const Duration(milliseconds: 500)
            ..reverse();
        }
      case _Phase.connected:
        _stopPulse();
        _setGlobe(false);
        _dotsRed = false;
        if (initial) {
          _grid.value = 1;
          _fade.value = 1;
          _fields.value = 1;
        } else {
          _fieldOrder = [0, 1, 2, 3, 4]..shuffle(math.Random());
          _grid
            ..duration = const Duration(milliseconds: 2200)
            ..forward();
          _scheduleGridOut();
          _fields
            ..duration = const Duration(milliseconds: 2500)
            ..forward(from: 0);
        }
      case _Phase.failed:
        _stopPulse();
        _setGlobe(false);
        _gridOutTimer?.cancel();
        _dotsRed = true;
        if (!initial) {
          _fade.forward();
          _fields
            ..duration = const Duration(milliseconds: 500)
            ..reverse();
        }
    }
  }

  /// The pulse's cycle, the original's own: a breath of a delay, the
  /// second-long run, three seconds of rest, and around again.
  void _startPulse() {
    _pulseTimer?.cancel();
    if (!mounted || widget.still || _phase != _Phase.off) return;
    _pulseRunning = true;
    final gen = ++_pulseGen;
    _pulseTimer = Timer(const Duration(milliseconds: 100), () {
      if (!mounted || gen != _pulseGen || widget.still || _phase != _Phase.off) {
        return;
      }
      _pulse.forward(from: 0).whenComplete(() {
        if (!mounted || gen != _pulseGen || widget.still || _phase != _Phase.off) {
          return;
        }
        _pulseTimer = Timer(const Duration(milliseconds: 3000), () {
          if (!mounted || gen != _pulseGen || widget.still || _phase != _Phase.off) {
            return;
          }
          _pulse.reset();
          _startPulse();
        });
      });
    });
  }

  void _stopPulse() {
    _pulseGen++;
    _pulseTimer?.cancel();
    _pulseRunning = false;
    _pulse.reset();
  }

  /// The globe's cross-fade, half a second after the state asks for it.
  void _setGlobe(bool visible) {
    _globeGen++;
    final gen = _globeGen;
    _globeTimer?.cancel();
    _globeTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || gen != _globeGen) return;
      if (visible) {
        _globe.forward();
      } else {
        _globe.reverse();
      }
    });
  }

  /// The grid fades out a second after the tunnel holds.
  void _scheduleGridOut() {
    _gridOutTimer?.cancel();
    _gridOutTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) _fade.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final typefaces = typefacesOf(context);
    final off = _phase == _Phase.off;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulse, _grid, _fade, _fields, _globe]),
        builder: (context, _) {
          return Semantics(
            button: true,
            enabled: true,
            label: switch (_phase) {
              _Phase.off => l.tapToConnectPhone,
              _Phase.connecting => l.stateConnecting,
              _Phase.connected => l.stateConnected,
              _Phase.failed => l.urConnectFailed,
            },
            child: Pressable(
              depth: 0.02,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onPressed,
                child: SizedBox.square(
                  dimension: widget.size,
                  child: CustomPaint(
                    painter: _ConnectFacePainter(
                      phase: _phase,
                      pulse: _pulse.value,
                      grid: _grid.value,
                      fade: _fade.value,
                      fields: _fields.value,
                      fieldOrder: _fieldOrder,
                      globe: _globe.value,
                      dots: _dots,
                      dotsRed: _dotsRed,
                    ),
                    child: Center(
                      // the CustomPaint hands its child tight constraints;
                      // the Center loosens them, so the word and the pulse
                      // keep their own height and stay centered
                      child: IgnorePointer(
                        ignoring: !off,
                        child: AnimatedOpacity(
                          opacity: off ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            // the original's own -12 dp lift
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l.tapToConnectPhone,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 1.0,
                                    fontWeight: FontWeight.w700,
                                    color: _Ur.ink,
                                    fontFamily: typefaces.display,
                                    fontFamilyFallback:
                                        typefaces.displayFallback,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox.square(
                                  dimension: 82,
                                  child: CustomPaint(
                                    painter: _PulsePainter(
                                      pulse: _pulse.value,
                                      still: widget.still,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The face's paint: the stepped square, the meridians, the grid, the
/// fields — one pass, in the original's own order.
class _ConnectFacePainter extends CustomPainter {
  _ConnectFacePainter({
    required this.phase,
    required this.pulse,
    required this.grid,
    required this.fade,
    required this.fields,
    required this.fieldOrder,
    required this.globe,
    required this.dots,
    required this.dotsRed,
  });

  final _Phase phase;
  final double pulse;
  final double grid;
  final double fade;
  final double fields;
  final List<int> fieldOrder;
  final double globe;
  final List<(int, int)> dots;
  final bool dotsRed;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 256;
    final face = _urSquircle(size.width);

    // the face's ground: white at four percent
    canvas.drawPath(face, Paint()..color = _Ur.face);

    canvas.save();
    canvas.clipPath(face);

    // the globe's meridians, the connecting state's mark
    if (globe > 0) {
      final line = Paint()
        ..color = _Ur.bg.withValues(alpha: globe)
        ..strokeWidth = 2 * s
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(0, 127.5 * s),
        Offset(size.width, 127.5 * s),
        line,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(128.5 * s, 128 * s),
          width: 103 * s,
          height: 254 * s,
        ),
        line,
      );
    }

    // the provider grid: the dots pop in yellow and settle green as the
    // network evaluates, inside the grid canvas's own 248 seat
    final o = 4 * s;
    final span = 248 * s;
    final cell = span / 16;
    canvas.save();
    canvas.translate(o, o);
    final dotPaint = Paint();
    final gridMs = grid * 2200;
    for (var i = 0; i < dots.length; i++) {
      final double pop =
          ((gridMs - i * 28.0) / 500).clamp(0.0, 1.0).toDouble();
      if (pop <= 0) continue;
      final (x, y) = dots[i];
      Color base;
      if (phase == _Phase.connecting) {
        final double mix =
            ((gridMs - i * 28.0 - 700) / 400).clamp(0.0, 1.0).toDouble();
        base = Color.lerp(_Ur.yellow, _Ur.green, mix)!;
      } else if (phase == _Phase.connected) {
        base = _Ur.green;
      } else {
        base = _Ur.red;
      }
      final double alpha = (1 - fade).clamp(0.0, 1.0).toDouble();
      if (alpha <= 0) continue;
      dotPaint.color = base.withValues(alpha: alpha);
      canvas.drawCircle(
        Offset(x * cell + cell / 2, y * cell + cell / 2),
        pop * cell / 2,
        dotPaint,
      );
    }

    // the color fields: two waves, a second apart, from their off-canvas
    // seats to their landings
    if (fields > 0) {
      final c = span * 0.4;
      final fieldPaint = Paint();
      for (var k = 0; k < fieldOrder.length; k++) {
        final delay = k < 2 ? 1000.0 : 2000.0;
        final double p =
            ((fields * 2500 - delay) / 500).clamp(0.0, 1.0).toDouble();
        if (p <= 0) continue;
        final e = Curves.fastOutSlowIn.transform(p);
        final f = _colorFields[fieldOrder[k]];
        final from = Offset(f.fromX * c, f.fromY * c);
        final to = Offset(f.toX * c, f.toY * c);
        fieldPaint.color = f.color;
        canvas.drawCircle(Offset.lerp(from, to, e)!, c, fieldPaint);
      }
    }
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(_ConnectFacePainter old) =>
      old.phase != phase ||
      old.pulse != pulse ||
      old.grid != grid ||
      old.fade != fade ||
      old.fields != fields ||
      old.globe != globe ||
      old.dotsRed != dotsRed ||
      old.fieldOrder != fieldOrder;
}

/// The off-state's pulse dot: the static blue mark, and the ring that
/// runs out of it once a cycle. The original's own measures.
class _PulsePainter extends CustomPainter {
  _PulsePainter({required this.pulse, required this.still});

  final double pulse;
  final bool still;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    if (!still && pulse > 0) {
      final diameter = 56 + 26 * pulse;
      canvas.drawCircle(
        c,
        diameter / 2,
        Paint()..color = _Ur.blueMedium.withValues(alpha: 1 - pulse),
      );
    }
    canvas.drawCircle(c, 28, Paint()..color = _Ur.blueMedium);
    canvas.drawCircle(c, 26, Paint()..color = _Ur.bg);
    canvas.drawCircle(c, 24, Paint()..color = _Ur.blueMedium);
  }

  @override
  bool shouldRepaint(_PulsePainter old) =>
      old.pulse != pulse || old.still != still;
}

/// The status line: the state's dot and its word, centered under the face.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.phase});

  final _Phase phase;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (text, dot) = switch (phase) {
      _Phase.off => (l.urReadyToConnect, _Ur.blueMedium),
      _Phase.connecting => (l.stateConnecting, _Ur.amber),
      _Phase.connected => (l.stateConnected, _Ur.green500),
      _Phase.failed => (l.urConnectFailed, _Ur.red),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15.5, color: _Ur.ink),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// The drawer.
// ---------------------------------------------------------------------------

/// The drawer: URnetwork's own sheet — the handle, the tinted card with
/// the location row and the Connect button at the peek, and the stats
/// below the fold.
class _UrDrawer extends StatelessWidget {
  const _UrDrawer({
    required this.scrollController,
    required this.core,
    required this.settings,
    required this.status,
    required this.phase,
    required this.busy,
    required this.place,
    required this.sessionStart,
    required this.samples,
    required this.onPress,
    this.onOpenServers,
    this.onOpenRouting,
    this.onOpenShare,
    this.push,
  });

  final ScrollController scrollController;
  final CoreController core;
  final AppSettings settings;
  final CoreStatus status;
  final _Phase phase;
  final bool busy;
  final HomePlace place;
  final DateTime? sessionStart;
  final List<List<double>> samples;
  final VoidCallback onPress;
  final VoidCallback? onOpenServers;
  final VoidCallback? onOpenRouting;
  final VoidCallback? onOpenShare;
  final void Function(String title, Widget page)? push;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _Ur.sheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          // the drag handle, the M3's own 32x4
          Center(
            child: Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: _Ur.muted.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _Ur.bgTinted,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
            child: Column(
              children: [
                _LocationRow(place: place, onOpen: onOpenServers),
                const SizedBox(height: 8),
                _ConnectAction(
                  on: phase == _Phase.connected || phase == _Phase.connecting,
                  busy: busy,
                  onPress: onPress,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // The connection's own options, the original's ConnectOptions
          // below the fold: the carrier the tunnel rides (the segmented
          // row) and the switches that shape the walk — all settings the
          // core keeps.
          _ConnectOptions(core: core),
          const SizedBox(height: 16),
          _StatsCard(
            status: status,
            connected: phase == _Phase.connected,
            confirming: phase == _Phase.connecting,
            sessionStart: sessionStart,
            samples: samples,
          ),
          const SizedBox(height: 16),
          // The session's usage as the original's usage bar: the send in
          // the blue, the receive in the faint ink.
          if (status.traffic != null)
            UrUsageCard(
              up: status.traffic!.up,
              down: status.traffic!.down,
            ),
          // The original's statistics sections under the stats: the
          // transports and the address families inside the card, then the
          // split apps row, the local statistics, the custom DNS summary
          // and the blocker's own panel.
          _TransportsSection(exit: status.exit),
          const SizedBox(height: 16),
          UrSplitPanel(push: push),
          const SizedBox(height: 16),
          UrLocalStatsCard(core: core, push: push),
          const SizedBox(height: 16),
          UrDnsCard(core: core, settings: settings, push: push),
          const SizedBox(height: 16),
          UrBlockerPanel(core: core),
          // The quick options and the hotspot share: the phone's own
          // settings, one card of switches and one row that opens the
          // share page.
          if (Platform.isAndroid) ...[
            const SizedBox(height: 16),
            _QuickCard(onOpenRouting: onOpenRouting),
            const SizedBox(height: 16),
            _ShareCard(onOpen: onOpenShare),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// The location row: the globe in the original's red while the app picks,
/// the flag once a country is chosen, the place's name and its line, and
/// the Change link in the pink.
class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.place, required this.onOpen});

  final HomePlace place;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final best = place.auto || place.flag == 'REC' || place.flag.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Pressable(
              depth: 0.02,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onOpen,
                child: Row(
                  children: [
                    best
                        ? const Icon(
                            Icons.public_rounded,
                            size: 36,
                            color: _Ur.red,
                          )
                        : SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: CountryFlag(code: place.flag, width: 32),
                            ),
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.2,
                              color: _Ur.ink,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            place.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.2,
                              color: _Ur.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onOpen,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 40),
            ),
            child: Text(
              l.urChangeLocation,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: _Ur.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The Connect button, the original's URButton: the blue fill for the
/// connect, the hairline outline for the disconnect, the spinner while
/// the walk is busy.
class _ConnectAction extends StatelessWidget {
  const _ConnectAction({
    required this.on,
    required this.busy,
    required this.onPress,
  });

  final bool on;
  final bool busy;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final typefaces = typefacesOf(context);
    return SizedBox(
      width: double.infinity,
      child: Pressable(
        depth: 0.03,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: busy ? null : onPress,
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on ? Colors.transparent : _Ur.blueMedium,
              borderRadius: BorderRadius.circular(12),
              border: on ? Border.all(color: _Ur.faint) : null,
            ),
            child: busy
                ? SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: on ? _Ur.muted : Colors.white,
                    ),
                  )
                : Text(
                    on ? l.urDisconnect : l.urConnect,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                      color: on ? _Ur.muted : Colors.white,
                      fontFamily: typefaces.display,
                      fontFamilyFallback: typefaces.displayFallback,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// The stats below the fold: the live speeds and the session's numbers,
/// in the drawer's own tinted cards.
class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.status,
    required this.connected,
    required this.confirming,
    required this.sessionStart,
    required this.samples,
  });

  final CoreStatus status;
  final bool connected;
  final bool confirming;
  final DateTime? sessionStart;
  final List<List<double>> samples;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final traffic = status.traffic;
    final exit = status.exit;
    final test = status.isCurrentTest(status.lastTest) ? status.lastTest : null;

    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _Ur.muted, fontSize: 13.5),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _Ur.ink,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: _Ur.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.urStatsTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: _Ur.muted,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SpeedTile(
                  label: l.urSpeedUp,
                  value: traffic?.upRate,
                  color: _Ur.blueMedium,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SpeedTile(
                  label: l.urSpeedDown,
                  value: traffic?.downRate,
                  color: _Ur.green500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TransferChart(samples: samples),
          const SizedBox(height: 6),
          row(
            l.urSessionTime,
            (connected || confirming) && sessionStart != null
                ? formatDuration(l, DateTime.now().difference(sessionStart!))
                : l.urNoData,
          ),
          _hairline(),
          row(
            l.urSessionData,
            traffic == null
                ? l.urNoData
                : '${ltr(formatBytes(traffic.up))} ↑ · ${ltr(formatBytes(traffic.down))} ↓',
          ),
          _hairline(),
          row(
            l.publicIp,
            exit == null || (exit.ipv4.isEmpty && exit.ipv6.isEmpty)
                ? l.urNoData
                : (exit.ipv4.isNotEmpty ? exit.ipv4 : exit.ipv6),
          ),
          _hairline(),
          row(
            l.urExitLocation,
            exit != null && exit.countryName.isNotEmpty
                ? (exit.city.isNotEmpty ? '${exit.city}, ' : '') +
                    exit.countryName
                : l.urNoData,
          ),
          _hairline(),
          row(
            l.urLastTest,
            test == null
                ? l.urNoData
                : test.ok
                ? '${test.totalMs} ms'
                : test.error,
          ),
        ],
      ),
    );
  }

  Widget _hairline() => Container(height: 1, color: _Ur.face);
}

/// One speed tile: the label's dot and the live rate.
class _SpeedTile extends StatelessWidget {
  const _SpeedTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int? value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 7),
              Text(label, style: const TextStyle(fontSize: 12.5, color: _Ur.muted)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value == null ? '0' : urFormatByteRate(value!),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _Ur.ink,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// The transfer chart, the original's own: mirrored around a center axis,
/// the send drawn above the line and the receive below it, each scaled to
/// its window's peak, the peak's own value labeled where it stands — the
/// label reads "2.50 KiB/s" in the same units the tiles carry.
class _TransferChart extends StatelessWidget {
  const _TransferChart({required this.samples});

  final List<List<double>> samples;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (samples.isEmpty) {
      return SizedBox(
        height: 88,
        child: Center(
          child: Text(
            l.urNoData,
            style: const TextStyle(fontSize: 12.5, color: _Ur.muted),
          ),
        ),
      );
    }
    return SizedBox(
      height: 88,
      child: CustomPaint(
        size: Size.infinite,
        painter: _TransferPainter(samples: samples),
      ),
    );
  }
}

class _TransferPainter extends CustomPainter {
  _TransferPainter({required this.samples});

  final List<List<double>> samples;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.height / 2;
    canvas.drawLine(
      Offset(0, center),
      Offset(size.width, center),
      Paint()
        ..color = _Ur.faint
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

    final peakUp = peak(0);
    final peakDown = peak(1);
    final room = size.height / 2 - 14;

    // One direction: the filled curve from the center axis, the 1.5 px
    // line over it, the newest sample at the right edge.
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

    draw(0, peakUp, _Ur.blueMedium, true);
    draw(1, peakDown, _Ur.green500, false);

    // The peaks' labels, each sitting over its own sample: the send's
    // window maximum on top, the receive's under the axis.
    void label(int i, double peak, String arrow, bool above) {
      var best = 0;
      for (var k = 1; k < samples.length; k++) {
        if (samples[k][i] > samples[best][i]) best = k;
      }
      final x = size.width * best / (samples.length - 1);
      final text = '$arrow ${urFormatByteRate(peak.round())}';
      final tp = TextPainter(
        text: TextSpan(
          text: ltr(text),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: _Ur.muted,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final dx = (x - tp.width / 2).clamp(0.0, size.width - tp.width);
      final dy = above
          ? (center - room - tp.height - 2).clamp(0.0, center - tp.height)
          : (center + room + 2).clamp(center, size.height - tp.height);
      tp.paint(canvas, Offset(dx, dy));
    }

    label(0, peakUp, '↑', true);
    label(1, peakDown, '↓', false);
  }

  @override
  bool shouldRepaint(_TransferPainter old) =>
      // The samples list is the page's own (its identity never changes),
      // so the count is what says a new point arrived.
      old.samples.length != samples.length;
}

/// The byte rate in the original's own words: binary steps, two decimals
/// once the number has one, "2.50 KiB/s".
String urFormatByteRate(int bytesPerSecond) {
  final b = bytesPerSecond.toDouble();
  const units = ['B/s', 'KiB/s', 'MiB/s', 'GiB/s', 'TiB/s'];
  var value = b;
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final text = unit == 0
      ? value.round().toString()
      : value >= 100
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(2);
  return ltr('$text ${units[unit]}');
}

/// The quick options: the phone's own connection settings, one card —
/// the kill switch, the notification's speed and flag, and the row that
/// opens the per-app routing.
class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.onOpenRouting});

  final VoidCallback? onOpenRouting;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _Ur.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.urQuickTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: _Ur.muted,
            ),
          ),
          const SizedBox(height: 4),
          ValueListenableBuilder<bool>(
            valueListenable: AndroidCore.killSwitch,
            builder: (context, on, _) => _switchRow(
              label: l.killSwitch,
              subtitle: l.killSwitchHint,
              value: on,
              onChanged: (v) => AndroidCore.setKillSwitch(v),
            ),
          ),
          _hairline(),
          ValueListenableBuilder<bool>(
            valueListenable: AndroidCore.showSpeed,
            builder: (context, on, _) => _switchRow(
              label: l.speedInNotification,
              value: on,
              onChanged: (v) => AndroidCore.setShowSpeed(v),
            ),
          ),
          _hairline(),
          ValueListenableBuilder<bool>(
            valueListenable: AndroidCore.notifFlag,
            builder: (context, on, _) => _switchRow(
              label: l.notifFlag,
              value: on,
              onChanged: (v) => AndroidCore.setNotifFlag(v),
            ),
          ),
          _hairline(),
          if (onOpenRouting != null)
            _navRow(
              icon: Icons.alt_route_rounded,
              label: l.sectionRouting,
              onTap: onOpenRouting!,
            ),
        ],
      ),
    );
  }

  Widget _hairline() => Container(height: 1, color: _Ur.face);

  Widget _switchRow({
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14.5, color: _Ur.ink),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: _Ur.muted),
                    ),
                  ],
                  const SizedBox(height: 2),
                ],
              ),
            ),
            UrSwitch(
              checked: value,
              onToggle: () => onChanged(!value),
            ),
          ],
        ),
      );

  Widget _navRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) => UrPressable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: _Ur.muted),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14.5, color: _Ur.ink),
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: _Ur.muted),
            ],
          ),
        ),
      );
}

/// The hotspot share: one row that opens the share page, where the phone
/// hands its tunnel to the devices on its own hotspot.
class _ShareCard extends StatelessWidget {
  const _ShareCard({required this.onOpen});

  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: _Ur.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onOpen != null)
            _row(
              icon: Icons.wifi_tethering_rounded,
              label: l.urShare,
              onTap: onOpen!,
            ),
        ],
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) => UrPressable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: _Ur.muted),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14.5, color: _Ur.ink),
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 20, color: _Ur.muted),
            ],
          ),
        ),
      );
}


/// The connection's own options, the original's ConnectOptions below the
/// fold: the segmented row for the carrier the tunnel rides (the core's
/// `proxy.transport`, HTTP/1.1, HTTP/2 or HTTP/3), and the switches that
/// shape the walk — the fastest location (`proxy.country` "fastest"),
/// QUIC pass-through (`tun.quic`), and the split routing
/// (`routing.enabled`). Each one a setting the core keeps; the writes go
/// through the settings API the section pages always used.
class _ConnectOptions extends StatefulWidget {
  const _ConnectOptions({required this.core});

  final CoreController core;

  @override
  State<_ConnectOptions> createState() => _ConnectOptionsState();
}

class _ConnectOptionsState extends State<_ConnectOptions> {
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
      if (!mounted) return;
      setState(() => _config = config);
    } on Exception {
      // The next drawer open reads again; the shell shows a save's error.
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

  String get _transport => switch (_get(['proxy', 'transport'])) {
    'h3' => 'h3',
    'h1' => 'h1',
    _ => 'h2',
  };

  /// Saves [values] (path → value) through the core and reads the config
  /// again; the toast lands as the app's own soft note.
  Future<void> _save(Map<List<String>, Object?> values) async {
    if (_saving) return;
    setState(() => _saving = true);
    final ok = await runShowingErrors(
      context,
      () => widget.core.editSettings((config) {
        values.forEach((path, value) {
          Object? node = config;
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
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      await _load();
      if (mounted) showToast(context, AppLocalizations.of(context).saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final transport = _transport;
    return Container(
      decoration: BoxDecoration(
        color: UrTokens.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // the segmented row: the carrier, the original's own control
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: UrTokens.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                for (final t in const ['h1', 'h2', 'h3'])
                  Expanded(
                    child: UrPressable(
                      onTap: _saving || t == transport
                          ? null
                          : () => _save({
                              ['proxy', 'transport']: t,
                            }),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: t == transport
                              ? UrTokens.bgTinted
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          t.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: t == transport
                                ? UrTokens.ink
                                : UrTokens.muted,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          _optionSwitch(
            label: l.smartLocation,
            subtitle: l.smartLocationHint,
            value: _get(['proxy', 'country']) == 'fastest',
            onChanged: _config == null
                ? null
                : (v) => _save({
                    ['proxy', 'country']: v ? 'fastest' : '',
                  }),
          ),
          _hairline(),
          _optionSwitch(
            label: l.quicPass,
            subtitle: l.quicPassHint,
            value: _get(['tun', 'quic']) == true,
            onChanged: _config == null
                ? null
                : (v) => _save({
                    ['tun', 'quic']: v,
                  }),
          ),
          _hairline(),
          _optionSwitch(
            label: l.sectionRouting,
            value: _get(['routing', 'enabled']) == true,
            onChanged: _config == null
                ? null
                : (v) => _save({
                    ['routing', 'enabled']: v,
                  }),
          ),
        ],
      ),
    );
  }

  Widget _hairline() => Container(height: 1, color: UrTokens.border);

  Widget _optionSwitch({
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: UrTokens.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: UrTokens.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                ],
              ),
            ),
            UrSwitch(
              checked: value,
              onToggle: () => onChanged?.call(!value),
            ),
          ],
        ),
      );
}

/// The transports card, the original's own section: the carriers the proxy's
/// connections ride, as the stacked bar with its legend and unused footer,
/// and the exit's address families under it. One small walk every two
/// seconds while the drawer stands open — the walk the connections page
/// takes — nothing more than the core already answers.
class _TransportsSection extends StatefulWidget {
  const _TransportsSection({required this.core, required this.exit});

  final CoreController core;
  final ExitInfo? exit;

  @override
  State<_TransportsSection> createState() => _TransportsSectionState();
}

class _TransportsSectionState extends State<_TransportsSection> {
  Timer? _timer;
  List<ProxyConnection> _connections = const [];
  String _configured = '';

  @override
  void initState() {
    super.initState();
    _read();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _read());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _read() async {
    try {
      final conns = await widget.core.call((api) => api.connections());
      final config = await widget.core.settings();
      final transport = switch (config['proxy']) {
        final Map<String, Object?> m => '${m['transport'] ?? 'h2'}',
        _ => 'h2',
      };
      if (!mounted) return;
      setState(() {
        _connections = conns;
        _configured = transport;
      });
    } on Exception {
      // The core may be mid-restart; the last list stands until the next
      // walk.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UrTokens.bgTinted,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UrTransportBar(
            shares: transportShares(_connections, _configured),
          ),
          const SizedBox(height: 12),
          UrIpFamilyRow(exit: widget.exit),
        ],
      ),
    );
  }
}
