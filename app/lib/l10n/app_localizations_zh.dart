// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => '滑动以连接';

  @override
  String get slideToDisconnect => '滑动以断开';

  @override
  String get navOverview => '概览';

  @override
  String get navAccounts => '账户';

  @override
  String get navSettings => '设置';

  @override
  String get stateConnected => '已连接';

  @override
  String get stateConnecting => '正在连接…';

  @override
  String get stateWaiting => '等待中';

  @override
  String get waitingForAccount => '在“账户”页添加 Firefox 账户后即可连接。';

  @override
  String get waitingForEnabledAccount => '所有账户都已关闭。请在“账户”页启用一个。';

  @override
  String get stateError => '错误';

  @override
  String get stateUnknown => '未知';

  @override
  String get restartProxy => '重启代理';

  @override
  String copied(String value) {
    return '已复制 $value';
  }

  @override
  String get activeAccount => '当前账户';

  @override
  String get noActiveAccount => '暂无使用中的账户';

  @override
  String get quotaNotRead => '尚未获取流量信息';

  @override
  String get unlimited => '不限量';

  @override
  String usedOf(String used, String limit) {
    return '已用 $used / $limit';
  }

  @override
  String resets(String date) {
    return '$date 重置';
  }

  @override
  String switchAt(int percent) {
    return '流量用到 $percent% 时切换账户';
  }

  @override
  String get publicIp => '公网 IP';

  @override
  String get testConnection => '测试连接';

  @override
  String get testing => '正在测试…';

  @override
  String get testFailed => '失败';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int n) {
    return '$n 分钟前';
  }

  @override
  String hoursAgo(int n) {
    return '$n 小时前';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return '$time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d 天 $h 小时';
  }

  @override
  String durationHours(int h, int m) {
    return '$h 小时 $m 分';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m 分 $s 秒';
  }

  @override
  String durationSeconds(int s) {
    return '$s 秒';
  }

  @override
  String accountsGuide(String size) {
    return '每个 Firefox 账户每月有 $size 流量。你可以添加多个账户：一个用完后，应用会自动切换到下一个。';
  }

  @override
  String accountsOrderNote(int percent) {
    return '按此列表顺序使用：每个账户用到 $percent%，最后一个用到流量耗尽。';
  }

  @override
  String get addAccount => '添加账户';

  @override
  String lowQuotaNotice(String size) {
    return '此账户的流量快用完了。再添加一个账户，可再获得 $size。';
  }

  @override
  String get noAccounts => '还没有账户';

  @override
  String get noAccountsHint => '添加 Firefox 账户即可连接。';

  @override
  String get delayTestFailed => '无法测量服务器延迟。请检查网络。';

  @override
  String get createAccountTitle => '还没有 Firefox 账户？';

  @override
  String get createAccountHint =>
      '可在 accounts.firefox.com 免费注册，然后回到这里点击“添加账户”。';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get statusActive => '使用中';

  @override
  String get statusReady => '可用';

  @override
  String get statusNeedsSignIn => '需要登录';

  @override
  String get statusReserved => '备用';

  @override
  String get statusUnavailable => '不可用';

  @override
  String statusUnavailableUntil(String date) {
    return '$date 前不可用';
  }

  @override
  String get statusDisabled => '已停用';

  @override
  String get statusEnabled => '已启用';

  @override
  String get useNow => '立即使用';

  @override
  String get signInAgain => '重新登录';

  @override
  String reasonQuotaThreshold(int percent) {
    return '此账户已用掉 $percent% 的流量，已切换到下一个账户。';
  }

  @override
  String get reasonQuotaExhausted => '本月流量已用完；每月重置后会再次使用。';

  @override
  String get reasonSignInRequired => '请重新登录以使用此账户。';

  @override
  String get reasonSignInConfirm => 'Mozilla 要求确认登录：请点“重新登录”（只需验证码）。';

  @override
  String reasonSignInFailed(String detail) {
    return '自动登录失败（$detail）。请重新登录。';
  }

  @override
  String reasonSignInWait(String time) {
    return '上次自动登录后不久就失效了；下次尝试时间为 $time。';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return '自动登录未能完成（$detail）；将在 $time 重试。';
  }

  @override
  String get reasonNotEntitled => 'Mozilla 拒绝了此账户；稍后会重试。';

  @override
  String get more => '更多';

  @override
  String get refreshQuota => '刷新流量';

  @override
  String get remove => '删除';

  @override
  String get removeTitle => '删除账户？';

  @override
  String removeBody(String name) {
    return '$name 及其保存的登录信息将从这台电脑上删除。之后可以重新添加。';
  }

  @override
  String get unlimitedQuota => '不限流量';

  @override
  String get signInTitle => '登录';

  @override
  String get signInIntro => '使用 Firefox 账户登录。';

  @override
  String get email => '邮箱';

  @override
  String get emailInvalid => '请输入账户邮箱';

  @override
  String get password => '密码';

  @override
  String get passwordEmpty => '请输入密码';

  @override
  String get show => '显示';

  @override
  String get hide => '隐藏';

  @override
  String get signIn => '登录';

  @override
  String get continueLabel => '继续';

  @override
  String get done => '完成';

  @override
  String get close => '关闭';

  @override
  String get noBrowserTitle => '此设备没有浏览器';

  @override
  String get noBrowserText => '请在手机或电脑上打开此地址：';

  @override
  String get cancel => '取消';

  @override
  String get tryAgain => '重试';

  @override
  String get signingIn => '正在登录…';

  @override
  String get accountReady => '账户已就绪';

  @override
  String get accountReadyHint => '已添加到账户列表末尾。';

  @override
  String get captchaLabel => '图片中的字符';

  @override
  String get codeLabel => '验证码';

  @override
  String get captchaBroken => '无法显示验证码图片。';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla 已向 $email 发送验证码，请在此输入。';
  }

  @override
  String get stepTotp => '请输入身份验证器应用中的验证码。';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla 检测到此次登录异常，已向 $email 发送解锁码，请在此输入。';
  }

  @override
  String get stepCaptcha => '请输入图片中的字符。';

  @override
  String stepEmailLink(String email) {
    return '请打开 Mozilla 发送到 $email 的确认链接，确认后将自动继续。';
  }

  @override
  String get signInFailed => '未能添加账户。';

  @override
  String get signInCancelled => '登录已取消。';

  @override
  String get signInNoAccount => '此邮箱没有 Firefox 账户。';

  @override
  String get signInNoAccountHint =>
      '请检查邮箱地址，或用它在 Mozilla 网站免费创建一个 Firefox 账户，在邮箱中确认后再在此添加。';

  @override
  String get createAccountButton => '创建 Firefox 账户';

  @override
  String get signInWrongPassword => '密码错误。';

  @override
  String get signInNoPassword =>
      '此账户没有密码：它是通过 Google 或 Apple 登录创建的。请先设置密码，然后在此用该密码登录。';

  @override
  String get setPasswordButton => '设置密码';

  @override
  String get signInTooManyAttempts => '尝试次数过多。请稍候再试。';

  @override
  String get signInUnblockRejected => '解锁码未被接受。请使用 Mozilla 最新邮件中的验证码。';

  @override
  String get signInWrongCode =>
      '验证码错误或已过期。请使用 Mozilla 最新邮件中的验证码；发送新验证码后，旧的即失效。';

  @override
  String get signInWrongTotp => '验证码错误。请输入身份验证器应用当前显示的验证码。';

  @override
  String get signInTooManyCodes => '错误的验证码过多。请重新开始登录。';

  @override
  String get signInTimedOut => '登录耗时过长。请重新开始。';

  @override
  String get signInNetwork => '无法连接 Mozilla。请检查网络后重试。';

  @override
  String get coreConnecting => '正在连接核心…';

  @override
  String get coreLost => '与核心的连接已断开，正在重试…';

  @override
  String get cantReachCore => '无法连接到核心';

  @override
  String get startingCore => '正在启动核心…';

  @override
  String get retry => '重试';

  @override
  String errNoCore(String path) {
    return '在应用旁边找不到核心程序（$path）。';
  }

  @override
  String errCoreExited(String detail) {
    return '核心已停止：$detail';
  }

  @override
  String get errNotAnswering => '核心没有响应。';

  @override
  String get errRefused => '核心拒绝了本应用的连接，它可能属于另一个正在运行的副本。';

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionGeneral => '常规';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get closeBehavior => '关闭窗口时';

  @override
  String get closeAsk => '每次询问';

  @override
  String get closeTray => '最小化到托盘';

  @override
  String get closeQuit => '退出应用';

  @override
  String get sectionConnection => '连接';

  @override
  String get localProxy => '本地代理';

  @override
  String get systemProxy => '系统代理';

  @override
  String get sectionRouting => '分流';

  @override
  String get routingDirect => '本地网站直连';

  @override
  String get routingDirectHint => '所选国家的网站和 IP 不走 VPN，打开更快，也节省流量。';

  @override
  String get region => '国家';

  @override
  String get regionIr => '伊朗';

  @override
  String get regionCn => '中国';

  @override
  String get regionRu => '俄罗斯';

  @override
  String get regionAf => '阿富汗';

  @override
  String get regionTr => '土耳其';

  @override
  String get regionId => '印度尼西亚';

  @override
  String get regionBr => '巴西';

  @override
  String get regionNone => '无';

  @override
  String get saved => '已保存';

  @override
  String get dataFolder => '数据文件夹';

  @override
  String get openFolder => '打开文件夹';

  @override
  String get unofficialNote => '非官方客户端，与 Mozilla 无关。';

  @override
  String get closeTitle => '关闭窗口？';

  @override
  String get closeBody => '最小化到托盘后 VPN 保持连接；退出则会断开。';

  @override
  String get rememberChoice => '记住我的选择';

  @override
  String get minimizeToTray => '最小化到托盘';

  @override
  String get quit => '退出';

  @override
  String get trayOpen => '打开';

  @override
  String get trayQuit => '退出';

  @override
  String get trayProxyOnly => '仅代理服务';

  @override
  String get traySetSystemProxy => '设置系统代理';

  @override
  String errPortInUse(String port) {
    return '端口 $port 被其他程序占用，应用无法连接到核心。';
  }

  @override
  String proxyPortInUse(String port) {
    return '端口 $port 被其他程序占用，代理无法启动。';
  }

  @override
  String get changePort => '更改端口';

  @override
  String get portDialogTitle => '选择端口';

  @override
  String portDialogBody(String port) {
    return '端口 $port 已被占用。下方已推荐一个空闲端口，你也可以输入其他端口。';
  }

  @override
  String get portChangeBody => '其他应用通过此端口连接。请选择 1024 到 65535 之间的端口。';

  @override
  String get portLabel => '端口';

  @override
  String get portInvalid => '请输入 1024 到 65535 之间的端口';

  @override
  String get portBusy => '此端口也已被占用';

  @override
  String get portInUse => '其他程序正在使用此端口';

  @override
  String get save => '保存';

  @override
  String get proxyPort => '代理端口';

  @override
  String get appPort => '应用端口';

  @override
  String get welcomeTitle => '欢迎';

  @override
  String get welcomeBody => '请选择语言和所在国家。本国网站将直连访问，不走 VPN，速度更快，也节省流量。';

  @override
  String get start => '开始';

  @override
  String routingSuggestTitle(String country) {
    return '$country网站直连？';
  }

  @override
  String routingSuggestBody(String country) {
    return '$country的网站和 IP 将直连访问，不走 VPN。可在“分流”中更改。';
  }

  @override
  String get yes => '是';

  @override
  String get notNow => '暂不';

  @override
  String get navServers => '服务器';

  @override
  String get navLogs => '日志';

  @override
  String get realDelay => '真实延迟';

  @override
  String get statElapsed => '时长';

  @override
  String get statDown => '下载';

  @override
  String get statUp => '上传';

  @override
  String noticePort(String port) {
    return 'Mozilla 代理不支持端口 $port，只有 80、443、8080 和 8443 端口可以走 VPN。';
  }

  @override
  String get noticeCommand => 'VPN 不支持此类连接。';

  @override
  String noticeTimes(int count, String time) {
    return '$count 次，最近一次 $time';
  }

  @override
  String get dismiss => '忽略';

  @override
  String get modeRecommended => '推荐';

  @override
  String get modeFastest => '最快';

  @override
  String get modeRecommendedHint => '由 Mozilla 为你选择节点。';

  @override
  String get modeFastestHint => '每次连接时自动选择延迟最低的节点。';

  @override
  String get testDelay => '测试真实延迟';

  @override
  String get testingDelay => '正在测量…';

  @override
  String get search => '搜索';

  @override
  String get noAnswer => '无响应';

  @override
  String testedAgo(String ago) {
    return '$ago测试';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered/$total 个节点有响应';
  }

  @override
  String get noServers => '暂无服务器。核心连接到 Mozilla 后即会显示。';

  @override
  String get levelAll => '全部';

  @override
  String get filter => '筛选';

  @override
  String get follow => '自动滚动';

  @override
  String get clear => '清空';

  @override
  String get copyAll => '复制';

  @override
  String get logsCopied => '日志已复制';

  @override
  String get noLogs => '暂无日志。';

  @override
  String get sectionAccounts => '自动切换账户';

  @override
  String get switchThreshold => '切换阈值';

  @override
  String get switchThresholdHint => '流量用到此比例时，自动切换到下一个账户。';

  @override
  String get signInMethod => '登录方式';

  @override
  String get signInMethodBrowser => '通过浏览器登录';

  @override
  String get signInMethodApi => '直接登录';

  @override
  String get browserSignInBroken => '无法打开登录页面。';

  @override
  String get browserSignInBlocked => 'Mozilla 未能完成添加账号的最后一步（HTTP 406）。';

  @override
  String get browserSignInFallback => '使用邮箱和密码登录';

  @override
  String get backupExport => '保存备份';

  @override
  String get backupImport => '导入备份';

  @override
  String backupSaved(String name) {
    return '已保存：$name';
  }

  @override
  String get backupImportTitle => '添加这些账户？';

  @override
  String get backupAccountExists => '已添加；将使用文件中的登录信息';

  @override
  String get backupImportAction => '添加';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已添加 $count 个账户',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS 服务器';

  @override
  String get dnsSystem => '系统';

  @override
  String get dnsAuto => '自动（Cloudflare、Google、Quad9）';

  @override
  String get dnsCustom => '自定义';

  @override
  String get dnsCustomHint => '每行一个：https://…/dns-query、tls://… 或 IP 地址。';

  @override
  String get dnsFallback => '回退到系统 DNS';

  @override
  String get testDns => '测试 DNS';

  @override
  String get transport => '协议';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP 版本';

  @override
  String get ipVersionAuto => '自动（先 IPv4，再 IPv6）';

  @override
  String get ipVersionDual => '同时使用两者（双栈）';

  @override
  String get ipVersionV6First => '先 IPv6，再 IPv4';

  @override
  String get ipVersionV4 => '仅 IPv4';

  @override
  String get ipVersionV6 => '仅 IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint => 'VPN 接口的数据包大小，1280 到 9000。留空：自动。';

  @override
  String get tunMtuInvalid => '1280 到 9000 之间的数字，或留空';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => '直连';

  @override
  String get directRulesHint =>
      '此列表中的网站和地址不经过 VPN，直接通过你自己的网络打开。所选国家的规则已在此处：可以添加、修改或删除。选择其他国家会替换为该国的规则。';

  @override
  String get restoreRegionRules => '恢复该国家的默认规则';

  @override
  String get blockRules => '拦截';

  @override
  String get blockRulesHint =>
      '此列表中的网站和地址完全无法打开，无论直连还是通过 VPN：适用于广告或你永远不想访问的网站。';

  @override
  String get rulesTitle => '规则';

  @override
  String get ruleSyntaxTitle => '如何编写规则';

  @override
  String get resolveDomains => 'IP 规则也应用于域名';

  @override
  String get routingLists => 'Geo 文件';

  @override
  String get listSource => '列表来源';

  @override
  String get listSourceCustom => '手动设置';

  @override
  String listsUpdatedAgo(String ago) {
    return '更新于 $ago';
  }

  @override
  String get updateLists => '更新 Geo 文件';

  @override
  String get listsUpdated => 'Geo 文件已更新。';

  @override
  String get testDestination => '测试分流';

  @override
  String get destinationHint => '域名、IP 或网址';

  @override
  String get check => '检查';

  @override
  String get routeDirect => '直连';

  @override
  String get routeProxy => '走 VPN';

  @override
  String get routeBlock => '已拦截';

  @override
  String ruleMatched(String rule) {
    return '规则：$rule';
  }

  @override
  String get portRefusedNote => 'Mozilla 代理不支持此端口。';

  @override
  String get sectionAdvanced => '高级';

  @override
  String get tlsFragment => 'TLS 分片';

  @override
  String get tlsFragmentOff => '关闭';

  @override
  String get tlsFragmentFirstByte => '首字节';

  @override
  String get tlsFragmentSni => '服务器名称 (SNI)';

  @override
  String get tlsFragmentFirstByteHint => '在首字节处拆分 TLS 头部 (0x16)';

  @override
  String get tlsFragmentSniHint => '将服务器名称 (SNI) 拆分到多个 TCP 数据包';

  @override
  String get tlsFragmentRecord => 'TLS 记录';

  @override
  String get tlsFragmentRecordHint => '将服务器名称 (SNI) 拆分到两条 TLS 记录';

  @override
  String get tlsFragmentOffHint => '普通 TLS 连接';

  @override
  String get sectionBypass => '如果 Mozilla 被封锁';

  @override
  String get sharedRelay => '共享中继';

  @override
  String get sharedRelayHint => '如果 Mozilla 屏蔽了你所在的地区，则使用应用的共享中继。已启用的个人中继优先。';

  @override
  String get personalRelay => '个人中继';

  @override
  String get apiRelay => '中继服务器';

  @override
  String get apiRelayUse => '使用中继服务器';

  @override
  String get apiRelayHint =>
      '你自己的 Cloudflare Worker，或你自己主机上的 relay.php。\n仅在 Mozilla 无法直接应答时使用：登录、账户和服务器列表经过它，VPN 流量不经过。';

  @override
  String get upstreamProxy => '上游代理';

  @override
  String get upstreamProxyOn => '上游代理已开启';

  @override
  String get upstreamProxyAddress => 'SOCKS5 代理地址';

  @override
  String get upstreamProxyPort => '端口';

  @override
  String get upstreamProxyHint =>
      '与 Mozilla 的连接通过此代理，适用于封锁或限速 Mozilla 的网络。\n如果代理运行在本设备上，请将其排除在 VPN 之外。';

  @override
  String get upstreamProxyInvalid => '请输入代理地址，例如 127.0.0.1。';

  @override
  String get upstreamProxyInvalidPort => '请输入 1 到 65535 之间的端口。';

  @override
  String get upstreamProxyOwn => '这是本应用自己的代理。请输入其他代理。';

  @override
  String get apiRelayInvalid => '必须是 https:// 地址。';

  @override
  String get listenAddress => '允许连接的设备';

  @override
  String get listenLocal => '127.0.0.1 · 仅本设备';

  @override
  String get listenAll => '0.0.0.0 · 所有网络（LAN）';

  @override
  String get proxyUsername => '代理用户名';

  @override
  String get proxyPassword => '代理密码';

  @override
  String get proxyLoginHint => '应用连接代理时需填写这些信息。两项都留空则无需验证。';

  @override
  String get loginBothOrNone => '请同时填写两项，或都留空。';

  @override
  String get proxyLogin => '代理认证';

  @override
  String get idleSleep => '空闲后休眠';

  @override
  String get sleepNever => '从不';

  @override
  String sleepMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String get sleepHour => '1 小时';

  @override
  String get showPublicIp => '显示公网 IP';

  @override
  String get hapticFeedback => '连接状态变化时振动';

  @override
  String get keepScreenOn => '连接期间保持屏幕常亮';

  @override
  String get showTraffic => '在主页显示实时流量';

  @override
  String get speedInNotification => '在通知中显示速度';

  @override
  String get liveTraffic => '实时流量';

  @override
  String get totalTraffic => '总流量';

  @override
  String get verboseLogs => '详细日志';

  @override
  String get webDashboard => '网页控制面板';

  @override
  String get webDashboardOpen => '打开';

  @override
  String get webDashboardHint => '高级设置和更多工具';

  @override
  String numberInvalid(int min, int max) {
    return '请输入 $min 到 $max 之间的数字';
  }

  @override
  String get notifySwitchedTitle => '已切换账户';

  @override
  String notifySwitchedBody(String name) {
    return '现在使用 $name。';
  }

  @override
  String get notifySignInTitle => '需要登录';

  @override
  String get notifySignInBody => '有账户需要在“账户”页面重新登录。';

  @override
  String get navAbout => '关于';

  @override
  String get appVersionLabel => '应用版本';

  @override
  String get coreVersionLabel => '核心版本';

  @override
  String get checkUpdates => '检查更新';

  @override
  String get checkingUpdates => '正在检查…';

  @override
  String get upToDate => '已是最新版本。';

  @override
  String updateAvailable(String version) {
    return '新版本 $version 已发布。';
  }

  @override
  String updateRequired(String version) {
    return '请更新至 $version 版本。此更新为必要更新。';
  }

  @override
  String get download => '下载';

  @override
  String updateCheckFailed(String error) {
    return '无法检查更新：$error';
  }

  @override
  String get updateCheckNoNetwork => '无法连接到 GitHub。请检查网络连接后重试。';

  @override
  String get updateNow => '更新';

  @override
  String updateDownloading(String version) {
    return '正在下载版本 $version…';
  }

  @override
  String updateReady(String version) {
    return '版本 $version 已可安装。';
  }

  @override
  String updateInstalling(String version) {
    return '正在安装版本 $version，应用将关闭并重新打开。';
  }

  @override
  String updateFailed(String version) {
    return '无法更新到版本 $version。';
  }

  @override
  String updateDone(String version) {
    return '已更新到版本 $version。';
  }

  @override
  String updateRolledBack(String version) {
    return '更新到版本 $version 未能完成，应用已恢复到之前的版本。';
  }

  @override
  String get repoNotSet => '尚未设置 GitHub 仓库。';

  @override
  String get sourceCode => '源代码';

  @override
  String get tapToConnect => '点击连接';

  @override
  String get tapToDisconnect => '点击断开';

  @override
  String get startOnBoot => '开机启动';

  @override
  String get connectOnStartup => '开机自动连接';

  @override
  String get proxyServiceActive => '代理服务运行中';

  @override
  String get navHome => '首页';

  @override
  String get groupApp => '应用';

  @override
  String get groupNetwork => '网络';

  @override
  String get stateOff => '已断开';

  @override
  String get tapToConnectPhone => '点击连接';

  @override
  String get tapToDisconnectPhone => '点击断开';

  @override
  String get tapToConnectTv => '按 OK 键连接';

  @override
  String get tapToDisconnectTv => '按 OK 键断开';

  @override
  String lanAddress(String address) {
    return '局域网 $address';
  }

  @override
  String get recommendedLocation => '推荐节点';

  @override
  String dataLeftOf(String limit) {
    return '共 $limit';
  }

  @override
  String get homeLocation => '节点';

  @override
  String get connectedTo => '已连接到';

  @override
  String get vpnNotAllowed => 'VPN 需要你的授权。请再次点击按钮并允许。';

  @override
  String get dataUsedTitle => '已用流量';

  @override
  String get bypassApps => '分应用代理';

  @override
  String get connectRetrying => '无法连接。请检查网络。';

  @override
  String get failUnreachable => '无法连接到 Mozilla 的服务器。请尝试其他网络。';

  @override
  String get failUpstreamProxy => '无法通过上游代理连接到 Mozilla。请检查代理是否正在运行。';

  @override
  String get failInsideVpn => '此网络已经通过 VPN。请将其关闭。';

  @override
  String get failRefused => 'Mozilla 服务器拒绝了连接。请几分钟后再试。';

  @override
  String get failLocationRefused => '这个国家不对你的账户开放。请选择其他国家。';

  @override
  String get useRecommendedLocation => '使用推荐节点';

  @override
  String exitMismatch(String exit, String chosen) {
    return '你选择了$chosen，但你的 IP 在$exit。';
  }

  @override
  String get failSignIn => '此账户的登录已过期。请在“账户”页重新登录。';

  @override
  String get failQuota => '本月流量已用完。请添加另一个账户。';

  @override
  String get failNotEntitled => 'Mozilla 不允许此账户使用 VPN。请添加另一个账户。';

  @override
  String get failRegion => 'Mozilla 不在你所在的国家提供服务。';

  @override
  String get failServer => 'Mozilla 服务暂时出现问题。应用会自动重试。';

  @override
  String get failNoAccount => '没有可用的账户。请打开“账户”页。';

  @override
  String get failTestSite => '已连接服务器，但网站打不开。请换一个国家试试。';

  @override
  String get failOther => '无法连接。请重试。';

  @override
  String get failNoInternet => '无网络连接。请检查 Wi-Fi 或移动数据。';

  @override
  String get waitingForNetwork => '正在等待网络连接…';

  @override
  String proxyStartFailed(String port) {
    return '代理无法在端口 $port 上启动。请选择其他端口。';
  }

  @override
  String get connectionSettings => '连接设置';

  @override
  String get appModeExclude => '绕行所选应用';

  @override
  String get appModeInclude => '仅代理所选应用';

  @override
  String get appModeExcludeHint => '所选应用直连，不走 VPN，例如拒绝境外 IP 的银行应用。';

  @override
  String get appModeIncludeHint => '仅所选应用走 VPN，其他应用直连。';

  @override
  String fromRegionList(String region) {
    return '推荐（$region列表）';
  }

  @override
  String get modeProxy => '代理';

  @override
  String get connectionMode => '连接模式';

  @override
  String get modeProxyHint => '仅对已设置代理的应用生效。';

  @override
  String get modeSystemProxyHint => 'Windows 和大多数应用都走代理。';

  @override
  String get modeSystemProxyHintOther => '浏览器和大多数应用都走代理。';

  @override
  String get suggestedApps => '推荐应用';

  @override
  String get showSystemApps => '显示系统应用';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选中 $count 个推荐应用',
      zero: '推荐应用已全部选中',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => '自动';

  @override
  String get locationsSection => '节点';

  @override
  String get dnsSummaryOk => '加密 DNS 工作正常';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个域名解析失败',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return '经由 $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '当前网络的 DNS 对 $count 个域名返回了过滤地址，本应用不会采用这些结果。',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => '结果：';

  @override
  String get dnsNetworkAnswer => '网络 DNS：';

  @override
  String get dnsFiltered => '被过滤';

  @override
  String get rulesSyntaxTitle => '每行一条规则';

  @override
  String get ruleDomain => '该网站及其子域名';

  @override
  String get ruleFull => '仅匹配此域名';

  @override
  String get ruleKeyword => '包含此关键词的域名';

  @override
  String get ruleGeosite => 'Geo 文件中指定标签的网站';

  @override
  String get ruleGeoip => 'Geo 文件中指定国家的 IP';

  @override
  String get ruleIp => '单个 IP 或网段';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => '仅代理';

  @override
  String get noNetwork => '无网络连接。请打开 Wi-Fi 或移动数据。';

  @override
  String get blockAds => '拦截广告';

  @override
  String systemProxyTakenBy(String address) {
    return '另一个程序将系统代理改为 $address，流量不再经过 VPN。';
  }

  @override
  String get systemProxyTakenOff => '另一个程序关闭了系统代理，流量不再经过 VPN。';

  @override
  String get setSystemProxyAgain => '重新设置';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return '$os 的所有流量都走 VPN。';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting => '正在等待安装 TUN 服务的许可…';

  @override
  String get tunInstallCancelled => 'TUN 模式需要一次管理员权限。未获得权限，模式未更改。';

  @override
  String tunInstallFailed(String error) {
    return '无法安装 TUN 服务：$error';
  }

  @override
  String get tunStarting => '正在开启 TUN 模式…';

  @override
  String get tunFailed => 'TUN 模式未能开启，正在重试…';

  @override
  String get tunLost => 'TUN 模式意外停止，正在重试…';

  @override
  String get tunNotRunning => 'TUN 服务未在运行，正在重试…';

  @override
  String get tunMissing => 'TUN 服务未安装。';

  @override
  String get tunOutdated => 'TUN 服务比此应用旧。请重新安装以使用 TUN 模式。';

  @override
  String get tunAppOutdated => 'TUN 服务比此应用新。请更新应用以使用 TUN 模式。';

  @override
  String get tunBusy => '另一个 Homa VPN 副本正在使用 TUN 模式。';

  @override
  String get tunNoDriver => '系统的 TUN 驱动不可用。请重启电脑后重试。';

  @override
  String get tunInstall => '安装';

  @override
  String get tunInstallAgain => '重新安装';

  @override
  String get trayTunMode => 'TUN 模式（所有应用）';

  @override
  String get removeTunService => '移除 TUN 服务';

  @override
  String get removeTunServiceHint => '移除 TUN 模式使用的系统服务。再次选择 TUN 时会重新安装。';

  @override
  String get tunServiceRemoved => '已移除 TUN 服务。';

  @override
  String get tunInstallPrompt => 'Homa VPN 想要安装 TUN 模式的服务。';

  @override
  String get tunRemovePrompt => 'Homa VPN 想要移除 TUN 模式的服务。';

  @override
  String tunRemoveFailed(String error) {
    return '无法移除 TUN 服务：$error';
  }

  @override
  String get sectionTun => 'TUN 设置';

  @override
  String get tunPrograms => '绕过 VPN 的程序';

  @override
  String get tunProgramsHint => '它们直连，不经过 Mozilla。仅适用于不用 VPN 也能正常工作的程序。';

  @override
  String get tunProgramsEmpty => '还没有程序。';

  @override
  String get addProgram => '添加程序';

  @override
  String get programFiles => '程序';

  @override
  String get tunProgramAll => '全部流量';

  @override
  String get tunProgramAllHint => '整个程序直连。';

  @override
  String get tunProgramUdp => '仅 UDP';

  @override
  String get tunProgramUdpHint => '仅其 UDP 直连；其余流量走 VPN。';

  @override
  String get udpNoticeSetting => 'UDP 被拦截时提示';

  @override
  String udpNoticeBody(String program) {
    return '$program 的 UDP 流量无法经过 VPN。';
  }

  @override
  String get dontShowAgain => '不再显示';

  @override
  String get addRunningProgram => '从正在运行的程序中选择';

  @override
  String get addProgramFile => '选择文件…';

  @override
  String get addProgramName => '输入名称…';

  @override
  String get programNameHint =>
      '程序的文件名，例如 steam.exe；* 代表任意文字（steam* 即 Steam 的所有程序）。';

  @override
  String get runningProgramsEmpty => '没有其他正在运行的程序。';

  @override
  String get tabLog => '日志';

  @override
  String get tabConnections => '连接';

  @override
  String get connectionsEmpty => '暂无连接。';

  @override
  String connectionsOpen(int count) {
    return '$count 个打开';
  }

  @override
  String get connTime => '时间';

  @override
  String get connRoute => '规则';

  @override
  String get connDestination => '目标';

  @override
  String get connInbound => '入站';

  @override
  String get connProtocol => '协议';

  @override
  String get connColumns => '列';

  @override
  String get connTraffic => '流量';

  @override
  String get connDuration => '时长';

  @override
  String get connRouteVpn => '代理';

  @override
  String get connRouteDirect => '直连';

  @override
  String get connRouteBlocked => '已拦截';

  @override
  String get connRoutePort => '端口被拒';

  @override
  String get connRouteFailed => '失败';

  @override
  String get testRelay => '测试中继状态';

  @override
  String get relayTestTitle => '中继状态测试';

  @override
  String get relayTestHint => '仅检查中继，不向 Mozilla 发送请求或账户信息。';

  @override
  String get relayTestPassed => '中继已就绪';

  @override
  String get relayTestFailed => '无法确认中继状态';

  @override
  String get relayTestCopy => '复制报告';

  @override
  String get relayTestInterrupted => '测试在收到完整结果前结束。';

  @override
  String get searchLocations => '搜索位置';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个位置',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => '自动更新';

  @override
  String get autoInstallApkHint => '自动下载新版本；安装前安装程序会先询问。';

  @override
  String get installNow => '安装';

  @override
  String get updateAllowInstall => '如需安装更新，请允许本应用安装应用。';

  @override
  String get allowInstall => '允许';

  @override
  String get noResults => '没有符合搜索的位置。';

  @override
  String get accentColor => '强调色';

  @override
  String get accentMono => '单色（默认）';

  @override
  String get accentCustom => '自定义颜色';

  @override
  String get accentEmber => '火焰';

  @override
  String get accentGold => '金色';

  @override
  String get accentEmerald => '祖母绿';

  @override
  String get accentSapphire => '蓝宝石';

  @override
  String get accentAmethyst => '紫水晶';

  @override
  String get accentRose => '玫瑰';

  @override
  String get autoReconnect => '自动重连';

  @override
  String get autoReconnectHint => '连接意外断开时自动重新连接。';

  @override
  String get androidOnlyHint => '仅限手机。';

  @override
  String get idleDisconnect => '空闲时断开';

  @override
  String get idleDisconnectHint => '一段时间没有流量时结束本次会话。';

  @override
  String get idleTimeout => '空闲时限';

  @override
  String get minutes5 => '5 分钟';

  @override
  String get minutes10 => '10 分钟';

  @override
  String get minutes15 => '15 分钟';

  @override
  String get minutes30 => '30 分钟';

  @override
  String get minutes60 => '1 小时';

  @override
  String get dataLimit => '会话流量上限';

  @override
  String get dataLimitHint => '流量达到上限时结束本次会话。';

  @override
  String get dataLimitAmount => '上限';

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
    return '已有 $minutes 分钟没有流量，连接已断开。';
  }

  @override
  String autoStoppedData(int mb) {
    return '会话流量达到 $mb MB 上限，连接已断开。';
  }

  @override
  String get protection => '保护';

  @override
  String get killSwitch => 'Kill Switch（断网保护）';

  @override
  String get killSwitchHint => 'VPN 断开时拦截流量——绝不泄漏——直至重连成功。';

  @override
  String get alwaysOnVpn => 'VPN 常开';

  @override
  String get alwaysOnVpnHint => '安卓自带的防护：没有 VPN 就不放行任何连接。';

  @override
  String get floatingIsland => '悬浮岛';

  @override
  String get floatingIslandHint => '离开应用时，在其他应用上方显示连接状态。';

  @override
  String whatsNewTitle(String version) {
    return '版本 $version 的新功能';
  }

  @override
  String get whatsNewContinue => '知道了';

  @override
  String get whatsNewMenu => '版本更新内容';

  @override
  String get whatsNewView => '再次查看';

  @override
  String get updateServers => '更新服务器';

  @override
  String get updatingServers => '正在更新…';

  @override
  String serversUpdated(int count) {
    return '来自 Mozilla 官方列表的 $count 个位置';
  }

  @override
  String get serversUpdateFailed => '服务器列表更新失败；已保留原列表。';

  @override
  String get smartPickTitle => '当前最快';

  @override
  String get smartPickUse => '使用';

  @override
  String get connectAtBoot => '开机后自动连接';

  @override
  String get connectAtBootHint => '开机时自动连接（需已授予 VPN 权限）。';

  @override
  String get gamingProfile => '游戏模式';

  @override
  String get gamingProfileHint => '实时显示连接延迟与质量；配合实测最快服务器使用。';

  @override
  String get diagnosticsRun => '运行诊断';

  @override
  String get diagnosticsHint => '一键检查连接、DNS 与隧道';

  @override
  String get diagnosticsTunnel => '隧道';

  @override
  String get diagnosticsTunnelUp => '已建立并在传输流量';

  @override
  String get diagnosticsTunnelDown => '未连接';

  @override
  String get diagnosticsExit => '出口国家';

  @override
  String get diagnosticsMismatch => '出口国家与所选不符';

  @override
  String get diagnosticsConnection => '连接测试';

  @override
  String get diagnosticsPassed => '通过';

  @override
  String get diagnosticsFailed => '失败';

  @override
  String get diagnosticsDnsFiltered => '响应被拦截或过滤';

  @override
  String get diagnosticsDnsOk => '有响应';

  @override
  String get diagnosticsPrivacy => '诊断结果不会保存；仅显示在此窗口与核心自身日志中。';

  @override
  String get diagnosticsAgain => '再次运行';

  @override
  String get whatsNewAdded => '新增';

  @override
  String get whatsNewImproved => '改进';

  @override
  String get whatsNewFixed => '修复';

  @override
  String get wnWheelImproved =>
      '国家转盘重新绘制：选中的旗帜以玻璃框呈现，带精细光晕与身后柔和光圈，尺寸更大；其余旗帜更小且有层次感；下方的名称以滑动动画出现。';

  @override
  String get wnLiveImproved =>
      '连接期间，通知会像参考实现那样请求 Android 16 将其提升为实时动态（Live Update）；时长自动计时，速度实时更新。';

  @override
  String get wnL10nFixed => '本页面现在会跟随应用语言显示——全部十五种语言，而不只是英文。';

  @override
  String get wnMarkFixed => 'Mozilla 标志干净地呈现在其色块上，圆角与旗帜一致。';

  @override
  String get designTitle => '主页设计';

  @override
  String get designHint => '主页的布局方式';

  @override
  String get designWheel => '轮盘';

  @override
  String get designWheelDesc => '旗帜排在玻璃轮盘上，开关在下方';

  @override
  String get designBento => '拼块';

  @override
  String get designBentoDesc => '圆角拼块面板：连接、数字、位置';

  @override
  String get designPixel => '紧凑';

  @override
  String get designPixelDesc => '一张安静的卡片：位置、开关、数字';

  @override
  String get notifFlag => '通知中的国旗';

  @override
  String get notifFlagHint => '该国自己的旗帜显示在名称旁';

  @override
  String get wnDesignAdded => '新增主页设计设置：轮盘、拼块或紧凑卡片';

  @override
  String get wnMapAdded => '主页背景换成真实的矢量世界地图，选中的国家会被点亮';

  @override
  String get wnWheelAdded => '旗帜轮盘重绘：玻璃更深邃、动效更顺滑';

  @override
  String get wnFlagNotifAdded => '通知可显示国家的 SVG 国旗，也可关闭';

  @override
  String get wnColorRemoved => '移除了自定义颜色页面；强调色列表仍支持 HEX 码';

  @override
  String get whatsNewRemoved => '已移除';

  @override
  String get wnCrashFixed => '应用不再在 Android 16 手机上自行停止：通知向系统索要了手机还没有的东西。';

  @override
  String get wnFlagArtFixed => '应用打开后不再把自己踢出去：通知的国旗图片返回了系统消息通道不接受的值。';

  @override
  String get statSession => '会话';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get wnTotalsAdded => '主页显示本次会话的总流量，轻点即可复制公共 IP。';

  @override
  String get wnPolishImproved => '旗帜转轮和服务器页面更整洁；文字更紧凑，Android 隧道以更高的速度传输流量。';

  @override
  String get valueSmart => '智能';

  @override
  String get wnSmartAdded => '智能连接：MTU、协议与 IP 版本跟随网络，按真实响应选择，以速度为先。';

  @override
  String get wnToastAdded => '确认提示现在以 iOS 风格轻柔呈现，图标会自己画出。';

  @override
  String get wnFlagsImproved => '旗帜转轮干净利落：边缘不再切半面旗，旗帜完整呈现，选择轻轻弹落。';

  @override
  String get wnMapImproved => '世界地图更大更清晰：不再压缩大陆，海岸线平滑，落点处有光晕。';

  @override
  String get dnsManual => '手动 DNS';

  @override
  String get dnsManualHint =>
      '每行一个地址：普通 IP、https://（DNS over HTTPS）或 tls://host（DNS over TLS）。以最先应答者为准。';

  @override
  String get dnsManualInvalid => '有一行不是内核可用的地址：普通 IP、https://… 或 tls://host。';

  @override
  String get killSwitchGuarded => '守护中：隧道中断期间，没有任何数据离开手机。';

  @override
  String get accountsUsageTitle => '本月';

  @override
  String get accountsCountLabel => '个账户';

  @override
  String get accountsUsageAverage => '各账户已用份额的平均值';

  @override
  String get wnDesignsAdded =>
      '应用设计：整个应用可以换上柔和新拟态或极光玻璃——每一页、每一张卡片——在 设置 → 通用 中选择。';

  @override
  String get wnWheelFixed => '转轮的半面旗消失了：选中旗帜下方的搁板是一泓光，不再是第二面旗，屏幕边缘也不会切掉任何旗帜。';

  @override
  String get wnMapReal => '世界地图依据各国官方边界重新绘制——每一处海岸、岛屿与飞地都忠实呈现，比例真实。';

  @override
  String get wnGlobeAdded => '世界变成了地球仪：银色球体会转向所选国家，发光的定位针与悬浮卡片标记它，连接的路线伸向各枢纽。';

  @override
  String get wnWheelGlowImproved =>
      '选中的旗帜在蓝色光晕与玻璃边框中更大更醒目，两侧旗帜明显更小，转轮下方的指示点显示当前位置。';

  @override
  String get wnDesignsRemoved => '应用设计选项已移除：应用恢复原本的单色外观——您的强调色与主题保持不变。';

  @override
  String get wnDnsAdded =>
      '手动 DNS：普通 IP、DNS over HTTPS 与 DNS over TLS——每一行的类型随手输入即时显示并校验。';

  @override
  String get wnSmartImproved => '智能连接现在实时显示网络的回答：它选中的传输方式与保留的 IP 版本。';

  @override
  String get wnProtectionImproved => 'Kill Switch 会在守护生效时说明状态，应用页面会显示你选择的应用数量。';

  @override
  String get wnWelcomeImproved => '欢迎页以一面呼吸的盾牌配上流动的极光开场，账户页则将整月用量一览汇总。';

  @override
  String bypassAppsCount(String n) {
    return '已选：$n';
  }

  @override
  String get sectionAppearance => '外观';

  @override
  String get mapStyle => '地图样式';

  @override
  String get mapStyleHint => '主页的地球会按您的选择上色，连接的灯光保持不变。';

  @override
  String get mapSilver => '银色';

  @override
  String get mapMidnight => '午夜';

  @override
  String get mapOcean => '海洋';

  @override
  String get mapMono => '单色';

  @override
  String get mapAurora => '极光';

  @override
  String get batterySaver => '省电模式';

  @override
  String get batterySaverHint => '连接时让地图动效安歇——地球的呼吸、转轮的光晕。连接本身完全不受影响。';

  @override
  String get connectOnOpen => '打开应用时连接';

  @override
  String get connectOnOpenHint => '应用一打开就连上 VPN，使用您上次选择的位置。';

  @override
  String get speedTitle => '速度';

  @override
  String get parallelTunnels => '并行隧道';

  @override
  String get parallelTunnelsHint =>
      '同时打开多条通往 Mozilla 的隧道并分担流量，单条慢隧道不再限制速度。八条对电池负担最大。';

  @override
  String get tunnels1 => '一条——最稳定';

  @override
  String get tunnels2 => '两条';

  @override
  String get tunnels4 => '四条——慢网络下更快';

  @override
  String get tunnels8 => '八条——最快';

  @override
  String get connectionCap => '连接数上限';

  @override
  String get connectionCapHint => '多少应用可以同时通过 VPN 通信；更小的上限在繁忙的手机上省电省流量。默认不限制。';

  @override
  String get capNone => '不限制';

  @override
  String get verboseLogging => '详细诊断';

  @override
  String get verboseLoggingHint => '把每一步都写进日志——报告问题时很有用，略微多耗一点电。';

  @override
  String get wn38MapStylesAdded =>
      '地图的五种外观：银色、午夜、海洋、单色和极光——在设置里新增的「外观」页选择，每种都有预览。';

  @override
  String get wn38ZoomAdded => '地图可以缩放：双指捏合，或双击放大、再次双击还原。';

  @override
  String get wn38OptionsAdded => '实用的新选项：并行隧道提升速度、连接数上限、省电模式、打开应用时连接，以及详细诊断。';

  @override
  String get wn38SocialAdded => 'Instagram 和 Telegram 现在也在这个页面的底部。';

  @override
  String get wn38FlightImproved =>
      '选择国家变成了一次小小的飞行：镜头后拉，球体转动，图钉带弹跳落下，路径自行延伸到各个枢纽。';

  @override
  String get wn38EffectsImproved =>
      '地图更耐看了：球体背后的星辰、坐标网格、枢纽自己的光点、边缘的光晕，还有陆地的阴影。';

  @override
  String get wn38SpeedImproved => '速度选项是真实的：并行隧道同时打开多条连接，核心在它们之间分配流量。';

  @override
  String get wn38NameFixed => '所选国家的名称只显示一次——在地图的悬浮卡片上；旗帜下方的重复文字已移除。';

  @override
  String get mapKind => '地图类型';

  @override
  String get mapKindHint =>
      '主页的世界如何呈现：一如既往的平面地图（默认）、其现代风格、夜晚地球、地形地球、金属球体，或卫星地球。每种类型使用的都是真实、官方的边界。';

  @override
  String get mapKindClassic => '经典';

  @override
  String get mapKindGlobe => '3D 球体';

  @override
  String get mapKindSatellite => '卫星';

  @override
  String get mapKindFlat => '平面 2D';

  @override
  String get mapStyleGlobeHint => '3D 球体的配色。卫星有自己的地球，平面地图有自己的墨色。';

  @override
  String get aboutVersions => '版本';

  @override
  String get aboutChannels => '联系页面';

  @override
  String get checkUpdatesHint => '查找更新的版本；找到后会下载，并由安装器进行确认。';

  @override
  String get speedTestTitle => '速度测试';

  @override
  String get speedTestRun => '测量';

  @override
  String get speedTestFailed => '测量未完成。';

  @override
  String get speedTestThrough => '经由隧道测得。';

  @override
  String get speedTestDirect => '直接测得（代理已关）。';

  @override
  String get speedTestHint => '经由隧道的一次下载与一次上传，才说明它真正能承载多少。主页的图表也会打开这里。';

  @override
  String get speedGraphHint => '隧道最近一分钟 · 点按测量';

  @override
  String get favoritePinned => '已固定。再次长按可取消。';

  @override
  String get favoriteUnpinned => '已取消固定。';

  @override
  String get shareReport => '分享报告';

  @override
  String get shareReportCopied => '报告已放入剪贴板。';

  @override
  String get batteryWizardTitle => '在电池下存活';

  @override
  String get batteryWizardBody =>
      '小米、三星、华为等厂商会在锁屏后杀死 VPN 应用。把这个应用移出电池优化，隧道才会一直在线。';

  @override
  String get batteryWizardSteps =>
      '在厂商自己的设置里也允许自启动，并把应用设为「无限制」（小米）、「移出睡眠应用」（三星）或「手动启动」（华为）。';

  @override
  String get batteryWizardState => '电池优化可能中断隧道。';

  @override
  String get batteryWizardPermit => '允许';

  @override
  String get batteryWizardOk => '隧道已受电池保护。';

  @override
  String get batteryWizardOpen => '电池设置';

  @override
  String get usageTitle => '应用用量';

  @override
  String get usageRowHint => '每个应用用了多少';

  @override
  String get usageGrant => '打开使用情况权限';

  @override
  String get usageGrantHint =>
      'Android 把每个应用的流量用量放在「使用情况访问权」后面。按钮打开的页面属于系统；本应用只读取数字。';

  @override
  String get usageEmpty => '此时间段没有记录用量。';

  @override
  String get usageToday => '今天';

  @override
  String get usageWeek => '最近 7 天';

  @override
  String get usageMonth => '最近 30 天';

  @override
  String get playProtectTitle => 'Google Play 保护';

  @override
  String get playProtectBody =>
      '本应用从 Google Play 以外安装，首次安装时 Play Protect 可能要求扫描。点一次「扫描应用」即可——干净的扫描会被记住，之后更新不再出现此提示。';

  @override
  String get smartLocation => '最快位置';

  @override
  String get smartLocationHint => '每次启动都落在核心延迟实测最快的服务器上。';

  @override
  String get quicPass => 'QUIC 直通';

  @override
  String get quicPassHint => '应用的 QUIC（UDP 443）从隧道通过：通话和游戏保持速度，不再回退到 TCP。';

  @override
  String get accountRename => '重命名账户';

  @override
  String get accountRenameLabel => '账户名称';

  @override
  String get accountProfile => '个人头像';

  @override
  String get avatarReset => '恢复默认头像';

  @override
  String get accountSecurity => '应用密码';

  @override
  String get appPasswordOn => '应用在密码保护下打开。';

  @override
  String get appPasswordOff => '未设密码：任何打开应用的人都能进入。';

  @override
  String get appPasswordSet => '设置密码';

  @override
  String get appPasswordChange => '修改密码';

  @override
  String get appPasswordRemove => '移除密码';

  @override
  String get appPasswordCurrent => '当前密码';

  @override
  String get appPasswordNew => '新密码（4 个字符以上）';

  @override
  String get appPasswordConfirm => '重复新密码';

  @override
  String get appPasswordShort => '至少 4 个字符。';

  @override
  String get appPasswordMismatch => '两次输入的密码不一致。';

  @override
  String get appPasswordWrong => '密码错误';

  @override
  String get appPasswordSetDone => '密码已设置——下次启动应用时会要求输入。';

  @override
  String get appPasswordRemoved => '密码已移除；应用可直接打开。';

  @override
  String get appPasswordUnlock => '应用已锁定';

  @override
  String get appPasswordUnlockHint => '输入应用密码以继续。';

  @override
  String get wn39MapKinds => '地图重新可选类型：一如既往的平面地图（默认）、3D 球体、卫星地球和现代平面 2D。';

  @override
  String get wn39EyeIp => '位置卡片带有眼睛图标：点按可查看流量出口地址并复制。';

  @override
  String get wn39Profile => '账户可拥有自己的名称与头像，应用也可以在密码保护下打开。';

  @override
  String get wn39Smart => '智能连接更完整：按真实延迟选择最快位置，并为通话和游戏提供 QUIC 直通。';

  @override
  String get wn39Flight => '切换国家飞行更顺滑——相机沿大圆弧移动——旗帜轮盘的指示点也更贴近旗帜。';

  @override
  String get wn39ToastEverywhere => '动态通知现在无处不在：每一次保存、复制和失败都穿上同一枚动画玻璃胶囊。';

  @override
  String get wn39Updates => '更新保持存储干净：安装器直接替换旧版本，不留任何安装包。';

  @override
  String get mapKindNight => '夜晚';

  @override
  String get mapKindTerrain => '地形';

  @override
  String get wn40MapKindsNew => '地图新增两种样式：夜晚地球与地形地球。';

  @override
  String get wn40Flight => '3D 球体以一次平滑的旋转飞向新国家——绝不再生硬跳变。';

  @override
  String get wn40Mercator => '平面地图改用标准墨卡托投影：真实比例、标准边界、毫无挤压变形。';

  @override
  String get wn40NameBack => '平面地图上，所选国家的名称重新出现在旗帜下方。';

  @override
  String get wn40Speed => '隧道默认开启两条并行会话——线路更强劲、更稳定。';

  @override
  String get wn40LockFixed => '连接按钮上的锁在状态切换时不再闪烁消失。';

  @override
  String get wn40IpRemoved => '位置卡片上的 IP 弹窗已移除。';

  @override
  String get soundFeedback => '音效';

  @override
  String get soundFeedbackHint => '轻触、开关与连接切换时的轻柔音效';

  @override
  String get rateUnit => '速度单位';

  @override
  String get lockInBackground => '离开后重新上锁';

  @override
  String get lockBgNever => '从不';

  @override
  String get lockBgNow => '立即';

  @override
  String get lockBgMin5 => '5 分钟后';

  @override
  String get lockBgMin15 => '15 分钟后';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound => '连接提示音与振动同行：VPN 开启或关闭时会发出一声短音（设置 → 通用）。';

  @override
  String get wn41RateUnit => '速度按你选择的单位显示：熟悉的 KB/s 或连接本身的 Mbps。';

  @override
  String get wn41BackgroundLock => '应用可在你离开后自行上锁：密码会在立即、5 分钟或 15 分钟后重新询问。';

  @override
  String get wn41BiggerLimits => '会话的数据上限可升到 25、50 或 100 GB。';

  @override
  String get wn41Motion => '新的动效：连接后的圆球会呼吸、对勾自行绘出、状态文字在取值间平滑滑动、密码错误时输入框会晃动。';

  @override
  String get wn41AboutFixed => '「关于」页面变得整齐：两个页面并排、每条说明独占一行，毫无挤压。';

  @override
  String get wn41HapticFixed => '振动设置重新生效：每次连接的开启与关闭都会遵循它，而不只是滑块。';

  @override
  String get copyIp => '复制 IP';

  @override
  String get wn42Fonts =>
      '每种语言都用应用自带的字体阅读：两种中文与孟加拉文用 Noto Sans，拉丁与西里尔文用 Inter——不再依赖手机字体。';

  @override
  String get wn42Sounds =>
      '应用的音效现在是真的：每个分区都有轻柔的触碰声、开关的两声短音、连接建立与断开时的升降音、锁定时的一声提示——音效开关统一控制。';

  @override
  String get wn42AboutFixed => '「关于」页面的标志、名称与说明居中显示，联系账号无论屏幕多窄都完整保持在一行。';

  @override
  String get wn42Gaming => '游戏模式现在是真的：服务器页面每半分钟重新测量延迟，并用强调色突出实测最快的服务器。';

  @override
  String get avatarPhoto => '自定义头像';

  @override
  String get avatarPhotoFailed => '无法使用该图片';

  @override
  String get designAether => '以太';

  @override
  String get designAetherDesc => 'iOS 状态卡：状态词与会话时长在浮起卡片上，电源键自发光';

  @override
  String get designZed => 'Zed';

  @override
  String get designZedDesc => '渐变圆球：紫、粉与柠檬绿中呼吸的圆球，承载会话时长';

  @override
  String get tlsFragmentAuto => '自动';

  @override
  String get tlsFragmentAutoHint => '先发完整的 hello；若网络不断切断 TLS，会自动切分名称半小时';

  @override
  String get accentDesign => '设计自带的配色';

  @override
  String get wn45Designs => '四种全新的主页外观——极光、霓虹、暮色、鼠尾草——每一种都以自己的配色装点所有页面';

  @override
  String get wn45HelloAuto => 'TLS 切分学会了：若网络反复扼杀握手，就自动切分名称，让隧道穿行过去';

  @override
  String get wn45RelayRace => '中继恢复现在同时测试三个边缘，被过滤的网络能更快找回通路';

  @override
  String get wn45AccentFixed => '颜色选择器重新点亮整个应用——此前所选颜色无法作用到各页面';

  @override
  String get wn45WhatsNewFixed => '「新变化」页面重新显示出文字——此前打开时是空白的';

  @override
  String get wn46Designs =>
      '两个来自参考设计的新外观：以太的 iOS 状态卡与 Zed 的渐变圆球 — 各自装扮整个应用的每个页面，此前的四个外观已离场。';

  @override
  String get wn46Sounds =>
      '音效换上专业套组：连接开始时的涌动，接通时的和弦，断开时的下行旋律，以及通路被堵时的一声闷响 — 同一时刻只有一个声音。';

  @override
  String get wn47Designs =>
      '两套参考设计现在装点整个应用——是每一页，不只是主页：aether 穿上第一款参考的 iOS 结构（弧形缺口栏、分组表格、彩色徽章、系统自带的状态色），zed 穿上第二款参考的灵动结构（悬浮底栏、超圆卡片、可拖动的工具气泡）。';

  @override
  String get wn47Fixes => '窄屏上曾溢出的设置行现在能读到末尾。';

  @override
  String get wn48Bars =>
      '两套设计的底部栏各归其位：aether 的蓝色圆钮落在自己标签的凹口里，zed 的圆钮不再盖住下方的名字。';

  @override
  String get wn48Fit =>
      '主页重新装得下屏幕：aether 的卡片把 Disconnected 读完，页面太挤时 zed 的光球会收一步，连接进行中轨道不再要你滑动连接、提示也不再同时说断开。';

  @override
  String get wn48Wheel =>
      '旗帜转轮会在屏幕边缘切到卡片之前把它淡出，推荐地点以看得清的尺寸佩戴 Mozilla 徽标，平面地图的南缘融进页面，不再以一条直线收尾。';

  @override
  String get wn49States =>
      '两个参考设计穿上了它们被画下的细节：aether 的卡片像 AetherST 一样显示本次会话的速率，电源键随参考的光晕呼吸并在指尖下沉，zed 的气泡在自身的形状之间变形，中央的内容交叉淡入淡出地换场。';

  @override
  String get wn49Words =>
      '“正在连接”现在处处有词：隧道搭建期间，开关的滑轨带着「正在连接…」字样，旋钮的图标在各个形态间淡入淡出，滑轨随连接自身的节奏呼吸——指尖之下再没有什么会突然消失。';

  @override
  String get wn49Sooner =>
      '连接的引擎重新回到原版：中继池、备用路线和它们的记忆，以及重复请求的守卫扛着隧道——起来得更早，也站得更稳。';

  @override
  String get wn49Mark => '推荐位置换上了 Mozilla VPN 真正的标志，更新按钮也换上了更新自己的图标。';

  @override
  String get wn50Notch =>
      '两套设计的衣着告别了积攒的凌乱：aether 的缺口栏读到圆钮自己的中心，被选中的标签名在两套外观里都穿上页面自己的墨色，圆钮的光晕守在圆钮身上，不再把名字洗掉。';

  @override
  String get wn50Cards =>
      'zed 的主页把速率折进便当格：速率卡并入便当格的两格与会话一行，页面最后的卡片让开底栏的座位，页面滑到底时再没有东西半截藏在底栏之下。';

  @override
  String get wn50Veil =>
      '状态条戴上自己的薄纱：滚动的内容在时钟下方淡出而不再与它相撞，zed 推开的页面不再从时钟下面开始，它的悬浮工具也远离底栏的座位。';

  @override
  String get wn50Ping => 'aether 的延迟胶囊再次一触即测，就像参考里它自己的胶囊那样应答。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => '滑動以連接';

  @override
  String get slideToDisconnect => '滑動以斷開';

  @override
  String get navOverview => '總覽';

  @override
  String get navAccounts => '帳號';

  @override
  String get navSettings => '設定';

  @override
  String get stateConnected => '已連線';

  @override
  String get stateConnecting => '正在連線…';

  @override
  String get stateWaiting => '等待中';

  @override
  String get waitingForAccount => '請在「帳號」頁面新增 Firefox Account 以連線。';

  @override
  String get waitingForEnabledAccount => '所有帳號都已關閉。請在「帳號」頁面啟用一個。';

  @override
  String get stateError => '錯誤';

  @override
  String get stateUnknown => '未知';

  @override
  String get restartProxy => '重新啟動代理';

  @override
  String copied(String value) {
    return '已複製 $value';
  }

  @override
  String get activeAccount => '目前帳號';

  @override
  String get noActiveAccount => '沒有使用中的帳號';

  @override
  String get quotaNotRead => '尚未取得流量資訊';

  @override
  String get unlimited => '無限制';

  @override
  String usedOf(String used, String limit) {
    return '已用 $used / $limit';
  }

  @override
  String resets(String date) {
    return '$date 重新計算';
  }

  @override
  String switchAt(int percent) {
    return '達到 $percent% 時切換帳號';
  }

  @override
  String get publicIp => '公用 IP';

  @override
  String get testConnection => '測試連線';

  @override
  String get testing => '正在測試…';

  @override
  String get testFailed => '失敗';

  @override
  String milliseconds(int value) {
    return '$value 毫秒';
  }

  @override
  String get justNow => '剛剛';

  @override
  String minutesAgo(int n) {
    return '$n 分鐘前';
  }

  @override
  String hoursAgo(int n) {
    return '$n 小時前';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天前',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return '於 $time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d 天 $h 小時';
  }

  @override
  String durationHours(int h, int m) {
    return '$h 小時 $m 分';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m 分 $s 秒';
  }

  @override
  String durationSeconds(int s) {
    return '$s 秒';
  }

  @override
  String accountsGuide(String size) {
    return '每個 Firefox 帳號每月有 $size 流量。你可以新增多個帳號：一個用完後，應用程式會自動切換到下一個。';
  }

  @override
  String accountsOrderNote(int percent) {
    return '依此清單順序使用：每個帳戶用到 $percent%，最後一個用到流量用完。';
  }

  @override
  String get addAccount => '新增帳號';

  @override
  String lowQuotaNotice(String size) {
    return '此帳號的流量快用完了。再新增一個帳號，可再獲得 $size。';
  }

  @override
  String get noAccounts => '尚無帳號';

  @override
  String get noAccountsHint => '新增一個 Firefox Account 以連線。';

  @override
  String get delayTestFailed => '無法測量伺服器延遲。請檢查網路。';

  @override
  String get createAccountTitle => '還沒有 Firefox Account？';

  @override
  String get createAccountHint => '可在 accounts.firefox.com 免費註冊，再回來點選「新增帳號」。';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get statusActive => '使用中';

  @override
  String get statusReady => '可用';

  @override
  String get statusNeedsSignIn => '需要登入';

  @override
  String get statusReserved => '已保留';

  @override
  String get statusUnavailable => '無法使用';

  @override
  String statusUnavailableUntil(String date) {
    return '$date 前無法使用';
  }

  @override
  String get statusDisabled => '已停用';

  @override
  String get statusEnabled => '已啟用';

  @override
  String get useNow => '立即使用';

  @override
  String get signInAgain => '重新登入';

  @override
  String reasonQuotaThreshold(int percent) {
    return '此帳號已用掉 $percent% 的流量，已切換到下一個帳號。';
  }

  @override
  String get reasonQuotaExhausted => '本月流量已用完；每月重設後會再次使用。';

  @override
  String get reasonSignInRequired => '請重新登入以使用此帳號。';

  @override
  String get reasonSignInConfirm => 'Mozilla 要求確認登入：請按「重新登入」（只需驗證碼）。';

  @override
  String reasonSignInFailed(String detail) {
    return '自動登入失敗（$detail）。請重新登入。';
  }

  @override
  String reasonSignInWait(String time) {
    return '上次自動登入後不久就失效了；下次嘗試時間為 $time。';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return '自動登入未能完成（$detail）；將在 $time 重試。';
  }

  @override
  String get reasonNotEntitled => 'Mozilla 拒絕了此帳號；稍後會重試。';

  @override
  String get more => '更多';

  @override
  String get refreshQuota => '重新整理流量';

  @override
  String get remove => '移除';

  @override
  String get removeTitle => '要移除帳號嗎？';

  @override
  String removeBody(String name) {
    return '$name 及其儲存的登入資訊將從這台電腦上移除。之後可以重新新增。';
  }

  @override
  String get unlimitedQuota => '無限流量';

  @override
  String get signInTitle => '登入';

  @override
  String get signInIntro => '使用 Firefox Account 登入。';

  @override
  String get email => '電子郵件';

  @override
  String get emailInvalid => '請輸入帳號的電子郵件';

  @override
  String get password => '密碼';

  @override
  String get passwordEmpty => '請輸入密碼';

  @override
  String get show => '顯示';

  @override
  String get hide => '隱藏';

  @override
  String get signIn => '登入';

  @override
  String get continueLabel => '繼續';

  @override
  String get done => '完成';

  @override
  String get close => '關閉';

  @override
  String get noBrowserTitle => '此裝置沒有瀏覽器';

  @override
  String get noBrowserText => '請在手機或電腦上開啟此位址：';

  @override
  String get cancel => '取消';

  @override
  String get tryAgain => '再試一次';

  @override
  String get signingIn => '正在登入…';

  @override
  String get accountReady => '帳號已就緒';

  @override
  String get accountReadyHint => '已排在帳號清單的最後。';

  @override
  String get captchaLabel => '圖片中的字元';

  @override
  String get codeLabel => '驗證碼';

  @override
  String get captchaBroken => '無法顯示 CAPTCHA 圖片。';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla 已將驗證碼寄到 $email，請在此輸入。';
  }

  @override
  String get stepTotp => '請輸入驗證器應用程式中的驗證碼。';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla 認為這次登入異常，已將解除封鎖碼寄到 $email，請在此輸入。';
  }

  @override
  String get stepCaptcha => '請輸入圖片中的字元。';

  @override
  String stepEmailLink(String email) {
    return '請開啟 Mozilla 寄到 $email 的確認連結，之後會自動繼續。';
  }

  @override
  String get signInFailed => '未能新增帳號。';

  @override
  String get signInCancelled => '已取消登入。';

  @override
  String get signInNoAccount => '此電子郵件沒有 Firefox Account。';

  @override
  String get signInNoAccountHint =>
      '請檢查電子郵件地址，或用它在 Mozilla 網站免費建立 Firefox Account，從信箱確認後再在此新增。';

  @override
  String get createAccountButton => '建立 Firefox Account';

  @override
  String get signInWrongPassword => '密碼錯誤。';

  @override
  String get signInNoPassword =>
      '此帳號沒有密碼：它是透過 Google 或 Apple 登入建立的。請先設定密碼，再於此用該密碼登入。';

  @override
  String get setPasswordButton => '設定密碼';

  @override
  String get signInTooManyAttempts => '嘗試次數過多。請稍候再試。';

  @override
  String get signInUnblockRejected => '解除封鎖碼未被接受。請使用 Mozilla 最新郵件中的代碼。';

  @override
  String get signInWrongCode =>
      '驗證碼錯誤或已過期。請使用 Mozilla 最新郵件中的驗證碼；寄出新驗證碼後，舊的即失效。';

  @override
  String get signInWrongTotp => '驗證碼錯誤。請輸入驗證器應用程式目前顯示的驗證碼。';

  @override
  String get signInTooManyCodes => '錯誤的驗證碼過多。請重新開始登入。';

  @override
  String get signInTimedOut => '登入耗時過長。請重新開始。';

  @override
  String get signInNetwork => '無法連線到 Mozilla。請檢查網路後再試。';

  @override
  String get coreConnecting => '正在連線到核心…';

  @override
  String get coreLost => '與核心的連線已中斷，正在重試…';

  @override
  String get cantReachCore => '無法連線到核心';

  @override
  String get startingCore => '正在啟動核心…';

  @override
  String get retry => '重試';

  @override
  String errNoCore(String path) {
    return '在應用程式旁找不到核心程式（$path）。';
  }

  @override
  String errCoreExited(String detail) {
    return '核心已停止：$detail';
  }

  @override
  String get errNotAnswering => '核心沒有回應。';

  @override
  String get errRefused => '核心拒絕連線，可能屬於另一個正在執行的副本。';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionGeneral => '一般';

  @override
  String get language => '語言';

  @override
  String get languageSystem => '系統預設';

  @override
  String get theme => '主題';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get closeBehavior => '關閉視窗時';

  @override
  String get closeAsk => '每次詢問';

  @override
  String get closeTray => '最小化到系統匣';

  @override
  String get closeQuit => '結束應用程式';

  @override
  String get sectionConnection => '連線';

  @override
  String get localProxy => '本機代理';

  @override
  String get systemProxy => '系統代理';

  @override
  String get sectionRouting => '分流';

  @override
  String get routingDirect => '本地網站直接連線';

  @override
  String get routingDirectHint => '所選國家的網站和 IP 不經過 VPN，開啟更快，也更省流量。';

  @override
  String get region => '國家';

  @override
  String get regionIr => '伊朗';

  @override
  String get regionCn => '中國';

  @override
  String get regionRu => '俄羅斯';

  @override
  String get regionAf => '阿富汗';

  @override
  String get regionTr => '土耳其';

  @override
  String get regionId => '印尼';

  @override
  String get regionBr => '巴西';

  @override
  String get regionNone => '無';

  @override
  String get saved => '已儲存';

  @override
  String get dataFolder => '資料儲存位置';

  @override
  String get openFolder => '開啟資料夾';

  @override
  String get unofficialNote => '非官方用戶端，與 Mozilla 無關。';

  @override
  String get closeTitle => '要關閉視窗嗎？';

  @override
  String get closeBody => '最小化到系統匣時，VPN 會保持連線；結束則會中斷連線。';

  @override
  String get rememberChoice => '記住我的選擇';

  @override
  String get minimizeToTray => '最小化到系統匣';

  @override
  String get quit => '結束';

  @override
  String get trayOpen => '開啟';

  @override
  String get trayQuit => '結束';

  @override
  String get trayProxyOnly => '僅代理服務';

  @override
  String get traySetSystemProxy => '設定系統代理';

  @override
  String errPortInUse(String port) {
    return '連接埠 $port 已被其他程式使用，應用程式無法連線到核心。';
  }

  @override
  String proxyPortInUse(String port) {
    return '連接埠 $port 已被其他程式使用，代理無法啟動。';
  }

  @override
  String get changePort => '變更連接埠';

  @override
  String get portDialogTitle => '選擇連接埠';

  @override
  String portDialogBody(String port) {
    return '連接埠 $port 已被佔用。下方已建議一個可用的連接埠，您也可以輸入其他連接埠。';
  }

  @override
  String get portChangeBody => '應用程式會連線到此連接埠。請選擇 1024 到 65535 之間的連接埠。';

  @override
  String get portLabel => '連接埠';

  @override
  String get portInvalid => '請輸入 1024 到 65535 之間的連接埠';

  @override
  String get portBusy => '這個連接埠也在使用中';

  @override
  String get portInUse => '其他程式正在使用此連接埠';

  @override
  String get save => '儲存';

  @override
  String get proxyPort => '代理連接埠';

  @override
  String get appPort => '應用程式連接埠';

  @override
  String get welcomeTitle => '歡迎';

  @override
  String get welcomeBody => '請選擇語言和國家。您所在國家的網站會直接開啟，不經過 VPN，速度更快，也更省流量。';

  @override
  String get start => '開始';

  @override
  String routingSuggestTitle(String country) {
    return '$country網站直接連線？';
  }

  @override
  String routingSuggestBody(String country) {
    return '$country的網站和 IP 將直接開啟，不經過 VPN。您可以在「分流」中變更。';
  }

  @override
  String get yes => '是';

  @override
  String get notNow => '暫時不要';

  @override
  String get navServers => '伺服器';

  @override
  String get navLogs => '記錄';

  @override
  String get realDelay => '真實延遲';

  @override
  String get statElapsed => '時長';

  @override
  String get statDown => '下載';

  @override
  String get statUp => '上傳';

  @override
  String noticePort(String port) {
    return 'Mozilla 的代理不會連線到連接埠 $port。只有 80、443、8080 和 8443 連接埠會經過 VPN。';
  }

  @override
  String get noticeCommand => 'VPN 不支援此類連線。';

  @override
  String noticeTimes(int count, String time) {
    return '$count 次，最近一次 $time';
  }

  @override
  String get dismiss => '知道了';

  @override
  String get modeRecommended => '推薦';

  @override
  String get modeFastest => '最快';

  @override
  String get modeRecommendedHint => '由 Mozilla 為您選擇位置。';

  @override
  String get modeFastestHint => '每次連線時自動選擇延遲最低的位置。';

  @override
  String get testDelay => '測試真實延遲';

  @override
  String get testingDelay => '正在測量…';

  @override
  String get search => '搜尋';

  @override
  String get noAnswer => '無回應';

  @override
  String testedAgo(String ago) {
    return '測試於 $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$total 個中有 $answered 個回應';
  }

  @override
  String get noServers => '尚無伺服器。核心連上 Mozilla 後就會顯示。';

  @override
  String get levelAll => '全部';

  @override
  String get filter => '篩選';

  @override
  String get follow => '自動捲動';

  @override
  String get clear => '清除';

  @override
  String get copyAll => '複製';

  @override
  String get logsCopied => '記錄已複製';

  @override
  String get noLogs => '尚無記錄。';

  @override
  String get sectionAccounts => '自動切換帳號';

  @override
  String get switchThreshold => '切換帳號門檻';

  @override
  String get switchThresholdHint => '流量用到此比例時，自動換下一個帳號。';

  @override
  String get signInMethod => '登入方式';

  @override
  String get signInMethodBrowser => '透過瀏覽器登入';

  @override
  String get signInMethodApi => '直接登入';

  @override
  String get browserSignInBroken => '無法開啟登入頁面。';

  @override
  String get browserSignInBlocked => 'Mozilla 未能完成新增帳號的最後一步（HTTP 406）。';

  @override
  String get browserSignInFallback => '使用電子郵件和密碼登入';

  @override
  String get backupExport => '儲存備份';

  @override
  String get backupImport => '匯入備份';

  @override
  String backupSaved(String name) {
    return '已儲存：$name';
  }

  @override
  String get backupImportTitle => '新增這些帳號？';

  @override
  String get backupAccountExists => '已新增；將使用檔案中的登入資訊';

  @override
  String get backupImportAction => '新增';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已新增 $count 個帳號',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS 伺服器';

  @override
  String get dnsSystem => '系統';

  @override
  String get dnsAuto => '自動（Cloudflare、Google、Quad9）';

  @override
  String get dnsCustom => '自訂';

  @override
  String get dnsCustomHint => '每行一個：https://…/dns-query、tls://… 或 IP 位址。';

  @override
  String get dnsFallback => '失敗時改用系統 DNS';

  @override
  String get testDns => '測試 DNS';

  @override
  String get transport => '通訊協定';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP 版本';

  @override
  String get ipVersionAuto => '自動（先 IPv4，再 IPv6）';

  @override
  String get ipVersionDual => '同時使用兩者（雙堆疊）';

  @override
  String get ipVersionV6First => '先 IPv6，再 IPv4';

  @override
  String get ipVersionV4 => '僅 IPv4';

  @override
  String get ipVersionV6 => '僅 IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint => 'VPN 介面的封包大小，1280 到 9000。留空：自動。';

  @override
  String get tunMtuInvalid => '1280 到 9000 之間的數字，或留空';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => '直接連線';

  @override
  String get directRulesHint =>
      '此清單中的網站和位址不經過 VPN，直接透過你自己的網路開啟。所選國家的規則已在此處：可以新增、修改或刪除。選擇其他國家會換成該國的規則。';

  @override
  String get restoreRegionRules => '還原該地區的規則';

  @override
  String get blockRules => '封鎖';

  @override
  String get blockRulesHint => '此清單中的網站和位址完全無法開啟，無論直連或透過 VPN：適用於廣告或你永遠不想連上的網站。';

  @override
  String get rulesTitle => '規則';

  @override
  String get ruleSyntaxTitle => '如何撰寫規則';

  @override
  String get resolveDomains => 'IP 規則也套用於網域';

  @override
  String get routingLists => 'Geo 檔案';

  @override
  String get listSource => '清單來源';

  @override
  String get listSourceCustom => '手動設定';

  @override
  String listsUpdatedAgo(String ago) {
    return '更新於 $ago';
  }

  @override
  String get updateLists => '更新 Geo 檔案';

  @override
  String get listsUpdated => 'Geo 檔案已更新。';

  @override
  String get testDestination => '測試路由';

  @override
  String get destinationHint => '網域、IP 或網址';

  @override
  String get check => '檢查';

  @override
  String get routeDirect => '直接連線';

  @override
  String get routeProxy => '經過 VPN';

  @override
  String get routeBlock => '已封鎖';

  @override
  String ruleMatched(String rule) {
    return '規則：$rule';
  }

  @override
  String get portRefusedNote => 'Mozilla 的代理不會連線到此連接埠。';

  @override
  String get sectionAdvanced => '進階';

  @override
  String get tlsFragment => 'TLS 分片';

  @override
  String get tlsFragmentOff => '關閉';

  @override
  String get tlsFragmentFirstByte => '首位元組';

  @override
  String get tlsFragmentSni => '伺服器名稱 (SNI)';

  @override
  String get tlsFragmentFirstByteHint => '在首位元組處拆分 TLS 標頭 (0x16)';

  @override
  String get tlsFragmentSniHint => '將伺服器名稱 (SNI) 拆分到多個 TCP 封包';

  @override
  String get tlsFragmentRecord => 'TLS 記錄';

  @override
  String get tlsFragmentRecordHint => '將伺服器名稱 (SNI) 拆分到兩筆 TLS 記錄';

  @override
  String get tlsFragmentOffHint => '一般 TLS 連線';

  @override
  String get sectionBypass => '如果 Mozilla 被封鎖';

  @override
  String get sharedRelay => '共用中繼';

  @override
  String get sharedRelayHint => '如果 Mozilla 封鎖了你所在的地區，則使用應用程式的共用中繼。已啟用的個人中繼優先。';

  @override
  String get personalRelay => '個人中繼';

  @override
  String get apiRelay => '中繼伺服器';

  @override
  String get apiRelayUse => '使用中繼伺服器';

  @override
  String get apiRelayHint =>
      '你自己的 Cloudflare Worker，或你自己主機上的 relay.php。\n僅在 Mozilla 無法直接回應時使用：登入、帳戶和伺服器清單經過它，VPN 流量不經過。';

  @override
  String get upstreamProxy => '上游代理';

  @override
  String get upstreamProxyOn => '上游代理已開啟';

  @override
  String get upstreamProxyAddress => 'SOCKS5 代理位址';

  @override
  String get upstreamProxyPort => '連接埠';

  @override
  String get upstreamProxyHint =>
      '與 Mozilla 的連線會經過此代理，適用於封鎖或限速 Mozilla 的網路。\n如果代理在本裝置上執行，請將其排除在 VPN 之外。';

  @override
  String get upstreamProxyInvalid => '請輸入代理位址，例如 127.0.0.1。';

  @override
  String get upstreamProxyInvalidPort => '請輸入 1 到 65535 之間的連接埠。';

  @override
  String get upstreamProxyOwn => '這是本應用程式自己的代理。請輸入其他代理。';

  @override
  String get apiRelayInvalid => '必須是 https:// 位址。';

  @override
  String get listenAddress => '允許連線的裝置';

  @override
  String get listenLocal => '127.0.0.1 · 僅本裝置';

  @override
  String get listenAll => '0.0.0.0 · 所有網路（LAN）';

  @override
  String get proxyUsername => '代理使用者名稱';

  @override
  String get proxyPassword => '代理密碼';

  @override
  String get proxyLoginHint => '應用程式需使用這組帳密連線到代理。兩者都留空則不需驗證。';

  @override
  String get loginBothOrNone => '請同時填寫兩項，或都留空。';

  @override
  String get proxyLogin => '代理驗證';

  @override
  String get idleSleep => '閒置多久後休眠';

  @override
  String get sleepNever => '從不';

  @override
  String sleepMinutes(int count) {
    return '$count 分鐘';
  }

  @override
  String get sleepHour => '1 小時';

  @override
  String get showPublicIp => '顯示公用 IP';

  @override
  String get hapticFeedback => '連線狀態變更時震動';

  @override
  String get keepScreenOn => '連線期間保持螢幕恆亮';

  @override
  String get showTraffic => '在首頁顯示即時流量';

  @override
  String get speedInNotification => '在通知中顯示速度';

  @override
  String get liveTraffic => '即時流量';

  @override
  String get totalTraffic => '總流量';

  @override
  String get verboseLogs => '詳細記錄';

  @override
  String get webDashboard => '網頁控制台';

  @override
  String get webDashboardOpen => '開啟';

  @override
  String get webDashboardHint => '進階設定和更多工具';

  @override
  String numberInvalid(int min, int max) {
    return '請輸入 $min 到 $max 之間的數字';
  }

  @override
  String get notifySwitchedTitle => '已切換帳號';

  @override
  String notifySwitchedBody(String name) {
    return '現在使用 $name。';
  }

  @override
  String get notifySignInTitle => '需要登入';

  @override
  String get notifySignInBody => '有帳號需要在「帳號」頁面重新登入。';

  @override
  String get navAbout => '關於';

  @override
  String get appVersionLabel => '應用程式版本';

  @override
  String get coreVersionLabel => '核心版本';

  @override
  String get checkUpdates => '檢查更新';

  @override
  String get checkingUpdates => '正在檢查…';

  @override
  String get upToDate => '已是最新版本。';

  @override
  String updateAvailable(String version) {
    return '已有新版本 $version。';
  }

  @override
  String updateRequired(String version) {
    return '請更新至 $version 版本。此更新為必要更新。';
  }

  @override
  String get download => '下載';

  @override
  String updateCheckFailed(String error) {
    return '無法檢查更新：$error';
  }

  @override
  String get updateCheckNoNetwork => '無法連線到 GitHub。請檢查網路連線後再試一次。';

  @override
  String get updateNow => '更新';

  @override
  String updateDownloading(String version) {
    return '正在下載版本 $version…';
  }

  @override
  String updateReady(String version) {
    return '版本 $version 已可安裝。';
  }

  @override
  String updateInstalling(String version) {
    return '正在安裝版本 $version，應用程式將關閉並重新開啟。';
  }

  @override
  String updateFailed(String version) {
    return '無法更新至版本 $version。';
  }

  @override
  String updateDone(String version) {
    return '已更新至版本 $version。';
  }

  @override
  String updateRolledBack(String version) {
    return '更新至版本 $version 未能完成，應用程式已恢復為先前的版本。';
  }

  @override
  String get repoNotSet => '尚未設定 GitHub 儲存庫。';

  @override
  String get sourceCode => '原始碼';

  @override
  String get tapToConnect => '按一下以連線';

  @override
  String get tapToDisconnect => '按一下以中斷連線';

  @override
  String get startOnBoot => '開機啟動';

  @override
  String get connectOnStartup => '開機自動連線';

  @override
  String get proxyServiceActive => '代理服務執行中';

  @override
  String get navHome => '首頁';

  @override
  String get groupApp => '應用程式';

  @override
  String get groupNetwork => '網路';

  @override
  String get stateOff => '未連線';

  @override
  String get tapToConnectPhone => '輕觸以連線';

  @override
  String get tapToDisconnectPhone => '輕觸以中斷連線';

  @override
  String get tapToConnectTv => '按 OK 鍵連線';

  @override
  String get tapToDisconnectTv => '按 OK 鍵中斷連線';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => '推薦位置';

  @override
  String dataLeftOf(String limit) {
    return '共 $limit';
  }

  @override
  String get homeLocation => '位置';

  @override
  String get connectedTo => '已連線到';

  @override
  String get vpnNotAllowed => 'VPN 需要您的許可。請再次輕觸按鈕並允許。';

  @override
  String get dataUsedTitle => '已用流量';

  @override
  String get bypassApps => '個別應用程式代理';

  @override
  String get connectRetrying => '無法連線。請檢查網路。';

  @override
  String get failUnreachable => '無法連線到 Mozilla 的伺服器。請嘗試其他網路。';

  @override
  String get failUpstreamProxy => '無法透過上游代理連線到 Mozilla。請檢查代理是否正在執行。';

  @override
  String get failInsideVpn => '此網路已經通過 VPN。請將其關閉。';

  @override
  String get failRefused => 'Mozilla 伺服器拒絕了連線。請幾分鐘後再試。';

  @override
  String get failLocationRefused => '這個國家未對您的帳號開放。請選擇其他國家。';

  @override
  String get useRecommendedLocation => '使用推薦位置';

  @override
  String exitMismatch(String exit, String chosen) {
    return '您選擇了$chosen，但您的 IP 位於$exit。';
  }

  @override
  String get failSignIn => '此帳號的登入已過期。請在「帳號」頁面重新登入。';

  @override
  String get failQuota => '本月流量已用完。請新增另一個帳號。';

  @override
  String get failNotEntitled => 'Mozilla 不允許此帳號使用 VPN。請新增另一個帳號。';

  @override
  String get failRegion => 'Mozilla 不在您所在的國家提供服務。';

  @override
  String get failServer => 'Mozilla 服務暫時發生問題。應用程式會自動重試。';

  @override
  String get failNoAccount => '沒有可用的帳號。請開啟「帳號」頁面。';

  @override
  String get failTestSite => '已連線伺服器，但網站打不開。請換個國家試試。';

  @override
  String get failOther => '無法連線。請再試一次。';

  @override
  String get failNoInternet => '無網路連線。請檢查 Wi-Fi 或行動數據。';

  @override
  String get waitingForNetwork => '正在等待網路連線…';

  @override
  String proxyStartFailed(String port) {
    return '代理無法在連接埠 $port 上啟動。請選擇其他連接埠。';
  }

  @override
  String get connectionSettings => '連線設定';

  @override
  String get appModeExclude => '排除所選應用程式';

  @override
  String get appModeInclude => '僅代理所選應用程式';

  @override
  String get appModeExcludeHint => '所選應用程式直接連線，不經過 VPN：例如會拒絕境外 IP 的銀行應用程式。';

  @override
  String get appModeIncludeHint => '只有所選應用程式經過 VPN；其他應用程式直接連線。';

  @override
  String fromRegionList(String region) {
    return '推薦：列於$region清單中';
  }

  @override
  String get modeProxy => '代理';

  @override
  String get connectionMode => '連線模式';

  @override
  String get modeProxyHint => '只有已設定使用代理的應用程式會經過代理。';

  @override
  String get modeSystemProxyHint => 'Windows 和大多數應用程式都會經過代理。';

  @override
  String get modeSystemProxyHintOther => '瀏覽器和大多數應用程式都會經過代理。';

  @override
  String get suggestedApps => '推薦的應用程式';

  @override
  String get showSystemApps => '顯示系統應用程式';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已選取 $count 個推薦的應用程式',
      one: '已選取 1 個推薦的應用程式',
      zero: '推薦的應用程式都已選取',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => '自動';

  @override
  String get locationsSection => '位置';

  @override
  String get dnsSummaryOk => '加密 DNS 運作正常';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個網域無法解析',
      one: '1 個網域無法解析',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return '透過 $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '您網路的 DNS 對 $count 個網域回傳了過濾用的位址，本應用程式不會用它解析這些網域。',
      one: '您網路的 DNS 對 1 個網域回傳了過濾用的位址，本應用程式不會用它解析這些網域。',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => '結果：';

  @override
  String get dnsNetworkAnswer => '網路 DNS：';

  @override
  String get dnsFiltered => '已過濾';

  @override
  String get rulesSyntaxTitle => '每行一條規則';

  @override
  String get ruleDomain => '該網站及其子網域';

  @override
  String get ruleFull => '完全符合此網域';

  @override
  String get ruleKeyword => '包含此關鍵字的網域';

  @override
  String get ruleGeosite => 'Geo 檔案中某個標籤的網站';

  @override
  String get ruleGeoip => 'Geo 檔案中某個國家的位址';

  @override
  String get ruleIp => '單一 IP 或網段';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => '僅代理';

  @override
  String get noNetwork => '沒有網路連線。請開啟 Wi-Fi 或行動數據。';

  @override
  String get blockAds => '封鎖廣告';

  @override
  String systemProxyTakenBy(String address) {
    return '另一個程式將系統代理改為 $address，流量不再經過 VPN。';
  }

  @override
  String get systemProxyTakenOff => '另一個程式關閉了系統代理，流量不再經過 VPN。';

  @override
  String get setSystemProxyAgain => '重新設定';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return '$os 的所有流量都會經過 VPN。';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting => '正在等待安裝 TUN 服務的許可…';

  @override
  String get tunInstallCancelled => 'TUN 模式需要一次系統管理員權限。未取得權限，模式未變更。';

  @override
  String tunInstallFailed(String error) {
    return '無法安裝 TUN 服務：$error';
  }

  @override
  String get tunStarting => '正在開啟 TUN 模式…';

  @override
  String get tunFailed => 'TUN 模式未能開啟，正在重試…';

  @override
  String get tunLost => 'TUN 模式意外停止，正在重試…';

  @override
  String get tunNotRunning => 'TUN 服務未在執行，正在重試…';

  @override
  String get tunMissing => 'TUN 服務未安裝。';

  @override
  String get tunOutdated => 'TUN 服務比此應用程式舊。請重新安裝以使用 TUN 模式。';

  @override
  String get tunAppOutdated => 'TUN 服務比此應用程式新。請更新應用程式以使用 TUN 模式。';

  @override
  String get tunBusy => '另一個 Homa VPN 副本正在使用 TUN 模式。';

  @override
  String get tunNoDriver => '系統的 TUN 驅動程式無法使用。請重新啟動電腦後再試一次。';

  @override
  String get tunInstall => '安裝';

  @override
  String get tunInstallAgain => '重新安裝';

  @override
  String get trayTunMode => 'TUN 模式（所有應用程式）';

  @override
  String get removeTunService => '移除 TUN 服務';

  @override
  String get removeTunServiceHint => '移除 TUN 模式使用的系統服務。再次選擇 TUN 時會重新安裝。';

  @override
  String get tunServiceRemoved => '已移除 TUN 服務。';

  @override
  String get tunInstallPrompt => 'Homa VPN 想要安裝 TUN 模式的服務。';

  @override
  String get tunRemovePrompt => 'Homa VPN 想要移除 TUN 模式的服務。';

  @override
  String tunRemoveFailed(String error) {
    return '無法移除 TUN 服務：$error';
  }

  @override
  String get sectionTun => 'TUN 設定';

  @override
  String get tunPrograms => '繞過 VPN 的程式';

  @override
  String get tunProgramsHint => '它們直接連線，不經過 Mozilla。僅適用於不用 VPN 也能正常運作的程式。';

  @override
  String get tunProgramsEmpty => '還沒有程式。';

  @override
  String get addProgram => '新增程式';

  @override
  String get programFiles => '程式';

  @override
  String get tunProgramAll => '全部流量';

  @override
  String get tunProgramAllHint => '整個程式直接連線。';

  @override
  String get tunProgramUdp => '僅 UDP';

  @override
  String get tunProgramUdpHint => '僅其 UDP 直接連線；其餘流量經過 VPN。';

  @override
  String get udpNoticeSetting => 'UDP 被封鎖時提示';

  @override
  String udpNoticeBody(String program) {
    return '$program 的 UDP 流量無法經過 VPN。';
  }

  @override
  String get dontShowAgain => '不再顯示';

  @override
  String get addRunningProgram => '從正在執行的程式中選擇';

  @override
  String get addProgramFile => '選擇檔案…';

  @override
  String get addProgramName => '輸入名稱…';

  @override
  String get programNameHint =>
      '程式的檔案名稱，例如 steam.exe；* 代表任意文字（steam* 即 Steam 的所有程式）。';

  @override
  String get runningProgramsEmpty => '沒有其他正在執行的程式。';

  @override
  String get tabLog => '記錄';

  @override
  String get tabConnections => '連線';

  @override
  String get connectionsEmpty => '尚無連線。';

  @override
  String connectionsOpen(int count) {
    return '$count 個開啟';
  }

  @override
  String get connTime => '時間';

  @override
  String get connRoute => '規則';

  @override
  String get connDestination => '目標';

  @override
  String get connInbound => '入站';

  @override
  String get connProtocol => '協定';

  @override
  String get connColumns => '欄';

  @override
  String get connTraffic => '流量';

  @override
  String get connDuration => '時長';

  @override
  String get connRouteVpn => '代理';

  @override
  String get connRouteDirect => '直連';

  @override
  String get connRouteBlocked => '已封鎖';

  @override
  String get connRoutePort => '連接埠被拒';

  @override
  String get connRouteFailed => '失敗';

  @override
  String get testRelay => '測試中繼狀態';

  @override
  String get relayTestTitle => '中繼狀態測試';

  @override
  String get relayTestHint => '僅檢查中繼，不向 Mozilla 傳送請求或帳戶資訊。';

  @override
  String get relayTestPassed => '中繼已就緒';

  @override
  String get relayTestFailed => '無法確認中繼狀態';

  @override
  String get relayTestCopy => '複製報告';

  @override
  String get relayTestInterrupted => '測試在收到完整結果前結束。';

  @override
  String get searchLocations => '搜尋位置';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個位置',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => '自動更新';

  @override
  String get autoInstallApkHint => '自動下載新版本；安裝前安裝程式會先詢問。';

  @override
  String get installNow => '安裝';

  @override
  String get updateAllowInstall => '如需安裝更新，請允許此應用程式安裝應用程式。';

  @override
  String get allowInstall => '允許';

  @override
  String get noResults => '沒有符合搜尋的位置。';

  @override
  String get accentColor => '強調色';

  @override
  String get accentMono => '單色（預設）';

  @override
  String get accentCustom => '自訂顏色';

  @override
  String get accentEmber => '火焰';

  @override
  String get accentGold => '金色';

  @override
  String get accentEmerald => '祖母綠';

  @override
  String get accentSapphire => '藍寶石';

  @override
  String get accentAmethyst => '紫水晶';

  @override
  String get accentRose => '玫瑰';

  @override
  String get autoReconnect => '自動重新連線';

  @override
  String get autoReconnectHint => '連線意外中斷時自動重新連線。';

  @override
  String get androidOnlyHint => '僅限手機。';

  @override
  String get idleDisconnect => '閒置時中斷連線';

  @override
  String get idleDisconnectHint => '一段時間沒有流量時結束此次工作階段。';

  @override
  String get idleTimeout => '閒置時限';

  @override
  String get minutes5 => '5 分鐘';

  @override
  String get minutes10 => '10 分鐘';

  @override
  String get minutes15 => '15 分鐘';

  @override
  String get minutes30 => '30 分鐘';

  @override
  String get minutes60 => '1 小時';

  @override
  String get dataLimit => '工作階段流量上限';

  @override
  String get dataLimitHint => '流量達到上限時結束此次工作階段。';

  @override
  String get dataLimitAmount => '上限';

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
    return '已有 $minutes 分鐘沒有流量，連線已中斷。';
  }

  @override
  String autoStoppedData(int mb) {
    return '工作階段流量達到 $mb MB 上限，連線已中斷。';
  }

  @override
  String get protection => '保護';

  @override
  String get killSwitch => '緊急斷流保護';

  @override
  String get killSwitchHint => 'VPN 中斷時攔截流量——絕不外洩——直至重新連線。';

  @override
  String get alwaysOnVpn => 'VPN 常開';

  @override
  String get alwaysOnVpnHint => 'Android 內建的防護：沒有 VPN 就不放行任何連線。';

  @override
  String get floatingIsland => '懸浮島';

  @override
  String get floatingIslandHint => '離開應用程式時，在其他應用程式上方顯示連線狀態。';

  @override
  String whatsNewTitle(String version) {
    return '版本 $version 的新功能';
  }

  @override
  String get whatsNewContinue => '知道了';

  @override
  String get whatsNewMenu => '版本更新內容';

  @override
  String get whatsNewView => '再次檢視';

  @override
  String get updateServers => '更新伺服器';

  @override
  String get updatingServers => '正在更新…';

  @override
  String serversUpdated(int count) {
    return '來自 Mozilla 官方清單的 $count 個位置';
  }

  @override
  String get serversUpdateFailed => '伺服器清單更新失敗；已保留原清單。';

  @override
  String get smartPickTitle => '目前最快';

  @override
  String get smartPickUse => '使用';

  @override
  String get connectAtBoot => '開機後自動連線';

  @override
  String get connectAtBootHint => '開機時自動連線（需已授予 VPN 權限）。';

  @override
  String get gamingProfile => '遊戲模式';

  @override
  String get gamingProfileHint => '即時顯示連線延遲與品質；搭配實測最快伺服器。';

  @override
  String get diagnosticsRun => '執行診斷';

  @override
  String get diagnosticsHint => '一鍵檢查連線、DNS 與通道';

  @override
  String get diagnosticsTunnel => '通道';

  @override
  String get diagnosticsTunnelUp => '已建立並在傳輸流量';

  @override
  String get diagnosticsTunnelDown => '未連線';

  @override
  String get diagnosticsExit => '出口國家';

  @override
  String get diagnosticsMismatch => '出口國家與所選不符';

  @override
  String get diagnosticsConnection => '連線測試';

  @override
  String get diagnosticsPassed => '通過';

  @override
  String get diagnosticsFailed => '失敗';

  @override
  String get diagnosticsDnsFiltered => '回應被攔截或過濾';

  @override
  String get diagnosticsDnsOk => '有回應';

  @override
  String get diagnosticsPrivacy => '診斷結果不會儲存；僅顯示於此視窗與核心自身日誌。';

  @override
  String get diagnosticsAgain => '再次執行';

  @override
  String get whatsNewAdded => '新增';

  @override
  String get whatsNewImproved => '改進';

  @override
  String get whatsNewFixed => '修復';

  @override
  String get wnWheelImproved =>
      '國家轉盤重新繪製：選中的旗幟以玻璃框呈現，帶精細光暈與身後柔和光圈，尺寸更大；其餘旗幟更小且有層次感；下方的名稱以滑動動畫出現。';

  @override
  String get wnLiveImproved =>
      '連線期間，通知會像參考實作那樣請求 Android 16 將其提升為即時動態（Live Update）；時長自動計時，速度即時更新。';

  @override
  String get wnL10nFixed => '本頁面現在會跟隨應用程式語言顯示——全部十五種語言，而不只是英文。';

  @override
  String get wnMarkFixed => 'Mozilla 標誌乾淨地呈現在其色塊上，圓角與旗幟一致。';

  @override
  String get designTitle => '主頁設計';

  @override
  String get designHint => '主頁的佈局方式';

  @override
  String get designWheel => '轉盤';

  @override
  String get designWheelDesc => '旗幟排在玻璃轉盤上，開關在下方';

  @override
  String get designBento => '拼塊';

  @override
  String get designBentoDesc => '圓角拼塊面板：連線、數字、位置';

  @override
  String get designPixel => '精簡';

  @override
  String get designPixelDesc => '一張安靜的卡片：位置、開關、數字';

  @override
  String get notifFlag => '通知中的國旗';

  @override
  String get notifFlagHint => '該國自己的旗幟顯示在名稱旁';

  @override
  String get wnDesignAdded => '新增主頁設計設定：轉盤、拼塊或精簡卡片';

  @override
  String get wnMapAdded => '主頁背景換成真實的向量世界地圖，選中的國家會被點亮';

  @override
  String get wnWheelAdded => '旗幟轉盤重繪：玻璃更深邃、動效更順暢';

  @override
  String get wnFlagNotifAdded => '通知可顯示國家的 SVG 國旗，也可關閉';

  @override
  String get wnColorRemoved => '移除了自訂顏色頁面；強調色清單仍支援 HEX 碼';

  @override
  String get whatsNewRemoved => '已移除';

  @override
  String get wnCrashFixed => '應用程式不再在 Android 16 手機上自行停止：通知向系統要求了手機還沒有的東西。';

  @override
  String get wnFlagArtFixed => '應用程式開啟後不再把自己踢出去：通知的國旗圖片回傳了系統訊息通道不接受的值。';

  @override
  String get statSession => '工作階段';

  @override
  String get copiedToClipboard => '已複製到剪貼簿';

  @override
  String get wnTotalsAdded => '主頁顯示本次工作階段的總流量，輕點即可複製公共 IP。';

  @override
  String get wnPolishImproved => '旗幟轉輪和伺服器頁面更整潔；文字更緊湊，Android 隧道以更高的速度傳輸流量。';

  @override
  String get valueSmart => '智慧';

  @override
  String get wnSmartAdded => '智慧連線：MTU、通訊協定與 IP 版本跟隨網路，按真實回應選擇，以速度為先。';

  @override
  String get wnToastAdded => '確認提示現在以 iOS 風格輕柔呈現，圖示會自己畫出。';

  @override
  String get wnFlagsImproved => '旗幟轉輪乾淨俐落：邊緣不再切半面旗，旗幟完整呈現，選擇輕輕彈落。';

  @override
  String get wnMapImproved => '世界地圖更大更清晰：不再壓縮大陸，海岸線平滑，落點處有光暈。';

  @override
  String get dnsManual => '手動 DNS';

  @override
  String get dnsManualHint =>
      '每行一個位址：普通 IP、https://（DNS over HTTPS）或 tls://host（DNS over TLS）。以最先應答者為準。';

  @override
  String get dnsManualInvalid => '有一行不是核心可用的位址：普通 IP、https://… 或 tls://host。';

  @override
  String get killSwitchGuarded => '守護中：隧道中斷期間，沒有任何資料離開手機。';

  @override
  String get accountsUsageTitle => '本月';

  @override
  String get accountsCountLabel => '個帳戶';

  @override
  String get accountsUsageAverage => '各帳戶已用份額的平均值';

  @override
  String get wnDesignsAdded =>
      '應用程式設計：整個應用程式可以換上柔軟新擬態或極光玻璃——每一頁、每一張卡片——在 設定 → 一般 中選擇。';

  @override
  String get wnWheelFixed => '轉輪的半面旗消失了：選中旗幟下方的擱板是一泓光，不再是第二面旗，螢幕邊緣也不會切掉任何旗幟。';

  @override
  String get wnMapReal => '世界地圖依據各國官方邊界重新繪製——每一處海岸、島嶼與飛地都忠實呈現，比例真實。';

  @override
  String get wnGlobeAdded => '世界變成了地球儀：銀色球體會轉向所選國家，發光的定位針與懸浮卡片標記它，連線的路線伸向各樞紐。';

  @override
  String get wnWheelGlowImproved =>
      '選中的旗幟在藍色光暈與玻璃邊框中更大更醒目，兩側旗幟明顯更小，轉輪下方的指示點顯示目前位置。';

  @override
  String get wnDesignsRemoved => '應用程式設計選項已移除：應用程式恢復原本的單色外觀——您的強調色與主題保持不變。';

  @override
  String get wnDnsAdded =>
      '手動 DNS：普通 IP、DNS over HTTPS 與 DNS over TLS——每一行的類型隨手輸入即時顯示並校驗。';

  @override
  String get wnSmartImproved => '智慧連線現在即時顯示網路的回答：它選中的傳輸方式與保留的 IP 版本。';

  @override
  String get wnProtectionImproved => 'Kill Switch 會在守護生效時說明狀態，應用頁面會顯示你選擇的應用數量。';

  @override
  String get wnWelcomeImproved => '歡迎頁以一面呼吸的盾牌配上流動的極光開場，帳戶頁則將整月用量一覽彙總。';

  @override
  String bypassAppsCount(String n) {
    return '已選：$n';
  }

  @override
  String get sectionAppearance => '外觀';

  @override
  String get mapStyle => '地圖樣式';

  @override
  String get mapStyleHint => '主頁的地球會按您的選擇上色，連線的燈光保持不變。';

  @override
  String get mapSilver => '銀色';

  @override
  String get mapMidnight => '午夜';

  @override
  String get mapOcean => '海洋';

  @override
  String get mapMono => '單色';

  @override
  String get mapAurora => '極光';

  @override
  String get batterySaver => '省電模式';

  @override
  String get batterySaverHint => '連線時讓地圖動效安歇——地球的呼吸、轉輪的光暈。連線本身完全不受影響。';

  @override
  String get connectOnOpen => '開啟應用程式時連線';

  @override
  String get connectOnOpenHint => '應用程式一開啟就連上 VPN，使用您上次選擇的位置。';

  @override
  String get speedTitle => '速度';

  @override
  String get parallelTunnels => '並行隧道';

  @override
  String get parallelTunnelsHint =>
      '同時開啟多條通往 Mozilla 的隧道並分擔流量，單條慢隧道不再限制速度。八條對電池負擔最大。';

  @override
  String get tunnels1 => '一條——最穩定';

  @override
  String get tunnels2 => '兩條';

  @override
  String get tunnels4 => '四條——慢網路下更快';

  @override
  String get tunnels8 => '八條——最快';

  @override
  String get connectionCap => '連線數上限';

  @override
  String get connectionCapHint =>
      '多少應用程式可以同時透過 VPN 通訊；更小的上限在繁忙的手機上省電省流量。預設不限制。';

  @override
  String get capNone => '不限制';

  @override
  String get verboseLogging => '詳細診斷';

  @override
  String get verboseLoggingHint => '把每一步都寫進日誌——回報問題時很有用，略微多耗一點電。';

  @override
  String get wn38MapStylesAdded =>
      '地圖的五種外觀：銀色、午夜、海洋、單色和極光——在設定裡新增的「外觀」頁選擇，每種都有預覽。';

  @override
  String get wn38ZoomAdded => '地圖可以縮放：雙指捏合，或雙擊放大、再次雙擊還原。';

  @override
  String get wn38OptionsAdded => '實用的新選項：並行隧道提升速度、連線數上限、省電模式、開啟應用程式時連線，以及詳細診斷。';

  @override
  String get wn38SocialAdded => 'Instagram 和 Telegram 現在也在這個頁面的底部。';

  @override
  String get wn38FlightImproved =>
      '選擇國家變成了一次小小的飛行：鏡頭後拉，球體轉動，圖釘帶彈跳落下，路徑自行延伸到各樞紐。';

  @override
  String get wn38EffectsImproved =>
      '地圖更耐看了：球體背後的星辰、座標網格、樞紐自己的光點、邊緣的光暈，還有陸地的陰影。';

  @override
  String get wn38SpeedImproved => '速度選項是真實的：並行隧道同時開啟多條連線，核心在它們之間分配流量。';

  @override
  String get wn38NameFixed => '所選國家的名稱只顯示一次——在地圖的懸浮卡片上；旗幟下方的重複文字已移除。';

  @override
  String get mapKind => '地圖類型';

  @override
  String get mapKindHint =>
      '主頁的世界如何呈現：一如既往的平面地圖（預設）、其現代風格、夜晚地球、地形地球、金屬球體，或衛星地球。';

  @override
  String get mapKindClassic => '經典';

  @override
  String get mapKindGlobe => '3D 球體';

  @override
  String get mapKindSatellite => '衛星';

  @override
  String get mapKindFlat => '平面 2D';

  @override
  String get mapStyleGlobeHint => '3D 球體的配色。衛星有自己的地球，平面地圖有自己的墨色。';

  @override
  String get aboutVersions => '版本';

  @override
  String get aboutChannels => '聯絡頁面';

  @override
  String get checkUpdatesHint => '查找更新的版本；找到後會下載，並由安裝器進行確認。';

  @override
  String get speedTestTitle => '速度測試';

  @override
  String get speedTestRun => '測量';

  @override
  String get speedTestFailed => '測量未完成。';

  @override
  String get speedTestThrough => '經由隧道測得。';

  @override
  String get speedTestDirect => '直接測得（代理已關）。';

  @override
  String get speedTestHint => '經由隧道的一次下載與一次上傳，才說明它真正能承載多少。主頁的圖表也會開啟這裡。';

  @override
  String get speedGraphHint => '隧道最近一分鐘 · 點按測量';

  @override
  String get favoritePinned => '已固定。再次長按可取消。';

  @override
  String get favoriteUnpinned => '已取消固定。';

  @override
  String get shareReport => '分享報告';

  @override
  String get shareReportCopied => '報告已放入剪貼簿。';

  @override
  String get batteryWizardTitle => '在電池下存活';

  @override
  String get batteryWizardBody =>
      '小米、三星、華為等廠商會在鎖屏後殺死 VPN 應用。把這個應用移出電池最佳化，隧道才會一直在線。';

  @override
  String get batteryWizardSteps =>
      '在廠商自己的設定裡也允許自動啟動，並把應用設為「無限制」（小米）、「移出睡眠應用」（三星）或「手動啟動」（華為）。';

  @override
  String get batteryWizardState => '電池最佳化可能中斷隧道。';

  @override
  String get batteryWizardPermit => '允許';

  @override
  String get batteryWizardOk => '隧道已受電池保護。';

  @override
  String get batteryWizardOpen => '電池設定';

  @override
  String get usageTitle => '應用用量';

  @override
  String get usageRowHint => '每個應用用了多少';

  @override
  String get usageGrant => '開啟使用情況權限';

  @override
  String get usageGrantHint =>
      'Android 把每個應用的流量用量放在「使用情況存取權」後面。按鈕開啟的頁面屬於系統；本應用只讀取數字。';

  @override
  String get usageEmpty => '此時間段沒有記錄用量。';

  @override
  String get usageToday => '今天';

  @override
  String get usageWeek => '最近 7 天';

  @override
  String get usageMonth => '最近 30 天';

  @override
  String get playProtectTitle => 'Google Play 保護';

  @override
  String get playProtectBody =>
      '本應用程式從 Google Play 以外安裝，首次安裝時 Play Protect 可能要求掃描。點一次「掃描應用程式」即可——乾淨的掃描會被記住，之後更新不會再出現此提示。';

  @override
  String get smartLocation => '最快位置';

  @override
  String get smartLocationHint => '每次啟動都落在核心延遲實測最快的伺服器上。';

  @override
  String get quicPass => 'QUIC 直通';

  @override
  String get quicPassHint => '應用的 QUIC（UDP 443）從隧道通過：通話和遊戲保持速度，不再回退到 TCP。';

  @override
  String get accountRename => '重新命名帳戶';

  @override
  String get accountRenameLabel => '帳戶名稱';

  @override
  String get accountProfile => '個人頭像';

  @override
  String get avatarReset => '恢復預設頭像';

  @override
  String get accountSecurity => '應用程式密碼';

  @override
  String get appPasswordOn => '應用程式在密碼保護下開啟。';

  @override
  String get appPasswordOff => '未設密碼：任何開啟應用程式的人都能進入。';

  @override
  String get appPasswordSet => '設定密碼';

  @override
  String get appPasswordChange => '修改密碼';

  @override
  String get appPasswordRemove => '移除密碼';

  @override
  String get appPasswordCurrent => '目前密碼';

  @override
  String get appPasswordNew => '新密碼（4 個字元以上）';

  @override
  String get appPasswordConfirm => '重複新密碼';

  @override
  String get appPasswordShort => '至少 4 個字元。';

  @override
  String get appPasswordMismatch => '兩次輸入的密碼不一致。';

  @override
  String get appPasswordWrong => '密碼錯誤';

  @override
  String get appPasswordSetDone => '密碼已設定——下次啟動應用程式時會要求輸入。';

  @override
  String get appPasswordRemoved => '密碼已移除；應用程式可直接開啟。';

  @override
  String get appPasswordUnlock => '應用程式已鎖定';

  @override
  String get appPasswordUnlockHint => '輸入應用程式密碼以繼續。';

  @override
  String get wn39MapKinds => '地圖重新可選類型：一如既往的平面地圖（預設）、3D 球體、衛星地球和現代平面 2D。';

  @override
  String get wn39EyeIp => '位置卡片帶有眼睛圖示：點按可查看流量出口位址並複製。';

  @override
  String get wn39Profile => '帳戶可擁有自己的名稱與頭像，應用程式也可以在密碼保護下開啟。';

  @override
  String get wn39Smart => '智慧連接更完整：按真實延遲選擇最快位置，並為通話和遊戲提供 QUIC 直通。';

  @override
  String get wn39Flight => '切換國家飛行更順滑——相機沿大圓弧移動——旗幟輪盤的指示點也更貼近旗幟。';

  @override
  String get wn39ToastEverywhere => '動態通知現在無所不在：每一次儲存、複製和失敗都穿上同一枚動畫玻璃膠囊。';

  @override
  String get wn39Updates => '更新保持儲存空間乾淨：安裝器直接替換舊版本，不留任何安裝包。';

  @override
  String get mapKindNight => '夜晚';

  @override
  String get mapKindTerrain => '地形';

  @override
  String get wn40MapKindsNew => '地圖新增兩種樣式：夜晚地球與地形地球。';

  @override
  String get wn40Flight => '3D 球體以一次平滑的旋轉飛向新國家——絕不再生硬跳變。';

  @override
  String get wn40Mercator => '平面地圖改用標準墨卡托投影：真實比例、標準邊界、毫無擠壓變形。';

  @override
  String get wn40NameBack => '平面地圖上，所選國家的名稱重新出現在旗幟下方。';

  @override
  String get wn40Speed => '隧道預設開啟兩條並行工作階段——線路更強勁、更穩定。';

  @override
  String get wn40LockFixed => '連接按鈕上的鎖在狀態切換時不再閃爍消失。';

  @override
  String get wn40IpRemoved => '位置卡片上的 IP 彈窗已移除。';

  @override
  String get soundFeedback => '音效';

  @override
  String get soundFeedbackHint => '輕觸、開關與連接切換時的輕柔音效';

  @override
  String get rateUnit => '速度單位';

  @override
  String get lockInBackground => '離開後重新上鎖';

  @override
  String get lockBgNever => '從不';

  @override
  String get lockBgNow => '立即';

  @override
  String get lockBgMin5 => '5 分鐘後';

  @override
  String get lockBgMin15 => '15 分鐘後';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound => '連接提示音與震動同行：VPN 開啟或關閉時會發出一聲短音（設定 → 一般）。';

  @override
  String get wn41RateUnit => '速度按你選擇的單位顯示：熟悉的 KB/s 或連接本身的 Mbps。';

  @override
  String get wn41BackgroundLock => '應用可在你離開後自行上鎖：密碼會在立即、5 分鐘或 15 分鐘後重新詢問。';

  @override
  String get wn41BiggerLimits => '會話的資料上限可升到 25、50 或 100 GB。';

  @override
  String get wn41Motion => '新的動效：連接後的圓球會呼吸、勾號自行繪出、狀態文字在取值間平滑滑動、密碼錯誤時輸入框會晃動。';

  @override
  String get wn41AboutFixed => '「關於」頁面變得整齊：兩個頁面並排、每條說明獨佔一行，毫無擠壓。';

  @override
  String get wn41HapticFixed => '震動設定重新生效：每次連接的開啟與關閉都會遵循它，而不只是滑塊。';

  @override
  String get copyIp => '複製 IP';

  @override
  String get wn42Fonts =>
      '每種語言都用應用自帶的字體閱讀：兩種中文與孟加拉文用 Noto Sans，拉丁與西里爾文用 Inter——不再依賴手機字體。';

  @override
  String get wn42Sounds =>
      '應用的音效現在是真的：每個分區都有輕柔的觸碰聲、開關的兩聲短音、連接建立與斷開時的升降音、鎖定時的一聲提示——音效開關統一控制。';

  @override
  String get wn42AboutFixed => '「關於」頁面的標誌、名稱與說明置中顯示，聯繫帳號無論螢幕多窄都完整保持在一行。';

  @override
  String get wn42Gaming => '遊戲模式現在是真的：伺服器頁面每半分鐘重新測量延遲，並用強調色突出實測最快的伺服器。';

  @override
  String get avatarPhoto => '自訂頭像';

  @override
  String get avatarPhotoFailed => '無法使用該圖片';

  @override
  String get designAether => '以太';

  @override
  String get designAetherDesc => 'iOS 狀態卡：狀態詞與工作階段時長在浮起卡片上，電源鍵自發光';

  @override
  String get designZed => 'Zed';

  @override
  String get designZedDesc => '漸層圓球：紫、粉與檸檬綠中呼吸的圓球，承載工作階段時長';

  @override
  String get tlsFragmentAuto => '自動';

  @override
  String get tlsFragmentAutoHint => '先送完整的 hello；若網路不斷切斷 TLS，會自動切分名稱半小時';

  @override
  String get accentDesign => '設計自帶的配色';

  @override
  String get wn45Designs => '四種全新的主頁外觀——極光、霓虹、暮色、鼠尾草——每一種都以自己的配色裝點所有頁面';

  @override
  String get wn45HelloAuto => 'TLS 切分學會了：若網路反覆扼殺交握，就自動切分名稱，讓隧道穿行過去';

  @override
  String get wn45RelayRace => '中繼恢復現在同時測試三個邊緣，被過濾的網路能更快找回通路';

  @override
  String get wn45AccentFixed => '顏色選擇器重新點亮整個應用——此前所選顏色無法作用到各頁面';

  @override
  String get wn45WhatsNewFixed => '「新變化」頁面重新顯示出文字——此前打開時是空白的';

  @override
  String get wn46Designs =>
      '兩個來自參考設計的新外觀：以太的 iOS 狀態卡與 Zed 的漸層圓球 — 各自妝點整個應用的每個頁面，此前的四個外觀已離場。';

  @override
  String get wn46Sounds =>
      '音效換上專業套組：連線開始時的湧動，接通時的和弦，斷線時的下行旋律，以及通路受阻時的一聲悶響 — 同一時刻只有一個聲音。';

  @override
  String get wn47Designs =>
      '兩套參考設計現在裝點整個應用——是每一頁，不只是主頁：aether 穿上第一款參考的 iOS 結構（弧形缺口欄、分組表格、彩色徽章、系統自帶的狀態色），zed 穿上第二款參考的靈動結構（浮動底欄、超圓卡片、可拖動的工具氣泡）。';

  @override
  String get wn47Fixes => '窄螢幕上曾溢出的設定列現在能讀到末尾。';

  @override
  String get wn48Bars =>
      '兩套設計的底部列各歸其位：aether 的藍色圓鈕落在自己分頁的凹槽裡，zed 的圓鈕不再蓋住下方的名稱。';

  @override
  String get wn48Fit =>
      '首頁重新裝得下螢幕：aether 的卡片把 Disconnected 讀完，頁面太擠時 zed 的光球會退一步，連接進行中軌道不再要你滑動連接、提示也不再同時說中斷。';

  @override
  String get wn48Wheel =>
      '旗幟轉輪會在螢幕邊緣切到卡片之前把它淡出，推薦地點以看得清的尺寸戴上 Mozilla 徽標，平面地圖的南緣融進頁面，不再以一條直線收尾。';

  @override
  String get wn49States =>
      '兩個參考設計穿上了它們被畫下的細節：aether 的卡片像 AetherST 一樣顯示本次工作階段的速率，電源鍵隨參考的光暈呼吸並在指尖下沉，zed 的氣泡在自身的形狀之間變形，中央的內容交叉淡入淡出地換場。';

  @override
  String get wn49Words =>
      '「正在連線」現在處處有詞：通道搭建期間，開關的滑軌帶著「正在連線…」字樣，旋鈕的圖示在各個形態間淡入淡出，滑軌隨連線自身的節奏呼吸——指尖之下再沒有什麼會突然消失。';

  @override
  String get wn49Sooner =>
      '連線的引擎重新回到原版：中繼池、備用路線和它們的記憶，以及重複請求的守衛扛著通道——起來得更早，也站得更穩。';

  @override
  String get wn49Mark => '建議位置換上了 Mozilla VPN 真正的標誌，更新按鈕也換上了更新自己的圖示。';

  @override
  String get wn50Notch =>
      '兩套設計的衣著告別了積存的凌亂：aether 的缺口欄讀到圓鈕自己的中心，被選中的分頁名在兩套外觀裡都穿上頁面自己的墨色，圓鈕的光暈守在圓鈕身上，不再把名字洗掉。';

  @override
  String get wn50Cards =>
      'zed 的首頁把速率摺進便當格：速率卡併入便當格的兩格與工作階段一行，頁面最後的卡片讓開底欄的座位，頁面滑到底時再沒有東西半截藏在底欄之下。';

  @override
  String get wn50Veil =>
      '狀態列戴上自己的薄紗：捲動的內容在時鐘下方淡出而不再與它相撞，zed 推開的頁面不再從時鐘下面開始，它的浮動工具也遠離底欄的座位。';

  @override
  String get wn50Ping => 'aether 的延遲膠囊再次一觸即測，就像參考裡它自己的膠囊那樣應答。';
}
