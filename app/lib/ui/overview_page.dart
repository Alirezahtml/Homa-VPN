import 'dart:io';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui' as ui;

import '../app_settings.dart';
import '../core/android_core.dart';
import '../core/core_controller.dart';
import '../core/updates.dart';
import '../core/models.dart';
import '../core/ports.dart';
import '../l10n/app_localizations.dart';
import '../platform.dart';
import 'accent.dart';
import 'browser_signin.dart';
import 'connection_mode.dart';
import 'design.dart';
import 'design_style.dart';
import 'flag_carousel.dart';
import 'format.dart';
import 'gazette.dart';
import 'glass.dart';
import 'motion.dart';
import 'port_dialog.dart';
import 'sound.dart' show AppSounds, SoundCue;
import 'speed_test_dialog.dart' show showSpeedTest;
import 'widgets.dart';
import 'world_map.dart';

/// The home page: the switch, the state, where the traffic goes, and the
/// data used; the phone's (_PhoneHome) and the computer's (_DesktopHome)
/// share the look, not the logic. Developer mode adds the details.
class OverviewPage extends StatelessWidget {
  const OverviewPage({
    super.key,
    required this.core,
    required this.settings,
    this.onOpenServers,
    this.onOpenAccounts,
    this.onOpenConnection,
    this.onOpenUpstreamProxy,
    this.phone = false,
  });

  final CoreController core;
  final AppSettings settings;

  /// The phone layout: a colored hero and the data left (_PhoneHome).
  final bool phone;

  /// Opens the server list and the accounts from the home page's cards (a
  /// page on the phone, a tab on the computer).
  final VoidCallback? onOpenServers;
  final VoidCallback? onOpenAccounts;

  /// Opens the connection settings, when Mozilla's servers are blocked.
  final VoidCallback? onOpenConnection;
  final VoidCallback? onOpenUpstreamProxy;

  @override
  Widget build(BuildContext context) {
    final status = core.status!;
    final showIp = settings.showPublicIp;
    if (phone) {
      return _PhoneHome(
        core: core,
        status: status,
        showIp: showIp,
        settings: settings,
        onOpenServers: onOpenServers,
        onOpenAccounts: onOpenAccounts,
        onOpenConnection: onOpenConnection,
        onOpenUpstreamProxy: onOpenUpstreamProxy,
      );
    }
    return _DesktopHome(
      core: core,
      status: status,
      showIp: showIp,
      settings: settings,
      onOpenServers: onOpenServers,
      onOpenAccounts: onOpenAccounts,
      onOpenConnection: onOpenConnection,
      onOpenUpstreamProxy: onOpenUpstreamProxy,
    );
  }
}

/// Opens the connection settings under "Mozilla's servers are blocked":
/// HTTP/2, HTTP/3, or HTTP/1.1, one of which a network may let through.
class _ConnectionSettingsButton extends StatelessWidget {
  const _ConnectionSettingsButton({required this.onPressed, this.label});

  final VoidCallback onPressed;

  /// The button's text; "Connection settings" without it.
  final String? label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Center(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.tune_rounded, size: 18),
        label: Text(label ?? AppLocalizations.of(context).connectionSettings),
      ),
    ),
  );
}

/// Under "This location isn't available for your account": switches to
/// Mozilla's recommended location (an empty `proxy.country`).
class _RecommendedLocationButton extends StatelessWidget {
  const _RecommendedLocationButton({required this.core});

  final CoreController core;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Center(
      child: TextButton.icon(
        onPressed: () => runShowingErrors(context, () => core.setLocation('')),
        icon: const Icon(Icons.public_rounded, size: 18),
        label: Text(AppLocalizations.of(context).useRecommendedLocation),
      ),
    ),
  );
}

/// An amber box when another program (another VPN or proxy) replaced the
/// system proxy the core set, so applications no longer use the VPN; the
/// button takes it back. The core never does that by itself.
class _SystemProxyTakenNote extends StatelessWidget {
  const _SystemProxyTakenNote({required this.core, required this.by});

  final CoreController core;

  /// What the system proxy points at now; empty when it was turned off.
  final String by;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProblemBox(
            text: by.isEmpty
                ? l.systemProxyTakenOff
                : l.systemProxyTakenBy(ltr(by)),
            color: StatusColors.busy,
            icon: Icons.warning_amber_rounded,
          ),
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: () =>
                runShowingErrors(context, () => core.setSystemProxy('set')),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l.setSystemProxyAgain),
          ),
        ],
      ),
    );
  }
}

/// An amber box when the public IP is in another country than the chosen
/// one: a hint, not an error; the connection works.
class _ExitMismatchNote extends StatelessWidget {
  const _ExitMismatchNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: _ProblemBox(
      text: text,
      color: StatusColors.busy,
      icon: Icons.warning_amber_rounded,
    ),
  );
}

/// The widest a [_ProblemBox] grows.
const _problemBoxWidth = 460.0;

/// A home-page problem in a tinted box, so it stands out from the ordinary
/// hints: red for an error, amber for a warning. The text is darkened (or,
/// at night, lightened) toward the page's text for contrast on the tint.
class _ProblemBox extends StatelessWidget {
  const _ProblemBox({
    required this.text,
    required this.color,
    required this.icon,
    this.tooltip = '',
  });

  final String text;
  final Color color;
  final IconData icon;

  /// The core's own words, on hover or a long press.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = Color.lerp(color, dark ? Colors.white : Colors.black, 0.25)!;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _problemBoxWidth),
        child: Tooltip(
          message: tooltip,
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 9, 14, 9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: dark ? 0.18 : 0.11),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: ink, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The accounts page, from the power button without an account; the
/// sign-in form when no page is given.
void _openAccounts(
  BuildContext context,
  CoreController core,
  AppSettings settings,
  VoidCallback? onOpenAccounts,
) {
  if (onOpenAccounts != null) {
    onOpenAccounts();
  } else {
    startAddAccount(context, core, settings);
  }
}

/// The core handles the initial connection while an explicit attempt is pending.
void _testAfterPowerOn(CoreController core) {
  final status = core.status;
  if (status != null && status.proxyOn && !status.connectPending) {
    unawaited(core.runTest().catchError((_) {}));
  }
}

/// The computer's home: the phone's look with the computer's logic. The
/// button turns the proxy on or off (off closes its port and gives Windows
/// its own proxy setting back); the mode chooses who uses it: Proxy, apps
/// set up by hand, or System proxy, Windows too. Switching modes never
/// disconnects. "Connecting" in orange until a test confirms the
/// connection. Where the traffic goes and the data used are in cards; the
/// email is on the accounts page.
class _DesktopHome extends StatelessWidget {
  const _DesktopHome({
    required this.core,
    required this.status,
    required this.showIp,
    required this.settings,
    this.onOpenServers,
    this.onOpenAccounts,
    this.onOpenConnection,
    this.onOpenUpstreamProxy,
  });

  final CoreController core;
  final CoreStatus status;

  /// Settings, Show the public IP.
  final bool showIp;
  final AppSettings settings;
  final VoidCallback? onOpenServers;
  final VoidCallback? onOpenAccounts;
  final VoidCallback? onOpenConnection;
  final VoidCallback? onOpenUpstreamProxy;

  /// The connection mode shown as chosen; changing it (chooseConnectionMode)
  /// keeps the proxy running and connected.
  String get _mode => connectionModeShown(status);

  /// The button: off, or on with a test that confirms the connection.
  Future<void> _power(bool on) async {
    await core.setOn(on);
    if (on) _testAfterPowerOn(core);
  }

  @override
  Widget build(BuildContext context) {
    final p = _homePalette(Theme.of(context).brightness);
    final page = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [p.top, p.bottom],
        ),
      ),
      child: SingleChildScrollView(
        // The bottom clears the floating pill navigation, which the page
        // runs beneath.
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 108),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _content(context, p),
          ),
        ),
      ),
    );
    final content = switch (DesignStyle.of(context).nav) {
      // The zed's own signature: the two violet FABs that ride the
      // screen's edge — the servers' map and the speed test — dragged
      // by hand, snapping back with the bounce (ZedSecure's cluster).
      NavVariant.floatingDock => Stack(
        children: [
          page,
          Positioned.fill(
            child: ZedFabCluster(
              onOpenServers: () => onOpenServers?.call(),
              onOpenSpeedTest: () => showSpeedTest(context, core, settings),
            ),
          ),
        ],
      ),
      _ => page,
    };
    return p.dark
        ? Theme(data: midnightTheme(Theme.of(context)), child: content)
        : content;
  }

  bool get _running => status.state.phase == Phase.running;

  /// The core is connecting, or the proxy still needs a passing test.
  bool get _confirming =>
      status.connectPending ||
      (status.proxyOn && _running && !status.confirmedBy(core.lastTest));

  Color _accent(_HomePalette p) => switch (status.state.phase) {
    _ when status.connectPending => p.busy,
    _ when !status.proxyOn => p.idle,
    Phase.error => p.error,
    Phase.running when _confirming => p.busy,
    Phase.running => p.connected,
    Phase.starting => p.busy,
    _ => p.idle,
  };

  Widget _content(BuildContext context, _HomePalette p) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final look = PhaseLook.of(l, status);
    final proxy = status.proxy;
    final on = status.proxyOn;
    final confirming = _confirming;
    final test = status.isCurrentTest(core.lastTest) ? core.lastTest : null;
    final noNetwork = !status.connectPending && status.noNetwork && on;
    final failing =
        !status.connectPending &&
        confirming &&
        ((proxy?.wakeError.isNotEmpty ?? false) || test?.ok == false);
    // The real reason; a long press or hover shows the core's own text.
    final failure = failing ? failureText(l, proxy, test) : null;
    // The last connect was given up: why, until the next one.
    final gaveUp = !on && status.connectFailure.isNotEmpty;
    final connected = on && _running && !confirming;
    final accent = _accent(p);
    final ip = !showIp
        ? ''
        : status.exit?.ipv4.isNotEmpty == true
        ? status.exit!.ipv4
        : status.exit?.ipv6 ?? '';
    final place = homeLocation(l, status, connected: connected);
    final mismatch = exitMismatchText(l, status);
    final cards = [
      Reveal(
        index: 3,
        child: _PlaceCard(
          palette: p,
          compact: true,
          place: place,
          accent: accent,
          onTap: onOpenServers,
        ),
      ),
      Reveal(
        index: 4,
        child: _HomeData(
          status: status,
          palette: p,
          onTap: onOpenAccounts,
          compact: true,
        ),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: _PowerOrb(
            palette: p,
            on: on,
            accent: accent,
            busy: core.switchingProxy,
            batterySaver: settings.batterySaver,
            tooltip: on ? l.tapToDisconnect : l.tapToConnect,
            // No account yet: the accounts page, which explains them.
            onPressed: () {
              AppSounds.play(SoundCue.tap);
              if (status.totalAccounts == 0) {
                _openAccounts(context, core, settings, onOpenAccounts);
              } else {
                runShowingErrors(context, () => _power(!on));
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        CrossfadeText(
          confirming
              ? l.stateConnecting
              : connected
              ? l.stateConnected
              : look.label,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: on ? accent : p.text,
          ),
        ),
        const SizedBox(height: 8),
        if (connected)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _HomeDelay(core: core, palette: p),
              if (ip.isNotEmpty)
                _HomePill(
                  palette: p,
                  // A tap copies the address: reports and checks need
                  // it by hand, and the note says so.
                  onTap: () {
                    AppSounds.play(SoundCue.tap);
                    _copyPublicIp(context, ip);
                  },
                  child: Text(
                    '${l.publicIp} ${ltr(ip)}',
                    style: theme.textTheme.labelLarge?.copyWith(color: p.muted),
                  ),
                ),
              if (status.upstreamProxy.isNotEmpty)
                _UpstreamProxyPill(
                  address: status.upstreamProxy,
                  palette: p,
                  onPressed: onOpenUpstreamProxy,
                ),
            ],
          )
        else if (failing || noNetwork || gaveUp)
          // Not connecting stands out from the ordinary hints.
          _ProblemBox(
            text: noNetwork
                ? l.noNetwork
                : failure != null
                ? failure.text
                : failureCodeText(l, status.connectFailure),
            color: p.error,
            icon: Icons.error_outline_rounded,
            tooltip: noNetwork ? '' : failure?.detail ?? '',
          )
        else if (core.autoStopReason == 'idle' && !noNetwork)
          // The caretaker ended the session: the idle wait passed.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _problemBoxWidth),
              child: _ProblemBox(
                text: l.autoStoppedIdle(settings.idleTimeoutMin),
                color: StatusColors.busy,
                icon: Icons.hourglass_bottom_rounded,
              ),
            ),
          )
        else if (core.autoStopReason == 'data')
          // The caretaker ended the session: the data limit.
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _problemBoxWidth),
              child: _ProblemBox(
                text: l.autoStoppedData(settings.dataLimitMb),
                color: StatusColors.busy,
                icon: Icons.data_usage_rounded,
              ),
            ),
          )
        else
          // A start failure's hint is general; the core's reason is on
          // hover or a long press.
          Tooltip(
            message: !status.connectPending && status.state.phase == Phase.error
                ? status.state.message
                : '',
            child: Text(
              !on ? l.tapToConnect : look.hint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: p.muted),
            ),
          ),
        if (failure?.code == Failure.unreachable && onOpenConnection != null)
          _ConnectionSettingsButton(onPressed: onOpenConnection!),
        if (failure?.code == Failure.upstreamProxy &&
            onOpenUpstreamProxy != null)
          _ConnectionSettingsButton(
            onPressed: onOpenUpstreamProxy!,
            label: AppLocalizations.of(context).upstreamProxy,
          ),
        if (!connected &&
            status.upstreamProxy.isNotEmpty &&
            failure?.code != Failure.upstreamProxy)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: _UpstreamProxyPill(
                address: status.upstreamProxy,
                palette: p,
                onPressed: onOpenUpstreamProxy,
              ),
            ),
          ),
        if (isLocationRefused(failure?.code ?? '') ||
            (gaveUp && isLocationRefused(status.connectFailure)))
          _RecommendedLocationButton(core: core),
        if (connected && mismatch != null) _ExitMismatchNote(text: mismatch),
        if (status.systemProxySet && status.systemProxyTakenBy != null)
          _SystemProxyTakenNote(core: core, by: status.systemProxyTakenBy!),
        if (status.state.proxyPortBlocked) ...[
          const SizedBox(height: 12),
          Center(
            child: FilledButton.tonalIcon(
              onPressed: () async {
                final port = await showPortDialog(
                  context,
                  taken: status.state.address,
                );
                if (port != null && context.mounted) {
                  await runShowingErrors(
                    context,
                    () => core.setProxyPort(port),
                  );
                }
              },
              icon: const Icon(Icons.settings_ethernet_rounded),
              label: Text(l.changePort),
            ),
          ),
        ],
        const SizedBox(height: 16),
        // The same choice as the button and the tray, by name, where this
        // computer has more than proxy only.
        if (status.systemProxySupported || status.tunSupported)
          Center(
            child: _ModeSwitch(
              palette: p,
              accent: accent,
              selected: _mode,
              onSelected: core.switchingProxy || core.installingTun
                  ? null
                  : (mode) => chooseConnectionMode(context, core, mode),
              modes: [
                (
                  value: 'clear',
                  icon: Icons.settings_ethernet_rounded,
                  label: l.modeProxy,
                  // Where apps set up by hand find the proxy, which always
                  // runs.
                  tooltip: _running && proxy != null
                      ? '${l.proxyServiceActive} · ${proxy.listen}'
                      : '',
                ),
                if (status.systemProxySupported)
                  (
                    value: 'set',
                    icon: Icons.computer_rounded,
                    label: l.systemProxy,
                    tooltip: '',
                  ),
                if (status.tunSupported)
                  (
                    value: 'tun',
                    icon: Icons.vpn_lock_rounded,
                    label: l.modeTun,
                    tooltip: '',
                  ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Text(
          // Windows names itself; Linux and macOS say "the system".
          connectionModeHint(
            l,
            status,
            installing: core.installingTun,
            windows: defaultTargetPlatform == TargetPlatform.windows,
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: p.muted),
        ),
        TunNote(
          core: core,
          box: (text, tooltip) => _ProblemBox(
            text: text,
            color: StatusColors.busy,
            icon: Icons.warning_amber_rounded,
            tooltip: tooltip,
          ),
        ),
        const SizedBox(height: 24),
        _UpdateNotice(core: core, settings: settings, palette: p),
        _UdpNotice(status: status, settings: settings, palette: p),
        _Notices(notices: homeNotices(status.notices)),
        _LowQuotaNotice(
          core: core,
          status: status,
          settings: settings,
          connected: connected,
          palette: p,
        ),
        // Side by side when there is room.
        LayoutBuilder(
          builder: (context, box) => box.maxWidth >= 560
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 12),
                      Expanded(child: cards[1]),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [cards[0], const SizedBox(height: 12), cards[1]],
                ),
        ),
      ],
    );
  }
}

