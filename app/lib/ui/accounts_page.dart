import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_settings.dart';
import '../core/core_api.dart';
import '../core/core_controller.dart';
import '../core/models.dart';
import '../l10n/app_localizations.dart';
import 'backup.dart';
import 'browser_signin.dart';
import 'design.dart';
import 'format.dart';
import 'motion.dart';
import 'signin_dialog.dart';
import 'widgets.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key, required this.core, required this.settings});

  final CoreController core;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final list = core.accounts?.accounts ?? const <Account>[];
    final threshold = core.accounts?.thresholdPercent ?? 0;
    return ListView(
      padding: pagePadding(context),
      children: [
        Row(
          children: [
            Expanded(child: PageTitle(l.navAccounts)),
            FilledButton.icon(
              onPressed: () => startAddAccount(context, core, settings),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.addAccount),
            ),
            const SizedBox(width: 4),
            BackupMenuButton(core: core),
          ],
        ),
        const SizedBox(height: 20),
        if (core.accounts == null)
          const Center(child: CircularProgressIndicator())
        else ...[
          // The month at a glance: how many accounts carry the traffic
          // and how much of their data the month has spent — one card
          // with its own bar, arriving with the page's entrance.
          if (list.isNotEmpty)
            Reveal(child: _QuotaHero(accounts: list, threshold: threshold)),
          const SizedBox(height: 12),
          if (list.isEmpty)
            const Reveal(child: NoAccountsPanel())
          else
            for (var i = 0; i < list.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              Reveal(
                index: i + 1,
                child: _AccountCard(
                  core: core,
                  settings: settings,
                  account: list[i],
                  threshold: threshold,
                  count: list.length,
                  first: i == 0,
                  last: i == list.length - 1,
                ),
              ),
            ],
          const SizedBox(height: 12),
          Reveal(child: _SignInMethodRow(settings: settings)),
          // Nothing to switch to with one account.
          if (list.length > 1) ...[
            const SizedBox(height: 12),
            Reveal(child: _AccountSwitching(core: core, percent: threshold)),
          ],
        ],
        // More accounts, more data: each has its own month's allowance,
        // and the app moves to the next one by itself.
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                [
                  l.accountsGuide(_allowance(list)),
                  if (list.length > 1) l.accountsOrderNote(threshold.round()),
                ].join(' '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _CreateAccountGuide(),
      ],
    );
  }
}

/// The month at a glance: every account's spent share drawn as one
/// stacked bar — each account its own segment in the state's color, the
/// switch threshold marked where the app moves to the next one. The
/// numbers glide with CountUp, so a refresh never jumps.
class _QuotaHero extends StatelessWidget {
  const _QuotaHero({required this.accounts, required this.threshold});

