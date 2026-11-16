// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Qoşulmaq üçün sürüşdür';

  @override
  String get slideToDisconnect => 'Ayırmaq üçün sürüşdür';

  @override
  String get navOverview => 'İcmal';

  @override
  String get navAccounts => 'Hesablar';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get stateConnected => 'Qoşulub';

  @override
  String get stateConnecting => 'Qoşulur…';

  @override
  String get stateWaiting => 'Gözləyir';

  @override
  String get waitingForAccount =>
      'Qoşulmaq üçün Hesablar səhifəsində Firefox Account əlavə edin.';

  @override
  String get waitingForEnabledAccount =>
      'Bütün hesablar söndürülüb. Hesablar səhifəsində birini yandırın.';

  @override
  String get stateError => 'Xəta';

  @override
  String get stateUnknown => 'Naməlum';

  @override
  String get restartProxy => 'Proksini yenidən başlat';

  @override
  String copied(String value) {
    return '$value kopyalandı';
  }

  @override
  String get activeAccount => 'Aktiv hesab';

  @override
  String get noActiveAccount => 'Aktiv hesab yoxdur';

  @override
  String get quotaNotRead => 'Trafik hələ yoxlanılmayıb';

  @override
  String get unlimited => 'Limitsiz';

  @override
  String usedOf(String used, String limit) {
    return '$used / $limit istifadə olunub';
  }

  @override
  String resets(String date) {
    return '$date tarixində sıfırlanır';
  }

  @override
  String switchAt(int percent) {
    return '$percent%-də hesab dəyişir';
  }

  @override
  String get publicIp => 'Xarici IP';

  @override
  String get testConnection => 'Bağlantını yoxla';

  @override
  String get testing => 'Yoxlanılır…';

  @override
  String get testFailed => 'Uğursuz';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'indicə';

  @override
  String minutesAgo(int n) {
    return '$n dəq əvvəl';
  }

  @override
  String hoursAgo(int n) {
    return '$n saat əvvəl';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün əvvəl',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'saat $time';
  }

  @override
  String durationDays(int d, int h) {
    return '${d}g ${h}s';
  }

  @override
  String durationHours(int h, int m) {
    return '${h}s ${m}dəq';
  }

  @override
  String durationMinutes(int m, int s) {
    return '${m}dəq ${s}san';
  }

  @override
  String durationSeconds(int s) {
    return '${s}san';
  }

  @override
  String accountsGuide(String size) {
    return 'Hər Firefox Account-un ayda $size trafiki var. Bir neçə hesab əlavə edə bilərsiniz: biri bitəndə tətbiq özü növbətiyə keçir.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'Bu siyahının sırası ilə: hər hesab $percent%-dək, sonuncu isə datası bitənədək.';
  }

  @override
  String get addAccount => 'Hesab əlavə et';

  @override
  String lowQuotaNotice(String size) {
    return 'Bu hesabın trafiki bitmək üzrədir. Daha bir hesab əlavə etsəniz, $size əlavə trafikiniz olacaq.';
  }

  @override
  String get noAccounts => 'Hələ hesab yoxdur';

  @override
  String get noAccountsHint => 'Qoşulmaq üçün Firefox Account əlavə edin.';

  @override
  String get delayTestFailed =>
      'Serverlərin gecikməsi ölçülə bilmədi. İnterneti yoxlayın.';

  @override
  String get createAccountTitle => 'Firefox Account hesabınız yoxdur?';

  @override
  String get createAccountHint =>
      'accounts.firefox.com saytında pulsuz hesab yaradın, sonra qayıdıb «Hesab əlavə et» düyməsini basın.';

  @override
  String get moveUp => 'Yuxarı';

  @override
  String get moveDown => 'Aşağı';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusReady => 'Hazır';

  @override
  String get statusNeedsSignIn => 'Giriş lazımdır';

  @override
  String get statusReserved => 'Ehtiyatda';

  @override
  String get statusUnavailable => 'Əlçatmaz';

  @override
  String statusUnavailableUntil(String date) {
    return '$date tarixinədək əlçatmaz';
  }

  @override
  String get statusDisabled => 'Deaktiv';

  @override
  String get statusEnabled => 'Aktiv';

  @override
  String get useNow => 'İndi istifadə et';

  @override
  String get signInAgain => 'Yenidən daxil ol';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Bu hesabın həcmi $percent%-ə çatdı və növbəti hesab aktivləşdi.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Bu ayın trafiki bitib; aylıq sıfırlamadan sonra yenidən istifadə olunur.';

  @override
  String get reasonSignInRequired =>
      'Bu hesabdan istifadə etmək üçün yenidən daxil olun.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla girişin təsdiqini istəyir: «Yenidən daxil ol» düyməsini basın (yalnız kod lazımdır).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Avtomatik giriş alınmadı ($detail). Yenidən daxil olun.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'Son avtomatik giriş qısa müddət sonra işləməyi dayandırdı; növbəti cəhd saat $time-dadır.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Avtomatik giriş başa çatmadı ($detail); saat $time-da yenidən cəhd ediləcək.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla bu hesabı qəbul etmədi; sonra yenidən cəhd ediləcək.';

  @override
  String get more => 'Daha çox';

  @override
  String get refreshQuota => 'Trafiki yenilə';

  @override
  String get remove => 'Sil';

  @override
  String get removeTitle => 'Hesab silinsin?';

  @override
  String removeBody(String name) {
    return '$name və onun saxlanmış giriş məlumatları bu kompüterdən silinəcək. Sonra yenidən əlavə edə bilərsiniz.';
  }

  @override
  String get unlimitedQuota => 'Limitsiz trafik';

  @override
  String get signInTitle => 'Giriş';

  @override
  String get signInIntro => 'Firefox Account ilə daxil olun.';

  @override
  String get email => 'E-poçt';

  @override
  String get emailInvalid => 'Hesabın e-poçt ünvanını daxil edin';

  @override
  String get password => 'Parol';

  @override
  String get passwordEmpty => 'Parolu daxil edin';

  @override
  String get show => 'Göstər';

  @override
  String get hide => 'Gizlət';

  @override
  String get signIn => 'Daxil ol';

  @override
  String get continueLabel => 'Davam et';

  @override
  String get done => 'Hazır';

  @override
  String get close => 'Bağla';

  @override
  String get noBrowserTitle => 'Bu cihazda brauzer yoxdur';

  @override
  String get noBrowserText =>
      'Bu ünvanı telefonunuzda və ya kompüterinizdə açın:';

  @override
  String get cancel => 'Ləğv et';

  @override
  String get tryAgain => 'Yenidən cəhd et';

  @override
  String get signingIn => 'Daxil olunur…';

  @override
  String get accountReady => 'Hesab hazırdır';

  @override
  String get accountReadyHint => 'Hesablar siyahısının sonuna əlavə olundu.';

  @override
  String get captchaLabel => 'Şəkildəki simvollar';

  @override
  String get codeLabel => 'Kod';

  @override
  String get captchaBroken => 'CAPTCHA şəkli göstərilə bilmədi.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla $email ünvanına kod göndərdi. Onu buraya daxil edin.';
  }

  @override
  String get stepTotp => 'Autentifikator tətbiqindəki kodu daxil edin.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla bu girişi şübhəli hesab etdi və $email ünvanına blokdan çıxarma kodu göndərdi. Onu buraya daxil edin.';
  }

  @override
  String get stepCaptcha => 'Şəkildəki simvolları yazın.';

  @override
  String stepEmailLink(String email) {
    return 'Mozilla-nın $email ünvanına göndərdiyi təsdiq linkini açın. Sonra hər şey avtomatik davam edəcək.';
  }

  @override
  String get signInFailed => 'Hesab əlavə olunmadı.';

  @override
  String get signInCancelled => 'Giriş ləğv edildi.';

  @override
  String get signInNoAccount => 'Bu e-poçtla Firefox Account yoxdur.';

  @override
  String get signInNoAccountHint =>
      'E-poçtu yoxlayın və ya bu e-poçtla Mozilla saytında pulsuz Firefox Account yaradın, onu poçt qutunuzdan təsdiqləyin, sonra buraya əlavə edin.';

  @override
  String get createAccountButton => 'Firefox Account yarat';

  @override
  String get signInWrongPassword => 'Şifrə səhvdir.';

  @override
  String get signInNoPassword =>
      'Bu hesabın şifrəsi yoxdur: Google və ya Apple ilə giriş vasitəsilə yaradılıb. Şifrə təyin edin, sonra onunla burada daxil olun.';

  @override
  String get setPasswordButton => 'Şifrə təyin et';

  @override
  String get signInTooManyAttempts =>
      'Çox cəhd edildi. Bir az gözləyin və yenidən cəhd edin.';

  @override
  String get signInUnblockRejected =>
      'Blokdan çıxarma kodu qəbul olunmadı. Mozilla-nın son məktubundakı kodu istifadə edin.';

  @override
  String get signInWrongCode =>
      'Kod səhvdir və ya vaxtı keçib. Mozilla-nın son məktubundakı kodu istifadə edin; yeni kod göndəriləndə köhnəsi işləmir.';

  @override
  String get signInWrongTotp =>
      'Kod səhvdir. Autentifikator tətbiqinin indi göstərdiyi kodu daxil edin.';

  @override
  String get signInTooManyCodes =>
      'Çox səhv kod daxil edildi. Girişə yenidən başlayın.';

  @override
  String get signInTimedOut => 'Giriş çox uzun çəkdi. Yenidən başlayın.';

  @override
  String get signInNetwork =>
      'Mozilla-ya qoşulmaq mümkün olmadı. İnterneti yoxlayın və yenidən cəhd edin.';

  @override
  String get coreConnecting => 'Nüvəyə qoşulur…';

  @override
  String get coreLost => 'Nüvə ilə əlaqə kəsildi. Yenidən cəhd edilir…';

  @override
  String get cantReachCore => 'Nüvəyə qoşulmaq mümkün deyil';

  @override
  String get startingCore => 'Nüvə işə salınır…';

  @override
  String get retry => 'Yenidən cəhd et';

  @override
  String errNoCore(String path) {
    return 'Nüvə proqramı tətbiqin yanında tapılmadı ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'Nüvə dayandı: $detail';
  }

  @override
  String get errNotAnswering => 'Nüvə cavab vermir.';

  @override
  String get errRefused =>
      'Nüvə tətbiqi qəbul etmədi; ola bilsin ki, o, tətbiqin başqa nüsxəsinə aiddir.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get sectionGeneral => 'Ümumi';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Sistem dili';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açıq';

  @override
  String get themeDark => 'Tünd';

  @override
  String get closeBehavior => 'Pəncərə bağlananda';

  @override
  String get closeAsk => 'Hər dəfə soruş';

  @override
  String get closeTray => 'Saatın yanında gizlət';

  @override
  String get closeQuit => 'Tətbiqdən çıx';

  @override
  String get sectionConnection => 'Bağlantı';

  @override
  String get localProxy => 'Lokal proksi';

  @override
  String get systemProxy => 'Sistem proksisi';

  @override
  String get sectionRouting => 'Marşrutlaşdırma';

  @override
  String get routingDirect => 'Yerli saytlar üçün birbaşa bağlantı';

  @override
  String get routingDirectHint =>
      'Seçilmiş ölkənin saytları və IP-ləri VPN-dən keçmir: daha sürətli açılır və trafikə qənaət olunur.';

  @override
  String get region => 'Ölkə';

  @override
  String get regionIr => 'İran';

  @override
  String get regionCn => 'Çin';

  @override
  String get regionRu => 'Rusiya';

  @override
  String get regionAf => 'Əfqanıstan';

  @override
  String get regionTr => 'Türkiyə';

  @override
  String get regionId => 'İndoneziya';

  @override
  String get regionBr => 'Braziliya';

  @override
  String get regionNone => 'Heç biri';

  @override
  String get saved => 'Saxlanıldı';

  @override
  String get dataFolder => 'Məlumat qovluğu';

  @override
  String get openFolder => 'Qovluğu aç';

  @override
  String get unofficialNote =>
      'Qeyri-rəsmi tətbiq. Mozilla ilə əlaqəsi yoxdur.';

  @override
  String get closeTitle => 'Pəncərə bağlansın?';

  @override
  String get closeBody =>
      'Saatın yanında gizlədiləndə VPN qoşulu qalır. Tətbiqdən çıxanda isə VPN söndürülür.';

  @override
  String get rememberChoice => 'Seçimimi yadda saxla';

  @override
  String get minimizeToTray => 'Saatın yanında gizlət';

  @override
  String get quit => 'Çıx';

  @override
  String get trayOpen => 'Aç';

  @override
  String get trayQuit => 'Çıx';

  @override
  String get trayProxyOnly => 'Yalnız proksi xidməti';

  @override
  String get traySetSystemProxy => 'Sistem proksisini qur';

  @override
  String errPortInUse(String port) {
    return '$port portu başqa proqram tərəfindən istifadə olunur, buna görə tətbiq nüvəyə qoşula bilmir.';
  }

  @override
  String proxyPortInUse(String port) {
    return '$port portu başqa proqram tərəfindən istifadə olunur, buna görə proksi işə düşə bilmir.';
  }

  @override
  String get changePort => 'Portu dəyiş';

  @override
  String get portDialogTitle => 'Port seçin';

  @override
  String portDialogBody(String port) {
    return '$port portu məşğuldur. Aşağıda boş port təklif olunur; başqasını da yaza bilərsiniz.';
  }

  @override
  String get portChangeBody =>
      'Tətbiqlər bu porta qoşulur. 1024 ilə 65535 arasında bir port seçin.';

  @override
  String get portLabel => 'Port';

  @override
  String get portInvalid => '1024-dən 65535-ə qədər port daxil edin';

  @override
  String get portBusy => 'Bu port da məşğuldur';

  @override
  String get portInUse => 'Bu portdan başqa proqram istifadə edir';

  @override
  String get save => 'Saxla';

  @override
  String get proxyPort => 'Proksi portu';

  @override
  String get appPort => 'Tətbiq portu';

  @override
  String get welcomeTitle => 'Xoş gəlmisiniz';

  @override
  String get welcomeBody =>
      'Dilinizi və ölkənizi seçin. Ölkənizin saytları VPN olmadan birbaşa açılır: bu, daha sürətlidir və trafikə qənaət edir.';

  @override
  String get start => 'Başla';

  @override
  String routingSuggestTitle(String country) {
    return '$country saytları birbaşa açılsın?';
  }

  @override
  String routingSuggestBody(String country) {
    return '$country saytları və IP-ləri VPN olmadan birbaşa açılacaq. Bunu Marşrutlaşdırma bölməsində dəyişə bilərsiniz.';
  }

  @override
  String get yes => 'Bəli';

  @override
  String get notNow => 'İndi yox';

  @override
  String get navServers => 'Serverlər';

  @override
  String get navLogs => 'Loglar';

  @override
  String get realDelay => 'Real gecikmə';

  @override
  String get statElapsed => 'Müddət';

  @override
  String get statDown => 'Yüklənmə';

  @override
  String get statUp => 'Göndərmə';

  @override
  String noticePort(String port) {
    return 'Mozilla-nın proksisi $port portuna qoşulmur. Yalnız 80, 443, 8080 və 8443 portları VPN-dən keçir.';
  }

  @override
  String get noticeCommand => 'Bu bağlantı növü VPN-də dəstəklənmir.';

  @override
  String noticeTimes(int count, String time) {
    return '$count dəfə, sonuncu: $time';
  }

  @override
  String get dismiss => 'Bağla';

  @override
  String get modeRecommended => 'Tövsiyə olunan';

  @override
  String get modeFastest => 'Ən sürətli';

  @override
  String get modeRecommendedHint => 'Məkanı Mozilla sizin üçün seçir.';

  @override
  String get modeFastestHint => 'Hər qoşulanda ən az gecikməli məkan seçilir.';

  @override
  String get testDelay => 'Real gecikməni yoxla';

  @override
  String get testingDelay => 'Ölçülür…';

  @override
  String get search => 'Axtar';

  @override
  String get noAnswer => 'Cavab yoxdur';

  @override
  String testedAgo(String ago) {
    return 'Yoxlanıb: $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$total serverdən $answered cavab verdi';
  }

  @override
  String get noServers =>
      'Hələ server yoxdur. Nüvə Mozilla-ya qoşulandan sonra görünəcək.';

  @override
  String get levelAll => 'Hamısı';

  @override
  String get filter => 'Filtr';

  @override
  String get follow => 'Avtomatik sürüşdürmə';

  @override
  String get clear => 'Təmizlə';

  @override
  String get copyAll => 'Kopyala';

  @override
  String get logsCopied => 'Loglar kopyalandı';

  @override
  String get noLogs => 'Hələ log yoxdur.';

  @override
  String get sectionAccounts => 'Avtomatik hesab dəyişmə';

  @override
  String get switchThreshold => 'Hesab dəyişmə həddi';

  @override
  String get switchThresholdHint =>
      'Trafikin bu qədəri istifadə olunanda növbəti hesaba keçilir.';

  @override
  String get signInMethod => 'Giriş üsulu';

  @override
  String get signInMethodBrowser => 'Brauzerlə giriş';

  @override
  String get signInMethodApi => 'Birbaşa giriş';

  @override
  String get browserSignInBroken => 'Giriş səhifəsi açıla bilmədi.';

  @override
  String get browserSignInBlocked =>
      'Mozilla hesabın əlavə edilməsinin son addımını tamamlamadı (HTTP 406).';

  @override
  String get browserSignInFallback => 'E-poçt və şifrə ilə giriş';

  @override
  String get backupExport => 'Ehtiyat nüsxəni saxla';

  @override
  String get backupImport => 'Ehtiyat nüsxəni idxal et';

  @override
  String backupSaved(String name) {
    return 'Saxlanıldı: $name';
  }

  @override
  String get backupImportTitle => 'Bu hesablar əlavə edilsin?';

  @override
  String get backupAccountExists =>
      'Artıq əlavə edilib; girişi fayldan alınacaq';

  @override
  String get backupImportAction => 'Əlavə et';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hesab əlavə edildi',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS serverləri';

  @override
  String get dnsSystem => 'Sistem';

  @override
  String get dnsAuto => 'Avtomatik (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Fərdi';

  @override
  String get dnsCustomHint =>
      'Hər sətirdə bir: https://…/dns-query, tls://… və ya IP ünvanı.';

  @override
  String get dnsFallback => 'Lazım olsa sistem DNS-inə keç';

  @override
  String get testDns => 'DNS-i yoxla';

  @override
  String get transport => 'Protokol';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP versiyası';

  @override
  String get ipVersionAuto => 'Avtomatik (əvvəl IPv4, sonra IPv6)';

  @override
  String get ipVersionDual => 'Hər ikisi birlikdə (dual-stack)';

  @override
  String get ipVersionV6First => 'Əvvəl IPv6, sonra IPv4';

  @override
  String get ipVersionV4 => 'Yalnız IPv4';

  @override
  String get ipVersionV6 => 'Yalnız IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'VPN interfeysinin paket ölçüsü, 1280-dən 9000-ə qədər. Boş: avtomatik.';

  @override
  String get tunMtuInvalid => '1280-dən 9000-ə qədər rəqəm və ya boş';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Birbaşa';

  @override
  String get directRulesHint =>
      'Bu siyahıdakı saytlar və ünvanlar VPN olmadan, birbaşa öz internetinizlə açılır. Seçdiyiniz ölkənin qaydaları artıq buradadır: sətir əlavə edə, dəyişə və ya silə bilərsiniz. Başqa ölkə seçmək onları həmin ölkənin qaydaları ilə əvəz edir.';

  @override
  String get restoreRegionRules => 'Ölkə qaydalarını bərpa et';

  @override
  String get blockRules => 'Blokla';

  @override
  String get blockRulesHint =>
      'Bu siyahıdakı saytlar və ünvanlar ümumiyyətlə açılmır — nə birbaşa, nə də VPN ilə: reklamlar və ya heç vaxt açılmasını istəmədiyiniz saytlar üçün.';

  @override
  String get rulesTitle => 'Qaydalar';

  @override
  String get ruleSyntaxTitle => 'Qayda necə yazılır';

  @override
  String get resolveDomains => 'IP qaydalarını domenlərə də tətbiq et';

  @override
  String get routingLists => 'Geo faylları';

  @override
  String get listSource => 'Siyahı mənbəyi';

  @override
  String get listSourceCustom => 'Əl ilə təyin edilib';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Yeniləndi: $ago';
  }

  @override
  String get updateLists => 'Geo fayllarını yenilə';

  @override
  String get listsUpdated => 'Geo faylları yeniləndi.';

  @override
  String get testDestination => 'Marşrutu yoxla';

  @override
  String get destinationHint => 'Sayt adı, IP ünvanı və ya URL';

  @override
  String get check => 'Yoxla';

  @override
  String get routeDirect => 'Birbaşa qoşulur';

  @override
  String get routeProxy => 'VPN-dən keçir';

  @override
  String get routeBlock => 'Bloklanıb';

  @override
  String ruleMatched(String rule) {
    return 'Qayda: $rule';
  }

  @override
  String get portRefusedNote => 'Mozilla-nın proksisi bu porta qoşulmur.';

  @override
  String get sectionAdvanced => 'Əlavə';

  @override
  String get tlsFragment => 'TLS fraqmentasiyası';

  @override
  String get tlsFragmentOff => 'Söndürülüb';

  @override
  String get tlsFragmentFirstByte => 'Birinci bayt';

  @override
  String get tlsFragmentSni => 'Server adı (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'TLS başlığını birinci baytda bölür (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Server adını (SNI) bir neçə TCP paketinə bölür';

  @override
  String get tlsFragmentRecord => 'TLS qeydi';

  @override
  String get tlsFragmentRecordHint =>
      'Server adını (SNI) iki TLS qeydinə bölür';

  @override
  String get tlsFragmentOffHint => 'Adi TLS bağlantısı';

  @override
  String get sectionBypass => 'Mozilla bloklanıbsa';

  @override
  String get sharedRelay => 'Paylaşılan rele';

  @override
  String get sharedRelayHint =>
      'Mozilla regionunuzu bloklayarsa tətbiqin paylaşılan relelərindən istifadə edin. Aktiv şəxsi rele üstünlük təşkil edir.';

  @override
  String get personalRelay => 'Şəxsi rele';

  @override
  String get apiRelay => 'Relay serveri';

  @override
  String get apiRelayUse => 'Relay serverindən istifadə et';

  @override
  String get apiRelayHint =>
      'Öz Cloudflare Worker-iniz və ya öz hostinqinizdəki relay.php.\nYalnız Mozilla birbaşa cavab vermədikdə istifadə olunur: ondan giriş, hesablar və server siyahısı keçir, VPN trafiki yox.';

  @override
  String get upstreamProxy => 'Yuxarı proksi';

  @override
  String get upstreamProxyOn => 'Yuxarı proksi aktivdir';

  @override
  String get upstreamProxyAddress => 'SOCKS5 proksi ünvanı';

  @override
  String get upstreamProxyPort => 'Port';

  @override
  String get upstreamProxyHint =>
      'Mozilla ilə bağlantı bu proksidən keçir; Mozilla-nı bloklayan və ya yavaşladan şəbəkələr üçün.\nProksi bu cihazdadırsa, onu VPN-dən kənarda saxlayın.';

  @override
  String get upstreamProxyInvalid =>
      'Proksi ünvanını daxil edin, məsələn 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => '1-dən 65535-ə qədər port daxil edin.';

  @override
  String get upstreamProxyOwn =>
      'Bu, tətbiqin öz proksisidir. Başqasını daxil edin.';

  @override
  String get apiRelayInvalid => 'https:// ünvanı olmalıdır.';

  @override
  String get listenAddress => 'Proksiyə kim qoşula bilər';

  @override
  String get listenLocal => '127.0.0.1 · yalnız bu cihaz';

  @override
  String get listenAll => '0.0.0.0 · bütün şəbəkələr (LAN)';

  @override
  String get proxyUsername => 'Proksi istifadəçi adı';

  @override
  String get proxyPassword => 'Proksi parolu';

  @override
  String get proxyLoginHint =>
      'Tətbiqlər proksiyə bu ad və parolla qoşulmalıdır. Parolsuz istifadə üçün hər ikisini boş qoyun.';

  @override
  String get loginBothOrNone =>
      'Hər ikisini doldurun və ya hər ikisini boş qoyun.';

  @override
  String get proxyLogin => 'Proksi adı və parolu';

  @override
  String get idleSleep => 'Trafik olmayanda yuxu rejimi';

  @override
  String get sleepNever => 'Heç vaxt';

  @override
  String sleepMinutes(int count) {
    return '$count dəqiqə';
  }

  @override
  String get sleepHour => '1 saat';

  @override
  String get showPublicIp => 'Xarici IP-ni göstər';

  @override
  String get hapticFeedback => 'Bağlantı dəyişəndə titrəmə';

  @override
  String get keepScreenOn => 'Qoşulu olanda ekranı ayıq saxla';

  @override
  String get showTraffic => 'Ana səhifədə canlı trafiki göstər';

  @override
  String get speedInNotification => 'Bildirişdə sürəti göstər';

  @override
  String get liveTraffic => 'Canlı trafik';

  @override
  String get totalTraffic => 'Ümumi trafik';

  @override
  String get verboseLogs => 'Ətraflı loglar';

  @override
  String get webDashboard => 'Veb panel';

  @override
  String get webDashboardOpen => 'Aç';

  @override
  String get webDashboardHint => 'Qabaqcıl ayarlar və daha çox alət';

  @override
  String numberInvalid(int min, int max) {
    return '$min ilə $max arasında rəqəm daxil edin';
  }

  @override
  String get notifySwitchedTitle => 'Hesab dəyişdi';

  @override
  String notifySwitchedBody(String name) {
    return 'İndi $name istifadə olunur.';
  }

  @override
  String get notifySignInTitle => 'Giriş lazımdır';

  @override
  String get notifySignInBody =>
      'Hesablar səhifəsində bir hesaba yenidən daxil olmaq lazımdır.';

  @override
  String get navAbout => 'Haqqında';

  @override
  String get appVersionLabel => 'Tətbiq versiyası';

  @override
  String get coreVersionLabel => 'Nüvə versiyası';

  @override
  String get checkUpdates => 'Yeniləmələri yoxla';

  @override
  String get checkingUpdates => 'Yoxlanılır…';

  @override
  String get upToDate => 'Ən son versiyadan istifadə edirsiniz.';

  @override
  String updateAvailable(String version) {
    return '$version versiyası mövcuddur.';
  }

  @override
  String updateRequired(String version) {
    return 'Zəhmət olmasa $version versiyasına yeniləyin. Bu yeniləmə tələb olunur.';
  }

  @override
  String get download => 'Yüklə';

  @override
  String updateCheckFailed(String error) {
    return 'Yeniləmələri yoxlamaq mümkün olmadı: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'GitHub-a qoşulmaq mümkün olmadı. İnternet bağlantınızı yoxlayın və yenidən cəhd edin.';

  @override
  String get updateNow => 'Yenilə';

  @override
  String updateDownloading(String version) {
    return '$version versiyası endirilir…';
  }

  @override
  String updateReady(String version) {
    return '$version versiyası quraşdırılmağa hazırdır.';
  }

  @override
  String updateInstalling(String version) {
    return '$version versiyası quraşdırılır. Tətbiq bağlanıb yenidən açılacaq.';
  }

  @override
  String updateFailed(String version) {
    return '$version versiyasına yeniləmək mümkün olmadı.';
  }

  @override
  String updateDone(String version) {
    return '$version versiyasına yeniləndi.';
  }

  @override
  String updateRolledBack(String version) {
    return '$version versiyasına yeniləmə başa çatmadı, ona görə tətbiq əvvəlki versiyaya qayıtdı.';
  }

  @override
  String get repoNotSet => 'GitHub repozitoriyası hələ təyin edilməyib.';

  @override
  String get sourceCode => 'Mənbə kodu';

  @override
  String get tapToConnect => 'Qoşulmaq üçün klikləyin';

  @override
  String get tapToDisconnect => 'Bağlantını kəsmək üçün klikləyin';

  @override
  String get startOnBoot => 'Sistem açılanda başlat';

  @override
  String get connectOnStartup => 'Açılışda avtomatik qoşul';

  @override
  String get proxyServiceActive => 'Proksi xidməti aktivdir';

  @override
  String get navHome => 'Ana səhifə';

  @override
  String get groupApp => 'Tətbiq';

  @override
  String get groupNetwork => 'Şəbəkə';

  @override
  String get stateOff => 'Qoşulmayıb';

  @override
  String get tapToConnectPhone => 'Qoşulmaq üçün toxunun';

  @override
  String get tapToDisconnectPhone => 'Bağlantını kəsmək üçün toxunun';

  @override
  String get tapToConnectTv => 'Qoşulmaq üçün OK düyməsini basın';

  @override
  String get tapToDisconnectTv => 'Bağlantını kəsmək üçün OK düyməsini basın';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Tövsiyə olunan məkan';

  @override
  String dataLeftOf(String limit) {
    return '/ $limit';
  }

  @override
  String get homeLocation => 'Məkan';

  @override
  String get connectedTo => 'Qoşulub:';

  @override
  String get vpnNotAllowed =>
      'VPN-in işləməsi üçün icazə lazımdır. Düyməyə yenidən toxunun və icazə verin.';

  @override
  String get dataUsedTitle => 'İstifadə olunan trafik';

  @override
  String get bypassApps => 'Tətbiqlər üzrə proksi';

  @override
  String get connectRetrying => 'Qoşulmaq alınmadı. İnterneti yoxlayın.';

  @override
  String get failUnreachable =>
      'Mozilla serverlərinə qoşulmaq mümkün olmadı. Başqa internet bağlantısını sınayın.';

  @override
  String get failUpstreamProxy =>
      'Yuxarı proksi vasitəsilə Mozilla-ya qoşulmaq mümkün olmadı. Proksinin işlədiyini yoxlayın.';

  @override
  String get failInsideVpn => 'Bu internet artıq VPN-dən keçir. Onu söndürün.';

  @override
  String get failRefused =>
      'Mozilla serveri bağlantını rədd etdi. Bir neçə dəqiqədən sonra yenidən cəhd edin.';

  @override
  String get failLocationRefused =>
      'Bu ölkə hesabınız üçün açıq deyil. Başqa ölkə seçin.';

  @override
  String get useRecommendedLocation => 'Tövsiyə olunan məkandan istifadə et';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Seçdiyiniz ölkə: $chosen, IP ünvanınızın ölkəsi: $exit.';
  }

  @override
  String get failSignIn =>
      'Bu hesabın girişinin müddəti bitib. Hesablar səhifəsində yenidən daxil olun.';

  @override
  String get failQuota => 'Bu ayın trafiki bitib. Başqa hesab əlavə edin.';

  @override
  String get failNotEntitled =>
      'Mozilla bu hesaba VPN-dən istifadə etməyə icazə vermir. Başqa hesab əlavə edin.';

  @override
  String get failRegion => 'Mozilla ölkənizdə xidmət göstərmir.';

  @override
  String get failServer =>
      'Mozilla xidmətində müvəqqəti problem var. Proqram özü yenidən cəhd edir.';

  @override
  String get failNoAccount => 'Hazır hesab yoxdur. Hesablar səhifəsini açın.';

  @override
  String get failTestSite =>
      'Serverə qoşuldu, amma saytlar açılmır. Başqa ölkəni sınayın.';

  @override
  String get failOther => 'Qoşulmaq alınmadı. Yenidən cəhd edin.';

  @override
  String get failNoInternet =>
      'İnternet yoxdur. Wi-Fi və ya mobil interneti yoxlayın.';

  @override
  String get waitingForNetwork => 'İnternet bağlantısı gözlənilir…';

  @override
  String proxyStartFailed(String port) {
    return 'Proksi $port portunda işə düşmədi. Başqa port seçin.';
  }

  @override
  String get connectionSettings => 'Bağlantı ayarları';

  @override
  String get appModeExclude => 'Seçilmiş tətbiqlər VPN-siz';

  @override
  String get appModeInclude => 'Yalnız seçilmiş tətbiqlər VPN ilə';

  @override
  String get appModeExcludeHint =>
      'Seçilmiş tətbiqlər VPN-siz, birbaşa qoşulur: məsələn, xarici IP-ləri qəbul etməyən bank tətbiqləri.';

  @override
  String get appModeIncludeHint =>
      'Yalnız seçilmiş tətbiqlər VPN-dən keçir; digərləri birbaşa qoşulur.';

  @override
  String fromRegionList(String region) {
    return 'Təklif: $region siyahısından';
  }

  @override
  String get modeProxy => 'Proksi';

  @override
  String get connectionMode => 'Bağlantı rejimi';

  @override
  String get modeProxyHint => 'Yalnız proksi ayarlanmış tətbiqlər ondan keçir.';

  @override
  String get modeSystemProxyHint =>
      'Windows və əksər tətbiqlər proksidən keçir.';

  @override
  String get modeSystemProxyHintOther =>
      'Brauzerlər və əksər tətbiqlər proksidən keçir.';

  @override
  String get suggestedApps => 'Təklif olunan tətbiqlər';

  @override
  String get showSystemApps => 'Sistem tətbiqlərini göstər';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count təklif olunan tətbiq seçildi',
      one: '1 təklif olunan tətbiq seçildi',
      zero: 'Təklif olunan tətbiqlər artıq seçilib',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Avtomatik';

  @override
  String get locationsSection => 'Məkanlar';

  @override
  String get dnsSummaryOk => 'Şifrəli DNS işləyir';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count domen üçün cavab alınmadı',
      one: '1 domen üçün cavab alınmadı',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return '$server vasitəsilə';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Şəbəkənizin DNS-i $count domen üçün filtr ünvanı qaytardı. Bu tətbiq həmin domenlər üçün o DNS-dən istifadə etmir.',
      one: 'Şəbəkənizin DNS-i 1 domen üçün filtr ünvanı qaytardı. Bu tətbiq həmin domen üçün o DNS-dən istifadə etmir.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Cavab:';

  @override
  String get dnsNetworkAnswer => 'Şəbəkə DNS-i:';

  @override
  String get dnsFiltered => 'filtrlənib';

  @override
  String get rulesSyntaxTitle => 'Hər sətirdə bir qayda';

  @override
  String get ruleDomain => 'Sayt və onun subdomenləri';

  @override
  String get ruleFull => 'Yalnız bu domen';

  @override
  String get ruleKeyword => 'Bu sözü daxil edən domenlər';

  @override
  String get ruleGeosite => 'Geo fayllarında teqə aid saytlar';

  @override
  String get ruleGeoip => 'Geo fayllarında ölkəyə aid IP-lər';

  @override
  String get ruleIp => 'IP ünvanı və ya şəbəkə';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Yalnız proksi';

  @override
  String get noNetwork =>
      'İnternet bağlantısı yoxdur. Wi-Fi və ya mobil datanı yandırın.';

  @override
  String get blockAds => 'Reklamları blokla';

  @override
  String systemProxyTakenBy(String address) {
    return 'Başqa proqram sistem proksisini $address ünvanına qoydu, ona görə trafik VPN-dən keçmir.';
  }

  @override
  String get systemProxyTakenOff =>
      'Başqa proqram sistem proksisini söndürdü, ona görə trafik VPN-dən keçmir.';

  @override
  String get setSystemProxyAgain => 'Yenidən qur';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Bütün $os trafiki VPN-dən keçir.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'TUN xidmətini quraşdırmaq üçün icazə gözlənilir…';

  @override
  String get tunInstallCancelled =>
      'TUN rejimi bir dəfə administrator icazəsi tələb edir. İcazə verilmədi, ona görə rejim dəyişmədi.';

  @override
  String tunInstallFailed(String error) {
    return 'TUN xidmətini quraşdırmaq alınmadı: $error';
  }

  @override
  String get tunStarting => 'TUN rejimi işə salınır…';

  @override
  String get tunFailed => 'TUN rejimi işə düşmədi. Yenidən cəhd edilir…';

  @override
  String get tunLost =>
      'TUN rejimi gözlənilmədən dayandı. Yenidən cəhd edilir…';

  @override
  String get tunNotRunning => 'TUN xidməti işləmir. Yenidən cəhd edilir…';

  @override
  String get tunMissing => 'TUN xidməti quraşdırılmayıb.';

  @override
  String get tunOutdated =>
      'TUN xidməti bu tətbiqdən köhnədir. TUN rejimindən istifadə etmək üçün onu yenidən quraşdırın.';

  @override
  String get tunAppOutdated =>
      'TUN xidməti bu tətbiqdən yenidir. TUN rejimindən istifadə etmək üçün tətbiqi yeniləyin.';

  @override
  String get tunBusy =>
      'Homa VPN-in başqa nüsxəsi TUN rejimindən istifadə edir.';

  @override
  String get tunNoDriver =>
      'Sistemin TUN sürücüsü əlçatan deyil. Kompüteri yenidən başladın və yenidən cəhd edin.';

  @override
  String get tunInstall => 'Quraşdır';

  @override
  String get tunInstallAgain => 'Yenidən quraşdır';

  @override
  String get trayTunMode => 'TUN rejimi (bütün tətbiqlər)';

  @override
  String get removeTunService => 'TUN xidmətini sil';

  @override
  String get removeTunServiceHint =>
      'TUN rejiminin istifadə etdiyi sistem xidmətini silir. TUN yenidən seçiləndə yenidən quraşdırılır.';

  @override
  String get tunServiceRemoved => 'TUN xidməti silindi.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN TUN rejimi üçün xidməti quraşdırmaq istəyir.';

  @override
  String get tunRemovePrompt =>
      'Homa VPN TUN rejiminin xidmətini silmək istəyir.';

  @override
  String tunRemoveFailed(String error) {
    return 'TUN xidmətini silmək alınmadı: $error';
  }

  @override
  String get sectionTun => 'TUN ayarları';

  @override
  String get tunPrograms => 'VPN-siz proqramlar';

  @override
  String get tunProgramsHint =>
      'Mozilla üzərindən deyil, birbaşa qoşulurlar. Yalnız VPN-siz işləyən proqramlar üçün.';

  @override
  String get tunProgramsEmpty => 'Hələ proqram yoxdur.';

  @override
  String get addProgram => 'Proqram əlavə et';

  @override
  String get programFiles => 'Proqramlar';

  @override
  String get tunProgramAll => 'Bütün trafik';

  @override
  String get tunProgramAllHint => 'Bütün proqram birbaşa qoşulur.';

  @override
  String get tunProgramUdp => 'Yalnız UDP';

  @override
  String get tunProgramUdpHint =>
      'Yalnız onun UDP-si birbaşa qoşulur; qalanı VPN üzərindən gedir.';

  @override
  String get udpNoticeSetting => 'Bloklanmış UDP bildirişi';

  @override
  String udpNoticeBody(String program) {
    return '$program proqramının UDP trafiki VPN-dən keçmir.';
  }

  @override
  String get dontShowAgain => 'Bir daha göstərmə';

  @override
  String get addRunningProgram => 'İşləyən proqramlardan';

  @override
  String get addProgramFile => 'Fayl seç…';

  @override
  String get addProgramName => 'Ad yaz…';

  @override
  String get programNameHint =>
      'Proqramın fayl adı, məsələn steam.exe; * istənilən mətn deməkdir (steam* bütün Steam proqramlarıdır).';

  @override
  String get runningProgramsEmpty => 'Başqa işləyən proqram yoxdur.';

  @override
  String get tabLog => 'Log';

  @override
  String get tabConnections => 'Bağlantılar';

  @override
  String get connectionsEmpty => 'Hələ bağlantı yoxdur.';

  @override
  String connectionsOpen(int count) {
    return '$count açıq';
  }

  @override
  String get connTime => 'Vaxt';

  @override
  String get connRoute => 'Qayda';

  @override
  String get connDestination => 'Təyinat';

  @override
  String get connInbound => 'Giriş';

  @override
  String get connProtocol => 'Protokol';

  @override
  String get connColumns => 'Sütunlar';

  @override
  String get connTraffic => 'Trafik';

  @override
  String get connDuration => 'Müddət';

  @override
  String get connRouteVpn => 'Proksi';

  @override
  String get connRouteDirect => 'Birbaşa';

  @override
  String get connRouteBlocked => 'Bloklanıb';

  @override
  String get connRoutePort => 'Port rədd edildi';

  @override
  String get connRouteFailed => 'Uğursuz';

  @override
  String get testRelay => 'Relay sağlamlığını yoxla';

  @override
  String get relayTestTitle => 'Relay sağlamlıq testi';

  @override
  String get relayTestHint =>
      'Yalnız relay yoxlanılır. Mozilla-ya sorğu və hesab məlumatı göndərilmir.';

  @override
  String get relayTestPassed => 'Relay hazırdır';

  @override
  String get relayTestFailed => 'Relay sağlamlığı təsdiqlənmədi';

  @override
  String get relayTestCopy => 'Hesabatı köçür';

  @override
  String get relayTestInterrupted => 'Tam nəticə alınmadan test başa çatdı.';

  @override
  String get searchLocations => 'Yerləri axtar';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yer',
      one: '1 yer',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Avtomatik yenilənmə';

  @override
  String get autoInstallApkHint =>
      'Yeni versiyalar özü yüklənir; quraşdırmadan əvvəl quraşdırıcı soruşur.';

  @override
  String get installNow => 'Quraşdır';

  @override
  String get updateAllowInstall =>
      'Yeniləməni quraşdırmaq üçün bu tətbiqə tətbiq quraşdırmağa icazə verin.';

  @override
  String get allowInstall => 'İcazə ver';

  @override
  String get noResults => 'Axtarışa uyğun yer yoxdur.';

  @override
  String get accentColor => 'Vurğu rəngi';

  @override
  String get accentMono => 'Tək rəng (standart)';

  @override
  String get accentCustom => 'Xüsusi rəng';

  @override
  String get accentEmber => 'Qızğın';

  @override
  String get accentGold => 'Qızıl';

  @override
  String get accentEmerald => 'Zümrüt';

  @override
  String get accentSapphire => 'Safir';

  @override
  String get accentAmethyst => 'Ametist';

  @override
  String get accentRose => 'Qızılgül';

  @override
  String get autoReconnect => 'Avtomatik yenidən qoşulma';

  @override
  String get autoReconnectHint =>
      'Bağlantı sizin istəyiniz olmadan kəsilsə, özü yenidən qoşulur.';

  @override
  String get androidOnlyHint => 'Yalnız telefondada.';

  @override
  String get idleDisconnect => 'Fasilədə qopar';

  @override
  String get idleDisconnectHint =>
      'Bir müddət trafik olmayanda sessiyanı bitirir.';

  @override
  String get idleTimeout => 'Fasilə gözləməsi';

  @override
  String get minutes5 => '5 dəqiqə';

  @override
  String get minutes10 => '10 dəqiqə';

  @override
  String get minutes15 => '15 dəqiqə';

  @override
  String get minutes30 => '30 dəqiqə';

  @override
  String get minutes60 => '1 saat';

  @override
  String get dataLimit => 'Sessiya data həddi';

  @override
  String get dataLimitHint => 'Trafik həddə çatanda sessiyanı bitirir.';

  @override
  String get dataLimitAmount => 'Hədd';

  @override
  String get mb256 => '256 MB';

  @override
  String get mb512 => '512 MB';

  @override
  String get mb1024 => '1 QB';

  @override
  String get mb2048 => '2 QB';

  @override
  String get mb5120 => '5 QB';

  @override
  String get mb10240 => '10 QB';

  @override
  String autoStoppedIdle(int minutes) {
    return '$minutes dəqiqə trafik olmayıb, bağlantı kəsildi.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'Sessiya $mb MB data həddinə çatdı, bağlantı kəsildi.';
  }

  @override
  String get protection => 'Qoruma';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'VPN kəsilsə, trafik saxlanılır — heç bir sızma olmadan — qoşulana qədər.';

  @override
  String get alwaysOnVpn => 'Həmişə işlək VPN';

  @override
  String get alwaysOnVpnHint =>
      'Android-in öz qoruması: VPN-siz heç bir bağlantı keçmir.';

  @override
  String get floatingIsland => 'Üzən ada';

  @override
  String get floatingIslandHint =>
      'Tətbiqdən kənarda bağlantını digər tətbiqlərin üzərində göstərir.';

  @override
  String whatsNewTitle(String version) {
    return '$version versiyasındakı yeniliklər';
  }

  @override
  String get whatsNewContinue => 'Anladım';

  @override
  String get whatsNewMenu => 'Yeniliklər';

  @override
  String get whatsNewView => 'Yenidən bax';

  @override
  String get updateServers => 'Serverləri yenilə';

  @override
  String get updatingServers => 'Yenilənir…';

  @override
  String serversUpdated(int count) {
    return 'Mozilla-nın rəsmi siyahısından $count yer';
  }

  @override
  String get serversUpdateFailed =>
      'Server siyahısı yenilənə bilmədi; əvvəlki siyahı saxlanıldı.';

  @override
  String get smartPickTitle => 'Hazırda ən sürətli';

  @override
  String get smartPickUse => 'İstifadə et';

  @override
  String get connectAtBoot => 'Telefon açılanda qoşul';

  @override
  String get connectAtBootHint =>
      'Connects by itself at boot, when the VPN permission is already granted.';

  @override
  String get gamingProfile => 'Oyun profili';

  @override
  String get gamingProfileHint =>
      'Shows the connection\'s live delay and quality; pairs with the fastest measured server.';

  @override
  String get diagnosticsRun => 'Diaqnostikanı işə sal';

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
  String get diagnosticsConnection => 'Bağlantı testi';

  @override
  String get diagnosticsPassed => 'Uğurlu';

  @override
  String get diagnosticsFailed => 'Uğursuz';

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
  String get whatsNewAdded => 'Yeni';

  @override
  String get whatsNewImproved => 'Təkmilləşdirmə';

  @override
  String get whatsNewFixed => 'Düzəliş';

  @override
  String get wnWheelImproved =>
      'Ölkə çarxı yenidən çəkildi: seçilmiş bayraq şənzər çərçivədə, zərif parıltı və arxasınca yumuşaq işıq haləsi ilə daha böyük durur, digər bayraqlar dərinliklə kiçik görünür və altındaki ad yumşaq sürüşmə ilə gəlir.';

  @override
  String get wnLiveImproved =>
      'Qoşulu zamanı bildiriş Android 16-dan reference implementasiya kimi onu Live Update kimi yüksəltməyi xahiş edir; müddət özü sayılır, sürətlər canlı qalır.';

  @override
  String get wnL10nFixed =>
      'Bu səhifə indi tətbiqin dilində danışır — onun on beş dilinin hamısı, yalnız ingilis deyil.';

  @override
  String get wnMarkFixed =>
      'Mozilla nişanı öz plitəsində təmiz durur, küncləri bayraqlar kimi yumrudur.';

  @override
  String get designTitle => 'Ana səhifə dizaynı';

  @override
  String get designHint => 'Ana səhifənin düzülüşü';

  @override
  String get designWheel => 'Çarx';

  @override
  String get designWheelDesc => 'Bayraqlar şüşə çarxında, açar altında';

  @override
  String get designBento => 'Mozaika';

  @override
  String get designBentoDesc => 'Yumru mozaik lövhə: bağlantı, rəqəmlər, yer';

  @override
  String get designPixel => 'Yığcam';

  @override
  String get designPixelDesc => 'Sakit bir kart: yer, açar və rəqəmlər';

  @override
  String get notifFlag => 'Bildirişdə ölkə bayrağı';

  @override
  String get notifFlagHint => 'Ölkənin öz bayrağı adının yanında';

  @override
  String get wnDesignAdded =>
      'Ana səhifə dizaynı seçimi: çarx, mozaika və ya yığcam kart';

  @override
  String get wnMapAdded =>
      'Ana səhifənin arxasında real vektor dünya xəritəsi, seçilən ölkə işıqlı';

  @override
  String get wnWheelAdded =>
      'Bayraq çarxı yenidən çəkildi: dərin şüşə, yumşaq hərəkət, dərinlik';

  @override
  String get wnFlagNotifAdded =>
      'Bildiriş ölkənin SVG bayrağını göstərə bilər və söndürülə bilər';

  @override
  String get wnColorRemoved =>
      'Xüsusi rəng səhifəsi silindi; vurğu rəng siyahısı HEX kodunu saxlayır';

  @override
  String get whatsNewRemoved => 'Silindi';

  @override
  String get wnCrashFixed =>
      'Tətbiq artıq Android 16 telefonlarında öz-özünə dayanmır: bildiriş telefonda hələ olmayan bir şey istəyirdi.';

  @override
  String get wnFlagArtFixed =>
      'Tətbiq artıq açılanda özünü çıxarmır: bildirişin bayraq şəkli sistemin mesajlaşmasının qəbul etmədiyi bir dəyər qaytarırdı.';

  @override
  String get statSession => 'Sessiya';

  @override
  String get copiedToClipboard => 'Buferə köçürüldü';

  @override
  String get wnTotalsAdded =>
      'Ana səhifə sessiyada ötürülənlərin cəmini göstərir; bir toxunuş ümumi IP-ni köçürür.';

  @override
  String get wnPolishImproved =>
      'Bayraq çarxı və serverlər səhifəsi daha səliqəlidir; mətnlər yığılmışdır, Android tunneli trafiği daha yüksək sürətlə daşıyır.';

  @override
  String get smartNetwork => 'Ağıllı bağlantı';

  @override
  String get smartNetworkHint =>
      'MTU, protokol və IP versiyası bu şəbəkəyə görə, sürət üçün seçilir.';

  @override
  String get valueSmart => 'Ağıllı';

  @override
  String get mtuAutoValue => 'Avtomatik — şəbəkəyə görə';

  @override
  String get wnSmartAdded =>
      'Ağıllı bağlantı: MTU, protokol və IP versiyası şəbəkəyə görə, real cavablara əsaslanaraq sürət üçün seçilir.';

  @override
  String get wnToastAdded =>
      'Təsdiqlər indi yumşaq iOS üslubunda bildiriş kimi gəlir, özünü çəkən nişanla.';

  @override
  String get wnFlagsImproved =>
      'Bayraq çarxı təmiz oturur: kənarədə bayraq yarılmır, bayraqlar tam görünür və seçim yumşaq yayla enir.';

  @override
  String get wnMapImproved =>
      'Dünya xəritəsi daha böyük və aydın çəkilir: sıxılmış qitələr yox, hamar sahillər və lövbərdə parlaq halə.';

  @override
  String get smartWaiting => 'Ölçülür…';

  @override
  String get smartFamilyRace => 'İlk bağlantıda hər ikisi yarışır';

  @override
  String get dnsManual => 'Əl ilə DNS';

  @override
  String get dnsManualHint =>
      'Hər ünvan bir sətirdə: sadə IP, https:// (DNS-over-HTTPS) və ya tls://host (DNS-over-TLS). İlk cavab udur.';

  @override
  String get dnsManualInvalid =>
      'Bir sətir nüvənin işlədə biləcəyi ünvan deyil: sadə IP, https://… və ya tls://host.';

  @override
  String get killSwitchGuarded =>
      'Mühafizə olunur: tunel kəsik olanda telefondan heç nə çıxmır.';

  @override
  String get accountsUsageTitle => 'Bu ay';

  @override
  String get accountsCountLabel => 'hesab';

  @override
  String get accountsUsageAverage => 'hesabların xərclənmiş payının ortalaması';

  @override
  String get wnDesignsAdded =>
      'Tətbiq dizaynları: tətbiqin hamısı Yumşaq Neomorfizm və ya Şimal pəncərəsini geyə bilər — hər səhifə, hər kart — Parametrlər → Ümumi bölməsində.';

  @override
  String get wnWheelFixed =>
      'Çarxın yarım bayrağı aradan qalxıb: seçilmiş bayrağın altındakı rəf işık gölməçəsidir, ikinci bayraq deyil, və heç bir bayraq kənarədə kəsilmir.';

  @override
  String get wnMapReal =>
      'Dünya xəritəsi ölkələrin rəsmi sərhədlərindən yenidən çəkilib — hər sahil, ada və anklav, tam sədaqətlə və real nisbətdə.';

  @override
  String get wnGlobeAdded =>
      'Dünya artıq kürədir: gümüş top seçilmiş ölkəyə dönür, parlaq bir pim və üzən kart onu işarələyir, bağlantı yolları mərkəzlərə uzanır.';

  @override
  String get wnWheelGlowImproved =>
      'Seçilmiş bayraq öz mavi halosu ilə şüşə çərçivədə daha böyük dayanır, qonşuları açıq şəkildə kiçikdir və çarxın altındakı işarələr harada olduğunuzu göstərir.';

  @override
  String get wnDesignsRemoved =>
      'Tətbiq dizaynı seçicisi çıxarıldı: tətbiq yenə öz tək rəng görünüşünü geyir — vurğu rənginiz və mövzunuz olduğu kimi qalıb.';

  @override
  String get wnDnsAdded =>
      'Əl ilə DNS: sadə IP-lər, DNS-over-HTTPS və DNS-over-TLS — hər sətirin növü yazarkən göstərilir və yoxlanılır.';

  @override
  String get wnSmartImproved =>
      'Ağıllı bağlantı indi şəbəkənin cavabını göstərir: seçdiyi nəqliyyatı və saxladığı IP versiyasını, canlı.';

  @override
  String get wnProtectionImproved =>
      'Kəsirmə düyməsi mühafizəsi qurulanda xəbər verir, tətbiqlər səhifəsi isə neçə tətbiq seçdiyini göstərir.';

  @override
  String get wnWelcomeImproved =>
      'Qarşılayıcı səhifə axan şimal pəncərəsi üzərində nəfəs alan qalxanla açılır, hesablar səhifəsi ayı bir baxışda yekunlaşdırır.';

  @override
  String bypassAppsCount(String n) {
    return 'Seçilmiş: $n';
  }

  @override
  String mtuAutoMeasured(int mtu) {
    return 'Avtomatik — şəbəkə $mtu daşıyır';
  }

  @override
  String get sectionAppearance => 'Görünüş';

  @override
  String get mapStyle => 'Xəritə stili';

  @override
  String get mapStyleHint =>
      'Ana səhifənin kürəsi seçdiyiniz kimi boyanır. Bağlantının işığı eyni qalır.';

  @override
  String get mapSilver => 'Gümüşü';

  @override
  String get mapMidnight => 'Gecə yarı';

  @override
  String get mapOcean => 'Okean';

  @override
  String get mapMono => 'Tək rəng';

  @override
  String get mapAurora => 'Aurora';

  @override
  String get batterySaver => 'Batareya qnağı';

  @override
  String get batterySaverHint =>
      'Bağlantı zamanı xəritənin hərəkətini sakitləşdirir — kürənin nəfəsi, çarxın parıltısı. Bağlantının özü olduğu kimi qalır.';

  @override
  String get connectOnOpen => 'Tətbiq açılanda bağlan';

  @override
  String get connectOnOpenHint =>
      'Tətbiq açılanda VPN-i qaldırır, son seçdiyiniz yerdə.';

  @override
  String get speedTitle => 'Sürət';

  @override
  String get parallelTunnels => 'Paralel tunellər';

  @override
  String get parallelTunnelsHint =>
      'Bir anda Mozillaya bir neçə tunel açır və trafiki onların arasında bölür — bir yavaş tunel artıq sürəti məhdudlaşdırmır. Səkkiz ən çox batareya aparır.';

  @override
  String get tunnels1 => 'Bir — ən sabit';

  @override
  String get tunnels2 => 'İki';

  @override
  String get tunnels4 => 'Dörd — yavaş şəbəkələrdə daha sürətli';

  @override
  String get tunnels8 => 'Səkkiz — ən sürətli';

  @override
  String get connectionCap => 'Bağlantı limiti';

  @override
  String get connectionCapHint =>
      'Necə tətbiqin bir anda VPN üzərindən danışmasına icazə var; kiçik limit məşğul telefonda batareya və trafikə qənaət edir. Susmaya görə limitsizdir.';

  @override
  String get capNone => 'Limitsiz';

  @override
  String get verboseLogging => 'Ətraflı diaqnostika';

  @override
  String get verboseLoggingHint =>
      'Hər addımı jurnal yazır — problem bildirəndə faydalıdır, batareyaya bir az ağır gəlir.';

  @override
  String get wn38MapStylesAdded =>
      'Xəritənin beş görünüşü: gümüşü, gecə yarı, okean, tək rəng və Aurora — parametrlərin yeni Görünüş səhifəsi seçir, hər birinin önbaxışı var.';

  @override
  String get wn38ZoomAdded =>
      'Xəritə yaxınlaşdırılır: iki barmaqla çəkin, ya iki dəfə toxunun — yaxınlaşır, bir daha uzaqlaşır.';

  @override
  String get wn38OptionsAdded =>
      'Faydalı seçimlər: daha çox sürət üçün paralel tunellər, bağlantı limiti, batareya qnağı, tətbiq açılanda bağlanma və ətraflı diaqnostika.';

  @override
  String get wn38SocialAdded =>
      'İnstagram və Telegram indi bu səhifənin altında da var.';

  @override
  String get wn38FlightImproved =>
      'Ölkə seçmək kiçik uçuşdur: kamera bir az geri çəkilir, kürə dönür, pin tullanaraq enir və yollar öz-özünə mərkəzlərə uzanır.';

  @override
  String get wn38EffectsImproved =>
      'Xəritə zəngin oxunur: kürənin ardında ulduzlar, koordinat şəbəkəsi, mərkəzlərin öz işıqları, kənar ətrafında halə və qurunun kölgəsi.';

  @override
  String get wn38SpeedImproved =>
      'Sürət seçimi real oldu: paralel tunellər bir neçə bağlantını bir anda açır və nüvə trafiki aralarında bölür.';

  @override
  String get wn38NameFixed =>
      'Seçilmiş ölkənin adı bir dəfə göstərilir — xəritənin üzən kartında; bayraqların altındakı nüsxə gedib.';

  @override
  String get mapKind => 'Xəritə növü';

  @override
  String get mapKindHint =>
      'Ana səhifənin dünyası necə göstərilir: köhnə düz xəritə (standart), müasir forması, gecə yumrusu, ərazi yumrusu, metal kürə və ya peyk yumru. Hər növda sərhədlər real rəsmi sərhədlərdir.';

  @override
  String get mapKindClassic => 'Klassik';

  @override
  String get mapKindGlobe => '3D kürə';

  @override
  String get mapKindSatellite => 'Peyk';

  @override
  String get mapKindFlat => 'Düz 2D';

  @override
  String get mapStyleGlobeHint =>
      '3D kürənin geyindiyi rənglər. Peyk öz yumrusunu, düz xəritələr öz mürəkkəbini daşıyır.';

  @override
  String get aboutVersions => 'Versiya';

  @override
  String get aboutChannels => 'Əlaqə səhifələri';

  @override
  String get checkUpdatesHint =>
      'Daha yeni versiyaya bax; tapılan versiya yüklənir və quraşdırıcı soruşur.';

  @override
  String get speedTestTitle => 'Sürət testi';

  @override
  String get speedTestRun => 'Ölç';

  @override
  String get speedTestFailed => 'Ölçmə başa çatmadı.';

  @override
  String get speedTestThrough => 'Tunel üzərindən ölçüldü.';

  @override
  String get speedTestDirect => 'Birbaşa ölçüldü (proksi sönüdür).';

  @override
  String get speedTestHint =>
      'Tunel üzərindən bir yükləmə və bir yükləmə onun nə daşıdığını deyir. Əsas səhifənin qrafiki də buranı açır.';

  @override
  String get speedGraphHint => 'Tunelin keçən dəqiqəsi · ölçmək üçün toxun';

  @override
  String get favoritePinned => 'Sancılı. Çıxarmaq üçün yenidən uzun basın.';

  @override
  String get favoriteUnpinned => 'Çıxarıldı.';

  @override
  String get shareReport => 'Hesabatı paylaş';

  @override
  String get shareReportCopied => 'Hesabat mübadilə buferinə qoyuldu.';

  @override
  String get batteryWizardTitle => 'Batareyada yaşamaq';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei və bənzərləri ekran kilidlənəndə VPN tətbiqlərini öldürür. Tunel yanansın deyə bu tətbiqi batareya optimallaşdırmasından çıxarın.';

  @override
  String get batteryWizardSteps =>
      'İstehsalçının öz tənzimləməsində avtomatik başlatmaya icazə verin və tətbiqi “Məhdudiyyətsiz” (Xiaomi), “Yatan tətbiqlərdən çıxar” (Samsung) və ya “Əl ilə başlat” (Huawei) qoyun.';

  @override
  String get batteryWizardState =>
      'Batareya optimallaşdırması tuneli dayandıra bilər.';

  @override
  String get batteryWizardPermit => 'İcazə verirəm';

  @override
  String get batteryWizardOk => 'Tunel batareyadan qorunur.';

  @override
  String get batteryWizardOpen => 'Batareya tənzimləmələri';

  @override
  String get usageTitle => 'Tətbiq istifadəsi';

  @override
  String get usageRowHint => 'Hər tətbiq nə qədər işlətdi';

  @override
  String get usageGrant => 'İstifadə icazəsini aç';

  @override
  String get usageGrantHint =>
      'Android hər tətbiqin istifadəsini “İstifadəyə giriş” icazəsi arxasında saxlayır. Düymənin açdığı səhifə sistemin özüdür; bu tətbiq yalnız ədədləri oxuyur.';

  @override
  String get usageEmpty => 'Bu dövrdə istifadə qeydə alınmadı.';

  @override
  String get usageToday => 'Bu gün';

  @override
  String get usageWeek => 'Keçən 7 gün';

  @override
  String get usageMonth => 'Keçən 30 gün';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'Tətbiq Google Play-dən kənar quraşdırılır; ilk quraşdırmada Play Protect yoxlama istəyə bilər. Bir dəfə \"Tətbiqi skan et\" düyməsinə basın — təmiz yoxlama yadda qalır və sonrakı yenilənmələr bu sorğu olmadan quraşdırılır.';

  @override
  String get smartLocation => 'Ən sürətli yer';

  @override
  String get smartLocationHint =>
      'Hər qoşulma, nüvənin öz gecikmə testinin ən sürətli dediyi serverə düşür.';

  @override
  String get quicPass => 'QUIC ötürmə';

  @override
  String get quicPassHint =>
      'Tətbiqlərin QUIC-i (UDP 443) tuneldən keçir: zənglər və oyunlar sürətini saxlayır, TCP-yə qayıtmır.';

  @override
  String get accountRename => 'Hesabın adını dəyiş';

  @override
  String get accountRenameLabel => 'Hesabın adı';

  @override
  String get accountProfile => 'Profil şəkli';

  @override
  String get avatarReset => 'Sadə işarəyə qayıt';

  @override
  String get accountSecurity => 'Tətbiq şifrəsi';

  @override
  String get appPasswordOn => 'Tətbiq şifrənin arxasında açılır.';

  @override
  String get appPasswordOff => 'Şifrə yoxdur: tətbiqi açan içəri girir.';

  @override
  String get appPasswordSet => 'Şifrə qoy';

  @override
  String get appPasswordChange => 'Şifrəni dəyiş';

  @override
  String get appPasswordRemove => 'Şifrəni sil';

  @override
  String get appPasswordCurrent => 'Hazırkı şifrə';

  @override
  String get appPasswordNew => 'Yeni şifrə (4+ simvol)';

  @override
  String get appPasswordConfirm => 'Yeni şifrəni təkrarla';

  @override
  String get appPasswordShort => 'Ən azı 4 simvol.';

  @override
  String get appPasswordMismatch => 'İki şifrə eyni deyil.';

  @override
  String get appPasswordWrong => 'Şifrə yanlışdır';

  @override
  String get appPasswordSetDone =>
      'Şifrə quruldu — tətbiq növbəti açılışdan soruşacaq.';

  @override
  String get appPasswordRemoved => 'Şifrə silindi; tətbiq sərbəst açılır.';

  @override
  String get appPasswordUnlock => 'Tətbiq kilidlidir';

  @override
  String get appPasswordUnlockHint =>
      'Davam etmək üçün tətbiq şifrəsini yazın.';

  @override
  String get wn39MapKinds =>
      'Xəritə yenə növlərini seçir: köhnə düz xəritə (standart), 3D kürə, peyk yumru və müasir düz 2D.';

  @override
  String get wn39EyeIp =>
      'Yer kartında göz var: toxunun, trafiğin çıxdığı ünvanı görün və köçürün.';

  @override
  String get wn39Profile =>
      'Hesabların öz adı və profil şəkli var, tətbiq şifrənin arxasında açıla bilər.';

  @override
  String get wn39Smart =>
      'Ağıllı qoşulma tamlandı: real gecikmə ilə ən sürətli yer və zənglər/oyunlar üçün QUIC ötürmə.';

  @override
  String get wn39Flight =>
      'Ölkə dəyişməsi daha hamar uçur — kamera böyük dairə üzrə gedir — və bayraq çarxının işarələri bayraqlara yaxındır.';

  @override
  String get wn39ToastEverywhere =>
      'Dinamik bildiriş artıq hər yerdədir: hər «saxlanıldı», «köçürüldü» və «xəta» eyni animasiyalı şüşə kapsuldadır.';

  @override
  String get wn39Updates =>
      'Yenilənmələr yaddaşı təmiz saxlayır: quraşdırıcı köhnə versiyanı əvəz edir və heç bir paket qalmır.';

  @override
  String get mapKindNight => 'Gecə';

  @override
  String get mapKindTerrain => 'Ərazi';

  @override
  String get wn40MapKindsNew =>
      'Xəritənin iki yeni forması: gecə yumrusu və ərazi yumrusu.';

  @override
  String get wn40Flight =>
      '3D kürə yeni ölkəyə bir hamar dönüşlə uçur — heç vaxt tullanma yoxdur.';

  @override
  String get wn40Mercator =>
      'Düz xəritələr standart Merkator proyeksiyası ilə çəkilir: real nisbətlər, standart sərhədlər, sıxılmamış.';

  @override
  String get wn40NameBack =>
      'Seçilmiş ölkənin adı düz xəritələrdə bayraqların altında geri qaytarıldı.';

  @override
  String get wn40Speed =>
      'Tunel indi standart olaraq iki paralel sessiya açır — daha güclü, daha sabit xətt.';

  @override
  String get wn40LockFixed =>
      'Qoşma düyməsinin kilidi halları arasında artıq yoxa ölmür.';

  @override
  String get wn40IpRemoved => 'Məkan kartının IP pəncərəsi götürüldü.';

  @override
  String get soundFeedback => 'Səs effektləri';

  @override
  String get soundFeedbackHint =>
      'Toxunuşlar, açarlar və qoşmanın yandırılıb-söndürülməsi üçün yumşaq səslər';

  @override
  String get rateUnit => 'Sürət vahidi';

  @override
  String get lockInBackground => 'Tərk edəndən sonra kilid';

  @override
  String get lockBgNever => 'Heç vaxt';

  @override
  String get lockBgNow => 'Dərhal';

  @override
  String get lockBgMin5 => '5 dəqiqədən sonra';

  @override
  String get lockBgMin15 => '15 dəqiqədən sonra';

  @override
  String get mb25600 => '25 QB';

  @override
  String get mb51200 => '50 QB';

  @override
  String get mb102400 => '100 QB';

  @override
  String get wn41Sound =>
      'Qoşma səsi titrişə qoşuldu: VPN yandırılan və ya söndürüləndə qısa bir not çalır (Ayarlar ← Ümumi).';

  @override
  String get wn41RateUnit =>
      'Sürət seçdiyiniz vahidlə oxunur: tanış KB/s və ya bağlantının öz Mbps-i.';

  @override
  String get wn41BackgroundLock =>
      'Tətbiq siz uzaqda olanda özünü kilidləyə bilər: şifrə dərhal, 5 və ya 15 dəqiqədən sonra yenidən soruşulur.';

  @override
  String get wn41BiggerLimits =>
      'Sessiyanın data həddi 25, 50 və ya 100 QB-yə qalxır.';

  @override
  String get wn41Motion =>
      'Yeni hərəkətlər: qoşulmuş kürə nəfəs alır, çek işarəsi özünü çəkir, halatın sözü qiymətləri arasında sürüşür, səhv şifrə sahəni silkələyir.';

  @override
  String get wn41AboutFixed =>
      'Haqqında səhifəsi qaydasına düşdü: iki səhifə yan-yanı, hər izah öz sətrində, sıxılmamış.';

  @override
  String get wn41HapticFixed =>
      'Titriş ayarı yeniden cavab verir: hər qoşmanın yandırılıb-söndürülməsi onu izləyir, yalnız sürülənin deyil.';

  @override
  String get copyIp => 'IP-ni kopyala';

  @override
  String get wn42Fonts =>
      'Hər dil tətbiqin öz şriftlərini oxuyur: iki çincə və bengal üçün Noto Sans, latın və kiril dilləri üçün Inter — artıq heç bir dil telefonun şriftlərinə söykənmir.';

  @override
  String get wn42Sounds =>
      'Tətbiqin səsləri artıq realdır: hər bölmədə yumşaq toxunuş, açarlar üçün iki nota, qoşmanın yaranıb-sönməsində qalxan və enən nota, kilid üçün zəng — Səs açarı hamısını idarə edir.';

  @override
  String get wn42AboutFixed =>
      'Haqqında səhifəsi loqosunu, adını və qeydini mərkəzə qoyur, əlaqə identləri telefonun enindən asılı olmayaraq tam və bir sətirdə qalır.';

  @override
  String get wn42Gaming =>
      'Oyun profili artıq realdır: serverlər səhifəsi gecikmələri hər yarım dəqiqədən bir təzə ölçür və ölçülmüş ən sürünü vurğulayır.';

  @override
  String get avatarPhoto => 'Öz şəklin';

  @override
  String get avatarPhotoFailed => 'Bu şəkil işlədilə bilmədi';
}
