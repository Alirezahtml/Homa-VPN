import 'package:flutter/material.dart';

import '../app_info.dart';
import '../app_settings.dart';
import '../l10n/app_localizations.dart';

/// What a version brought, in the words of what actually changed in it
/// (the same lines the release itself carries). A version without an entry
/// here simply has no page to show: nothing is invented per release.
const whatsNew = <String, List<({String title, List<String> lines})>>{
  '1.0.19': [
    (
      title: 'Security and no leaks',
      lines: [
        'Kill Switch: when the tunnel or the core dies while the VPN is on, '
            'the VPN stays up holding the traffic and reconnects — nothing '
            'leaves the phone unencrypted.',
        'The DNS and the IPv6 routes already travel inside the tunnel; the '
            'diagnostics page can now check them in one tap.',
        'Update offers now come from Homa\'s own release source, and a '
            'release without its signed SHA-256 checksum list is never '
            'offered.',
      ],
    ),
    (
      title: 'Connection',
      lines: [
        'Connect after the phone starts (a choice in the connection '
            'settings); network changes (Wi-Fi ↔ mobile data) already '
            'reconnect by themselves, now with a calmer retry beat.',
        'Smart server pick: measure every location once, and the app '
            'suggests the fastest one to use.',
        '"Update servers" on the servers page fetches Mozilla\'s official '
            'server list again, so new or removed locations apply.',
        'The Recommended choice now carries the official Mozilla mark.',
      ],
    ),
    (
      title: 'The app itself',
      lines: [
        'Android Live Updates: while connected, the notification shows the '
            'session\'s duration, the download and upload speeds, and the '
            'exit country, with Disconnect in it (Android 16 and later; '
            'earlier versions keep a standard, compatible notification).',
        'A country carousel on the home page: swipe through the flags, the '
            'chosen one sits larger in the middle, and picking one moves the '
            'VPN there.',
        'A full Custom color panel: wheel, HEX, RGB, the accent\'s own '
            'color, an intensity slider, kept swatches, and a live preview.',
        'The About page now links Instagram and Telegram in one row, in '
            'their own colors.',
        'This What\'s New page, once per version.',
      ],
    ),
  ],
  '1.0.18': [
    (
      title: 'Homa VPN',
      lines: [
        'The app is Homa VPN now (com.homa.vpn): its own name, icon and '
            'colors, independent of the project it started from.',
        'The dashboard, the settings and the phone layout were redrawn in '
            'one monochrome night look, with the slide-to-connect button.',
        'Releases and updates are built and published by Homa\'s own '
            'pipeline, signed with Homa\'s key.',
      ],
    ),
  ],
};

/// Whether this version's page is still waiting to be seen.
bool whatsNewPending(AppSettings settings) =>
    settings.whatsNewSeen != appVersion &&
    whatsNew.containsKey(appVersion) &&
    appVersion != '0.0.0';

/// Shows the current version's page, and marks it seen (once per version;
/// About can show it again without harm).
Future<void> showWhatsNew(
  BuildContext context,
  AppSettings settings, {
  bool markSeen = true,
}) {
  if (markSeen) {
    settings.update(whatsNewSeen: appVersion);
  }
  return showDialog<void>(
    context: context,
    builder: (context) => WhatsNewDialog(version: appVersion),
  );
}

/// The page itself: what the version added, improved, and fixed.
class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sections = whatsNew[version] ?? const [];
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.celebration_outlined),
          const SizedBox(width: 10),
          Expanded(child: Text(l.whatsNewTitle(version))),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, section) in sections.indexed) ...[
                if (i > 0) const SizedBox(height: 14),
                Text(
                  section.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                for (final line in section.lines)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4, bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('•  '),
                        Expanded(
                          child: Text(
                            line,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.whatsNewContinue),
        ),
      ],
    );
  }
}
