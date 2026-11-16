import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arman_vpn/ui/widgets.dart';

/// The faces the app speaks: every family the theme's words and the
/// display's voice can ask for must actually ride inside the built app —
/// a name in pubspec whose files went missing would leave the words in
/// the phone's own face, the very thing this app never does again.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the built app carries every face its theme speaks', () async {
    final manifest = await rootBundle.loadString('FontManifest.json');
    final families =
        (jsonDecode(manifest) as List<Object?>)
            .cast<Map<Object?, Object?>>()
            .map((entry) => entry['family'] as String)
            .toSet();

    const expected = [
      // The body: the languages' own faces.
      'Inter',
      'Vazirmatn',
      'NotoSansSC',
      'NotoSansTC',
      'NotoSansBengali',
      // The display: the titles', the state word's and the stat values'
      // own voice.
      'SpaceGrotesk',
    ];
    for (final face in expected) {
      expect(families, contains(face), reason: '$face must be bundled');
    }
  });

  test('the display face answers every language the app speaks', () {
    for (final code in languageNames.keys) {
      final display = displayFont(code);
      expect(
        displayFallbacks(display),
        isNotEmpty,
        reason: '$code falls back through something',
      );
      // No language's display hides in the phone's face: the name must
      // be one of the bundled families, never null.
      expect(
        const [
          'SpaceGrotesk',
          'Vazirmatn',
          'NotoSansSC',
          'NotoSansTC',
          'NotoSansBengali',
        ],
        contains(display),
        reason: '$code reads in a bundled display face',
      );
    }
  });
}
