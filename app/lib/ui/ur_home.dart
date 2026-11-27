import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../core/core_controller.dart';
import '../core/models.dart';
import '../l10n/app_localizations.dart';
import 'design.dart';
import 'design_style.dart';
import 'format.dart';
import 'motion.dart';
import 'widgets.dart';

/// The ur home: the URnetwork connect face, re-read for this app.
///
/// One big round button carries the connection: a scatter of points that
/// gathers into a core as the tunnel comes up and falls apart as it goes,
/// a breathing pulse while nothing runs, and the state's word where
/// URnetwork says "Tap to connect". A location card sits under it, a wide
/// Connect button under that, and the page's bottom edge is a handle: pull
/// it up and the live stats open in a sheet — speeds, the sparkline, the
/// session's numbers.
///
/// Everything here draws from the core's own state (no new data), every
/// animation is a one-way walk tied to the state change (nothing loops
/// except the off-state pulse, which stops under the battery saver and the
/// system's reduce-motion), and every moving piece is a RepaintBoundary
/// painted in one CustomPainter, so the weak-GPU phones keep their frames.

class UrHome extends StatefulWidget {
  const UrHome({
    super.key,
    required this.core,
    required this.status,
    required this.settings,
    this.onOpenServers,
    this.onOpenAccounts,
  });

  final CoreController core;
  final CoreStatus status;
  final AppSettings settings;
  final VoidCallback? onOpenServers;
  final VoidCallback? onOpenAccounts;

  @override
  State<UrHome> createState() => _UrHomeState();
}

class _UrHomeState extends State<UrHome> {
  /// The moment the tunnel came up this session; null while it is down.
  /// The elapsed row reads it — the page's own rebuilds never move it.
  DateTime? _sessionStart;

  /// The speed samples the sparkline draws: (up, down) bytes per second,
  /// one per second at most, the newest last.
  final List<List<double>> _samples = [];
  DateTime _lastSample = DateTime.fromMillisecondsSinceEpoch(0);

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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    final style = DesignStyle.of(context);
    final top = MediaQuery.paddingOf(context).top;

    final running = status.state.phase == Phase.running;
    final on = status.proxyOn;
    final confirming =
        status.connectPending ||
        (on && running && !status.confirmedBy(widget.core.lastTest));
    final connected = on && running && !confirming;
    final busy = widget.core.switchingProxy || status.connectPending;
    final accent = look.accent ?? Theme.of(context).colorScheme.primary;

