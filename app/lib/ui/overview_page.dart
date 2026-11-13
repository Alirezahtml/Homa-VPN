import 'dart:async';
import 'dart:io';
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
import 'browser_signin.dart';
import 'connection_mode.dart';
import 'design.dart';
import 'format.dart';
import 'motion.dart';
import 'port_dialog.dart';
import 'widgets.dart';

/// The home page: one circle to press, the state over it, the session
/// (time, upload, download) under it, and where the traffic goes and the
/// data used in cards. The phone's (_PhoneHome) and the computer's
/// (_DesktopHome) share the look, not the logic. Developer mode adds the
/// details.
///
/// The state the page shows comes from the engine's phase alone: when the
/// engine is running and the switch is on, the page says "Connected" — a
/// failing test keeps its own note under the state, it does not hold the
/// state back.
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

  /// The phone layout: the big button and the cards (_PhoneHome).
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

/// The connection as the home page reads it, derived in one place so the
/// phone and the computer say the same.
class HomeState {
  HomeState.of(
    AppLocalizations l,
    CoreController core,
    CoreStatus status, {
    required bool showIp,
    required bool on,
  }) {
    this.on = on;
    final running = status.state.phase == Phase.running;
    final starting = status.state.phase == Phase.starting;
    connecting =
        status.connectPending || core.switchingProxy || (on && starting);
    final test = status.isCurrentTest(core.lastTest) ? core.lastTest : null;
    final proxy = status.proxy;
    noNetwork = !status.connectPending && status.noNetwork && on;
    // Connected when the engine runs and the switch is on; the page does
    // not wait for a test to say so. Without a network it keeps waiting:
    // nothing can work yet.
    connected = on && running && !connecting && !noNetwork;
    failing =
        !status.connectPending &&
        on &&
        running &&
        ((proxy?.wakeError.isNotEmpty ?? false) || test?.ok == false);
    failure = failing ? failureText(l, proxy, test) : null;
    gaveUp = !on && status.connectFailure.isNotEmpty;
    look = PhaseLook.of(l, status);
    place = homeLocation(l, status, connected: connected);
    ip = !showIp
        ? ''
        : status.exit?.ipv4.isNotEmpty == true
        ? status.exit!.ipv4
        : status.exit?.ipv6 ?? '';
    mismatch = exitMismatchText(l, status);
    label = connecting
        ? l.stateConnecting
        : connected
        ? l.stateConnected
        // Without a network nothing can work yet: it keeps waiting.
        : noNetwork
        ? l.stateConnecting
        : look.label;
  }

  late final bool on;
  late final bool connecting;
  late final bool connected;
  late final bool failing;
  late final bool noNetwork;
  late final bool gaveUp;
  late final PhaseLook look;
  late final HomePlace place;
  late final String ip;
  late final String? mismatch;
  late final String label;
  late final ({String text, String detail, String code})? failure;
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
    padding: const EdgeInsets.only(top: Homa.gap2),
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
    padding: const EdgeInsets.only(top: Homa.gap2),
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: Homa.gap3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProblemBox(
            text: by.isEmpty
                ? l.systemProxyTakenOff
                : l.systemProxyTakenBy(ltr(by)),
            dark: dark,
          ),
          const SizedBox(height: Homa.gap2),
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

/// A soft box when the public IP is in another country than the chosen
/// one: a hint, not an error; the connection works.
class _ExitMismatchNote extends StatelessWidget {
  const _ExitMismatchNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Homa.gap3),
    child: _ProblemBox(text: text, dark: Theme.of(context).brightness == Brightness.dark),
  );
}

/// The widest a [_ProblemBox] grows.
const _problemBoxWidth = 460.0;

/// A home-page problem in a quiet box, so it stands out from the ordinary
/// hints: the alternate card's fill, a hairline border, and the warning
/// icon. The palette has no red; the icon and the words carry the meaning.
class _ProblemBox extends StatelessWidget {
  const _ProblemBox({required this.text, required this.dark, this.tooltip = ''});

  final String text;
  final bool dark;

