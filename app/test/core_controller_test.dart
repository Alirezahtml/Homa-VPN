import 'package:flutter_test/flutter_test.dart';
import 'package:arman_vpn/app_settings.dart';
import 'package:arman_vpn/core/core_api.dart';
import 'package:arman_vpn/core/core_controller.dart';
import 'package:arman_vpn/core/models.dart';

/// A core whose next [failNext] reads fail as if the connection dropped.
class _FlakyApi implements CoreApi {
  int failNext = 0;

  @override
  Future<CoreStatus> status() async {
    if (failNext > 0) {
      failNext--;
      throw const CoreUnavailable(CoreProblem.notAnswering, 'connection reset');
    }
    return CoreStatus.fromJson({
      'state': {'phase': 'off', 'message': 'Proxy off'},
    });
  }

  @override
  Future<AccountList> accounts() async => AccountList.fromJson({});

  @override
  void close() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A running core whose auto-connect tests the connection; it counts the
/// app's own tests.
class _AutoConnectingApi implements CoreApi {
  int tests = 0;
  bool autoConnecting = true;

  @override
  Future<CoreStatus> status() async => CoreStatus.fromJson({
    'state': {'phase': 'running', 'message': 'Proxy running'},
    'system_proxy': 'set',
    'system_proxy_supported': true,
    'auto_connecting': autoConnecting,
  });

  @override
  Future<ConnectionTest> test() async {
    tests++;
    return ConnectionTest.fromJson({'ok': false});
  }

  @override
  Future<AccountList> accounts() async => AccountList.fromJson({});

  @override
  void close() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A running core whose last test passed [age] ago; it counts the measurements
/// of the delay.
class _DelayApi implements CoreApi {
  _DelayApi(this.responseMs, this.age);

  final int responseMs;
  final Duration age;
  bool passed = true;
  int delays = 0;

  @override
  Future<CoreStatus> status() async => CoreStatus.fromJson({
    'state': {'phase': 'running', 'message': 'Proxy running'},
    'proxy': <String, Object?>{},
    'last_test': {
      'ok': passed,
      'at': DateTime.now().subtract(age).toUtc().toIso8601String(),
      'response_ms': responseMs,
    },
  });

  @override
  Future<void> delay() async => delays++;

  @override
  Future<void> retry() async {}

  @override
  Future<AccountList> accounts() async => AccountList.fromJson({});

  @override
  void close() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// A phone's core with live traffic counters, for the caretaker: the
/// power, the traffic totals and the rates are all under the test's hand.
class _CaretakerApi implements CoreApi {
  bool on = true;
  int up = 0;
  int down = 0;
  int upRate = 0;
  int downRate = 0;
  final List<bool> powers = [];

  /// The session's start, fixed: the caretaker keys the traffic baseline
  /// to it, as the real core's own start time behaves.
  final String startedAt = DateTime.utc(2026, 1, 1).toIso8601String();

  @override
  Future<CoreStatus> status() async => CoreStatus.fromJson({
    'state': on
        ? {'phase': 'running', 'message': ''}
        : {'phase': 'off', 'message': 'Proxy off'},
    'system_proxy': 'clear',
    'system_proxy_supported': false,
    'proxy': {
      'listen': '127.0.0.1:10810',
      'country_code': 'NL',
      'country_name': 'Netherlands',
      'city_name': 'Amsterdam',
      'transport': 'HTTP/3',
      if (on) 'started_at': startedAt,
    },
    'traffic': {
      'up': up,
      'down': down,
      'up_rate': upRate,
      'down_rate': downRate,
    },
  });

  @override
  Future<void> setPower(bool value) async {
    powers.add(value);
    on = value;
  }

  @override
  Future<AccountList> accounts() async => AccountList.fromJson({});

