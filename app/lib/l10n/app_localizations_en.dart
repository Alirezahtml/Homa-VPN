// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Slide to connect';

  @override
  String get slideToDisconnect => 'Slide to disconnect';

  @override
  String get navOverview => 'Overview';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navSettings => 'Settings';

  @override
  String get stateConnected => 'Connected';

  @override
  String get stateConnecting => 'Connecting…';

  @override
  String get stateWaiting => 'Waiting';

  @override
  String get waitingForAccount =>
      'Add a Firefox Account on the Accounts page to connect.';

  @override
  String get waitingForEnabledAccount =>
      'All accounts are turned off. Turn one on in Accounts.';

  @override
  String get stateError => 'Error';

  @override
  String get stateUnknown => 'Unknown';

  @override
  String get restartProxy => 'Restart the proxy';

  @override
  String copied(String value) {
    return 'Copied $value';
  }

  @override
  String get activeAccount => 'Active account';

  @override
  String get noActiveAccount => 'No active account';

  @override
  String get quotaNotRead => 'Quota not read yet';

  @override
  String get unlimited => 'Unlimited';

  @override
  String usedOf(String used, String limit) {
    return '$used of $limit used';
  }

  @override
  String resets(String date) {
    return 'resets $date';
  }

  @override
  String switchAt(int percent) {
    return 'Switches account at $percent%';
  }

  @override
  String get publicIp => 'Public IP';

  @override
  String get testConnection => 'Test connection';

  @override
  String get testing => 'Testing…';

  @override
  String get testFailed => 'Failed';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'just now';

  @override
  String minutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String hoursAgo(int n) {
    return '$n h ago';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'at $time';
  }

  @override
  String durationDays(int d, int h) {
    return '${d}d ${h}h';
  }

  @override
  String durationHours(int h, int m) {
    return '${h}h ${m}m';
  }

  @override
  String durationMinutes(int m, int s) {
    return '${m}m ${s}s';
  }

  @override
  String durationSeconds(int s) {
    return '${s}s';
  }

  @override
  String accountsGuide(String size) {
    return 'Each Firefox Account has $size of data a month. You can add several: when one runs out, the app moves to the next one by itself.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'In the order of this list: each up to $percent%, the last one until its data runs out.';
  }

  @override
  String get addAccount => 'Add account';

  @override
  String lowQuotaNotice(String size) {
    return 'This account is running out of data. Add another account to get $size more.';
  }

  @override
  String get noAccounts => 'No accounts yet';

  @override
  String get noAccountsHint => 'Add a Firefox Account to connect.';

  @override
  String get delayTestFailed =>
      'Couldn\'t measure the servers\' delay. Check your internet.';

  @override
  String get createAccountTitle => 'Don\'t have a Firefox Account?';

  @override
  String get createAccountHint =>
      'Create one for free at accounts.firefox.com, then come back and press Add account.';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get statusActive => 'Active';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusNeedsSignIn => 'Needs sign-in';

  @override
  String get statusReserved => 'Reserved';

  @override
  String get statusUnavailable => 'Unavailable';

  @override
  String statusUnavailableUntil(String date) {
    return 'Unavailable until $date';
  }

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get statusEnabled => 'Enabled';

  @override
  String get useNow => 'Use now';

  @override
  String get signInAgain => 'Sign in again';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Used $percent% of its data, so the next account took over.';
  }

  @override
  String get reasonQuotaExhausted =>
      'This month\'s data is used up; it is used again after the monthly reset.';

  @override
  String get reasonSignInRequired => 'Sign in again to use this account.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla asks to confirm the sign-in: press Sign in again (only the code is needed).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Automatic sign-in failed ($detail). Sign in again.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'The last automatic sign-in stopped working soon after; the next try is at $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Automatic sign-in could not finish ($detail); trying again at $time.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla refused this account; trying again later.';

  @override
  String get more => 'More';

  @override
  String get refreshQuota => 'Refresh quota';

  @override
  String get remove => 'Remove';

  @override
  String get removeTitle => 'Remove account?';

  @override
  String removeBody(String name) {
    return '$name and its saved sign-in will be removed from this computer. You can add it again later.';
  }

  @override
  String get unlimitedQuota => 'Unlimited quota';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInIntro => 'Sign in with a Firefox Account.';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Enter the account email';

  @override
  String get password => 'Password';

  @override
  String get passwordEmpty => 'Enter the password';

  @override
  String get show => 'Show';

  @override
  String get hide => 'Hide';

  @override
  String get signIn => 'Sign in';

  @override
  String get continueLabel => 'Continue';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get noBrowserTitle => 'No browser on this device';

  @override
  String get noBrowserText => 'Open this address on your phone or computer:';

  @override
  String get cancel => 'Cancel';

  @override
  String get tryAgain => 'Try again';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get accountReady => 'Account ready';

  @override
  String get accountReadyHint => 'It joined the end of the account order.';

  @override
  String get captchaLabel => 'Characters in the image';

  @override
  String get codeLabel => 'Code';

  @override
  String get captchaBroken => 'The CAPTCHA image could not be shown.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla emailed a code to $email. Enter it here.';
  }

  @override
  String get stepTotp => 'Enter the code from your authenticator app.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla finds this sign-in unusual and emailed an unblock code to $email. Enter it here.';
  }

  @override
  String get stepCaptcha => 'Type the characters in the image.';

  @override
  String stepEmailLink(String email) {
    return 'Open the confirmation link Mozilla emailed to $email. This continues by itself.';
  }

  @override
  String get signInFailed => 'The account was not added.';

  @override
  String get signInCancelled => 'Sign-in cancelled.';

  @override
  String get signInNoAccount => 'No Firefox Account exists for this email.';

  @override
  String get signInNoAccountHint =>
      'Check the email, or create a free Firefox Account with it on Mozilla\'s site, confirm it from your inbox, then add it here.';

  @override
  String get createAccountButton => 'Create a Firefox Account';

  @override
  String get signInWrongPassword => 'Incorrect password.';

  @override
  String get signInNoPassword =>
      'This account has no password: it was made with Google or Apple sign-in. Set a password, then sign in here with it.';

  @override
  String get setPasswordButton => 'Set a password';

  @override
  String get signInTooManyAttempts =>
      'Too many attempts. Wait a while and try again.';

  @override
  String get signInUnblockRejected =>
      'The unblock code was not accepted. Use the code from the latest email from Mozilla.';

  @override
  String get signInWrongCode =>
      'Wrong or expired code. Use the code from the latest email from Mozilla; an older code stops working when a new one is sent.';

  @override
  String get signInWrongTotp =>
      'Wrong code. Enter the code the authenticator app shows now.';

  @override
  String get signInTooManyCodes =>
      'Too many wrong codes. Start the sign-in again.';

  @override
  String get signInTimedOut => 'The sign-in took too long. Start it again.';

  @override
  String get signInNetwork =>
      'Mozilla could not be reached. Check your internet and try again.';

  @override
  String get coreConnecting => 'Connecting to the core…';

  @override
  String get coreLost => 'Lost the connection to the core. Retrying…';

  @override
  String get cantReachCore => 'Can\'t reach the core';

  @override
  String get startingCore => 'Starting the core…';

  @override
  String get retry => 'Retry';

  @override
  String errNoCore(String path) {
    return 'The core program was not found next to the app ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'The core stopped: $detail';
  }

  @override
  String get errNotAnswering => 'The core is not answering.';

  @override
  String get errRefused =>
      'The core refused the app; it may belong to another copy.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionGeneral => 'General';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get closeBehavior => 'When closing the window';

  @override
  String get closeAsk => 'Ask every time';

  @override
  String get closeTray => 'Minimize to the tray';

  @override
  String get closeQuit => 'Quit the app';

  @override
  String get sectionConnection => 'Connection';

  @override
  String get localProxy => 'Local proxy';

  @override
  String get systemProxy => 'System proxy';

  @override
  String get sectionRouting => 'Routing';

  @override
  String get routingDirect => 'Direct connection for local sites';

  @override
  String get routingDirectHint =>
      'Sites and IPs of the chosen country skip the VPN: they open faster and save quota.';

  @override
  String get region => 'Country';

  @override
  String get regionIr => 'Iran';

  @override
  String get regionCn => 'China';

  @override
  String get regionRu => 'Russia';

  @override
  String get regionAf => 'Afghanistan';

  @override
  String get regionTr => 'Turkey';

  @override
  String get regionId => 'Indonesia';

  @override
  String get regionBr => 'Brazil';

  @override
  String get regionNone => 'None';

  @override
  String get saved => 'Saved';

  @override
  String get dataFolder => 'Data folder';

  @override
  String get openFolder => 'Open folder';

  @override
  String get unofficialNote =>
      'Unofficial client. Not affiliated with Mozilla.';

  @override
  String get closeTitle => 'Close the window?';

  @override
  String get closeBody =>
      'In the tray, the VPN stays connected. Quitting turns it off.';

  @override
  String get rememberChoice => 'Remember my choice';

  @override
  String get minimizeToTray => 'Minimize to tray';

  @override
  String get quit => 'Quit';

  @override
  String get trayOpen => 'Open';

  @override
  String get trayQuit => 'Quit';

  @override
  String get trayProxyOnly => 'Proxy service only';

  @override
  String get traySetSystemProxy => 'Set system proxy';

  @override
  String errPortInUse(String port) {
    return 'Port $port is used by another program, so the app cannot reach its core.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'Port $port is used by another program, so the proxy cannot start.';
  }

  @override
  String get changePort => 'Change port';

  @override
  String get portDialogTitle => 'Choose a port';

  @override
  String portDialogBody(String port) {
    return 'Port $port is taken. A free port is suggested below; you can type another one.';
  }

  @override
  String get portChangeBody =>
      'Apps connect to this port. Choose one from 1024 to 65535.';

  @override
  String get portLabel => 'Port';

  @override
  String get portInvalid => 'Enter a port from 1024 to 65535';

  @override
  String get portBusy => 'This port is in use too';

  @override
  String get portInUse => 'Another program uses this port';

  @override
  String get save => 'Save';

  @override
  String get proxyPort => 'Proxy port';

  @override
  String get appPort => 'App port';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeBody =>
      'Choose your language and your country. Sites of your country open directly, without the VPN, which is faster and saves quota.';

  @override
  String get start => 'Start';

  @override
  String routingSuggestTitle(String country) {
    return 'Route $country directly?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Sites and IPs of $country would open directly, without the VPN. You can change this in Routing.';
  }

  @override
  String get yes => 'Yes';

  @override
  String get notNow => 'Not now';

  @override
  String get navServers => 'Servers';

  @override
  String get navLogs => 'Logs';

  @override
  String get realDelay => 'Real delay';

  @override
  String get statElapsed => 'Elapsed';

  @override
  String get statDown => 'Down';

  @override
  String get statUp => 'Up';

  @override
  String noticePort(String port) {
    return 'Mozilla\'s proxy does not connect to port $port. Only ports 80, 443, 8080 and 8443 go through the VPN.';
  }

  @override
  String get noticeCommand =>
      'This type of connection isn\'t supported by the VPN.';

  @override
  String noticeTimes(int count, String time) {
    return '$count times, last $time';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get modeRecommended => 'Recommended';

  @override
  String get modeFastest => 'Fastest';

  @override
  String get modeRecommendedHint => 'Mozilla picks the location for you.';

  @override
  String get modeFastestHint =>
      'The location with the lowest delay at each connection.';

  @override
  String get testDelay => 'Test real delay';

  @override
  String get testingDelay => 'Measuring…';

  @override
  String get search => 'Search';

  @override
  String get noAnswer => 'No answer';

  @override
  String testedAgo(String ago) {
    return 'Tested $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered of $total answered';
  }

  @override
  String get noServers =>
      'No servers yet. They appear once the core reaches Mozilla.';

  @override
  String get levelAll => 'All';

  @override
  String get filter => 'Filter';

  @override
  String get follow => 'Auto-scroll';

  @override
  String get clear => 'Clear';

  @override
  String get copyAll => 'Copy';

  @override
  String get logsCopied => 'Logs copied';

  @override
  String get noLogs => 'No log lines yet.';

  @override
  String get sectionAccounts => 'Account switching';

  @override
  String get switchThreshold => 'Switch account at';

  @override
  String get switchThresholdHint =>
      'The next account takes over when this share of the quota is used.';

  @override
  String get signInMethod => 'Sign-in method';

  @override
  String get signInMethodBrowser => 'Sign in with the browser';

  @override
  String get signInMethodApi => 'Sign in directly';

  @override
  String get browserSignInBroken => 'The sign-in page could not be opened.';

  @override
  String get browserSignInBlocked =>
      'Mozilla did not complete the final step of adding the account (HTTP 406).';

  @override
  String get browserSignInFallback => 'Sign in with email and password';

  @override
  String get backupExport => 'Save a backup';

  @override
  String get backupImport => 'Import a backup';

  @override
  String backupSaved(String name) {
    return 'Saved: $name';
  }

  @override
  String get backupImportTitle => 'Add these accounts?';

  @override
  String get backupAccountExists => 'Already added; it signs in from the file';

  @override
  String get backupImportAction => 'Add';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts added',
      one: '1 account added',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS servers';

  @override
  String get dnsSystem => 'System';

  @override
  String get dnsAuto => 'Auto (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Custom';

  @override
  String get dnsCustomHint =>
      'One per line: https://…/dns-query, tls://…, or an IP address.';

  @override
  String get dnsFallback => 'Fall back to the system DNS';

  @override
  String get testDns => 'Test DNS';

  @override
  String get transport => 'Protocol';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP version';

  @override
  String get ipVersionAuto => 'Auto (IPv4, then IPv6)';

  @override
  String get ipVersionDual => 'Both at once (dual-stack)';

  @override
  String get ipVersionV6First => 'IPv6 first, then IPv4';

  @override
  String get ipVersionV4 => 'IPv4 only';

  @override
  String get ipVersionV6 => 'IPv6 only';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'The VPN interface\'s packet size, 1280 to 9000. Empty: automatic.';

  @override
  String get tunMtuInvalid => 'A number from 1280 to 9000, or empty';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Direct';

  @override
  String get directRulesHint =>
      'Sites and addresses in this list open without the VPN, straight through your own internet. The chosen country\'s rules are already here: add, change, or remove lines. Choosing another country replaces them with its own.';

  @override
  String get restoreRegionRules => 'Restore the region\'s rules';

  @override
  String get blockRules => 'Block';

  @override
  String get blockRulesHint =>
      'Sites and addresses in this list do not open at all, neither directly nor through the VPN: for ads, or sites you never want reached.';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get ruleSyntaxTitle => 'How to write a rule';

  @override
  String get resolveDomains => 'Look up names for IP rules';

  @override
  String get routingLists => 'Geo files';

  @override
  String get listSource => 'List source';

  @override
  String get listSourceCustom => 'Set by hand';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Updated $ago';
  }

  @override
  String get updateLists => 'Update the geo files';

  @override
  String get listsUpdated => 'The geo files were updated.';

  @override
  String get testDestination => 'Test a destination';

  @override
  String get destinationHint => 'A name, an address, or a URL';

  @override
  String get check => 'Check';

  @override
  String get routeDirect => 'Goes directly';

  @override
  String get routeProxy => 'Goes through the VPN';

  @override
  String get routeBlock => 'Blocked';

  @override
  String ruleMatched(String rule) {
    return 'Rule: $rule';
  }

  @override
  String get portRefusedNote =>
      'Mozilla\'s proxy does not connect to this port.';

  @override
  String get sectionAdvanced => 'Advanced';

  @override
  String get tlsFragment => 'TLS fragmentation';

  @override
  String get tlsFragmentOff => 'Off';

  @override
  String get tlsFragmentFirstByte => 'First byte';

  @override
  String get tlsFragmentSni => 'Server name (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Splits the TLS header at the first byte (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Splits the server name (SNI) across TCP packets';

  @override
  String get tlsFragmentRecord => 'TLS record';

  @override
  String get tlsFragmentRecordHint =>
      'Splits the server name (SNI) across two TLS records';

  @override
  String get tlsFragmentOffHint => 'Normal TLS connection';

  @override
  String get sectionBypass => 'If Mozilla is blocked';

  @override
  String get sharedRelay => 'Shared relay';

  @override
  String get sharedRelayHint =>
      'Use the app\'s shared relays if Mozilla blocks your region. An enabled personal relay takes priority.';

  @override
  String get personalRelay => 'Personal relay';

  @override
  String get apiRelay => 'Relay server';

  @override
  String get apiRelayUse => 'Use the relay server';

  @override
  String get apiRelayHint =>
      'Your own Cloudflare Worker, or relay.php on your own host.\nUsed only when Mozilla doesn\'t answer directly: the sign-in, accounts, and server list go through it, not the VPN traffic.';

  @override
  String get upstreamProxy => 'Upstream proxy';

  @override
  String get upstreamProxyOn => 'Upstream proxy is on';

  @override
  String get upstreamProxyAddress => 'SOCKS5 proxy address';

  @override
  String get upstreamProxyPort => 'Port';

  @override
  String get upstreamProxyHint =>
      'The connection to Mozilla goes through this proxy, for networks that block or slow Mozilla.\nIf the proxy runs on this device, leave it out of the VPN.';

  @override
  String get upstreamProxyInvalid =>
      'Enter the proxy\'s address, such as 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Enter a port from 1 to 65535.';

  @override
  String get upstreamProxyOwn =>
      'That\'s this app\'s own proxy. Enter another one.';

  @override
  String get apiRelayInvalid => 'Must be an https:// address.';

  @override
  String get listenAddress => 'Listen on';

  @override
  String get listenLocal => '127.0.0.1 · this device only';

  @override
  String get listenAll => '0.0.0.0 · all networks (LAN)';

  @override
  String get proxyUsername => 'Proxy username';

  @override
  String get proxyPassword => 'Proxy password';

  @override
  String get proxyLoginHint =>
      'Apps must sign in with these. Leave both empty for no login.';

  @override
  String get loginBothOrNone => 'Fill in both, or leave both empty.';

  @override
  String get proxyLogin => 'Proxy login';

  @override
  String get idleSleep => 'Sleep when idle after';

  @override
  String get sleepNever => 'Never';

  @override
  String sleepMinutes(int count) {
    return '$count minutes';
  }

  @override
  String get sleepHour => '1 hour';

  @override
  String get showPublicIp => 'Show the public IP';

  @override
  String get hapticFeedback => 'Vibrate when the connection changes';

  @override
  String get keepScreenOn => 'Keep the screen awake while connected';

  @override
  String get showTraffic => 'Show live traffic on the home page';

  @override
  String get speedInNotification => 'Show speed in the notification';

  @override
  String get liveTraffic => 'Live traffic';

  @override
  String get totalTraffic => 'Total traffic';

  @override
  String get verboseLogs => 'Detailed logs';

  @override
  String get webDashboard => 'Web dashboard';

  @override
  String get webDashboardOpen => 'Open';

  @override
  String get webDashboardHint => 'Advanced settings and more tools';

  @override
  String numberInvalid(int min, int max) {
    return 'Enter a number from $min to $max';
  }

  @override
  String get notifySwitchedTitle => 'Switched account';

  @override
  String notifySwitchedBody(String name) {
    return 'Now using $name.';
  }

  @override
  String get notifySignInTitle => 'Sign-in needed';

  @override
  String get notifySignInBody =>
      'An account must be signed in again on the Accounts page.';

  @override
  String get navAbout => 'About';

  @override
  String get appVersionLabel => 'App version';

  @override
  String get coreVersionLabel => 'Core version';

  @override
  String get checkUpdates => 'Check for updates';

  @override
  String get checkingUpdates => 'Checking…';

  @override
  String get upToDate => 'You have the latest version.';

  @override
  String updateAvailable(String version) {
    return 'Version $version is available.';
  }

  @override
  String updateRequired(String version) {
    return 'Please update to version $version. This update is required.';
  }

  @override
  String get download => 'Download';

  @override
  String updateCheckFailed(String error) {
    return 'Could not check for updates: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'Could not reach GitHub. Check your internet connection and try again.';

  @override
  String get updateNow => 'Update';

  @override
  String updateDownloading(String version) {
    return 'Downloading version $version…';
  }

  @override
  String updateReady(String version) {
    return 'Version $version is ready to install.';
  }

  @override
  String updateInstalling(String version) {
    return 'Installing version $version. The app will close and open again.';
  }

  @override
  String updateFailed(String version) {
    return 'Couldn\'t update to version $version.';
  }

  @override
  String updateDone(String version) {
    return 'Updated to version $version.';
  }

  @override
  String updateRolledBack(String version) {
    return 'The update to version $version didn\'t finish, so the app went back to the previous version.';
  }

  @override
  String get repoNotSet => 'The GitHub repository is not set yet.';

  @override
  String get sourceCode => 'Source code';

  @override
  String get tapToConnect => 'Click to connect';

  @override
  String get tapToDisconnect => 'Click to disconnect';

  @override
  String get startOnBoot => 'Start on boot';

  @override
  String get connectOnStartup => 'Connect on startup';

  @override
  String get proxyServiceActive => 'Proxy service active';

  @override
  String get navHome => 'Home';

  @override
  String get groupApp => 'App';

  @override
  String get groupNetwork => 'Network';

  @override
  String get stateOff => 'Disconnected';

  @override
  String get tapToConnectPhone => 'Tap to connect';

  @override
  String get tapToDisconnectPhone => 'Tap to disconnect';

  @override
  String get tapToConnectTv => 'Press OK to connect';

  @override
  String get tapToDisconnectTv => 'Press OK to disconnect';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Recommended location';

  @override
  String dataLeftOf(String limit) {
    return 'of $limit';
  }

  @override
  String get homeLocation => 'Location';

  @override
  String get connectedTo => 'Connected to';

  @override
  String get vpnNotAllowed =>
      'The VPN needs your permission. Tap the button again and allow it.';

  @override
  String get dataUsedTitle => 'Data used';

  @override
  String get bypassApps => 'Per-app proxy';

  @override
  String get connectRetrying => 'Couldn\'t connect. Check your internet.';

  @override
  String get failUnreachable =>
      'Couldn\'t reach Mozilla\'s servers. Try another internet connection.';

  @override
  String get failUpstreamProxy =>
      'Couldn\'t reach Mozilla through your upstream proxy. Check that it\'s running.';

  @override
  String get failInsideVpn =>
      'This internet already goes through a VPN. Turn it off.';

  @override
  String get failRefused =>
      'Mozilla\'s server refused the connection. Try again in a few minutes.';

  @override
  String get failLocationRefused =>
      'This country isn\'t open to your account. Choose another country.';

  @override
  String get useRecommendedLocation => 'Use the recommended location';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'You chose $chosen, but your IP is in $exit.';
  }

  @override
  String get failSignIn =>
      'This account\'s sign-in has expired. Sign in again on the Accounts page.';

  @override
  String get failQuota => 'This month\'s data is used up. Add another account.';

  @override
  String get failNotEntitled =>
      'Mozilla doesn\'t let this account use the VPN. Add another account.';

  @override
  String get failRegion =>
      'Mozilla doesn\'t offer its service in your country.';

  @override
  String get failServer =>
      'Mozilla\'s service has a temporary problem. The app tries again by itself.';

  @override
  String get failNoAccount => 'No account is ready. Open the Accounts page.';

  @override
  String get failTestSite =>
      'Connected to the server, but sites don\'t open. Try another country.';

  @override
  String get failOther => 'Couldn\'t connect. Try again.';

  @override
  String get failNoInternet => 'No internet. Check Wi-Fi or mobile data.';

  @override
  String get waitingForNetwork => 'Waiting for an internet connection…';

  @override
  String proxyStartFailed(String port) {
    return 'The proxy couldn\'t start on port $port. Choose another port.';
  }

  @override
  String get connectionSettings => 'Connection settings';

  @override
  String get appModeExclude => 'Bypass selected apps';

  @override
  String get appModeInclude => 'Proxy selected apps';

  @override
  String get appModeExcludeHint =>
      'Selected apps connect directly, not through the VPN: for example banking apps that refuse foreign addresses.';

  @override
  String get appModeIncludeHint =>
      'Only the selected apps go through the VPN; the others connect directly.';

  @override
  String fromRegionList(String region) {
    return 'Suggested: on the $region list';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Connection mode';

  @override
  String get modeProxyHint =>
      'Only apps set up to use the proxy go through it.';

  @override
  String get modeSystemProxyHint =>
      'Windows and most apps go through the proxy.';

  @override
  String get modeSystemProxyHintOther =>
      'Browsers and most apps go through the proxy.';

  @override
  String get suggestedApps => 'Suggested apps';

  @override
  String get showSystemApps => 'Show system apps';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suggested apps selected',
      one: '1 suggested app selected',
      zero: 'The suggested apps are already selected',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Automatic';

  @override
  String get locationsSection => 'Locations';

  @override
  String get dnsSummaryOk => 'Encrypted DNS works';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count names did not resolve',
      one: '1 name did not resolve',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'via $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Your network\'s DNS answered $count names with a filtering address. This app does not use it for them.',
      one: 'Your network\'s DNS answered 1 name with a filtering address. This app does not use it for them.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Answer:';

  @override
  String get dnsNetworkAnswer => 'Network DNS:';

  @override
  String get dnsFiltered => 'filtered';

  @override
  String get rulesSyntaxTitle => 'One rule per line';

  @override
  String get ruleDomain => 'The site and its subdomains';

  @override
  String get ruleFull => 'Exactly this name';

  @override
  String get ruleKeyword => 'Names that contain the word';

  @override
  String get ruleGeosite => 'Sites of a tag in the geo files';

  @override
  String get ruleGeoip => 'Addresses of a country in the geo files';

  @override
  String get ruleIp => 'An address or a network';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Proxy only';

  @override
  String get noNetwork =>
      'No internet connection. Turn on Wi-Fi or mobile data.';

  @override
  String get blockAds => 'Block ads';

  @override
  String systemProxyTakenBy(String address) {
    return 'Another program set the system proxy to $address, so traffic doesn\'t go through the VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Another program turned the system proxy off, so traffic doesn\'t go through the VPN.';

  @override
  String get setSystemProxyAgain => 'Set it again';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'All $os traffic goes through the VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'Waiting for permission to install the TUN service…';

  @override
  String get tunInstallCancelled =>
      'TUN mode needs administrator permission once. It wasn\'t given, so the mode didn\'t change.';

  @override
  String tunInstallFailed(String error) {
    return 'Couldn\'t install the TUN service: $error';
  }

  @override
  String get tunStarting => 'Starting TUN mode…';

  @override
  String get tunFailed => 'TUN mode couldn\'t start. Trying again…';

  @override
  String get tunLost => 'TUN mode stopped unexpectedly. Trying again…';

  @override
  String get tunNotRunning => 'The TUN service isn\'t running. Trying again…';

  @override
  String get tunMissing => 'The TUN service isn\'t installed.';

  @override
  String get tunOutdated =>
      'The TUN service is older than this app. Install it again to use TUN mode.';

  @override
  String get tunAppOutdated =>
      'The TUN service is newer than this app. Update the app to use TUN mode.';

  @override
  String get tunBusy => 'Another copy of Homa VPN is using TUN mode.';

  @override
  String get tunNoDriver =>
      'The system\'s TUN driver isn\'t available. Restart the computer and try again.';

  @override
  String get tunInstall => 'Install';

  @override
  String get tunInstallAgain => 'Install again';

  @override
  String get trayTunMode => 'TUN mode (all apps)';

  @override
  String get removeTunService => 'Remove the TUN service';

  @override
  String get removeTunServiceHint =>
      'Removes the system service that TUN mode uses. Choosing TUN again installs it again.';

  @override
  String get tunServiceRemoved => 'The TUN service was removed.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN wants to install the service for TUN mode.';

  @override
  String get tunRemovePrompt =>
      'Homa VPN wants to remove the service for TUN mode.';

  @override
  String tunRemoveFailed(String error) {
    return 'Couldn\'t remove the TUN service: $error';
  }

  @override
  String get sectionTun => 'TUN settings';

  @override
  String get tunPrograms => 'Programs that bypass the VPN';

  @override
  String get tunProgramsHint =>
      'They connect directly, not through Mozilla. Only for programs that work without a VPN.';

  @override
  String get tunProgramsEmpty => 'No programs yet.';

  @override
  String get addProgram => 'Add program';

  @override
  String get programFiles => 'Programs';

  @override
  String get tunProgramAll => 'All traffic';

  @override
  String get tunProgramAllHint => 'The whole program connects directly.';

  @override
  String get tunProgramUdp => 'UDP only';

  @override
  String get tunProgramUdpHint =>
      'Only its UDP connects directly; the rest goes through the VPN.';

  @override
  String get udpNoticeSetting => 'Notice when UDP is blocked';

  @override
  String udpNoticeBody(String program) {
    return '$program\'s UDP traffic can\'t go through the VPN.';
  }

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get addRunningProgram => 'From running programs';

  @override
  String get addProgramFile => 'Choose a file…';

  @override
  String get addProgramName => 'Type a name…';

  @override
  String get programNameHint =>
      'A program\'s file name, such as steam.exe; * stands for any text (steam* is every Steam program).';

  @override
  String get runningProgramsEmpty => 'No other programs are running.';

  @override
  String get tabLog => 'Log';

  @override
  String get tabConnections => 'Connections';

  @override
  String get connectionsEmpty => 'No connections yet.';

  @override
  String connectionsOpen(int count) {
    return '$count open';
  }

  @override
  String get connTime => 'Time';

  @override
  String get connRoute => 'Rule';

  @override
  String get connDestination => 'Destination';

  @override
  String get connInbound => 'Inbound';

  @override
  String get connProtocol => 'Protocol';

  @override
  String get connColumns => 'Columns';

  @override
  String get connTraffic => 'Traffic';

  @override
  String get connDuration => 'Duration';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Direct';

  @override
  String get connRouteBlocked => 'Blocked';

  @override
  String get connRoutePort => 'Port refused';

  @override
  String get connRouteFailed => 'Failed';

  @override
  String get testRelay => 'Test relay health';

  @override
  String get relayTestTitle => 'Relay health test';

  @override
  String get relayTestHint =>
      'Checks only the relay. No Mozilla request or account information is sent.';

  @override
  String get relayTestPassed => 'Relay is ready';

  @override
  String get relayTestFailed => 'Relay health could not be confirmed';

  @override
  String get relayTestCopy => 'Copy report';

  @override
  String get relayTestInterrupted =>
      'The test ended before a complete result was received.';

  @override
  String get searchLocations => 'Search locations';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count locations',
      one: '1 location',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Automatic updates';

  @override
  String get autoInstallApkHint =>
      'New versions download by themselves; the installer asks before it installs.';

  @override
  String get installNow => 'Install';

  @override
  String get updateAllowInstall =>
      'To install the update, allow this app to install apps.';

  @override
  String get allowInstall => 'Allow';

  @override
  String get noResults => 'No location matches the search.';

  @override
  String get accentColor => 'Accent color';

  @override
  String get accentMono => 'Monochrome (default)';

  @override
  String get accentCustom => 'Custom color';

  @override
  String get accentEmber => 'Ember';

  @override
  String get accentGold => 'Gold';

  @override
  String get accentEmerald => 'Emerald';

  @override
  String get accentSapphire => 'Sapphire';

  @override
  String get accentAmethyst => 'Amethyst';

  @override
  String get accentRose => 'Rose';

  @override
  String get autoReconnect => 'Auto-reconnect';

  @override
  String get autoReconnectHint =>
      'Puts the connection back up by itself when it drops.';

  @override
  String get androidOnlyHint => 'On the phone only.';

  @override
  String get idleDisconnect => 'Disconnect when idle';

  @override
  String get idleDisconnectHint =>
      'Ends the session when no traffic moves for a while.';

  @override
  String get idleTimeout => 'Idle wait';

  @override
  String get minutes5 => '5 minutes';

  @override
  String get minutes10 => '10 minutes';

  @override
  String get minutes15 => '15 minutes';

  @override
  String get minutes30 => '30 minutes';

  @override
  String get minutes60 => '1 hour';

  @override
  String get dataLimit => 'Session data limit';

  @override
  String get dataLimitHint =>
      'Ends the session when its traffic reaches the limit.';

  @override
  String get dataLimitAmount => 'Limit';

  @override
  String get mb256 => '256 MB';

  @override
  String get mb512 => '512 MB';

  @override
  String get mb1024 => '1 GB';

  @override
  String get mb2048 => '2 GB';

  @override
  String get mb5120 => '5 GB';

  @override
  String get mb10240 => '10 GB';

  @override
  String autoStoppedIdle(int minutes) {
    return 'No traffic moved for $minutes minutes, so the connection was disconnected.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'The session reached its $mb MB data limit, so it was disconnected.';
  }

  @override
  String get protection => 'Protection';

  @override
  String get killSwitch => 'Kill switch';

  @override
  String get killSwitchHint =>
      'If the VPN dies, traffic is held — never leaked — until it reconnects.';

  @override
  String get alwaysOnVpn => 'Always-on VPN';

  @override
  String get alwaysOnVpnHint =>
      'Android\'s own guard: no connection without the VPN.';

  @override
  String get floatingIsland => 'Floating island';

  @override
  String get floatingIslandHint =>
      'Carries the connection over the other apps while the app is away.';

  @override
  String whatsNewTitle(String version) {
    return 'What\'s new in $version';
  }

  @override
  String get whatsNewContinue => 'Got it';

  @override
  String get whatsNewMenu => 'What\'s New';

  @override
  String get whatsNewView => 'View again';

  @override
  String get updateServers => 'Update servers';

  @override
  String get updatingServers => 'Updating…';

  @override
  String serversUpdated(int count) {
    return '$count locations from Mozilla\'s official list';
  }

  @override
  String get serversUpdateFailed =>
      'The server list could not be updated; the previous list is kept.';

  @override
  String get smartPickTitle => 'Fastest right now';

  @override
  String get smartPickUse => 'Use';

  @override
  String get connectAtBoot => 'Connect after the phone starts';

  @override
  String get connectAtBootHint =>
      'Connects by itself at boot, when the VPN permission is already granted.';

  @override
  String get gamingProfile => 'Gaming profile';

  @override
  String get gamingProfileHint =>
      'Shows the connection\'s live delay and quality; pairs with the fastest measured server.';

  @override
  String get diagnosticsRun => 'Run diagnostics';

  @override
  String get diagnosticsHint =>
      'Connection, DNS, and tunnel, checked in one tap';

  @override
  String get diagnosticsTunnel => 'Tunnel';

  @override
  String get diagnosticsTunnelUp => 'Up and carrying traffic';

  @override
  String get diagnosticsTunnelDown => 'Down';

  @override
  String get diagnosticsExit => 'Exit country';

  @override
  String get diagnosticsMismatch => 'Exit differs from the choice';

  @override
  String get diagnosticsConnection => 'Connection test';

  @override
  String get diagnosticsPassed => 'Passed';

  @override
  String get diagnosticsFailed => 'Failed';

  @override
  String get diagnosticsDnsFiltered => 'Blocked or filtered answer';

  @override
  String get diagnosticsDnsOk => 'Answered';

  @override
  String get diagnosticsPrivacy =>
      'Nothing here is stored; the results stay in this window and the core\'s own log.';

  @override
  String get diagnosticsAgain => 'Run again';

  @override
  String get whatsNewAdded => 'New';

  @override
  String get whatsNewImproved => 'Improved';

  @override
  String get whatsNewFixed => 'Fixed';

  @override
  String get wnWheelImproved =>
      'The country wheel is redrawn: the chosen flag stands bigger in a glass frame with a fine glow and a soft halo of light behind it, the other flags sit smaller with depth, and the name below arrives with a slide.';

  @override
  String get wnLiveImproved =>
      'While connected, the notification asks Android 16 to promote it as a Live Update, the way the reference implementation does; the duration keeps counting, the speeds keep running.';

  @override
  String get wnL10nFixed =>
      'This page now speaks the app\'s language — every one of its fifteen languages, not only English.';

  @override
  String get wnMarkFixed =>
      'Mozilla\'s mark sits clean on its tile, rounded like the flags.';

  @override
  String get designTitle => 'Home design';

  @override
  String get designHint => 'How the home page is laid out';

  @override
  String get designWheel => 'Wheel';

  @override
  String get designWheelDesc =>
      'The flags in their glass wheel, the switch under them';

  @override
  String get designBento => 'Bento';

  @override
  String get designBentoDesc =>
      'The lunch box\'s own design: the flags on their board of tiles, the connect tile, the numbers and the place as tiles of one warm box';

  @override
  String get designPixel => 'Material You';

  @override
  String get designPixelDesc =>
      'Material You: the tonal surfaces, the big filled cards, the pill-indicator bar and the large titles — the Android\'s own voice';

  @override
  String get notifFlag => 'Country flag in the notification';

  @override
  String get notifFlagHint =>
      'The notification\'s own flag beside the country\'s name';

  @override
  String get wnDesignAdded =>
      'A Home design setting: the wheel, the tiles, or the compact card';

  @override
  String get wnMapAdded =>
      'A real vector world map behind the home page, with the chosen country lit';

  @override
  String get wnWheelAdded =>
      'The flag wheel redrawn: deeper glass, smoother motion, richer depth';

  @override
  String get wnFlagNotifAdded =>
      'The notification can show the country\'s SVG flag, and be told not to';

  @override
  String get wnColorRemoved =>
      'The Custom color page was removed; the accent list keeps its hex';

  @override
  String get whatsNewRemoved => 'Removed';

  @override
  String get wnCrashFixed =>
      'The app no longer stops by itself on Android 16 phones: the notification asked the system for a piece the phone does not have yet.';

  @override
  String get wnFlagArtFixed =>
      'The app no longer kicks itself out when opened: the notification\'s flag art answered with a value the system\'s messenger refuses.';

  @override
  String get statSession => 'Session';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get wnTotalsAdded =>
      'The home shows what the session moved in total, and a tap copies the public IP.';

  @override
  String get wnPolishImproved =>
      'The flags\' wheel and the servers page sit tidier; texts are compact, and the Android tunnel carries the traffic at a higher speed.';

  @override
  String get valueSmart => 'Smart';

  @override
  String get wnSmartAdded =>
      'Smart connection: MTU, protocol, and IP version follow the network, chosen by real answers for speed.';

  @override
  String get wnToastAdded =>
      'Confirmations arrive as a soft iOS-style note, with a mark that draws itself.';

  @override
  String get wnFlagsImproved =>
      'The flag wheel sits clean: no flag is cut at the screen\'s edge, flags show whole, and the choice lands with a soft spring.';

  @override
  String get wnMapImproved =>
      'The world map is drawn larger and clearer: no squeezed continents, smooth coastlines, and a glowing halo at the anchor.';

  @override
  String get dnsManual => 'Manual DNS';

  @override
  String get dnsManualHint =>
      'One address per line: a plain IP, https:// (DNS over HTTPS), or tls://host (DNS over TLS). The first answer wins.';

  @override
  String get dnsManualInvalid =>
      'One line is not an address the core can use: a plain IP, https://…, or tls://host.';

  @override
  String get killSwitchGuarded =>
      'Guarded: nothing leaves the phone while the tunnel is down.';

  @override
  String get accountsUsageTitle => 'This month';

  @override
  String get accountsCountLabel => 'accounts';

  @override
  String get accountsUsageAverage => 'average of the accounts\' spent share';

  @override
  String get wnDesignsAdded =>
      'App designs: the whole app can wear Soft Neumorphism or Aurora Glass — every page, every card — picked in Settings → General.';

  @override
  String get wnWheelFixed =>
      'The wheel\'s half-flag is gone: the shelf under the chosen flag is a pool of light, not a second flag, and no flag is cut at the screen\'s edge.';

  @override
  String get wnMapReal =>
      'The world map is redrawn from official country borders — every coast, island, and enclave at true fidelity, in true proportion.';

  @override
  String get wnGlobeAdded =>
      'The world is a globe now: the silver ball turns to face the chosen country, a glowing pin and a floating card mark it, and the connection\'s roads reach for the hubs.';

  @override
  String get wnWheelGlowImproved =>
      'The chosen flag stands bigger in a glass frame with its own blue halo, the neighbors sit clearly smaller, and the markers under the wheel show where you are.';

  @override
  String get wnDesignsRemoved =>
      'The App Design picker has left: the app wears its own monochrome look again — your accent and your theme stay as they were.';

  @override
  String get wnDnsAdded =>
      'Manual DNS: plain IPs, DNS over HTTPS, and DNS over TLS — each line\'s kind shown and checked as you type.';

  @override
  String get wnSmartImproved =>
      'The smart connection now shows what the network answered: the transport it picked and the IP family it kept, live.';

  @override
  String get wnProtectionImproved =>
      'The kill switch says when its guard stands, and the apps page shows how many apps you chose.';

  @override
  String get wnWelcomeImproved =>
      'The welcome opens with a breathing shield over a drifting aurora, and the accounts page sums the month at a glance.';

  @override
  String bypassAppsCount(String n) {
    return 'Chosen: $n';
  }

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get mapStyle => 'Map style';

  @override
  String get mapStyleHint =>
      'The home page\'s globe, painted the way you pick. The connection\'s light stays the same.';

  @override
  String get mapSilver => 'Silver';

  @override
  String get mapMidnight => 'Midnight';

  @override
  String get mapOcean => 'Ocean';

  @override
  String get mapMono => 'Mono';

  @override
  String get mapAurora => 'Aurora';

  @override
  String get batterySaver => 'Battery saver';

  @override
  String get batterySaverHint =>
      'Puts the map\'s motion to rest while connected — the globe\'s breath, the wheel\'s glow. The connection itself stays exactly as it is.';

  @override
  String get connectOnOpen => 'Connect when the app opens';

  @override
  String get connectOnOpenHint =>
      'Brings the VPN up as the app opens, with the location you last chose.';

  @override
  String get speedTitle => 'Speed';

  @override
  String get parallelTunnels => 'Parallel tunnels';

  @override
  String get parallelTunnelsHint =>
      'Opens several tunnels to Mozilla at once and splits the traffic between them, so one slow tunnel no longer caps the speed. Eight is the heaviest on the battery.';

  @override
  String get tunnels1 => 'One — the most stable';

  @override
  String get tunnels2 => 'Two';

  @override
  String get tunnels4 => 'Four — faster on slow networks';

  @override
  String get tunnels8 => 'Eight — the fastest';

  @override
  String get connectionCap => 'Connection limit';

  @override
  String get connectionCapHint =>
      'How many apps may talk through the VPN at once; a smaller cap saves battery and data on a busy phone. No limit is the default.';

  @override
  String get capNone => 'No limit';

  @override
  String get verboseLogging => 'Detailed diagnostics';

  @override
  String get verboseLoggingHint =>
      'Writes every step to the log — helpful when reporting a problem, a little heavier on the battery.';

  @override
  String get wn38MapStylesAdded =>
      'Five looks for the map: silver, midnight, ocean, mono, and aurora — the settings\' new Appearance page picks, with a preview of each.';

  @override
  String get wn38ZoomAdded =>
      'The map zooms: pinch it, or double-tap to step in and back out.';

  @override
  String get wn38OptionsAdded =>
      'Practical options: parallel tunnels for more speed, a connection limit, battery saver, connect when the app opens, and detailed diagnostics.';

  @override
  String get wn38SocialAdded =>
      'Instagram and Telegram now live at the bottom of this page too.';

  @override
  String get wn38FlightImproved =>
      'Choosing a country is a small flight: the camera pulls back, the ball turns, the pin drops with a bounce, and the roads draw themselves out to the hubs.';

  @override
  String get wn38EffectsImproved =>
      'The map reads richer: stars behind the ball, a coordinate grid, the hubs\' own lights, a halo around the limb, and the land\'s shadow.';

  @override
  String get wn38SpeedImproved =>
      'The speed option is real: parallel tunnels open several connections at once, and the core splits the traffic between them.';

  @override
  String get wn38NameFixed =>
      'The chosen country\'s name shows once — on the map\'s floating card; the copy under the flags is gone.';

  @override
  String get mapKind => 'Map type';

  @override
  String get mapKindHint =>
      'How the home\'s world is carried: the flat map as it always was (the default), its modern finish, the night earth, the terrain earth, the metal ball, or the satellite\'s earth. The borders are the real, official ones in every kind.';

  @override
  String get mapKindClassic => 'Classic';

  @override
  String get mapKindGlobe => '3D globe';

  @override
  String get mapKindSatellite => 'Satellite';

  @override
  String get mapKindFlat => 'Flat 2D';

  @override
  String get mapKindHud => 'Radar';

  @override
  String get mapStyleGlobeHint =>
      'The colors the 3D globe wears. The satellite carries its own earth, and the flat maps their own ink.';

  @override
  String get aboutVersions => 'Version';

  @override
  String get aboutChannels => 'Contact pages';

  @override
  String get checkUpdatesHint =>
      'Look for a newer version; a found one downloads and the installer asks.';

  @override
  String get speedTestTitle => 'Speed test';

  @override
  String get speedTestRun => 'Measure';

  @override
  String get speedTestFailed => 'The measurement did not finish.';

  @override
  String get speedTestThrough => 'Measured through the tunnel.';

  @override
  String get speedTestDirect => 'Measured directly (the proxy is off).';

  @override
  String get speedTestHint =>
      'A download and an upload through the tunnel tell you what it really carries. The graph on the home page opens this too.';

  @override
  String get speedGraphHint => 'The tunnel’s last minute · tap to measure';

  @override
  String get favoritePinned => 'Pinned. Long-press again to unpin.';

  @override
  String get favoriteUnpinned => 'Unpinned.';

  @override
  String get shareReport => 'Share report';

  @override
  String get shareReportCopied => 'The report is on the clipboard.';

  @override
  String get batteryWizardTitle => 'Stay alive on the battery';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei and the like kill VPN apps after the screen locks. Take this app out of battery optimization so the tunnel stays on.';

  @override
  String get batteryWizardSteps =>
      'In the maker’s own settings also allow autostart, and set the app to No restrictions (Xiaomi), Remove from Sleeping apps (Samsung), or Launch — Manual (Huawei).';

  @override
  String get batteryWizardState => 'Battery optimization can stop the tunnel.';

  @override
  String get batteryWizardPermit => 'Allow';

  @override
  String get batteryWizardOk => 'The tunnel is protected from the battery.';

  @override
  String get batteryWizardOpen => 'Battery settings';

  @override
  String get usageTitle => 'App usage';

  @override
  String get usageRowHint => 'What each app’s traffic was';

  @override
  String get usageGrant => 'Open Usage access';

  @override
  String get usageGrantHint =>
      'Android keeps per-app data usage behind the Usage access permission. The page the button opens is the system’s own; the app reads only the numbers.';

  @override
  String get usageEmpty => 'No usage recorded in this period.';

  @override
  String get usageToday => 'Today';

  @override
  String get usageWeek => 'Last 7 days';

  @override
  String get usageMonth => 'Last 30 days';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'The app installs outside Google Play, so Play Protect may ask to scan it on the first install. Tap \"Scan app\" once — a clean scan is remembered, and the updates after it install quietly.';

  @override
  String get smartLocation => 'Fastest location';

  @override
  String get smartLocationHint =>
      'Every start rides the server the core\'s own latency test says is fastest.';

  @override
  String get quicPass => 'QUIC pass-through';

  @override
  String get quicPassHint =>
      'Apps\' QUIC (UDP 443) rides the tunnel: calls and games keep their speed instead of falling back to TCP.';

  @override
  String get accountRename => 'Rename account';

  @override
  String get accountRenameLabel => 'Account name';

  @override
  String get accountProfile => 'Profile picture';

  @override
  String get avatarReset => 'Back to the plain mark';

  @override
  String get accountSecurity => 'App password';

  @override
  String get appPasswordOn => 'The app opens behind a password.';

  @override
  String get appPasswordOff => 'No password: anyone who opens the app gets in.';

  @override
  String get appPasswordSet => 'Set password';

  @override
  String get appPasswordChange => 'Change password';

  @override
  String get appPasswordRemove => 'Remove password';

  @override
  String get appPasswordCurrent => 'Current password';

  @override
  String get appPasswordNew => 'New password (4+ characters)';

  @override
  String get appPasswordConfirm => 'Repeat the new password';

  @override
  String get appPasswordShort => 'At least 4 characters.';

  @override
  String get appPasswordMismatch => 'The two words are not the same.';

  @override
  String get appPasswordWrong => 'Wrong password';

  @override
  String get appPasswordSetDone =>
      'The password stands — the app asks for it from the next start.';

  @override
  String get appPasswordRemoved =>
      'The password is gone; the app opens freely.';

  @override
  String get appPasswordUnlock => 'The app is locked';

  @override
  String get appPasswordUnlockHint => 'Enter the app password to continue.';

  @override
  String get wn39MapKinds =>
      'The map is a choice of kinds again: the flat map as it always was (the default), the 3D globe, the satellite\'s earth, and a modern flat 2D.';

  @override
  String get wn39EyeIp =>
      'The location card carries an eye: tap it to see the address the traffic leaves from, and copy it.';

  @override
  String get wn39Profile =>
      'Accounts carry their own name and profile picture, and the app can open behind a password.';

  @override
  String get wn39Smart =>
      'The smart connection grew: the fastest location by real latency, and QUIC pass-through for calls and games.';

  @override
  String get wn39Flight =>
      'A change of country flies smoother — the camera rides the great circle — and the flag wheel\'s markers sit closer to the flags.';

  @override
  String get wn39ToastEverywhere =>
      'The dynamic note is everywhere now: every saved, copied, and failed notice wears the same animated glass pill.';

  @override
  String get wn39Updates =>
      'Updates keep the storage clean: the installer replaces the old version, and no package is left behind.';

  @override
  String get mapKindNight => 'Night';

  @override
  String get mapKindTerrain => 'Terrain';

  @override
  String get wn40MapKindsNew =>
      'Two new map finishes: the night earth and the terrain earth.';

  @override
  String get wn40Flight =>
      'The 3D globe flies to the new country in one smooth turn — never a jump.';

  @override
  String get wn40Mercator =>
      'The flat maps draw in the standard Mercator projection: true proportions, standard borders, nothing squeezed.';

  @override
  String get wn40NameBack =>
      'The chosen country\'s name is back under the flags on the flat maps.';

  @override
  String get wn40Speed =>
      'The tunnel now opens two parallel sessions by default — a stronger, steadier line.';

  @override
  String get wn40LockFixed =>
      'The connect button\'s lock no longer blinks out between its states.';

  @override
  String get wn40IpRemoved => 'The IP popup on the location card is gone.';

  @override
  String get soundFeedback => 'Sound effects';

  @override
  String get soundFeedbackHint =>
      'Soft sounds for taps, switches, and the connection\'s turns';

  @override
  String get rateUnit => 'Speed unit';

  @override
  String get lockInBackground => 'Lock when leaving';

  @override
  String get lockBgNever => 'Never';

  @override
  String get lockBgNow => 'Right away';

  @override
  String get lockBgMin5 => 'After 5 minutes';

  @override
  String get lockBgMin15 => 'After 15 minutes';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound =>
      'A connection sound joins the vibration: the VPN hums a short note as it comes up or goes down (Settings → General).';

  @override
  String get wn41RateUnit =>
      'The speed reads in the unit you pick: the familiar KB/s or the connection\'s own Mbps.';

  @override
  String get wn41BackgroundLock =>
      'The app can lock itself while away: the password asks again right away, after 5, or after 15 minutes.';

  @override
  String get wn41BiggerLimits =>
      'The session\'s data limit climbs to 25, 50, or 100 GB.';

  @override
  String get wn41Motion =>
      'New motion: the connected orb breathes, the check draws itself in, the state\'s word glides between its values, and a wrong password shakes the field.';

  @override
  String get wn41AboutFixed =>
      'The About page sits straight: the two pages side by side, every hint on its own line, nothing squeezed.';

  @override
  String get wn41HapticFixed =>
      'The vibration setting answers again: every connection\'s on and off follows it, not just the slider\'s.';

  @override
  String get copyIp => 'Copy IP';

  @override
  String get wn42Fonts =>
      'Every language reads in the app\'s own faces: Noto Sans for the two Chinese and for Bengali, Inter for the Latin and Cyrillic ones — no language leans on the phone\'s fonts anymore.';

  @override
  String get wn42Sounds =>
      'The app\'s sounds are real now: a soft tap in every section, two notes for the switches, a rising and a falling note as the connection comes up and goes down, a ping for the lock — the sound switch gates them all.';

  @override
  String get wn42AboutFixed =>
      'The About page centers its logo, its name and its note, and the contact handles stay whole on one line whatever the phone\'s width.';

  @override
  String get wn42Gaming =>
      'The gaming profile is real now: the servers page measures the delays fresh every half minute and lifts the measured fastest with the accent.';

  @override
  String get avatarPhoto => 'Your photo';

  @override
  String get avatarPhotoFailed => 'That picture could not be used';

  @override
  String get tlsFragmentAuto => 'Auto';

  @override
  String get tlsFragmentAutoHint =>
      'The whole hello first; a network that keeps cutting TLS gets the name cut on its own, for half an hour';

  @override
  String get accentDesign => 'The design\'s own light';

  @override
  String get wn45Designs =>
      'Four new home looks — Aurora, Neon, Dusk and Sage — each dressing every page in its own palette';

  @override
  String get wn45HelloAuto =>
      'The TLS fragment learned: a network that keeps killing the handshake gets the name cut on its own, and the tunnel gets through';

  @override
  String get wn45RelayRace =>
      'Relay recovery now races three edges at once, so a filtered network finds its way back sooner';

  @override
  String get wn45AccentFixed =>
      'The accent picker lights the app again — its color had stopped reaching the pages';

  @override
  String get wn45WhatsNewFixed =>
      'The What\'s new page shows its words again — it had opened empty';

  @override
  String get wn46Designs =>
      'Two new looks from the reference designs: the aether\'s iOS status card and the zed\'s gradient blob — each dresses the whole app, every page, and the four earlier looks left.';

  @override
  String get wn46Sounds =>
      'The sounds grew a professional set: a swell for the connect that begins, a chord when it carries, a falling one when it rests, and a muted note for the blocked way — one voice at a time.';

  @override
  String get wn47Designs =>
      'The two reference looks now dress the whole app — every page, not just the home: the aether wears AetherST\'s iOS structure (the curved notch bar, the grouped tables, the colored badges, the system\'s own state colors), and the zed wears ZedSecure\'s expressive one (the floating dock, the very-round cards, the draggable tool bubbles).';

  @override
  String get wn47Fixes =>
      'A settings row that overflowed on narrow screens now reads to its end.';

  @override
  String get wn48Bars =>
      'The two designs\' bottom bars hold their places again: the aether\'s blue circle rests in its own tab\'s notch, and the zed\'s circle no longer covers the name under it.';

  @override
  String get wn48Fit =>
      'The homes fit their screens again: the aether\'s card reads Disconnected to its end, the zed\'s orb steps down when the page runs tight, and while the connection is being made no track asks to slide to connect and no hint says disconnect at once.';

  @override
  String get wn48Wheel =>
      'The flags\' wheel dissolves a card before the screen\'s edge can cut it, the recommended place wears Mozilla\'s mark at a size that reads, and the flat map\'s south edge melts into the page instead of ending in a line.';

  @override
  String get wn49States =>
      'The two reference designs wear the details they were drawn with: the aether\'s card carries the session\'s own rates the way AetherST\'s does, its power button breathes the reference\'s glow and sinks under the finger, and the zed\'s blob turns itself between its shapes while its center\'s selves cross-fade.';

  @override
  String get wn49Words =>
      'Connecting has a word everywhere now: while the tunnel is being made, the switch\'s track carries Connecting…, the knob\'s mark fades between its selves, and the track breathes with the connection\'s own rhythm — nothing vanishes under the finger.';

  @override
  String get wn49Sooner =>
      'The connection\'s engine is the original\'s own again: the relay pool, the alternate routes and their cache, and the repeated-request guard carry the tunnel — it comes up sooner and holds.';

  @override
  String get wn49Mark =>
      'The recommended location wears Mozilla VPN\'s real mark, and the update\'s buttons wear the update\'s own glyph.';

  @override
  String get wn50Notch =>
      'The two designs\' dress comes out of the mess it had kept: the aether\'s notch bar reads the circle\'s own center, the chosen tab\'s name wears the page\'s ink on both looks, and the circle\'s glow keeps to the circle instead of washing the name.';

  @override
  String get wn50Cards =>
      'The zed\'s home folds its rates into the bento: the rate card joins the bento\'s two cells and the session\'s row, the page\'s last cards clear the dock\'s seat, and nothing runs half under the dock when the page scrolls to its end.';

  @override
  String get wn50Veil =>
      'The status band wears its veil: the scrolled content fades beneath the clock instead of colliding with it, the zed\'s pushed pages no longer start under the clock, and its floating tools keep clear of the dock\'s seat.';

  @override
  String get wn50Ping =>
      'The aether\'s ping chip measures again on a tap, the way the reference\'s own chip answers.';

  @override
  String get tapToChangeServer => 'Tap to change server';

  @override
  String get wn51Smooth =>
      'The flags\' wheel and the strip move the way a wheel should: the drag and the change of country now ride the compositor — nothing re-lays out and no glow redraws itself while the flags turn, so the wheel spins smooth and the page scrolls with it.';

  @override
  String get wn51Zed =>
      'The zed\'s home wears the reference\'s own structure: the two rate cards stand under the brand (resting at their zeros when the tunnel rests), the state\'s word arrives in the display\'s big face under the orb, and the place lives on the bright server card above the dock — the small chip and the repeated name are gone.';

  @override
  String get wn51Aether =>
      'The aether\'s home says the place once: the strip\'s repeated name line rests, the status card and the power button keep their seats, and the page reads as one clean column.';

  @override
  String get wn51Veil =>
      'The clock\'s veil grew a breath tall and holds its color across the clock\'s band: the content that scrolls beneath it fades whole, and its words never meet the clock.';

  @override
  String get wn52Speed =>
      'The tunnel runs at the network\'s own speed again: the VPN\'s interface speaks the line\'s packet size (MTU 1500) instead of an oversized one, so downloads take their full speed and calls stay steady — on mobile data especially.';

  @override
  String get wn52Smart =>
      'Fastest location and the recommended service choose honestly again: every start measures the locations fresh and takes the best one now, instead of quietly riding the place chosen before.';

  @override
  String get wn52Motion =>
      'Thirty new animations, all over the app: every page and card lands softly, pressed tiles sink and return, the connecting state\'s dot breathes, and pushed pages glide in — each one standing still when the system asks for less motion.';

  @override
  String get wn52Pages =>
      'The pushed pages arrive with a soft glide and the page\'s title from its own edge; while a setting saves, a quiet line sweeps the section.';

  @override
  String get wn56Button =>
      'The connect slider keeps its word through the whole walk — no more empty moment between connecting and connected: the word glides between its states now, and the working dim follows with a breath.';

  @override
  String get wn56Capsule =>
      'The wheel\'s home says each state once: the repeated status word above the slider is gone — the track itself carries it, and the page reads a line quieter.';

  @override
  String get wn56Door =>
      'The speed test has its own door on the home: one row, one tap, and the measurement opens — before the first connect too, not only while the tunnel carries.';

  @override
  String get wn56Wheel =>
      'The flags\' wheel glides: one fling carries one country, and the landing settles into place instead of snapping — the drag reads heavy and steady, the way a good dial turns.';

  @override
  String get designGazette => 'Gazette';

  @override
  String get designGazetteDesc =>
      'A front page: the masthead, the ruled columns and the ink stamp — the news sheet\'s own calm, in paper and ink';

  @override
  String get speedTestSizesTitle => 'Test size';

  @override
  String get wn61Gta =>
      'The GTA design: the game\'s own HUD — the weapon wheel for the flags, the radar-green tunnel, the amber panels, the heavy face and its own tick';

  @override
  String get wn61Sound =>
      'The wheel\'s tick: every seat the dial passes answers in the ear as well as the hand';

  @override
  String get wn62Wheel =>
      'The weapon wheel rebuilt: the seats keep the game\'s own spacing at any country count, the chosen sector carries the wheel\'s lit wedge, and a flick throws the dial';

  @override
  String get wn62Map =>
      'The home\'s map wears each design\'s own colors now — the water, the land and the grid follow the design the page carries';

  @override
  String get wn62HudMap =>
      'The GTA design\'s own map: the game\'s HUD plate — deep water, the neon coast, the amber radar grid and the sweep that walks the world while the tunnel carries';

  @override
  String get wn62Aether =>
      'The Aether design\'s power control rebuilt: the disc stands in a thin ring track, the connecting arc walks the ring, and the machined face catches the light';

  @override
  String get wn62Gta =>
      'The GTA connect pad answers the hand — the whole panel sinks on a press, and the power\'s mark steps back while the connection is being made';

  @override
  String get speedTestSizeLight => 'Light';

  @override
  String get speedTestSizeStandard => 'Standard';

  @override
  String get speedTestSizeFull => 'Full';

  @override
  String get speedTestJitter => 'Jitter';

  @override
  String gazetteEdition(int n) {
    return 'No. $n';
  }

  @override
  String get gazetteBulletin => 'Security Bulletin';

  @override
  String get gazetteLiveWire => 'Live wire';

  @override
  String get wn56Speed =>
      'The speed test lives again: each leg measures on its own connection and speaks plain HTTP/1.1, so the upload no longer dies when the download\'s window closes — and the panel adds the path\'s delay, its jitter, and a size to pick.';

  @override
  String get wn56Gazette =>
      'A new home look: the gazette — a front page with a masthead, ruled columns, a live ticker and the ink stamp that presses when the tunnel carries.';

  @override
  String get designIos => 'iOS';

  @override
  String get designIosDesc =>
      'The system\'s own: the grouped tables, the tab bar\'s hairline, the status card and the capsule button — clarity in the system\'s voice';

  @override
  String get gazetteSection => 'SECTION';

  @override
  String get wn58Lock =>
      'The knob\'s lock keeps its ink when the tunnel carries: the mark now reads the face it stands on — dark on a light knob, white on a dark one — so the icon never drowns again.';

  @override
  String get wn58Enter =>
      'The connected section breathes in: the numbers fade and lift while the room grows beneath them, and walk back out the same way — the cards no longer snap up between two frames.';

  @override
  String get wn58Speed =>
      'The speed test runs lighter: the panel repaints ten times a second at most, the sweep\'s needle walks in a short straight line, and the faces crossfade instead of snapping.';

  @override
  String get wn58Ios =>
      'A new design: iOS — the system\'s own look, from the grouped tables and the tab bar\'s hairline to the status card with its capsule button. Every page, card, dialog and icon in the system\'s voice, in both modes.';

  @override
  String get wn58Pixel =>
      'A new design: Pixel — Material You\'s look, the tonal surfaces, the big filled cards, the pill-indicator bar and the large titles. Every page, card, dialog and icon in the Android\'s own voice, in both modes.';

  @override
  String get wn58Paper =>
      'The gazette is a whole paper now: its own section bar with the print\'s bullet and underline, a section-front header for every pushed page, and the ruled paper box for every group of settings — the print\'s rules reach the whole app.';

  @override
  String get wn59Flags =>
      'The flags wear each design\'s own cut: the round medal on iOS and the aether, the squircle on the zed, the ruled plate on the gazette, the pixel\'s soft big rounds — the wheel, the strip and every row\'s little flag follow.';

  @override
  String get wn59Map =>
      'The world map is drawn in the design\'s own ink: the paper\'s warm brown on the gazette, the violet night\'s gray on the zed, the tonal blue-gray on the pixel — each design\'s world belongs to its page.';

  @override
  String get wn59Buttons =>
      'The connect controls speak their designs: Material You\'s big tonal pill on the pixel, the iOS capsule breathing while the connection is being made, and every page\'s cards entering in their design\'s own motion.';

  @override
  String get wn59Scroll =>
      'The wheels and strips scroll in the design\'s own physics: the system\'s bounce, Material\'s quick settle, and the paper\'s weight that dies against the fold.';

  @override
  String get flagAllPlaces => 'All places';

  @override
  String get gazetteRegions => 'Destinations';

  @override
  String get wn60Flags =>
      'Each design shows the countries its own way now: the bento\'s board of tiles, the pixel\'s filter chips, the aether\'s capsule options, the iOS medals\' deck, the zed\'s paged board, the gazette\'s region index printed like the paper\'s own — the wheel keeps its wheel.';

  @override
  String get wn60Bento =>
      'The bento design stands whole: its own warm palette of porcelain and charcoal, the tangerine\'s light, the dock of tiles, the squircle page headers, the tinted cards and the board of flags — every page, both modes.';

  @override
  String get wn60Spacing =>
      'The homes walk in one rhythm: the dead bands between the sections are gone, the closing cards fill their rows, and every gap breathes by the spacing the design keeps.';

  @override
  String get wn63Retired =>
      'The aether and the zed designs retired: their users walk to the designs that wear their structure — the aether\'s tables to iOS, the zed\'s bento to Bento';

  @override
  String get wn63Map =>
      'The GTA map reads as the game\'s own now: every border as a road, an amber blip on every server country, the chosen place as the waypoint with its beam and its name on the plate, the compass at the corner';

  @override
  String get wn63Servers =>
      'The servers page wears each design\'s own list — the iOS grouped table, the gazette\'s ruled index, the GTA\'s HUD slots, the pixel\'s tonal cards, the bento\'s board';

  @override
  String get wn63Accounts =>
      'The accounts page wears the design too: the cards in the design\'s own round, the add button in the design\'s voice, the dialogs\' titles in the display\'s face, the fields in the design\'s frame';

  @override
  String get wn63Wheel =>
      'The weapon wheel rebuilt to the game\'s own measure: the full circle of sector dividers, the two-layer lit wedge, the counter\'s gauge arc, the pop of the opening, and the pick\'s own pulse';

  @override
  String get wn63Ios =>
      'The iOS design stands fuller: the status card\'s state wash, the medal deck\'s page dots, the tick at every snap';

  @override
  String get wn64Wheel =>
      'The GTA wheel\'s medals sit inside the dial now — twelve seats the game\'s own spread, no medal on the rim or past the screen\'s edge, no two medals touching';

  @override
  String get wn64Glass =>
      'The wheel wears the game\'s glass: the world blurred softly under the dial, the plate a touch see-through, its sheen gathered at the top';

  @override
  String get wn64Groups =>
      'The iOS home\'s own groups: the session\'s table — the tunnel\'s address, a tap from the clipboard — and the quick actions: the speed test, the connection\'s settings, the accounts';

  @override
  String get wn64Headers =>
      'Every page header stretches the page again — the back arrow stands at its edge, not the screen\'s middle';

  @override
  String get wn64Pill =>
      'The Material You pill\'s label keeps its breath inside the rounded ends';

  @override
  String get wn64Map =>
      'The GTA map\'s borders return to their first dress — the coast keeps its neon, the land its thin ink edge';

  @override
  String get wn64Name =>
      'The Pixel design answers to its own name: Material You';

  @override
  String get wn65Gone =>
      'The GTA design left: its home, its pages, its palette — five designs stay, and a settings file that still names it lands on the wheel';

  @override
  String get wn65Tight =>
      'The home packs tighter in every design: the bare bands the screen\'s leftover used to open between the cards are gone — the wheel, the tiles, the paper, the medals and the chips follow one another at a breath\'s distance, and the page scrolls where it used to stretch';

  @override
  String get wn65Radar =>
      'The map the GTA design carried stands on its own now, as the radar: the same deep water, the amber grid and the sweep, under its own name in the map picker';
}