  /// The core's own words, on hover or a long press.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _problemBoxWidth),
        child: Tooltip(
          message: tooltip,
          child: Container(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 11, 14, 11),
            decoration: BoxDecoration(
              color: Homa.cardAlt(dark),
              borderRadius: BorderRadius.circular(Homa.radiusBox),
              border: Border.all(color: Homa.borderStrong(dark)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 18,
                  color: Homa.ink(dark),
                ),
                const SizedBox(width: Homa.gap2),
                Flexible(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Homa.ink(dark),
                      fontWeight: FontWeight.w600,
                    ),
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
/// disconnects. Where the traffic goes and the data used are in cards; the
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final page = DecoratedBox(
      decoration: BoxDecoration(color: dark ? Homa.black : Homa.white),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _content(context, dark),
          ),
        ),
      ),
    );
    return page;
  }

  bool get _running => status.state.phase == Phase.running;

  Widget _content(BuildContext context, bool dark) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final status = this.status;
    final proxy = status.proxy;
    final on = status.proxyOn;
    final s = HomeState.of(l, core, status, showIp: showIp, on: on);
    final cards = [
      Reveal(
        index: 4,
        child: _PlaceCard(
          dark: dark,
          place: s.place,
          onTap: onOpenServers,
        ),
      ),
      Reveal(
        index: 5,
        child: _DataCard(
          status: status,
          dark: dark,
          onTap: onOpenAccounts,
        ),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Reveal(
          index: 0,
          child: Center(
            child: _Orb(
              on: on,
              busy: s.connecting,
              connected: s.connected,
              dark: dark,
              tapToConnect: l.tapToConnect,
              tapToDisconnect: l.tapToDisconnect,
              onToggle: () => status.totalAccounts == 0
                  ? _openAccounts(context, core, settings, onOpenAccounts)
                  : runShowingErrors(context, () => _power(!on)),
              onSwipeDown: status.totalAccounts == 0
                  ? null
                  : () => runShowingErrors(context, () => _power(true)),
              onSwipeUp: status.totalAccounts == 0
                  ? null
                  : () => runShowingErrors(context, () => _power(false)),
            ),
          ),
        ),
        const SizedBox(height: Homa.gap4),
        Reveal(
          index: 1,
          child: _Headline(state: s, dark: dark),
        ),
        const SizedBox(height: Homa.gap4),
        if (s.connected && !s.failing)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: Homa.gap2,
            runSpacing: Homa.gap2,
            children: [
              _HomeDelay(core: core, dark: dark),
              if (s.ip.isNotEmpty)
                _HomePill(
                  dark: dark,
                  child: Text(
                    '${l.publicIp} ${ltr(s.ip)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Homa.muted(dark),
                    ),
                  ),
                ),
              if (status.upstreamProxy.isNotEmpty)
                _UpstreamProxyPill(
                  address: status.upstreamProxy,
                  dark: dark,
                  onPressed: onOpenUpstreamProxy,
                ),
            ],
          )
        else if (s.failing || s.noNetwork || s.gaveUp)
          // Not connecting stands out from the ordinary hints.
          _ProblemBox(
            text: s.noNetwork
                ? l.noNetwork
                : s.failure != null
                ? s.failure!.text
                : failureCodeText(l, status.connectFailure),
            dark: dark,
            tooltip: s.noNetwork ? '' : s.failure?.detail ?? '',
          )
        else
          // A start failure's hint is general; the core's reason is on
          // hover or a long press.
          Tooltip(
            message: !status.connectPending && status.state.phase == Phase.error
                ? status.state.message
                : '',
            child: Text(
              !on ? l.tapToConnect : s.look.hint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Homa.muted(dark),
              ),
            ),
          ),
        if (s.failure?.code == Failure.unreachable && onOpenConnection != null)
          _ConnectionSettingsButton(onPressed: onOpenConnection!),
        if (s.failure?.code == Failure.upstreamProxy &&
            onOpenUpstreamProxy != null)
          _ConnectionSettingsButton(
            onPressed: onOpenUpstreamProxy!,
            label: AppLocalizations.of(context).upstreamProxy,
          ),
        if (!s.connected &&
            status.upstreamProxy.isNotEmpty &&
            s.failure?.code != Failure.upstreamProxy)
          Padding(
            padding: const EdgeInsets.only(top: Homa.gap2),
            child: Center(
              child: _UpstreamProxyPill(
                address: status.upstreamProxy,
                dark: dark,
                onPressed: onOpenUpstreamProxy,
              ),
            ),
          ),
        if (isLocationRefused(s.failure?.code ?? '') ||
            (s.gaveUp && isLocationRefused(status.connectFailure)))
          _RecommendedLocationButton(core: core),
        if (s.connected && s.mismatch != null) _ExitMismatchNote(text: s.mismatch!),
        if (status.systemProxySet && status.systemProxyTakenBy != null)
          _SystemProxyTakenNote(core: core, by: status.systemProxyTakenBy!),
        if (status.state.proxyPortBlocked) ...[
          const SizedBox(height: Homa.gap3),
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
        const SizedBox(height: Homa.gap4),
        // The same choice as the button and the tray, by name, where this
        // computer has more than proxy only.
        if (status.systemProxySupported || status.tunSupported)
          Center(
            child: _ModeSwitch(
              dark: dark,
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
        const SizedBox(height: Homa.gap2),
        Text(
          // Windows names itself; Linux and macOS say "the system".
          connectionModeHint(
            l,
            status,
            installing: core.installingTun,
            windows: defaultTargetPlatform == TargetPlatform.windows,
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(color: Homa.muted(dark)),
        ),
        TunNote(
          core: core,
          box: (text, tooltip) => _ProblemBox(text: text, dark: dark, tooltip: tooltip),
        ),
        const SizedBox(height: Homa.gap5),
        _UpdateNotice(core: core, settings: settings, dark: dark),
        _UdpNotice(status: status, settings: settings, dark: dark),
        _Notices(notices: homeNotices(status.notices), dark: dark),
        _LowQuotaNotice(
          core: core,
          status: status,
          settings: settings,
          connected: s.connected,
          dark: dark,
        ),
        // Side by side when there is room.
        LayoutBuilder(
          builder: (context, box) => box.maxWidth >= 560
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: Homa.gap3),
                      Expanded(child: cards[1]),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    cards[0],
                    const SizedBox(height: Homa.gap3),
                    cards[1],
                  ],
                ),
        ),
      ],
    );
  }
}