  @override
  void close() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('the delay is measured again', () {
    Future<int> measured(
      _DelayApi api, {
      bool onScreen = true,
      bool cameToFront = false,
    }) async {
      final core = CoreController(
        () async => api,
        pollInterval: const Duration(hours: 1),
      )..onScreen = onScreen;
      await core.refresh();
      if (cameToFront) {
        await core.retryNow();
        await core.refresh();
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
      core.dispose();
      return api.delays;
    }

    const old = Duration(minutes: 2);

    test('while a high one is on the screen', () async {
      expect(await measured(_DelayApi(1500, const Duration(seconds: 15))), 1);
    });

    test('not at once', () async {
      expect(await measured(_DelayApi(1500, const Duration(seconds: 1))), 0);
    });

    test('not while the app is off the screen', () async {
      final api = _DelayApi(1500, old);
      expect(await measured(api, onScreen: false), 0);
    });

    test('a good one only when the app comes back to the front', () async {
      expect(await measured(_DelayApi(150, old)), 0);
      expect(await measured(_DelayApi(150, old), cameToFront: true), 1);
      final fresh = _DelayApi(150, const Duration(seconds: 15));
      expect(await measured(fresh, cameToFront: true), 0);
    });

    test('not after a failed test', () async {
      final api = _DelayApi(1500, old)..passed = false;
      expect(await measured(api), 0);
    });
  });

  // The core's auto-connect tests by itself; the app adds none meanwhile.
  test('no tests of its own while the core auto-connects', () async {
    final api = _AutoConnectingApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    await core.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(core.status?.autoConnecting, isTrue);
    expect(api.tests, 0);

    api.autoConnecting = false;
    await core.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(api.tests, 1, reason: 'unconfirmed once auto-connect is over');
    core.dispose();
  });

  // Android closes the app's connections when the phone's network goes
  // away; one failed read must not show the core as lost.
  test('one failed read is retried before the core counts as lost', () async {
    final api = _FlakyApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
    );
    await core.refresh();
    expect(core.unavailable, isNull);

    api.failNext = 1;
    await core.refresh();
    expect(core.unavailable, isNull, reason: 'a single failure is retried');
    await core.refresh();
    expect(core.unavailable, isNull);

    api.failNext = 2;
    await core.refresh();
    await core.refresh();
    expect(core.unavailable?.problem, CoreProblem.notAnswering);
    await core.refresh();
    expect(core.unavailable, isNull, reason: 'it answers again');
    core.dispose();
  });

  // The caretaker, with its switch on: a connection that drops without
  // the user asking goes back up by itself.
  test('the caretaker reconnects an unexpected drop on the phone', () async {
    final api = _CaretakerApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
      turnOn: (on) async {
        api.powers.add(on);
        api.on = on;
      },
      appSettings: AppSettings()..autoReconnect = true,
    );
    await core.refresh();
    expect(core.status?.proxyOn, isTrue);

    // The drop: nobody asked for it.
    api.on = false;
    await core.refresh();
    expect(core.status?.proxyOn, isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 3400));
    await core.refresh();
    expect(api.powers, contains(true), reason: 'it reconnects by itself');
    core.dispose();
  });

  // The user's own power-off is theirs; the caretaker never second-guesses.
  test('the caretaker leaves a user power-off alone', () async {
    final api = _CaretakerApi();
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
      turnOn: (on) async {
        api.powers.add(on);
        api.on = on;
      },
      appSettings: AppSettings()..autoReconnect = true,
    );
    await core.refresh();
    await core.setOn(false);
    api.powers.clear();
    await core.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 3400));
    await core.refresh();
    expect(api.powers, isEmpty, reason: 'the user asked for the off');
    core.dispose();
  });

  // The session's data limit ends the session by itself, with a reason
  // the home page can say.
  test('the caretaker ends the session at the data limit', () async {
    final api = _CaretakerApi()..up = 10 * 1000 * 1000;
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
      turnOn: (on) async {
        api.powers.add(on);
        api.on = on;
      },
      appSettings: AppSettings()
        ..dataLimit = true
        ..dataLimitMb = 256,
    );
    // The first poll fixes the baseline the session started at.
    await core.refresh();
    expect(core.autoStopReason, '', reason: 'the session just started');

    // The session passes the limit: it ends itself, with the reason.
    api.up = 300 * 1000 * 1000;
    api.upRate = 4096;
    await core.refresh();
    expect(core.autoStopReason, 'data');
    expect(api.powers.last, isFalse, reason: 'the session ends itself');
    core.dispose();
  });

  // With the switches off, nothing moves by itself.
  test('the caretaker sleeps when its switches are off', () async {
    final api = _CaretakerApi()..on = false;
    final core = CoreController(
      () async => api,
      pollInterval: const Duration(hours: 1),
      turnOn: (on) async {
        api.powers.add(on);
        api.on = on;
      },
      appSettings: AppSettings(),
    );
    await core.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 3400));
    await core.refresh();
    expect(api.powers, isEmpty, reason: 'no switch asks for it');
    core.dispose();
  });
}
