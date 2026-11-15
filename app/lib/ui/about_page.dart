import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../app_info.dart';
import '../app_settings.dart';
import '../core/core_controller.dart';
import '../core/updates.dart';
import '../l10n/app_localizations.dart';
import '../platform.dart';
import 'widgets.dart';
import 'whats_new.dart';

/// The makers' social channels: the official glyphs, drawn in the app's
/// ink (Instagram's camera, Telegram's plane; the simple-icons paths).
/// Public, so the What's New page carries the same buttons.
const String instagramGlyph = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 0C8.74 0 8.333.015 7.053.072 5.775.132 4.905.333 4.14.63c-.789.306-1.459.717-2.126 1.384S.935 3.35.63 4.14C.333 4.905.131 5.775.072 7.053.012 8.333 0 8.74 0 12s.015 3.667.072 4.947c.06 1.277.261 2.148.558 2.913.306.788.717 1.459 1.384 2.126.667.666 1.336 1.079 2.126 1.384.766.296 1.636.499 2.913.558C8.333 23.988 8.74 24 12 24s3.667-.015 4.947-.072c1.277-.06 2.148-.262 2.913-.558.788-.306 1.459-.718 2.126-1.384.666-.667 1.079-1.335 1.384-2.126.296-.765.499-1.636.558-2.913.06-1.28.072-1.687.072-4.947s-.015-3.667-.072-4.947c-.06-1.277-.262-2.149-.558-2.913-.306-.789-.718-1.459-1.384-2.126C21.319 1.347 20.651.935 19.86.63c-.765-.297-1.636-.499-2.913-.558C15.667.012 15.26 0 12 0zm0 2.16c3.203 0 3.585.016 4.85.071 1.17.055 1.805.249 2.227.415.562.217.96.477 1.382.896.419.42.679.819.896 1.381.164.422.36 1.057.413 2.227.057 1.266.07 1.646.07 4.85s-.015 3.585-.074 4.85c-.061 1.17-.256 1.805-.421 2.227-.224.562-.479.96-.899 1.382-.419.419-.824.679-1.38.896-.42.164-1.065.36-2.235.413-1.274.057-1.649.07-4.859.07-3.211 0-3.586-.015-4.859-.074-1.171-.061-1.816-.256-2.236-.421-.569-.224-.96-.479-1.379-.899-.421-.419-.69-.824-.9-1.38-.165-.42-.359-1.065-.42-2.235-.045-1.26-.061-1.649-.061-4.844 0-3.196.016-3.586.061-4.861.061-1.17.255-1.814.42-2.234.21-.57.479-.96.9-1.381.419-.419.81-.689 1.379-.898.42-.166 1.051-.361 2.221-.421 1.275-.045 1.65-.06 4.859-.06l.045.03zm0 3.678c-3.405 0-6.162 2.76-6.162 6.162 0 3.405 2.76 6.162 6.162 6.162 3.405 0 6.162-2.76 6.162-6.162 0-3.405-2.76-6.162-6.162-6.162zM12 16c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4zm7.846-10.405c0 .795-.646 1.44-1.44 1.44-.795 0-1.44-.646-1.44-1.44 0-.794.646-1.439 1.44-1.439.793-.001 1.44.645 1.44 1.439z"/></svg>
''';

const String telegramGlyph = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.48.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z"/></svg>
''';