/// A small pill on the home background.
class _HomePill extends StatelessWidget {
  const _HomePill({required this.dark, required this.child});

  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: ShapeDecoration(
      color: Homa.cardAlt(dark),
      shape: StadiumBorder(side: BorderSide(color: Homa.border(dark))),
    ),
    child: child,
  );
}

/// While the upstream proxy is on: says so whatever the connection's state, with
/// its address on hover or a long press, and opens its settings.
class _UpstreamProxyPill extends StatelessWidget {
  const _UpstreamProxyPill({
    required this.address,
    required this.dark,
    this.onPressed,
  });

  final String address;
  final bool dark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: ltr(address),
    child: Material(
      color: Homa.cardAlt(dark),
      shape: StadiumBorder(side: BorderSide(color: Homa.border(dark))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lan_outlined, size: 16, color: Homa.ink(dark)),
              const SizedBox(width: Homa.gap1 + 2),
              Text(
                AppLocalizations.of(context).upstreamProxyOn,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Homa.muted(dark),
                ),
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
    required this.dark,
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final bool dark;
  final List<_Mode> modes;
  final String selected;

  /// Null while a change is under way.
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final n = modes.length;
    final index = modes.indexWhere((m) => m.value == selected);
    final still = MediaQuery.of(context).disableAnimations;
    final onSelected = this.onSelected;
    Widget option(_Mode m) {
      final chosen = m.value == selected;
      final color = chosen ? Homa.onInk(dark) : Homa.muted(dark);
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
              const SizedBox(width: Homa.gap2),
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
            color: Homa.cardAlt(dark),
            shape: StadiumBorder(side: BorderSide(color: Homa.border(dark))),
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
                            : const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        child: FractionallySizedBox(
                          widthFactor: 1 / n,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: Homa.ink(dark),
                              shape: const StadiumBorder(),
                            ),
                          ),
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

/// The real delay under the state; a tap tests again.
class _HomeDelay extends StatelessWidget {
  const _HomeDelay({required this.core, required this.dark});

  final CoreController core;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final test = core.lastTest;
    final (text, color) = switch (test) {
      null => (l.testConnection, Homa.muted(dark)),
      final t when !t.ok => (l.testFailed, Homa.muted(dark)),
      final t => (l.milliseconds(t.responseMs), Homa.ink(dark)),
    };
    return Tooltip(
      message: '${l.realDelay} · ${l.testConnection}',
      child: Material(
        color: Homa.cardAlt(dark),
        shape: StadiumBorder(side: BorderSide(color: Homa.border(dark))),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: core.testing
              ? null
              : () => runShowingErrors(context, core.runTest),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                const SizedBox(width: Homa.gap1),
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

/// The button: one big circle. Off, it is filled with the page's ink and
/// its power mark is the background's; on, it is a ring of ink with the
/// mark inside, over soft rings that breathe while the connection is
/// alive. A tap turns it, and a drag works too: down connects, up
/// disconnects.
class _Orb extends StatefulWidget {
  const _Orb({
    required this.on,
    required this.busy,
    required this.connected,
    required this.dark,
    required this.tapToConnect,
    required this.tapToDisconnect,
    required this.onToggle,
    this.onSwipeDown,
    this.onSwipeUp,
    this.autofocusOverride = false,
  });

  final bool on;
  final bool busy;
  final bool connected;
  final bool dark;
  final String tapToConnect;
  final String tapToDisconnect;
  final VoidCallback onToggle;

  /// A remote starts here: the button takes the focus when the page opens.
  final bool autofocusOverride;

  /// Drags: down connects, up disconnects; null where there is no account.
  final VoidCallback? onSwipeDown;
  final VoidCallback? onSwipeUp;

  @override
  State<_Orb> createState() => _OrbState();
}

class _OrbState extends State<_Orb> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  late AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: _onState);
  }

  @override
  void didUpdateWidget(_Orb old) {
    super.didUpdateWidget(old);
    final should = widget.connected && !_still(context);
    if (should && !_c.isAnimating) _c.repeat();
    if (!should) _c.stop();
  }

  void _onState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.resumed) {
      if (widget.connected && !_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _c.dispose();
    super.dispose();
  }

  bool _still(BuildContext context) => MediaQuery.of(context).disableAnimations;

  /// The drag's meaning: down connects, up disconnects, and nothing
  /// in between.
  void _dragged(DragEndDetails d) {
    final v = d.velocity.pixelsPerSecond.dy;
    if (widget.busy) return;
    if (!widget.on && v > 420 && widget.onSwipeDown != null) {
      widget.onSwipeDown!();
    } else if (widget.on && v < -420 && widget.onSwipeUp != null) {
      widget.onSwipeUp!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.dark;
    final ink = Homa.ink(dark);
    final on = widget.on;
    final busy = widget.busy;
    const disc = 172.0;
    const area = 264.0;
    final still = _still(context);
    return Tooltip(
      message: on ? widget.tapToDisconnect : widget.tapToConnect,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragEnd: _dragged,
        child: SizedBox.square(
          dimension: area,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // The breathing rings: only while connected, and never for
              // someone who asked for less motion.
              if (widget.connected && !still)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _c,
                      builder: (context, _) => CustomPaint(
                        painter: _RingsPainter(t: _c.value, color: ink),
                      ),
                    ),
                  ),
                ),
              if (busy)
                SizedBox.square(
                  dimension: disc + 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: ink,
                  ),
                ),
              // The disc: filled with ink when off; on, a ring with the
              // mark inside.
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: disc,
                height: disc,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: on ? Colors.transparent : ink,
                  border: Border.all(color: ink, width: on ? 2.2 : 0),
                  boxShadow: [
                    BoxShadow(
                      color: dark
                          ? Colors.white.withValues(alpha: on ? 0.10 : 0.14)
                          : Colors.black.withValues(alpha: on ? 0.06 : 0.10),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    autofocus: widget.autofocusOverride,
                    onTap: busy ? null : widget.onToggle,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            on
                                ? Icons.stop_rounded
                                : Icons.power_settings_new_rounded,
                            key: ValueKey(on),
                            size: 40,
                            color: on ? ink : Homa.onInk(dark),
                          ),
                        ),
                        const SizedBox(height: Homa.gap1),
                        Text(
                          on
                              ? AppLocalizations.of(context).btnDisconnect
                              : AppLocalizations.of(context).btnConnect,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: on ? ink : Homa.onInk(dark),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                        ),
                      ],
                    ),
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

/// Two rings that drift outwards and fade, one behind the other, in ink.
class _RingsPainter extends CustomPainter {
  _RingsPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    const disc = 172.0;
    for (var i = 0; i < 2; i++) {
      final p = (t + i * 0.5) % 1;
      final r = disc / 2 + 12 + p * (size.shortestSide / 2 - disc / 2 - 12);
      paint.color = color.withValues(alpha: (1 - p) * 0.20);
      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.t != t || old.color != color;
}

/// The state, big, and under it where the traffic goes: the page's first
/// line, in the ink of its state (a state that waits is softer).
class _Headline extends StatelessWidget {
  const _Headline({required this.state, required this.dark});