    final place = homeLocation(l, status, connected: connected);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Stack(
        children: [
          // The dark canvas with its own quiet shapes: the blob behind the
          // button and the color notes the stats carry. Painted once, the
          // page's rebuilds never touch it.
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _UrBackdropPainter(
                  accent: accent,
                  dark: dark,
                  on: connected,
                ),
              ),
            ),
          ),
          // The connect face: the brand, the orb, the location card, the
          // wide button — each its own repaint boundary.
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(height: top > 0 ? 0 : 8),
                  const Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Center(child: BrandWordmark(height: 24)),
                  ),
                  Expanded(
                    child: Center(
                      child: RepaintBoundary(
                        child: UrConnectOrb(
                          on: on,
                          confirming: confirming,
                          busy: busy,
                          accent: accent,
                          ink: look.ink,
                          muted: look.muted,
                          still: widget.settings.batterySaver,
                          onPressed: () => _press(context),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: UrLocationCard(
                      place: place,
                      accent: accent,
                      card: look.homeCard,
                      border: look.homeCardBorder,
                      ink: look.ink,
                      muted: look.muted,
                      onOpenServers: widget.onOpenServers,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    child: UrConnectButton(
                      on: on,
                      busy: busy,
                      accent: accent,
                      ink: look.ink,
                      onPressed: () => _press(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          // The stats sheet: a handle at the page's bottom edge, the live
          // numbers behind it. Its bottom stops above the floating pill.
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 88),
              child: DraggableScrollableSheet(
                initialChildSize: 0.085,
                minChildSize: 0.085,
                maxChildSize: 0.72,
                snap: true,
                snapSizes: const [0.085, 0.42, 0.72],
                builder: (context, scrollController) => UrStatsSheet(
                  scrollController: scrollController,
                  status: status,
                  connected: connected,
                  confirming: confirming,
                  sessionStart: _sessionStart,
                  samples: _samples,
                  accent: accent,
                  card: look.homeCard,
                  border: look.homeCardBorder,
                  ink: look.ink,
                  muted: look.muted,
                  connectedColor: style.connected,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The backdrop: the dark stock with its quiet shapes.
// ---------------------------------------------------------------------------

/// The page's own canvas: the near-black wash, the big soft blob that
/// holds the button (the way URnetwork's dark panels sit behind the
/// connect circle), and two small color notes — the pink and the green
/// — low in the page, where the stats sheet's colors already answer them.
/// Static: one paint per state change at most.
class _UrBackdropPainter extends CustomPainter {
  _UrBackdropPainter({
    required this.accent,
    required this.dark,
    required this.on,
  });

  final Color accent;
  final bool dark;
  final bool on;

  @override
  void paint(Canvas canvas, Size size) {
    // The wash.
    final wash = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF101010),
          const Color(0xFF0B0B0B),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, wash);

    // The blob behind the button: an irregular rounded polygon, the
    // app's own dark panels' shape. It breathes a touch lighter while
    // the tunnel carries.
    final cx = size.width / 2;
    final cy = size.height * (on ? 0.40 : 0.38);
    final r = math.min(size.width * 0.62, size.height * 0.30);
    final blob = Path();
    final paint = Paint()
      ..color = const Color(0xFF181818)
      ..style = PaintingStyle.fill;
    // Six lobes at uneven radii — one path, no cost.
    const lobes = [1.0, 0.82, 1.06, 0.9, 1.0, 0.86];
    var first = true;
    for (var i = 0; i < 24; i++) {
      final t = i / 24 * 2 * math.pi;
      final k = lobes[i % lobes.length] * (0.9 + 0.1 * math.sin(t * 3));
      final p = Offset(cx + math.cos(t) * r * k, cy + math.sin(t) * r * 0.92 * k);
      if (first) {
        blob.moveTo(p.dx, p.dy);
        first = false;
      } else {
        blob.lineTo(p.dx, p.dy);
      }
    }
    blob.close();
    canvas.drawPath(blob, paint);
    // A second, smaller wash above it keeps the shape from reading flat.
    paint.color = const Color(0xFF151515);
    canvas.drawCircle(Offset(cx, cy), r * 0.72, paint);

    // The two color notes: the pink flower's tint and the green's, both
    // far down where the sheet sits over them, both barely there.
    final note = Paint();
    note.color = const Color(0xFFED8FFF).withValues(alpha: 0.05);
    canvas.drawCircle(Offset(size.width * 0.16, size.height * 0.78), r * 0.30, note);
    note.color = const Color(0xFF53F12A).withValues(alpha: 0.04);
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.70), r * 0.26, note);
    // The blue's halo behind the button while the tunnel carries.
    if (on) {
      note.color = accent.withValues(alpha: 0.10);
      canvas.drawCircle(Offset(cx, cy), r * 0.80, note);
    }
  }

  @override
  bool shouldRepaint(_UrBackdropPainter old) =>
      old.on != on || old.accent != accent || old.dark != dark;
}

// ---------------------------------------------------------------------------
// The connect orb.
// ---------------------------------------------------------------------------

/// The round button: one face for every state, in one canvas.
///
/// - Off: "Tap to connect" and a breathing pulse ring, the way
///   URnetwork invites the first tap.
/// - Connecting: the scatter, lit, with the state's word.
/// - Connected: the scatter gathered into a core around the blue disc,
///   the network's own picture of the tunnel.
///
/// Two controllers only: the gather (one walk per state change) and the
/// pulse (a 4-second cycle whose first second breathes, repeating only
/// while off and only while the screen asks for motion).
class UrConnectOrb extends StatefulWidget {
  const UrConnectOrb({
    super.key,
    required this.on,
    required this.confirming,
    required this.busy,
    required this.accent,
    required this.ink,
    required this.muted,
    required this.still,
    required this.onPressed,
  });

  final bool on;
  final bool confirming;
  final bool busy;
  final Color accent;
  final Color ink;
  final Color muted;
  final bool still;
  final VoidCallback onPressed;

  @override
  State<UrConnectOrb> createState() => _UrConnectOrbState();
}

class _UrConnectOrbState extends State<UrConnectOrb>
    with TickerProviderStateMixin {
  late final AnimationController _gather = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4000),
  );

  @override
  void initState() {
    super.initState();
    // The pulse's start needs the inherited media (reduce-motion), so the
    // first sync runs in didChangeDependencies.
    if (widget.on) _gather.value = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(UrConnectOrb old) {
    super.didUpdateWidget(old);
    _sync();
  }

  /// One walk per change: off scatters (reverse), on gathers (forward).
  /// The pulse runs only while off, and only when motion is welcome.
  void _sync() {
    final off = !widget.on;
    if (off) {
      _gather.reverse();
      if (widget.still || MediaQuery.of(context).disableAnimations) {
        _pulse.stop();
      } else if (!_pulse.isAnimating) {
        _pulse.repeat();
      }
    } else {
      _pulse.stop();
      _gather.forward();
    }
  }

  @override
  void dispose() {
    _gather.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = widget.confirming
        ? l.stateConnecting
        : widget.on
        ? l.stateConnected
        : l.tapToConnectPhone;
    final orb = MediaQuery.of(context).disableAnimations || widget.still
        ? _gather.value.clamp(0.0, 1.0)
        : null;

    return Semantics(
      button: true,
      label: label,
      child: Pressable(
        depth: 0.04,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: SizedBox.square(
            dimension: 248,
            child: AnimatedBuilder(
              animation: Listenable.merge([_gather, _pulse]),
              builder: (context, _) {
                final gather = orb ?? Curves.easeOutCubic.transform(
                  _gather.value.clamp(0.0, 1.0),
                );
                return CustomPaint(
                  painter: _UrOrbPainter(
                    gather: gather,
                    pulse: widget.on ? 0 : _pulse.value,
                    accent: widget.accent,
                    muted: widget.muted,
                    on: widget.on,
                    confirming: widget.confirming,
                    busy: widget.busy,
                    still: widget.still ||
                        MediaQuery.of(context).disableAnimations,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // The state's word, in the display's own voice.
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                            color: widget.on && !widget.confirming
                                ? Colors.white
                                : widget.ink,
                            fontFamily: typefacesOf(context).display,
                            fontFamilyFallback:
                                typefacesOf(context).displayFallback,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // The mark under the word: the flower while off,
                        // the spinner while the walk is busy.
                        SizedBox.square(
                          dimension: 40,
                          child: Center(
                            child: widget.busy && widget.on
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                    ),
                                  )
                                : Icon(
                                    Icons.local_florist_rounded,
                                    size: 26,
                                    color: widget.confirming
                                        ? widget.accent
                                        : widget.accent.withValues(
                                            alpha: widget.on ? 1 : 0.9,
                                          ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// The orb's face: the ring, the scatter's points and their walk, the
/// pulse. One painter per state frame — the weak GPUs keep their frames.
class _UrOrbPainter extends CustomPainter {
  _UrOrbPainter({
    required this.gather,
    required this.pulse,
    required this.accent,
    required this.muted,
    required this.on,
    required this.confirming,
    required this.busy,
    required this.still,
  });

  final double gather;
  final double pulse;
  final Color accent;
  final Color muted;
  final bool on;
  final bool confirming;
  final bool busy;
  final bool still;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final face = Paint()..color = Colors.white.withValues(alpha: 0.04);
    // The button's own ground: a soft square the circle sits in.
    canvas.drawCircle(c, size.width / 2 - 2, face);

    // The gathered core: the blue disc the points land on.
    final coreRadius = 8 + 30 * gather;
    if (gather > 0.02) {
      final core = Paint()
        ..color = accent.withValues(alpha: (0.25 + 0.75 * gather).clamp(0.0, 1.0));
      canvas.drawCircle(c, coreRadius, core);
    }

    // The scatter: the app's own points, deterministic so a refresh never
    // reshuffles the picture. Each point walks from its resting place to
    // the core's edge, in two waves, the way the network's own dots
    // gather as the tunnel comes up.
    final rnd = math.Random(11);
    const points = 34;
    final dot = Paint();
    final maxR = size.width / 2 - 26;
    for (var i = 0; i < points; i++) {
      final angle = rnd.nextDouble() * 2 * math.pi;
      final dist = (0.30 + 0.70 * rnd.nextDouble()) * maxR;
      final rest = Offset(
        c.dx + math.cos(angle) * dist,
        c.dy + math.sin(angle) * dist,
      );
      // Two waves: the first half lands, then the second.
      final wave = i < points ~/ 2 ? 0.0 : 0.28;
      final t = ((gather - wave) / (1 - wave)).clamp(0.0, 1.0);
      final e = Curves.easeInOutCubic.transform(t);
      final p = Offset.lerp(rest, c, e)!;
      final base = confirming || on
          ? (t > 0.85 ? Colors.white : accent)
          : (t > 0.5 ? accent : muted);
      dot.color = base.withValues(
        alpha: (0.30 + 0.55 * (1 - e)).clamp(0.0, 1.0),
      );
      final radius = 1.6 + 1.2 * rnd.nextDouble() + 1.6 * e;
      canvas.drawCircle(p, radius, dot);
    }

    // The off-state pulse: one ring breathing outward every cycle's first
    // second, the rest of the cycle still.
    if (!on && !still && pulse > 0) {
      final breathe = (pulse * 4).clamp(0.0, 1.0);
      if (breathe < 1) {
        final ring = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = accent.withValues(alpha: (1 - breathe) * 0.5);
        canvas.drawCircle(c, 34 + 26 * Curves.easeOut.transform(breathe), ring);
      }
    }

    // The connected disc's rim and its quiet center mark.
    if (gather > 0.95) {
      final rim = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = Colors.white.withValues(alpha: 0.16);
      canvas.drawCircle(c, coreRadius + 6, rim);
    }
  }

  @override
  bool shouldRepaint(_UrOrbPainter old) =>
      old.gather != gather ||
      old.pulse != pulse ||
      old.on != on ||
      old.confirming != confirming ||
      old.busy != busy ||
      old.accent != accent;
}

// ---------------------------------------------------------------------------
// The location card and the wide button.
// ---------------------------------------------------------------------------

/// The location's card: the flag, the place's name, the line above it
/// (how it was chosen), and the Change link — URnetwork's card, with
/// this app's own words.
class UrLocationCard extends StatelessWidget {
  const UrLocationCard({
    super.key,
    required this.place,
    required this.accent,
    required this.card,
    required this.border,
    required this.ink,
    required this.muted,
    required this.onOpenServers,
  });

  final HomePlace place;
  final Color accent;
  final Color card;
  final Color border;
  final Color ink;
  final Color muted;
  final VoidCallback? onOpenServers;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onOpenServers,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              CountryFlag(code: place.flag, width: 40),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l.urChangeLocation,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The wide Connect button: one filled block under the card, the state's
/// word or the spinner carrying its label.
class UrConnectButton extends StatelessWidget {
  const UrConnectButton({
    super.key,
    required this.on,
    required this.busy,
    required this.accent,
    required this.ink,
    required this.onPressed,
  });

  final bool on;
  final bool busy;
  final Color accent;
  final Color ink;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = busy
        ? l.stateConnecting
        : on
        ? l.urDisconnect
        : l.urConnect;
    return Pressable(
      depth: 0.05,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: on ? Colors.white.withValues(alpha: 0.10) : accent,
            foregroundColor: on ? ink : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy) ...[
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                ),
                const SizedBox(width: 10),
              ],
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The stats sheet.
// ---------------------------------------------------------------------------

/// The live stats: a handle at the bottom edge, and behind it the speeds,
/// the sparkline and the session's rows — every number the core already
/// reports, in the URnetwork's own dark tiles.
class UrStatsSheet extends StatelessWidget {
  const UrStatsSheet({
    super.key,
    required this.scrollController,
    required this.status,
    required this.connected,
    required this.confirming,
    required this.sessionStart,
    required this.samples,
    required this.accent,
    required this.card,
    required this.border,
    required this.ink,
    required this.muted,
    required this.connectedColor,
  });

  final ScrollController scrollController;
  final CoreStatus status;
  final bool connected;
  final bool confirming;
  final DateTime? sessionStart;
  final List<List<double>> samples;
  final Color accent;
  final Color card;
  final Color border;
  final Color ink;
  final Color muted;
  final Color connectedColor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final traffic = status.traffic;
    final exit = status.exit;
    final test =
        status.isCurrentTest(status.lastTest) ? status.lastTest : null;

    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: muted, fontSize: 13.5))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ink,
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
        color: card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: border)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          // The handle.
          Center(
            child: Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: confirming
                      ? accent
                      : connected
                      ? connectedColor
                      : muted,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l.urStatsTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              const Spacer(),
              Text(
                l.urStatsHint,
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // The two speeds and the sparkline between them.
          Row(
            children: [
              Expanded(
                child: _SpeedTile(
                  label: l.urSpeedUp,
                  value: traffic?.upRate,
                  color: accent,
                  ink: ink,
                  muted: muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SpeedTile(
                  label: l.urSpeedDown,
                  value: traffic?.downRate,
                  color: connectedColor,
                  ink: ink,
                  muted: muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          UrSpeedSpark(
            samples: samples,
            up: accent,
            down: connectedColor,
            muted: muted,
          ),
          const SizedBox(height: 6),
          Divider(color: border, height: 24),
          // The session's numbers.
          row(
            l.urSessionTime,
            (connected || confirming) && sessionStart != null
                ? formatDuration(l, DateTime.now().difference(sessionStart!))
                : l.urNoData,
          ),
          row(
            l.urSessionData,
            traffic == null
                ? l.urNoData
                : '${formatBytes(traffic.up)} ↑ · ${formatBytes(traffic.down)} ↓',
          ),
          row(
            l.publicIp,
            exit == null || (exit.ipv4.isEmpty && exit.ipv6.isEmpty)
                ? l.urNoData
                : (exit.ipv4.isNotEmpty ? exit.ipv4 : exit.ipv6),
          ),
          row(
            l.urExitLocation,
            exit != null && exit.countryName.isNotEmpty
                ? (exit.city.isNotEmpty ? '${exit.city}, ' : '') +
                    exit.countryName
                : l.urNoData,
          ),
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
}

/// One speed tile: the tile's tint, the label, and the live rate — the
/// same numbers the notification carries, drawn in the sheet's own ink.
class _SpeedTile extends StatelessWidget {
  const _SpeedTile({
    required this.label,
    required this.value,
    required this.color,
    required this.ink,
    required this.muted,
  });

  final String label;
  final int? value;
  final Color color;
  final Color ink;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
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
              Text(
                label,
                style: TextStyle(fontSize: 12.5, color: muted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value == null ? '0' : formatRate(value!),
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: ink,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// The sparkline: the session's speeds, one line each way, drawn small
/// and quiet. The samples the page keeps change one point at a time, so
/// the painter repaints only itself.
class UrSpeedSpark extends StatelessWidget {
  const UrSpeedSpark({
    super.key,
    required this.samples,
    required this.up,
    required this.down,
    required this.muted,
  });

  final List<List<double>> samples;
  final Color up;
  final Color down;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return SizedBox(
        height: 64,
        child: Center(
          child: Text(
            AppLocalizations.of(context).urNoData,
            style: TextStyle(fontSize: 12.5, color: muted),
          ),
        ),
      );
    }
    return SizedBox(
      height: 64,
      child: CustomPaint(
        size: Size.infinite,
        painter: _UrSparkPainter(
          samples: samples,
          up: up,
          down: down,
          grid: muted.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _UrSparkPainter extends CustomPainter {
  _UrSparkPainter({
    required this.samples,
    required this.up,
    required this.down,
    required this.grid,
  });

  final List<List<double>> samples;
  final Color up;
  final Color down;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) return;
    double peak = 1;
    for (final s in samples) {
      peak = math.max(peak, math.max(s[0], s[1]));
    }
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // One hairline at the middle keeps the two lines apart without a grid.
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = grid
        ..strokeWidth = 1,
    );
    void draw(int i, Color color) {
      final path = Path();
      final n = samples.length;
      for (var k = 0; k < n; k++) {
        final x = size.width * k / (n - 1);
        final v = (samples[k][i] / peak).clamp(0.0, 1.0);
        final y = size.height - 3 - v * (size.height - 6);
        if (k == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, line..color = color);
    }

    draw(0, up);
    draw(1, down);
  }

  @override
  bool shouldRepaint(_UrSparkPainter old) =>
      // The samples list is the page's own (its identity never changes),
      // so the count is what says a new point arrived.
      old.samples.length != samples.length;
}