/// The versions, the update check, What's New, the social row, and the
/// data folder. No repository link: the update check knows where the
/// releases are, and the interface stays the app's own.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.core, this.settings});

  final CoreController core;

  /// For the What's New page (it marks the version seen; null still shows
  /// the page, it just does not record the visit).
  final AppSettings? settings;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _checking = false;
  String? _result;
  Release? _release;

  @override
  void initState() {
    super.initState();
    _release = Updates.available.value;
  }

  Future<void> _check() async {
    final l = AppLocalizations.of(context);
    if (githubRepo.isEmpty) {
      setState(() => _result = l.repoNotSet);
      return;
    }
    setState(() {
      _checking = true;
      _result = null;
      _release = null;
    });
    try {
      final release = await checkForUpdate(
        check: UpdateCheck.manual,
        proxy: updateProxy(widget.core.status),
        onAnnouncements: Updates.receiveAnnouncements,
      );
      Updates.found(release, check: UpdateCheck.manual);
      if (!mounted) return;
      setState(() {
        _release = release;
        _result = release == null
            ? l.upToDate
            : release.mandatory
            ? l.updateRequired(release.version)
            : l.updateAvailable(release.version);
      });
    } on Exception catch (e) {
      // No connection, a timeout, or a refused handshake: say so in words,
      // not as the exception's text.
      final network =
          e is SocketException || e is TimeoutException || e is TlsException;
      if (mounted) {
        setState(
          () => _result = network
              ? l.updateCheckNoNetwork
              : l.updateCheckFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = widget.core.status;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    // The sponsor layout: every card hugs what it carries — wide enough
    // for its own words in any language, never squeezed — and grows only
    // when it must, by stepping to a line of its own when the row runs
    // out of room. Nothing is compressed to fit.
    Widget social(String glyph, String handle, String url) =>
        SocialChannelButton(glyph: glyph, handle: handle, url: url);
    // The repository stays out of the app on purpose: no source link, no
    // GitHub row — only the app's own pages and the update check.
    //
    // Each thing on this page is a card of its own: the app's identity,
    // the versions, What's New, the channels, the update check, the web
    // console, the data folder — a card per section, the way every other
    // page of the app lays its own out.
    return ListView(
      padding: pagePadding(context),
      children: [
        PageTitle(l.navAbout),
        const SizedBox(height: 20),
        // The identity: who this app is, in one card of its own.
        Panel(
          child: Column(
            children: [
              const AppLogo(size: 72),
              const SizedBox(height: 10),
              Text(l.appTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(l.unofficialNote, style: muted, textAlign: TextAlign.center),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // The versions: this build and the core it carries.
        Panel(
          title: l.aboutVersions,
          icon: Icons.tag_rounded,
          child: Column(
            children: [
              _Line(label: l.appVersionLabel, value: appVersion),
              const SizedBox(height: 14),
              _Line(label: l.coreVersionLabel, value: status?.version ?? '—'),
              // What this version brought: opens once per version on its
              // own, and again whenever wanted.
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(l.whatsNewMenu, style: theme.textTheme.titleSmall),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => showWhatsNew(
                      context,
                      widget.settings ?? AppSettings(),
                    ),
                    icon: const Icon(Icons.new_releases_outlined, size: 18),
                    label: Text(l.whatsNewView),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // The social channels: Instagram and Telegram, by their handles,
        // in a card of their own. There is no code repository in this app.
        Panel(
          title: l.aboutChannels,
          icon: Icons.alternate_email_rounded,
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              social(
                instagramGlyph,
                '@Aliem061',
                'https://instagram.com/Aliem061',
              ),
              social(
                telegramGlyph,
                '@Aliem_061',
                'https://t.me/Aliem_061',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // The update check: the button, the result, and the update's own
        // action, in a card of their own.
        if (githubRepo.isNotEmpty)
          Panel(
            title: l.checkUpdates,
            icon: Icons.system_update_alt_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.checkUpdatesHint,
                        style: muted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _checking ? null : _check,
                      icon: _checking
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.update_rounded, size: 18),
                      label: Text(
                        _checking ? l.checkingUpdates : l.checkUpdates,
                      ),
                    ),
                  ],
                ),
                if (_result != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(_result!, style: muted),
                  ),
                ],
                if (_release case final release?) ...[
                  const SizedBox(height: 10),
                  _UpdateAction(core: widget.core, release: release),
                ],
              ],
            ),
          ),
        if (Platform.isAndroid) ...[
          const SizedBox(height: 12),
          // The web console: advanced settings and more tools, in a card
          // of its own.
          Panel(
            title: l.webDashboard,
            icon: Icons.language_rounded,
            child: Row(
              children: [
                Expanded(child: Text(l.webDashboardHint, style: muted)),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => runShowingErrors(
                    context,
                    () async => openUrl('${await widget.core.dashboardLink()}'),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: Text(l.webDashboardOpen),
                ),
              ],
            ),
          ),
        ],
        // The data folder: not on a phone, where it is the app's
        // private storage, which nobody can open.
        if (!Platform.isAndroid &&
            status != null &&
            status.dataDir.isNotEmpty) ...[
          const SizedBox(height: 12),
          Panel(
            title: l.dataFolder,
            icon: Icons.folder_open_rounded,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    status.dataDir,
                    style: muted,
                    textDirection: TextDirection.ltr,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () =>
                      runShowingErrors(context, widget.core.openFolder),
                  icon: const Icon(Icons.folder_open_rounded, size: 18),
                  label: Text(l.openFolder),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// The found version's button: Update where the app installs it itself
/// (Windows), with the download's progress, why it failed, and Try again;
/// else Download.
class _UpdateAction extends StatelessWidget {
  const _UpdateAction({required this.core, required this.release});

  final CoreController core;
  final Release release;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([
      core,
      Updates.failure,
      Updates.apkState,
      Updates.apkProgress,
    ]),
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final muted = Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
      Widget button(String label, IconData icon, VoidCallback? onPressed) =>
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
            ),
          );
      // Android updates the app itself: the package downloads here, then
      // the system's installer asks — the repository stays out of it.
      if (Platform.isAndroid) {
        final progress = Updates.apkProgress.value;
        return switch (Updates.apkState.value) {
          ApkState.downloading => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.updateDownloading(release.version), style: muted),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress),
            ],
          ),
          ApkState.ready => button(
            l.installNow,
            Icons.install_mobile_rounded,
            () => Updates.installApkUpdate(),
          ),
          ApkState.permission => button(
            l.allowInstall,
            Icons.settings_rounded,
            () => Updates.installApkUpdate(),
          ),
          ApkState.failed => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.updateFailed(release.version), style: muted),
              const SizedBox(height: 8),
              button(
                l.tryAgain,
                Icons.refresh_rounded,
                () => Updates.update(release),
              ),
            ],
          ),
          ApkState.idle => button(
            l.updateNow,
            Icons.system_update_alt_rounded,
            () => Updates.update(release),
          ),
        };
      }
      final update = core.status?.update;
      if (update == null) {
        return release.url.isEmpty
            ? const SizedBox.shrink()
            : button(
                l.download,
                Icons.download_rounded,
                () => openDownload(context, release),
              );
      }
      final mine = update.version == release.version;
      if (mine && (update.downloading || update.installing)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              update.downloading
                  ? l.updateDownloading(release.version)
                  : l.updateInstalling(release.version),
              style: muted,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: update.downloading ? update.progress : null,
            ),
          ],
        );
      }
      final failure =
          Updates.failure.value ??
          (mine && update.failed ? update.error : null);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (failure != null) ...[
            Tooltip(
              message: failure,
              child: Text(l.updateFailed(release.version), style: muted),
            ),
            const SizedBox(height: 8),
          ],
          button(
            failure != null ? l.tryAgain : l.updateNow,
            failure != null
                ? Icons.refresh_rounded
                : Icons.system_update_alt_rounded,
            () => Updates.update(release),
          ),
        ],
      );
    },
  );
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }
}
