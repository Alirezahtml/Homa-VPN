import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../l10n/app_localizations.dart';
import 'accent.dart';
import 'widgets.dart';

/// The Custom color panel: a full picker (a hue ring, a shade box, HEX and
/// RGB), the curated accents beside it, a live preview, kept swatches, and
/// the way back to the monochrome design. The color becomes the app's
/// accent - the connected state, the buttons, the sliders' fill - and
/// holds across starts (accent.dart reads it from the settings).
class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  late HSVColor _hsv;
  final _hex = TextEditingController();
  final _red = TextEditingController();
  final _green = TextEditingController();
  final _blue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(Color(widget.settings.customAccent));
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

  void _pick(HSVColor hsv) {
    setState(() {
      _hsv = hsv;
      _syncFields();
    });
    _save();
  }

  /// Types a color in: a HEX code or one of the RGB channels. Empty, or a
  /// mistake, is simply ignored - the fields follow the picker, not the
  /// other way around while typing.
  void _typed(String text, {int? r, int? g, int? b}) {
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
    if (color != null) _pick(HSVColor.fromColor(color));
  }

  void _syncFields() {
    final c = _hsv.toColor();
    _hex.text = (c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    _red.text = '${(c.r * 255.0).round()}';
    _green.text = '${(c.g * 255.0).round()}';
    _blue.text = '${(c.b * 255.0).round()}';
  }

  void _save() {
    widget.settings.update(
      accentKey: 'custom',
      customAccent: _hsv.toColor().toARGB32() & 0xFFFFFF | 0xFF000000,
    );
  }

  void _reset() {
    setState(() {
      widget.settings.update(accentKey: '');
      _hsv = HSVColor.fromColor(const Color(0xFF60A5FA));
      _syncFields();
    });
  }

  void _keepSwatch() {
    final color = _hsv.toColor().toARGB32() & 0xFFFFFF | 0xFF000000;
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
    final dark = theme.brightness == Brightness.dark;
    final accent = AppAccent.resolve(widget.settings);
    return ListView(
      padding: pagePadding(context),
      children: [
        PageTitle(l.customColorTitle),
        const SizedBox(height: 12),
        // The curated accents first: a tap wears one; the wheel beneath
        // makes any other color the user's own.
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final (key, color) in AppAccent.presets)
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  widget.settings.update(accentKey: key);
                  setState(() => _hsv = HSVColor.fromColor(color));
                  _syncFields();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.settings.accentKey == key
                          ? (scheme.onSurface)
                          : scheme.outlineVariant,
                      width: widget.settings.accentKey == key ? 3 : 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
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
        const SizedBox(height: 18),
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
                  onTap: () {
                    setState(() => _hsv = HSVColor.fromColor(Color(color)));
                    _syncFields();
                    _save();
                  },
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
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: Text(l.customColorReset),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(l.customColorPreview, style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        _Preview(accent: accent, dark: dark),
        const SizedBox(height: 24),
        Text(l.customColorNote, style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        )),
      ],
    );
  }
}

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
    canvas.drawRect(
      Offset.zero & size,
      Paint()
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

/// A small, real slice of the app's monochrome look, with the color the
/// user is choosing as its accent: the connected state, a filled button,
/// a toggle - before anything is saved.
class _Preview extends StatelessWidget {
  const _Preview({required this.accent, required this.dark});

  final Color? accent;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final surface = dark ? Colors.black : Colors.white;
    final ink = dark ? Colors.white : Colors.black;
    final a = accentForTheme(
      accent ?? (dark ? Colors.white : Colors.black),
      dark,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ink.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: a),
              const SizedBox(width: 8),
              Text(
                l.appTitle,
                style: TextStyle(color: ink, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Icon(Icons.settings_outlined, color: ink.withValues(alpha: 0.55)),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: a,
              foregroundColor: AppAccent.onAccent(a),
            ),
            onPressed: () {},
            icon: const Icon(Icons.bolt_rounded, size: 18),
            label: Text(l.customColorPreviewButton),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Chip(
                  avatar: Icon(Icons.check_circle_rounded, size: 18, color: a),
                  label: Text(
                    l.customColorPreviewChip,
                    style: TextStyle(color: ink),
                  ),
                  backgroundColor: ink.withValues(alpha: 0.06),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: true,
                  onChanged: (_) {},
                  activeThumbColor: a,
                  title: Text(
                    l.customColorPreviewSwitch,
                    style: TextStyle(fontSize: 13, color: ink),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
