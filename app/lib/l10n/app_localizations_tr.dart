// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Bağlanmak için kaydır';

  @override
  String get slideToDisconnect => 'Kesmek için kaydır';

  @override
  String get navOverview => 'Genel bakış';

  @override
  String get navAccounts => 'Hesaplar';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get stateConnected => 'Bağlı';

  @override
  String get stateConnecting => 'Bağlanıyor…';

  @override
  String get stateWaiting => 'Beklemede';

  @override
  String get waitingForAccount =>
      'Bağlanmak için Hesaplar sayfasından bir Firefox Account ekleyin.';

  @override
  String get waitingForEnabledAccount =>
      'Tüm hesaplar kapalı. Hesaplar sayfasından birini açın.';

  @override
  String get stateError => 'Hata';

  @override
  String get stateUnknown => 'Bilinmiyor';

  @override
  String get restartProxy => 'Proxy\'yi yeniden başlat';

  @override
  String copied(String value) {
    return '$value kopyalandı';
  }

  @override
  String get activeAccount => 'Etkin hesap';

  @override
  String get noActiveAccount => 'Etkin hesap yok';

  @override
  String get quotaNotRead => 'Kota bilgisi henüz alınmadı';

  @override
  String get unlimited => 'Sınırsız';

  @override
  String usedOf(String used, String limit) {
    return '$used / $limit kullanıldı';
  }

  @override
  String resets(String date) {
    return '$date tarihinde sıfırlanır';
  }

  @override
  String switchAt(int percent) {
    return 'Kota %$percent dolunca hesap değişir';
  }

  @override
  String get publicIp => 'Genel IP';

  @override
  String get testConnection => 'Bağlantıyı test et';

  @override
  String get testing => 'Test ediliyor…';

  @override
  String get testFailed => 'Başarısız';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'az önce';

  @override
  String minutesAgo(int n) {
    return '$n dk önce';
  }

  @override
  String hoursAgo(int n) {
    return '$n sa önce';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'saat $time';
  }

  @override
  String durationDays(int d, int h) {
    return '${d}g ${h}sa';
  }

  @override
  String durationHours(int h, int m) {
    return '${h}sa ${m}dk';
  }

  @override
  String durationMinutes(int m, int s) {
    return '${m}dk ${s}sn';
  }

  @override
  String durationSeconds(int s) {
    return '${s}sn';
  }

  @override
  String accountsGuide(String size) {
    return 'Her Firefox Account\'un ayda $size kotası var. Birden fazla hesap ekleyebilirsiniz: biri bitince uygulama kendiliğinden sıradakine geçer.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'Bu listedeki sırayla: her biri %$percent oranına kadar, sonuncusu verisi bitene kadar.';
  }

  @override
  String get addAccount => 'Hesap ekle';

  @override
  String lowQuotaNotice(String size) {
    return 'Bu hesabın kotası bitmek üzere. Bir hesap daha ekleyerek $size daha kazanın.';
  }

  @override
  String get noAccounts => 'Henüz hesap yok';

  @override
  String get noAccountsHint => 'Bağlanmak için bir Firefox Account ekleyin.';

  @override
  String get delayTestFailed =>
      'Sunucuların gecikmesi ölçülemedi. İnternetinizi kontrol edin.';

  @override
  String get createAccountTitle => 'Firefox Account\'unuz yok mu?';

  @override
  String get createAccountHint =>
      'accounts.firefox.com adresinden ücretsiz bir hesap oluşturun, ardından buraya dönüp Hesap ekle\'ye basın.';

  @override
  String get moveUp => 'Yukarı taşı';

  @override
  String get moveDown => 'Aşağı taşı';

  @override
  String get statusActive => 'Kullanımda';

  @override
  String get statusReady => 'Hazır';

  @override
  String get statusNeedsSignIn => 'Oturum açılmalı';

  @override
  String get statusReserved => 'Yedekte';

  @override
  String get statusUnavailable => 'Kullanılamıyor';

  @override
  String statusUnavailableUntil(String date) {
    return '$date tarihine kadar kullanılamaz';
  }

  @override
  String get statusDisabled => 'Devre dışı';

  @override
  String get statusEnabled => 'Etkin';

  @override
  String get useNow => 'Şimdi kullan';

  @override
  String get signInAgain => 'Yeniden oturum aç';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Bu hesap verisinin %$percent kadarını kullandı; sıradaki hesap devreye girdi.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Bu ayın kotası bitti; aylık sıfırlamadan sonra yeniden kullanılır.';

  @override
  String get reasonSignInRequired =>
      'Bu hesabı kullanmak için yeniden giriş yapın.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla girişin onaylanmasını istiyor: «Yeniden oturum aç» düğmesine basın (yalnızca kod gerekir).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Otomatik giriş başarısız oldu ($detail). Yeniden giriş yapın.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'Son otomatik giriş kısa süre sonra çalışmayı bıraktı; sonraki deneme $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Otomatik giriş tamamlanamadı ($detail); $time saatinde yeniden denenecek.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla bu hesabı reddetti; daha sonra yeniden denenecek.';

  @override
  String get more => 'Daha fazla';

  @override
  String get refreshQuota => 'Kotayı yenile';

  @override
  String get remove => 'Kaldır';

  @override
  String get removeTitle => 'Hesap kaldırılsın mı?';

  @override
  String removeBody(String name) {
    return '$name ve kayıtlı oturumu bu bilgisayardan kaldırılacak. Daha sonra yeniden ekleyebilirsiniz.';
  }

  @override
  String get unlimitedQuota => 'Sınırsız kota';

  @override
  String get signInTitle => 'Oturum aç';

  @override
  String get signInIntro => 'Bir Firefox Account ile oturum açın.';

  @override
  String get email => 'E-posta';

  @override
  String get emailInvalid => 'Hesabın e-posta adresini girin';

  @override
  String get password => 'Parola';

  @override
  String get passwordEmpty => 'Parolayı girin';

  @override
  String get show => 'Göster';

  @override
  String get hide => 'Gizle';

  @override
  String get signIn => 'Oturum aç';

  @override
  String get continueLabel => 'Devam';

  @override
  String get done => 'Tamam';

  @override
  String get close => 'Kapat';

  @override
  String get noBrowserTitle => 'Bu cihazda tarayıcı yok';

  @override
  String get noBrowserText =>
      'Bu adresi telefonunuzda veya bilgisayarınızda açın:';

  @override
  String get cancel => 'İptal';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get signingIn => 'Oturum açılıyor…';

  @override
  String get accountReady => 'Hesap hazır';

  @override
  String get accountReadyHint => 'Hesap sırasının sonuna eklendi.';

  @override
  String get captchaLabel => 'Resimdeki karakterler';

  @override
  String get codeLabel => 'Kod';

  @override
  String get captchaBroken => 'CAPTCHA resmi gösterilemedi.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla, $email adresine bir kod gönderdi. Kodu buraya girin.';
  }

  @override
  String get stepTotp => 'Kimlik doğrulama uygulamanızdaki kodu girin.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla bu oturum açma girişimini olağan dışı buldu ve $email adresine bir engel kaldırma kodu gönderdi. Kodu buraya girin.';
  }

  @override
  String get stepCaptcha => 'Resimdeki karakterleri yazın.';

  @override
  String stepEmailLink(String email) {
    return 'Mozilla\'nın $email adresine gönderdiği onay bağlantısını açın. İşlem kendiliğinden devam eder.';
  }

  @override
  String get signInFailed => 'Hesap eklenmedi.';

  @override
  String get signInCancelled => 'Oturum açma iptal edildi.';

  @override
  String get signInNoAccount => 'Bu e-postayla bir Firefox Account yok.';

  @override
  String get signInNoAccountHint =>
      'E-postayı kontrol edin ya da bu e-postayla Mozilla\'nın sitesinde ücretsiz bir Firefox Account oluşturun, gelen kutunuzdan onaylayın ve buraya ekleyin.';

  @override
  String get createAccountButton => 'Firefox Account oluştur';

  @override
  String get signInWrongPassword => 'Parola yanlış.';

  @override
  String get signInNoPassword =>
      'Bu hesabın parolası yok: Google veya Apple ile oturum açılarak oluşturulmuş. Bir parola belirleyin, ardından onunla burada oturum açın.';

  @override
  String get setPasswordButton => 'Parola belirle';

  @override
  String get signInTooManyAttempts =>
      'Çok fazla deneme yapıldı. Biraz bekleyip yeniden deneyin.';

  @override
  String get signInUnblockRejected =>
      'Engel kaldırma kodu kabul edilmedi. Mozilla\'nın son e-postasındaki kodu kullanın.';

  @override
  String get signInWrongCode =>
      'Kod yanlış veya süresi dolmuş. Mozilla\'nın son e-postasındaki kodu kullanın; yeni kod gönderilince eskisi çalışmaz.';

  @override
  String get signInWrongTotp =>
      'Kod yanlış. Kimlik doğrulama uygulamasının şu an gösterdiği kodu girin.';

  @override
  String get signInTooManyCodes =>
      'Çok fazla yanlış kod girildi. Oturum açmaya baştan başlayın.';

  @override
  String get signInTimedOut => 'Oturum açma çok uzun sürdü. Yeniden başlayın.';

  @override
  String get signInNetwork =>
      'Mozilla\'ya ulaşılamadı. İnternetinizi kontrol edip yeniden deneyin.';

  @override
  String get coreConnecting => 'Çekirdeğe bağlanılıyor…';

  @override
  String get coreLost => 'Çekirdekle bağlantı koptu. Yeniden deneniyor…';

  @override
  String get cantReachCore => 'Çekirdeğe ulaşılamıyor';

  @override
  String get startingCore => 'Çekirdek başlatılıyor…';

  @override
  String get retry => 'Yeniden dene';

  @override
  String errNoCore(String path) {
    return 'Çekirdek programı uygulamanın yanında bulunamadı ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'Çekirdek durdu: $detail';
  }

  @override
  String get errNotAnswering => 'Çekirdek yanıt vermiyor.';

  @override
  String get errRefused =>
      'Çekirdek uygulamayı reddetti; başka bir kopyaya ait olabilir.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get sectionGeneral => 'Genel';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Sistem varsayılanı';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get closeBehavior => 'Pencere kapatılırken';

  @override
  String get closeAsk => 'Her seferinde sor';

  @override
  String get closeTray => 'Sistem tepsisine küçült';

  @override
  String get closeQuit => 'Uygulamadan çık';

  @override
  String get sectionConnection => 'Bağlantı';

  @override
  String get localProxy => 'Yerel proxy';

  @override
  String get systemProxy => 'Sistem proxy\'si';

  @override
  String get sectionRouting => 'Yönlendirme';

  @override
  String get routingDirect => 'Yerel siteler için doğrudan bağlantı';

  @override
  String get routingDirectHint =>
      'Seçilen ülkenin siteleri ve IP\'leri VPN kullanmadan açılır: daha hızlı yüklenir ve kotanızı harcamaz.';

  @override
  String get region => 'Ülke';

  @override
  String get regionIr => 'İran';

  @override
  String get regionCn => 'Çin';

  @override
  String get regionRu => 'Rusya';

  @override
  String get regionAf => 'Afganistan';

  @override
  String get regionTr => 'Türkiye';

  @override
  String get regionId => 'Endonezya';

  @override
  String get regionBr => 'Brezilya';

  @override
  String get regionNone => 'Hiçbiri';

  @override
  String get saved => 'Kaydedildi';

  @override
  String get dataFolder => 'Veri klasörü';

  @override
  String get openFolder => 'Klasörü aç';

  @override
  String get unofficialNote =>
      'Resmî olmayan istemci. Mozilla ile bir ilişkisi yoktur.';

  @override
  String get closeTitle => 'Pencere kapatılsın mı?';

  @override
  String get closeBody =>
      'Tepsiye küçültülünce VPN bağlı kalır. Çıkarsanız bağlantı kesilir.';

  @override
  String get rememberChoice => 'Seçimimi hatırla';

  @override
  String get minimizeToTray => 'Tepsiye küçült';

  @override
  String get quit => 'Çık';

  @override
  String get trayOpen => 'Aç';

  @override
  String get trayQuit => 'Çık';

  @override
  String get trayProxyOnly => 'Yalnızca proxy hizmeti';

  @override
  String get traySetSystemProxy => 'Sistem proxy\'sini ayarla';

  @override
  String errPortInUse(String port) {
    return '$port portu başka bir program tarafından kullanılıyor, bu yüzden uygulama çekirdeğine ulaşamıyor.';
  }

  @override
  String proxyPortInUse(String port) {
    return '$port portu başka bir program tarafından kullanılıyor, bu yüzden proxy başlatılamıyor.';
  }

  @override
  String get changePort => 'Portu değiştir';

  @override
  String get portDialogTitle => 'Port seçin';

  @override
  String portDialogBody(String port) {
    return '$port portu kullanımda. Aşağıda boş bir port önerildi; isterseniz başka bir port yazabilirsiniz.';
  }

  @override
  String get portChangeBody =>
      'Uygulamalar bu porta bağlanır. 1024 ile 65535 arasında bir port seçin.';

  @override
  String get portLabel => 'Port';

  @override
  String get portInvalid => '1024 ile 65535 arasında bir port girin';

  @override
  String get portBusy => 'Bu port da kullanımda';

  @override
  String get portInUse => 'Bu portu başka bir program kullanıyor';

  @override
  String get save => 'Kaydet';

  @override
  String get proxyPort => 'Proxy portu';

  @override
  String get appPort => 'Uygulama portu';

  @override
  String get welcomeTitle => 'Hoş geldiniz';

  @override
  String get welcomeBody =>
      'Dilinizi ve ülkenizi seçin. Ülkenizin siteleri VPN olmadan doğrudan açılır; böylece daha hızlı yüklenir ve kotanızı harcamaz.';

  @override
  String get start => 'Başla';

  @override
  String routingSuggestTitle(String country) {
    return '$country siteleri doğrudan açılsın mı?';
  }

  @override
  String routingSuggestBody(String country) {
    return '$country siteleri ve IP\'leri VPN olmadan doğrudan açılır. Bunu Yönlendirme bölümünden değiştirebilirsiniz.';
  }

  @override
  String get yes => 'Evet';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String get navServers => 'Sunucular';

  @override
  String get navLogs => 'Günlükler';

  @override
  String get realDelay => 'Gerçek gecikme';

  @override
  String get statElapsed => 'Süre';

  @override
  String get statDown => 'İndirme';

  @override
  String get statUp => 'Yükleme';

  @override
  String noticePort(String port) {
    return 'Mozilla\'nın proxy\'si $port portuna bağlanmaz. Yalnızca 80, 443, 8080 ve 8443 portları VPN üzerinden geçer.';
  }

  @override
  String get noticeCommand => 'Bu bağlantı türü VPN\'de desteklenmiyor.';

  @override
  String noticeTimes(int count, String time) {
    return '$count kez, son: $time';
  }

  @override
  String get dismiss => 'Kapat';

  @override
  String get modeRecommended => 'Önerilen';

  @override
  String get modeFastest => 'En hızlı';

  @override
  String get modeRecommendedHint => 'Konumu Mozilla sizin için seçer.';

  @override
  String get modeFastestHint => 'Her bağlantıda en düşük gecikmeli konum.';

  @override
  String get testDelay => 'Gerçek gecikmeyi test et';

  @override
  String get testingDelay => 'Ölçülüyor…';

  @override
  String get search => 'Ara';

  @override
  String get noAnswer => 'Yanıt yok';

  @override
  String testedAgo(String ago) {
    return '$ago test edildi';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$total konumdan $answered tanesi yanıt verdi';
  }

  @override
  String get noServers =>
      'Henüz sunucu yok. Çekirdek Mozilla\'ya ulaşınca burada görünür.';

  @override
  String get levelAll => 'Tümü';

  @override
  String get filter => 'Filtre';

  @override
  String get follow => 'Otomatik kaydır';

  @override
  String get clear => 'Temizle';

  @override
  String get copyAll => 'Kopyala';

  @override
  String get logsCopied => 'Günlükler kopyalandı';

  @override
  String get noLogs => 'Henüz günlük satırı yok.';

  @override
  String get sectionAccounts => 'Otomatik hesap değiştirme';

  @override
  String get switchThreshold => 'Hesap değiştirme eşiği';

  @override
  String get switchThresholdHint =>
      'Kotanın bu kadarı dolunca sıradaki hesaba geçilir.';

  @override
  String get signInMethod => 'Giriş yöntemi';

  @override
  String get signInMethodBrowser => 'Tarayıcıyla giriş';

  @override
  String get signInMethodApi => 'Doğrudan giriş';

  @override
  String get browserSignInBroken => 'Giriş sayfası açılamadı.';

  @override
  String get browserSignInBlocked =>
      'Mozilla, hesabı eklemenin son adımını tamamlamadı (HTTP 406).';

  @override
  String get browserSignInFallback => 'E-posta ve parola ile giriş';

  @override
  String get backupExport => 'Yedeği kaydet';

  @override
  String get backupImport => 'Yedeği içe aktar';

  @override
  String backupSaved(String name) {
    return 'Kaydedildi: $name';
  }

  @override
  String get backupImportTitle => 'Bu hesaplar eklensin mi?';

  @override
  String get backupAccountExists => 'Zaten ekli; oturumu dosyadan alınacak';

  @override
  String get backupImportAction => 'Ekle';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hesap eklendi',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS sunucuları';

  @override
  String get dnsSystem => 'Sistem';

  @override
  String get dnsAuto => 'Otomatik (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Özel';

  @override
  String get dnsCustomHint =>
      'Her satıra bir tane: https://…/dns-query, tls://… veya bir IP adresi.';

  @override
  String get dnsFallback => 'Gerekirse sistem DNS\'ine geri dön';

  @override
  String get testDns => 'DNS\'i test et';

  @override
  String get transport => 'Protokol';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP sürümü';

  @override
  String get ipVersionAuto => 'Otomatik (önce IPv4, sonra IPv6)';

  @override
  String get ipVersionDual => 'İkisi birden (dual-stack)';

  @override
  String get ipVersionV6First => 'Önce IPv6, sonra IPv4';

  @override
  String get ipVersionV4 => 'Yalnızca IPv4';

  @override
  String get ipVersionV6 => 'Yalnızca IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'VPN arayüzünün paket boyutu, 1280 ile 9000 arası. Boş: otomatik.';

  @override
  String get tunMtuInvalid => '1280 ile 9000 arası bir sayı ya da boş';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Doğrudan';

  @override
  String get directRulesHint =>
      'Bu listedeki siteler ve adresler VPN olmadan, doğrudan kendi internetinizle açılır. Seçilen ülkenin kuralları zaten burada: satır ekleyebilir, değiştirebilir veya silebilirsiniz. Başka bir ülke seçmek bunları o ülkenin kurallarıyla değiştirir.';

  @override
  String get restoreRegionRules => 'Ülke kurallarını geri yükle';

  @override
  String get blockRules => 'Engelle';

  @override
  String get blockRulesHint =>
      'Bu listedeki siteler ve adresler hiç açılmaz; ne doğrudan ne de VPN üzerinden: reklamlar veya asla açılmasını istemediğiniz siteler için.';

  @override
  String get rulesTitle => 'Kurallar';

  @override
  String get ruleSyntaxTitle => 'Kural nasıl yazılır';

  @override
  String get resolveDomains => 'IP kurallarını alan adlarına da uygula';

  @override
  String get routingLists => 'Geo dosyaları';

  @override
  String get listSource => 'Liste kaynağı';

  @override
  String get listSourceCustom => 'Elle ayarlandı';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Güncellendi: $ago';
  }

  @override
  String get updateLists => 'Geo dosyalarını güncelle';

  @override
  String get listsUpdated => 'Geo dosyaları güncellendi.';

  @override
  String get testDestination => 'Bir sitenin rotasını test et';

  @override
  String get destinationHint => 'Alan adı, IP adresi veya URL';

  @override
  String get check => 'Kontrol et';

  @override
  String get routeDirect => 'Doğrudan gider';

  @override
  String get routeProxy => 'VPN üzerinden gider';

  @override
  String get routeBlock => 'Engellendi';

  @override
  String ruleMatched(String rule) {
    return 'Kural: $rule';
  }

  @override
  String get portRefusedNote => 'Mozilla\'nın proxy\'si bu porta bağlanmaz.';

  @override
  String get sectionAdvanced => 'Gelişmiş';

  @override
  String get tlsFragment => 'TLS parçalama';

  @override
  String get tlsFragmentOff => 'Kapalı';

  @override
  String get tlsFragmentFirstByte => 'İlk bayt';

  @override
  String get tlsFragmentSni => 'Sunucu adı (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'TLS başlığını ilk baytta böler (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Sunucu adını (SNI) birkaç TCP paketine böler';

  @override
  String get tlsFragmentRecord => 'TLS kaydı';

  @override
  String get tlsFragmentRecordHint =>
      'Sunucu adını (SNI) iki TLS kaydına böler';

  @override
  String get tlsFragmentOffHint => 'Normal TLS bağlantısı';

  @override
  String get sectionBypass => 'Mozilla engelliyse';

  @override
  String get sharedRelay => 'Paylaşılan aktarıcı';

  @override
  String get sharedRelayHint =>
      'Mozilla bölgenizi engellerse uygulamanın paylaşılan aktarıcılarını kullanın. Etkin kişisel aktarıcı önceliklidir.';

  @override
  String get personalRelay => 'Kişisel aktarıcı';

  @override
  String get apiRelay => 'Aktarma sunucusu';

  @override
  String get apiRelayUse => 'Aktarma sunucusunu kullan';

  @override
  String get apiRelayHint =>
      'Kendi Cloudflare Worker\'ınız veya kendi barındırmanızdaki relay.php.\nYalnızca Mozilla doğrudan yanıt vermediğinde kullanılır: ondan giriş, hesaplar ve sunucu listesi geçer, VPN trafiği geçmez.';

  @override
  String get upstreamProxy => 'Üst proxy';

  @override
  String get upstreamProxyOn => 'Üst proxy açık';

  @override
  String get upstreamProxyAddress => 'SOCKS5 proxy adresi';

  @override
  String get upstreamProxyPort => 'Port';

  @override
  String get upstreamProxyHint =>
      'Mozilla bağlantısı bu proxy üzerinden geçer; Mozilla\'yı engelleyen veya yavaşlatan ağlar için.\nProxy bu cihazda çalışıyorsa onu VPN dışında bırakın.';

  @override
  String get upstreamProxyInvalid => 'Proxy adresini girin, örneğin 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => '1 ile 65535 arasında bir port girin.';

  @override
  String get upstreamProxyOwn =>
      'Bu, uygulamanın kendi proxy\'si. Başka bir tane girin.';

  @override
  String get apiRelayInvalid => 'https:// adresi olmalıdır.';

  @override
  String get listenAddress => 'Proxy erişimi';

  @override
  String get listenLocal => '127.0.0.1 · yalnızca bu cihaz';

  @override
  String get listenAll => '0.0.0.0 · tüm ağlar (LAN)';

  @override
  String get proxyUsername => 'Proxy kullanıcı adı';

  @override
  String get proxyPassword => 'Proxy parolası';

  @override
  String get proxyLoginHint =>
      'Uygulamalar bu bilgilerle bağlanmalıdır. Parolasız kullanım için ikisini de boş bırakın.';

  @override
  String get loginBothOrNone =>
      'İkisini de doldurun ya da ikisini de boş bırakın.';

  @override
  String get proxyLogin => 'Proxy kullanıcı adı ve parolası';

  @override
  String get idleSleep => 'Boşta kalınca uykuya geç';

  @override
  String get sleepNever => 'Asla';

  @override
  String sleepMinutes(int count) {
    return '$count dakika';
  }

  @override
  String get sleepHour => '1 saat';

  @override
  String get showPublicIp => 'Genel IP\'yi göster';

  @override
  String get hapticFeedback => 'Bağlantı değişince titret';

  @override
  String get keepScreenOn => 'Bağlıyken ekranı açık tut';

  @override
  String get showTraffic => 'Ana sayfada canlı trafiği göster';

  @override
  String get speedInNotification => 'Bildirimde hızı göster';

  @override
  String get liveTraffic => 'Anlık trafik';

  @override
  String get totalTraffic => 'Toplam trafik';

  @override
  String get verboseLogs => 'Ayrıntılı günlükler';

  @override
  String get webDashboard => 'Web paneli';

  @override
  String get webDashboardOpen => 'Aç';

  @override
  String get webDashboardHint => 'Gelişmiş ayarlar ve daha fazla araç';

  @override
  String numberInvalid(int min, int max) {
    return '$min ile $max arasında bir sayı girin';
  }

  @override
  String get notifySwitchedTitle => 'Hesap değiştirildi';

  @override
  String notifySwitchedBody(String name) {
    return 'Şu an $name kullanılıyor.';
  }

  @override
  String get notifySignInTitle => 'Oturum açmanız gerekiyor';

  @override
  String get notifySignInBody =>
      'Hesaplar sayfasından bir hesapta yeniden oturum açın.';

  @override
  String get navAbout => 'Hakkında';

  @override
  String get appVersionLabel => 'Uygulama sürümü';

  @override
  String get coreVersionLabel => 'Çekirdek sürümü';

  @override
  String get checkUpdates => 'Güncellemeleri kontrol et';

  @override
  String get checkingUpdates => 'Kontrol ediliyor…';

  @override
  String get upToDate => 'En son sürümü kullanıyorsunuz.';

  @override
  String updateAvailable(String version) {
    return '$version sürümü mevcut.';
  }

  @override
  String updateRequired(String version) {
    return 'Lütfen $version sürümüne güncelleyin. Bu güncelleme gereklidir.';
  }

  @override
  String get download => 'İndir';

  @override
  String updateCheckFailed(String error) {
    return 'Güncellemeler kontrol edilemedi: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'GitHub\'a ulaşılamadı. İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get updateNow => 'Güncelle';

  @override
  String updateDownloading(String version) {
    return '$version sürümü indiriliyor…';
  }

  @override
  String updateReady(String version) {
    return '$version sürümü kurulmaya hazır.';
  }

  @override
  String updateInstalling(String version) {
    return '$version sürümü kuruluyor. Uygulama kapanıp yeniden açılacak.';
  }

  @override
  String updateFailed(String version) {
    return '$version sürümüne güncellenemedi.';
  }

  @override
  String updateDone(String version) {
    return '$version sürümüne güncellendi.';
  }

  @override
  String updateRolledBack(String version) {
    return '$version sürümüne güncelleme tamamlanmadı, bu yüzden uygulama önceki sürüme döndü.';
  }

  @override
  String get repoNotSet => 'GitHub deposu henüz ayarlanmadı.';

  @override
  String get sourceCode => 'Kaynak kodu';

  @override
  String get tapToConnect => 'Bağlanmak için tıklayın';

  @override
  String get tapToDisconnect => 'Bağlantıyı kesmek için tıklayın';

  @override
  String get startOnBoot => 'Açılışta başlat';

  @override
  String get connectOnStartup => 'Açılışta bağlan';

  @override
  String get proxyServiceActive => 'Proxy hizmeti etkin';

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get groupApp => 'Uygulama';

  @override
  String get groupNetwork => 'Ağ';

  @override
  String get stateOff => 'Bağlı değil';

  @override
  String get tapToConnectPhone => 'Bağlanmak için dokunun';

  @override
  String get tapToDisconnectPhone => 'Bağlantıyı kesmek için dokunun';

  @override
  String get tapToConnectTv => 'Bağlanmak için OK tuşuna basın';

  @override
  String get tapToDisconnectTv => 'Bağlantıyı kesmek için OK tuşuna basın';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Önerilen konum';

  @override
  String dataLeftOf(String limit) {
    return '/ $limit';
  }

  @override
  String get homeLocation => 'Konum';

  @override
  String get connectedTo => 'Bağlı konum';

  @override
  String get vpnNotAllowed =>
      'VPN için izniniz gerekiyor. Düğmeye tekrar dokunun ve izin verin.';

  @override
  String get dataUsedTitle => 'Kullanılan veri';

  @override
  String get bypassApps => 'Uygulama bazlı proxy';

  @override
  String get connectRetrying => 'Bağlanılamadı. İnternetinizi kontrol edin.';

  @override
  String get failUnreachable =>
      'Mozilla sunucularına ulaşılamadı. Başka bir internet bağlantısı deneyin.';

  @override
  String get failUpstreamProxy =>
      'Üst proxy üzerinden Mozilla\'ya ulaşılamadı. Proxy\'nin çalıştığını kontrol edin.';

  @override
  String get failInsideVpn =>
      'Bu internet zaten bir VPN üzerinden geçiyor. Onu kapatın.';

  @override
  String get failRefused =>
      'Mozilla sunucusu bağlantıyı reddetti. Birkaç dakika sonra tekrar deneyin.';

  @override
  String get failLocationRefused =>
      'Bu ülke hesabınıza açık değil. Başka bir ülke seçin.';

  @override
  String get useRecommendedLocation => 'Önerilen konumu kullan';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Seçtiğiniz ülke: $chosen; IP adresinizin ülkesi: $exit.';
  }

  @override
  String get failSignIn =>
      'Bu hesabın oturumu sona erdi. Hesaplar sayfasından yeniden giriş yapın.';

  @override
  String get failQuota => 'Bu ayın verisi bitti. Başka bir hesap ekleyin.';

  @override
  String get failNotEntitled =>
      'Mozilla bu hesabın VPN kullanmasına izin vermiyor. Başka bir hesap ekleyin.';

  @override
  String get failRegion => 'Mozilla ülkenizde hizmet vermiyor.';

  @override
  String get failServer =>
      'Mozilla hizmetinde geçici bir sorun var. Uygulama kendisi tekrar deneyecek.';

  @override
  String get failNoAccount => 'Hazır hesap yok. Hesaplar sayfasını açın.';

  @override
  String get failTestSite =>
      'Sunucuya bağlandı ama siteler açılmıyor. Başka bir ülke deneyin.';

  @override
  String get failOther => 'Bağlanılamadı. Tekrar deneyin.';

  @override
  String get failNoInternet =>
      'İnternet yok. Wi-Fi\'yi veya mobil veriyi kontrol edin.';

  @override
  String get waitingForNetwork => 'İnternet bağlantısı bekleniyor…';

  @override
  String proxyStartFailed(String port) {
    return 'Proxy $port portunda başlatılamadı. Başka bir port seçin.';
  }

  @override
  String get connectionSettings => 'Bağlantı ayarları';

  @override
  String get appModeExclude => 'Seçili uygulamaları hariç tut';

  @override
  String get appModeInclude => 'Yalnızca seçili uygulamalar';

  @override
  String get appModeExcludeHint =>
      'Seçili uygulamalar VPN yerine doğrudan bağlanır: örneğin yabancı adresleri reddeden bankacılık uygulamaları.';

  @override
  String get appModeIncludeHint =>
      'Yalnızca seçili uygulamalar VPN üzerinden gider; diğerleri doğrudan bağlanır.';

  @override
  String fromRegionList(String region) {
    return 'Önerilen: $region listesinde';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Bağlantı modu';

  @override
  String get modeProxyHint =>
      'Yalnızca proxy ayarı yapılmış uygulamalar proxy\'den geçer.';

  @override
  String get modeSystemProxyHint =>
      'Windows ve çoğu uygulama proxy üzerinden geçer.';

  @override
  String get modeSystemProxyHintOther =>
      'Tarayıcılar ve çoğu uygulama proxy üzerinden geçer.';

  @override
  String get suggestedApps => 'Önerilen uygulamalar';

  @override
  String get showSystemApps => 'Sistem uygulamalarını göster';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count önerilen uygulama seçildi',
      one: '1 önerilen uygulama seçildi',
      zero: 'Önerilen uygulamalar zaten seçili',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Otomatik';

  @override
  String get locationsSection => 'Konumlar';

  @override
  String get dnsSummaryOk => 'Şifreli DNS çalışıyor';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alan adı çözümlenemedi',
      one: '1 alan adı çözümlenemedi',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return '$server üzerinden';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ağınızın DNS\'i $count alan adı için filtreleme adresi döndürdü. Bu uygulama bu yanıtları kullanmaz.',
      one: 'Ağınızın DNS\'i 1 alan adı için filtreleme adresi döndürdü. Bu uygulama o yanıtı kullanmaz.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Yanıt:';

  @override
  String get dnsNetworkAnswer => 'Ağ DNS\'i:';

  @override
  String get dnsFiltered => 'filtrelendi';

  @override
  String get rulesSyntaxTitle => 'Her satıra bir kural';

  @override
  String get ruleDomain => 'Site ve alt alan adları';

  @override
  String get ruleFull => 'Yalnızca bu alan adı';

  @override
  String get ruleKeyword => 'Bu kelimeyi içeren alan adları';

  @override
  String get ruleGeosite => 'Geo dosyalarında bir etiketteki siteler';

  @override
  String get ruleGeoip => 'Geo dosyalarında bir ülkenin IP adresleri';

  @override
  String get ruleIp => 'Bir IP adresi veya ağ';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Yalnızca proxy';

  @override
  String get noNetwork =>
      'İnternet bağlantısı yok. Wi-Fi\'yi veya mobil veriyi açın.';

  @override
  String get blockAds => 'Reklamları engelle';

  @override
  String systemProxyTakenBy(String address) {
    return 'Başka bir program sistem proxy\'sini $address olarak değiştirdi, bu yüzden trafik VPN\'den geçmiyor.';
  }

  @override
  String get systemProxyTakenOff =>
      'Başka bir program sistem proxy\'sini kapattı, bu yüzden trafik VPN\'den geçmiyor.';

  @override
  String get setSystemProxyAgain => 'Yeniden ayarla';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Tüm $os trafiği VPN üzerinden geçer.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'TUN hizmetini yüklemek için izin bekleniyor…';

  @override
  String get tunInstallCancelled =>
      'TUN modu bir kez yönetici izni gerektirir. İzin verilmedi, bu yüzden mod değişmedi.';

  @override
  String tunInstallFailed(String error) {
    return 'TUN hizmeti yüklenemedi: $error';
  }

  @override
  String get tunStarting => 'TUN modu açılıyor…';

  @override
  String get tunFailed => 'TUN modu açılamadı. Yeniden deneniyor…';

  @override
  String get tunLost =>
      'TUN modu beklenmedik şekilde kapandı. Yeniden deneniyor…';

  @override
  String get tunNotRunning => 'TUN hizmeti çalışmıyor. Yeniden deneniyor…';

  @override
  String get tunMissing => 'TUN hizmeti yüklü değil.';

  @override
  String get tunOutdated =>
      'TUN hizmeti bu uygulamadan eski. TUN modunu kullanmak için yeniden yükleyin.';

  @override
  String get tunAppOutdated =>
      'TUN hizmeti bu uygulamadan yeni. TUN modunu kullanmak için uygulamayı güncelleyin.';

  @override
  String get tunBusy => 'Homa VPN\'in başka bir kopyası TUN modunu kullanıyor.';

  @override
  String get tunNoDriver =>
      'Sistemin TUN sürücüsü kullanılamıyor. Bilgisayarı yeniden başlatıp tekrar deneyin.';

  @override
  String get tunInstall => 'Yükle';

  @override
  String get tunInstallAgain => 'Yeniden yükle';

  @override
  String get trayTunMode => 'TUN modu (tüm uygulamalar)';

  @override
  String get removeTunService => 'TUN hizmetini kaldır';

  @override
  String get removeTunServiceHint =>
      'TUN modunun kullandığı sistem hizmetini kaldırır. TUN yeniden seçildiğinde yeniden yüklenir.';

  @override
  String get tunServiceRemoved => 'TUN hizmeti kaldırıldı.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN, TUN modu için hizmeti yüklemek istiyor.';

  @override
  String get tunRemovePrompt =>
      'Homa VPN, TUN modunun hizmetini kaldırmak istiyor.';

  @override
  String tunRemoveFailed(String error) {
    return 'TUN hizmeti kaldırılamadı: $error';
  }

  @override
  String get sectionTun => 'TUN ayarları';

  @override
  String get tunPrograms => 'VPN\'i atlayan programlar';

  @override
  String get tunProgramsHint =>
      'Mozilla üzerinden değil, doğrudan bağlanırlar. Yalnızca VPN olmadan çalışan programlar için.';

  @override
  String get tunProgramsEmpty => 'Henüz program yok.';

  @override
  String get addProgram => 'Program ekle';

  @override
  String get programFiles => 'Programlar';

  @override
  String get tunProgramAll => 'Tüm trafik';

  @override
  String get tunProgramAllHint => 'Programın tamamı doğrudan bağlanır.';

  @override
  String get tunProgramUdp => 'Yalnızca UDP';

  @override
  String get tunProgramUdpHint =>
      'Yalnızca UDP\'si doğrudan bağlanır; geri kalanı VPN\'den geçer.';

  @override
  String get udpNoticeSetting => 'Engellenen UDP bildirimi';

  @override
  String udpNoticeBody(String program) {
    return '$program programının UDP trafiği VPN\'den geçmez.';
  }

  @override
  String get dontShowAgain => 'Bir daha gösterme';

  @override
  String get addRunningProgram => 'Çalışan programlardan';

  @override
  String get addProgramFile => 'Dosya seç…';

  @override
  String get addProgramName => 'Ad yaz…';

  @override
  String get programNameHint =>
      'Programın dosya adı, ör. steam.exe; * herhangi bir metin demektir (steam*, Steam\'in tüm programlarıdır).';

  @override
  String get runningProgramsEmpty => 'Çalışan başka program yok.';

  @override
  String get tabLog => 'Günlük';

  @override
  String get tabConnections => 'Bağlantılar';

  @override
  String get connectionsEmpty => 'Henüz bağlantı yok.';

  @override
  String connectionsOpen(int count) {
    return '$count açık';
  }

  @override
  String get connTime => 'Zaman';

  @override
  String get connRoute => 'Kural';

  @override
  String get connDestination => 'Hedef';

  @override
  String get connInbound => 'Giriş';

  @override
  String get connProtocol => 'Protokol';

  @override
  String get connColumns => 'Sütunlar';

  @override
  String get connTraffic => 'Trafik';

  @override
  String get connDuration => 'Süre';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Doğrudan';

  @override
  String get connRouteBlocked => 'Engellendi';

  @override
  String get connRoutePort => 'Port reddedildi';

  @override
  String get connRouteFailed => 'Başarısız';

  @override
  String get testRelay => 'Röle sağlığını test et';

  @override
  String get relayTestTitle => 'Röle sağlık testi';

  @override
  String get relayTestHint =>
      'Yalnızca röle kontrol edilir. Mozilla isteği veya hesap bilgisi gönderilmez.';

  @override
  String get relayTestPassed => 'Röle hazır';

  @override
  String get relayTestFailed => 'Rölenin sağlığı doğrulanamadı';

  @override
  String get relayTestCopy => 'Raporu kopyala';

  @override
  String get relayTestInterrupted => 'Test, tam sonuç alınmadan sona erdi.';

  @override
  String get searchLocations => 'Konum ara';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count konum',
      one: '1 konum',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Otomatik güncelleme';

  @override
  String get autoInstallApkHint =>
      'Yeni sürümler kendiliğinden indirilir; yüklemeden önce yükleyici sorar.';

  @override
  String get installNow => 'Yükle';

  @override
  String get updateAllowInstall =>
      'Güncellemeyi yüklemek için bu uygulamanın uygulama yüklemesine izin verin.';

  @override
  String get allowInstall => 'İzin ver';

  @override
  String get noResults => 'Aramayla eşleşen konum yok.';

  @override
  String get accentColor => 'Vurgu rengi';

  @override
  String get accentMono => 'Tek renk (varsayılan)';

  @override
  String get accentCustom => 'Özel renk';

  @override
  String get accentEmber => 'Kor';

  @override
  String get accentGold => 'Altın';

  @override
  String get accentEmerald => 'Zümrüt';

  @override
  String get accentSapphire => 'Safir';

  @override
  String get accentAmethyst => 'Ametist';

  @override
  String get accentRose => 'Gül';

  @override
  String get autoReconnect => 'Otomatik yeniden bağlanma';

  @override
  String get autoReconnectHint =>
      'Bağlantı siz istemeden kopardığında kendisi yeniden bağlanır.';

  @override
  String get androidOnlyHint => 'Yalnızca telefonda.';

  @override
  String get idleDisconnect => 'Boşta kalınca bağlantıyı kes';

  @override
  String get idleDisconnectHint =>
      'Bir süredir trafik akmıyorsa oturumu sonlandırır.';

  @override
  String get idleTimeout => 'Boşta bekleme';

  @override
  String get minutes5 => '5 dakika';

  @override
  String get minutes10 => '10 dakika';

  @override
  String get minutes15 => '15 dakika';

  @override
  String get minutes30 => '30 dakika';

  @override
  String get minutes60 => '1 saat';

  @override
  String get dataLimit => 'Oturum veri sınırı';

  @override
  String get dataLimitHint => 'Trafik sınıra ulaştığında oturumu sonlandırır.';

  @override
  String get dataLimitAmount => 'Sınır';

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
    return '$minutes dakikadır trafik akmıyordu; bağlantı kesildi.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'Oturum $mb MB veri sınırına ulaştı; bağlantı kesildi.';
  }

  @override
  String get protection => 'Koruma';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'VPN kesilirse trafik, bağlantı geri gelene kadar tutulur — asla sızmaz.';

  @override
  String get alwaysOnVpn => 'Her zaman açık VPN';

  @override
  String get alwaysOnVpnHint =>
      'Android\'in kendi koruması: VPN olmadan hiçbir bağlantı geçmez.';

  @override
  String get floatingIsland => 'Yüzen ada';

  @override
  String get floatingIslandHint =>
      'Uygulamadan çıkarken bağlantıyı diğer uygulamaların üzerinde gösterir.';

  @override
  String whatsNewTitle(String version) {
    return '$version sürümündeki yenilikler';
  }

  @override
  String get whatsNewContinue => 'Anladım';

  @override
  String get whatsNewMenu => 'Yenilikler';

  @override
  String get whatsNewView => 'Yeniden göster';

  @override
  String get updateServers => 'Sunucuları güncelle';

  @override
  String get updatingServers => 'Güncelleniyor…';

  @override
  String serversUpdated(int count) {
    return 'Mozilla\'nın resmi listesinden $count konum';
  }

  @override
  String get serversUpdateFailed =>
      'Sunucu listesi güncellenemedi; önceki listeyi korundu.';

  @override
  String get smartPickTitle => 'Şu anki en hızlı';

  @override
  String get smartPickUse => 'Kullan';

  @override
  String get connectAtBoot => 'Telefon açılınca bağlan';

  @override
  String get connectAtBootHint =>
      'VPN izni verilmişse açılışta kendiliğinden bağlanır.';

  @override
  String get gamingProfile => 'Oyun profili';

  @override
  String get gamingProfileHint =>
      'Bağlantının canlı gecikmesini ve kalitesini gösterir; ölçülen en hızlı sunucuyla birlikte.';

  @override
  String get diagnosticsRun => 'Tanılamayı çalıştır';

  @override
  String get diagnosticsHint => 'Bağlantı, DNS ve tünel tek dokunuşta';

  @override
  String get diagnosticsTunnel => 'Tünel';

  @override
  String get diagnosticsTunnelUp => 'Kurulu ve trafik taşıyor';

  @override
  String get diagnosticsTunnelDown => 'Kapalı';

  @override
  String get diagnosticsExit => 'Çıkış ülkesi';

  @override
  String get diagnosticsMismatch => 'Çıkış ülkesi seçiminizden farklı';

  @override
  String get diagnosticsConnection => 'Bağlantı testi';

  @override
  String get diagnosticsPassed => 'Başarılı';

  @override
  String get diagnosticsFailed => 'Başarısız';

  @override
  String get diagnosticsDnsFiltered => 'Yanıt engellendi veya filtrelandı';

  @override
  String get diagnosticsDnsOk => 'Yanıtladı';

  @override
  String get diagnosticsPrivacy =>
      'Buradaki hiçbir şey kaydedilmez; sonuçlar bu pencerede ve çekirdeğin kendi günlüğünde kalır.';

  @override
  String get diagnosticsAgain => 'Yeniden çalıştır';

  @override
  String get whatsNewAdded => 'Yeni';

  @override
  String get whatsNewImproved => 'İyileştirildi';

  @override
  String get whatsNewFixed => 'Düzeltildi';

  @override
  String get wnWheelImproved =>
      'Ülke çarkı yeniden çizildi: seçilen bayrak cam bir çerçevede ince bir parıltı ve arkasında yumuşak bir ışık hâlesiyle daha büyük duruyor, diğer bayraklar derinlikle daha küçük, altındaki ad ise kayarak geliyor.';

  @override
  String get wnLiveImproved =>
      'Bağlıyken bildirim, Android 16dan referans uygulamada olduğu gibi Live Update olarak yükseltilmesini ister; süre kendini sayar, hızlar canlıdır.';

  @override
  String get wnL10nFixed =>
      'Bu sayfa artık uygulamanın dilinde konuşuyor — on beş dilinin hepsinde, yalnızca İngilizce değil.';

  @override
  String get wnMarkFixed =>
      'Mozilla\'nın işareti karo üzerinde temiz duruyor, köşeleri bayraklar gibi yuvarlak.';

  @override
  String get designTitle => 'Ana sayfa tasarımı';

  @override
  String get designHint => 'Ana sayfanın dizilişi';

  @override
  String get designWheel => 'Çark';

  @override
  String get designWheelDesc => 'Bayraklar cam çarkında, anahtar altında';

  @override
  String get designBento => 'Mozaik';

  @override
  String get designBentoDesc =>
      'Yuvarlak mozaik levha: bağlantı, sayılar, konum';

  @override
  String get designPixel => 'Sade';

  @override
  String get designPixelDesc => 'Tek sakin bir kart: konum, anahtar, sayılar';

  @override
  String get notifFlag => 'Bildirimde ülke bayrağı';

  @override
  String get notifFlagHint => 'Ülkenin kendi bayrağı adının yanında';

  @override
  String get wnDesignAdded =>
      'Ana sayfa tasarımı ayarı: çark, mozaik veya sade kart';

  @override
  String get wnMapAdded =>
      'Ana sayfanın ardında gerçek vektör dünya haritası, seçilen ülke aydınlık';

  @override
  String get wnWheelAdded =>
      'Bayrak çarkı yeniden çizildi: derin cam, yumuşak hareket';

  @override
  String get wnFlagNotifAdded =>
      'Bildirim ülkenin SVG bayrağını gösterebilir ve kapatılabilir';

  @override
  String get wnColorRemoved =>
      'Özel renk sayfası kaldırıldı; vurgu listesi HEX kodunu tutuyor';

  @override
  String get whatsNewRemoved => 'Kaldırıldı';

  @override
  String get wnCrashFixed =>
      'Uygulama, Android 16 telefonlarında artık kendi kendine kapanmıyor: bildirim, telefonda henüz olmayan bir şey istiyordu.';

  @override
  String get wnFlagArtFixed =>
      'Uygulama artık açılınca kendini dışarı atmıyor: bildirimin bayrak görseli sistemin mesajlaşma katmanının reddettiği bir değer döndürüyordu.';

  @override
  String get statSession => 'Oturum';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get wnTotalsAdded =>
      'Ana sayfa oturumun toplam trafiğini gösteriyor; bir dokunuş genel IP\'yi kopyalıyor.';

  @override
  String get wnPolishImproved =>
      'Bayrak çarkı ve sunucular sayfası daha derli toplu; metinler daha kompakt ve Android tüneli trafiği daha hızlı taşıyor.';

  @override
  String get valueSmart => 'Akıllı';

  @override
  String get wnSmartAdded =>
      'Akıllı bağlantı: MTU, protokol ve IP sürümü ağa uyarlanır; gerçek yanıtlarla, hız için seçilir.';

  @override
  String get wnToastAdded =>
      'Onaylar artık yumuşak, iOS tarzı bir not olarak geliyor; kendini çizen bir işaretle.';

  @override
  String get wnFlagsImproved =>
      'Bayrak çarkı temiz duruyor: ekran kenarında bayrak kesilmiyor, bayraklar tam görünür ve seçim yumuşak bir yayla yerleşiyor.';

  @override
  String get wnMapImproved =>
      'Dünya haritası daha büyük ve net çiziliyor: sıkışmış kıtalar yok, pürüzsüz kıyılar ve çapada ışıltılı bir hale.';

  @override
  String get dnsManual => 'Elle DNS';

  @override
  String get dnsManualHint =>
      'Her satıra bir adres: yalın IP, https:// (DNS-over-HTTPS) veya tls://host (DNS-over-TLS). İlk yanıt kazanır.';

  @override
  String get dnsManualInvalid =>
      'Bir satır, çekirdeğin kullanabileceği bir adres değil: yalın IP, https://… veya tls://host.';

  @override
  String get killSwitchGuarded =>
      'Korumalı: tünel kesikken telefondan hiçbir şey çıkmaz.';

  @override
  String get accountsUsageTitle => 'Bu ay';

  @override
  String get accountsCountLabel => 'hesap';

  @override
  String get accountsUsageAverage => 'hesapların harcanan payının ortalaması';

  @override
  String get wnDesignsAdded =>
      'Uygulama tasarımları: uygulamanın tamamı Yumuşak Neomorfizm veya Kutup Işığı Camı giyebilir — her sayfa, her kart — Ayarlar → Genel\'den.';

  @override
  String get wnWheelFixed =>
      'Çarxın yarım bayrağı gitti: seçili bayrağın altındaki raf bir ışık gölcüğü, ikinci bir bayrak değil; ekran kenarında hiçbir şey kesilmiyor.';

  @override
  String get wnMapReal =>
      'Dünya haritası ülkelerin resmi sınırlarından yeniden çizildi — her kıyı, ada ve eksklav, sadık ve gerçek oranında.';

  @override
  String get wnGlobeAdded =>
      'Dünya artık küre: gümüş top seçili ülkeye dönüyor, ışıltılı bir pim ve yüzen bir kart onu işaretliyor, bağlantı yolları merkezlere uzanıyor.';

  @override
  String get wnWheelGlowImproved =>
      'Seçilen bayrak kendi mavi hâlesiyle cam bir çerçevede daha büyük duruyor, komşuları belirgin biçimde küçük ve çarkın altındaki işaretler nerede olduğunuzu gösteriyor.';

  @override
  String get wnDesignsRemoved =>
      'Uygulama tasarımı seçicisi kalktı: uygulama kendi tek renk görünümünü yeniden giydi — vurgu renginiz ve temanız olduğu gibi kaldı.';

  @override
  String get wnDnsAdded =>
      'Elle DNS: yalın IP\'ler, DNS-over-HTTPS ve DNS-over-TLS — her satırın türü yazarken gösterilir ve denetlenir.';

  @override
  String get wnSmartImproved =>
      'Akıllı bağlantı artık ağın yanıtını gösteriyor: seçtiği taşıma ve tuttuğu IP sürümü, canlı.';

  @override
  String get wnProtectionImproved =>
      'Kesme anahtarı nöbeti devredeyken haber verir; uygulamalar sayfası kaç uygulama seçtiğinizi gösterir.';

  @override
  String get wnWelcomeImproved =>
      'Karşılama, akan kutup ışığı üzerinde nefes alan bir kalkanla açılıyor; hesaplar sayfası ayı tek bakışta özetliyor.';

  @override
  String bypassAppsCount(String n) {
    return 'Seçili: $n';
  }

  @override
  String get sectionAppearance => 'Görünüm';

  @override
  String get mapStyle => 'Harita stili';

  @override
  String get mapStyleHint =>
      'Ana sayfanın küresi seçtiğiniz gibi boyanır. Bağlantının ışığı aynı kalır.';

  @override
  String get mapSilver => 'Gümüş';

  @override
  String get mapMidnight => 'Gece yarısı';

  @override
  String get mapOcean => 'Okyanus';

  @override
  String get mapMono => 'Tek renk';

  @override
  String get mapAurora => 'Aurora';

  @override
  String get batterySaver => 'Pil tasarrufu';

  @override
  String get batterySaverHint =>
      'Bağlıyken haritanın hareketini dinlendirir — kürenin nefesi, çarxın parıltısı. Bağlantının kendisi aynı kalır.';

  @override
  String get connectOnOpen => 'Uygulama açılınca bağlan';

  @override
  String get connectOnOpenHint =>
      'Uygulama açılırken VPN\'i kaldırır, son seçtiğiniz konumla.';

  @override
  String get speedTitle => 'Hız';

  @override
  String get parallelTunnels => 'Paralel tüneller';

  @override
  String get parallelTunnelsHint =>
      'Aynı anda Mozillaya birkaç tünel açar ve trafiği aralarında böler; böylece yavaş bir tünel artık hızı sınırlamaz. Sekiz tanesi pil için en ağırıdır.';

  @override
  String get tunnels1 => 'Bir — en kararlısı';

  @override
  String get tunnels2 => 'İki';

  @override
  String get tunnels4 => 'Dört — yavaş ağlarda daha hızlı';

  @override
  String get tunnels8 => 'Sekiz — en hızlısı';

  @override
  String get connectionCap => 'Bağlantı sınırı';

  @override
  String get connectionCapHint =>
      'Kaç uygulamanın aynı anda VPN üzerinden konuşabileceği; küçük bir sınır meşgul bir telefonda pil ve veri tasarrufu sağlar. Sınırsız varsaylandır.';

  @override
  String get capNone => 'Sınırsız';

  @override
  String get verboseLogging => 'Ayrıntılı tanılama';

  @override
  String get verboseLoggingHint =>
      'Her adımı günlüğe yazar — sorun bildirirken işe yarar, pili biraz daha yorar.';

  @override
  String get wn38MapStylesAdded =>
      'Haritanın beş stili: gümüş, gece yarısı, okyanus, tek renk ve aurora — ayarlardaki yeni Görünüm sayfası seçer, her birinin önizlemesi var.';

  @override
  String get wn38ZoomAdded =>
      'Harita yakınlaşıyor: iki parmakla çekin ya da çift dokunun — yaklaşır ve geri döner.';

  @override
  String get wn38OptionsAdded =>
      'İşe yarar seçenekler: daha çok hız için paralel tüneller, bağlantı sınırı, pil tasarrufu, uygulama açılınca bağlanma ve ayrıntılı tanılama.';

  @override
  String get wn38SocialAdded =>
      'Instagram ve Telegram artık bu sayfanın altında da duruyor.';

  @override
  String get wn38FlightImproved =>
      'Bir ülke seçmek küçük bir uçuş: kamera geri çekilir, küre döner, iğne sekişle iner ve yollar kendi kendine merkezlere uzanır.';

  @override
  String get wn38EffectsImproved =>
      'Harita daha zengin okunuyor: kürenin ardında yıldızlar, koordinat ızgarası, merkezlerin kendi ışıkları, kenarda bir hale ve karaların gölgesi.';

  @override
  String get wn38SpeedImproved =>
      'Hız seçeneği gerçek: paralel tüneller aynı anda birkaç bağlantı açar ve çekirdek trafiği aralarında böler.';

  @override
  String get wn38NameFixed =>
      'Seçilen ülkenin adı bir kez gösteriliyor — haritanın yüzen kartında; bayrakların altındaki kopya gitti.';

  @override
  String get mapKind => 'Harita türü';

  @override
  String get mapKindHint =>
      'Ana sayfanın dünyası nasıl gösterilir: her zamanki düz harita (varsayılan), modern biçimi, gece Dünya\'sı, arazi Dünya\'sı, metal küre veya uydu Dünya\'sı. Her türde sınırlar gerçek, resmî sınırlardır.';

  @override
  String get mapKindClassic => 'Klasik';

  @override
  String get mapKindGlobe => '3D küre';

  @override
  String get mapKindSatellite => 'Uydu';

  @override
  String get mapKindFlat => 'Düz 2D';

  @override
  String get mapStyleGlobeHint =>
      '3D kürenin giydiği renkler. Uydu kendi Dünya\'sını, düz haritalar kendi mürekkebini taşır.';

  @override
  String get aboutVersions => 'Sürüm';

  @override
  String get aboutChannels => 'İletişim sayfaları';

  @override
  String get checkUpdatesHint =>
      'Daha yeni bir sürüme bak; bulunan indirilir ve yükleyici sorar.';

  @override
  String get speedTestTitle => 'Hız testi';

  @override
  String get speedTestRun => 'Ölç';

  @override
  String get speedTestFailed => 'Ölçüm bitmedi.';

  @override
  String get speedTestThrough => 'Tünel üzerinden ölçüldü.';

  @override
  String get speedTestDirect => 'Doğrudan ölçüldü (proxy kapalı).';

  @override
  String get speedTestHint =>
      'Tünel üzerinden bir indirme ve bir yükleme, gerçekte ne taşıdığını söyler. Ana sayfanın grafiği de burayı açar.';

  @override
  String get speedGraphHint => 'Tünelin geçen dakikası · ölçmek için dokun';

  @override
  String get favoritePinned => 'Sabitlendi. Kaldırmak için tekrar uzun bas.';

  @override
  String get favoriteUnpinned => 'Kaldırıldı.';

  @override
  String get shareReport => 'Raporu paylaş';

  @override
  String get shareReportCopied => 'Rapor panoya kopyalandı.';

  @override
  String get batteryWizardTitle => 'Pilde hayatta kalmak';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei ve benzerleri ekran kilitlenince VPN uygulamalarını öldürür. Tünel yanık kalsın diye bu uygulamayı pil optimizasyonundan çıkar.';

  @override
  String get batteryWizardSteps =>
      'Üreticinin kendi ayarlarında otomatik başlatmaya da izin ver ve uygulamayı Kısıtlama yok (Xiaomi), Uyuyan uygulamalardan çıkar (Samsung) ya da Elle başlat (Huawei) yap.';

  @override
  String get batteryWizardState => 'Pil optimizasyonu tüneli durdurabilir.';

  @override
  String get batteryWizardPermit => 'İzin ver';

  @override
  String get batteryWizardOk => 'Tünel pilden korunuyor.';

  @override
  String get batteryWizardOpen => 'Pil ayarları';

  @override
  String get usageTitle => 'Uygulama kullanımı';

  @override
  String get usageRowHint => 'Her uygulama ne kadar kullandı';

  @override
  String get usageGrant => 'Kullanım erişimini aç';

  @override
  String get usageGrantHint =>
      'Android, uygulama başına veri kullanımını Kullanım erişimi izninin arkasında tutar. Düğmenin açtığı sayfa sistemin kendisidir; uygulama yalnızca sayıları okur.';

  @override
  String get usageEmpty => 'Bu dönemde kayıtlı kullanım yok.';

  @override
  String get usageToday => 'Bugün';

  @override
  String get usageWeek => 'Geçen 7 gün';

  @override
  String get usageMonth => 'Geçen 30 gün';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'Uygulama Google Play dışından kurulur; ilk kurulumda Play Protect tarama isteyebilir. Bir kez \"Uygulamayı tara\" deyin — temiz tarama hatırlanır ve sonraki güncellemeler bu soru olmadan kurulur.';

  @override
  String get smartLocation => 'En hızlı konum';

  @override
  String get smartLocationHint =>
      'Her başlangıç, çekirdeğin kendi gecikme testinin en hızlı dediği sunucuya çıkar.';

  @override
  String get quicPass => 'QUIC geçişi';

  @override
  String get quicPassHint =>
      'Uygulamaların QUIC\'i (UDP 443) tünelden geçer: aramalar ve oyunlar TCP\'ye düşmeden hızını korur.';

  @override
  String get accountRename => 'Hesabı yeniden adlandır';

  @override
  String get accountRenameLabel => 'Hesap adı';

  @override
  String get accountProfile => 'Profil resmi';

  @override
  String get avatarReset => 'Basit işarete dön';

  @override
  String get accountSecurity => 'Uygulama şifresi';

  @override
  String get appPasswordOn => 'Uygulama bir şifrenin ardında açılır.';

  @override
  String get appPasswordOff => 'Şifre yok: uygulamayı açan içeri girer.';

  @override
  String get appPasswordSet => 'Şifre oluştur';

  @override
  String get appPasswordChange => 'Şifreyi değiştir';

  @override
  String get appPasswordRemove => 'Şifreyi kaldır';

  @override
  String get appPasswordCurrent => 'Mevcut şifre';

  @override
  String get appPasswordNew => 'Yeni şifre (4+ karakter)';

  @override
  String get appPasswordConfirm => 'Yeni şifreyi yinele';

  @override
  String get appPasswordShort => 'En az 4 karakter.';

  @override
  String get appPasswordMismatch => 'İki şifre aynı değil.';

  @override
  String get appPasswordWrong => 'Şifre yanlış';

  @override
  String get appPasswordSetDone =>
      'Şifre kuruldu — uygulama bir sonraki açılışta soracak.';

  @override
  String get appPasswordRemoved => 'Şifre gitti; uygulama özgürce açılır.';

  @override
  String get appPasswordUnlock => 'Uygulama kilitli';

  @override
  String get appPasswordUnlockHint =>
      'Devam etmek için uygulama şifresini girin.';

  @override
  String get wn39MapKinds =>
      'Harita yeniden türlerini sunuyor: her zamanki düz harita (varsayılan), 3D küre, uydu Dünya\'sı ve modern düz 2D.';

  @override
  String get wn39EyeIp =>
      'Konum kartında bir göz var: dokunun, trafiğin çıktığı adresi görün ve kopyalayın.';

  @override
  String get wn39Profile =>
      'Hesaplar kendi adını ve profil resmini taşır; uygulama bir şifrenin ardında açılabilir.';

  @override
  String get wn39Smart =>
      'Akıllı bağlantı büyüdü: gerçek gecikmeyle en hızlı konum ve aramalar/oyunlar için QUIC geçişi.';

  @override
  String get wn39Flight =>
      'Ülke değişimi daha yumuşak uçar — kamera büyük çemberi izler — ve bayrak çarkının işaretleri bayraklara yakın.';

  @override
  String get wn39ToastEverywhere =>
      'Dinamik not artık her yerde: her kaydetme, kopyalama ve hata aynı animasyonlu cam kapsülü giyer.';

  @override
  String get wn39Updates =>
      'Güncellemeler depoyu temiz tutar: yükleyici eski sürümü değiştirir ve hiçbir paket geride kalmaz.';

  @override
  String get mapKindNight => 'Gece';

  @override
  String get mapKindTerrain => 'Arazi';

  @override
  String get wn40MapKindsNew =>
      'Haritanın iki yeni biçimi: gece Dünya\'sı ve arazi Dünya\'sı.';

  @override
  String get wn40Flight =>
      '3D küre yeni ülkeye tek bir yumuşak dönüşle uçar — asla sıçramaz.';

  @override
  String get wn40Mercator =>
      'Düz haritalar standart Mercator izdüşümüyle çizilir: gerçek oranlar, standart sınırlar, hiçbir sıkıştırma yok.';

  @override
  String get wn40NameBack =>
      'Seçilen ülkenin adı düz haritalarda bayrakların altına geri döndü.';

  @override
  String get wn40Speed =>
      'Tün artık varsayılan olarak iki paralel oturum açıyor — daha güçlü, daha kararlı bir hat.';

  @override
  String get wn40LockFixed =>
      'Bağlan düğmesinin kilidi artık durumları arasında kaybolmuyor.';

  @override
  String get wn40IpRemoved => 'Konum kartındaki IP penceresi kaldırıldı.';

  @override
  String get soundFeedback => 'Ses efektleri';

  @override
  String get soundFeedbackHint =>
      'Dokunuşlar, anahtarlar ve bağlanma-kopma için yumuşak sesler';

  @override
  String get rateUnit => 'Hız birimi';

  @override
  String get lockInBackground => 'Uzaklaşınca kilitle';

  @override
  String get lockBgNever => 'Asla';

  @override
  String get lockBgNow => 'Hemen';

  @override
  String get lockBgMin5 => '5 dakika sonra';

  @override
  String get lockBgMin15 => '15 dakika sonra';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound =>
      'Bağlantı sesi titreşime katıldı: VPN açılıp kapanırken kısa bir nota çalıyor (Ayarlar → Genel).';

  @override
  String get wn41RateUnit =>
      'Hız, seçtiğiniz birimle okunur: tanıdık KB/s ya da bağlantının kendi Mbps\'i.';

  @override
  String get wn41BackgroundLock =>
      'Uygulama siz yokken kendini kilitleyebilir: şifre hemen, 5 veya 15 dakika sonra yeniden sorulur.';

  @override
  String get wn41BiggerLimits =>
      'Oturumun veri sınırı 25, 50 veya 100 GB\'a yükseliyor.';

  @override
  String get wn41Motion =>
      'Yeni hareketler: bağlı küre nefes alır, onay işareti kendini çizer, durumun sözü değerleri arasında kayar, yanlış şifre alanı silkeler.';

  @override
  String get wn41AboutFixed =>
      'Hakkında sayfası düzeldi: iki sayfa yan yana, her ipucu kendi satırında, hiçbir sıkıştırma yok.';

  @override
  String get wn41HapticFixed =>
      'Titreşim ayarı yeniden dinliyor: her bağlanma ve kopma ona uyuyor, artık yalnızca kaydırıcının değil.';

  @override
  String get copyIp => 'IP\'yi kopyala';

  @override
  String get wn42Fonts =>
      'Her dil uygulamanın kendi yazı tipiyle okunur: iki Çince ile Bengalce için Noto Sans, Latin ve Kiril dilleri için Inter — artık hiçbir dil telefonun yazı tiplerine yaslanmıyor.';

  @override
  String get wn42Sounds =>
      'Uygulamanın sesleri artık gerçek: her bölümde yumuşak bir dokunuş, anahtarlar için iki nota, bağlantı açılıp kapanırken yükselen ve alçalan bir nota, kilit için bir zil — ses anahtarı hepsini yönetiyor.';

  @override
  String get wn42AboutFixed =>
      'Hakkında sayfası logosunu, adını ve notunu ortalar; iletişim kimlikleri telefonun genişliğinden bağımsız olarak bozulmadan tek satırda kalır.';

  @override
  String get wn42Gaming =>
      'Oyun profili artık gerçek: sunucular sayfası gecikmeleri yarım dakikada bir yeniden ölçüyor ve ölçülmüş en hızlısını vurgu rengiyle öne çıkarıyor.';

  @override
  String get avatarPhoto => 'Kendi fotoğrafın';

  @override
  String get avatarPhotoFailed => 'Bu fotoğraf kullanılamadı';

  @override

  @override

  @override

  @override

  @override
  String get tlsFragmentAuto => 'Otomatik';

  @override
  String get tlsFragmentAutoHint =>
      'Önce bütün merhaba; TLS\'i sürekley kesen ağ, adı yarım saatliğine kendiliğinden keser';

  @override
  String get accentDesign => 'Tasarımın kendi ışığı';

  @override
  String get wn45Designs =>
      'Dört yeni ana ekran tasarımı — Aurora, Neon, Gün batımı ve Adaçayı — her biri tüm sayfaları kendi paletiyle giydirir';

  @override
  String get wn45HelloAuto =>
      'TLS parçalayıcı öğrendi: el sıkışmayı sürekley öldüren ağın adı kendiliğinden kesilir, tünel geçer';

  @override
  String get wn45RelayRace =>
      'Röle kurtarma artık üç ucu birden dener, filtrelenmiş ağ yolunu daha çabuk bulur';

  @override
  String get wn45AccentFixed =>
      'Renk seçici uygulamayı yeniden aydınlatıyor — rengi sayfalara ulaşmıyordu';

  @override
  String get wn45WhatsNewFixed =>
      '«Yenilikler» sayfası sözlerini yeniden gösteriyor — boş açılıyordu';

  @override
  String get wn46Designs =>
      'Referans tasarımlardan iki yeni görünüm: etherin iOS durum kartı ve zedin gradyan küresi — her biri uygulamanın tamamını giydirir, önceki dört görünüm gitti.';

  @override
  String get wn46Sounds =>
      'Sesler profesyonel bir set kazandı: başlayan bağlantı için dalga, kurulduğunda akor, kesildiğinde iniş melodisi ve kapalı yol için boğuk bir nota — bir seferde tek ses.';

  @override
  String get wn47Designs =>
      'İki başvuru görünümü artık uygulamanın bütününü giyiyor — yalnızca ana sayfayı değil, her sayfayı: aether birinci başvurunun iOS yapısını (eğik çentikli çubuk, gruplu tablolar, renkli rozetler, sistemin kendi durum renkleri), zed ise ikinci başvurunun ifadeli yapısını (yüzen dock, çok yuvarlak kartlar, sürüklenebilir araç baloncukları) giyiyor.';

  @override
  String get wn47Fixes =>
      'Dar ekranlarda taşan bir ayar satırı artık sonuna kadar okunuyor.';

  @override
  String get wn48Bars =>
      'İki tasarımın alt barları yerine oturdu: aether\'in mavi çemberi kendi sekmesinin yuvasında duruyor, zed\'in çemberi artık altındaki adı kapatmıyor.';

  @override
  String get wn48Fit =>
      'Ana sayfalar yeniden ekranına sığıyor: aether kartı Disconnected\'i sonuna kadar okuyor, sayfa daraldığında zed\'in küresi bir adım küçülüyor ve bağlantı kurulurken ne yol bağlanmak için kaydırma diyor ne ipucu aynı anda kes diyor.';

  @override
  String get wn48Wheel =>
      'Bayrak çarkı, ekran kenarı bir kartı yarıp kesmeden önce onu eritir, önerilen yer Mozilla\'nın nişanını okunur boyda taşır ve düz haritanın güney kenarı bir çizgiye bitmek yerine sayfaya erir.';

  @override
  String get wn49States =>
      'İki referans tasarım da çizildikleri ayrıntıları giydi: aether kartı oturumun kendi hızlarını AetherST gibi taşır, güç düğmesi referansın ışımasıyla nefes alır ve parmağın altında göçer, zed\'in balonu şekilleri arasında dönüşür, merkezi ise solayarak değişir.';

  @override
  String get wn49Words =>
      '“Bağlanıyor” artık her yerde bir söze sahip: tünel kurulurken anahtarın yolu Bağlanıyor… sözünü taşır, topuzun işareti halleri arasında erir ve yol bağlantının kendi ritmiyle nefes alır — parmağın altında hiçbir şey kaybolmaz.';

  @override
  String get wn49Sooner =>
      'Bağlantının motoru yeniden aslın kendisi: röle havuzu, yedek yollar ve bellekleri, ve yinelenen isteklerin bekçisi tüneli taşır — daha erken kurulur ve ayakta kalır.';

  @override
  String get wn49Mark =>
      'Önerilen konum Mozilla VPN\'in gerçek işaretini taşır, güncelleme düğmeleri de güncellemenin kendi glifini.';

  @override
  String get wn50Notch =>
      'İki tasarımın giysisi taşıdığı dağınıklıktan çıkıyor: aether\'in çentikli çubuğu çemberin kendi merkezini okuyor, seçilen sekmenin adı her iki görünümde sayfanın kendi mürekkebini giyiyor, çemberin ışıması çemberde kalıyor ve adı yıkamıyor.';

  @override
  String get wn50Cards =>
      'zed\'in evi hızlarını bentoya katlıyor: hız kartı bentonun iki gözüne ve oturum satırına katılıyor, sayfanın son kartları dock\'un koltuğunu boş bırakıyor ve sayfa sonuna kadar kaydığında hiçbir şeyin yarısı dock\'un altında kalmıyor.';

  @override
  String get wn50Veil =>
      'Durum şeridi kendi perdesini giyiyor: kayan içerik saatle çarpışmak yerine saatin altında solar, zed\'in açtığı sayfalar artık saatin altında başlamıyor ve yüzen araçları dock\'un koltuğundan uzak duruyor.';

  @override
  String get wn50Ping =>
      'aether\'in ping çipi bir dokunuşla yeniden ölçüyor, tıpkı referansın kendi çipinin cevap vermesi gibi.';

  @override
  String get tapToChangeServer => 'Sunucuyu değiştirmek için dokun';

  @override
  String get wn51Smooth =>
      'Bayrak çarkı ve şeridi bir çarhın döndüğü gibi döner: sürükleme ve ülke değişimi artık oluşturucuda seyahat eder — bayraklar dönerken hiçbir şey yeniden düzenlenmez ve hiçbir ışıma kendini yeniden çizmez; çark pürüzsüz döner ve sayfa onunla birlikte kayar.';

  @override
  String get wn51Zed =>
      'zed\'in evi referansın kendi yapısını giydi: iki hız kartı markanın altında durur (tünel dinlendiğinde sıfırlarında dinlenir), durumun sözcüğü gırgırın altında display\'in büyük yüzüyle gelir ve yer, dock\'un üstündeki parlak sunucu kartında yaşar — küçük fiş ve tekrarlanan ad gitti.';

  @override
  String get wn51Aether =>
      'aether\'in evi yeri bir kez söyler: şeridin tekrarlanan ad satırı dinlenir, durum kartı ve güç düğmesi koltuklarını korur ve sayfa tek bir temiz sütun gibi okunur.';

  @override
  String get wn51Veil =>
      'Saatin perdesi bir nefes boyandı ve rengini saatin bütün şeridinde tutuyor: altında kayan içerik bütün halde solar ve sözcükleri saate hiç ulaşmaz.';

  @override
  String get wn52Speed =>
      'Tünel yeniden ağın kendi hızında akar: VPN arayüzü, abartılı boyut yerine hattın paket boyutunu (MTU 1500) konuşur; böylece indirmeler tam hızına ulaşır ve aramalar sabit kalır — özellikle mobil veride.';

  @override
  String get wn52Smart =>
      'En hızlı konum ve önerilen servis yeniden dürüstçe seçer: her başlangıç konumları taze ölçer ve şimdinin en iyisini alır — daha önce seçilen yeri sessizce taşımak yerine.';

  @override
  String get wn52Motion =>
      'Uygulamanın her yanında otuz yeni animasyon: her sayfa ve kart yumuşakça konar, basılan kutular çöker ve döner, bağlanıyor durumunun noktası nefes alır, açılan sayfalar yumuşak kayar — sistem daha az hareket istediğinde her biri durur.';

  @override
  String get wn52Pages =>
      'Açılan sayfalar yumuşak bir kayışla gelir, sayfa başlığı kendi kenarından; bir ayar kaydedilirken bölümde sessiz bir çizgi akar.';

  @override
  String get wn56Button =>
      'Bağlantı kaydırıcısı sözünü yolun boyunca korur — \'bağlanıyor\' ile \'bağlandı\' arasında artık boş bir an yok: söz şimdi hâlleri arasında kayar, çalışma kararması bir nefesle gelir.';

  @override
  String get wn56Capsule =>
      'Çarkın ana sayfası her hâli bir kez söyler: kaydırıcının üstündeki tekrarlanan durum sözü gitti — yolu kendisi taşır, sayfa bir satır daha sakin okunur.';

  @override
  String get wn56Door =>
      'Hız testinin ana sayfada kendi kapısı var: bir satır, bir dokunuş ve ölçüm açılır — ilk bağlantıdan önce de, yalnızca tünel taşıyorken değil.';

  @override
  String get wn56Wheel =>
      'Bayrak çarkı akıcı kayar: bir savurma bir ülke getirir, iniş çarpıp oturmak yerine yerine yerleşir — sürükleme ağır ve düzenli, iyi bir düğme gibi okunur.';

  @override
  String get designGazette => 'Gazete';

  @override
  String get designGazetteDesc =>
      'Manşet: başlık, çizgili sütunlar ve mürekkep damgası — kâğıt ve mürekkepte gazetenin sükûneti';

  @override
  String get speedTestSizesTitle => 'Test boyutu';

  @override
  String get speedTestSizeLight => 'Hafif';

  @override
  String get speedTestSizeStandard => 'Standart';

  @override
  String get speedTestSizeFull => 'Tam';

  @override
  String get speedTestJitter => 'Titreme';

  @override
  String gazetteEdition(int n) {
    return 'Sayı $n';
  }

  @override
  String get gazetteBulletin => 'Güvenlik Bülteni';

  @override
  String get gazetteLiveWire => 'Canlı hat';

  @override
  String get wn56Speed =>
      'Hız testi canlandı: her yön kendi bağlantısında ölçüyor ve yalın HTTP/1.1 konuşuyor, indirme penceresi kapanınca yükleme artık ölmüyor — panel yolun gecikmesini, titremesini ve seçilebilir boyutu ekliyor.';

  @override
  String get wn56Gazette =>
      'Yeni ana görünüm: gazete — başlıklı, çizgili sütunlu, canlı bantlı ve tünel tuttuğunda basılan mürekkep damgalı bir ön sayfa.';
}
