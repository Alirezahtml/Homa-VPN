import 'package:flutter/material.dart';

import '../app_info.dart';
import '../app_settings.dart';
import '../l10n/app_localizations.dart';

/// What a version brought, in the words of what actually changed in it
/// (the same lines the release itself carries). A version without an entry
/// here simply has no page to show: nothing is invented per release.
const whatsNew = <String, List<({String title, List<String> lines})>>{
  '1.0.29': [
    (
      title: 'Android Live Updates',
      lines: [
        'While connected, the notification carries the session\'s duration '
            '(it ticks by itself), the live download and upload speeds, and '
            'the exit country, and it may be promoted by Android 16 above '
            'the shade as a Live Update; a progress bar runs while the '
            'connection is being made. No overlay, no new risky permission '
            '- the system decides.',
      ],
    ),
    (
      title: 'The country wheel',
      lines: [
        'The home page carries the countries as a wheel: drag it, and the '
            'flag in the middle - larger, named below - is the location the '
            'VPN uses. The list is the core\'s real one, Mozilla\'s '
            'recommended location first, under Mozilla\'s own mark.',
      ],
    ),
    (
      title: 'Servers',
      lines: [
        '"Update servers" fetches Mozilla\'s official server list again '
            'through the core: locations Mozilla added appear, ones it '
            'removed leave, and a failed fetch keeps the list you had.',
        'After a delay test, the smart pick offers the measured fastest '
            'country when it clearly beats the choice - the measurements '
            'are real, the choice stays yours.',
      ],
    ),
    (
      title: 'Connection care',
      lines: [
        'Connect after the phone starts: a choice in the settings, which '
            'the app honors at boot when the VPN permission is already '
            'granted.',
        'The kill switch now holds the traffic by default, and the '
            'one-tap diagnostics check the tunnel, the exit country, a real '
            'connection, and the DNS (a filtered answer is called out). '
            'Nothing from it is stored.',
        'The gaming profile surfaces the connection\'s real delay and '
            'turns the notification\'s live speed on; it promises nothing '
            'about ping.',
      ],
    ),
    (
      title: 'The app itself',
      lines: [
        'A full custom color panel: a hue ring, a shade box, HEX and RGB, '
            'the curated accents beside it, kept swatches, a live preview, '
            'and the way back to the monochrome design.',
        'This What\'s New page, once per version.',
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