  final List<Account> accounts;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final look = AppDesign.current.look(dark);
    final accent =
        look.accent ?? (dark ? Colors.white : const Color(0xFF0A0A0A));
    final withUsage = [
      for (final a in accounts)
        if (a.usedPercent > 0) a.usedPercent.clamp(0.0, 100.0),
    ];
    final average = withUsage.isEmpty
        ? 0.0
        : withUsage.reduce((a, b) => a + b) / withUsage.length;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.data_usage_rounded, size: 18, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.accountsUsageTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Text(
                '${accounts.length}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                l.accountsCountLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // The month's spend, one bar: each account its own segment,
          // separated by a hair of the scaffold's color.
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, t, _) => Row(
                  children: [
                    for (var i = 0; i < accounts.length; i++) ...[
                      if (i > 0) const SizedBox(width: 2),
                      Expanded(
                        flex: 1,
                        child: FractionallySizedBox(
                          widthFactor:
                              (accounts[i].usedPercent / 100).clamp(0.0, 1.0) *
                                  t,
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            decoration: BoxDecoration(
                              color: quotaColor(
                                accounts[i].usedPercent,
                                threshold,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${average.round()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: quotaColor(average, threshold),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l.accountsUsageAverage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chooses which sign-in flow Add account opens.
class _SignInMethodRow extends StatelessWidget {
  const _SignInMethodRow({required this.settings});

  final AppSettings settings;

  static String _label(AppLocalizations l, SignInMethod method) =>
      switch (method) {
        SignInMethod.browser => l.signInMethodBrowser,
        SignInMethod.api => l.signInMethodApi,
      };

  Future<void> _change(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final picked = await showDialog<SignInMethod>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.signInMethod),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: SizedBox(
          width: 360,
          child: RadioGroup<SignInMethod>(
            groupValue: settings.signInMethod,
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final method in SignInMethod.values)
                  RadioListTile<SignInMethod>(
                    value: method,
                    title: Text(_label(l, method)),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
        ],
      ),
    );
    if (picked != null) settings.update(signInMethod: picked);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: settings,
    builder: (context, _) => Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.login_rounded),
        title: Text(AppLocalizations.of(context).signInMethod),
        // The value goes under the title: too long beside it on a phone.
        subtitle: Text(
          _label(AppLocalizations.of(context), settings.signInMethod),
        ),
        // Mirrors itself in right-to-left languages.
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _change(context),
      ),
    ),
  );
}

/// How much of an account's data is used before the next one takes over
/// (accounts.switch_threshold_percent): one row, since few people change it.
class _AccountSwitching extends StatelessWidget {
  const _AccountSwitching({required this.core, required this.percent});

  final CoreController core;
  final double percent;

  Future<void> _change(BuildContext context) async {
    final value = await showDialog<int>(
      context: context,
      builder: (_) => _SwitchThresholdDialog(percent: percent.round()),
    );
    if (value == null || !context.mounted) return;
    await runShowingErrors(
      context,
      () => core.editSettings((config) {
        final accounts = switch (config['accounts']) {
          final Map<String, Object?> m => m,
          _ => config['accounts'] = <String, Object?>{},
        };
        accounts['switch_threshold_percent'] = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      leading: const Icon(Icons.swap_horiz_rounded),
      title: Text(AppLocalizations.of(context).sectionAccounts),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ltr('${percent.round()}%'),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(width: 4),
          // Mirrors itself in right-to-left languages.
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
      onTap: () => _change(context),
    ),
  );
}

class _SwitchThresholdDialog extends StatefulWidget {
  const _SwitchThresholdDialog({required this.percent});

  final int percent;

  @override
  State<_SwitchThresholdDialog> createState() => _SwitchThresholdDialogState();
}

class _SwitchThresholdDialogState extends State<_SwitchThresholdDialog> {
  late final _field = TextEditingController(text: '${widget.percent}');
  String? _error;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_field.text);
    if (value == null || value < 1 || value > 100) {
      setState(
        () => _error = AppLocalizations.of(context).numberInvalid(1, 100),
      );
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.switchThreshold),
      content: TextField(
        controller: _field,
        autofocus: true,
        textDirection: TextDirection.ltr,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          suffixText: '%',
          helperText: l.switchThresholdHint,
          helperMaxLines: 3,
          errorText: _error,
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() => _error = null),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.save)),
      ],
    );
  }
}

/// Why an account is out of the rotation, in the user's language; the
/// core's English for a reason the app does not know; null for none.
/// [threshold] is the account-switch setting, in percent.
String? accountReason(AppLocalizations l, Account a, double threshold) {
  final known = switch (a.reasonCode) {
    'quota_threshold' => l.reasonQuotaThreshold(
      (threshold > 0 ? threshold : 95).round(),
    ),
    'quota_exhausted' => l.reasonQuotaExhausted,
    'signin_required' ||
    'signin_confirm' ||
    'signin_failed' ||
    'signin_wait' ||
    'signin_retry' => l.reasonSignInRequired,
    'not_entitled' => l.reasonNotEntitled,
    _ => null,
  };
  return known ?? (a.reason.isEmpty ? null : a.reason);
}

/// An account's monthly allowance as the accounts report it (50 GB until
/// one has been read).
String _allowance(List<Account> list) {
  final limit =
      list
          .map((a) => a.usage?.limitBytes ?? 0)
          .where((b) => b > 0)
          .firstOrNull ??
      50 << 30;
  return formatBytes(limit).replaceAll('.0 ', ' ');
}

