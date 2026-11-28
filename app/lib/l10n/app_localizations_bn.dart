// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'সংযোগ করতে স্লাইড করুন';

  @override
  String get slideToDisconnect => 'বিচ্ছিন্ন করতে স্লাইড করুন';

  @override
  String get navOverview => 'সারসংক্ষেপ';

  @override
  String get navAccounts => 'অ্যাকাউন্ট';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get stateConnected => 'সংযুক্ত';

  @override
  String get stateConnecting => 'সংযোগ হচ্ছে…';

  @override
  String get stateWaiting => 'অপেক্ষা করছে';

  @override
  String get waitingForAccount =>
      'সংযোগ করতে অ্যাকাউন্ট পাতায় একটি Firefox Account যোগ করুন।';

  @override
  String get waitingForEnabledAccount =>
      'সব অ্যাকাউন্ট বন্ধ আছে। অ্যাকাউন্ট পাতা থেকে একটি চালু করুন।';

  @override
  String get stateError => 'ত্রুটি';

  @override
  String get stateUnknown => 'অজানা';

  @override
  String get restartProxy => 'প্রক্সি পুনরায় চালু করুন';

  @override
  String copied(String value) {
    return '$value কপি হয়েছে';
  }

  @override
  String get activeAccount => 'সক্রিয় অ্যাকাউন্ট';

  @override
  String get noActiveAccount => 'কোনো সক্রিয় অ্যাকাউন্ট নেই';

  @override
  String get quotaNotRead => 'ডেটার তথ্য এখনও আসেনি';

  @override
  String get unlimited => 'সীমাহীন';

  @override
  String usedOf(String used, String limit) {
    return '$limit-এর মধ্যে $used ব্যবহৃত';
  }

  @override
  String resets(String date) {
    return '$date তারিখে রিসেট হবে';
  }

  @override
  String switchAt(int percent) {
    return '$percent% হলে অ্যাকাউন্ট বদলাবে';
  }

  @override
  String get publicIp => 'পাবলিক IP';

  @override
  String get testConnection => 'সংযোগ পরীক্ষা করুন';

  @override
  String get testing => 'পরীক্ষা চলছে…';

  @override
  String get testFailed => 'ব্যর্থ';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'এইমাত্র';

  @override
  String minutesAgo(int n) {
    return '$n মিনিট আগে';
  }

  @override
  String hoursAgo(int n) {
    return '$n ঘণ্টা আগে';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count দিন আগে',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return '$time-এ';
  }

  @override
  String durationDays(int d, int h) {
    return '$d দিন $h ঘণ্টা';
  }

  @override
  String durationHours(int h, int m) {
    return '$h ঘ $m মি';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m মি $s সে';
  }

  @override
  String durationSeconds(int s) {
    return '$s সে';
  }

  @override
  String accountsGuide(String size) {
    return 'প্রতিটি Firefox Account-এ মাসে $size ডেটা থাকে। আপনি একাধিক অ্যাকাউন্ট যোগ করতে পারেন: একটির ডেটা শেষ হলে অ্যাপ নিজে থেকেই পরেরটিতে যায়।';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'এই তালিকার ক্রমে: প্রতিটি অ্যাকাউন্ট $percent% পর্যন্ত, শেষটি ডেটা শেষ না হওয়া পর্যন্ত।';
  }

  @override
  String get addAccount => 'অ্যাকাউন্ট যোগ করুন';

  @override
  String lowQuotaNotice(String size) {
    return 'এই অ্যাকাউন্টের ডেটা প্রায় শেষ। আরেকটি অ্যাকাউন্ট যোগ করলে আরও $size পাবেন।';
  }

  @override
  String get noAccounts => 'এখনও কোনো অ্যাকাউন্ট নেই';

  @override
  String get noAccountsHint => 'সংযোগ করতে একটি Firefox Account যোগ করুন।';

  @override
  String get delayTestFailed =>
      'সার্ভারগুলোর বিলম্ব মাপা যায়নি। ইন্টারনেট পরীক্ষা করুন।';

  @override
  String get createAccountTitle => 'Firefox Account নেই?';

  @override
  String get createAccountHint =>
      'accounts.firefox.com-এ বিনামূল্যে একটি তৈরি করুন, তারপর এখানে ফিরে “অ্যাকাউন্ট যোগ করুন” চাপুন।';

  @override
  String get moveUp => 'উপরে সরান';

  @override
  String get moveDown => 'নিচে সরান';

  @override
  String get statusActive => 'সক্রিয়';

  @override
  String get statusReady => 'প্রস্তুত';

  @override
  String get statusNeedsSignIn => 'সাইন-ইন দরকার';

  @override
  String get statusReserved => 'রিজার্ভ';

  @override
  String get statusUnavailable => 'উপলভ্য নয়';

  @override
  String statusUnavailableUntil(String date) {
    return '$date পর্যন্ত উপলভ্য নয়';
  }

  @override
  String get statusDisabled => 'বন্ধ';

  @override
  String get statusEnabled => 'চালু';

  @override
  String get useNow => 'এখন ব্যবহার করুন';

  @override
  String get signInAgain => 'আবার সাইন ইন করুন';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'এই অ্যাকাউন্টের ডেটা $percent% ব্যবহৃত হয়েছে, তাই পরের অ্যাকাউন্টটি চালু হয়েছে।';
  }

  @override
  String get reasonQuotaExhausted =>
      'এই মাসের ডেটা শেষ; মাসিক রিসেটের পর আবার ব্যবহার হবে।';

  @override
  String get reasonSignInRequired =>
      'এই অ্যাকাউন্ট ব্যবহার করতে আবার সাইন ইন করুন।';

  @override
  String get reasonSignInConfirm =>
      'Mozilla সাইন-ইন নিশ্চিত করতে বলছে: «আবার সাইন ইন করুন» চাপুন (শুধু কোড লাগবে)।';

  @override
  String reasonSignInFailed(String detail) {
    return 'স্বয়ংক্রিয় সাইন-ইন ব্যর্থ হয়েছে ($detail)। আবার সাইন ইন করুন।';
  }

  @override
  String reasonSignInWait(String time) {
    return 'শেষ স্বয়ংক্রিয় সাইন-ইন কিছুক্ষণ পরেই কাজ করা বন্ধ করেছে; পরের চেষ্টা $time-এ।';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'স্বয়ংক্রিয় সাইন-ইন শেষ হয়নি ($detail); $time-এ আবার চেষ্টা হবে।';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla এই অ্যাকাউন্টটি গ্রহণ করেনি; পরে আবার চেষ্টা হবে।';

  @override
  String get more => 'আরও';

  @override
  String get refreshQuota => 'ডেটার হিসাব রিফ্রেশ করুন';

  @override
  String get remove => 'সরান';

  @override
  String get removeTitle => 'অ্যাকাউন্ট সরাবেন?';

  @override
  String removeBody(String name) {
    return '$name এবং এর সেভ করা সাইন-ইন এই ডিভাইস থেকে মুছে যাবে। পরে আবার যোগ করতে পারবেন।';
  }

  @override
  String get unlimitedQuota => 'সীমাহীন ডেটা';

  @override
  String get signInTitle => 'সাইন ইন';

  @override
  String get signInIntro => 'একটি Firefox Account দিয়ে সাইন ইন করুন।';

  @override
  String get email => 'ইমেইল';

  @override
  String get emailInvalid => 'অ্যাকাউন্টের ইমেইল লিখুন';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get passwordEmpty => 'পাসওয়ার্ড লিখুন';

  @override
  String get show => 'দেখান';

  @override
  String get hide => 'লুকান';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get continueLabel => 'চালিয়ে যান';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get close => 'বন্ধ';

  @override
  String get noBrowserTitle => 'এই ডিভাইসে কোনো ব্রাউজার নেই';

  @override
  String get noBrowserText => 'এই ঠিকানাটি আপনার ফোন বা কম্পিউটারে খুলুন:';

  @override
  String get cancel => 'বাতিল';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get signingIn => 'সাইন ইন হচ্ছে…';

  @override
  String get accountReady => 'অ্যাকাউন্ট প্রস্তুত';

  @override
  String get accountReadyHint => 'এটি অ্যাকাউন্ট তালিকার শেষে যোগ হয়েছে।';

  @override
  String get captchaLabel => 'ছবির অক্ষরগুলো';

  @override
  String get codeLabel => 'কোড';

  @override
  String get captchaBroken => 'CAPTCHA ছবিটি দেখানো যায়নি।';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla $email-এ একটি কোড ইমেইল করেছে। এখানে লিখুন।';
  }

  @override
  String get stepTotp => 'আপনার অথেনটিকেটর অ্যাপের কোডটি লিখুন।';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla এই সাইন-ইনটিকে অস্বাভাবিক মনে করছে এবং $email-এ একটি আনব্লক কোড ইমেইল করেছে। এখানে লিখুন।';
  }

  @override
  String get stepCaptcha => 'ছবির অক্ষরগুলো টাইপ করুন।';

  @override
  String stepEmailLink(String email) {
    return 'Mozilla $email-এ যে নিশ্চিতকরণ লিংক পাঠিয়েছে সেটি খুলুন। বাকিটা নিজে থেকেই হয়ে যাবে।';
  }

  @override
  String get signInFailed => 'অ্যাকাউন্ট যোগ হয়নি।';

  @override
  String get signInCancelled => 'সাইন ইন বাতিল হয়েছে।';

  @override
  String get signInNoAccount => 'এই ইমেইলে কোনো Firefox Account নেই।';

  @override
  String get signInNoAccountHint =>
      'ইমেইলটি দেখুন, অথবা এই ইমেইল দিয়ে Mozilla-র সাইটে একটি বিনামূল্যের Firefox Account তৈরি করুন, ইনবক্স থেকে নিশ্চিত করুন, তারপর এখানে যোগ করুন।';

  @override
  String get createAccountButton => 'Firefox Account তৈরি করুন';

  @override
  String get signInWrongPassword => 'পাসওয়ার্ড ভুল।';

  @override
  String get signInNoPassword =>
      'এই অ্যাকাউন্টের কোনো পাসওয়ার্ড নেই: এটি Google বা Apple দিয়ে সাইন ইন করে তৈরি। একটি পাসওয়ার্ড সেট করুন, তারপর সেটি দিয়ে এখানে সাইন ইন করুন।';

  @override
  String get setPasswordButton => 'পাসওয়ার্ড সেট করুন';

  @override
  String get signInTooManyAttempts =>
      'অনেকবার চেষ্টা হয়েছে। কিছুক্ষণ অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get signInUnblockRejected =>
      'আনব্লক কোড গৃহীত হয়নি। Mozilla-র সর্বশেষ ইমেইলের কোডটি ব্যবহার করুন।';

  @override
  String get signInWrongCode =>
      'কোড ভুল বা মেয়াদোত্তীর্ণ। Mozilla-র সর্বশেষ ইমেইলের কোডটি ব্যবহার করুন; নতুন কোড পাঠালে পুরোনোটি আর কাজ করে না।';

  @override
  String get signInWrongTotp =>
      'কোড ভুল। অথেনটিকেটর অ্যাপ এখন যে কোড দেখাচ্ছে সেটি লিখুন।';

  @override
  String get signInTooManyCodes =>
      'অনেকগুলো ভুল কোড। আবার শুরু থেকে সাইন ইন করুন।';

  @override
  String get signInTimedOut => 'সাইন ইনে অনেক সময় লেগেছে। আবার শুরু করুন।';

  @override
  String get signInNetwork =>
      'Mozilla-তে পৌঁছানো যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String get coreConnecting => 'কোরের সাথে সংযোগ হচ্ছে…';

  @override
  String get coreLost => 'কোরের সাথে সংযোগ বিচ্ছিন্ন। আবার চেষ্টা হচ্ছে…';

  @override
  String get cantReachCore => 'কোরে পৌঁছানো যাচ্ছে না';

  @override
  String get startingCore => 'কোর চালু হচ্ছে…';

  @override
  String get retry => 'আবার চেষ্টা';

  @override
  String errNoCore(String path) {
    return 'অ্যাপের পাশে কোর প্রোগ্রামটি পাওয়া যায়নি ($path)।';
  }

  @override
  String errCoreExited(String detail) {
    return 'কোর বন্ধ হয়ে গেছে: $detail';
  }

  @override
  String get errNotAnswering => 'কোর সাড়া দিচ্ছে না।';

  @override
  String get errRefused =>
      'কোর এই অ্যাপকে সংযোগ করতে দিচ্ছে না; সম্ভবত এটি অ্যাপের অন্য কোনো কপির কোর।';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get sectionGeneral => 'সাধারণ';

  @override
  String get language => 'ভাষা';

  @override
  String get languageSystem => 'সিস্টেম ডিফল্ট';

  @override
  String get theme => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get closeBehavior => 'উইন্ডো বন্ধ করার সময়';

  @override
  String get closeAsk => 'প্রতিবার জিজ্ঞেস করুন';

  @override
  String get closeTray => 'সিস্টেম ট্রে-তে লুকান';

  @override
  String get closeQuit => 'অ্যাপ বন্ধ করুন';

  @override
  String get sectionConnection => 'সংযোগ';

  @override
  String get localProxy => 'লোকাল প্রক্সি';

  @override
  String get systemProxy => 'সিস্টেম প্রক্সি';

  @override
  String get sectionRouting => 'রাউটিং';

  @override
  String get routingDirect => 'দেশি সাইটে সরাসরি সংযোগ';

  @override
  String get routingDirectHint =>
      'নির্বাচিত দেশের সাইট ও IP VPN ছাড়া সরাসরি খোলে, তাই দ্রুত লোড হয় এবং ডেটা বাঁচে।';

  @override
  String get region => 'দেশ';

  @override
  String get regionIr => 'ইরান';

  @override
  String get regionCn => 'চীন';

  @override
  String get regionRu => 'রাশিয়া';

  @override
  String get regionAf => 'আফগানিস্তান';

  @override
  String get regionTr => 'তুরস্ক';

  @override
  String get regionId => 'ইন্দোনেশিয়া';

  @override
  String get regionBr => 'ব্রাজিল';

  @override
  String get regionNone => 'কোনোটি নয়';

  @override
  String get saved => 'সেভ হয়েছে';

  @override
  String get dataFolder => 'ডেটা ফোল্ডার';

  @override
  String get openFolder => 'ফোল্ডার খুলুন';

  @override
  String get unofficialNote =>
      'এটি অফিসিয়াল ক্লায়েন্ট নয়। Mozilla-র সাথে এর কোনো সম্পর্ক নেই।';

  @override
  String get closeTitle => 'উইন্ডো বন্ধ করবেন?';

  @override
  String get closeBody =>
      'ট্রে-তে থাকলে VPN চালু থাকে। অ্যাপ বন্ধ করলে VPN-ও বন্ধ হয়ে যাবে।';

  @override
  String get rememberChoice => 'আমার পছন্দ মনে রাখুন';

  @override
  String get minimizeToTray => 'ট্রে-তে লুকান';

  @override
  String get quit => 'বেরিয়ে যান';

  @override
  String get trayOpen => 'খুলুন';

  @override
  String get trayQuit => 'বেরিয়ে যান';

  @override
  String get trayProxyOnly => 'শুধু প্রক্সি সার্ভিস';

  @override
  String get traySetSystemProxy => 'সিস্টেম প্রক্সি সেট করুন';

  @override
  String errPortInUse(String port) {
    return 'পোর্ট $port অন্য একটি প্রোগ্রাম ব্যবহার করছে, তাই অ্যাপটি তার কোরে পৌঁছাতে পারছে না।';
  }

  @override
  String proxyPortInUse(String port) {
    return 'পোর্ট $port অন্য একটি প্রোগ্রাম ব্যবহার করছে, তাই প্রক্সি চালু হতে পারছে না।';
  }

  @override
  String get changePort => 'পোর্ট বদলান';

  @override
  String get portDialogTitle => 'একটি পোর্ট বেছে নিন';

  @override
  String portDialogBody(String port) {
    return 'পোর্ট $port ব্যস্ত। নিচে একটি খালি পোর্ট দেওয়া হয়েছে; চাইলে অন্য একটি লিখতে পারেন।';
  }

  @override
  String get portChangeBody =>
      'অ্যাপগুলো এই পোর্টে সংযোগ করে। 1024 থেকে 65535-এর মধ্যে একটি বেছে নিন।';

  @override
  String get portLabel => 'পোর্ট';

  @override
  String get portInvalid => '1024 থেকে 65535-এর মধ্যে একটি পোর্ট লিখুন';

  @override
  String get portBusy => 'এই পোর্টটিও ব্যস্ত';

  @override
  String get portInUse => 'অন্য একটি প্রোগ্রাম এই পোর্ট ব্যবহার করছে';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get proxyPort => 'প্রক্সি পোর্ট';

  @override
  String get appPort => 'অ্যাপ পোর্ট';

  @override
  String get welcomeTitle => 'স্বাগতম';

  @override
  String get welcomeBody =>
      'আপনার ভাষা ও দেশ বেছে নিন। আপনার দেশের সাইটগুলো VPN ছাড়া সরাসরি খুলবে, তাই দ্রুত লোড হবে এবং ডেটা বাঁচবে।';

  @override
  String get start => 'শুরু';

  @override
  String routingSuggestTitle(String country) {
    return '$country-এর সাইট সরাসরি খুলবেন?';
  }

  @override
  String routingSuggestBody(String country) {
    return '$country-এর সাইট ও IP VPN ছাড়া সরাসরি খুলবে। পরে রাউটিং থেকে এটি বদলাতে পারবেন।';
  }

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get notNow => 'এখন নয়';

  @override
  String get navServers => 'সার্ভার';

  @override
  String get navLogs => 'লগ';

  @override
  String get realDelay => 'আসল ডিলে';

  @override
  String get statElapsed => 'সময়';

  @override
  String get statDown => 'ডাউনলোড';

  @override
  String get statUp => 'আপলোড';

  @override
  String noticePort(String port) {
    return 'Mozilla-র প্রক্সি পোর্ট $port-এ সংযোগ করে না। শুধু 80, 443, 8080 ও 8443 পোর্ট VPN দিয়ে যায়।';
  }

  @override
  String get noticeCommand => 'এই ধরনের সংযোগ VPN-এ সমর্থিত নয়।';

  @override
  String noticeTimes(int count, String time) {
    return '$count বার, শেষবার $time';
  }

  @override
  String get dismiss => 'বাদ দিন';

  @override
  String get modeRecommended => 'প্রস্তাবিত';

  @override
  String get modeFastest => 'দ্রুততম';

  @override
  String get modeRecommendedHint => 'Mozilla আপনার জন্য লোকেশন বেছে নেয়।';

  @override
  String get modeFastestHint =>
      'প্রতিবার সংযোগের সময় সবচেয়ে কম ডিলের লোকেশন।';

  @override
  String get testDelay => 'আসল ডিলে পরীক্ষা করুন';

  @override
  String get testingDelay => 'মাপা হচ্ছে…';

  @override
  String get search => 'খুঁজুন';

  @override
  String get noAnswer => 'সাড়া নেই';

  @override
  String testedAgo(String ago) {
    return '$ago পরীক্ষা করা হয়েছে';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$totalটির মধ্যে $answeredটি সাড়া দিয়েছে';
  }

  @override
  String get noServers =>
      'এখনও কোনো সার্ভার নেই। কোর Mozilla-র সাথে সংযুক্ত হলে এখানে দেখা যাবে।';

  @override
  String get levelAll => 'সব';

  @override
  String get filter => 'ফিল্টার';

  @override
  String get follow => 'স্বয়ংক্রিয় স্ক্রল';

  @override
  String get clear => 'মুছুন';

  @override
  String get copyAll => 'কপি';

  @override
  String get logsCopied => 'লগ কপি হয়েছে';

  @override
  String get noLogs => 'এখনও কোনো লগ নেই।';

  @override
  String get sectionAccounts => 'স্বয়ংক্রিয় অ্যাকাউন্ট বদল';

  @override
  String get switchThreshold => 'অ্যাকাউন্ট বদলের সীমা';

  @override
  String get switchThresholdHint =>
      'ডেটার এই অংশ খরচ হলে পরের অ্যাকাউন্টে চলে যায়।';

  @override
  String get signInMethod => 'সাইন-ইন পদ্ধতি';

  @override
  String get signInMethodBrowser => 'ব্রাউজার দিয়ে সাইন ইন';

  @override
  String get signInMethodApi => 'সরাসরি সাইন ইন';

  @override
  String get browserSignInBroken => 'সাইন-ইন পৃষ্ঠা খোলা যায়নি।';

  @override
  String get browserSignInBlocked =>
      'Mozilla অ্যাকাউন্ট যোগ করার শেষ ধাপটি সম্পন্ন করেনি (HTTP 406)।';

  @override
  String get browserSignInFallback => 'ইমেল ও পাসওয়ার্ড দিয়ে সাইন ইন';

  @override
  String get backupExport => 'ব্যাকআপ সংরক্ষণ করুন';

  @override
  String get backupImport => 'ব্যাকআপ ইমপোর্ট করুন';

  @override
  String backupSaved(String name) {
    return 'সংরক্ষিত: $name';
  }

  @override
  String get backupImportTitle => 'এই অ্যাকাউন্টগুলো যোগ করবেন?';

  @override
  String get backupAccountExists => 'আগে থেকেই আছে; ফাইল থেকে সাইন ইন হবে';

  @override
  String get backupImportAction => 'যোগ করুন';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি অ্যাকাউন্ট যোগ হয়েছে',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS সার্ভার';

  @override
  String get dnsSystem => 'সিস্টেম';

  @override
  String get dnsAuto => 'স্বয়ংক্রিয় (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'কাস্টম';

  @override
  String get dnsCustomHint =>
      'প্রতি লাইনে একটি: https://…/dns-query, tls://…, অথবা একটি IP ঠিকানা।';

  @override
  String get dnsFallback => 'প্রয়োজনে সিস্টেম DNS ব্যবহার করুন';

  @override
  String get testDns => 'DNS পরীক্ষা করুন';

  @override
  String get transport => 'প্রোটোকল';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP সংস্করণ';

  @override
  String get ipVersionAuto => 'স্বয়ংক্রিয় (প্রথমে IPv4, পরে IPv6)';

  @override
  String get ipVersionDual => 'দুটোই একসাথে (dual-stack)';

  @override
  String get ipVersionV6First => 'প্রথমে IPv6, পরে IPv4';

  @override
  String get ipVersionV4 => 'শুধু IPv4';

  @override
  String get ipVersionV6 => 'শুধু IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'VPN ইন্টারফেসের প্যাকেটের আকার, 1280 থেকে 9000। খালি: স্বয়ংক্রিয়।';

  @override
  String get tunMtuInvalid => '1280 থেকে 9000-এর মধ্যে একটি সংখ্যা, বা খালি';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'সরাসরি';

  @override
  String get directRulesHint =>
      'এই তালিকার সাইট ও ঠিকানাগুলো VPN ছাড়া, সরাসরি আপনার নিজের ইন্টারনেটে খোলে। বেছে নেওয়া দেশের নিয়মগুলো আগে থেকেই এখানে আছে: লাইন যোগ, বদল বা মুছতে পারেন। অন্য দেশ বেছে নিলে সেগুলো সেই দেশের নিয়মে বদলে যায়।';

  @override
  String get restoreRegionRules => 'দেশের নিয়ম ফিরিয়ে আনুন';

  @override
  String get blockRules => 'ব্লক';

  @override
  String get blockRulesHint =>
      'এই তালিকার সাইট ও ঠিকানাগুলো একেবারেই খোলে না, সরাসরিও না, VPN দিয়েও না: বিজ্ঞাপন বা যেসব সাইট কখনো খুলতে চান না সেগুলোর জন্য।';

  @override
  String get rulesTitle => 'নিয়ম';

  @override
  String get ruleSyntaxTitle => 'নিয়ম কীভাবে লিখবেন';

  @override
  String get resolveDomains => 'ডোমেইনেও IP নিয়ম প্রয়োগ করুন';

  @override
  String get routingLists => 'Geo ফাইল';

  @override
  String get listSource => 'তালিকার উৎস';

  @override
  String get listSourceCustom => 'কাস্টম';

  @override
  String listsUpdatedAgo(String ago) {
    return 'আপডেট হয়েছে $ago';
  }

  @override
  String get updateLists => 'Geo ফাইল আপডেট করুন';

  @override
  String get listsUpdated => 'Geo ফাইলগুলো আপডেট হয়েছে।';

  @override
  String get testDestination => 'সাইটের রুট যাচাই';

  @override
  String get destinationHint => 'সাইটের নাম, ঠিকানা বা URL';

  @override
  String get check => 'যাচাই';

  @override
  String get routeDirect => 'সরাসরি যায়';

  @override
  String get routeProxy => 'VPN দিয়ে যায়';

  @override
  String get routeBlock => 'ব্লক করা';

  @override
  String ruleMatched(String rule) {
    return 'নিয়ম: $rule';
  }

  @override
  String get portRefusedNote => 'Mozilla-র প্রক্সি এই পোর্টে সংযোগ করে না।';

  @override
  String get sectionAdvanced => 'উন্নত';

  @override
  String get tlsFragment => 'TLS ফ্র্যাগমেন্টেশন';

  @override
  String get tlsFragmentOff => 'বন্ধ';

  @override
  String get tlsFragmentFirstByte => 'প্রথম বাইট';

  @override
  String get tlsFragmentSni => 'সার্ভারের নাম (SNI)';

  @override
  String get tlsFragmentFirstByteHint => 'প্রথম বাইটে TLS হেডার ভাগ করে (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'সার্ভারের নাম (SNI) কয়েকটি TCP প্যাকেটে ভাগ করে';

  @override
  String get tlsFragmentRecord => 'TLS রেকর্ড';

  @override
  String get tlsFragmentRecordHint =>
      'সার্ভারের নাম (SNI) দুটি TLS রেকর্ডে ভাগ করে';

  @override
  String get tlsFragmentOffHint => 'সাধারণ TLS সংযোগ';

  @override
  String get sectionBypass => 'Mozilla অবরুদ্ধ থাকলে';

  @override
  String get sharedRelay => 'শেয়ার করা রিলে';

  @override
  String get sharedRelayHint =>
      'Mozilla আপনার অঞ্চল ব্লক করলে অ্যাপের শেয়ার করা রিলে ব্যবহার করুন। চালু থাকা ব্যক্তিগত রিলে অগ্রাধিকার পায়।';

  @override
  String get personalRelay => 'ব্যক্তিগত রিলে';

  @override
  String get apiRelay => 'রিলে সার্ভার';

  @override
  String get apiRelayUse => 'রিলে সার্ভার ব্যবহার করুন';

  @override
  String get apiRelayHint =>
      'আপনার নিজের Cloudflare Worker, অথবা আপনার হোস্টে relay.php।\nশুধু Mozilla সরাসরি উত্তর না দিলে ব্যবহৃত হয়: সাইন-ইন, অ্যাকাউন্ট ও সার্ভার তালিকা এর মধ্য দিয়ে যায়, VPN ট্রাফিক নয়।';

  @override
  String get upstreamProxy => 'আপস্ট্রিম প্রক্সি';

  @override
  String get upstreamProxyOn => 'আপস্ট্রিম প্রক্সি চালু আছে';

  @override
  String get upstreamProxyAddress => 'SOCKS5 প্রক্সির ঠিকানা';

  @override
  String get upstreamProxyPort => 'পোর্ট';

  @override
  String get upstreamProxyHint =>
      'Mozilla-র সংযোগ এই প্রক্সির মধ্য দিয়ে যায়; যেসব নেটওয়ার্ক Mozilla অবরুদ্ধ বা ধীর করে তাদের জন্য।\nপ্রক্সি এই ডিভাইসে চললে সেটিকে VPN-এর বাইরে রাখুন।';

  @override
  String get upstreamProxyInvalid => 'প্রক্সির ঠিকানা লিখুন, যেমন 127.0.0.1।';

  @override
  String get upstreamProxyInvalidPort =>
      '1 থেকে 65535-এর মধ্যে একটি পোর্ট লিখুন।';

  @override
  String get upstreamProxyOwn => 'এটি এই অ্যাপেরই প্রক্সি। অন্য একটি লিখুন।';

  @override
  String get apiRelayInvalid => 'একটি https:// ঠিকানা হতে হবে।';

  @override
  String get listenAddress => 'প্রক্সি অ্যাক্সেস';

  @override
  String get listenLocal => '127.0.0.1 · শুধু এই ডিভাইস';

  @override
  String get listenAll => '0.0.0.0 · সব নেটওয়ার্ক (LAN)';

  @override
  String get proxyUsername => 'প্রক্সি ইউজারনেম';

  @override
  String get proxyPassword => 'প্রক্সি পাসওয়ার্ড';

  @override
  String get proxyLoginHint =>
      'প্রক্সি ব্যবহার করতে অ্যাপগুলোকে এই ইউজারনেম ও পাসওয়ার্ড দিতে হবে। পাসওয়ার্ড ছাড়া চালাতে দুটোই খালি রাখুন।';

  @override
  String get loginBothOrNone => 'দুটোই পূরণ করুন, অথবা দুটোই খালি রাখুন।';

  @override
  String get proxyLogin => 'প্রক্সি ইউজারনেম ও পাসওয়ার্ড';

  @override
  String get idleSleep => 'কতক্ষণ নিষ্ক্রিয় থাকলে স্লিপ';

  @override
  String get sleepNever => 'কখনো না';

  @override
  String sleepMinutes(int count) {
    return '$count মিনিট';
  }

  @override
  String get sleepHour => '1 ঘণ্টা';

  @override
  String get showPublicIp => 'পাবলিক IP দেখান';

  @override
  String get hapticFeedback => 'সংযোগ বদলালে কম্পন';

  @override
  String get keepScreenOn => 'সংযুক্ত থাকলে স্ক্রিন জাগ্রত রাখো';

  @override
  String get showTraffic => 'হোম পেজে লাইভ ট্রাফিক দেখাও';

  @override
  String get speedInNotification => 'বিজ্ঞপ্তিতে গতি দেখান';

  @override
  String get liveTraffic => 'লাইভ ট্রাফিক';

  @override
  String get totalTraffic => 'মোট ট্রাফিক';

  @override
  String get verboseLogs => 'বিস্তারিত লগ';

  @override
  String get webDashboard => 'ওয়েব ড্যাশবোর্ড';

  @override
  String get webDashboardOpen => 'খুলুন';

  @override
  String get webDashboardHint => 'উন্নত সেটিংস ও আরও টুল';

  @override
  String numberInvalid(int min, int max) {
    return '$min থেকে $max-এর মধ্যে একটি সংখ্যা লিখুন';
  }

  @override
  String get notifySwitchedTitle => 'অ্যাকাউন্ট বদলানো হয়েছে';

  @override
  String notifySwitchedBody(String name) {
    return 'এখন $name ব্যবহার হচ্ছে।';
  }

  @override
  String get notifySignInTitle => 'সাইন-ইন দরকার';

  @override
  String get notifySignInBody =>
      'একটি অ্যাকাউন্টে আবার সাইন ইন করা দরকার। অ্যাকাউন্ট পাতায় যান।';

  @override
  String get navAbout => 'সম্পর্কে';

  @override
  String get appVersionLabel => 'অ্যাপ সংস্করণ';

  @override
  String get coreVersionLabel => 'কোর সংস্করণ';

  @override
  String get checkUpdates => 'আপডেট আছে কিনা দেখুন';

  @override
  String get checkingUpdates => 'যাচাই হচ্ছে…';

  @override
  String get upToDate => 'আপনার কাছে সর্বশেষ সংস্করণ আছে।';

  @override
  String updateAvailable(String version) {
    return 'সংস্করণ $version পাওয়া যাচ্ছে।';
  }

  @override
  String updateRequired(String version) {
    return 'অনুগ্রহ করে $version সংস্করণে আপডেট করুন। এই আপডেটটি প্রয়োজন।';
  }

  @override
  String get download => 'ডাউনলোড';

  @override
  String updateCheckFailed(String error) {
    return 'আপডেট যাচাই করা যায়নি: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'GitHub-এ পৌঁছানো যায়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get updateNow => 'আপডেট করুন';

  @override
  String updateDownloading(String version) {
    return 'সংস্করণ $version ডাউনলোড হচ্ছে…';
  }

  @override
  String updateReady(String version) {
    return 'সংস্করণ $version ইনস্টলের জন্য প্রস্তুত।';
  }

  @override
  String updateInstalling(String version) {
    return 'সংস্করণ $version ইনস্টল হচ্ছে। অ্যাপটি বন্ধ হয়ে আবার খুলবে।';
  }

  @override
  String updateFailed(String version) {
    return 'সংস্করণ $version-এ আপডেট করা গেল না।';
  }

  @override
  String updateDone(String version) {
    return 'সংস্করণ $version-এ আপডেট হয়েছে।';
  }

  @override
  String updateRolledBack(String version) {
    return 'সংস্করণ $version-এ আপডেট শেষ হয়নি, তাই অ্যাপটি আগের সংস্করণে ফিরে গেছে।';
  }

  @override
  String get repoNotSet => 'GitHub রিপোজিটরি এখনও সেট করা হয়নি।';

  @override
  String get sourceCode => 'সোর্স কোড';

  @override
  String get tapToConnect => 'সংযোগ করতে ক্লিক করুন';

  @override
  String get tapToDisconnect => 'সংযোগ বিচ্ছিন্ন করতে ক্লিক করুন';

  @override
  String get startOnBoot => 'সিস্টেম চালু হলে শুরু করুন';

  @override
  String get connectOnStartup => 'চালু হলে স্বয়ংক্রিয়ভাবে সংযোগ করুন';

  @override
  String get proxyServiceActive => 'প্রক্সি সার্ভিস চালু আছে';

  @override
  String get navHome => 'হোম';

  @override
  String get groupApp => 'অ্যাপ';

  @override
  String get groupNetwork => 'নেটওয়ার্ক';

  @override
  String get stateOff => 'সংযোগ বিচ্ছিন্ন';

  @override
  String get tapToConnectPhone => 'সংযোগ করতে ট্যাপ করুন';

  @override
  String get tapToDisconnectPhone => 'সংযোগ বিচ্ছিন্ন করতে ট্যাপ করুন';

  @override
  String get tapToConnectTv => 'সংযোগ করতে OK চাপুন';

  @override
  String get tapToDisconnectTv => 'সংযোগ বিচ্ছিন্ন করতে OK চাপুন';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'প্রস্তাবিত লোকেশন';

  @override
  String dataLeftOf(String limit) {
    return '$limit-এর মধ্যে';
  }

  @override
  String get homeLocation => 'লোকেশন';

  @override
  String get connectedTo => 'সংযুক্ত:';

  @override
  String get vpnNotAllowed =>
      'VPN-এর জন্য আপনার অনুমতি দরকার। বোতামটি আবার ট্যাপ করে অনুমতি দিন।';

  @override
  String get dataUsedTitle => 'ব্যবহৃত ডেটা';

  @override
  String get bypassApps => 'অ্যাপভিত্তিক প্রক্সি';

  @override
  String get connectRetrying => 'সংযোগ করা যায়নি। ইন্টারনেট পরীক্ষা করুন।';

  @override
  String get failUnreachable =>
      'Mozilla-র সার্ভারে পৌঁছানো যায়নি। অন্য ইন্টারনেট সংযোগ ব্যবহার করে দেখুন।';

  @override
  String get failUpstreamProxy =>
      'আপস্ট্রিম প্রক্সির মাধ্যমে Mozilla-য় পৌঁছানো যায়নি। প্রক্সিটি চালু আছে কি না দেখুন।';

  @override
  String get failInsideVpn =>
      'এই ইন্টারনেট আগে থেকেই একটি VPN দিয়ে যায়। সেটি বন্ধ করুন।';

  @override
  String get failRefused =>
      'Mozilla-র সার্ভার সংযোগ প্রত্যাখ্যান করেছে। কয়েক মিনিট পরে আবার চেষ্টা করুন।';

  @override
  String get failLocationRefused =>
      'এই দেশটি আপনার অ্যাকাউন্টের জন্য খোলা নয়। অন্য দেশ বেছে নিন।';

  @override
  String get useRecommendedLocation => 'প্রস্তাবিত লোকেশন ব্যবহার করুন';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'আপনি $chosen বেছে নিয়েছেন, কিন্তু আপনার IP-র দেশ: $exit।';
  }

  @override
  String get failSignIn =>
      'এই অ্যাকাউন্টের সাইন-ইনের মেয়াদ শেষ। অ্যাকাউন্ট পাতা থেকে আবার সাইন ইন করুন।';

  @override
  String get failQuota => 'এই মাসের ডেটা শেষ। আরেকটি অ্যাকাউন্ট যোগ করুন।';

  @override
  String get failNotEntitled =>
      'Mozilla এই অ্যাকাউন্টকে VPN ব্যবহার করতে দেয় না। আরেকটি অ্যাকাউন্ট যোগ করুন।';

  @override
  String get failRegion => 'আপনার দেশে Mozilla তার পরিষেবা দেয় না।';

  @override
  String get failServer =>
      'Mozilla-র পরিষেবায় সাময়িক সমস্যা হয়েছে। অ্যাপ নিজেই আবার চেষ্টা করবে।';

  @override
  String get failNoAccount =>
      'কোনো অ্যাকাউন্ট প্রস্তুত নেই। অ্যাকাউন্ট পাতা খুলুন।';

  @override
  String get failTestSite =>
      'সার্ভারে সংযুক্ত হয়েছে, কিন্তু সাইট খুলছে না। অন্য দেশ চেষ্টা করুন।';

  @override
  String get failOther => 'সংযোগ করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get failNoInternet =>
      'ইন্টারনেট নেই। Wi-Fi বা মোবাইল ডেটা পরীক্ষা করুন।';

  @override
  String get waitingForNetwork => 'ইন্টারনেট সংযোগের অপেক্ষায়…';

  @override
  String proxyStartFailed(String port) {
    return 'পোর্ট $port-এ প্রক্সি চালু হয়নি। অন্য একটি পোর্ট বেছে নিন।';
  }

  @override
  String get connectionSettings => 'সংযোগ সেটিংস';

  @override
  String get appModeExclude => 'নির্বাচিত অ্যাপ VPN ছাড়া';

  @override
  String get appModeInclude => 'শুধু নির্বাচিত অ্যাপ VPN-এ';

  @override
  String get appModeExcludeHint =>
      'নির্বাচিত অ্যাপগুলো VPN ছাড়া সরাসরি সংযোগ করে: যেমন বিদেশি ঠিকানা প্রত্যাখ্যান করে এমন ব্যাংকিং অ্যাপ।';

  @override
  String get appModeIncludeHint =>
      'শুধু নির্বাচিত অ্যাপগুলো VPN দিয়ে যায়; বাকিগুলো সরাসরি সংযোগ করে।';

  @override
  String fromRegionList(String region) {
    return 'প্রস্তাবিত: $region-এর তালিকায় আছে';
  }

  @override
  String get modeProxy => 'প্রক্সি';

  @override
  String get connectionMode => 'সংযোগ মোড';

  @override
  String get modeProxyHint =>
      'শুধু যেসব অ্যাপে প্রক্সি সেট করা আছে সেগুলোই এর মধ্য দিয়ে যায়।';

  @override
  String get modeSystemProxyHint =>
      'Windows ও বেশিরভাগ অ্যাপ প্রক্সি দিয়ে যায়।';

  @override
  String get modeSystemProxyHintOther =>
      'ব্রাউজার ও বেশিরভাগ অ্যাপ প্রক্সি দিয়ে যায়।';

  @override
  String get suggestedApps => 'প্রস্তাবিত অ্যাপ';

  @override
  String get showSystemApps => 'সিস্টেম অ্যাপ দেখান';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি প্রস্তাবিত অ্যাপ নির্বাচিত',
      one: '1টি প্রস্তাবিত অ্যাপ নির্বাচিত',
      zero: 'প্রস্তাবিত অ্যাপগুলো আগেই নির্বাচিত',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'স্বয়ংক্রিয়';

  @override
  String get locationsSection => 'লোকেশন';

  @override
  String get dnsSummaryOk => 'এনক্রিপ্টেড DNS কাজ করছে';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি নাম রিজলভ হয়নি',
      one: '1টি নাম রিজলভ হয়নি',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return '$server দিয়ে';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'আপনার নেটওয়ার্কের DNS $countটি নামের জন্য একটি ফিল্টারিং ঠিকানা দিয়েছে। এই অ্যাপ সেই উত্তরগুলো ব্যবহার করে না।',
      one: 'আপনার নেটওয়ার্কের DNS 1টি নামের জন্য একটি ফিল্টারিং ঠিকানা দিয়েছে। এই অ্যাপ সেই উত্তর ব্যবহার করে না।',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'উত্তর:';

  @override
  String get dnsNetworkAnswer => 'নেটওয়ার্ক DNS:';

  @override
  String get dnsFiltered => 'ফিল্টার করা';

  @override
  String get rulesSyntaxTitle => 'প্রতি লাইনে একটি নিয়ম';

  @override
  String get ruleDomain => 'সাইট ও এর সাবডোমেইন';

  @override
  String get ruleFull => 'ঠিক এই নামটি';

  @override
  String get ruleKeyword => 'যেসব নামে শব্দটি আছে';

  @override
  String get ruleGeosite => 'Geo ফাইলের একটি ট্যাগের সাইট';

  @override
  String get ruleGeoip => 'Geo ফাইলে থাকা একটি দেশের ঠিকানা';

  @override
  String get ruleIp => 'একটি ঠিকানা বা নেটওয়ার্ক';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'শুধু প্রক্সি';

  @override
  String get noNetwork =>
      'ইন্টারনেট সংযোগ নেই। Wi-Fi বা মোবাইল ডেটা চালু করুন।';

  @override
  String get blockAds => 'বিজ্ঞাপন ব্লক করুন';

  @override
  String systemProxyTakenBy(String address) {
    return 'অন্য একটি প্রোগ্রাম সিস্টেম প্রক্সি $address-এ বদলে দিয়েছে, তাই ট্রাফিক VPN দিয়ে যাচ্ছে না।';
  }

  @override
  String get systemProxyTakenOff =>
      'অন্য একটি প্রোগ্রাম সিস্টেম প্রক্সি বন্ধ করে দিয়েছে, তাই ট্রাফিক VPN দিয়ে যাচ্ছে না।';

  @override
  String get setSystemProxyAgain => 'আবার সেট করুন';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return '$os-এর সব ট্রাফিক VPN দিয়ে যায়।';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting => 'TUN সার্ভিস ইনস্টল করার অনুমতির অপেক্ষা…';

  @override
  String get tunInstallCancelled =>
      'TUN মোডের জন্য একবার অ্যাডমিনিস্ট্রেটর অনুমতি লাগে। অনুমতি দেওয়া হয়নি, তাই মোড বদলায়নি।';

  @override
  String tunInstallFailed(String error) {
    return 'TUN সার্ভিস ইনস্টল করা যায়নি: $error';
  }

  @override
  String get tunStarting => 'TUN মোড চালু হচ্ছে…';

  @override
  String get tunFailed => 'TUN মোড চালু হয়নি। আবার চেষ্টা করা হচ্ছে…';

  @override
  String get tunLost => 'TUN মোড হঠাৎ বন্ধ হয়ে গেছে। আবার চেষ্টা করা হচ্ছে…';

  @override
  String get tunNotRunning => 'TUN সার্ভিস চলছে না। আবার চেষ্টা করা হচ্ছে…';

  @override
  String get tunMissing => 'TUN সার্ভিস ইনস্টল করা নেই।';

  @override
  String get tunOutdated =>
      'TUN সার্ভিস এই অ্যাপের চেয়ে পুরোনো। TUN মোড ব্যবহার করতে এটি আবার ইনস্টল করুন।';

  @override
  String get tunAppOutdated =>
      'TUN সার্ভিস এই অ্যাপের চেয়ে নতুন। TUN মোড ব্যবহার করতে অ্যাপটি আপডেট করুন।';

  @override
  String get tunBusy => 'Homa VPN-এর অন্য একটি কপি TUN মোড ব্যবহার করছে।';

  @override
  String get tunNoDriver =>
      'সিস্টেমের TUN ড্রাইভার পাওয়া যাচ্ছে না। কম্পিউটার রিস্টার্ট করে আবার চেষ্টা করুন।';

  @override
  String get tunInstall => 'ইনস্টল করুন';

  @override
  String get tunInstallAgain => 'আবার ইনস্টল করুন';

  @override
  String get trayTunMode => 'TUN মোড (সব অ্যাপ)';

  @override
  String get removeTunService => 'TUN সার্ভিস সরান';

  @override
  String get removeTunServiceHint =>
      'TUN মোড যে সিস্টেম সার্ভিস ব্যবহার করে তা সরিয়ে দেয়। আবার TUN বেছে নিলে এটি আবার ইনস্টল হয়।';

  @override
  String get tunServiceRemoved => 'TUN সার্ভিস সরানো হয়েছে।';

  @override
  String get tunInstallPrompt =>
      'Homa VPN TUN মোডের জন্য সার্ভিসটি ইনস্টল করতে চায়।';

  @override
  String get tunRemovePrompt => 'Homa VPN TUN মোডের সার্ভিসটি সরাতে চায়।';

  @override
  String tunRemoveFailed(String error) {
    return 'TUN সার্ভিস সরানো যায়নি: $error';
  }

  @override
  String get sectionTun => 'TUN সেটিংস';

  @override
  String get tunPrograms => 'VPN এড়িয়ে চলা প্রোগ্রাম';

  @override
  String get tunProgramsHint =>
      'এগুলো Mozilla দিয়ে নয়, সরাসরি সংযোগ করে। শুধু VPN ছাড়া চলে এমন প্রোগ্রামের জন্য।';

  @override
  String get tunProgramsEmpty => 'এখনও কোনো প্রোগ্রাম নেই।';

  @override
  String get addProgram => 'প্রোগ্রাম যোগ করুন';

  @override
  String get programFiles => 'প্রোগ্রাম';

  @override
  String get tunProgramAll => 'সব ট্রাফিক';

  @override
  String get tunProgramAllHint => 'পুরো প্রোগ্রাম সরাসরি সংযোগ করে।';

  @override
  String get tunProgramUdp => 'শুধু UDP';

  @override
  String get tunProgramUdpHint => 'শুধু এর UDP সরাসরি যায়; বাকিটা VPN দিয়ে।';

  @override
  String get udpNoticeSetting => 'আটকে যাওয়া UDP-র নোটিশ';

  @override
  String udpNoticeBody(String program) {
    return '$program-এর UDP ট্রাফিক VPN দিয়ে যায় না।';
  }

  @override
  String get dontShowAgain => 'আর দেখাবেন না';

  @override
  String get addRunningProgram => 'চলমান প্রোগ্রাম থেকে';

  @override
  String get addProgramFile => 'ফাইল বেছে নিন…';

  @override
  String get addProgramName => 'নাম লিখুন…';

  @override
  String get programNameHint =>
      'প্রোগ্রামের ফাইলের নাম, যেমন steam.exe; * মানে যেকোনো লেখা (steam* মানে Steam-এর সব প্রোগ্রাম)।';

  @override
  String get runningProgramsEmpty => 'আর কোনো প্রোগ্রাম চলছে না।';

  @override
  String get tabLog => 'লগ';

  @override
  String get tabConnections => 'সংযোগ';

  @override
  String get connectionsEmpty => 'এখনও কোনো সংযোগ নেই।';

  @override
  String connectionsOpen(int count) {
    return '$countটি খোলা';
  }

  @override
  String get connTime => 'সময়';

  @override
  String get connRoute => 'নিয়ম';

  @override
  String get connDestination => 'গন্তব্য';

  @override
  String get connInbound => 'ইনবাউন্ড';

  @override
  String get connProtocol => 'প্রোটোকল';

  @override
  String get connColumns => 'কলাম';

  @override
  String get connTraffic => 'ট্রাফিক';

  @override
  String get connDuration => 'সময়কাল';

  @override
  String get connRouteVpn => 'প্রক্সি';

  @override
  String get connRouteDirect => 'সরাসরি';

  @override
  String get connRouteBlocked => 'অবরুদ্ধ';

  @override
  String get connRoutePort => 'পোর্ট প্রত্যাখ্যাত';

  @override
  String get connRouteFailed => 'ব্যর্থ';

  @override
  String get testRelay => 'রিলের অবস্থা পরীক্ষা';

  @override
  String get relayTestTitle => 'রিলের অবস্থা পরীক্ষা';

  @override
  String get relayTestHint =>
      'শুধু রিলে পরীক্ষা করা হয়। Mozilla-তে কোনো অনুরোধ বা অ্যাকাউন্টের তথ্য পাঠানো হয় না।';

  @override
  String get relayTestPassed => 'রিলে প্রস্তুত';

  @override
  String get relayTestFailed => 'রিলের অবস্থা নিশ্চিত করা যায়নি';

  @override
  String get relayTestCopy => 'রিপোর্ট কপি করুন';

  @override
  String get relayTestInterrupted =>
      'সম্পূর্ণ ফলাফল পাওয়ার আগে পরীক্ষা শেষ হয়েছে।';

  @override
  String get searchLocations => 'লোকেশন খুঁজুন';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি লোকেশন',
      one: '১টি লোকেশন',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'স্বয়ংক্রিয় আপডেট';

  @override
  String get autoInstallApkHint =>
      'নতুন সংস্করণ নিজে নিজে ডাউনলোড হয়; ইনস্টল করার আগে ইনস্টলার জিজ্ঞেস করে।';

  @override
  String get installNow => 'ইনস্টল করুন';

  @override
  String get updateAllowInstall =>
      'আপডেট ইনস্টল করতে এই অ্যাপকে অ্যাপ ইনস্টলের অনুমতি দিন।';

  @override
  String get allowInstall => 'অনুমতি দিন';

  @override
  String get noResults => 'কোনো লোকেশন খোঁজার সঙ্গে মেলে না।';

  @override
  String get accentColor => 'অ্যাকসেন্ট রং';

  @override
  String get accentMono => 'একবর্ণা (ডিফল্ট)';

  @override
  String get accentCustom => 'নিজের রং';

  @override
  String get accentEmber => 'অঙ্গার';

  @override
  String get accentGold => 'সোনালি';

  @override
  String get accentEmerald => 'পান্না';

  @override
  String get accentSapphire => 'নীলমণি';

  @override
  String get accentAmethyst => 'অ্যামেথিস্ট';

  @override
  String get accentRose => 'গোলাপি';

  @override
  String get autoReconnect => 'স্বয়ংক্রিয় পুনরায় সংযোগ';

  @override
  String get autoReconnectHint =>
      'আপনার অনুরোধ ছাড়া সংযোগ ছিঁড়ে গেলে নিজে থেকেই ফিরিয়ে আনে।';

  @override
  String get androidOnlyHint => 'শুধু ফোনে।';

  @override
  String get idleDisconnect => 'অলস অবস্থায় বিচ্ছিন্ন করুন';

  @override
  String get idleDisconnectHint =>
      'কিছুক্ষণ কোনো ট্রাফিক না গেলে সেশন শেষ করে।';

  @override
  String get idleTimeout => 'অলস সময়সীমা';

  @override
  String get minutes5 => '৫ মিনিট';

  @override
  String get minutes10 => '১০ মিনিট';

  @override
  String get minutes15 => '১৫ মিনিট';

  @override
  String get minutes30 => '৩০ মিনিট';

  @override
  String get minutes60 => '১ ঘণ্টা';

  @override
  String get dataLimit => 'সেশন ডেটা সীমা';

  @override
  String get dataLimitHint => 'ট্রাফিক সীমায় পৌঁছালে সেশন শেষ করে।';

  @override
  String get dataLimitAmount => 'সীমা';

  @override
  String get mb256 => '২৫৬ এমবি';

  @override
  String get mb512 => '৫১২ এমবি';

  @override
  String get mb1024 => '১ জিবি';

  @override
  String get mb2048 => '২ জিবি';

  @override
  String get mb5120 => '৫ জিবি';

  @override
  String get mb10240 => '১০ জিবি';

  @override
  String autoStoppedIdle(int minutes) {
    return '$minutes মিনিট কোনো ট্রাফিক যায়নি, তাই সংযোগ বিচ্ছিন্ন হয়েছে।';
  }

  @override
  String autoStoppedData(int mb) {
    return 'সেশন তার $mb এমবি ডেটা সীমায় পৌঁছেছে, তাই সংযোগ বিচ্ছিন্ন হয়েছে।';
  }

  @override
  String get protection => 'সুরক্ষা';

  @override
  String get killSwitch => 'কিল সুইচ';

  @override
  String get killSwitchHint =>
      'ভিপিএন বিচ্ছিন্ন হলে ট্রাফিক আটকে রাখা হয় — কোনো ফাঁস নেই — পুনঃসংযোগ পর্যন্ত।';

  @override
  String get alwaysOnVpn => 'সর্বদা চালু VPN';

  @override
  String get alwaysOnVpnHint =>
      'অ্যান্ড্রয়েডের নিজস্ব প্রহরী: VPN ছাড়া কোনো সংযোগ যায় না।';

  @override
  String get floatingIsland => 'ভাসমান দ্বীপ';

  @override
  String get floatingIslandHint =>
      'অ্যাপের বাইরে থাকলে অন্য অ্যাপের ওপর সংযোগের অবস্থা দেখায়।';

  @override
  String whatsNewTitle(String version) {
    return 'সংস্করণ $version-এ নতুন কী';
  }

  @override
  String get whatsNewContinue => 'বুঝেছি';

  @override
  String get whatsNewMenu => 'নতুন কী আছে';

  @override
  String get whatsNewView => 'আবার দেখুন';

  @override
  String get updateServers => 'সার্ভার আপডেট করুন';

  @override
  String get updatingServers => 'আপডেট হচ্ছে…';

  @override
  String serversUpdated(int count) {
    return 'মোজিলার অফিসিয়াল তালিকা থেকে $countটি অবস্থান';
  }

  @override
  String get serversUpdateFailed =>
      'সার্ভার তালিকা আপডেট করা যায়নি; আগের তালিকা রাখা হয়েছে।';

  @override
  String get smartPickTitle => 'এখনকার দ্রুততম';

  @override
  String get smartPickUse => 'ব্যবহার করুন';

  @override
  String get connectAtBoot => 'ফোন চালু হলে সংযোগ করুন';

  @override
  String get connectAtBootHint =>
      'ফোন চালু হলে নিজেই সংযোগ করে, VPN-এর অনুমতি আগেই দেওয়া থাকলে।';

  @override
  String get gamingProfile => 'গেমিং প্রোফাইল';

  @override
  String get gamingProfileHint =>
      'সংযোগের সরাসরি বিলম্ব আর মান দেখায়; মাপা সবচেয়ে দ্রুত সার্ভারের সাথে চলে।';

  @override
  String get diagnosticsRun => 'ডায়াগনস্টিক চালান';

  @override
  String get diagnosticsHint => 'সংযোগ, DNS আর টানেল, এক টোকায় পরীক্ষা';

  @override
  String get diagnosticsTunnel => 'টানেল';

  @override
  String get diagnosticsTunnelUp => 'চালু এবং ট্রাফিক বহন করছে';

  @override
  String get diagnosticsTunnelDown => 'বন্ধ';

  @override
  String get diagnosticsExit => 'প্রস্থান দেশ';

  @override
  String get diagnosticsMismatch => 'প্রস্থান নির্বাচন থেকে আলাদা';

  @override
  String get diagnosticsConnection => 'সংযোগ পরীক্ষা';

  @override
  String get diagnosticsPassed => 'সফল';

  @override
  String get diagnosticsFailed => 'ব্যর্থ';

  @override
  String get diagnosticsDnsFiltered => 'অবরুদ্ধ বা ফিল্টার করা উত্তর';

  @override
  String get diagnosticsDnsOk => 'উত্তর দিয়েছে';

  @override
  String get diagnosticsPrivacy =>
      'এখানে কিছুই জমা হয় না; ফলাফল এই জানালায় আর কোরের নিজের লগে থাকে।';

  @override
  String get diagnosticsAgain => 'আবার চালাও';

  @override
  String get whatsNewAdded => 'নতুন';

  @override
  String get whatsNewImproved => 'উন্নতি';

  @override
  String get whatsNewFixed => 'সংশোধন';

  @override
  String get wnWheelImproved =>
      'দেশের চাকা নতুন করে আঁকা হয়েছে: নির্বাচিত পতাকা কাচের ফ্রেমে, হালকা আভা ও পেছনে নরম আলোর হালোসহ বড় দেখায়, বাকি পতাকাগুলো গভীরতাসহ ছোট থাকে, আর নিচের নামটি মসৃণ স্লাইডে আসে।';

  @override
  String get wnLiveImproved =>
      'সংযুক্ত থাকাকালীন নোটিফিকেশন অ্যান্ড্রয়েড ১৬-কে রেফারেন্স বাস্তবায়নের মতোই Live Update হিসেবে প্রমোট করতে বলে; সময় নিজে গোনে, গতি চলতে থাকে।';

  @override
  String get wnL10nFixed =>
      'এই পেজ এখন অ্যাপের ভাষায় কথা বলে — এর পনেরোটি ভাষার প্রতিটিতে, শুধু ইংরেজিতে নয়।';

  @override
  String get wnMarkFixed =>
      'মোজিলার মার্ক তার টাইলে পরিষ্কারভাবে বসে আছে, পতাকার মতো গোল কোণায়।';

  @override
  String get designTitle => 'হোম পেজের নকশা';

  @override
  String get designHint => 'হোম পেজ কীভাবে সাজানো থাকে';

  @override
  String get designWheel => 'চাকা';

  @override
  String get designWheelDesc => 'কাচের চাকায় পতাকা, নিচে সুইচ';

  @override
  String get designBento => 'বেন্টো';

  @override
  String get designBentoDesc =>
      'বেন্টো বক্সের নিজের ডিজাইন: টালির বোর্ডে পতাকা, সংযোগের টালি, সংখ্যা ও স্থান — এক উষ্ণ বাক্সের টালি হয়ে';

  @override
  String get designPixel => 'Material You';

  @override
  String get designPixelDesc =>
      'Material You: টোনাল সারফেস, বড় ভরাট কার্ড, পিল-ইন্ডিকেটর বার ও বড় শিরোনাম — অ্যান্ড্রয়েডের নিজের কণ্ঠ';

  @override
  String get notifFlag => 'নোটিফিকেশনে দেশের পতাকা';

  @override
  String get notifFlagHint => 'দেশের নিজের পতাকা নামের পাশে';

  @override
  String get wnDesignAdded => 'হোম ডিজাইন সেটিং: চাকা, টালি বা কমপ্যাক্ট কার্ড';

  @override
  String get wnMapAdded =>
      'হোম পেজের পেছনে সত্যিকারের ভেক্টর বিশ্বমানচিত্র, বাছাই দেশ আলোকিত';

  @override
  String get wnWheelAdded =>
      'পতাকার চাকা নতুন আঁকা: গভীর কাচ, মসৃণ গতি, বেশি গভীরতা';

  @override
  String get wnFlagNotifAdded =>
      'নোটিফিকেশন দেশের SVG পতাকা দেখাতে পারে, বন্ধও করা যায়';

  @override
  String get wnColorRemoved =>
      'কাস্টম রঙের পেজ সরানো হয়েছে; অ্যাকসেন্ট তালিকায় HEX কোড আছে';

  @override
  String get whatsNewRemoved => 'সরানো হয়েছে';

  @override
  String get wnCrashFixed =>
      'অ্যাপ আর অ্যান্ড্রয়েড ১৬ ফোনে নিজে থেকে বন্ধ হয় না: বিজ্ঞপ্তি ফোনে যা এখনো ছিল না তা চেয়েছিল।';

  @override
  String get wnFlagArtFixed =>
      'অ্যাপ আর খুলতেই নিজে থেকে বন্ধ হয় না: বিজ্ঞপ্তির পতাকার ছবি এমন একটি মান পাঠাত যা সিস্টেমের বার্তাবাহক গ্রহণ করত না।';

  @override
  String get statSession => 'সেশন';

  @override
  String get copiedToClipboard => 'ক্লিপবোর্ডে কপি হয়েছে';

  @override
  String get wnTotalsAdded =>
      'হোম পাতা সেশনে মোট কত ডেটা গেল তা দেখায়, আর এক ট্যাপে পাবলিক আইপি কপি হয়।';

  @override
  String get wnPolishImproved =>
      'পতাকার চাকা ও সার্ভার পাতা আরও গোছানো; লেখা সংক্ষিপ্ত, আর Android টানেল বেশি গতিতে ট্রাফিক বহন করে।';

  @override
  String get valueSmart => 'স্মার্ট';

  @override
  String get wnSmartAdded =>
      'স্মার্ট সংযোগ: MTU, প্রোটোকল ও IP সংস্করণ নেটওয়ার্ক অনুযায়ী, সত্যিকারের প্রতিক্রিয়া দেখে গতির জন্য বেছে নেওয়া হয়।';

  @override
  String get wnToastAdded =>
      'নিশ্চিতকরণ এখন নরম iOS-স্টাইল বার্তায় আসে, যেখানে নিজেকে আঁকা একটি চিহ্ন থাকে।';

  @override
  String get wnFlagsImproved =>
      'পতাকার চাকা পরিষ্কার বসে: স্ক্রিনের ধারে কোনো পতাকা কাটা যায় না, পতাকা সম্পূর্ণ দেখা যায়, আর নির্বাচন নরমভাবে বসে।';

  @override
  String get wnMapImproved =>
      'বিশ্ব মানচিত্র এখন বড় ও স্পষ্ট: চাপা মহাদেশ নেই, মসৃণ উপকূলরেখা, আর অ্যাঙ্করে উজ্জ্বল হ্যালো।';

  @override
  String get dnsManual => 'ম্যানুয়াল DNS';

  @override
  String get dnsManualHint =>
      'প্রতি লাইনে একটি ঠিকানা: সাধারণ IP, https:// (DNS over HTTPS), বা tls://host (DNS over TLS)। প্রথম উত্তরই জেতে।';

  @override
  String get dnsManualInvalid =>
      'একটি লাইন কোর ব্যবহার করতে পারে এমন ঠিকানা নয়: সাধারণ IP, https://…, বা tls://host।';

  @override
  String get killSwitchGuarded =>
      'সুরক্ষিত: টানেল বন্ধ থাকলাকালীন ফোন থেকে কিছুই বেরোয় না।';

  @override
  String get accountsUsageTitle => 'এই মাস';

  @override
  String get accountsCountLabel => 'অ্যাকাউন্ট';

  @override
  String get accountsUsageAverage => 'অ্যাকাউন্টগুলোর ব্যবহৃত অংশের গড়';

  @override
  String get wnDesignsAdded =>
      'অ্যাপ ডিজাইন: পুরো অ্যাপ এখন সফট নিউমরফিজম বা অরোরা গ্লাস পরতে পারে — প্রতিটি পাতা, প্রতিটি কার্ড — সেটিংস → সাধারণ থেকে।';

  @override
  String get wnWheelFixed =>
      'চাকার অর্ধেক পতাকা চলে গেছে: নির্বাচিত পতাকার নিচের তাকটি আলোর পুকুর, দ্বিতীয় পতাকা নয়, আর স্ক্রিনের ধারে কোনো পতাকা কাটা যায় না।';

  @override
  String get wnMapReal =>
      'বিশ্ব মানচিত্র দেশের সরকারি সীমানা থেকে নতুন করে আঁকা — প্রতিটি উপকূল, দ্বীপ ও এনক্লেভ, সত্যিকারের অনুপাতে।';

  @override
  String get wnGlobeAdded =>
      'পৃথিবী এখন গোলক: রুপালি গোলকটি নির্বাচিত দেশের দিকে ঘোরে, উজ্জ্বল পিন ও ভাসমান কার্ড তা চিহ্নিত করে, সংযোগের পথ হাবগুলির দিকে যায়।';

  @override
  String get wnWheelGlowImproved =>
      'নির্বাচিত পতাকা নিজের নীল আভাসহ কাচের ফ্রেমে বড় হয়ে দাঁড়ায়, পাশেরগুলি স্পষ্টভাবে ছোট, আর চাকার নিচের নির্দেশকগুলি আপনার অবস্থান দেখায়।';

  @override
  String get wnDesignsRemoved =>
      'অ্যাপ ডিজাইন নির্বাচক সরানো হয়েছে: অ্যাপ আবার নিজের একরঙা চেহারা পরে — আপনার অ্যাকসেন্ট ও থিম আগের মতোই আছে।';

  @override
  String get wnDnsAdded =>
      'ম্যানুয়াল DNS: সাধারণ IP, DNS over HTTPS, ও DNS over TLS — লেখার সময়ই প্রতিটি লাইনের ধরন দেখানো ও যাচাই হয়।';

  @override
  String get wnSmartImproved =>
      'স্মার্ট সংযোগ এখন দেখায় নেটওয়ার্ক কী উত্তর দিয়েছে: এটি কোন ট্রান্সপোর্ট বেছে নিয়েছে ও কোন IP সংস্করণ ধরে রেখেছে, সরাসরি।';

  @override
  String get wnProtectionImproved =>
      'কিল সুইচ তার প্রহরা দাঁড়ালে জানায়, আর অ্যাপ পাতায় দেখা যায় কতটি অ্যাপ বেছেছেন।';

  @override
  String get wnWelcomeImproved =>
      'স্বাগত পাতা ভাসমান অরোরার ওপর নিঃশ্বাস নেওয়া ঢাল নিয়ে খোলে, আর অ্যাকাউন্ট পাতা মাসটি এক নজরে সারসংক্ষেপ করে।';

  @override
  String bypassAppsCount(String n) {
    return 'নির্বাচিত: $n';
  }

  @override
  String get sectionAppearance => 'চেহারা';

  @override
  String get mapStyle => 'মানচিত্রের ধরন';

  @override
  String get mapStyleHint =>
      'হোম পেজের গ্লোব আপনার পছন্দ অনুযায়ী রঙিন হয়। সংযোগের আলো অপরিবর্তিত থাকে।';

  @override
  String get mapSilver => 'রুপোলি';

  @override
  String get mapMidnight => 'মধ্যরাত';

  @override
  String get mapOcean => 'মহাসাগর';

  @override
  String get mapMono => 'এক রঙ';

  @override
  String get mapAurora => 'আরোরা';

  @override
  String get batterySaver => 'ব্যাটারি সাশ্রয়';

  @override
  String get batterySaverHint =>
      'সংযুক্ত থাকাকালীন মানচিত্রের গতি স্থির করে — গ্লোবের নিঃশ্বাস, চাকার ঝলক। সংযোগ নিজে ঠিক আগের মতোই থাকে।';

  @override
  String get connectOnOpen => 'অ্যাপ খুললেই সংযোগ';

  @override
  String get connectOnOpenHint =>
      'অ্যাপ খোলার সাথে সাথে VPN চালু করে, আপনার শেষ বেছে নেওয়া লোকেশনে।';

  @override
  String get speedTitle => 'গতি';

  @override
  String get parallelTunnels => 'সমান্তরাল টানেল';

  @override
  String get parallelTunnelsHint =>
      'একসাথে Mozilla-তে কয়েকটি টানেল খোলে এবং ট্রাফিক তাদের মধ্যে ভাগ করে, ফলে একটি ধীর টানেল আর গতি সীমিত করে না। আটটি ব্যাটারির জন্য সবচেয়ে ভারী।';

  @override
  String get tunnels1 => 'একটি — সবচেয়ে স্থিতিশীল';

  @override
  String get tunnels2 => 'দুটি';

  @override
  String get tunnels4 => 'চারটি — ধীর নেটওয়ার্কে দ্রুততর';

  @override
  String get tunnels8 => 'আটটি — দ্রুততম';

  @override
  String get connectionCap => 'সংযোগের সীমা';

  @override
  String get connectionCapHint =>
      'একসাথে কতগুলি অ্যাপ VPN দিয়ে কথা বলতে পারে; ছোট সীমা ব্যস্ত ফোনে ব্যাটারি ও ডেটা বাঁচায়। সীমাহীনই ডিফল্ট।';

  @override
  String get capNone => 'সীমা নেই';

  @override
  String get verboseLogging => 'বিস্তারিত নির্ণয়';

  @override
  String get verboseLoggingHint =>
      'প্রতিটি ধাপ লগে লেখে — সমস্যা জানাতে সহায়ক, ব্যাটারিতে সামান্য বেশি ভারী।';

  @override
  String get wn38MapStylesAdded =>
      'মানচিত্রের পাঁচটি রূপ: রুপোলি, মধ্যরাত, মহাসাগর, এক রঙ এবং আরোরা — সেটিংসের নতুন চেহারা পেজ বেছে নেয়, প্রতিটির প্রিভিউ সহ।';

  @override
  String get wn38ZoomAdded =>
      'মানচিত্রে জুম হয়: দুই আঙুলে চেপে টানুন, বা ডাবল ট্যাপে কাছে ও দূরে যান।';

  @override
  String get wn38OptionsAdded =>
      'কাজের অপশন: বেশি গতির জন্য সমান্তরাল টানেল, সংযোগের সীমা, ব্যাটারি সাশ্রয়, অ্যাপ খুললেই সংযোগ এবং বিস্তারিত নির্ণয়।';

  @override
  String get wn38SocialAdded =>
      'ইনস্টাগ্রাম ও টেলিগ্রাম এখন এই পেজের নিচেও রয়েছে।';

  @override
  String get wn38FlightImproved =>
      'দেশ বাছাই একটি ছোট ফ্লাইট: ক্যামেরা একটু পিছিয়ে যায়, গ্লোব ঘোরে, পিন লাফিয়ে নামে এবং রাস্তাগুলি নিজে নিজেই হাব পর্যন্ত আঁকা হয়।';

  @override
  String get wn38EffectsImproved =>
      'মানচিত্র এখন সমৃদ্ধ দেখায়: গ্লোবের পেছনে তারা, স্থানাঙ্ক জাল, হাবের নিজস্ব আলো, প্রান্তে হ্যালো এবং ভূমির ছায়া।';

  @override
  String get wn38SpeedImproved =>
      'গতির অপশন এখন সত্যিই কাজ করে: সমান্তরাল টানেল একসাথে কয়েকটি সংযোগ খোলে, আর কোর ট্রাফিক তাদের মধ্যে ভাগ করে।';

  @override
  String get wn38NameFixed =>
      'নির্বাচিত দেশের নাম একবারই দেখায় — মানচিত্রের ভাসমান কার্ডে; পতাকার নিচের অনুলিপি সরানো হয়েছে।';

  @override
  String get mapKind => 'মানচিত্রের ধরন';

  @override
  String get mapKindHint =>
      'হোম পেজের পৃথিবী কেমন দেখাবে: আগের মতো সমতল মানচিত্র (ডিফল্ট), তার আধুনিক রূপ, রাতের পৃথিবী, ভূখণ্ডের পৃথিবী, ধাতব গোলক, বা স্যাটেলাইট পৃথিবী। প্রতিটি ধরনেই সীমানাগুলি সত্যিকারের অফিসিয়াল সীমানা।';

  @override
  String get mapKindClassic => 'ক্লাসিক';

  @override
  String get mapKindGlobe => 'থ্রিডি গোলক';

  @override
  String get mapKindSatellite => 'স্যাটেলাইট';

  @override
  String get mapKindFlat => 'ফ্ল্যাট 2D';

  @override
  String get mapKindHud => 'রাডার';

  @override
  String get mapStyleGlobeHint =>
      'থ্রিডি গোলকের রং। স্যাটেলাইটের নিজের পৃথিবী আছে, আর সমতল মানচিত্রের নিজের কালি।';

  @override
  String get aboutVersions => 'সংস্করণ';

  @override
  String get aboutChannels => 'যোগাযোগের পৃষ্ঠা';

  @override
  String get checkUpdatesHint =>
      'নতুন সংস্করণ খুঁজুন; পাওয়া গেলে ডাউনলোড হবে এবং ইনস্টলার জিজ্ঞেস করবে।';

  @override
  String get speedTestTitle => 'স্পিড টেস্ট';

  @override
  String get speedTestRun => 'মাপুন';

  @override
  String get speedTestFailed => 'মাপা শেষ হয়নি।';

  @override
  String get speedTestThrough => 'টানেলের ভেতর দিয়ে মাপা হয়েছে।';

  @override
  String get speedTestDirect => 'সরাসরি মাপা হয়েছে (প্রক্সি বন্ধ)।';

  @override
  String get speedTestHint =>
      'টানেলের ভেতর দিয়ে একটি ডাউনলোড ও একটি আপলোড বলে দেয় এটি আসলে কী বহন করে। হোম পাতার গ্রাফও এখানে খোলে।';

  @override
  String get speedGraphHint => 'টানেলের গত এক মিনিট · মাপতে চাপুন';

  @override
  String get favoritePinned => 'পিন হয়েছে। সরাতে আবার চেপে ধরুন।';

  @override
  String get favoriteUnpinned => 'সরানো হয়েছে।';

  @override
  String get shareReport => 'রিপোর্ট শেয়ার';

  @override
  String get shareReportCopied => 'রিপোর্ট ক্লিপবোর্ডে রাখা হয়েছে।';

  @override
  String get batteryWizardTitle => 'ব্যাটারিতে বেঁচে থাকা';

  @override
  String get batteryWizardBody =>
      'শাওমি, স্যামসাং, হুয়াওয়ে জাতীয় ফোন স্ক্রিন লক হলে VPN অ্যাপকে মেরে ফেলে। টানেল জ্বলে থাকুক, তাই অ্যাপটিকে ব্যাটারি অপ্টিমাইজেশন থেকে বাদ দিন।';

  @override
  String get batteryWizardSteps =>
      'প্রস্তুতকারকের নিজের সেটিংসে অটোস্টার্টের অনুমতি দিন এবং অ্যাপকে “No restrictions” (শাওমি), “Sleeping apps থেকে বাদ” (স্যামসাং) বা “Launch — Manual” (হুয়াওয়ে) রাখুন।';

  @override
  String get batteryWizardState => 'ব্যাটারি অপ্টিমাইজেশন টানেল থামাতে পারে।';

  @override
  String get batteryWizardPermit => 'অনুমতি';

  @override
  String get batteryWizardOk => 'টানেল ব্যাটারি থেকে সুরক্ষিত।';

  @override
  String get batteryWizardOpen => 'ব্যাটারি সেটিংস';

  @override
  String get usageTitle => 'অ্যাপ ব্যবহার';

  @override
  String get usageRowHint => 'প্রতিটি অ্যাপ কত ব্যবহার করেছে';

  @override
  String get usageGrant => 'Usage access খুলুন';

  @override
  String get usageGrantHint =>
      'অ্যান্ড্রয়েড প্রতি-অ্যাপ ডেটা ব্যবহার Usage access অনুমতির পিছনে রাখে। বোতাম যে পাতা খোলে সেটি সিস্টেমের নিজের; অ্যাপ শুধু সংখ্যাগুলো পড়ে।';

  @override
  String get usageEmpty => 'এই সময়ে কোনো ব্যবহার নেই।';

  @override
  String get usageToday => 'আজ';

  @override
  String get usageWeek => 'গত ৭ দিন';

  @override
  String get usageMonth => 'গত ৩০ দিন';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'অ্যাপটি Google Play-এর বাইরে থেকে ইনস্টল হয়, তাই প্রথম ইনস্টলে Play Protect স্ক্যান চাইতে পারে। একবার \"অ্যাপ স্ক্যান করুন\" চাপুন — পরিষ্কার স্ক্যান মনে রাখা হয়, এবং পরের আপডেটগুলো এই প্রশ্ন ছাড়াই ইনস্টল হয়।';

  @override
  String get smartLocation => 'সবচেয়ে দ্রুত লোকেশন';

  @override
  String get smartLocationHint =>
      'প্রতি সংযোগে সেই সার্ভারে যায়, যাকে কোরের নিজস্ব লেটেন্সি পরীক্ষা দ্রুততম বলে।';

  @override
  String get quicPass => 'QUIC পাস-থ্রু';

  @override
  String get quicPassHint =>
      'অ্যাপের QUIC (UDP 443) টানেল দিয়ে যায়: কল ও গেম TCP-তে ফিরে না গিয়ে গতি ধরে রাখে।';

  @override
  String get accountRename => 'অ্যাকাউন্টের নাম বদলান';

  @override
  String get accountRenameLabel => 'অ্যাকাউন্টের নাম';

  @override
  String get accountProfile => 'প্রোফাইল ছবি';

  @override
  String get avatarReset => 'সাধারণ চিহ্নে ফিরে যান';

  @override
  String get accountSecurity => 'অ্যাপ পাসওয়ার্ড';

  @override
  String get appPasswordOn => 'অ্যাপ পাসওয়ার্ডের আড়ালে খোলে।';

  @override
  String get appPasswordOff => 'পাসওয়ার্ড নেই: যে অ্যাপ খুলবে সে ঢুকবে।';

  @override
  String get appPasswordSet => 'পাসওয়ার্ড সেট করুন';

  @override
  String get appPasswordChange => 'পাসওয়ার্ড বদলান';

  @override
  String get appPasswordRemove => 'পাসওয়ার্ড সরান';

  @override
  String get appPasswordCurrent => 'বর্তমান পাসওয়ার্ড';

  @override
  String get appPasswordNew => 'নতুন পাসওয়ার্ড (৪+ অক্ষর)';

  @override
  String get appPasswordConfirm => 'নতুন পাসওয়ার্ড আবার লিখুন';

  @override
  String get appPasswordShort => 'কমপক্ষে ৪ অক্ষর।';

  @override
  String get appPasswordMismatch => 'দুটি পাসওয়ার্ড এক নয়।';

  @override
  String get appPasswordWrong => 'ভুল পাসওয়ার্ড';

  @override
  String get appPasswordSetDone =>
      'পাসওয়ার্ড সেট হয়েছে — পরের বার অ্যাপ খুললে জিজ্ঞেস করবে।';

  @override
  String get appPasswordRemoved =>
      'পাসওয়ার্ড সরানো হয়েছে; অ্যাপ এখন মুক্তভাবে খোলে।';

  @override
  String get appPasswordUnlock => 'অ্যাপ লক করা আছে';

  @override
  String get appPasswordUnlockHint => 'চালিয়ে যেতে অ্যাপ পাসওয়ার্ড লিখুন।';

  @override
  String get wn39MapKinds =>
      'মানচিত্রে আবার ধরন বাছার সুযোগ: আগের মতো সমতল মানচিত্র (ডিফল্ট), থ্রিডি গোলক, স্যাটেলাইট পৃথিবী, এবং আধুনিক ফ্ল্যাট 2D।';

  @override
  String get wn39EyeIp =>
      'লোকেশন কার্ডে একটি চোখ আছে: ট্যাপ করে ট্রাফিকের বের হওয়ার ঠিকানা দেখুন ও কপি করুন।';

  @override
  String get wn39Profile =>
      'প্রতিটি অ্যাকাউন্টের নিজের নাম ও প্রোফাইল ছবি আছে, এবং অ্যাপ পাসওয়ার্ডের আড়ালে খুলতে পারে।';

  @override
  String get wn39Smart =>
      'স্মার্ট সংযোগ আরও সম্পূর্ণ: প্রকৃত লেটেন্সিতে দ্রুততম লোকেশন, এবং কল ও গেমের জন্য QUIC পাস-থ্রু।';

  @override
  String get wn39Flight =>
      'দেশ বদলালে আরও মসৃণভাবে উড়ে যায় — ক্যামেরা মহাবৃত্ত ধরে চলে — এবং পতাকা চাকার চিহ্নগুলো পতাকার কাছে।';

  @override
  String get wn39ToastEverywhere =>
      'ডাইনামিক নোটিফিকেশন এখন সব জায়গায়: প্রতিটি সেভ, কপি ও ব্যর্থতার বার্তা একই অ্যানিমেটেড গ্লাস পিলে আসে।';

  @override
  String get wn39Updates =>
      'আপডেট স্টোরেজ পরিষ্কার রাখে: ইনস্টলার পুরনো সংস্করণ বদলে দেয় এবং কোনো প্যাকেজ থেকে যায় না।';

  @override
  String get mapKindNight => 'রাত';

  @override
  String get mapKindTerrain => 'ভূখণ্ড';

  @override
  String get wn40MapKindsNew =>
      'মানচিত্রের দুটি নতুন রূপ: রাতের পৃথিবী ও ভূখণ্ডের পৃথিবী।';

  @override
  String get wn40Flight =>
      'থ্রিডি গোলক একটি মসৃণ ঘূর্ণনে নতুন দেশে উড়ে যায় — কখনও লাফ দেয় না।';

  @override
  String get wn40Mercator =>
      'সমতল মানচিত্র আঁকা হয় স্ট্যান্ডার্ড মার্কেটর অভিক্ষেপে: সঠিক অনুপাত, স্ট্যান্ডার্ড সীমানা, কোনো চাপা নেই।';

  @override
  String get wn40NameBack =>
      'সমতল মানচিত্রে নির্বাচিত দেশের নাম পতাকার নিচে ফিরে এসেছে।';

  @override
  String get wn40Speed =>
      'টানেল এখন ডিফল্টভাবে দুটি সমান্তরাল সেশন খোলে — আরও শক্তিশালী, স্থির লাইন।';

  @override
  String get wn40LockFixed =>
      'সংযোগ বোতামের তালা আর অবস্থা বদলাতে গিয়ে মিলিয়ে যায় না।';

  @override
  String get wn40IpRemoved => 'লোকেশন কার্ডের IP পপআপ সরানো হয়েছে।';

  @override
  String get soundFeedback => 'সাউন্ড ইফেক্ট';

  @override
  String get soundFeedbackHint =>
      'ট্যাপ, সুইচ ও সংযোগ চালু-বন্ধের জন্য নরম শব্দ';

  @override
  String get rateUnit => 'গতির একক';

  @override
  String get lockInBackground => 'ছেড়ে গেলে লক';

  @override
  String get lockBgNever => 'কখনও নয়';

  @override
  String get lockBgNow => 'সাথে সাথে';

  @override
  String get lockBgMin5 => '৫ মিনিট পরে';

  @override
  String get lockBgMin15 => '১৫ মিনিট পরে';

  @override
  String get mb25600 => '২৫ জিবি';

  @override
  String get mb51200 => '৫০ জিবি';

  @override
  String get mb102400 => '১০০ জিবি';

  @override
  String get wn41Sound =>
      'কম্পনের পাশে সংযোগের শব্দ: VPN চালু বা বন্ধ হলে একটি ছোট সুর বাজে (সেটিংস → সাধারণ)।';

  @override
  String get wn41RateUnit =>
      'গতি আপনার পছন্দের এককে দেখাবে: পরিচিত KB/s বা সংযোগের নিজের Mbps.';

  @override
  String get wn41BackgroundLock =>
      'অ্যাপ আপনার অনুপস্থিতিতে নিজেকে লক করতে পারে: পাসওয়ার্ড আবার সাথে সাথে, ৫ বা ১৫ মিনিট পরে চাওয়া হয়।';

  @override
  String get wn41BiggerLimits =>
      'সেশনের ডেটা সীমা এখন ২৫, ৫০ বা ১০০ জিবি পর্যন্ত।';

  @override
  String get wn41Motion =>
      'নতুন গতি: সংযুক্ত গোলক শ্বাস নেয়, টিক নিজে আঁকা হয়, অবস্থার শব্দ মানের মধ্যে গড়িয়ে যায়, ভুল পাসওয়ার্ড ঘরটি কাঁপায়।';

  @override
  String get wn41AboutFixed =>
      'সম্পর্কে পৃষ্ঠা সোজা হয়েছে: দুই পৃষ্ঠা পাশাপাশি, প্রতিটি ব্যাখ্যা নিজের লাইনে, কোনো চাপ নেই।';

  @override
  String get wn41HapticFixed =>
      'ভাইব্রেশন সেটিং আবার কাজ করে: প্রতিটি সংযোগের চালু-বন্ধ এটি মানে, শুধু স্লাইডারের নয়।';

  @override
  String get copyIp => 'IP কপি করুন';

  @override
  String get wn42Fonts =>
      'প্রতিটি ভাষা অ্যাপের নিজের ফন্টে পড়ে: দুই চীনা ও বাংলার জন্য Noto Sans, লাতিন ও সিরিলিকের জন্য Inter — আর কোনো ভাষা ফোনের ফন্টের ওপর ভরসা করে না।';

  @override
  String get wn42Sounds =>
      'অ্যাপের শব্দ এখন সত্যি: প্রতিটি অংশে একটি নরম ট্যাপ, সুইচের জন্য দুটি সুর, সংযোগ চালু-বন্ধে ওঠা-নামা একটি সুর, লকের জন্য একটি পিং — সাউন্ড সুইচ সব নিয়ন্ত্রণ করে।';

  @override
  String get wn42AboutFixed =>
      'সম্পর্কে পৃষ্ঠা তার লোগো, নাম ও নোট মাঝখানে বসায়, এবং যোগাযোগের আইডিগুলো ফোনের প্রস্থ যা-ই হোক, অক্ষত ও এক লাইনে থাকে।';

  @override
  String get wn42Gaming =>
      'গেমিং প্রোফাইল এখন সত্যি: সার্ভার পৃষ্ঠা প্রতি আধা মিনিটে দেরি নতুন করে মাপে এবং মাপা দ্রুততমটিকে অ্যাকসেন্ট দিয়ে তুলে ধরে।';

  @override
  String get avatarPhoto => 'নিজের ছবি';

  @override
  String get avatarPhotoFailed => 'এই ছবিটি ব্যবহার করা যায়নি';

  @override
  String get tlsFragmentAuto => 'স্বয়ংক্রিয়';

  @override
  String get tlsFragmentAutoHint =>
      'প্রথমে সম্পূর্ণ হ্যালো; TLS বারবার কাটা নেটওয়ার্ক নিজেই আধ ঘণ্টার জন্য নাম কাটে';

  @override
  String get accentDesign => 'ডিজাইনের নিজের আলো';

  @override
  String get wn45Designs =>
      'চারটি নতুন হোম ডিজাইন — অরোরা, নিয়ন, গোধূলি আর সেজ — প্রতিটি পুরো অ্যাপকে নিজের রঙে সাজায়';

  @override
  String get wn45HelloAuto =>
      'TLS খণ্ডক শিখেছে: যে নেটওয়ার্ক বারবার হ্যান্ডশেক মারে, নিজেই নাম কেটে টানেল পার হয়';

  @override
  String get wn45RelayRace =>
      'রিলে পুনরুদ্ধার এখন একসাথে তিনটি প্রান্ত পরীক্ষা করে, ফিল্টার নেটওয়ার্ক তাড়াতাড়ি পথ পায়';

  @override
  String get wn45AccentFixed =>
      'রঙ নির্বাচক আবার অ্যাপ জ্বালায় — তার রঙ পাতায় পৌঁছাত না';

  @override
  String get wn45WhatsNewFixed =>
      '«নতুন কী» পাতা আবার তার কথা দেখায় — খালি খুলত';

  @override
  String get wn46Designs =>
      'রেফারেন্স ডিজাইন থেকে দুটি নতুন লুক: ইথারের iOS স্ট্যাটাস কার্ড ও জেডের গ্রেডিয়েন্ট বল — প্রতিটি পুরো অ্যাপকে মুড়ে দেয়, আগের চারটি লুক চলে গেছে।';

  @override
  String get wn46Sounds =>
      'শব্দগুলি একটি পেশাদার সেট পেল: সংযোগ শুরুর ঢেউ, চালু হলে সুর, বিচ্ছিন্ন হলে অবরোহী সুর এবং বন্ধ পথের মৃদু সুর — একবারে এক কণ্ঠ।';

  @override
  String get wn47Designs =>
      'দুটি রেফারেন্স লুক এখন পুরো অ্যাপকে মুড়ে ফেলে — শুধু হোম নয়, প্রতিটি পৃষ্ঠা: এথার পরে প্রথম রেফারেন্সের iOS কাঠামো (বাঁকা খাঁজের বার, দলবদ্ধ টেবিল, রঙিন ব্যাজ, সিস্টেমের নিজস্ব অবস্থার রং), আর জেড পরে দ্বিতীয় রেফারেন্সের অভিব্যক্তিপূর্ণ কাঠামো (ভাসমান ডক, অতি গোল কার্ড, টানাযোগ্য টুল বাবল)।';

  @override
  String get wn47Fixes =>
      'সরু পর্দায় যে সেটিংস সারি উপচে পড়ত, সেটি এখন শেষ পর্যন্ত পড়া যায়।';

  @override
  String get wn48Bars =>
      'দুই ডিজাইনের নিচের বার আবার নিজের জায়গায় বসেছে: aether-এর নীল বৃত্ত তার ট্যাবের খাঁজে থামে, আর zed-এর বৃত্ত নিচের নামকে আর ঢাকে না।';

  @override
  String get wn48Fit =>
      'হোমগুলো আবার তাদের স্ক্রিনে ধরে: aether-এর কার্ড Disconnected শব্দটি শেষ পর্যন্ত পড়ে, পৃষ্ঠা টানটান হলে zed-এর অর্ব এক ধাপ ছোট হয়, আর সংযোগ চলাকালে কোনো ট্র্যাক \"সংযোগের জন্য স্লাইড করুন\" বলে না, কোনো হিন্টও একসঙ্গে \"বিচ্ছিন্ন করুন\" বলে না।';

  @override
  String get wn48Wheel =>
      'পতাকার চাকা স্ক্রিনের ধার যাতে কার্ড কেটে না ফেলে তার আগেই তাকে মিলিয়ে দেয়, সুপারিশকৃত স্থান পড়ার মতো মাপে Mozilla-র চিহ্ন পরে, আর সমতল মানচিত্রের দক্ষিণ ধার এক রেখায় শেষ না হয়ে পৃষ্ঠায় গলে মিশে যায়।';

  @override
  String get wn49States =>
      'দুটি রেফারেন্স ডিজাইন তাদের আঁকা অলংকারই পরল: aether-এর কার্ড AetherST-এর মতোই সেশনের হারগুলি বহন করে, তার পাওয়ার বোতাম রেফারেন্সের দ্যুতি নিয়ে শ্বাস নেয় ও আঙুলের নিচে ধসে, আর zed-এর বাবল নিজের আকারের মাঝে রূপ বদলায়, কেন্দ্র ক্রস-ফেডে বদলায়।';

  @override
  String get wn49Words =>
      '«সংযুক্ত হচ্ছে»-র এখন সর্বত্র শব্দ আছে: টানেল তৈরি হওয়ার সময় সুইচের পথে «সংযুক্ত হচ্ছে…» থাকে, হাতলের চিহ্ন অবস্থার মাঝে মিলিয়ে যায়, আর পথ সংযোগের নিজের ছন্দে শ্বাস নেয় — আঙুলের নিচে কিছুই মুছে যায় না।';

  @override
  String get wn49Sooner =>
      'সংযোগের ইঞ্জিন আবার মূল সংস্করণেরই: রিলে পুল, বিকল্প পথ ও তাদের স্মৃতি, এবং পুনরাবৃত্ত অনুরোধের প্রহরী টানেল বহন করে — আগেই ওঠে আর স্থির থাকে।';

  @override
  String get wn49Mark =>
      'প্রস্তাবিত অবস্থান Mozilla VPN-এর প্রকৃত চিহ্ন পরে, আর আপডেটের বোতামগুলি আপডেটের নিজের গ্লিফ।';

  @override
  String get wn50Notch =>
      'দুই ডিজাইনের পোশাক তার জমানো এলোমেলো থেকে বেরিয়ে আসে: aether-এর খাঁজের বার বৃত্তের নিজের কেন্দ্র পড়ে, নির্বাচিত ট্যাবের নাম দুই লুকেই পৃষ্ঠার নিজের কালি পরে, আর বৃত্তের দ্যুতি বৃত্তেই থাকে, নাম ধুয়ে ফেলে না।';

  @override
  String get wn50Cards =>
      'zed-এর হোম তার হারগুলো বেন্টোতে ভাঁজ করে: হারের কার্ড বেন্টোর দুই ঘর ও সেশনের সারিতে যোগ দেয়, পৃষ্ঠার শেষ কার্ডগুলো ডকের আসন ফাঁকা রাখে, আর পৃষ্ঠা শেষ পর্যন্ত স্ক্রল হলে কিছুই অর্ধেক ডকের নিচে থাকে না।';

  @override
  String get wn50Veil =>
      'স্ট্যাটাস বার নিজের পর্দা পরে: স্ক্রল হওয়া কনটেন্ট ঘড়ির নিচে মিলিয়ে যায়, তার সঙ্গে ধাক্কা খায় না, zed-এর খোলা পৃষ্ঠাগুলো আর ঘড়ির নিচে শুরু হয় না, আর তার ভাসমান টুলগুলো ডকের আসন থেকে দূরে থাকে।';

  @override
  String get wn50Ping =>
      'aether-এর পিং চিপ আবার এক টোকায় মাপে, যেমন রেফারেন্সের নিজের চিপ সাড়া দেয়।';

  @override
  String get tapToChangeServer => 'সার্ভার বদলাতে ট্যাপ করুন';

  @override
  String get wn51Smooth =>
      'পতাকার চাকা আর সারি এখন সত্যিকারের চাকার মতো ঘোরে: টানা আর দেশ বদল এখন কম্পোজিটরের উপর দিয়ে যায় — পতাকা ঘোরার সময় কিছুই নতুন করে সাজানো হয় না, কোনো দ্যুতিও নতুন করে আঁকা হয় না; চাকা মসৃণভাবে ঘোরে, আর পৃষ্ঠা তার সঙ্গে মসৃণভাবে স্ক্রল হয়।';

  @override
  String get wn51Zed =>
      'zed-এর হোম রেফারেন্সের নিজের কাঠামোই পরল: দুটি হারের কার্ড ব্র্যান্ডের নিচে দাঁড়ায় (টানেল বিশ্রামে থাকলে তাদের শূন্যেই থামে), অবস্থার শব্দ বাবলের নিচে display-এর বড় মুখে আসে, আর জায়গা ডকের উপরের উজ্জ্বল সার্ভার কার্ডে বাস করে — ছোট চিপ আর পুনরাবৃত্ত নাম চলে গেছে।';

  @override
  String get wn51Aether =>
      'aether-এর হোম জায়গা একবারই বলে: সারির পুনরাবৃত্ত নামের লাইন বিশ্রাম নেয়, স্ট্যাটাস কার্ড আর পাওয়ার বোতাম নিজেদের আসন ধরে রাখে, আর পৃষ্ঠা পড়ে একটা পরিষ্কার স্তম্ভের মতো।';

  @override
  String get wn51Veil =>
      'ঘড়ির পর্দা এক নিঃশ্বাস লম্বা হলো আর ঘড়ির পুরো ব্যান্ড জুড়ে তার রং ধরে রাখে: নিচ দিয়ে স্ক্রল হওয়া কনটেন্ট পুরোপুরি মিলিয়ে যায়, তার শব্দ ঘড়িকে আর ছোঁয় না।';

  @override
  String get wn52Speed =>
      'টানেল আবার নেটওয়ার্কের নিজের গতিতে চলে: VPN-এর ইন্টারফেস লাইনের প্যাকেট মাপ (MTU 1500) কথা বলে, বাড়াবাড়ি মাপ নয় — ডাউনলোড তার পূর্ণ গতি ফিরে পায়, কল স্থির থাকে, মোবাইল ডেটায় বিশেষ করে।';

  @override
  String get wn52Smart =>
      'দ্রুততম লোকেশন ও প্রস্তাবিত সার্ভিস আবার সৎভাবে বাছে: প্রতি শুরুতে লোকেশনগুলো নতুন করে মাপা হয় এবং এখনকার সেরাটি নেওয়া হয় — আগে বাছা জায়গাটি নীরবে বহন করার বদলে।';

  @override
  String get wn52Motion =>
      'পুরো অ্যাপে ত্রিশটি নতুন অ্যানিমেশন: প্রতিটি পেজ ও কার্ড নরমভাবে নামে, চাপা টাইল ডুবে ফিরে আসে, সংযোগ হচ্ছে-অবস্থার বিন্দু শ্বাস নেয়, খোলা পেজ মসৃণভাবে ভেসে আসে — সিস্টেম কম গতি চাইলে সব থমকে দাঁড়ায়।';

  @override
  String get wn52Pages =>
      'খোলা পেজগুলো নরম পিছলে আসে আর শিরোনাম তার নিজের প্রান্ত থেকে; সেটিং সংরক্ষণের সময় বিভাগে একটি শান্ত রেখা বয়ে যায়।';

  @override
  String get wn56Button =>
      'সংযোগের স্লাইডার পুরো পথে তার শব্দ ধরে রাখে — \'সংযোগ হচ্ছে\' আর \'সংযুক্ত\'-এর মাঝে আর কোনো ফাঁকা মুহূর্ত নেই: শব্দটি এখন তার অবস্থাগুলির মধ্যে মসৃণভাবে যায়, আর কাজের সময়ের ঝাপসা ভাব নিঃশ্বাসের সঙ্গে আসে।';

  @override
  String get wn56Capsule =>
      'চাকার হোম প্রতিটি অবস্থা একবারই বলে: স্লাইডারের উপরের পুনরাবৃত্ত স্ট্যাটাস শব্দটি সরে গেছে — ট্র্যাক নিজেই তা বহন করে, পেজ এক লাইন শান্ত লাগে।';

  @override
  String get wn56Door =>
      'স্পিড টেস্টের হোমে নিজের দরজা আছে: একটি সারি, এক ট্যাপ, আর পরিমাপ খুলে যায় — প্রথম সংযোগের আগেও, শুধু টানেল চলাকালীন নয়।';

  @override
  String get wn56Wheel =>
      'পতাকার চাকা মসৃণভাবে ভাসে: এক ফ্লিং একটি দেশ আনে, আর অবতরণ ঠোকর খেয়ে না বসে জায়গায় স্থির হয় — টানটা ভারী ও স্থির, ভালো ঘুরানো নবের মতো।';

  @override
  String get designGazette => 'সংবাদপত্র';

  @override
  String get designGazetteDesc =>
      'সংবাদপত্রের প্রথম পাতা: মাস্টহেড, রেখাযুক্ত কলাম এবং কালির সিল — কাগজ ও কালিতে খবরের শান্তি';

  @override
  String get speedTestSizesTitle => 'পরীক্ষার আকার';

  @override
  String get wn61Gta =>
      'জিটিএ ডিজাইন: গেমের নিজের হাড — পতাকার জন্য অস্ত্র-চাকা, রাডারের সবুজ টানেল, অ্যাম্বার প্যানেল, ভারী ফন্ট ও তার নিজের শব্দ';

  @override
  String get wn61Sound =>
      'চাকার টিক: চাকা যে প্রতিটি আসন পাস করে কানেও সাড়া দেয়';

  @override
  String get wn62Wheel =>
      'অস্ত্রের চাকা নতুন করে সাজানো হয়েছে: দেশের সংখ্যা যা-ই হোক, আসনগুলো খেলার নিজস্ব ব্যবধান ধরে রাখে, নির্বাচিত অংশে চাকার আলোকিত কীলক থাকে, আর ঝাঁকুনি দিলে চাকা ছুটে যায়';

  @override
  String get wn62Map =>
      'হোমের মানচিত্র এখন প্রতিটি ডিজাইনের নিজস্ব রঙ পরে — জল, স্থল ও গ্রিড পাতার ডিজাইন অনুসরণ করে';

  @override
  String get wn62HudMap =>
      'GTA ডিজাইনের নিজস্ব মানচিত্র: খেলার HUD প্লেট — গভীর জল, নিয়ন উপকূল, অ্যাম্বার রাডার গ্রিড, আর টানেল চলার সময় পৃথিবী জুড়ে বিচরণ করা স্ক্যান';

  @override
  String get wn62Aether =>
      'Aether ডিজাইনের পাওয়ার বোতাম নতুন করে সাজানো হয়েছে: ডিস্ক সরু রিংয়ে দাঁড়ায়, সংযোগের চাপ রিং ঘুরে বেড়ায়, আর যন্ত্রকৃত তল আলো ধরে রাখে';

  @override
  String get wn62Gta =>
      'GTA সংযোগ প্যাড হাতের জবাব দেয় — চাপলে পুরো প্যানেল একটু বসে যায়, আর সংযোগ চলাকালে পাওয়ার চিহ্ন সরে দাঁড়ায়';

  @override
  String get speedTestSizeLight => 'হালকা';

  @override
  String get speedTestSizeStandard => 'স্ট্যান্ডার্ড';

  @override
  String get speedTestSizeFull => 'পূর্ণ';

  @override
  String get speedTestJitter => 'জিটার';

  @override
  String gazetteEdition(int n) {
    return 'সংখ্যা $n';
  }

  @override
  String get gazetteBulletin => 'নিরাপত্তা বুলেটিন';

  @override
  String get gazetteLiveWire => 'লাইভ সংবাদ';

  @override
  String get wn56Speed =>
      'স্পিড টেস্ট ফিরে এসেছে: প্রতিটি দিক নিজের সংযোগে মাপে এবং সাধারণ HTTP/1.1-এ কথা বলে, তাই ডাউনলোডের জানালা বন্ধ হলে আপলোড আর মারা যায় না — প্যানেলে পাথের ডিলে, জিটার ও পছন্দের আকার যোগ হয়েছে।';

  @override
  String get wn56Gazette =>
      'নতুন হোম চেহারা: সংবাদপত্র — মাস্টহেড, রেখাযুক্ত কলাম, লাইভ টিকার এবং টানেল চালু হলে ছাপা হওয়া কালির সিলসহ প্রথম পাতা।';

  @override
  String get designIos => 'iOS';

  @override
  String get designIosDesc =>
      'সিস্টেমের নিজের ভাষা: গ্রুপ করা টেবিল, ট্যাব বারের হেয়ারলাইন, স্ট্যাটাস কার্ড ও ক্যাপসুল বোতাম — সিস্টেমের কণ্ঠে স্পষ্টতা';

  @override
  String get gazetteSection => 'বিভাগ';

  @override
  String get wn58Lock =>
      'টানেল চালু থাকলে নবের লক তার রং ধরে রাখে: চিহ্ন এখন যে পৃষ্ঠে দাঁড়িয়ে সেটি পড়ে — হালকা নবে গাঢ়, গাঢ়ে সাদা — আইকন আর কখনো হারায় না।';

  @override
  String get wn58Enter =>
      'সংযুক্ত অংশ শ্বাস নেয়: সংখ্যাগুলো মিলিয়ে উঠে আসে যখন নিচে জায়গা বাড়ে, এবং সেভাবেই বেরিয়ে যায় — কার্ড আর দুই ফ্রেমের মাঝে লাফায় না।';

  @override
  String get wn58Speed =>
      'স্পিড টেস্ট হালকাভাবে চলে: প্যানেল সর্বোচ্চ সেকেন্ডে দশবার আঁকা হয়, ঘড়ির কাঁটা ছোট সরলরেখায় চলে, এবং ফেসগুলো লাফিয়ে নয়, মিলিয়ে বদলায়।';

  @override
  String get wn58Ios =>
      'নতুন ডিজাইন: iOS — সিস্টেমের নিজের চেহারা, গ্রুপ টেবিল ও ট্যাব বারের হেয়ারলাইন থেকে ক্যাপসুল বোতামের স্ট্যাটাস কার্ড পর্যন্ত। প্রতিটি পেজ, কার্ড, ডায়ালগ ও আইকন সিস্টেমের কণ্ঠে, দুই মোডেই।';

  @override
  String get wn58Pixel =>
      'নতুন ডিজাইন: Pixel — Material You-র চেহারা, টোনাল সারফেস, বড় ভরাট কার্ড, পিল-ইন্ডিকেটর বার ও বড় শিরোনাম। প্রতিটি পেজ, কার্ড, ডায়ালগ ও আইকন অ্যান্ড্রয়েডের কণ্ঠে, দুই মোডেই।';

  @override
  String get wn58Paper =>
      'সংবাদপত্র এখন পুরো একটা পত্রিকা: নিজস্ব সেকশন বার ছাপার বুলেট ও আন্ডারলাইনসহ, প্রতিটি আলাদা পেজের সেকশন হেডার, আর প্রতিটি সেটিংস গ্রুপের রেখাযুক্ত কাগজের বাক্স — ছাপার রেখা পুরো অ্যাপে পৌঁছেছে।';

  @override
  String get wn59Flags =>
      'পতাকাগুলো প্রতিটি ডিজাইনের নিজস্ব কাট পরে: iOS ও aether-এ গোল পদক, zed-এ স্কয়ারকল, gazette-এ রেখাঙ্কিত পাত, pixel-এ বড় নরম কোণ — চাকা, স্ট্রিপ আর প্রতি সারির ছোট পতাকাও তা মেনে চলে।';

  @override
  String get wn59Map =>
      'বিশ্ব মানচিত্র ডিজাইনের নিজস্ব কালিতে আঁকা হয়: gazette-এ কাগজের উষ্ণ বাদামি, zed-এ বেগুনি রাতের ধূসর, pixel-এ টোনাল নীল-ধূসর — প্রতিটি ডিজাইনের জগৎ তার নিজের পাতার।';

  @override
  String get wn59Buttons =>
      'সংযোগের বোতামগুলো তাদের ডিজাইনের ভাষায় কথা বলে: pixel-এ Material You-র বড় টোনাল পিল, সংযোগ তৈরি হওয়ার সময় iOS ক্যাপসুলের শ্বাস, আর প্রতি পাতার কার্ড নিজস্ব গতিতে ভেতরে আসে।';

  @override
  String get wn59Scroll =>
      'চাকা ও স্ট্রিপ ডিজাইনের নিজস্ব ফিজিক্সে স্ক্রল করে: সিস্টেমের বাউন্স, Material-এর দ্রুত থামা, আর কাগজের ভার যা ভাঁজেই থেমে যায়।';

  @override
  String get flagAllPlaces => 'সব জায়গা';

  @override
  String get gazetteRegions => 'গন্তব্য';

  @override
  String get wn60Flags =>
      'প্রতিটি ডিজাইন এখন দেশগুলো নিজের ভাবে দেখায়: বেন্টোর টালির বোর্ড, পিক্সেলের ফিল্টার চিপ, অ্যাথারের ক্যাপসুল বিকল্প, iOS পদকের ডেক, জেড-এর পৃষ্ঠাভিত্তিক বোর্ড, আর গ্যাজেটের অঞ্চল সূচি কাগজের নিজের ছাপের মতো — চাকা তার চাকাই রাখে।';

  @override
  String get wn60Bento =>
      'বেন্টো ডিজাইন সম্পূর্ণ দাঁড়িয়েছে: পর্সেলিন ও কাঠকয়লার নিজের উষ্ণ প্যালেট, ট্যানজারিনের আলো, টালির ডক, স্কয়ার্কল পৃষ্ঠা শিরোনাম, টিন্টেড কার্ড ও পতাকার বোর্ড — প্রতিটি পৃষ্ঠায়, দুই মোডেই।';

  @override
  String get wn60Spacing =>
      'হোমগুলো এক ছন্দে চলে: বিভাগগুলোর মাঝের মৃত ব্যান্ড চলে গেছে, সমাপ্তি কার্ডগুলো তাদের সারি ভরে, আর প্রতিটি ফাঁক ডিজাইনের রাখা স্পেসিং অনুযায়ী শ্বাস নেয়।';

  @override
  String get wn63Retired =>
      'aether ও zed ডিজাইনগুলো অবসর নিল: ব্যবহারকারীরা সেই ডিজাইনে যাবেন যারা তাদের কাঠামো বহন করে — aether-এর টেবিল iOS-এ, zed-এর বেন্তো Bento-তে';

  @override
  String get wn63Map =>
      'GTA ম্যাপ এখন গেমের নিজের ম্যাপের মতো পড়া যায়: প্রতিটি সীমানা রাস্তার মতো, প্রতিটি সার্ভার দেশে অ্যাম্বার চিহ্ন, নির্বাচিত স্থান ওয়েপয়েন্ট হিসেবে তার আলোর স্তম্ভ ও প্লেটে নামসহ, কোণায় কম্পাস';

  @override
  String get wn63Servers =>
      'সার্ভার পাতা প্রতিটি ডিজাইনের নিজের তালিকা পরে — iOS-এর দলবদ্ধ টেবিল, gazette-এর রেখাযুক্ত সূচি, GTA-র HUD স্লট, pixel-এর টোনাল কার্ড, bento-র বোর্ড';

  @override
  String get wn63Accounts =>
      'অ্যাকাউন্ট পাতাও ডিজাইন পরে: কার্ডগুলো ডিজাইনের নিজের গোলাকারে, যোগ বোতাম ডিজাইনের কণ্ঠে, ডায়ালগের শিরোনাম প্রদর্শনের মুখে, ফিল্ডগুলো ডিজাইনের ফ্রেমে';

  @override
  String get wn63Wheel =>
      'অস্ত্র-চাকা গেমের নিজের মাপে নতুন করে সাজানো হলো: বিভাজকের পূর্ণ বৃত্ত, দ্বিস্তরীয় আলোকিত খণ্ড, গণকের চাপ, খোলার লাফ এবং নির্বাচনের নিজের স্পন্দন';

  @override
  String get wn63Ios =>
      'iOS ডিজাইন আরও পূর্ণ: স্ট্যাটাস কার্ডের অবস্থার ধোয়া, মেডেল ডেকের পাতার বিন্দু, প্রতিটি স্ন্যাপে টিক';

  @override
  String get wn64Wheel =>
      'GTA চাকার পদকগুলি এখন ডিস্কের ভেতরে বসে — গেমের নিজের বিন্যাসে বারোটি আসন, পেরিমেটরে বা স্ক্রিনের কিনারার বাইরে কোনো পদক নেই, দুটি পদকও আর ছুঁয়ে যায় না';

  @override
  String get wn64Glass =>
      'চাকা এখন গেমের কাচ পরে: ডিস্কের নিচে পৃথিবী নরম হয়ে ঝাপসা, পাতটা একটু স্বচ্ছ, ওপরে তার ঝিলিক জমা';

  @override
  String get wn64Groups =>
      'iOS হোমের নিজের গ্রুপ: সেশনের টেবিল — টানেলের ঠিকানা এক ট্যাপে ক্লিপবোর্ডে — এবং কুইক অ্যাকশন: স্পিড টেস্ট, সংযোগের সেটিংস, অ্যাকাউন্ট';

  @override
  String get wn64Headers =>
      'প্রতিটি পাতার হেডার আবার পাতার প্রস্থ জুড়ে দাঁড়ায় — ফেরত তীর তার কিনারায়, স্ক্রিনের মাঝে নয়';

  @override
  String get wn64Pill =>
      'Material You পিলের লেখা গোল প্রান্তের ভেতরেই তার জায়গা ধরে রাখে';

  @override
  String get wn64Map =>
      'GTA মানচিত্রের সীমানাগুলি প্রথম পোশাকে ফিরেছে — উপকূল তার নিয়ন ধরে রেখেছে, স্থল তার সরু কালির কিনারা';

  @override
  String get wn64Name => 'Pixel ডিজাইন এখন তার নিজের নামেই ডাকে: Material You';

  @override
  String get wn65Gone =>
      'GTA ডিজাইন চলে গেল: তার হোম, তার পেজ, তার প্যালেট — পাঁচটি ডিজাইন থাকল, আর যে সেটিংস ফাইল এখনও তার নাম বহন করে সেটি চাকায় পড়ে';

  @override
  String get wn65Tight =>
      'সব ডিজাইনে হোম এখন আরও ঘনভাবে সাজানো: কার্ডগুলির মাঝে স্ক্রিনের বাড়তি জায়গা যে ফাঁকা ব্যান্ড খুলত সেগুলি চলে গেছে — চাকা, টাইলস, পত্রিকা, পদক ও চিপগুলি এক নিঃশ্বাসের দূরত্বে একে অপরের পরে আসে, আর পেজ টান টানানোর বদলে স্ক্রল করে';

  @override
  String get wn65Radar =>
      'GTA ডিজাইন যে মানচিত্র বহন করত সেটি এখন নিজের নামে দাঁড়ায়: রাডার — সেই একই গভীর জল, অ্যাম্বার গ্রিড ও সুইপ, এবার মানচিত্র নির্বাচকে নিজের নামে';

  @override
  String get wn67Port =>
      'সংযোগ-পোর্টের সেটিং চলে গেছে: সার্ভারগুলো শুধু সার্ভার তালিকার দেওয়া পোর্টেই সাড়া দেয় — একটি পোর্ট চাপিয়ে দিলে প্রতিটি সংযোগ বন্ধ হয়ে যেত, আর যে কনফিগ এখনও তা বহন করে সে প্রথম চালুতেই তা ছেড়ে দেয়';

  @override
  String get wn67Back =>
      'সংযোগ আবার তার জায়গায় — বাকি সব 1.0.65 যেখানে রেখেছিল সেখানেই: পাঁচটি ডিজাইন, রাডার ম্যাপ ও স্থিতিশীল টানেল';

  @override
  String get designUr =>
      'URnetwork';

  @override
  String get designUrDesc =>
      'URnetwork মুখ: গোল সংযোগ বোতাম, লোকেশন কার্ড এবং উপরে টানলে খোলা লাইভ পরিসংখ্যান শিট';

  @override
  String get urConnect =>
      'সংযোগ';

  @override
  String get urDisconnect =>
      'বিচ্ছিন্ন';

  @override
  String get urChangeLocation =>
      'পরিবর্তন';

  @override
  String get urStatsTitle =>
      'লাইভ পরিসংখ্যান';

  @override
  String get urStatsHint =>
      'উপরে টানুন';

  @override
  String get urSpeedUp =>
      'আপ';

  @override
  String get urSpeedDown =>
      'ডাউন';

  @override
  String get urSessionTime =>
      'সংযুক্ত সময়';

  @override
  String get urSessionData =>
      'সেশন ডেটা';

  @override
  String get urExitLocation =>
      'এক্সিট লোকেশন';

  @override
  String get urLastTest =>
      'শেষ পরীক্ষা';

  @override
  String get urNoData =>
      'এখনও ডেটা নেই';

  @override
  String get urSectionGeneral =>
      'সাধারণ';

  @override
  String get urSectionConnections =>
      'সংযোগ';

  @override
  String get urSectionAppearance =>
      'চেহারা';

  @override
  String get urSectionAbout =>
      'সম্পর্কে';

  @override
  String get urNavStyle =>
      'নেভিগেশন স্টাইল';

  @override
  String get urNavStyleNote =>
      'স্ক্রিনের নিচের বারের চেহারা বদলায়।';

  @override
  String get urNavMorphing =>
      'মর্ফিং';

  @override
  String get urNavNeon =>
      'নিয়ন আভা';

  @override
  String get urNavBubble =>
      'বাবল';

  @override
  String get urNavCapsule =>
      'ক্যাপসুল';

  @override
  String get urBatterySaverNote =>
      'সংযুক্ত থাকলে হোম পেজের গতি শান্ত রাখে।';

  @override
  String get urUsageTitle =>
      'সেশন ব্যবহার';

  @override
  String get urUsageTotal =>
      'মোট';

  @override
  String get urWhatsNew =>
      'নতুন কী আছে';

  @override
  String get urAboutUpdates =>
      'অ্যাপ ও আপডেট';

  @override
  String get wn70UrNav =>
      'URnetwork নেভিগেশন ডিজাইনে যোগ হলো: ভাসমান মর্ফিং বার, নিয়ন আভা, বাবল এবং ক্যাপসুল — সেটিংস → চেহারা থেকে বেছে নিন';

  @override
  String get wn70UrCards =>
      'URnetwork সেটিংস স্ক্রিন: সেকশন ও কার্ড, ভাষা, নেভিগেশন স্টাইল এবং ড্রয়ারে সেশন ব্যবহারের বার';

  @override
  String get urQuickTitle =>
      'দ্রুত বিকল্প';

  @override
  String get urShare =>
      'হটস্পট শেয়ার';

  @override
  String get urShareDesc =>
      'এই ফোনটিকে গেটওয়ে বানান: এর হটস্পটের ডিভাইসগুলো এর মাধ্যমে VPN ব্যবহার করতে পারে। হটস্পট চালু করুন, অন্য ডিভাইসটি সংযুক্ত করুন, তারপর তার প্রক্সি নিচের ঠিকানায় দিন।';

  @override
  String get urShareProxy =>
      'প্রক্সি ঠিকানা';

  @override
  String get urShareCopied =>
      'কপি হয়েছে';

  @override
  String get urShareOpenHotspot =>
      'হটস্পট সেটিংস খুলুন';

  @override
  String get urShareOn =>
      'শেয়ার চালু — প্রক্সি হটস্পটে সাড়া দেয়।';

  @override
  String get urShareNeedsVpn =>
      'আগে VPN সংযুক্ত করুন; শেয়ার করা ডিভাইসগুলো তার টানেলে যায়।';

  @override
  String get urShareSteps =>
      '1. ফোনের হটস্পট চালু করুন\n2. অন্য ডিভাইসটি হটস্পটে সংযুক্ত করুন\n3. সেই ডিভাইসে Wi-Fi নেটওয়ার্কের প্রক্সি খুলে Manual বেছে নিন\n4. সার্ভারে উপরের ঠিকানাটি দিন — একই ঠিকানা SOCKS5-ও সাড়া দেয়';

  @override
  String get urShareNote =>
      'VPN সংযুক্ত থাকলে কাজ করে। কোরের প্রক্সি একই পোর্টে HTTP ও SOCKS5 দুটোই সাড়া দেয়; শেয়ার বন্ধ করলে পোর্ট আবার শুধু লুপব্যাকে ফিরে যায়।';

  @override
  String get wn71Nav =>
      'নেভিগেশন এখন শুধু ক্লাসিক নিচের বার — চলমান পিল, নিয়ন আভা, বুদবুদ ও ক্যাপসুল তাদের নির্বাচকসহ চলে গেছে।';

  @override
  String get wn71Stats =>
      'ড্রয়ারের স্ট্যাটস মূলের নির্ভুলতায় কথা বলে: কেন্দ্রীয় অক্ষে আয়নার মতো ট্রান্সফার চার্ট, প্রতিটি দিকের শীর্ষ নিজ জায়গায়, প্রতিটি রেট 2.50 KiB/s রূপে।';

  @override
  String get wn71Drawer =>
      'উপরে টানা ড্রয়ার নেভিগেশনের নিচে থামে এবং দ্রুত বিকল্প পায়: কিল সুইচ, নোটিফিকেশনের স্পিড ও পতাকা, প্রতি-অ্যাপ রাউটিং, হটস্পট শেয়ার।';

  @override
  String get wn71Share =>
      'হটস্পট শেয়ার: ফোনটিকে তার হটস্পটের ডিভাইসদের জন্য VPN গেটওয়ে বানান — এক সুইচ প্রক্সি খোলে, পৃষ্ঠাটি ঠিকানা ও ধাপগুলো বলে।';

  @override
  String get wn72Sheet =>
      'উপরে টানা ড্রয়ার আর নিচের বারের মাঝের কালো অংশ চলে গেছে: ড্রয়ার এখন বারেই ছোঁয়, আর লোকেশন কার্ড কিনারার আড়ালে লুকিয়ে না থেকে পুরোটা জায়গায় বসে।';

  @override
  String get wn72Settings =>
      'সেটিংস পৃষ্ঠায় এখন সব অপশন আছে: প্রোটেকশনের সারি (কিল সুইচ ও সিস্টেমের always-on গার্ড), ফোন চালু হলে সংযোগ ও অটো-ইনস্টল, স্পিড ইউনিট, অলস অবস্থায় বিচ্ছিন্নতা ও ডেটা লিমিট, ডায়াগনস্টিকস, নেটওয়ার্ক ও বাইপাস সেকশন, প্রতি-অ্যাপ ব্যবহার, এবং ব্যাটারি গাইড।';

  @override
  String get changeUi =>
      'UI/UX পরিবর্তন';

  @override
  String get wn68Toast =>
      'ভাসমান নোটিফিকেশন ব্লার ছেড়ে দিয়েছে: প্রতিটি টোস্টে একটি ভারী ইফেক্ট কম, দুর্বল ফোনগুলো তাদের ফ্রেম ধরে রাখে';

  @override
  String get urReadyToConnect =>
      'সংযোগের জন্য প্রস্তুত';

  @override
  String get urConnectFailed =>
      'সংযোগ ব্যর্থ হয়েছে';

  @override
  String get wn69Ur =>
      'URnetwork স্ক্রিন যেমন আছে তেমন পোর্ট করা: ধাপে ধাপে কোণার বর্গ সংযোগ ফেস, ট্যাপ-টু-কানেক্ট পালস, টানেল তৈরি হওয়ার সময় প্রোভাইডার গ্রিড, এবং স্থির হলে বসে যাওয়া রঙের ক্ষেত্র';

  @override
  String get wn69Stats =>
      'ড্রয়ার মূলের জ্যামিতি ধরে রাখে: পিকে লোকেশন সারি ও সংযোগ, ভাঁজের নিচে লাইভ গতি, সেশনের সংখ্যা, এক্সিট এবং শেষ পরীক্ষা';

  @override
  String get wn68Stats =>
      'হোমের নিচের ধারা উপরে টানুন: লাইভ গতি, সেশনের স্পার্কলাইন, এক্সিট লোকেশন, IP এবং শেষ পরীক্ষা — কোর যা আগেই বলে তার বাইরে কিছু নয়';

  @override
  String get wn68Ur =>
      'URnetwork ডিজাইন পিকারে যোগ দিল: গোল সংযোগ বোতাম যার বিন্দুগুলো টানেল আসার সাথে জড়ো হয়, লোকেশন কার্ড এবং চওড়া «সংযোগ» — চেহারা থেকে বেছে নিন';
}
