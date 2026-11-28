import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_az.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('az'),
    Locale('bn'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hu'),
    Locale('id'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Homa VPN'**
  String get appTitle;

  /// No description provided for @slideToConnect.
  ///
  /// In en, this message translates to:
  /// **'Slide to connect'**
  String get slideToConnect;

  /// No description provided for @slideToDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Slide to disconnect'**
  String get slideToDisconnect;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @stateConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get stateConnected;

  /// No description provided for @stateConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get stateConnecting;

  /// No description provided for @stateWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get stateWaiting;

  /// No description provided for @waitingForAccount.
  ///
  /// In en, this message translates to:
  /// **'Add a Firefox Account on the Accounts page to connect.'**
  String get waitingForAccount;

  /// Home hint while the proxy waits: accounts exist, but every one is turned off.
  ///
  /// In en, this message translates to:
  /// **'All accounts are turned off. Turn one on in Accounts.'**
  String get waitingForEnabledAccount;

  /// No description provided for @stateError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get stateError;

  /// No description provided for @stateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get stateUnknown;

  /// No description provided for @restartProxy.
  ///
  /// In en, this message translates to:
  /// **'Restart the proxy'**
  String get restartProxy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied {value}'**
  String copied(String value);

  /// No description provided for @activeAccount.
  ///
  /// In en, this message translates to:
  /// **'Active account'**
  String get activeAccount;

  /// No description provided for @noActiveAccount.
  ///
  /// In en, this message translates to:
  /// **'No active account'**
  String get noActiveAccount;

  /// No description provided for @quotaNotRead.
  ///
  /// In en, this message translates to:
  /// **'Quota not read yet'**
  String get quotaNotRead;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @usedOf.
  ///
  /// In en, this message translates to:
  /// **'{used} of {limit} used'**
  String usedOf(String used, String limit);

  /// No description provided for @resets.
  ///
  /// In en, this message translates to:
  /// **'resets {date}'**
  String resets(String date);

  /// No description provided for @switchAt.
  ///
  /// In en, this message translates to:
  /// **'Switches account at {percent}%'**
  String switchAt(int percent);

  /// No description provided for @publicIp.
  ///
  /// In en, this message translates to:
  /// **'Public IP'**
  String get publicIp;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get testConnection;

  /// No description provided for @testing.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get testing;

  /// No description provided for @testFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get testFailed;

  /// No description provided for @milliseconds.
  ///
  /// In en, this message translates to:
  /// **'{value} ms'**
  String milliseconds(int value);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{n} min ago'**
  String minutesAgo(int n);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{n} h ago'**
  String hoursAgo(int n);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @atTime.
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String atTime(String time);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{d}d {h}h'**
  String durationDays(int d, int h);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{h}h {m}m'**
  String durationHours(int h, int m);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{m}m {s}s'**
  String durationMinutes(int m, int s);

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{s}s'**
  String durationSeconds(int s);

  /// No description provided for @accountsGuide.
  ///
  /// In en, this message translates to:
  /// **'Each Firefox Account has {size} of data a month. You can add several: when one runs out, the app moves to the next one by itself.'**
  String accountsGuide(String size);

  /// No description provided for @accountsOrderNote.
  ///
  /// In en, this message translates to:
  /// **'In the order of this list: each up to {percent}%, the last one until its data runs out.'**
  String accountsOrderNote(int percent);

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// No description provided for @lowQuotaNotice.
  ///
  /// In en, this message translates to:
  /// **'This account is running out of data. Add another account to get {size} more.'**
  String lowQuotaNotice(String size);

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get noAccounts;

  /// No description provided for @noAccountsHint.
  ///
  /// In en, this message translates to:
  /// **'Add a Firefox Account to connect.'**
  String get noAccountsHint;

  /// No description provided for @delayTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t measure the servers\' delay. Check your internet.'**
  String get delayTestFailed;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a Firefox Account?'**
  String get createAccountTitle;

  /// No description provided for @createAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Create one for free at accounts.firefox.com, then come back and press Add account.'**
  String get createAccountHint;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusNeedsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Needs sign-in'**
  String get statusNeedsSignIn;

  /// No description provided for @statusReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get statusReserved;

  /// No description provided for @statusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get statusUnavailable;

  /// No description provided for @statusUnavailableUntil.
  ///
  /// In en, this message translates to:
  /// **'Unavailable until {date}'**
  String statusUnavailableUntil(String date);

  /// No description provided for @statusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// No description provided for @statusEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get statusEnabled;

  /// No description provided for @useNow.
  ///
  /// In en, this message translates to:
  /// **'Use now'**
  String get useNow;

  /// No description provided for @signInAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get signInAgain;

  /// An account set aside at the switch threshold (percent, the setting) while the next account is used.
  ///
  /// In en, this message translates to:
  /// **'Used {percent}% of its data, so the next account took over.'**
  String reasonQuotaThreshold(int percent);

  /// No description provided for @reasonQuotaExhausted.
  ///
  /// In en, this message translates to:
  /// **'This month\'s data is used up; it is used again after the monthly reset.'**
  String get reasonQuotaExhausted;

  /// No description provided for @reasonSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in again to use this account.'**
  String get reasonSignInRequired;

  /// No description provided for @reasonSignInConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mozilla asks to confirm the sign-in: press Sign in again (only the code is needed).'**
  String get reasonSignInConfirm;

  /// No description provided for @reasonSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Automatic sign-in failed ({detail}). Sign in again.'**
  String reasonSignInFailed(String detail);

  /// No description provided for @reasonSignInWait.
  ///
  /// In en, this message translates to:
  /// **'The last automatic sign-in stopped working soon after; the next try is at {time}.'**
  String reasonSignInWait(String time);

  /// No description provided for @reasonSignInRetry.
  ///
  /// In en, this message translates to:
  /// **'Automatic sign-in could not finish ({detail}); trying again at {time}.'**
  String reasonSignInRetry(String detail, String time);

  /// No description provided for @reasonNotEntitled.
  ///
  /// In en, this message translates to:
  /// **'Mozilla refused this account; trying again later.'**
  String get reasonNotEntitled;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @refreshQuota.
  ///
  /// In en, this message translates to:
  /// **'Refresh quota'**
  String get refreshQuota;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove account?'**
  String get removeTitle;

  /// No description provided for @removeBody.
  ///
  /// In en, this message translates to:
  /// **'{name} and its saved sign-in will be removed from this computer. You can add it again later.'**
  String removeBody(String name);

  /// No description provided for @unlimitedQuota.
  ///
  /// In en, this message translates to:
  /// **'Unlimited quota'**
  String get unlimitedQuota;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInIntro.
  ///
  /// In en, this message translates to:
  /// **'Sign in with a Firefox Account.'**
  String get signInIntro;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the account email'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter the password'**
  String get passwordEmpty;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noBrowserTitle.
  ///
  /// In en, this message translates to:
  /// **'No browser on this device'**
  String get noBrowserTitle;

  /// No description provided for @noBrowserText.
  ///
  /// In en, this message translates to:
  /// **'Open this address on your phone or computer:'**
  String get noBrowserText;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get signingIn;

  /// No description provided for @accountReady.
  ///
  /// In en, this message translates to:
  /// **'Account ready'**
  String get accountReady;

  /// No description provided for @accountReadyHint.
  ///
  /// In en, this message translates to:
  /// **'It joined the end of the account order.'**
  String get accountReadyHint;

  /// No description provided for @captchaLabel.
  ///
  /// In en, this message translates to:
  /// **'Characters in the image'**
  String get captchaLabel;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get codeLabel;

  /// No description provided for @captchaBroken.
  ///
  /// In en, this message translates to:
  /// **'The CAPTCHA image could not be shown.'**
  String get captchaBroken;

  /// No description provided for @stepEmailCode.
  ///
  /// In en, this message translates to:
  /// **'Mozilla emailed a code to {email}. Enter it here.'**
  String stepEmailCode(String email);

  /// No description provided for @stepTotp.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your authenticator app.'**
  String get stepTotp;

  /// No description provided for @stepUnblockCode.
  ///
  /// In en, this message translates to:
  /// **'Mozilla finds this sign-in unusual and emailed an unblock code to {email}. Enter it here.'**
  String stepUnblockCode(String email);

  /// No description provided for @stepCaptcha.
  ///
  /// In en, this message translates to:
  /// **'Type the characters in the image.'**
  String get stepCaptcha;

  /// No description provided for @stepEmailLink.
  ///
  /// In en, this message translates to:
  /// **'Open the confirmation link Mozilla emailed to {email}. This continues by itself.'**
  String stepEmailLink(String email);

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'The account was not added.'**
  String get signInFailed;

  /// No description provided for @signInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in cancelled.'**
  String get signInCancelled;

  /// No description provided for @signInNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No Firefox Account exists for this email.'**
  String get signInNoAccount;

  /// No description provided for @signInNoAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Check the email, or create a free Firefox Account with it on Mozilla\'s site, confirm it from your inbox, then add it here.'**
  String get signInNoAccountHint;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create a Firefox Account'**
  String get createAccountButton;

  /// No description provided for @signInWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get signInWrongPassword;

  /// Sign-in failed: the Firefox Account was made with Google or Apple sign-in and has no password (FxA errno 210).
  ///
  /// In en, this message translates to:
  /// **'This account has no password: it was made with Google or Apple sign-in. Set a password, then sign in here with it.'**
  String get signInNoPassword;

  /// Button in place of Try again after signInNoPassword; opens Mozilla's page to set a password.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get setPasswordButton;

  /// No description provided for @signInTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a while and try again.'**
  String get signInTooManyAttempts;

  /// No description provided for @signInUnblockRejected.
  ///
  /// In en, this message translates to:
  /// **'The unblock code was not accepted. Use the code from the latest email from Mozilla.'**
  String get signInUnblockRejected;

  /// No description provided for @signInWrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong or expired code. Use the code from the latest email from Mozilla; an older code stops working when a new one is sent.'**
  String get signInWrongCode;

  /// No description provided for @signInWrongTotp.
  ///
  /// In en, this message translates to:
  /// **'Wrong code. Enter the code the authenticator app shows now.'**
  String get signInWrongTotp;

  /// No description provided for @signInTooManyCodes.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Start the sign-in again.'**
  String get signInTooManyCodes;

  /// No description provided for @signInTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The sign-in took too long. Start it again.'**
  String get signInTimedOut;

  /// No description provided for @signInNetwork.
  ///
  /// In en, this message translates to:
  /// **'Mozilla could not be reached. Check your internet and try again.'**
  String get signInNetwork;

  /// No description provided for @coreConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to the core…'**
  String get coreConnecting;

  /// No description provided for @coreLost.
  ///
  /// In en, this message translates to:
  /// **'Lost the connection to the core. Retrying…'**
  String get coreLost;

  /// No description provided for @cantReachCore.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the core'**
  String get cantReachCore;

  /// No description provided for @startingCore.
  ///
  /// In en, this message translates to:
  /// **'Starting the core…'**
  String get startingCore;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errNoCore.
  ///
  /// In en, this message translates to:
  /// **'The core program was not found next to the app ({path}).'**
  String errNoCore(String path);

  /// No description provided for @errCoreExited.
  ///
  /// In en, this message translates to:
  /// **'The core stopped: {detail}'**
  String errCoreExited(String detail);

  /// No description provided for @errNotAnswering.
  ///
  /// In en, this message translates to:
  /// **'The core is not answering.'**
  String get errNotAnswering;

  /// No description provided for @errRefused.
  ///
  /// In en, this message translates to:
  /// **'The core refused the app; it may belong to another copy.'**
  String get errRefused;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sectionGeneral;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @closeBehavior.
  ///
  /// In en, this message translates to:
  /// **'When closing the window'**
  String get closeBehavior;

  /// No description provided for @closeAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask every time'**
  String get closeAsk;

  /// No description provided for @closeTray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to the tray'**
  String get closeTray;

  /// No description provided for @closeQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit the app'**
  String get closeQuit;

  /// No description provided for @sectionConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get sectionConnection;

  /// No description provided for @localProxy.
  ///
  /// In en, this message translates to:
  /// **'Local proxy'**
  String get localProxy;

  /// No description provided for @systemProxy.
  ///
  /// In en, this message translates to:
  /// **'System proxy'**
  String get systemProxy;

  /// No description provided for @sectionRouting.
  ///
  /// In en, this message translates to:
  /// **'Routing'**
  String get sectionRouting;

  /// No description provided for @routingDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct connection for local sites'**
  String get routingDirect;

  /// No description provided for @routingDirectHint.
  ///
  /// In en, this message translates to:
  /// **'Sites and IPs of the chosen country skip the VPN: they open faster and save quota.'**
  String get routingDirectHint;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get region;

  /// No description provided for @regionIr.
  ///
  /// In en, this message translates to:
  /// **'Iran'**
  String get regionIr;

  /// No description provided for @regionCn.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get regionCn;

  /// No description provided for @regionRu.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get regionRu;

  /// No description provided for @regionAf.
  ///
  /// In en, this message translates to:
  /// **'Afghanistan'**
  String get regionAf;

  /// No description provided for @regionTr.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get regionTr;

  /// No description provided for @regionId.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get regionId;

  /// No description provided for @regionBr.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get regionBr;

  /// No description provided for @regionNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get regionNone;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @dataFolder.
  ///
  /// In en, this message translates to:
  /// **'Data folder'**
  String get dataFolder;

  /// No description provided for @openFolder.
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get openFolder;

  /// No description provided for @unofficialNote.
  ///
  /// In en, this message translates to:
  /// **'Unofficial client. Not affiliated with Mozilla.'**
  String get unofficialNote;

  /// No description provided for @closeTitle.
  ///
  /// In en, this message translates to:
  /// **'Close the window?'**
  String get closeTitle;

  /// No description provided for @closeBody.
  ///
  /// In en, this message translates to:
  /// **'In the tray, the VPN stays connected. Quitting turns it off.'**
  String get closeBody;

  /// No description provided for @rememberChoice.
  ///
  /// In en, this message translates to:
  /// **'Remember my choice'**
  String get rememberChoice;

  /// No description provided for @minimizeToTray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to tray'**
  String get minimizeToTray;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// No description provided for @trayOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get trayOpen;

  /// No description provided for @trayQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get trayQuit;

  /// No description provided for @trayProxyOnly.
  ///
  /// In en, this message translates to:
  /// **'Proxy service only'**
  String get trayProxyOnly;

  /// No description provided for @traySetSystemProxy.
  ///
  /// In en, this message translates to:
  /// **'Set system proxy'**
  String get traySetSystemProxy;

  /// No description provided for @errPortInUse.
  ///
  /// In en, this message translates to:
  /// **'Port {port} is used by another program, so the app cannot reach its core.'**
  String errPortInUse(String port);

  /// No description provided for @proxyPortInUse.
  ///
  /// In en, this message translates to:
  /// **'Port {port} is used by another program, so the proxy cannot start.'**
  String proxyPortInUse(String port);

  /// No description provided for @changePort.
  ///
  /// In en, this message translates to:
  /// **'Change port'**
  String get changePort;

  /// No description provided for @portDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a port'**
  String get portDialogTitle;

  /// No description provided for @portDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Port {port} is taken. A free port is suggested below; you can type another one.'**
  String portDialogBody(String port);

  /// No description provided for @portChangeBody.
  ///
  /// In en, this message translates to:
  /// **'Apps connect to this port. Choose one from 1024 to 65535.'**
  String get portChangeBody;

  /// No description provided for @portLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get portLabel;

  /// No description provided for @portInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a port from 1024 to 65535'**
  String get portInvalid;

  /// No description provided for @portBusy.
  ///
  /// In en, this message translates to:
  /// **'This port is in use too'**
  String get portBusy;

  /// No description provided for @portInUse.
  ///
  /// In en, this message translates to:
  /// **'Another program uses this port'**
  String get portInUse;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @proxyPort.
  ///
  /// In en, this message translates to:
  /// **'Proxy port'**
  String get proxyPort;

  /// No description provided for @appPort.
  ///
  /// In en, this message translates to:
  /// **'App port'**
  String get appPort;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Choose your language and your country. Sites of your country open directly, without the VPN, which is faster and saves quota.'**
  String get welcomeBody;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @routingSuggestTitle.
  ///
  /// In en, this message translates to:
  /// **'Route {country} directly?'**
  String routingSuggestTitle(String country);

  /// No description provided for @routingSuggestBody.
  ///
  /// In en, this message translates to:
  /// **'Sites and IPs of {country} would open directly, without the VPN. You can change this in Routing.'**
  String routingSuggestBody(String country);

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @navServers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get navServers;

  /// No description provided for @navLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get navLogs;

  /// No description provided for @realDelay.
  ///
  /// In en, this message translates to:
  /// **'Real delay'**
  String get realDelay;

  /// No description provided for @statElapsed.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get statElapsed;

  /// No description provided for @statDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get statDown;

  /// No description provided for @statUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get statUp;

  /// No description provided for @noticePort.
  ///
  /// In en, this message translates to:
  /// **'Mozilla\'s proxy does not connect to port {port}. Only ports 80, 443, 8080 and 8443 go through the VPN.'**
  String noticePort(String port);

  /// No description provided for @noticeCommand.
  ///
  /// In en, this message translates to:
  /// **'This type of connection isn\'t supported by the VPN.'**
  String get noticeCommand;

  /// No description provided for @noticeTimes.
  ///
  /// In en, this message translates to:
  /// **'{count} times, last {time}'**
  String noticeTimes(int count, String time);

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @modeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get modeRecommended;

  /// No description provided for @modeFastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get modeFastest;

  /// No description provided for @modeRecommendedHint.
  ///
  /// In en, this message translates to:
  /// **'Mozilla picks the location for you.'**
  String get modeRecommendedHint;

  /// No description provided for @modeFastestHint.
  ///
  /// In en, this message translates to:
  /// **'The location with the lowest delay at each connection.'**
  String get modeFastestHint;

  /// No description provided for @testDelay.
  ///
  /// In en, this message translates to:
  /// **'Test real delay'**
  String get testDelay;

  /// No description provided for @testingDelay.
  ///
  /// In en, this message translates to:
  /// **'Measuring…'**
  String get testingDelay;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get noAnswer;

  /// No description provided for @testedAgo.
  ///
  /// In en, this message translates to:
  /// **'Tested {ago}'**
  String testedAgo(String ago);

  /// No description provided for @delaySummary.
  ///
  /// In en, this message translates to:
  /// **'{answered} of {total} answered'**
  String delaySummary(int answered, int total);

  /// No description provided for @noServers.
  ///
  /// In en, this message translates to:
  /// **'No servers yet. They appear once the core reaches Mozilla.'**
  String get noServers;

  /// No description provided for @levelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get levelAll;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll'**
  String get follow;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @copyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAll;

  /// No description provided for @logsCopied.
  ///
  /// In en, this message translates to:
  /// **'Logs copied'**
  String get logsCopied;

  /// No description provided for @noLogs.
  ///
  /// In en, this message translates to:
  /// **'No log lines yet.'**
  String get noLogs;

  /// No description provided for @sectionAccounts.
  ///
  /// In en, this message translates to:
  /// **'Account switching'**
  String get sectionAccounts;

  /// No description provided for @switchThreshold.
  ///
  /// In en, this message translates to:
  /// **'Switch account at'**
  String get switchThreshold;

  /// No description provided for @switchThresholdHint.
  ///
  /// In en, this message translates to:
  /// **'The next account takes over when this share of the quota is used.'**
  String get switchThresholdHint;

  /// No description provided for @signInMethod.
  ///
  /// In en, this message translates to:
  /// **'Sign-in method'**
  String get signInMethod;

  /// No description provided for @signInMethodBrowser.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the browser'**
  String get signInMethodBrowser;

  /// No description provided for @signInMethodApi.
  ///
  /// In en, this message translates to:
  /// **'Sign in directly'**
  String get signInMethodApi;

  /// No description provided for @browserSignInBroken.
  ///
  /// In en, this message translates to:
  /// **'The sign-in page could not be opened.'**
  String get browserSignInBroken;

  /// No description provided for @browserSignInBlocked.
  ///
  /// In en, this message translates to:
  /// **'Mozilla did not complete the final step of adding the account (HTTP 406).'**
  String get browserSignInBlocked;

  /// No description provided for @browserSignInFallback.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email and password'**
  String get browserSignInFallback;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Save a backup'**
  String get backupExport;

  /// No description provided for @backupImport.
  ///
  /// In en, this message translates to:
  /// **'Import a backup'**
  String get backupImport;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved: {name}'**
  String backupSaved(String name);

  /// No description provided for @backupImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Add these accounts?'**
  String get backupImportTitle;

  /// No description provided for @backupAccountExists.
  ///
  /// In en, this message translates to:
  /// **'Already added; it signs in from the file'**
  String get backupAccountExists;

  /// No description provided for @backupImportAction.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get backupImportAction;

  /// No description provided for @backupImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account added} other{{count} accounts added}}'**
  String backupImported(int count);

  /// No description provided for @sectionDns.
  ///
  /// In en, this message translates to:
  /// **'DNS'**
  String get sectionDns;

  /// No description provided for @dnsPreset.
  ///
  /// In en, this message translates to:
  /// **'DNS servers'**
  String get dnsPreset;

  /// No description provided for @dnsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get dnsSystem;

  /// No description provided for @dnsAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto (Cloudflare, Google, Quad9)'**
  String get dnsAuto;

  /// No description provided for @dnsCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get dnsCustom;

  /// No description provided for @dnsCustomHint.
  ///
  /// In en, this message translates to:
  /// **'One per line: https://…/dns-query, tls://…, or an IP address.'**
  String get dnsCustomHint;

  /// No description provided for @dnsFallback.
  ///
  /// In en, this message translates to:
  /// **'Fall back to the system DNS'**
  String get dnsFallback;

  /// No description provided for @testDns.
  ///
  /// In en, this message translates to:
  /// **'Test DNS'**
  String get testDns;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get transport;

  /// No description provided for @transportH3.
  ///
  /// In en, this message translates to:
  /// **'HTTP/3 (QUIC)'**
  String get transportH3;

  /// No description provided for @ipVersion.
  ///
  /// In en, this message translates to:
  /// **'IP version'**
  String get ipVersion;

  /// No description provided for @ipVersionAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto (IPv4, then IPv6)'**
  String get ipVersionAuto;

  /// No description provided for @ipVersionDual.
  ///
  /// In en, this message translates to:
  /// **'Both at once (dual-stack)'**
  String get ipVersionDual;

  /// No description provided for @ipVersionV6First.
  ///
  /// In en, this message translates to:
  /// **'IPv6 first, then IPv4'**
  String get ipVersionV6First;

  /// No description provided for @ipVersionV4.
  ///
  /// In en, this message translates to:
  /// **'IPv4 only'**
  String get ipVersionV4;

  /// No description provided for @ipVersionV6.
  ///
  /// In en, this message translates to:
  /// **'IPv6 only'**
  String get ipVersionV6;

  /// No description provided for @tunMtu.
  ///
  /// In en, this message translates to:
  /// **'MTU'**
  String get tunMtu;

  /// No description provided for @tunMtuHint.
  ///
  /// In en, this message translates to:
  /// **'The VPN interface\'s packet size, 1280 to 9000. Empty: automatic.'**
  String get tunMtuHint;

  /// No description provided for @tunMtuInvalid.
  ///
  /// In en, this message translates to:
  /// **'A number from 1280 to 9000, or empty'**
  String get tunMtuInvalid;

  /// No description provided for @transportH2.
  ///
  /// In en, this message translates to:
  /// **'HTTP/2 (TCP)'**
  String get transportH2;

  /// No description provided for @transportH1.
  ///
  /// In en, this message translates to:
  /// **'HTTP/1.1 (TLS)'**
  String get transportH1;

  /// No description provided for @directRules.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get directRules;

  /// No description provided for @directRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Sites and addresses in this list open without the VPN, straight through your own internet. The chosen country\'s rules are already here: add, change, or remove lines. Choosing another country replaces them with its own.'**
  String get directRulesHint;

  /// No description provided for @restoreRegionRules.
  ///
  /// In en, this message translates to:
  /// **'Restore the region\'s rules'**
  String get restoreRegionRules;

  /// No description provided for @blockRules.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get blockRules;

  /// No description provided for @blockRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Sites and addresses in this list do not open at all, neither directly nor through the VPN: for ads, or sites you never want reached.'**
  String get blockRulesHint;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @ruleSyntaxTitle.
  ///
  /// In en, this message translates to:
  /// **'How to write a rule'**
  String get ruleSyntaxTitle;

  /// No description provided for @resolveDomains.
  ///
  /// In en, this message translates to:
  /// **'Look up names for IP rules'**
  String get resolveDomains;

  /// No description provided for @routingLists.
  ///
  /// In en, this message translates to:
  /// **'Geo files'**
  String get routingLists;

  /// No description provided for @listSource.
  ///
  /// In en, this message translates to:
  /// **'List source'**
  String get listSource;

  /// No description provided for @listSourceCustom.
  ///
  /// In en, this message translates to:
  /// **'Set by hand'**
  String get listSourceCustom;

  /// No description provided for @listsUpdatedAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {ago}'**
  String listsUpdatedAgo(String ago);

  /// No description provided for @updateLists.
  ///
  /// In en, this message translates to:
  /// **'Update the geo files'**
  String get updateLists;

  /// No description provided for @listsUpdated.
  ///
  /// In en, this message translates to:
  /// **'The geo files were updated.'**
  String get listsUpdated;

  /// No description provided for @testDestination.
  ///
  /// In en, this message translates to:
  /// **'Test a destination'**
  String get testDestination;

  /// No description provided for @destinationHint.
  ///
  /// In en, this message translates to:
  /// **'A name, an address, or a URL'**
  String get destinationHint;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @routeDirect.
  ///
  /// In en, this message translates to:
  /// **'Goes directly'**
  String get routeDirect;

  /// No description provided for @routeProxy.
  ///
  /// In en, this message translates to:
  /// **'Goes through the VPN'**
  String get routeProxy;

  /// No description provided for @routeBlock.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get routeBlock;

  /// No description provided for @ruleMatched.
  ///
  /// In en, this message translates to:
  /// **'Rule: {rule}'**
  String ruleMatched(String rule);

  /// No description provided for @portRefusedNote.
  ///
  /// In en, this message translates to:
  /// **'Mozilla\'s proxy does not connect to this port.'**
  String get portRefusedNote;

  /// No description provided for @sectionAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get sectionAdvanced;

  /// No description provided for @tlsFragment.
  ///
  /// In en, this message translates to:
  /// **'TLS fragmentation'**
  String get tlsFragment;

  /// No description provided for @tlsFragmentOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get tlsFragmentOff;

  /// No description provided for @tlsFragmentFirstByte.
  ///
  /// In en, this message translates to:
  /// **'First byte'**
  String get tlsFragmentFirstByte;

  /// No description provided for @tlsFragmentSni.
  ///
  /// In en, this message translates to:
  /// **'Server name (SNI)'**
  String get tlsFragmentSni;

  /// No description provided for @tlsFragmentFirstByteHint.
  ///
  /// In en, this message translates to:
  /// **'Splits the TLS header at the first byte (0x16)'**
  String get tlsFragmentFirstByteHint;

  /// No description provided for @tlsFragmentSniHint.
  ///
  /// In en, this message translates to:
  /// **'Splits the server name (SNI) across TCP packets'**
  String get tlsFragmentSniHint;

  /// No description provided for @tlsFragmentRecord.
  ///
  /// In en, this message translates to:
  /// **'TLS record'**
  String get tlsFragmentRecord;

  /// No description provided for @tlsFragmentRecordHint.
  ///
  /// In en, this message translates to:
  /// **'Splits the server name (SNI) across two TLS records'**
  String get tlsFragmentRecordHint;

  /// No description provided for @tlsFragmentOffHint.
  ///
  /// In en, this message translates to:
  /// **'Normal TLS connection'**
  String get tlsFragmentOffHint;

  /// No description provided for @sectionBypass.
  ///
  /// In en, this message translates to:
  /// **'If Mozilla is blocked'**
  String get sectionBypass;

  /// No description provided for @sharedRelay.
  ///
  /// In en, this message translates to:
  /// **'Shared relay'**
  String get sharedRelay;

  /// No description provided for @sharedRelayHint.
  ///
  /// In en, this message translates to:
  /// **'Use the app\'s shared relays if Mozilla blocks your region. An enabled personal relay takes priority.'**
  String get sharedRelayHint;

  /// No description provided for @personalRelay.
  ///
  /// In en, this message translates to:
  /// **'Personal relay'**
  String get personalRelay;

  /// No description provided for @apiRelay.
  ///
  /// In en, this message translates to:
  /// **'Relay server'**
  String get apiRelay;

  /// No description provided for @apiRelayUse.
  ///
  /// In en, this message translates to:
  /// **'Use the relay server'**
  String get apiRelayUse;

  /// No description provided for @apiRelayHint.
  ///
  /// In en, this message translates to:
  /// **'Your own Cloudflare Worker, or relay.php on your own host.\nUsed only when Mozilla doesn\'t answer directly: the sign-in, accounts, and server list go through it, not the VPN traffic.'**
  String get apiRelayHint;

  /// No description provided for @upstreamProxy.
  ///
  /// In en, this message translates to:
  /// **'Upstream proxy'**
  String get upstreamProxy;

  /// No description provided for @upstreamProxyOn.
  ///
  /// In en, this message translates to:
  /// **'Upstream proxy is on'**
  String get upstreamProxyOn;

  /// No description provided for @upstreamProxyAddress.
  ///
  /// In en, this message translates to:
  /// **'SOCKS5 proxy address'**
  String get upstreamProxyAddress;

  /// No description provided for @upstreamProxyPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get upstreamProxyPort;

  /// No description provided for @upstreamProxyHint.
  ///
  /// In en, this message translates to:
  /// **'The connection to Mozilla goes through this proxy, for networks that block or slow Mozilla.\nIf the proxy runs on this device, leave it out of the VPN.'**
  String get upstreamProxyHint;

  /// No description provided for @upstreamProxyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the proxy\'s address, such as 127.0.0.1.'**
  String get upstreamProxyInvalid;

  /// No description provided for @upstreamProxyInvalidPort.
  ///
  /// In en, this message translates to:
  /// **'Enter a port from 1 to 65535.'**
  String get upstreamProxyInvalidPort;

  /// No description provided for @upstreamProxyOwn.
  ///
  /// In en, this message translates to:
  /// **'That\'s this app\'s own proxy. Enter another one.'**
  String get upstreamProxyOwn;

  /// No description provided for @apiRelayInvalid.
  ///
  /// In en, this message translates to:
  /// **'Must be an https:// address.'**
  String get apiRelayInvalid;

  /// No description provided for @listenAddress.
  ///
  /// In en, this message translates to:
  /// **'Listen on'**
  String get listenAddress;

  /// No description provided for @listenLocal.
  ///
  /// In en, this message translates to:
  /// **'127.0.0.1 · this device only'**
  String get listenLocal;

  /// No description provided for @listenAll.
  ///
  /// In en, this message translates to:
  /// **'0.0.0.0 · all networks (LAN)'**
  String get listenAll;

  /// No description provided for @proxyUsername.
  ///
  /// In en, this message translates to:
  /// **'Proxy username'**
  String get proxyUsername;

  /// No description provided for @proxyPassword.
  ///
  /// In en, this message translates to:
  /// **'Proxy password'**
  String get proxyPassword;

  /// No description provided for @proxyLoginHint.
  ///
  /// In en, this message translates to:
  /// **'Apps must sign in with these. Leave both empty for no login.'**
  String get proxyLoginHint;

  /// No description provided for @loginBothOrNone.
  ///
  /// In en, this message translates to:
  /// **'Fill in both, or leave both empty.'**
  String get loginBothOrNone;

  /// No description provided for @proxyLogin.
  ///
  /// In en, this message translates to:
  /// **'Proxy login'**
  String get proxyLogin;

  /// No description provided for @idleSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep when idle after'**
  String get idleSleep;

  /// No description provided for @sleepNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get sleepNever;

  /// No description provided for @sleepMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String sleepMinutes(int count);

  /// No description provided for @sleepHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get sleepHour;

  /// No description provided for @showPublicIp.
  ///
  /// In en, this message translates to:
  /// **'Show the public IP'**
  String get showPublicIp;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Vibrate when the connection changes'**
  String get hapticFeedback;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen awake while connected'**
  String get keepScreenOn;

  /// No description provided for @showTraffic.
  ///
  /// In en, this message translates to:
  /// **'Show live traffic on the home page'**
  String get showTraffic;

  /// No description provided for @speedInNotification.
  ///
  /// In en, this message translates to:
  /// **'Show speed in the notification'**
  String get speedInNotification;

  /// No description provided for @liveTraffic.
  ///
  /// In en, this message translates to:
  /// **'Live traffic'**
  String get liveTraffic;

  /// No description provided for @totalTraffic.
  ///
  /// In en, this message translates to:
  /// **'Total traffic'**
  String get totalTraffic;

  /// No description provided for @verboseLogs.
  ///
  /// In en, this message translates to:
  /// **'Detailed logs'**
  String get verboseLogs;

  /// No description provided for @webDashboard.
  ///
  /// In en, this message translates to:
  /// **'Web dashboard'**
  String get webDashboard;

  /// No description provided for @webDashboardOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get webDashboardOpen;

  /// No description provided for @webDashboardHint.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings and more tools'**
  String get webDashboardHint;

  /// No description provided for @numberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from {min} to {max}'**
  String numberInvalid(int min, int max);

  /// No description provided for @notifySwitchedTitle.
  ///
  /// In en, this message translates to:
  /// **'Switched account'**
  String get notifySwitchedTitle;

  /// No description provided for @notifySwitchedBody.
  ///
  /// In en, this message translates to:
  /// **'Now using {name}.'**
  String notifySwitchedBody(String name);

  /// No description provided for @notifySignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign-in needed'**
  String get notifySignInTitle;

  /// No description provided for @notifySignInBody.
  ///
  /// In en, this message translates to:
  /// **'An account must be signed in again on the Accounts page.'**
  String get notifySignInBody;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersionLabel;

  /// No description provided for @coreVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Core version'**
  String get coreVersionLabel;

  /// No description provided for @checkUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkUpdates;

  /// No description provided for @checkingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checkingUpdates;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version.'**
  String get upToDate;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available.'**
  String updateAvailable(String version);

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please update to version {version}. This update is required.'**
  String updateRequired(String version);

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates: {error}'**
  String updateCheckFailed(String error);

  /// The update check could not reach GitHub (no connection, a timeout, or a refused TLS handshake).
  ///
  /// In en, this message translates to:
  /// **'Could not reach GitHub. Check your internet connection and try again.'**
  String get updateCheckNoNetwork;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateNow;

  /// No description provided for @updateDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading version {version}…'**
  String updateDownloading(String version);

  /// No description provided for @updateReady.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is ready to install.'**
  String updateReady(String version);

  /// No description provided for @updateInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing version {version}. The app will close and open again.'**
  String updateInstalling(String version);

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update to version {version}.'**
  String updateFailed(String version);

  /// No description provided for @updateDone.
  ///
  /// In en, this message translates to:
  /// **'Updated to version {version}.'**
  String updateDone(String version);

  /// No description provided for @updateRolledBack.
  ///
  /// In en, this message translates to:
  /// **'The update to version {version} didn\'t finish, so the app went back to the previous version.'**
  String updateRolledBack(String version);

  /// No description provided for @repoNotSet.
  ///
  /// In en, this message translates to:
  /// **'The GitHub repository is not set yet.'**
  String get repoNotSet;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get sourceCode;

  /// No description provided for @tapToConnect.
  ///
  /// In en, this message translates to:
  /// **'Click to connect'**
  String get tapToConnect;

  /// No description provided for @tapToDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Click to disconnect'**
  String get tapToDisconnect;

  /// No description provided for @startOnBoot.
  ///
  /// In en, this message translates to:
  /// **'Start on boot'**
  String get startOnBoot;

  /// No description provided for @connectOnStartup.
  ///
  /// In en, this message translates to:
  /// **'Connect on startup'**
  String get connectOnStartup;

  /// No description provided for @proxyServiceActive.
  ///
  /// In en, this message translates to:
  /// **'Proxy service active'**
  String get proxyServiceActive;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @groupApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get groupApp;

  /// No description provided for @groupNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get groupNetwork;

  /// No description provided for @stateOff.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get stateOff;

  /// No description provided for @tapToConnectPhone.
  ///
  /// In en, this message translates to:
  /// **'Tap to connect'**
  String get tapToConnectPhone;

  /// No description provided for @tapToDisconnectPhone.
  ///
  /// In en, this message translates to:
  /// **'Tap to disconnect'**
  String get tapToDisconnectPhone;

  /// Under the switch on a TV, worked with a remote: its middle button is OK.
  ///
  /// In en, this message translates to:
  /// **'Press OK to connect'**
  String get tapToConnectTv;

  /// No description provided for @tapToDisconnectTv.
  ///
  /// In en, this message translates to:
  /// **'Press OK to disconnect'**
  String get tapToDisconnectTv;

  /// No description provided for @lanAddress.
  ///
  /// In en, this message translates to:
  /// **'LAN {address}'**
  String lanAddress(String address);

  /// No description provided for @recommendedLocation.
  ///
  /// In en, this message translates to:
  /// **'Recommended location'**
  String get recommendedLocation;

  /// No description provided for @dataLeftOf.
  ///
  /// In en, this message translates to:
  /// **'of {limit}'**
  String dataLeftOf(String limit);

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get homeLocation;

  /// No description provided for @connectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to'**
  String get connectedTo;

  /// No description provided for @vpnNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'The VPN needs your permission. Tap the button again and allow it.'**
  String get vpnNotAllowed;

  /// No description provided for @dataUsedTitle.
  ///
  /// In en, this message translates to:
  /// **'Data used'**
  String get dataUsedTitle;

  /// No description provided for @bypassApps.
  ///
  /// In en, this message translates to:
  /// **'Per-app proxy'**
  String get bypassApps;

  /// No description provided for @connectRetrying.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Check your internet.'**
  String get connectRetrying;

  /// No description provided for @failUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach Mozilla\'s servers. Try another internet connection.'**
  String get failUnreachable;

  /// No description provided for @failUpstreamProxy.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach Mozilla through your upstream proxy. Check that it\'s running.'**
  String get failUpstreamProxy;

  /// No description provided for @failInsideVpn.
  ///
  /// In en, this message translates to:
  /// **'This internet already goes through a VPN. Turn it off.'**
  String get failInsideVpn;

  /// No description provided for @failRefused.
  ///
  /// In en, this message translates to:
  /// **'Mozilla\'s server refused the connection. Try again in a few minutes.'**
  String get failRefused;

  /// No description provided for @failLocationRefused.
  ///
  /// In en, this message translates to:
  /// **'This country isn\'t open to your account. Choose another country.'**
  String get failLocationRefused;

  /// No description provided for @useRecommendedLocation.
  ///
  /// In en, this message translates to:
  /// **'Use the recommended location'**
  String get useRecommendedLocation;

  /// No description provided for @exitMismatch.
  ///
  /// In en, this message translates to:
  /// **'You chose {chosen}, but your IP is in {exit}.'**
  String exitMismatch(String exit, String chosen);

  /// No description provided for @failSignIn.
  ///
  /// In en, this message translates to:
  /// **'This account\'s sign-in has expired. Sign in again on the Accounts page.'**
  String get failSignIn;

  /// No description provided for @failQuota.
  ///
  /// In en, this message translates to:
  /// **'This month\'s data is used up. Add another account.'**
  String get failQuota;

  /// No description provided for @failNotEntitled.
  ///
  /// In en, this message translates to:
  /// **'Mozilla doesn\'t let this account use the VPN. Add another account.'**
  String get failNotEntitled;

  /// No description provided for @failRegion.
  ///
  /// In en, this message translates to:
  /// **'Mozilla doesn\'t offer its service in your country.'**
  String get failRegion;

  /// No description provided for @failServer.
  ///
  /// In en, this message translates to:
  /// **'Mozilla\'s service has a temporary problem. The app tries again by itself.'**
  String get failServer;

  /// No description provided for @failNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account is ready. Open the Accounts page.'**
  String get failNoAccount;

  /// No description provided for @failTestSite.
  ///
  /// In en, this message translates to:
  /// **'Connected to the server, but sites don\'t open. Try another country.'**
  String get failTestSite;

  /// No description provided for @failOther.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Try again.'**
  String get failOther;

  /// No description provided for @failNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet. Check Wi-Fi or mobile data.'**
  String get failNoInternet;

  /// The home page while the core waits for a network before connecting (state code waiting_for_network).
  ///
  /// In en, this message translates to:
  /// **'Waiting for an internet connection…'**
  String get waitingForNetwork;

  /// The home page after the proxy failed to start on its port for a reason other than another program holding it, such as a port Windows reserves (state code start_failed), with a Change port button.
  ///
  /// In en, this message translates to:
  /// **'The proxy couldn\'t start on port {port}. Choose another port.'**
  String proxyStartFailed(String port);

  /// No description provided for @connectionSettings.
  ///
  /// In en, this message translates to:
  /// **'Connection settings'**
  String get connectionSettings;

  /// No description provided for @appModeExclude.
  ///
  /// In en, this message translates to:
  /// **'Bypass selected apps'**
  String get appModeExclude;

  /// No description provided for @appModeInclude.
  ///
  /// In en, this message translates to:
  /// **'Proxy selected apps'**
  String get appModeInclude;

  /// No description provided for @appModeExcludeHint.
  ///
  /// In en, this message translates to:
  /// **'Selected apps connect directly, not through the VPN: for example banking apps that refuse foreign addresses.'**
  String get appModeExcludeHint;

  /// No description provided for @appModeIncludeHint.
  ///
  /// In en, this message translates to:
  /// **'Only the selected apps go through the VPN; the others connect directly.'**
  String get appModeIncludeHint;

  /// No description provided for @fromRegionList.
  ///
  /// In en, this message translates to:
  /// **'Suggested: on the {region} list'**
  String fromRegionList(String region);

  /// No description provided for @modeProxy.
  ///
  /// In en, this message translates to:
  /// **'Proxy'**
  String get modeProxy;

  /// No description provided for @connectionMode.
  ///
  /// In en, this message translates to:
  /// **'Connection mode'**
  String get connectionMode;

  /// No description provided for @modeProxyHint.
  ///
  /// In en, this message translates to:
  /// **'Only apps set up to use the proxy go through it.'**
  String get modeProxyHint;

  /// No description provided for @modeSystemProxyHint.
  ///
  /// In en, this message translates to:
  /// **'Windows and most apps go through the proxy.'**
  String get modeSystemProxyHint;

  /// No description provided for @modeSystemProxyHintOther.
  ///
  /// In en, this message translates to:
  /// **'Browsers and most apps go through the proxy.'**
  String get modeSystemProxyHintOther;

  /// No description provided for @suggestedApps.
  ///
  /// In en, this message translates to:
  /// **'Suggested apps'**
  String get suggestedApps;

  /// No description provided for @showSystemApps.
  ///
  /// In en, this message translates to:
  /// **'Show system apps'**
  String get showSystemApps;

  /// No description provided for @suggestedAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{The suggested apps are already selected} =1{1 suggested app selected} other{{count} suggested apps selected}}'**
  String suggestedAdded(int count);

  /// No description provided for @autoSection.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get autoSection;

  /// No description provided for @locationsSection.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locationsSection;

  /// No description provided for @dnsSummaryOk.
  ///
  /// In en, this message translates to:
  /// **'Encrypted DNS works'**
  String get dnsSummaryOk;

  /// No description provided for @dnsSummaryFailed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 name did not resolve} other{{count} names did not resolve}}'**
  String dnsSummaryFailed(int count);

  /// No description provided for @dnsVia.
  ///
  /// In en, this message translates to:
  /// **'via {server}'**
  String dnsVia(String server);

  /// No description provided for @dnsSummaryDiffers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your network\'s DNS answered 1 name with a filtering address. This app does not use it for them.} other{Your network\'s DNS answered {count} names with a filtering address. This app does not use it for them.}}'**
  String dnsSummaryDiffers(int count);

  /// No description provided for @dnsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer:'**
  String get dnsAnswer;

  /// No description provided for @dnsNetworkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Network DNS:'**
  String get dnsNetworkAnswer;

  /// No description provided for @dnsFiltered.
  ///
  /// In en, this message translates to:
  /// **'filtered'**
  String get dnsFiltered;

  /// No description provided for @rulesSyntaxTitle.
  ///
  /// In en, this message translates to:
  /// **'One rule per line'**
  String get rulesSyntaxTitle;

  /// No description provided for @ruleDomain.
  ///
  /// In en, this message translates to:
  /// **'The site and its subdomains'**
  String get ruleDomain;

  /// No description provided for @ruleFull.
  ///
  /// In en, this message translates to:
  /// **'Exactly this name'**
  String get ruleFull;

  /// No description provided for @ruleKeyword.
  ///
  /// In en, this message translates to:
  /// **'Names that contain the word'**
  String get ruleKeyword;

  /// No description provided for @ruleGeosite.
  ///
  /// In en, this message translates to:
  /// **'Sites of a tag in the geo files'**
  String get ruleGeosite;

  /// No description provided for @ruleGeoip.
  ///
  /// In en, this message translates to:
  /// **'Addresses of a country in the geo files'**
  String get ruleGeoip;

  /// No description provided for @ruleIp.
  ///
  /// In en, this message translates to:
  /// **'An address or a network'**
  String get ruleIp;

  /// Phone connection mode: every app on the phone goes through the VPN.
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get modeVpn;

  /// Phone connection mode: no VPN; only apps set up to use the local proxy. Also shown before the proxy address on the home page.
  ///
  /// In en, this message translates to:
  /// **'Proxy only'**
  String get modeProxyOnly;

  /// Shown at once, in red, when the phone has neither Wi-Fi nor mobile data.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Turn on Wi-Fi or mobile data.'**
  String get noNetwork;

  /// No description provided for @blockAds.
  ///
  /// In en, this message translates to:
  /// **'Block ads'**
  String get blockAds;

  /// The home page when another program (another VPN or proxy) replaced the system proxy the app set (status system_proxy_taken).
  ///
  /// In en, this message translates to:
  /// **'Another program set the system proxy to {address}, so traffic doesn\'t go through the VPN.'**
  String systemProxyTakenBy(String address);

  /// No description provided for @systemProxyTakenOff.
  ///
  /// In en, this message translates to:
  /// **'Another program turned the system proxy off, so traffic doesn\'t go through the VPN.'**
  String get systemProxyTakenOff;

  /// No description provided for @setSystemProxyAgain.
  ///
  /// In en, this message translates to:
  /// **'Set it again'**
  String get setSystemProxyAgain;

  /// The connection mode that sends every app through the VPN with a TUN adapter (system_proxy.mode tun).
  ///
  /// In en, this message translates to:
  /// **'TUN'**
  String get modeTun;

  /// Under the TUN mode on the home page; os is osWindows, osLinux, or osMacos.
  ///
  /// In en, this message translates to:
  /// **'All {os} traffic goes through the VPN.'**
  String modeTunHint(String os);

  /// No description provided for @osWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get osWindows;

  /// No description provided for @osLinux.
  ///
  /// In en, this message translates to:
  /// **'Linux'**
  String get osLinux;

  /// No description provided for @osMacos.
  ///
  /// In en, this message translates to:
  /// **'macOS'**
  String get osMacos;

  /// No description provided for @tunInstallWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for permission to install the TUN service…'**
  String get tunInstallWaiting;

  /// No description provided for @tunInstallCancelled.
  ///
  /// In en, this message translates to:
  /// **'TUN mode needs administrator permission once. It wasn\'t given, so the mode didn\'t change.'**
  String get tunInstallCancelled;

  /// No description provided for @tunInstallFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t install the TUN service: {error}'**
  String tunInstallFailed(String error);

  /// No description provided for @tunStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting TUN mode…'**
  String get tunStarting;

  /// No description provided for @tunFailed.
  ///
  /// In en, this message translates to:
  /// **'TUN mode couldn\'t start. Trying again…'**
  String get tunFailed;

  /// No description provided for @tunLost.
  ///
  /// In en, this message translates to:
  /// **'TUN mode stopped unexpectedly. Trying again…'**
  String get tunLost;

  /// No description provided for @tunNotRunning.
  ///
  /// In en, this message translates to:
  /// **'The TUN service isn\'t running. Trying again…'**
  String get tunNotRunning;

  /// No description provided for @tunMissing.
  ///
  /// In en, this message translates to:
  /// **'The TUN service isn\'t installed.'**
  String get tunMissing;

  /// No description provided for @tunOutdated.
  ///
  /// In en, this message translates to:
  /// **'The TUN service is older than this app. Install it again to use TUN mode.'**
  String get tunOutdated;

  /// No description provided for @tunAppOutdated.
  ///
  /// In en, this message translates to:
  /// **'The TUN service is newer than this app. Update the app to use TUN mode.'**
  String get tunAppOutdated;

  /// No description provided for @tunBusy.
  ///
  /// In en, this message translates to:
  /// **'Another copy of Homa VPN is using TUN mode.'**
  String get tunBusy;

  /// No description provided for @tunNoDriver.
  ///
  /// In en, this message translates to:
  /// **'The system\'s TUN driver isn\'t available. Restart the computer and try again.'**
  String get tunNoDriver;

  /// No description provided for @tunInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get tunInstall;

  /// No description provided for @tunInstallAgain.
  ///
  /// In en, this message translates to:
  /// **'Install again'**
  String get tunInstallAgain;

  /// No description provided for @trayTunMode.
  ///
  /// In en, this message translates to:
  /// **'TUN mode (all apps)'**
  String get trayTunMode;

  /// No description provided for @removeTunService.
  ///
  /// In en, this message translates to:
  /// **'Remove the TUN service'**
  String get removeTunService;

  /// No description provided for @removeTunServiceHint.
  ///
  /// In en, this message translates to:
  /// **'Removes the system service that TUN mode uses. Choosing TUN again installs it again.'**
  String get removeTunServiceHint;

  /// No description provided for @tunServiceRemoved.
  ///
  /// In en, this message translates to:
  /// **'The TUN service was removed.'**
  String get tunServiceRemoved;

  /// macOS: the reason its administrator password prompt shows when the app installs the TUN mode's service.
  ///
  /// In en, this message translates to:
  /// **'Homa VPN wants to install the service for TUN mode.'**
  String get tunInstallPrompt;

  /// macOS: the reason its administrator password prompt shows when the app removes the TUN mode's service while the service does not run.
  ///
  /// In en, this message translates to:
  /// **'Homa VPN wants to remove the service for TUN mode.'**
  String get tunRemovePrompt;

  /// No description provided for @tunRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove the TUN service: {error}'**
  String tunRemoveFailed(String error);

  /// The computer's settings section for TUN mode, after Routing.
  ///
  /// In en, this message translates to:
  /// **'TUN settings'**
  String get sectionTun;

  /// No description provided for @tunPrograms.
  ///
  /// In en, this message translates to:
  /// **'Programs that bypass the VPN'**
  String get tunPrograms;

  /// No description provided for @tunProgramsHint.
  ///
  /// In en, this message translates to:
  /// **'They connect directly, not through Mozilla. Only for programs that work without a VPN.'**
  String get tunProgramsHint;

  /// No description provided for @tunProgramsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No programs yet.'**
  String get tunProgramsEmpty;

  /// No description provided for @addProgram.
  ///
  /// In en, this message translates to:
  /// **'Add program'**
  String get addProgram;

  /// The kind of file the program picker shows (on Windows, .exe files).
  ///
  /// In en, this message translates to:
  /// **'Programs'**
  String get programFiles;

  /// No description provided for @tunProgramAll.
  ///
  /// In en, this message translates to:
  /// **'All traffic'**
  String get tunProgramAll;

  /// No description provided for @tunProgramAllHint.
  ///
  /// In en, this message translates to:
  /// **'The whole program connects directly.'**
  String get tunProgramAllHint;

  /// No description provided for @tunProgramUdp.
  ///
  /// In en, this message translates to:
  /// **'UDP only'**
  String get tunProgramUdp;

  /// No description provided for @tunProgramUdpHint.
  ///
  /// In en, this message translates to:
  /// **'Only its UDP connects directly; the rest goes through the VPN.'**
  String get tunProgramUdpHint;

  /// No description provided for @udpNoticeSetting.
  ///
  /// In en, this message translates to:
  /// **'Notice when UDP is blocked'**
  String get udpNoticeSetting;

  /// A card on the home page in TUN mode when a program's UDP was refused.
  ///
  /// In en, this message translates to:
  /// **'{program}\'s UDP traffic can\'t go through the VPN.'**
  String udpNoticeBody(String program);

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// TUN settings, Add program: the first of three ways (then a file, then a name).
  ///
  /// In en, this message translates to:
  /// **'From running programs'**
  String get addRunningProgram;

  /// No description provided for @addProgramFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file…'**
  String get addProgramFile;

  /// No description provided for @addProgramName.
  ///
  /// In en, this message translates to:
  /// **'Type a name…'**
  String get addProgramName;

  /// No description provided for @programNameHint.
  ///
  /// In en, this message translates to:
  /// **'A program\'s file name, such as steam.exe; * stands for any text (steam* is every Steam program).'**
  String get programNameHint;

  /// No description provided for @runningProgramsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No other programs are running.'**
  String get runningProgramsEmpty;

  /// No description provided for @tabLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get tabLog;

  /// Logs page: the tab that lists the proxy's connections (GET /api/connections).
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get tabConnections;

  /// No description provided for @connectionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No connections yet.'**
  String get connectionsEmpty;

  /// No description provided for @connectionsOpen.
  ///
  /// In en, this message translates to:
  /// **'{count} open'**
  String connectionsOpen(int count);

  /// No description provided for @connTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get connTime;

  /// No description provided for @connRoute.
  ///
  /// In en, this message translates to:
  /// **'Rule'**
  String get connRoute;

  /// No description provided for @connDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get connDestination;

  /// How the client came: SOCKS5, HTTP, or TUN.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get connInbound;

  /// TCP or UDP.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get connProtocol;

  /// No description provided for @connColumns.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get connColumns;

  /// No description provided for @connTraffic.
  ///
  /// In en, this message translates to:
  /// **'Traffic'**
  String get connTraffic;

  /// No description provided for @connDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get connDuration;

  /// No description provided for @connRouteVpn.
  ///
  /// In en, this message translates to:
  /// **'Proxy'**
  String get connRouteVpn;

  /// No description provided for @connRouteDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get connRouteDirect;

  /// No description provided for @connRouteBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get connRouteBlocked;

  /// Mozilla's proxy connects to ports 80, 443, 8080, and 8443 only.
  ///
  /// In en, this message translates to:
  /// **'Port refused'**
  String get connRoutePort;

  /// No description provided for @connRouteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get connRouteFailed;

  /// No description provided for @testRelay.
  ///
  /// In en, this message translates to:
  /// **'Test relay health'**
  String get testRelay;

  /// No description provided for @relayTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Relay health test'**
  String get relayTestTitle;

  /// No description provided for @relayTestHint.
  ///
  /// In en, this message translates to:
  /// **'Checks only the relay. No Mozilla request or account information is sent.'**
  String get relayTestHint;

  /// No description provided for @relayTestPassed.
  ///
  /// In en, this message translates to:
  /// **'Relay is ready'**
  String get relayTestPassed;

  /// No description provided for @relayTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Relay health could not be confirmed'**
  String get relayTestFailed;

  /// No description provided for @relayTestCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy report'**
  String get relayTestCopy;

  /// No description provided for @relayTestInterrupted.
  ///
  /// In en, this message translates to:
  /// **'The test ended before a complete result was received.'**
  String get relayTestInterrupted;

  /// No description provided for @searchLocations.
  ///
  /// In en, this message translates to:
  /// **'Search locations'**
  String get searchLocations;

  /// No description provided for @locationCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 location} other{{count} locations}}'**
  String locationCount(int count);

  /// No description provided for @autoInstallApk.
  ///
  /// In en, this message translates to:
  /// **'Automatic updates'**
  String get autoInstallApk;

  /// No description provided for @autoInstallApkHint.
  ///
  /// In en, this message translates to:
  /// **'New versions download by themselves; the installer asks before it installs.'**
  String get autoInstallApkHint;

  /// No description provided for @installNow.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get installNow;

  /// No description provided for @updateAllowInstall.
  ///
  /// In en, this message translates to:
  /// **'To install the update, allow this app to install apps.'**
  String get updateAllowInstall;

  /// No description provided for @allowInstall.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allowInstall;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No location matches the search.'**
  String get noResults;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// No description provided for @accentMono.
  ///
  /// In en, this message translates to:
  /// **'Monochrome (default)'**
  String get accentMono;

  /// No description provided for @accentCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get accentCustom;

  /// No description provided for @accentEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get accentEmber;

  /// No description provided for @accentGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get accentGold;

  /// No description provided for @accentEmerald.
  ///
  /// In en, this message translates to:
  /// **'Emerald'**
  String get accentEmerald;

  /// No description provided for @accentSapphire.
  ///
  /// In en, this message translates to:
  /// **'Sapphire'**
  String get accentSapphire;

  /// No description provided for @accentAmethyst.
  ///
  /// In en, this message translates to:
  /// **'Amethyst'**
  String get accentAmethyst;

  /// No description provided for @accentRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get accentRose;

  /// No description provided for @autoReconnect.
  ///
  /// In en, this message translates to:
  /// **'Auto-reconnect'**
  String get autoReconnect;

  /// No description provided for @autoReconnectHint.
  ///
  /// In en, this message translates to:
  /// **'Puts the connection back up by itself when it drops.'**
  String get autoReconnectHint;

  /// No description provided for @androidOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'On the phone only.'**
  String get androidOnlyHint;

  /// No description provided for @idleDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect when idle'**
  String get idleDisconnect;

  /// No description provided for @idleDisconnectHint.
  ///
  /// In en, this message translates to:
  /// **'Ends the session when no traffic moves for a while.'**
  String get idleDisconnectHint;

  /// No description provided for @idleTimeout.
  ///
  /// In en, this message translates to:
  /// **'Idle wait'**
  String get idleTimeout;

  /// No description provided for @minutes5.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get minutes5;

  /// No description provided for @minutes10.
  ///
  /// In en, this message translates to:
  /// **'10 minutes'**
  String get minutes10;

  /// No description provided for @minutes15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get minutes15;

  /// No description provided for @minutes30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get minutes30;

  /// No description provided for @minutes60.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get minutes60;

  /// No description provided for @dataLimit.
  ///
  /// In en, this message translates to:
  /// **'Session data limit'**
  String get dataLimit;

  /// No description provided for @dataLimitHint.
  ///
  /// In en, this message translates to:
  /// **'Ends the session when its traffic reaches the limit.'**
  String get dataLimitHint;

  /// No description provided for @dataLimitAmount.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get dataLimitAmount;

  /// No description provided for @mb256.
  ///
  /// In en, this message translates to:
  /// **'256 MB'**
  String get mb256;

  /// No description provided for @mb512.
  ///
  /// In en, this message translates to:
  /// **'512 MB'**
  String get mb512;

  /// No description provided for @mb1024.
  ///
  /// In en, this message translates to:
  /// **'1 GB'**
  String get mb1024;

  /// No description provided for @mb2048.
  ///
  /// In en, this message translates to:
  /// **'2 GB'**
  String get mb2048;

  /// No description provided for @mb5120.
  ///
  /// In en, this message translates to:
  /// **'5 GB'**
  String get mb5120;

  /// No description provided for @mb10240.
  ///
  /// In en, this message translates to:
  /// **'10 GB'**
  String get mb10240;

  /// No description provided for @autoStoppedIdle.
  ///
  /// In en, this message translates to:
  /// **'No traffic moved for {minutes} minutes, so the connection was disconnected.'**
  String autoStoppedIdle(int minutes);

  /// No description provided for @autoStoppedData.
  ///
  /// In en, this message translates to:
  /// **'The session reached its {mb} MB data limit, so it was disconnected.'**
  String autoStoppedData(int mb);

  /// No description provided for @protection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get protection;

  /// No description provided for @killSwitch.
  ///
  /// In en, this message translates to:
  /// **'Kill switch'**
  String get killSwitch;

  /// No description provided for @killSwitchHint.
  ///
  /// In en, this message translates to:
  /// **'If the VPN dies, traffic is held — never leaked — until it reconnects.'**
  String get killSwitchHint;

  /// No description provided for @alwaysOnVpn.
  ///
  /// In en, this message translates to:
  /// **'Always-on VPN'**
  String get alwaysOnVpn;

  /// No description provided for @alwaysOnVpnHint.
  ///
  /// In en, this message translates to:
  /// **'Android\'s own guard: no connection without the VPN.'**
  String get alwaysOnVpnHint;

  /// No description provided for @floatingIsland.
  ///
  /// In en, this message translates to:
  /// **'Floating island'**
  String get floatingIsland;

  /// No description provided for @floatingIslandHint.
  ///
  /// In en, this message translates to:
  /// **'Carries the connection over the other apps while the app is away.'**
  String get floatingIslandHint;

  /// No description provided for @whatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in {version}'**
  String whatsNewTitle(String version);

  /// No description provided for @whatsNewContinue.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get whatsNewContinue;

  /// No description provided for @whatsNewMenu.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNewMenu;

  /// No description provided for @whatsNewView.
  ///
  /// In en, this message translates to:
  /// **'View again'**
  String get whatsNewView;

  /// No description provided for @updateServers.
  ///
  /// In en, this message translates to:
  /// **'Update servers'**
  String get updateServers;

  /// No description provided for @updatingServers.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get updatingServers;

  /// No description provided for @serversUpdated.
  ///
  /// In en, this message translates to:
  /// **'{count} locations from Mozilla\'s official list'**
  String serversUpdated(int count);

  /// No description provided for @serversUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'The server list could not be updated; the previous list is kept.'**
  String get serversUpdateFailed;

  /// No description provided for @smartPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Fastest right now'**
  String get smartPickTitle;

  /// No description provided for @smartPickUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get smartPickUse;

  /// No description provided for @connectAtBoot.
  ///
  /// In en, this message translates to:
  /// **'Connect after the phone starts'**
  String get connectAtBoot;

  /// No description provided for @connectAtBootHint.
  ///
  /// In en, this message translates to:
  /// **'Connects by itself at boot, when the VPN permission is already granted.'**
  String get connectAtBootHint;

  /// No description provided for @gamingProfile.
  ///
  /// In en, this message translates to:
  /// **'Gaming profile'**
  String get gamingProfile;

  /// No description provided for @gamingProfileHint.
  ///
  /// In en, this message translates to:
  /// **'Shows the connection\'s live delay and quality; pairs with the fastest measured server.'**
  String get gamingProfileHint;

  /// No description provided for @diagnosticsRun.
  ///
  /// In en, this message translates to:
  /// **'Run diagnostics'**
  String get diagnosticsRun;

  /// No description provided for @diagnosticsHint.
  ///
  /// In en, this message translates to:
  /// **'Connection, DNS, and tunnel, checked in one tap'**
  String get diagnosticsHint;

  /// No description provided for @diagnosticsTunnel.
  ///
  /// In en, this message translates to:
  /// **'Tunnel'**
  String get diagnosticsTunnel;

  /// No description provided for @diagnosticsTunnelUp.
  ///
  /// In en, this message translates to:
  /// **'Up and carrying traffic'**
  String get diagnosticsTunnelUp;

  /// No description provided for @diagnosticsTunnelDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get diagnosticsTunnelDown;

  /// No description provided for @diagnosticsExit.
  ///
  /// In en, this message translates to:
  /// **'Exit country'**
  String get diagnosticsExit;

  /// No description provided for @diagnosticsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Exit differs from the choice'**
  String get diagnosticsMismatch;

  /// No description provided for @diagnosticsConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection test'**
  String get diagnosticsConnection;

  /// No description provided for @diagnosticsPassed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get diagnosticsPassed;

  /// No description provided for @diagnosticsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get diagnosticsFailed;

  /// No description provided for @diagnosticsDnsFiltered.
  ///
  /// In en, this message translates to:
  /// **'Blocked or filtered answer'**
  String get diagnosticsDnsFiltered;

  /// No description provided for @diagnosticsDnsOk.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get diagnosticsDnsOk;

  /// No description provided for @diagnosticsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Nothing here is stored; the results stay in this window and the core\'s own log.'**
  String get diagnosticsPrivacy;

  /// No description provided for @diagnosticsAgain.
  ///
  /// In en, this message translates to:
  /// **'Run again'**
  String get diagnosticsAgain;

  /// No description provided for @whatsNewAdded.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get whatsNewAdded;

  /// No description provided for @whatsNewImproved.
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get whatsNewImproved;

  /// No description provided for @whatsNewFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get whatsNewFixed;

  /// No description provided for @wnWheelImproved.
  ///
  /// In en, this message translates to:
  /// **'The country wheel is redrawn: the chosen flag stands bigger in a glass frame with a fine glow and a soft halo of light behind it, the other flags sit smaller with depth, and the name below arrives with a slide.'**
  String get wnWheelImproved;

  /// No description provided for @wnLiveImproved.
  ///
  /// In en, this message translates to:
  /// **'While connected, the notification asks Android 16 to promote it as a Live Update, the way the reference implementation does; the duration keeps counting, the speeds keep running.'**
  String get wnLiveImproved;

  /// No description provided for @wnL10nFixed.
  ///
  /// In en, this message translates to:
  /// **'This page now speaks the app\'s language — every one of its fifteen languages, not only English.'**
  String get wnL10nFixed;

  /// No description provided for @wnMarkFixed.
  ///
  /// In en, this message translates to:
  /// **'Mozilla\'s mark sits clean on its tile, rounded like the flags.'**
  String get wnMarkFixed;

  /// No description provided for @designTitle.
  ///
  /// In en, this message translates to:
  /// **'Home design'**
  String get designTitle;

  /// No description provided for @designHint.
  ///
  /// In en, this message translates to:
  /// **'How the home page is laid out'**
  String get designHint;

  /// No description provided for @designWheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get designWheel;

  /// No description provided for @designWheelDesc.
  ///
  /// In en, this message translates to:
  /// **'The flags in their glass wheel, the switch under them'**
  String get designWheelDesc;

  /// No description provided for @designBento.
  ///
  /// In en, this message translates to:
  /// **'Bento'**
  String get designBento;

  /// No description provided for @designBentoDesc.
  ///
  /// In en, this message translates to:
  /// **'The lunch box\'s own design: the flags on their board of tiles, the connect tile, the numbers and the place as tiles of one warm box'**
  String get designBentoDesc;

  /// No description provided for @designPixel.
  ///
  /// In en, this message translates to:
  /// **'Material You'**
  String get designPixel;

  /// No description provided for @designPixelDesc.
  ///
  /// In en, this message translates to:
  /// **'Material You: the tonal surfaces, the big filled cards, the pill-indicator bar and the large titles — the Android\'s own voice'**
  String get designPixelDesc;

  /// No description provided for @notifFlag.
  ///
  /// In en, this message translates to:
  /// **'Country flag in the notification'**
  String get notifFlag;

  /// No description provided for @notifFlagHint.
  ///
  /// In en, this message translates to:
  /// **'The notification\'s own flag beside the country\'s name'**
  String get notifFlagHint;

  /// No description provided for @wnDesignAdded.
  ///
  /// In en, this message translates to:
  /// **'A Home design setting: the wheel, the tiles, or the compact card'**
  String get wnDesignAdded;

  /// No description provided for @wnMapAdded.
  ///
  /// In en, this message translates to:
  /// **'A real vector world map behind the home page, with the chosen country lit'**
  String get wnMapAdded;

  /// No description provided for @wnWheelAdded.
  ///
  /// In en, this message translates to:
  /// **'The flag wheel redrawn: deeper glass, smoother motion, richer depth'**
  String get wnWheelAdded;

  /// No description provided for @wnFlagNotifAdded.
  ///
  /// In en, this message translates to:
  /// **'The notification can show the country\'s SVG flag, and be told not to'**
  String get wnFlagNotifAdded;

  /// No description provided for @wnColorRemoved.
  ///
  /// In en, this message translates to:
  /// **'The Custom color page was removed; the accent list keeps its hex'**
  String get wnColorRemoved;

  /// No description provided for @whatsNewRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get whatsNewRemoved;

  /// No description provided for @wnCrashFixed.
  ///
  /// In en, this message translates to:
  /// **'The app no longer stops by itself on Android 16 phones: the notification asked the system for a piece the phone does not have yet.'**
  String get wnCrashFixed;

  /// No description provided for @wnFlagArtFixed.
  ///
  /// In en, this message translates to:
  /// **'The app no longer kicks itself out when opened: the notification\'s flag art answered with a value the system\'s messenger refuses.'**
  String get wnFlagArtFixed;

  /// No description provided for @statSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get statSession;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @wnTotalsAdded.
  ///
  /// In en, this message translates to:
  /// **'The home shows what the session moved in total, and a tap copies the public IP.'**
  String get wnTotalsAdded;

  /// No description provided for @wnPolishImproved.
  ///
  /// In en, this message translates to:
  /// **'The flags\' wheel and the servers page sit tidier; texts are compact, and the Android tunnel carries the traffic at a higher speed.'**
  String get wnPolishImproved;

  /// No description provided for @valueSmart.
  ///
  /// In en, this message translates to:
  /// **'Smart'**
  String get valueSmart;

  /// No description provided for @wnSmartAdded.
  ///
  /// In en, this message translates to:
  /// **'Smart connection: MTU, protocol, and IP version follow the network, chosen by real answers for speed.'**
  String get wnSmartAdded;

  /// No description provided for @wnToastAdded.
  ///
  /// In en, this message translates to:
  /// **'Confirmations arrive as a soft iOS-style note, with a mark that draws itself.'**
  String get wnToastAdded;

  /// No description provided for @wnFlagsImproved.
  ///
  /// In en, this message translates to:
  /// **'The flag wheel sits clean: no flag is cut at the screen\'s edge, flags show whole, and the choice lands with a soft spring.'**
  String get wnFlagsImproved;

  /// No description provided for @wnMapImproved.
  ///
  /// In en, this message translates to:
  /// **'The world map is drawn larger and clearer: no squeezed continents, smooth coastlines, and a glowing halo at the anchor.'**
  String get wnMapImproved;

  /// No description provided for @dnsManual.
  ///
  /// In en, this message translates to:
  /// **'Manual DNS'**
  String get dnsManual;

  /// No description provided for @dnsManualHint.
  ///
  /// In en, this message translates to:
  /// **'One address per line: a plain IP, https:// (DNS over HTTPS), or tls://host (DNS over TLS). The first answer wins.'**
  String get dnsManualHint;

  /// No description provided for @dnsManualInvalid.
  ///
  /// In en, this message translates to:
  /// **'One line is not an address the core can use: a plain IP, https://…, or tls://host.'**
  String get dnsManualInvalid;

  /// No description provided for @killSwitchGuarded.
  ///
  /// In en, this message translates to:
  /// **'Guarded: nothing leaves the phone while the tunnel is down.'**
  String get killSwitchGuarded;

  /// No description provided for @accountsUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get accountsUsageTitle;

  /// No description provided for @accountsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'accounts'**
  String get accountsCountLabel;

  /// No description provided for @accountsUsageAverage.
  ///
  /// In en, this message translates to:
  /// **'average of the accounts\' spent share'**
  String get accountsUsageAverage;

  /// No description provided for @wnDesignsAdded.
  ///
  /// In en, this message translates to:
  /// **'App designs: the whole app can wear Soft Neumorphism or Aurora Glass — every page, every card — picked in Settings → General.'**
  String get wnDesignsAdded;

  /// No description provided for @wnWheelFixed.
  ///
  /// In en, this message translates to:
  /// **'The wheel\'s half-flag is gone: the shelf under the chosen flag is a pool of light, not a second flag, and no flag is cut at the screen\'s edge.'**
  String get wnWheelFixed;

  /// No description provided for @wnMapReal.
  ///
  /// In en, this message translates to:
  /// **'The world map is redrawn from official country borders — every coast, island, and enclave at true fidelity, in true proportion.'**
  String get wnMapReal;

  /// No description provided for @wnGlobeAdded.
  ///
  /// In en, this message translates to:
  /// **'The world is a globe now: the silver ball turns to face the chosen country, a glowing pin and a floating card mark it, and the connection\'s roads reach for the hubs.'**
  String get wnGlobeAdded;

  /// No description provided for @wnWheelGlowImproved.
  ///
  /// In en, this message translates to:
  /// **'The chosen flag stands bigger in a glass frame with its own blue halo, the neighbors sit clearly smaller, and the markers under the wheel show where you are.'**
  String get wnWheelGlowImproved;

  /// No description provided for @wnDesignsRemoved.
  ///
  /// In en, this message translates to:
  /// **'The App Design picker has left: the app wears its own monochrome look again — your accent and your theme stay as they were.'**
  String get wnDesignsRemoved;

  /// No description provided for @wnDnsAdded.
  ///
  /// In en, this message translates to:
  /// **'Manual DNS: plain IPs, DNS over HTTPS, and DNS over TLS — each line\'s kind shown and checked as you type.'**
  String get wnDnsAdded;

  /// No description provided for @wnSmartImproved.
  ///
  /// In en, this message translates to:
  /// **'The smart connection now shows what the network answered: the transport it picked and the IP family it kept, live.'**
  String get wnSmartImproved;

  /// No description provided for @wnProtectionImproved.
  ///
  /// In en, this message translates to:
  /// **'The kill switch says when its guard stands, and the apps page shows how many apps you chose.'**
  String get wnProtectionImproved;

  /// No description provided for @wnWelcomeImproved.
  ///
  /// In en, this message translates to:
  /// **'The welcome opens with a breathing shield over a drifting aurora, and the accounts page sums the month at a glance.'**
  String get wnWelcomeImproved;

  /// No description provided for @bypassAppsCount.
  ///
  /// In en, this message translates to:
  /// **'Chosen: {n}'**
  String bypassAppsCount(String n);

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @mapStyle.
  ///
  /// In en, this message translates to:
  /// **'Map style'**
  String get mapStyle;

  /// No description provided for @mapStyleHint.
  ///
  /// In en, this message translates to:
  /// **'The home page\'s globe, painted the way you pick. The connection\'s light stays the same.'**
  String get mapStyleHint;

  /// No description provided for @mapSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get mapSilver;

  /// No description provided for @mapMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get mapMidnight;

  /// No description provided for @mapOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get mapOcean;

  /// No description provided for @mapMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get mapMono;

  /// No description provided for @mapAurora.
  ///
  /// In en, this message translates to:
  /// **'Aurora'**
  String get mapAurora;

  /// No description provided for @batterySaver.
  ///
  /// In en, this message translates to:
  /// **'Battery saver'**
  String get batterySaver;

  /// No description provided for @batterySaverHint.
  ///
  /// In en, this message translates to:
  /// **'Puts the map\'s motion to rest while connected — the globe\'s breath, the wheel\'s glow. The connection itself stays exactly as it is.'**
  String get batterySaverHint;

  /// No description provided for @connectOnOpen.
  ///
  /// In en, this message translates to:
  /// **'Connect when the app opens'**
  String get connectOnOpen;

  /// No description provided for @connectOnOpenHint.
  ///
  /// In en, this message translates to:
  /// **'Brings the VPN up as the app opens, with the location you last chose.'**
  String get connectOnOpenHint;

  /// No description provided for @speedTitle.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedTitle;

  /// No description provided for @parallelTunnels.
  ///
  /// In en, this message translates to:
  /// **'Parallel tunnels'**
  String get parallelTunnels;

  /// No description provided for @parallelTunnelsHint.
  ///
  /// In en, this message translates to:
  /// **'Opens several tunnels to Mozilla at once and splits the traffic between them, so one slow tunnel no longer caps the speed. Eight is the heaviest on the battery.'**
  String get parallelTunnelsHint;

  /// No description provided for @tunnels1.
  ///
  /// In en, this message translates to:
  /// **'One — the most stable'**
  String get tunnels1;

  /// No description provided for @tunnels2.
  ///
  /// In en, this message translates to:
  /// **'Two'**
  String get tunnels2;

  /// No description provided for @tunnels4.
  ///
  /// In en, this message translates to:
  /// **'Four — faster on slow networks'**
  String get tunnels4;

  /// No description provided for @tunnels8.
  ///
  /// In en, this message translates to:
  /// **'Eight — the fastest'**
  String get tunnels8;

  /// No description provided for @connectionCap.
  ///
  /// In en, this message translates to:
  /// **'Connection limit'**
  String get connectionCap;

  /// No description provided for @connectionCapHint.
  ///
  /// In en, this message translates to:
  /// **'How many apps may talk through the VPN at once; a smaller cap saves battery and data on a busy phone. No limit is the default.'**
  String get connectionCapHint;

  /// No description provided for @capNone.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get capNone;

  /// No description provided for @verboseLogging.
  ///
  /// In en, this message translates to:
  /// **'Detailed diagnostics'**
  String get verboseLogging;

  /// No description provided for @verboseLoggingHint.
  ///
  /// In en, this message translates to:
  /// **'Writes every step to the log — helpful when reporting a problem, a little heavier on the battery.'**
  String get verboseLoggingHint;

  /// No description provided for @wn38MapStylesAdded.
  ///
  /// In en, this message translates to:
  /// **'Five looks for the map: silver, midnight, ocean, mono, and aurora — the settings\' new Appearance page picks, with a preview of each.'**
  String get wn38MapStylesAdded;

  /// No description provided for @wn38ZoomAdded.
  ///
  /// In en, this message translates to:
  /// **'The map zooms: pinch it, or double-tap to step in and back out.'**
  String get wn38ZoomAdded;

  /// No description provided for @wn38OptionsAdded.
  ///
  /// In en, this message translates to:
  /// **'Practical options: parallel tunnels for more speed, a connection limit, battery saver, connect when the app opens, and detailed diagnostics.'**
  String get wn38OptionsAdded;

  /// No description provided for @wn38SocialAdded.
  ///
  /// In en, this message translates to:
  /// **'Instagram and Telegram now live at the bottom of this page too.'**
  String get wn38SocialAdded;

  /// No description provided for @wn38FlightImproved.
  ///
  /// In en, this message translates to:
  /// **'Choosing a country is a small flight: the camera pulls back, the ball turns, the pin drops with a bounce, and the roads draw themselves out to the hubs.'**
  String get wn38FlightImproved;

  /// No description provided for @wn38EffectsImproved.
  ///
  /// In en, this message translates to:
  /// **'The map reads richer: stars behind the ball, a coordinate grid, the hubs\' own lights, a halo around the limb, and the land\'s shadow.'**
  String get wn38EffectsImproved;

  /// No description provided for @wn38SpeedImproved.
  ///
  /// In en, this message translates to:
  /// **'The speed option is real: parallel tunnels open several connections at once, and the core splits the traffic between them.'**
  String get wn38SpeedImproved;

  /// No description provided for @wn38NameFixed.
  ///
  /// In en, this message translates to:
  /// **'The chosen country\'s name shows once — on the map\'s floating card; the copy under the flags is gone.'**
  String get wn38NameFixed;

  /// No description provided for @mapKind.
  ///
  /// In en, this message translates to:
  /// **'Map type'**
  String get mapKind;

  /// No description provided for @mapKindHint.
  ///
  /// In en, this message translates to:
  /// **'How the home\'s world is carried: the flat map as it always was (the default), its modern finish, the night earth, the terrain earth, the metal ball, or the satellite\'s earth. The borders are the real, official ones in every kind.'**
  String get mapKindHint;

  /// No description provided for @mapKindClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get mapKindClassic;

  /// No description provided for @mapKindGlobe.
  ///
  /// In en, this message translates to:
  /// **'3D globe'**
  String get mapKindGlobe;

  /// No description provided for @mapKindSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapKindSatellite;

  /// No description provided for @mapKindFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat 2D'**
  String get mapKindFlat;

  /// No description provided for @mapKindHud.
  ///
  /// In en, this message translates to:
  /// **'Radar'**
  String get mapKindHud;

  /// No description provided for @mapStyleGlobeHint.
  ///
  /// In en, this message translates to:
  /// **'The colors the 3D globe wears. The satellite carries its own earth, and the flat maps their own ink.'**
  String get mapStyleGlobeHint;

  /// No description provided for @aboutVersions.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersions;

  /// No description provided for @aboutChannels.
  ///
  /// In en, this message translates to:
  /// **'Contact pages'**
  String get aboutChannels;

  /// No description provided for @checkUpdatesHint.
  ///
  /// In en, this message translates to:
  /// **'Look for a newer version; a found one downloads and the installer asks.'**
  String get checkUpdatesHint;

  /// No description provided for @speedTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Speed test'**
  String get speedTestTitle;

  /// No description provided for @speedTestRun.
  ///
  /// In en, this message translates to:
  /// **'Measure'**
  String get speedTestRun;

  /// No description provided for @speedTestFailed.
  ///
  /// In en, this message translates to:
  /// **'The measurement did not finish.'**
  String get speedTestFailed;

  /// No description provided for @speedTestThrough.
  ///
  /// In en, this message translates to:
  /// **'Measured through the tunnel.'**
  String get speedTestThrough;

  /// No description provided for @speedTestDirect.
  ///
  /// In en, this message translates to:
  /// **'Measured directly (the proxy is off).'**
  String get speedTestDirect;

  /// No description provided for @speedTestHint.
  ///
  /// In en, this message translates to:
  /// **'A download and an upload through the tunnel tell you what it really carries. The graph on the home page opens this too.'**
  String get speedTestHint;

  /// No description provided for @speedGraphHint.
  ///
  /// In en, this message translates to:
  /// **'The tunnel’s last minute · tap to measure'**
  String get speedGraphHint;

  /// No description provided for @favoritePinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned. Long-press again to unpin.'**
  String get favoritePinned;

  /// No description provided for @favoriteUnpinned.
  ///
  /// In en, this message translates to:
  /// **'Unpinned.'**
  String get favoriteUnpinned;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share report'**
  String get shareReport;

  /// No description provided for @shareReportCopied.
  ///
  /// In en, this message translates to:
  /// **'The report is on the clipboard.'**
  String get shareReportCopied;

  /// No description provided for @batteryWizardTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay alive on the battery'**
  String get batteryWizardTitle;

  /// No description provided for @batteryWizardBody.
  ///
  /// In en, this message translates to:
  /// **'Xiaomi, Samsung, Huawei and the like kill VPN apps after the screen locks. Take this app out of battery optimization so the tunnel stays on.'**
  String get batteryWizardBody;

  /// No description provided for @batteryWizardSteps.
  ///
  /// In en, this message translates to:
  /// **'In the maker’s own settings also allow autostart, and set the app to No restrictions (Xiaomi), Remove from Sleeping apps (Samsung), or Launch — Manual (Huawei).'**
  String get batteryWizardSteps;

  /// No description provided for @batteryWizardState.
  ///
  /// In en, this message translates to:
  /// **'Battery optimization can stop the tunnel.'**
  String get batteryWizardState;

  /// No description provided for @batteryWizardPermit.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get batteryWizardPermit;

  /// No description provided for @batteryWizardOk.
  ///
  /// In en, this message translates to:
  /// **'The tunnel is protected from the battery.'**
  String get batteryWizardOk;

  /// No description provided for @batteryWizardOpen.
  ///
  /// In en, this message translates to:
  /// **'Battery settings'**
  String get batteryWizardOpen;

  /// No description provided for @usageTitle.
  ///
  /// In en, this message translates to:
  /// **'App usage'**
  String get usageTitle;

  /// No description provided for @usageRowHint.
  ///
  /// In en, this message translates to:
  /// **'What each app’s traffic was'**
  String get usageRowHint;

  /// No description provided for @usageGrant.
  ///
  /// In en, this message translates to:
  /// **'Open Usage access'**
  String get usageGrant;

  /// No description provided for @usageGrantHint.
  ///
  /// In en, this message translates to:
  /// **'Android keeps per-app data usage behind the Usage access permission. The page the button opens is the system’s own; the app reads only the numbers.'**
  String get usageGrantHint;

  /// No description provided for @usageEmpty.
  ///
  /// In en, this message translates to:
  /// **'No usage recorded in this period.'**
  String get usageEmpty;

  /// No description provided for @usageToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get usageToday;

  /// No description provided for @usageWeek.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get usageWeek;

  /// No description provided for @usageMonth.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get usageMonth;

  /// No description provided for @playProtectTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Play Protect'**
  String get playProtectTitle;

  /// No description provided for @playProtectBody.
  ///
  /// In en, this message translates to:
  /// **'The app installs outside Google Play, so Play Protect may ask to scan it on the first install. Tap \"Scan app\" once — a clean scan is remembered, and the updates after it install quietly.'**
  String get playProtectBody;

  /// No description provided for @smartLocation.
  ///
  /// In en, this message translates to:
  /// **'Fastest location'**
  String get smartLocation;

  /// No description provided for @smartLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Every start rides the server the core\'s own latency test says is fastest.'**
  String get smartLocationHint;

  /// No description provided for @quicPass.
  ///
  /// In en, this message translates to:
  /// **'QUIC pass-through'**
  String get quicPass;

  /// No description provided for @quicPassHint.
  ///
  /// In en, this message translates to:
  /// **'Apps\' QUIC (UDP 443) rides the tunnel: calls and games keep their speed instead of falling back to TCP.'**
  String get quicPassHint;

  /// No description provided for @accountRename.
  ///
  /// In en, this message translates to:
  /// **'Rename account'**
  String get accountRename;

  /// No description provided for @accountRenameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountRenameLabel;

  /// No description provided for @accountProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile picture'**
  String get accountProfile;

  /// No description provided for @avatarReset.
  ///
  /// In en, this message translates to:
  /// **'Back to the plain mark'**
  String get avatarReset;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'App password'**
  String get accountSecurity;

  /// No description provided for @appPasswordOn.
  ///
  /// In en, this message translates to:
  /// **'The app opens behind a password.'**
  String get appPasswordOn;

  /// No description provided for @appPasswordOff.
  ///
  /// In en, this message translates to:
  /// **'No password: anyone who opens the app gets in.'**
  String get appPasswordOff;

  /// No description provided for @appPasswordSet.
  ///
  /// In en, this message translates to:
  /// **'Set password'**
  String get appPasswordSet;

  /// No description provided for @appPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get appPasswordChange;

  /// No description provided for @appPasswordRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get appPasswordRemove;

  /// No description provided for @appPasswordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get appPasswordCurrent;

  /// No description provided for @appPasswordNew.
  ///
  /// In en, this message translates to:
  /// **'New password (4+ characters)'**
  String get appPasswordNew;

  /// No description provided for @appPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Repeat the new password'**
  String get appPasswordConfirm;

  /// No description provided for @appPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'At least 4 characters.'**
  String get appPasswordShort;

  /// No description provided for @appPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two words are not the same.'**
  String get appPasswordMismatch;

  /// No description provided for @appPasswordWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get appPasswordWrong;

  /// No description provided for @appPasswordSetDone.
  ///
  /// In en, this message translates to:
  /// **'The password stands — the app asks for it from the next start.'**
  String get appPasswordSetDone;

  /// No description provided for @appPasswordRemoved.
  ///
  /// In en, this message translates to:
  /// **'The password is gone; the app opens freely.'**
  String get appPasswordRemoved;

  /// No description provided for @appPasswordUnlock.
  ///
  /// In en, this message translates to:
  /// **'The app is locked'**
  String get appPasswordUnlock;

  /// No description provided for @appPasswordUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the app password to continue.'**
  String get appPasswordUnlockHint;

  /// No description provided for @wn39MapKinds.
  ///
  /// In en, this message translates to:
  /// **'The map is a choice of kinds again: the flat map as it always was (the default), the 3D globe, the satellite\'s earth, and a modern flat 2D.'**
  String get wn39MapKinds;

  /// No description provided for @wn39EyeIp.
  ///
  /// In en, this message translates to:
  /// **'The location card carries an eye: tap it to see the address the traffic leaves from, and copy it.'**
  String get wn39EyeIp;

  /// No description provided for @wn39Profile.
  ///
  /// In en, this message translates to:
  /// **'Accounts carry their own name and profile picture, and the app can open behind a password.'**
  String get wn39Profile;

  /// No description provided for @wn39Smart.
  ///
  /// In en, this message translates to:
  /// **'The smart connection grew: the fastest location by real latency, and QUIC pass-through for calls and games.'**
  String get wn39Smart;

  /// No description provided for @wn39Flight.
  ///
  /// In en, this message translates to:
  /// **'A change of country flies smoother — the camera rides the great circle — and the flag wheel\'s markers sit closer to the flags.'**
  String get wn39Flight;

  /// No description provided for @wn39ToastEverywhere.
  ///
  /// In en, this message translates to:
  /// **'The dynamic note is everywhere now: every saved, copied, and failed notice wears the same animated glass pill.'**
  String get wn39ToastEverywhere;

  /// No description provided for @wn39Updates.
  ///
  /// In en, this message translates to:
  /// **'Updates keep the storage clean: the installer replaces the old version, and no package is left behind.'**
  String get wn39Updates;

  /// No description provided for @mapKindNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get mapKindNight;

  /// No description provided for @mapKindTerrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get mapKindTerrain;

  /// No description provided for @wn40MapKindsNew.
  ///
  /// In en, this message translates to:
  /// **'Two new map finishes: the night earth and the terrain earth.'**
  String get wn40MapKindsNew;

  /// No description provided for @wn40Flight.
  ///
  /// In en, this message translates to:
  /// **'The 3D globe flies to the new country in one smooth turn — never a jump.'**
  String get wn40Flight;

  /// No description provided for @wn40Mercator.
  ///
  /// In en, this message translates to:
  /// **'The flat maps draw in the standard Mercator projection: true proportions, standard borders, nothing squeezed.'**
  String get wn40Mercator;

  /// No description provided for @wn40NameBack.
  ///
  /// In en, this message translates to:
  /// **'The chosen country\'s name is back under the flags on the flat maps.'**
  String get wn40NameBack;

  /// No description provided for @wn40Speed.
  ///
  /// In en, this message translates to:
  /// **'The tunnel now opens two parallel sessions by default — a stronger, steadier line.'**
  String get wn40Speed;

  /// No description provided for @wn40LockFixed.
  ///
  /// In en, this message translates to:
  /// **'The connect button\'s lock no longer blinks out between its states.'**
  String get wn40LockFixed;

  /// No description provided for @wn40IpRemoved.
  ///
  /// In en, this message translates to:
  /// **'The IP popup on the location card is gone.'**
  String get wn40IpRemoved;

  /// No description provided for @soundFeedback.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundFeedback;

  /// No description provided for @soundFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Soft sounds for taps, switches, and the connection\'s turns'**
  String get soundFeedbackHint;

  /// No description provided for @rateUnit.
  ///
  /// In en, this message translates to:
  /// **'Speed unit'**
  String get rateUnit;

  /// No description provided for @lockInBackground.
  ///
  /// In en, this message translates to:
  /// **'Lock when leaving'**
  String get lockInBackground;

  /// No description provided for @lockBgNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get lockBgNever;

  /// No description provided for @lockBgNow.
  ///
  /// In en, this message translates to:
  /// **'Right away'**
  String get lockBgNow;

  /// No description provided for @lockBgMin5.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get lockBgMin5;

  /// No description provided for @lockBgMin15.
  ///
  /// In en, this message translates to:
  /// **'After 15 minutes'**
  String get lockBgMin15;

  /// No description provided for @mb25600.
  ///
  /// In en, this message translates to:
  /// **'25 GB'**
  String get mb25600;

  /// No description provided for @mb51200.
  ///
  /// In en, this message translates to:
  /// **'50 GB'**
  String get mb51200;

  /// No description provided for @mb102400.
  ///
  /// In en, this message translates to:
  /// **'100 GB'**
  String get mb102400;

  /// No description provided for @wn41Sound.
  ///
  /// In en, this message translates to:
  /// **'A connection sound joins the vibration: the VPN hums a short note as it comes up or goes down (Settings → General).'**
  String get wn41Sound;

  /// No description provided for @wn41RateUnit.
  ///
  /// In en, this message translates to:
  /// **'The speed reads in the unit you pick: the familiar KB/s or the connection\'s own Mbps.'**
  String get wn41RateUnit;

  /// No description provided for @wn41BackgroundLock.
  ///
  /// In en, this message translates to:
  /// **'The app can lock itself while away: the password asks again right away, after 5, or after 15 minutes.'**
  String get wn41BackgroundLock;

  /// No description provided for @wn41BiggerLimits.
  ///
  /// In en, this message translates to:
  /// **'The session\'s data limit climbs to 25, 50, or 100 GB.'**
  String get wn41BiggerLimits;

  /// No description provided for @wn41Motion.
  ///
  /// In en, this message translates to:
  /// **'New motion: the connected orb breathes, the check draws itself in, the state\'s word glides between its values, and a wrong password shakes the field.'**
  String get wn41Motion;

  /// No description provided for @wn41AboutFixed.
  ///
  /// In en, this message translates to:
  /// **'The About page sits straight: the two pages side by side, every hint on its own line, nothing squeezed.'**
  String get wn41AboutFixed;

  /// No description provided for @wn41HapticFixed.
  ///
  /// In en, this message translates to:
  /// **'The vibration setting answers again: every connection\'s on and off follows it, not just the slider\'s.'**
  String get wn41HapticFixed;

  /// No description provided for @copyIp.
  ///
  /// In en, this message translates to:
  /// **'Copy IP'**
  String get copyIp;

  /// No description provided for @wn42Fonts.
  ///
  /// In en, this message translates to:
  /// **'Every language reads in the app\'s own faces: Noto Sans for the two Chinese and for Bengali, Inter for the Latin and Cyrillic ones — no language leans on the phone\'s fonts anymore.'**
  String get wn42Fonts;

  /// No description provided for @wn42Sounds.
  ///
  /// In en, this message translates to:
  /// **'The app\'s sounds are real now: a soft tap in every section, two notes for the switches, a rising and a falling note as the connection comes up and goes down, a ping for the lock — the sound switch gates them all.'**
  String get wn42Sounds;

  /// No description provided for @wn42AboutFixed.
  ///
  /// In en, this message translates to:
  /// **'The About page centers its logo, its name and its note, and the contact handles stay whole on one line whatever the phone\'s width.'**
  String get wn42AboutFixed;

  /// No description provided for @wn42Gaming.
  ///
  /// In en, this message translates to:
  /// **'The gaming profile is real now: the servers page measures the delays fresh every half minute and lifts the measured fastest with the accent.'**
  String get wn42Gaming;

  /// No description provided for @avatarPhoto.
  ///
  /// In en, this message translates to:
  /// **'Your photo'**
  String get avatarPhoto;

  /// No description provided for @avatarPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'That picture could not be used'**
  String get avatarPhotoFailed;

  /// No description provided for @tlsFragmentAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get tlsFragmentAuto;

  /// No description provided for @tlsFragmentAutoHint.
  ///
  /// In en, this message translates to:
  /// **'The whole hello first; a network that keeps cutting TLS gets the name cut on its own, for half an hour'**
  String get tlsFragmentAutoHint;

  /// No description provided for @accentDesign.
  ///
  /// In en, this message translates to:
  /// **'The design\'s own light'**
  String get accentDesign;

  /// No description provided for @wn45Designs.
  ///
  /// In en, this message translates to:
  /// **'Four new home looks — Aurora, Neon, Dusk and Sage — each dressing every page in its own palette'**
  String get wn45Designs;

  /// No description provided for @wn45HelloAuto.
  ///
  /// In en, this message translates to:
  /// **'The TLS fragment learned: a network that keeps killing the handshake gets the name cut on its own, and the tunnel gets through'**
  String get wn45HelloAuto;

  /// No description provided for @wn45RelayRace.
  ///
  /// In en, this message translates to:
  /// **'Relay recovery now races three edges at once, so a filtered network finds its way back sooner'**
  String get wn45RelayRace;

  /// No description provided for @wn45AccentFixed.
  ///
  /// In en, this message translates to:
  /// **'The accent picker lights the app again — its color had stopped reaching the pages'**
  String get wn45AccentFixed;

  /// No description provided for @wn45WhatsNewFixed.
  ///
  /// In en, this message translates to:
  /// **'The What\'s new page shows its words again — it had opened empty'**
  String get wn45WhatsNewFixed;

  /// No description provided for @wn46Designs.
  ///
  /// In en, this message translates to:
  /// **'Two new looks from the reference designs: the aether\'s iOS status card and the zed\'s gradient blob — each dresses the whole app, every page, and the four earlier looks left.'**
  String get wn46Designs;

  /// No description provided for @wn46Sounds.
  ///
  /// In en, this message translates to:
  /// **'The sounds grew a professional set: a swell for the connect that begins, a chord when it carries, a falling one when it rests, and a muted note for the blocked way — one voice at a time.'**
  String get wn46Sounds;

  /// No description provided for @wn47Designs.
  ///
  /// In en, this message translates to:
  /// **'The two reference looks now dress the whole app — every page, not just the home: the aether wears AetherST\'s iOS structure (the curved notch bar, the grouped tables, the colored badges, the system\'s own state colors), and the zed wears ZedSecure\'s expressive one (the floating dock, the very-round cards, the draggable tool bubbles).'**
  String get wn47Designs;

  /// No description provided for @wn47Fixes.
  ///
  /// In en, this message translates to:
  /// **'A settings row that overflowed on narrow screens now reads to its end.'**
  String get wn47Fixes;

  /// No description provided for @wn48Bars.
  ///
  /// In en, this message translates to:
  /// **'The two designs\' bottom bars hold their places again: the aether\'s blue circle rests in its own tab\'s notch, and the zed\'s circle no longer covers the name under it.'**
  String get wn48Bars;

  /// No description provided for @wn48Fit.
  ///
  /// In en, this message translates to:
  /// **'The homes fit their screens again: the aether\'s card reads Disconnected to its end, the zed\'s orb steps down when the page runs tight, and while the connection is being made no track asks to slide to connect and no hint says disconnect at once.'**
  String get wn48Fit;

  /// No description provided for @wn48Wheel.
  ///
  /// In en, this message translates to:
  /// **'The flags\' wheel dissolves a card before the screen\'s edge can cut it, the recommended place wears Mozilla\'s mark at a size that reads, and the flat map\'s south edge melts into the page instead of ending in a line.'**
  String get wn48Wheel;

  /// No description provided for @wn49States.
  ///
  /// In en, this message translates to:
  /// **'The two reference designs wear the details they were drawn with: the aether\'s card carries the session\'s own rates the way AetherST\'s does, its power button breathes the reference\'s glow and sinks under the finger, and the zed\'s blob turns itself between its shapes while its center\'s selves cross-fade.'**
  String get wn49States;

  /// No description provided for @wn49Words.
  ///
  /// In en, this message translates to:
  /// **'Connecting has a word everywhere now: while the tunnel is being made, the switch\'s track carries Connecting…, the knob\'s mark fades between its selves, and the track breathes with the connection\'s own rhythm — nothing vanishes under the finger.'**
  String get wn49Words;

  /// No description provided for @wn49Sooner.
  ///
  /// In en, this message translates to:
  /// **'The connection\'s engine is the original\'s own again: the relay pool, the alternate routes and their cache, and the repeated-request guard carry the tunnel — it comes up sooner and holds.'**
  String get wn49Sooner;

  /// No description provided for @wn49Mark.
  ///
  /// In en, this message translates to:
  /// **'The recommended location wears Mozilla VPN\'s real mark, and the update\'s buttons wear the update\'s own glyph.'**
  String get wn49Mark;

  /// No description provided for @wn50Notch.
  ///
  /// In en, this message translates to:
  /// **'The two designs\' dress comes out of the mess it had kept: the aether\'s notch bar reads the circle\'s own center, the chosen tab\'s name wears the page\'s ink on both looks, and the circle\'s glow keeps to the circle instead of washing the name.'**
  String get wn50Notch;

  /// No description provided for @wn50Cards.
  ///
  /// In en, this message translates to:
  /// **'The zed\'s home folds its rates into the bento: the rate card joins the bento\'s two cells and the session\'s row, the page\'s last cards clear the dock\'s seat, and nothing runs half under the dock when the page scrolls to its end.'**
  String get wn50Cards;

  /// No description provided for @wn50Veil.
  ///
  /// In en, this message translates to:
  /// **'The status band wears its veil: the scrolled content fades beneath the clock instead of colliding with it, the zed\'s pushed pages no longer start under the clock, and its floating tools keep clear of the dock\'s seat.'**
  String get wn50Veil;

  /// No description provided for @wn50Ping.
  ///
  /// In en, this message translates to:
  /// **'The aether\'s ping chip measures again on a tap, the way the reference\'s own chip answers.'**
  String get wn50Ping;

  /// No description provided for @tapToChangeServer.
  ///
  /// In en, this message translates to:
  /// **'Tap to change server'**
  String get tapToChangeServer;

  /// No description provided for @wn51Smooth.
  ///
  /// In en, this message translates to:
  /// **'The flags\' wheel and the strip move the way a wheel should: the drag and the change of country now ride the compositor — nothing re-lays out and no glow redraws itself while the flags turn, so the wheel spins smooth and the page scrolls with it.'**
  String get wn51Smooth;

  /// No description provided for @wn51Zed.
  ///
  /// In en, this message translates to:
  /// **'The zed\'s home wears the reference\'s own structure: the two rate cards stand under the brand (resting at their zeros when the tunnel rests), the state\'s word arrives in the display\'s big face under the orb, and the place lives on the bright server card above the dock — the small chip and the repeated name are gone.'**
  String get wn51Zed;

  /// No description provided for @wn51Aether.
  ///
  /// In en, this message translates to:
  /// **'The aether\'s home says the place once: the strip\'s repeated name line rests, the status card and the power button keep their seats, and the page reads as one clean column.'**
  String get wn51Aether;

  /// No description provided for @wn51Veil.
  ///
  /// In en, this message translates to:
  /// **'The clock\'s veil grew a breath tall and holds its color across the clock\'s band: the content that scrolls beneath it fades whole, and its words never meet the clock.'**
  String get wn51Veil;

  /// No description provided for @wn52Speed.
  ///
  /// In en, this message translates to:
  /// **'The tunnel runs at the network\'s own speed again: the VPN\'s interface speaks the line\'s packet size (MTU 1500) instead of an oversized one, so downloads take their full speed and calls stay steady — on mobile data especially.'**
  String get wn52Speed;

  /// No description provided for @wn52Smart.
  ///
  /// In en, this message translates to:
  /// **'Fastest location and the recommended service choose honestly again: every start measures the locations fresh and takes the best one now, instead of quietly riding the place chosen before.'**
  String get wn52Smart;

  /// No description provided for @wn52Motion.
  ///
  /// In en, this message translates to:
  /// **'Thirty new animations, all over the app: every page and card lands softly, pressed tiles sink and return, the connecting state\'s dot breathes, and pushed pages glide in — each one standing still when the system asks for less motion.'**
  String get wn52Motion;

  /// No description provided for @wn52Pages.
  ///
  /// In en, this message translates to:
  /// **'The pushed pages arrive with a soft glide and the page\'s title from its own edge; while a setting saves, a quiet line sweeps the section.'**
  String get wn52Pages;

  /// No description provided for @wn56Button.
  ///
  /// In en, this message translates to:
  /// **'The connect slider keeps its word through the whole walk — no more empty moment between connecting and connected: the word glides between its states now, and the working dim follows with a breath.'**
  String get wn56Button;

  /// No description provided for @wn56Capsule.
  ///
  /// In en, this message translates to:
  /// **'The wheel\'s home says each state once: the repeated status word above the slider is gone — the track itself carries it, and the page reads a line quieter.'**
  String get wn56Capsule;

  /// No description provided for @wn56Door.
  ///
  /// In en, this message translates to:
  /// **'The speed test has its own door on the home: one row, one tap, and the measurement opens — before the first connect too, not only while the tunnel carries.'**
  String get wn56Door;

  /// No description provided for @wn56Wheel.
  ///
  /// In en, this message translates to:
  /// **'The flags\' wheel glides: one fling carries one country, and the landing settles into place instead of snapping — the drag reads heavy and steady, the way a good dial turns.'**
  String get wn56Wheel;

  /// No description provided for @designGazette.
  ///
  /// In en, this message translates to:
  /// **'Gazette'**
  String get designGazette;

  /// No description provided for @designGazetteDesc.
  ///
  /// In en, this message translates to:
  /// **'A front page: the masthead, the ruled columns and the ink stamp — the news sheet\'s own calm, in paper and ink'**
  String get designGazetteDesc;

  /// No description provided for @speedTestSizesTitle.
  ///
  /// In en, this message translates to:
  /// **'Test size'**
  String get speedTestSizesTitle;

  /// No description provided for @wn61Gta.
  ///
  /// In en, this message translates to:
  /// **'The GTA design: the game\'s own HUD — the weapon wheel for the flags, the radar-green tunnel, the amber panels, the heavy face and its own tick'**
  String get wn61Gta;

  /// No description provided for @wn61Sound.
  ///
  /// In en, this message translates to:
  /// **'The wheel\'s tick: every seat the dial passes answers in the ear as well as the hand'**
  String get wn61Sound;

  /// No description provided for @wn62Wheel.
  ///
  /// In en, this message translates to:
  /// **'The weapon wheel rebuilt: the seats keep the game\'s own spacing at any country count, the chosen sector carries the wheel\'s lit wedge, and a flick throws the dial'**
  String get wn62Wheel;

  /// No description provided for @wn62Map.
  ///
  /// In en, this message translates to:
  /// **'The home\'s map wears each design\'s own colors now — the water, the land and the grid follow the design the page carries'**
  String get wn62Map;

  /// No description provided for @wn62HudMap.
  ///
  /// In en, this message translates to:
  /// **'The GTA design\'s own map: the game\'s HUD plate — deep water, the neon coast, the amber radar grid and the sweep that walks the world while the tunnel carries'**
  String get wn62HudMap;

  /// No description provided for @wn62Aether.
  ///
  /// In en, this message translates to:
  /// **'The Aether design\'s power control rebuilt: the disc stands in a thin ring track, the connecting arc walks the ring, and the machined face catches the light'**
  String get wn62Aether;

  /// No description provided for @wn62Gta.
  ///
  /// In en, this message translates to:
  /// **'The GTA connect pad answers the hand — the whole panel sinks on a press, and the power\'s mark steps back while the connection is being made'**
  String get wn62Gta;

  /// No description provided for @speedTestSizeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get speedTestSizeLight;

  /// No description provided for @speedTestSizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get speedTestSizeStandard;

  /// No description provided for @speedTestSizeFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get speedTestSizeFull;

  /// No description provided for @speedTestJitter.
  ///
  /// In en, this message translates to:
  /// **'Jitter'**
  String get speedTestJitter;

  /// No description provided for @gazetteEdition.
  ///
  /// In en, this message translates to:
  /// **'No. {n}'**
  String gazetteEdition(int n);

  /// No description provided for @gazetteBulletin.
  ///
  /// In en, this message translates to:
  /// **'Security Bulletin'**
  String get gazetteBulletin;

  /// No description provided for @gazetteLiveWire.
  ///
  /// In en, this message translates to:
  /// **'Live wire'**
  String get gazetteLiveWire;

  /// No description provided for @wn56Speed.
  ///
  /// In en, this message translates to:
  /// **'The speed test lives again: each leg measures on its own connection and speaks plain HTTP/1.1, so the upload no longer dies when the download\'s window closes — and the panel adds the path\'s delay, its jitter, and a size to pick.'**
  String get wn56Speed;

  /// No description provided for @wn56Gazette.
  ///
  /// In en, this message translates to:
  /// **'A new home look: the gazette — a front page with a masthead, ruled columns, a live ticker and the ink stamp that presses when the tunnel carries.'**
  String get wn56Gazette;

  /// No description provided for @designIos.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get designIos;

  /// No description provided for @designIosDesc.
  ///
  /// In en, this message translates to:
  /// **'The system\'s own: the grouped tables, the tab bar\'s hairline, the status card and the capsule button — clarity in the system\'s voice'**
  String get designIosDesc;

  /// No description provided for @gazetteSection.
  ///
  /// In en, this message translates to:
  /// **'SECTION'**
  String get gazetteSection;

  /// No description provided for @wn58Lock.
  ///
  /// In en, this message translates to:
  /// **'The knob\'s lock keeps its ink when the tunnel carries: the mark now reads the face it stands on — dark on a light knob, white on a dark one — so the icon never drowns again.'**
  String get wn58Lock;

  /// No description provided for @wn58Enter.
  ///
  /// In en, this message translates to:
  /// **'The connected section breathes in: the numbers fade and lift while the room grows beneath them, and walk back out the same way — the cards no longer snap up between two frames.'**
  String get wn58Enter;

  /// No description provided for @wn58Speed.
  ///
  /// In en, this message translates to:
  /// **'The speed test runs lighter: the panel repaints ten times a second at most, the sweep\'s needle walks in a short straight line, and the faces crossfade instead of snapping.'**
  String get wn58Speed;

  /// No description provided for @wn58Ios.
  ///
  /// In en, this message translates to:
  /// **'A new design: iOS — the system\'s own look, from the grouped tables and the tab bar\'s hairline to the status card with its capsule button. Every page, card, dialog and icon in the system\'s voice, in both modes.'**
  String get wn58Ios;

  /// No description provided for @wn58Pixel.
  ///
  /// In en, this message translates to:
  /// **'A new design: Pixel — Material You\'s look, the tonal surfaces, the big filled cards, the pill-indicator bar and the large titles. Every page, card, dialog and icon in the Android\'s own voice, in both modes.'**
  String get wn58Pixel;

  /// No description provided for @wn58Paper.
  ///
  /// In en, this message translates to:
  /// **'The gazette is a whole paper now: its own section bar with the print\'s bullet and underline, a section-front header for every pushed page, and the ruled paper box for every group of settings — the print\'s rules reach the whole app.'**
  String get wn58Paper;

  /// No description provided for @wn59Flags.
  ///
  /// In en, this message translates to:
  /// **'The flags wear each design\'s own cut: the round medal on iOS and the aether, the squircle on the zed, the ruled plate on the gazette, the pixel\'s soft big rounds — the wheel, the strip and every row\'s little flag follow.'**
  String get wn59Flags;

  /// No description provided for @wn59Map.
  ///
  /// In en, this message translates to:
  /// **'The world map is drawn in the design\'s own ink: the paper\'s warm brown on the gazette, the violet night\'s gray on the zed, the tonal blue-gray on the pixel — each design\'s world belongs to its page.'**
  String get wn59Map;

  /// No description provided for @wn59Buttons.
  ///
  /// In en, this message translates to:
  /// **'The connect controls speak their designs: Material You\'s big tonal pill on the pixel, the iOS capsule breathing while the connection is being made, and every page\'s cards entering in their design\'s own motion.'**
  String get wn59Buttons;

  /// No description provided for @wn59Scroll.
  ///
  /// In en, this message translates to:
  /// **'The wheels and strips scroll in the design\'s own physics: the system\'s bounce, Material\'s quick settle, and the paper\'s weight that dies against the fold.'**
  String get wn59Scroll;

  /// No description provided for @flagAllPlaces.
  ///
  /// In en, this message translates to:
  /// **'All places'**
  String get flagAllPlaces;

  /// No description provided for @gazetteRegions.
  ///
  /// In en, this message translates to:
  /// **'Destinations'**
  String get gazetteRegions;

  /// No description provided for @wn60Flags.
  ///
  /// In en, this message translates to:
  /// **'Each design shows the countries its own way now: the bento\'s board of tiles, the pixel\'s filter chips, the aether\'s capsule options, the iOS medals\' deck, the zed\'s paged board, the gazette\'s region index printed like the paper\'s own — the wheel keeps its wheel.'**
  String get wn60Flags;

  /// No description provided for @wn60Bento.
  ///
  /// In en, this message translates to:
  /// **'The bento design stands whole: its own warm palette of porcelain and charcoal, the tangerine\'s light, the dock of tiles, the squircle page headers, the tinted cards and the board of flags — every page, both modes.'**
  String get wn60Bento;

  /// No description provided for @wn60Spacing.
  ///
  /// In en, this message translates to:
  /// **'The homes walk in one rhythm: the dead bands between the sections are gone, the closing cards fill their rows, and every gap breathes by the spacing the design keeps.'**
  String get wn60Spacing;

  /// No description provided for @wn63Retired.
  ///
  /// In en, this message translates to:
  /// **'The aether and the zed designs retired: their users walk to the designs that wear their structure — the aether\'s tables to iOS, the zed\'s bento to Bento'**
  String get wn63Retired;

  /// No description provided for @wn63Map.
  ///
  /// In en, this message translates to:
  /// **'The GTA map reads as the game\'s own now: every border as a road, an amber blip on every server country, the chosen place as the waypoint with its beam and its name on the plate, the compass at the corner'**
  String get wn63Map;

  /// No description provided for @wn63Servers.
  ///
  /// In en, this message translates to:
  /// **'The servers page wears each design\'s own list — the iOS grouped table, the gazette\'s ruled index, the GTA\'s HUD slots, the pixel\'s tonal cards, the bento\'s board'**
  String get wn63Servers;

  /// No description provided for @wn63Accounts.
  ///
  /// In en, this message translates to:
  /// **'The accounts page wears the design too: the cards in the design\'s own round, the add button in the design\'s voice, the dialogs\' titles in the display\'s face, the fields in the design\'s frame'**
  String get wn63Accounts;

  /// No description provided for @wn63Wheel.
  ///
  /// In en, this message translates to:
  /// **'The weapon wheel rebuilt to the game\'s own measure: the full circle of sector dividers, the two-layer lit wedge, the counter\'s gauge arc, the pop of the opening, and the pick\'s own pulse'**
  String get wn63Wheel;

  /// No description provided for @wn63Ios.
  ///
  /// In en, this message translates to:
  /// **'The iOS design stands fuller: the status card\'s state wash, the medal deck\'s page dots, the tick at every snap'**
  String get wn63Ios;

  /// No description provided for @wn64Wheel.
  ///
  /// In en, this message translates to:
  /// **'The GTA wheel\'s medals sit inside the dial now — twelve seats the game\'s own spread, no medal on the rim or past the screen\'s edge, no two medals touching'**
  String get wn64Wheel;

  /// No description provided for @wn64Glass.
  ///
  /// In en, this message translates to:
  /// **'The wheel wears the game\'s glass: the world blurred softly under the dial, the plate a touch see-through, its sheen gathered at the top'**
  String get wn64Glass;

  /// No description provided for @wn64Groups.
  ///
  /// In en, this message translates to:
  /// **'The iOS home\'s own groups: the session\'s table — the tunnel\'s address, a tap from the clipboard — and the quick actions: the speed test, the connection\'s settings, the accounts'**
  String get wn64Groups;

  /// No description provided for @wn64Headers.
  ///
  /// In en, this message translates to:
  /// **'Every page header stretches the page again — the back arrow stands at its edge, not the screen\'s middle'**
  String get wn64Headers;

  /// No description provided for @wn64Pill.
  ///
  /// In en, this message translates to:
  /// **'The Material You pill\'s label keeps its breath inside the rounded ends'**
  String get wn64Pill;

  /// No description provided for @wn64Map.
  ///
  /// In en, this message translates to:
  /// **'The GTA map\'s borders return to their first dress — the coast keeps its neon, the land its thin ink edge'**
  String get wn64Map;

  /// No description provided for @wn64Name.
  ///
  /// In en, this message translates to:
  /// **'The Pixel design answers to its own name: Material You'**
  String get wn64Name;

  /// No description provided for @wn65Gone.
  ///
  /// In en, this message translates to:
  /// **'The GTA design left: its home, its pages, its palette — five designs stay, and a settings file that still names it lands on the wheel'**
  String get wn65Gone;

  /// No description provided for @wn65Tight.
  ///
  /// In en, this message translates to:
  /// **'The home packs tighter in every design: the bare bands the screen\'s leftover used to open between the cards are gone — the wheel, the tiles, the paper, the medals and the chips follow one another at a breath\'s distance, and the page scrolls where it used to stretch'**
  String get wn65Tight;

  /// No description provided for @wn65Radar.
  ///
  /// In en, this message translates to:
  /// **'The map the GTA design carried stands on its own now, as the radar: the same deep water, the amber grid and the sweep, under its own name in the map picker'**
  String get wn65Radar;

  /// No description provided for @wn67Port.
  ///
  /// In en, this message translates to:
  /// **'The connection-port setting leaves: the servers answer only on the port the server list gives them — a port forced on them closed every connection, and a config that still carries one drops it at the first start'**
  String get wn67Port;

  /// No description provided for @wn67Back.
  ///
  /// In en, this message translates to:
  /// **'The connection stands again — everything else is where 1.0.65 left it: the five designs, the radar map, the steady tunnel'**
  String get wn67Back;

  /// No description provided for @designUr.
  ///
  /// In en, this message translates to:
  /// **'URnetwork'**
  String get designUr;

  /// No description provided for @designUrDesc.
  ///
  /// In en, this message translates to:
  /// **'The URnetwork face: a round connect button, a location card, and a pull-up live-stats sheet'**
  String get designUrDesc;

  /// No description provided for @urConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get urConnect;

  /// No description provided for @urDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get urDisconnect;

  /// No description provided for @urChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get urChangeLocation;

  /// No description provided for @urStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Live stats'**
  String get urStatsTitle;

  /// No description provided for @urStatsHint.
  ///
  /// In en, this message translates to:
  /// **'Pull up'**
  String get urStatsHint;

  /// No description provided for @urSpeedUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get urSpeedUp;

  /// No description provided for @urSpeedDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get urSpeedDown;

  /// No description provided for @urSessionTime.
  ///
  /// In en, this message translates to:
  /// **'Connected for'**
  String get urSessionTime;

  /// No description provided for @urSessionData.
  ///
  /// In en, this message translates to:
  /// **'Session data'**
  String get urSessionData;

  /// No description provided for @urExitLocation.
  ///
  /// In en, this message translates to:
  /// **'Exit location'**
  String get urExitLocation;

  /// No description provided for @urLastTest.
  ///
  /// In en, this message translates to:
  /// **'Last test'**
  String get urLastTest;

  /// No description provided for @urNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get urNoData;

  /// No description provided for @urSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get urSectionGeneral;

  /// No description provided for @urSectionConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get urSectionConnections;

  /// No description provided for @urSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get urSectionAppearance;

  /// No description provided for @urSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get urSectionAbout;

  /// No description provided for @urNavStyle.
  ///
  /// In en, this message translates to:
  /// **'Navigation style'**
  String get urNavStyle;

  /// No description provided for @urNavStyleNote.
  ///
  /// In en, this message translates to:
  /// **'The look of the bar at the screen\'s foot.'**
  String get urNavStyleNote;

  /// No description provided for @urNavMorphing.
  ///
  /// In en, this message translates to:
  /// **'Morphing'**
  String get urNavMorphing;

  /// No description provided for @urNavNeon.
  ///
  /// In en, this message translates to:
  /// **'Neon glow'**
  String get urNavNeon;

  /// No description provided for @urNavBubble.
  ///
  /// In en, this message translates to:
  /// **'Bubble'**
  String get urNavBubble;

  /// No description provided for @urNavCapsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get urNavCapsule;

  /// No description provided for @urBatterySaverNote.
  ///
  /// In en, this message translates to:
  /// **'Rests the home\'s motion while connected.'**
  String get urBatterySaverNote;

  /// No description provided for @urUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Session usage'**
  String get urUsageTitle;

  /// No description provided for @urUsageTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get urUsageTotal;

  /// No description provided for @urWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get urWhatsNew;

  /// No description provided for @urAboutUpdates.
  ///
  /// In en, this message translates to:
  /// **'App and updates'**
  String get urAboutUpdates;

  /// No description provided for @wn70UrNav.
  ///
  /// In en, this message translates to:
  /// **'The URnetwork navigation joins the design: the floating morphing bar whose highlight glides between the tabs, the neon glow, the bubbles, and the capsule — pick the look under Settings → Appearance'**
  String get wn70UrNav;

  /// No description provided for @wn70UrCards.
  ///
  /// In en, this message translates to:
  /// **'The URnetwork settings screen: the sections and cards, the language, the navigation style, and the session\'s usage bar in the drawer'**
  String get wn70UrCards;

  /// No description provided for @urQuickTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick options'**
  String get urQuickTitle;

  /// No description provided for @urShare.
  ///
  /// In en, this message translates to:
  /// **'Hotspot sharing'**
  String get urShare;

  /// No description provided for @urShareDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn this phone into a gateway: the devices on its hotspot can use the VPN through it. Turn the hotspot on, connect the other device, then set its proxy to the address below.'**
  String get urShareDesc;

  /// No description provided for @urShareProxy.
  ///
  /// In en, this message translates to:
  /// **'Proxy address'**
  String get urShareProxy;

  /// No description provided for @urShareCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get urShareCopied;

  /// No description provided for @urShareOpenHotspot.
  ///
  /// In en, this message translates to:
  /// **'Open hotspot settings'**
  String get urShareOpenHotspot;

  /// No description provided for @urShareOn.
  ///
  /// In en, this message translates to:
  /// **'Sharing is on — the proxy answers on the hotspot.'**
  String get urShareOn;

  /// No description provided for @urShareNeedsVpn.
  ///
  /// In en, this message translates to:
  /// **'Connect the VPN first; the shared devices go through its tunnel.'**
  String get urShareNeedsVpn;

  /// No description provided for @urShareSteps.
  ///
  /// In en, this message translates to:
  /// **'1. Turn on this phone\'s hotspot\n2. Connect the other device to the hotspot\n3. On that device, open the Wi-Fi network\'s proxy and choose Manual\n4. Set the server to the address above — the same address answers SOCKS5 too'**
  String get urShareSteps;

  /// No description provided for @urShareNote.
  ///
  /// In en, this message translates to:
  /// **'Works while the VPN is connected. The core\'s proxy carries both the HTTP proxy and SOCKS5 on the same port; the port closes back to the loopback when the share goes off.'**
  String get urShareNote;

  /// No description provided for @wn71Nav.
  ///
  /// In en, this message translates to:
  /// **'The classic bottom bar is the only navigation now — the morphing pill, the neon glow, the bubbles and the capsule leave with their picker.'**
  String get wn71Nav;

  /// No description provided for @wn71Stats.
  ///
  /// In en, this message translates to:
  /// **'The drawer\'s stats speak the original\'s precision: the transfer chart mirrored on a center axis, each direction\'s peak labeled in its place, and every rate read as 2.50 KiB/s.'**
  String get wn71Stats;

  /// No description provided for @wn71Drawer.
  ///
  /// In en, this message translates to:
  /// **'The pull-up drawer stops below the navigation and gains the quick options: the kill switch, the notification\'s speed and flag, the per-app routing, and the hotspot sharing.'**
  String get wn71Drawer;

  /// No description provided for @wn71Share.
  ///
  /// In en, this message translates to:
  /// **'Hotspot sharing: turn this phone into a VPN gateway for the devices on its hotspot — one switch opens the proxy, the page carries the address and the steps.'**
  String get wn71Share;

  /// No description provided for @changeUi.
  ///
  /// In en, this message translates to:
  /// **'Change UI/UX'**
  String get changeUi;

  /// No description provided for @wn68Toast.
  ///
  /// In en, this message translates to:
  /// **'The floating notes drop the blur: one less heavy effect on every toast, the weak phones keep their frames'**
  String get wn68Toast;

  /// No description provided for @urReadyToConnect.
  ///
  /// In en, this message translates to:
  /// **'Ready to connect'**
  String get urReadyToConnect;

  /// No description provided for @urConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get urConnectFailed;

  /// No description provided for @wn69Ur.
  ///
  /// In en, this message translates to:
  /// **'The URnetwork screen, ported as it ships: the stepped-square connect face, the tap-to-connect pulse, the provider grid as the tunnel builds, and the color fields that land once it holds'**
  String get wn69Ur;

  /// No description provided for @wn69Stats.
  ///
  /// In en, this message translates to:
  /// **'The drawer keeps the original\'s geometry: the location row and Connect at the peek, and below the fold the live speeds, the session\'s numbers, the exit and the last test'**
  String get wn69Stats;

  /// No description provided for @wn68Stats.
  ///
  /// In en, this message translates to:
  /// **'Pull the home\'s bottom edge up: live speeds, the session\'s sparkline, the exit location, the IP and the last test — nothing the core is not already reporting'**
  String get wn68Stats;

  /// No description provided for @wn68Ur.
  ///
  /// In en, this message translates to:
  /// **'The URnetwork design joins the picker: the round connect button that gathers its points as the tunnel comes up, the location card, the wide Connect — choose it under Appearance'**
  String get wn68Ur;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'az',
    'bn',
    'en',
    'es',
    'fa',
    'fr',
    'hu',
    'id',
    'pt',
    'ru',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'az':
      return AppLocalizationsAz();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
