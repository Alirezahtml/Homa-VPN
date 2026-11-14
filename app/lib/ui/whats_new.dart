import 'package:flutter/material.dart';

import '../app_info.dart';
import '../app_settings.dart';
import '../l10n/app_localizations.dart';

/// What a version brought, in the words of what actually changed in it.
/// The words live in the app's translations, so the page speaks the app's
/// language — every language the app has, not only English. A version
/// without an entry here simply has no page to show: nothing is invented
/// per release.
List<({String title, List<String> lines})> whatsNewSections(
  AppLocalizations l,
  String version,
) => switch (version) {
  '1.0.30' => [
    (
      title: l.whatsNewImproved,
      lines: [l.wnWheelImproved, l.wnLiveImproved],
    ),
    (
      title: l.whatsNewFixed,
      lines: [l.wnL10nFixed, l.wnMarkFixed],
    ),
  ],
  _ => const [],
};

/// The versions that carry a page (every language has it at once).
const _whatsNewVersions = {'1.0.30'};

/// Whether this version's page is still waiting to be seen.
bool whatsNewPending(AppSettings settings) =>
    settings.whatsNewSeen != appVersion &&
    appVersion != '0.0.0' &&
    _whatsNewVersions.contains(appVersion);

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

/// The page itself: what the version improved, and what it fixed, each
/// named in the app's own language.
class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sections = whatsNewSections(l, version);
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
                    padding: const EdgeInsetsDirectional.only(
                      start: 4,
                      bottom: 6,
                    ),
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
