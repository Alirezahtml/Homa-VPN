// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Trượt để kết nối';

  @override
  String get slideToDisconnect => 'Trượt để ngắt kết nối';

  @override
  String get navOverview => 'Tổng quan';

  @override
  String get navAccounts => 'Tài khoản';

  @override
  String get navSettings => 'Cài đặt';

  @override
  String get stateConnected => 'Đã kết nối';

  @override
  String get stateConnecting => 'Đang kết nối…';

  @override
  String get stateWaiting => 'Đang chờ';

  @override
  String get waitingForAccount =>
      'Thêm một Firefox Account ở trang Tài khoản để kết nối.';

  @override
  String get waitingForEnabledAccount =>
      'Tất cả tài khoản đang tắt. Hãy bật một tài khoản ở trang Tài khoản.';

  @override
  String get stateError => 'Lỗi';

  @override
  String get stateUnknown => 'Không rõ';

  @override
  String get restartProxy => 'Khởi động lại proxy';

  @override
  String copied(String value) {
    return 'Đã sao chép $value';
  }

  @override
  String get activeAccount => 'Tài khoản đang dùng';

  @override
  String get noActiveAccount => 'Không có tài khoản đang dùng';

  @override
  String get quotaNotRead => 'Chưa có thông tin dung lượng';

  @override
  String get unlimited => 'Không giới hạn';

  @override
  String usedOf(String used, String limit) {
    return 'Đã dùng $used / $limit';
  }

  @override
  String resets(String date) {
    return 'làm mới vào $date';
  }

  @override
  String switchAt(int percent) {
    return 'Chuyển tài khoản khi đạt $percent%';
  }

  @override
  String get publicIp => 'IP công khai';

  @override
  String get testConnection => 'Kiểm tra kết nối';

  @override
  String get testing => 'Đang kiểm tra…';

  @override
  String get testFailed => 'Thất bại';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'vừa xong';

  @override
  String minutesAgo(int n) {
    return '$n phút trước';
  }

  @override
  String hoursAgo(int n) {
    return '$n giờ trước';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'lúc $time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d ngày $h giờ';
  }

  @override
  String durationHours(int h, int m) {
    return '$h giờ $m phút';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m phút $s giây';
  }

  @override
  String durationSeconds(int s) {
    return '$s giây';
  }

  @override
  String accountsGuide(String size) {
    return 'Mỗi Firefox Account có $size dung lượng mỗi tháng. Bạn có thể thêm nhiều tài khoản: khi một tài khoản hết, ứng dụng tự chuyển sang tài khoản tiếp theo.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'Theo thứ tự danh sách này: mỗi tài khoản đến $percent%, tài khoản cuối dùng đến khi hết dữ liệu.';
  }

  @override
  String get addAccount => 'Thêm tài khoản';

  @override
  String lowQuotaNotice(String size) {
    return 'Dung lượng của tài khoản này sắp hết. Thêm một tài khoản nữa để có thêm $size.';
  }

  @override
  String get noAccounts => 'Chưa có tài khoản';

  @override
  String get noAccountsHint => 'Thêm một Firefox Account để kết nối.';

  @override
  String get delayTestFailed =>
      'Không đo được độ trễ của máy chủ. Hãy kiểm tra internet.';

  @override
  String get createAccountTitle => 'Chưa có Firefox Account?';

  @override
  String get createAccountHint =>
      'Hãy tạo miễn phí tại accounts.firefox.com, rồi quay lại và nhấn Thêm tài khoản.';

  @override
  String get moveUp => 'Lên trên';

  @override
  String get moveDown => 'Xuống dưới';

  @override
  String get statusActive => 'Đang dùng';

  @override
  String get statusReady => 'Sẵn sàng';

  @override
  String get statusNeedsSignIn => 'Cần đăng nhập';

  @override
  String get statusReserved => 'Dự phòng';

  @override
  String get statusUnavailable => 'Không khả dụng';

  @override
  String statusUnavailableUntil(String date) {
    return 'Không khả dụng đến $date';
  }

  @override
  String get statusDisabled => 'Đã tắt';

  @override
  String get statusEnabled => 'Đã bật';

  @override
  String get useNow => 'Dùng ngay';

  @override
  String get signInAgain => 'Đăng nhập lại';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Tài khoản này đã dùng $percent% dữ liệu, nên tài khoản tiếp theo đã thay thế.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Dung lượng tháng này đã hết; sẽ dùng lại sau khi làm mới hằng tháng.';

  @override
  String get reasonSignInRequired => 'Hãy đăng nhập lại để dùng tài khoản này.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla yêu cầu xác nhận đăng nhập: nhấn Đăng nhập lại (chỉ cần mã).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Đăng nhập tự động thất bại ($detail). Hãy đăng nhập lại.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'Lần đăng nhập tự động gần nhất ngừng hoạt động ngay sau đó; lần thử tiếp theo lúc $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Đăng nhập tự động chưa hoàn tất ($detail); sẽ thử lại lúc $time.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla đã từ chối tài khoản này; sẽ thử lại sau.';

  @override
  String get more => 'Tùy chọn khác';

  @override
  String get refreshQuota => 'Cập nhật dung lượng';

  @override
  String get remove => 'Xóa';

  @override
  String get removeTitle => 'Xóa tài khoản?';

  @override
  String removeBody(String name) {
    return '$name và thông tin đăng nhập đã lưu sẽ bị xóa khỏi máy tính này. Bạn có thể thêm lại sau.';
  }

  @override
  String get unlimitedQuota => 'Dung lượng không giới hạn';

  @override
  String get signInTitle => 'Đăng nhập';

  @override
  String get signInIntro => 'Đăng nhập bằng Firefox Account.';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Nhập email của tài khoản';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordEmpty => 'Nhập mật khẩu';

  @override
  String get show => 'Hiện';

  @override
  String get hide => 'Ẩn';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String get done => 'Xong';

  @override
  String get close => 'Đóng';

  @override
  String get noBrowserTitle => 'Thiết bị này không có trình duyệt';

  @override
  String get noBrowserText =>
      'Hãy mở địa chỉ này trên điện thoại hoặc máy tính:';

  @override
  String get cancel => 'Hủy';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get signingIn => 'Đang đăng nhập…';

  @override
  String get accountReady => 'Tài khoản đã sẵn sàng';

  @override
  String get accountReadyHint => 'Tài khoản đã được thêm vào cuối danh sách.';

  @override
  String get captchaLabel => 'Ký tự trong ảnh';

  @override
  String get codeLabel => 'Mã';

  @override
  String get captchaBroken => 'Không thể hiển thị ảnh CAPTCHA.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla đã gửi mã đến $email. Nhập mã vào đây.';
  }

  @override
  String get stepTotp => 'Nhập mã từ ứng dụng xác thực của bạn.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla thấy lần đăng nhập này bất thường và đã gửi mã mở khóa đến $email. Nhập mã vào đây.';
  }

  @override
  String get stepCaptcha => 'Nhập các ký tự trong ảnh.';

  @override
  String stepEmailLink(String email) {
    return 'Mở liên kết xác nhận Mozilla đã gửi đến $email. Quá trình sẽ tự tiếp tục.';
  }

  @override
  String get signInFailed => 'Chưa thêm được tài khoản.';

  @override
  String get signInCancelled => 'Đã hủy đăng nhập.';

  @override
  String get signInNoAccount => 'Không có Firefox Account nào với email này.';

  @override
  String get signInNoAccountHint =>
      'Hãy kiểm tra email, hoặc tạo một Firefox Account miễn phí bằng email này trên trang của Mozilla, xác nhận từ hộp thư rồi thêm vào đây.';

  @override
  String get createAccountButton => 'Tạo Firefox Account';

  @override
  String get signInWrongPassword => 'Mật khẩu không đúng.';

  @override
  String get signInNoPassword =>
      'Tài khoản này chưa có mật khẩu: nó được tạo bằng đăng nhập Google hoặc Apple. Hãy đặt mật khẩu, rồi đăng nhập tại đây bằng mật khẩu đó.';

  @override
  String get setPasswordButton => 'Đặt mật khẩu';

  @override
  String get signInTooManyAttempts =>
      'Thử quá nhiều lần. Hãy đợi một lúc rồi thử lại.';

  @override
  String get signInUnblockRejected =>
      'Mã bỏ chặn không được chấp nhận. Hãy dùng mã trong email mới nhất của Mozilla.';

  @override
  String get signInWrongCode =>
      'Mã sai hoặc đã hết hạn. Hãy dùng mã trong email mới nhất của Mozilla; mã cũ không còn dùng được khi có mã mới.';

  @override
  String get signInWrongTotp =>
      'Mã sai. Nhập mã mà ứng dụng xác thực đang hiển thị.';

  @override
  String get signInTooManyCodes =>
      'Nhập sai mã quá nhiều lần. Hãy đăng nhập lại từ đầu.';

  @override
  String get signInTimedOut =>
      'Đăng nhập mất quá nhiều thời gian. Hãy bắt đầu lại.';

  @override
  String get signInNetwork =>
      'Không kết nối được tới Mozilla. Hãy kiểm tra internet rồi thử lại.';

  @override
  String get coreConnecting => 'Đang kết nối với lõi…';

  @override
  String get coreLost => 'Mất kết nối với lõi. Đang thử lại…';

  @override
  String get cantReachCore => 'Không kết nối được với lõi';

  @override
  String get startingCore => 'Đang khởi động lõi…';

  @override
  String get retry => 'Thử lại';

  @override
  String errNoCore(String path) {
    return 'Không tìm thấy chương trình lõi bên cạnh ứng dụng ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'Lõi đã dừng: $detail';
  }

  @override
  String get errNotAnswering => 'Lõi không phản hồi.';

  @override
  String get errRefused =>
      'Lõi từ chối kết nối từ ứng dụng; có thể lõi này thuộc về một bản cài đặt khác.';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get sectionGeneral => 'Chung';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo hệ thống';

  @override
  String get theme => 'Giao diện';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get closeBehavior => 'Khi đóng cửa sổ';

  @override
  String get closeAsk => 'Luôn hỏi';

  @override
  String get closeTray => 'Thu nhỏ xuống khay hệ thống';

  @override
  String get closeQuit => 'Thoát ứng dụng';

  @override
  String get sectionConnection => 'Kết nối';

  @override
  String get localProxy => 'Proxy cục bộ';

  @override
  String get systemProxy => 'Proxy hệ thống';

  @override
  String get sectionRouting => 'Định tuyến';

  @override
  String get routingDirect => 'Kết nối trực tiếp cho trang trong nước';

  @override
  String get routingDirectHint =>
      'Các trang và IP của quốc gia đã chọn sẽ không qua VPN: mở nhanh hơn và tiết kiệm dung lượng.';

  @override
  String get region => 'Quốc gia';

  @override
  String get regionIr => 'Iran';

  @override
  String get regionCn => 'Trung Quốc';

  @override
  String get regionRu => 'Nga';

  @override
  String get regionAf => 'Afghanistan';

  @override
  String get regionTr => 'Thổ Nhĩ Kỳ';

  @override
  String get regionId => 'Indonesia';

  @override
  String get regionBr => 'Brazil';

  @override
  String get regionNone => 'Không chọn';

  @override
  String get saved => 'Đã lưu';

  @override
  String get dataFolder => 'Thư mục dữ liệu';

  @override
  String get openFolder => 'Mở thư mục';

  @override
  String get unofficialNote =>
      'Ứng dụng không chính thức. Không liên kết với Mozilla.';

  @override
  String get closeTitle => 'Đóng cửa sổ?';

  @override
  String get closeBody =>
      'Khi thu nhỏ xuống khay hệ thống, VPN vẫn giữ kết nối. Thoát ứng dụng sẽ ngắt VPN.';

  @override
  String get rememberChoice => 'Ghi nhớ lựa chọn';

  @override
  String get minimizeToTray => 'Thu nhỏ xuống khay';

  @override
  String get quit => 'Thoát';

  @override
  String get trayOpen => 'Mở';

  @override
  String get trayQuit => 'Thoát';

  @override
  String get trayProxyOnly => 'Chỉ dịch vụ proxy';

  @override
  String get traySetSystemProxy => 'Đặt proxy hệ thống';

  @override
  String errPortInUse(String port) {
    return 'Cổng $port đang được chương trình khác sử dụng, nên ứng dụng không thể kết nối với lõi.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'Cổng $port đang được chương trình khác sử dụng, nên proxy không thể khởi động.';
  }

  @override
  String get changePort => 'Đổi cổng';

  @override
  String get portDialogTitle => 'Chọn cổng';

  @override
  String portDialogBody(String port) {
    return 'Cổng $port đã bị chiếm. Một cổng trống được gợi ý bên dưới; bạn có thể nhập cổng khác.';
  }

  @override
  String get portChangeBody =>
      'Các ứng dụng kết nối tới cổng này. Hãy chọn một cổng từ 1024 đến 65535.';

  @override
  String get portLabel => 'Cổng';

  @override
  String get portInvalid => 'Nhập cổng từ 1024 đến 65535';

  @override
  String get portBusy => 'Cổng này cũng đang được dùng';

  @override
  String get portInUse => 'Một chương trình khác đang dùng cổng này';

  @override
  String get save => 'Lưu';

  @override
  String get proxyPort => 'Cổng proxy';

  @override
  String get appPort => 'Cổng ứng dụng';

  @override
  String get welcomeTitle => 'Chào mừng';

  @override
  String get welcomeBody =>
      'Chọn ngôn ngữ và quốc gia của bạn. Các trang trong nước sẽ mở trực tiếp, không qua VPN, giúp nhanh hơn và tiết kiệm dung lượng.';

  @override
  String get start => 'Bắt đầu';

  @override
  String routingSuggestTitle(String country) {
    return 'Mở trực tiếp các trang của $country?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Các trang và IP của $country sẽ mở trực tiếp, không qua VPN. Bạn có thể thay đổi trong mục Định tuyến.';
  }

  @override
  String get yes => 'Có';

  @override
  String get notNow => 'Để sau';

  @override
  String get navServers => 'Máy chủ';

  @override
  String get navLogs => 'Nhật ký';

  @override
  String get realDelay => 'Độ trễ thực';

  @override
  String get statElapsed => 'Thời gian';

  @override
  String get statDown => 'Tải xuống';

  @override
  String get statUp => 'Tải lên';

  @override
  String noticePort(String port) {
    return 'Proxy của Mozilla không kết nối tới cổng $port. Chỉ các cổng 80, 443, 8080 và 8443 đi qua VPN.';
  }

  @override
  String get noticeCommand => 'Loại kết nối này không được VPN hỗ trợ.';

  @override
  String noticeTimes(int count, String time) {
    return '$count lần, gần nhất $time';
  }

  @override
  String get dismiss => 'Bỏ qua';

  @override
  String get modeRecommended => 'Đề xuất';

  @override
  String get modeFastest => 'Nhanh nhất';

  @override
  String get modeRecommendedHint => 'Mozilla chọn vị trí cho bạn.';

  @override
  String get modeFastestHint =>
      'Mỗi lần kết nối, chọn vị trí có độ trễ thấp nhất.';

  @override
  String get testDelay => 'Đo độ trễ thực';

  @override
  String get testingDelay => 'Đang đo…';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get noAnswer => 'Không phản hồi';

  @override
  String testedAgo(String ago) {
    return 'Đã đo $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered / $total đã phản hồi';
  }

  @override
  String get noServers =>
      'Chưa có máy chủ. Danh sách sẽ hiện khi lõi kết nối được với Mozilla.';

  @override
  String get levelAll => 'Tất cả';

  @override
  String get filter => 'Lọc';

  @override
  String get follow => 'Tự động cuộn';

  @override
  String get clear => 'Xóa';

  @override
  String get copyAll => 'Sao chép';

  @override
  String get logsCopied => 'Đã sao chép nhật ký';

  @override
  String get noLogs => 'Chưa có dòng nhật ký nào.';

  @override
  String get sectionAccounts => 'Tự động chuyển tài khoản';

  @override
  String get switchThreshold => 'Chuyển tài khoản khi đạt';

  @override
  String get switchThresholdHint =>
      'Khi dung lượng đã dùng đạt mức này, ứng dụng chuyển sang tài khoản tiếp theo.';

  @override
  String get signInMethod => 'Phương thức đăng nhập';

  @override
  String get signInMethodBrowser => 'Đăng nhập qua trình duyệt';

  @override
  String get signInMethodApi => 'Đăng nhập trực tiếp';

  @override
  String get browserSignInBroken => 'Không thể mở trang đăng nhập.';

  @override
  String get browserSignInBlocked =>
      'Mozilla chưa hoàn tất bước cuối để thêm tài khoản (HTTP 406).';

  @override
  String get browserSignInFallback => 'Đăng nhập bằng email và mật khẩu';

  @override
  String get backupExport => 'Lưu bản sao lưu';

  @override
  String get backupImport => 'Nhập bản sao lưu';

  @override
  String backupSaved(String name) {
    return 'Đã lưu: $name';
  }

  @override
  String get backupImportTitle => 'Thêm các tài khoản này?';

  @override
  String get backupAccountExists =>
      'Đã có sẵn; thông tin đăng nhập sẽ lấy từ tệp';

  @override
  String get backupImportAction => 'Thêm';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã thêm $count tài khoản',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'Máy chủ DNS';

  @override
  String get dnsSystem => 'Hệ thống';

  @override
  String get dnsAuto => 'Tự động (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Tùy chỉnh';

  @override
  String get dnsCustomHint =>
      'Mỗi dòng một máy chủ: https://…/dns-query, tls://…, hoặc một địa chỉ IP.';

  @override
  String get dnsFallback => 'Dùng DNS hệ thống làm dự phòng';

  @override
  String get testDns => 'Kiểm tra DNS';

  @override
  String get transport => 'Giao thức';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'Phiên bản IP';

  @override
  String get ipVersionAuto => 'Tự động (IPv4 trước, rồi IPv6)';

  @override
  String get ipVersionDual => 'Cả hai cùng lúc (dual-stack)';

  @override
  String get ipVersionV6First => 'IPv6 trước, rồi IPv4';

  @override
  String get ipVersionV4 => 'Chỉ IPv4';

  @override
  String get ipVersionV6 => 'Chỉ IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'Kích thước gói của giao diện VPN, từ 1280 đến 9000. Để trống: tự động.';

  @override
  String get tunMtuInvalid => 'Một số từ 1280 đến 9000, hoặc để trống';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Trực tiếp';

  @override
  String get directRulesHint =>
      'Các trang và địa chỉ trong danh sách này mở không qua VPN, trực tiếp bằng mạng của bạn. Quy tắc của quốc gia đã chọn đã có sẵn ở đây: bạn có thể thêm, sửa hoặc xóa dòng. Chọn quốc gia khác sẽ thay bằng quy tắc của quốc gia đó.';

  @override
  String get restoreRegionRules => 'Khôi phục quy tắc của quốc gia';

  @override
  String get blockRules => 'Chặn';

  @override
  String get blockRulesHint =>
      'Các trang và địa chỉ trong danh sách này hoàn toàn không mở được, dù trực tiếp hay qua VPN: dùng cho quảng cáo hoặc những trang bạn không bao giờ muốn truy cập.';

  @override
  String get rulesTitle => 'Quy tắc';

  @override
  String get ruleSyntaxTitle => 'Cách viết quy tắc';

  @override
  String get resolveDomains => 'Áp dụng quy tắc IP cho tên miền';

  @override
  String get routingLists => 'Tệp geo';

  @override
  String get listSource => 'Nguồn danh sách';

  @override
  String get listSourceCustom => 'Nhập thủ công';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Cập nhật $ago';
  }

  @override
  String get updateLists => 'Cập nhật tệp geo';

  @override
  String get listsUpdated => 'Đã cập nhật tệp geo.';

  @override
  String get testDestination => 'Kiểm tra định tuyến';

  @override
  String get destinationHint => 'Tên miền, địa chỉ hoặc URL';

  @override
  String get check => 'Kiểm tra';

  @override
  String get routeDirect => 'Đi trực tiếp';

  @override
  String get routeProxy => 'Đi qua VPN';

  @override
  String get routeBlock => 'Bị chặn';

  @override
  String ruleMatched(String rule) {
    return 'Quy tắc: $rule';
  }

  @override
  String get portRefusedNote => 'Proxy của Mozilla không kết nối tới cổng này.';

  @override
  String get sectionAdvanced => 'Nâng cao';

  @override
  String get tlsFragment => 'Phân mảnh TLS';

  @override
  String get tlsFragmentOff => 'Tắt';

  @override
  String get tlsFragmentFirstByte => 'Byte đầu tiên';

  @override
  String get tlsFragmentSni => 'Tên máy chủ (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Tách phần đầu TLS tại byte đầu tiên (0x16)';

  @override
  String get tlsFragmentSniHint => 'Chia tên máy chủ (SNI) thành nhiều gói TCP';

  @override
  String get tlsFragmentRecord => 'Bản ghi TLS';

  @override
  String get tlsFragmentRecordHint =>
      'Chia tên máy chủ (SNI) thành hai bản ghi TLS';

  @override
  String get tlsFragmentOffHint => 'Kết nối TLS thông thường';

  @override
  String get sectionBypass => 'Nếu Mozilla bị chặn';

  @override
  String get sharedRelay => 'Chuyển tiếp dùng chung';

  @override
  String get sharedRelayHint =>
      'Dùng máy chủ chuyển tiếp dùng chung của ứng dụng nếu Mozilla chặn khu vực của bạn. Máy chủ chuyển tiếp cá nhân đang bật được ưu tiên.';

  @override
  String get personalRelay => 'Chuyển tiếp cá nhân';

  @override
  String get apiRelay => 'Máy chủ chuyển tiếp';

  @override
  String get apiRelayUse => 'Dùng máy chủ chuyển tiếp';

  @override
  String get apiRelayHint =>
      'Cloudflare Worker của riêng bạn, hoặc relay.php trên hosting của bạn.\nChỉ dùng khi Mozilla không trả lời trực tiếp: đăng nhập, tài khoản và danh sách máy chủ đi qua nó, không phải lưu lượng VPN.';

  @override
  String get upstreamProxy => 'Proxy thượng nguồn';

  @override
  String get upstreamProxyOn => 'Proxy thượng nguồn đang bật';

  @override
  String get upstreamProxyAddress => 'Địa chỉ proxy SOCKS5';

  @override
  String get upstreamProxyPort => 'Cổng';

  @override
  String get upstreamProxyHint =>
      'Kết nối đến Mozilla đi qua proxy này, dành cho các mạng chặn hoặc làm chậm Mozilla.\nNếu proxy chạy trên thiết bị này, hãy để nó ngoài VPN.';

  @override
  String get upstreamProxyInvalid => 'Nhập địa chỉ proxy, ví dụ 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Nhập cổng từ 1 đến 65535.';

  @override
  String get upstreamProxyOwn =>
      'Đó là proxy của chính ứng dụng này. Hãy nhập proxy khác.';

  @override
  String get apiRelayInvalid => 'Phải là địa chỉ https://.';

  @override
  String get listenAddress => 'Quyền truy cập proxy';

  @override
  String get listenLocal => '127.0.0.1 · chỉ thiết bị này';

  @override
  String get listenAll => '0.0.0.0 · mọi mạng (LAN)';

  @override
  String get proxyUsername => 'Tên người dùng proxy';

  @override
  String get proxyPassword => 'Mật khẩu proxy';

  @override
  String get proxyLoginHint =>
      'Các ứng dụng phải dùng thông tin này để kết nối. Để trống cả hai nếu không cần xác thực.';

  @override
  String get loginBothOrNone => 'Điền cả hai, hoặc để trống cả hai.';

  @override
  String get proxyLogin => 'Xác thực proxy';

  @override
  String get idleSleep => 'Tạm dừng khi không dùng sau';

  @override
  String get sleepNever => 'Không bao giờ';

  @override
  String sleepMinutes(int count) {
    return '$count phút';
  }

  @override
  String get sleepHour => '1 giờ';

  @override
  String get showPublicIp => 'Hiện IP công khai';

  @override
  String get hapticFeedback => 'Rung khi kết nối thay đổi';

  @override
  String get keepScreenOn => 'Giữ màn hình sáng khi đang kết nối';

  @override
  String get showTraffic => 'Hiển thị lưu lượng trực tiếp trên trang chủ';

  @override
  String get speedInNotification => 'Hiện tốc độ trong thông báo';

  @override
  String get liveTraffic => 'Lưu lượng hiện tại';

  @override
  String get totalTraffic => 'Tổng lưu lượng';

  @override
  String get verboseLogs => 'Nhật ký chi tiết';

  @override
  String get webDashboard => 'Bảng điều khiển web';

  @override
  String get webDashboardOpen => 'Mở';

  @override
  String get webDashboardHint => 'Cài đặt nâng cao và thêm công cụ';

  @override
  String numberInvalid(int min, int max) {
    return 'Nhập một số từ $min đến $max';
  }

  @override
  String get notifySwitchedTitle => 'Đã chuyển tài khoản';

  @override
  String notifySwitchedBody(String name) {
    return 'Đang dùng $name.';
  }

  @override
  String get notifySignInTitle => 'Cần đăng nhập';

  @override
  String get notifySignInBody =>
      'Một tài khoản cần đăng nhập lại ở trang Tài khoản.';

  @override
  String get navAbout => 'Giới thiệu';

  @override
  String get appVersionLabel => 'Phiên bản ứng dụng';

  @override
  String get coreVersionLabel => 'Phiên bản lõi';

  @override
  String get checkUpdates => 'Kiểm tra cập nhật';

  @override
  String get checkingUpdates => 'Đang kiểm tra…';

  @override
  String get upToDate => 'Bạn đang dùng phiên bản mới nhất.';

  @override
  String updateAvailable(String version) {
    return 'Đã có phiên bản mới $version.';
  }

  @override
  String updateRequired(String version) {
    return 'Vui lòng cập nhật lên phiên bản $version. Bản cập nhật này là bắt buộc.';
  }

  @override
  String get download => 'Tải xuống';

  @override
  String updateCheckFailed(String error) {
    return 'Không thể kiểm tra cập nhật: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'Không thể kết nối tới GitHub. Hãy kiểm tra kết nối internet và thử lại.';

  @override
  String get updateNow => 'Cập nhật';

  @override
  String updateDownloading(String version) {
    return 'Đang tải phiên bản $version…';
  }

  @override
  String updateReady(String version) {
    return 'Phiên bản $version đã sẵn sàng để cài đặt.';
  }

  @override
  String updateInstalling(String version) {
    return 'Đang cài đặt phiên bản $version. Ứng dụng sẽ đóng và mở lại.';
  }

  @override
  String updateFailed(String version) {
    return 'Không thể cập nhật lên phiên bản $version.';
  }

  @override
  String updateDone(String version) {
    return 'Đã cập nhật lên phiên bản $version.';
  }

  @override
  String updateRolledBack(String version) {
    return 'Bản cập nhật lên phiên bản $version chưa hoàn tất nên ứng dụng đã quay về phiên bản trước.';
  }

  @override
  String get repoNotSet => 'Chưa thiết lập kho GitHub.';

  @override
  String get sourceCode => 'Mã nguồn';

  @override
  String get tapToConnect => 'Nhấp để kết nối';

  @override
  String get tapToDisconnect => 'Nhấp để ngắt kết nối';

  @override
  String get startOnBoot => 'Khởi động cùng hệ thống';

  @override
  String get connectOnStartup => 'Tự động kết nối khi khởi động';

  @override
  String get proxyServiceActive => 'Dịch vụ proxy đang hoạt động';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get groupApp => 'Ứng dụng';

  @override
  String get groupNetwork => 'Mạng';

  @override
  String get stateOff => 'Đã ngắt kết nối';

  @override
  String get tapToConnectPhone => 'Chạm để kết nối';

  @override
  String get tapToDisconnectPhone => 'Chạm để ngắt kết nối';

  @override
  String get tapToConnectTv => 'Nhấn OK để kết nối';

  @override
  String get tapToDisconnectTv => 'Nhấn OK để ngắt kết nối';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Vị trí đề xuất';

  @override
  String dataLeftOf(String limit) {
    return '/ $limit';
  }

  @override
  String get homeLocation => 'Vị trí';

  @override
  String get connectedTo => 'Đã kết nối tới';

  @override
  String get vpnNotAllowed =>
      'VPN cần sự cho phép của bạn. Chạm nút lần nữa và cho phép.';

  @override
  String get dataUsedTitle => 'Dung lượng đã dùng';

  @override
  String get bypassApps => 'Proxy theo ứng dụng';

  @override
  String get connectRetrying => 'Không thể kết nối. Hãy kiểm tra internet.';

  @override
  String get failUnreachable =>
      'Không thể kết nối đến máy chủ của Mozilla. Hãy thử kết nối internet khác.';

  @override
  String get failUpstreamProxy =>
      'Không thể kết nối đến Mozilla qua proxy thượng nguồn. Hãy kiểm tra xem proxy có đang chạy không.';

  @override
  String get failInsideVpn => 'Internet này đã đi qua một VPN. Hãy tắt nó.';

  @override
  String get failRefused =>
      'Máy chủ Mozilla đã từ chối kết nối. Hãy thử lại sau vài phút.';

  @override
  String get failLocationRefused =>
      'Quốc gia này không mở cho tài khoản của bạn. Hãy chọn quốc gia khác.';

  @override
  String get useRecommendedLocation => 'Dùng vị trí đề xuất';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Bạn đã chọn $chosen, nhưng IP của bạn ở $exit.';
  }

  @override
  String get failSignIn =>
      'Phiên đăng nhập của tài khoản này đã hết hạn. Hãy đăng nhập lại ở trang Tài khoản.';

  @override
  String get failQuota =>
      'Dung lượng tháng này đã hết. Hãy thêm tài khoản khác.';

  @override
  String get failNotEntitled =>
      'Mozilla không cho tài khoản này dùng VPN. Hãy thêm tài khoản khác.';

  @override
  String get failRegion =>
      'Mozilla không cung cấp dịch vụ tại quốc gia của bạn.';

  @override
  String get failServer =>
      'Dịch vụ Mozilla đang gặp sự cố tạm thời. Ứng dụng sẽ tự thử lại.';

  @override
  String get failNoAccount =>
      'Không có tài khoản nào sẵn sàng. Hãy mở trang Tài khoản.';

  @override
  String get failTestSite =>
      'Đã kết nối máy chủ nhưng không mở được trang web. Hãy thử quốc gia khác.';

  @override
  String get failOther => 'Không thể kết nối. Hãy thử lại.';

  @override
  String get failNoInternet =>
      'Không có internet. Hãy kiểm tra Wi-Fi hoặc dữ liệu di động.';

  @override
  String get waitingForNetwork => 'Đang chờ kết nối internet…';

  @override
  String proxyStartFailed(String port) {
    return 'Không thể khởi động proxy trên cổng $port. Hãy chọn cổng khác.';
  }

  @override
  String get connectionSettings => 'Cài đặt kết nối';

  @override
  String get appModeExclude => 'Ứng dụng đã chọn không qua VPN';

  @override
  String get appModeInclude => 'Chỉ ứng dụng đã chọn qua VPN';

  @override
  String get appModeExcludeHint =>
      'Ứng dụng đã chọn kết nối trực tiếp, không qua VPN: ví dụ ứng dụng ngân hàng chặn IP nước ngoài.';

  @override
  String get appModeIncludeHint =>
      'Chỉ các ứng dụng đã chọn đi qua VPN; các ứng dụng khác kết nối trực tiếp.';

  @override
  String fromRegionList(String region) {
    return 'Gợi ý: có trong danh sách $region';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Chế độ kết nối';

  @override
  String get modeProxyHint =>
      'Chỉ những ứng dụng được cài đặt dùng proxy mới đi qua proxy.';

  @override
  String get modeSystemProxyHint => 'Windows và hầu hết ứng dụng đi qua proxy.';

  @override
  String get modeSystemProxyHintOther =>
      'Trình duyệt và hầu hết ứng dụng đi qua proxy.';

  @override
  String get suggestedApps => 'Ứng dụng gợi ý';

  @override
  String get showSystemApps => 'Hiện ứng dụng hệ thống';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chọn $count ứng dụng gợi ý',
      one: 'Đã chọn 1 ứng dụng gợi ý',
      zero: 'Các ứng dụng gợi ý đã được chọn sẵn',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Tự động';

  @override
  String get locationsSection => 'Vị trí';

  @override
  String get dnsSummaryOk => 'DNS mã hóa hoạt động tốt';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Không phân giải được $count tên miền',
      one: 'Không phân giải được 1 tên miền',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'qua $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'DNS của mạng bạn trả về địa chỉ bị lọc cho $count tên miền. Ứng dụng không dùng DNS đó cho các tên miền này.',
      one: 'DNS của mạng bạn trả về địa chỉ bị lọc cho 1 tên miền. Ứng dụng không dùng DNS đó cho tên miền này.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Kết quả:';

  @override
  String get dnsNetworkAnswer => 'DNS của mạng:';

  @override
  String get dnsFiltered => 'bị lọc';

  @override
  String get rulesSyntaxTitle => 'Mỗi dòng một quy tắc';

  @override
  String get ruleDomain => 'Trang web và các tên miền con';

  @override
  String get ruleFull => 'Đúng chính xác tên miền này';

  @override
  String get ruleKeyword => 'Tên miền chứa từ khóa này';

  @override
  String get ruleGeosite => 'Các trang của một thẻ trong tệp geo';

  @override
  String get ruleGeoip => 'Các địa chỉ của một quốc gia trong tệp geo';

  @override
  String get ruleIp => 'Một địa chỉ hoặc một mạng';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Chỉ proxy';

  @override
  String get noNetwork =>
      'Không có kết nối internet. Hãy bật Wi-Fi hoặc dữ liệu di động.';

  @override
  String get blockAds => 'Chặn quảng cáo';

  @override
  String systemProxyTakenBy(String address) {
    return 'Một chương trình khác đã đặt proxy hệ thống thành $address, nên lưu lượng không đi qua VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Một chương trình khác đã tắt proxy hệ thống, nên lưu lượng không đi qua VPN.';

  @override
  String get setSystemProxyAgain => 'Đặt lại';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Toàn bộ lưu lượng của $os đi qua VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting => 'Đang chờ cho phép cài đặt dịch vụ TUN…';

  @override
  String get tunInstallCancelled =>
      'Chế độ TUN cần quyền quản trị một lần. Quyền không được cấp nên chế độ không thay đổi.';

  @override
  String tunInstallFailed(String error) {
    return 'Không thể cài đặt dịch vụ TUN: $error';
  }

  @override
  String get tunStarting => 'Đang bật chế độ TUN…';

  @override
  String get tunFailed => 'Không bật được chế độ TUN. Đang thử lại…';

  @override
  String get tunLost => 'Chế độ TUN đã dừng bất ngờ. Đang thử lại…';

  @override
  String get tunNotRunning => 'Dịch vụ TUN không chạy. Đang thử lại…';

  @override
  String get tunMissing => 'Dịch vụ TUN chưa được cài đặt.';

  @override
  String get tunOutdated =>
      'Dịch vụ TUN cũ hơn ứng dụng này. Hãy cài đặt lại để dùng chế độ TUN.';

  @override
  String get tunAppOutdated =>
      'Dịch vụ TUN mới hơn ứng dụng này. Hãy cập nhật ứng dụng để dùng chế độ TUN.';

  @override
  String get tunBusy => 'Một bản Homa VPN khác đang dùng chế độ TUN.';

  @override
  String get tunNoDriver =>
      'Trình điều khiển TUN của hệ thống không khả dụng. Hãy khởi động lại máy tính rồi thử lại.';

  @override
  String get tunInstall => 'Cài đặt';

  @override
  String get tunInstallAgain => 'Cài đặt lại';

  @override
  String get trayTunMode => 'Chế độ TUN (mọi ứng dụng)';

  @override
  String get removeTunService => 'Gỡ dịch vụ TUN';

  @override
  String get removeTunServiceHint =>
      'Gỡ dịch vụ hệ thống mà chế độ TUN dùng. Chọn lại TUN sẽ cài đặt lại dịch vụ.';

  @override
  String get tunServiceRemoved => 'Đã gỡ dịch vụ TUN.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN muốn cài đặt dịch vụ cho chế độ TUN.';

  @override
  String get tunRemovePrompt => 'Homa VPN muốn gỡ dịch vụ của chế độ TUN.';

  @override
  String tunRemoveFailed(String error) {
    return 'Không thể gỡ dịch vụ TUN: $error';
  }

  @override
  String get sectionTun => 'Cài đặt TUN';

  @override
  String get tunPrograms => 'Chương trình không qua VPN';

  @override
  String get tunProgramsHint =>
      'Kết nối trực tiếp, không qua Mozilla. Chỉ dành cho chương trình chạy được mà không cần VPN.';

  @override
  String get tunProgramsEmpty => 'Chưa có chương trình nào.';

  @override
  String get addProgram => 'Thêm chương trình';

  @override
  String get programFiles => 'Chương trình';

  @override
  String get tunProgramAll => 'Mọi lưu lượng';

  @override
  String get tunProgramAllHint => 'Toàn bộ chương trình kết nối trực tiếp.';

  @override
  String get tunProgramUdp => 'Chỉ UDP';

  @override
  String get tunProgramUdpHint =>
      'Chỉ UDP của nó kết nối trực tiếp; phần còn lại qua VPN.';

  @override
  String get udpNoticeSetting => 'Thông báo UDP bị chặn';

  @override
  String udpNoticeBody(String program) {
    return 'Lưu lượng UDP của $program không đi qua VPN.';
  }

  @override
  String get dontShowAgain => 'Không hiện lại';

  @override
  String get addRunningProgram => 'Từ các chương trình đang chạy';

  @override
  String get addProgramFile => 'Chọn tệp…';

  @override
  String get addProgramName => 'Nhập tên…';

  @override
  String get programNameHint =>
      'Tên tệp của chương trình, ví dụ steam.exe; * nghĩa là văn bản bất kỳ (steam* là mọi chương trình của Steam).';

  @override
  String get runningProgramsEmpty =>
      'Không có chương trình nào khác đang chạy.';

  @override
  String get tabLog => 'Nhật ký';

  @override
  String get tabConnections => 'Kết nối';

  @override
  String get connectionsEmpty => 'Chưa có kết nối nào.';

  @override
  String connectionsOpen(int count) {
    return '$count đang mở';
  }

  @override
  String get connTime => 'Thời gian';

  @override
  String get connRoute => 'Quy tắc';

  @override
  String get connDestination => 'Đích';

  @override
  String get connInbound => 'Đầu vào';

  @override
  String get connProtocol => 'Giao thức';

  @override
  String get connColumns => 'Cột';

  @override
  String get connTraffic => 'Lưu lượng';

  @override
  String get connDuration => 'Thời lượng';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Trực tiếp';

  @override
  String get connRouteBlocked => 'Bị chặn';

  @override
  String get connRoutePort => 'Cổng bị từ chối';

  @override
  String get connRouteFailed => 'Thất bại';

  @override
  String get testRelay => 'Kiểm tra relay';

  @override
  String get relayTestTitle => 'Kiểm tra tình trạng relay';

  @override
  String get relayTestHint =>
      'Chỉ kiểm tra relay. Không gửi yêu cầu tới Mozilla hoặc thông tin tài khoản.';

  @override
  String get relayTestPassed => 'Relay đã sẵn sàng';

  @override
  String get relayTestFailed => 'Không thể xác nhận tình trạng relay';

  @override
  String get relayTestCopy => 'Sao chép báo cáo';

  @override
  String get relayTestInterrupted =>
      'Kiểm tra kết thúc trước khi nhận được kết quả đầy đủ.';

  @override
  String get searchLocations => 'Tìm vị trí';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vị trí',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Tự động cập nhật';

  @override
  String get autoInstallApkHint =>
      'Các phiên bản mới tự tải về; trình cài đặt sẽ hỏi trước khi cài.';

  @override
  String get installNow => 'Cài đặt';

  @override
  String get updateAllowInstall =>
      'Để cài đặt bản cập nhật, hãy cho phép ứng dụng này cài đặt ứng dụng.';

  @override
  String get allowInstall => 'Cho phép';

  @override
  String get noResults => 'Không có vị trí nào khớp với tìm kiếm.';

  @override
  String get accentColor => 'Màu nhấn';

  @override
  String get accentMono => 'Đơn sắc (mặc định)';

  @override
  String get accentCustom => 'Màu tùy chọn';

  @override
  String get accentEmber => 'Hồng than';

  @override
  String get accentGold => 'Vàng';

  @override
  String get accentEmerald => 'Lục bảo';

  @override
  String get accentSapphire => 'Xa phi';

  @override
  String get accentAmethyst => 'Thạch anh tím';

  @override
  String get accentRose => 'Hồng';

  @override
  String get autoReconnect => 'Tự động kết nối lại';

  @override
  String get autoReconnectHint =>
      'Tự kết nối lại khi kết nối bị đứt mà không phải do bạn.';

  @override
  String get androidOnlyHint => 'Chỉ trên điện thoại.';

  @override
  String get idleDisconnect => 'Ngắt khi không hoạt động';

  @override
  String get idleDisconnectHint =>
      'Kết thúc phiên khi một lúc không có lưu lượng nào.';

  @override
  String get idleTimeout => 'Thời gian chờ';

  @override
  String get minutes5 => '5 phút';

  @override
  String get minutes10 => '10 phút';

  @override
  String get minutes15 => '15 phút';

  @override
  String get minutes30 => '30 phút';

  @override
  String get minutes60 => '1 giờ';

  @override
  String get dataLimit => 'Giới hạn dữ liệu phiên';

  @override
  String get dataLimitHint => 'Kết thúc phiên khi lưu lượng đạt tới giới hạn.';

  @override
  String get dataLimitAmount => 'Giới hạn';

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
    return 'Không có lưu lượng trong $minutes phút nên kết nối đã bị ngắt.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'Phiên đã đạt giới hạn $mb MB nên kết nối đã bị ngắt.';
  }

  @override
  String get protection => 'Bảo vệ';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Nếu VPN đứt, lưu lượng bị giữ lại — không rò rỉ — cho đến khi kết nối lại.';

  @override
  String get alwaysOnVpn => 'VPN luôn bật';

  @override
  String get alwaysOnVpnHint =>
      'Vệ sĩ của Android: không kết nối nào đi qua nếu không có VPN.';

  @override
  String get floatingIsland => 'Đảo nổi';

  @override
  String get floatingIslandHint =>
      'Hiển thị trạng thái kết nối trên các ứng dụng khác khi bạn rời ứng dụng.';

  @override
  String whatsNewTitle(String version) {
    return 'Có gì mới trong phiên bản $version';
  }

  @override
  String get whatsNewContinue => 'Đã hiểu';

  @override
  String get whatsNewMenu => 'Có gì mới';

  @override
  String get whatsNewView => 'Xem lại';

  @override
  String get updateServers => 'Cập nhật máy chủ';

  @override
  String get updatingServers => 'Đang cập nhật…';

  @override
  String serversUpdated(int count) {
    return '$count vị trí từ danh sách chính thức của Mozilla';
  }

  @override
  String get serversUpdateFailed =>
      'Không thể cập nhật danh sách máy chủ; giữ nguyên danh sách cũ.';

  @override
  String get smartPickTitle => 'Nhanh nhất hiện tại';

  @override
  String get smartPickUse => 'Dùng';

  @override
  String get connectAtBoot => 'Kết nối sau khi bật điện thoại';

  @override
  String get connectAtBootHint =>
      'Tự kết nối khi mở máy, nếu quyền VPN đã được cấp.';

  @override
  String get gamingProfile => 'Hồ sơ gaming';

  @override
  String get gamingProfileHint =>
      'Hiện độ trễ và chất lượng kết nối trực tiếp; ghép với máy chủ đo được nhanh nhất.';

  @override
  String get diagnosticsRun => 'Chạy chẩn đoán';

  @override
  String get diagnosticsHint =>
      'Kết nối, DNS và đường hầm, kiểm tra trong một chạm';

  @override
  String get diagnosticsTunnel => 'Đường hầm';

  @override
  String get diagnosticsTunnelUp => 'Đang chạy và mang lưu lượng';

  @override
  String get diagnosticsTunnelDown => 'Đã dừng';

  @override
  String get diagnosticsExit => 'Quốc gia xuất phát';

  @override
  String get diagnosticsMismatch => 'Nơi ra khác với lựa chọn';

  @override
  String get diagnosticsConnection => 'Kiểm tra kết nối';

  @override
  String get diagnosticsPassed => 'Đạt';

  @override
  String get diagnosticsFailed => 'Thất bại';

  @override
  String get diagnosticsDnsFiltered => 'Câu trả lời bị chặn hoặc lọc';

  @override
  String get diagnosticsDnsOk => 'Đã trả lời';

  @override
  String get diagnosticsPrivacy =>
      'Không có gì được lưu ở đây; kết quả chỉ ở trong cửa sổ này và nhật ký riêng của nhân.';

  @override
  String get diagnosticsAgain => 'Chạy lại';

  @override
  String get whatsNewAdded => 'Mới';

  @override
  String get whatsNewImproved => 'Cải thiện';

  @override
  String get whatsNewFixed => 'Đã sửa';

  @override
  String get wnWheelImproved =>
      'Bánh xe quốc gia được vẽ lại: cờ được chọn lớn hơn trong khung kính với vầng sáng tinh tế và quầng sáng mềm phía sau, các cờ khác nhỏ hơn có chiều sâu, tên bên dưới trượt vào nhẹ nhàng.';

  @override
  String get wnLiveImproved =>
      'Khi đang kết nối, thông báo xin Android 16 thăng cấp nó thành Live Update như bản triển khai tham chiếu; thời gian tự đếm, tốc độ vẫn chạy.';

  @override
  String get wnL10nFixed =>
      'Trang này giờ nói theo ngôn ngữ của ứng dụng — đủ mười lăm ngôn ngữ, không chỉ tiếng Anh.';

  @override
  String get wnMarkFixed =>
      'Dấu hiệu của Mozilla hiển thị sạch sẽ trên ô của nó, bo tròn như các lá cờ.';

  @override
  String get designTitle => 'Thiết kế trang chính';

  @override
  String get designHint => 'Trang chính được bố trí ra sao';

  @override
  String get designWheel => 'Vòng xoay';

  @override
  String get designWheelDesc => 'Lá cờ trên vòng kính, công tắc bên dưới';

  @override
  String get designBento => 'Bento';

  @override
  String get designBentoDesc =>
      'Thiết kế riêng của hộp bento: cờ trên bảng ô của chúng, ô kết nối, số liệu và địa điểm như những ô của một hộp ấm áp';

  @override
  String get designPixel => 'Material You';

  @override
  String get designPixelDesc =>
      'Material You: bề mặt tông màu, thẻ lớn đặc, thanh chỉ dẫn viên nang và tiêu đề lớn — giọng riêng của Android';

  @override
  String get notifFlag => 'Cờ nước trong thông báo';

  @override
  String get notifFlagHint => 'Cờ của chính nước đó bên cạnh tên';

  @override
  String get wnDesignAdded =>
      'Cài đặt thiết kế trang chính: vòng xoay, ô lát hay thẻ gọn';

  @override
  String get wnMapAdded =>
      'Bản đồ thế giới vector thật sau trang chính, quốc gia đã chọn sáng lên';

  @override
  String get wnWheelAdded =>
      'Vòng cờ vẽ lại: kính sâu hơn, chuyển động mượt hơn';

  @override
  String get wnFlagNotifAdded =>
      'Thông báo có thể hiện cờ SVG của nước, và có thể tắt';

  @override
  String get wnColorRemoved =>
      'Trang màu tuỳ chọn đã được bỏ; danh sách nhấn vẫn giữ mã HEX';

  @override
  String get whatsNewRemoved => 'Đã bỏ';

  @override
  String get wnCrashFixed =>
      'Ứng dụng không còn tự dừng trên máy Android 16: thông báo đã yêu cầu hệ thống điều máy chưa có.';

  @override
  String get wnFlagArtFixed =>
      'Ứng dụng không còn tự đẩy mình ra khi mở: hình cờ của thông báo trả về một giá trị mà bộ phận nhắn tin của hệ thống không chấp nhận.';

  @override
  String get statSession => 'Phiên';

  @override
  String get copiedToClipboard => 'Đã sao chép vào bộ nhớ tạm';

  @override
  String get wnTotalsAdded =>
      'Trang chủ cho thấy tổng dữ liệu phiên đã truyền, và một chạm sao chép IP công khai.';

  @override
  String get wnPolishImproved =>
      'Bánh xe cờ và trang máy chủ gọn gàng hơn; chữ ngắn gọn, và đường hầm Android truyền lưu lượng nhanh hơn.';

  @override
  String get valueSmart => 'Thông minh';

  @override
  String get wnSmartAdded =>
      'Kết nối thông minh: MTU, giao thức và phiên bản IP theo mạng, được chọn từ phản hồi thật để có tốc độ.';

  @override
  String get wnToastAdded =>
      'Xác nhận giờ đến như một ghi chú mềm mại kiểu iOS, với dấu vẽ chính mình.';

  @override
  String get wnFlagsImproved =>
      'Bánh xe cờ gọn gàng: không còn cờ bị cắt ở mép màn hình, cờ hiển thị trọn vẹn, và lựa chọn đáp xuống nhẹ nhàng.';

  @override
  String get wnMapImproved =>
      'Bản đồ thế giới được vẽ lớn và rõ hơn: không còn lục địa bị nén, bờ biển mượt, và quầng sáng tại điểm neo.';

  @override
  String get dnsManual => 'DNS thủ công';

  @override
  String get dnsManualHint =>
      'Mỗi dòng một địa chỉ: IP thường, https:// (DNS over HTTPS), hoặc tls://host (DNS over TLS). Ai trả lời trước thắng.';

  @override
  String get dnsManualInvalid =>
      'Một dòng không phải địa chỉ phần lõi dùng được: IP thường, https://…, hoặc tls://host.';

  @override
  String get killSwitchGuarded =>
      'Được canh giữ: không gì rời điện thoại trong khi đường hầm ngắt.';

  @override
  String get accountsUsageTitle => 'Tháng này';

  @override
  String get accountsCountLabel => 'tài khoản';

  @override
  String get accountsUsageAverage =>
      'phần trăm dùng trung bình của các tài khoản';

  @override
  String get wnDesignsAdded =>
      'Thiết kế ứng dụng: cả ứng dụng có thể khoác Neumorphism mềm hoặc Kính quang cực — mọi trang, mọi thẻ — trong Cài đặt → Chung.';

  @override
  String get wnWheelFixed =>
      'Nửa lá cờ ở bánh xe đã mất: giá dưới lá cờ được chọn là vũng sáng, không phải lá cờ thứ hai, và không cờ nào bị cắt ở mép màn hình.';

  @override
  String get wnMapReal =>
      'Bản đồ thế giới được vẽ lại từ biên giới chính thức của các nước — mọi bờ biển, hòn đảo và vùng bao vây, đúng xác và đúng tỉ lệ.';

  @override
  String get wnGlobeAdded =>
      'Thế giới giờ là quả cầu: khối cầu bạc xoay về phía quốc gia đã chọn, ghim phát sáng và thẻ nổi đánh dấu nó, đường kết nối vươn tới các trung tâm.';

  @override
  String get wnWheelGlowImproved =>
      'Cờ được chọn đứng to hơn trong khung kính với quầng sáng xanh riêng, các lá cờ bên cạnh nhỏ hơn rõ rệt, và các điểm chỉ dưới vòng xoay cho biết bạn đang ở đâu.';

  @override
  String get wnDesignsRemoved =>
      'Bộ chọn Thiết kế ứng dụng đã được gỡ bỏ: ứng dụng trở lại diện mạo đơn sắc vốn có — màu nhấn và chủ đề của bạn giữ nguyên.';

  @override
  String get wnDnsAdded =>
      'DNS thủ công: IP thường, DNS over HTTPS và DNS over TLS — loại của từng dòng hiển thị và được kiểm tra khi gõ.';

  @override
  String get wnSmartImproved =>
      'Kết nối thông minh giờ cho thấy mạng đã trả lời gì: phương tiện vận chuyển đã chọn và phiên bản IP đã giữ, trực tiếp.';

  @override
  String get wnProtectionImproved =>
      'Công tắc ngắt báo khi lính gác đứng gác, và trang ứng dụng cho biết bạn đã chọn bao nhiêu ứng dụng.';

  @override
  String get wnWelcomeImproved =>
      'Trang chào mừng mở ra với chiếc khiên đang thở trên vầng quang cực trôi, và trang tài khoản gói cả tháng trong một cái nhìn.';

  @override
  String bypassAppsCount(String n) {
    return 'Đã chọn: $n';
  }

  @override
  String get sectionAppearance => 'Diện mạo';

  @override
  String get mapStyle => 'Kiểu bản đồ';

  @override
  String get mapStyleHint =>
      'Quả cầu ở trang chủ được tô theo cách bạn chọn. Ánh sáng kết nối vẫn như cũ.';

  @override
  String get mapSilver => 'Bạc';

  @override
  String get mapMidnight => 'Nửa đêm';

  @override
  String get mapOcean => 'Đại dương';

  @override
  String get mapMono => 'Đơn sắc';

  @override
  String get mapAurora => 'Cực quang';

  @override
  String get batterySaver => 'Tiết kiệm pin';

  @override
  String get batterySaverHint =>
      'Đưa chuyển động của bản đồ vào nghỉ khi đang kết nối — nhịp thở của quả cầu, ánh sáng của bánh xe. Kết nối vẫn nguyên như cũ.';

  @override
  String get connectOnOpen => 'Kết nối khi mở ứng dụng';

  @override
  String get connectOnOpenHint =>
      'Bật VPN ngay khi mở ứng dụng, với vị trí bạn chọn lần cuối.';

  @override
  String get speedTitle => 'Tốc độ';

  @override
  String get parallelTunnels => 'Đường hầm song song';

  @override
  String get parallelTunnelsHint =>
      'Mở cùng lúc nhiều đường hầm tới Mozilla và chia lưu lượng giữa chúng, để một đường hầm chậm không còn chặn tốc độ. Tám là mức nặng nhất cho pin.';

  @override
  String get tunnels1 => 'Một — ổn định nhất';

  @override
  String get tunnels2 => 'Hai';

  @override
  String get tunnels4 => 'Bốn — nhanh hơn trên mạng chậm';

  @override
  String get tunnels8 => 'Tám — nhanh nhất';

  @override
  String get connectionCap => 'Giới hạn kết nối';

  @override
  String get connectionCapHint =>
      'Bao nhiêu ứng dụng có thể nói qua VPN cùng lúc; giới hạn nhỏ hơn tiết kiệm pin và dữ liệu trên điện thoại bận rộn. Mặc định là không giới hạn.';

  @override
  String get capNone => 'Không giới hạn';

  @override
  String get verboseLogging => 'Chẩn đoán chi tiết';

  @override
  String get verboseLoggingHint =>
      'Ghi từng bước vào nhật ký — hữu ích khi báo lỗi, hơi tốn pin hơn.';

  @override
  String get wn38MapStylesAdded =>
      'Năm kiểu cho bản đồ: bạc, nửa đêm, đại dương, đơn sắc và cực quang — trang Diện mạo mới trong cài đặt chọn, có xem trước từng kiểu.';

  @override
  String get wn38ZoomAdded =>
      'Bản đồ có thể phóng to: kẹp hai ngón tay, hoặc chạm đôi để lại gần rồi quay lại.';

  @override
  String get wn38OptionsAdded =>
      'Tùy chọn thực dụng: đường hầm song song cho tốc độ cao hơn, giới hạn kết nối, tiết kiệm pin, kết nối khi mở ứng dụng và chẩn đoán chi tiết.';

  @override
  String get wn38SocialAdded =>
      'Instagram và Telegram giờ cũng ở ngay cuối trang này.';

  @override
  String get wn38FlightImproved =>
      'Chọn một quốc gia là một chuyến bay nhỏ: camera lùi lại, quả cầu xoay, ghim rơi xuống nảy nhẹ và các đường nối tự vẽ tới các trung tâm.';

  @override
  String get wn38EffectsImproved =>
      'Bản đồ nhìn giàu hơn: những ngôi sao sau quả cầu, lưới tọa độ, ánh sáng của các trung tâm, quầng sáng quanh viền và bóng của đất liền.';

  @override
  String get wn38SpeedImproved =>
      'Tùy chọn tốc độ là thật: đường hầm song song mở nhiều kết nối cùng lúc, và lõi chia lưu lượng giữa chúng.';

  @override
  String get wn38NameFixed =>
      'Tên quốc gia đã chọn chỉ hiện một lần — trên thẻ nổi của bản đồ; bản sao dưới các lá cờ đã được bỏ.';

  @override
  String get mapKind => 'Kiểu bản đồ';

  @override
  String get mapKindHint =>
      'Thế giới của trang chủ hiển thị thế nào: bản đồ phẳng như trước (mặc định), bản đồ hiện đại, Trái Đất ban đêm, Trái Đất địa hình, quả cầu kim loại, hay Trái Đất vệ tinh. Ở mỗi kiểu, biên giới đều là biên giới thật, chính thức.';

  @override
  String get mapKindClassic => 'Cổ điển';

  @override
  String get mapKindGlobe => 'Globe 3D';

  @override
  String get mapKindSatellite => 'Vệ tinh';

  @override
  String get mapKindFlat => 'Phẳng 2D';

  @override
  String get mapKindHud => 'Radar';

  @override
  String get mapStyleGlobeHint =>
      'Màu sắc của globe 3D. Vệ tinh mang Trái Đất riêng của nó, còn bản đồ phẳng mang mực riêng của nó.';

  @override
  String get aboutVersions => 'Phiên bản';

  @override
  String get aboutChannels => 'Trang liên hệ';

  @override
  String get checkUpdatesHint =>
      'Tìm phiên bản mới hơn; phiên bản tìm thấy sẽ được tải xuống và trình cài đặt sẽ hỏi.';

  @override
  String get speedTestTitle => 'Kiểm tra tốc độ';

  @override
  String get speedTestRun => 'Đo';

  @override
  String get speedTestFailed => 'Việc đo chưa xong.';

  @override
  String get speedTestThrough => 'Đo qua đường hầm.';

  @override
  String get speedTestDirect => 'Đo trực tiếp (proxy đang tắt).';

  @override
  String get speedTestHint =>
      'Một lượt tải và một lượt tải lên qua hầm cho biết nó thực sự mang được gì. Biểu đồ ở trang chủ cũng mở màn này.';

  @override
  String get speedGraphHint => 'Phút vừa qua của hầm · chạm để đo';

  @override
  String get favoritePinned => 'Đã ghim. Chạm giữ lâu lần nữa để bỏ ghim.';

  @override
  String get favoriteUnpinned => 'Đã bỏ ghim.';

  @override
  String get shareReport => 'Chia sẻ báo cáo';

  @override
  String get shareReportCopied => 'Báo cáo đã nằm trên bảng nhớ tạm.';

  @override
  String get batteryWizardTitle => 'Sống sót với pin';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei và tương tự giết ứng dụng VPN sau khi màn hình khóa. Đưa ứng dụng này ra khỏi tối ưu pin để hầm vẫn sáng.';

  @override
  String get batteryWizardSteps =>
      'Trong cài đặt của hãng, cũng cho tự khởi động và để ứng dụng ở Không giới hạn (Xiaomi), bỏ khỏi Ứng dụng đang ngủ (Samsung) hoặc Khởi động thủ công (Huawei).';

  @override
  String get batteryWizardState => 'Tối ưu pin có thể dừng đường hầm.';

  @override
  String get batteryWizardPermit => 'Cho phép';

  @override
  String get batteryWizardOk => 'Hầm được bảo vệ khỏi pin.';

  @override
  String get batteryWizardOpen => 'Cài đặt pin';

  @override
  String get usageTitle => 'Sử dụng theo ứng dụng';

  @override
  String get usageRowHint => 'Mỗi ứng dụng đã dùng bao nhiêu';

  @override
  String get usageGrant => 'Mở quyền truy cập sử dụng';

  @override
  String get usageGrantHint =>
      'Android giữ mức dùng dữ liệu từng ứng dụng sau quyền truy cập sử dụng. Trang mà nút mở là của hệ thống; ứng dụng chỉ đọc số.';

  @override
  String get usageEmpty => 'Không có mức dùng nào trong khoảng này.';

  @override
  String get usageToday => 'Hôm nay';

  @override
  String get usageWeek => '7 ngày vừa qua';

  @override
  String get usageMonth => '30 ngày vừa qua';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'Ứng dụng được cài đặt bên ngoài Google Play, nên Play Protect có thể yêu cầu quét khi cài lần đầu. Nhấn \"Quét ứng dụng\" một lần — lần quét sạch sẽ được ghi nhớ, và các bản cập nhật sau đó cài đặt không cần câu hỏi này.';

  @override
  String get smartLocation => 'Vị trí nhanh nhất';

  @override
  String get smartLocationHint =>
      'Mỗi lần kết nối chọn máy chủ mà phép đo trễ của lõi cho là nhanh nhất.';

  @override
  String get quicPass => 'Đi qua QUIC';

  @override
  String get quicPassHint =>
      'QUIC của ứng dụng (UDP 443) đi qua đường hầm: cuộc gọi và trò chơi giữ tốc độ thay vì rơi về TCP.';

  @override
  String get accountRename => 'Đổi tên tài khoản';

  @override
  String get accountRenameLabel => 'Tên tài khoản';

  @override
  String get accountProfile => 'Ảnh đại diện';

  @override
  String get avatarReset => 'Quay lại dấu đơn giản';

  @override
  String get accountSecurity => 'Mật khẩu ứng dụng';

  @override
  String get appPasswordOn => 'Ứng dụng mở sau một mật khẩu.';

  @override
  String get appPasswordOff =>
      'Không có mật khẩu: ai mở ứng dụng cũng vào được.';

  @override
  String get appPasswordSet => 'Đặt mật khẩu';

  @override
  String get appPasswordChange => 'Đổi mật khẩu';

  @override
  String get appPasswordRemove => 'Xoá mật khẩu';

  @override
  String get appPasswordCurrent => 'Mật khẩu hiện tại';

  @override
  String get appPasswordNew => 'Mật khẩu mới (4+ ký tự)';

  @override
  String get appPasswordConfirm => 'Nhập lại mật khẩu mới';

  @override
  String get appPasswordShort => 'Ít nhất 4 ký tự.';

  @override
  String get appPasswordMismatch => 'Hai mật khẩu không giống nhau.';

  @override
  String get appPasswordWrong => 'Sai mật khẩu';

  @override
  String get appPasswordSetDone =>
      'Mật khẩu đã đặt — ứng dụng sẽ hỏi từ lần mở sau.';

  @override
  String get appPasswordRemoved => 'Mật khẩu đã bỏ; ứng dụng mở tự do.';

  @override
  String get appPasswordUnlock => 'Ứng dụng đang khóa';

  @override
  String get appPasswordUnlockHint => 'Nhập mật khẩu ứng dụng để tiếp tục.';

  @override
  String get wn39MapKinds =>
      'Bản đồ lại có các kiểu: bản đồ phẳng như trước (mặc định), globe 3D, Trái Đất vệ tinh và bản đồ 2D hiện đại.';

  @override
  String get wn39EyeIp =>
      'Thẻ vị trí có một con mắt: chạm để xem địa chỉ ra của lưu lượng và sao chép.';

  @override
  String get wn39Profile =>
      'Tài khoản có tên và ảnh đại diện riêng, và ứng dụng có thể mở sau mật khẩu.';

  @override
  String get wn39Smart =>
      'Kết nối thông minh hoàn thiện hơn: vị trí nhanh nhất theo độ trễ thực và đường QUIC cho gọi điện, chơi game.';

  @override
  String get wn39Flight =>
      'Đổi quốc gia bay mượt hơn — camera đi theo vòng lớn — và các điểm trên vòng cờ sát vào lá cờ hơn.';

  @override
  String get wn39ToastEverywhere =>
      'Thông báo động giờ ở khắp nơi: mỗi lần lưu, sao chép hay lỗi đều mang viên thuốc kính động ấy.';

  @override
  String get wn39Updates =>
      'Bản cập nhật giữ bộ nhớ sạch: trình cài đặt thay phiên cũ và không để lại gói nào.';

  @override
  String get mapKindNight => 'Đêm';

  @override
  String get mapKindTerrain => 'Địa hình';

  @override
  String get wn40MapKindsNew =>
      'Hai diện mạo mới của bản đồ: Trái Đất ban đêm và Trái Đất địa hình.';

  @override
  String get wn40Flight =>
      'Globe 3D bay sang quốc gia mới bằng một vòng quay mượt mà — không bao giờ giật cục.';

  @override
  String get wn40Mercator =>
      'Bản đồ phẳng vẽ theo phép chiếu Mercator chuẩn: tỷ lệ thật, biên giới chuẩn, không bị nén ép.';

  @override
  String get wn40NameBack =>
      'Tên quốc gia đã chọn trở lại bên dưới các lá cờ trên bản đồ phẳng.';

  @override
  String get wn40Speed =>
      'Đường hầm giờ mở mặc định hai phiên song song — kết nối mạnh hơn, ổn định hơn.';

  @override
  String get wn40LockFixed =>
      'Ổ khóa trên nút kết nối không còn nhấp nháy giữa các trạng thái.';

  @override
  String get wn40IpRemoved => 'Cửa sổ IP trên thẻ vị trí đã được bỏ.';

  @override
  String get soundFeedback => 'Hiệu ứng âm thanh';

  @override
  String get soundFeedbackHint =>
      'Âm thanh nhẹ nhàng khi chạm, khi gạt công tắc và khi kết nối bật hoặc tắt';

  @override
  String get rateUnit => 'Đơn vị tốc độ';

  @override
  String get lockInBackground => 'Khoá khi rời đi';

  @override
  String get lockBgNever => 'Không bao giờ';

  @override
  String get lockBgNow => 'Ngay lập tức';

  @override
  String get lockBgMin5 => 'Sau 5 phút';

  @override
  String get lockBgMin15 => 'Sau 15 phút';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound =>
      'Âm thanh kết nối tham gia cùng rung: VPN kêu một nốt ngắn khi bật hoặc tắt (Cài đặt → Chung).';

  @override
  String get wn41RateUnit =>
      'Tốc độ hiển thị theo đơn vị bạn chọn: KB/s thân thuộc hay Mbps của kết nối.';

  @override
  String get wn41BackgroundLock =>
      'Ứng dụng có thể tự khoá khi bạn vắng mặt: mật khẩu được hỏi lại ngay, sau 5 hoặc sau 15 phút.';

  @override
  String get wn41BiggerLimits =>
      'Giới hạn dữ liệu của phiên nâng lên 25, 50 hoặc 100 GB.';

  @override
  String get wn41Motion =>
      'Chuyển động mới: quả cầu đang kết nối thở, dấu tích tự vẽ chính nó, từ trạng thái trượt giữa các giá trị, và mật khẩu sai làm rung ô nhập.';

  @override
  String get wn41AboutFixed =>
      'Trang Giới thiệu gọn gàng: hai trang nằm cạnh nhau, mỗi chú thích trên dòng riêng, không bị nén.';

  @override
  String get wn41HapticFixed =>
      'Cài đặt rung lại hoạt động: mỗi lần kết nối bật hay tắt đều theo nó, không chỉ con trượt.';

  @override
  String get copyIp => 'Sao chép IP';

  @override
  String get wn42Fonts =>
      'Mọi ngôn ngữ đều đọc bằng phông chữ riêng của ứng dụng: Noto Sans cho hai tiếng Trung và tiếng Bengal, Inter cho các ngôn ngữ Latinh và Kiryl — không còn ngôn ngữ nào dựa vào phông chữ của điện thoại.';

  @override
  String get wn42Sounds =>
      'Âm thanh của ứng dụng giờ đây có thật: một cú chạm nhẹ ở mỗi phần, hai nốt cho công tắc, một nốt lên xuống khi kết nối bật và tắt, một tiếng ping cho khoá — công tắc âm thanh kiểm soát tất cả.';

  @override
  String get wn42AboutFixed =>
      'Trang Giới thiệu đặt logo, tên và ghi chú vào giữa, và các định danh liên lạc luôn nguyên vẹn trên một dòng bất kể bề rộng điện thoại.';

  @override
  String get wn42Gaming =>
      'Hồ sơ chơi game giờ có thật: trang máy chủ đo lại độ trễ mỗi nửa phút và nêu bật máy nhanh nhất đã đo bằng màu nhấn.';

  @override
  String get avatarPhoto => 'Ảnh của bạn';

  @override
  String get avatarPhotoFailed => 'Không thể dùng ảnh đó';

  @override
  String get tlsFragmentAuto => 'Tự động';

  @override
  String get tlsFragmentAutoHint =>
      'Gửi trọn lời chào trước; mạng cứ cắt TLS sẽ tự cắt tên trong nửa giờ';

  @override
  String get accentDesign => 'Ánh sáng riêng của thiết kế';

  @override
  String get wn45Designs =>
      'Bốn diện mạo mới cho trang chủ — Aurora, Neon, Hoàng hôn và Xô thơm — mỗi cái khoác cho mọi trang một bảng màu riêng';

  @override
  String get wn45HelloAuto =>
      'Bộ phân mảnh TLS đã học: mạng cứ giết bắt tay sẽ tự cắt tên, và đường hầm đi qua được';

  @override
  String get wn45RelayRace =>
      'Phục hồi trung chuyển giờ thử ba biên cùng lúc, mạng bị lọc sớm tìm lại đường của nó';

  @override
  String get wn45AccentFixed =>
      'Bộ chọn màu lại thắp sáng ứng dụng — màu của nó đã không còn tới được các trang';

  @override
  String get wn45WhatsNewFixed =>
      'Trang «Có gì mới» lại hiển thị lời của nó — trước đây mở ra trống trơn';

  @override
  String get wn46Designs =>
      'Hai diện mạo mới từ thiết kế tham chiếu: thẻ trạng thái iOS của aether và quả cầu chuyển sắc của zed — mỗi cái khoác lên toàn bộ ứng dụng, và bốn diện mạo cũ đã ra đi.';

  @override
  String get wn46Sounds =>
      'Âm thanh có bộ chuyên nghiệp: sóng mềm cho kết nối bắt đầu, hợp âm khi thông suốt, giai điệu đi xuống khi ngắt và nốt trầm cho lối bị chặn — mỗi lúc một tiếng.';

  @override
  String get wn47Designs =>
      'Hai giao diện tham chiếu giờ khoác lên toàn bộ ứng dụng — mọi trang, không chỉ trang chủ: aether mang cấu trúc iOS của tham chiếu thứ nhất (thanh khểnh cong, các bảng nhóm, huy hiệu màu, màu trạng thái riêng của hệ thống), còn zed mang cấu trúc biểu cảm của tham chiếu thứ hai (dock nổi, thẻ rất tròn, bong bóng công cụ kéo được).';

  @override
  String get wn47Fixes =>
      'Một hàng cài đặt từng tràn màn hình hẹp nay đọc được đến hết.';

  @override
  String get wn48Bars =>
      'Thanh dưới của hai thiết kế đã về đúng chỗ: vòng tròn xanh của aether nằm trong khía của thẻ của nó, còn vòng tròn của zed không còn che cái tên phía dưới nữa.';

  @override
  String get wn48Fit =>
      'Các trang chủ lại vừa với màn hình của chúng: thẻ của aether đọc Disconnected đến tận cùng, quả cầu của zed lùi một bước khi trang chật, và khi kết nối đang diễn ra không có rãnh nào bảo trượt để kết nối, cũng không có gợi ý nào bảo ngắt kết nối cùng lúc.';

  @override
  String get wn48Wheel =>
      'Bánh xe cờ làm mờ một thẻ trước khi mép màn hình cắt đôi nó, địa điểm được đề xuất đeo dấu Mozilla ở cỡ đọc được, và mép nam của bản đồ phẳng tan vào trang thay vì kết thúc bằng một đường thẳng.';

  @override
  String get wn49States =>
      'Hai thiết kế tham chiếu khoác những chi tiết chúng được vẽ: thẻ của aether mang tốc độ của phiên như AetherST, nút nguồn thở theo quầng sáng của tham chiếu và lún xuống dưới ngón tay, còn bong bóng của zed biến hình giữa các dáng của nó, tâm nó chuyển qua lại bằng cross-fade.';

  @override
  String get wn49Words =>
      '“Đang kết nối” giờ có chữ ở khắp nơi: trong khi đường hầm đang dựng, rãnh của công tắc mang chữ Đang kết nối…, dấu núm mờ dần giữa các trạng thái, và rãnh thở theo nhịp của chính kết nối — chẳng gì biến mất dưới ngón tay.';

  @override
  String get wn49Sooner =>
      'Động cơ kết nối trở lại là của bản gốc: bể chuyển tiếp, các tuyến thay thế và bộ nhớ của chúng, và người gác yêu cầu lặp lại mang đường hầm — dựng lên sớm hơn và giữ vững.';

  @override
  String get wn49Mark =>
      'Vị trí đề xuất khoác dấu thật của Mozilla VPN, và các nút cập nhật mang ký tự cập nhật của riêng chúng.';

  @override
  String get wn50Notch =>
      'Trang phục của hai thiết kế thoát khỏi mớ lộn xộn nó từng giữ: thanh khểnh của aether đọc đúng tâm của chính vòng tròn, tên của thẻ được chọn khoác mực của trang ở cả hai giao diện, còn quầng sáng của vòng tròn ở lại với vòng tròn, không rửa trôi cái tên.';

  @override
  String get wn50Cards =>
      'Trang chủ của zed gấp tốc độ của nó vào bento: thẻ tốc độ gia nhập hai ô của bento và hàng phiên, những thẻ cuối trang nhường chỗ ngồi của dock, và chẳng gì còn nửa chừng dưới dock khi trang cuộn tới tận cùng.';

  @override
  String get wn50Veil =>
      'Dải trạng thái khoác tấm voan của nó: nội dung cuộn mờ dần dưới đồng hồ thay vì va vào nó, các trang zed đẩy ra không còn bắt đầu dưới đồng hồ, và những công cụ nổi giữ xa chỗ ngồi của dock.';

  @override
  String get wn50Ping =>
      'Viên chip ping của aether đo lại bằng một lần chạm, đúng cách viên chip của tham chiếu tự phản hồi.';

  @override
  String get tapToChangeServer => 'Chạm để đổi máy chủ';

  @override
  String get wn51Smooth =>
      'Bánh xe và dải cờ quay đúng cách một bánh xe phải quay: kéo và đổi quốc gia giờ đi trên bộ ghép — không gì sắp lại và không quầng sáng nào vẽ lại chính mình khi cờ quay; bánh xe quay mượt và trang cuộn theo nó.';

  @override
  String get wn51Zed =>
      'Trang chủ của zed khoác cấu trúc của chính tham chiếu: hai thẻ tốc độ đứng dưới thương hiệu (nghỉ ngơi ở số không của chúng khi đường hầm nghỉ), từ trạng thái đến bằng gương mặt lớn của display dưới bong bóng, còn địa điểm sống trên thẻ máy chủ sáng rực phía trên dock — viên chip nhỏ và cái tên lặp lại đã đi.';

  @override
  String get wn51Aether =>
      'Trang chủ của aether chỉ nói địa điểm một lần: dòng tên lặp lại của dải nghỉ ngơi, thẻ trạng thái và nút nguồn giữ ghế của chúng, và trang đọc như một cột sạch sẽ.';

  @override
  String get wn51Veil =>
      'Tấm voan của đồng hồ cao thêm một hơi thở và giữ màu của nó qua toàn dải đồng hồ: nội dung cuộn bên dưới mờ dần trọn vẹn, và lời của nó không bao giờ chạm tới đồng hồ.';

  @override
  String get wn52Speed =>
      'Đường hầm lại chạy với tốc độ riêng của mạng: giao diện VPN nói kích thước gói của đường truyền (MTU 1500) thay vì một kích thước phóng đại — bản tải về lấy lại tốc độ đầy đủ, cuộc gọi giữ vững, nhất là trên dữ liệu di động.';

  @override
  String get wn52Smart =>
      'Vị trí nhanh nhất và dịch vụ khuyên dùng chọn lại một cách trung thực: mỗi lần khởi động đều đo vị trí mới và lấy cái tốt nhất hiện nay — thay vì lặng lẽ cưỡi lên nơi đã chọn trước đó.';

  @override
  String get wn52Motion =>
      'Ba mươi hiệu ứng mới khắp ứng dụng: mỗi trang và thẻ đáp xuống nhẹ nhàng, ô được nhấn chìm xuống rồi trở lại, chấm trạng thái đang kết nối thở nhẹ, trang mở trượt vào êm ru — tất cả lặng khi hệ thống yêu cầu bớt chuyển động.';

  @override
  String get wn52Pages =>
      'Trang mở đến với một cú trượt mềm và tiêu đề từ cạnh của nó; khi một cài đặt được lưu, một đường kẻ êm chảy qua mục.';

  @override
  String get wn56Button =>
      'Thanh trượt kết nối giữ nguyên chữ của nó suốt hành trình — không còn khoảnh khắc trống giữa \'đang kết nối\' và \'đã kết nối\': chữ nay trượt mượt giữa các trạng thái, và độ mờ khi làm việc đến theo một nhịp thở.';

  @override
  String get wn56Capsule =>
      'Trang chính của bánh xe nói mỗi trạng thái một lần: chữ trạng thái lặp lại trên thanh trượt đã đi — chính đường ray mang nó, và trang đọc êm hơn một dòng.';

  @override
  String get wn56Door =>
      'Bài kiểm tra tốc độ có cửa riêng trên trang chính: một hàng, một chạm, và phép đo mở ra — cả trước lần kết nối đầu tiên, không chỉ khi đường hầm đang chạy.';

  @override
  String get wn56Wheel =>
      'Bánh xe cờ trượt mượt: một cú đẩy mang một quốc gia, và cú đáp nằm yên vào chỗ thay vì va đập — cú kéo đọc nặng và ổn như một núm xoay tốt.';

  @override
  String get designGazette => 'Tờ báo';

  @override
  String get designGazetteDesc =>
      'Trang nhất: đề mục, các cột kẻ dòng và con dấu mực — sự tĩnh lặng của tờ báo, bằng giấy và mực';

  @override
  String get speedTestSizesTitle => 'Cỡ bài kiểm tra';

  @override
  String get wn61Gta =>
      'Thiết kế GTA: HUD của trò chơi — bánh vũ khí cho cờ, đường hầm xanh radar, tấm panel hổ phách, chữ nặng và âm thanh riêng';

  @override
  String get wn61Sound =>
      'Tiếng tích của bánh xe: mỗi vị trí bánh xe đi qua cũng trả lời trong tai';

  @override
  String get wn62Wheel =>
      'Bánh xe vũ khí được dựng lại: các ghế giữ khoảng cách của trò chơi dù số quốc gia là bao nhiêu, cung đã chọn mang hình nêm sáng của bánh xe, và một cú hất làm bánh quay vọt';

  @override
  String get wn62Map =>
      'Bản đồ trang chủ nay mang màu riêng của từng thiết kế — nước, đất lục địa và lưới đi theo thiết kế của trang';

  @override
  String get wn62HudMap =>
      'Bản đồ riêng của thiết kế GTA: tấm HUD của trò chơi — nước sâu, bờ biển neon, lưới radar màu hổ phách và vệt quét đi khắp thế giới khi đường hầm đang chạy';

  @override
  String get wn62Aether =>
      'Nút nguồn của thiết kế Aether được dựng lại: đĩa đứng trong vòng mỏng, cung kết nối chạy quanh vòng, và mặt gia công bắt lấy ánh sáng';

  @override
  String get wn62Gta =>
      'Bảng kết nối GTA phản hồi tay — cả bảng lún nhẹ khi nhấn, và biểu tượng nguồn lùi lại trong khi đang kết nối';

  @override
  String get speedTestSizeLight => 'Nhẹ';

  @override
  String get speedTestSizeStandard => 'Tiêu chuẩn';

  @override
  String get speedTestSizeFull => 'Đầy đủ';

  @override
  String get speedTestJitter => 'Độ rung';

  @override
  String gazetteEdition(int n) {
    return 'Số $n';
  }

  @override
  String get gazetteBulletin => 'Bản tin an ninh';

  @override
  String get gazetteLiveWire => 'Tin trực tiếp';

  @override
  String get wn56Speed =>
      'Bài kiểm tra tốc độ sống lại: mỗi chiều đo trên kết nối riêng và nói HTTP/1.1 thuần, việc tải lên không còn chết khi cửa sổ tải xuống đóng — bảng thêm độ trễ đường đi, độ rung và cỡ để chọn.';

  @override
  String get wn56Gazette =>
      'Diện mạo trang chủ mới: tờ báo — trang nhất với đề mục, các cột kẻ dòng, băng tin trực tiếp và con dấu mực đóng xuống khi đường hầm chạy.';

  @override
  String get designIos => 'iOS';

  @override
  String get designIosDesc =>
      'Giọng của hệ thống: bảng nhóm, đường kẻ mảnh của thanh tab, thẻ trạng thái và nút viên nang — sáng rõ theo giọng hệ thống';

  @override
  String get gazetteSection => 'MỤC';

  @override
  String get wn58Lock =>
      'Ổ khóa trên nút giữ màu khi đường hầm chạy: dấu giờ đọc bề mặt mình đứng — đậm trên nút sáng, trắng trên nền đậm — biểu tượng không còn bị nhòa.';

  @override
  String get wn58Enter =>
      'Mục đã kết nối thở vào: các số mờ dần nâng lên khi không gian bên dưới mở ra, và ra đi cũng vậy — thẻ không còn bật lên giữa hai khung hình.';

  @override
  String get wn58Speed =>
      'Bài kiểm tra tốc độ chạy nhẹ hơn: bảng vẽ lại tối đa mười lần mỗi giây, kim quét đi trong đường thẳng ngắn, và các mặt chuyển mờ dần thay vì bật nhảy.';

  @override
  String get wn58Ios =>
      'Thiết kế mới: iOS — giọng của chính hệ thống, từ bảng nhóm và đường kẻ mảnh thanh tab đến thẻ trạng thái với nút viên nang. Mỗi trang, thẻ, hộp thoại và biểu tượng theo giọng hệ thống, ở cả hai chế độ.';

  @override
  String get wn58Pixel =>
      'Thiết kế mới: Pixel — giọng Material You, bề mặt tông màu, thẻ lớn đặc, thanh chỉ dẫn viên nang và tiêu đề lớn. Mỗi trang, thẻ, hộp thoại và biểu tượng theo giọng riêng của Android, ở cả hai chế độ.';

  @override
  String get wn58Paper =>
      'Tờ báo giờ là cả một tờ báo: thanh mục riêng với dấu in và gạch chân, đề mục cho từng trang mở riêng, và hộp giấy kẻ dòng cho từng nhóm cài đặt — đường in đã chạm tới toàn bộ ứng dụng.';

  @override
  String get wn59Flags =>
      'Cờ mang kiểu cắt riêng của từng thiết kế: huy chương tròn trên iOS và aether, squircle trên zed, tấm có đường kẻ trên gazette, góc tròn lớn dịu trên pixel — vòng, dải và lá cờ nhỏ ở mọi hàng đều theo vậy.';

  @override
  String get wn59Map =>
      'Bản đồ thế giới được vẽ bằng mực riêng của thiết kế: nâu ấm của giấy trên gazette, xám của đêm tím trên zed, xanh xám tông màu trên pixel — thế giới của mỗi thiết kế thuộc về trang của nó.';

  @override
  String get wn59Buttons =>
      'Nút kết nối nói bằng giọng thiết kế của nó: viên thuốc tông màu lớn của Material You trên pixel, vỏ iOS thở khi đang kết nối, và thẻ của mỗi trang bước vào bằng chuyển động riêng của thiết kế đó.';

  @override
  String get wn59Scroll =>
      'Vòng và dải cuộn bằng vật lý riêng của thiết kế: độ nảy của hệ thống, dừng nhanh của Material và trọng lượng giấy chết tại nếp gấp.';

  @override
  String get flagAllPlaces => 'Tất cả nơi';

  @override
  String get gazetteRegions => 'Điểm đến';

  @override
  String get wn60Flags =>
      'Mỗi thiết kế giờ hiển thị các quốc gia theo cách riêng: bảng ô của bento, chip lọc của pixel, tùy chọn nang của aether, bộ huy chương của iOS, bảng phân trang của zed, và mục lục điểm đến của gazette in như chính tờ báo — bánh xe giữ bánh xe của nó.';

  @override
  String get wn60Bento =>
      'Thiết kế bento đứng vẹn nguyên: bảng màu ấm riêng từ sứ và than, ánh quýt, dock ô, đầu trang squircle, thẻ tô màu và bảng cờ — từng trang, cả hai chế độ.';

  @override
  String get wn60Spacing =>
      'Các trang chủ đi trong một nhịp: dải chết giữa các mục đã biến mất, thẻ kết thúc lấp đầy hàng của nó, và mỗi khoảng trống thở theo khoảng cách thiết kế giữ.';

  @override
  String get wn63Retired =>
      'Các thiết kế aether và zed nghỉ hưu: người dùng chuyển sang các thiết kế mang cấu trúc của chúng — bảng của aether sang iOS, bento của zed sang Bento';

  @override
  String get wn63Map =>
      'Bản đồ GTA đọc như bản đồ của trò chơi: mỗi biên giới là một con đường, một điểm hổ phách trên mỗi quốc gia máy chủ, nơi chọn là waypoint với chùm sáng và tên trên tấm biển, la bàn ở góc';

  @override
  String get wn63Servers =>
      'Trang máy chủ mặc danh sách riêng của từng thiết kế — bảng nhóm của iOS, chỉ mục kẻ dòng của gazette, ô HUD của GTA, thẻ tông màu của pixel, bảng của bento';

  @override
  String get wn63Accounts =>
      'Trang tài khoản cũng mặc thiết kế: thẻ với bo tròn riêng của thiết kế, nút thêm với giọng thiết kế, tiêu đề hộp thoại với mặt hiển thị, ô nhập trong khung thiết kế';

  @override
  String get wn63Wheel =>
      'Bánh xe vũ khí dựng lại theo thước của trò chơi: vòng tròn đầy đủ các đường chia, mí sáng hai lớp, cung đồng hồ đếm, cú bật khi mở và nhịp của lựa chọn';

  @override
  String get wn63Ios =>
      'Thiết kế iOS đứng đầy hơn: lớp phủ trạng thái trên thẻ trạng thái, chấm trang của bộ bài huy chương, tích ở mỗi lần snap';

  @override
  String get wn64Wheel =>
      'Các huy chương của bánh xe GTA nay ngồi bên trong đĩa — mười hai chỗ theo nhịp của chính trò chơi, không huy chương nào trên vành hay vượt mép màn hình, và không huy chương nào chạm vào huy chương kế bên';

  @override
  String get wn64Glass =>
      'Bánh xe khoác lớp kính của trò chơi: thế giới mờ dần êm dưới mặt số, tấm kính hơi trong, ánh sắc của nó tụ lại phía trên';

  @override
  String get wn64Groups =>
      'Các nhóm riêng của trang chủ iOS: bảng của phiên — địa chỉ của đường hầm, một chạm vào clipboard — và các tác vụ nhanh: đo tốc độ, cài đặt kết nối, tài khoản';

  @override
  String get wn64Headers =>
      'Đầu trang của mọi trang lại trải rộng cả trang — mũi tên quay lại đứng ở mép, không ở giữa màn hình';

  @override
  String get wn64Pill =>
      'Nhãn viên Material You giữ hơi thở của mình trong phần tròn ở hai đầu';

  @override
  String get wn64Map =>
      'Biên giới của bản đồ GTA trở lại bộ áo đầu tiên — bờ biển giữ neon của nó, đất liền giữ viền mỏng như nét mực';

  @override
  String get wn64Name =>
      'Thiết kế Pixel nay đáp đúng tên của mình: Material You';

  @override
  String get wn65Gone =>
      'Thiết kế GTA đã ra đi: trang chủ, các trang và bảng màu của nó — năm thiết kế ở lại, và tệp cài đặt còn gọi tên nó sẽ rơi về bánh xe';

  @override
  String get wn65Tight =>
      'Trang chủ gọn gàng hơn trong mọi thiết kế: những dải trống mà phần màn hình dư mở giữa các thẻ đã biến mất — bánh xe, ô gạch, báo, huy chương và chip nối tiếp nhau cách nhau một hơi thở, và trang cuộn thay vì giãn ra';

  @override
  String get wn65Radar =>
      'Bản đồ mà thiết kế GTA mang theo giờ đứng dưới tên riêng: radar — cùng mặt nước sâu, lưới hổ phách và vệt quét, lần này với tên riêng của nó trong bộ chọn bản đồ';

  @override
  String get wn67Port =>
      'Thiết lập cổng kết nối ra đi: máy chủ chỉ trả lời trên cổng mà danh sách máy chủ trao cho chúng — áp đặt một cổng đã đóng mọi kết nối, và cấu hình nào còn mang nó sẽ bỏ nó ở lần khởi động đầu';

  @override
  String get wn67Back =>
      'Kết nối trở lại vị trí của nó — mọi thứ còn lại đứng nơi 1.0.65 đã để: năm thiết kế, bản đồ radar và đường hầm vững vàng';
}
