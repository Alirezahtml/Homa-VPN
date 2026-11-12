import 'package:flutter_test/flutter_test.dart';

/// The pumpAndSettle of the Homa design: the pages now carry endless
/// motions (the aurora, the pulses, the shimmers), which a plain
/// pumpAndSettle would wait on forever. Pumps until the frames go quiet,
/// or [max] frames have passed — enough for every entrance, snack bar and
/// dialog of the app to land.
Future<void> settle(WidgetTester tester, {int max = 40}) async {
  for (var i = 0; i < max; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (!tester.binding.hasScheduledFrame) break;
  }
  await tester.pump(const Duration(milliseconds: 100));
}