  final HomeState state;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = state.connected
        ? Homa.ink(dark)
        : state.connecting
        ? HomaState.busy(dark)
        : state.failing || state.noNetwork || state.gaveUp
        ? Homa.ink(dark)
        : Homa.muted(dark);
    return Text(
      state.label,
      textAlign: TextAlign.center,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: ink,
      ),
    );
  }
}

/// The session while connected: its time, the upload and the download,
/// in one quiet strip. The time ticks every second.
class _SessionStrip extends StatefulWidget {
  const _SessionStrip({required this.status, required this.dark});

  final CoreStatus status;
  final bool dark;

  @override
  State<_SessionStrip> createState() => _SessionStripState();
}

class _SessionStripState extends State<_SessionStrip> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _elapsed() {
    final started = widget.status.proxy?.startedAt;
    if (started == null) return '00:00:00';
    final d = DateTime.now().difference(started);
    String two(int n) => n.toString().padLeft(2, '0');
    return ltr('${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = widget.dark;
    final traffic = widget.status.traffic;
    Widget cell(
      IconData icon,
      String label,
      String value, {
      bool tabular = false,
    }) => Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: Homa.faint(dark)),
              const SizedBox(width: Homa.gap1),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Homa.faint(dark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Homa.gap1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Homa.ink(dark),
              fontWeight: FontWeight.w700,
              fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: Homa.gap3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Homa.gap3, horizontal: Homa.gap2),
        decoration: BoxDecoration(
          color: Homa.cardAlt(dark),
          borderRadius: BorderRadius.circular(Homa.radiusTile),
          border: Border.all(color: Homa.border(dark)),
        ),
        child: Row(
          children: [
            cell(
              Icons.schedule_rounded,
              l.statElapsed,
              _elapsed(),
              tabular: true,
            ),
            _divider(dark),
            cell(
              Icons.arrow_upward_rounded,
              l.statUp,
              formatRate(traffic?.upRate ?? 0),
              tabular: true,
            ),
            _divider(dark),
            cell(
              Icons.arrow_downward_rounded,
              l.statDown,
              formatRate(traffic?.downRate ?? 0),
              tabular: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool dark) => Container(
    width: 1,
    height: 34,
    margin: const EdgeInsets.symmetric(horizontal: Homa.gap2),
    color: Homa.border(dark),
  );
}

/// The phone's home: the state, the button, the session, and the cards.
/// Light or dark with the app's theme; the email is on the accounts page.
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final page = AnnotatedRegion<SystemUiOverlayStyle>(
      value: (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: DecoratedBox(
        decoration: BoxDecoration(color: dark ? Homa.black : Homa.white),
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight),
              child: IntrinsicHeight(child: _content(context, dark, box)),
            ),
          ),
        ),
      ),
    );
    return page;
  }

  Widget _content(BuildContext context, bool dark, BoxConstraints box) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final width = box.maxWidth;
    // A wide, low screen (a TV, 960 x 540): a smaller button and the two
    // cards side by side, so that all of it shows without scrolling.
    final short = box.maxHeight < 560 && width >= 600;
    // On a tablet the content keeps about a phone's width in the middle;
    // both as padding, since IntrinsicHeight measures through padding but
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
    final s = HomeState.of(l, core, status, showIp: showIp, on: on);
    // A TV's remote presses OK; a phone is tapped.
    final tv = Platform.isAndroid && AndroidCore.isTv;
    final press = s.on
        ? (tv ? l.tapToDisconnectTv : l.swipeToDisconnect)
        : (tv ? l.tapToConnectTv : l.swipeToConnect);
    final proxyOnly = Platform.isAndroid && AndroidCore.mode.value == 'proxy';
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(side, top + 10, side, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The brand: the official mark and the name, with the state's dot.
          Reveal(
            index: 0,
            child: Row(
              children: [
                const AppLogo(size: 30),
                const SizedBox(width: Homa.gap2 + 2),
                Text(
                  l.appTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Homa.ink(dark),
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                PulsingDot(
                  color: s.connected
                      ? Homa.ink(dark)
                      : Homa.faint(dark),
                  active: s.connected,
                ),
              ],
            ),
          ),
          SizedBox(height: short ? Homa.gap5 : Homa.gap6),
          Reveal(
            index: 1,
            child: _Headline(state: s, dark: dark),
          ),
          SizedBox(height: short ? Homa.gap2 : Homa.gap5),
          Reveal(
            index: 2,
            child: Center(
              child: _Orb(
                on: s.on,
                busy: s.connecting,
                connected: s.connected,
                dark: dark,
                tapToConnect: tv
                    ? l.tapToConnectTv
                    : l.tapToConnectPhone,
                tapToDisconnect: tv
                    ? l.tapToDisconnectTv
                    : l.tapToDisconnectPhone,
                // A TV starts on the switch, its ring showing.
                autofocusOverride: tv,
                // No account yet: the accounts page, which explains them
                // and links to Mozilla's sign-up.
                // _toggle takes the state it is in and flips it.
                onToggle: () => status.totalAccounts == 0
                    ? _openAccounts(context, core, settings, onOpenAccounts)
                    : runShowingErrors(context, () => _toggle(s.on)),
                onSwipeDown: status.totalAccounts == 0
                    ? null
                    : () => runShowingErrors(context, () => _toggle(false)),
                onSwipeUp: status.totalAccounts == 0
                    ? null
                    : () => runShowingErrors(context, () => _toggle(true)),
              ),
            ),
          ),
          SizedBox(height: short ? Homa.gap2 : Homa.gap3),
          Text(
            s.connecting ? '' : press,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Homa.faint(dark),
            ),
          ),
          // The session while connected: the time, the upload, the download.
          if (s.connected) _SessionStrip(status: status, dark: dark),
          if (s.failing || s.noNetwork || s.gaveUp)
            // Not connecting stands out from the ordinary hints.
            problem(
              Padding(
                padding: const EdgeInsets.only(top: Homa.gap3),
                child: _ProblemBox(
                  text: s.noNetwork
                      ? l.noNetwork
                      : s.failure != null
                      ? s.failure!.text
                      : failureCodeText(l, status.connectFailure),
                  dark: dark,
                  tooltip: s.noNetwork ? '' : s.failure?.detail ?? '',
                ),
              ),
            )
          else if (!s.connected)
            Padding(
              padding: EdgeInsets.only(top: short ? Homa.gap2 : Homa.gap4),
              child: Tooltip(
                message:
                    !status.connectPending && status.state.phase == Phase.error
                    ? status.state.message
                    : '',
                child: Text(
                  s.look.hint.isNotEmpty && s.on ? s.look.hint : '',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Homa.faint(dark),
                  ),
                ),
              ),
            ),
          // Where to find the proxy, on a line of its own under the strip.
          if (s.connected && proxyOnly && proxy != null)
            Padding(
              padding: const EdgeInsets.only(top: Homa.gap2),
              child: Center(
                child: _HomePill(
                  dark: dark,
                  child: Text(
                    '${l.modeProxyOnly} ${ltr('127.0.0.1:${portOf(proxy.listen) ?? 10810}')}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Homa.muted(dark),
                    ),
                  ),
                ),
              ),
            ),
          if (s.failure?.code == Failure.unreachable && onOpenConnection != null)
            _ConnectionSettingsButton(onPressed: onOpenConnection!),
          if (s.failure?.code == Failure.upstreamProxy &&
              onOpenUpstreamProxy != null)
            _ConnectionSettingsButton(
              onPressed: onOpenUpstreamProxy!,
              label: AppLocalizations.of(context).upstreamProxy,
            ),
          if (!s.connected &&
              status.upstreamProxy.isNotEmpty &&
              s.failure?.code != Failure.upstreamProxy)
            Padding(
              padding: const EdgeInsets.only(top: Homa.gap2),
              child: Center(
                child: _UpstreamProxyPill(
                  address: status.upstreamProxy,
                  dark: dark,
                  onPressed: onOpenUpstreamProxy,
                ),
              ),
            ),
          if (isLocationRefused(s.failure?.code ?? '') ||
              (s.gaveUp && isLocationRefused(status.connectFailure)))
            _RecommendedLocationButton(core: core),
          if (s.connected && s.mismatch != null)
            problem(_ExitMismatchNote(text: s.mismatch!)),
          if (_switchSystemProxy &&
              status.systemProxySet &&
              status.systemProxyTakenBy != null)
            problem(
              _SystemProxyTakenNote(
                core: core,
                by: status.systemProxyTakenBy!,
              ),
            ),
          if (status.state.proxyPortBlocked) ...[
            const SizedBox(height: Homa.gap3),
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
          if (status.state.phase == Phase.running &&
              proxy != null &&
              !_switchSystemProxy &&
              sharedWithLan(proxy.listen)) ...[
            const SizedBox(height: Homa.gap3),
            Center(child: _LanChip(port: portOf(proxy.listen) ?? 10810)),
          ],
          const Spacer(),
          SizedBox(height: short ? Homa.gap3 : Homa.gap5),
          _UpdateNotice(core: core, settings: settings, dark: dark),
          _UdpNotice(status: status, settings: settings, dark: dark),
          _Notices(notices: homeNotices(status.notices), dark: dark),
          _LowQuotaNotice(
            core: core,
            status: status,
            settings: settings,
            connected: s.connected,
            dark: dark,
          ),
          if (short)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _PlaceCard(
                      dark: dark,
                      place: s.place,
                      onTap: onOpenServers,
                    ),
                  ),
                  const SizedBox(width: Homa.gap3),
                  Expanded(
                    child: _DataCard(
                      status: status,
                      dark: dark,
                      onTap: onOpenAccounts,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Reveal(
              index: 4,
              child: _PlaceCard(dark: dark, place: s.place, onTap: onOpenServers),
            ),
            const SizedBox(height: Homa.gap3),
            Reveal(
              index: 5,
              child: _DataCard(
                status: status,
                dark: dark,
                onTap: onOpenAccounts,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Where the traffic goes: the flag and the country, under how the
/// location is chosen (a sparkle for the app's choice); a tap opens the
/// server list.
class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.dark,
    required this.place,
    this.onTap,
  });

  final bool dark;
  final HomePlace place;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HomaCard(
      dark: dark,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 8, 14),
      onTap: onTap,
      child: Row(
        children: [
          IconBox(icon: Icons.public_rounded),
          const SizedBox(width: Homa.gap3 + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.caption,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: place.auto ? Homa.ink(dark) : Homa.faint(dark),
                    fontWeight: place.auto ? FontWeight.w600 : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Homa.ink(dark),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Homa.gap2),
            child: CountryFlag(code: place.flag, width: 40),
          ),
          Icon(Icons.chevron_right_rounded, color: Homa.faint(dark)),
        ],
      ),
    );
  }
}

