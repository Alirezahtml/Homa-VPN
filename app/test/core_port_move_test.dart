import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arman_vpn/core/android_core.dart';
import 'package:arman_vpn/core/core_api.dart';
import 'package:arman_vpn/core/ports.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('app/android');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// The core's own words when another program holds the dashboard's
  /// address (mobile.LastError, through the app/android channel).
  const taken = 'the core stopped a moment ago: starting the dashboard: '
      'the dashboard address 127.0.0.1:10820 is already in use by another '
      'program';

  Future<String> listenIn(Directory dir) => CoreLocator.dashboardListen(dir.path);

  test(
    'a taken dashboard address moves to a free port instead of dying',
    () async {
      final dir = await Directory.systemTemp.createTemp('homa-port-move');
      addTearDown(() => dir.delete(recursive: true));
      messenger.setMockMethodCallHandler(channel, (call) async {
        return switch (call.method) {
          'isRunning' => false,
          'startCore' => null,
          'lastError' => taken,
          _ => null,
        };
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      final core = AndroidCore(dir.path);
      // The first connect moves the address and asks to be tried again.
      await expectLater(
        core.connect(),
        throwsA(
          isA<CoreUnavailable>().having(
            (e) => e.problem,
            'problem',
            CoreProblem.starting,
          ),
        ),
      );
      final moved = await listenIn(dir);
      final port = portOf(moved)!;
      expect(port, isNot(10820));
      expect(port, inInclusiveRange(10821, 11021));

      // A retry right after does not walk the port range: the move waits
      // for the core's own restart pause before it decides it did not help.
      await expectLater(core.connect(), throwsA(isA<CoreUnavailable>()));
      expect(await listenIn(dir), moved);
    },
  );

  test('a failure that is not the address keeps the address and says why', () async {
    final dir = await Directory.systemTemp.createTemp('homa-port-keep');
    addTearDown(() => dir.delete(recursive: true));
    messenger.setMockMethodCallHandler(channel, (call) async {
      return switch (call.method) {
        'isRunning' => false,
        'startCore' => null,
        'lastError' => 'the core stopped a moment ago: the signing key is broken',
        _ => null,
      };
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    await expectLater(
      AndroidCore(dir.path).connect(),
      throwsA(
        isA<CoreUnavailable>()
            .having((e) => e.problem, 'problem', CoreProblem.exited)
            .having((e) => e.detail, 'detail', contains('signing key')),
      ),
    );
    // No config.json was written: the address stays the core's own.
    expect(await listenIn(dir), CoreLocator.defaultListen);
  });
}
