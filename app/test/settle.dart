import 'package:flutter/services.dart';
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

/// The sounds' warmup talks to the audio plugin, which tests have none
/// of: the global channel's own event stream throws a
/// MissingPluginException outside any try, and the test's zone fails.
/// The two channels answer quietly instead, so the pools' build settles
/// and the goldens render without the platform's noise.
void quietAudio(WidgetTester tester) {
  const global = MethodChannel('xyz.luan/audioplayers.global');
  const events = MethodChannel('xyz.luan/audioplayers.global/events');
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    global,
    (call) async => call.method == 'create' ? 1 : null,
  );
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    events,
    (call) async => null,
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger
      ..setMockMethodCallHandler(global, null)
      ..setMockMethodCallHandler(events, null),
  );
}
