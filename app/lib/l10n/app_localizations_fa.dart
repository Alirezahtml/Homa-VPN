// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'برای اتصال بکشید';

  @override
  String get slideToDisconnect => 'برای قطع اتصال بکشید';

  @override
  String get navOverview => 'نمای کلی';

  @override
  String get navAccounts => 'حساب‌ها';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get stateConnected => 'متصل';

  @override
  String get stateConnecting => 'در حال اتصال…';

  @override
  String get stateWaiting => 'در انتظار';

  @override
  String get waitingForAccount =>
      'برای اتصال، در بخش حساب‌ها یک Firefox Account اضافه کنید.';

  @override
  String get waitingForEnabledAccount =>
      'همه حساب‌ها خاموش هستند. یکی را در صفحه حساب‌ها روشن کنید.';

  @override
  String get stateError => 'خطا';

  @override
  String get stateUnknown => 'نامشخص';

  @override
  String get restartProxy => 'راه‌اندازی دوباره پروکسی';

  @override
  String copied(String value) {
    return '$value کپی شد';
  }

  @override
  String get activeAccount => 'حساب فعال';

  @override
  String get noActiveAccount => 'حساب فعالی نیست';

  @override
  String get quotaNotRead => 'حجم هنوز خوانده نشده';

  @override
  String get unlimited => 'نامحدود';

  @override
  String usedOf(String used, String limit) {
    return '$used از $limit مصرف شده';
  }

  @override
  String resets(String date) {
    return 'ریست در $date';
  }

  @override
  String switchAt(int percent) {
    return 'تعویض حساب در $percent٪';
  }

  @override
  String get publicIp => 'IP عمومی';

  @override
  String get testConnection => 'تست اتصال';

  @override
  String get testing => 'در حال تست…';

  @override
  String get testFailed => 'ناموفق';

  @override
  String milliseconds(int value) {
    return '$value میلی‌ثانیه';
  }

  @override
  String get justNow => 'همین الان';

  @override
  String minutesAgo(int n) {
    return '$n دقیقه پیش';
  }

  @override
  String hoursAgo(int n) {
    return '$n ساعت پیش';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز پیش',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'ساعت $time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d روز و $h ساعت';
  }

  @override
  String durationHours(int h, int m) {
    return '$h ساعت و $m دقیقه';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m دقیقه و $s ثانیه';
  }

  @override
  String durationSeconds(int s) {
    return '$s ثانیه';
  }

  @override
  String accountsGuide(String size) {
    return 'هر حساب Firefox ماهی $size حجم دارد. می‌توانید چند حساب اضافه کنید؛ وقتی حجم یکی تمام شود، برنامه خودش به حساب بعدی می‌رود.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'به ترتیب همین فهرست؛ هر حساب تا $percent٪ و آخرین حساب تا تمام شدن حجم.';
  }

  @override
  String get addAccount => 'افزودن حساب';

  @override
  String lowQuotaNotice(String size) {
    return 'حجم این حساب رو به اتمام است. با افزودن یک حساب دیگر، $size حجم بیشتر خواهید داشت.';
  }

  @override
  String get noAccounts => 'هنوز حسابی نیست';

  @override
  String get noAccountsHint => 'برای اتصال یک Firefox Account اضافه کنید.';

  @override
  String get delayTestFailed =>
      'تأخیر سرورها اندازه‌گیری نشد. اینترنت را بررسی کنید.';

  @override
  String get createAccountTitle => 'حساب Firefox ندارید؟';

  @override
  String get createAccountHint =>
      'در accounts.firefox.com یک حساب رایگان بسازید، بعد برگردید و «افزودن حساب» را بزنید.';

  @override
  String get moveUp => 'بالا بردن';

  @override
  String get moveDown => 'پایین بردن';

  @override
  String get statusActive => 'فعال';

  @override
  String get statusReady => 'آماده';

  @override
  String get statusNeedsSignIn => 'نیاز به ورود';

  @override
  String get statusReserved => 'رزرو';

  @override
  String get statusUnavailable => 'در دسترس نیست';

  @override
  String statusUnavailableUntil(String date) {
    return 'تا $date در دسترس نیست';
  }

  @override
  String get statusDisabled => 'غیرفعال';

  @override
  String get statusEnabled => 'فعال';

  @override
  String get useNow => 'انتخاب';

  @override
  String get signInAgain => 'ورود دوباره';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'حجم این حساب به $percent٪ رسید و حساب بعدی فعال شد.';
  }

  @override
  String get reasonQuotaExhausted =>
      'حجم این ماه تمام شده؛ بعد از ریست ماهانه دوباره استفاده می‌شود.';

  @override
  String get reasonSignInRequired =>
      'برای استفاده از این حساب، دوباره وارد شوید.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla می‌خواهد ورود تأیید شود: «ورود دوباره» را بزنید (فقط کد لازم است).';

  @override
  String reasonSignInFailed(String detail) {
    return 'ورود خودکار ناموفق بود ($detail). دوباره وارد شوید.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'ورود خودکار قبلی کمی بعد از کار افتاد؛ تلاش بعدی ساعت $time است.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'ورود خودکار کامل نشد ($detail)؛ ساعت $time دوباره تلاش می‌شود.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla این حساب را نپذیرفت؛ بعداً دوباره تلاش می‌شود.';

  @override
  String get more => 'بیشتر';

  @override
  String get refreshQuota => 'به‌روزرسانی حجم';

  @override
  String get remove => 'حذف';

  @override
  String get removeTitle => 'حساب حذف شود؟';

  @override
  String removeBody(String name) {
    return '$name و اطلاعات ورود ذخیره‌شده آن از این کامپیوتر حذف می‌شود. بعداً می‌توانید دوباره اضافه‌اش کنید.';
  }

  @override
  String get unlimitedQuota => 'حجم نامحدود';

  @override
  String get signInTitle => 'ورود';

  @override
  String get signInIntro => 'با Firefox Account وارد شوید.';

  @override
  String get email => 'ایمیل';

  @override
  String get emailInvalid => 'ایمیل حساب را وارد کنید';

  @override
  String get password => 'رمز عبور';

  @override
  String get passwordEmpty => 'رمز عبور را وارد کنید';

  @override
  String get show => 'نمایش';

  @override
  String get hide => 'پنهان';

  @override
  String get signIn => 'ورود';

  @override
  String get continueLabel => 'ادامه';

  @override
  String get done => 'تمام';

  @override
  String get close => 'بستن';

  @override
  String get noBrowserTitle => 'این دستگاه مرورگر ندارد';

  @override
  String get noBrowserText => 'این آدرس را روی گوشی یا کامپیوتر باز کنید:';

  @override
  String get cancel => 'انصراف';

  @override
  String get tryAgain => 'تلاش دوباره';

  @override
  String get signingIn => 'در حال ورود…';

  @override
  String get accountReady => 'حساب آماده است';

  @override
  String get accountReadyHint => 'به انتهای فهرست حساب‌ها اضافه شد.';

  @override
  String get captchaLabel => 'حروف داخل تصویر';

  @override
  String get codeLabel => 'کد';

  @override
  String get captchaBroken => 'تصویر CAPTCHA نمایش داده نشد.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla یک کد به $email فرستاد. آن را اینجا وارد کنید.';
  }

  @override
  String get stepTotp => 'کد برنامه احراز هویت (Authenticator) را وارد کنید.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla این ورود را غیرعادی می‌داند و یک کد رفع مسدودی به $email فرستاد. آن را اینجا وارد کنید.';
  }

  @override
  String get stepCaptcha => 'حروف داخل تصویر را وارد کنید.';

  @override
  String stepEmailLink(String email) {
    return 'لینک تأییدی را که Mozilla به $email فرستاد باز کنید. ادامه کار خودکار است.';
  }

  @override
  String get signInFailed => 'حساب اضافه نشد.';

  @override
  String get signInCancelled => 'ورود لغو شد.';

  @override
  String get signInNoAccount => 'هیچ Firefox Account با این ایمیل وجود ندارد.';

  @override
  String get signInNoAccountHint =>
      'ایمیل را بررسی کنید، یا با همین ایمیل یک Firefox Account رایگان در سایت Mozilla بسازید، آن را از صندوق ایمیلتان تأیید کنید و بعد اینجا اضافه‌اش کنید.';

  @override
  String get createAccountButton => 'ساخت Firefox Account';

  @override
  String get signInWrongPassword => 'رمز عبور اشتباه است.';

  @override
  String get signInNoPassword =>
      'این حساب رمز ندارد؛ با گوگل یا اپل ساخته شده است. یک رمز بگذارید و بعد با همان رمز اینجا وارد شوید.';

  @override
  String get setPasswordButton => 'ساختن رمز';

  @override
  String get signInTooManyAttempts =>
      'تلاش‌ها بیش از حد بود. کمی صبر کنید و دوباره امتحان کنید.';

  @override
  String get signInUnblockRejected =>
      'کد رفع مسدودی پذیرفته نشد. کد آخرین ایمیل Mozilla را وارد کنید.';

  @override
  String get signInWrongCode =>
      'کد اشتباه است یا منقضی شده. کد آخرین ایمیل Mozilla را وارد کنید؛ با ارسال کد جدید، کد قبلی دیگر کار نمی‌کند.';

  @override
  String get signInWrongTotp =>
      'کد اشتباه است. کدی را که الان برنامه احراز هویت نشان می‌دهد وارد کنید.';

  @override
  String get signInTooManyCodes =>
      'کدهای اشتباه زیادی وارد شد. ورود را از اول شروع کنید.';

  @override
  String get signInTimedOut => 'ورود بیش از حد طول کشید. دوباره شروع کنید.';

  @override
  String get signInNetwork =>
      'به Mozilla وصل نشد. اینترنت را بررسی کنید و دوباره امتحان کنید.';

  @override
  String get coreConnecting => 'در حال اتصال به هسته…';

  @override
  String get coreLost => 'ارتباط با هسته قطع شد. در حال تلاش دوباره…';

  @override
  String get cantReachCore => 'دسترسی به هسته ممکن نیست';

  @override
  String get startingCore => 'در حال اجرای هسته…';

  @override
  String get retry => 'تلاش دوباره';

  @override
  String errNoCore(String path) {
    return 'برنامه هسته کنار اپ پیدا نشد ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'هسته متوقف شد: $detail';
  }

  @override
  String get errNotAnswering => 'هسته پاسخ نمی‌دهد.';

  @override
  String get errRefused => 'هسته اپ را نپذیرفت؛ شاید متعلق به نسخه دیگری باشد.';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get sectionGeneral => 'عمومی';

  @override
  String get language => 'زبان';

  @override
  String get languageSystem => 'پیش‌فرض سیستم';

  @override
  String get theme => 'تم';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get closeBehavior => 'هنگام بستن پنجره';

  @override
  String get closeAsk => 'هر بار بپرس';

  @override
  String get closeTray => 'پنهان شدن کنار ساعت';

  @override
  String get closeQuit => 'خروج از برنامه';

  @override
  String get sectionConnection => 'اتصال';

  @override
  String get localProxy => 'پروکسی محلی';

  @override
  String get systemProxy => 'پروکسی سیستم';

  @override
  String get sectionRouting => 'مسیریابی';

  @override
  String get routingDirect => 'اتصال مستقیم برای سایت‌های داخلی';

  @override
  String get routingDirectHint =>
      'سایت‌ها و IP های کشور انتخاب‌شده از VPN عبور نمی‌کنند: سریع‌تر باز می‌شوند و از حجم کم نمی‌کنند.';

  @override
  String get region => 'کشور';

  @override
  String get regionIr => 'ایران';

  @override
  String get regionCn => 'چین';

  @override
  String get regionRu => 'روسیه';

  @override
  String get regionAf => 'افغانستان';

  @override
  String get regionTr => 'ترکیه';

  @override
  String get regionId => 'اندونزی';

  @override
  String get regionBr => 'برزیل';

  @override
  String get regionNone => 'هیچ‌کدام';

  @override
  String get saved => 'ذخیره شد';

  @override
  String get dataFolder => 'پوشه داده';

  @override
  String get openFolder => 'باز کردن پوشه';

  @override
  String get unofficialNote => 'کلاینت غیررسمی. وابسته به Mozilla نیست.';

  @override
  String get closeTitle => 'پنجره بسته شود؟';

  @override
  String get closeBody =>
      'وقتی برنامه کنار ساعت پنهان باشد، VPN وصل می‌ماند. با خروج، قطع می‌شود.';

  @override
  String get rememberChoice => 'انتخابم را به خاطر بسپار';

  @override
  String get minimizeToTray => 'پنهان شدن کنار ساعت';

  @override
  String get quit => 'خروج';

  @override
  String get trayOpen => 'باز کردن';

  @override
  String get trayQuit => 'خروج';

  @override
  String get trayProxyOnly => 'فقط سرویس پروکسی';

  @override
  String get traySetSystemProxy => 'تنظیم پروکسی سیستم';

  @override
  String errPortInUse(String port) {
    return 'پورت $port در اختیار برنامه دیگری است و اپ نمی‌تواند به هسته‌اش وصل شود.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'پورت $port در اختیار برنامه دیگری است و پروکسی اجرا نمی‌شود.';
  }

  @override
  String get changePort => 'تغییر پورت';

  @override
  String get portDialogTitle => 'انتخاب پورت';

  @override
  String portDialogBody(String port) {
    return 'پورت $port اشغال است. یک پورت آزاد در زیر پیشنهاد شده؛ می‌توانید پورت دیگری هم وارد کنید.';
  }

  @override
  String get portChangeBody =>
      'برنامه‌ها به این پورت وصل می‌شوند. یک پورت بین 1024 تا 65535 انتخاب کنید.';

  @override
  String get portLabel => 'پورت';

  @override
  String get portInvalid => 'یک پورت بین 1024 تا 65535 وارد کنید';

  @override
  String get portBusy => 'این پورت هم اشغال است';

  @override
  String get portInUse => 'برنامه دیگری از این پورت استفاده می‌کند';

  @override
  String get save => 'ذخیره';

  @override
  String get proxyPort => 'پورت پروکسی';

  @override
  String get appPort => 'پورت اپ';

  @override
  String get welcomeTitle => 'خوش آمدید';

  @override
  String get welcomeBody =>
      'زبان و کشورتان را انتخاب کنید. سایت‌های کشورتان مستقیم و بدون VPN باز می‌شوند؛ سریع‌تر است و از حجم کم نمی‌کند.';

  @override
  String get start => 'شروع';

  @override
  String routingSuggestTitle(String country) {
    return 'مسیریابی مستقیم برای $country؟';
  }

  @override
  String routingSuggestBody(String country) {
    return 'سایت‌ها و IP های $country مستقیم و بدون VPN باز می‌شوند. بعداً در بخش مسیریابی قابل تغییر است.';
  }

  @override
  String get yes => 'بله';

  @override
  String get notNow => 'فعلاً نه';

  @override
  String get navServers => 'سرورها';

  @override
  String get navLogs => 'لاگ‌ها';

  @override
  String get realDelay => 'تأخیر واقعی';

  @override
  String get statElapsed => 'مدت اتصال';

  @override
  String get statDown => 'دریافت';

  @override
  String get statUp => 'ارسال';

  @override
  String noticePort(String port) {
    return 'پروکسی Mozilla به پورت $port وصل نمی‌شود. فقط پورت‌های 80، 443، 8080 و 8443 از VPN عبور می‌کنند.';
  }

  @override
  String get noticeCommand => 'این نوع اتصال در VPN پشتیبانی نمی‌شود.';

  @override
  String noticeTimes(int count, String time) {
    return '$count بار، آخرین بار $time';
  }

  @override
  String get dismiss => 'بستن';

  @override
  String get modeRecommended => 'پیشنهادی';

  @override
  String get modeFastest => 'سریع‌ترین';

  @override
  String get modeRecommendedHint => 'Mozilla مکان را برایتان انتخاب می‌کند.';

  @override
  String get modeFastestHint => 'مکانی با کمترین تأخیر در هر اتصال.';

  @override
  String get testDelay => 'تست تأخیر واقعی';

  @override
  String get testingDelay => 'در حال اندازه‌گیری…';

  @override
  String get search => 'جستجو';

  @override
  String get noAnswer => 'بی‌پاسخ';

  @override
  String testedAgo(String ago) {
    return 'تست‌شده $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered از $total پاسخ دادند';
  }

  @override
  String get noServers =>
      'هنوز سروری نیست. وقتی هسته به Mozilla وصل شود، سرورها نمایش داده می‌شوند.';

  @override
  String get levelAll => 'همه';

  @override
  String get filter => 'فیلتر';

  @override
  String get follow => 'اسکرول خودکار';

  @override
  String get clear => 'پاک کردن';

  @override
  String get copyAll => 'کپی';

  @override
  String get logsCopied => 'لاگ‌ها کپی شد';

  @override
  String get noLogs => 'هنوز لاگی نیست.';

  @override
  String get sectionAccounts => 'تعویض خودکار حساب';

  @override
  String get switchThreshold => 'تعویض حساب در';

  @override
  String get switchThresholdHint =>
      'وقتی این مقدار از حجم مصرف شود، حساب بعدی جایگزین می‌شود.';

  @override
  String get signInMethod => 'روش ورود';

  @override
  String get signInMethodBrowser => 'ورود با مرورگر';

  @override
  String get signInMethodApi => 'ورود مستقیم';

  @override
  String get browserSignInBroken => 'صفحه ورود باز نشد.';

  @override
  String get browserSignInBlocked =>
      'موزیلا درخواست نهایی افزودن حساب را نپذیرفت (خطای ۴۰۶).';

  @override
  String get browserSignInFallback => 'ورود با ایمیل و رمز عبور';

  @override
  String get backupExport => 'گرفتن بک‌آپ';

  @override
  String get backupImport => 'ایمپورت بک‌آپ';

  @override
  String backupSaved(String name) {
    return 'بک‌آپ ذخیره شد: $name';
  }

  @override
  String get backupImportTitle => 'این حساب‌ها اضافه شوند؟';

  @override
  String get backupAccountExists => 'از قبل هست؛ ورودش از بک‌آپ گرفته می‌شود';

  @override
  String get backupImportAction => 'افزودن';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب اضافه شد',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'سرورهای DNS';

  @override
  String get dnsSystem => 'سیستم';

  @override
  String get dnsAuto => 'خودکار (Cloudflare، Google، Quad9)';

  @override
  String get dnsCustom => 'سفارشی';

  @override
  String get dnsCustomHint =>
      'هر خط یکی: https://…/dns-query، tls://… یا یک نشانی IP.';

  @override
  String get dnsFallback => 'استفاده از DNS سیستم اگر این‌ها پاسخ ندهند';

  @override
  String get testDns => 'تست DNS';

  @override
  String get transport => 'پروتکل';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'نسخه IP';

  @override
  String get ipVersionAuto => 'خودکار (اول IPv4، بعد IPv6)';

  @override
  String get ipVersionDual => 'هر دو هم‌زمان (Dual-Stack)';

  @override
  String get ipVersionV6First => 'اول IPv6، بعد IPv4';

  @override
  String get ipVersionV4 => 'فقط IPv4';

  @override
  String get ipVersionV6 => 'فقط IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'اندازه بسته‌های رابط VPN، از ۱۲۸۰ تا ۹۰۰۰. خالی: خودکار.';

  @override
  String get tunMtuInvalid => 'عددی از ۱۲۸۰ تا ۹۰۰۰، یا خالی';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'مستقیم';

  @override
  String get directRulesHint =>
      'سایت‌ها و آدرس‌های این فهرست بدون VPN و مستقیم با اینترنت خودتان باز می‌شوند. قوانین کشوری که انتخاب کرده‌اید از قبل اینجا هست: می‌توانید خطی اضافه، ویرایش یا حذف کنید. با انتخاب کشور دیگر، قوانین آن کشور جایگزین می‌شوند.';

  @override
  String get restoreRegionRules => 'بازگرداندن قوانین کشور';

  @override
  String get blockRules => 'مسدود';

  @override
  String get blockRulesHint =>
      'سایت‌ها و آدرس‌های این فهرست اصلاً باز نمی‌شوند، نه مستقیم و نه از VPN: برای تبلیغات یا سایت‌هایی که نمی‌خواهید هیچ‌وقت باز شوند.';

  @override
  String get rulesTitle => 'قوانین';

  @override
  String get ruleSyntaxTitle => 'راهنمای نوشتن قانون';

  @override
  String get resolveDomains => 'اعمال قوانین IP روی دامنه‌ها';

  @override
  String get routingLists => 'فایل‌های Geo';

  @override
  String get listSource => 'منبع فهرست‌ها';

  @override
  String get listSourceCustom => 'تنظیم دستی';

  @override
  String listsUpdatedAgo(String ago) {
    return 'به‌روزرسانی: $ago';
  }

  @override
  String get updateLists => 'به‌روزرسانی فایل‌های Geo';

  @override
  String get listsUpdated => 'فایل‌های Geo به‌روز شدند.';

  @override
  String get testDestination => 'بررسی مسیر یک سایت';

  @override
  String get destinationHint => 'یک نام، نشانی یا URL';

  @override
  String get check => 'بررسی';

  @override
  String get routeDirect => 'مستقیم وصل می‌شود';

  @override
  String get routeProxy => 'از VPN عبور می‌کند';

  @override
  String get routeBlock => 'مسدود';

  @override
  String ruleMatched(String rule) {
    return 'قانون: $rule';
  }

  @override
  String get portRefusedNote => 'پروکسی Mozilla به این پورت وصل نمی‌شود.';

  @override
  String get sectionAdvanced => 'پیشرفته';

  @override
  String get tlsFragment => 'فرگمنت TLS';

  @override
  String get tlsFragmentOff => 'غیرفعال';

  @override
  String get tlsFragmentFirstByte => 'بایت اول';

  @override
  String get tlsFragmentSni => 'نام سرور (SNI)';

  @override
  String get tlsFragmentFirstByteHint => 'جدا شدن هدر TLS از بایت اول (0x16)';

  @override
  String get tlsFragmentSniHint => 'تقسیم نام سرور (SNI) بین چند بسته TCP';

  @override
  String get tlsFragmentRecord => 'دو تکه کردن TLS';

  @override
  String get tlsFragmentRecordHint => 'ارسال نام سرور (SNI) در دو تکه TLS';

  @override
  String get tlsFragmentOffHint => 'اتصال عادی TLS';

  @override
  String get sectionBypass => 'اگر موزیلا مسدود است';

  @override
  String get sharedRelay => 'رله اشتراکی';

  @override
  String get sharedRelayHint =>
      'اگر موزیلا دسترسی از منطقه شما را محدود کرده، از رله‌های اشتراکی برنامه استفاده می‌شود. رله شخصیِ فعال در اولویت است.';

  @override
  String get personalRelay => 'رله شخصی';

  @override
  String get apiRelay => 'سرور رله';

  @override
  String get apiRelayUse => 'استفاده از سرور رله';

  @override
  String get apiRelayHint =>
      'Cloudflare Worker خودتان، یا فایل relay.php روی هاست خودتان.\nفقط وقتی موزیلا مستقیم جواب ندهد استفاده می‌شود: لاگین، حساب‌ها و لیست سرورها از آن عبور می‌کنند، نه ترافیک VPN.';

  @override
  String get upstreamProxy => 'پروکسی بالادستی';

  @override
  String get upstreamProxyOn => 'پروکسی بالادستی روشن است';

  @override
  String get upstreamProxyAddress => 'آدرس پروکسی SOCKS5';

  @override
  String get upstreamProxyPort => 'پورت';

  @override
  String get upstreamProxyHint =>
      'اتصال به موزیلا از این پروکسی عبور می‌کند؛ برای شبکه‌هایی که موزیلا را مسدود یا کند می‌کنند.\nاگر پروکسی روی همین دستگاه است، آن را از VPN خارج کنید.';

  @override
  String get upstreamProxyInvalid =>
      'آدرس پروکسی را وارد کنید؛ مثلاً 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'پورتی بین 1 تا 65535 وارد کنید.';

  @override
  String get upstreamProxyOwn =>
      'این پروکسی خود همین برنامه است. پروکسی دیگری وارد کنید.';

  @override
  String get apiRelayInvalid => 'باید یک آدرس https:// باشد.';

  @override
  String get listenAddress => 'دسترسی به پروکسی';

  @override
  String get listenLocal => '127.0.0.1 · فقط همین دستگاه';

  @override
  String get listenAll => '0.0.0.0 · همه شبکه‌ها (LAN)';

  @override
  String get proxyUsername => 'نام کاربری پروکسی';

  @override
  String get proxyPassword => 'رمز عبور پروکسی';

  @override
  String get proxyLoginHint =>
      'برنامه‌ها برای استفاده از پروکسی باید این‌ها را وارد کنند. برای استفاده بدون رمز، هر دو را خالی بگذارید.';

  @override
  String get loginBothOrNone => 'هر دو را پر کنید، یا هر دو را خالی بگذارید.';

  @override
  String get proxyLogin => 'نام کاربری و رمز پروکسی';

  @override
  String get idleSleep => 'توقف موقت هنگام عدم استفاده';

  @override
  String get sleepNever => 'هرگز';

  @override
  String sleepMinutes(int count) {
    return '$count دقیقه';
  }

  @override
  String get sleepHour => '۱ ساعت';

  @override
  String get showPublicIp => 'نمایش IP عمومی';

  @override
  String get hapticFeedback => 'لرزش هنگام تغییر اتصال';

  @override
  String get keepScreenOn => 'روشن ماندن صفحه هنگام اتصال';

  @override
  String get showTraffic => 'نمایش ترافیک زنده در صفحهٔ اصلی';

  @override
  String get speedInNotification => 'نمایش سرعت در اعلان';

  @override
  String get liveTraffic => 'ترافیک لحظه‌ای';

  @override
  String get totalTraffic => 'ترافیک کل';

  @override
  String get verboseLogs => 'لاگ کامل';

  @override
  String get webDashboard => 'داشبورد وب';

  @override
  String get webDashboardOpen => 'باز کردن';

  @override
  String get webDashboardHint => 'تنظیمات پیشرفته و ابزارهای بیشتر';

  @override
  String numberInvalid(int min, int max) {
    return 'عددی از $min تا $max وارد کنید';
  }

  @override
  String get notifySwitchedTitle => 'حساب عوض شد';

  @override
  String notifySwitchedBody(String name) {
    return 'الان از $name استفاده می‌شود.';
  }

  @override
  String get notifySignInTitle => 'نیاز به ورود';

  @override
  String get notifySignInBody =>
      'یکی از حساب‌ها باید در صفحه حساب‌ها دوباره وارد شود.';

  @override
  String get navAbout => 'درباره';

  @override
  String get appVersionLabel => 'نسخه برنامه';

  @override
  String get coreVersionLabel => 'نسخه هسته';

  @override
  String get checkUpdates => 'بررسی به‌روزرسانی';

  @override
  String get checkingUpdates => 'در حال بررسی…';

  @override
  String get upToDate => 'آخرین نسخه را دارید.';

  @override
  String updateAvailable(String version) {
    return 'نسخه $version منتشر شده است.';
  }

  @override
  String updateRequired(String version) {
    return 'لطفاً به نسخه $version به‌روزرسانی کنید. این به‌روزرسانی ضروری است.';
  }

  @override
  String get download => 'دانلود';

  @override
  String updateCheckFailed(String error) {
    return 'بررسی به‌روزرسانی ممکن نشد: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'اتصال به GitHub برقرار نشد. اتصال اینترنت را بررسی کنید و دوباره امتحان کنید.';

  @override
  String get updateNow => 'به‌روزرسانی';

  @override
  String updateDownloading(String version) {
    return 'در حال دانلود نسخه $version…';
  }

  @override
  String updateReady(String version) {
    return 'نسخه $version آماده نصب است.';
  }

  @override
  String updateInstalling(String version) {
    return 'در حال نصب نسخه $version؛ برنامه بسته و دوباره باز می‌شود.';
  }

  @override
  String updateFailed(String version) {
    return 'به‌روزرسانی به نسخه $version انجام نشد.';
  }

  @override
  String updateDone(String version) {
    return 'برنامه به نسخه $version به‌روز شد.';
  }

  @override
  String updateRolledBack(String version) {
    return 'به‌روزرسانی به نسخه $version کامل نشد و برنامه به نسخه قبلی برگشت.';
  }

  @override
  String get repoNotSet => 'آدرس مخزن گیت‌هاب هنوز تنظیم نشده است.';

  @override
  String get sourceCode => 'کد منبع';

  @override
  String get tapToConnect => 'برای اتصال کلیک کنید';

  @override
  String get tapToDisconnect => 'برای قطع اتصال کلیک کنید';

  @override
  String get startOnBoot => 'اجرا با روشن شدن سیستم';

  @override
  String get connectOnStartup => 'اتصال خودکار هنگام روشن شدن';

  @override
  String get proxyServiceActive => 'سرویس پروکسی فعال';

  @override
  String get navHome => 'خانه';

  @override
  String get groupApp => 'برنامه';

  @override
  String get groupNetwork => 'شبکه';

  @override
  String get stateOff => 'قطع';

  @override
  String get tapToConnectPhone => 'برای اتصال ضربه بزنید';

  @override
  String get tapToDisconnectPhone => 'برای قطع اتصال ضربه بزنید';

  @override
  String get tapToConnectTv => 'برای اتصال OK را بزنید';

  @override
  String get tapToDisconnectTv => 'برای قطع اتصال OK را بزنید';

  @override
  String lanAddress(String address) {
    return 'شبکه محلی $address';
  }

  @override
  String get recommendedLocation => 'مکان پیشنهادی';

  @override
  String dataLeftOf(String limit) {
    return 'از $limit';
  }

  @override
  String get homeLocation => 'مکان';

  @override
  String get connectedTo => 'متصل به';

  @override
  String get vpnNotAllowed =>
      'VPN به اجازه شما نیاز دارد. دوباره دکمه را بزنید و اجازه دهید.';

  @override
  String get dataUsedTitle => 'حجم مصرف‌شده';

  @override
  String get bypassApps => 'انتخاب برنامه‌ها';

  @override
  String get connectRetrying => 'اتصال برقرار نشد. اینترنت را بررسی کنید.';

  @override
  String get failUnreachable =>
      'اتصال به سرورهای Mozilla برقرار نشد. اینترنت دیگری را امتحان کنید.';

  @override
  String get failUpstreamProxy =>
      'اتصال به Mozilla از طریق پروکسی بالادستی برقرار نشد. روشن بودن پروکسی را بررسی کنید.';

  @override
  String get failInsideVpn =>
      'این اینترنت از قبل از یک VPN عبور می‌کند. آن را خاموش کنید.';

  @override
  String get failRefused =>
      'سرور Mozilla اتصال را رد کرد. چند دقیقه دیگر دوباره امتحان کنید.';

  @override
  String get failLocationRefused =>
      'این کشور برای حساب شما باز نیست. کشور دیگری انتخاب کنید.';

  @override
  String get useRecommendedLocation => 'استفاده از مکان پیشنهادی';

  @override
  String exitMismatch(String exit, String chosen) {
    return '$chosen را انتخاب کردید، اما IP شما مال $exit است.';
  }

  @override
  String get failSignIn =>
      'ورود این حساب منقضی شده. از صفحه حساب‌ها دوباره وارد شوید.';

  @override
  String get failQuota => 'حجم این ماه تمام شده. حساب دیگری اضافه کنید.';

  @override
  String get failNotEntitled =>
      'این حساب از طرف Mozilla اجازه VPN ندارد. حساب دیگری اضافه کنید.';

  @override
  String get failRegion => 'سرویس Mozilla در کشور شما ارائه نمی‌شود.';

  @override
  String get failServer =>
      'سرویس Mozilla موقتاً مشکل دارد. برنامه خودش دوباره تلاش می‌کند.';

  @override
  String get failNoAccount => 'هیچ حسابی آماده نیست. صفحه حساب‌ها را باز کنید.';

  @override
  String get failTestSite =>
      'به سرور وصل شد، اما سایت‌ها باز نمی‌شوند. کشور دیگری را امتحان کنید.';

  @override
  String get failOther => 'اتصال برقرار نشد. دوباره امتحان کنید.';

  @override
  String get failNoInternet =>
      'اینترنت وصل نیست. Wi-Fi یا اینترنت موبایل را بررسی کنید.';

  @override
  String get waitingForNetwork => 'منتظر اتصال اینترنت…';

  @override
  String proxyStartFailed(String port) {
    return 'پروکسی روی پورت $port اجرا نشد. پورت دیگری انتخاب کنید.';
  }

  @override
  String get connectionSettings => 'تنظیمات اتصال';

  @override
  String get appModeExclude => 'اتصال مستقیم برنامه‌های انتخاب‌شده';

  @override
  String get appModeInclude => 'فقط برنامه‌های انتخاب‌شده از VPN';

  @override
  String get appModeExcludeHint =>
      'برنامه‌های انتخاب‌شده مستقیم وصل می‌شوند، نه از VPN؛ مثلاً اپ‌های بانکی که آدرس خارجی را نمی‌پذیرند.';

  @override
  String get appModeIncludeHint =>
      'فقط برنامه‌های انتخاب‌شده از VPN عبور می‌کنند؛ بقیه مستقیم وصل می‌شوند.';

  @override
  String fromRegionList(String region) {
    return 'پیشنهادی: در فهرست $region';
  }

  @override
  String get modeProxy => 'پروکسی';

  @override
  String get connectionMode => 'حالت اتصال';

  @override
  String get modeProxyHint =>
      'فقط برنامه‌هایی که برای پروکسی تنظیم شده‌اند از آن استفاده می‌کنند.';

  @override
  String get modeSystemProxyHint =>
      'ویندوز و بیشتر برنامه‌ها از پروکسی عبور می‌کنند.';

  @override
  String get modeSystemProxyHintOther =>
      'مرورگرها و بیشتر برنامه‌ها از پروکسی عبور می‌کنند.';

  @override
  String get suggestedApps => 'برنامه‌های پیشنهادی';

  @override
  String get showSystemApps => 'نمایش برنامه‌های سیستمی';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count برنامه پیشنهادی انتخاب شد',
      zero: 'برنامه‌های پیشنهادی از قبل انتخاب شده‌اند',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'خودکار';

  @override
  String get locationsSection => 'مکان‌ها';

  @override
  String get dnsSummaryOk => 'DNS رمزنگاری‌شده کار می‌کند';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نام پیدا نشد',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'از طریق $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'DNS شبکه شما برای $count نام آدرس فیلترینگ داد. این برنامه برای آن‌ها از آن استفاده نمی‌کند.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'پاسخ:';

  @override
  String get dnsNetworkAnswer => 'DNS شبکه:';

  @override
  String get dnsFiltered => 'فیلتر شده';

  @override
  String get rulesSyntaxTitle => 'هر خط یک قانون';

  @override
  String get ruleDomain => 'سایت و زیردامنه‌هایش';

  @override
  String get ruleFull => 'دقیقاً همین نام';

  @override
  String get ruleKeyword => 'نام‌هایی که این کلمه را دارند';

  @override
  String get ruleGeosite => 'سایت‌های یک برچسب در فایل‌های Geo';

  @override
  String get ruleGeoip => 'آدرس‌های یک کشور در فایل‌های Geo';

  @override
  String get ruleIp => 'یک آدرس یا یک شبکه';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'فقط پروکسی';

  @override
  String get noNetwork =>
      'اتصال اینترنت برقرار نیست. اینترنت موبایل یا Wi-Fi را روشن کنید.';

  @override
  String get blockAds => 'مسدود کردن تبلیغات';

  @override
  String systemProxyTakenBy(String address) {
    return 'برنامه دیگری پروکسی سیستم را روی $address گذاشته و ترافیک از VPN نمی‌رود.';
  }

  @override
  String get systemProxyTakenOff =>
      'برنامه دیگری پروکسی سیستم را خاموش کرده و ترافیک از VPN نمی‌رود.';

  @override
  String get setSystemProxyAgain => 'دوباره تنظیم کن';

  @override
  String get modeTun => 'حالت TUN';

  @override
  String modeTunHint(String os) {
    return 'کل ترافیک $os از VPN عبور می‌کند.';
  }

  @override
  String get osWindows => 'ویندوز';

  @override
  String get osLinux => 'لینوکس';

  @override
  String get osMacos => 'مک';

  @override
  String get tunInstallWaiting => 'در انتظار اجازه برای نصب سرویس TUN…';

  @override
  String get tunInstallCancelled =>
      'حالت TUN یک بار اجازه Administrator لازم دارد. این اجازه داده نشد و حالت عوض نشد.';

  @override
  String tunInstallFailed(String error) {
    return 'نصب سرویس TUN ممکن نشد: $error';
  }

  @override
  String get tunStarting => 'در حال روشن کردن حالت TUN…';

  @override
  String get tunFailed => 'حالت TUN روشن نشد؛ دوباره تلاش می‌شود…';

  @override
  String get tunLost => 'حالت TUN ناگهان خاموش شد؛ دوباره تلاش می‌شود…';

  @override
  String get tunNotRunning => 'سرویس TUN اجرا نمی‌شود؛ دوباره تلاش می‌شود…';

  @override
  String get tunMissing => 'سرویس TUN نصب نیست.';

  @override
  String get tunOutdated =>
      'سرویس TUN از این برنامه قدیمی‌تر است. برای استفاده از حالت TUN دوباره نصبش کنید.';

  @override
  String get tunAppOutdated =>
      'سرویس TUN از این برنامه جدیدتر است. برای استفاده از حالت TUN برنامه را به‌روز کنید.';

  @override
  String get tunBusy => 'حالت TUN را نسخه دیگری از Homa VPN استفاده می‌کند.';

  @override
  String get tunNoDriver =>
      'درایور TUN سیستم در دسترس نیست. سیستم را ری‌استارت کنید و دوباره امتحان کنید.';

  @override
  String get tunInstall => 'نصب';

  @override
  String get tunInstallAgain => 'نصب دوباره';

  @override
  String get trayTunMode => 'حالت TUN (همه برنامه‌ها)';

  @override
  String get removeTunService => 'حذف سرویس TUN';

  @override
  String get removeTunServiceHint =>
      'سرویس سیستمی که حالت TUN از آن استفاده می‌کند حذف می‌شود. با انتخاب دوباره حالت TUN، دوباره نصب می‌شود.';

  @override
  String get tunServiceRemoved => 'سرویس TUN حذف شد.';

  @override
  String get tunInstallPrompt => 'برای حالت TUN، سرویس Homa VPN باید نصب شود.';

  @override
  String get tunRemovePrompt =>
      'برای حذف حالت TUN، سرویس Homa VPN باید حذف شود.';

  @override
  String tunRemoveFailed(String error) {
    return 'حذف سرویس TUN ممکن نشد: $error';
  }

  @override
  String get sectionTun => 'تنظیمات TUN';

  @override
  String get tunPrograms => 'برنامه‌های بدون VPN';

  @override
  String get tunProgramsHint =>
      'مستقیم وصل می‌شوند، نه از موزیلا؛ فقط برای برنامه‌هایی که بدون VPN کار می‌کنند.';

  @override
  String get tunProgramsEmpty => 'هنوز برنامه‌ای اضافه نشده است.';

  @override
  String get addProgram => 'افزودن برنامه';

  @override
  String get programFiles => 'برنامه‌ها';

  @override
  String get tunProgramAll => 'همه ترافیک';

  @override
  String get tunProgramAllHint => 'کل برنامه مستقیم وصل می‌شود.';

  @override
  String get tunProgramUdp => 'فقط UDP';

  @override
  String get tunProgramUdpHint =>
      'فقط ترافیک UDP آن مستقیم وصل می‌شود؛ بقیه از VPN عبور می‌کند.';

  @override
  String get udpNoticeSetting => 'اعلان مسدود شدن UDP';

  @override
  String udpNoticeBody(String program) {
    return 'ترافیک UDP برنامه $program از VPN عبور نمی‌کند.';
  }

  @override
  String get dontShowAgain => 'دیگر نشان نده';

  @override
  String get addRunningProgram => 'از برنامه‌های در حال اجرا';

  @override
  String get addProgramFile => 'انتخاب فایل…';

  @override
  String get addProgramName => 'نوشتن نام…';

  @override
  String get programNameHint =>
      'نام فایل برنامه، مثل steam.exe؛ علامت * یعنی هر متنی (steam* یعنی همه برنامه‌های Steam).';

  @override
  String get runningProgramsEmpty => 'برنامه دیگری در حال اجرا نیست.';

  @override
  String get tabLog => 'لاگ';

  @override
  String get tabConnections => 'اتصال‌ها';

  @override
  String get connectionsEmpty => 'هنوز اتصالی نیست.';

  @override
  String connectionsOpen(int count) {
    return 'باز: $count';
  }

  @override
  String get connTime => 'زمان';

  @override
  String get connRoute => 'قانون';

  @override
  String get connDestination => 'مقصد';

  @override
  String get connInbound => 'ورودی';

  @override
  String get connProtocol => 'پروتکل';

  @override
  String get connColumns => 'ستون‌ها';

  @override
  String get connTraffic => 'حجم';

  @override
  String get connDuration => 'مدت';

  @override
  String get connRouteVpn => 'پروکسی';

  @override
  String get connRouteDirect => 'مستقیم';

  @override
  String get connRouteBlocked => 'مسدود';

  @override
  String get connRoutePort => 'پورت غیرمجاز';

  @override
  String get connRouteFailed => 'ناموفق';

  @override
  String get testRelay => 'تست سلامت رله';

  @override
  String get relayTestTitle => 'تست سلامت رله';

  @override
  String get relayTestHint =>
      'فقط خود رله بررسی می‌شود؛ درخواستی به موزیلا یا اطلاعات حساب ارسال نمی‌شود.';

  @override
  String get relayTestPassed => 'رله آماده است';

  @override
  String get relayTestFailed => 'سلامت رله تأیید نشد';

  @override
  String get relayTestCopy => 'کپی گزارش';

  @override
  String get relayTestInterrupted => 'تست پیش از دریافت نتیجهٔ کامل متوقف شد.';

  @override
  String get searchLocations => 'جستجوی مکان‌ها';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مکان',
      one: '۱ مکان',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'به‌روزرسانی خودکار';

  @override
  String get autoInstallApkHint =>
      'نسخه‌های جدید خودشان دانلود می‌شوند؛ نصاب پیش از نصب می‌پرسد.';

  @override
  String get installNow => 'نصب';

  @override
  String get updateAllowInstall =>
      'برای نصب به‌روزرسانی، اجازهٔ نصب برنامه را به این برنامه بدهید.';

  @override
  String get allowInstall => 'اجازه دادن';

  @override
  String get noResults => 'هیچ مکانی با جستجو هم‌خوانی ندارد.';

  @override
  String get accentColor => 'رنگ تاکیدی';

  @override
  String get accentMono => 'تک‌رنگ (پیش‌فرض)';

  @override
  String get accentCustom => 'رنگ دلخواه';

  @override
  String get accentEmber => 'شعله‌ای';

  @override
  String get accentGold => 'طلایی';

  @override
  String get accentEmerald => 'زمردی';

  @override
  String get accentSapphire => 'لاجوردی';

  @override
  String get accentAmethyst => 'یاقوت بنفش';

  @override
  String get accentRose => 'رزی';

  @override
  String get autoReconnect => 'اتصال دوباره خودکار';

  @override
  String get autoReconnectHint =>
      'اگر اتصال بدون دست شما قطع شد، خودش دوباره وصل می‌کند.';

  @override
  String get androidOnlyHint => 'فقط روی گوشی.';

  @override
  String get idleDisconnect => 'قطع در حالت بی‌حرکتی';

  @override
  String get idleDisconnectHint =>
      'اگر مدتی ترافیکی رد و بدل نشود، جلسه را تمام می‌کند.';

  @override
  String get idleTimeout => 'مهلت بی‌حرکتی';

  @override
  String get minutes5 => '۵ دقیقه';

  @override
  String get minutes10 => '۱۰ دقیقه';

  @override
  String get minutes15 => '۱۵ دقیقه';

  @override
  String get minutes30 => '۳۰ دقیقه';

  @override
  String get minutes60 => '۱ ساعت';

  @override
  String get dataLimit => 'محدودیت دادهٔ جلسه';

  @override
  String get dataLimitHint => 'وقتی دادهٔ جلسه به سقف رسید، آن را تمام می‌کند.';

  @override
  String get dataLimitAmount => 'سقف داده';

  @override
  String get mb256 => '۲۵۶ مگابایت';

  @override
  String get mb512 => '۵۱۲ مگابایت';

  @override
  String get mb1024 => '۱ گیگابایت';

  @override
  String get mb2048 => '۲ گیگابایت';

  @override
  String get mb5120 => '۵ گیگابایت';

  @override
  String get mb10240 => '۱۰ گیگابایت';

  @override
  String autoStoppedIdle(int minutes) {
    return 'به مدت $minutes دقیقه ترافیکی رد و بدل نشد و اتصال قطع شد.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'دادهٔ جلسه به سقف $mb مگابایت رسید و اتصال قطع شد.';
  }

  @override
  String get protection => 'محافظت';

  @override
  String get killSwitch => 'کلید قطع اضطراری';

  @override
  String get killSwitchHint =>
      'اگر VPN قطع شود، ترافیک نگه داشته می‌شود — هرگز نشت نمی‌کند — تا اتصال برقرار شود.';

  @override
  String get alwaysOnVpn => 'VPN همیشه‌روشن';

  @override
  String get alwaysOnVpnHint =>
      'محافظ خودِ اندروید: بدون VPN هیچ ارتباطی رد نمی‌شود.';

  @override
  String get floatingIsland => 'جزیره شناور';

  @override
  String get floatingIslandHint =>
      'وقتی از برنامه بیرون هستید، وضعیت اتصال را روی دیگر برنامه‌ها نشان می‌دهد.';

  @override
  String whatsNewTitle(String version) {
    return 'امکانات جدید نسخه $version';
  }

  @override
  String get whatsNewContinue => 'متوجه شدم';

  @override
  String get whatsNewMenu => 'تغییرات نسخه';

  @override
  String get whatsNewView => 'مشاهده دوباره';

  @override
  String get updateServers => 'بروزرسانی سرورها';

  @override
  String get updatingServers => 'در حال بروزرسانی…';

  @override
  String serversUpdated(int count) {
    return '$count لوکیشن از فهرست رسمی موزیلا';
  }

  @override
  String get serversUpdateFailed =>
      'بروزرسانی فهرست سرورها انجام نشد؛ فهرست قبلی حفظ شد.';

  @override
  String get smartPickTitle => 'سریع‌ترین در حال حاضر';

  @override
  String get smartPickUse => 'استفاده';

  @override
  String get connectAtBoot => 'اتصال پس از روشن شدن گوشی';

  @override
  String get connectAtBootHint =>
      'هنگام روشن شدن گوشی خودکار وصل می‌شود، اگر اجازه VPN از قبل داده شده باشد.';

  @override
  String get gamingProfile => 'حالت بازی';

  @override
  String get gamingProfileHint =>
      'پینگ و کیفیت واقعی اتصال را زنده نشان می‌دهد؛ با سریع‌ترین سرور اندازه‌گیری‌شده همراه است.';

  @override
  String get diagnosticsRun => 'اجرای عیب‌یابی';

  @override
  String get diagnosticsHint => 'اتصال، DNS و تونل، با یک ضربه';

  @override
  String get diagnosticsTunnel => 'تونل';

  @override
  String get diagnosticsTunnelUp => 'برقرار و در حال انتقال ترافیک';

  @override
  String get diagnosticsTunnelDown => 'قطع';

  @override
  String get diagnosticsExit => 'کشور خروج';

  @override
  String get diagnosticsMismatch => 'کشور خروج با انتخاب شما فرق دارد';

  @override
  String get diagnosticsConnection => 'آزمون اتصال';

  @override
  String get diagnosticsPassed => 'موفق';

  @override
  String get diagnosticsFailed => 'ناموفق';

  @override
  String get diagnosticsDnsFiltered => 'پاسخ مسدود یا فیلتر شده';

  @override
  String get diagnosticsDnsOk => 'پاسخ داد';

  @override
  String get diagnosticsPrivacy =>
      'هیچ‌چیز از این‌ها ذخیره نمی‌شود؛ نتیجه فقط در همین پنجره و گزارش خود هسته می‌ماند.';

  @override
  String get diagnosticsAgain => 'اجرای دوباره';

  @override
  String get whatsNewAdded => 'جدید';

  @override
  String get whatsNewImproved => 'بهبودها';

  @override
  String get whatsNewFixed => 'رفع اشکال';

  @override
  String get wnWheelImproved =>
      'چرخ کشورها از نو طراحی شد: پرچم انتخاب‌شده بزرگ‌تر در قاب شیشه‌ای با درخشش ظریف و هاله‌ای ملایم از نور پشت آن می‌ایستد، پرچم‌های دیگر کوچک‌تر با عمق قرار می‌گیرند، و نام زیر آن با حرکتی نرم می‌آید.';

  @override
  String get wnLiveImproved =>
      'هنگام اتصال، اعلان از اندروید ۱۶ می‌خواهد آن را به‌صورت Live Update ارتقا دهد، همان‌طور که پیاده‌سازی مرجع انجام می‌دهد؛ زمان اتصال خودش می‌شمارد و سرعت‌ها زنده می‌مانند.';

  @override
  String get wnL10nFixed =>
      'این صفحه حالا به زبان برنامه صحبت می‌کند — هر پانزده زبان آن، نه فقط انگلیسی.';

  @override
  String get wnMarkFixed =>
      'نشان Mozilla تمیز روی کاشی خود نشسته و گوشه‌هایش مثل پرچم‌ها گرد است.';

  @override
  String get designTitle => 'طراحی صفحه اصلی';

  @override
  String get designHint => 'چیدمان صفحه اصلی برنامه';

  @override
  String get designWheel => 'چرخ';

  @override
  String get designWheelDesc => 'پرچم‌ها در چرخ شیشه‌ای و کلید زیر آن';

  @override
  String get designBento => 'بنتو';

  @override
  String get designBentoDesc =>
      'طرح جعبهٔ بنتو: پرچم‌ها روی تختهٔ کاشی‌هایشان، کاشی اتصال، و اعداد و مکان به‌عنوان کاشی‌های یک جعبهٔ گرم';

  @override
  String get designPixel => 'Material You';

  @override
  String get designPixelDesc =>
      'Material You: سطوح رنگی ملایم، کارت‌های توپر بزرگ، نوار نشانگر کپسولی و تیترهای درشت — صدای خود اندروید';

  @override
  String get notifFlag => 'پرچم کشور در اعلان';

  @override
  String get notifFlagHint => 'پرچم همان کشور کنار نامش در اعلان';

  @override
  String get wnDesignAdded => 'تنظیم طراحی صفحه اصلی: چرخ، کاشی یا کارت فشرده';

  @override
  String get wnMapAdded =>
      'نقشه برداری واقعی جهان در پس‌زمینه، با روشنی کشور انتخابی';

  @override
  String get wnWheelAdded =>
      'چرخ پرچم‌ها بازطراحی شد: شیشه عمیق‌تر، حرکت نرم‌تر، عمق بیشتر';

  @override
  String get wnFlagNotifAdded =>
      'اعلان می‌تواند پرچم SVG کشور را نشان دهد و می‌توان خاموشش کرد';

  @override
  String get wnColorRemoved =>
      'صفحه رنگ دلخواه حذف شد؛ فهرست رنگ تأکیدی کد HEX را دارد';

  @override
  String get whatsNewRemoved => 'حذف‌شده';

  @override
  String get wnCrashFixed =>
      'برنامه دیگر روی گوشی‌های اندروید ۱۶ خودبه‌خود متوقف نمی‌شود: اعلان چیزی را از سیستم می‌خواست که هنوز در گوشی نبود.';

  @override
  String get wnFlagArtFixed =>
      'برنامه دیگر هنگام باز شدن خودش را بیرون نمی‌اندازد: هنر پرچم اعلان مقداری را برمی‌گرداند که پیام‌رسان سیستم نمی‌پذیرفت.';

  @override
  String get statSession => 'نشست';

  @override
  String get copiedToClipboard => 'در حافظه کپی شد';

  @override
  String get wnTotalsAdded =>
      'خانه مجموع آنچه در این نشست رد و بدل شد را نشان می‌دهد، و یک لمس، IP عمومی را کپی می‌کند.';

  @override
  String get wnPolishImproved =>
      'چرخ پرچم‌ها و صفحهٔ سرورها مرتب‌تر نشسته‌اند؛ متن‌ها فشرده‌ترند و تونل اندروید با سرعت بیشتری ترافیک را می‌برد.';

  @override
  String get valueSmart => 'هوشمند';

  @override
  String get wnSmartAdded =>
      'اتصال هوشمند: اندازهٔ MTU، پروتکل و نسخهٔ IP بر اساس شبکه و با پاسخ‌های واقعی برای سرعت انتخاب می‌شوند.';

  @override
  String get wnToastAdded =>
      'پیام‌های تأیید حالا نرم و به سبک iOS می‌آیند، با نشانه‌ای که خودش را می‌کشد.';

  @override
  String get wnFlagsImproved =>
      'چرخ پرچم‌ها تمیز نشسته: هیچ پرچمی لبهٔ صفحه نصف نمی‌شود، پرچم‌ها کامل دیده می‌شوند و انتخاب با فنری نرم می‌نشیند.';

  @override
  String get wnMapImproved =>
      'نقشهٔ جهان بزرگ‌تر و واضح‌تر کشیده می‌شود: بدون قاره‌های فشرده، با ساحل‌های صاف و هالهٔ درخشان روی مقصد.';

  @override
  String get dnsManual => 'DNS دستی';

  @override
  String get dnsManualHint =>
      'هر نشانی در یک خط: یک IP ساده، https:// (DNS روی HTTPS) یا tls://host (DNS روی TLS). نخستین پاسخ برنده است.';

  @override
  String get dnsManualInvalid =>
      'یکی از خط‌ها نشانی‌ای نیست که هسته بتواند استفاده کند: یک IP ساده، https://… یا tls://host.';

  @override
  String get killSwitchGuarded =>
      'پاسداری می‌شود: تا وقتی تونل قطع است، هیچ چیزی از گوشی بیرون نمی‌رود.';

  @override
  String get accountsUsageTitle => 'این ماه';

  @override
  String get accountsCountLabel => 'حساب';

  @override
  String get accountsUsageAverage => 'میانگین سهم مصرف‌شدهٔ حساب‌ها';

  @override
  String get wnDesignsAdded =>
      'طرح‌های برنامه: حالا کل برنامه می‌تواند نئومورفیسم نرم یا شیشهٔ شفق را بپوشد — همهٔ صفحه‌ها، همهٔ کارت‌ها — از تنظیمات ← همگانی.';

  @override
  String get wnWheelFixed =>
      'نیمه‌پرچمِ چرخ از بین رفت: قفسهٔ زیر پرچم انتخاب‌شده یک حوضچهٔ نور است، نه پرچمی دوم، و هیچ پرچمی لبهٔ صفحه نصف نمی‌شود.';

  @override
  String get wnMapReal =>
      'نقشهٔ جهان با مرزهای رسمی کشورها بازکشیده شد — هر ساحل، جزیره و هم‌محوری با وفاداری کامل و در تناسب واقعی.';

  @override
  String get wnGlobeAdded =>
      'جهان حالا کره است: کرهٔ نقره‌ای به سمت کشور انتخاب‌شده می‌چرخد، یک پین نورانی و یک کارت شناور آن را نشان می‌دهند و راه‌های اتصال به سمت مراکز اصلی می‌روند.';

  @override
  String get wnWheelGlowImproved =>
      'پرچم انتخاب‌شده بزرگ‌تر در قابی شیشه‌ای با هالهٔ آبی خودش می‌ایستد، همسایه‌ها آشکارا کوچک‌ترند و نشانگرهای زیر چرخ جایتان را نشان می‌دهند.';

  @override
  String get wnDesignsRemoved =>
      'انتخاب‌گر «طرح برنامه» حذف شد: برنامه دوباره ظاهر تک‌رنگ خودش را می‌پوشد — رنگ تأکید و پوستهٔ شما سر جایشان‌اند.';

  @override
  String get wnDnsAdded =>
      'DNS دستی: IP ساده، DNS روی HTTPS و DNS روی TLS — نوع هر خط هنگام نوشتن نشان داده و بررسی می‌شود.';

  @override
  String get wnSmartImproved =>
      'اتصال هوشمند حالا نشان می‌دهد شبکه چه پاسخی داد: تراکنشی که برگزیده و نسخهٔ IP که نگه داشته، زنده.';

  @override
  String get wnProtectionImproved =>
      'کلید قطع، وقتی پاسداری برقرار است می‌گوید و صفحهٔ برنامه‌ها نشان می‌دهد چند برنامه انتخاب کرده‌اید.';

  @override
  String get wnWelcomeImproved =>
      'صفحهٔ خوش‌آمد با سپری نفس‌کش بر شفقی روان باز می‌شود و صفحهٔ حساب‌ها ماه را در یک نگاه جمع می‌کند.';

  @override
  String bypassAppsCount(String n) {
    return 'انتخاب‌شده: $n';
  }

  @override
  String get sectionAppearance => 'ظاهر';

  @override
  String get mapStyle => 'طرح نقشه';

  @override
  String get mapStyleHint =>
      'کرهٔ صفحهٔ اصلی، همان‌طور که انتخاب می‌کنید رنگ می‌شود. نور اتصال همان می‌ماند.';

  @override
  String get mapSilver => 'نقره‌ای';

  @override
  String get mapMidnight => 'نیمه‌شب';

  @override
  String get mapOcean => 'اقیانوس';

  @override
  String get mapMono => 'تک‌رنگ';

  @override
  String get mapAurora => 'شفق';

  @override
  String get batterySaver => 'ذخیرهٔ باتری';

  @override
  String get batterySaverHint =>
      'حرکت نقشه را در حال اتصال به سکون می‌برد — نفس کره و درخشش چرخ. خود اتصال دقیقاً همان می‌ماند.';

  @override
  String get connectOnOpen => 'اتصال هنگام باز شدن برنامه';

  @override
  String get connectOnOpenHint =>
      'همان‌طور که برنامه باز می‌شود VPN را بالا می‌آورد، با آخرین مکانی که انتخاب کرده بودید.';

  @override
  String get speedTitle => 'سرعت';

  @override
  String get parallelTunnels => 'تونل‌های موازی';

  @override
  String get parallelTunnelsHint =>
      'چند تونل را هم‌زمان به سمت Mozilla باز می‌کند و ترافیک را میان‌شان می‌بخشد، تا یک تونل کند دیگر سرعت را سقف‌دار نکند. هشت تونل سنگین‌ترین حالت برای باتری است.';

  @override
  String get tunnels1 => 'یکی — باثبات‌ترین';

  @override
  String get tunnels2 => 'دو';

  @override
  String get tunnels4 => 'چهار — روی شبکه‌های کند تندتر';

  @override
  String get tunnels8 => 'هشت — تندترین';

  @override
  String get connectionCap => 'سقف اتصال‌ها';

  @override
  String get connectionCapHint =>
      'چند برنامه می‌توانند هم‌زمان از VPN حرف بزنند؛ سقف کوچک‌تر روی گوشی پرکار باتری و دیتا ذخیره می‌کند. بی‌سقف حالت پیش‌فرض است.';

  @override
  String get capNone => 'بی‌سقف';

  @override
  String get verboseLogging => 'تشخیص کامل';

  @override
  String get verboseLoggingHint =>
      'هر گام را در گزارش می‌نویسد — برای گزارش یک مشکل سودمند است و کمی باتری بیش می‌خورد.';

  @override
  String get wn38MapStylesAdded =>
      'پنج طرح برای نقشه: نقره‌ای، نیمه‌شب، اقیانوس، تک‌رنگ و شفق — صفحهٔ تازهٔ «ظاهر» در تنظیمات انتخابشان می‌کند، با پیش‌نمای هر یک.';

  @override
  String get wn38ZoomAdded =>
      'نقشه زوم می‌شود: با دو انگشت کشش دهید، یا دو ضربه برای نزدیک شدن و برگشتن.';

  @override
  String get wn38OptionsAdded =>
      'گزینه‌های کاربردی: تونل‌های موازی برای سرعت بیشتر، سقف اتصال‌ها، ذخیرهٔ باتری، اتصال هنگام باز شدن برنامه و تشخیص کامل.';

  @override
  String get wn38SocialAdded =>
      'اینستاگرام و تلگرام حالا پایین همین صفحه هم هستند.';

  @override
  String get wn38FlightImproved =>
      'انتخاب یک کشور یک پرواز کوچک است: دوربین کمی عقب می‌کشد، کره می‌چرخد، پین با یک جهش فرود می‌آید و راه‌ها خودشان تا مراکز اصلی کشیده می‌شوند.';

  @override
  String get wn38EffectsImproved =>
      'نقشه پرجزئیات‌تر خوانده می‌شود: ستاره‌ها پشت کره، شبکهٔ مختصات، نورهای خود مراکز، هاله دور لبه و سایهٔ خشکی.';

  @override
  String get wn38SpeedImproved =>
      'گزینهٔ سرعت واقعی شد: تونل‌های موازی چند اتصال را هم‌زمان باز می‌کنند و هسته ترافیک را میان‌شان می‌بخشد.';

  @override
  String get wn38NameFixed =>
      'نام کشور انتخاب‌شده یک بار نشان داده می‌شود — روی کارت شناور نقشه؛ نسخهٔ زیر پرچم‌ها حذف شده است.';

  @override
  String get mapKind => 'نوع نقشه';

  @override
  String get mapKindHint =>
      'جهان صفحهٔ اصلی چگونه نشان داده شود: نقشهٔ تخت مثل همیشه (پیش‌فرض)، حالت مدرن آن، زمین شب، زمین زمین‌شناسی، کرهٔ فلزی، یا زمین ماهواره‌ای. مرزها در هر حالتی همان مرزهای واقعی و رسمی‌اند.';

  @override
  String get mapKindClassic => 'اصلی';

  @override
  String get mapKindGlobe => 'سه‌بعدی';

  @override
  String get mapKindSatellite => 'ماهواره‌ای';

  @override
  String get mapKindFlat => 'دو‌بعدی';

  @override
  String get mapKindHud => 'رادار';

  @override
  String get mapStyleGlobeHint =>
      'رنگ‌هایی که کرهٔ سه‌بعدی می‌پوشد. ماهواره زمین خودش را دارد و نقشه‌های تخت مرکب خودشان را.';

  @override
  String get aboutVersions => 'نسخه';

  @override
  String get aboutChannels => 'صفحه‌های ارتباطی';

  @override
  String get checkUpdatesHint =>
      'جست‌وجوی نسخهٔ تازه‌تر؛ نسخهٔ پیدا‌شده دانلود می‌شود و نصب‌کننده می‌پرسد.';

  @override
  String get speedTestTitle => 'تست سرعت';

  @override
  String get speedTestRun => 'اندازه بگیر';

  @override
  String get speedTestFailed => 'اندازه‌گیری تمام نشد.';

  @override
  String get speedTestThrough => 'اندازه از درون تونل.';

  @override
  String get speedTestDirect => 'اندازه مستقیم (پروکسی خاموش است).';

  @override
  String get speedTestHint =>
      'یک دانلود و یک آپلود از درون تونل می‌گویند واقعاً چه چیزی حمل می‌کند. نمودار صفحهٔ خانه هم اینجا را باز می‌کند.';

  @override
  String get speedGraphHint => 'دقیقهٔ گذشتهٔ تونل · برای اندازه بزنید';

  @override
  String get favoritePinned => 'سنجاق شد. برای برداشتن دوباره ممول کنید.';

  @override
  String get favoriteUnpinned => 'برداشته شد.';

  @override
  String get shareReport => 'هم‌اهزوی گزارش';

  @override
  String get shareReportCopied => 'گزارش روی کلیپ‌بورد قرار گرفت.';

  @override
  String get batteryWizardTitle => 'زنده ماندن روی باتری';

  @override
  String get batteryWizardBody =>
      'شیائومی، سامسونگ، هوآوی و مانند آن‌ها اپ‌های VPN را پس از قفل شدن صفحه می‌کشند. این برنامه را از بهینه‌سازی باتری خارج کنید تا تونل روشن بماند.';

  @override
  String get batteryWizardSteps =>
      'در تنظیمات خود سازنده هم اجازهٔ اجرای خودکار بدهید و اپ را بر «بدون محدودیت» (شیائومی)، «حذف از برنامه‌های خواب» (سامسونگ) یا «اجرا دستی» (هوآوی) بگذارید.';

  @override
  String get batteryWizardState =>
      'بهینه‌سازی باتری می‌تواند تونل را متوقف کند.';

  @override
  String get batteryWizardPermit => 'اجازه می‌دهم';

  @override
  String get batteryWizardOk => 'تونل از باتری محافظت می‌شود.';

  @override
  String get batteryWizardOpen => 'تنظیمات باتری';

  @override
  String get usageTitle => 'مصرف اپ‌ها';

  @override
  String get usageRowHint => 'مصرف هر اپ چقدر بود';

  @override
  String get usageGrant => 'بازکردن اجازهٔ مصرف';

  @override
  String get usageGrantHint =>
      'اندروید مصرف هر اپ را پشت اجازهٔ «دسترسی به مصرف» نگه می‌دارد. صفحه‌ای که دکمه باز می‌کند مال خود سیستم است؛ این اپ تنها عددها را می‌خواند.';

  @override
  String get usageEmpty => 'در این بازه مصرفی ثبت نشده.';

  @override
  String get usageToday => 'امروز';

  @override
  String get usageWeek => '۷ روز گذشته';

  @override
  String get usageMonth => '۳۰ روز گذشته';

  @override
  String get playProtectTitle => 'گوگل پلی پروتکت';

  @override
  String get playProtectBody =>
      'این برنامه از بیرون از گوگل‌پلی نصب می‌شود؛ ممکن است بار نخست گوگل پلی پروتکت پیشنهاد اسکن بدهد. یک بار روی «اسکن برنامه» بزنید — اسکنِ سالم به یادگار می‌ماند و نصب نسخه‌های بعدی بدون این پیام انجام می‌شود.';

  @override
  String get smartLocation => 'سریع‌ترین لوکیشن';

  @override
  String get smartLocationHint =>
      'هر بار اتصال، روی سروری می‌نشیند که آزمون تأخیر خود هسته سریع‌ترین می‌خواند.';

  @override
  String get quicPass => 'گذر QUIC';

  @override
  String get quicPassHint =>
      'QUIC برنامه‌ها (UDP ۴۴۳) از تونل می‌گذرد: تماس‌ها و بازی‌ها سرعت‌شان می‌ماند و به TCP پس نمی‌افتند.';

  @override
  String get accountRename => 'تغییر نام اکانت';

  @override
  String get accountRenameLabel => 'نام اکانت';

  @override
  String get accountProfile => 'تصویر پروفایل';

  @override
  String get avatarReset => 'بازگشت به نشان ساده';

  @override
  String get accountSecurity => 'رمز برنامه';

  @override
  String get appPasswordOn => 'برنامه پشت رمز باز می‌شود.';

  @override
  String get appPasswordOff => 'بدون رمز: هر کس برنامه را باز کند داخل می‌شود.';

  @override
  String get appPasswordSet => 'تنظیم رمز';

  @override
  String get appPasswordChange => 'تغییر رمز';

  @override
  String get appPasswordRemove => 'حذف رمز';

  @override
  String get appPasswordCurrent => 'رمز فعلی';

  @override
  String get appPasswordNew => 'رمز تازه (۴ نویسه یا بیشتر)';

  @override
  String get appPasswordConfirm => 'تکرار رمز تازه';

  @override
  String get appPasswordShort => 'دست‌کم ۴ نویسه.';

  @override
  String get appPasswordMismatch => 'دو رمز یکی نیستند.';

  @override
  String get appPasswordWrong => 'رمز نادرست';

  @override
  String get appPasswordSetDone =>
      'رمز برقرار شد — از آغاز بعدی برنامه آن را می‌پرسد.';

  @override
  String get appPasswordRemoved => 'رمز حذف شد؛ برنامه آزادانه باز می‌شود.';

  @override
  String get appPasswordUnlock => 'برنامه قفل است';

  @override
  String get appPasswordUnlockHint => 'برای ادامه رمز برنامه را وارد کنید.';

  @override
  String get wn39MapKinds =>
      'نقشه دوباره نوع‌های خودش را دارد: نقشهٔ تخت مثل همیشه (پیش‌فرض)، کرهٔ سه‌بعدی، زمین ماهواره‌ای، و دوبعدی مدرن.';

  @override
  String get wn39EyeIp =>
      'کارت لوکیشن یک چشم دارد: با لمسش نشانی خروج ترافیک را ببینید و کپی کنید.';

  @override
  String get wn39Profile =>
      'هر اکانت نام و تصویر پروفایل خودش را دارد، و برنامه می‌تواند پشت رمز باز شود.';

  @override
  String get wn39Smart =>
      'اتصال هوشمند کامل‌تر شد: سریع‌ترین لوکیشن با تأخیر واقعی، و گذر QUIC برای تماس‌ها و بازی‌ها.';

  @override
  String get wn39Flight =>
      'تغییر کشور نرم‌تر پرواز می‌کند — دوربین روی دایرهٔ بزرگ می‌نشیند — و نشانگرهای چرخ پرچم به پرچم‌ها نزدیک‌ترند.';

  @override
  String get wn39ToastEverywhere =>
      'اعلان پویا حالا همه‌جاست: هر «ذخیره شد»، «کپی شد» و «خطا» همان کپسول شیشه‌ای متحرک را می‌پوشد.';

  @override
  String get wn39Updates =>
      'به‌روزرسانی‌ها حافظه را تمیز نگه می‌دارند: نصب‌کننده نسخهٔ قبلی را جایگزین می‌کند و هیچ بسته‌ای جا نمی‌ماند.';

  @override
  String get mapKindNight => 'شب';

  @override
  String get mapKindTerrain => 'زمین';

  @override
  String get wn40MapKindsNew =>
      'دو حالت تازهٔ نقشه: زمین شب و زمین زمین‌شناسی.';

  @override
  String get wn40Flight =>
      'کرهٔ سه‌بعدی با یک چرخش نرم و روان به کشور تازه می‌رود — دیگر هیچ پرشی نیست.';

  @override
  String get wn40Mercator =>
      'نقشه‌های تخت با تصویر استاندارد مرکاتور رسم می‌شوند: نسبت‌های واقعی، مرزهای استاندارد، بدون هیچ فشردگی.';

  @override
  String get wn40NameBack =>
      'نام کشور انتخاب‌شده روی نقشه‌های تخت زیر پرچم‌ها برگشت.';

  @override
  String get wn40Speed =>
      'تونل به‌طور پیش‌فرض دو نشست موازی باز می‌کند — خطی قوی‌تر و پایدارتر.';

  @override
  String get wn40LockFixed =>
      'قفل دکمهٔ اتصال دیگر بین حالت‌ها چشمک نمی‌زند و ناپدید نمی‌شود.';

  @override
  String get wn40IpRemoved => 'پنجرهٔ آی‌پی روی کارت مکان حذف شد.';

  @override
  String get soundFeedback => 'جلوه‌های صوتی';

  @override
  String get soundFeedbackHint =>
      'صداهای نرم برای لمس‌ها، کلیدها و روشن و خاموش شدن اتصال';

  @override
  String get rateUnit => 'واحد سرعت';

  @override
  String get lockInBackground => 'قفل پس از ترک برنامه';

  @override
  String get lockBgNever => 'هرگز';

  @override
  String get lockBgNow => 'بلافاصله';

  @override
  String get lockBgMin5 => 'پس از ۵ دقیقه';

  @override
  String get lockBgMin15 => 'پس از ۱۵ دقیقه';

  @override
  String get mb25600 => '۲۵ گیگابایت';

  @override
  String get mb51200 => '۵۰ گیگابایت';

  @override
  String get mb102400 => '۱۰۰ گیگابایت';

  @override
  String get wn41Sound =>
      'صدای اتصال کنار لرزش نشست: VPN هنگام روشن یا خاموش شدن یک نت کوتاه پخش می‌کند (تنظیمات ← همگانی).';

  @override
  String get wn41RateUnit =>
      'سرعت با واحدی که انتخاب می‌کنید خوانده می‌شود: همان کیلوبایت بر ثانیهٔ آشنا یا مگابیت بر ثانیهٔ خود اتصال.';

  @override
  String get wn41BackgroundLock =>
      'برنامه می‌تواند در نبود شما خودش را قفل کند: رمز دوباره بلافاصله، پس از ۵ یا پس از ۱۵ دقیقه پرسیده می‌شود.';

  @override
  String get wn41BiggerLimits =>
      'سقف دادهٔ نشست تا ۲۵، ۵۰ یا ۱۰۰ گیگابایت بالا می‌رود.';

  @override
  String get wn41Motion =>
      'حرکت‌های تازه: گرهٔ متصل نفس می‌کشد، تیک خودش را می‌کشد، واژهٔ حالت میان حالت‌هایش سُر می‌خورد، و رمز اشتباه کادر را می‌لرزاند.';

  @override
  String get wn41AboutFixed =>
      'صفحهٔ درباره مرتب نشست: دو صفحه کنار هم، هر توضیح در سطر خودش، بدون هیچ فشردگی.';

  @override
  String get wn41HapticFixed =>
      'تنظیم لرزش دوباره کار می‌کند: روشن و خاموش شدن هر اتصال از آن پیروی می‌کند، نه فقط کشویی.';

  @override
  String get copyIp => 'کپی آی‌پی';

  @override
  String get wn42Fonts =>
      'هر زبان با قلم خود برنامه می‌خوانَد: نوتو سانس برای دو چینی و بنگالی، اینتر برای لاتین و سیریلیک — دیگر هیچ زبانی به فونت‌های گوشی تکیه نمی‌کند.';

  @override
  String get wn42Sounds =>
      'صداهای برنامه حالا واقعی‌اند: لمسی نرم در هر بخش، دو نُت برای کلیدها، نُتی بالا رونده و پایین رونده هنگام برقراری و قطع اتصال، و یک بوق برای قفل — کلید صدا همه را کنترل می‌کند.';

  @override
  String get wn42AboutFixed =>
      'صفحهٔ درباره لوگو، نام و توضیحش را در وسط می‌نشاند و نشانی‌های تماس در هر عرضی سالم و در یک سطر می‌مانند.';

  @override
  String get wn42Gaming =>
      'نیم‌رخ گیمینگ حالا واقعی است: صفحهٔ سرورها تأخیرها را هر نیم دقیقه تازه می‌سنجد و سریع‌ترین را با رنگ تأکید نشان می‌دهد.';

  @override
  String get avatarPhoto => 'عکس دلخواه';

  @override
  String get avatarPhotoFailed => 'این عکس قابل استفاده نبود';

  @override
  String get tlsFragmentAuto => 'خودکار';

  @override
  String get tlsFragmentAutoHint =>
      'اول هِلوی کامل؛ شبکه‌ای که پیوسته TLS را می‌بُرد، نام را خودکار برای نیم ساعت می‌بُرد';

  @override
  String get accentDesign => 'نور خودِ طرح';

  @override
  String get wn45Designs =>
      'چهار طرح تازهٔ خانه — اورورا، نئون، غروب و مریم‌گلی — هر یک همهٔ صفحه‌ها را با پالت خودش می‌پوشاند';

  @override
  String get wn45HelloAuto =>
      'شکافندهٔ TLS یاد گرفت: شبکه‌ای که پیوسته دست‌دادن را می‌کشد، نام را خودکار می‌بُرد و تونل می‌گذرد';

  @override
  String get wn45RelayRace =>
      'بازیابی رله حالا سه لبه را هم‌زمان می‌آزماید، تا شبکهٔ فیلترشده زودتر راهش را پیدا کند';

  @override
  String get wn45AccentFixed =>
      'انتخابگر رنگ دوباره اپ را روشن می‌کند — رنگش دیگر به صفحه‌ها نمی‌رسید';

  @override
  String get wn45WhatsNewFixed =>
      'صفحهٔ «چه چیزی تازه» باز هم متنش را نشان می‌دهد — پیش‌تر خالی باز می‌شد';

  @override
  String get wn46Designs =>
      'دو طرح جدید از طرح‌های مرجع: کارت وضعیت iOS اثیر و گوی گرادیانی زد — هر یک کل برنامه را می‌پوشاند و چهار طرح پیشین کنار رفتند.';

  @override
  String get wn46Sounds =>
      'صداها یک مجموعه حرفه‌ای گرفتند: موج نرم برای آغاز اتصال، آکورد برای برقراری، آهنگ نزولی برای قطع و نتی خفه برای مسیر بسته — هر بار یک صدا.';

  @override
  String get wn47Designs =>
      'دو طرح مرجع اکنون کل برنامه را می‌پوشانند — هر صفحه را، نه فقط خانه را: اثیر ساختار iOS مرجع اول را می‌پوشد (نوار بریدگی خمیده، جدول‌های گروهی، نشان‌های رنگی، رنگ‌های وضعیت خود سیستم) و زد ساختار پرشور مرجع دوم را (داک شناور، کارت‌های خیلی گرد، حباب‌های ابزار کشیدنی).';

  @override
  String get wn47Fixes =>
      'ردیف تنظیماتی که در صفحه‌های باریک سرریز می‌شد حالا تا پایان خودش خوانده می‌شود.';

  @override
  String get wn48Bars =>
      'نوارهای پایین دو طرح سر جایشان نشستند: دایرهٔ آبی طرح aether در فرورفتگی تب خودش می‌ایستد و دایرهٔ طرح zed دیگر روی نامِ زیرش نمی‌افتد.';

  @override
  String get wn48Fit =>
      'خانه‌ها باز در صفحه‌شان جا می‌گیرند: کارت طرح aether «Disconnected» را تا آخر می‌خواند، گوی طرح zed وقتی صفحه تنگ است یک قدم کوچک می‌شود، و در حالی که اتصال در راه است نه مسیری می‌گوید «بکش تا وصل شوی» و نه سرنخی می‌گوید «قطع کن».';

  @override
  String get wn48Wheel =>
      'چرخ پرچم‌ها هر کارت را پیش از آنکه لبهٔ صفحه نصفش کند محو می‌کند، مکان پیشنهادی نشان Mozilla را در اندازه‌ای خوانا می‌پوشد، و لبهٔ جنوب نقشهٔ تخت در صفحه ذوب می‌شود، نه اینکه به یک خط ختم شود.';

  @override
  String get wn49States =>
      'دو طرح مرجع جزئیات خودشان را پوشیدند: کارت طرح aether نرخ‌های همین نشست را مثل کارت AetherST نشان می‌دهد، دکمهٔ پاورش با هالهٔ مرجع نفس می‌کشد و زیر انگشت می‌نشیند، و حباب طرح zed میان شکل‌های خودش دگرگون می‌شود و محتوای مرکزش با محو‌شدن جابه‌جا می‌شود.';

  @override
  String get wn49Words =>
      'برای «در حال اتصال» حالا همه‌جا واژه‌ای هست: در حال ساخته‌شدن تونل، ریل کلید واژهٔ «در حال اتصال…» را حمل می‌کند، نشان دستگیره میان حالت‌هایش محو می‌شود و ریل با نفسِ خودِ اتصال می‌تراود — چیزی زیر انگشت ناپدید نمی‌شود.';

  @override
  String get wn49Sooner =>
      'موتور اتصال دوباره مالِ خودِ نسخه اصلی است: استخر رله، مسیرهای جایگزین و حافظه‌شان، و نگهبان درخواست‌های تکراری تونل را می‌برند — زودتر بالا می‌آید و استوار می‌ماند.';

  @override
  String get wn49Mark =>
      'موقعیت پیشنهادی نشان واقعی Mozilla VPN را می‌پوشد و دکمه‌های به‌روزرسانی گلیفِ به‌روزرسانی خودشان را.';

  @override
  String get wn50Notch =>
      'پوشش دو طرح از بهم‌ریختگی‌اش بیرون می‌آید: نوار فرورفتگی طرح aether مرکز خودِ دایره را می‌خواند، نام تبِ انتخاب‌شده در هر دو طرح جوهرِ خودِ صفحه را می‌پوشد، و هالهٔ دایره به خودِ دایره می‌ماند و دیگر نام را نمی‌شوید.';

  @override
  String get wn50Cards =>
      'خانهٔ طرح zed نرخ‌هایش را در بنتو جمع می‌کند: کارتِ نرخ به دو خانهٔ بنتو و ردیف نشست می‌پیوندد، آخرین کارت‌های صفحه صندلی داک را باز می‌گذارند، و وقتی صفحه تا پایانش می‌لغزد چیزی نصفه زیر داک نمی‌ماند.';

  @override
  String get wn50Veil =>
      'نوار وضعیت پردهٔ خودش را می‌پوشد: محتوای در حال لغزش زیر ساعت محو می‌شود و با آن برخورد نمی‌کند، صفحه‌های رانده‌شدهٔ طرح zed دیگر زیر ساعت شروع نمی‌شوند، و ابزارهای شناورش از صندلی داک فاصله می‌گیرند.';

  @override
  String get wn50Ping =>
      'تراشهٔ پینگ طرح aether دوباره با یک ضربه اندازه می‌گیرد، همان‌گونه که تراشهٔ خودِ مرجع پاسخ می‌دهد.';

  @override
  String get tapToChangeServer => 'برای تغییر سرور بزنید';

  @override
  String get wn51Smooth =>
      'چرخ و نوار پرچم‌ها حالا مثل یک چرخ واقعی می‌چرخند: درگ و تغییر کشور روی موتور ترسیم می‌رود — هیچ چیزی دوباره چیده نمی‌شود و هیچ هاله‌ای در حین چرخش پرچم‌ها از نو رسم نمی‌شود؛ چرخ نرم می‌چرخد و صفحه با آن روان می‌لغزد.';

  @override
  String get wn51Zed =>
      'خانهٔ طرح zed ساختار خودِ مرجع را پوشید: دو کارت نرخ زیر نام برنامه می‌ایستند (وقتی تونل خاموش است در صفرهایشان می‌آرمند)، واژهٔ وضعیت با چهرهٔ بزرگ display زیر گوی می‌آید، و مکان روی کارت سرور روشن بالای داک زندگی می‌کند — چیپ کوچک و نام تکراری رفته‌اند.';

  @override
  String get wn51Aether =>
      'خانهٔ طرح aether مکان را یک‌بار می‌گوید: خط نام تکراری نوار می‌آرمَد، کارت وضعیت و دکمهٔ پاور سر جایشان می‌مانند، و صفحه مثل یک ستون تمیز خوانده می‌شود.';

  @override
  String get wn51Veil =>
      'پردهٔ ساعت یک نفس قد کشید و رنگش را سراسر باند ساعت نگه می‌دارد: محتوایی که زیرش می‌لغزد یکجا محو می‌شود و واژه‌هایش دیگر به ساعت نمی‌رسند.';

  @override
  String get wn52Speed =>
      'تانل دوباره با سرعتِ خود شبکه می‌دود: رابط VPN اندازهٔ بستهٔ خط (MTU ۱۵۰۰) را به‌جای اندازهٔ بزرگ‌تر سخن می‌گوید، پس دانلودها سرعت کاملشان را می‌گیرند و مکالمه‌ها پایدار می‌مانند — روی دیتای موبایل بیشتر از همه.';

  @override
  String get wn52Smart =>
      'انتخاب «سریع‌ترین مکان» و سرویس پیشنهادی دوباره درست انتخاب می‌کنند: هر بار روشن‌شدن، مکان‌ها از نو اندازه‌گیری می‌شوند و بهترینِ همین لحظه برداشته می‌شود، نه آن‌که بی‌سروصدا همان مکان قبلی را برانند.';

  @override
  String get wn52Motion =>
      'سی انیمیشن تازه، در سراسر برنامه: هر صفحه و هر کارت نرم فرود می‌آید، کاشی‌های فشرده‌شده فرو می‌روند و بازمی‌گردند، نقطهٔ حالت «در حال اتصال» نفس می‌کشد، و صفحه‌های باز‌شده نرم سرازیر می‌شوند — هر یک با درخواستِ «کاهش حرکت» سیستم آرام می‌ایستند.';

  @override
  String get wn52Pages =>
      'صفحه‌های باز‌شده با یک لغزش نرم می‌آیند و عنوان صفحه از لبهٔ خودش؛ وقتی تنظیمی ذخیره می‌شود، خطی آرام در بخش می‌دود.';

  @override
  String get wn56Button =>
      'کلید کشیدنیِ اتصال واژه‌اش را در تمام مسیر نگه می‌دارد — دیگر هیچ لحظهٔ خالی میان «در حال اتصال» و «متصل شد» نیست: واژه حالا میان حالت‌هایش می‌لغزد و کم‌نور شدنِ حالت کار با یک نفس دنبال می‌شود.';

  @override
  String get wn56Capsule =>
      'خانهٔ چرخ هر حالت را یک بار می‌گوید: واژهٔ وضعیتِ تکراری بالای کلید حذف شد — خودِ مسیرِ کلید آن را حمل می‌کند و صفحه یک خط آرام‌تر خوانده می‌شود.';

  @override
  String get wn56Door =>
      'تست سرعت در خانه دری از خودش دارد: یک ردیف، یک لمس، و اندازه‌گیری باز می‌شود — قبل از اولین اتصال هم، نه فقط وقتی تانل برقرار است.';

  @override
  String get wn56Wheel =>
      'چرخ پرچم‌ها با یک لغزش نرم می‌رود: یک پرتاب یک کشور را می‌آورد و فرود، جای اینکه با ضربه بنشیند، آرام در جای خود می‌ایستد — کشیدن، سنگین و پیوسته مثل یک ولوم خوب خوانده می‌شود.';

  @override
  String get designGazette => 'روزنامه';

  @override
  String get designGazetteDesc =>
      'روزنامه: سرلوحه، ستون‌های خط‌کشی‌شده و مُهر جوهر — آرامش صفحهٔ اول، با کاغذ و مرکب';

  @override
  String get speedTestSizesTitle => 'اندازهٔ آزمون';

  @override
  String get wn61Gta =>
      'طرح جی‌تی‌ای: اچ‌دی خودِ بازی — چرخ اسلحه برای پرچم‌ها، تونل سبز رادار، پنل‌های کهربایی، فونت سنگین و صدای مخصوصش';

  @override
  String get wn61Sound =>
      'تیکِ چرخ: هر خانه‌ای که صفحه می‌گذرد، در گوش هم جواب می‌دهد';

  @override
  String get wn62Wheel =>
      'بازسازی چرخ اسلحه: خانه‌ها در هر تعداد کشور فاصله‌ی خود بازی را دارند، بخش انتخاب‌شده گوه‌ی روشن چرخ را می‌گیرد و شوتِ دست صفحه را می‌پراند';

  @override
  String get wn62Map =>
      'نقشه‌ی خانه حالا رنگ‌های مخصوص هر طرح را می‌پوشد — آب، خشکی و شبکه از طرحی که صفحه دارد پیروی می‌کنند';

  @override
  String get wn62HudMap =>
      'نقشه‌ی مخصوص طرح جی‌تی‌ای: صفحه‌ی اچ‌دی بازی — آب عمیق، ساحل نئون، شبکه‌ی رادار کهربایی و جاروبی که وقتی تونل روشن است جهان را می‌پیماید';

  @override
  String get wn62Aether =>
      'بازسازی دکمه‌ی قدرت طرح Aether: دیسک در حلقه‌ای باریک می‌نشیند، کمان اتصال روی حلقه می‌چرخد و رویِ ماشین‌خورده نور را می‌گیرد';

  @override
  String get wn62Gta =>
      'پد اتصال جی‌تی‌ای جوابِ دست می‌دهد — کل پنل با فشار کمی فرو می‌رود و نشان قدرت هنگام اتصال کنار می‌کشد';

  @override
  String get speedTestSizeLight => 'سبک';

  @override
  String get speedTestSizeStandard => 'استاندارد';

  @override
  String get speedTestSizeFull => 'کامل';

  @override
  String get speedTestJitter => 'لرزش';

  @override
  String gazetteEdition(int n) {
    return 'شمارهٔ $n';
  }

  @override
  String get gazetteBulletin => 'بولتن امنیت';

  @override
  String get gazetteLiveWire => 'اخبار فوری';

  @override
  String get wn56Speed =>
      'تست سرعت جان گرفت: هر لگ روی اتصال خودش و با HTTP/1.1 ساده اندازه می‌گیرد، پس آپلود با بسته‌شدن پنجرهٔ دانلود نمی‌میرد — و پنل، تأخیر مسیر، لرزش و اندازهٔ آزمون را هم می‌دهد.';

  @override
  String get wn56Gazette =>
      'خانهٔ تازه: روزنامه — صفحهٔ اول با سرلوحه، ستون‌های خط‌کشی‌شده، نوار اخبار زنده و مُهر جوهر که با برقراری تونل کوبیده می‌شود.';

  @override
  String get designIos => 'iOS';

  @override
  String get designIosDesc =>
      'حال‌وهوای سیستم: جدول‌های گروهی، خط مویی نوار پایین، کارت وضعیت و دکمهٔ کپسولی — شفافیت به زبان خود سیستم';

  @override
  String get gazetteSection => 'بخش';

  @override
  String get wn58Lock =>
      'قفل دستگیره وقتی تونل برقرار است رنگ خودش را نگه می‌دارد: نشانه حالا سطح زیر پایش را می‌خواند — روی دستگیرهٔ روشن تیره، روی تیره سفید — پس دیگر آیکون غرق نمی‌شود.';

  @override
  String get wn58Enter =>
      'بخش «متصل» نرم نفس می‌کشد: اعداد با محوشدن و بالارفتن می‌آیند و جای‌شان زیرشان باز می‌شود، و به همان نرمی بیرون می‌روند — کارت‌ها دیگر بین دو فریم پرش نمی‌زنند.';

  @override
  String get wn58Speed =>
      'تست سرعت سبک‌تر می‌دود: پنل حداکثر ده بار در ثانیه رنگ می‌شود، عقربهٔ زمان‌سنج خطی کوتاه و روان می‌پیماید، و چهره‌های پنل به‌جای پرش، محو‌به‌م هم می‌روند.';

  @override
  String get wn58Ios =>
      'طرح تازه: iOS — حال‌وهوای خود سیستم، از جدول‌های گروهی و خط مویی نوار پایین تا کارت وضعیت با دکمهٔ کپسولی. هر صفحه، کارت، پنجره و آیکون به زبان سیستم، در هر دو حالت.';

  @override
  String get wn58Pixel =>
      'طرح تازه: پیکسل — حال‌وهوای Material You، سطوح رنگی ملایم، کارت‌های توپر بزرگ، نوار نشانگر کپسولی و تیترهای درشت. هر صفحه، کارت، پنجره و آیکون به زبان خود اندروید، در هر دو حالت.';

  @override
  String get wn58Paper =>
      'روزنامه حالا یک روزنامهٔ کامل است: نوار بخش‌های مخصوص خودش با نشان چاپی و خط زیر عنوان، سرصفحهٔ بخش برای هر صفحهٔ جدا، و جعبهٔ کاغذی خط‌کشی‌شده برای هر گروه تنظیمات — خطوط چاپ به کل اپ رسیده است.';

  @override
  String get wn59Flags =>
      'پرچم‌ها برش مخصوص هر طرح را می‌پوشند: مدال گرد در iOS و اثیر، اسکویرکل در زد، بشقاب خط‌کشی‌شده در روزنامه، و گوشه‌های نرم درشت پیکسل — چرخ، نوار و پرچم کوچک همهٔ ردیف‌ها پیروی می‌کنند.';

  @override
  String get wn59Map =>
      'نقشهٔ جهان با مرکب مخصوص هر طرح کشیده می‌شود: قهوه‌ای گرم کاغذ در روزنامه، خاکستری شب بنفش در زد، آبی‌خاکستری رنگی در پیکسل — جهانِ هر طرح متعلق به صفحهٔ خودش است.';

  @override
  String get wn59Buttons =>
      'دکمه‌های اتصال به زبان طرح خودشان حرف می‌زنند: قرص بزرگ رنگی Material You در پیکسل، نفس‌کشیدن کپسول iOS هنگام برقراری اتصال، و ورود کارت‌های هر صفحه با حرکت مخصوص طرح خودش.';

  @override
  String get wn59Scroll =>
      'چرخ‌ها و نوارها با فیزیک مخصوص هر طرح می‌لغزند: جهش سیستم، توقف سریع متریال، و وزن کاغذ که در برابر تاخوردن می‌ایستد.';

  @override
  String get flagAllPlaces => 'همهٔ مقصدها';

  @override
  String get gazetteRegions => 'مقصدها';

  @override
  String get wn60Flags =>
      'هر طرح حالا کشورها را به شکل خودش نشان می‌دهد: تختهٔ کاشی‌های بنتو، تراشه‌های فیلتری پیکسل، کپسول‌های گزینه‌ای اثیر، دستهٔ مدال‌های iOS، تختهٔ صفحه‌صفحه‌ای زد، و نمایهٔ مقصدهای روزنامه مثل چاپ خود روزنامه — چرخ، چرخِ خودش را نگه می‌دارد.';

  @override
  String get wn60Bento =>
      'طرح بنتو کامل ایستاده: پالت گرم خودش از چینی و زغال، نور نارنجی، سکوی کاشی‌ها، سرصفحه‌های چهارگوشِ صفحه‌ها، کارت‌های رنگ‌گرفته و تختهٔ پرچم‌ها — همهٔ صفحه‌ها، در هر دو حالت.';

  @override
  String get wn60Spacing =>
      'خانه‌ها با یک ریتم قدم می‌زنند: نوارهای مردهٔ میان بخش‌ها رفته‌اند، کارت‌های پایانی ردیف‌هایشان را پر می‌کنند و هر فاصله با فاصله‌گذاری‌ای که طرح نگه می‌دارد نفس می‌کشد.';

  @override
  String get wn63Retired =>
      'طرح‌های اتر و زد بازنشسته شدند: کاربرانشان به طرح‌هایی می‌روند که همان ساختار را دارند — جدول‌های اتر به iOS، بنتوی زد به بنتو';

  @override
  String get wn63Map =>
      'نقشه جی‌تی‌ای حالا عین نقشه خود بازی است: هر مرز مثل جاده، یک نشان کهربایی روی هر کشورِ سرور، مکان انتخابی به‌شکل وِی‌پوینت با ستون نورش و نامش روی پلاک، و قطب‌نما در گوشه';

  @override
  String get wn63Servers =>
      'صفحه سرورها لیست خودِ هر طرح را می‌پوشد — جدول گروهی iOS، فهرست خط‌کشی‌شده روزنامه، اسلات‌های HUD جی‌تی‌ای، کارت‌های تونال پیکسل، تخته بنتو';

  @override
  String get wn63Accounts =>
      'صفحه حساب‌ها هم طرح را می‌پوشد: کارت‌ها با گردی خودِ طرح، دکمه افزودن با صدای طرح، عنوان دیالوگ‌ها با قلم نمایش، فیلدها در قاب طرح';

  @override
  String get wn63Wheel =>
      'چرخ اسلحه با اندازه خود بازی بازسازی شد: دایرهٔ کامل خط‌های جداکننده، برش روشن دولایه، کمان گیج شمارنده، پرشِ باز شدن، و تپش خود انتخاب';

  @override
  String get wn63Ios =>
      'طرح iOS کامل‌تر ایستاده: شستوی حالت روی کارت وضعیت، نقطه‌های صفحه دسته مدال‌ها، و تیک هر اسنپ';

  @override
  String get wn64Wheel =>
      'مدال‌های چرخ جی‌تی‌ای حالا داخل صفحه‌دل می‌نشینند — دوازده جایگاه با چیدمان خود بازی، نه مدالی روی لبه و نه کسی بیرون از لبهٔ صفحه، و هیچ دو مدالی به هم نمی‌رسند';

  @override
  String get wn64Glass =>
      'چرخ شیشهٔ خود بازی را پوشید: جهان زیر صفحه‌دل نرم مات می‌شود، صفحه کمی شفاف است و درخششش در بالا جمع شده';

  @override
  String get wn64Groups =>
      'گروه‌های خودِ صفحهٔ اصلی iOS: جدول نشست — نشانی تونل با یک ضربه در کلیپ‌بورد — و کنش‌های سریع: تست سرعت، تنظیمات اتصال و حساب‌ها';

  @override
  String get wn64Headers =>
      'سرصفحهٔ هر صفحه دوباره به اندازهٔ صفحه کشیده می‌شود — فلش بازگشت سر جایش در لبه است، نه وسط صفحه';

  @override
  String get wn64Pill =>
      'برچسب قرص Material You نفسش را داخل انحناهای گرد نگه می‌دارد';

  @override
  String get wn64Map =>
      'مرزهای نقشهٔ جی‌تی‌ای به لباس اول خود برگشتند — ساحل نئونش را نگه داشت و خشکی لبهٔ خطِ نازک خود را';

  @override
  String get wn64Name =>
      'طرح پیکسل حالا به نام خودش صدا زده می‌شود: Material You';

  @override
  String get wn65Gone =>
      'طرح GTA رفت: خانه‌اش، صفحه‌هایش، پالتش — پنج طرح می‌مانند و فایل تنظیماتی که هنوز نامش را دارد روی چرخ می‌افتد';

  @override
  String get wn65Tight =>
      'خانه در همهٔ طرح‌ها جمع‌وجورتر شد: نوارهای خالی‌ای که بقیهٔ صفحه میان کارت‌ها باز می‌کرد از میان رفت — چرخ، کاشی‌ها، روزنامه، مدال‌ها و چیپ‌ها با یک نفس فاصله پشت هم می‌آیند و صفحه به‌جای کش آمدن، اسکرول می‌خورد';

  @override
  String get wn65Radar =>
      'نقشه‌ای که طرح GTA با خود می‌آورد حالا به نام خودش می‌ایستد: رادار — همان آب عمیق، شبکهٔ کهربایی و خط پویش، این بار با نام خودش در انتخابگر نقشه';

  @override
  String get wn67Port =>
      'تنظیمِ پورت اتصال حذف شد: سرورها فقط روی پورتِ خودِ فهرست پاسخ می‌دهند — اجبارِ یک پورت، همه‌ی اتصال‌ها را می‌بست و کانفیگی که چنین مقداری داشت آن را در نخستین اجرا کنار می‌گذارد';

  @override
  String get wn67Back =>
      'اتصال دوباره سر جایش است — بقیه‌ی چیزها همان‌جاست که 1.0.65 گذاشت: پنج طرح، نقشه‌ی رادار و تانلِ پایدار';

  @override
  String get designUr =>
      'URnetwork';

  @override
  String get designUrDesc =>
      'چهره‌ی URnetwork: دکمه‌ی اتصال گرد، کارت مکان و پنل آمار زنده که با کشیدن بالا باز می‌شود';

  @override
  String get urConnect =>
      'اتصال';

  @override
  String get urDisconnect =>
      'قطع اتصال';

  @override
  String get urChangeLocation =>
      'تغییر';

  @override
  String get urStatsTitle =>
      'آمار زنده';

  @override
  String get urStatsHint =>
      'بالا بکشید';

  @override
  String get urSpeedUp =>
      'بالا';

  @override
  String get urSpeedDown =>
      'پایین';

  @override
  String get urSessionTime =>
      'مدت اتصال';

  @override
  String get urSessionData =>
      'داده جلسه';

  @override
  String get urExitLocation =>
      'مکان خروج';

  @override
  String get urLastTest =>
      'آخرین تست';

  @override
  String get urNoData =>
      'هنوز داده‌ای نیست';

  @override
  String get urSectionGeneral =>
      'عمومی';

  @override
  String get urSectionConnections =>
      'اتصال‌ها';

  @override
  String get urSectionAppearance =>
      'ظاهر';

  @override
  String get urSectionAbout =>
      'درباره';

  @override
  String get urNavStyle =>
      'سبک ناوبری';

  @override
  String get urNavStyleNote =>
      'شکل نوار پایین صفحه را تغییر می‌دهد.';

  @override
  String get urNavMorphing =>
      'مورفینگ';

  @override
  String get urNavNeon =>
      'درخشش نئون';

  @override
  String get urNavBubble =>
      'حبابی';

  @override
  String get urNavCapsule =>
      'کپسولی';

  @override
  String get urBatterySaverNote =>
      'حرکت صفحه اصلی هنگام اتصال آرام می‌شود.';

  @override
  String get urUsageTitle =>
      'مصرف جلسه';

  @override
  String get urUsageTotal =>
      'جمع';

  @override
  String get urWhatsNew =>
      'تازه‌ها';

  @override
  String get urAboutUpdates =>
      'برنامه و به‌روزرسانی‌ها';

  @override
  String get wn70UrNav =>
      'ناوبری URnetwork به طرح اضافه شد: نوار شناور مورفینگ که هایلایتش بین زبانه‌ها سر می‌خورد، درخشش نئون، حباب‌ها و کپسولی — از تنظیمات ← ظاهر انتخابش کنید';

  @override
  String get wn70UrCards =>
      'صفحه تنظیمات URnetwork: بخش‌ها و کارت‌ها، زبان، سبک ناوبری و نوار مصرف جلسه در کشو';

  @override
  String get urQuickTitle =>
      'گزینه‌های سریع';

  @override
  String get urShare =>
      'اشتراک هات‌اسپات';

  @override
  String get urShareDesc =>
      'گوشی‌تان را تبدیل به دروازه کنید: دستگاه‌های روی هات‌اسپاتش می‌توانند از VPN بگذرند. هات‌اسپات را روشن کنید، دستگاه دیگر را وصل کنید، و پروکسی آن را روی نشانی زیر بگذارید.';

  @override
  String get urShareProxy =>
      'نشانی پروکسی';

  @override
  String get urShareCopied =>
      'کپی شد';

  @override
  String get urShareOpenHotspot =>
      'باز کردن تنظیمات هات‌اسپات';

  @override
  String get urShareOn =>
      'اشتراک روشن است — پروکسی روی هات‌اسپات پاسخ می‌دهد.';

  @override
  String get urShareNeedsVpn =>
      'اول VPN را وصل کنید؛ دستگاه‌های اشتراکی از تونل آن می‌گذرند.';

  @override
  String get urShareSteps =>
      '۱. هات‌اسپات گوشی را روشن کنید\n۲. دستگاه دیگر را به هات‌اسپات وصل کنید\n۳. روی آن دستگاه، تنظیمات پروکسی شبکه وای‌فای را باز کنید و Manual را انتخاب کنید\n۴. نشانی بالا را در قسمت سرور بگذارید — همان نشانی به SOCKS5 هم پاسخ می‌دهد';

  @override
  String get urShareNote =>
      'تا وقتی VPN وصل است کار می‌کند. پروکسی هسته روی یک درگاه هم HTTP و هم SOCKS5 را پاسخ می‌دهد؛ با خاموش کردن اشتراک، درگاه دوباره فقط روی همان سیستم می‌شنود.';

  @override
  String get wn71Nav =>
      'ناوبری حالا فقط نوار کلاسیک پایین است — قرص متحرک، هاله‌ی نئون، حباب‌ها و کپسول همراه با انتخاب‌گرشان حذف شدند.';

  @override
  String get wn71Stats =>
      'آمار کشو با دقتِ خود نسخه اصلی حرف می‌زند: نمودار انتقال آینه‌شده روی محور میانی، برچسب بیشینه‌ی هر جهت سر جای خودش، و هر سرعتی به شکل 2.50 KiB/s.';

  @override
  String get wn71Drawer =>
      'کشوی بالا کشیده‌شده زیر ناوبری می‌ایستد و گزینه‌های سریع می‌گیرد: کلید قطع اضطراری، سرعت و پرچم اعلان، مسیریابی هر اپ، و اشتراک هات‌اسپات.';

  @override
  String get wn71Share =>
      'اشتراک هات‌اسپات: گوشی را تبدیل به دروازه‌ی VPN برای دستگاه‌های روی هات‌اسپاتش کنید — یک کلید پروکسی را باز می‌کند، صفحه نشانی و مراحل را می‌گوید.';

  @override
  String get changeUi =>
      'تغییر UI/UX';

  @override
  String get wn68Toast =>
      'اعلان‌های شناور افکت مات را کنار گذاشتند: یک افکت سنگین کمتر در هر اعلان، گوشی‌های ضعیف فریم‌هایشان را نگه می‌دارند';

  @override
  String get urReadyToConnect =>
      'آماده برای اتصال';

  @override
  String get urConnectFailed =>
      'اتصال ناموفق بود';

  @override
  String get wn69Ur =>
      'صفحه‌ی URnetwork همان‌طور که خودش دارد منتقل شد: وجه اتصالِ مربعِ پله‌ای، ضربان «برای اتصال بزنید»، شبکه‌ی نقاط در حال ساخته شدن تانل و میدان‌های رنگی که با برقراری می‌نشینند';

  @override
  String get wn69Stats =>
      'کشو، هندسه‌ی اصلی را نگه می‌دارد: ردیف مکان و «اتصال» در لبه، و زیر لبه سرعت‌های زنده، اعداد جلسه، مکان خروج و آخرین تست';

  @override
  String get wn68Stats =>
      'لبه‌ی پایین صفحه‌ی اصلی را بالا بکشید: سرعت‌های زنده، نمودار جلسه، مکان خروج، IP و آخرین تست — چیزی که هسته از قبل نمی‌گوید نمی‌خواهد';

  @override
  String get wn68Ur =>
      'طرح URnetwork به انتخابگر پیوست: دکمه‌ی اتصالِ گرد که نقاطش با بالا آمدن تانل جمع می‌شوند، کارت مکان و دکمه‌ی «اتصال» — از بخش ظاهر انتخابش کنید';
}