/// A small frosted pill on the home background.
class _HomePill extends StatelessWidget {
  const _HomePill({required this.palette, required this.child, this.onTap});

  final _HomePalette palette;
  final Widget child;

  /// Set where the pill answers a tap — the public IP's copy.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: ShapeDecoration(
        color: palette.card,
        shape: StadiumBorder(side: BorderSide(color: palette.cardBorder)),
      ),
      child: child,
    );
    if (onTap == null) return pill;
    return Tooltip(
      message: AppLocalizations.of(context).copyIp,
      child: Material(
        color: palette.card,
        shape: StadiumBorder(side: BorderSide(color: palette.cardBorder)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: pill),
      ),
    );
  }
}

/// While the upstream proxy is on: says so whatever the connection's state, with
/// its address on hover or a long press, and opens its settings.
class _UpstreamProxyPill extends StatelessWidget {
  const _UpstreamProxyPill({
    required this.address,
    required this.palette,
    this.onPressed,
  });

  final String address;
  final _HomePalette palette;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: ltr(address),
    child: Material(
      color: palette.card,
      shape: StadiumBorder(side: BorderSide(color: palette.cardBorder)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lan_outlined, size: 16, color: palette.connected),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context).upstreamProxyOn,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: palette.muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A connection mode in [_ModeSwitch]; an empty tooltip shows none.
typedef _Mode = ({String value, IconData icon, String label, String tooltip});

/// The connection modes as one rounded track with no lines between them:
/// the chosen mode sits on a pill that slides to the one tapped. The modes
/// are equally wide (the widest one's width), and the whole track shrinks
/// to fit a narrow window. A tap on the chosen mode changes nothing.
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.palette,
    required this.accent,
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final _HomePalette palette;
  final Color accent;
  final List<_Mode> modes;
  final String selected;

