import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_controller.dart';
import '../l10n/app_localizations.dart';
import 'accent.dart';
import 'design.dart';
import 'motion.dart';
import 'widgets.dart';

/// The first run: the user picks a language and a country, and the
/// country's sites go directly (the core's routing region).
///
/// The page earns its first impression: a shield that breathes inside
/// rings of its own light, over an aurora that drifts on its own slow
/// clock; the selectors and the start button land with the entrance the
/// rest of the app uses. Everything on it still works the way it did —
/// only the look moved forward.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.core, required this.settings});

  final CoreController core;
  final AppSettings settings;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late String _language;
  late String _region;

  /// A manual region choice always wins over desktop language suggestions.
  bool _regionPicked = false;
  bool _saving = false;

  /// The aurora's own slow clock: two lights drifting behind the hero.
  /// It stops the moment the page is gone (dispose), and holds still for
  /// the system's reduce-motion, like every moving part of the app.
  late final AnimationController _drift = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  );

  /// The shield's breath: the rings around it swell and fade. Started
  /// with the aurora, once the first frame's MediaQuery is here; under
  /// reduce-motion it rests at its middle instead of repeating.
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void initState() {
    super.initState();
    final system = PlatformDispatcher.instance.locale;
    _language = widget.settings.language.isNotEmpty
        ? widget.settings.language
        : AppSettings.languageFor(system);
    _region =
        widget.settings.firstRunRegion ??
        AppSettings.suggestedRegion(_language, system.countryCode);
  }

  /// The aurora starts once the first frame's MediaQuery is here: it
  /// holds still for the system's reduce-motion, like every moving part
  /// of the app.
  bool _driftStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_driftStarted) return;
    _driftStarted = true;
    final still = MediaQuery.of(context).disableAnimations;
    if (still) {
      _breath.value = 0.5;
    } else {
      _breath.repeat(reverse: true);
      _drift.repeat();
    }
  }

  @override
  void dispose() {
    _drift.dispose();
    _breath.dispose();
    super.dispose();
  }

  void _pickLanguage(String language) {
    setState(() {
      _language = language;
      if (widget.settings.firstRunRegion == null && !_regionPicked) {
        _region = AppSettings.regionForLanguage(language) ?? _region;
      }
    });
    // Show the page in the chosen language at once.
    widget.settings.update(language: language);
  }

  Future<void> _start() async {
    setState(() => _saving = true);
    final region = _region;
    await runShowingErrors(
      context,
      () => widget.core.editSettings((config) {
        final routing = config['routing'];
        if (routing is! Map<String, Object?>) return;
        routing['enabled'] = region.isNotEmpty;
        if (region.isNotEmpty) routing['region'] = region;
      }),
    );
    widget.settings.update(language: _language, firstRun: false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    final accent =
        look.accent ?? (dark ? Colors.white : const Color(0xFF0A0A0A));
    final still = MediaQuery.of(context).disableAnimations;
    return Scaffold(
      backgroundColor: look.scaffold,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [look.scaffold, look.scaffoldBottom],
          ),
        ),
        child: Stack(
          children: [
            // The aurora: two slow lights drifting behind everything, in
            // the design's own light. Still under reduce-motion.
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _drift,
                  builder: (context, _) {
                    final t = still ? 0.35 : _drift.value;
                    return CustomPaint(
                      painter: _AuroraPainter(
                        accent: accent,
                        dark: dark,
                        t: t,
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      // The hero: the shield breathing inside two rings
                      // of its own light, on a glass disc.
                      Center(
                        child: Reveal(
                          child: _ShieldHero(
                            accent: accent,
                            ink: look.ink,
                            dark: dark,
                            breath: _breath,
                            still: still,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Reveal(
                        index: 1,
                        child: Text(
                          l.welcomeTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: look.ink,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Reveal(
                        index: 2,
                        child: Text(
                          l.welcomeBody,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: look.muted,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Reveal(
                        index: 3,
                        child: _WelcomeField(
                          look: look,
                          child: DropdownButtonFormField<String>(
                            initialValue: _language,
                            dropdownColor: look.surface,
                            decoration: _fieldDecoration(l.language, look),
                            icon: Icon(
                              Icons.expand_more_rounded,
                              color: look.muted,
                            ),
                            onChanged: (v) => _pickLanguage(v!),
                            items: [
                              for (final code in AppSettings.supportedLanguages)
                                DropdownMenuItem(
                                  value: code,
                                  child: Row(
                                    children: [
                                      Text(
                                        languageNames[code]!,
                                        style: languageStyle(code),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Reveal(
                        index: 4,
                        child: _WelcomeField(
                          look: look,
                          child: DropdownButtonFormField<String>(
                            key: ValueKey(_region),
                            initialValue: _region,
                            dropdownColor: look.surface,
                            decoration: _fieldDecoration(
                              l.region,
                              look,
                              helper: l.routingDirectHint,
                            ),
                            icon: Icon(
                              Icons.expand_more_rounded,
                              color: look.muted,
                            ),
                            onChanged: (v) => setState(() {
                              _region = v!;
                              _regionPicked = true;
                            }),
                            items: [
                              for (final r in AppSettings.regions)
                                DropdownMenuItem(
                                  value: r,
                                  child: Text(regionName(l, r)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // The start: the design's own light, pressed into
                      // the page with the app's press feel.
                      Reveal(
                        index: 5,
                        child: Pressable(
                          depth: 0.04,
                          child: FilledButton(
                            // A TV starts on Start: the remote's OK goes
                            // on with the language and the country it
                            // found.
                            autofocus:
                                Platform.isAndroid && AndroidCore.isTv,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              backgroundColor: accent,
                              foregroundColor: AppAccent.onAccent(accent),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: _saving ? null : _start,
                            child: Text(l.start),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, DesignLook look,
      {String? helper}) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: look.muted, fontWeight: FontWeight.w600),
      helperText: helper,
      helperMaxLines: 3,
      helperStyle: TextStyle(color: look.muted.withValues(alpha: 0.8)),
      filled: true,
      fillColor: look.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: border(look.outline),
      focusedBorder: border(
        (look.accent ?? look.ink).withValues(alpha: 0.8),
        1.4,
      ),
      border: border(look.outline),
    );
  }
}

/// The selector's plate: on the neumorphism, the field sits on an
/// extruded card of the design's own surface — the same dual shadows
/// every card of the app wears, so the selectors read as the page's
/// own buttons. The other designs keep the field's own fill.
class _WelcomeField extends StatelessWidget {
  const _WelcomeField({
    required this.look,
    required this.child,
  });

  final DesignLook look;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (look.cardShadow.isEmpty) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: look.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: look.cardShadow,
      ),
      child: child,
    );
  }
}

/// The hero: a glass disc, the shield inside it, two rings of the
/// design's light swelling and fading around it — the app's first
/// handshake, drawn by hand.
class _ShieldHero extends StatelessWidget {
  const _ShieldHero({
    required this.accent,
    required this.ink,
    required this.dark,
    required this.breath,
    required this.still,
  });

  final Color accent;
  final Color ink;
  final bool dark;
  final Animation<double> breath;
  final bool still;

  @override
  Widget build(BuildContext context) {
    final glow = still ? 0.5 : null;
    return SizedBox(
      width: 148,
      height: 148,
      child: AnimatedBuilder(
        animation: breath,
        builder: (context, _) {
          final b = glow ?? breath.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // The outer ring, farthest out and faintest.
              _ring(134, 0.10 + 0.10 * b, 1.5 + 2.5 * b),
              // The middle ring.
              _ring(112, 0.16 + 0.14 * b, 1.2 + 2.0 * b),
              // The glass disc the shield stands on.
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.65),
                  border: Border.all(
                    color: (dark ? Colors.white : ink).withValues(alpha: 0.14),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.28 + 0.14 * b),
                      blurRadius: 26 + 10 * b,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shield_rounded,
                  size: 44,
                  color: accent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _ring(double size, double alpha, double width) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: accent.withValues(alpha: alpha), width: width),
        ),
      );
}

/// The aurora behind the welcome page: two soft radial lights, drifting
/// on their own slow clock. One sits high, one low; each breathes with
/// its own phase, so the page never sits on a flat color.
class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.accent,
    required this.dark,
    required this.t,
  });

  final Color accent;
  final bool dark;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Phase-shifted drift: the lights wander a small ellipse, never
    // leaving the page.
    Offset drift(double phase, double rx, double ry) => Offset(
          size.width * (0.5 + 0.16 * math.cos(2 * math.pi * (t + phase))) * rx +
              size.width * (rx - 1) * 0.5,
          size.height * (0.5 + 0.14 * math.sin(2 * math.pi * (t + phase))) * ry +
              size.height * (ry - 1) * 0.5,
        );
    final a1 = dark ? 0.16 : 0.10;
    final a2 = dark ? 0.10 : 0.07;
    void blob(Offset c, double r, double alpha) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            accent.withValues(alpha: alpha),
            accent.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: r))
        ..isAntiAlias = true;
      canvas.drawCircle(c, r, paint);
    }

    blob(drift(0, 0.78, 0.62), size.width * 0.42, a1);
    blob(drift(0.5, 0.62, 0.86), size.width * 0.36, a2);
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.t != t || old.accent != accent || old.dark != dark;
}
