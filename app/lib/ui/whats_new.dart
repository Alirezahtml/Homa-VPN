import 'package:flutter/material.dart';

import '../app_info.dart';
import '../app_settings.dart';
import '../l10n/app_localizations.dart';
import 'about_page.dart' show instagramGlyph, telegramGlyph;
import 'widgets.dart' show SocialChannelButton;

/// What a version brought, in the words of what actually changed in it.
/// The words live in the app's translations, so the page speaks the app's
/// language — every language the app has, not only English. A version
/// without an entry here simply has no page to show: nothing is invented
/// per release.
List<({String title, List<String> lines})> whatsNewSections(
  AppLocalizations l,
  String version,
) => switch (version) {
  '1.0.65' => [
    (
      title: l.whatsNewRemoved,
      lines: [l.wn65Gone],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn65Tight, l.wn65Radar],
    ),
  ],
  '1.0.64' => [
    (
      title: l.whatsNewFixed,
      lines: [l.wn64Wheel, l.wn64Headers, l.wn64Pill],
    ),
    (
      title: l.whatsNewAdded,
      lines: [l.wn64Groups],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn64Glass, l.wn64Map, l.wn64Name],
    ),
  ],
  '1.0.63' => [
    (
      title: l.whatsNewRemoved,
      lines: [l.wn63Retired],
    ),
    (
      title: l.whatsNewAdded,
      lines: [l.wn63Map, l.wn63Servers, l.wn63Accounts],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn63Wheel, l.wn63Ios],
    ),
  ],
  '1.0.62' => [
    (
      title: l.whatsNewAdded,
      lines: [l.wn62Map, l.wn62HudMap],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn62Wheel, l.wn62Aether, l.wn62Gta],
    ),
  ],
  '1.0.61' => [
    (
      title: l.whatsNewAdded,
      lines: [l.wn61Gta, l.wn61Sound],
    ),
  ],
  '1.0.60' => [
    (
      title: l.whatsNewAdded,
      lines: [l.wn60Bento, l.wn60Flags],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn60Spacing],
    ),
  ],
  '1.0.59' => [
    (
      title: l.whatsNewAdded,
      lines: [l.wn59Flags, l.wn59Map],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn59Buttons, l.wn59Scroll],
    ),
  ],
  '1.0.58' => [
    (
      title: l.whatsNewFixed,
      lines: [l.wn58Lock, l.wn58Enter, l.wn58Speed],
    ),
    (title: l.whatsNewAdded, lines: [l.wn58Ios, l.wn58Pixel]),
    (title: l.whatsNewImproved, lines: [l.wn58Paper]),
  ],
  '1.0.56' || '1.0.57' => [
    (title: l.whatsNewFixed, lines: [l.wn56Button, l.wn56Speed]),
    (title: l.whatsNewAdded, lines: [l.wn56Gazette, l.wn56Door]),
    (
      title: l.whatsNewImproved,
      lines: [l.wn56Capsule, l.wn56Wheel],
    ),
  ],
  '1.0.52' || '1.0.55' => [
    (title: l.whatsNewFixed, lines: [l.wn52Speed, l.wn52Smart]),
    (title: l.whatsNewAdded, lines: [l.wn52Motion]),
    (title: l.whatsNewImproved, lines: [l.wn52Pages]),
  ],
  '1.0.51' => [
    (title: l.whatsNewImproved, lines: [l.wn51Smooth, l.wn51Zed, l.wn51Aether]),
    (title: l.whatsNewFixed, lines: [l.wn51Veil]),
  ],
  '1.0.50' => [
    (
      title: l.whatsNewFixed,
      lines: [l.wn50Notch, l.wn50Cards, l.wn50Veil, l.wn50Ping],
    ),
  ],
  '1.0.49' => [
    (title: l.whatsNewAdded, lines: [l.wn49States]),
    (title: l.whatsNewImproved, lines: [l.wn49Words, l.wn49Sooner]),
    (title: l.whatsNewFixed, lines: [l.wn49Mark]),
  ],
  '1.0.48' => [
    (title: l.whatsNewFixed, lines: [l.wn48Bars, l.wn48Fit, l.wn48Wheel]),
  ],
  '1.0.47' => [
    (title: l.whatsNewAdded, lines: [l.wn47Designs]),
    (title: l.whatsNewImproved, lines: [l.wn47Fixes]),
  ],
  '1.0.46' => [
    (title: l.whatsNewAdded, lines: [l.wn46Designs]),
    (title: l.whatsNewImproved, lines: [l.wn46Sounds]),
  ],
  '1.0.45' => [
    (title: l.whatsNewAdded, lines: [l.wn45Designs, l.wn45HelloAuto]),
    (title: l.whatsNewImproved, lines: [l.wn45RelayRace]),
    (title: l.whatsNewFixed, lines: [l.wn45AccentFixed, l.wn45WhatsNewFixed]),
  ],
  '1.0.42' => [
    (title: l.whatsNewAdded, lines: [l.wn42Fonts, l.wn42Sounds, l.wn42Gaming]),
    (title: l.whatsNewFixed, lines: [l.wn42AboutFixed]),
  ],
  '1.0.41' => [
    (
      title: l.whatsNewAdded,
      lines: [
        l.wn41Sound,
        l.wn41RateUnit,
        l.wn41BackgroundLock,
        l.wn41BiggerLimits,
      ],
    ),
    (title: l.whatsNewImproved, lines: [l.wn41Motion, l.wn41AboutFixed]),
    (title: l.whatsNewFixed, lines: [l.wn41HapticFixed]),
  ],
  '1.0.40' => [
    (title: l.whatsNewAdded, lines: [l.wn40MapKindsNew]),
    (
      title: l.whatsNewImproved,
      lines: [l.wn40Flight, l.wn40Mercator, l.wn40NameBack, l.wn40Speed],
    ),
    (title: l.whatsNewFixed, lines: [l.wn40LockFixed]),
    (title: l.whatsNewRemoved, lines: [l.wn40IpRemoved]),
  ],
  '1.0.39' => [
    (
      title: l.whatsNewAdded,
      lines: [l.wn39MapKinds, l.wn39EyeIp, l.wn39Profile, l.wn39Smart],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn39Flight, l.wn39ToastEverywhere, l.wn39Updates],
    ),
  ],
  '1.0.38' => [
    (
      title: l.whatsNewAdded,
      lines: [
        l.wn38MapStylesAdded,
        l.wn38ZoomAdded,
        l.wn38OptionsAdded,
        l.wn38SocialAdded,
      ],
    ),
    (
      title: l.whatsNewImproved,
      lines: [l.wn38FlightImproved, l.wn38EffectsImproved, l.wn38SpeedImproved],
    ),
    (title: l.whatsNewFixed, lines: [l.wn38NameFixed]),
  ],
  '1.0.37' => [
    (title: l.whatsNewImproved, lines: [l.wnGlobeAdded, l.wnWheelGlowImproved]),
    (title: l.whatsNewRemoved, lines: [l.wnDesignsRemoved]),
  ],
  '1.0.36' => [
    (title: l.whatsNewAdded, lines: [l.wnDesignsAdded, l.wnDnsAdded]),
    (
      title: l.whatsNewImproved,
      lines: [
        l.wnMapReal,
        l.wnSmartImproved,
        l.wnProtectionImproved,
        l.wnWelcomeImproved,
      ],
    ),
    (title: l.whatsNewFixed, lines: [l.wnWheelFixed]),
  ],
  '1.0.35' => [
    (title: l.whatsNewAdded, lines: [l.wnSmartAdded, l.wnToastAdded]),
    (title: l.whatsNewImproved, lines: [l.wnFlagsImproved, l.wnMapImproved]),
  ],
  '1.0.34' => [
    (title: l.whatsNewAdded, lines: [l.wnTotalsAdded]),
    (title: l.whatsNewImproved, lines: [l.wnPolishImproved]),
  ],
  '1.0.33' => [
    (title: l.whatsNewFixed, lines: [l.wnFlagArtFixed]),
  ],
  '1.0.32' => [
    (title: l.whatsNewFixed, lines: [l.wnCrashFixed]),
  ],
  '1.0.31' => [
    (title: l.whatsNewAdded, lines: [l.wnDesignAdded, l.wnFlagNotifAdded]),
    (title: l.whatsNewImproved, lines: [l.wnMapAdded, l.wnWheelAdded]),
    (title: l.whatsNewRemoved, lines: [l.wnColorRemoved]),
  ],
  '1.0.30' => [
    (title: l.whatsNewImproved, lines: [l.wnWheelImproved, l.wnLiveImproved]),
    (title: l.whatsNewFixed, lines: [l.wnL10nFixed, l.wnMarkFixed]),
  ],
  _ => const [],
};

/// The versions that carry a page (every language has it at once).
const _whatsNewVersions = {
  '1.0.52',
  '1.0.30',
  '1.0.31',
  '1.0.32',
  '1.0.33',
  '1.0.34',
  '1.0.35',
  '1.0.36',
  '1.0.37',
  '1.0.38',
  '1.0.39',
  '1.0.40',
  '1.0.41',
  '1.0.42',
  '1.0.45',
  '1.0.46',
  '1.0.47',
  '1.0.48',
  '1.0.49',
  '1.0.50',
  '1.0.51',
  '1.0.56',
  '1.0.58',
  '1.0.59',
};

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
                          child: Text(line, style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  ),
              ],
              // The makers' channels, at the page's own bottom: the same
              // two buttons the About page carries, one breath from the
              // version's story.
              const Divider(height: 26),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: const [
                  SocialChannelButton(
                    glyph: instagramGlyph,
                    handle: '@Aliem061',
                    url: 'https://instagram.com/Aliem061',
                  ),
                  SocialChannelButton(
                    glyph: telegramGlyph,
                    handle: '@Aliem_061',
                    url: 'https://t.me/Aliem_061',
                  ),
                ],
              ),
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
