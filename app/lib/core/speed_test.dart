/// One live tick of the speed test: the direction's bytes so far and the
/// speed they imply, refreshed every quarter second while the leg runs.
class SpeedTestProgress {
  SpeedTestProgress.fromJson(Map<String, Object?> j)
    : dir = j['dir'] as String? ?? '',
      bytes = (j['bytes'] as num?)?.toInt() ?? 0,
      bps = (j['bps'] as num?)?.toInt() ?? 0;

  final String dir;
  final int bytes;
  final int bps;
}

/// The speed test's answer: what each direction carried and how fast.
/// [throughTunnel] says the transfers took the tunnel; false, the proxy
/// was off and the raw network was measured instead.
class SpeedTestResult {
  const SpeedTestResult({
    required this.ok,
    required this.throughTunnel,
    required this.downBps,
    required this.upBps,
    required this.downBytes,
    required this.upBytes,
    required this.totalMs,
    this.error = '',
  });

  const SpeedTestResult.empty()
    : ok = false,
      throughTunnel = false,
      downBps = 0,
      upBps = 0,
      downBytes = 0,
      upBytes = 0,
      totalMs = 0,
      error = '';

  SpeedTestResult.fromJson(Map<String, Object?> j)
    : ok = j['ok'] == true,
      throughTunnel = j['through_tunnel'] == true,
      downBps = (j['down_bps'] as num?)?.toInt() ?? 0,
      upBps = (j['up_bps'] as num?)?.toInt() ?? 0,
      downBytes = (j['down_bytes'] as num?)?.toInt() ?? 0,
      upBytes = (j['up_bytes'] as num?)?.toInt() ?? 0,
      totalMs = (j['total_ms'] as num?)?.toInt() ?? 0,
      error = j['error'] as String? ?? '';

  final bool ok;
  final bool throughTunnel;
  final int downBps;
  final int upBps;
  final int downBytes;
  final int upBytes;
  final int totalMs;
  final String error;
}

/// One app's data usage the system reports, for the per-app usage page.
class UsageApp {
  UsageApp.fromJson(Map<String, Object?> j)
    : pkg = j['package'] as String? ?? '',
      label = j['label'] as String? ?? '',
      bytes = (j['bytes'] as num?)?.toInt() ?? 0;

  final String pkg;
  final String label;
  final int bytes;
}

/// The usage answer: whether the Usage access permission stands, and the
/// apps' usage when it does.
class UsageApps {
  UsageApps.fromJson(Map<String, Object?> j)
    : granted = j['granted'] == true,
      apps = [
        for (final app in (j['apps'] as List<Object?>? ?? const []))
          if (app is Map<String, Object?>) UsageApp.fromJson(app),
      ];

  final bool granted;
  final List<UsageApp> apps;
}
