import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../app_info.dart' show appVersion;
import 'format.dart';

/// The gazette's own parts: the printed page's furniture — the masthead,
/// the ruled paper card, the ink stamp, the telegraph's typewriter word,
/// the live-wire ticker and the stats' columns. Everything here is paper
/// and ink: hairline rules instead of shadows, the serif's voice instead
/// of the glass, and motion that reads like a press, not a screen.
///
/// The colors arrive as plain arguments (the ink, the muted ink, the rule
/// gray), because the palette they belong to is the home's own, resolved
/// per design — the parts stay loose and the page stays honest.

/// The edition's number: the version's own last number, the build the
/// page carries («No. 56» for 1.0.56). A development build prints 1.
int gazetteEditionNo() {
  final parts = appVersion.split('.');
  final n = parts.isEmpty ? 0 : int.tryParse(parts.last) ?? 0;
  return n <= 0 ? 1 : n;
}

/// The session's elapsed time, the paper's own figures: hh:mm:ss once
/// the hour stands, mm:ss before it.
String gazetteElapsed(DateTime startedAt, {DateTime? now}) {
  final s = (now ?? DateTime.now())
      .difference(startedAt)
      .inSeconds
      .clamp(0, 86399);
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  return h > 0
      ? '$h:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}'
      : '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
}

/// The day's line, in the page's own language: «۲۰ نوامبر ۲۰۲۶» — short
/// enough to ride the masthead's middle beside the brand.
String gazetteDateLine(AppLocalizations l, DateTime now) =>
    DateFormat.yMMMd(l.localeName).format(now);

/// The masthead: the newspaper's own opening — the thick-and-thin rule,
/// the brand riding the middle with the day's line on one side and the
/// edition's number on the other, and the bulletin's tag under them in
/// small, widely spaced letters. The page's first breath.
class GazetteMasthead extends StatelessWidget {
  const GazetteMasthead({
    super.key,
    required this.brand,
    required this.dateLine,
    required this.edition,
    required this.bulletin,
    required this.ink,
    required this.muted,
    required this.rule,
  });

  final Widget brand;
  final String dateLine;
  final String edition;
  final String bulletin;
  final Color ink;
  final Color muted;
  final Color rule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 2.4, color: ink),
        const SizedBox(height: 2),
        Container(height: 0.8, color: rule),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                dateLine,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: muted,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: brand),
            ),
            Expanded(
              child: Text(
                edition,
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // The bulletin's tag, in small, widely spaced letters — but only
        // when the language's own script takes the tracking: the Latin
        // loves it, the Arabic's joined letters do not (the space between
        // joined letters breaks the word in half).
        Text(
          bulletin.toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: _arabicScript(bulletin) ? 0 : 3,
            color: muted,
          ),
        ),
        const SizedBox(height: 10),
        Container(height: 1.4, color: ink),
      ],
    );
  }
}

/// The ruled paper card: the gazette's own box — the near-square corners,
/// the outer hairline and the inner fine rule a hand-set page carries.
/// No shadow, no blur: the paper stands on the rules alone.
class PaperCard extends StatelessWidget {
  const PaperCard({
    super.key,
    required this.child,
    required this.ink,
    required this.rule,
    required this.paper,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final Color ink;
  final Color rule;
  final Color paper;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RuleBorderPainter(ink: ink, rule: rule),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// The double rule the paper card draws: the outer box at the ink's own
/// weight, the inner box a breath in, at the hairline's weight.
class _RuleBorderPainter extends CustomPainter {
  const _RuleBorderPainter({required this.ink, required this.rule});

  final Color ink;
  final Color rule;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Offset.zero & size;
    final inner = outer.deflate(3);
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = ink;
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = rule;
    canvas.drawRect(outer.deflate(0.7), outerPaint);
    canvas.drawRect(inner, innerPaint);
  }

  @override
  bool shouldRepaint(_RuleBorderPainter old) => old.ink != ink || old.rule != rule;
}

/// The horizontal rule a page sections with: one weight to choose.
class GazetteRule extends StatelessWidget {
  const GazetteRule({
    super.key,
    required this.color,
    this.weight = 1,
    this.spacing = 10,
  });

  final Color color;
  final double weight;
  final double spacing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: spacing / 2),
    child: Container(height: weight, color: color),
  );
}

/// Whether [text] carries Arabic-script letters (the Persian, the
/// Arabic, the Urdu) — the script that tracking would tear apart.
bool _arabicScript(String text) => text.contains(
  RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]'),
);

/// The rubber stamp: the rotated bordered badge the page presses onto
/// the state — the measured delay inside it. When [pressed] turns true
/// (the tunnel carrying, the measurement fresh), the stamp lands the way
/// a stamp lands: one quick press, a touch of overshoot, and a settle.
class GazetteStamp extends StatelessWidget {
  const GazetteStamp({
    super.key,
    required this.label,
    required this.value,
    required this.ink,
    required this.on,
  });

