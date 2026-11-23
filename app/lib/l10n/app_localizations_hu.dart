// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Csúsztass a csatlakozáshoz';

  @override
  String get slideToDisconnect => 'Csúsztass a leválasztáshoz';

  @override
  String get navOverview => 'Áttekintés';

  @override
  String get navAccounts => 'Fiókok';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get stateConnected => 'Csatlakozva';

  @override
  String get stateConnecting => 'Csatlakozás…';

  @override
  String get stateWaiting => 'Várakozás';

  @override
  String get waitingForAccount =>
      'A csatlakozáshoz adjon hozzá egy Firefox Accountot a Fiókok oldalon.';

  @override
  String get waitingForEnabledAccount =>
      'Minden fiók ki van kapcsolva. Kapcsoljon be egyet a Fiókok oldalon.';

  @override
  String get stateError => 'Hiba';

  @override
  String get stateUnknown => 'Ismeretlen';

  @override
  String get restartProxy => 'Proxy újraindítása';

  @override
  String copied(String value) {
    return 'Másolva: $value';
  }

  @override
  String get activeAccount => 'Aktív fiók';

  @override
  String get noActiveAccount => 'Nincs aktív fiók';

  @override
  String get quotaNotRead => 'Az adatkeret még nincs lekérdezve';

  @override
  String get unlimited => 'Korlátlan';

  @override
  String usedOf(String used, String limit) {
    return '$used / $limit felhasználva';
  }

  @override
  String resets(String date) {
    return 'nullázódik: $date';
  }

  @override
  String switchAt(int percent) {
    return 'Fiókváltás $percent%-nál';
  }

  @override
  String get publicIp => 'Nyilvános IP';

  @override
  String get testConnection => 'Kapcsolat tesztelése';

  @override
  String get testing => 'Tesztelés…';

  @override
  String get testFailed => 'Sikertelen';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'épp most';

  @override
  String minutesAgo(int n) {
    return '$n perce';
  }

  @override
  String hoursAgo(int n) {
    return '$n órája';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count napja',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return '$time-kor';
  }

  @override
  String durationDays(int d, int h) {
    return '$d nap $h ó';
  }

  @override
  String durationHours(int h, int m) {
    return '$h ó $m p';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m p $s mp';
  }

  @override
  String durationSeconds(int s) {
    return '$s mp';
  }

  @override
  String accountsGuide(String size) {
    return 'Minden Firefox Account havi $size adatkerettel rendelkezik. Több fiókot is hozzáadhat: ha az egyik elfogy, az alkalmazás magától a következőre vált.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'A lista sorrendjében: mindegyik $percent%-ig, az utolsó az adatkerete elfogyásáig.';
  }

  @override
  String get addAccount => 'Fiók hozzáadása';

  @override
  String lowQuotaNotice(String size) {
    return 'Ennek a fióknak az adatkerete hamarosan elfogy. Adjon hozzá egy másik fiókot, és $size adatkerettel több lesz.';
  }

  @override
  String get noAccounts => 'Még nincs fiók';

  @override
  String get noAccountsHint =>
      'A csatlakozáshoz adjon hozzá egy Firefox Accountot.';

  @override
  String get delayTestFailed =>
      'Nem sikerült megmérni a szerverek késleltetését. Ellenőrizze az internetet.';

  @override
  String get createAccountTitle => 'Nincs Firefox Accountja?';

  @override
  String get createAccountHint =>
      'Hozzon létre egyet ingyen az accounts.firefox.com oldalon, majd térjen vissza, és nyomja meg a Fiók hozzáadása gombot.';

  @override
  String get moveUp => 'Feljebb';

  @override
  String get moveDown => 'Lejjebb';

  @override
  String get statusActive => 'Aktív';

  @override
  String get statusReady => 'Használható';

  @override
  String get statusNeedsSignIn => 'Bejelentkezés szükséges';

  @override
  String get statusReserved => 'Tartalék';

  @override
  String get statusUnavailable => 'Nem elérhető';

  @override
  String statusUnavailableUntil(String date) {
    return 'Nem elérhető eddig: $date';
  }

  @override
  String get statusDisabled => 'Letiltva';

  @override
  String get statusEnabled => 'Engedélyezve';

  @override
  String get useNow => 'Váltás erre';

  @override
  String get signInAgain => 'Újbóli bejelentkezés';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Ez a fiók elérte adatkerete $percent%-át, ezért a következő fiók vette át.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Elfogyott a havi adatkeret; a havi nullázás után újra használatba kerül.';

  @override
  String get reasonSignInRequired =>
      'Jelentkezzen be újra a fiók használatához.';

  @override
  String get reasonSignInConfirm =>
      'A Mozilla a bejelentkezés megerősítését kéri: nyomja meg az „Újbóli bejelentkezés” gombot (csak a kód kell).';

  @override
  String reasonSignInFailed(String detail) {
    return 'Az automatikus bejelentkezés nem sikerült ($detail). Jelentkezzen be újra.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'A legutóbbi automatikus bejelentkezés hamar leállt; a következő próbálkozás $time-kor.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'Az automatikus bejelentkezés nem fejeződött be ($detail); újrapróbálkozás $time-kor.';
  }

  @override
  String get reasonNotEntitled =>
      'A Mozilla elutasította ezt a fiókot; később újrapróbálkozunk.';

  @override
  String get more => 'Továbbiak';

  @override
  String get refreshQuota => 'Adatkeret frissítése';

  @override
  String get remove => 'Eltávolítás';

  @override
  String get removeTitle => 'Eltávolítja a fiókot?';

  @override
  String removeBody(String name) {
    return '$name és a mentett bejelentkezési adatai törlődnek erről a számítógépről. Később újra hozzáadhatja.';
  }

  @override
  String get unlimitedQuota => 'Korlátlan adatkeret';

  @override
  String get signInTitle => 'Bejelentkezés';

  @override
  String get signInIntro => 'Jelentkezzen be egy Firefox Accounttal.';

  @override
  String get email => 'E-mail';

  @override
  String get emailInvalid => 'Adja meg a fiók e-mail-címét';

  @override
  String get password => 'Jelszó';

  @override
  String get passwordEmpty => 'Adja meg a jelszót';

  @override
  String get show => 'Megjelenítés';

  @override
  String get hide => 'Elrejtés';

  @override
  String get signIn => 'Bejelentkezés';

  @override
  String get continueLabel => 'Tovább';

  @override
  String get done => 'Kész';

  @override
  String get close => 'Bezárás';

  @override
  String get noBrowserTitle => 'Ezen az eszközön nincs böngésző';

  @override
  String get noBrowserText =>
      'Nyissa meg ezt a címet a telefonján vagy a számítógépén:';

  @override
  String get cancel => 'Mégse';

  @override
  String get tryAgain => 'Újra';

  @override
  String get signingIn => 'Bejelentkezés…';

  @override
  String get accountReady => 'A fiók használatra kész';

  @override
  String get accountReadyHint => 'A fióklista végére került.';

  @override
  String get captchaLabel => 'A képen látható karakterek';

  @override
  String get codeLabel => 'Kód';

  @override
  String get captchaBroken => 'A CAPTCHA-kép nem jeleníthető meg.';

  @override
  String stepEmailCode(String email) {
    return 'A Mozilla kódot küldött a(z) $email címre. Írja be ide.';
  }

  @override
  String get stepTotp => 'Írja be a hitelesítő alkalmazásban látható kódot.';

  @override
  String stepUnblockCode(String email) {
    return 'A Mozilla szokatlannak találta ezt a bejelentkezést, és feloldókódot küldött a(z) $email címre. Írja be ide.';
  }

  @override
  String get stepCaptcha => 'Írja be a képen látható karaktereket.';

  @override
  String stepEmailLink(String email) {
    return 'Nyissa meg a megerősítő linket, amelyet a Mozilla a(z) $email címre küldött. Utána minden magától folytatódik.';
  }

  @override
  String get signInFailed => 'A fiók nem lett hozzáadva.';

  @override
  String get signInCancelled => 'A bejelentkezés megszakítva.';

  @override
  String get signInNoAccount =>
      'Ehhez az e-mail-címhez nem tartozik Firefox Account.';

  @override
  String get signInNoAccountHint =>
      'Ellenőrizze a címet, vagy hozzon létre vele ingyenes Firefox Accountot a Mozilla oldalán, erősítse meg a postafiókjából, majd adja hozzá itt.';

  @override
  String get createAccountButton => 'Firefox Account létrehozása';

  @override
  String get signInWrongPassword => 'Hibás jelszó.';

  @override
  String get signInNoPassword =>
      'Ennek a fióknak nincs jelszava: Google- vagy Apple-bejelentkezéssel jött létre. Állítson be jelszót, majd jelentkezzen be vele itt.';

  @override
  String get setPasswordButton => 'Jelszó beállítása';

  @override
  String get signInTooManyAttempts =>
      'Túl sok próbálkozás. Várjon egy kicsit, majd próbálja újra.';

  @override
  String get signInUnblockRejected =>
      'A feloldókódot nem fogadta el. Használja a Mozilla legutóbbi e-mailjében lévő kódot.';

  @override
  String get signInWrongCode =>
      'Hibás vagy lejárt kód. Használja a Mozilla legutóbbi e-mailjében lévő kódot; egy új kód küldésekor a régi már nem működik.';

  @override
  String get signInWrongTotp =>
      'Hibás kód. Írja be a hitelesítő alkalmazásban most látható kódot.';

  @override
  String get signInTooManyCodes =>
      'Túl sok hibás kód. Kezdje elölről a bejelentkezést.';

  @override
  String get signInTimedOut =>
      'A bejelentkezés túl sokáig tartott. Kezdje újra.';

  @override
  String get signInNetwork =>
      'A Mozilla nem érhető el. Ellenőrizze az internetet, és próbálja újra.';

  @override
  String get coreConnecting => 'Csatlakozás a magprogramhoz…';

  @override
  String get coreLost =>
      'Megszakadt a kapcsolat a magprogrammal. Újrapróbálás…';

  @override
  String get cantReachCore => 'A magprogram nem érhető el';

  @override
  String get startingCore => 'A magprogram indítása…';

  @override
  String get retry => 'Újra';

  @override
  String errNoCore(String path) {
    return 'A magprogram nem található az alkalmazás mellett ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'A magprogram leállt: $detail';
  }

  @override
  String get errNotAnswering => 'A magprogram nem válaszol.';

  @override
  String get errRefused =>
      'A magprogram elutasította az alkalmazást; lehet, hogy egy másik példányhoz tartozik.';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get sectionGeneral => 'Általános';

  @override
  String get language => 'Nyelv';

  @override
  String get languageSystem => 'Rendszer nyelve';

  @override
  String get theme => 'Téma';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeDark => 'Sötét';

  @override
  String get closeBehavior => 'Az ablak bezárásakor';

  @override
  String get closeAsk => 'Mindig kérdezzen rá';

  @override
  String get closeTray => 'Elrejtés a rendszertálcára';

  @override
  String get closeQuit => 'Kilépés az alkalmazásból';

  @override
  String get sectionConnection => 'Kapcsolat';

  @override
  String get localProxy => 'Helyi proxy';

  @override
  String get systemProxy => 'Rendszerproxy';

  @override
  String get sectionRouting => 'Útválasztás';

  @override
  String get routingDirect => 'Közvetlen kapcsolat a helyi oldalakhoz';

  @override
  String get routingDirectHint =>
      'A kiválasztott ország oldalai és IP-címei a VPN-t megkerülve, közvetlenül nyílnak meg: így gyorsabbak, és nem fogyasztják az adatkeretet.';

  @override
  String get region => 'Ország';

  @override
  String get regionIr => 'Irán';

  @override
  String get regionCn => 'Kína';

  @override
  String get regionRu => 'Oroszország';

  @override
  String get regionAf => 'Afganisztán';

  @override
  String get regionTr => 'Törökország';

  @override
  String get regionId => 'Indonézia';

  @override
  String get regionBr => 'Brazília';

  @override
  String get regionNone => 'Nincs';

  @override
  String get saved => 'Mentve';

  @override
  String get dataFolder => 'Adatmappa';

  @override
  String get openFolder => 'Mappa megnyitása';

  @override
  String get unofficialNote =>
      'Nem hivatalos kliens. Nem áll kapcsolatban a Mozillával.';

  @override
  String get closeTitle => 'Bezárja az ablakot?';

  @override
  String get closeBody =>
      'A rendszertálcára rejtve a VPN csatlakozva marad. Kilépéskor a kapcsolat megszakad.';

  @override
  String get rememberChoice => 'Választás megjegyzése';

  @override
  String get minimizeToTray => 'Rendszertálcára';

  @override
  String get quit => 'Kilépés';

  @override
  String get trayOpen => 'Megnyitás';

  @override
  String get trayQuit => 'Kilépés';

  @override
  String get trayProxyOnly => 'Csak proxyszolgáltatás';

  @override
  String get traySetSystemProxy => 'Rendszerproxy beállítása';

  @override
  String errPortInUse(String port) {
    return 'A(z) $port portot egy másik program használja, ezért az alkalmazás nem éri el a magprogramot.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'A(z) $port portot egy másik program használja, ezért a proxy nem tud elindulni.';
  }

  @override
  String get changePort => 'Port módosítása';

  @override
  String get portDialogTitle => 'Port kiválasztása';

  @override
  String portDialogBody(String port) {
    return 'A(z) $port port foglalt. Alább egy szabad portot javaslunk; megadhat másikat is.';
  }

  @override
  String get portChangeBody =>
      'Az alkalmazások ehhez a porthoz csatlakoznak. Válasszon egyet 1024 és 65535 között.';

  @override
  String get portLabel => 'Port';

  @override
  String get portInvalid => 'Adjon meg egy portot 1024 és 65535 között';

  @override
  String get portBusy => 'Ez a port is foglalt';

  @override
  String get portInUse => 'Ezt a portot egy másik program használja';

  @override
  String get save => 'Mentés';

  @override
  String get proxyPort => 'Proxyport';

  @override
  String get appPort => 'Alkalmazásport';

  @override
  String get welcomeTitle => 'Üdvözöljük';

  @override
  String get welcomeBody =>
      'Válassza ki a nyelvet és az országát. Az országa oldalai közvetlenül, VPN nélkül nyílnak meg: így gyorsabbak, és nem fogyasztják az adatkeretet.';

  @override
  String get start => 'Kezdés';

  @override
  String routingSuggestTitle(String country) {
    return 'Közvetlen kapcsolat: $country?';
  }

  @override
  String routingSuggestBody(String country) {
    return '$country oldalai és IP-címei közvetlenül, VPN nélkül nyílnának meg. Ezt az Útválasztás részben módosíthatja.';
  }

  @override
  String get yes => 'Igen';

  @override
  String get notNow => 'Most nem';

  @override
  String get navServers => 'Szerverek';

  @override
  String get navLogs => 'Naplók';

  @override
  String get realDelay => 'Valós késleltetés';

  @override
  String get statElapsed => 'Eltelt idő';

  @override
  String get statDown => 'Letöltés';

  @override
  String get statUp => 'Feltöltés';

  @override
  String noticePort(String port) {
    return 'A Mozilla proxyja nem csatlakozik a(z) $port porthoz. Csak a 80-as, 443-as, 8080-as és 8443-as port megy át a VPN-en.';
  }

  @override
  String get noticeCommand => 'Ezt a kapcsolattípust a VPN nem támogatja.';

  @override
  String noticeTimes(int count, String time) {
    return '$count alkalommal, utoljára $time';
  }

  @override
  String get dismiss => 'Elvetés';

  @override
  String get modeRecommended => 'Ajánlott';

  @override
  String get modeFastest => 'Leggyorsabb';

  @override
  String get modeRecommendedHint => 'A Mozilla választja ki a helyszínt.';

  @override
  String get modeFastestHint =>
      'A legkisebb késleltetésű helyszín minden csatlakozáskor.';

  @override
  String get testDelay => 'Valós késleltetés mérése';

  @override
  String get testingDelay => 'Mérés…';

  @override
  String get search => 'Keresés';

  @override
  String get noAnswer => 'Nincs válasz';

  @override
  String testedAgo(String ago) {
    return 'Tesztelve: $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered / $total válaszolt';
  }

  @override
  String get noServers =>
      'Még nincsenek szerverek. Akkor jelennek meg, amikor a magprogram eléri a Mozillát.';

  @override
  String get levelAll => 'Összes';

  @override
  String get filter => 'Szűrő';

  @override
  String get follow => 'Automatikus görgetés';

  @override
  String get clear => 'Törlés';

  @override
  String get copyAll => 'Másolás';

  @override
  String get logsCopied => 'Naplók másolva';

  @override
  String get noLogs => 'Még nincsenek naplósorok.';

  @override
  String get sectionAccounts => 'Automatikus fiókváltás';

  @override
  String get switchThreshold => 'Váltási küszöb';

  @override
  String get switchThresholdHint =>
      'A következő fiók akkor veszi át, amikor az adatkeret ekkora része elfogyott.';

  @override
  String get signInMethod => 'Bejelentkezési mód';

  @override
  String get signInMethodBrowser => 'Bejelentkezés böngészővel';

  @override
  String get signInMethodApi => 'Közvetlen bejelentkezés';

  @override
  String get browserSignInBroken => 'A bejelentkezési oldal nem nyitható meg.';

  @override
  String get browserSignInBlocked =>
      'A Mozilla nem fejezte be a fiók hozzáadásának utolsó lépését (HTTP 406).';

  @override
  String get browserSignInFallback => 'Bejelentkezés e-maillel és jelszóval';

  @override
  String get backupExport => 'Biztonsági mentés készítése';

  @override
  String get backupImport => 'Biztonsági mentés importálása';

  @override
  String backupSaved(String name) {
    return 'Mentve: $name';
  }

  @override
  String get backupImportTitle => 'Hozzáadja ezeket a fiókokat?';

  @override
  String get backupAccountExists =>
      'Már hozzá van adva; a bejelentkezést a fájlból kapja';

  @override
  String get backupImportAction => 'Hozzáadás';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fiók hozzáadva',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'DNS-szerverek';

  @override
  String get dnsSystem => 'Rendszer';

  @override
  String get dnsAuto => 'Automatikus (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Egyéni';

  @override
  String get dnsCustomHint =>
      'Soronként egy: https://…/dns-query, tls://… vagy egy IP-cím.';

  @override
  String get dnsFallback => 'Rendszer-DNS használata tartalékként';

  @override
  String get testDns => 'DNS tesztelése';

  @override
  String get transport => 'Protokoll';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'IP-verzió';

  @override
  String get ipVersionAuto => 'Automatikus (előbb IPv4, aztán IPv6)';

  @override
  String get ipVersionDual => 'Mindkettő egyszerre (dual-stack)';

  @override
  String get ipVersionV6First => 'Előbb IPv6, aztán IPv4';

  @override
  String get ipVersionV4 => 'Csak IPv4';

  @override
  String get ipVersionV6 => 'Csak IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'A VPN-interfész csomagmérete, 1280 és 9000 között. Üres: automatikus.';

  @override
  String get tunMtuInvalid => 'Egy szám 1280 és 9000 között, vagy üres';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Közvetlen';

  @override
  String get directRulesHint =>
      'A lista webhelyei és címei VPN nélkül, közvetlenül a saját internetkapcsolatán nyílnak meg. A választott ország szabályai már itt vannak: sorokat adhat hozzá, módosíthat vagy törölhet. Másik ország választása lecseréli őket annak szabályaira.';

  @override
  String get restoreRegionRules => 'Az ország szabályainak visszaállítása';

  @override
  String get blockRules => 'Tiltás';

  @override
  String get blockRulesHint =>
      'A lista webhelyei és címei egyáltalán nem nyílnak meg, sem közvetlenül, sem VPN-en keresztül: hirdetésekhez vagy olyan oldalakhoz, amelyeket soha nem akar elérni.';

  @override
  String get rulesTitle => 'Szabályok';

  @override
  String get ruleSyntaxTitle => 'Hogyan írjunk szabályt';

  @override
  String get resolveDomains => 'IP-szabályok alkalmazása domainekre';

  @override
  String get routingLists => 'Geo-fájlok';

  @override
  String get listSource => 'Listák forrása';

  @override
  String get listSourceCustom => 'Kézzel megadva';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Frissítve: $ago';
  }

  @override
  String get updateLists => 'Geo-fájlok frissítése';

  @override
  String get listsUpdated => 'A geo-fájlok frissültek.';

  @override
  String get testDestination => 'Útvonal tesztelése';

  @override
  String get destinationHint => 'Domain, IP-cím vagy URL';

  @override
  String get check => 'Ellenőrzés';

  @override
  String get routeDirect => 'Közvetlenül megy';

  @override
  String get routeProxy => 'A VPN-en át megy';

  @override
  String get routeBlock => 'Tiltva';

  @override
  String ruleMatched(String rule) {
    return 'Szabály: $rule';
  }

  @override
  String get portRefusedNote =>
      'A Mozilla proxyja nem csatlakozik ehhez a porthoz.';

  @override
  String get sectionAdvanced => 'Speciális';

  @override
  String get tlsFragment => 'TLS-fragmentálás';

  @override
  String get tlsFragmentOff => 'Kikapcsolva';

  @override
  String get tlsFragmentFirstByte => 'Első bájt';

  @override
  String get tlsFragmentSni => 'Kiszolgálónév (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Az első bájtnál osztja ketté a TLS-fejlécet (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Több TCP-csomagra osztja a kiszolgálónevet (SNI)';

  @override
  String get tlsFragmentRecord => 'TLS-rekord';

  @override
  String get tlsFragmentRecordHint =>
      'Két TLS-rekordra osztja a kiszolgálónevet (SNI)';

  @override
  String get tlsFragmentOffHint => 'Normál TLS-kapcsolat';

  @override
  String get sectionBypass => 'Ha a Mozilla le van tiltva';

  @override
  String get sharedRelay => 'Megosztott átjátszó';

  @override
  String get sharedRelayHint =>
      'Az alkalmazás megosztott átjátszóinak használata, ha a Mozilla blokkolja a régiót. Az engedélyezett saját átjátszó elsőbbséget élvez.';

  @override
  String get personalRelay => 'Saját átjátszó';

  @override
  String get apiRelay => 'Közvetítő szerver';

  @override
  String get apiRelayUse => 'A továbbítószerver használata';

  @override
  String get apiRelayHint =>
      'Saját Cloudflare Worker, vagy relay.php a saját tárhelyén.\nCsak akkor használatos, ha a Mozilla közvetlenül nem válaszol: a bejelentkezés, a fiókok és a szerverlista megy rajta keresztül, a VPN-forgalom nem.';

  @override
  String get upstreamProxy => 'Felsőbb szintű proxy';

  @override
  String get upstreamProxyOn => 'A felsőbb szintű proxy be van kapcsolva';

  @override
  String get upstreamProxyAddress => 'SOCKS5-proxy címe';

  @override
  String get upstreamProxyPort => 'Port';

  @override
  String get upstreamProxyHint =>
      'A Mozillához vezető kapcsolat ezen a proxyn megy át, azokhoz a hálózatokhoz, amelyek letiltják vagy lassítják a Mozillát.\nHa a proxy ezen az eszközön fut, hagyja ki a VPN-ből.';

  @override
  String get upstreamProxyInvalid =>
      'Adja meg a proxy címét, például 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort =>
      'Adjon meg egy portot 1 és 65535 között.';

  @override
  String get upstreamProxyOwn =>
      'Ez az alkalmazás saját proxyja. Adjon meg egy másikat.';

  @override
  String get apiRelayInvalid => 'https:// címnek kell lennie.';

  @override
  String get listenAddress => 'Proxyhozzáférés';

  @override
  String get listenLocal => '127.0.0.1 · csak ez az eszköz';

  @override
  String get listenAll => '0.0.0.0 · minden hálózat (LAN)';

  @override
  String get proxyUsername => 'Proxy-felhasználónév';

  @override
  String get proxyPassword => 'Proxyjelszó';

  @override
  String get proxyLoginHint =>
      'Az alkalmazásoknak ezekkel kell bejelentkezniük. Hagyja mindkettőt üresen, ha nem kell bejelentkezés.';

  @override
  String get loginBothOrNone =>
      'Töltse ki mindkettőt, vagy hagyja üresen mindkettőt.';

  @override
  String get proxyLogin => 'Proxyhitelesítés';

  @override
  String get idleSleep => 'Alvás tétlenség után';

  @override
  String get sleepNever => 'Soha';

  @override
  String sleepMinutes(int count) {
    return '$count perc';
  }

  @override
  String get sleepHour => '1 óra';

  @override
  String get showPublicIp => 'Nyilvános IP megjelenítése';

  @override
  String get hapticFeedback => 'Rezgés a kapcsolat változásakor';

  @override
  String get keepScreenOn => 'A képernyő ébren tartása csatlakozás közben';

  @override
  String get showTraffic => 'Élő forgalom megjelenítése a kezdőlapon';

  @override
  String get speedInNotification => 'Sebesség megjelenítése az értesítésben';

  @override
  String get liveTraffic => 'Élő forgalom';

  @override
  String get totalTraffic => 'Teljes forgalom';

  @override
  String get verboseLogs => 'Részletes naplók';

  @override
  String get webDashboard => 'Webes vezérlőpult';

  @override
  String get webDashboardOpen => 'Megnyitás';

  @override
  String get webDashboardHint => 'Speciális beállítások és további eszközök';

  @override
  String numberInvalid(int min, int max) {
    return 'Adjon meg egy számot $min és $max között';
  }

  @override
  String get notifySwitchedTitle => 'Fiókváltás';

  @override
  String notifySwitchedBody(String name) {
    return 'Aktív fiók: $name.';
  }

  @override
  String get notifySignInTitle => 'Bejelentkezés szükséges';

  @override
  String get notifySignInBody =>
      'Egy fiókba újra be kell jelentkezni a Fiókok oldalon.';

  @override
  String get navAbout => 'Névjegy';

  @override
  String get appVersionLabel => 'Alkalmazás verziója';

  @override
  String get coreVersionLabel => 'Magprogram verziója';

  @override
  String get checkUpdates => 'Frissítések keresése';

  @override
  String get checkingUpdates => 'Keresés…';

  @override
  String get upToDate => 'A legújabb verziót használja.';

  @override
  String updateAvailable(String version) {
    return 'Elérhető a(z) $version verzió.';
  }

  @override
  String updateRequired(String version) {
    return 'Frissíts a(z) $version verzióra. Ez a frissítés szükséges.';
  }

  @override
  String get download => 'Letöltés';

  @override
  String updateCheckFailed(String error) {
    return 'Nem sikerült frissítéseket keresni: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'A GitHub nem érhető el. Ellenőrizze az internetkapcsolatot, és próbálja újra.';

  @override
  String get updateNow => 'Frissítés';

  @override
  String updateDownloading(String version) {
    return 'A(z) $version verzió letöltése…';
  }

  @override
  String updateReady(String version) {
    return 'A(z) $version verzió készen áll a telepítésre.';
  }

  @override
  String updateInstalling(String version) {
    return 'A(z) $version verzió telepítése. Az alkalmazás bezárul, majd újra megnyílik.';
  }

  @override
  String updateFailed(String version) {
    return 'Nem sikerült frissíteni a(z) $version verzióra.';
  }

  @override
  String updateDone(String version) {
    return 'Frissítve a(z) $version verzióra.';
  }

  @override
  String updateRolledBack(String version) {
    return 'A(z) $version verzióra frissítés nem fejeződött be, ezért az alkalmazás visszaállt az előző verzióra.';
  }

  @override
  String get repoNotSet => 'A GitHub-tároló még nincs beállítva.';

  @override
  String get sourceCode => 'Forráskód';

  @override
  String get tapToConnect => 'Kattintson a csatlakozáshoz';

  @override
  String get tapToDisconnect => 'Kattintson a kapcsolat bontásához';

  @override
  String get startOnBoot => 'Indítás rendszerindításkor';

  @override
  String get connectOnStartup => 'Csatlakozás rendszerindításkor';

  @override
  String get proxyServiceActive => 'A proxyszolgáltatás aktív';

  @override
  String get navHome => 'Kezdőlap';

  @override
  String get groupApp => 'Alkalmazás';

  @override
  String get groupNetwork => 'Hálózat';

  @override
  String get stateOff => 'Nincs csatlakozva';

  @override
  String get tapToConnectPhone => 'Koppintson a csatlakozáshoz';

  @override
  String get tapToDisconnectPhone => 'Koppintson a kapcsolat bontásához';

  @override
  String get tapToConnectTv => 'Nyomja meg az OK gombot a csatlakozáshoz';

  @override
  String get tapToDisconnectTv =>
      'Nyomja meg az OK gombot a kapcsolat bontásához';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Ajánlott helyszín';

  @override
  String dataLeftOf(String limit) {
    return '/ $limit';
  }

  @override
  String get homeLocation => 'Helyszín';

  @override
  String get connectedTo => 'Csatlakozva ide:';

  @override
  String get vpnNotAllowed =>
      'A VPN-hez az Ön engedélye szükséges. Koppintson újra a gombra, és engedélyezze.';

  @override
  String get dataUsedTitle => 'Felhasznált adat';

  @override
  String get bypassApps => 'Alkalmazásonkénti proxy';

  @override
  String get connectRetrying =>
      'Nem sikerült csatlakozni. Ellenőrizze az internetet.';

  @override
  String get failUnreachable =>
      'Nem sikerült elérni a Mozilla szervereit. Próbáljon másik internetkapcsolatot.';

  @override
  String get failUpstreamProxy =>
      'Nem sikerült elérni a Mozillát a felsőbb szintű proxyn keresztül. Ellenőrizze, hogy fut-e.';

  @override
  String get failInsideVpn =>
      'Ez az internet már egy VPN-en keresztül megy. Kapcsolja ki.';

  @override
  String get failRefused =>
      'A Mozilla szervere elutasította a kapcsolatot. Próbálja újra néhány perc múlva.';

  @override
  String get failLocationRefused =>
      'Ez az ország nem érhető el a fiókja számára. Válasszon másik országot.';

  @override
  String get useRecommendedLocation => 'Az ajánlott helyszín használata';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Ezt választotta: $chosen, de az IP-címe ezt mutatja: $exit.';
  }

  @override
  String get failSignIn =>
      'A fiók bejelentkezése lejárt. Jelentkezzen be újra a Fiókok oldalon.';

  @override
  String get failQuota =>
      'Az e havi adatkeret elfogyott. Adjon hozzá egy másik fiókot.';

  @override
  String get failNotEntitled =>
      'A Mozilla nem engedi, hogy ez a fiók használja a VPN-t. Adjon hozzá egy másik fiókot.';

  @override
  String get failRegion =>
      'A Mozilla nem nyújtja szolgáltatását az Ön országában.';

  @override
  String get failServer =>
      'A Mozilla szolgáltatásában átmeneti hiba van. Az alkalmazás magától újrapróbálja.';

  @override
  String get failNoAccount =>
      'Egyik fiók sem áll készen. Nyissa meg a Fiókok oldalt.';

  @override
  String get failTestSite =>
      'Csatlakozott a szerverhez, de az oldalak nem nyílnak meg. Próbáljon másik országot.';

  @override
  String get failOther => 'Nem sikerült csatlakozni. Próbálja újra.';

  @override
  String get failNoInternet =>
      'Nincs internet. Ellenőrizze a Wi-Fit vagy a mobiladatot.';

  @override
  String get waitingForNetwork => 'Várakozás az internetkapcsolatra…';

  @override
  String proxyStartFailed(String port) {
    return 'A proxy nem tudott elindulni a(z) $port porton. Válasszon másik portot.';
  }

  @override
  String get connectionSettings => 'Kapcsolati beállítások';

  @override
  String get appModeExclude => 'Kijelöltek VPN nélkül';

  @override
  String get appModeInclude => 'Csak a kijelöltek VPN-nel';

  @override
  String get appModeExcludeHint =>
      'A kijelölt alkalmazások közvetlenül csatlakoznak, nem a VPN-en át: például a külföldi címeket elutasító banki alkalmazások.';

  @override
  String get appModeIncludeHint =>
      'Csak a kijelölt alkalmazások mennek a VPN-en át; a többiek közvetlenül csatlakoznak.';

  @override
  String fromRegionList(String region) {
    return 'Javasolt: szerepel a(z) $region listán';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Kapcsolati mód';

  @override
  String get modeProxyHint =>
      'Csak a proxy használatára beállított alkalmazások mennek rajta át.';

  @override
  String get modeSystemProxyHint =>
      'A Windows és a legtöbb alkalmazás a proxyn át megy.';

  @override
  String get modeSystemProxyHintOther =>
      'A böngészők és a legtöbb alkalmazás a proxyn át megy.';

  @override
  String get suggestedApps => 'Javasolt alkalmazások';

  @override
  String get showSystemApps => 'Rendszeralkalmazások megjelenítése';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count javasolt alkalmazás kijelölve',
      one: '1 javasolt alkalmazás kijelölve',
      zero: 'A javasolt alkalmazások már ki vannak jelölve',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Automatikus';

  @override
  String get locationsSection => 'Helyszínek';

  @override
  String get dnsSummaryOk => 'A titkosított DNS működik';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nevet nem sikerült feloldani',
      one: '1 nevet nem sikerült feloldani',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'ezen át: $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'A hálózat DNS-e $count névre szűrő címet adott vissza. Ezeknél az alkalmazás nem használja ezt a DNS-t.',
      one: 'A hálózat DNS-e 1 névre szűrő címet adott vissza. Ennél az alkalmazás nem használja ezt a DNS-t.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Válasz:';

  @override
  String get dnsNetworkAnswer => 'Hálózati DNS:';

  @override
  String get dnsFiltered => 'szűrt';

  @override
  String get rulesSyntaxTitle => 'Soronként egy szabály';

  @override
  String get ruleDomain => 'Az oldal és aldomainjei';

  @override
  String get ruleFull => 'Pontosan ez a név';

  @override
  String get ruleKeyword => 'A szót tartalmazó nevek';

  @override
  String get ruleGeosite => 'Egy címke oldalai a geo-fájlokban';

  @override
  String get ruleGeoip => 'Egy ország címei a geo-fájlokban';

  @override
  String get ruleIp => 'Egy cím vagy hálózat';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Csak proxy';

  @override
  String get noNetwork =>
      'Nincs internetkapcsolat. Kapcsolja be a Wi-Fit vagy a mobiladatot.';

  @override
  String get blockAds => 'Hirdetések tiltása';

  @override
  String systemProxyTakenBy(String address) {
    return 'Egy másik program a rendszerproxyt erre állította: $address, így a forgalom nem a VPN-en megy.';
  }

  @override
  String get systemProxyTakenOff =>
      'Egy másik program kikapcsolta a rendszerproxyt, így a forgalom nem a VPN-en megy.';

  @override
  String get setSystemProxyAgain => 'Beállítás újra';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'A $os teljes forgalma a VPN-en át megy.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'Várakozás az engedélyre a TUN-szolgáltatás telepítéséhez…';

  @override
  String get tunInstallCancelled =>
      'A TUN módhoz egyszer rendszergazdai engedély kell. Az engedély nem érkezett meg, ezért a mód nem változott.';

  @override
  String tunInstallFailed(String error) {
    return 'A TUN-szolgáltatás telepítése nem sikerült: $error';
  }

  @override
  String get tunStarting => 'A TUN mód indul…';

  @override
  String get tunFailed => 'A TUN mód nem indult el. Újrapróbálkozás…';

  @override
  String get tunLost => 'A TUN mód váratlanul leállt. Újrapróbálkozás…';

  @override
  String get tunNotRunning => 'A TUN-szolgáltatás nem fut. Újrapróbálkozás…';

  @override
  String get tunMissing => 'A TUN-szolgáltatás nincs telepítve.';

  @override
  String get tunOutdated =>
      'A TUN-szolgáltatás régebbi, mint ez az alkalmazás. A TUN mód használatához telepítse újra.';

  @override
  String get tunAppOutdated =>
      'A TUN-szolgáltatás újabb, mint ez az alkalmazás. A TUN mód használatához frissítse az alkalmazást.';

  @override
  String get tunBusy => 'Az Homa VPN egy másik példánya használja a TUN módot.';

  @override
  String get tunNoDriver =>
      'A rendszer TUN-illesztőprogramja nem érhető el. Indítsa újra a számítógépet, és próbálja újra.';

  @override
  String get tunInstall => 'Telepítés';

  @override
  String get tunInstallAgain => 'Újratelepítés';

  @override
  String get trayTunMode => 'TUN mód (minden alkalmazás)';

  @override
  String get removeTunService => 'A TUN-szolgáltatás eltávolítása';

  @override
  String get removeTunServiceHint =>
      'Eltávolítja a rendszerszolgáltatást, amelyet a TUN mód használ. A TUN újbóli választása újra telepíti.';

  @override
  String get tunServiceRemoved => 'A TUN-szolgáltatás eltávolítva.';

  @override
  String get tunInstallPrompt =>
      'Az Homa VPN telepíteni szeretné a TUN mód szolgáltatását.';

  @override
  String get tunRemovePrompt =>
      'Az Homa VPN el szeretné távolítani a TUN mód szolgáltatását.';

  @override
  String tunRemoveFailed(String error) {
    return 'A TUN-szolgáltatás eltávolítása nem sikerült: $error';
  }

  @override
  String get sectionTun => 'TUN-beállítások';

  @override
  String get tunPrograms => 'VPN-t megkerülő programok';

  @override
  String get tunProgramsHint =>
      'Közvetlenül csatlakoznak, nem a Mozillán át. Csak VPN nélkül is működő programokhoz.';

  @override
  String get tunProgramsEmpty => 'Még nincs program.';

  @override
  String get addProgram => 'Program hozzáadása';

  @override
  String get programFiles => 'Programok';

  @override
  String get tunProgramAll => 'Teljes forgalom';

  @override
  String get tunProgramAllHint => 'A teljes program közvetlenül csatlakozik.';

  @override
  String get tunProgramUdp => 'Csak UDP';

  @override
  String get tunProgramUdpHint =>
      'Csak az UDP-je csatlakozik közvetlenül; a többi a VPN-en át megy.';

  @override
  String get udpNoticeSetting => 'Értesítés letiltott UDP-ről';

  @override
  String udpNoticeBody(String program) {
    return 'A(z) $program UDP-forgalma nem megy át a VPN-en.';
  }

  @override
  String get dontShowAgain => 'Ne mutassa többé';

  @override
  String get addRunningProgram => 'A futó programok közül';

  @override
  String get addProgramFile => 'Fájl kiválasztása…';

  @override
  String get addProgramName => 'Név beírása…';

  @override
  String get programNameHint =>
      'Egy program fájlneve, például steam.exe; a * bármilyen szöveget jelent (a steam* az összes Steam-program).';

  @override
  String get runningProgramsEmpty => 'Más program nem fut.';

  @override
  String get tabLog => 'Napló';

  @override
  String get tabConnections => 'Kapcsolatok';

  @override
  String get connectionsEmpty => 'Még nincs kapcsolat.';

  @override
  String connectionsOpen(int count) {
    return '$count nyitott';
  }

  @override
  String get connTime => 'Idő';

  @override
  String get connRoute => 'Szabály';

  @override
  String get connDestination => 'Cél';

  @override
  String get connInbound => 'Bejövő';

  @override
  String get connProtocol => 'Protokoll';

  @override
  String get connColumns => 'Oszlopok';

  @override
  String get connTraffic => 'Forgalom';

  @override
  String get connDuration => 'Időtartam';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Közvetlen';

  @override
  String get connRouteBlocked => 'Letiltva';

  @override
  String get connRoutePort => 'Port elutasítva';

  @override
  String get connRouteFailed => 'Sikertelen';

  @override
  String get testRelay => 'Átjátszó ellenőrzése';

  @override
  String get relayTestTitle => 'Átjátszó állapotvizsgálata';

  @override
  String get relayTestHint =>
      'Csak az átjátszót ellenőrzi. Nem küld Mozilla-kérést vagy fiókadatokat.';

  @override
  String get relayTestPassed => 'Az átjátszó kész';

  @override
  String get relayTestFailed => 'Az átjátszó állapota nem igazolható';

  @override
  String get relayTestCopy => 'Jelentés másolása';

  @override
  String get relayTestInterrupted =>
      'A teszt a teljes eredmény beérkezése előtt véget ért.';

  @override
  String get searchLocations => 'Helyek keresése';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hely',
      one: '1 hely',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Automatikus frissítés';

  @override
  String get autoInstallApkHint =>
      'Az új verziók maguktól letöltődnek; a telepítő rákérdez, mielőtt telepít.';

  @override
  String get installNow => 'Telepítés';

  @override
  String get updateAllowInstall =>
      'A frissítés telepítéséhez engedélyezze az alkalmazásnak alkalmazások telepítését.';

  @override
  String get allowInstall => 'Engedélyezés';

  @override
  String get noResults => 'A keresésnek megfelelő hely nincs.';

  @override
  String get accentColor => 'Kiemelő szín';

  @override
  String get accentMono => 'Egyszínű (alapértelmezett)';

  @override
  String get accentCustom => 'Egyéni szín';

  @override
  String get accentEmber => 'Parázs';

  @override
  String get accentGold => 'Arany';

  @override
  String get accentEmerald => 'Smaragd';

  @override
  String get accentSapphire => 'Zafír';

  @override
  String get accentAmethyst => 'Ametiszt';

  @override
  String get accentRose => 'Rózsa';

  @override
  String get autoReconnect => 'Automatikus újracsatlakozás';

  @override
  String get autoReconnectHint =>
      'Önmagától visszakapcsol, ha a kapcsolat a kérése nélkül megszakad.';

  @override
  String get androidOnlyHint => 'Csak telefonon.';

  @override
  String get idleDisconnect => 'Bontás üresjáratnál';

  @override
  String get idleDisconnectHint =>
      'Befejezi a munkamenetet, ha egy darabig nem folyik forgalom.';

  @override
  String get idleTimeout => 'Üresjárati várakozás';

  @override
  String get minutes5 => '5 perc';

  @override
  String get minutes10 => '10 perc';

  @override
  String get minutes15 => '15 perc';

  @override
  String get minutes30 => '30 perc';

  @override
  String get minutes60 => '1 óra';

  @override
  String get dataLimit => 'Munkamenet adatkorlátja';

  @override
  String get dataLimitHint =>
      'Befejezi a munkamenetet, ha forgalma eléri a korlátot.';

  @override
  String get dataLimitAmount => 'Korlát';

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
    return '$minutes percig nem folyt forgalom, ezért a kapcsolat megszakadt.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'A munkamenet elérte a(z) $mb MB adatkorlátot, ezért a kapcsolat megszakadt.';
  }

  @override
  String get protection => 'Védelem';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Ha a VPN megszakad, a forgalom visszatartva — szivárgás nélkül — amíg újra csatlakozik.';

  @override
  String get alwaysOnVpn => 'Mindig bekapcsolt VPN';

  @override
  String get alwaysOnVpnHint =>
      'Az Android saját őre: a VPN nélkül semmi nem megy át.';

  @override
  String get floatingIsland => 'Lebegő sziget';

  @override
  String get floatingIslandHint =>
      'Amíg az alkalmazáson kívül van, a többi alkalmazás fölött mutatja a kapcsolatot.';

  @override
  String whatsNewTitle(String version) {
    return 'Új ebben a verzióban ($version)';
  }

  @override
  String get whatsNewContinue => 'Rendben';

  @override
  String get whatsNewMenu => 'Újdonságok';

  @override
  String get whatsNewView => 'Megint megtekintés';

  @override
  String get updateServers => 'Szerverek frissítése';

  @override
  String get updatingServers => 'Frissítés…';

  @override
  String serversUpdated(int count) {
    return '$count helyszín a Mozilla hivatalos listájából';
  }

  @override
  String get serversUpdateFailed =>
      'A szerverlista frissítése nem sikerült; a régi lista megmaradt.';

  @override
  String get smartPickTitle => 'Most a leggyorsabb';

  @override
  String get smartPickUse => 'Használat';

  @override
  String get connectAtBoot => 'Csatlakozás a telefon bekapcsolása után';

  @override
  String get connectAtBootHint =>
      'A telefon bekapcsolásakor magától csatlakozik, ha a VPN-engedély már megvan.';

  @override
  String get gamingProfile => 'Játék profil';

  @override
  String get gamingProfileHint =>
      'A kapcsolat élő késleltetését és minőségét mutatja; a mérleg gyorsabb szerverrel párosítva.';

  @override
  String get diagnosticsRun => 'Diagnosztika futtatása';

  @override
  String get diagnosticsHint =>
      'Kapcsolat, DNS és alagút, egy koppintással ellenőrizve';

  @override
  String get diagnosticsTunnel => 'Alagút';

  @override
  String get diagnosticsTunnelUp => 'Működik és forgalmat visz';

  @override
  String get diagnosticsTunnelDown => 'Leállt';

  @override
  String get diagnosticsExit => 'Kilépő ország';

  @override
  String get diagnosticsMismatch => 'A kilépés eltér a választástól';

  @override
  String get diagnosticsConnection => 'Kapcsolat teszt';

  @override
  String get diagnosticsPassed => 'Sikeres';

  @override
  String get diagnosticsFailed => 'Sikertelen';

  @override
  String get diagnosticsDnsFiltered => 'Letiltott vagy szűrt válasz';

  @override
  String get diagnosticsDnsOk => 'Válaszolt';

  @override
  String get diagnosticsPrivacy =>
      'Itt semmi nem tárolódik; az eredmények ebben az ablakban és a mag saját naplójában maradnak.';

  @override
  String get diagnosticsAgain => 'Futtatás újra';

  @override
  String get whatsNewAdded => 'Új';

  @override
  String get whatsNewImproved => 'Továbbfejlesztve';

  @override
  String get whatsNewFixed => 'Javítva';

  @override
  String get wnWheelImproved =>
      'Az országkerék újrarajzolva: a választott zászló üvegbelkerőben, finom fénnyel és mögötte halvány fényudvarral nagyobban áll, a többi zászló kisebb, mélységgel, az alatta lévő név csúszva érkezik.';

  @override
  String get wnLiveImproved =>
      'Csatlakozás közben az értesítés megkéri az Android 16-ot, hogy Live Update-ként emelje ki, ahogy a referencia-megvalósítás teszi; az idő magát számolja, a sebességek élnek.';

  @override
  String get wnL10nFixed =>
      'Ez az oldal most az alkalmazás nyelvén szólal meg — mind a tizenöt nyelvén, nem csak angolul.';

  @override
  String get wnMarkFixed =>
      'A Mozilla jele tisztán ül a lapkáján, lekerekítve, mint a zászlók.';

  @override
  String get designTitle => 'Kezdőlap design';

  @override
  String get designHint => 'A kezdőlap elrendezése';

  @override
  String get designWheel => 'Korong';

  @override
  String get designWheelDesc => 'A zászlók üvegkorongján, a kapcsoló alattuk';

  @override
  String get designBento => 'Bento';

  @override
  String get designBentoDesc =>
      'A bento doboz saját dizajnja: a zászlók a csempéjük tábláján, a kapcsolat csempe, a számok és a hely egy meleg doboz csempéiként';

  @override
  String get designPixel => 'Material You';

  @override
  String get designPixelDesc =>
      'Material You: tonális felületek, nagy tömör kártyák, pillancele kijelzős sáv és nagy címek — az Android saját hangja';

  @override
  String get notifFlag => 'Országzászló az értesítésben';

  @override
  String get notifFlagHint => 'Az ország saját zászlója a neve mellett';

  @override
  String get wnDesignAdded =>
      'Kezdőlap-design beállítás: korong, mozaik vagy kompakt kártya';

  @override
  String get wnMapAdded =>
      'Valódi vektoros világtérkép a kezdőlap mögött, a választott ország fényben';

  @override
  String get wnWheelAdded =>
      'A zászlókorong újrarajzolva: mélyebb üveg, lágyabb mozgás';

  @override
  String get wnFlagNotifAdded =>
      'Az értesítés mutathatja az ország SVG zászlaját, és kikapcsolható';

  @override
  String get wnColorRemoved =>
      'A saját szín oldal eltűnt; az akcentlista megtartja a HEX kódot';

  @override
  String get whatsNewRemoved => 'Eltávolítva';

  @override
  String get wnCrashFixed =>
      'Az alkalmazás már nem áll meg magától Android 16 telefonokon: az értesítés olyat kért a rendszertől, amit a telefon még nem tudott.';

  @override
  String get wnFlagArtFixed =>
      'Az alkalmazás már nem zárja be magát megnyitáskor: az értesítés zászlóképe olyan értéket adott vissza, amelyet a rendszer üzenetközvetítője nem fogad el.';

  @override
  String get statSession => 'Munkamenet';

  @override
  String get copiedToClipboard => 'A vágólapra másolva';

  @override
  String get wnTotalsAdded =>
      'A főoldal összesen mutatja, mit mozgatott a munkamenet, és egy koppintás átmásolja a nyilvános IP-t.';

  @override
  String get wnPolishImproved =>
      'A zászlókerék és a szerveroldal rendezettebb; a szövegek tömörebbek, és az Android-alagút gyorsabban viszi a forgalmat.';

  @override
  String get valueSmart => 'Okos';

  @override
  String get wnSmartAdded =>
      'Okos kapcsolat: az MTU, a protokoll és az IP-verzió a hálózathoz igazodik, valódi válaszok alapján, a sebességért.';

  @override
  String get wnToastAdded =>
      'A megerősítések most puha, iOS-stílusú jelzésként érkeznek, önmagát kirajzoló jellel.';

  @override
  String get wnFlagsImproved =>
      'A zászlókerék tisztán áll: egyetlen zászló sem vágódik félbe a képernyő szélén, a zászlók egészben látszanak, és a választás puha rugóval ér földet.';

  @override
  String get wnMapImproved =>
      'A világtérkép nagyobban és tisztábban rajzolódik: nyomorított kontinensek nélkül, sima partvonalakkal, és világító aurával a ponton.';

  @override
  String get dnsManual => 'Kézi DNS';

  @override
  String get dnsManualHint =>
      'Soronként egy cím: sima IP, https:// (DNS over HTTPS) vagy tls://host (DNS over TLS). Az első válasz nyer.';

  @override
  String get dnsManualInvalid =>
      'Az egyik sor nem olyan cím, amellyel a mag dolgozhat: sima IP, https://… vagy tls://host.';

  @override
  String get killSwitchGuarded =>
      'Őrzött: amíg az alagút áll, semmi nem hagyja el a telefont.';

  @override
  String get accountsUsageTitle => 'E hónapban';

  @override
  String get accountsCountLabel => 'fiók';

  @override
  String get accountsUsageAverage => 'a fiókok elhasznált részének átlaga';

  @override
  String get wnDesignsAdded =>
      'Alkalmazás-dizájnok: az egész app öltheti a Lágy neomorfizmust vagy a Sarkifény-üveget — minden oldal, minden kártya — a Beállítások → Általános alatt.';

  @override
  String get wnWheelFixed =>
      'A kerék félzászlója eltűnt: a kiválasztott zászló alatti polc egy fénytó, nem második zászló, és a képernyő szélén semmi nem vágódik félbe.';

  @override
  String get wnMapReal =>
      'A világtérkép a hivatalos országhatárokból készült újra — minden part, sziget és enkkláv, hűen és valódi arányban.';

  @override
  String get wnGlobeAdded =>
      'A világ most gömb: az ezüst gömb a kiválasztott ország felé fordul, fénylő tű és lebegő kártya jelöli, a kapcsolat útjai a csomópontok felé futnak.';

  @override
  String get wnWheelGlowImproved =>
      'A kiválasztott zászló nagyobban áll a saját kék halójával övezett üvegkeretben, a szomszédok láthatóan kisebbek, a kerék alatti jelzők pedig mutatják, hol tartasz.';

  @override
  String get wnDesignsRemoved =>
      'Az alkalmazás-dizájn választó eltávolítva: az app megint a saját egyszínű külsejét viseli — a kiemelő színed és a témád marad, ahogy volt.';

  @override
  String get wnDnsAdded =>
      'Kézi DNS: sima IP-címek, DNS over HTTPS és DNS over TLS — minden sor típusa gépelés közben látszik és ellenőrződik.';

  @override
  String get wnSmartImproved =>
      'Az okos kapcsolat most megmutatja, mit felelt a hálózat: a választott szállítást és a megtartott IP-verziót, élőben.';

  @override
  String get wnProtectionImproved =>
      'A kill switch jelzi, ha az őre áll, és az appok oldala megmutatja, hányat választottál.';

  @override
  String get wnWelcomeImproved =>
      'A üdvözlő egy lélegző pajzzsal nyílik, sodródó sarki fény felett, és a fiókok oldala egy pillantással összegzi a hónapot.';

  @override
  String bypassAppsCount(String n) {
    return 'Kiválasztva: $n';
  }

  @override
  String get sectionAppearance => 'Megjelenés';

  @override
  String get mapStyle => 'Térkép stílusa';

  @override
  String get mapStyleHint =>
      'A kezdőlap gömbje úgy festődik, ahogy választja. A kapcsolat fénye változatlan marad.';

  @override
  String get mapSilver => 'Ezüst';

  @override
  String get mapMidnight => 'Éjfél';

  @override
  String get mapOcean => 'Óceán';

  @override
  String get mapMono => 'Egyszínű';

  @override
  String get mapAurora => 'Aurora';

  @override
  String get batterySaver => 'Akkumulátorkímélő';

  @override
  String get batterySaverHint =>
      'Pihenre teszi a térkép mozgását kapcsolat közben — a gömb légzését, a kerék fényét. Maga a kapcsolat pontosan ugyanúgy marad.';

  @override
  String get connectOnOpen => 'Csatlakozás az app megnyitásakor';

  @override
  String get connectOnOpenHint =>
      'Az app megnyitásakor elindítja a VPN-t, az utoljára választott hellyel.';

  @override
  String get speedTitle => 'Sebesség';

  @override
  String get parallelTunnels => 'Párhuzamos alagutak';

  @override
  String get parallelTunnelsHint =>
      'Egyszerre több alagutat nyit a Mozilla felé, és szétosztja köztük a forgalmat, így egy lassú alagút többé nem szab határt a sebességnek. A nyolc a legnehezebb az akkumulátorra.';

  @override
  String get tunnels1 => 'Egy — a legstabilabb';

  @override
  String get tunnels2 => 'Kettő';

  @override
  String get tunnels4 => 'Négy — lassabb hálózatokon gyorsabb';

  @override
  String get tunnels8 => 'Nyolc — a leggyorsabb';

  @override
  String get connectionCap => 'Kapcsolatszám-korlát';

  @override
  String get connectionCapHint =>
      'Hány app beszélhet egyszerre a VPN-en át; kisebb korlát akkumulátort és adatot spórol egy elfoglalt telefonon. Korlátlan az alapértelmezett.';

  @override
  String get capNone => 'Korlátlan';

  @override
  String get verboseLogging => 'Részletes diagnosztika';

  @override
  String get verboseLoggingHint =>
      'Minden lépést a naplóba ír — hiba jelzésekor hasznos, az akkumulátort kicsit jobban terheli.';

  @override
  String get wn38MapStylesAdded =>
      'Öt stílus a térképnek: ezüst, éjfél, óceán, egyszínű és aurora — a beállítások új Megjelenés oldala választ, mindegyik előnézetével.';

  @override
  String get wn38ZoomAdded =>
      'A térkép nagyítható: csippentsd össze, vagy koppints kétszer a közelítéshez és vissza.';

  @override
  String get wn38OptionsAdded =>
      'Hasznos beállítások: párhuzamos alagutak a nagyobb sebességért, kapcsolatszám-korlát, akkumulátorkímélő, csatlakozás az app megnyitásakor és részletes diagnosztika.';

  @override
  String get wn38SocialAdded =>
      'Az Instagram és a Telegram most az oldal alján is otthon van.';

  @override
  String get wn38FlightImproved =>
      'Egy ország választása kis repülés: a kamera hátrahúzódik, a gömb fordul, a tű pattanva ér földet, és az utak maguktól húzódnak a központok felé.';

  @override
  String get wn38EffectsImproved =>
      'A térkép gazdagabban mutatkozik: csillagok a gömb mögött, koordináta-háló, a központok saját fényei, fényudvar a peremen és a szárazföld árnyéka.';

  @override
  String get wn38SpeedImproved =>
      'A sebesség opció valós: a párhuzamos alagutak egyszerre több kapcsolatot nyitnak, a mag pedig szétosztja köztük a forgalmat.';

  @override
  String get wn38NameFixed =>
      'A választott ország neve egyszer jelenik meg — a térkép lebegő kártyáján; a másolat a zászlók alatt eltűnt.';

  @override
  String get mapKind => 'Térkép típusa';

  @override
  String get mapKindHint =>
      'Hogyan jelenik meg a kezdőlap világa: a lapos térkép, mint mindig (alapértelmezett), modern változata, az éjszakai Föld, a domborzati Föld, a fémgömb vagy a műholdas Föld. A határok minden típusban a valódi, hivatalos határok.';

  @override
  String get mapKindClassic => 'Klasszikus';

  @override
  String get mapKindGlobe => '3D gömb';

  @override
  String get mapKindSatellite => 'Műhold';

  @override
  String get mapKindFlat => 'Lapos 2D';

  @override
  String get mapKindHud => 'Radar';

  @override
  String get mapStyleGlobeHint =>
      'A 3D gömb színei. A műhold a saját Földjét viseli, a lapos térképek a saját tusukat.';

  @override
  String get aboutVersions => 'Verzió';

  @override
  String get aboutChannels => 'Elérhetőségi oldalak';

  @override
  String get checkUpdatesHint =>
      'Újabb verzió keresése; a megtalált letöltődik, és a telepítő megkérdezi.';

  @override
  String get speedTestTitle => 'Sebességteszt';

  @override
  String get speedTestRun => 'Mérés';

  @override
  String get speedTestFailed => 'A mérés nem fejeződött be.';

  @override
  String get speedTestThrough => 'Az alagúton át mérve.';

  @override
  String get speedTestDirect => 'Közvetlenül mérve (a proxy ki van kapcsolva).';

  @override
  String get speedTestHint =>
      'Egy letöltés és egy feltöltés az alagúton át megmondja, mit bír valójában. A főoldal grafikonja is ezt nyitja.';

  @override
  String get speedGraphHint => 'Az alagút elmúlt perce · koppints a méréshez';

  @override
  String get favoritePinned => 'Kitűzve. Az eltávolításhoz tartsd nyomva újra.';

  @override
  String get favoriteUnpinned => 'Eltávolítva.';

  @override
  String get shareReport => 'Jelentés megosztása';

  @override
  String get shareReportCopied => 'A jelentés a vágólapon van.';

  @override
  String get batteryWizardTitle => 'Életben maradás az akkumulátorral';

  @override
  String get batteryWizardBody =>
      'A Xiaomi, Samsung, Huawei és fajtársai a képernyőzár után megölik a VPN-alkalmazásokat. Vedd ki ezt az appot az akkumulátoroptimalizálásból, hogy az alagút égve maradjon.';

  @override
  String get batteryWizardSteps =>
      'A gyártó saját beállításaiban engedélyezd az automatikus indítást, és tedd az appot Korlátozás nélkül (Xiaomi), az Alvó alkalmazásokból kivezetve (Samsung) vagy Kézi indítás (Huawei) állapotba.';

  @override
  String get batteryWizardState =>
      'Az akkumulátoroptimalizálás leállíthatja az alagutat.';

  @override
  String get batteryWizardPermit => 'Engedélyezés';

  @override
  String get batteryWizardOk => 'Az alagút védve van az akkumulátortól.';

  @override
  String get batteryWizardOpen => 'Akkumulátorbeállítások';

  @override
  String get usageTitle => 'App-használat';

  @override
  String get usageRowHint => 'Mennyit használt egy-egy app';

  @override
  String get usageGrant => 'Használati hozzáférés nyitása';

  @override
  String get usageGrantHint =>
      'Az Android az apponkénti adathasználatot a használati hozzáférés engedélye mögött tartja. A gomb által nyitott oldal a rendszeré; az app csak a számokat olvassa.';

  @override
  String get usageEmpty => 'Ebben az időszakban nincs rögzített használat.';

  @override
  String get usageToday => 'Ma';

  @override
  String get usageWeek => ' Elmúlt 7 nap';

  @override
  String get usageMonth => 'Elmúlt 30 nap';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'Az alkalmazás a Google Playen kívülről települ, ezért az első telepítéskor a Play Protect ellenőrzést kérhet. Érintse meg egyszer az „Alkalmazás beolvasása\" gombot — a tiszta ellenőrzés megmarad, és a későbbi frissítések kérdés nélkül települnek.';

  @override
  String get smartLocation => 'Leggyorsabb helyszín';

  @override
  String get smartLocationHint =>
      'Minden indítás a mag saját késleltetés-mérése szerint leggyorsabb szerverre ül.';

  @override
  String get quicPass => 'QUIC átengedés';

  @override
  String get quicPassHint =>
      'Az appok QUIC-je (UDP 443) átmegy az alagúton: hívások és játékok megtartják sebességüket, TCP-re esés nélkül.';

  @override
  String get accountRename => 'Fiók átnevezése';

  @override
  String get accountRenameLabel => 'Fiók neve';

  @override
  String get accountProfile => 'Profilkép';

  @override
  String get avatarReset => 'Vissza az egyszerű jelig';

  @override
  String get accountSecurity => 'App jelszó';

  @override
  String get appPasswordOn => 'Az app jelszó mögött nyílik meg.';

  @override
  String get appPasswordOff => 'Nincs jelszó: aki megnyitja az appot, bemegy.';

  @override
  String get appPasswordSet => 'Jelszó beállítása';

  @override
  String get appPasswordChange => 'Jelszó módosítása';

  @override
  String get appPasswordRemove => 'Jelszó eltávolítása';

  @override
  String get appPasswordCurrent => 'Jelenlegi jelszó';

  @override
  String get appPasswordNew => 'Új jelszó (4+ karakter)';

  @override
  String get appPasswordConfirm => 'Új jelszó ismét';

  @override
  String get appPasswordShort => 'Legalább 4 karakter.';

  @override
  String get appPasswordMismatch => 'A két jelszó nem ugyanaz.';

  @override
  String get appPasswordWrong => 'Hibás jelszó';

  @override
  String get appPasswordSetDone =>
      'A jelszó megállt — az app legközelebb kérni fogja.';

  @override
  String get appPasswordRemoved => 'A jelszó eltűnt; az app szabadon nyílik.';

  @override
  String get appPasswordUnlock => 'Az app zárolva van';

  @override
  String get appPasswordUnlockHint => 'A folytatáshoz írd be az app jelszavát.';

  @override
  String get wn39MapKinds =>
      'A térkép megint típusokat kínál: a régi lapos (alapértelmezett), a 3D gömb, a műholdas Föld és egy modern lapos 2D.';

  @override
  String get wn39EyeIp =>
      'A helyszínkártya szemett tart: koppints rá, lásd a forgalom kimenő címét, és másold.';

  @override
  String get wn39Profile =>
      'A fiókok saját nevet és profilképet viselnek, és az app jelszó mögött nyílhat.';

  @override
  String get wn39Smart =>
      'Az okos kapcsolat kibővült: valós késleltetés alapján leggyorsabb helyszín és QUIC átengedés hívásoknak, játékoknak.';

  @override
  String get wn39Flight =>
      'Az országváltás simábban repül — a kamera a főkörön halad — és a zászlókerék jelzői közelebb ülnek a zászlókhoz.';

  @override
  String get wn39ToastEverywhere =>
      'A dinamikus jegyzet most mindenhol ott van: minden mentés, másolás és hiba ugyanazt az animált üvegbogyót viseli.';

  @override
  String get wn39Updates =>
      'A frissítések tisztán tartják a tárolót: a telepítő a régi verziót cseréli, és csomag nem marad.';

  @override
  String get mapKindNight => 'Éjszaka';

  @override
  String get mapKindTerrain => 'Terep';

  @override
  String get wn40MapKindsNew =>
      'A térkép két új változata: az éjszakai Föld és a domborzati Föld.';

  @override
  String get wn40Flight =>
      'A 3D gömb egyetlen sima fordulattal repül az új országhoz — soha nem ugrál.';

  @override
  String get wn40Mercator =>
      'A lapos térképek a szabványos Mercator-vetülettel rajzolódnak: valódi arányok, szabványos határok, semmi összenyomás.';

  @override
  String get wn40NameBack =>
      'A választott ország neve visszatért a zászlók alá a lapos térképeken.';

  @override
  String get wn40Speed =>
      'Az alagút alapból két párhuzamos munkamenetet nyit — erősebb, stabilabb vonal.';

  @override
  String get wn40LockFixed =>
      'A csatlakozás gomb lakatja már nem villog ki az állapotok között.';

  @override
  String get wn40IpRemoved => 'A helykártya IP-ablakát eltávolítottuk.';

  @override
  String get soundFeedback => 'Hangok';

  @override
  String get soundFeedbackHint =>
      'Lágy hangok érintéshez, kapcsolókhoz, csatlakozáshoz és lecsatlakozáshoz';

  @override
  String get rateUnit => 'Sebesség mértékegysége';

  @override
  String get lockInBackground => 'Zárolás távollétben';

  @override
  String get lockBgNever => 'Soha';

  @override
  String get lockBgNow => 'Azonnal';

  @override
  String get lockBgMin5 => '5 perc után';

  @override
  String get lockBgMin15 => '15 perc után';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound =>
      'A csatlakozás hangja a rezgéssel együtt: a VPN rövid hangot szól le-, és felcsatlakozáskor (Beállítások → Általános).';

  @override
  String get wn41RateUnit =>
      'A sebesség a választott egységben olvasható: a megszokott KB/s vagy a kapcsolat Mbps-e.';

  @override
  String get wn41BackgroundLock =>
      'Az app távollétben magát is zárolhatja: a jelszó azonnal, 5 vagy 15 perc után újra kérhető.';

  @override
  String get wn41BiggerLimits =>
      'A munkamenet adatkerete 25, 50 vagy 100 GB-ra emelkedik.';

  @override
  String get wn41Motion =>
      'Új mozzanatok: a csatlakozott gömb lélegzik, a pipa magát rajzolja meg, az állapotszó értékei közt siklik, és a rossz jelszó megrázza a mezőt.';

  @override
  String get wn41AboutFixed =>
      'A Névjegy lap rendbe szedette: a két oldal egymás mellett, minden jegyzet a saját sorában, semmi összenyomás.';

  @override
  String get wn41HapticFixed =>
      'A rezgés beállítása újra hallgat: minden kapcsolódás és lecsatlakozás követi, nem csak a csúszka.';

  @override
  String get copyIp => 'IP másolása';

  @override
  String get wn42Fonts =>
      'Minden nyelv az app saját betűivel olvas: Noto Sans a két kínaihoz és a bengálihoz, Inter a latin és a cirill nyelvekhez — már egyetlen nyelv sem a telefon betűire támaszkodik.';

  @override
  String get wn42Sounds =>
      'Az app hangjai mostantól valóságosak: lágy koppanás minden szakaszban, két hang a kapcsolókhoz, fel-le szökő hang a csatlakozásnál és a lecsatlakozásnál, csengő a zárhoz — a hangkapcsoló mindet uralja.';

  @override
  String get wn42AboutFixed =>
      'A Névjegy lap középre igazítja logóját, nevét és jegyzetét, és az elérési azonosítók a telefon szélességétől függetlenül épek és egy sorban maradnak.';

  @override
  String get wn42Gaming =>
      'A játékprofil mostantól valóságos: a szerverek lapja félpercenként újraméri a késéseket, és a mért leggyorsabbat kiemeli az akcentussal.';

  @override
  String get avatarPhoto => 'Saját fotód';

  @override
  String get avatarPhotoFailed => 'A fotó nem használható';

  @override
  String get tlsFragmentAuto => 'Auto';

  @override
  String get tlsFragmentAutoHint =>
      'Előbb a teljes hello; a TLS-t folyton metsző hálózat fél órára magától elvágja a nevet';

  @override
  String get accentDesign => 'A maga tervezés fénye';

  @override
  String get wn45Designs =>
      'Négy új főoldali kinézet — Aurora, Neon, Alkonyat és Zsálya — mindegyik a maga palettájába öltözteti az összes oldalt';

  @override
  String get wn45HelloAuto =>
      'A TLS-hasogató megtanult: a kézfogást folyton ölő hálózat a nevét magától vágja ketté, és az alagút átjár';

  @override
  String get wn45RelayRace =>
      'A relé helyreállítása most három célt egyszerre próbál, a szűrt hálózat hamarabb talál utat';

  @override
  String get wn45AccentFixed =>
      'A színválasztó újra fényt ad az appnak — a színe nem ért el az oldalakig';

  @override
  String get wn45WhatsNewFixed =>
      'Az újdonságok oldala újra mutatja a szavait — üresen nyílt meg';

  @override
  String get wn46Designs =>
      'Két új megjelenés a referenciatervekből: az éter iOS állapotkártyája és a zed színátmenetes gömbje — mindegyik az egész alkalmazást öltözteti, a korábbi négy elment.';

  @override
  String get wn46Sounds =>
      'A hangok profi szettet kaptak: hullám a kezdődő kapcsolathoz, akkord amikor feláll, ereszkedő dallam amikor megszakad, és tompa hang a zárt úthoz — egyszerre egy hang.';

  @override
  String get wn47Designs =>
      'A két referenciakinézet most az egész alkalmazást öltözteti — minden oldalt, nem csak a főoldalt: az aether az első referencia iOS szerkezetét viseli (a hajlított bevágású sáv, a csoportosított táblák, a színes jelvények, a rendszer saját állatszínei), a zed pedig a második kifejező szerkezetét (a lebegő dokkot, a nagyon kerek kártyákat, a húzható eszközbuborékokat).';

  @override
  String get wn47Fixes =>
      'A keskeny képernyőkön túlcorduló beállítási sor most a végéig olvasható.';

  @override
  String get wn48Bars =>
      'A két dizájn alsó sávjai visszaültek a helyükre: az aether kék köre a saját fülének bevágásában pihen, a zed köre már nem takarja az alatta lévő nevet.';

  @override
  String get wn48Fit =>
      'A kezdőlapok újra beleférnek a kijelzőjükbe: az aether kártya a Disconnected szót a végéig olvassa, a zed gömbje egy lépést visszaesik, ha szűk az oldal, és kapcsolás közben sem kér egyetlen sáv sem csúsztatást a kapcsolathoz, és egyetlen tipp sem mondja a bontást egyszerre.';

  @override
  String get wn48Wheel =>
      'A zászlókerék feloldja a kártyát, mielőtt a képernyő széle kettévágná, a javasolt hely Mozilla-jelvényét olvasható méretben viseli, a sík térkép déli széle pedig egy vonal helyett az oldalba olvad.';

  @override
  String get wn49States =>
      'A két hivatkozási dizájn felvette a rajzolt részleteit: az aether kártya a munkamenet saját sebességeit viseli, ahogy az AetherST-é, a bekapcsológombja a referencia fényével lélegzik és elsüllyed az ujj alatt, a zed buborékja pedig alakjai között változik, középe áttűnéssel cserélődik.';

  @override
  String get wn49Words =>
      'A „Csatlakozás…” szónak most mindenhol helye van: miközben az alagút épül, a kapcsoló síne viseli a szót, a gomb jele állapotai között oldódik át, és a sín a kapcsolás saját ritmusában lélegzik — semmi nem tűnik el az ujj alatt.';

  @override
  String get wn49Sooner =>
      'A kapcsolat motorja visszatért az eredetihez: a relé készlet, a tartalék utak és emlékeik, valamint az ismételt kérések őre viszi az alagutat — hamarabb áll fel és kitart.';

  @override
  String get wn49Mark =>
      'Az ajánlott hely a Mozilla VPN igazi jelét viseli, a frissítés gombjai pedig a frissítés saját jelképét.';

  @override
  String get wn50Notch =>
      'A két dizájn ruhája kikerül abból a rendetlenségből, amit őrzött: az aether bevágású sávja a kör saját középpontját olvassa, a kiválasztott fül neve mindkét kinézetben az oldal saját tintáját viseli, a kör fénye pedig a körnél marad, s nem mossa le a nevet.';

  @override
  String get wn50Cards =>
      'A zed otthona a bentóba hajtja sebességeit: a sebességkártya a bentó két cellájához és a munkamenet sorához csatlakozik, az oldal utolsó kártyái felszabadítják a dokk ülését, és amikor az oldalt a végéig görgetik, semmi nem marad félig a dokk alatt.';

  @override
  String get wn50Veil =>
      'Az állapotsáv felvéti fátylát: a görgetett tartalom az óra alatt halványul el, ahelyett hogy nekiütközne, a zed elé tolt oldalai már nem az óra alatt kezdődnek, és lebegő eszközei távolról tartják a dokk ülését.';

  @override
  String get wn50Ping =>
      'Az aether ping-chipje egy koppintásra megint mér, úgy felel, ahogy a referencia saját chipje.';

  @override
  String get tapToChangeServer => 'Koppints a szerver cseréjéhez';

  @override
  String get wn51Smooth =>
      'A zászlókerék és a sáv úgy forog, ahogy egy keréknek forognia kell: a húzás és az országváltás most a komponálón utazik — amíg a zászlók forognak, semmi nem rendezi újra magát és egy fény sem rajzolja újra magát; a kerék simán forog, és az oldal vele együtt csúszik.';

  @override
  String get wn51Zed =>
      'A zed otthona magának a referenciának a szerkezetét ölti magára: a két sebességkártya a márka alatt áll (pihenéskor, a saját nulláikon, amikor az alagút pihen), az állapotszó a buborék alatt a display nagy arcával érkezik, a hely pedig a dokk feletti ragyogó szerverkártyán él — a kis jelvény és a kétszer mondott nevük eltűnt.';

  @override
  String get wn51Aether =>
      'Az aether otthona egyszer mondja a helyet: a sáv kétszer mondott névsora pihen, az állapotkártya és a bekapcsológomb megtartja ülését, és az oldal egy tiszta oszlopként olvasható.';

  @override
  String get wn51Veil =>
      'Az óra fátyla egy lélegzetet nőtt, és színét az óra egész sávján tartja: alatta átgördülő tartalom egésze halványul el, szavai többé nem érnek az órához.';

  @override
  String get wn52Speed =>
      'Az alagút újra a hálózat saját sebességén szalad: a VPN felülete a vonal csomagméretét (MTU 1500) beszéli a túlméretezett helyett — a letöltések visszakapják teljes sebességüket, és a hívások stabilak maradnak, főleg mobilneten.';

  @override
  String get wn52Smart =>
      'A leggyorsabb hely és az ajánlott szolgáltatás újra becsületesen választ: minden indítás frissen méri a helyeket, és a mostani legjobbot veszi — ahelyett, hogy csendben a korábban választottat vitte volna.';

  @override
  String get wn52Motion =>
      'Harminc új animáció az alkalmazás minden táján: minden oldal és kártya puhan landol, a megnyomott csempék süppednek és visszaállnak, a kapcsolódás pontja lélegzik, a nyitott oldalak lágyan úsznak be — és mind elhallgat, ha a rendszer kevesebb mozgást kér.';

  @override
  String get wn52Pages =>
      'A nyitott oldalak lágy csúszással érkeznek, a cím a saját széléről; beállítás mentésekor egy halk vonal fut végig a szakaszon.';

  @override
  String get wn56Button =>
      'A csúszka végig őrzi a szavát — többé nincs üres pillanat a „kapcsolódás” és a „kapcsolódva” között: a szó most átcsúszik állapotai között, és a munka halványulása egy lehellel érkezik.';

  @override
  String get wn56Capsule =>
      'A kerék hazája minden állapotot egyszer mond: eltűnt a csúszka fölött ismétlődő állapotszó — maga a pálya viszi, és az oldal egy sorral nyugodtabb.';

  @override
  String get wn56Door =>
      'A sebességtesztnek saját ajtaja van a főoldalon: egy sor, egy koppintás, és nyílik a mérés — az első kapcsolódás előtt is, nem csak amikor az alagút viszi.';

  @override
  String get wn56Wheel =>
      'A zászlókerék súrlódás nélkül csúszik: egy lendület egy országot hoz, és a landolás helyre ül, nem becsapódik — a húzás nehéz és egyenletes, mint egy jó gomb.';

  @override
  String get designGazette => 'Lap';
  @override
  String get designSky => 'Ég';
  @override
  String get designSkyDesc => 'Ég: lágy árnyékú fehér kártyák, medália-zászlók és világos ponttérkép — a felhők könnyedsége';
  @override
  String get designOcean => 'Óceán';
  @override
  String get designOceanDesc => 'Óceán: mélykék üveg, cián ragyogás és gyűrűs kijelző — a tenger mélysége';
  @override
  String get connectionPort => 'Kapcsolat portja';
  @override
  String get connectionPortHint => 'A port, amelyen az alagút a szervereket hívja; üresen 443 marad';
  @override
  String get connectionPortInvalid => 'Írj egy 1 és 65535 közötti portot';
  @override
  String get wn66Sky => 'Két új megjelenés: Ég és Óceán — minden oldal a saját kártyáival, navigációjával és térképével';
  @override
  String get wn66Port => 'Kapcsolat port beállítása: az alagút 443-on, vagy a szerver által elfogadott bármely porton köt be';

  @override
  String get designGazetteDesc =>
      'Címlap: a fejléc, a vonaltagolt hasábok és a tintabélyegző — az újság nyugalma, papíron és tintával';

  @override
  String get speedTestSizesTitle => 'Teszt mérete';

  @override
  String get wn61Gta =>
      'A GTA dizájn: a játék saját HUD-ja — fegykeret a zászlóknak, a radar zöld alagútja, borostyán panelek, nehéz betűk és saját hang';

  @override
  String get wn61Sound =>
      'A kerék kattanása: minden hely, amit a tárcsa elhagy, a fülnek is válaszol';

  @override
  String get wn62Wheel =>
      'A fegykerék újjáépítve: az ülések bármely országszámnál a játék saját távolságát tartják, a kiválasztott szektor a kerék megvilágított ékét viseli, a pöccintés pedig eldobja a tárcsát';

  @override
  String get wn62Map =>
      'A főoldal térképe most minden dizájn saját színeit viseli — a víz, a szárazföld és a rács a lap dizájnját követi';

  @override
  String get wn62HudMap =>
      'A GTA dizájn saját térképe: a játék HUD-lemeze — mély víz, neon part, borostyán radar rács és a söprés, amely a világot járja, míg az alagút tart';

  @override
  String get wn62Aether =>
      'Az Aether dizájn bekapcs-gombja újjáépítve: a lemez vékony gyűrűben áll, a kapcsolódás íve a gyűrűn jár, a megmunkolt lap pedig megfogja a fényt';

  @override
  String get wn62Gta =>
      'A GTA csatlakozó panelje kézre felel — nyomásra az egész panel kissé süllyed, és a kapcsolódás alatt a jel visszahúzódik';

  @override
  String get speedTestSizeLight => 'Könnyű';

  @override
  String get speedTestSizeStandard => 'Normál';

  @override
  String get speedTestSizeFull => 'Teljes';

  @override
  String get speedTestJitter => 'Jitter';

  @override
  String gazetteEdition(int n) {
    return '$n. szám';
  }

  @override
  String get gazetteBulletin => 'Biztonsági híradó';

  @override
  String get gazetteLiveWire => 'Riportsor';

  @override
  String get wn56Speed =>
      'A sebességteszt újra él: minden irány a saját kapcsolatán mér és sima HTTP/1.1-en beszél, így a feltöltés nem hal meg, amikor a letöltés ablaka zárul — a panel adja az út késleltetését, a jittert és választható méretet.';

  @override
  String get wn56Gazette =>
      'Új otthon-look: a lap — címlap fejléccel, vonaltagolt hasábokkal, élő hírsorral és a tintabélyegzővel, amely akkor csapódik rá, amikor az alagút áll.';

  @override
  String get designIos => 'iOS';

  @override
  String get designIosDesc =>
      'A rendszer sajátja: csoportosított táblák, a fülca sávja, az állapotkártya és a kapszula gomb — tisztaság a rendszer hangján';

  @override
  String get gazetteSection => 'ROVAT';

  @override
  String get wn58Lock =>
      'Az alagút állásakor a gomb zárja megtartja tintáját: a jel most olvassa a felületet, amin áll — sötét világos gombon, fehér sötéten — az ikon sosemfullad többé.';

  @override
  String get wn58Enter =>
      'A csatlakoztatott rész lélegzik: a számok elsápadva emelkednek, miközben alattuk nő a hely, és úgy távoznak is — a kártyák nem ugranak be két képkocka között.';

  @override
  String get wn58Speed =>
      'A sebességteszt könnyebben fut: a panel másodpercenként legfeljebb tízszer újrarajzolódik, a mérő mutatója rövid egyenesen jár, és a lapok átúszanak egymásba, nem ugranak.';

  @override
  String get wn58Ios =>
      'Új dizájn: iOS — a rendszer sajátja, a csoportosított tábláktól és a fülca vonalán át az állapotkártyáig a kapszula gombbal. Minden oldal, kártya, párbeszéd és ikon a rendszer hangján, mindkét módban.';

  @override
  String get wn58Pixel =>
      'Új dizájn: Pixel — a Material You stílusa, tonális felületek, nagy tömör kártyák, pillancele kijelzős sáv és nagy címek. Minden oldal, kártya, párbeszéd és ikon az Android saját hangján, mindkét módban.';

  @override
  String get wn58Paper =>
      'A lap most már egész újság: saját rovatsávja a nyomtatott jelel és aláhúzással, rovatfejléc minden külön oldalhoz, és vonaltagolt papírdoboz minden beállításcsoporthoz — a nyomdai vonalak elértek az egész alkalmazásig.';

  @override
  String get wn59Flags =>
      'A zászlók mindegyik dizájn saját vágását viselik: kerek medál az iOS-on és az aetheren, szkvircle a zeden, vonalazott lemez a gazette-on, a pixel nagy kerek sarkai — a kerék, a sor és minden sor kis zászlója követi őket.';

  @override
  String get wn59Map =>
      'A világtérkép a dizájn saját tusával készül: a papír meleg barnája a gazette-on, a lila éjszaka szürkéje a zeden, a tonális kékesszürke a pixelen — minden dizájn világa a saját oldaláé.';

  @override
  String get wn59Buttons =>
      'A csatlakozás gombjai a dizájnjuk hangján szólnak: a Material You nagy tonális pirulája a pixelen, az iOS kapszula lélegzete a kapcsolat épülésekor, és minden oldal kártyái a saját dizájnjuk mozgásával lépnek be.';

  @override
  String get wn59Scroll =>
      'A kerekek és sorok a dizájn saját fizikájával görgetnek: a rendszer pattanása, a Material gyors megállása, és a papír súlya, ami a hajtásnál elhal.';

  @override
  String get flagAllPlaces => 'Minden hely';

  @override
  String get gazetteRegions => 'Úti célok';

  @override
  String get wn60Flags =>
      'Minden dizájn most a saját módján mutatja az országokat: a bento csempetáblája, a pixel szűrőcsipjei, az aether kapszula lehetőségei, az iOS érempaklija, a zed lapozott táblája és a gazette úti céljainak jegyzéke, mint a saját nyomtatása — a kerék megtartja kerékjét.';

  @override
  String get wn60Bento =>
      'A bento dizájn teljesen áll: saját meleg palettája porcelánból és szénből, a mandarin fénye, a csempe dokk, a squircle oldalfejlécek, a színezett kártyák és a zászlótábla — minden oldal, mindkét módban.';

  @override
  String get wn60Spacing =>
      'A kezdőlapok egy ritmusban járnak: a szakaszok közti holt sávok eltűntek, a záró kártyák megtöltik soraikat, és minden rés a dizájn által tartott távolsággal lélegzik.';

  @override
  String get wn63Retired =>
      'Az aether és a zed dizájnok nyugdíjba mentek: használóik azokhoz a dizájnokhoz állnak, amelyek a szerkezetüket viselik — az aether táblái az iOS-hoz, a zed bentója a Bentóhoz';

  @override
  String get wn63Map =>
      'A GTA térkép a játék saját térképeként olvasható: minden határ útként, borostyán jel minden szerver-országban, a választott hely útpontként a fénnyel és a táblán lévő nevével, az iránytű a sarokban';

  @override
  String get wn63Servers =>
      'A szerverek oldala minden dizájn saját listáját viseli — az iOS csoportos táblája, a gazetta vonalazott jegyzéke, a GTA HUD slotjai, a pixel tónusú kártyái, a bento táblája';

  @override
  String get wn63Accounts =>
      'A fiókok oldala is a dizájnt viseli: a kártyák a dizájn saját kerekítésében, a hozzáadás gombja a dizájn hangján, a párbeszédek címe a kijelző saját arcán, a mezők a dizájn keretében';

  @override
  String get wn63Wheel =>
      'A fegykerelendítő a játék saját méretére épült: a szektorválasztók teljes köre, a kétrétegű megvilágított körcikk, a számláló mutatóíve, a nyitás ugrása és a választás saját pulzusa';

  @override
  String get wn63Ios =>
      'Az iOS dizájn teljesebben áll: az állapotkártya állapota-mosása, a medália-pakli oldalszám-pontjai, a minden kapcsolódás tikje';

  @override
  String get wn64Wheel =>
      'A GTA kerék érmei most a korong belsejében ülnek — tizen két ülés a játék saját ritmusában, érem sincs a peremen és a képernyő szélén túl, és egyik érem sem ér a másikhoz';

  @override
  String get wn64Glass =>
      'A kerék a játék üvegét öltötte: a világ a tárcsa alatt puhán elmosódik, a lap enyhén átlátszó, fénye felül gyűlik össze';

  @override
  String get wn64Groups =>
      'Az iOS nyitóképernyő saját csoportjai: a munkamenet táblája — az alagút címe, egy koppintás a vágólapra — és a gyors műveletek: sebességteszt, kapcsolat beállításai, fiókok';

  @override
  String get wn64Headers =>
      'Minden oldal fejléce újra az oldal szélességét fogja — a vissza nyíl a peremén áll, nem a képernyő közepén';

  @override
  String get wn64Pill =>
      'A Material You tabletta felirata a lekerekített végek levegőjében marad';

  @override
  String get wn64Map =>
      'A GTA térkép határai visszatértek első ruhájukhoz — a part megtartja neonját, a szárazföld a vékony tintacsíkját';

  @override
  String get wn64Name =>
      'A Pixel dizájn a saját nevén szólal meg: Material You';

  @override
  String get wn65Gone =>
      'A GTA dizájn eltávozott: saját otthona, oldalai, palettája — öt dizájn marad, és az azt még nevező beállításfájl a kerékre esik';

  @override
  String get wn65Tight =>
      'A honlap minden dizájnban szorosabbra áll: eltűntek a csupasz sávok, amelyeket a képernyő maradéka nyitott a kártyák között — a kerék, a csempék, a lap, az érmek és a chipek egy levegőnyi távolságra követik egymást, és az oldal görget, ahol korábban nyúlt';

  @override
  String get wn65Radar =>
      'A GTA dizájn térképe most saját nevén áll: radar — ugyanaz a mély víz, borostyán rács és söprés, ezúttal saját nevével a térképválasztóban';
}