  /// Null while a change is under way.
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final theme = Theme.of(context);
    final n = modes.length;
    final index = modes.indexWhere((m) => m.value == selected);
    final still = MediaQuery.of(context).disableAnimations;
    final onSelected = this.onSelected;
    Widget option(_Mode m) {
      final chosen = m.value == selected;
      final color = chosen ? p.text : p.muted;
      Widget child = InkWell(
        customBorder: const StadiumBorder(),
        onTap: onSelected == null || chosen
            ? null
            : () {
                AppSounds.play(SoundCue.tap);
                onSelected(m.value);
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(m.icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                m.label,
                maxLines: 1,
                softWrap: false,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: chosen ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
      if (m.tooltip.isNotEmpty) {
        child = Tooltip(message: m.tooltip, child: child);
      }
      return Semantics(
        button: true,
        selected: chosen,
        enabled: onSelected != null,
        child: child,
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: AnimatedOpacity(
        opacity: onSelected == null ? 0.6 : 1,
        duration: const Duration(milliseconds: 150),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: p.card,
            shape: StadiumBorder(side: BorderSide(color: p.cardBorder)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            // The row is as wide as its widest mode times their number
            // (each mode Expanded under IntrinsicWidth), so the pill is one
            // mode wide wherever it is.
            child: IntrinsicWidth(
              child: Stack(
                children: [
                  if (index >= 0)
                    Positioned.fill(
                      child: AnimatedAlign(
                        alignment: AlignmentDirectional(
                          n == 1 ? 0 : -1 + 2 * index / (n - 1),
                          0,
                        ),
                        duration: still
                            ? Duration.zero
                            : const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        child: FractionallySizedBox(
                          widthFactor: 1 / n,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: accent.withValues(alpha: 0.2),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: accent.withValues(alpha: 0.35),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // A line between two modes, so each reads as a button of
                  // its own; none beside the pill, which marks its mode.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Row(
                        children: [
                          for (var i = 0; i < n; i++)
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: i == n - 1
                                    ? null
                                    : AnimatedOpacity(
                                        opacity: i == index || i + 1 == index
                                            ? 0
                                            : 1,
                                        duration: still
                                            ? Duration.zero
                                            : const Duration(milliseconds: 180),
                                        child: Container(
                                          width: 1.2,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: p.muted.withValues(
                                              alpha: 0.45,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              1,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: Row(
                      children: [
                        for (final m in modes) Expanded(child: option(m)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Where the traffic goes: the flag and the country, under how the
/// location is chosen (a sparkle for the app's choice); a tap opens the
/// server list.
class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.palette,
    required this.place,
    required this.accent,
    this.onTap,
    this.compact = false,
  });

  final _HomePalette palette;
  final HomePlace place;
  final Color accent;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = palette;
    return _HomeCard(
      palette: p,
      onTap: onTap,
      compact: compact,
      // As tall as the data card's ring, so the two cards match.
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _homeCardContent(compact)),
        child: Row(
          children: [
            CountryFlag(code: place.flag, width: compact ? 34 : 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (place.auto) ...[
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: accent,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          place.caption,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: place.auto ? accent : p.muted,
                            fontWeight: place.auto ? FontWeight.w600 : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.name,
                    style:
                        (compact
                                ? theme.textTheme.titleSmall
                                : theme.textTheme.titleMedium)
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: p.text,
                            ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: p.muted),
          ],
        ),
      ),
    );
  }
}

class _HomePalette {
  const _HomePalette({
    required this.dark,
    required this.top,
    required this.bottom,
    required this.text,
    required this.muted,
    required this.card,
    required this.cardBorder,
    required this.idle,
    required this.connected,
    required this.busy,
    required this.error,
    required this.discOff,
    required this.discOffEdge,
  });

  final bool dark;
  final Color top;
  final Color bottom;
  final Color text;
  final Color muted;
  final Color card;
  final Color cardBorder;
  final Color idle;
  final Color connected;
  final Color busy;
  final Color error;
  final List<Color> discOff;
  final Color discOffEdge;

  static const night = _HomePalette(
    dark: true,
    top: Color(0xFF0A0A0A),
    bottom: Colors.black,
    text: Colors.white,
    muted: Color(0xFF9E9E9E),
    card: Color(0xFF141414),
    cardBorder: Color(0xFF282828),
    idle: Color(0xFF8A8A8A),
    connected: Colors.white,
    busy: Color(0xFFBFBFBF),
    error: Colors.white,
    discOff: [Color(0xFF161616), Color(0xFF050505)],
    discOffEdge: Color(0xFF2E2E2E),
  );

  static const day = _HomePalette(
    dark: false,
    top: Colors.white,
    bottom: Color(0xFFF6F6F6),
    text: Color(0xFF0A0A0A),
    muted: Color(0xFF6B6B6B),
    card: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE4E4E4),
    idle: Color(0xFF6B6B6B),
    connected: Color(0xFF0A0A0A),
    busy: Color(0xFF8A8A8A),
    error: Color(0xFF0A0A0A),
    discOff: [Colors.white, Color(0xFFF1F1F1)],
    discOffEdge: Color(0xFFD6D6D6),
  );

  /// The palette with the chosen accent in the state's lights (connected,
  /// error); the surfaces, the ink and the grays stay as they are.
  _HomePalette tinted(Color accent) => _HomePalette(
    dark: dark,
    top: top,
    bottom: bottom,
    text: text,
    muted: muted,
    card: card,
    cardBorder: cardBorder,
    idle: idle,
    connected: accentForTheme(accent, dark),
    busy: busy,
    error: accentForTheme(accent, dark),
    discOff: discOff,
    discOffEdge: discOffEdge,
  );
}

/// The home's palette for this build: night or day, in the design the
/// home wears — the monochrome's own colors, or the chosen design's
/// surfaces — with the resolved light ([AppAccent], the design's own or
/// the user's pick) in the state's colors when one stands.
_HomePalette _homePalette(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final look = AppDesign.current.look(dark);
  // The state's neutral lights stay the monochrome's: connecting is
  // deliberately unlit, and the accent (when one stands) takes the rest.
  final p = _HomePalette(
    dark: dark,
    top: look.homeTop,
    bottom: look.homeBottom,
    text: look.ink,
    muted: look.muted,
    card: look.homeCard,
    cardBorder: look.homeCardBorder,
    idle: dark ? _HomePalette.night.idle : _HomePalette.day.idle,
    connected: look.ink,
    busy: dark ? _HomePalette.night.busy : _HomePalette.day.busy,
    error: look.ink,
    discOff: dark
        ? [look.surfaceHigh, look.scaffold]
        : [look.homeCard, look.homeBottom],
    discOffEdge: look.outline,
  );
  final accent = AppAccent.current;
  return accent == null ? p : p.tinted(accent);
}

/// The phone's home: the switch in the middle over soft lights and wavy
/// contour lines in the state's color, the state under it, then where the
/// traffic goes and the data used. Light or dark with the app's theme; the
/// email is on the accounts page.
/// Pins or unpins a country in the flag wheel: the wheel leads with the
/// pinned ones, and the launcher's long-press menu carries the first four
/// as "connect here" shortcuts.
Future<void> _toggleFavorite(
  BuildContext context,
  CoreController core,
  AppSettings settings,
  String code,
) async {
  final was = List<String>.of(settings.favoriteCountries);
  final lower = was.map((c) => c.toLowerCase()).toList();
  final pinned = lower.contains(code.toLowerCase());
  final next = pinned
      ? [
          for (final c in was)
            if (c.toLowerCase() != code.toLowerCase()) c,
        ]
      : [...was, code];
  settings.update(favoriteCountries: next);
  HapticFeedback.selectionClick();
  AppSounds.play(SoundCue.tap);
  if (defaultTargetPlatform == TargetPlatform.android) {
    final l = AppLocalizations.of(context);
    unawaited(
      AndroidCore.setShortcuts([
        for (final code in next.take(4))
          {'code': code, 'name': countryName(l, code)},
      ]).catchError((_) {}),
    );
  }
  if (context.mounted) {
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pinned ? l.favoriteUnpinned : l.favoritePinned),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _PhoneHome extends StatelessWidget {
  const _PhoneHome({
    required this.core,
    required this.status,
    required this.showIp,
    required this.settings,
    this.onOpenServers,
    this.onOpenAccounts,
    this.onOpenConnection,
    this.onOpenUpstreamProxy,
  });

  final CoreController core;
  final CoreStatus status;

  /// Settings, Show the public IP.
  final bool showIp;
  final AppSettings settings;
  final VoidCallback? onOpenServers;
  final VoidCallback? onOpenAccounts;
  final VoidCallback? onOpenConnection;
  final VoidCallback? onOpenUpstreamProxy;

  bool get _switchSystemProxy =>
      status.systemProxySupported &&
      !status.connectPending &&
      status.connectFailure.isEmpty;

  Future<void> _toggle(bool on) async {
    if (_switchSystemProxy) {
      await core.setSystemProxy(on ? 'clear' : 'set');
    } else {
      await core.setOn(!on);
    }
    if (!on) _testAfterPowerOn(core);
  }

  @override
  Widget build(BuildContext context) {
    final p = _homePalette(Theme.of(context).brightness);
    final l = AppLocalizations.of(context);
    // The status bar's own height: the clock's veil under the scroll
    // reads its reach from it.
    final top = MediaQuery.paddingOf(context).top;
    // The home's map kind, read once: the world carries it, and the
    // wheel's name rides on whether the kind has a floating card of its
    // own (the ball kinds) or not (the flat kinds).
    final mapKind =
        MapKind.values.asNameMap()[settings.mapKind] ?? MapKind.classic;
    final page = AnnotatedRegion<SystemUiOverlayStyle>(
      value: (p.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.top, p.bottom],
          ),
        ),
        // The world behind the switch (world_map.dart): in the kind the
        // settings picked — the flat map as it always was, the flat map's
        // modern finish, the metal ball, or the satellite's earth — the
        // countries' own official outlines, the chosen country lit in the
        // state's color, and the change of country a soft flight while
        // the VPN carries the traffic.
        child: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder<List<WorldCountry>>(
                future: WorldMap.load(),
                builder: (context, snapshot) {
                  final selectedCode =
                      (status.exit?.countryCode.isNotEmpty == true
                              ? status.exit!.countryCode
                              : status.selection)
                          .toUpperCase();
                  // A boundary of its own: the map redraws every frame it
                  // breathes, and this keeps that redraw inside the map —
                  // the page's own content never repaints for it.
                  return RepaintBoundary(
                    child: WorldBackdrop(
                      kind: mapKind,
                      countries: snapshot.data ?? const [],
                      accent: status.state.phase == Phase.running
                          ? p.connected
                          : p.idle,
                      selected: selectedCode,
                      animated: status.state.phase == Phase.running,
                      dark: p.dark,
                      label: selectedCode.length == 2
                          ? countryName(l, selectedCode)
                          : '',
                      style:
                          GlobeStyle.values.asNameMap()[settings.mapStyle] ??
                          GlobeStyle.silver,
                      still: settings.batterySaver,
                      // The land drawn in the design's own ink: the
                      // paper's warm brown, the violet night's gray, the
                      // tonal blue-gray — the monochrome keeps its own.
                      ink: AppDesign.current.look(p.dark).ink,
                    ),
                  );
                },
              ),
            ),
            LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight),
                  child: IntrinsicHeight(child: _content(context, p, box)),
                ),
              ),
            ),
            // The clock's own veil: when the page scrolls, the content
            // that slides under the status bar fades out beneath it — the
            // iOS way — instead of colliding with the clock and the
            // battery. The veil is a full breath tall now and holds its
            // color solid across the clock's own band before it lets go,
            // so the card and the orb that ride under it fade whole —
            // their words never meet the clock's. The veil's color is the
            // page's own top, so on a resting page (whose content starts
            // below it anyway) it is invisible: nothing changes there,
            // only the scrolled state gains its readability back.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: top + 46,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [p.top, p.top.withValues(alpha: 0)],
                      stops: const [0.42, 1],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final content = switch (DesignStyle.of(context).nav) {
      // The zed's own signature on the phone: the two violet FABs that
      // ride the screen's edge — the servers' map and the speed test —
      // dragged by hand, snapping back with the bounce.
      NavVariant.floatingDock => Stack(
        children: [
          page,
          Positioned.fill(
            child: ZedFabCluster(
              onOpenServers: () => onOpenServers?.call(),
              onOpenSpeedTest: () => showSpeedTest(context, core, settings),
            ),
          ),
        ],
      ),
      _ => page,
    };
    return p.dark
        ? Theme(data: midnightTheme(Theme.of(context)), child: content)
        : content;
  }

  Widget _content(BuildContext context, _HomePalette p, BoxConstraints box) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final look = PhaseLook.of(l, status);
    // The home's map kind here too: the wheel's name rides on whether
    // the kind has a floating card of its own (the ball kinds) or not
    // (the flat kinds).
    final mapKind =
        MapKind.values.asNameMap()[settings.mapKind] ?? MapKind.classic;
    final running = status.state.phase == Phase.running;
    final canSwitch = status.systemProxySupported;
    final width = box.maxWidth;
    // A wide, low screen (a TV, 960 x 540): a smaller switch and the two
    // cards side by side, so that all of it shows without scrolling.
    final short = box.maxHeight < 560 && width >= 600;
    // On a tablet the content keeps about a phone's width in the middle (the
    // colors still reach the edges), and the problem boxes their own limit.
    // Both as padding, since IntrinsicHeight measures through padding but
    // not through a width limit.
    final side = math.max(20.0, (width - (short ? 720 : 560)) / 2);
    final boxSide = math.max(0.0, (width - 2 * side - _problemBoxWidth) / 2);
    Widget problem(Widget box) => Padding(
      padding: EdgeInsets.symmetric(horizontal: boxSide),
      child: box,
    );
    // A computer's narrow window: on while the system proxy or TUN mode
    // carries the apps.
    final on = _switchSystemProxy
        ? status.systemProxySet || status.tunMode
        : status.proxyOn;
    final proxy = status.proxy;
    // The phone's VPN is "Connecting", in orange, until a test confirms it
    // works (the controller tests again meanwhile): with no internet it
    // does not claim to be connected.
    final confirming =
        status.connectPending ||
        (on && running && !canSwitch && !status.confirmedBy(core.lastTest));
    final test = status.isCurrentTest(core.lastTest) ? core.lastTest : null;
    final noNetwork = !status.connectPending && status.noNetwork && on;
    final failing =
        !status.connectPending &&
        confirming &&
        ((proxy?.wakeError.isNotEmpty ?? false) || test?.ok == false);
    // The real reason; a long press or hover shows the core's own text.
    final failure = failing ? failureText(l, proxy, test) : null;
    // The last connect was given up: why, until the next one.
    final gaveUp = !on && status.connectFailure.isNotEmpty;
    final connected =
        on && running && (status.computerUsesVpn || !canSwitch) && !confirming;
    final ip = !showIp
        ? ''
        : status.exit?.ipv4.isNotEmpty == true
        ? status.exit!.ipv4
        : status.exit?.ipv6 ?? '';
    final proxyOnly = Platform.isAndroid && AndroidCore.mode.value == 'proxy';
    final accent = !on
        ? p.idle
        : confirming
        ? p.busy
        : switch (status.state.phase) {
            Phase.running => p.connected,
            Phase.error => p.error,
            _ => p.busy,
          };
    final label = confirming ? l.stateConnecting : look.label;
    // A TV's remote presses OK; a phone is tapped.
    final tv = Platform.isAndroid && AndroidCore.isTv;
    final press = on
        ? (tv ? l.tapToDisconnectTv : l.tapToDisconnectPhone)
        : (tv ? l.tapToConnectTv : l.tapToConnectPhone);
    final place = homeLocation(l, status, connected: connected);
    final mismatch = exitMismatchText(l, status);
    final top = MediaQuery.paddingOf(context).top;
    // The design the user chose for this home: the wheel, the tiles, the
    // compact card, or one of the four looks that carry a palette of
    // their own — the aurora's glass, the neon's ring, the dusk's banner,
    // the sage's ledger. Everything the designs share (the problem boxes,
    // the notices, the data) stays put; what changes is how the own
    // things are laid out: the place, the switch, and the numbers.
    final design = settings.homeDesign;
    return Padding(
      // The bottom clears the floating navigation, which the page runs
      // beneath — with room to breathe, not a dead band: the cards sit
      // close above it. The two newer designs' docks sit taller than the
      // pill (their own seat plus the dock), so they ask for their own
      // deeper margin — otherwise the page's last cards end up half
      // under the dock when the page scrolls to its end.
      padding: EdgeInsets.fromLTRB(
        side,
        top + 14,
        side,
        // The pages run under the navigation: the floating pill asks for
        // 72, the docks and the M3 bar (the bar is tall, its labels ride
        // with it) ask for 104, and the iOS tab bar — glued to the edge,
        // its labels under the icons — clears at 84.
        design == 'aether' || design == 'zed' || design == 'pixel'
            ? 104
            : design == 'ios'
            ? 84
            : 72,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The brand: the official wordmark, in the theme's face — the
          // gazette's masthead carries it instead, so the wordmark rests
          // there and the page opens like a paper, not a screen.
          if (design != 'gazette')
            Reveal(index: 0, child: Center(child: BrandWordmark(height: 24))),
          if (design == 'wheel') ...[
            // The wheel sits a touch lower than the wordmark: a breath of
            // space under the brand before the flags begin.
            const SizedBox(height: 30),
            // The countries' wheel: drag to the one the traffic leaves
            // from; it is the servers page's choice, read from the core.
            Reveal(
              index: 1,
              child: RepaintBoundary(
                child: FlagCarousel(
                  core: core,
                  text: p.text,
                  muted: p.muted,
                  card: p.card,
                  border: p.cardBorder,
                  onOpenServers: onOpenServers,
                  // The wheel's glow breathes only while the connection
                  // carries (or is on its way): off, it holds one pose and
                  // the phone's battery keeps the frames.
                  animated: connected || confirming,
                  still: settings.batterySaver,
                  showName: mapKind != MapKind.globe,
                  favorites: settings.favoriteCountries,
                  onToggleFavorite: (code) =>
                      _toggleFavorite(context, core, settings, code),
                ),
              ),
            ),
            const Spacer(),
            // The hero (the state's word, the switch, its cards) sits a
            // touch under the middle: 3.4% of the page's height lower. The
            // box is twice that, and the two spacers each give up half of
            // it — the group keeps its distances, only lower.
            SizedBox(height: math.max(0.0, box.maxHeight * 0.068)),
            SizedBox(height: short ? 4 : 16),
          ] else if (design == 'bento') ...[
            // The tiles' home: the flags in their strip under the brand.
            const SizedBox(height: 26),
            Reveal(
              index: 1,
              child: FlagStrip(
                core: core,
                text: p.text,
                border: p.cardBorder,
                accent: accent,
              ),
            ),
            const SizedBox(height: 26),
          ] else if (design == 'aether') ...[
            // The aether's home: the flags in their strip too, above the
            // status card that carries the switch. The card names the
            // place itself, so the strip's own name line rests — the
            // page says the place once.
            const SizedBox(height: 24),
            Reveal(
              index: 1,
              child: RepaintBoundary(
                child: FlagStrip(
                  core: core,
                  text: p.text,
                  border: p.cardBorder,
                  accent: accent,
                  showName: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ] else if (design == 'zed') ...[
            // The zed's home wears the reference's own opening: the two
            // rate cards under the brand — alive with the session's
            // numbers when the tunnel carries, resting at their zeros
            // when it does not, the way the reference's own pair stands
            // on the page whatever the connection says — then the flags'
            // strip, whose name line rests: the server card under the
            // blob names the place, and one page says it once.
            if (settings.showTraffic) ...[
              const SizedBox(height: 18),
              Reveal(
                index: 1,
                child: RepaintBoundary(
                  child: _ZedRatePair(palette: p, traffic: status.traffic),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Reveal(
              index: 1,
              child: RepaintBoundary(
                child: FlagStrip(
                  core: core,
                  text: p.text,
                  border: p.cardBorder,
                  accent: accent,
                  showName: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ] else if (design == 'gazette') ...[
            // The gazette's opening: the masthead — the double rule, the
            // brand riding the middle between the day's line and the
            // edition's number, the bulletin's tag under them — then the
            // flags' strip, ruled like the paper's own region box.
            const SizedBox(height: 10),
            Reveal(
              index: 0,
              child: GazetteMasthead(
                brand: BrandWordmark(height: 22),
                dateLine: gazetteDateLine(l, DateTime.now()),
                edition: l.gazetteEdition(gazetteEditionNo()),
                bulletin: l.gazetteBulletin,
                ink: p.text,
                muted: p.muted,
                rule: p.cardBorder,
              ),
            ),
            const SizedBox(height: 18),
            Reveal(
              index: 1,
              child: RepaintBoundary(
                child: FlagStrip(
                  core: core,
                  text: p.text,
                  border: p.cardBorder,
                  accent: accent,
                  showName: false,
                ),
              ),
            ),
            const SizedBox(height: 22),
          ] else if (design == 'ios') ...[
            // The iOS home's opening: the flags in their strip above the
            // status card — the card names the place itself, so the
            // strip's own name line rests, the way the system keeps one
            // word per thing.
            const SizedBox(height: 24),
            Reveal(
              index: 1,
              child: RepaintBoundary(
                child: FlagStrip(
                  core: core,
                  text: p.text,
                  border: p.cardBorder,
                  accent: accent,
                  showName: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ] else ...[
            // The compact home: its place is a chip in its own card
            // below; here only the space the card breathes in.
            const SizedBox(height: 24),
          ],
          // The state, in words, where the island used to live. The tiles'
          // home carries it inside its connect bar instead. Here it wears
          // its own capsule over the map: the word gets the layer it
          // never had, and the state's dot before it says the state at a
          // glance — a quiet pulse while the connection is still being
          // made.
          // The dusk's banner said the state's word inside itself; now the
          // aether's status card does, and the zed wears the reference's
          // own big word under the blob instead, so all three skip the
          // capsule here.
          // The wheel's home says the state once — in the slider's own
          // track. The capsule above it repeated the same word the track
          // was already carrying ("Connecting…" stacked on "Connecting…",
          // "Connected" under "Connected"), so on the wheel it leaves.
          if (design != 'wheel' &&
              design != 'bento' &&
              design != 'aether' &&
              design != 'zed' &&
              design != 'gazette' &&
              design != 'ios')
            Reveal(
              index: 1,
              child: Center(
                child: StatusCapsule(
                  dark: p.dark,
                  dot: true,
                  dotColor: accent,
                  dotBreathes: confirming,
                  child: CrossfadeText(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                      height: 1.15,
                      // The state's word wears the display's own voice —
                      // the face nobody would mistake for the phone's.
                      fontFamily: typefacesOf(context).display,
                      fontFamilyFallback: typefacesOf(context).displayFallback,
                      // The dot carries the state's color; the word itself
                      // stays at full contrast while nothing is confirmed
                      // yet, so "Connecting…" reads clearly in both themes.
                      color: confirming ? p.text : (on ? accent : p.text),
                    ),
                  ),
                ),
              ),
            ),
          if (design == 'wheel') ...[
            const SizedBox(height: 14),
            Reveal(
              index: 2,
              child: Center(
                child: SlideToConnect(
                  on: on,
                  // The whole connection's walk, not only the proxy's
                  // swap: the knob's spinner and the track's own word
                  // stand while the tunnel is still being made.
                  busy: core.switchingProxy || status.connectPending,
                  accent: accent,
                  dark: p.dark,
                  card: p.card,
                  border: p.cardBorder,
                  text: p.text,
                  muted: p.muted,
                  labelConnect: l.slideToConnect,
                  labelDisconnect: l.slideToDisconnect,
                  // The state's word stays in the track once connected;
                  // while the connection is still being made — the walk
                  // AND the confirmation wait after it — the track keeps
                  // the connecting word. The old empty window was exactly
                  // between the two: the tunnel was up, the test had not
                  // said so yet, and the words left the track bare.
                  labelOn: confirming ? l.stateConnecting : l.stateConnected,
                  labelBusy: l.stateConnecting,
                  tooltip: press,
                  // The commit's knock answers to the vibration setting.
                  haptic: settings.hapticFeedback,
                  // A TV starts on the switch, its ring showing.
                  autofocus: Platform.isAndroid && AndroidCore.isTv,
                  // No account yet: the accounts page, which explains
                  // them and links to Mozilla's sign-up.
                  onPressed: () => status.totalAccounts == 0
                      ? _openAccounts(context, core, settings, onOpenAccounts)
                      : runShowingErrors(context, () => _toggle(on)),
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 14),
          ] else if (design == 'bento') ...[
            // The tiles' switch: one wide tile, the power's circle beside
            // the state's own word — a tap on any of it flips the VPN.
            Reveal(
              index: 2,
              child: Center(
                child: _BentoConnectBar(
                  palette: p,
                  on: on,
                  busy: core.switchingProxy || status.connectPending,
                  accent: accent,
                  label: label,
                  hint: press,
                  onPressed: () => status.totalAccounts == 0
                      ? _openAccounts(context, core, settings, onOpenAccounts)
                      : runShowingErrors(context, () => _toggle(on)),
                ),
              ),
            ),
            SizedBox(height: short ? 12 : 18),
          ] else if (design == 'aether') ...[
            // The aether's hero: the iOS status card AetherST wears — the
            // raised card with the state's own light washing down from
            // its top, the state's dot and word on the first line, the
            // session's time big when the tunnel carries, and the
            // morphing power button (circle when off, rounded square
            // when on) under them.
            Flexible(
              // The hero's stage: the card and the button keep their
              // design size on a tall screen and step down, whole and
              // together, when the page runs tight — the page never
              // pushes its own bottom cards under the dock.
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Reveal(
                    index: 2,
                    child: _AetherHeroCard(
                      palette: p,
                      place: place,
                      on: on,
                      busy: core.switchingProxy || status.connectPending,
                      error: status.state.phase == Phase.error,
                      tooltip: press,
                      label: label,
                      hint: press,
                      startedAt: proxy?.startedAt,
                      pingMs: (test?.ok ?? false) ? test!.responseMs : null,
                      traffic: status.traffic,
                      showTraffic: settings.showTraffic,
                      batterySaver: settings.batterySaver,
                      onOpenServers: onOpenServers,
                      testing: core.testing,
                      onTest: () => runShowingErrors(context, core.runTest),
                      onPressed: () => status.totalAccounts == 0
                          ? _openAccounts(
                              context,
                              core,
                              settings,
                              onOpenAccounts,
                            )
                          : runShowingErrors(context, () => _toggle(on)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 18),
          ] else if (design == 'zed') ...[
            // The zed's hero: the gradient blob ZedSecure wears — one
            // breathing orb painted with the brand's own light (violet,
            // pink, lime) when the tunnel carries, the cooler cyan swell
            // while it is being made, the dim violet when it rests. The
            // session's time stands in the middle when it carries, the
            // power's mark when it rests — nothing under it, the way the
            // reference's orb stands alone.
            Flexible(
              // The hero's stage: the reference lets its orb shrink with
              // the stage's own height (its stage * 0.58 cap) instead of
              // shoving the page under the dock — the FittedBox does the
              // same here: the orb keeps its design size on a tall screen
              // and steps down, whole, when the page is tight, so the
              // cards below keep their places above the dock.
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Reveal(
                    index: 2,
                    child: RepaintBoundary(
                      child: _ZedBlobCard(
                        palette: p,
                        on: on,
                        busy: core.switchingProxy || status.connectPending,
                        tooltip: press,
                        startedAt: proxy?.startedAt,
                        batterySaver: settings.batterySaver,
                        onPressed: () => status.totalAccounts == 0
                            ? _openAccounts(
                                context,
                                core,
                                settings,
                                onOpenAccounts,
                              )
                            : runShowingErrors(context, () => _toggle(on)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: short ? 6 : 12),
            // The state's word, the reference's own voice: the display's
            // big face under the orb — the word the small capsule could
            // never carry — with the tap's word quiet beneath it, and
            // nothing else, so the page's middle reads as one breath.
            Reveal(
              index: 3,
              child: Column(
                children: [
                  CrossfadeText(
                    label,
                    textAlign: TextAlign.center,
                    style:
                        (theme.textTheme.headlineLarge ??
                                const TextStyle(fontSize: 34))
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              letterSpacing: 0.3,
                              fontFamily: typefacesOf(context).display,
                              fontFamilyFallback: typefacesOf(context)
                                  .displayFallback,
                              color: confirming
                                  ? p.text
                                  : (on ? accent : p.text),
                            ),
                  ),
                  if (!on && !confirming) ...[
                    const SizedBox(height: 5),
                    Text(
                      press,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: p.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: short ? 12 : 18),
            // The server card, the reference's bright pill over the dock:
            // the place's name bold with the change's word muted beneath,
            // and a white circle with the globe's glyph at its end — a
            // tap opens the servers page, the way the reference's own
            // card answers. The place's small chip under the orb retires:
            // this card says the place, and one page says it once.
            Reveal(
              index: 3,
              child: RepaintBoundary(
                child: _ZedServerCard(
                  palette: p,
                  place: place,
                  onOpenServers: onOpenServers,
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 18),
          ] else if (design == 'gazette') ...[
            // The gazette's hero: the front page — the headline (the
            // state's word, typed by the wire) with the measured delay's
            // stamp beside it, the slider's commit under a rule, and the
            // session's numbers in their ruled columns. The live wire's
            // tape walks under the page while the tunnel carries.
            Flexible(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Reveal(
                    index: 2,
                    child: RepaintBoundary(
                      child: GazetteFrontPage(
                        headline: label,
                        headlineStyle: (theme.textTheme.headlineLarge ??
                                const TextStyle(fontSize: 32))
                            .copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              fontFamily: typefacesOf(context).display,
                              fontFamilyFallback: typefacesOf(context)
                                  .displayFallback,
                              color: confirming
                                  ? p.text
                                  : (on ? accent : p.text),
                            ),
                        stampLabel: l.realDelay,
                        stampValue: (test?.ok ?? false)
                            ? l.milliseconds(test!.responseMs)
                            : '—',
                        stampOn: connected && (test?.ok ?? false),
                        stats: [
                          (
                            l.statElapsed,
                            proxy?.startedAt != null
                                ? gazetteElapsed(proxy!.startedAt!)
                                : '—',
                          ),
                          (
                            l.statDown,
                            formatRate(status.traffic?.downRate ?? 0),
                          ),
                          (
                            l.statUp,
                            formatRate(status.traffic?.upRate ?? 0),
                          ),
                        ],
                        ink: p.text,
                        muted: p.muted,
                        rule: p.cardBorder,
                        paper: p.card,
                        display: typefacesOf(context).display,
                        displayFallback: typefacesOf(context).displayFallback,
                        accent: accent,
                        slider: SlideToConnect(
                          on: on,
                          busy: core.switchingProxy || status.connectPending,
                          accent: accent,
                          dark: p.dark,
                          card: p.card,
                          border: p.cardBorder,
                          text: p.text,
                          muted: p.muted,
                          labelConnect: l.slideToConnect,
                          labelDisconnect: l.slideToDisconnect,
                          // The headline carries the state's word, so the
                          // track carries the action's instead — one page,
                          // no word said twice.
                          labelOn: l.slideToDisconnect,
                          labelBusy: l.stateConnecting,
                          tooltip: press,
                          haptic: settings.hapticFeedback,
                          onPressed: () => status.totalAccounts == 0
                              ? _openAccounts(
                                  context,
                                  core,
                                  settings,
                                  onOpenAccounts,
                                )
                              : runShowingErrors(context, () => _toggle(on)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 12),
            // The live wire: the session's own news, walking while the
            // tunnel carries, resting when the battery saver asks.
            Reveal(
              index: 3,
              child: GazetteTicker(
                items: gazetteTickerItems(
                  l: l,
                  downRate: status.traffic?.downRate,
                  upRate: status.traffic?.upRate,
                  delay: (test?.ok ?? false)
                      ? l.milliseconds(test!.responseMs)
                      : null,
                  place: place.name,
                ),
                ink: p.text,
                muted: p.muted,
                rule: p.cardBorder,
                moving: connected && !settings.batterySaver,
              ),
            ),
            SizedBox(height: short ? 8 : 14),
          ] else if (design == 'ios') ...[
            // The iOS hero: the system's own status card — the raised
            // rounded sheet with the state's dot and word, the place's
            // cell (the flag, the name, the chevron to the servers), the
            // session's numbers in their inset-grouped table, and the
            // full-width capsule button under them. No glass, no glow:
            // the clarity is the style.
            Flexible(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Reveal(
                    index: 2,
                    child: RepaintBoundary(
                      child: _IosStatusCard(
                        palette: p,
                        place: place,
                        on: on,
                        busy: core.switchingProxy || status.connectPending,
                        error: confirming &&
                            ((proxy?.wakeError.isNotEmpty ?? false) ||
                                (test?.ok == false)),
                        label: label,
                        press: press,
                        startedAt: proxy?.startedAt,
                        pingMs: (test?.ok ?? false) ? test!.responseMs : null,
                        traffic: status.traffic,
                        showTraffic: settings.showTraffic,
                        onOpenServers: onOpenServers,
                        onPressed: () => status.totalAccounts == 0
                            ? _openAccounts(context, core, settings, onOpenAccounts)
                            : runShowingErrors(context, () => _toggle(on)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 14),
          ] else ...[
            // The compact switch: the orb, on the place's own card.
            const SizedBox(height: 14),
            Reveal(
              index: 2,
              child: Center(
                child: _PixelHomeCard(
                  palette: p,
                  place: place,
                  on: on,
                  busy: core.switchingProxy || status.connectPending,
                  tooltip: press,
                  onOpenServers: onOpenServers,
                  onPressed: () => status.totalAccounts == 0
                      ? _openAccounts(context, core, settings, onOpenAccounts)
                      : runShowingErrors(context, () => _toggle(on)),
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 18),
          ],
          // The connected section and the idle words share one seat, and
          // the seat moves as one motion between them: the numbers breathe
          // in (fade, a small lift, the room growing beneath) when the
          // tunnel carries, and walk back out when it does not. The old
          // seat swapped its faces between two frames — the cards came up
          // dry and sudden. Reduce-motion keeps the honest instant.
          SmoothEnter(
            show: connected,
            // The faces force the seat's full width: the switcher's stack
            // loosens its children, and a lone Text would narrow the seat
            // instead of filling it as the page's own column does.
            shown: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // The connection's numbers, in the page itself: the time
                // it has been up, the real delay, the live rates. The wheel
                // and the tiles lay them out as cards; the compact home as
                // rows inside one card of its own; the zed's pair lives at
                // the page's top, the reference's own place for it; the
                // iOS card carries its own table inside the hero.
                if (design == 'pixel')
                  RepaintBoundary(
                    child: _FlatStats(
                      core: core,
                      status: status,
                      palette: p,
                      startedAt: proxy?.startedAt,
                      pingMs: (test?.ok ?? false) ? test!.responseMs : null,
                      showTraffic: settings.showTraffic,
                      showConnection: true,
                    ),
                  )
                else if (design != 'aether' &&
                    design != 'zed' &&
                    design != 'ios')
                  // The aether's card carries the time, the ping and the two
                  // rates itself (the reference's own rows); its page keeps
                  // no second numbers card under them.
                  RepaintBoundary(
                    child: _HomeStats(
                      core: core,
                      status: status,
                      palette: p,
                      settings: settings,
                      startedAt: proxy?.startedAt,
                      pingMs: (test?.ok ?? false) ? test!.responseMs : null,
                      showTraffic: settings.showTraffic,
                    ),
                  ),
                if (ip.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _HomeRow(
                      palette: p,
                      icon: Icons.public_rounded,
                      label: l.publicIp,
                      value: ltr(ip),
                      // The address is the kind of thing a report needs: a
                      // tap carries it to the clipboard, and a word says so.
                      onTap: () => _copyPublicIp(context, ip),
                      trailing: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: p.muted,
                        ),
                      ),
                    ),
                  ),
                if (status.upstreamProxy.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: _UpstreamProxyPill(
                        address: status.upstreamProxy,
                        palette: p,
                        onPressed: onOpenUpstreamProxy,
                      ),
                    ),
                  ),
              ],
              ),
            ),
            hidden: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                if (failing || noNetwork || gaveUp)
                  // Not connecting stands out from the ordinary hints.
                  problem(
                    _ProblemBox(
                      text: noNetwork
                          ? l.noNetwork
                          : failure != null
                          ? failure.text
                          : failureCodeText(l, status.connectFailure),
                      color: p.error,
                      icon: Icons.error_outline_rounded,
                      tooltip: noNetwork ? '' : failure?.detail ?? '',
                    ),
                  )
                else if (core.autoStopReason == 'idle' && !noNetwork)
                  // The caretaker ended the session: the idle wait passed.
                  problem(
                    _ProblemBox(
                      text: l.autoStoppedIdle(settings.idleTimeoutMin),
                      color: StatusColors.busy,
                      icon: Icons.hourglass_bottom_rounded,
                    ),
                  )
                else if (core.autoStopReason == 'data')
                  // The caretaker ended the session: the data limit.
                  problem(
                    _ProblemBox(
                      text: l.autoStoppedData(settings.dataLimitMb),
                      color: StatusColors.busy,
                      icon: Icons.data_usage_rounded,
                    ),
                  )
                else if (design == 'bento' ||
                    design == 'aether' ||
                    design == 'zed' ||
                    design == 'ios' ||
                    confirming)
                  // The tiles' bar, the aether's status card, the zed's own
                  // word and the iOS card's button already say the tap's
                  // own hint; the plain hint line below would only say it
                  // twice. While the connection is still being made, the
                  // state's word stands alone — "tap to disconnect" under a
                  // reaching tunnel reads as noise. The state's own
                  // guidance still has the problem boxes above.
                  const SizedBox.shrink()
                else
                  // A start failure's hint is general; the core's reason is
                  // on a long press.
                  Tooltip(
                    message:
                        !status.connectPending &&
                            status.state.phase == Phase.error
                        ? status.state.message
                        : '',
                    child: Text(
                      look.hint.isNotEmpty ? look.hint : press,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: p.muted,
                      ),
                    ),
                  ),
              ],
              ),
            ),
          ),
          // Where to find the proxy, on a line of its own under the delay.
          if (connected && proxyOnly && proxy != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: _HomePill(
                  palette: p,
                  child: Text(
                    '${l.modeProxyOnly} ${ltr('127.0.0.1:${portOf(proxy.listen) ?? 10810}')}',
                    style: theme.textTheme.labelLarge?.copyWith(color: p.muted),
                  ),
                ),
              ),
            ),
          if (failure?.code == Failure.unreachable && onOpenConnection != null)
            _ConnectionSettingsButton(onPressed: onOpenConnection!),
          if (failure?.code == Failure.upstreamProxy &&
              onOpenUpstreamProxy != null)
            _ConnectionSettingsButton(
              onPressed: onOpenUpstreamProxy!,
              label: AppLocalizations.of(context).upstreamProxy,
            ),
          if (!connected &&
              status.upstreamProxy.isNotEmpty &&
              failure?.code != Failure.upstreamProxy)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: _UpstreamProxyPill(
                  address: status.upstreamProxy,
                  palette: p,
                  onPressed: onOpenUpstreamProxy,
                ),
              ),
            ),
          if (isLocationRefused(failure?.code ?? '') ||
              (gaveUp && isLocationRefused(status.connectFailure)))
            _RecommendedLocationButton(core: core),
          if (connected && mismatch != null)
            problem(_ExitMismatchNote(text: mismatch)),
          if (canSwitch &&
              status.systemProxySet &&
              status.systemProxyTakenBy != null)
            problem(
              _SystemProxyTakenNote(core: core, by: status.systemProxyTakenBy!),
            ),
          if (status.state.proxyPortBlocked) ...[
            const SizedBox(height: 12),
            Center(
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final port = await showPortDialog(
                    context,
                    taken: status.state.address,
                  );
                  if (port != null && context.mounted) {
                    await runShowingErrors(
                      context,
                      () => core.setProxyPort(port),
                    );
                  }
                },
                icon: const Icon(Icons.settings_ethernet_rounded),
                label: Text(l.changePort),
              ),
            ),
          ],
          if (running &&
              proxy != null &&
              !canSwitch &&
              sharedWithLan(proxy.listen)) ...[
            const SizedBox(height: 10),
            Center(child: _LanChip(port: portOf(proxy.listen) ?? 10810)),
          ],
          const Spacer(),
          SizedBox(height: short ? 12 : 16),
          _UpdateNotice(core: core, settings: settings, palette: p),
          _UdpNotice(status: status, settings: settings, palette: p),
          _Notices(notices: homeNotices(status.notices)),
          _LowQuotaNotice(
            core: core,
            status: status,
            settings: settings,
            connected: connected,
            palette: p,
          ),
          if (short)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _PlaceCard(
                      palette: p,
                      place: place,
                      accent: accent,
                      onTap: onOpenServers,
                      compact: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeData(
                      status: status,
                      palette: p,
                      onTap: onOpenAccounts,
                      compact: true,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            // The compact home already shows the place as the chip its
            // switch sits on; the aurora's hero, the neon's ring and the
            // sage's ledger carry it too. The wheel's, the tiles' and the
            // gazette's homes keep the place's own card down here.
            if (design == 'wheel' ||
                design == 'bento' ||
                design == 'gazette') ...[
              Reveal(
                index: 4,
                child: RepaintBoundary(
                  child: _PlaceCard(
                    palette: p,
                    place: place,
                    accent: accent,
                    onTap: onOpenServers,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // The speed test's own door on these homes: a row like the
              // rest, one tap from the measurement — a real download and
              // an upload, through the tunnel when it carries, the raw
              // network when it does not. It stands here in every state,
              // so the measurement is findable before the first connect
              // too, not only through the graph that lives with the
              // connected numbers.
              Reveal(
                index: 4,
                child: RepaintBoundary(
                  child: _HomeRow(
                    palette: p,
                    icon: Icons.speed_rounded,
                    label: l.speedTestTitle,
                    value: connected ? l.speedTestThrough : l.speedTestDirect,
                    onTap: () {
                      AppSounds.play(SoundCue.tap);
                      showSpeedTest(context, core, settings);
                    },
                    trailing: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: p.muted,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Reveal(
              index: 5,
              child: RepaintBoundary(
                child: _HomeData(
                  status: status,
                  palette: p,
                  onTap: onOpenAccounts,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A frosted card on the home background.
/// The height of the home cards' content: the data card's ring; smaller
/// on the computer, whose controls above the cards are small.
double _homeCardContent(bool compact) => compact ? 46 : 62;

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.palette,
    required this.child,
    this.onTap,
    this.compact = false,
  });

  final _HomePalette palette;
  final Widget child;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // The gazette's card wears paper instead of glass: the ruled box,
    // the near-square corners, no shadow — the rules alone hold it.
    if (AppDesign.current.key == 'gazette') {
      return PaperCard(
        ink: palette.text,
        rule: palette.cardBorder,
        paper: palette.card,
        padding: EdgeInsetsDirectional.fromSTEB(
          compact ? 14 : 16,
          compact ? 10 : 14,
          compact ? 8 : 10,
          compact ? 10 : 14,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(onTap: onTap, child: child),
        ),
      );
    }
    // The pixel's card: Material You's filled shape — the big tonal
    // surface with no outline and no glass; the radius speaks, the
    // shadow stays home.
    if (AppDesign.current.key == 'pixel') {
      return Material(
        color: AppDesign.current.look(palette.dark).containerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: compact
                ? const EdgeInsetsDirectional.fromSTEB(14, 10, 8, 10)
                : const EdgeInsetsDirectional.fromSTEB(16, 14, 10, 14),
            child: child,
          ),
        ),
      );
    }
    // The iOS card: the system's raised sheet — the surface's own white
    // (the night's raised gray), the hairline's edge, the grouped
    // table's round. No glass, no shadow; the clarity is the style.
    if (AppDesign.current.key == 'ios') {
      return Material(
        color: AppDesign.current.look(palette.dark).surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: compact
                ? const EdgeInsetsDirectional.fromSTEB(14, 10, 8, 10)
                : const EdgeInsetsDirectional.fromSTEB(16, 14, 10, 14),
            child: child,
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: palette.dark
            ? null
            : [
                // Monochrome: a quiet black shade, no hue.
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Pressable(
        // The home's own card, as glass: the fill the page breathes
        // through, the rim's hair of light in the card border's place.
        child: LiquidGlass(
          radius: 22,
          child: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: compact
                    ? const EdgeInsetsDirectional.fromSTEB(14, 10, 8, 10)
                    : const EdgeInsetsDirectional.fromSTEB(16, 14, 10, 14),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The real delay under the state; a tap tests again.
class _HomeDelay extends StatelessWidget {
  const _HomeDelay({required this.core, required this.palette});

  final CoreController core;
  final _HomePalette palette;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final test = core.lastTest;
    final showMs = test != null && test.ok;
    final (text, color) = switch (test) {
      null => (l.testConnection, palette.muted),
      final t when !t.ok => (l.testFailed, palette.error),
      final t => (l.milliseconds(t.responseMs), delayColor(t.responseMs)),
    };
    return RadarPing(
      active: core.testing,
      color: color,
      child: Tooltip(
        message: '${l.realDelay} · ${l.testConnection}',
        child: Material(
          color: Colors.transparent,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: core.testing
                ? null
                : () => runShowingErrors(context, core.runTest),
            child: LiquidGlass(
              radius: 999,
              accent: core.testing ? color : null,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 7,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (core.testing)
                    SweepLoader(color: color, size: 13, stroke: 1.6)
                  else
                    Icon(Icons.bolt_rounded, size: 16, color: color),
                  const SizedBox(width: 4),
                  if (showMs)
                    FlipCounter(
                      text: text,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    )
                  else
                    Text(
                      text,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The connection's numbers, where the island's details used to live: a
/// two-by-two grid of small cards — the time the connection has been up,
/// the real delay (a tap tests again), and the live down and up rates.
class _HomeStats extends StatelessWidget {
  const _HomeStats({
    required this.core,
    required this.status,
    required this.palette,
    required this.settings,
    required this.startedAt,
    required this.pingMs,
    this.showTraffic = true,
  });

  final CoreController core;
  final CoreStatus status;
  final _HomePalette palette;
  final AppSettings settings;
  final DateTime? startedAt;
  final int? pingMs;

  /// The setting: the live up/down cards show while it is on.
  final bool showTraffic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = palette;
    final traffic = status.traffic;
    final ping = pingMs;
    Widget card(
      IconData icon,
      String label,
      Widget value, {
      Color? valueColor,
      VoidCallback? onTap,
      Widget? busy,
    }) => _StatCard(
      palette: p,
      icon: icon,
      label: label,
      value: value,
      valueColor: valueColor,
      onTap: onTap,
      busy: busy,
    );
    Widget stat(Widget a, Widget b) => Row(
      // No stretch: the two cards share one structure (a label, a value),
      // so they land on the same height by themselves — and a stretched
      // Row with Expanded children cannot sit under an IntrinsicHeight.
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );
    return Column(
      children: [
        stat(
          card(
            Icons.schedule_rounded,
            l.statElapsed,
            startedAt == null
                ? const Text('—')
                : _ElapsedText(startedAt: startedAt!),
          ),
          card(
            Icons.bolt_rounded,
            l.realDelay,
            core.testing
                ? const Text('')
                : ping == null
                ? Text(l.testConnection)
                : FlipCounter(text: l.milliseconds(ping)),
            valueColor: ping == null ? p.muted : delayColor(ping),
            onTap: core.testing
                ? null
                : () => runShowingErrors(context, core.runTest),
            busy: core.testing
                ? SweepLoader(color: p.muted, size: 14, stroke: 1.6)
                : null,
          ),
        ),
        const SizedBox(height: 12),
        // The live rates, until the setting turns them off.
        if (showTraffic) ...[
          stat(
            card(
              Icons.south_rounded,
              l.statDown,
              Text(formatRate(traffic?.downRate ?? 0)),
            ),
            card(
              Icons.north_rounded,
              l.statUp,
              Text(formatRate(traffic?.upRate ?? 0)),
            ),
          ),
          const SizedBox(height: 12),
          // The last minute of both rates, drawn: the tunnel's own pulse.
          // Tapping it measures the tunnel for real (the speed test).
          _SpeedGraph(core: core, palette: p, settings: settings),
          const SizedBox(height: 12),
          // What the whole session moved, through the tunnel and routed
          // directly: the rates say how fast, this says how much.
          _HomeRow(
            palette: p,
            icon: Icons.swap_vert_rounded,
            label: l.statSession,
            value:
                '↓ ${formatBytes((traffic?.down ?? 0) + (traffic?.directDown ?? 0))}'
                ' · '
                '↑ ${formatBytes((traffic?.up ?? 0) + (traffic?.directUp ?? 0))}',
          ),
        ],
      ],
    );
  }
}

/// The tunnel's last minute, drawn: one sample per status poll, the down
/// rate as the filled line and the up rate over it. A quiet shape until
/// traffic moves; tapped, it measures the tunnel for real (the speed
/// test), so the graph and the numbers answer each other.
class _SpeedGraph extends StatefulWidget {
  const _SpeedGraph({
    required this.core,
    required this.palette,
    required this.settings,
  });

  final CoreController core;
  final _HomePalette palette;
  final AppSettings settings;

  @override
  State<_SpeedGraph> createState() => _SpeedGraphState();
}

class _SpeedGraphState extends State<_SpeedGraph> {
  static const _samples = 60;
  final List<double> _down = [];
  final List<double> _up = [];
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _sample();
    });
    _sample();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  /// One sample a second, read from the controller's own status: the
  /// graph watches the clock, not the core's notifications, so it can
  /// never answer a change while the tree is being taken apart.
  void _sample() {
    final traffic = widget.core.status?.traffic;
    _down.add((traffic?.downRate ?? 0).toDouble());
    _up.add((traffic?.upRate ?? 0).toDouble());
    if (_down.length > _samples) _down.removeAt(0);
    if (_up.length > _samples) _up.removeAt(0);
    setState(() {});
  }

  void _openTest() {
    showSpeedTest(context, widget.core, widget.settings);
    AppSounds.play(SoundCue.tap);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final theme = Theme.of(context);
    final peak = [..._down, ..._up].fold(1.0, (m, v) => v > m ? v : m);
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: _openTest,
        child: Container(
          height: 76,
          padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 8),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.insights_rounded, size: 13, color: p.muted),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context).speedGraphHint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: p.muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _SpeedGraphPainter(
                    down: _down,
                    up: _up,
                    peak: peak,
                    line: theme.colorScheme.primary,
                    upLine: p.muted,
                    grid: p.cardBorder,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The two rate lines: the down rate filled from the floor, the up rate a
/// thin line above it, three hairlines for the scale. Nothing moves while
/// the tunnel is quiet, and no saveLayer anywhere.
class _SpeedGraphPainter extends CustomPainter {
  const _SpeedGraphPainter({
    required this.down,
    required this.up,
    required this.peak,
    required this.line,
    required this.upLine,
    required this.grid,
  });

  final List<double> down;
  final List<double> up;
  final double peak;
  final Color line;
  final Color upLine;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    final hair = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final t in const [0.25, 0.5, 0.75]) {
      final y = size.height * t;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), hair);
    }
    if (down.length < 2) return;
    final width = size.width / (_samplesCount - 1);
    Path downPath(double Function(double) at) {
      final path = Path()..moveTo(0, at(size.height));
      for (var i = 0; i < down.length; i++) {
        final x = i * width;
        final v = down[i] / peak;
        path.lineTo(x, size.height - (size.height - 2) * v.clamp(0.0, 1.0) - 1);
      }
      return path;
    }

    final filled = downPath((h) => h)
      ..lineTo((down.length - 1) * width, size.height)
      ..close();
    canvas.drawPath(filled, Paint()..color = line.withValues(alpha: 0.18));
    canvas.drawPath(
      downPath((h) => h),
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    final upPath = Path();
    for (var i = 0; i < up.length; i++) {
      final x = i * width;
      final v = up[i] / peak;
      final y = size.height - (size.height - 2) * v.clamp(0.0, 1.0) - 1;
      if (i == 0) {
        upPath.moveTo(x, y);
      } else {
        upPath.lineTo(x, y);
      }
    }
    canvas.drawPath(
      upPath,
      Paint()
        ..color = upLine
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  static const _samplesCount = 60;

  @override
  bool shouldRepaint(_SpeedGraphPainter old) =>
      old.peak != peak || !identical(old.down, down) || !identical(old.up, up);
}

/// One small card of the stats grid: an icon and a muted label above the
/// value in large type.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.palette,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
    this.busy,
  });

  final _HomePalette palette;
  final IconData icon;
  final String label;
  final Widget value;
  final Color? valueColor;
  final VoidCallback? onTap;
  final Widget? busy;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final theme = Theme.of(context);
    // The stat's own card, as glass: the fill the home breathes through,
    // the rim's light, the state's color carried at the light's corner.
    final child = LiquidGlass(
      radius: 20,
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: p.muted),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: p.muted),
                ),
              ),
              if (busy != null) ...[const SizedBox(width: 6), busy!],
            ],
          ),
          const SizedBox(height: 6),
          DefaultTextStyle(
            style:
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  // The numbers wear the display's own voice too.
                  fontFamily: typefacesOf(context).display,
                  fontFamilyFallback: typefacesOf(context).displayFallback,
                  color: valueColor ?? p.text,
                ) ??
                const TextStyle(fontSize: 16),
            child: value,
          ),
        ],
      ),
    );
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

/// The time the connection has been up, ticking every second: mm:ss, and
/// h:mm:ss once the hour is past.
class _ElapsedText extends StatefulWidget {
  const _ElapsedText({required this.startedAt});

  final DateTime startedAt;

  @override
  State<_ElapsedText> createState() => _ElapsedTextState();
}

class _ElapsedTextState extends State<_ElapsedText>
    with WidgetsBindingObserver {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // A hidden window needs no mm:ss: the tick that redraws it every
    // second wakes the engine for nothing, and the battery pays for it.
    // It picks up where it stopped when the window comes back.
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _tick?.cancel();
      _tick = null;
    } else if (state == AppLifecycleState.resumed && _tick == null) {
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = DateTime.now()
        .difference(widget.startedAt)
        .inSeconds
        .clamp(0, 86399);
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    final text = h > 0
        ? '$h:${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
    return Text(text);
  }
}

/// Copies the exit's public IP for the user's clipboard, and says so in
/// the app's own dynamic note (widgets.dart): an address is the kind of
/// thing a report or a check needs by hand.
void _copyPublicIp(BuildContext context, String ip) {
  Clipboard.setData(ClipboardData(text: ip));
  showToast(
    context,
    AppLocalizations.of(context).copiedToClipboard,
    mark: ToastMark.copy,
  );
}

/// A full-width stat row: an icon, a muted label, then the value, all in
/// one quiet card. A row with [onTap] answers a tap (the public IP's
/// copy), with [trailing] a small mark after the value.
class _HomeRow extends StatelessWidget {
  const _HomeRow({
    required this.palette,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });

  final _HomePalette palette;
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final theme = Theme.of(context);
    final child = Container(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: p.card,
        // The gazette's row rules itself like the paper's own box.
        borderRadius: BorderRadius.circular(
          AppDesign.current.key == 'gazette' ? 6 : 20,
        ),
        border: Border.all(color: p.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: p.muted),
          const SizedBox(width: 10),
          // The label yields, the value keeps its width as far as it can:
          // both wrap free, so a wide language or a long address bends the
          // row instead of pushing past its card.
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: p.muted),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: p.text,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

/// The switch: an orb in the state's color with a glow and a thin ring.
/// It stays still on the desktop: an endless animation redraws the window
/// every frame, and kept a CPU core busy even with the window hidden in
/// the tray. The phone carries the one breath: rings that grow and fade
/// around the connected disc — the phone's frames stop with its screen,
/// and the battery saver holds them to a quiet ring.
class _PowerOrb extends StatelessWidget {
  const _PowerOrb({
    required this.palette,
    required this.on,
    required this.accent,
    required this.busy,
    required this.batterySaver,
    required this.tooltip,
    required this.onPressed,
  });

  final _HomePalette palette;
  final bool on;
  final Color accent;
  final bool busy;

  /// The battery saver's word: true holds the halo's rings still.
  final bool batterySaver;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    const area = 250.0;
    const ring = 186.0;
    const disc = 148.0;
    // The connected face: the disc carries the power, and the check's
    // badge draws itself in at the disc's edge each time the VPN lands.
    Widget face = AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: disc,
      height: disc,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: on
              ? [Color.lerp(accent, Colors.white, 0.28)!, accent]
              : p.discOff,
        ),
        border: Border.all(
          color: on ? Colors.white.withValues(alpha: 0.4) : p.discOffEdge,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: on
                ? accent.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: p.dark ? 0.45 : 0.14),
            blurRadius: on ? 36 : 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: busy ? null : onPressed,
          child: Icon(
            Icons.power_settings_new_rounded,
            size: 58,
            color: on ? Colors.white : (p.dark ? p.muted : p.idle),
          ),
        ),
      ),
    );
    if (on && Platform.isAndroid) {
      // The connected breath, on the phone only: rings grow out of the
      // disc and fade — the desktop stays still, the way it always was.
      // The battery saver holds the rings to one quiet circle.
      face = PulseHalo(
        color: accent,
        baseSize: disc,
        paused: batterySaver,
        child: face,
      );
    }
    return Tooltip(
      message: tooltip,
      child: SizedBox.square(
        dimension: area,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: area,
              height: area,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: on ? 0.30 : 0.10),
                    accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            Container(
              width: ring,
              height: ring,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: accent.withValues(alpha: on ? 0.55 : 0.28),
                  width: 1.5,
                ),
              ),
            ),
            if (busy)
              SizedBox.square(
                dimension: ring,
                child: CircularProgressIndicator(strokeWidth: 2, color: accent),
              ),
            face,
            // The arrival's own mark: the check strokes itself in, once,
            // each time the connection lands. Gone while the switch is
            // still turning, so it never blinks between states.
            if (on && !busy)
              Positioned(
                left: 162,
                top: 162,
                child: _CheckBadge(accent: accent),
              ),
          ],
        ),
      ),
    );
  }
}

/// The orb's own arrival badge: a white coin on the disc's edge with the
/// check drawn in the accent. A key per connected turn replays the draw.
class _CheckBadge extends StatelessWidget {
  const _CheckBadge({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.35 : 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: DrawCheck(color: accent, size: 14, strokeWidth: 2.4),
      ),
    );
  }
}

/// The data used of the active account: a ring that fills as it is used,
/// in the quota's color, and the amount in large type.
class _HomeData extends StatelessWidget {
  const _HomeData({
    required this.status,
    required this.palette,
    this.onTap,
    this.compact = false,
  });

  final CoreStatus status;
  final _HomePalette palette;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = palette;
    final muted = theme.textTheme.bodySmall?.copyWith(color: p.muted);
    final a = status.activeAccount;
    final usage = a?.usage;
    Widget body;
    if (a == null || usage == null || usage.unlimited) {
      body = Row(
        children: [
          Icon(
            a == null
                ? Icons.person_add_alt_rounded
                : Icons.all_inclusive_rounded,
            color: p.muted,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              a == null
                  ? l.noActiveAccount
                  : usage == null
                  ? l.quotaNotRead
                  : l.unlimited,
              style: theme.textTheme.titleMedium?.copyWith(color: p.text),
            ),
          ),
        ],
      );
    } else {
      final used = usage.usedBytes.clamp(0, usage.limitBytes);
      final fraction = usage.limitBytes == 0 ? 0.0 : used / usage.limitBytes;
      final color = quotaColor(fraction * 100, status.thresholdPercent);
      body = Row(
        children: [
          SizedBox.square(
            dimension: _homeCardContent(compact),
            child: CustomPaint(
              painter: _QuotaRing(
                value: fraction,
                color: color,
                track: p.text.withValues(alpha: 0.08),
              ),
              child: Center(
                child: CountUp(
                  value: fraction * 100,
                  format: (v) => ltr('${v.round()}%'),
                  style:
                      (compact
                              ? theme.textTheme.labelMedium
                              : theme.textTheme.titleSmall)
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: p.text,
                          ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.dataUsedTitle, style: muted),
                Text(
                  formatBytes(used),
                  style:
                      (compact
                              ? theme.textTheme.titleLarge
                              : theme.textTheme.headlineSmall)
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: p.text,
                          ),
                ),
                Text(
                  [
                    l.dataLeftOf(formatBytes(usage.limitBytes)),
                    if (usage.resetAt != null)
                      l.resets(formatDate(l, usage.resetAt!)),
                  ].join(' · '),
                  style: muted,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return _HomeCard(
      palette: p,
      onTap: onTap,
      compact: compact,
      child: Row(
        children: [
          Expanded(child: body),
          Icon(Icons.chevron_right_rounded, color: p.muted),
        ],
      ),
    );
  }
}

class _QuotaRing extends CustomPainter {
  _QuotaRing({required this.value, required this.color, required this.track});

  final double value;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value.clamp(0.0, 1.0),
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_QuotaRing old) =>
      old.value != value || old.color != color || old.track != track;
}

/// The proxy's address on the local network, for other devices; a tap
/// copies it.
class _LanChip extends StatefulWidget {
  const _LanChip({required this.port});

  final int port;

  @override
  State<_LanChip> createState() => _LanChipState();
}

class _LanChipState extends State<_LanChip> {
  String? _ip;

  @override
  void initState() {
    super.initState();
    lanAddress().then((ip) {
      if (mounted) setState(() => _ip = ip);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ip = _ip;
    if (ip == null) return const SizedBox.shrink();
    final address = '$ip:${widget.port}';
    return ActionChip(
      avatar: const Icon(Icons.lan_outlined, size: 18),
      label: Text(l.lanAddress(ltr(address))),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: address));
        showToast(context, l.copied(address), mark: ToastMark.copy);
      },
    );
  }
}

/// Refusals dismissed in this session, by [Notice.key]; a newer refusal of
/// the same kind shows again.
final _dismissedNotices = <String>{};

/// Notes on requests the proxy refused in the last minutes: a port
/// Mozilla's proxy does not connect to, or UDP.
class _Notices extends StatefulWidget {
  const _Notices({required this.notices});

  final List<Notice> notices;

  @override
  State<_Notices> createState() => _NoticesState();
}

class _NoticesState extends State<_Notices> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final shown = [
      for (final n in widget.notices)
        if (!_dismissedNotices.contains(n.key) &&
            (n.kind == 'port' || n.kind == 'command'))
          n,
    ];
    if (shown.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final n in shown)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 6, 10),
              decoration: BoxDecoration(
                color: StatusColors.busy.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: StatusColors.busy.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: StatusColors.busy,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n.kind == 'port'
                              ? l.noticePort(n.detail)
                              : l.noticeCommand,
                          style: theme.textTheme.bodySmall,
                        ),
                        if (n.last != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            [
                              l.noticeTimes(n.count, formatAgo(l, n.last!)),
                              if (n.hosts.isNotEmpty) n.hosts.join(', '),
                            ].join(' · '),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l.dismiss,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close_rounded, size: 16),
                    onPressed: () =>
                        setState(() => _dismissedNotices.add(n.key)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A newer version on GitHub. The desktop apps (Windows, Linux, macOS)
/// install it themselves: Update downloads it (its progress shows here),
/// then the app closes and opens again as the new version; on Android it
/// downloads here and Update opens Android's installer (or, with Update in
/// the app off, Download opens the browser; Updates).
/// After an update, what it did. Closed, a version's notice stays away
/// until a later version.
class _UpdateNotice extends StatelessWidget {
  const _UpdateNotice({
    required this.core,
    required this.settings,
    required this.palette,
  });

  final CoreController core;
  final AppSettings settings;
  final _HomePalette palette;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([
      Updates.available,
      Updates.failure,
      Updates.resultSeen,
      Updates.apkState,
      Updates.apkProgress,
    ]),
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final update = core.status?.update;
      final release = Updates.available.value;
      final last = update?.last;
      if (last != null &&
          !Updates.resultSeen.value &&
          release?.mandatory != true) {
        return _UpdateBanner(
          palette: palette,
          icon: last.ok ? Icons.check_circle_rounded : Icons.history_rounded,
          text: last.ok ? l.updateDone(last.to) : l.updateRolledBack(last.to),
          tooltip: last.error,
          problem: !last.ok,
          onClose: () => Updates.resultSeen.value = true,
        );
      }
      if (release == null ||
          (!release.mandatory && release.version == settings.dismissedUpdate)) {
        return const SizedBox.shrink();
      }
      final VoidCallback? dismiss = release.mandatory
          ? null
          : () => settings.update(dismissedUpdate: release.version);
      // Android updates the app itself: the package downloads in the
      // background, then the system's installer asks. No page of the
      // release, no repository — only the version and what happens.
      if (Platform.isAndroid) {
        return switch (Updates.apkState.value) {
          ApkState.downloading => _UpdateBanner(
            palette: palette,
            icon: Icons.downloading_rounded,
            text: l.updateDownloading(release.version),
            busy: true,
            progress: Updates.apkProgress.value,
          ),
          ApkState.ready => _UpdateBanner(
            palette: palette,
            icon: Icons.install_mobile_rounded,
            text: l.updateReady(release.version),
            action: (
              label: l.installNow,
              icon: Icons.upgrade_rounded,
              onPressed: () => Updates.installApkUpdate(),
            ),
            onClose: dismiss,
          ),
          ApkState.permission => _UpdateBanner(
            palette: palette,
            icon: Icons.install_mobile_rounded,
            text: l.updateAllowInstall,
            action: (
              label: l.allowInstall,
              icon: Icons.settings_rounded,
              onPressed: () => Updates.installApkUpdate(),
            ),
            onClose: dismiss,
          ),
          ApkState.failed => _UpdateBanner(
            palette: palette,
            icon: Icons.error_outline_rounded,
            text: l.updateFailed(release.version),
            tooltip: Updates.apkError.value,
            problem: true,
            action: (
              label: l.tryAgain,
              icon: Icons.refresh_rounded,
              onPressed: () => Updates.update(release),
            ),
            onClose: dismiss,
          ),
          ApkState.idle => _UpdateBanner(
            palette: palette,
            icon: Icons.system_update_rounded,
            problem: release.mandatory,
            text: release.mandatory
                ? l.updateRequired(release.version)
                : l.updateAvailable(release.version),
            action: (
              label: l.updateNow,
              icon: Icons.upgrade_rounded,
              onPressed: () => Updates.update(release),
            ),
            onClose: dismiss,
          ),
        };
      }
      if (update == null) {
        return _UpdateBanner(
          palette: palette,
          icon: Icons.system_update_rounded,
          text: release.mandatory
              ? l.updateRequired(release.version)
              : l.updateAvailable(release.version),
          problem: release.mandatory,
          action: release.url.isEmpty
              ? null
              : (
                  label: l.download,
                  icon: Icons.download_rounded,
                  onPressed: () => openDownload(context, release),
                ),
          onClose: dismiss,
        );
      }
      final mine = update.version == release.version;
      if (mine && (update.downloading || update.installing)) {
        return _UpdateBanner(
          palette: palette,
          icon: Icons.downloading_rounded,
          text: update.downloading
              ? l.updateDownloading(release.version)
              : l.updateInstalling(release.version),
          busy: true,
          progress: update.downloading ? update.progress : null,
        );
      }
      final failure =
          Updates.failure.value ??
          (mine && update.failed ? update.error : null);
      if (failure != null) {
        return _UpdateBanner(
          palette: palette,
          icon: Icons.error_outline_rounded,
          text: l.updateFailed(release.version),
          tooltip: failure,
          problem: true,
          action: (
            label: l.tryAgain,
            icon: Icons.refresh_rounded,
            onPressed: () => Updates.update(release),
          ),
          onClose: dismiss,
        );
      }
      return _UpdateBanner(
        palette: palette,
        icon: Icons.system_update_rounded,
        problem: release.mandatory,
        text: release.mandatory
            ? l.updateRequired(release.version)
            : mine && update.ready
            ? l.updateReady(release.version)
            : l.updateAvailable(release.version),
        action: (
          label: l.updateNow,
          icon: Icons.upgrade_rounded,
          onPressed: () => Updates.update(release),
        ),
        onClose: dismiss,
      );
    },
  );
}

/// The update notice's look: a rounded bar in the connected color (amber
/// for a problem, with the core's reason on hover), a button, a close
/// button, and a progress bar under the text while busy.
class _UpdateBanner extends StatelessWidget {
  const _UpdateBanner({
    required this.palette,
    required this.icon,
    required this.text,
    this.tooltip = '',
    this.problem = false,
    this.action,
    this.busy = false,
    this.progress,
    this.onClose,
  });

  final _HomePalette palette;
  final IconData icon;
  final String text;
  final String tooltip;
  final bool problem;
  final ({String label, IconData icon, VoidCallback onPressed})? action;

  /// A bar under the text: the download's [progress], or under way
  /// (null).
  final bool busy;
  final double? progress;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = palette;
    final color = problem ? StatusColors.busy : p.connected;
    final action = this.action;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: color.withValues(alpha: p.dark ? 0.16 : 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: color.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            14,
            6,
            onClose == null ? 14 : 6,
            6,
          ),
          child: Row(
            children: [
              // The notice with its button is one place to choose: a
              // remote's down arrow from the switch reaches it (the button
              // alone stands aside, out of the arrow's line), and OK runs
              // the button's action; right goes on to close.
              Expanded(
                child: InkWell(
                  onTap: action?.onPressed,
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    children: [
                      Icon(icon, color: color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Tooltip(
                                message: tooltip,
                                child: Text(
                                  text,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: p.text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (busy) ...[
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 4,
                                    color: color,
                                    backgroundColor: color.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(width: 8),
                        // Solid, in the banner's color: the one thing to
                        // press (focus goes to the whole notice).
                        ExcludeFocus(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              // From the theme, for its font (Vazirmatn in
                              // Persian): a bare style would replace it.
                              textStyle: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: action.onPressed,
                            icon: Icon(action.icon, size: 18),
                            label: Text(action.label),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (onClose != null)
                IconButton(
                  tooltip: l.dismiss,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.close_rounded, size: 18, color: p.muted),
                  onPressed: onClose,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// TUN mode refused a program's UDP that looks like a call or a game (on a port
/// Mozilla does not carry): the program by name. Sending its UDP directly is
/// chosen in the TUN settings, on purpose: a button here could be pressed without
/// knowing what it gives away. Once seen, the card goes after a minute, and stays
/// away while the same program is the one refused and the TUN runs.
class _UdpNotice extends StatefulWidget {
  const _UdpNotice({
    required this.status,
    required this.settings,
    required this.palette,
  });

  final CoreStatus status;
  final AppSettings settings;
  final _HomePalette palette;

  @override
  State<_UdpNotice> createState() => _UdpNoticeState();
}

class _UdpNoticeState extends State<_UdpNotice> {
  static const _showFor = Duration(seconds: 60);

  /// The program the card is out for, and whether its minute is over; the
  /// minute starts when the card can first be seen (the window is shown, the
  /// app in front), also when the home page is built again meanwhile.
  static String? _shownFor;
  static bool _over = false;
  static Timer? _minute;
  static final _changed = ValueNotifier(0);

  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _changed.addListener(_rebuild);
    // Shown from the tray, or the app brought to the front: seen now.
    _lifecycle = AppLifecycleListener(onStateChange: (_) => _rebuild());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _changed.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  /// Whether the user can see the home page now.
  static bool get _seen {
    final state = WidgetsBinding.instance.lifecycleState;
    return (state == AppLifecycleState.resumed ||
            state == AppLifecycleState.inactive) &&
        !Updates.windowHidden();
  }

  /// Whether to show the card for [program] ("" for none) now.
  bool _visible(String program) {
    if (program.isEmpty) {
      // The TUN stopped, or the program skips the VPN now: a later refusal
      // shows again.
      _shownFor = null;
      _over = false;
      _minute?.cancel();
      _minute = null;
      return false;
    }
    if (program != _shownFor) {
      _shownFor = program;
      _over = false;
      _minute?.cancel();
      _minute = null;
    }
    if (!_over && _minute == null && _seen) {
      _minute = Timer(_showFor, () {
        _over = true;
        _changed.value++;
      });
    }
    return !_over;
  }

  /// A program by the name people know: without ".exe".
  static String _label(String program) => program.toLowerCase().endsWith('.exe')
      ? program.substring(0, program.length - 4)
      : program;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.settings,
    builder: (context, _) {
      final status = widget.status, settings = widget.settings;
      final tun = status.tun;
      final refused = status.tunMode && tun != null && tun.on
          ? tun.refusedUdp
          : '';
      if (!_visible(refused) ||
          !tun!.programsSupported ||
          !settings.udpNotice) {
        return const SizedBox.shrink();
      }
      final program = refused;
      final l = AppLocalizations.of(context);
      final theme = Theme.of(context);
      final p = widget.palette;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: StatusColors.busy.withValues(alpha: p.dark ? 0.16 : 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: StatusColors.busy.withValues(alpha: 0.4)),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 6, 8),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: StatusColors.busy),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.udpNoticeBody(ltr(_label(program))),
                    style: theme.textTheme.bodyMedium?.copyWith(color: p.text),
                  ),
                ),
                const SizedBox(width: 8),
                // The style starts from the theme, for its font.
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: p.muted,
                    visualDensity: VisualDensity.compact,
                    textStyle: theme.textTheme.labelLarge,
                  ),
                  onPressed: () => settings.update(udpNotice: false),
                  icon: const Icon(Icons.visibility_off_outlined, size: 18),
                  label: Text(l.dontShowAgain),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// When the user connects and the active account is nearly used up with
/// no other account to take over: adding an account gives another month's
/// data. Shown once per connection, for a minute; closed, it stays away for
/// a day.
class _LowQuotaNotice extends StatefulWidget {
  const _LowQuotaNotice({
    required this.core,
    required this.status,
    required this.settings,
    required this.connected,
    required this.palette,
  });

  final CoreController core;
  final CoreStatus status;
  final AppSettings settings;
  final bool connected;
  final _HomePalette palette;

  @override
  State<_LowQuotaNotice> createState() => _LowQuotaNoticeState();
}

class _LowQuotaNoticeState extends State<_LowQuotaNotice> {
  /// Below this much left, the account is running out.
  static const _left = 5 << 30;
  static const _showFor = Duration(seconds: 60);
  static const _quiet = Duration(hours: 24);

  /// The connection it was shown for (the proxy's start), and whether its
  /// minute is over: once per connection, also when the home page is
  /// built again meanwhile.
  static DateTime? _shownFor;
  static bool _started = false;
  static bool _over = false;
  static Timer? _minute;
  static final _changed = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _changed.addListener(_rebuild);
  }

  @override
  void dispose() {
    _changed.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  bool get _due {
    final active = widget.status.activeAccount;
    final usage = active?.usage;
    if (!widget.connected || active == null || usage == null) return false;
    if (usage.unlimited || usage.limitBytes == 0) return false;
    if (usage.remainingBytes >= _left) return false;
    // Another account that can take over: the app moves to it by itself.
    final others = widget.core.accounts?.accounts ?? const <Account>[];
    final spare = others.any(
      (a) =>
          a.id != active.id &&
          a.enabled &&
          a.status == AccountStatus.ready &&
          (a.usage?.unlimited == true ||
              (a.usage?.remainingBytes ?? 0) >= _left),
    );
    if (spare) return false;
    final closed = widget.settings.lowQuotaDismissedAt;
    return closed == null || DateTime.now().difference(closed) >= _quiet;
  }

  /// Whether to show it now; the minute starts at the first look of a
  /// connection.
  bool _visible() {
    if (!_due) return false;
    final connection = widget.status.proxy?.startedAt;
    if (!_started || _shownFor != connection) {
      _started = true;
      _shownFor = connection;
      _over = false;
      _minute?.cancel();
      _minute = Timer(_showFor, () {
        _over = true;
        _changed.value++;
      });
    }
    return !_over;
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible()) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = widget.palette;
    final usage = widget.status.activeAccount!.usage!;
    String rounded(int bytes) => formatBytes(bytes).replaceAll('.0 ', ' ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: StatusColors.busy.withValues(alpha: p.dark ? 0.16 : 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: StatusColors.busy.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 6, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.data_usage_rounded,
                      color: StatusColors.busy,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.lowQuotaNotice(rounded(usage.limitBytes)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: p.text,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l.close,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.close_rounded, size: 18, color: p.muted),
                    onPressed: () {
                      widget.settings.update(
                        lowQuotaDismissedAt: DateTime.now(),
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: () =>
                      startAddAccount(context, widget.core, widget.settings),
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                  label: Text(l.addAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The tiles' connect bar: one wide card, the power's own circle beside
/// the state's word and the tap's hint — a tap anywhere on it flips the
/// VPN. The circle lights in the state's color when it is on and carries
/// the busy ring while the path comes up.
class _BentoConnectBar extends StatelessWidget {
  const _BentoConnectBar({
    required this.palette,
    required this.on,
    required this.busy,
    required this.accent,
    required this.label,
    required this.hint,
    required this.onPressed,
  });

  final _HomePalette palette;
  final bool on;
  final bool busy;
  final Color accent;
  final String label;
  final String hint;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = palette;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: _HomeCard(
        palette: p,
        onTap: busy ? null : onPressed,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(22, 20, 22, 20),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 64,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: on ? accent : p.card,
                    border: Border.all(
                      color: on
                          ? accent.withValues(alpha: 0.9)
                          : p.cardBorder.withValues(alpha: 1),
                      width: 1.5,
                    ),
                    boxShadow: on
                        ? [
                            BoxShadow(
                              color: accent.withValues(
                                alpha: p.dark ? 0.42 : 0.3,
                              ),
                              blurRadius: 24,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (busy)
                        const SizedBox.square(
                          dimension: 64,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      Icon(
                        Icons.power_settings_new_rounded,
                        size: 30,
                        color: on
                            ? (accent.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white)
                            : p.muted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: on ? accent : p.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: p.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The compact home's one card: the place as a chip on top (a tap opens
/// the servers page), the switch's orb under it. Everything else the
/// home shows stays where it always was — the numbers in this card's
/// flat rows once the connection is up.
class _PixelHomeCard extends StatelessWidget {
  const _PixelHomeCard({
    required this.palette,
    required this.place,
    required this.on,
    required this.busy,
    required this.tooltip,
    required this.onOpenServers,
    required this.onPressed,
  });

  final _HomePalette palette;
  final HomePlace place;
  final bool on;
  final bool busy;
  final String tooltip;
  final VoidCallback? onOpenServers;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = palette;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: _HomeCard(
        palette: p,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 14, 18, 18),
          child: Column(
            children: [
              // The place's chip: the flag, the name, and the way to the
              // servers page to change it.
              InkWell(
                onTap: onOpenServers,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      CountryFlag(code: place.flag, width: 26),
                      const SizedBox(width: 12),
                      if (place.auto) ...[
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: p.text,
                          ),
                        ),
                      ),
                      if (onOpenServers != null)
                        Icon(Icons.chevron_right_rounded, color: p.muted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // The pixel's own connect control: the Material You tonal
              // pill — the surface's color carries the state, the state
              // layer answers the finger, the press squishes. No glass,
              // no glow: the shape and the color speak.
              _PixelConnect(
                on: on,
                busy: busy,
                label: tooltip,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The pixel's connect control: Material You's big tonal pill — the
/// filled container that carries the state's color (the surface's own
/// tone while off, the primary's container while the tunnel carries),
/// the power's mark, and the state's word. The press squishes the pill
/// and the ripple answers under the finger; the connecting wait rides
/// a thin spinner in the pill's own ink.
class _PixelConnect extends StatelessWidget {
  const _PixelConnect({
    required this.on,
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  final bool on;
  final bool busy;

  /// The tap's own word — the state-aware label the page already holds.
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final container = on
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest;
    final ink = on ? scheme.onPrimaryContainer : scheme.onSurface;
    return Pressable(
      depth: 0.045,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: busy ? null : onPressed,
          customBorder: const StadiumBorder(),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => ink.withValues(
              alpha: states.contains(WidgetState.pressed) ? 0.10 : 0.0,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            height: 62,
            decoration: BoxDecoration(color: container, borderRadius: BorderRadius.circular(31)),
            child: Center(
              widthFactor: 1,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: Tween(begin: 0.97, end: 1.0).animate(anim), child: child),
                ),
                child: Row(
                  key: ValueKey('$label-$busy-$on'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (busy) ...[
                      SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2, color: ink),
                      ),
                    ] else
                      Icon(
                        on ? Icons.power_settings_new_rounded : Icons.bolt_rounded,
                        size: 22,
                        color: ink,
                      ),
                    const SizedBox(width: 10),
                    Text(
                      busy ? AppLocalizations.of(context).stateConnecting : label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.1,
                        color: ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The compact home's numbers: the connection's own rows — the time it
/// has been up, the real delay, the live rates — inside one flat card,
/// each a quiet line, not a tile of its own.
class _FlatStats extends StatelessWidget {
  const _FlatStats({
    required this.core,
    required this.status,
    required this.palette,
    required this.startedAt,
    required this.pingMs,
    required this.showTraffic,
    this.showConnection = true,
  });

  final CoreController core;
  final CoreStatus status;
  final _HomePalette palette;
  final DateTime? startedAt;
  final int? pingMs;
  final bool showTraffic;

  /// The time and the delay rows: the aether's card and the zed's blob
  /// already carry the session's time and the ping themselves, so their
  /// stats card keeps only the rates.
  final bool showConnection;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = palette;
    final traffic = status.traffic;
    final ping = pingMs;
    final sessionRow = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _FlatRow(
        palette: p,
        icon: Icons.swap_vert_rounded,
        label: l.statSession,
        value: Text(
          '↓ ${formatBytes((traffic?.down ?? 0) + (traffic?.directDown ?? 0))}'
          ' · '
          '↑ ${formatBytes((traffic?.up ?? 0) + (traffic?.directUp ?? 0))}',
        ),
      ),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: _HomeCard(
        palette: p,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
          child: Column(
            children: [
              if (showConnection) ...[
                _FlatRow(
                  palette: p,
                  icon: Icons.schedule_rounded,
                  label: l.statElapsed,
                  value: startedAt == null
                      ? const Text('—')
                      : _ElapsedText(startedAt: startedAt!),
                ),
                const SizedBox(height: 10),
                _FlatRow(
                  palette: p,
                  icon: Icons.bolt_rounded,
                  label: l.realDelay,
                  value: Text(
                    core.testing
                        ? ''
                        : ping == null
                        ? l.testConnection
                        : l.milliseconds(ping),
                  ),
                  valueColor: ping == null ? p.muted : delayColor(ping),
                  onTap: core.testing
                      ? null
                      : () => runShowingErrors(context, core.runTest),
                ),
              ],
              if (showTraffic) ...[
                const SizedBox(height: 10),
                _FlatRow(
                  palette: p,
                  icon: Icons.south_rounded,
                  label: l.statDown,
                  value: Text(formatRate(traffic?.downRate ?? 0)),
                ),
                const SizedBox(height: 10),
                _FlatRow(
                  palette: p,
                  icon: Icons.north_rounded,
                  label: l.statUp,
                  value: Text(formatRate(traffic?.upRate ?? 0)),
                ),
                sessionRow,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One of the zed card's two rate cells: the direction's word and the
/// moment's rate on the first line, the session's bytes muted beneath —
/// a tile of the bento the design wears, not a row of a ledger.
class _RateCell extends StatelessWidget {
  const _RateCell({
    required this.palette,
    required this.label,
    required this.icon,
    required this.bytes,
    required this.rate,
    required this.color,
  });

  final _HomePalette palette;
  final String label;
  final IconData icon;
  final int bytes;
  final int rate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = palette;
    return LiquidGlass(
      radius: 14,
      padding: const EdgeInsetsDirectional.fromSTEB(12, 9, 12, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          // The moment's rate, walked to its next value — the live
          // numbers glide instead of flickering between polls.
          TickerNumber(
            value: rate,
            builder:
                (context, v) => Text(
                  formatRate(v),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: (
                    theme.textTheme.titleMedium ?? const TextStyle()
                  ).copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: p.text,
                  ),
                ),
          ),
          const SizedBox(height: 1),
          Text(
            formatBytes(bytes),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: p.muted,
            ),
          ),
        ],
      ),
    );
  }
}

/// One row of the compact home's numbers: the icon and the muted label
/// on the left, the value on the right — a line, not a tile.
class _FlatRow extends StatelessWidget {
  const _FlatRow({
    required this.palette,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  final _HomePalette palette;
  final IconData icon;
  final String label;
  final Widget value;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Row(
          children: [
            Icon(icon, size: 16, color: p.muted),
            const SizedBox(width: 10),
            // The label yields to the value on a narrow screen: the row
            // reads to its end instead of painting past it.
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: p.muted),
              ),
            ),
            const SizedBox(width: 8),
            DefaultTextStyle(
              style: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: valueColor ?? p.text,
              ),
              child: value,
            ),
          ],
        ),
      ),
    );
  }
}

/// The aether home's hero: the iOS status card and the morphing power
/// button the AetherST design wears — a raised card whose top washes
/// with the state's own system color, the state's dot and word on the
/// first line with the place's flag beside it, the session's time big
/// under them with the ping chip at its side, and the button below the
/// card: a blue circle while off that rounds itself into a green
/// squircle when the tunnel carries.
class _AetherHeroCard extends StatelessWidget {
  const _AetherHeroCard({
    required this.palette,
    required this.place,
    required this.on,
    required this.busy,
    required this.error,
    required this.tooltip,
    required this.label,
    required this.hint,
    required this.startedAt,
    required this.pingMs,
    required this.traffic,
    required this.showTraffic,
    required this.batterySaver,
    required this.onOpenServers,
    required this.onPressed,
    this.testing = false,
    this.onTest,
  });

  final _HomePalette palette;
  final HomePlace place;
  final bool on;
  final bool busy;

  /// The start gave up on its own: the card's light reads red.
  final bool error;
  final String tooltip;
  final String label;
  final String hint;
  final DateTime? startedAt;
  final int? pingMs;

  /// The session's own numbers, the reference's card wears while the
  /// tunnel carries: the rates the settings offer to show.
  final Traffic? traffic;
  final bool showTraffic;

  /// The battery saver's word: the button's glow holds one pose.
  final bool batterySaver;
  final VoidCallback? onOpenServers;
  final VoidCallback onPressed;

  /// The ping chip is a button too: the reference's card measures the
  /// delay again when its own chip is tapped — the chip shows the test's
  /// spinner while the measure runs.
  final bool testing;
  final VoidCallback? onTest;

  /// AetherST's own state lights — the system colors the iOS look
  /// speaks: the vivid set on the dark page, the deeper set on the
  /// light one. The card's wash, the dot and the button read these; the
  /// accent stays out of the state's voice.
  Color get _state {
    if (error) {
      return palette.dark ? const Color(0xFFFF3B30) : const Color(0xFFC0392B);
    }
    if (busy) {
      return palette.dark ? const Color(0xFFFF9500) : const Color(0xFFC77D1E);
    }
    if (on) {
      return palette.dark ? const Color(0xFF34C759) : const Color(0xFF1E9E6B);
    }
    return const Color(0xFF8E8E93);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final p = palette;
    final state = _state;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The status card itself: a sheet of glass with the state's
          // light washing down from its top edge, the rim's own light
          // walking it while the connection is being made.
          GlassFlow(
            radius: 16,
            color: state,
            paused: !busy || batterySaver,
            child: LiquidGlass(
              radius: 16,
              accent: on || busy || error ? state : null,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      state.withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    16,
                    13,
                    16,
                    15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The state's line: the dot, the word, and the place's
                      // flag chip that opens the servers page. The word takes
                      // the room before the chip — a Spacer here would split
                      // the free width with the word and leave it halved,
                      // ellipsizing "Disconnected" on the phones that size
                      // their text up.
                      Row(
                        children: [
                          // The state's own dot; while the connection is
                          // being made it breathes — the wait made visible.
                          busy
                              ? PulseDot(
                                  color: state,
                                  size: 8,
                                  paused: batterySaver,
                                )
                              : Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: state,
                                  ),
                                ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: state,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: onOpenServers,
                            borderRadius: BorderRadius.circular(9),
                            child: Container(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                    8,
                                    5,
                                    8,
                                    5,
                                  ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: p.dark
                                    ? const Color(0xFF2C2C2E)
                                    : const Color(0xFFECECF1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CountryFlag(code: place.flag, width: 18),
                                  const SizedBox(width: 7),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 120,
                                    ),
                                    child: Text(
                                      place.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: p.text,
                                          ),
                                    ),
                                  ),
                                  if (place.auto) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 12,
                                      color: p.muted,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // The session's line: the time big when the tunnel
                      // carries, the tap's word when it rests.
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: on && startedAt != null
                                ? DefaultTextStyle(
                                    style:
                                        (
                                          theme.textTheme.headlineMedium ??
                                              const TextStyle(fontSize: 26)
                                        )
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                              fontFeatures: const [
                                                FontFeature.tabularFigures(),
                                              ],
                                              color: p.text,
                                              height: 1.1,
                                            ),
                                    child: _ElapsedText(startedAt: startedAt!),
                                  )
                                : Text(
                                    hint,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(color: p.muted),
                                  ),
                          ),
                          // The ping chip at the time's side: the last
                          // test's own number, the way the iOS card reads —
                          // and a tap measures it again, the way the
                          // reference's chip answers.
                          if (on && pingMs != null) ...[
                            const SizedBox(width: 10),
                            RadarPing(
                              active: testing,
                              color: state,
                              child: InkWell(
                                onTap: testing ? null : onTest,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                        8,
                                        4,
                                        8,
                                        4,
                                      ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: p.dark
                                        ? const Color(0xFF2C2C2E)
                                        : const Color(0xFFECECF1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      testing
                                          ? SweepLoader(
                                              color: p.muted,
                                              size: 12,
                                              stroke: 1.5,
                                            )
                                          : Icon(
                                              Icons.speed_rounded,
                                              size: 13,
                                              color: p.muted,
                                            ),
                                      const SizedBox(width: 4),
                                      FlipCounter(
                                        text: '$pingMs ms',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontFeatures: const [
                                                FontFeature.tabularFigures(),
                                              ],
                                              color: p.muted,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    // The session's numbers, the reference's card wears
                    // while the tunnel carries: the two rates side by
                    // side in the iOS group's own grey, the download in
                    // green and the upload in the aether's blue. The
                    // settings' own toggle decides they show at all.
                    if (on && showTraffic) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: p.dark
                              ? const Color(0xFF2C2C2E)
                              : const Color(0xFFECECF1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _AetherTrafficCell(
                                palette: p,
                                label: l.statDown,
                                bytes:
                                    (traffic?.down ?? 0) +
                                    (traffic?.directDown ?? 0),
                                rate: traffic?.downRate ?? 0,
                                color: p.dark
                                    ? const Color(0xFF34C759)
                                    : const Color(0xFF1E9E6B),
                              ),
                            ),
                            Expanded(
                              child: _AetherTrafficCell(
                                palette: p,
                                label: l.statUp,
                                bytes:
                                    (traffic?.up ?? 0) +
                                    (traffic?.directUp ?? 0),
                                rate: traffic?.upRate ?? 0,
                                color: p.dark
                                    ? const Color(0xFF0A84FF)
                                    : const Color(0xFF0A6CFF),
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
          ),
          ),
          const SizedBox(height: 18),
          // The morphing power button: a circle while off, a squircle
          // when the tunnel carries — the color and the radius both ride
          // the state, with the glow breathing only while connecting.
          _AetherPowerButton(
            on: on,
            busy: busy,
            error: error,
            dark: p.dark,
            batterySaver: batterySaver,
            tooltip: tooltip,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

/// One half of the aether card's traffic row: the direction's word, the
/// session's bytes bold beneath it, and the moment's rate — the
/// reference's TrafficValue in the app's own type.
class _AetherTrafficCell extends StatelessWidget {
  const _AetherTrafficCell({
    required this.palette,
    required this.label,
    required this.bytes,
    required this.rate,
    required this.color,
  });

  final _HomePalette palette;
  final String label;
  final int bytes;
  final int rate;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatBytes(bytes),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w800,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: p.text,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          formatRate(rate),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: p.muted,
          ),
        ),
      ],
    );
  }
}

/// The aether look's power button: the rounded square that becomes a
/// circle when the VPN rests, in the state's own system color, with the
/// reference's two glow layers breathing behind it while the tunnel
/// carries or is being made — the rest of the time nothing here redraws,
/// and the battery keeps its frames. A press sinks the button the way
/// the reference's spring does.
class _AetherPowerButton extends StatefulWidget {
  const _AetherPowerButton({
    required this.on,
    required this.busy,
    required this.error,
    required this.dark,
    required this.batterySaver,
    required this.tooltip,
    required this.onPressed,
  });

  final bool on;
  final bool busy;
  final bool error;

  /// The page's own darkness: the state's colors read it.
  final bool dark;

  /// The battery saver's word: the glow holds one pose when it stands.
  final bool batterySaver;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  State<_AetherPowerButton> createState() => _AetherPowerButtonState();
}

class _AetherPowerButtonState extends State<_AetherPowerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  bool _pressed = false;

  @override
  void didUpdateWidget(_AetherPowerButton old) {
    super.didUpdateWidget(old);
    // The glow runs only while the tunnel carries or is being made; every
    // other state holds one pose and the battery keeps the frames.
    final alive = (widget.on || widget.busy) && !widget.batterySaver;
    if (alive && !_breath.isAnimating) {
      _breath.repeat(reverse: true);
    } else if (!alive && _breath.isAnimating) {
      _breath.stop();
      _breath.value = 0;
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  Color get _color {
    if (widget.error) {
      return widget.dark ? const Color(0xFFFF3B30) : const Color(0xFFC0392B);
    }
    if (widget.busy) {
      return widget.dark ? const Color(0xFFFF9500) : const Color(0xFFC77D1E);
    }
    if (widget.on) {
      return widget.dark ? const Color(0xFF34C759) : const Color(0xFF1E9E6B);
    }
    // Ready to connect: the aether's own blue.
    return widget.dark ? const Color(0xFF0A84FF) : const Color(0xFF0A6CFF);
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    const size = 108.0;
    // The stage gives the glow room to breathe: the widest glow layer
    // stays inside it, so nothing clips.
    const stage = 176.0;
    final still = MediaQuery.of(context).disableAnimations;
    return Tooltip(
      message: widget.tooltip,
      child: AnimatedBuilder(
        animation: _breath,
        builder: (context, child) {
          final t = Curves.easeInOut.transform(_breath.value);
          final glowScale = 1.18 + 0.30 * t;
          final glowAlpha =
              (widget.on || widget.busy) && !widget.batterySaver && !still
              ? 0.34 - 0.26 * t
              : 0.0;
          final glow = color.withValues(alpha: glowAlpha);
          final radius = widget.on ? 34.0 : size / 2;
          return SizedBox(
            width: stage,
            height: stage,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The two glow layers, the reference's own: the wide one
                // breathing behind, the nearer one riding its back while
                // the tunnel carries.
                if (glowAlpha > 0) ...[
                  Transform.scale(
                    scale: glowScale,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: glow,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: glowScale * 0.74,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: color.withValues(alpha: glowAlpha * 1.7),
                      ),
                    ),
                  ),
                ],
                child!,
              ],
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.busy ? null : widget.onPressed,
            onTapDown: widget.busy
                ? null
                : (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: AnimatedScale(
              // The press's own sink, the reference's spring in spirit:
              // the button yields a shade under the finger and returns
              // with a soft overshoot.
              scale: _pressed ? 0.88 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: _pressed ? Curves.easeOut : Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.on ? 34 : size / 2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.32),
                      Colors.white.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                  ),
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(
                        alpha: widget.on || widget.busy ? 0.35 : 0.22,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  size: 44,
                  color: Colors.white,
                  shadows: widget.dark
                      ? null
                      : const [Shadow(color: Color(0x33000000), blurRadius: 6)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The zed home's hero: the gradient blob the ZedSecure design wears —
/// one breathing orb painted with the brand's own light: violet, pink
/// and lime while the tunnel carries, the cooler cyan swell while the
/// connection is being made, the dim violet when it rests. The session's
/// time stands in its middle; the page's server card names the place.
class _ZedBlobCard extends StatefulWidget {
  const _ZedBlobCard({
    required this.palette,
    required this.on,
    required this.busy,
    required this.tooltip,
    required this.startedAt,
    required this.batterySaver,
    required this.onPressed,
  });

  final _HomePalette palette;
  final bool on;
  final bool busy;
  final String tooltip;
  final DateTime? startedAt;

  /// The battery saver's word: the blob holds its breath when it stands.
  final bool batterySaver;
  final VoidCallback onPressed;

  @override
  State<_ZedBlobCard> createState() => _ZedBlobCardState();
}

class _ZedBlobCardState extends State<_ZedBlobCard>
    with TickerProviderStateMixin {
  late final AnimationController _breathe = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  /// The shape's own walk: the cookie the blob rests as turns itself into
  /// the soft burst the reference wears while the tunnel carries, and
  /// back — one run per state change, never a loop of its own.
  late final AnimationController _morph = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
    value: widget.on || widget.busy ? 1 : 0,
  );

  @override
  void didUpdateWidget(_ZedBlobCard old) {
    super.didUpdateWidget(old);
    // The blob breathes only while the connection is alive; every other
    // state holds one pose and the battery keeps the frames.
    final alive = (widget.on || widget.busy) && !widget.batterySaver;
    if (alive && !_breathe.isAnimating) {
      _breathe.repeat(reverse: true);
    } else if (!alive && _breathe.isAnimating) {
      _breathe.stop();
      _breathe.value = 0;
    }
    // The shape follows the state; reduce-motion lands it at once.
    final active = widget.on || widget.busy;
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _morph.stop();
      _morph.value = active ? 1 : 0;
    } else {
      _morph.animateTo(active ? 1 : 0, curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _breathe.dispose();
    _morph.dispose();
    super.dispose();
  }

  /// The blob's own light, ZedSecure's gradients on both modes: the
  /// brand's violet-pink-lime when the tunnel carries, the violet-cyan
  /// while it is being made, the dim violet when it rests — the same
  /// diagonal sweep the reference paints its blob with.
  List<Color> get _blobColors {
    final dark = widget.palette.dark;
    return widget.busy
        ? const [Color(0xFF7A5CFF), Color(0xFF37E0D8), Color(0xFFC7F24E)]
        : widget.on
        ? const [Color(0xFF7A5CFF), Color(0xFFFF5FA2), Color(0xFFC7F24E)]
        : dark
        ? const [Color(0xFF43359B), Color(0xFF2A1361)]
        : const [Color(0xFF7A5CFF), Color(0xFF5646D6)];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.palette;
    const blob = 212.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: widget.tooltip,
          child: AnimatedBuilder(
            animation: Listenable.merge([_breathe, _morph]),
            builder: (context, child) {
              final s = 1.0 + 0.06 * Curves.easeOut.transform(_breathe.value);
              final alive = widget.on || widget.busy;
              final dark = p.dark;
              return Transform.scale(
                scale: s,
                child: RepaintBoundary(
                  // The blob's own boundary: its breath repaints every
                  // frame it runs, and this keeps that redraw inside the
                  // orb — the page around it never repaints for it.
                  child: CustomPaint(
                    size: const Size.square(blob + 24),
                    painter: _ZedBlobPainter(
                      morph: _morph.value,
                      colors: _blobColors,
                      glows: alive
                          ? [
                              (
                                color: const Color(0xFF7A5CFF)
                                    .withValues(alpha: dark ? 0.40 : 0.30),
                                blur: 38,
                              ),
                              (
                                color: const Color(0xFFFF5FA2)
                                    .withValues(alpha: dark ? 0.25 : 0.16),
                                blur: 52,
                              ),
                            ]
                          : const [],
                    ),
                    child: child!,
                  ),
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.busy ? null : widget.onPressed,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: blob + 24,
                  height: blob + 24,
                  child: Center(
                    // The center's selves cross-fade the reference's own
                    // way: the loader, the time and the power's mark never
                    // hard-swap — one fades out while the next fades in.
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.9, end: 1.0).animate(anim),
                          child: child,
                        ),
                      ),
                      child: widget.busy
                          ? const SizedBox.square(
                              key: ValueKey('busy'),
                              dimension: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : widget.on && widget.startedAt != null
                          ? DefaultTextStyle(
                              key: const ValueKey('elapsed'),
                              style:
                                  (theme.textTheme.headlineLarge ??
                                          const TextStyle(fontSize: 34))
                                      .copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                        color: Colors.white,
                                      ),
                              child: _ElapsedText(startedAt: widget.startedAt!),
                            )
                          : const Icon(
                              key: ValueKey('power'),
                              Icons.power_settings_new_rounded,
                              size: 46,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One glow layer the blob paints beneath itself: the color and how far
/// it blurs.
typedef _ZedGlow = ({Color color, double blur});

/// The blob's own body: a nine-lobed cookie that turns itself into the
/// reference's soft burst while the tunnel carries. The lobes ride one
/// polar function, so the morph is one path moving, not two shapes cut
/// against each other; the gradient and the glow layers follow the path.
class _ZedBlobPainter extends CustomPainter {
  _ZedBlobPainter({
    required this.morph,
    required this.colors,
    required this.glows,
  });

  final double morph;
  final List<Color> colors;
  final List<_ZedGlow> glows;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // The body sits inside the tap target's own halo: the lobes' widest
    // breath stays within it, so nothing clips.
    final base = size.shortestSide / 2 - 14;
    final path = _blobPath(center, base, morph);
    for (final glow in glows) {
      final paint = Paint()
        ..color = glow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow.blur / 2.2);
      canvas.drawPath(path, paint);
    }
    final bounds = path.getBounds();
    // dart:ui's linear gradient wants the stops spelled out when the
    // brand's gradient carries more than its two ends.
    final stops = <double>[
      for (var i = 0; i < colors.length; i++)
        colors.length == 1 ? 0.0 : i / (colors.length - 1),
    ];
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        bounds.topLeft,
        bounds.bottomRight,
        colors,
        stops,
      );
    canvas.drawPath(path, paint);
  }

  /// The shape: nine lobes on [r], the peak's sharpness [k] and the
  /// lobes' height [a] both riding the morph — the cookie's soft bumps
  /// at rest, the burst's taller, sharper petals while it carries.
  Path _blobPath(Offset c, double r, double t) {
    const lobes = 9.0;
    final a = 0.05 + 0.055 * t;
    final k = 1.0 + 1.2 * t;
    final phi = 0.14 * t;
    final path = Path();
    const steps = 132;
    for (var i = 0; i <= steps; i++) {
      final th = 2 * math.pi * i / steps;
      final f = math.pow(0.5 + 0.5 * math.cos(lobes * th + phi), k).toDouble();
      final rr = r * (1 + a * f);
      final p = c + Offset(rr * math.cos(th), rr * math.sin(th));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_ZedBlobPainter old) {
    if (old.morph != morph) return true;
    if (old.colors.length != colors.length) return true;
    if (old.glows.length != glows.length) return true;
    for (var i = 0; i < colors.length; i++) {
      if (old.colors[i] != colors[i]) return true;
    }
    for (var i = 0; i < glows.length; i++) {
      if (old.glows[i] != glows[i]) return true;
    }
    return false;
  }
}

/// The zed page's opening pair: the two rate cards the reference wears
/// under its header — download in the carrying green, upload in the
/// design's violet, the session's bytes muted beneath each rate. The
/// reference keeps them on the page whatever the connection says; ours
/// do too: alive with the session's numbers while the tunnel carries,
/// resting at their zeros when it does not.
class _ZedRatePair extends StatelessWidget {
  const _ZedRatePair({required this.palette, required this.traffic});

  final _HomePalette palette;

  /// The session's own numbers; null while the tunnel rests — the pair
  /// stands at its zeros.
  final Traffic? traffic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = palette;
    final t = traffic;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _RateCell(
                palette: p,
                label: l.statDown,
                icon: Icons.south_rounded,
                bytes: (t?.down ?? 0) + (t?.directDown ?? 0),
                rate: t?.downRate ?? 0,
                color: p.dark
                    ? const Color(0xFF34C759)
                    : const Color(0xFF1E9E6B),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _RateCell(
                palette: p,
                label: l.statUp,
                icon: Icons.north_rounded,
                bytes: (t?.up ?? 0) + (t?.directUp ?? 0),
                rate: t?.upRate ?? 0,
                color: DesignStyle.of(context).navActive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The zed page's server card — the reference's bright pill over the
/// dock: the place's name bold with the change's word muted beneath, and
/// a white circle with the globe's glyph at its end. A tap opens the
/// servers page, the way the reference's own card answers.
class _ZedServerCard extends StatelessWidget {
  const _ZedServerCard({
    required this.palette,
    required this.place,
    this.onOpenServers,
  });

  final _HomePalette palette;
  final HomePlace place;
  final VoidCallback? onOpenServers;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final violet = DesignStyle.of(context).navActive;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Material(
        color: violet,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpenServers,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 11, 11, 11),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              place.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (place.auto) ...[
                            const SizedBox(width: 5),
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 13,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.tapToChangeServer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.public_rounded, size: 22, color: violet),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The iOS home: the system's own status card.
// ---------------------------------------------------------------------------

/// The capsule's breath while the connection is being made: a slow,
/// light swell on the whole button — the wait made visible without a
/// new surface. The controller runs only while [active]; the moment the
/// state settles, the button stands still again and costs nothing.
class _CapsuleBreath extends StatefulWidget {
  const _CapsuleBreath({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<_CapsuleBreath> createState() => _CapsuleBreathState();
}

class _CapsuleBreathState extends State<_CapsuleBreath>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_CapsuleBreath old) {
    super.didUpdateWidget(old);
    if (widget.active && !_c.isAnimating) {
      _c.repeat(reverse: true);
    } else if (!widget.active && _c.isAnimating) {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        return Transform.scale(scale: 1.0 + 0.012 * t, child: child);
      },
      child: widget.child,
    );
  }
}

/// The iOS home's status card: the system's own voice — the raised
/// rounded sheet with the state's dot and word, the place's cell (the
/// flag, the name, the chevron to the servers), the session's numbers in
/// their inset-grouped table, and the full-width capsule button under
/// them: filled blue while off, the state's own tint while on. No glass,
/// no glow — the clarity is the style, the hairline is the line.
class _IosStatusCard extends StatelessWidget {
  const _IosStatusCard({
    required this.palette,
    required this.place,
    required this.on,
    required this.busy,
    required this.error,
    required this.label,
    required this.press,
    required this.startedAt,
    required this.pingMs,
    required this.traffic,
    required this.showTraffic,
    required this.onOpenServers,
    required this.onPressed,
  });

  final _HomePalette palette;
  final HomePlace place;
  final bool on;
  final bool busy;

  /// The start gave up on its own: the card's light reads red.
  final bool error;
  final String label;

  /// The tap's own word — the button's label (state-aware already).
  final String press;
  final DateTime? startedAt;
  final int? pingMs;
  final Traffic? traffic;
  final bool showTraffic;
  final VoidCallback? onOpenServers;
  final VoidCallback onPressed;

  /// The system's own state lights: the green carries, the amber
  /// reaches, the red blocks, the gray rests.
  Color get _state {
    final p = palette;
    final style = DesignStyle.resolve('ios', p.dark);
    if (error) return style.danger;
    if (busy) return style.scanning;
    if (on) return style.connected;
    return p.dark ? const Color(0xFF98989F) : const Color(0xFF999CA1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final p = palette;
    final style = DesignStyle.of(context);
    final state = _state;
    final blue = style.navActive;
    final groupColor = p.dark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The status card: the raised sheet, the hairline's edge, the
          // state's word over the place's cell.
          Material(
            color: p.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: p.cardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // The state's own dot; while the connection is being
                      // made it breathes — the wait made visible.
                      busy
                          ? PulseDot(color: state, size: 9)
                          : Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state,
                              ),
                            ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            letterSpacing: 0.2,
                            color: state,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // The place's cell: the system settings' own row — the
                  // flag, the name, the chevron; a tap opens the servers.
                  InkWell(
                    onTap: onOpenServers,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        12,
                        10,
                        8,
                        10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: groupColor,
                      ),
                      child: Row(
                        children: [
                          CountryFlag(code: place.flag, width: 22),
                          const SizedBox(width: 10),
                          if (place.auto) ...[
                            Icon(Icons.auto_awesome_rounded,
                                size: 13, color: blue),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              place.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: p.text,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: p.muted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // The session's numbers: the inset-grouped table, the
                  // system's own — the label left, the value right, the
                  // hairlines between. The elapsed rides the top row while
                  // the tunnel carries; the dashes keep the seats when it
                  // does not.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: groupColor,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        if (on && startedAt != null) ...[
                          _iosRow(
                            context,
                            theme,
                            p,
                            l.statElapsed,
                            _ElapsedText(startedAt: startedAt!),
                          ),
                          _iosLine(p),
                        ],
                        _iosRow(
                          context,
                          theme,
                          p,
                          l.realDelay,
                          Text(
                            pingMs != null ? '$pingMs ms' : '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showTraffic) ...[
                          _iosLine(p),
                          _iosRow(
                            context,
                            theme,
                            p,
                            l.statDown,
                            Text(formatRate(traffic?.downRate ?? 0),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          _iosLine(p),
                          _iosRow(
                            context,
                            theme,
                            p,
                            l.statUp,
                            Text(formatRate(traffic?.upRate ?? 0),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // The capsule button: filled blue while off and while the
          // connection is being made, the state's own tint when the
          // tunnel carries — the system's two weights of the same press.
          // The press sinks it a touch; the connecting wait breathes it,
          // the wait made visible without a new surface.
          _CapsuleBreath(
            active: busy,
            child: Pressable(
              depth: 0.025,
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: busy ? null : onPressed,
              borderRadius: BorderRadius.circular(27),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 54,
                decoration: BoxDecoration(
                  color: on && !busy && !error
                      ? state.withValues(alpha: 0.16)
                      : blue,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                    child: Row(
                      key: ValueKey('$label-$busy'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (busy) ...[
                          SizedBox.square(
                            dimension: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: on ? blue : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          busy
                              ? AppLocalizations.of(context).stateConnecting
                              : press,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.5,
                            letterSpacing: 0.2,
                            color: on && !busy && !error
                                ? state
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
            ),
          ),
        ],
      ),
    );
  }

  /// One row of the grouped table: the label left, the value right, the
  /// value in the display's own voice with the tabular figures.
  Widget _iosRow(
    BuildContext context,
    ThemeData theme,
    _HomePalette p,
    String label,
    Widget value,
  ) {
    final typefaces = typefacesOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(color: p.text),
            ),
          ),
          DefaultTextStyle(
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
              fontFamily: typefaces.display,
              fontFamilyFallback: typefaces.displayFallback,
              color: p.text,
            ) ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            child: value,
          ),
        ],
      ),
    );
  }

  /// The table's hairline: a half-point line, inset to the text's start.
  Widget _iosLine(_HomePalette p) => Divider(
    height: 1,
    thickness: 0.5,
    indent: 12,
    color: p.cardBorder.withValues(alpha: 0.7),
  );
}
