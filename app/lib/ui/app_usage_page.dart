import 'package:flutter/material.dart';

import '../core/android_core.dart';
import '../core/speed_test.dart';
import '../l10n/app_localizations.dart';
import 'format.dart';
import 'widgets.dart' show typefacesOf;

/// Android: what each app's traffic was, the system's own accounting (the
/// VPN's carried bytes already attributed to the app that made them), for
/// the last day, week, or month. The system keeps the numbers; the app
/// only reads them, and Usage access is the user's to grant.
class AppUsagePage extends StatefulWidget {
  const AppUsagePage({super.key});

  @override
  State<AppUsagePage> createState() => _AppUsagePageState();
}

class _AppUsagePageState extends State<AppUsagePage> {
  int _days = 1;
  UsageApps? _usage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final usage = await AndroidCore.usageApps(_days);
    if (!mounted) return;
    setState(() => _usage = usage);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final usage = _usage;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.usageTitle),
        actions: [
          PopupMenuButton<int>(
            onSelected: (days) {
              setState(() => _days = days);
              _load();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text(l.usageToday)),
              PopupMenuItem(value: 7, child: Text(l.usageWeek)),
              PopupMenuItem(value: 30, child: Text(l.usageMonth)),
            ],
          ),
        ],
      ),
      body: usage == null
          ? const Center(child: CircularProgressIndicator())
          : !usage.granted
          ? _grant(context, l)
          : usage.apps.isEmpty
          ? Center(child: Text(l.usageEmpty, style: theme.textTheme.bodyMedium))
          : ListView.builder(
              itemCount: usage.apps.length,
              itemBuilder: (context, i) {
                final app = usage.apps[i];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.apps_rounded, size: 20),
                  ),
                  title: Text(
                    app.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    app.pkg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Text(
                    formatBytes(app.bytes),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontFamily: typefacesOf(context).display,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _grant(BuildContext context, AppLocalizations l) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.admin_panel_settings_outlined, size: 44),
          const SizedBox(height: 16),
          Text(
            l.usageGrantHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () async {
              await AndroidCore.openUsageAccess();
              // The user comes back from the settings page.
              if (!mounted) return;
              await Future<void>.delayed(const Duration(milliseconds: 400));
              _load();
            },
            icon: const Icon(Icons.settings_rounded),
            label: Text(l.usageGrant),
          ),
        ],
      ),
    );
  }
}
