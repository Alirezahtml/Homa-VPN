import 'dart:io';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
import 'flag_carousel.dart';
import 'format.dart';
import 'motion.dart';
import 'port_dialog.dart';
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
    return p.dark
        ? Theme(data: midnightTheme(Theme.of(context)), child: page)
        : page;
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
            onPressed: () => status.totalAccounts == 0
                ? _openAccounts(context, core, settings, onOpenAccounts)
                : runShowingErrors(context, () => _power(!on)),
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
  const _HomePill({required this.palette, required this.child});

  final _HomePalette palette;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: ShapeDecoration(
      color: palette.card,
      shape: StadiumBorder(side: BorderSide(color: palette.cardBorder)),
    ),
    child: child,
  );
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
        onTap: onSelected == null || chosen ? null : () => onSelected(m.value),
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

/// The home's palette for this build: night or day, in the app's one
/// monochrome design, with the chosen accent ([AppAccent]) in the
/// state's lights when one is set.
_HomePalette _homePalette(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final p = dark ? _HomePalette.night : _HomePalette.day;
  final accent = AppAccent.current;
  return accent == null ? p : p.tinted(accent);
}

/// The phone's home: the switch in the middle over soft lights and wavy
/// contour lines in the state's color, the state under it, then where the
/// traffic goes and the data used. Light or dark with the app's theme; the
/// email is on the accounts page.
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
    // The home's map kind, read once: the world carries it, and the
    // wheel's name rides on whether the kind has a floating card of its
    // own (the ball kinds) or not (the flat kinds).
    final mapKind = MapKind.values.asNameMap()[settings.mapKind] ??
        MapKind.classic;
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
                  final selectedCode = (status.exit?.countryCode.isNotEmpty ==
                              true
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
                      style: GlobeStyle.values
                          .asNameMap()[settings.mapStyle] ??
                          GlobeStyle.silver,
                      still: settings.batterySaver,
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
          ],
        ),
      ),
    );
    return p.dark
        ? Theme(data: midnightTheme(Theme.of(context)), child: page)
        : page;
  }

  Widget _content(BuildContext context, _HomePalette p, BoxConstraints box) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final look = PhaseLook.of(l, status);
    // The home's map kind here too: the wheel's name rides on whether
    // the kind has a floating card of its own (the ball kinds) or not
    // (the flat kinds).
    final mapKind = MapKind.values.asNameMap()[settings.mapKind] ??
        MapKind.classic;
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
    // The design the user chose for this home: the wheel, the tiles, or
    // the compact card. Everything the designs share (the state's word,
    // the problem boxes, the notices, the data) stays put; what changes
    // is how the three own things are laid out: the place, the switch,
    // and the numbers.
    final design = settings.homeDesign;
    return Padding(
      // The bottom clears the floating pill navigation, which the page
      // runs beneath — with room to breathe, not a dead band: the cards
      // sit close above it.
      padding: EdgeInsets.fromLTRB(side, top + 14, side, 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The brand: the official wordmark, in the theme's face.
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
                  still: settings.batterySaver,
                  showName: mapKind != MapKind.globe &&
                      mapKind != MapKind.satellite,
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
          ] else ...[
            // The compact home: its place is a chip in its own card
            // below; here only the space the card breathes in.
            const SizedBox(height: 24),
          ],
          // The state, in words, where the island used to live. The tiles'
          // home carries it inside its connect bar instead.
          if (design != 'bento')
            Reveal(
              index: 1,
              child: CrossfadeText(
                label,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: on ? accent : p.text,
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
                  busy: core.switchingProxy,
                  accent: accent,
                  dark: p.dark,
                  card: p.card,
                  border: p.cardBorder,
                  text: p.text,
                  muted: p.muted,
                  labelConnect: l.slideToConnect,
                  labelDisconnect: l.slideToDisconnect,
                  // The state's word stays in the track once connected;
                  // while the connection is still being confirmed the
                  // track keeps the connect hint (nothing is claimed yet).
                  labelOn: confirming ? '' : l.stateConnected,
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
                  accent: accent,
                  tooltip: press,
                  batterySaver: settings.batterySaver,
                  onOpenServers: onOpenServers,
                  onPressed: () => status.totalAccounts == 0
                      ? _openAccounts(context, core, settings, onOpenAccounts)
                      : runShowingErrors(context, () => _toggle(on)),
                ),
              ),
            ),
            SizedBox(height: short ? 8 : 18),
          ],
          if (connected) ...[
            // The connection's numbers, in the page itself: the time
            // it has been up, the real delay, the live rates. The wheel
            // and the tiles lay them out as cards; the compact home as
            // rows inside one card of its own.
            if (design == 'pixel')
              _FlatStats(
                core: core,
                status: status,
                palette: p,
                startedAt: proxy?.startedAt,
                pingMs: (test?.ok ?? false) ? test!.responseMs : null,
                showTraffic: settings.showTraffic,
              )
            else
              _HomeStats(
                core: core,
                status: status,
                palette: p,
                startedAt: proxy?.startedAt,
                pingMs: (test?.ok ?? false) ? test!.responseMs : null,
                showTraffic: settings.showTraffic,
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
                    child: Icon(Icons.copy_rounded, size: 14, color: p.muted),
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
          ] else if (failing || noNetwork || gaveUp)
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
          else if (design == 'bento')
            // The tiles' connect bar already says the tap's own hint; the
            // plain hint line below would only say it twice. The state's
            // own guidance still has the problem boxes above.
            const SizedBox.shrink()
          else
            // A start failure's hint is general; the core's reason is
            // on a long press.
            Tooltip(
              message:
                  !status.connectPending && status.state.phase == Phase.error
                  ? status.state.message
                  : '',
              child: Text(
                look.hint.isNotEmpty ? look.hint : press,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: p.muted),
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
            // switch sits on; the wheel's and the tiles' homes keep the
            // place's own card down here.
            if (design != 'pixel') ...[
              Reveal(
                index: 4,
                child: _PlaceCard(
                  palette: p,
                  place: place,
                  accent: accent,
                  onTap: onOpenServers,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Reveal(
              index: 5,
              child: _HomeData(
                status: status,
                palette: p,
                onTap: onOpenAccounts,
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
  Widget build(BuildContext context) => DecoratedBox(
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
      child: Material(
        color: palette.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: palette.cardBorder),
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
  );
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
    final (text, color) = switch (test) {
      null => (l.testConnection, palette.muted),
      final t when !t.ok => (l.testFailed, palette.error),
      final t => (l.milliseconds(t.responseMs), delayColor(t.responseMs)),
    };
    return Tooltip(
      message: '${l.realDelay} · ${l.testConnection}',
      child: Material(
        color: palette.card,
        shape: StadiumBorder(side: BorderSide(color: palette.cardBorder)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: core.testing
              ? null
              : () => runShowingErrors(context, core.runTest),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (core.testing)
                  const SizedBox.square(
                    dimension: 12,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  )
                else
                  Icon(Icons.bolt_rounded, size: 16, color: color),
                const SizedBox(width: 4),
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
    required this.startedAt,
    required this.pingMs,
    this.showTraffic = true,
  });

  final CoreController core;
  final CoreStatus status;
  final _HomePalette palette;
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
            Text(
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
            busy: core.testing
                ? const SizedBox.square(
                    dimension: 14,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  )
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
    final child = Container(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.cardBorder),
      ),
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

class _ElapsedTextState extends State<_ElapsedText> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: p.muted),
          const SizedBox(width: 10),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: p.muted),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: p.text,
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
    Widget disc = AnimatedContainer(
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
          color: on
              ? Colors.white.withValues(alpha: 0.4)
              : p.discOffEdge,
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
      disc = PulseHalo(
        color: accent,
        baseSize: disc,
        paused: batterySaver,
        child: disc,
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
            disc,
            // The arrival's own mark: the check strokes itself in, once,
            // each time the connection lands. Gone while the switch is
            // still turning, so it never blinks between states.
            if (on && !busy)
              Positioned(left: 162, top: 162, child: _CheckBadge(accent: accent)),
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
      child: Center(child: DrawCheck(color: accent, size: 14, strokeWidth: 2.4)),
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
        showToast(
          context,
          l.copied(address),
          mark: ToastMark.copy,
        );
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
              icon: Icons.system_update_alt_rounded,
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
              icon: Icons.system_update_alt_rounded,
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
          icon: Icons.system_update_alt_rounded,
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
    required this.accent,
    required this.tooltip,
    required this.onOpenServers,
    required this.onPressed,
    this.batterySaver = false,
  });

  final _HomePalette palette;
  final HomePlace place;
  final bool on;
  final bool busy;
  final Color accent;
  final String tooltip;
  final VoidCallback? onOpenServers;
  final VoidCallback onPressed;

  /// The battery saver's word, for the orb's own breath.
  final bool batterySaver;

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
                          color: accent,
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
              // The compact home's orb: a touch smaller than the desktop's
              // own, so its card stays a card and not a hall.
              Transform.scale(
                scale: 0.88,
                child: _PowerOrb(
                  palette: p,
                  on: on,
                  accent: accent,
                  busy: busy,
                  batterySaver: batterySaver,
                  tooltip: tooltip,
                  onPressed: onPressed,
                ),
              ),
            ],
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
  });

  final CoreController core;
  final CoreStatus status;
  final _HomePalette palette;
  final DateTime? startedAt;
  final int? pingMs;
  final bool showTraffic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = palette;
    final traffic = status.traffic;
    final ping = pingMs;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: _HomeCard(
        palette: p,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
          child: Column(
            children: [
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
                const SizedBox(height: 10),
                _FlatRow(
                  palette: p,
                  icon: Icons.swap_vert_rounded,
                  label: l.statSession,
                  value: Text(
                    '↓ ${formatBytes((traffic?.down ?? 0) + (traffic?.directDown ?? 0))}'
                    ' · '
                    '↑ ${formatBytes((traffic?.up ?? 0) + (traffic?.directUp ?? 0))}',
                  ),
                ),
              ],
            ],
          ),
        ),
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
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: p.muted),
            ),
            const Spacer(),
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
