// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Проведите для подключения';

  @override
  String get slideToDisconnect => 'Проведите для отключения';

  @override
  String get navOverview => 'Обзор';

  @override
  String get navAccounts => 'Аккаунты';

  @override
  String get navSettings => 'Настройки';

  @override
  String get stateConnected => 'Подключено';

  @override
  String get stateConnecting => 'Подключение…';

  @override
  String get stateWaiting => 'Ожидание';

  @override
  String get waitingForAccount =>
      'Добавьте аккаунт Firefox на странице «Аккаунты», чтобы подключиться.';

  @override
  String get waitingForEnabledAccount =>
      'Все аккаунты выключены. Включите один на странице «Аккаунты».';

  @override
  String get stateError => 'Ошибка';

  @override
  String get stateUnknown => 'Неизвестно';

  @override
  String get restartProxy => 'Перезапустить прокси';

  @override
  String copied(String value) {
    return 'Скопировано: $value';
  }

  @override
  String get activeAccount => 'Активный аккаунт';

  @override
  String get noActiveAccount => 'Нет активного аккаунта';

  @override
  String get quotaNotRead => 'Остаток трафика ещё неизвестен';

  @override
  String get unlimited => 'Без ограничений';

  @override
  String usedOf(String used, String limit) {
    return 'использовано $used из $limit';
  }

  @override
  String resets(String date) {
    return 'обнулится $date';
  }

  @override
  String switchAt(int percent) {
    return 'Смена аккаунта при $percent%';
  }

  @override
  String get publicIp => 'Публичный IP';

  @override
  String get testConnection => 'Проверить';

  @override
  String get testing => 'Проверка…';

  @override
  String get testFailed => 'Ошибка';

  @override
  String milliseconds(int value) {
    return '$value мс';
  }

  @override
  String get justNow => 'только что';

  @override
  String minutesAgo(int n) {
    return '$n мин назад';
  }

  @override
  String hoursAgo(int n) {
    return '$n ч назад';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'в $time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d д $h ч';
  }

  @override
  String durationHours(int h, int m) {
    return '$h ч $m мин';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m мин $s с';
  }

  @override
  String durationSeconds(int s) {
    return '$s с';
  }

  @override
  String accountsGuide(String size) {
    return 'У каждого Firefox Account $size трафика в месяц. Можно добавить несколько: когда один закончится, приложение само перейдёт к следующему.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'В порядке этого списка: каждый до $percent%, последний — пока не кончится трафик.';
  }

  @override
  String get addAccount => 'Добавить аккаунт';

  @override
  String lowQuotaNotice(String size) {
    return 'Трафик этого аккаунта заканчивается. Добавьте ещё один аккаунт — это ещё $size.';
  }

  @override
  String get noAccounts => 'Аккаунтов пока нет';

  @override
  String get noAccountsHint => 'Добавьте аккаунт Firefox, чтобы подключиться.';

  @override
  String get delayTestFailed =>
      'Не удалось измерить задержку серверов. Проверьте интернет.';

  @override
  String get createAccountTitle => 'Нет Firefox Account?';

  @override
  String get createAccountHint =>
      'Создайте его бесплатно на accounts.firefox.com, затем вернитесь и нажмите «Добавить аккаунт».';

  @override
  String get moveUp => 'Вверх';

  @override
  String get moveDown => 'Вниз';

  @override
  String get statusActive => 'Активен';

  @override
  String get statusReady => 'Готов';

  @override
  String get statusNeedsSignIn => 'Нужен вход';

  @override
  String get statusReserved => 'В резерве';

  @override
  String get statusUnavailable => 'Недоступен';

  @override
  String statusUnavailableUntil(String date) {
    return 'Недоступен до $date';
  }

  @override
  String get statusDisabled => 'Отключён';

  @override
  String get statusEnabled => 'Включён';

  @override
  String get useNow => 'Использовать';

  @override
  String get signInAgain => 'Войти снова';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Аккаунт израсходовал $percent% трафика, поэтому подключился следующий.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Трафик на этот месяц закончился; аккаунт снова используется после обнуления.';

  @override
  String get reasonSignInRequired =>
      'Войдите снова, чтобы использовать этот аккаунт.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla просит подтвердить вход: нажмите «Войти снова» (нужен только код).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Автоматический вход не удался ($detail). Войдите снова.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'Последний автоматический вход вскоре перестал работать; следующая попытка в $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Автоматический вход не завершился ($detail); повтор в $time.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla отклонила этот аккаунт; повторим позже.';

  @override
  String get more => 'Ещё';

  @override
  String get refreshQuota => 'Проверить остаток трафика';

  @override
  String get remove => 'Удалить';

  @override
  String get removeTitle => 'Удалить аккаунт?';

  @override
  String removeBody(String name) {
    return '$name и сохранённые данные входа будут удалены с этого компьютера. Позже его можно добавить снова.';
  }

  @override
  String get unlimitedQuota => 'Безлимитный трафик';

  @override
  String get signInTitle => 'Вход';

  @override
  String get signInIntro => 'Войдите в аккаунт Firefox.';

  @override
  String get email => 'Эл. почта';

  @override
  String get emailInvalid => 'Введите почту аккаунта';

  @override
  String get password => 'Пароль';

  @override
  String get passwordEmpty => 'Введите пароль';

  @override
  String get show => 'Показать';

  @override
  String get hide => 'Скрыть';

  @override
  String get signIn => 'Войти';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get done => 'Готово';

  @override
  String get close => 'Закрыть';

  @override
  String get noBrowserTitle => 'На этом устройстве нет браузера';

  @override
  String get noBrowserText => 'Откройте этот адрес на телефоне или компьютере:';

  @override
  String get cancel => 'Отмена';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get signingIn => 'Вход…';

  @override
  String get accountReady => 'Аккаунт готов';

  @override
  String get accountReadyHint => 'Он добавлен в конец списка аккаунтов.';

  @override
  String get captchaLabel => 'Символы на картинке';

  @override
  String get codeLabel => 'Код';

  @override
  String get captchaBroken => 'Не удалось показать CAPTCHA.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla отправила код на $email. Введите его здесь.';
  }

  @override
  String get stepTotp => 'Введите код из приложения-аутентификатора.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla сочла этот вход подозрительным и отправила код разблокировки на $email. Введите его здесь.';
  }

  @override
  String get stepCaptcha => 'Введите символы с картинки.';

  @override
  String stepEmailLink(String email) {
    return 'Откройте ссылку подтверждения, которую Mozilla отправила на $email. Дальше вход продолжится автоматически.';
  }

  @override
  String get signInFailed => 'Аккаунт не добавлен.';

  @override
  String get signInCancelled => 'Вход отменён.';

  @override
  String get signInNoAccount => 'Firefox Account с этой почтой не существует.';

  @override
  String get signInNoAccountHint =>
      'Проверьте адрес или создайте с ним бесплатный Firefox Account на сайте Mozilla, подтвердите его из письма, а затем добавьте здесь.';

  @override
  String get createAccountButton => 'Создать Firefox Account';

  @override
  String get signInWrongPassword => 'Неверный пароль.';

  @override
  String get signInNoPassword =>
      'У этого аккаунта нет пароля: он создан через вход с Google или Apple. Задайте пароль, а затем войдите с ним здесь.';

  @override
  String get setPasswordButton => 'Задать пароль';

  @override
  String get signInTooManyAttempts =>
      'Слишком много попыток. Подождите немного и попробуйте снова.';

  @override
  String get signInUnblockRejected =>
      'Код разблокировки не принят. Используйте код из последнего письма Mozilla.';

  @override
  String get signInWrongCode =>
      'Неверный или просроченный код. Используйте код из последнего письма Mozilla; старый код перестаёт работать, когда приходит новый.';

  @override
  String get signInWrongTotp =>
      'Неверный код. Введите код, который сейчас показывает приложение-аутентификатор.';

  @override
  String get signInTooManyCodes =>
      'Слишком много неверных кодов. Начните вход заново.';

  @override
  String get signInTimedOut =>
      'Вход занял слишком много времени. Начните заново.';

  @override
  String get signInNetwork =>
      'Не удалось связаться с Mozilla. Проверьте интернет и попробуйте снова.';

  @override
  String get coreConnecting => 'Подключение к ядру…';

  @override
  String get coreLost => 'Связь с ядром потеряна. Повторная попытка…';

  @override
  String get cantReachCore => 'Нет связи с ядром';

  @override
  String get startingCore => 'Запуск ядра…';

  @override
  String get retry => 'Повторить';

  @override
  String errNoCore(String path) {
    return 'Файл ядра не найден рядом с приложением ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'Ядро остановилось: $detail';
  }

  @override
  String get errNotAnswering => 'Ядро не отвечает.';

  @override
  String get errRefused =>
      'Ядро отклонило подключение приложения: возможно, оно принадлежит другой копии.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionGeneral => 'Общие';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get closeBehavior => 'При закрытии окна';

  @override
  String get closeAsk => 'Спрашивать каждый раз';

  @override
  String get closeTray => 'Свернуть в трей';

  @override
  String get closeQuit => 'Выйти из приложения';

  @override
  String get sectionConnection => 'Подключение';

  @override
  String get localProxy => 'Локальный прокси';

  @override
  String get systemProxy => 'Системный прокси';

  @override
  String get sectionRouting => 'Маршрутизация';

  @override
  String get routingDirect => 'Прямое подключение к местным сайтам';

  @override
  String get routingDirectHint =>
      'Сайты и IP выбранной страны открываются напрямую, мимо VPN: быстрее и без расхода трафика.';

  @override
  String get region => 'Страна';

  @override
  String get regionIr => 'Иран';

  @override
  String get regionCn => 'Китай';

  @override
  String get regionRu => 'Россия';

  @override
  String get regionAf => 'Афганистан';

  @override
  String get regionTr => 'Турция';

  @override
  String get regionId => 'Индонезия';

  @override
  String get regionBr => 'Бразилия';

  @override
  String get regionNone => 'Нет';

  @override
  String get saved => 'Сохранено';

  @override
  String get dataFolder => 'Папка данных';

  @override
  String get openFolder => 'Открыть папку';

  @override
  String get unofficialNote => 'Неофициальный клиент. Не связан с Mozilla.';

  @override
  String get closeTitle => 'Закрыть окно?';

  @override
  String get closeBody =>
      'Если свернуть окно в трей, VPN останется включённым. При выходе он отключится.';

  @override
  String get rememberChoice => 'Запомнить выбор';

  @override
  String get minimizeToTray => 'Свернуть в трей';

  @override
  String get quit => 'Выйти';

  @override
  String get trayOpen => 'Открыть';

  @override
  String get trayQuit => 'Выйти';

  @override
  String get trayProxyOnly => 'Только прокси-сервис';

  @override
  String get traySetSystemProxy => 'Включить системный прокси';

  @override
  String errPortInUse(String port) {
    return 'Порт $port занят другой программой, и приложение не может связаться с ядром.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'Порт $port занят другой программой, и прокси не может запуститься.';
  }

  @override
  String get changePort => 'Сменить порт';

  @override
  String get portDialogTitle => 'Выбор порта';

  @override
  String portDialogBody(String port) {
    return 'Порт $port занят. Ниже предложен свободный порт; можно ввести другой.';
  }

  @override
  String get portChangeBody =>
      'Приложения подключаются к этому порту. Выберите порт от 1024 до 65535.';

  @override
  String get portLabel => 'Порт';

  @override
  String get portInvalid => 'Введите порт от 1024 до 65535';

  @override
  String get portBusy => 'Этот порт тоже занят';

  @override
  String get portInUse => 'Этот порт занят другой программой';

  @override
  String get save => 'Сохранить';

  @override
  String get proxyPort => 'Порт прокси';

  @override
  String get appPort => 'Порт приложения';

  @override
  String get welcomeTitle => 'Добро пожаловать';

  @override
  String get welcomeBody =>
      'Выберите язык и страну. Сайты вашей страны будут открываться напрямую, без VPN: так быстрее и не расходуется трафик.';

  @override
  String get start => 'Начать';

  @override
  String routingSuggestTitle(String country) {
    return 'Прямое подключение: $country?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Сайты и IP страны «$country» будут открываться напрямую, без VPN. Это можно изменить в разделе «Маршрутизация».';
  }

  @override
  String get yes => 'Да';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get navServers => 'Серверы';

  @override
  String get navLogs => 'Логи';

  @override
  String get realDelay => 'Реальная задержка';

  @override
  String get statElapsed => 'Время';

  @override
  String get statDown => 'Приём';

  @override
  String get statUp => 'Отдача';

  @override
  String noticePort(String port) {
    return 'Прокси Mozilla не подключается к порту $port. Через VPN идут только порты 80, 443, 8080 и 8443.';
  }

  @override
  String get noticeCommand => 'Этот тип подключения не поддерживается VPN.';

  @override
  String noticeTimes(int count, String time) {
    return 'Раз: $count, последний — $time';
  }

  @override
  String get dismiss => 'Скрыть';

  @override
  String get modeRecommended => 'Рекомендуемый';

  @override
  String get modeFastest => 'Самый быстрый';

  @override
  String get modeRecommendedHint => 'Mozilla выбирает локацию за вас.';

  @override
  String get modeFastestHint =>
      'При каждом подключении выбирается локация с наименьшей задержкой.';

  @override
  String get testDelay => 'Проверить задержку';

  @override
  String get testingDelay => 'Измерение…';

  @override
  String get search => 'Поиск';

  @override
  String get noAnswer => 'Нет ответа';

  @override
  String testedAgo(String ago) {
    return 'Проверено $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return 'Ответили $answered из $total';
  }

  @override
  String get noServers =>
      'Серверов пока нет. Они появятся, когда ядро свяжется с Mozilla.';

  @override
  String get levelAll => 'Все';

  @override
  String get filter => 'Фильтр';

  @override
  String get follow => 'Автопрокрутка';

  @override
  String get clear => 'Очистить';

  @override
  String get copyAll => 'Копировать всё';

  @override
  String get logsCopied => 'Логи скопированы';

  @override
  String get noLogs => 'Логов пока нет.';

  @override
  String get sectionAccounts => 'Автосмена аккаунтов';

  @override
  String get switchThreshold => 'Менять аккаунт при';

  @override
  String get switchThresholdHint =>
      'Когда израсходована эта доля трафика, включается следующий аккаунт.';

  @override
  String get signInMethod => 'Способ входа';

  @override
  String get signInMethodBrowser => 'Вход через браузер';

  @override
  String get signInMethodApi => 'Прямой вход';

  @override
  String get browserSignInBroken => 'Не удалось открыть страницу входа.';

  @override
  String get browserSignInBlocked =>
      'Mozilla не завершила последний шаг добавления аккаунта (HTTP 406).';

  @override
  String get browserSignInFallback => 'Вход с почтой и паролем';

  @override
  String get backupExport => 'Сохранить резервную копию';

  @override
  String get backupImport => 'Импортировать резервную копию';

  @override
  String backupSaved(String name) {
    return 'Сохранено: $name';
  }

  @override
  String get backupImportTitle => 'Добавить эти аккаунты?';

  @override
  String get backupAccountExists => 'Уже добавлен; вход будет взят из файла';

  @override
  String get backupImportAction => 'Добавить';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Добавлено $count аккаунта',
      many: 'Добавлено $count аккаунтов',
      few: 'Добавлено $count аккаунта',
      one: 'Добавлен $count аккаунт',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS-серверы';

  @override
  String get dnsSystem => 'Системные';

  @override
  String get dnsAuto => 'Авто (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Свои';

  @override
  String get dnsCustomHint =>
      'По одному на строку: https://…/dns-query, tls://… или IP-адрес.';

  @override
  String get dnsFallback => 'Системный DNS как запасной';

  @override
  String get testDns => 'Проверить DNS';

  @override
  String get transport => 'Протокол';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'Версия IP';

  @override
  String get ipVersionAuto => 'Авто (сначала IPv4, затем IPv6)';

  @override
  String get ipVersionDual => 'Оба сразу (dual-stack)';

  @override
  String get ipVersionV6First => 'Сначала IPv6, затем IPv4';

  @override
  String get ipVersionV4 => 'Только IPv4';

  @override
  String get ipVersionV6 => 'Только IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'Размер пакета интерфейса VPN, от 1280 до 9000. Пусто: автоматически.';

  @override
  String get tunMtuInvalid => 'Число от 1280 до 9000 или пусто';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Напрямую';

  @override
  String get directRulesHint =>
      'Сайты и адреса из этого списка открываются без VPN, напрямую через ваш интернет. Правила выбранной страны уже здесь: добавляйте, меняйте или удаляйте строки. Выбор другой страны заменит их её правилами.';

  @override
  String get restoreRegionRules => 'Вернуть правила страны';

  @override
  String get blockRules => 'Блокировать';

  @override
  String get blockRulesHint =>
      'Сайты и адреса из этого списка не открываются вообще — ни напрямую, ни через VPN: для рекламы или сайтов, которые не должны открываться никогда.';

  @override
  String get rulesTitle => 'Правила';

  @override
  String get ruleSyntaxTitle => 'Как написать правило';

  @override
  String get resolveDomains => 'Применять IP-правила к доменам';

  @override
  String get routingLists => 'Geo-файлы';

  @override
  String get listSource => 'Источник списков';

  @override
  String get listSourceCustom => 'Задано вручную';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Обновлено $ago';
  }

  @override
  String get updateLists => 'Обновить geo-файлы';

  @override
  String get listsUpdated => 'Geo-файлы обновлены.';

  @override
  String get testDestination => 'Проверить маршрут';

  @override
  String get destinationHint => 'Домен, IP-адрес или URL';

  @override
  String get check => 'Проверить';

  @override
  String get routeDirect => 'Напрямую';

  @override
  String get routeProxy => 'Через VPN';

  @override
  String get routeBlock => 'Заблокировано';

  @override
  String ruleMatched(String rule) {
    return 'Правило: $rule';
  }

  @override
  String get portRefusedNote => 'Прокси Mozilla не подключается к этому порту.';

  @override
  String get sectionAdvanced => 'Дополнительно';

  @override
  String get tlsFragment => 'Фрагментация TLS';

  @override
  String get tlsFragmentOff => 'Выключено';

  @override
  String get tlsFragmentFirstByte => 'Первый байт';

  @override
  String get tlsFragmentSni => 'Имя сервера (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Разделяет заголовок TLS на первом байте (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Разбивает имя сервера (SNI) на несколько TCP-пакетов';

  @override
  String get tlsFragmentRecord => 'Запись TLS';

  @override
  String get tlsFragmentRecordHint =>
      'Разбивает имя сервера (SNI) на две записи TLS';

  @override
  String get tlsFragmentOffHint => 'Обычное подключение TLS';

  @override
  String get sectionBypass => 'Если Mozilla заблокирована';

  @override
  String get sharedRelay => 'Общий ретранслятор';

  @override
  String get sharedRelayHint =>
      'Использовать общие ретрансляторы приложения, если Mozilla блокирует ваш регион. Включённый личный ретранслятор имеет приоритет.';

  @override
  String get personalRelay => 'Личный ретранслятор';

  @override
  String get apiRelay => 'Сервер-ретранслятор';

  @override
  String get apiRelayUse => 'Использовать сервер-ретранслятор';

  @override
  String get apiRelayHint =>
      'Ваш собственный Cloudflare Worker или relay.php на вашем хостинге.\nИспользуется, только когда Mozilla не отвечает напрямую: через него идут вход, аккаунты и список серверов, а не трафик VPN.';

  @override
  String get upstreamProxy => 'Вышестоящий прокси';

  @override
  String get upstreamProxyOn => 'Вышестоящий прокси включён';

  @override
  String get upstreamProxyAddress => 'Адрес прокси SOCKS5';

  @override
  String get upstreamProxyPort => 'Порт';

  @override
  String get upstreamProxyHint =>
      'Подключение к Mozilla идёт через этот прокси: для сетей, которые блокируют или замедляют Mozilla.\nЕсли прокси работает на этом устройстве, исключите его из VPN.';

  @override
  String get upstreamProxyInvalid =>
      'Введите адрес прокси, например 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Введите порт от 1 до 65535.';

  @override
  String get upstreamProxyOwn =>
      'Это прокси самого приложения. Введите другой.';

  @override
  String get apiRelayInvalid => 'Должен быть адрес https://.';

  @override
  String get listenAddress => 'Доступ к прокси';

  @override
  String get listenLocal => '127.0.0.1 · только это устройство';

  @override
  String get listenAll => '0.0.0.0 · все сети (LAN)';

  @override
  String get proxyUsername => 'Имя пользователя прокси';

  @override
  String get proxyPassword => 'Пароль прокси';

  @override
  String get proxyLoginHint =>
      'Приложениям нужно будет указать эти данные. Оставьте оба поля пустыми, чтобы прокси работал без пароля.';

  @override
  String get loginBothOrNone => 'Заполните оба поля или оставьте оба пустыми.';

  @override
  String get proxyLogin => 'Логин и пароль прокси';

  @override
  String get idleSleep => 'Спящий режим после простоя';

  @override
  String get sleepNever => 'Никогда';

  @override
  String sleepMinutes(int count) {
    return '$count мин';
  }

  @override
  String get sleepHour => '1 час';

  @override
  String get showPublicIp => 'Показывать публичный IP';

  @override
  String get hapticFeedback => 'Вибрация при изменении соединения';

  @override
  String get keepScreenOn => 'Не гасить экран, пока включено подключение';

  @override
  String get showTraffic =>
      'Показывать трафик в реальном времени на главном экране';

  @override
  String get speedInNotification => 'Показывать скорость в уведомлении';

  @override
  String get liveTraffic => 'Текущий трафик';

  @override
  String get totalTraffic => 'Всего трафика';

  @override
  String get verboseLogs => 'Подробные логи';

  @override
  String get webDashboard => 'Веб-панель';

  @override
  String get webDashboardOpen => 'Открыть';

  @override
  String get webDashboardHint => 'Расширенные настройки и другие инструменты';

  @override
  String numberInvalid(int min, int max) {
    return 'Введите число от $min до $max';
  }

  @override
  String get notifySwitchedTitle => 'Аккаунт сменён';

  @override
  String notifySwitchedBody(String name) {
    return 'Теперь используется $name.';
  }

  @override
  String get notifySignInTitle => 'Нужен вход';

  @override
  String get notifySignInBody =>
      'Войдите снова в один из аккаунтов на странице «Аккаунты».';

  @override
  String get navAbout => 'О программе';

  @override
  String get appVersionLabel => 'Версия приложения';

  @override
  String get coreVersionLabel => 'Версия ядра';

  @override
  String get checkUpdates => 'Проверить обновления';

  @override
  String get checkingUpdates => 'Проверка…';

  @override
  String get upToDate => 'У вас последняя версия.';

  @override
  String updateAvailable(String version) {
    return 'Доступна версия $version.';
  }

  @override
  String updateRequired(String version) {
    return 'Обновите приложение до версии $version. Это обновление необходимо.';
  }

  @override
  String get download => 'Скачать';

  @override
  String updateCheckFailed(String error) {
    return 'Не удалось проверить обновления: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'Не удалось связаться с GitHub. Проверьте подключение к интернету и попробуйте ещё раз.';

  @override
  String get updateNow => 'Обновить';

  @override
  String updateDownloading(String version) {
    return 'Загрузка версии $version…';
  }

  @override
  String updateReady(String version) {
    return 'Версия $version готова к установке.';
  }

  @override
  String updateInstalling(String version) {
    return 'Установка версии $version. Приложение закроется и откроется снова.';
  }

  @override
  String updateFailed(String version) {
    return 'Не удалось обновиться до версии $version.';
  }

  @override
  String updateDone(String version) {
    return 'Обновлено до версии $version.';
  }

  @override
  String updateRolledBack(String version) {
    return 'Обновление до версии $version не завершилось, поэтому приложение вернулось к предыдущей версии.';
  }

  @override
  String get repoNotSet => 'Репозиторий GitHub ещё не указан.';

  @override
  String get sourceCode => 'Исходный код';

  @override
  String get tapToConnect => 'Нажмите, чтобы подключиться';

  @override
  String get tapToDisconnect => 'Нажмите, чтобы отключиться';

  @override
  String get startOnBoot => 'Запускать при включении';

  @override
  String get connectOnStartup => 'Подключаться при включении';

  @override
  String get proxyServiceActive => 'Прокси-служба работает';

  @override
  String get navHome => 'Главная';

  @override
  String get groupApp => 'Приложение';

  @override
  String get groupNetwork => 'Сеть';

  @override
  String get stateOff => 'Отключено';

  @override
  String get tapToConnectPhone => 'Нажмите, чтобы подключиться';

  @override
  String get tapToDisconnectPhone => 'Нажмите, чтобы отключиться';

  @override
  String get tapToConnectTv => 'Нажмите OK, чтобы подключиться';

  @override
  String get tapToDisconnectTv => 'Нажмите OK, чтобы отключиться';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Рекомендуемая локация';

  @override
  String dataLeftOf(String limit) {
    return 'из $limit';
  }

  @override
  String get homeLocation => 'Локация';

  @override
  String get connectedTo => 'Подключено к';

  @override
  String get vpnNotAllowed =>
      'Для VPN нужно ваше разрешение. Нажмите кнопку ещё раз и разрешите подключение.';

  @override
  String get dataUsedTitle => 'Использовано';

  @override
  String get bypassApps => 'Раздельное туннелирование';

  @override
  String get connectRetrying => 'Не удалось подключиться. Проверьте интернет.';

  @override
  String get failUnreachable =>
      'Не удалось связаться с серверами Mozilla. Попробуйте другое подключение к интернету.';

  @override
  String get failUpstreamProxy =>
      'Не удалось связаться с Mozilla через вышестоящий прокси. Проверьте, что он работает.';

  @override
  String get failInsideVpn =>
      'Этот интернет уже идёт через VPN. Отключите его.';

  @override
  String get failRefused =>
      'Сервер Mozilla отклонил подключение. Попробуйте снова через несколько минут.';

  @override
  String get failLocationRefused =>
      'Эта страна недоступна для вашего аккаунта. Выберите другую страну.';

  @override
  String get useRecommendedLocation => 'Использовать рекомендуемую локацию';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Выбрано: $chosen, но ваш IP определяется как $exit.';
  }

  @override
  String get failSignIn =>
      'Сеанс этого аккаунта истёк. Войдите снова на странице «Аккаунты».';

  @override
  String get failQuota =>
      'Трафик этого месяца исчерпан. Добавьте другой аккаунт.';

  @override
  String get failNotEntitled =>
      'Mozilla не разрешает этому аккаунту пользоваться VPN. Добавьте другой аккаунт.';

  @override
  String get failRegion => 'Mozilla не предоставляет сервис в вашей стране.';

  @override
  String get failServer =>
      'Временная проблема в сервисе Mozilla. Приложение само попробует снова.';

  @override
  String get failNoAccount =>
      'Нет готового аккаунта. Откройте страницу «Аккаунты».';

  @override
  String get failTestSite =>
      'Подключено к серверу, но сайты не открываются. Попробуйте другую страну.';

  @override
  String get failOther => 'Не удалось подключиться. Попробуйте снова.';

  @override
  String get failNoInternet =>
      'Нет интернета. Проверьте Wi-Fi или мобильный интернет.';

  @override
  String get waitingForNetwork => 'Ожидание подключения к интернету…';

  @override
  String proxyStartFailed(String port) {
    return 'Прокси не удалось запустить на порту $port. Выберите другой порт.';
  }

  @override
  String get connectionSettings => 'Настройки подключения';

  @override
  String get appModeExclude => 'Выбранные приложения — напрямую';

  @override
  String get appModeInclude => 'Только выбранные — через VPN';

  @override
  String get appModeExcludeHint =>
      'Выбранные приложения подключаются напрямую, не через VPN: например, банковские, которые не пускают с зарубежных IP.';

  @override
  String get appModeIncludeHint =>
      'Через VPN идут только выбранные приложения; остальные подключаются напрямую.';

  @override
  String fromRegionList(String region) {
    return 'Рекомендуется: есть в списке «$region»';
  }

  @override
  String get modeProxy => 'Прокси';

  @override
  String get connectionMode => 'Режим подключения';

  @override
  String get modeProxyHint =>
      'Через прокси идут только приложения, в которых он настроен.';

  @override
  String get modeSystemProxyHint =>
      'Через прокси идут Windows и большинство приложений.';

  @override
  String get modeSystemProxyHintOther =>
      'Через прокси идут браузеры и большинство приложений.';

  @override
  String get suggestedApps => 'Рекомендуемые приложения';

  @override
  String get showSystemApps => 'Показывать системные приложения';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count рекомендуемых приложений',
      few: 'Выбрано $count рекомендуемых приложения',
      one: 'Выбрано $count рекомендуемое приложение',
      zero: 'Рекомендуемые приложения уже выбраны',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Автоматически';

  @override
  String get locationsSection => 'Локации';

  @override
  String get dnsSummaryOk => 'Шифрованный DNS работает';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось разрешить $count имён',
      few: 'Не удалось разрешить $count имени',
      one: 'Не удалось разрешить $count имя',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'через $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'DNS вашей сети вернул адрес фильтра для $count имён. Приложение такие ответы не использует.',
      one:
          'DNS вашей сети вернул адрес фильтра для $count имени. Приложение такие ответы не использует.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Ответ:';

  @override
  String get dnsNetworkAnswer => 'DNS сети:';

  @override
  String get dnsFiltered => 'фильтруется';

  @override
  String get rulesSyntaxTitle => 'По одному правилу в строке';

  @override
  String get ruleDomain => 'Сайт и его поддомены';

  @override
  String get ruleFull => 'Только этот домен';

  @override
  String get ruleKeyword => 'Домены, содержащие слово';

  @override
  String get ruleGeosite => 'Сайты с тегом из geo-файлов';

  @override
  String get ruleGeoip => 'IP-адреса страны из geo-файлов';

  @override
  String get ruleIp => 'IP-адрес или подсеть';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Только прокси';

  @override
  String get noNetwork =>
      'Нет подключения к интернету. Включите Wi-Fi или мобильные данные.';

  @override
  String get blockAds => 'Блокировать рекламу';

  @override
  String systemProxyTakenBy(String address) {
    return 'Другая программа переключила системный прокси на $address, поэтому трафик идёт не через VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Другая программа выключила системный прокси, поэтому трафик идёт не через VPN.';

  @override
  String get setSystemProxyAgain => 'Настроить снова';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Весь трафик $os идёт через VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'Ожидание разрешения на установку службы TUN…';

  @override
  String get tunInstallCancelled =>
      'Режиму TUN один раз нужно разрешение администратора. Оно не было дано, поэтому режим не изменился.';

  @override
  String tunInstallFailed(String error) {
    return 'Не удалось установить службу TUN: $error';
  }

  @override
  String get tunStarting => 'Включение режима TUN…';

  @override
  String get tunFailed => 'Режим TUN не включился. Повторная попытка…';

  @override
  String get tunLost => 'Режим TUN неожиданно выключился. Повторная попытка…';

  @override
  String get tunNotRunning => 'Служба TUN не запущена. Повторная попытка…';

  @override
  String get tunMissing => 'Служба TUN не установлена.';

  @override
  String get tunOutdated =>
      'Служба TUN старше этого приложения. Установите её снова, чтобы пользоваться режимом TUN.';

  @override
  String get tunAppOutdated =>
      'Служба TUN новее этого приложения. Обновите приложение, чтобы пользоваться режимом TUN.';

  @override
  String get tunBusy => 'Режимом TUN пользуется другая копия Homa VPN.';

  @override
  String get tunNoDriver =>
      'Драйвер TUN в системе недоступен. Перезагрузите компьютер и повторите попытку.';

  @override
  String get tunInstall => 'Установить';

  @override
  String get tunInstallAgain => 'Установить снова';

  @override
  String get trayTunMode => 'Режим TUN (все приложения)';

  @override
  String get removeTunService => 'Удалить службу TUN';

  @override
  String get removeTunServiceHint =>
      'Удаляет системную службу, которую использует режим TUN. Если снова выбрать TUN, она установится заново.';

  @override
  String get tunServiceRemoved => 'Служба TUN удалена.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN хочет установить службу для режима TUN.';

  @override
  String get tunRemovePrompt => 'Homa VPN хочет удалить службу режима TUN.';

  @override
  String tunRemoveFailed(String error) {
    return 'Не удалось удалить службу TUN: $error';
  }

  @override
  String get sectionTun => 'Настройки TUN';

  @override
  String get tunPrograms => 'Программы в обход VPN';

  @override
  String get tunProgramsHint =>
      'Подключаются напрямую, не через Mozilla. Только для программ, которые работают без VPN.';

  @override
  String get tunProgramsEmpty => 'Программ пока нет.';

  @override
  String get addProgram => 'Добавить программу';

  @override
  String get programFiles => 'Программы';

  @override
  String get tunProgramAll => 'Весь трафик';

  @override
  String get tunProgramAllHint => 'Вся программа подключается напрямую.';

  @override
  String get tunProgramUdp => 'Только UDP';

  @override
  String get tunProgramUdpHint =>
      'Напрямую идёт только её UDP; остальное — через VPN.';

  @override
  String get udpNoticeSetting => 'Уведомление о заблокированном UDP';

  @override
  String udpNoticeBody(String program) {
    return 'UDP-трафик программы $program не идёт через VPN.';
  }

  @override
  String get dontShowAgain => 'Больше не показывать';

  @override
  String get addRunningProgram => 'Из запущенных программ';

  @override
  String get addProgramFile => 'Выбрать файл…';

  @override
  String get addProgramName => 'Ввести имя…';

  @override
  String get programNameHint =>
      'Имя файла программы, например steam.exe; * означает любой текст (steam* — все программы Steam).';

  @override
  String get runningProgramsEmpty => 'Других запущенных программ нет.';

  @override
  String get tabLog => 'Лог';

  @override
  String get tabConnections => 'Подключения';

  @override
  String get connectionsEmpty => 'Подключений пока нет.';

  @override
  String connectionsOpen(int count) {
    return 'Открыто: $count';
  }

  @override
  String get connTime => 'Время';

  @override
  String get connRoute => 'Правило';

  @override
  String get connDestination => 'Назначение';

  @override
  String get connInbound => 'Вход';

  @override
  String get connProtocol => 'Протокол';

  @override
  String get connColumns => 'Столбцы';

  @override
  String get connTraffic => 'Трафик';

  @override
  String get connDuration => 'Длительность';

  @override
  String get connRouteVpn => 'Прокси';

  @override
  String get connRouteDirect => 'Напрямую';

  @override
  String get connRouteBlocked => 'Заблокировано';

  @override
  String get connRoutePort => 'Порт отклонён';

  @override
  String get connRouteFailed => 'Ошибка';

  @override
  String get testRelay => 'Проверить реле';

  @override
  String get relayTestTitle => 'Проверка реле';

  @override
  String get relayTestHint =>
      'Проверяется только реле. Запросы к Mozilla и данные аккаунта не отправляются.';

  @override
  String get relayTestPassed => 'Реле готово';

  @override
  String get relayTestFailed => 'Не удалось подтвердить исправность реле';

  @override
  String get relayTestCopy => 'Копировать отчёт';

  @override
  String get relayTestInterrupted =>
      'Проверка завершилась до получения полного результата.';

  @override
  String get searchLocations => 'Поиск локаций';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count локации',
      many: '$count локаций',
      few: '$count локации',
      one: '1 локация',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Автообновление';

  @override
  String get autoInstallApkHint =>
      'Новые версии скачиваются сами; перед установкой установщик спросит.';

  @override
  String get installNow => 'Установить';

  @override
  String get updateAllowInstall =>
      'Чтобы установить обновление, разрешите приложению установку приложений.';

  @override
  String get allowInstall => 'Разрешить';

  @override
  String get noResults => 'Нет локаций по этому запросу.';

  @override
  String get accentColor => 'Акцентный цвет';

  @override
  String get accentMono => 'Монохром (по умолчанию)';

  @override
  String get accentCustom => 'Свой цвет';

  @override
  String get accentEmber => 'Пламя';

  @override
  String get accentGold => 'Золото';

  @override
  String get accentEmerald => 'Изумруд';

  @override
  String get accentSapphire => 'Сапфир';

  @override
  String get accentAmethyst => 'Аметист';

  @override
  String get accentRose => 'Роза';

  @override
  String get autoReconnect => 'Автопереподключение';

  @override
  String get autoReconnectHint =>
      'Сам возвращает соединение, если оно оборвалось без вашего участия.';

  @override
  String get androidOnlyHint => 'Только на телефоне.';

  @override
  String get idleDisconnect => 'Отключать при простое';

  @override
  String get idleDisconnectHint => 'Завершает сеанс, если трафика долго нет.';

  @override
  String get idleTimeout => 'Порог простоя';

  @override
  String get minutes5 => '5 минут';

  @override
  String get minutes10 => '10 минут';

  @override
  String get minutes15 => '15 минут';

  @override
  String get minutes30 => '30 минут';

  @override
  String get minutes60 => '1 час';

  @override
  String get dataLimit => 'Лимит данных сеанса';

  @override
  String get dataLimitHint =>
      'Завершает сеанс, когда его трафик доходит до лимита.';

  @override
  String get dataLimitAmount => 'Лимит';

  @override
  String get mb256 => '256 МБ';

  @override
  String get mb512 => '512 МБ';

  @override
  String get mb1024 => '1 ГБ';

  @override
  String get mb2048 => '2 ГБ';

  @override
  String get mb5120 => '5 ГБ';

  @override
  String get mb10240 => '10 ГБ';

  @override
  String autoStoppedIdle(int minutes) {
    return 'Трафика не было $minutes минут, поэтому соединение отключено.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'Сеанс достиг лимита $mb МБ, поэтому соединение отключено.';
  }

  @override
  String get protection => 'Защита';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Если VPN оборвался, трафик удерживается — без утечек — пока связь не восстановится.';

  @override
  String get alwaysOnVpn => 'Постоянный VPN';

  @override
  String get alwaysOnVpnHint =>
      'Собственная защита Android: без VPN не проходит ни одно соединение.';

  @override
  String get floatingIsland => 'Плавающий остров';

  @override
  String get floatingIslandHint =>
      'Показывает состояние соединения поверх других приложений, пока приложение закрыто.';

  @override
  String whatsNewTitle(String version) {
    return 'Новое в версии $version';
  }

  @override
  String get whatsNewContinue => 'Понятно';

  @override
  String get whatsNewMenu => 'Что нового';

  @override
  String get whatsNewView => 'Показать снова';

  @override
  String get updateServers => 'Обновить серверы';

  @override
  String get updatingServers => 'Обновление…';

  @override
  String serversUpdated(int count) {
    return '$count локаций из официального списка Mozilla';
  }

  @override
  String get serversUpdateFailed =>
      'Не удалось обновить список серверов; прежний список сохранён.';

  @override
  String get smartPickTitle => 'Быстрейший сейчас';

  @override
  String get smartPickUse => 'Выбрать';

  @override
  String get connectAtBoot => 'Подключаться при включении телефона';

  @override
  String get connectAtBootHint =>
      'Сам подключается при загрузке, если разрешение VPN уже выдано.';

  @override
  String get gamingProfile => 'Игровой профиль';

  @override
  String get gamingProfileHint =>
      'Показывает живой пинг и качество связи; вместе с самым быстрым измеренным сервером.';

  @override
  String get diagnosticsRun => 'Запустить диагностику';

  @override
  String get diagnosticsHint => 'Соединение, DNS и туннель одним касанием';

  @override
  String get diagnosticsTunnel => 'Туннель';

  @override
  String get diagnosticsTunnelUp => 'Поднят и передаёт трафик';

  @override
  String get diagnosticsTunnelDown => 'Не работает';

  @override
  String get diagnosticsExit => 'Страна выхода';

  @override
  String get diagnosticsMismatch => 'Страна выхода отличается от выбора';

  @override
  String get diagnosticsConnection => 'Тест соединения';

  @override
  String get diagnosticsPassed => 'Пройден';

  @override
  String get diagnosticsFailed => 'Не пройден';

  @override
  String get diagnosticsDnsFiltered => 'Ответ заблокирован или отфильтрован';

  @override
  String get diagnosticsDnsOk => 'Отвечает';

  @override
  String get diagnosticsPrivacy =>
      'Ничего из этого не сохраняется; результаты остаются в этом окне и в журнале ядра.';

  @override
  String get diagnosticsAgain => 'Запустить снова';

  @override
  String get whatsNewAdded => 'Новое';

  @override
  String get whatsNewImproved => 'Улучшено';

  @override
  String get whatsNewFixed => 'Исправлено';

  @override
  String get wnWheelImproved =>
      'Колесо стран перерисовано: выбранный флаг крупнее, в стеклянной рамке с тонким свечением и мягким ореолом света позади, остальные флаги мельче и глубже, а название под ними выезжает плавно.';

  @override
  String get wnLiveImproved =>
      'Во время подключения уведомление просит Android 16 продвинуть его как Live Update, как это делает эталонная реализация; время продолжает идти, скорости живут.';

  @override
  String get wnL10nFixed =>
      'Эта страница теперь говорит на языке приложения — на всех его пятнадцати языках, а не только на английском.';

  @override
  String get wnMarkFixed =>
      'Знак Mozilla аккуратно расположен на своей плитке, со скруглением, как у флагов.';

  @override
  String get designTitle => 'Оформление главной';

  @override
  String get designHint => 'Как устроена главная страница';

  @override
  String get designWheel => 'Колесо';

  @override
  String get designWheelDesc => 'Флаги в стеклянном колесе, кнопка под ним';

  @override
  String get designBento => 'Плитки';

  @override
  String get designBentoDesc =>
      'Доска скруглённых плиток: соединение, числа, место';

  @override
  String get designPixel => 'Компакт';

  @override
  String get designPixelDesc => 'Одна спокойная карточка: место, кнопка, числа';

  @override
  String get notifFlag => 'Флаг страны в уведомлении';

  @override
  String get notifFlagHint => 'Флаг самой страны рядом с её названием';

  @override
  String get wnDesignAdded =>
      'Настройка оформления главной: колесо, плитки или компактная карточка';

  @override
  String get wnMapAdded =>
      'Настоящая векторная карта мира за главной страницей, выбранная страна подсвечена';

  @override
  String get wnWheelAdded =>
      'Колесо флагов перерисовано: глубже стекло, плавнее движение';

  @override
  String get wnFlagNotifAdded =>
      'Уведомление может показывать SVG-флаг страны, и его можно выключить';

  @override
  String get wnColorRemoved =>
      'Страница своего цвета удалена; список акцентов сохраняет код HEX';

  @override
  String get whatsNewRemoved => 'Удалено';

  @override
  String get wnCrashFixed =>
      'Приложение больше не останавливается само на телефонах с Android 16: уведомление просило у системы то, чего в телефоне ещё не было.';

  @override
  String get wnFlagArtFixed =>
      'Приложение больше не выкидывает само себя при открытии: картинка флага в уведомлении возвращала значение, которое отказывается принимать системный канал сообщений.';

  @override
  String get statSession => 'Сессия';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get wnTotalsAdded =>
      'Главная показывает суммарный объём данных за сессию, а касание копирует публичный IP.';

  @override
  String get wnPolishImproved =>
      'Колесо флагов и страница серверов стали аккуратнее; тексты компактнее, а туннель Android несёт трафик быстрее.';

  @override
  String get smartNetwork => 'Умное подключение';

  @override
  String get smartNetworkHint =>
      'MTU, протокол и версия IP подстраиваются под эту сеть — ради скорости.';

  @override
  String get valueSmart => 'Умный';

  @override
  String get mtuAutoValue => 'Авто — по сети';

  @override
  String get wnSmartAdded =>
      'Умное подключение: MTU, протокол и версия IP следуют за сетью — по реальным ответам и ради скорости.';

  @override
  String get wnToastAdded =>
      'Подтверждения приходят мягкой заметкой в стиле iOS, с значком, который рисует себя сам.';

  @override
  String get wnFlagsImproved =>
      'Колесо флагов смотрится чисто: ни один флаг не обрезается краем экрана, флаги видны целиком, а выбор приземляется мягко.';

  @override
  String get wnMapImproved =>
      'Карта мира рисуется крупнее и чётче: без сжатых континентов, с гладкими берегами и светящимся ореолом у точки.';

  @override
  String get smartWaiting => 'Измеряется…';

  @override
  String get smartFamilyRace => 'При первом соединении стартуют оба';

  @override
  String get dnsManual => 'DNS вручную';

  @override
  String get dnsManualHint =>
      'Один адрес на строку: обычный IP, https:// (DNS over HTTPS) или tls://host (DNS over TLS). Побеждает первый ответ.';

  @override
  String get dnsManualInvalid =>
      'Одна из строк — не адрес, который ядро сможет использовать: обычный IP, https://… или tls://host.';

  @override
  String get killSwitchGuarded =>
      'Под стражей: пока туннель лежит, из телефона не уходит ничего.';

  @override
  String get accountsUsageTitle => 'В этом месяце';

  @override
  String get accountsCountLabel => 'аккаунтов';

  @override
  String get accountsUsageAverage => 'средняя израсходованная доля аккаунтов';

  @override
  String get wnDesignsAdded =>
      'Дизайны приложения: всё приложение может носить Мягкий неоморфизм или Стекло северного сияния — каждая страница, каждая карточка — в Настройках → Общие.';

  @override
  String get wnWheelFixed =>
      'Половина флага у колеса исчезла: полка под выбранным флагом — лужица света, а не второй флаг, и у края экрана ничего не обрезается.';

  @override
  String get wnMapReal =>
      'Карта мира перерисована по официальным границам стран — каждый берег, остров и анклав, точно и в настоящих пропорциях.';

  @override
  String get wnGlobeAdded =>
      'Мир стал глобусом: серебряный шар поворачивается к выбранной стране, светящийся пин и плавающая карточка отмечают её, а дороги соединения тянутся к хабам.';

  @override
  String get wnWheelGlowImproved =>
      'Выбранный флаг стоит крупнее — в стеклянной раме со своим синим ореолом, соседи заметно меньше, а метки под колесом показывают, где вы.';

  @override
  String get wnDesignsRemoved =>
      'Выбор дизайна приложения ушёл: приложение снова носит собственный монохромный облик — ваш акцент и тема остались прежними.';

  @override
  String get wnDnsAdded =>
      'DNS вручную: обычные IP, DNS over HTTPS и DNS over TLS — тип каждой строки виден и проверяется по мере ввода.';

  @override
  String get wnSmartImproved =>
      'Умное подключение теперь показывает ответ сети: выбранный транспорт и удержанную версию IP — вживую.';

  @override
  String get wnProtectionImproved =>
      'Аварийный выключатель говорит, когда стража на посту, а страница приложений — сколько приложений выбрано.';

  @override
  String get wnWelcomeImproved =>
      'Приветствие открывается щитом, что дышит над плывущим сиянием, а страница аккаунтов сводит месяц в один взгляд.';

  @override
  String bypassAppsCount(String n) {
    return 'Выбрано: $n';
  }

  @override
  String mtuAutoMeasured(int mtu) {
    return 'Авто — сеть несёт $mtu';
  }

  @override
  String get sectionAppearance => 'Внешний вид';

  @override
  String get mapStyle => 'Стиль карты';

  @override
  String get mapStyleHint =>
      'Глобус домашней страницы красится, как вы выберете. Свет подключения остаётся тем же.';

  @override
  String get mapSilver => 'Серебро';

  @override
  String get mapMidnight => 'Полночь';

  @override
  String get mapOcean => 'Океан';

  @override
  String get mapMono => 'Моно';

  @override
  String get mapAurora => 'Аврора';

  @override
  String get batterySaver => 'Экономия батареи';

  @override
  String get batterySaverHint =>
      'Оставляет движение карты в покое, пока идёт подключение — дыхание глобуса, свечение колеса. Само подключение остаётся ровно тем же.';

  @override
  String get connectOnOpen => 'Подключать при открытии приложения';

  @override
  String get connectOnOpenHint =>
      'Поднимает VPN, как только приложение открылось, с последним выбранным местом.';

  @override
  String get speedTitle => 'Скорость';

  @override
  String get parallelTunnels => 'Параллельные туннели';

  @override
  String get parallelTunnelsHint =>
      'Открывает сразу несколько туннелей к Mozilla и делит трафик между ними, чтобы один медленный туннель больше не ставил потолок скорости. Восемь — самый тяжёлый для батареи.';

  @override
  String get tunnels1 => 'Один — самый стабильный';

  @override
  String get tunnels2 => 'Два';

  @override
  String get tunnels4 => 'Четыре — быстрее на медленных сетях';

  @override
  String get tunnels8 => 'Восемь — самый быстрый';

  @override
  String get connectionCap => 'Лимит подключений';

  @override
  String get connectionCapHint =>
      'Сколько приложений могут говорить через VPN одновременно; меньший предел экономит батарею и трафик на занятом телефоне. По умолчанию — без лимита.';

  @override
  String get capNone => 'Без лимита';

  @override
  String get verboseLogging => 'Подробная диагностика';

  @override
  String get verboseLoggingHint =>
      'Записывает каждый шаг в журнал — помогает при сообщении о проблеме, чуть тяжелее для батареи.';

  @override
  String get wn38MapStylesAdded =>
      'Пять образов карты: серебро, полночь, океан, моно и аврора — выбирает новая страница «Внешний вид» в настройках, с превью каждого.';

  @override
  String get wn38ZoomAdded =>
      'Карту можно приблизить: сведите пальцы или коснитесь дважды, чтобы подойти ближе и вернуться.';

  @override
  String get wn38OptionsAdded =>
      'Практичные опции: параллельные туннели для большей скорости, лимит подключений, экономия батареи, подключение при открытии приложения и подробная диагностика.';

  @override
  String get wn38SocialAdded =>
      'Instagram и Telegram теперь живут и внизу этой страницы.';

  @override
  String get wn38FlightImproved =>
      'Выбор страны — это маленький полёт: камера отъезжает, шар поворачивается, булавка падает с отскоком, а дороги сами прочерчиваются к узлам.';

  @override
  String get wn38EffectsImproved =>
      'Карта читается богаче: звёзды за шаром, координатная сетка, собственные огни узлов, ореол по краю и тень суши.';

  @override
  String get wn38SpeedImproved =>
      'Опция скорости настоящая: параллельные туннели открывают сразу несколько соединений, и ядро делит трафик между ними.';

  @override
  String get wn38NameFixed =>
      'Имя выбранной страны показывается один раз — на парящей карточке карты; копия под флагами ушла.';

  @override
  String get mapKind => 'Тип карты';

  @override
  String get mapKindHint =>
      'Как показывается мир главной страницы: плоская карта, как всегда (по умолчанию), её современный вид, ночная Земля, Земля рельефа, металлический шар или спутниковая Земля. Границы в каждом виде — настоящие, официальные.';

  @override
  String get mapKindClassic => 'Классическая';

  @override
  String get mapKindGlobe => '3D-шар';

  @override
  String get mapKindSatellite => 'Спутник';

  @override
  String get mapKindFlat => 'Плоская 2D';

  @override
  String get mapStyleGlobeHint =>
      'Цвета, в которые одет 3D-шар. Спутник несёт свою Землю, а плоские карты — свой цвет.';

  @override
  String get aboutVersions => 'Версия';

  @override
  String get aboutChannels => 'Страницы связи';

  @override
  String get checkUpdatesHint =>
      'Искать версию новее; найденная скачается, и установщик спросит.';

  @override
  String get speedTestTitle => 'Тест скорости';

  @override
  String get speedTestRun => 'Измерить';

  @override
  String get speedTestFailed => 'Измерение не завершилось.';

  @override
  String get speedTestThrough => 'Измерено через туннель.';

  @override
  String get speedTestDirect => 'Измерено напрямую (прокси выключен).';

  @override
  String get speedTestHint =>
      'Одна загрузка и одна выгрузка через туннель говорят, что он на самом деле несёт. График на главном экране тоже открывает это.';

  @override
  String get speedGraphHint =>
      'Последняя минута туннеля · коснитесь для замера';

  @override
  String get favoritePinned => 'Закреплено. Долгое нажатие снова — убрать.';

  @override
  String get favoriteUnpinned => 'Убрано.';

  @override
  String get shareReport => 'Поделиться отчётом';

  @override
  String get shareReportCopied => 'Отчёт в буфере обмена.';

  @override
  String get batteryWizardTitle => 'Остаться живым на батарее';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei и подобные убивают VPN-приложения после блокировки экрана. Выведите приложение из оптимизации батареи, чтобы туннель горел.';

  @override
  String get batteryWizardSteps =>
      'В собственных настройках производителя разрешите автозапуск и поставьте приложение в «Без ограничений» (Xiaomi), «Удалить из спящих» (Samsung) или «Запуск — вручную» (Huawei).';

  @override
  String get batteryWizardState =>
      'Оптимизация батареи может остановить туннель.';

  @override
  String get batteryWizardPermit => 'Разрешить';

  @override
  String get batteryWizardOk => 'Туннель защищён от батареи.';

  @override
  String get batteryWizardOpen => 'Настройки батареи';

  @override
  String get usageTitle => 'Использование по приложениям';

  @override
  String get usageRowHint => 'Сколько потратило каждое приложение';

  @override
  String get usageGrant => 'Открыть доступ к использованию';

  @override
  String get usageGrantHint =>
      'Android держит расход данных каждого приложения за разрешением «Доступ к данным об использовании». Страница, которую открывает кнопка, принадлежит системе; приложение читает только числа.';

  @override
  String get usageEmpty => 'За этот период использование не записано.';

  @override
  String get usageToday => 'Сегодня';

  @override
  String get usageWeek => 'Последние 7 дней';

  @override
  String get usageMonth => 'Последние 30 дней';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'Приложение устанавливается не из Google Play, поэтому Play Protect может предложить проверку при первой установке. Нажмите «Проверить приложение» один раз — проверка запомнится, и обновления после неё устанавливаются без этого запроса.';

  @override
  String get smartLocation => 'Быстрейшая локация';

  @override
  String get smartLocationHint =>
      'Каждый запуск садится на сервер, который собственный тест задержки ядра зовёт быстрым.';

  @override
  String get quicPass => 'Пропуск QUIC';

  @override
  String get quicPassHint =>
      'QUIC приложений (UDP 443) идёт через туннель: звонки и игры сохраняют скорость вместо отката к TCP.';

  @override
  String get accountRename => 'Переименовать аккаунт';

  @override
  String get accountRenameLabel => 'Имя аккаунта';

  @override
  String get accountProfile => 'Аватар профиля';

  @override
  String get avatarReset => 'Вернуть простую метку';

  @override
  String get accountSecurity => 'Пароль приложения';

  @override
  String get appPasswordOn => 'Приложение открывается за паролем.';

  @override
  String get appPasswordOff =>
      'Без пароля: кто откроет приложение, тот войдёт.';

  @override
  String get appPasswordSet => 'Задать пароль';

  @override
  String get appPasswordChange => 'Сменить пароль';

  @override
  String get appPasswordRemove => 'Убрать пароль';

  @override
  String get appPasswordCurrent => 'Текущий пароль';

  @override
  String get appPasswordNew => 'Новый пароль (4+ символов)';

  @override
  String get appPasswordConfirm => 'Повторите новый пароль';

  @override
  String get appPasswordShort => 'Не меньше 4 символов.';

  @override
  String get appPasswordMismatch => 'Пароли не совпадают.';

  @override
  String get appPasswordWrong => 'Неверный пароль';

  @override
  String get appPasswordSetDone =>
      'Пароль стоит — приложение спросит его со следующего запуска.';

  @override
  String get appPasswordRemoved =>
      'Пароля больше нет; приложение открывается свободно.';

  @override
  String get appPasswordUnlock => 'Приложение заперто';

  @override
  String get appPasswordUnlockHint =>
      'Введите пароль приложения, чтобы продолжить.';

  @override
  String get wn39MapKinds =>
      'У карты снова есть типы: плоская, как всегда (по умолчанию), 3D-шар, спутниковая Земля и современная плоская 2D.';

  @override
  String get wn39EyeIp =>
      'У карточки локации есть глаз: коснитесь, увидите адрес выхода трафика и скопируете его.';

  @override
  String get wn39Profile =>
      'У аккаунтов свои имя и аватар, а приложение может открываться за паролем.';

  @override
  String get wn39Smart =>
      'Умное подключение выросло: быстрейшая локация по реальной задержке и пропуск QUIC для звонков и игр.';

  @override
  String get wn39Flight =>
      'Смена страны летит плавнее — камера идёт по большой окружности — и метки колеса флагов ближе к флагам.';

  @override
  String get wn39ToastEverywhere =>
      'Динамическая заметка теперь везде: каждое сохранение, копия и ошибка носят ту же анимированную стеклянную капсулу.';

  @override
  String get wn39Updates =>
      'Обновления держат хранилище чистым: установщик заменяет старую версию, и пакетов не остаётся.';

  @override
  String get mapKindNight => 'Ночь';

  @override
  String get mapKindTerrain => 'Рельеф';

  @override
  String get wn40MapKindsNew =>
      'Два новых вида карты: ночная Земля и Земля рельефа.';

  @override
  String get wn40Flight =>
      '3D-шар плавно поворачивается к новой стране — никаких резких скачков.';

  @override
  String get wn40Mercator =>
      'Плоские карты рисуются в стандартной проекции Меркатора: настоящие пропорции, стандартные границы, без искажений.';

  @override
  String get wn40NameBack =>
      'Имя выбранной страны вернулось под флагами на плоских картах.';

  @override
  String get wn40Speed =>
      'Туннель теперь по умолчанию открывает две параллельные сессии — линия сильнее и стабильнее.';

  @override
  String get wn40LockFixed =>
      'Замок кнопки подключения больше не мигает между состояниями.';

  @override
  String get wn40IpRemoved => 'Окно IP на карточке места убрано.';

  @override
  String get soundFeedback => 'Звуковые эффекты';

  @override
  String get soundFeedbackHint =>
      'Мягкие звуки касаний, переключателей, включения и выключения подключения';

  @override
  String get rateUnit => 'Единица скорости';

  @override
  String get lockInBackground => 'Блокировка после ухода';

  @override
  String get lockBgNever => 'Никогда';

  @override
  String get lockBgNow => 'Сразу же';

  @override
  String get lockBgMin5 => 'Через 5 минут';

  @override
  String get lockBgMin15 => 'Через 15 минут';

  @override
  String get mb25600 => '25 ГБ';

  @override
  String get mb51200 => '50 ГБ';

  @override
  String get mb102400 => '100 ГБ';

  @override
  String get wn41Sound =>
      'К вибрации добавился звук подключения: VPN коротко звучит при включении и выключении (Настройки → Общие).';

  @override
  String get wn41RateUnit =>
      'Скорость читается в выбранной единице: привычные КБ/с или родные Мбит/с.';

  @override
  String get wn41BackgroundLock =>
      'Приложение может запереть себя в ваше отсутствие: пароль спрашивают снова сразу, через 5 или через 15 минут.';

  @override
  String get wn41BiggerLimits =>
      'Лимит данных сессии поднимается до 25, 50 или 100 ГБ.';

  @override
  String get wn41Motion =>
      'Новые движения: подключённый шар дышит, галочка рисует себя сама, слово состояния скользит между своими значениями, а неверный пароль встряхивает поле.';

  @override
  String get wn41AboutFixed =>
      'Страница «О приложении» выровнялась: две страницы рядом, каждая подсказка на своей строке, без сжатия.';

  @override
  String get wn41HapticFixed =>
      'Настройка вибрации снова слушается: включение и выключение каждого подключения следует ей, а не только ползунку.';

  @override
  String get copyIp => 'Копировать IP';

  @override
  String get wn42Fonts =>
      'Каждый язык читается шрифтами самого приложения: Noto Sans для двух китайских и бенгальского, Inter для латиницы и кириллицы — ни один язык больше не зависит от шрифтов телефона.';

  @override
  String get wn42Sounds =>
      'Звуки приложения теперь настоящие: мягкое касание в каждом разделе, две ноты для переключателей, восходящая и нисходящая нота при включении и выключении подключения, звонок для блокировки — звуковой переключатель управляет всеми.';

  @override
  String get wn42AboutFixed =>
      'Страница «О приложении» центрирует логотип, имя и примечание, а контактные адреса остаются целыми на одной строке при любой ширине телефона.';

  @override
  String get wn42Gaming =>
      'Игровой профиль теперь настоящий: страница серверов заново измеряет задержки каждые полминуты и выделяет самый быстрый акцентом.';

  @override
  String get avatarPhoto => 'Своя фотография';

  @override
  String get avatarPhotoFailed => 'Это изображение не удалось использовать';

  @override
  String get designAether => 'Эфир';

  @override
  String get designAetherDesc =>
      'Карточка статуса в стиле iOS: слово состояния и время сессии на приподнятой карточке, со светящейся кнопкой питания';

  @override
  String get designZed => 'Зед';

  @override
  String get designZedDesc =>
      'Градиентная сфера: дышащий шар в фиолетовом, розовом и лаймовом, несёт время сессии';

  @override
  String get tlsFragmentAuto => 'Авто';

  @override
  String get tlsFragmentAutoHint =>
      'Сначала целое hello; сеть, что режет TLS без конца, сама режет имя на полчаса';

  @override
  String get accentDesign => 'Собственный свет оформления';

  @override
  String get wn45Designs =>
      'Четыре новых облика главной — Огни, Неон, Закат и Шалфей — каждый одевает все страницы в свою палитру';

  @override
  String get wn45HelloAuto =>
      'Разделитель TLS научился: сеть, что убивает рукопожатие без конца, сама режет имя — и туннель проходит';

  @override
  String get wn45RelayRace =>
      'Восстановление реле теперь проверяет три края разом, и фильтрованная сеть быстрее находит дорогу';

  @override
  String get wn45AccentFixed =>
      'Выбор цвета снова освещает приложение — его цвет переставал доходить до страниц';

  @override
  String get wn45WhatsNewFixed =>
      'Страница «Что нового» вновь показывает свои слова — она открывалась пустой';

  @override
  String get wn46Designs =>
      'Два новых облика из эталонных дизайнов: карточка статуса iOS у эфира и градиентная сфера у зеда — каждый одевает всё приложение целиком, а четыре прежних облика ушли.';

  @override
  String get wn46Sounds =>
      'У звуков появился профессиональный набор: волна для начинающегося подключения, аккорд когда туннель встал, нисходящая мелодия когда он лёг и глухая нота для закрытого пути — один голос за раз.';

  @override
  String get wn47Designs =>
      'Два образа-эталона теперь одевают всё приложение — каждую страницу, а не только главную: эфир носит iOS-структуру первого эталона (изогнутая планка с выемкой, сгруппированные таблицы, цветные значки, собственные цвета состояния системы), а зед — выразительную структуру второго (плавучий док, очень круглые карточки, перетаскиваемые пузыри инструментов).';

  @override
  String get wn47Fixes =>
      'Строка настроек, которая выходила за края на узких экранах, теперь читается до конца.';

  @override
  String get wn48Bars =>
      'Нижние панели обоих дизайнов встали на свои места: синий круг эфира отдыхает в вырезе своей вкладки, а круг зеда больше не накрывает имя под ним.';

  @override
  String get wn48Fit =>
      'Домашние страницы снова умещаются на своих экранах: карточка эфира дочитывает Disconnected до конца, сфера зеда делает шаг вниз, когда страница тесна, и пока подключение идёт, ни дорожка не просит сдвинуть для подключения, ни подсказка не говорит об отключении разом.';

  @override
  String get wn48Wheel =>
      'Колесо флагов растворяет карточку прежде, чем край экрана разрежет её, рекомендуемое место носит знак Mozilla в читаемом размере, а южный край плоской карты тает в страницу, не обрываясь линией.';

  @override
  String get wn49States =>
      'Оба эталонных оформления носят детали, с которыми были нарисованы: карточка aether показывает скорости сессии, как у AetherST, её кнопка питания дышит свечением эталона и проседает под пальцем, а капля zed перетекает между своими формами, пока её центр сменяется крест-растворением.';

  @override
  String get wn49Words =>
      'У «Подключения» теперь есть слово везде: пока туннель строится, дорожка переключателя несёт «Подключение…», знак ручки тает между своими состояниями, и дорожка дышит ритмом самого соединения — ничего не исчезает из-под пальца.';

  @override
  String get wn49Sooner =>
      '«Подключено» приходит раньше: вердикт самого туннеля записывается в миг прохождения, а место выхода — страна и адрес — едет следом.';

  @override
  String get wn49Mark =>
      'Рекомендуемое место носит настоящую метку Mozilla VPN, а кнопки обновления — собственный глиф обновления.';
}
