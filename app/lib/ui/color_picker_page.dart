import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../l10n/app_localizations.dart';
import 'app.dart';
import 'widgets.dart';

/// The Custom color panel: a full picker (a hue ring's wheel, a lightness
/// box, HEX and RGB), the roles the color applies to, how strongly it
/// drives the scheme, a live preview, kept swatches, and the way back to
/// the app's own colors. Everything the user picks holds across starts.
class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  HSVColor _hsv = HSVColor.fromColor(const Color(0xFF5B5BD6));
  int? _seed;
  int? _accent;
  double _intensity = 1.0;
  final _hex = TextEditingController();
  final _red = TextEditingController();
  final _green = TextEditingController();
  final _blue = TextEditingController();

  /// The role the picker edits: the whole scheme's seed, or the highlights.
  _Role _role = _Role.seed;

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _seed = s.customSeed;
    _accent = s.customAccent;
    _intensity = s.colorIntensity;
    _hsv = HSVColor.fromColor(Color(_roleColor()));
    _syncFields();
  }

  @override
  void dispose() {
    _hex.dispose();
    _red.dispose();
    _green.dispose();
    _blue.dispose();
    super.dispose();
  }

  int _roleColor() => switch (_role) {
    _Role.seed => _seed ?? 0xFF5B5BD6,
    _Role.accent => _accent ?? 0xFF5B5BD6,
  };

  void _pick(HSVColor hsv) {
    setState(() {
      _hsv = hsv;
      final color = hsv.toColor();
      final value = (color.toARGB32() & 0xFFFFFF) | 0xFF000000;
      if (_role == _Role.seed) {
        _seed = value;
      } else {
        _accent = value;
      }
      _syncFields();
    });
  }

  /// Types a color in: a HEX code or one of the RGB channels. Empty, or a
  /// mistake, is simply ignored — the fields follow the picker, not the
  /// other way around while typing.
  Color? _typed(String text, {int? r, int? g, int? b}) {
    Color? color;
    if (r != null || g != null || b != null) {
      final base = _hsv.toColor();
      color = Color.fromARGB(
        255,
        r ?? (base.r * 255.0).round(),
        g ?? (base.g * 255.0).round(),
        b ?? (base.b * 255.0).round(),
      );
    } else {
      final hex = text.trim().replaceFirst('#', '');
      if (RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(hex)) {
        color = Color(int.parse('FF$hex', radix: 16));
      }
    }
    if (color != null) {
      _pick(HSVColor.fromColor(color));
      return color;
    }
    return null;
  }

  void _syncFields() {
    final c = _hsv.toColor();
    _hex.text = (c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    _red.text = '${(c.r * 255.0).round()}';
    _green.text = '${(c.g * 255.0).round()}';
    _blue.text = '${(c.b * 255.0).round()}';
  }

  void _save() {
    final s = widget.settings;
    s.update(
      customSeed: _seed,
      customAccent: _accent,
      colorIntensity: _intensity,
    );
  }

  void _reset() {
    setState(() {
      _seed = null;
      _accent = null;
      _intensity = 1.0;
      _role = _Role.seed;
      _hsv = HSVColor.fromColor(const Color(0xFF5B5BD6));
      _syncFields();
    });
    widget.settings.update(customSeed: null, customAccent: null, colorIntensity: 1.0);
  }

  void _keepSwatch() {
    final color = _roleColor();
    final kept = [
      color,
      ...widget.settings.savedColors.where((c) => c != color),
    ].take(12).toList();
    widget.settings.update(savedColors: kept);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final preview = ColorScheme.fromSeed(
      seedColor: seedFor(widget.settings),
      brightness: theme.brightness,
    );
    return ListView(
      padding: pagePadding(context),
      children: [
        PageTitle(l.customColorTitle),
        const SizedBox(height: 12),
        // The roles: the whole scheme, or the highlights on top of it.
        SegmentedButton<_Role>(
          segments: [
            ButtonSegment(value: _Role.seed, label: Text(l.customColorSeed)),
            ButtonSegment(value: _Role.accent, label: Text(l.customColorAccent)),
          ],
          selected: {_role},
          onSelectionChanged: (selection) => setState(() {
            _role = selection.first;
            _hsv = HSVColor.fromColor(Color(_roleColor()));
            _syncFields();
          }),
        ),
        const SizedBox(height: 16),
        _Wheel(hsv: _hsv, onPick: _pick),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _HexField(controller: _hex, onTyped: _typed)),
            const SizedBox(width: 8),
            for (final (i, field) in [_red, _green, _blue].indexed) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: _ChannelField(
                  controller: field,
                  label: 'RGB'[i],
                  onTyped: _typed,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),
        // How far the user's color drives the app: the app's own at the
        // left end, theirs alone at the right.
        Row(
          children: [
            SizedBox(
              width: 96,
              child: Text(l.customColorIntensity, style: theme.textTheme.bodyMedium),
            ),
            Expanded(
              child: Slider(
                value: _intensity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: '${(_intensity * 100).round()}%',
                onChanged: (value) => setState(() {
                  _intensity = value;
                }),
                onChangeEnd: (_) => _save(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Kept colors: a tap wears one; a long press forgets it.
        if (widget.settings.savedColors.isNotEmpty) ...[
          Text(l.customColorSwatches, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final color in widget.settings.savedColors)
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onLongPress: () {
                    widget.settings.update(
                      savedColors: [
                        ...widget.settings.savedColors.where((c) => c != color),
                      ],
                    );
                    setState(() {});
                  },
                  onTap: () => _pick(HSVColor.fromColor(Color(color))),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            TextButton.icon(
              onPressed: _keepSwatch,
              icon: const Icon(Icons.bookmark_add_outlined, size: 18),
              label: Text(l.customColorKeep),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                _reset();
              },
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: Text(l.customColorReset),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(l.customColorPreview, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        _Preview(scheme: preview, accent: widget.settings.customAccent),
        const SizedBox(height: 24),
        Text(l.customColorNote, style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        )),
      ],
    );
  }
}

enum _Role { seed, accent }

/// The color wheel: a ring of hues around a square of the hue's shades,
/// drawn by hand (no package). A drag picks; the dot follows.
class _Wheel extends StatelessWidget {
  const _Wheel({required this.hsv, required this.onPick});

  final HSVColor hsv;
  final void Function(HSVColor) onPick;

  static const _size = 260.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: _size,
            height: _size,
            child: GestureDetector(
              onPanDown: (details) => _hue(details.localPosition),
              onPanUpdate: (details) => _hue(details.localPosition),
              onTapDown: (details) => _hue(details.localPosition),
              child: CustomPaint(painter: _HueRingPainter(hsv: hsv)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: _size,
            height: 130,
            child: GestureDetector(
              onPanDown: (details) => _shade(details.localPosition),
              onPanUpdate: (details) => _shade(details.localPosition),
              onTapDown: (details) => _shade(details.localPosition),
              child: CustomPaint(painter: _ShadeBoxPainter(hsv: hsv)),
            ),
          ),
        ],
      ),
    );
  }

  void _hue(Offset at) {
    final center = Offset(_size / 2, _size / 2);
    var angle = math.atan2(at.dy - center.dy, at.dx - center.dx);
    // The ring starts at red and runs counter-clockwise, as HSV's hue does.
    final degrees = (math.pi / 2 - angle) / math.pi * 180;
    onPick(hsv.withHue((degrees + 360) % 360));
  }

  void _shade(Offset at) {
    const w = _size, h = 130.0;
    final s = (at.dx / w).clamp(0.0, 1.0);
    final v = 1.0 - (at.dy / h).clamp(0.0, 1.0);
    onPick(hsv.withSaturation(s).withValue(v));
  }
}

class _HueRingPainter extends CustomPainter {
  const _HueRingPainter({required this.hsv});

  final HSVColor hsv;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    const thickness = 26.0;
    final rect = Rect.fromCircle(center: center, radius: radius - thickness / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    // Twelve arcs, each a hue step: a ring every wheel has.
    for (var i = 0; i < 360; i++) {
      paint.color = HSVColor.fromAHSV(1, i.toDouble(), 1, 1).toColor();
      canvas.drawArc(rect, i * math.pi / 180 - math.pi / 2, math.pi / 180 + 0.02, false, paint);
    }
    // The chosen hue's marker on the ring.
    final hueRad = math.pi / 2 - hsv.hue * math.pi / 180;
    final marker = center + Offset(math.cos(hueRad), -math.sin(hueRad)) * (radius - thickness / 2);
    canvas.drawCircle(marker, 11, Paint()..color = Colors.white);
    canvas.drawCircle(
      marker,
      11,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.black54,
    );
  }

  @override
  bool shouldRepaint(_HueRingPainter old) => old.hsv.hue != hsv.hue;
}

class _ShadeBoxPainter extends CustomPainter {
  const _ShadeBoxPainter({required this.hsv});

  final HSVColor hsv;

  @override
  void paint(Canvas canvas, Size size) {
    final horizontal = Paint();
    canvas.drawRect(
      Offset.zero & size,
      horizontal
        ..shader = LinearGradient(
          colors: [
            Colors.white,
            HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black],
        ).createShader(Offset.zero & size),
    );
    final at = Offset(hsv.saturation * size.width, (1 - hsv.value) * size.height);
    canvas.drawCircle(at, 10, Paint()..color = Colors.white);
    canvas.drawCircle(
      at,
      10,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.black54,
    );
  }

  @override
  bool shouldRepaint(_ShadeBoxPainter old) => old.hsv != hsv;
}

class _HexField extends StatelessWidget {
  const _HexField({required this.controller, required this.onTyped});

  final TextEditingController controller;
  final void Function(String) onTyped;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    textInputAction: TextInputAction.done,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[#0-9a-fA-F]'))],
    decoration: InputDecoration(
      isDense: true,
      prefixText: '#',
      prefixIcon: const Icon(Icons.tag_rounded, size: 18),
      border: const OutlineInputBorder(),
      labelText: AppLocalizations.of(context).customColorHex,
    ),
    onSubmitted: onTyped,
    onChanged: (text) {
      if (RegExp(r'^#?[0-9a-fA-F]{6}$').hasMatch(text.trim())) onTyped(text);
    },
  );
}

class _ChannelField extends StatelessWidget {
  const _ChannelField({
    required this.controller,
    required this.label,
    required this.onTyped,
  });

  final TextEditingController controller;
  final String label;
  final void Function(String, {int? r, int? g, int? b}) onTyped;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      isDense: true,
      border: const OutlineInputBorder(),
      labelText: label,
    ),
    onSubmitted: (text) {
      final value = int.tryParse(text) ?? 0;
      onTyped(
        '',
        r: label == 'R' ? value : null,
        g: label == 'G' ? value : null,
        b: label == 'B' ? value : null,
      );
    },
    onChanged: (text) {
      final value = int.tryParse(text);
      if (value == null) return;
      onTyped(
        '',
        r: label == 'R' ? value : null,
        g: label == 'G' ? value : null,
        b: label == 'B' ? value : null,
      );
    },
  );
}

/// A small, real slice of the app: cards, buttons, chips and icons in the
/// colors the user is choosing, before they save anything.
class _Preview extends StatelessWidget {
  const _Preview({required this.scheme, this.accent});

  final ColorScheme scheme;
  final int? accent;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final localAccent = accent == null ? scheme.secondary : Color(accent!);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: scheme.primary),
              const SizedBox(width: 8),
              Text(l.appTitle, style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.settings_outlined, color: localAccent),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: scheme.primary),
            onPressed: () {},
            icon: const Icon(Icons.bolt_rounded, size: 18),
            label: Text(l.customColorPreviewButton),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Chip(
                  avatar: Icon(Icons.check_circle_rounded, size: 18, color: scheme.primary),
                  label: Text(l.customColorPreviewChip),
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: true,
                  onChanged: (_) {},
                  activeThumbColor: localAccent,
                  title: Text(l.customColorPreviewSwitch, style: const TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