  final String label;
  final String value;
  final Color ink;
  final bool on;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: on ? 1.0 : 0.55),
      duration: const Duration(milliseconds: 380),
      curve: on ? Curves.easeOutBack : Curves.easeOut,
      builder: (context, t, child) => Transform.rotate(
        angle: -0.10,
        child: Transform.scale(scale: 0.7 + 0.3 * t, child: child),
      ),
      child: Opacity(
        opacity: 0.9,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ink, width: 1.6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  // The tracking the Latin stamp takes; the Arabic-script
                  // label keeps its joins instead.
                  letterSpacing: _arabicScript(label) ? 0 : 1.5,
                  color: ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: ink,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The telegraph's word: the state's line types itself in, letter by
/// letter, the way a wire service sets a headline. A new word re-types;
/// the words the wire carries never snap-cut.
class TelegraphText extends StatefulWidget {
  const TelegraphText(
    this.text, {
    super.key,
    required this.style,
    this.perCharacter = const Duration(milliseconds: 28),
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Duration perCharacter;
  final TextAlign? textAlign;

  @override
  State<TelegraphText> createState() => _TelegraphTextState();
}

class _TelegraphTextState extends State<TelegraphText> {
  Timer? _ticker;
  int _shown = 0;
  String _target = '';

  @override
  void initState() {
    super.initState();
    _start(widget.text);
  }

  @override
  void didUpdateWidget(TelegraphText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) _start(widget.text);
  }

  void _start(String text) {
    _ticker?.cancel();
    _target = text;
    _shown = 0;
    if (text.isEmpty) return;
    // The wire ticks one letter at a time; a short word types in under a
    // breath, a long one stays readable.
    final step = widget.perCharacter;
    _ticker = Timer.periodic(step, (_) {
      if (!mounted) {
        _ticker?.cancel();
        return;
      }
      setState(() {
        _shown += 1;
        if (_shown >= _target.length) {
          _shown = _target.length;
          _ticker?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shown = _target.isEmpty
        ? ''
        : _target.characters.take(_shown).toString();
    return Text(
      shown,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// The live wire: the session's own news on a moving tape — the rates,
/// the elapsed time and the measured delay, one line that walks while
/// the tunnel carries and rests when it does not. The battery saver's
/// word stops the walk.
class GazetteTicker extends StatefulWidget {
  const GazetteTicker({
    super.key,
    required this.items,
    required this.ink,
    required this.muted,
    required this.rule,
    this.moving = true,
  });

  final List<String> items;
  final Color ink;
  final Color muted;
  final Color rule;
  final bool moving;

  @override
  State<GazetteTicker> createState() => _GazetteTickerState();
}

class _GazetteTickerState extends State<GazetteTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ride = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );

  @override
  void initState() {
    super.initState();
    _ride.repeat();
  }

  @override
  void didUpdateWidget(GazetteTicker old) {
    super.didUpdateWidget(old);
    if (widget.moving != old.moving) {
      if (widget.moving) {
        _ride.repeat();
      } else {
        _ride.stop();
      }
    }
  }

  @override
  void dispose() {
    _ride.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.items.join('   ·   ');
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: widget.rule),
          bottom: BorderSide(color: widget.rule),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      height: 32,
      width: double.infinity,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _ride,
          builder: (context, child) {
            return Align(
              alignment: Alignment(-1 + _ride.value * 2, 0),
              child: child,
            );
          },
          child: Text(
            line,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: widget.moving ? widget.ink : widget.muted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

/// The stats' columns: the numbers standing in their ruled columns, the
/// way a paper's data box sets them — hairline dividers between, the
/// value in the display's voice and the label in the small ink.
class GazetteColumns extends StatelessWidget {
  const GazetteColumns({
    super.key,
    required this.stats,
    required this.ink,
    required this.muted,
    required this.rule,
    required this.display,
    required this.displayFallback,
  });

  /// The (label, value) pairs, in the order the page sets them.
  final List<(String, String)> stats;
  final Color ink;
  final Color muted;
  final Color rule;
  final String display;
  final List<String> displayFallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          if (i > 0) Container(width: 1, height: 34, color: rule),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stats[i].$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    fontFamily: display,
                    fontFamilyFallback: displayFallback,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stats[i].$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The gazette's home data box: the front page's card — the headline
/// (the state's word, typed by the wire), the stamp beside it (the
/// measured delay), the slider's commit, and the columns of the
/// session's numbers under a rule. The whole front page in one box.
class GazetteFrontPage extends StatelessWidget {
  const GazetteFrontPage({
    super.key,
    required this.headline,
    required this.headlineStyle,
    required this.stampLabel,
    required this.stampValue,
    required this.stampOn,
    required this.stats,
    required this.ink,
    required this.muted,
    required this.rule,
    required this.paper,
    required this.display,
    required this.displayFallback,
    required this.slider,
    this.accent,
  });

  final String headline;
  final TextStyle? headlineStyle;
  final String stampLabel;
  final String stampValue;
  final bool stampOn;
  final List<(String, String)> stats;
  final Color ink;
  final Color muted;
  final Color rule;
  final Color paper;
  final String display;
  final List<String> displayFallback;
  final Widget slider;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: PaperCard(
        ink: ink,
        rule: rule,
        paper: paper,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TelegraphText(
                    headline,
                    style: headlineStyle,
                  ),
                ),
                const SizedBox(width: 10),
                GazetteStamp(
                  label: stampLabel,
                  value: stampValue,
                  ink: accent ?? ink,
                  on: stampOn,
                ),
              ],
            ),
            GazetteRule(color: rule, weight: 0.8, spacing: 12),
            slider,
            GazetteRule(color: rule, weight: 0.8, spacing: 12),
            GazetteColumns(
              stats: stats,
              ink: ink,
              muted: muted,
              rule: rule,
              display: display,
              displayFallback: displayFallback,
            ),
          ],
        ),
      ),
    );
  }
}

/// The ticker's own items for the home: the live rates, the session's
/// time and the place — the words the wire carries while the tunnel
/// works. Built by the page, which owns the data.
List<String> gazetteTickerItems({
  required AppLocalizations l,
  required int? downRate,
  required int? upRate,
  required String? delay,
  required String? place,
}) => [
  '↓ ${formatRate(downRate ?? 0)}',
  '↑ ${formatRate(upRate ?? 0)}',
  ?delay,
  ?place,
];
