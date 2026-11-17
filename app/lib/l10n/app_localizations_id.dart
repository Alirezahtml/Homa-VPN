// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Geser untuk menyambung';

  @override
  String get slideToDisconnect => 'Geser untuk memutus';

  @override
  String get navOverview => 'Ringkasan';

  @override
  String get navAccounts => 'Akun';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get stateConnected => 'Terhubung';

  @override
  String get stateConnecting => 'Menghubungkan…';

  @override
  String get stateWaiting => 'Menunggu';

  @override
  String get waitingForAccount =>
      'Tambahkan Firefox Account di halaman Akun untuk terhubung.';

  @override
  String get waitingForEnabledAccount =>
      'Semua akun dinonaktifkan. Aktifkan salah satu di halaman Akun.';

  @override
  String get stateError => 'Error';

  @override
  String get stateUnknown => 'Tidak diketahui';

  @override
  String get restartProxy => 'Mulai ulang proxy';

  @override
  String copied(String value) {
    return '$value disalin';
  }

  @override
  String get activeAccount => 'Akun aktif';

  @override
  String get noActiveAccount => 'Tidak ada akun aktif';

  @override
  String get quotaNotRead => 'Kuota belum dicek';

  @override
  String get unlimited => 'Tanpa batas';

  @override
  String usedOf(String used, String limit) {
    return '$used dari $limit terpakai';
  }

  @override
  String resets(String date) {
    return 'reset $date';
  }

  @override
  String switchAt(int percent) {
    return 'Ganti akun pada $percent%';
  }

  @override
  String get publicIp => 'IP publik';

  @override
  String get testConnection => 'Uji koneksi';

  @override
  String get testing => 'Menguji…';

  @override
  String get testFailed => 'Gagal';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'baru saja';

  @override
  String minutesAgo(int n) {
    return '$n menit lalu';
  }

  @override
  String hoursAgo(int n) {
    return '$n jam lalu';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari lalu',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'pukul $time';
  }

  @override
  String durationDays(int d, int h) {
    return '${d}h ${h}j';
  }

  @override
  String durationHours(int h, int m) {
    return '${h}j ${m}m';
  }

  @override
  String durationMinutes(int m, int s) {
    return '${m}m ${s}d';
  }

  @override
  String durationSeconds(int s) {
    return '${s}d';
  }

  @override
  String accountsGuide(String size) {
    return 'Setiap Firefox Account punya kuota $size per bulan. Anda bisa menambahkan beberapa akun: saat satu habis, aplikasi otomatis pindah ke akun berikutnya.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'Sesuai urutan daftar ini: masing-masing sampai $percent%, yang terakhir sampai datanya habis.';
  }

  @override
  String get addAccount => 'Tambah akun';

  @override
  String lowQuotaNotice(String size) {
    return 'Kuota akun ini hampir habis. Tambahkan akun lain untuk mendapat $size lagi.';
  }

  @override
  String get noAccounts => 'Belum ada akun';

  @override
  String get noAccountsHint => 'Tambahkan Firefox Account untuk terhubung.';

  @override
  String get delayTestFailed =>
      'Tidak dapat mengukur jeda server. Periksa internet Anda.';

  @override
  String get createAccountTitle => 'Belum punya Firefox Account?';

  @override
  String get createAccountHint =>
      'Buat gratis di accounts.firefox.com, lalu kembali dan tekan Tambah akun.';

  @override
  String get moveUp => 'Naikkan';

  @override
  String get moveDown => 'Turunkan';

  @override
  String get statusActive => 'Aktif';

  @override
  String get statusReady => 'Siap';

  @override
  String get statusNeedsSignIn => 'Perlu masuk';

  @override
  String get statusReserved => 'Cadangan';

  @override
  String get statusUnavailable => 'Tidak tersedia';

  @override
  String statusUnavailableUntil(String date) {
    return 'Tidak tersedia hingga $date';
  }

  @override
  String get statusDisabled => 'Nonaktif';

  @override
  String get statusEnabled => 'Aktif';

  @override
  String get useNow => 'Gunakan sekarang';

  @override
  String get signInAgain => 'Masuk lagi';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Akun ini telah memakai $percent% datanya, jadi akun berikutnya mengambil alih.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Kuota bulan ini habis; dipakai lagi setelah reset bulanan.';

  @override
  String get reasonSignInRequired => 'Masuk lagi untuk memakai akun ini.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla meminta konfirmasi masuk: tekan Masuk lagi (hanya perlu kode).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Masuk otomatis gagal ($detail). Masuk lagi.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'Masuk otomatis terakhir segera berhenti berfungsi; percobaan berikutnya pukul $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Masuk otomatis tidak selesai ($detail); dicoba lagi pukul $time.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla menolak akun ini; akan dicoba lagi nanti.';

  @override
  String get more => 'Lainnya';

  @override
  String get refreshQuota => 'Perbarui kuota';

  @override
  String get remove => 'Hapus';

  @override
  String get removeTitle => 'Hapus akun?';

  @override
  String removeBody(String name) {
    return '$name dan data login yang tersimpan akan dihapus dari komputer ini. Anda bisa menambahkannya lagi nanti.';
  }

  @override
  String get unlimitedQuota => 'Kuota tanpa batas';

  @override
  String get signInTitle => 'Masuk';

  @override
  String get signInIntro => 'Masuk dengan Firefox Account.';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Masukkan email akun';

  @override
  String get password => 'Kata sandi';

  @override
  String get passwordEmpty => 'Masukkan kata sandi';

  @override
  String get show => 'Tampilkan';

  @override
  String get hide => 'Sembunyikan';

  @override
  String get signIn => 'Masuk';

  @override
  String get continueLabel => 'Lanjutkan';

  @override
  String get done => 'Selesai';

  @override
  String get close => 'Tutup';

  @override
  String get noBrowserTitle => 'Tidak ada browser di perangkat ini';

  @override
  String get noBrowserText => 'Buka alamat ini di ponsel atau komputer Anda:';

  @override
  String get cancel => 'Batal';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get signingIn => 'Sedang masuk…';

  @override
  String get accountReady => 'Akun siap';

  @override
  String get accountReadyHint => 'Akun ditambahkan di urutan terakhir.';

  @override
  String get captchaLabel => 'Teks pada gambar';

  @override
  String get codeLabel => 'Kode';

  @override
  String get captchaBroken => 'Gambar CAPTCHA tidak dapat ditampilkan.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla mengirim kode ke $email. Masukkan di sini.';
  }

  @override
  String get stepTotp => 'Masukkan kode dari aplikasi autentikator Anda.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla menganggap upaya masuk ini tidak biasa dan mengirim kode buka blokir ke $email. Masukkan di sini.';
  }

  @override
  String get stepCaptcha => 'Ketik teks pada gambar.';

  @override
  String stepEmailLink(String email) {
    return 'Buka tautan konfirmasi yang dikirim Mozilla ke $email. Proses akan berlanjut otomatis.';
  }

  @override
  String get signInFailed => 'Akun tidak ditambahkan.';

  @override
  String get signInCancelled => 'Masuk dibatalkan.';

  @override
  String get signInNoAccount => 'Tidak ada Firefox Account dengan email ini.';

  @override
  String get signInNoAccountHint =>
      'Periksa emailnya, atau buat Firefox Account gratis dengan email ini di situs Mozilla, konfirmasi dari kotak masuk Anda, lalu tambahkan di sini.';

  @override
  String get createAccountButton => 'Buat Firefox Account';

  @override
  String get signInWrongPassword => 'Kata sandi salah.';

  @override
  String get signInNoPassword =>
      'Akun ini tidak punya kata sandi: dibuat dengan masuk lewat Google atau Apple. Atur kata sandi, lalu masuk di sini dengannya.';

  @override
  String get setPasswordButton => 'Atur kata sandi';

  @override
  String get signInTooManyAttempts =>
      'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get signInUnblockRejected =>
      'Kode pembuka blokir tidak diterima. Gunakan kode dari email terbaru Mozilla.';

  @override
  String get signInWrongCode =>
      'Kode salah atau kedaluwarsa. Gunakan kode dari email terbaru Mozilla; kode lama tidak berlaku lagi saat kode baru dikirim.';

  @override
  String get signInWrongTotp =>
      'Kode salah. Masukkan kode yang ditampilkan aplikasi autentikator sekarang.';

  @override
  String get signInTooManyCodes =>
      'Terlalu banyak kode salah. Mulai masuk dari awal.';

  @override
  String get signInTimedOut => 'Proses masuk terlalu lama. Mulai lagi.';

  @override
  String get signInNetwork =>
      'Mozilla tidak dapat dihubungi. Periksa internet Anda lalu coba lagi.';

  @override
  String get coreConnecting => 'Menghubungkan ke core…';

  @override
  String get coreLost => 'Koneksi ke core terputus. Mencoba lagi…';

  @override
  String get cantReachCore => 'Tidak dapat terhubung ke core';

  @override
  String get startingCore => 'Memulai core…';

  @override
  String get retry => 'Coba lagi';

  @override
  String errNoCore(String path) {
    return 'Program core tidak ditemukan di samping aplikasi ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'Core berhenti: $detail';
  }

  @override
  String get errNotAnswering => 'Core tidak merespons.';

  @override
  String get errRefused =>
      'Core menolak aplikasi; mungkin core ini milik salinan aplikasi lain.';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get sectionGeneral => 'Umum';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Bawaan sistem';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get closeBehavior => 'Saat menutup jendela';

  @override
  String get closeAsk => 'Selalu tanya';

  @override
  String get closeTray => 'Minimalkan ke tray';

  @override
  String get closeQuit => 'Keluar dari aplikasi';

  @override
  String get sectionConnection => 'Koneksi';

  @override
  String get localProxy => 'Proxy lokal';

  @override
  String get systemProxy => 'Proxy sistem';

  @override
  String get sectionRouting => 'Perutean';

  @override
  String get routingDirect => 'Koneksi langsung untuk situs lokal';

  @override
  String get routingDirectHint =>
      'Situs dan IP dari negara yang dipilih tidak lewat VPN, jadi lebih cepat dibuka dan hemat kuota.';

  @override
  String get region => 'Negara';

  @override
  String get regionIr => 'Iran';

  @override
  String get regionCn => 'Tiongkok';

  @override
  String get regionRu => 'Rusia';

  @override
  String get regionAf => 'Afganistan';

  @override
  String get regionTr => 'Turki';

  @override
  String get regionId => 'Indonesia';

  @override
  String get regionBr => 'Brasil';

  @override
  String get regionNone => 'Tidak ada';

  @override
  String get saved => 'Tersimpan';

  @override
  String get dataFolder => 'Folder data';

  @override
  String get openFolder => 'Buka folder';

  @override
  String get unofficialNote =>
      'Klien tidak resmi. Tidak berafiliasi dengan Mozilla.';

  @override
  String get closeTitle => 'Tutup jendela?';

  @override
  String get closeBody =>
      'Saat di tray, VPN tetap terhubung. Keluar akan memutus VPN.';

  @override
  String get rememberChoice => 'Ingat pilihan saya';

  @override
  String get minimizeToTray => 'Minimalkan ke tray';

  @override
  String get quit => 'Keluar';

  @override
  String get trayOpen => 'Buka';

  @override
  String get trayQuit => 'Keluar';

  @override
  String get trayProxyOnly => 'Hanya layanan proxy';

  @override
  String get traySetSystemProxy => 'Atur proxy sistem';

  @override
  String errPortInUse(String port) {
    return 'Port $port dipakai program lain, sehingga aplikasi tidak dapat terhubung ke core.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'Port $port dipakai program lain, sehingga proxy tidak dapat dimulai.';
  }

  @override
  String get changePort => 'Ganti port';

  @override
  String get portDialogTitle => 'Pilih port';

  @override
  String portDialogBody(String port) {
    return 'Port $port sudah dipakai. Berikut port yang masih kosong; Anda juga bisa mengetik port lain.';
  }

  @override
  String get portChangeBody =>
      'Aplikasi terhubung ke port ini. Pilih antara 1024 dan 65535.';

  @override
  String get portLabel => 'Port';

  @override
  String get portInvalid => 'Masukkan port dari 1024 hingga 65535';

  @override
  String get portBusy => 'Port ini juga sedang dipakai';

  @override
  String get portInUse => 'Program lain memakai port ini';

  @override
  String get save => 'Simpan';

  @override
  String get proxyPort => 'Port proxy';

  @override
  String get appPort => 'Port aplikasi';

  @override
  String get welcomeTitle => 'Selamat datang';

  @override
  String get welcomeBody =>
      'Pilih bahasa dan negara Anda. Situs dari negara Anda dibuka langsung tanpa VPN, jadi lebih cepat dan hemat kuota.';

  @override
  String get start => 'Mulai';

  @override
  String routingSuggestTitle(String country) {
    return 'Buka situs $country secara langsung?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Situs dan IP $country akan dibuka langsung tanpa VPN. Anda bisa mengubahnya di Perutean.';
  }

  @override
  String get yes => 'Ya';

  @override
  String get notNow => 'Nanti saja';

  @override
  String get navServers => 'Server';

  @override
  String get navLogs => 'Log';

  @override
  String get realDelay => 'Ping asli';

  @override
  String get statElapsed => 'Durasi';

  @override
  String get statDown => 'Unduh';

  @override
  String get statUp => 'Unggah';

  @override
  String noticePort(String port) {
    return 'Proxy Mozilla tidak bisa terhubung ke port $port. Hanya port 80, 443, 8080, dan 8443 yang bisa lewat VPN.';
  }

  @override
  String get noticeCommand => 'Jenis koneksi ini tidak didukung oleh VPN.';

  @override
  String noticeTimes(int count, String time) {
    return '$count kali, terakhir $time';
  }

  @override
  String get dismiss => 'Tutup';

  @override
  String get modeRecommended => 'Disarankan';

  @override
  String get modeFastest => 'Tercepat';

  @override
  String get modeRecommendedHint => 'Mozilla memilihkan lokasi untuk Anda.';

  @override
  String get modeFastestHint =>
      'Lokasi dengan ping terendah, dipilih di setiap koneksi.';

  @override
  String get testDelay => 'Uji ping asli';

  @override
  String get testingDelay => 'Mengukur…';

  @override
  String get search => 'Cari';

  @override
  String get noAnswer => 'Tidak merespons';

  @override
  String testedAgo(String ago) {
    return 'Diuji $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered dari $total merespons';
  }

  @override
  String get noServers =>
      'Belum ada server. Server akan muncul setelah core terhubung ke Mozilla.';

  @override
  String get levelAll => 'Semua';

  @override
  String get filter => 'Filter';

  @override
  String get follow => 'Gulir otomatis';

  @override
  String get clear => 'Bersihkan';

  @override
  String get copyAll => 'Salin';

  @override
  String get logsCopied => 'Log disalin';

  @override
  String get noLogs => 'Belum ada baris log.';

  @override
  String get sectionAccounts => 'Ganti akun otomatis';

  @override
  String get switchThreshold => 'Ganti akun pada';

  @override
  String get switchThresholdHint =>
      'Pindah ke akun berikutnya saat kuota sudah terpakai sebanyak ini.';

  @override
  String get signInMethod => 'Metode masuk';

  @override
  String get signInMethodBrowser => 'Masuk lewat peramban';

  @override
  String get signInMethodApi => 'Masuk langsung';

  @override
  String get browserSignInBroken => 'Halaman masuk tidak dapat dibuka.';

  @override
  String get browserSignInBlocked =>
      'Mozilla tidak menyelesaikan langkah terakhir untuk menambahkan akun (HTTP 406).';

  @override
  String get browserSignInFallback => 'Masuk dengan email dan kata sandi';

  @override
  String get backupExport => 'Simpan cadangan';

  @override
  String get backupImport => 'Impor cadangan';

  @override
  String backupSaved(String name) {
    return 'Tersimpan: $name';
  }

  @override
  String get backupImportTitle => 'Tambahkan akun-akun ini?';

  @override
  String get backupAccountExists =>
      'Sudah ada; info masuknya diambil dari file';

  @override
  String get backupImportAction => 'Tambah';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count akun ditambahkan',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'Server DNS';

  @override
  String get dnsSystem => 'Sistem';

  @override
  String get dnsAuto => 'Otomatis (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Kustom';

  @override
  String get dnsCustomHint =>
      'Satu per baris: https://…/dns-query, tls://…, atau alamat IP.';

  @override
  String get dnsFallback => 'Gunakan DNS sistem sebagai cadangan';

  @override
  String get testDns => 'Uji DNS';

  @override
  String get transport => 'Protokol';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'Versi IP';

  @override
  String get ipVersionAuto => 'Otomatis (IPv4 dulu, lalu IPv6)';

  @override
  String get ipVersionDual => 'Keduanya sekaligus (dual-stack)';

  @override
  String get ipVersionV6First => 'IPv6 dulu, lalu IPv4';

  @override
  String get ipVersionV4 => 'Hanya IPv4';

  @override
  String get ipVersionV6 => 'Hanya IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'Ukuran paket antarmuka VPN, 1280 hingga 9000. Kosong: otomatis.';

  @override
  String get tunMtuInvalid => 'Angka dari 1280 hingga 9000, atau kosong';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Langsung';

  @override
  String get directRulesHint =>
      'Situs dan alamat dalam daftar ini dibuka tanpa VPN, langsung lewat internet Anda sendiri. Aturan negara yang dipilih sudah ada di sini: tambah, ubah, atau hapus baris. Memilih negara lain menggantinya dengan aturan negara itu.';

  @override
  String get restoreRegionRules => 'Pulihkan aturan negara';

  @override
  String get blockRules => 'Blokir';

  @override
  String get blockRulesHint =>
      'Situs dan alamat dalam daftar ini tidak bisa dibuka sama sekali, baik langsung maupun lewat VPN: untuk iklan atau situs yang tidak pernah ingin Anda buka.';

  @override
  String get rulesTitle => 'Aturan';

  @override
  String get ruleSyntaxTitle => 'Cara menulis aturan';

  @override
  String get resolveDomains => 'Terapkan aturan IP ke domain';

  @override
  String get routingLists => 'File geo';

  @override
  String get listSource => 'Sumber daftar';

  @override
  String get listSourceCustom => 'Diatur manual';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Diperbarui $ago';
  }

  @override
  String get updateLists => 'Perbarui file geo';

  @override
  String get listsUpdated => 'File geo telah diperbarui.';

  @override
  String get testDestination => 'Uji tujuan';

  @override
  String get destinationHint => 'Domain, alamat IP, atau URL';

  @override
  String get check => 'Periksa';

  @override
  String get routeDirect => 'Langsung';

  @override
  String get routeProxy => 'Melalui VPN';

  @override
  String get routeBlock => 'Diblokir';

  @override
  String ruleMatched(String rule) {
    return 'Aturan: $rule';
  }

  @override
  String get portRefusedNote =>
      'Proxy Mozilla tidak bisa terhubung ke port ini.';

  @override
  String get sectionAdvanced => 'Lanjutan';

  @override
  String get tlsFragment => 'Fragmentasi TLS';

  @override
  String get tlsFragmentOff => 'Nonaktif';

  @override
  String get tlsFragmentFirstByte => 'Byte pertama';

  @override
  String get tlsFragmentSni => 'Nama server (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Memisahkan header TLS pada byte pertama (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Membagi nama server (SNI) ke beberapa paket TCP';

  @override
  String get tlsFragmentRecord => 'Rekaman TLS';

  @override
  String get tlsFragmentRecordHint =>
      'Membagi nama server (SNI) ke dua rekaman TLS';

  @override
  String get tlsFragmentOffHint => 'Koneksi TLS biasa';

  @override
  String get sectionBypass => 'Jika Mozilla diblokir';

  @override
  String get sharedRelay => 'Relai bersama';

  @override
  String get sharedRelayHint =>
      'Gunakan relai bersama aplikasi jika Mozilla memblokir wilayah Anda. Relai pribadi yang aktif diprioritaskan.';

  @override
  String get personalRelay => 'Relai pribadi';

  @override
  String get apiRelay => 'Server relay';

  @override
  String get apiRelayUse => 'Gunakan server relay';

  @override
  String get apiRelayHint =>
      'Cloudflare Worker milik Anda, atau relay.php di hosting Anda sendiri.\nHanya dipakai saat Mozilla tidak menjawab langsung: proses masuk, akun, dan daftar server melewatinya, bukan lalu lintas VPN.';

  @override
  String get upstreamProxy => 'Proxy upstream';

  @override
  String get upstreamProxyOn => 'Proxy upstream aktif';

  @override
  String get upstreamProxyAddress => 'Alamat proxy SOCKS5';

  @override
  String get upstreamProxyPort => 'Port';

  @override
  String get upstreamProxyHint =>
      'Koneksi ke Mozilla melewati proxy ini, untuk jaringan yang memblokir atau memperlambat Mozilla.\nJika proxy berjalan di perangkat ini, keluarkan dari VPN.';

  @override
  String get upstreamProxyInvalid =>
      'Masukkan alamat proxy, misalnya 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Masukkan port dari 1 sampai 65535.';

  @override
  String get upstreamProxyOwn =>
      'Itu proxy milik aplikasi ini. Masukkan yang lain.';

  @override
  String get apiRelayInvalid => 'Harus berupa alamat https://.';

  @override
  String get listenAddress => 'Akses proxy';

  @override
  String get listenLocal => '127.0.0.1 · hanya perangkat ini';

  @override
  String get listenAll => '0.0.0.0 · semua jaringan (LAN)';

  @override
  String get proxyUsername => 'Nama pengguna proxy';

  @override
  String get proxyPassword => 'Kata sandi proxy';

  @override
  String get proxyLoginHint =>
      'Aplikasi harus login dengan data ini. Kosongkan keduanya jika tidak perlu login.';

  @override
  String get loginBothOrNone => 'Isi keduanya, atau biarkan keduanya kosong.';

  @override
  String get proxyLogin => 'Login proxy';

  @override
  String get idleSleep => 'Tidur jika tidak aktif selama';

  @override
  String get sleepNever => 'Tidak pernah';

  @override
  String sleepMinutes(int count) {
    return '$count menit';
  }

  @override
  String get sleepHour => '1 jam';

  @override
  String get showPublicIp => 'Tampilkan IP publik';

  @override
  String get hapticFeedback => 'Getar saat koneksi berubah';

  @override
  String get keepScreenOn => 'Biarkan layar tetap menyala saat terhubung';

  @override
  String get showTraffic => 'Tampilkan lalu lintas langsung di halaman utama';

  @override
  String get speedInNotification => 'Tampilkan kecepatan di notifikasi';

  @override
  String get liveTraffic => 'Lalu lintas langsung';

  @override
  String get totalTraffic => 'Total lalu lintas';

  @override
  String get verboseLogs => 'Log terperinci';

  @override
  String get webDashboard => 'Dasbor web';

  @override
  String get webDashboardOpen => 'Buka';

  @override
  String get webDashboardHint => 'Pengaturan lanjutan dan alat lainnya';

  @override
  String numberInvalid(int min, int max) {
    return 'Masukkan angka dari $min hingga $max';
  }

  @override
  String get notifySwitchedTitle => 'Akun diganti';

  @override
  String notifySwitchedBody(String name) {
    return 'Sekarang menggunakan $name.';
  }

  @override
  String get notifySignInTitle => 'Perlu masuk';

  @override
  String get notifySignInBody =>
      'Sebuah akun harus masuk lagi di halaman Akun.';

  @override
  String get navAbout => 'Tentang';

  @override
  String get appVersionLabel => 'Versi aplikasi';

  @override
  String get coreVersionLabel => 'Versi core';

  @override
  String get checkUpdates => 'Periksa pembaruan';

  @override
  String get checkingUpdates => 'Memeriksa…';

  @override
  String get upToDate => 'Anda memiliki versi terbaru.';

  @override
  String updateAvailable(String version) {
    return 'Versi $version tersedia.';
  }

  @override
  String updateRequired(String version) {
    return 'Perbarui ke versi $version. Pembaruan ini diperlukan.';
  }

  @override
  String get download => 'Unduh';

  @override
  String updateCheckFailed(String error) {
    return 'Tidak dapat memeriksa pembaruan: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'Tidak dapat menghubungi GitHub. Periksa koneksi internet Anda lalu coba lagi.';

  @override
  String get updateNow => 'Perbarui';

  @override
  String updateDownloading(String version) {
    return 'Mengunduh versi $version…';
  }

  @override
  String updateReady(String version) {
    return 'Versi $version siap dipasang.';
  }

  @override
  String updateInstalling(String version) {
    return 'Memasang versi $version. Aplikasi akan tertutup lalu terbuka lagi.';
  }

  @override
  String updateFailed(String version) {
    return 'Gagal memperbarui ke versi $version.';
  }

  @override
  String updateDone(String version) {
    return 'Diperbarui ke versi $version.';
  }

  @override
  String updateRolledBack(String version) {
    return 'Pembaruan ke versi $version tidak selesai, jadi aplikasi kembali ke versi sebelumnya.';
  }

  @override
  String get repoNotSet => 'Repositori GitHub belum diatur.';

  @override
  String get sourceCode => 'Kode sumber';

  @override
  String get tapToConnect => 'Klik untuk terhubung';

  @override
  String get tapToDisconnect => 'Klik untuk memutus koneksi';

  @override
  String get startOnBoot => 'Mulai saat sistem menyala';

  @override
  String get connectOnStartup => 'Sambungkan saat sistem menyala';

  @override
  String get proxyServiceActive => 'Layanan proxy aktif';

  @override
  String get navHome => 'Beranda';

  @override
  String get groupApp => 'Aplikasi';

  @override
  String get groupNetwork => 'Jaringan';

  @override
  String get stateOff => 'Tidak terhubung';

  @override
  String get tapToConnectPhone => 'Ketuk untuk terhubung';

  @override
  String get tapToDisconnectPhone => 'Ketuk untuk memutus koneksi';

  @override
  String get tapToConnectTv => 'Tekan OK untuk terhubung';

  @override
  String get tapToDisconnectTv => 'Tekan OK untuk memutus koneksi';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Lokasi yang disarankan';

  @override
  String dataLeftOf(String limit) {
    return 'dari $limit';
  }

  @override
  String get homeLocation => 'Lokasi';

  @override
  String get connectedTo => 'Terhubung ke';

  @override
  String get vpnNotAllowed =>
      'VPN memerlukan izin Anda. Ketuk tombol lagi dan izinkan.';

  @override
  String get dataUsedTitle => 'Data terpakai';

  @override
  String get bypassApps => 'Proxy per aplikasi';

  @override
  String get connectRetrying => 'Tidak dapat terhubung. Periksa internet Anda.';

  @override
  String get failUnreachable =>
      'Tidak dapat menjangkau server Mozilla. Coba koneksi internet lain.';

  @override
  String get failUpstreamProxy =>
      'Tidak dapat menjangkau Mozilla melalui proxy upstream. Pastikan proxy berjalan.';

  @override
  String get failInsideVpn =>
      'Internet ini sudah melewati VPN. Matikan VPN tersebut.';

  @override
  String get failRefused =>
      'Server Mozilla menolak koneksi. Coba lagi dalam beberapa menit.';

  @override
  String get failLocationRefused =>
      'Negara ini tidak terbuka untuk akun Anda. Pilih negara lain.';

  @override
  String get useRecommendedLocation => 'Gunakan lokasi yang disarankan';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Anda memilih $chosen, tetapi IP Anda berada di $exit.';
  }

  @override
  String get failSignIn =>
      'Sesi masuk akun ini sudah kedaluwarsa. Masuk lagi di halaman Akun.';

  @override
  String get failQuota => 'Kuota bulan ini habis. Tambahkan akun lain.';

  @override
  String get failNotEntitled =>
      'Mozilla tidak mengizinkan akun ini memakai VPN. Tambahkan akun lain.';

  @override
  String get failRegion =>
      'Mozilla tidak menyediakan layanannya di negara Anda.';

  @override
  String get failServer =>
      'Layanan Mozilla sedang bermasalah sementara. Aplikasi akan mencoba lagi sendiri.';

  @override
  String get failNoAccount => 'Tidak ada akun yang siap. Buka halaman Akun.';

  @override
  String get failTestSite =>
      'Terhubung ke server, tetapi situs tidak terbuka. Coba negara lain.';

  @override
  String get failOther => 'Tidak dapat terhubung. Coba lagi.';

  @override
  String get failNoInternet =>
      'Tidak ada internet. Periksa Wi-Fi atau data seluler.';

  @override
  String get waitingForNetwork => 'Menunggu koneksi internet…';

  @override
  String proxyStartFailed(String port) {
    return 'Proxy tidak dapat dimulai di port $port. Pilih port lain.';
  }

  @override
  String get connectionSettings => 'Pengaturan koneksi';

  @override
  String get appModeExclude => 'Kecualikan aplikasi terpilih';

  @override
  String get appModeInclude => 'Hanya aplikasi terpilih';

  @override
  String get appModeExcludeHint =>
      'Aplikasi terpilih terhubung langsung, tidak lewat VPN; misalnya aplikasi bank yang menolak IP luar negeri.';

  @override
  String get appModeIncludeHint =>
      'Hanya aplikasi terpilih yang lewat VPN; aplikasi lain terhubung langsung.';

  @override
  String fromRegionList(String region) {
    return 'Disarankan: ada di daftar $region';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Mode koneksi';

  @override
  String get modeProxyHint =>
      'Hanya aplikasi yang diatur memakai proxy yang lewat proxy.';

  @override
  String get modeSystemProxyHint =>
      'Windows dan sebagian besar aplikasi lewat proxy.';

  @override
  String get modeSystemProxyHintOther =>
      'Browser dan sebagian besar aplikasi lewat proxy.';

  @override
  String get suggestedApps => 'Aplikasi yang disarankan';

  @override
  String get showSystemApps => 'Tampilkan aplikasi sistem';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aplikasi yang disarankan dipilih',
      one: '1 aplikasi yang disarankan dipilih',
      zero: 'Aplikasi yang disarankan sudah dipilih',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Otomatis';

  @override
  String get locationsSection => 'Lokasi';

  @override
  String get dnsSummaryOk => 'DNS terenkripsi berfungsi';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nama tidak dapat di-resolve',
      one: '1 nama tidak dapat di-resolve',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'melalui $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'DNS jaringan Anda menjawab $count nama dengan alamat pemblokiran. Aplikasi ini tidak memakai jawaban tersebut.',
      one: 'DNS jaringan Anda menjawab 1 nama dengan alamat pemblokiran. Aplikasi ini tidak memakai jawaban tersebut.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Jawaban:';

  @override
  String get dnsNetworkAnswer => 'DNS jaringan:';

  @override
  String get dnsFiltered => 'diblokir';

  @override
  String get rulesSyntaxTitle => 'Satu aturan per baris';

  @override
  String get ruleDomain => 'Situs dan subdomainnya';

  @override
  String get ruleFull => 'Persis nama ini';

  @override
  String get ruleKeyword => 'Nama yang mengandung kata ini';

  @override
  String get ruleGeosite => 'Situs dari sebuah tag di file geo';

  @override
  String get ruleGeoip => 'Alamat dari sebuah negara di file geo';

  @override
  String get ruleIp => 'Alamat atau jaringan';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Hanya proxy';

  @override
  String get noNetwork =>
      'Tidak ada koneksi internet. Nyalakan Wi-Fi atau data seluler.';

  @override
  String get blockAds => 'Blokir iklan';

  @override
  String systemProxyTakenBy(String address) {
    return 'Program lain mengubah proxy sistem ke $address, jadi lalu lintas tidak melewati VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Program lain mematikan proxy sistem, jadi lalu lintas tidak melewati VPN.';

  @override
  String get setSystemProxyAgain => 'Atur lagi';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Semua lalu lintas $os lewat VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting => 'Menunggu izin untuk memasang layanan TUN…';

  @override
  String get tunInstallCancelled =>
      'Mode TUN memerlukan izin administrator sekali. Izin tidak diberikan, jadi mode tidak berubah.';

  @override
  String tunInstallFailed(String error) {
    return 'Tidak dapat memasang layanan TUN: $error';
  }

  @override
  String get tunStarting => 'Menyalakan mode TUN…';

  @override
  String get tunFailed => 'Mode TUN tidak dapat menyala. Mencoba lagi…';

  @override
  String get tunLost => 'Mode TUN berhenti tiba-tiba. Mencoba lagi…';

  @override
  String get tunNotRunning => 'Layanan TUN tidak berjalan. Mencoba lagi…';

  @override
  String get tunMissing => 'Layanan TUN belum dipasang.';

  @override
  String get tunOutdated =>
      'Layanan TUN lebih lama dari aplikasi ini. Pasang lagi untuk memakai mode TUN.';

  @override
  String get tunAppOutdated =>
      'Layanan TUN lebih baru dari aplikasi ini. Perbarui aplikasi untuk memakai mode TUN.';

  @override
  String get tunBusy => 'Salinan lain Homa VPN sedang memakai mode TUN.';

  @override
  String get tunNoDriver =>
      'Driver TUN sistem tidak tersedia. Mulai ulang komputer lalu coba lagi.';

  @override
  String get tunInstall => 'Pasang';

  @override
  String get tunInstallAgain => 'Pasang lagi';

  @override
  String get trayTunMode => 'Mode TUN (semua aplikasi)';

  @override
  String get removeTunService => 'Hapus layanan TUN';

  @override
  String get removeTunServiceHint =>
      'Menghapus layanan sistem yang dipakai mode TUN. Memilih TUN lagi akan memasangnya kembali.';

  @override
  String get tunServiceRemoved => 'Layanan TUN telah dihapus.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN ingin memasang layanan untuk mode TUN.';

  @override
  String get tunRemovePrompt => 'Homa VPN ingin menghapus layanan mode TUN.';

  @override
  String tunRemoveFailed(String error) {
    return 'Tidak dapat menghapus layanan TUN: $error';
  }

  @override
  String get sectionTun => 'Pengaturan TUN';

  @override
  String get tunPrograms => 'Program yang melewati VPN';

  @override
  String get tunProgramsHint =>
      'Terhubung langsung, tidak lewat Mozilla. Hanya untuk program yang berfungsi tanpa VPN.';

  @override
  String get tunProgramsEmpty => 'Belum ada program.';

  @override
  String get addProgram => 'Tambah program';

  @override
  String get programFiles => 'Program';

  @override
  String get tunProgramAll => 'Semua lalu lintas';

  @override
  String get tunProgramAllHint => 'Seluruh program terhubung langsung.';

  @override
  String get tunProgramUdp => 'Hanya UDP';

  @override
  String get tunProgramUdpHint =>
      'Hanya UDP-nya yang terhubung langsung; sisanya lewat VPN.';

  @override
  String get udpNoticeSetting => 'Pemberitahuan UDP yang diblokir';

  @override
  String udpNoticeBody(String program) {
    return 'Lalu lintas UDP $program tidak lewat VPN.';
  }

  @override
  String get dontShowAgain => 'Jangan tampilkan lagi';

  @override
  String get addRunningProgram => 'Dari program yang berjalan';

  @override
  String get addProgramFile => 'Pilih file…';

  @override
  String get addProgramName => 'Ketik nama…';

  @override
  String get programNameHint =>
      'Nama file program, misalnya steam.exe; * berarti teks apa saja (steam* adalah semua program Steam).';

  @override
  String get runningProgramsEmpty => 'Tidak ada program lain yang berjalan.';

  @override
  String get tabLog => 'Log';

  @override
  String get tabConnections => 'Koneksi';

  @override
  String get connectionsEmpty => 'Belum ada koneksi.';

  @override
  String connectionsOpen(int count) {
    return '$count terbuka';
  }

  @override
  String get connTime => 'Waktu';

  @override
  String get connRoute => 'Aturan';

  @override
  String get connDestination => 'Tujuan';

  @override
  String get connInbound => 'Masuk';

  @override
  String get connProtocol => 'Protokol';

  @override
  String get connColumns => 'Kolom';

  @override
  String get connTraffic => 'Lalu lintas';

  @override
  String get connDuration => 'Durasi';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Langsung';

  @override
  String get connRouteBlocked => 'Diblokir';

  @override
  String get connRoutePort => 'Port ditolak';

  @override
  String get connRouteFailed => 'Gagal';

  @override
  String get testRelay => 'Uji kesehatan relai';

  @override
  String get relayTestTitle => 'Uji kesehatan relai';

  @override
  String get relayTestHint =>
      'Hanya memeriksa relai. Tidak mengirim permintaan Mozilla atau informasi akun.';

  @override
  String get relayTestPassed => 'Relai siap';

  @override
  String get relayTestFailed => 'Kesehatan relai tidak dapat dipastikan';

  @override
  String get relayTestCopy => 'Salin laporan';

  @override
  String get relayTestInterrupted =>
      'Pengujian berakhir sebelum hasil lengkap diterima.';

  @override
  String get searchLocations => 'Cari lokasi';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lokasi',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Pembaruan otomatis';

  @override
  String get autoInstallApkHint =>
      'Versi baru diunduh sendiri; penginstal bertanya sebelum memasang.';

  @override
  String get installNow => 'Pasang';

  @override
  String get updateAllowInstall =>
      'Untuk memasang pembaruan, izinkan aplikasi ini memasang aplikasi.';

  @override
  String get allowInstall => 'Izinkan';

  @override
  String get noResults => 'Tidak ada lokasi yang cocok dengan pencarian.';

  @override
  String get accentColor => 'Warna aksen';

  @override
  String get accentMono => 'Monokrom (bawaan)';

  @override
  String get accentCustom => 'Warna khusus';

  @override
  String get accentEmber => 'Bara';

  @override
  String get accentGold => 'Emas';

  @override
  String get accentEmerald => 'Zamrud';

  @override
  String get accentSapphire => 'Safir';

  @override
  String get accentAmethyst => 'Ametis';

  @override
  String get accentRose => 'Mawar';

  @override
  String get autoReconnect => 'Sambung ulang otomatis';

  @override
  String get autoReconnectHint =>
      'Menyambung kembali dengan sendirinya saat koneksi terputus tanpa perintah Anda.';

  @override
  String get androidOnlyHint => 'Hanya di ponsel.';

  @override
  String get idleDisconnect => 'Putuskan saat senggang';

  @override
  String get idleDisconnectHint =>
      'Mengakhiri sesi ketika tidak ada lalu lintas untuk sementara.';

  @override
  String get idleTimeout => 'Tenggang senggang';

  @override
  String get minutes5 => '5 menit';

  @override
  String get minutes10 => '10 menit';

  @override
  String get minutes15 => '15 menit';

  @override
  String get minutes30 => '30 menit';

  @override
  String get minutes60 => '1 jam';

  @override
  String get dataLimit => 'Batas data sesi';

  @override
  String get dataLimitHint =>
      'Mengakhiri sesi ketika lalu lintasnya mencapai batas.';

  @override
  String get dataLimitAmount => 'Batas';

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
    return 'Tidak ada lalu lintas selama $minutes menit, koneksi diputus.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'Sesi mencapai batas datanya $mb MB, koneksi diputus.';
  }

  @override
  String get protection => 'Perlindungan';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Jika VPN terputus, lalu lintas ditahan — tanpa kebocoran — sampai tersambung ulang.';

  @override
  String get alwaysOnVpn => 'VPN selalu aktif';

  @override
  String get alwaysOnVpnHint =>
      'Pengaman bawaan Android: tanpa VPN tidak ada koneksi lewat.';

  @override
  String get floatingIsland => 'Pulau mengambang';

  @override
  String get floatingIslandHint =>
      'Menampilkan status koneksi di atas aplikasi lain saat Anda keluar dari aplikasi.';

  @override
  String whatsNewTitle(String version) {
    return 'Yang baru di versi $version';
  }

  @override
  String get whatsNewContinue => 'Mengerti';

  @override
  String get whatsNewMenu => 'Yang baru';

  @override
  String get whatsNewView => 'Lihat lagi';

  @override
  String get updateServers => 'Perbarui server';

  @override
  String get updatingServers => 'Memperbarui…';

  @override
  String serversUpdated(int count) {
    return '$count lokasi dari daftar resmi Mozilla';
  }

  @override
  String get serversUpdateFailed =>
      'Daftar server tidak dapat diperbarui; daftar sebelumnya dipertahankan.';

  @override
  String get smartPickTitle => 'Tercepat saat ini';

  @override
  String get smartPickUse => 'Pakai';

  @override
  String get connectAtBoot => 'Sambungkan setelah telepon menyala';

  @override
  String get connectAtBootHint =>
      'Menyambung sendiri saat telepon dinyalakan, jika izin VPN sudah diberikan.';

  @override
  String get gamingProfile => 'Profil gaming';

  @override
  String get gamingProfileHint =>
      'Menampilkan jeda dan kualitas koneksi secara langsung; berpasangan dengan server terukur tercepat.';

  @override
  String get diagnosticsRun => 'Jalankan diagnostik';

  @override
  String get diagnosticsHint =>
      'Koneksi, DNS, dan terowongan, diperiksa satu ketukan';

  @override
  String get diagnosticsTunnel => 'Terowongan';

  @override
  String get diagnosticsTunnelUp => 'Aktif dan membawa lalu lintas';

  @override
  String get diagnosticsTunnelDown => 'Mati';

  @override
  String get diagnosticsExit => 'Negara keluar';

  @override
  String get diagnosticsMismatch => 'Keluaran berbeda dari pilihan';

  @override
  String get diagnosticsConnection => 'Uji koneksi';

  @override
  String get diagnosticsPassed => 'Lulus';

  @override
  String get diagnosticsFailed => 'Gagal';

  @override
  String get diagnosticsDnsFiltered => 'Jawaban diblokir atau disaring';

  @override
  String get diagnosticsDnsOk => 'Menjawab';

  @override
  String get diagnosticsPrivacy =>
      'Tidak ada yang disimpan di sini; hasil tinggal di jendela ini dan di log milik inti.';

  @override
  String get diagnosticsAgain => 'Jalankan lagi';

  @override
  String get whatsNewAdded => 'Baru';

  @override
  String get whatsNewImproved => 'Ditingkatkan';

  @override
  String get whatsNewFixed => 'Diperbaiki';

  @override
  String get wnWheelImproved =>
      'Roda negara digambar ulang: bendera terpilih tampil lebih besar dalam bingkai kaca dengan kilau halus dan halo cahaya lembut di belakangnya, bendera lain tampak lebih kecil dengan kedalaman, dan nama di bawahnya datang dengan geseran.';

  @override
  String get wnLiveImproved =>
      'Saat terhubung, notifikasi meminta Android 16 untuk mempromosikannya sebagai Live Update, seperti implementasi referensi; durasi terus menghitung, kecepatan tetap berjalan.';

  @override
  String get wnL10nFixed =>
      'Halaman ini kini berbicara dalam bahasa aplikasi — semua lima belas bahasanya, bukan hanya bahasa Inggris.';

  @override
  String get wnMarkFixed =>
      'Lambang Mozilla tampil bersih di petaknya, membulat seperti bendera.';

  @override
  String get designTitle => 'Desain halaman utama';

  @override
  String get designHint => 'Bagaimana halaman utama disusun';

  @override
  String get designWheel => 'Roda';

  @override
  String get designWheelDesc => 'Bendera pada roda kacanya, tombol di bawah';

  @override
  String get designBento => 'Ubin';

  @override
  String get designBentoDesc => 'Papan ubin membulat: sambungan, angka, lokasi';

  @override
  String get designPixel => 'Ringkas';

  @override
  String get designPixelDesc => 'Satu kartu tenang: lokasi, tombol, angka';

  @override
  String get notifFlag => 'Bendera negara di notifikasi';

  @override
  String get notifFlagHint => 'Bendera negaranya sendiri di samping namanya';

  @override
  String get wnDesignAdded =>
      'Pengaturan desain halaman utama: roda, ubin, atau kartu ringkas';

  @override
  String get wnMapAdded =>
      'Peta dunia vektor sungguhan di belakang halaman utama, negara pilihan menyala';

  @override
  String get wnWheelAdded =>
      'Roda bendera digambar ulang: kaca lebih dalam, gerak lebih halus';

  @override
  String get wnFlagNotifAdded =>
      'Notifikasi dapat menampilkan bendera SVG negara, dan bisa dimatikan';

  @override
  String get wnColorRemoved =>
      'Halaman warna kustom dihapus; daftar aksen tetap menyimpan kode HEX';

  @override
  String get whatsNewRemoved => 'Dihapus';

  @override
  String get wnCrashFixed =>
      'Aplikasi tidak lagi berhenti sendiri di ponsel Android 16: notifikasi meminta sesuatu yang belum dimiliki ponsel.';

  @override
  String get wnFlagArtFixed =>
      'Aplikasi tidak lagi mengeluarkan dirinya saat dibuka: gambar bendera notifikasi menjawab dengan nilai yang ditolak sistem.';

  @override
  String get statSession => 'Sesi';

  @override
  String get copiedToClipboard => 'Disalin ke papan klip';

  @override
  String get wnTotalsAdded =>
      'Beranda menampilkan total yang dipindahkan sesi, dan satu ketukan menyalin IP publik.';

  @override
  String get wnPolishImproved =>
      'Roda bendera dan halaman server lebih rapi; teks ringkas, dan terowong Android memuat lalu lintas dengan kecepatan lebih tinggi.';

  @override
  String get smartNetwork => 'Koneksi pintar';

  @override
  String get smartNetworkHint =>
      'MTU, protokol, dan versi IP menyesuaikan jaringan ini, demi kecepatan.';

  @override
  String get valueSmart => 'Pintar';

  @override
  String get mtuAutoValue => 'Otomatis — mengikuti jaringan';

  @override
  String get wnSmartAdded =>
      'Koneksi pintar: MTU, protokol, dan versi IP mengikuti jaringan, dipilih dari jawaban nyata demi kecepatan.';

  @override
  String get wnToastAdded =>
      'Konfirmasi kini datang sebagai catatan lembut bergaya iOS, dengan tanda yang menggambar dirinya sendiri.';

  @override
  String get wnFlagsImproved =>
      'Roda bendera tampil bersih: tidak ada bendera terpotong di tepi layar, bendera tampil utuh, dan pilihan mendarat dengan pegas lembut.';

  @override
  String get wnMapImproved =>
      'Peta dunia digambar lebih besar dan jelas: tanpa benua yang sesak, garis pantai halus, dan halo bercahaya di titik jangkar.';

  @override
  String get smartWaiting => 'Mengukur…';

  @override
  String get smartFamilyRace => 'Keduanya balapan pada koneksi pertama';

  @override
  String get dnsManual => 'DNS manual';

  @override
  String get dnsManualHint =>
      'Satu alamat per baris: IP biasa, https:// (DNS over HTTPS), atau tls://host (DNS over TLS). Jawaban pertama menang.';

  @override
  String get dnsManualInvalid =>
      'Satu baris bukan alamat yang bisa dipakai core: IP biasa, https://…, atau tls://host.';

  @override
  String get killSwitchGuarded =>
      'Terjaga: tidak ada yang keluar dari ponsel selama terowongan mati.';

  @override
  String get accountsUsageTitle => 'Bulan ini';

  @override
  String get accountsCountLabel => 'akun';

  @override
  String get accountsUsageAverage => 'rata-rata porsi terpakai dari tiap akun';

  @override
  String get wnDesignsAdded =>
      'Desain aplikasi: seluruh aplikasi bisa memakai Neumorfisme Lembut atau Kaca Aurora — setiap halaman, setiap kartu — di Setelan → Umum.';

  @override
  String get wnWheelFixed =>
      'Setengah bendera di roda hilang: rak di bawah bendera terpilih adalah genangan cahaya, bukan bendera kedua, dan tak ada bendera terpotong di tepi layar.';

  @override
  String get wnMapReal =>
      'Peta dunia digambar ulang dari perbatasan resmi negara — setiap pesisir, pulau, dan enklaf, setia dan berproporsi benar.';

  @override
  String get wnGlobeAdded =>
      'Dunia kini berbentuk globe: bola perak berputar menghadap negara yang dipilih, pin bercahaya dan kart mengapung menandainya, serta jalur koneksi merambah hub.';

  @override
  String get wnWheelGlowImproved =>
      'Bendera terpilih tampil lebih besar dalam bingkai kaca dengan halo biru khasnya, tetangganya terlihat jelas lebih kecil, dan penanda di bawah roda menunjukkan posisi Anda.';

  @override
  String get wnDesignsRemoved =>
      'Pemilih Desain Aplikasi dihapus: aplikasi kembali memakai tampilan satu warnanya — warna aksen dan tema Anda tetap seperti semula.';

  @override
  String get wnDnsAdded =>
      'DNS manual: IP biasa, DNS over HTTPS, dan DNS over TLS — jenis tiap baris ditunjukkan dan diperiksa saat mengetik.';

  @override
  String get wnSmartImproved =>
      'Koneksi pintar kini menunjukkan jawaban jaringan: transport yang dipilih dan versi IP yang dipertahankan, langsung.';

  @override
  String get wnProtectionImproved =>
      'Kill switch memberi tahu saat penjaganya berdiri, dan halaman aplikasi menunjukkan berapa aplikasi yang kamu pilih.';

  @override
  String get wnWelcomeImproved =>
      'Halaman sambutan terbuka dengan perisai bernapas di atas aurora yang mengalir, dan halaman akun meringkas sebulan sekali lirik.';

  @override
  String bypassAppsCount(String n) {
    return 'Dipilih: $n';
  }

  @override
  String mtuAutoMeasured(int mtu) {
    return 'Otomatis — jaringan membawa $mtu';
  }

  @override
  String get sectionAppearance => 'Tampilan';

  @override
  String get mapStyle => 'Gaya peta';

  @override
  String get mapStyleHint =>
      'Globe halaman beranda dicat sesuai pilihan Anda. Cahaya koneksi tetap sama.';

  @override
  String get mapSilver => 'Perak';

  @override
  String get mapMidnight => 'Tengah malam';

  @override
  String get mapOcean => 'Samudra';

  @override
  String get mapMono => 'Mono';

  @override
  String get mapAurora => 'Aurora';

  @override
  String get batterySaver => 'Penghemat baterai';

  @override
  String get batterySaverHint =>
      'Menenangkan gerak peta saat terhubung — napas globe, cahaya roda. Koneksi itu sendiri tetap persis sama.';

  @override
  String get connectOnOpen => 'Sambungkan saat aplikasi dibuka';

  @override
  String get connectOnOpenHint =>
      'Menyalakan VPN begitu aplikasi dibuka, dengan lokasi terakhir yang Anda pilih.';

  @override
  String get speedTitle => 'Kecepatan';

  @override
  String get parallelTunnels => 'Terowongan paralel';

  @override
  String get parallelTunnelsHint =>
      'Membuka beberapa terowongan ke Mozilla sekaligus dan membagi lalu lintas di antara mereka, agar satu terowongan lambat tak lagi membatasi kecepatan. Delapan paling berat untuk baterai.';

  @override
  String get tunnels1 => 'Satu — paling stabil';

  @override
  String get tunnels2 => 'Dua';

  @override
  String get tunnels4 => 'Empat — lebih cepat di jaringan lambat';

  @override
  String get tunnels8 => 'Delapan — paling cepat';

  @override
  String get connectionCap => 'Batas koneksi';

  @override
  String get connectionCapHint =>
      'Berapa banyak aplikasi yang boleh bicara lewat VPN sekaligus; batas lebih kecil menghemat baterai dan data di ponsel yang sibuk. Tanpa batas adalah bawaan.';

  @override
  String get capNone => 'Tanpa batas';

  @override
  String get verboseLogging => 'Diagnostik terperinci';

  @override
  String get verboseLoggingHint =>
      'Menulis setiap langkah ke log — berguna saat melaporkan masalah, sedikit lebih berat untuk baterai.';

  @override
  String get wn38MapStylesAdded =>
      'Lima gaya untuk peta: perak, tengah malam, samudra, mono, dan aurora — halaman Tampilan baru di pengaturan yang memilih, dengan pratinjau masing-masing.';

  @override
  String get wn38ZoomAdded =>
      'Peta bisa di-zoom: cubit dengan dua jari, atau ketuk dua kali untuk mendekat dan kembali.';

  @override
  String get wn38OptionsAdded =>
      'Opsi praktis: terowongan paralel untuk kecepatan lebih, batas koneksi, penghemat baterai, sambungkan saat aplikasi dibuka, dan diagnostik terperinci.';

  @override
  String get wn38SocialAdded =>
      'Instagram dan Telegram kini juga berada di dasar halaman ini.';

  @override
  String get wn38FlightImproved =>
      'Memilih negara adalah penerbangan kecil: kamera mundur, globe berputar, pin mendarat dengan pantulan, dan jalan-jalan menggambar diri ke hub.';

  @override
  String get wn38EffectsImproved =>
      'Peta terasa lebih kaya: bintang di belakang globe, kisi koordinat, cahaya hub, halo di tepi, dan bayangan daratan.';

  @override
  String get wn38SpeedImproved =>
      'Opsi kecepatan kini nyata: terowongan paralel membuka beberapa koneksi sekaligus, dan inti membagi lalu lintas di antara mereka.';

  @override
  String get wn38NameFixed =>
      'Nama negara yang dipilih tampil sekali — pada kartu melayang peta; salinannya di bawah bendera sudah tiada.';

  @override
  String get mapKind => 'Jenis peta';

  @override
  String get mapKindHint =>
      'Bagaimana dunia halaman utama ditampilkan: peta datar seperti biasa (bawaan), sentuhan modernnya, bumi malam, bumi daratan, bola metal, atau bumi satelit. Batasnya adalah batas resmi yang sebenarnya di setiap jenis.';

  @override
  String get mapKindClassic => 'Klasik';

  @override
  String get mapKindGlobe => 'Globe 3D';

  @override
  String get mapKindSatellite => 'Satelit';

  @override
  String get mapKindFlat => 'Datar 2D';

  @override
  String get mapStyleGlobeHint =>
      'Warna yang dikenakan globe 3D. Satelit membawa buminya sendiri, dan peta datar membawa tintanya sendiri.';

  @override
  String get aboutVersions => 'Versi';

  @override
  String get aboutChannels => 'Halaman kontak';

  @override
  String get checkUpdatesHint =>
      'Cari versi yang lebih baru; versi yang ditemukan diunduh dan penginstal bertanya.';

  @override
  String get speedTestTitle => 'Uji kecepatan';

  @override
  String get speedTestRun => 'Ukur';

  @override
  String get speedTestFailed => 'Pengukuran tidak selesai.';

  @override
  String get speedTestThrough => 'Diukur melalui terowongan.';

  @override
  String get speedTestDirect => 'Diukur langsung (proksi mati).';

  @override
  String get speedTestHint =>
      'Satu unduhan dan satu unggahan melalui terowongan memberitahu apa yang benar-benar dibawanya. Graf di halaman rumah juga membuka ini.';

  @override
  String get speedGraphHint =>
      'Menit terakhir terowongan · ketuk untuk mengukur';

  @override
  String get favoritePinned => 'Dipasang. Tekan lama lagi untuk melepas.';

  @override
  String get favoriteUnpinned => 'Dilepas.';

  @override
  String get shareReport => 'Bagikan laporan';

  @override
  String get shareReportCopied => 'Laporan diletakkan di papan klip.';

  @override
  String get batteryWizardTitle => 'Tetap hidup dengan baterai';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei dan sejenisnya mematikan aplikasi VPN setelah layar terkunci. Keluarkan aplikasi ini dari optimasi baterai agar terowongan tetap menyala.';

  @override
  String get batteryWizardSteps =>
      'Di pengaturan pabrikan, izinkan juga autostart dan atur aplikasi ke Tanpa batasan (Xiaomi), keluarkan dari Aplikasi tidur (Samsung), atau Luncur — Manual (Huawei).';

  @override
  String get batteryWizardState =>
      'Optimasi baterai bisa menghentikan terowongan.';

  @override
  String get batteryWizardPermit => 'Izinkan';

  @override
  String get batteryWizardOk => 'Terowongan terlindungi dari baterai.';

  @override
  String get batteryWizardOpen => 'Pengaturan baterai';

  @override
  String get usageTitle => 'Pemakaian per app';

  @override
  String get usageRowHint => 'Berapa tiap app memakai';

  @override
  String get usageGrant => 'Buka akses pemakaian';

  @override
  String get usageGrantHint =>
      'Android menyimpan pemakaian data per app di balik izin akses pemakaian. Halaman yang dibuka tombol milik sistem; aplikasi hanya membaca angkanya.';

  @override
  String get usageEmpty => 'Tidak ada pemakaian tercatat pada periode ini.';

  @override
  String get usageToday => 'Hari ini';

  @override
  String get usageWeek => '7 hari terakhir';

  @override
  String get usageMonth => '30 hari terakhir';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'Aplikasi dipasang di luar Google Play, jadi Play Protect mungkin meminta pemindaian saat pemasangan pertama. Ketuk \"Pindai aplikasi\" sekali — pemindaian yang bersih diingat, dan pembaruan berikutnya terpasang tanpa pertanyaan ini.';

  @override
  String get smartLocation => 'Lokasi tercepat';

  @override
  String get smartLocationHint =>
      'Setiap mulai memakai server yang diuji latensinya paling cepat oleh inti.';

  @override
  String get quicPass => 'Lolos QUIC';

  @override
  String get quicPassHint =>
      'QUIC aplikasi (UDP 443) melewati terowongan: panggilan dan gim tetap cepat, tidak jatuh ke TCP.';

  @override
  String get accountRename => 'Ganti nama akun';

  @override
  String get accountRenameLabel => 'Nama akun';

  @override
  String get accountProfile => 'Foto profil';

  @override
  String get avatarReset => 'Kembali ke tanda sederhana';

  @override
  String get accountSecurity => 'Kata sandi aplikasi';

  @override
  String get appPasswordOn => 'Aplikasi terbuka di balik kata sandi.';

  @override
  String get appPasswordOff =>
      'Tanpa kata sandi: siapa pun yang membuka aplikasi masuk.';

  @override
  String get appPasswordSet => 'Atur kata sandi';

  @override
  String get appPasswordChange => 'Ganti kata sandi';

  @override
  String get appPasswordRemove => 'Hapus kata sandi';

  @override
  String get appPasswordCurrent => 'Kata sandi sekarang';

  @override
  String get appPasswordNew => 'Kata sandi baru (4+ karakter)';

  @override
  String get appPasswordConfirm => 'Ulangi kata sandi baru';

  @override
  String get appPasswordShort => 'Minimal 4 karakter.';

  @override
  String get appPasswordMismatch => 'Kedua kata sandi tidak sama.';

  @override
  String get appPasswordWrong => 'Kata sandi salah';

  @override
  String get appPasswordSetDone =>
      'Kata sandi terpasang — aplikasi akan menanyakannya sejak mulai berikutnya.';

  @override
  String get appPasswordRemoved =>
      'Kata sandi sudah tiada; aplikasi terbuka bebas.';

  @override
  String get appPasswordUnlock => 'Aplikasi terkunci';

  @override
  String get appPasswordUnlockHint =>
      'Masukkan kata sandi aplikasi untuk lanjut.';

  @override
  String get wn39MapKinds =>
      'Peta kembali punya jenis: datar seperti biasa (bawaan), globe 3D, bumi satelit, dan datar 2D modern.';

  @override
  String get wn39EyeIp =>
      'Kartu lokasi membawa mata: ketuk untuk melihat alamat keluar trafik dan menyalinnya.';

  @override
  String get wn39Profile =>
      'Akun membawa nama dan foto profilnya sendiri, dan aplikasi bisa terbuka di balik kata sandi.';

  @override
  String get wn39Smart =>
      'Koneksi pintar makin lengkap: lokasi tercepat berdasar latensi nyata dan lolos QUIC untuk panggilan dan gim.';

  @override
  String get wn39Flight =>
      'Pergantian negara terbang lebih halus — kamera mengikuti lingkaran besar — dan penanda roda bendera dekat ke bendera.';

  @override
  String get wn39ToastEverywhere =>
      'Catatan dinamis kini di mana-mana: setiap tersimpan, tersalin, dan gagal memakai pil kaca animasi yang sama.';

  @override
  String get wn39Updates =>
      'Pembaruan menjaga penyimpanan bersih: penginstal mengganti versi lama dan tak ada paket yang tertinggal.';

  @override
  String get mapKindNight => 'Malam';

  @override
  String get mapKindTerrain => 'Daratan';

  @override
  String get wn40MapKindsNew =>
      'Dua tampilan baru peta: bumi malam dan bumi daratan.';

  @override
  String get wn40Flight =>
      'Globe 3D terbang ke negara baru dalam satu putaran halus — tanpa lompatan.';

  @override
  String get wn40Mercator =>
      'Peta datar digambar dengan proyeksi Mercator standar: proporsi sejati, batas standar, tanpa penekanan.';

  @override
  String get wn40NameBack =>
      'Nama negara yang dipilih kembali di bawah bendera pada peta datar.';

  @override
  String get wn40Speed =>
      'Tunnel kini membuka dua sesi paralel secara bawaan — jalur yang lebih kuat dan stabil.';

  @override
  String get wn40LockFixed =>
      'Gembok tombol sambungan tidak lagi menghilang di antara keadaannya.';

  @override
  String get wn40IpRemoved => 'Jendela IP pada kartu lokasi dihapus.';

  @override
  String get soundFeedback => 'Efek suara';

  @override
  String get soundFeedbackHint =>
      'Suara lembut untuk ketukan, sakelar, dan saat koneksi menyala atau mati';

  @override
  String get rateUnit => 'Satuan kecepatan';

  @override
  String get lockInBackground => 'Kunci saat pergi';

  @override
  String get lockBgNever => 'Tidak pernah';

  @override
  String get lockBgNow => 'Langsung';

  @override
  String get lockBgMin5 => 'Setelah 5 menit';

  @override
  String get lockBgMin15 => 'Setelah 15 menit';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound =>
      'Suara koneksi bergabung dengan getaran: VPN memainkan nada pendek saat menyala atau mati (Pengaturan → Umum).';

  @override
  String get wn41RateUnit =>
      'Kecepatan dibaca dalam satuan pilihan Anda: KB/s yang biasa atau Mbps milik koneksi.';

  @override
  String get wn41BackgroundLock =>
      'Aplikasi bisa mengunci dirinya saat Anda pergi: kata sandi ditanya lagi langsung, setelah 5, atau setelah 15 menit.';

  @override
  String get wn41BiggerLimits =>
      'Batas data sesi naik hingga 25, 50, atau 100 GB.';

  @override
  String get wn41Motion =>
      'Gerakan baru: orb yang terhubung bernapas, tanda centang menggambar dirinya sendiri, kata status meluncur di antara nilainya, dan kata sandi yang salah mengguncang kolomnya.';

  @override
  String get wn41AboutFixed =>
      'Halaman Tentang kini tertata: dua halaman berdampingan, tiap keterangan di barisnya sendiri, tanpa penekanan.';

  @override
  String get wn41HapticFixed =>
      'Pengaturan getaran kini berfungsi lagi: nyala-mati setiap koneksi mengikutinya, bukan hanya slider.';

  @override
  String get copyIp => 'Salin IP';

  @override
  String get wn42Fonts =>
      'Setiap bahasa membaca dengan huruf milik aplikasi sendiri: Noto Sans untuk dua bahasa Tionghoa dan Bengali, Inter untuk bahasa Latin dan Kiril — tidak ada lagi yang bergantung pada huruf ponsel.';

  @override
  String get wn42Sounds =>
      'Suara aplikasi kini nyata: ketukan lembut di setiap bagian, dua nada untuk sakelar, nada naik-turun saat koneksi menyala dan mati, ping untuk kunci — sakelar suara mengatur semuanya.';

  @override
  String get wn42AboutFixed =>
      'Halaman Tentang memusat logo, nama, dan catatannya, dan ident kontak tetap utuh satu baris apa pun lebar ponselnya.';

  @override
  String get wn42Gaming =>
      'Profil gim kini nyata: halaman server mengukur ulang keterlambatan tiap setengah menit dan mengangkat yang tercepat terukur dengan aksen.';

  @override
  String get avatarPhoto => 'Fotomu';

  @override
  String get avatarPhotoFailed => 'Gambar itu tidak dapat dipakai';

  @override
  String get designAether => 'Aether';

  @override
  String get designAetherDesc =>
      'Kartu status iOS: kata status dan waktu sesi pada kartu timbul, dengan tombol daya yang menyala';

  @override
  String get designZed => 'Zed';

  @override
  String get designZedDesc =>
      'Bola gradien: orb bernapas dalam ungu, merah muda, dan limau yang membawa waktu sesi';

  @override
  String get tlsFragmentAuto => 'Otomatis';

  @override
  String get tlsFragmentAutoHint =>
      'Hello utuh dulu; jaringan yang terus memotong TLS memotong nama sendiri, selama setengah jam';

  @override
  String get accentDesign => 'Cahaya desain itu sendiri';

  @override
  String get wn45Designs =>
      'Empat tampilan rumah baru — Aurora, Neon, Senja, dan Sage — masing-masing memakaikan setiap halaman dengan paletnya sendiri';

  @override
  String get wn45HelloAuto =>
      'Pemecah TLS belajar: jaringan yang terus membunuh jabat tangan memotong nama sendiri, dan terowongan lewat';

  @override
  String get wn45RelayRace =>
      'Pemulihan relai kini menguji tiga tepi sekaligus, jaringan tersaring lebih cepat menemukan jalannya';

  @override
  String get wn45AccentFixed =>
      'Pemilih warna kembali menerangi aplikasi — warnanya tak lagi sampai ke halaman';

  @override
  String get wn45WhatsNewFixed =>
      'Halaman «Yang baru» kembali menampilkan kata-katanya — dulu terbuka kosong';

  @override
  String get wn46Designs =>
      'Dua tampilan baru dari desain referensi: kartu status iOS milik aether dan bola gradien milik zed — masing-masing mengenakan seluruh aplikasi, dan empat tampilan sebelumnya pergi.';

  @override
  String get wn46Sounds =>
      'Suara mendapat set profesional: gelombang untuk koneksi yang mulai, akor saat tersambung, melodi menurun saat terputus, dan nada redup untuk jalan yang terhalang — satu suara pada satu waktu.';

  @override
  String get wn47Designs =>
      'Kedua tampilan referensi kini menjelma ke seluruh aplikasi — setiap halaman, bukan hanya beranda: aether memakai struktur iOS referensi pertama (bilah takik melengkung, tabel berkelompok, lencana berwarna, warna status sistem) dan zed memakai struktur ekspresif referensi kedua (dok mengapung, kartu sangat bulat, gelembung alat yang bisa digeser).';

  @override
  String get wn47Fixes =>
      'Baris pengaturan yang meluap pada layar sempit kini terbaca sampai ujungnya.';

  @override
  String get wn48Bars =>
      'Bilah bawah kedua desain kembali ke tempatnya: lingkaran biru aether bertengger di alur tabnya sendiri, dan lingkaran zed tak lagi menutupi namanya di bawah.';

  @override
  String get wn48Fit =>
      'Laman utama kembali pas di layarnya: kartu aether membaca Disconnected sampai habis, orb zed turun satu langkah saat halaman sesak, dan saat penyambungan berlangsung tak ada lintasan yang minta digeser untuk menyambung dan tak ada petunjuk yang bilang putuskan sekaligus.';

  @override
  String get wn48Wheel =>
      'Roda bendera melarutkan kartu sebelum tepi layar memotongnya, lokasi yang disarankan memakai tanda Mozilla dalam ukuran yang terbaca, dan tepi selatan peta datar melebur ke halaman alih-alih berakhir menjadi garis.';

  @override
  String get wn49States =>
      'Kedua desain referensi memakai detail yang digambar untuknya: kartu aether membawa laju sesi seperti milik AetherST, tombol dayanya bernapas dengan cahaya referensi dan turun di bawah jari, dan gelembung zed berubah di antara bentuk-bentuknya sementara isinya berganti dengan cross-fade.';

  @override
  String get wn49Words =>
      '“Menyambung” kini punya kata di mana-mana: selagi terowongan dibangun, lintas saklar membawa kata Menyambung…, tanda kenop memudar di antara wujudnya, dan lintas bernapas dengan irama sambungan sendiri — tak ada yang lenyap di bawah jari.';

  @override
  String get wn49Sooner =>
      '“Tersambung” datang lebih cepat: putusan terowongan sendiri menghampiri begitu lulus, dan tempat keluar — negara dan alamat — menyusul kemudian.';

  @override
  String get wn49Mark =>
      'Lokasi yang disarankan memakai tanda Mozilla VPN yang sebenarnya, dan tombol pembaruan memakai glif pembaruan miliknya.';
}