/// The data used of the active account: a ring that fills as it is used,
/// in ink, and the amount in large type; a tap opens the accounts.
class _DataCard extends StatelessWidget {
  const _DataCard({
    required this.status,
    required this.dark,
    this.onTap,
  });

  final CoreStatus status;
  final bool dark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final a = status.activeAccount;
    final usage = a?.usage;
    Widget body;
    if (a == null || usage == null || usage.unlimited) {
      body = Row(
        children: [
          IconBox(
            icon: a == null
                ? Icons.person_add_alt_rounded
                : Icons.all_inclusive_rounded,
          ),
          const SizedBox(width: Homa.gap3 + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.dataUsedTitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Homa.faint(dark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a == null
                      ? l.noActiveAccount
                      : usage == null
                      ? l.quotaNotRead
                      : l.unlimited,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Homa.ink(dark),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      final used = usage.usedBytes.clamp(0, usage.limitBytes);
      final fraction = usage.limitBytes == 0 ? 0.0 : used / usage.limitBytes;
      body = Row(
        children: [
          SizedBox.square(
            dimension: 52,
            child: CustomPaint(
              painter: _QuotaRing(
                value: fraction,
                color: Homa.ink(dark),
                track: Homa.border(dark),
              ),
              child: Center(
                child: CountUp(
                  value: fraction * 100,
                  format: (v) => ltr('${v.round()}%'),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Homa.ink(dark),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: Homa.gap3 + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.dataUsedTitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Homa.faint(dark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatBytes(used),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Homa.ink(dark),
                  ),
                ),
                Text(
                  [
                    l.dataLeftOf(formatBytes(usage.limitBytes)),
                    if (usage.resetAt != null)
                      l.resets(formatDate(l, usage.resetAt!)),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Homa.faint(dark),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return HomaCard(
      dark: dark,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 8, 14),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: body),
          Icon(Icons.chevron_right_rounded, color: Homa.faint(dark)),
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
    const stroke = 5.0;
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
      avatar: Icon(Icons.lan_outlined, size: 18, color: Homa.muted(Theme.of(context).brightness == Brightness.dark)),
      label: Text(l.lanAddress(ltr(address))),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: address));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.copied(address)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
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
  const _Notices({required this.notices, required this.dark});

  final List<Notice> notices;
  final bool dark;

  @override
  State<_Notices> createState() => _NoticesState();
}

class _NoticesState extends State<_Notices> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = widget.dark;
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
            padding: const EdgeInsets.only(bottom: Homa.gap2),
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 6, 10),
              decoration: BoxDecoration(
                color: Homa.cardAlt(dark),
                borderRadius: BorderRadius.circular(Homa.radiusBox),
                border: Border.all(color: Homa.border(dark)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Homa.muted(dark),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: Homa.gap2 + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          n.kind == 'port'
                              ? l.noticePort(n.detail)
                              : l.noticeCommand,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Homa.ink(dark),
                          ),
                        ),
                        if (n.last != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            [
                              l.noticeTimes(n.count, formatAgo(l, n.last!)),
                              if (n.hosts.isNotEmpty) n.hosts.join(', '),
                            ].join(' · '),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Homa.faint(dark),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l.dismiss,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.close_rounded, size: 16, color: Homa.muted(dark)),
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

/// A newer version. The desktop apps (Windows, Linux, macOS) install it
/// themselves: Update downloads it (its progress shows here), then the app
/// closes and opens again as the new version; on Android it downloads here
/// and Update opens Android's installer (or, with Update in the app off,
/// Download opens the browser; Updates). After an update, what it did.
/// Closed, a version's notice stays away until a later version.
class _UpdateNotice extends StatelessWidget {
  const _UpdateNotice({
    required this.core,
    required this.settings,
    required this.dark,
  });

  final CoreController core;
  final AppSettings settings;
  final bool dark;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([
      Updates.available,
      Updates.failure,
      Updates.resultSeen,
    ]),
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final update = core.status?.update;
      final release = Updates.available.value;
      final last = update?.last;
      if (last != null &&
          !Updates.resultSeen.value &&
          release?.mandatory != true) {
        return _NoticeBanner(
          dark: dark,
          icon: last.ok ? Icons.check_circle_rounded : Icons.history_rounded,
          text: last.ok ? l.updateDone(last.to) : l.updateRolledBack(last.to),
          tooltip: last.error,
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
      if (update == null) {
        return _NoticeBanner(
          dark: dark,
          icon: Icons.system_update_rounded,
          text: release.mandatory
              ? l.updateRequired(release.version)
              : l.updateAvailable(release.version),
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
        return _NoticeBanner(
          dark: dark,
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
        return _NoticeBanner(
          dark: dark,
          icon: Icons.error_outline_rounded,
          text: l.updateFailed(release.version),
          tooltip: failure,
          action: (
            label: l.tryAgain,
            icon: Icons.refresh_rounded,
            onPressed: () => Updates.update(release),
          ),
          onClose: dismiss,
        );
      }
      return _NoticeBanner(
        dark: dark,
        icon: Icons.system_update_rounded,
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

/// A notice on the home page: a quiet bar, its text, an optional button,
/// an optional close, and a progress bar under the text while busy.
class _NoticeBanner extends StatelessWidget {
  const _NoticeBanner({
    required this.dark,
    required this.icon,
    required this.text,
    this.tooltip = '',
    this.action,
    this.busy = false,
    this.progress,
    this.onClose,
  });

  final bool dark;
  final IconData icon;
  final String text;
  final String tooltip;
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
    final action = this.action;
    return Padding(
      padding: const EdgeInsets.only(bottom: Homa.gap3),
      child: Material(
        color: Homa.cardAlt(dark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Homa.radiusTile),
          side: BorderSide(color: Homa.border(dark)),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            14,
            8,
            onClose == null ? 14 : 6,
            8,
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
                  borderRadius: BorderRadius.circular(Homa.radiusBox),
                  child: Row(
                    children: [
                      Icon(icon, color: Homa.ink(dark), size: 22),
                      const SizedBox(width: Homa.gap2 + 2),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Tooltip(
                                message: tooltip,
                                child: Text(
                                  text,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Homa.ink(dark),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (busy) ...[
                                const SizedBox(height: Homa.gap2),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 4,
                                    color: Homa.ink(dark),
                                    backgroundColor: Homa.border(dark),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(width: Homa.gap2),
                        ExcludeFocus(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
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
                  icon: Icon(Icons.close_rounded, size: 18, color: Homa.muted(dark)),
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
    required this.dark,
  });

  final CoreStatus status;
  final AppSettings settings;
  final bool dark;

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
      final dark = widget.dark;
      return Padding(
        padding: const EdgeInsets.only(bottom: Homa.gap3),
        child: Material(
          color: Homa.cardAlt(dark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Homa.radiusTile),
            side: BorderSide(color: Homa.border(dark)),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 6, 8),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Homa.ink(dark)),
                const SizedBox(width: Homa.gap2 + 2),
                Expanded(
                  child: Text(
                    l.udpNoticeBody(ltr(_label(program))),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Homa.ink(dark),
                    ),
                  ),
                ),
                const SizedBox(width: Homa.gap2),
                // The style starts from the theme, for its font.
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Homa.muted(dark),
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
    required this.dark,
  });

  final CoreController core;
  final CoreStatus status;
  final AppSettings settings;
  final bool connected;
  final bool dark;

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
    final dark = widget.dark;
    final usage = widget.status.activeAccount!.usage!;
    String rounded(int bytes) => formatBytes(bytes).replaceAll('.0 ', ' ');
    return Padding(
      padding: const EdgeInsets.only(bottom: Homa.gap3),
      child: Material(
        color: Homa.cardAlt(dark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Homa.radiusTile),
          side: BorderSide(color: Homa.border(dark)),
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
                      color: Homa.ink(dark),
                    ),
                  ),
                  const SizedBox(width: Homa.gap2 + 2),
                  Expanded(
                    child: Text(
                      l.lowQuotaNotice(rounded(usage.limitBytes)),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Homa.ink(dark),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l.close,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.close_rounded, size: 18, color: Homa.muted(dark)),
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