/// Where to make a Firefox Account: Mozilla's site, then Add account here.
class _CreateAccountGuide extends StatelessWidget {
  const _CreateAccountGuide();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Panel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.createAccountTitle, style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  l.createAccountHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  onPressed: () => openLink(context, firefoxAccountSignUpUrl),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  // The address reads left to right in every language.
                  label: Text(
                    'accounts.firefox.com',
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatefulWidget {
  const _AccountCard({
    required this.core,
    required this.settings,
    required this.account,
    required this.threshold,
    required this.count,
    required this.first,
    required this.last,
  });

  final CoreController core;
  final AppSettings settings;
  final Account account;
  final double threshold;

  /// How many accounts there are (the order number and the arrows show
  /// only when there is more than one).
  final int count;
  final bool first;
  final bool last;

  @override
  State<_AccountCard> createState() => _AccountCardState();
}

/// An account as a quiet card. The face of it — the letter, the name, the
/// state, the month's bar — is always in view; the reason and the controls
/// open only when they are needed, so the words of every language keep
/// their breathing room (nothing is squeezed onto one line). The card
/// opens by itself when something needs attention: the active account,
/// and one that asks for a sign-in.
class _AccountCardState extends State<_AccountCard> {
  late bool _open = widget.account.active || widget.account.needsSignIn;

  @override
  void didUpdateWidget(_AccountCard old) {
    super.didUpdateWidget(old);
    // A card that starts needing a sign-in opens by itself; the user's
    // own open or closed choice is left alone afterwards.
    if (!old.account.needsSignIn && widget.account.needsSignIn) _open = true;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final a = widget.account;
    final core = widget.core;
    final busy = core.busyAccounts.contains(a.id);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final usage = a.usage;
    final reason = accountReason(l, a, widget.threshold);

    // What the account needs now: a sign-in, or a tap to take over.
    final Widget? action = busy
        ? const Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : a.needsSignIn
        ? FilledButton.tonal(
            onPressed: () => _signInAgain(context),
            child: Text(l.signInAgain),
          )
        : !a.active && a.enabled && a.status == AccountStatus.ready
        ? OutlinedButton(
            onPressed: () => runShowingErrors(context, () => core.activate(a)),
            child: Text(l.useNow),
          )
        : null;

    // The month's words: the share beside the state; under the bar only
    // the day it starts over — the share is already said above, and no
    // sentence is written twice.
    final share = usage == null
        ? ''
        : usage.unlimited
        ? l.unlimitedQuota
        : l.usedOf(formatBytes(usage.usedBytes), formatBytes(usage.limitBytes));
    final caption = usage == null
        ? ltr('0 MB')
        : usage.unlimited || usage.resetAt == null
        ? ''
        : l.resets(formatDate(l, usage.resetAt!));

    return Opacity(
      opacity: a.enabled ? 1 : 0.6,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: a.active
              ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
              : BorderSide.none,
        ),
        // A tap anywhere opens or closes the card's rest; the switch and
        // the buttons take their own taps.
        child: InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The face: the order, the letter, the name and the mail;
              // the switch at the end, out of the words' way.
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 12, 0),
                child: Row(
                  children: [
                    if (widget.count > 1) ...[
                      SizedBox(
                        width: 20,
                        child: Text(
                          '${a.position}',
                          textAlign: TextAlign.center,
                          style: muted,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    _Monogram(name: a.name, active: a.active),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (a.name != a.email && a.email.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              a.email,
                              style: muted,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: a.enabled,
                      onChanged: busy
                          ? null
                          : (v) => runShowingErrors(
                              context,
                              () => core.setEnabled(a, v),
                            ),
                    ),
                  ],
                ),
              ),
              // The state and the month's numbers, on their own line.
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                child: Row(
                  children: [
                    _StatusPill(account: a),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        share,
                        style: muted,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              // The bar, always (unless the month is unlimited): a picture
              // of the share, with zero read as zero.
              if (usage?.unlimited != true) ...[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                  child: QuotaBar(
                    percent: usage == null ? 0 : a.usedPercent,
                    threshold: widget.threshold,
                  ),
                ),
              ],
              if (caption.isNotEmpty)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 14),
                  child: Text(caption, style: muted),
                )
              else
                const SizedBox(height: 14),
              // The rest, a tap away: the reason in the user's words, then
              // the controls — the order on one side, the care on the other.
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                sizeCurve: Curves.easeOutCubic,
                crossFadeState: _open
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The whole address, on its own wrapping line: the
                      // identity this card stands for, never squeezed.
                      if (a.email.isNotEmpty) ...[
                        Text(a.email, style: muted),
                        const SizedBox(height: 12),
                      ],
                      if (reason case final reason?) ...[
                        Text(reason, style: muted),
                        const SizedBox(height: 12),
                      ],
                      if (action != null) ...[
                        action,
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          if (widget.count > 1) ...[
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip: l.moveUp,
                              onPressed: widget.first || busy
                                  ? null
                                  : () => runShowingErrors(
                                      context,
                                      () => core.move(a, -1),
                                    ),
                              icon: const Icon(Icons.arrow_upward_rounded),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip: l.moveDown,
                              onPressed: widget.last || busy
                                  ? null
                                  : () => runShowingErrors(
                                      context,
                                      () => core.move(a, 1),
                                    ),
                              icon: const Icon(Icons.arrow_downward_rounded),
                            ),
                          ],
                          const Spacer(),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: l.refreshQuota,
                            onPressed: busy
                                ? null
                                : () => runShowingErrors(
                                    context,
                                    () => core.refreshQuota(a),
                                  ),
                            icon: const Icon(Icons.sync_rounded),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: l.remove,
                            onPressed: busy ? null : () => _remove(context),
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Signs in with the stored password; without one, asks for it.
  Future<void> _signInAgain(BuildContext context) async {
    final api = widget.core.api;
    final account = widget.account;
    if (api == null) return;
    try {
      final started = await api.startSignInAgain(account.id);
      if (context.mounted) {
        await showSignInDialog(context, widget.core, started: started);
      }
    } on CoreApiException catch (e) {
      if (!context.mounted) return;
      if (e.statusCode == 409) {
        // No stored password (a browser-added or Google/Apple account):
        // the whole sign-in again, the way the settings say.
        await startAddAccount(
          context,
          widget.core,
          widget.settings,
          email: account.email,
        );
      } else {
        showError(context, e.message);
      }
    } on CoreUnavailable catch (e) {
      if (context.mounted) {
        showError(context, describeProblem(AppLocalizations.of(context), e));
      }
    }
  }

  Future<void> _remove(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final account = widget.account;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.removeTitle),
        content: Text(l.removeBody(account.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: StatusColors.bad),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.remove),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await runShowingErrors(context, () => widget.core.remove(account));
    }
  }
}

/// The account's letter in a ring: filled with the accent's light when
/// the account is the one carrying the traffic, quiet gray otherwise.
class _Monogram extends StatelessWidget {
  const _Monogram({required this.name, required this.active});

  final String name;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmed = name.trim();
    final letter = trimmed.isEmpty
        ? '?'
        : trimmed.characters.first.toUpperCase();
    final color = active
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? color.withValues(alpha: 0.14)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        border: Border.all(
          color: active
              ? color.withValues(alpha: 0.55)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: theme.textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final a = account;
    if (!a.enabled) return Pill(l.statusDisabled);
    if (a.active) {
      return Pill(
        l.statusActive,
        color: StatusColors.good,
        icon: Icons.bolt_rounded,
      );
    }
    return switch (a.status) {
      AccountStatus.ready => Pill(
        l.statusReady,
        color: Theme.of(context).colorScheme.primary,
      ),
      AccountStatus.reauthRequired => Pill(
        l.statusNeedsSignIn,
        color: StatusColors.bad,
      ),
      AccountStatus.reserved => Pill(
        l.statusReserved,
        color: StatusColors.busy,
      ),
      AccountStatus.unavailable => Pill(
        a.retryAt != null
            ? l.statusUnavailableUntil(formatDate(l, a.retryAt!))
            : l.statusUnavailable,
        color: StatusColors.busy,
      ),
      _ => Pill(a.status),
    };
  }
}
