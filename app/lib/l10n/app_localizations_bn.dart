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
      'Connects by itself at boot, when the VPN permission is already granted.';

  @override
  String get gamingProfile => 'গেমিং প্রোফাইল';

  @override
  String get gamingProfileHint =>
      'Shows the connection\'s live delay and quality; pairs with the fastest measured server.';

  @override
  String get diagnosticsRun => 'ডায়াগনস্টিক চালান';

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
  String get diagnosticsConnection => 'সংযোগ পরীক্ষা';

  @override
  String get diagnosticsPassed => 'সফল';

  @override
  String get diagnosticsFailed => 'ব্যর্থ';

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
  String get designBento => 'টালি';

  @override
  String get designBentoDesc => 'গোল টালির বোর্ড: সংযোগ, সংখ্যা, স্থান';

  @override
  String get designPixel => 'কমপ্যাক্ট';

  @override
  String get designPixelDesc => 'একটি শান্ত কার্ড: স্থান, সুইচ, সংখ্যা';

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
  String get copiedToClipboard => 'ক্লিপবোর্ডে কপি হয়েছে';
  String get wnTotalsAdded => 'হোম পাতা সেশনে মোট কত ডেটা গেল তা দেখায়, আর এক ট্যাপে পাবলিক আইপি কপি হয়।';
  String get wnPolishImproved => 'পতাকার চাকা ও সার্ভার পাতা আরও গোছানো; লেখা সংক্ষিপ্ত, আর Android টানেল বেশি গতিতে ট্রাফিক বহন করে।';

  @override
  String get smartNetwork => 'স্মার্ট সংযোগ';
  String get smartNetworkHint => 'এই নেটওয়ার্ক অনুযায়ী গতির জন্য MTU, প্রোটোকল ও IP সংস্করণ বেছে নেওয়া হয়।';
  String get valueSmart => 'স্মার্ট';
  String get mtuAutoValue => 'অটো — নেটওয়ার্ক অনুযায়ী';

  @override
  String mtuAutoMeasured(int mtu) {
    return 'স্বয়ংক্রিয় — নেটওয়ার্ক $mtu বহন করে';
  }
  String get wnSmartAdded => 'স্মার্ট সংযোগ: MTU, প্রোটোকল ও IP সংস্করণ নেটওয়ার্ক অনুযায়ী, সত্যিকারের প্রতিক্রিয়া দেখে গতির জন্য বেছে নেওয়া হয়।';
  String get wnToastAdded => 'নিশ্চিতকরণ এখন নরম iOS-স্টাইল বার্তায় আসে, যেখানে নিজেকে আঁকা একটি চিহ্ন থাকে।';
  String get wnFlagsImproved => 'পতাকার চাকা পরিষ্কার বসে: স্ক্রিনের ধারে কোনো পতাকা কাটা যায় না, পতাকা সম্পূর্ণ দেখা যায়, আর নির্বাচন নরমভাবে বসে।';
  String get wnMapImproved => 'বিশ্ব মানচিত্র এখন বড় ও স্পষ্ট: চাপা মহাদেশ নেই, মসৃণ উপকূলরেখা, আর অ্যাঙ্করে উজ্জ্বল হ্যালো।';

  @override
  String get smartWaiting => 'পরিমাপ চলছে…';
  String get smartFamilyRace => 'প্রথম সংযোগে দুটোই প্রতিযোগিতা করে';
  String get dnsManual => 'ম্যানুয়াল DNS';
  String get dnsManualHint => 'প্রতি লাইনে একটি ঠিকানা: সাধারণ IP, https:// (DNS over HTTPS), বা tls://host (DNS over TLS)। প্রথম উত্তরই জেতে।';
  String get dnsManualInvalid => 'একটি লাইন কোর ব্যবহার করতে পারে এমন ঠিকানা নয়: সাধারণ IP, https://…, বা tls://host।';
  String get killSwitchGuarded => 'সুরক্ষিত: টানেল বন্ধ থাকলাকালীন ফোন থেকে কিছুই বেরোয় না।';
  String get accountsUsageTitle => 'এই মাস';
  String get accountsCountLabel => 'অ্যাকাউন্ট';
  String get accountsUsageAverage => 'অ্যাকাউন্টগুলোর ব্যবহৃত অংশের গড়';
  String get wnDesignsAdded => 'অ্যাপ ডিজাইন: পুরো অ্যাপ এখন সফট নিউমরফিজম বা অরোরা গ্লাস পরতে পারে — প্রতিটি পাতা, প্রতিটি কার্ড — সেটিংস → সাধারণ থেকে।';
  String get wnWheelFixed => 'চাকার অর্ধেক পতাকা চলে গেছে: নির্বাচিত পতাকার নিচের তাকটি আলোর পুকুর, দ্বিতীয় পতাকা নয়, আর স্ক্রিনের ধারে কোনো পতাকা কাটা যায় না।';
  String get wnMapReal => 'বিশ্ব মানচিত্র দেশের সরকারি সীমানা থেকে নতুন করে আঁকা — প্রতিটি উপকূল, দ্বীপ ও এনক্লেভ, সত্যিকারের অনুপাতে।';
  String get wnGlobeAdded => 'পৃথিবী এখন গোলক: রুপালি গোলকটি নির্বাচিত দেশের দিকে ঘোরে, উজ্জ্বল পিন ও ভাসমান কার্ড তা চিহ্নিত করে, সংযোগের পথ হাবগুলির দিকে যায়।';
  String get wnWheelGlowImproved => 'নির্বাচিত পতাকা নিজের নীল আভাসহ কাচের ফ্রেমে বড় হয়ে দাঁড়ায়, পাশেরগুলি স্পষ্টভাবে ছোট, আর চাকার নিচের নির্দেশকগুলি আপনার অবস্থান দেখায়।';
  String get sectionAppearance => 'চেহারা';
  String get mapStyle => 'মানচিত্রের ধরন';
  String get mapStyleHint => 'হোম পেজের গ্লোব আপনার পছন্দ অনুযায়ী রঙিন হয়। সংযোগের আলো অপরিবর্তিত থাকে।';
  String get mapSilver => 'রুপোলি';
  String get mapMidnight => 'মধ্যরাত';
  String get mapOcean => 'মহাসাগর';
  String get mapMono => 'এক রঙ';
  String get mapAurora => 'আরোরা';
  String get batterySaver => 'ব্যাটারি সাশ্রয়';
  String get batterySaverHint => 'সংযুক্ত থাকাকালীন মানচিত্রের গতি স্থির করে — গ্লোবের নিঃশ্বাস, চাকার ঝলক। সংযোগ নিজে ঠিক আগের মতোই থাকে।';
  String get connectOnOpen => 'অ্যাপ খুললেই সংযোগ';
  String get connectOnOpenHint => 'অ্যাপ খোলার সাথে সাথে VPN চালু করে, আপনার শেষ বেছে নেওয়া লোকেশনে।';
  String get speedTitle => 'গতি';
  String get parallelTunnels => 'সমান্তরাল টানেল';
  String get parallelTunnelsHint => 'একসাথে Mozilla-তে কয়েকটি টানেল খোলে এবং ট্রাফিক তাদের মধ্যে ভাগ করে, ফলে একটি ধীর টানেল আর গতি সীমিত করে না। আটটি ব্যাটারির জন্য সবচেয়ে ভারী।';
  String get tunnels1 => 'একটি — সবচেয়ে স্থিতিশীল';
  String get tunnels2 => 'দুটি';
  String get tunnels4 => 'চারটি — ধীর নেটওয়ার্কে দ্রুততর';
  String get tunnels8 => 'আটটি — দ্রুততম';
  String get connectionCap => 'সংযোগের সীমা';
  String get connectionCapHint => 'একসাথে কতগুলি অ্যাপ VPN দিয়ে কথা বলতে পারে; ছোট সীমা ব্যস্ত ফোনে ব্যাটারি ও ডেটা বাঁচায়। সীমাহীনই ডিফল্ট।';
  String get capNone => 'সীমা নেই';
  String get verboseLogging => 'বিস্তারিত নির্ণয়';
  String get verboseLoggingHint => 'প্রতিটি ধাপ লগে লেখে — সমস্যা জানাতে সহায়ক, ব্যাটারিতে সামান্য বেশি ভারী।';
  String get wn38MapStylesAdded => 'মানচিত্রের পাঁচটি রূপ: রুপোলি, মধ্যরাত, মহাসাগর, এক রঙ এবং আরোরা — সেটিংসের নতুন চেহারা পেজ বেছে নেয়, প্রতিটির প্রিভিউ সহ।';
  String get wn38ZoomAdded => 'মানচিত্রে জুম হয়: দুই আঙুলে চেপে টানুন, বা ডাবল ট্যাপে কাছে ও দূরে যান।';
  String get wn38OptionsAdded => 'কাজের অপশন: বেশি গতির জন্য সমান্তরাল টানেল, সংযোগের সীমা, ব্যাটারি সাশ্রয়, অ্যাপ খুললেই সংযোগ এবং বিস্তারিত নির্ণয়।';
  String get wn38SocialAdded => 'ইনস্টাগ্রাম ও টেলিগ্রাম এখন এই পেজের নিচেও রয়েছে।';
  String get wn38FlightImproved => 'দেশ বাছাই একটি ছোট ফ্লাইট: ক্যামেরা একটু পিছিয়ে যায়, গ্লোব ঘোরে, পিন লাফিয়ে নামে এবং রাস্তাগুলি নিজে নিজেই হাব পর্যন্ত আঁকা হয়।';
  String get wn38EffectsImproved => 'মানচিত্র এখন সমৃদ্ধ দেখায়: গ্লোবের পেছনে তারা, স্থানাঙ্ক জাল, হাবের নিজস্ব আলো, প্রান্তে হ্যালো এবং ভূমির ছায়া।';
  String get wn38SpeedImproved => 'গতির অপশন এখন সত্যিই কাজ করে: সমান্তরাল টানেল একসাথে কয়েকটি সংযোগ খোলে, আর কোর ট্রাফিক তাদের মধ্যে ভাগ করে।';
  String get wn38NameFixed => 'নির্বাচিত দেশের নাম একবারই দেখায় — মানচিত্রের ভাসমান কার্ডে; পতাকার নিচের অনুলিপি সরানো হয়েছে।';
  String get mapKind => 'মানচিত্রের ধরন';
  String get mapKindHint => 'হোম পেজের পৃথিবী কেমন দেখাবে: আগের মতো সমতল মানচিত্র (ডিফল্ট), তার আধুনিক রূপ, ধাতব গোলক, বা স্যাটেলাইট পৃথিবী।';
  String get mapKindClassic => 'ক্লাসিক';
  String get mapKindGlobe => 'থ্রিডি গোলক';
  String get mapKindSatellite => 'স্যাটেলাইট';
  String get mapKindFlat => 'ফ্ল্যাট 2D';
  String get mapStyleGlobeHint => 'থ্রিডি গোলকের রং। স্যাটেলাইটের নিজের পৃথিবী আছে, আর সমতল মানচিত্রের নিজের কালি।';
  String get showExitIp => 'এই দেশের IP দেখান';
  String get copyIp => 'IP কপি করুন';
  String get exitIpHint => 'সংযোগ করুন, তাহলে চোখ এই দেশের ট্রাফিকের বের হওয়ার ঠিকানা দেখাবে — কপি করার জন্য প্রস্তুত।';
  String get aboutVersions => 'সংস্করণ';
  String get aboutChannels => 'সোশ্যাল চ্যানেল';
  String get checkUpdatesHint => 'নতুন সংস্করণ খুঁজুন; পাওয়া গেলে ডাউনলোড হবে এবং ইনস্টলার জিজ্ঞেস করবে।';
  String get smartLocation => 'সবচেয়ে দ্রুত লোকেশন';
  String get smartLocationHint => 'প্রতি সংযোগে সেই সার্ভারে যায়, যাকে কোরের নিজস্ব লেটেন্সি পরীক্ষা দ্রুততম বলে।';
  String get quicPass => 'QUIC পাস-থ্রু';
  String get quicPassHint => 'অ্যাপের QUIC (UDP 443) টানেল দিয়ে যায়: কল ও গেম TCP-তে ফিরে না গিয়ে গতি ধরে রাখে।';
  String get accountRename => 'অ্যাকাউন্টের নাম বদলান';
  String get accountRenameLabel => 'অ্যাকাউন্টের নাম';
  String get accountProfile => 'প্রোফাইল ছবি';
  String get avatarReset => 'সাধারণ চিহ্নে ফিরে যান';
  String get accountSecurity => 'অ্যাপ পাসওয়ার্ড';
  String get appPasswordOn => 'অ্যাপ পাসওয়ার্ডের আড়ালে খোলে।';
  String get appPasswordOff => 'পাসওয়ার্ড নেই: যে অ্যাপ খুলবে সে ঢুকবে।';
  String get appPasswordSet => 'পাসওয়ার্ড সেট করুন';
  String get appPasswordChange => 'পাসওয়ার্ড বদলান';
  String get appPasswordRemove => 'পাসওয়ার্ড সরান';
  String get appPasswordCurrent => 'বর্তমান পাসওয়ার্ড';
  String get appPasswordNew => 'নতুন পাসওয়ার্ড (৪+ অক্ষর)';
  String get appPasswordConfirm => 'নতুন পাসওয়ার্ড আবার লিখুন';
  String get appPasswordShort => 'কমপক্ষে ৪ অক্ষর।';
  String get appPasswordMismatch => 'দুটি পাসওয়ার্ড এক নয়।';
  String get appPasswordWrong => 'ভুল পাসওয়ার্ড';
  String get appPasswordSetDone => 'পাসওয়ার্ড সেট হয়েছে — পরের বার অ্যাপ খুললে জিজ্ঞেস করবে।';
  String get appPasswordRemoved => 'পাসওয়ার্ড সরানো হয়েছে; অ্যাপ এখন মুক্তভাবে খোলে।';
  String get appPasswordUnlock => 'অ্যাপ লক করা আছে';
  String get appPasswordUnlockHint => 'চালিয়ে যেতে অ্যাপ পাসওয়ার্ড লিখুন।';
  String get wn39MapKinds => 'মানচিত্রে আবার ধরন বাছার সুযোগ: আগের মতো সমতল মানচিত্র (ডিফল্ট), থ্রিডি গোলক, স্যাটেলাইট পৃথিবী, এবং আধুনিক ফ্ল্যাট 2D।';
  String get wn39EyeIp => 'লোকেশন কার্ডে একটি চোখ আছে: ট্যাপ করে ট্রাফিকের বের হওয়ার ঠিকানা দেখুন ও কপি করুন।';
  String get wn39Profile => 'প্রতিটি অ্যাকাউন্টের নিজের নাম ও প্রোফাইল ছবি আছে, এবং অ্যাপ পাসওয়ার্ডের আড়ালে খুলতে পারে।';
  String get wn39Smart => 'স্মার্ট সংযোগ আরও সম্পূর্ণ: প্রকৃত লেটেন্সিতে দ্রুততম লোকেশন, এবং কল ও গেমের জন্য QUIC পাস-থ্রু।';
  String get wn39Flight => 'দেশ বদলালে আরও মসৃণভাবে উড়ে যায় — ক্যামেরা মহাবৃত্ত ধরে চলে — এবং পতাকা চাকার চিহ্নগুলো পতাকার কাছে।';
  String get wn39ToastEverywhere => 'ডাইনামিক নোটিফিকেশন এখন সব জায়গায়: প্রতিটি সেভ, কপি ও ব্যর্থতার বার্তা একই অ্যানিমেটেড গ্লাস পিলে আসে।';
  String get wn39Updates => 'আপডেট স্টোরেজ পরিষ্কার রাখে: ইনস্টলার পুরনো সংস্করণ বদলে দেয় এবং কোনো প্যাকেজ থেকে যায় না।';
  String get wnDesignsRemoved => 'অ্যাপ ডিজাইন নির্বাচক সরানো হয়েছে: অ্যাপ আবার নিজের একরঙা চেহারা পরে — আপনার অ্যাকসেন্ট ও থিম আগের মতোই আছে।';
  String get wnDnsAdded => 'ম্যানুয়াল DNS: সাধারণ IP, DNS over HTTPS, ও DNS over TLS — লেখার সময়ই প্রতিটি লাইনের ধরন দেখানো ও যাচাই হয়।';
  String get wnSmartImproved => 'স্মার্ট সংযোগ এখন দেখায় নেটওয়ার্ক কী উত্তর দিয়েছে: এটি কোন ট্রান্সপোর্ট বেছে নিয়েছে ও কোন IP সংস্করণ ধরে রেখেছে, সরাসরি।';
  String get wnProtectionImproved => 'কিল সুইচ তার প্রহরা দাঁড়ালে জানায়, আর অ্যাপ পাতায় দেখা যায় কতটি অ্যাপ বেছেছেন।';
  String get wnWelcomeImproved => 'স্বাগত পাতা ভাসমান অরোরার ওপর নিঃশ্বাস নেওয়া ঢাল নিয়ে খোলে, আর অ্যাকাউন্ট পাতা মাসটি এক নজরে সারসংক্ষেপ করে।';
  String bypassAppsCount(String n) => 'নির্বাচিত: {n}'.replaceFirst('{n}', n);
}
