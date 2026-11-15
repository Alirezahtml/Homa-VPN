// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Desliza para conectar';

  @override
  String get slideToDisconnect => 'Desliza para desconectar';

  @override
  String get navOverview => 'Resumen';

  @override
  String get navAccounts => 'Cuentas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get stateConnected => 'Conectado';

  @override
  String get stateConnecting => 'Conectando…';

  @override
  String get stateWaiting => 'En espera';

  @override
  String get waitingForAccount =>
      'Agregue una Firefox Account en la página Cuentas para conectarse.';

  @override
  String get waitingForEnabledAccount =>
      'Todas las cuentas están desactivadas. Active una en la página Cuentas.';

  @override
  String get stateError => 'Error';

  @override
  String get stateUnknown => 'Desconocido';

  @override
  String get restartProxy => 'Reiniciar el proxy';

  @override
  String copied(String value) {
    return 'Copiado: $value';
  }

  @override
  String get activeAccount => 'Cuenta activa';

  @override
  String get noActiveAccount => 'Sin cuenta activa';

  @override
  String get quotaNotRead => 'Uso de datos aún sin consultar';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String usedOf(String used, String limit) {
    return '$used de $limit usados';
  }

  @override
  String resets(String date) {
    return 'se reinicia el $date';
  }

  @override
  String switchAt(int percent) {
    return 'Cambia de cuenta al $percent %';
  }

  @override
  String get publicIp => 'IP pública';

  @override
  String get testConnection => 'Probar conexión';

  @override
  String get testing => 'Probando…';

  @override
  String get testFailed => 'Falló';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'ahora mismo';

  @override
  String minutesAgo(int n) {
    return 'hace $n min';
  }

  @override
  String hoursAgo(int n) {
    return 'hace $n h';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'a las $time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d d $h h';
  }

  @override
  String durationHours(int h, int m) {
    return '$h h $m min';
  }

  @override
  String durationMinutes(int m, int s) {
    return '$m min $s s';
  }

  @override
  String durationSeconds(int s) {
    return '$s s';
  }

  @override
  String accountsGuide(String size) {
    return 'Cada Firefox Account tiene $size de datos al mes. Puede agregar varias: cuando una se agota, la aplicación pasa sola a la siguiente.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'En el orden de esta lista: cada una hasta el $percent %, la última hasta agotar sus datos.';
  }

  @override
  String get addAccount => 'Agregar cuenta';

  @override
  String lowQuotaNotice(String size) {
    return 'Los datos de esta cuenta se están agotando. Agregue otra cuenta para tener $size más.';
  }

  @override
  String get noAccounts => 'Aún no hay cuentas';

  @override
  String get noAccountsHint => 'Agregue una Firefox Account para conectarse.';

  @override
  String get delayTestFailed =>
      'No se pudo medir el retraso de los servidores. Revise su internet.';

  @override
  String get createAccountTitle => '¿No tiene una Firefox Account?';

  @override
  String get createAccountHint =>
      'Cree una gratis en accounts.firefox.com, vuelva aquí y pulse Agregar cuenta.';

  @override
  String get moveUp => 'Subir';

  @override
  String get moveDown => 'Bajar';

  @override
  String get statusActive => 'Activa';

  @override
  String get statusReady => 'Lista';

  @override
  String get statusNeedsSignIn => 'Requiere iniciar sesión';

  @override
  String get statusReserved => 'Reservada';

  @override
  String get statusUnavailable => 'No disponible';

  @override
  String statusUnavailableUntil(String date) {
    return 'No disponible hasta $date';
  }

  @override
  String get statusDisabled => 'Desactivada';

  @override
  String get statusEnabled => 'Activada';

  @override
  String get useNow => 'Usar ahora';

  @override
  String get signInAgain => 'Volver a iniciar sesión';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Esta cuenta usó el $percent % de sus datos, así que la siguiente tomó el relevo.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Los datos de este mes se agotaron; se vuelve a usar tras el reinicio mensual.';

  @override
  String get reasonSignInRequired =>
      'Inicie sesión de nuevo para usar esta cuenta.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla pide confirmar el inicio de sesión: pulse «Volver a iniciar sesión» (solo hace falta el código).';

  @override
  String reasonSignInFailed(String detail) {
    return 'El inicio de sesión automático falló ($detail). Inicie sesión de nuevo.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'El último inicio de sesión automático dejó de funcionar al poco tiempo; el próximo intento es a las $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'El inicio de sesión automático no terminó ($detail); se reintentará a las $time.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla rechazó esta cuenta; se reintentará más tarde.';

  @override
  String get more => 'Más';

  @override
  String get refreshQuota => 'Actualizar uso de datos';

  @override
  String get remove => 'Quitar';

  @override
  String get removeTitle => '¿Quitar la cuenta?';

  @override
  String removeBody(String name) {
    return '$name y su inicio de sesión guardado se quitarán de este equipo. Puede agregarla de nuevo más tarde.';
  }

  @override
  String get unlimitedQuota => 'Datos ilimitados';

  @override
  String get signInTitle => 'Iniciar sesión';

  @override
  String get signInIntro => 'Inicie sesión con una Firefox Account.';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailInvalid => 'Ingrese el correo de la cuenta';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordEmpty => 'Ingrese la contraseña';

  @override
  String get show => 'Mostrar';

  @override
  String get hide => 'Ocultar';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get done => 'Listo';

  @override
  String get close => 'Cerrar';

  @override
  String get noBrowserTitle => 'No hay navegador en este dispositivo';

  @override
  String get noBrowserText =>
      'Abra esta dirección en su teléfono o computadora:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get signingIn => 'Iniciando sesión…';

  @override
  String get accountReady => 'Cuenta lista';

  @override
  String get accountReadyHint => 'Se agregó al final de la lista de cuentas.';

  @override
  String get captchaLabel => 'Caracteres de la imagen';

  @override
  String get codeLabel => 'Código';

  @override
  String get captchaBroken => 'No se pudo mostrar la imagen CAPTCHA.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla envió un código a $email. Ingréselo aquí.';
  }

  @override
  String get stepTotp => 'Ingrese el código de su app de autenticación.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla considera inusual este inicio de sesión y envió un código de desbloqueo a $email. Ingréselo aquí.';
  }

  @override
  String get stepCaptcha => 'Escriba los caracteres de la imagen.';

  @override
  String stepEmailLink(String email) {
    return 'Abra el enlace de confirmación que Mozilla envió a $email. El proceso continuará automáticamente.';
  }

  @override
  String get signInFailed => 'No se añadió la cuenta.';

  @override
  String get signInCancelled => 'Inicio de sesión cancelado.';

  @override
  String get signInNoAccount =>
      'No existe ninguna Firefox Account con este correo.';

  @override
  String get signInNoAccountHint =>
      'Revise el correo, o cree con él una Firefox Account gratuita en el sitio de Mozilla, confírmela desde su bandeja de entrada y luego añádala aquí.';

  @override
  String get createAccountButton => 'Crear una Firefox Account';

  @override
  String get signInWrongPassword => 'Contraseña incorrecta.';

  @override
  String get signInNoPassword =>
      'Esta cuenta no tiene contraseña: se creó iniciando sesión con Google o Apple. Establezca una contraseña y luego inicie sesión aquí con ella.';

  @override
  String get setPasswordButton => 'Establecer contraseña';

  @override
  String get signInTooManyAttempts =>
      'Demasiados intentos. Espere un rato y vuelva a intentarlo.';

  @override
  String get signInUnblockRejected =>
      'No se aceptó el código de desbloqueo. Use el código del correo más reciente de Mozilla.';

  @override
  String get signInWrongCode =>
      'Código incorrecto o caducado. Use el código del correo más reciente de Mozilla; un código anterior deja de funcionar al enviarse uno nuevo.';

  @override
  String get signInWrongTotp =>
      'Código incorrecto. Ingrese el código que muestra ahora la app de autenticación.';

  @override
  String get signInTooManyCodes =>
      'Demasiados códigos incorrectos. Vuelva a iniciar sesión desde el principio.';

  @override
  String get signInTimedOut =>
      'El inicio de sesión tardó demasiado. Vuelva a empezar.';

  @override
  String get signInNetwork =>
      'No se pudo conectar con Mozilla. Revise su internet y vuelva a intentarlo.';

  @override
  String get coreConnecting => 'Conectando al núcleo…';

  @override
  String get coreLost => 'Se perdió la conexión con el núcleo. Reintentando…';

  @override
  String get cantReachCore => 'No se puede contactar al núcleo';

  @override
  String get startingCore => 'Iniciando el núcleo…';

  @override
  String get retry => 'Reintentar';

  @override
  String errNoCore(String path) {
    return 'No se encontró el programa del núcleo junto a la app ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'El núcleo se detuvo: $detail';
  }

  @override
  String get errNotAnswering => 'El núcleo no responde.';

  @override
  String get errRefused =>
      'El núcleo rechazó la app; puede que pertenezca a otra copia.';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionGeneral => 'General';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get closeBehavior => 'Al cerrar la ventana';

  @override
  String get closeAsk => 'Preguntar siempre';

  @override
  String get closeTray => 'Minimizar a la bandeja';

  @override
  String get closeQuit => 'Salir de la app';

  @override
  String get sectionConnection => 'Conexión';

  @override
  String get localProxy => 'Proxy local';

  @override
  String get systemProxy => 'Proxy del sistema';

  @override
  String get sectionRouting => 'Enrutamiento';

  @override
  String get routingDirect => 'Conexión directa para sitios locales';

  @override
  String get routingDirectHint =>
      'Los sitios e IP del país elegido no pasan por la VPN: abren más rápido y ahorran datos.';

  @override
  String get region => 'País';

  @override
  String get regionIr => 'Irán';

  @override
  String get regionCn => 'China';

  @override
  String get regionRu => 'Rusia';

  @override
  String get regionAf => 'Afganistán';

  @override
  String get regionTr => 'Turquía';

  @override
  String get regionId => 'Indonesia';

  @override
  String get regionBr => 'Brasil';

  @override
  String get regionNone => 'Ninguno';

  @override
  String get saved => 'Guardado';

  @override
  String get dataFolder => 'Carpeta de datos';

  @override
  String get openFolder => 'Abrir carpeta';

  @override
  String get unofficialNote =>
      'Cliente no oficial. Sin afiliación con Mozilla.';

  @override
  String get closeTitle => '¿Cerrar la ventana?';

  @override
  String get closeBody =>
      'Si la minimiza a la bandeja, la VPN sigue conectada. Si sale, se desconecta.';

  @override
  String get rememberChoice => 'Recordar mi elección';

  @override
  String get minimizeToTray => 'Minimizar a la bandeja';

  @override
  String get quit => 'Salir';

  @override
  String get trayOpen => 'Abrir';

  @override
  String get trayQuit => 'Salir';

  @override
  String get trayProxyOnly => 'Solo servicio proxy';

  @override
  String get traySetSystemProxy => 'Configurar proxy del sistema';

  @override
  String errPortInUse(String port) {
    return 'Otro programa usa el puerto $port, por lo que la app no puede contactar a su núcleo.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'Otro programa usa el puerto $port, por lo que el proxy no puede iniciarse.';
  }

  @override
  String get changePort => 'Cambiar puerto';

  @override
  String get portDialogTitle => 'Elija un puerto';

  @override
  String portDialogBody(String port) {
    return 'El puerto $port está ocupado. Abajo se sugiere un puerto libre; puede escribir otro.';
  }

  @override
  String get portChangeBody =>
      'Las aplicaciones se conectan a este puerto. Elija uno entre 1024 y 65535.';

  @override
  String get portLabel => 'Puerto';

  @override
  String get portInvalid => 'Ingrese un puerto entre 1024 y 65535';

  @override
  String get portBusy => 'Este puerto también está en uso';

  @override
  String get portInUse => 'Otro programa usa este puerto';

  @override
  String get save => 'Guardar';

  @override
  String get proxyPort => 'Puerto del proxy';

  @override
  String get appPort => 'Puerto de la app';

  @override
  String get welcomeTitle => 'Bienvenido';

  @override
  String get welcomeBody =>
      'Elija su idioma y su país. Los sitios de su país se abren directamente, sin la VPN: cargan más rápido y ahorran datos.';

  @override
  String get start => 'Comenzar';

  @override
  String routingSuggestTitle(String country) {
    return '¿Conexión directa para $country?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Los sitios e IP de $country se abrirían directamente, sin la VPN. Puede cambiarlo en Enrutamiento.';
  }

  @override
  String get yes => 'Sí';

  @override
  String get notNow => 'Ahora no';

  @override
  String get navServers => 'Servidores';

  @override
  String get navLogs => 'Registros';

  @override
  String get realDelay => 'Latencia real';

  @override
  String get statElapsed => 'Tiempo';

  @override
  String get statDown => 'Bajada';

  @override
  String get statUp => 'Subida';

  @override
  String noticePort(String port) {
    return 'El proxy de Mozilla no se conecta al puerto $port. Solo los puertos 80, 443, 8080 y 8443 pasan por la VPN.';
  }

  @override
  String get noticeCommand =>
      'Este tipo de conexión no es compatible con la VPN.';

  @override
  String noticeTimes(int count, String time) {
    return '$count veces, la última $time';
  }

  @override
  String get dismiss => 'Descartar';

  @override
  String get modeRecommended => 'Recomendada';

  @override
  String get modeFastest => 'La más rápida';

  @override
  String get modeRecommendedHint => 'Mozilla elige la ubicación por usted.';

  @override
  String get modeFastestHint =>
      'La ubicación con menor latencia en cada conexión.';

  @override
  String get testDelay => 'Medir latencia real';

  @override
  String get testingDelay => 'Midiendo…';

  @override
  String get search => 'Buscar';

  @override
  String get noAnswer => 'Sin respuesta';

  @override
  String testedAgo(String ago) {
    return 'Probado $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered de $total respondieron';
  }

  @override
  String get noServers =>
      'Aún no hay servidores. Aparecerán cuando el núcleo contacte a Mozilla.';

  @override
  String get levelAll => 'Todos';

  @override
  String get filter => 'Filtrar';

  @override
  String get follow => 'Desplazamiento automático';

  @override
  String get clear => 'Borrar';

  @override
  String get copyAll => 'Copiar';

  @override
  String get logsCopied => 'Registros copiados';

  @override
  String get noLogs => 'Aún no hay líneas de registro.';

  @override
  String get sectionAccounts => 'Cambio automático de cuenta';

  @override
  String get switchThreshold => 'Cambiar de cuenta al';

  @override
  String get switchThresholdHint =>
      'La siguiente cuenta toma el relevo cuando se consume este porcentaje de los datos.';

  @override
  String get signInMethod => 'Método de inicio de sesión';

  @override
  String get signInMethodBrowser => 'Iniciar sesión con el navegador';

  @override
  String get signInMethodApi => 'Iniciar sesión directamente';

  @override
  String get browserSignInBroken =>
      'No se pudo abrir la página de inicio de sesión.';

  @override
  String get browserSignInBlocked =>
      'Mozilla no completó el último paso para añadir la cuenta (HTTP 406).';

  @override
  String get browserSignInFallback => 'Iniciar sesión con correo y contraseña';

  @override
  String get backupExport => 'Guardar copia de seguridad';

  @override
  String get backupImport => 'Importar copia de seguridad';

  @override
  String backupSaved(String name) {
    return 'Guardado: $name';
  }

  @override
  String get backupImportTitle => '¿Agregar estas cuentas?';

  @override
  String get backupAccountExists =>
      'Ya agregada; tomará el inicio de sesión del archivo';

  @override
  String get backupImportAction => 'Agregar';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cuentas agregadas',
      one: '1 cuenta agregada',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'Servidores DNS';

  @override
  String get dnsSystem => 'Sistema';

  @override
  String get dnsAuto => 'Automático (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Personalizado';

  @override
  String get dnsCustomHint =>
      'Uno por línea: https://…/dns-query, tls://… o una dirección IP.';

  @override
  String get dnsFallback => 'Usar el DNS del sistema como respaldo';

  @override
  String get testDns => 'Probar DNS';

  @override
  String get transport => 'Protocolo';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'Versión de IP';

  @override
  String get ipVersionAuto => 'Automático (IPv4 primero, luego IPv6)';

  @override
  String get ipVersionDual => 'Ambos a la vez (dual-stack)';

  @override
  String get ipVersionV6First => 'IPv6 primero, luego IPv4';

  @override
  String get ipVersionV4 => 'Solo IPv4';

  @override
  String get ipVersionV6 => 'Solo IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'Tamaño de paquete de la interfaz VPN, de 1280 a 9000. Vacío: automático.';

  @override
  String get tunMtuInvalid => 'Un número de 1280 a 9000, o vacío';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Directo';

  @override
  String get directRulesHint =>
      'Los sitios y direcciones de esta lista se abren sin la VPN, directamente con tu propia conexión. Las reglas del país elegido ya están aquí: añade, cambia o quita líneas. Elegir otro país las reemplaza por las suyas.';

  @override
  String get restoreRegionRules => 'Restaurar las reglas del país';

  @override
  String get blockRules => 'Bloquear';

  @override
  String get blockRulesHint =>
      'Los sitios y direcciones de esta lista no se abren en absoluto, ni directamente ni a través de la VPN: para anuncios o sitios que nunca quieres abrir.';

  @override
  String get rulesTitle => 'Reglas';

  @override
  String get ruleSyntaxTitle => 'Cómo escribir una regla';

  @override
  String get resolveDomains => 'Aplicar reglas de IP a dominios';

  @override
  String get routingLists => 'Archivos geo';

  @override
  String get listSource => 'Origen de las listas';

  @override
  String get listSourceCustom => 'Manual';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Actualizado $ago';
  }

  @override
  String get updateLists => 'Actualizar los archivos geo';

  @override
  String get listsUpdated => 'Los archivos geo se actualizaron.';

  @override
  String get testDestination => 'Comprobar la ruta de un sitio';

  @override
  String get destinationHint => 'Un nombre, una dirección o una URL';

  @override
  String get check => 'Comprobar';

  @override
  String get routeDirect => 'Conexión directa';

  @override
  String get routeProxy => 'Pasa por la VPN';

  @override
  String get routeBlock => 'Bloqueado';

  @override
  String ruleMatched(String rule) {
    return 'Regla: $rule';
  }

  @override
  String get portRefusedNote =>
      'El proxy de Mozilla no se conecta a este puerto.';

  @override
  String get sectionAdvanced => 'Avanzado';

  @override
  String get tlsFragment => 'Fragmentación TLS';

  @override
  String get tlsFragmentOff => 'Desactivado';

  @override
  String get tlsFragmentFirstByte => 'Primer byte';

  @override
  String get tlsFragmentSni => 'Nombre del servidor (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Divide el encabezado TLS en el primer byte (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Divide el nombre del servidor (SNI) en varios paquetes TCP';

  @override
  String get tlsFragmentRecord => 'Registro TLS';

  @override
  String get tlsFragmentRecordHint =>
      'Divide el nombre del servidor (SNI) en dos registros TLS';

  @override
  String get tlsFragmentOffHint => 'Conexión TLS normal';

  @override
  String get sectionBypass => 'Si Mozilla está bloqueado';

  @override
  String get sharedRelay => 'Relé compartido';

  @override
  String get sharedRelayHint =>
      'Usar los relés compartidos de la aplicación si Mozilla bloquea tu región. Un relé personal activado tiene prioridad.';

  @override
  String get personalRelay => 'Relé personal';

  @override
  String get apiRelay => 'Servidor de retransmisión';

  @override
  String get apiRelayUse => 'Usar el servidor de retransmisión';

  @override
  String get apiRelayHint =>
      'Su propio Cloudflare Worker, o relay.php en su propio alojamiento.\nSolo se usa cuando Mozilla no responde directamente: el inicio de sesión, las cuentas y la lista de servidores pasan por él, no el tráfico de la VPN.';

  @override
  String get upstreamProxy => 'Proxy ascendente';

  @override
  String get upstreamProxyOn => 'Proxy ascendente activado';

  @override
  String get upstreamProxyAddress => 'Dirección SOCKS5';

  @override
  String get upstreamProxyPort => 'Puerto';

  @override
  String get upstreamProxyHint =>
      'La conexión con Mozilla pasa por este proxy, para redes que bloquean o ralentizan Mozilla.\nSi el proxy se ejecuta en este dispositivo, déjelo fuera de la VPN.';

  @override
  String get upstreamProxyInvalid =>
      'Introduzca la dirección del proxy, como 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Introduzca un puerto del 1 al 65535.';

  @override
  String get upstreamProxyOwn =>
      'Ese es el proxy de esta misma aplicación. Introduzca otro.';

  @override
  String get apiRelayInvalid => 'Debe ser una dirección https://.';

  @override
  String get listenAddress => 'Acceso al proxy';

  @override
  String get listenLocal => '127.0.0.1 · solo este dispositivo';

  @override
  String get listenAll => '0.0.0.0 · todas las redes (LAN)';

  @override
  String get proxyUsername => 'Usuario del proxy';

  @override
  String get proxyPassword => 'Contraseña del proxy';

  @override
  String get proxyLoginHint =>
      'Las apps deberán usar este usuario y contraseña. Deje ambos vacíos para no pedirlos.';

  @override
  String get loginBothOrNone => 'Complete ambos o deje ambos vacíos.';

  @override
  String get proxyLogin => 'Usuario y contraseña del proxy';

  @override
  String get idleSleep => 'Suspender tras inactividad';

  @override
  String get sleepNever => 'Nunca';

  @override
  String sleepMinutes(int count) {
    return '$count minutos';
  }

  @override
  String get sleepHour => '1 hora';

  @override
  String get showPublicIp => 'Mostrar la IP pública';

  @override
  String get hapticFeedback => 'Vibrar cuando cambia la conexión';

  @override
  String get keepScreenOn =>
      'Mantener la pantalla encendida mientras estás conectado';

  @override
  String get showTraffic => 'Mostrar el tráfico en vivo en la página principal';

  @override
  String get speedInNotification => 'Mostrar la velocidad en la notificación';

  @override
  String get liveTraffic => 'Tráfico en vivo';

  @override
  String get totalTraffic => 'Tráfico total';

  @override
  String get verboseLogs => 'Registros detallados';

  @override
  String get webDashboard => 'Panel web';

  @override
  String get webDashboardOpen => 'Abrir';

  @override
  String get webDashboardHint => 'Ajustes avanzados y más herramientas';

  @override
  String numberInvalid(int min, int max) {
    return 'Ingrese un número entre $min y $max';
  }

  @override
  String get notifySwitchedTitle => 'Se cambió de cuenta';

  @override
  String notifySwitchedBody(String name) {
    return 'Ahora se usa $name.';
  }

  @override
  String get notifySignInTitle => 'Se requiere iniciar sesión';

  @override
  String get notifySignInBody =>
      'Una cuenta necesita volver a iniciar sesión. Vaya a la página Cuentas.';

  @override
  String get navAbout => 'Acerca de';

  @override
  String get appVersionLabel => 'Versión de la app';

  @override
  String get coreVersionLabel => 'Versión del núcleo';

  @override
  String get checkUpdates => 'Buscar actualizaciones';

  @override
  String get checkingUpdates => 'Buscando…';

  @override
  String get upToDate => 'Tiene la última versión.';

  @override
  String updateAvailable(String version) {
    return 'La versión $version está disponible.';
  }

  @override
  String updateRequired(String version) {
    return 'Actualiza a la versión $version. Esta actualización es necesaria.';
  }

  @override
  String get download => 'Descargar';

  @override
  String updateCheckFailed(String error) {
    return 'No se pudieron buscar actualizaciones: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'No se pudo conectar con GitHub. Comprueba tu conexión a internet e inténtalo de nuevo.';

  @override
  String get updateNow => 'Actualizar';

  @override
  String updateDownloading(String version) {
    return 'Descargando la versión $version…';
  }

  @override
  String updateReady(String version) {
    return 'La versión $version está lista para instalarse.';
  }

  @override
  String updateInstalling(String version) {
    return 'Instalando la versión $version. La app se cerrará y se volverá a abrir.';
  }

  @override
  String updateFailed(String version) {
    return 'No se pudo actualizar a la versión $version.';
  }

  @override
  String updateDone(String version) {
    return 'Actualizada a la versión $version.';
  }

  @override
  String updateRolledBack(String version) {
    return 'La actualización a la versión $version no terminó, así que la app volvió a la versión anterior.';
  }

  @override
  String get repoNotSet => 'El repositorio de GitHub aún no está configurado.';

  @override
  String get sourceCode => 'Código fuente';

  @override
  String get tapToConnect => 'Haga clic para conectar';

  @override
  String get tapToDisconnect => 'Haga clic para desconectar';

  @override
  String get startOnBoot => 'Iniciar al arrancar';

  @override
  String get connectOnStartup => 'Conectar al arrancar';

  @override
  String get proxyServiceActive => 'Servicio de proxy activo';

  @override
  String get navHome => 'Inicio';

  @override
  String get groupApp => 'App';

  @override
  String get groupNetwork => 'Red';

  @override
  String get stateOff => 'Desconectado';

  @override
  String get tapToConnectPhone => 'Toque para conectar';

  @override
  String get tapToDisconnectPhone => 'Toque para desconectar';

  @override
  String get tapToConnectTv => 'Pulse OK para conectar';

  @override
  String get tapToDisconnectTv => 'Pulse OK para desconectar';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Ubicación recomendada';

  @override
  String dataLeftOf(String limit) {
    return 'de $limit';
  }

  @override
  String get homeLocation => 'Ubicación';

  @override
  String get connectedTo => 'Conectado a';

  @override
  String get vpnNotAllowed =>
      'La VPN necesita su permiso. Toque el botón de nuevo y permítalo.';

  @override
  String get dataUsedTitle => 'Datos usados';

  @override
  String get bypassApps => 'Proxy por app';

  @override
  String get connectRetrying => 'No se pudo conectar. Revise su internet.';

  @override
  String get failUnreachable =>
      'No se pudo llegar a los servidores de Mozilla. Pruebe con otra conexión a internet.';

  @override
  String get failUpstreamProxy =>
      'No se pudo llegar a Mozilla a través del proxy ascendente. Compruebe que esté en funcionamiento.';

  @override
  String get failInsideVpn => 'Este internet ya pasa por una VPN. Desactívela.';

  @override
  String get failRefused =>
      'El servidor de Mozilla rechazó la conexión. Vuelva a intentarlo en unos minutos.';

  @override
  String get failLocationRefused =>
      'Este país no está disponible para su cuenta. Elija otro país.';

  @override
  String get useRecommendedLocation => 'Usar la ubicación recomendada';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Eligió $chosen, pero su IP está en $exit.';
  }

  @override
  String get failSignIn =>
      'La sesión de esta cuenta caducó. Vuelva a iniciar sesión en la página Cuentas.';

  @override
  String get failQuota =>
      'Los datos de este mes se agotaron. Añada otra cuenta.';

  @override
  String get failNotEntitled =>
      'Mozilla no permite que esta cuenta use la VPN. Añada otra cuenta.';

  @override
  String get failRegion => 'Mozilla no ofrece su servicio en su país.';

  @override
  String get failServer =>
      'El servicio de Mozilla tiene un problema temporal. La aplicación lo reintentará sola.';

  @override
  String get failNoAccount =>
      'Ninguna cuenta está lista. Abra la página Cuentas.';

  @override
  String get failTestSite =>
      'Conectado al servidor, pero los sitios no abren. Pruebe otro país.';

  @override
  String get failOther => 'No se pudo conectar. Inténtelo de nuevo.';

  @override
  String get failNoInternet =>
      'Sin internet. Revise el Wi-Fi o los datos móviles.';

  @override
  String get waitingForNetwork => 'Esperando una conexión a internet…';

  @override
  String proxyStartFailed(String port) {
    return 'El proxy no pudo iniciarse en el puerto $port. Elige otro puerto.';
  }

  @override
  String get connectionSettings => 'Ajustes de conexión';

  @override
  String get appModeExclude => 'Excluir apps seleccionadas';

  @override
  String get appModeInclude => 'Solo apps seleccionadas';

  @override
  String get appModeExcludeHint =>
      'Las apps seleccionadas se conectan directamente, sin la VPN: por ejemplo, apps bancarias que rechazan direcciones extranjeras.';

  @override
  String get appModeIncludeHint =>
      'Solo las apps seleccionadas pasan por la VPN; las demás se conectan directamente.';

  @override
  String fromRegionList(String region) {
    return 'Sugerida: en la lista de $region';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Modo de conexión';

  @override
  String get modeProxyHint =>
      'Solo las apps configuradas para usar el proxy pasan por él.';

  @override
  String get modeSystemProxyHint =>
      'Windows y la mayoría de las apps pasan por el proxy.';

  @override
  String get modeSystemProxyHintOther =>
      'Los navegadores y la mayoría de las apps pasan por el proxy.';

  @override
  String get suggestedApps => 'Apps sugeridas';

  @override
  String get showSystemApps => 'Mostrar apps del sistema';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps sugeridas seleccionadas',
      one: '1 app sugerida seleccionada',
      zero: 'Las apps sugeridas ya están seleccionadas',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Automático';

  @override
  String get locationsSection => 'Ubicaciones';

  @override
  String get dnsSummaryOk => 'El DNS cifrado funciona';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nombres no se resolvieron',
      one: '1 nombre no se resolvió',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'a través de $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'El DNS de su red respondió a $count nombres con una dirección de filtrado. Esta app no lo usa para esos nombres.',
      one: 'El DNS de su red respondió a 1 nombre con una dirección de filtrado. Esta app no lo usa para ese nombre.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Respuesta:';

  @override
  String get dnsNetworkAnswer => 'DNS de la red:';

  @override
  String get dnsFiltered => 'filtrado';

  @override
  String get rulesSyntaxTitle => 'Una regla por línea';

  @override
  String get ruleDomain => 'El sitio y sus subdominios';

  @override
  String get ruleFull => 'Exactamente este nombre';

  @override
  String get ruleKeyword => 'Nombres que contienen la palabra';

  @override
  String get ruleGeosite => 'Sitios de una etiqueta en los archivos geo';

  @override
  String get ruleGeoip => 'Direcciones de un país en los archivos geo';

  @override
  String get ruleIp => 'Una dirección o una red';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Solo proxy';

  @override
  String get noNetwork =>
      'Sin conexión a internet. Active el Wi-Fi o los datos móviles.';

  @override
  String get blockAds => 'Bloquear anuncios';

  @override
  String systemProxyTakenBy(String address) {
    return 'Otro programa cambió el proxy del sistema a $address, así que el tráfico no pasa por la VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Otro programa desactivó el proxy del sistema, así que el tráfico no pasa por la VPN.';

  @override
  String get setSystemProxyAgain => 'Volver a configurarlo';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Todo el tráfico de $os pasa por la VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'Esperando permiso para instalar el servicio TUN…';

  @override
  String get tunInstallCancelled =>
      'El modo TUN necesita permiso de administrador una vez. No se concedió, así que el modo no cambió.';

  @override
  String tunInstallFailed(String error) {
    return 'No se pudo instalar el servicio TUN: $error';
  }

  @override
  String get tunStarting => 'Iniciando el modo TUN…';

  @override
  String get tunFailed => 'El modo TUN no pudo iniciarse. Reintentando…';

  @override
  String get tunLost =>
      'El modo TUN se detuvo de forma inesperada. Reintentando…';

  @override
  String get tunNotRunning =>
      'El servicio TUN no se está ejecutando. Reintentando…';

  @override
  String get tunMissing => 'El servicio TUN no está instalado.';

  @override
  String get tunOutdated =>
      'El servicio TUN es más antiguo que esta app. Vuelva a instalarlo para usar el modo TUN.';

  @override
  String get tunAppOutdated =>
      'El servicio TUN es más reciente que esta app. Actualice la app para usar el modo TUN.';

  @override
  String get tunBusy => 'Otra copia de Homa VPN está usando el modo TUN.';

  @override
  String get tunNoDriver =>
      'El controlador TUN del sistema no está disponible. Reinicia el ordenador e inténtalo de nuevo.';

  @override
  String get tunInstall => 'Instalar';

  @override
  String get tunInstallAgain => 'Volver a instalar';

  @override
  String get trayTunMode => 'Modo TUN (todas las apps)';

  @override
  String get removeTunService => 'Quitar el servicio TUN';

  @override
  String get removeTunServiceHint =>
      'Quita el servicio del sistema que usa el modo TUN. Al elegir TUN otra vez, se vuelve a instalar.';

  @override
  String get tunServiceRemoved => 'Se quitó el servicio TUN.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN quiere instalar el servicio para el modo TUN.';

  @override
  String get tunRemovePrompt =>
      'Homa VPN quiere quitar el servicio del modo TUN.';

  @override
  String tunRemoveFailed(String error) {
    return 'No se pudo quitar el servicio TUN: $error';
  }

  @override
  String get sectionTun => 'Ajustes de TUN';

  @override
  String get tunPrograms => 'Programas que no usan la VPN';

  @override
  String get tunProgramsHint =>
      'Se conectan directamente, no a través de Mozilla. Solo para programas que funcionan sin VPN.';

  @override
  String get tunProgramsEmpty => 'Aún no hay programas.';

  @override
  String get addProgram => 'Añadir programa';

  @override
  String get programFiles => 'Programas';

  @override
  String get tunProgramAll => 'Todo el tráfico';

  @override
  String get tunProgramAllHint => 'Todo el programa se conecta directamente.';

  @override
  String get tunProgramUdp => 'Solo UDP';

  @override
  String get tunProgramUdpHint =>
      'Solo su UDP se conecta directamente; el resto pasa por la VPN.';

  @override
  String get udpNoticeSetting => 'Aviso de UDP bloqueado';

  @override
  String udpNoticeBody(String program) {
    return 'El tráfico UDP de $program no pasa por la VPN.';
  }

  @override
  String get dontShowAgain => 'No volver a mostrar';

  @override
  String get addRunningProgram => 'De los programas en ejecución';

  @override
  String get addProgramFile => 'Elegir un archivo…';

  @override
  String get addProgramName => 'Escribir un nombre…';

  @override
  String get programNameHint =>
      'El nombre de archivo de un programa, como steam.exe; * significa cualquier texto (steam* son todos los programas de Steam).';

  @override
  String get runningProgramsEmpty => 'No hay otros programas en ejecución.';

  @override
  String get tabLog => 'Registro';

  @override
  String get tabConnections => 'Conexiones';

  @override
  String get connectionsEmpty => 'Aún no hay conexiones.';

  @override
  String connectionsOpen(int count) {
    return '$count abiertas';
  }

  @override
  String get connTime => 'Hora';

  @override
  String get connRoute => 'Regla';

  @override
  String get connDestination => 'Destino';

  @override
  String get connInbound => 'Entrada';

  @override
  String get connProtocol => 'Protocolo';

  @override
  String get connColumns => 'Columnas';

  @override
  String get connTraffic => 'Tráfico';

  @override
  String get connDuration => 'Duración';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Directo';

  @override
  String get connRouteBlocked => 'Bloqueado';

  @override
  String get connRoutePort => 'Puerto rechazado';

  @override
  String get connRouteFailed => 'Fallido';

  @override
  String get testRelay => 'Comprobar el relé';

  @override
  String get relayTestTitle => 'Prueba del relé';

  @override
  String get relayTestHint =>
      'Solo comprueba el relé. No envía solicitudes a Mozilla ni datos de la cuenta.';

  @override
  String get relayTestPassed => 'El relé está listo';

  @override
  String get relayTestFailed => 'No se pudo confirmar el estado del relé';

  @override
  String get relayTestCopy => 'Copiar informe';

  @override
  String get relayTestInterrupted =>
      'La prueba terminó antes de recibir un resultado completo.';

  @override
  String get searchLocations => 'Buscar ubicaciones';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ubicaciones',
      many: '$count ubicaciones',
      one: '1 ubicación',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Actualizaciones automáticas';

  @override
  String get autoInstallApkHint =>
      'Las versiones nuevas se descargan solas; el instalador pregunta antes de instalar.';

  @override
  String get installNow => 'Instalar';

  @override
  String get updateAllowInstall =>
      'Para instalar la actualización, permite que esta aplicación instale aplicaciones.';

  @override
  String get allowInstall => 'Permitir';

  @override
  String get noResults => 'Ninguna ubicación coincide con la búsqueda.';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get accentMono => 'Monocromo (predeterminado)';

  @override
  String get accentCustom => 'Color personalizado';

  @override
  String get accentEmber => 'Ascua';

  @override
  String get accentGold => 'Dorado';

  @override
  String get accentEmerald => 'Esmeralda';

  @override
  String get accentSapphire => 'Zafiro';

  @override
  String get accentAmethyst => 'Amatista';

  @override
  String get accentRose => 'Rosa';

  @override
  String get autoReconnect => 'Reconexión automática';

  @override
  String get autoReconnectHint =>
      'Vuelve a conectar por sí mismo si la conexión se corta sin pedirlo.';

  @override
  String get androidOnlyHint => 'Solo en el teléfono.';

  @override
  String get idleDisconnect => 'Desconectar si está inactiva';

  @override
  String get idleDisconnectHint =>
      'Termina la sesión cuando no pasa tráfico por un rato.';

  @override
  String get idleTimeout => 'Espera de inactividad';

  @override
  String get minutes5 => '5 minutos';

  @override
  String get minutes10 => '10 minutos';

  @override
  String get minutes15 => '15 minutos';

  @override
  String get minutes30 => '30 minutos';

  @override
  String get minutes60 => '1 hora';

  @override
  String get dataLimit => 'Límite de datos de la sesión';

  @override
  String get dataLimitHint =>
      'Termina la sesión cuando su tráfico llega al límite.';

  @override
  String get dataLimitAmount => 'Límite';

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
    return 'No pasó tráfico durante $minutes minutos, así que se desconectó.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'La sesión alcanzó su límite de $mb MB, así que se desconectó.';
  }

  @override
  String get protection => 'Protección';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Si la VPN se cae, el tráfico se retiene — sin fugas — hasta reconectar.';

  @override
  String get alwaysOnVpn => 'VPN siempre activa';

  @override
  String get alwaysOnVpnHint =>
      'Protección propia de Android: ninguna conexión sin la VPN.';

  @override
  String get floatingIsland => 'Isla flotante';

  @override
  String get floatingIslandHint =>
      'Muestra la conexión sobre las demás apps mientras estás fuera de la app.';

  @override
  String whatsNewTitle(String version) {
    return 'Novedades de la versión $version';
  }

  @override
  String get whatsNewContinue => 'Entendido';

  @override
  String get whatsNewMenu => 'Novedades';

  @override
  String get whatsNewView => 'Ver de nuevo';

  @override
  String get updateServers => 'Actualizar servidores';

  @override
  String get updatingServers => 'Actualizando…';

  @override
  String serversUpdated(int count) {
    return '$count ubicaciones de la lista oficial de Mozilla';
  }

  @override
  String get serversUpdateFailed =>
      'No se pudo actualizar la lista; se conservó la anterior.';

  @override
  String get smartPickTitle => 'El más rápido ahora';

  @override
  String get smartPickUse => 'Usar';

  @override
  String get connectAtBoot => 'Conectar al encender el teléfono';

  @override
  String get connectAtBootHint =>
      'Connects by itself at boot, when the VPN permission is already granted.';

  @override
  String get gamingProfile => 'Perfil de juegos';

  @override
  String get gamingProfileHint =>
      'Shows the connection\'s live delay and quality; pairs with the fastest measured server.';

  @override
  String get diagnosticsRun => 'Ejecutar diagnóstico';

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
  String get diagnosticsConnection => 'Prueba de conexión';

  @override
  String get diagnosticsPassed => 'Correcta';

  @override
  String get diagnosticsFailed => 'Fallida';

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
  String get whatsNewAdded => 'Nuevo';

  @override
  String get whatsNewImproved => 'Mejorado';

  @override
  String get whatsNewFixed => 'Corregido';

  @override
  String get wnWheelImproved =>
      'La rueda de países se redibujó: la bandera elegida se ve más grande en un marco de cristal con un brillo fino y un halo suave de luz detrás, las otras banderas quedan más pequeñas con profundidad, y el nombre de abajo llega con un deslizamiento.';

  @override
  String get wnLiveImproved =>
      'Mientras está conectado, la notificación pide a Android 16 promocionarla como Live Update, como hace la implementación de referencia; la duración sigue contando y las velocidades siguen vivas.';

  @override
  String get wnL10nFixed =>
      'Esta página ahora habla el idioma de la app: sus quince idiomas, no solo inglés.';

  @override
  String get wnMarkFixed =>
      'La marca de Mozilla se ve limpia en su mosaico, con esquinas redondeadas como las banderas.';

  @override
  String get designTitle => 'Diseño de inicio';

  @override
  String get designHint => 'Cómo se organiza la página principal';

  @override
  String get designWheel => 'Rueda';

  @override
  String get designWheelDesc =>
      'Las banderas en su rueda de cristal, el interruptor debajo';

  @override
  String get designBento => 'Mosaico';

  @override
  String get designBentoDesc =>
      'Tablero de fichas redondeadas: conexión, cifras, lugar';

  @override
  String get designPixel => 'Compacta';

  @override
  String get designPixelDesc =>
      'Una tarjeta serena: el lugar, el interruptor, las cifras';

  @override
  String get notifFlag => 'Bandera del país en la notificación';

  @override
  String get notifFlagHint => 'La bandera del propio país junto a su nombre';

  @override
  String get wnDesignAdded =>
      'Un ajuste de diseño de inicio: rueda, mosaico o tarjeta compacta';

  @override
  String get wnMapAdded =>
      'Un mapa mundial vectorial real tras la página principal, con el país elegido iluminado';

  @override
  String get wnWheelAdded =>
      'La rueda de banderas redibujada: cristal más hondo, movimiento más suave';

  @override
  String get wnFlagNotifAdded =>
      'La notificación puede mostrar la bandera SVG del país, y puede apagarse';

  @override
  String get wnColorRemoved =>
      'Se quitó la página de color personalizado; la lista de acento conserva su HEX';

  @override
  String get whatsNewRemoved => 'Eliminado';

  @override
  String get wnCrashFixed =>
      'La app ya no se detiene sola en los teléfonos con Android 16: la notificación pedía al sistema algo que el teléfono aún no tenía.';

  @override
  String get wnFlagArtFixed =>
      'La aplicación ya no se cierra sola al abrirse: el arte de la bandera de la notificación devolvía un valor que el mensajero del sistema rechaza.';

  @override
  String get statSession => 'Sesión';
  String get copiedToClipboard => 'Copiado al portapapeles';
  String get wnTotalsAdded => 'La página principal muestra el total que movió la sesión, y un toque copia la IP pública.';
  String get wnPolishImproved => 'La rueda de banderas y la página de servidores se ven más ordenadas; los textos son compactos y el túnel de Android lleva el tráfico a mayor velocidad.';

  @override
  String get smartNetwork => 'Conexión inteligente';
  String get smartNetworkHint => 'MTU, protocolo y versión de IP se adaptan a esta red, buscando velocidad.';
  String get valueSmart => 'Inteligente';
  String get mtuAutoValue => 'Automático — según la red';

  @override
  String mtuAutoMeasured(int mtu) {
    return 'Automático — la red lleva $mtu';
  }
  String get wnSmartAdded => 'Conexión inteligente: MTU, protocolo y versión de IP siguen la red, elegidos por respuestas reales y para la velocidad.';
  String get wnToastAdded => 'Las confirmaciones llegan como una nota suave al estilo iOS, con una marca que se dibuja sola.';
  String get wnFlagsImproved => 'La rueda de banderas se ve limpia: ninguna bandera se corta en el borde de la pantalla, se muestran enteras y la elección cae con un suave resorte.';
  String get wnMapImproved => 'El mapa del mundo se dibuja más grande y claro: sin continentes apretados, costas suaves y un halo brillante en el punto.';

  @override
  String get smartWaiting => 'Midiendo…';
  String get smartFamilyRace => 'Ambos compiten en la primera conexión';
  String get dnsManual => 'DNS manual';
  String get dnsManualHint => 'Una dirección por línea: IP simple, https:// (DNS sobre HTTPS) o tls://host (DNS sobre TLS). Gana la primera respuesta.';
  String get dnsManualInvalid => 'Una línea no es una dirección que el núcleo pueda usar: IP simple, https://… o tls://host.';
  String get killSwitchGuarded => 'Protegido: nada sale del teléfono mientras el túnel esté caído.';
  String get accountsUsageTitle => 'Este mes';
  String get accountsCountLabel => 'cuentas';
  String get accountsUsageAverage => 'promedio de la parte gastada de las cuentas';
  String get wnDesignsAdded => 'Diseños de la app: toda la app puede vestir Neumorfismo suave o Cristal aurora — cada página, cada tarjeta — en Ajustes → General.';
  String get wnWheelFixed => 'Adiós a la media bandera de la rueda: la repisa bajo la bandera elegida es un charco de luz, no otra bandera, y ninguna bandera se corta en el borde.';
  String get wnMapReal => 'El mapa del mundo se redibujó con las fronteras oficiales de los países — cada costa, isla y enclave, con fidelidad real y en su proporción verdadera.';
  String get wnGlobeAdded => 'El mundo es un globo ahora: la bola de plata gira para mirar al país elegido, un pin brillante y una tarjeta flotante lo marcan, y los caminos de la conexión van hacia los nodos.';
  String get wnWheelGlowImproved => 'La bandera elegida luce más grande en un marco de cristal con su propio halo azul, las vecinas se ven claramente más pequeñas y los marcadores bajo la rueda muestran dónde estás.';
  String get sectionAppearance => 'Apariencia';
  String get mapStyle => 'Estilo del mapa';
  String get mapStyleHint => 'El globo de la página de inicio se pinta como elija. La luz de la conexión queda igual.';
  String get mapSilver => 'Plata';
  String get mapMidnight => 'Medianoche';
  String get mapOcean => 'Océano';
  String get mapMono => 'Monocromo';
  String get mapAurora => 'Aurora';
  String get batterySaver => 'Ahorro de batería';
  String get batterySaverHint => 'Pone en reposo el movimiento del mapa mientras estás conectado: el respiro del globo, el brillo de la rueda. La conexión queda exactamente igual.';
  String get connectOnOpen => 'Conectar al abrir la app';
  String get connectOnOpenHint => 'Levanta la VPN al abrir la app, con la última ubicación que eligió.';
  String get speedTitle => 'Velocidad';
  String get parallelTunnels => 'Túneles paralelos';
  String get parallelTunnelsHint => 'Abre varios túneles hacia Mozilla a la vez y reparte el tráfico entre ellos, para que un túnel lento deje de limitar la velocidad. Ocho es lo más pesado para la batería.';
  String get tunnels1 => 'Uno — el más estable';
  String get tunnels2 => 'Dos';
  String get tunnels4 => 'Cuatro — más rápido en redes lentas';
  String get tunnels8 => 'Ocho — el más rápido';
  String get connectionCap => 'Límite de conexiones';
  String get connectionCapHint => 'Cuántas apps pueden hablar por la VPN a la vez; un límite menor ahorra batería y datos en un teléfono muy activo. Sin límite es lo predeterminado.';
  String get capNone => 'Sin límite';
  String get verboseLogging => 'Diagnóstico detallado';
  String get verboseLoggingHint => 'Escribe cada paso en el registro — útil al informar de un problema, un poco más pesado para la batería.';
  String get wn38MapStylesAdded => 'Cinco estilos para el mapa: plata, medianoche, océano, monocromo y aurora — la nueva página de Apariencia en los ajustes elige, con una vista previa de cada uno.';
  String get wn38ZoomAdded => 'El mapa hace zoom: pellizca con dos dedos, o toca dos veces para acercarte y volver.';
  String get wn38OptionsAdded => 'Opciones prácticas: túneles paralelos para más velocidad, límite de conexiones, ahorro de batería, conectar al abrir la app y diagnóstico detallado.';
  String get wn38SocialAdded => 'Instagram y Telegram ahora también viven al pie de esta página.';
  String get wn38FlightImproved => 'Elegir un país es un vuelo corto: la cámara retrocede, el globo gira, el pin cae con un rebote y los caminos se dibujan solos hasta los centros.';
  String get wn38EffectsImproved => 'El mapa se lee más rico: estrellas detrás del globo, una cuadrícula de coordenadas, las luces de los centros, un halo en el borde y la sombra de la tierra.';
  String get wn38SpeedImproved => 'La opción de velocidad es real: los túneles paralelos abren varias conexiones a la vez y el núcleo reparte el tráfico entre ellas.';
  String get wn38NameFixed => 'El nombre del país elegido se muestra una vez — en la tarjeta flotante del mapa; la copia bajo las banderas se fue.';
  String get mapKind => 'Tipo de mapa';
  String get mapKindClassic => 'Clásico';
  String get mapKindGlobe => 'Globo 3D';
  String get mapKindSatellite => 'Satélite';
  String get mapKindFlat => 'Plano 2D';
  String get mapKindNight => 'Noche';
  String get aboutChannels => 'Páginas de contacto';
  String get soundFeedback => 'Efectos de sonido';
  String get soundFeedbackHint => 'Sonidos suaves al tocar, en los interruptores y al conectar o desconectar';
  String get rateUnit => 'Unidad de velocidad';
  String get lockInBackground => 'Bloquear al salir';
  String get lockBgNever => 'Nunca';
  String get lockBgNow => 'Enseguida';
  String get lockBgMin5 => 'Tras 5 minutos';
  String get lockBgMin15 => 'Tras 15 minutos';
  String get mb25600 => '25 GB';
  String get mb51200 => '50 GB';
  String get mb102400 => '100 GB';
  String get wn41Sound => 'El sonido de conexión acompaña a la vibración: la VPN suena una nota corta al conectar o desconectar (Ajustes → General).';
  String get copyIp => 'Copiar la IP';
  String get wn42Fonts => 'Cada idioma lee con la propia tipografía de la app: Noto Sans para los dos chinos y el bengalí, Inter para los latinos y los cirílicos; ningún idioma depende ya de las fuentes del teléfono.';
  String get wn42Sounds => 'Los sonidos de la app son reales ahora: un toque suave en cada sección, dos notas para los interruptores, una nota que sube y baja al conectar y desconectar, un pitido para el bloqueo; el interruptor de sonido los gobierna todos.';
  String get wn42AboutFixed => 'La página Acerca de centra su logo, su nombre y su nota, y las direcciones de contacto quedan enteras en una línea, sea cual sea el ancho del teléfono.';
  String get wn42Gaming => 'El perfil de juego es real ahora: la página de servidores mide los retrasos de nuevo cada medio minuto y realza el más rápido medido con el acento.';
  String get wn41RateUnit => 'La velocidad se lee en la unidad que elijas: el conocido KB/s o el Mbps de la conexión.';
  String get wn41BackgroundLock => 'La app puede bloquearse en tu ausencia: la contraseña se pide enseguida, tras 5 o tras 15 minutos.';
  String get wn41BiggerLimits => 'El límite de datos de la sesión sube hasta 25, 50 o 100 GB.';
  String get wn41Motion => 'Movimiento nuevo: el orbe conectado respira, la marca de verificación se dibuja sola, la palabra de estado se desliza entre sus valores y una contraseña errónea sacude el campo.';
  String get wn41AboutFixed => 'La página Acerca de queda ordenada: las dos páginas lado a lado, cada aviso en su línea, nada comprimido.';
  String get wn41HapticFixed => 'El ajuste de vibración responde otra vez: cada conexión y desconexión lo sigue, no solo el deslizador.';
  String get mapKindTerrain => 'Relieve';
  String get mapKindHint => 'Cómo se muestra el mundo de la página principal: el mapa plano de siempre (predeterminado), su acabado moderno, la Tierra nocturna, la Tierra de relieve, la esfera metálica o la Tierra satelital. Las fronteras son las oficiales reales en cada tipo.';
  String get wn40MapKindsNew => 'Dos nuevos acabados del mapa: la Tierra nocturna y la Tierra de relieve.';
  String get wn40Flight => 'El globo 3D vuela al nuevo país en un giro suave — nunca un salto.';
  String get wn40Mercator => 'Los mapas planos se dibujan en la proyección Mercator estándar: proporciones verdaderas, fronteras estándar, nada comprimido.';
  String get wn40NameBack => 'El nombre del país elegido vuelve bajo las banderas en los mapas planos.';
  String get wn40Speed => 'El túnel ahora abre dos sesiones paralelas por defecto — una línea más fuerte y estable.';
  String get wn40LockFixed => 'El candado del botón de conexión ya no parpadea entre sus estados.';
  String get wn40IpRemoved => 'La ventana emergente de IP en la tarjeta de ubicación se eliminó.';
  String get mapStyleGlobeHint => 'Los colores que viste el globo 3D. El satélite lleva su propia Tierra y los mapas planos su propia tinta.';
  String get aboutVersions => 'Versión';
  String get checkUpdatesHint => 'Buscar una versión más nueva; la que se encuentre se descarga y el instalador pregunta.';
  String get smartLocation => 'Ubicación más rápida';
  String get smartLocationHint => 'Cada inicio usa el servidor que la prueba de latencia del núcleo llama más rápido.';
  String get quicPass => 'Paso de QUIC';
  String get quicPassHint => 'El QUIC de las apps (UDP 443) pasa por el túnel: llamadas y juegos conservan su velocidad en vez de volver a TCP.';
  String get accountRename => 'Renombrar cuenta';
  String get accountRenameLabel => 'Nombre de la cuenta';
  String get accountProfile => 'Foto de perfil';
  String get avatarReset => 'Volver a la marca simple';
  String get accountSecurity => 'Contraseña de la app';
  String get appPasswordOn => 'La app se abre tras una contraseña.';
  String get appPasswordOff => 'Sin contraseña: quien abra la app entra.';
  String get appPasswordSet => 'Establecer contraseña';
  String get appPasswordChange => 'Cambiar contraseña';
  String get appPasswordRemove => 'Quitar contraseña';
  String get appPasswordCurrent => 'Contraseña actual';
  String get appPasswordNew => 'Nueva contraseña (4+ caracteres)';
  String get appPasswordConfirm => 'Repite la nueva contraseña';
  String get appPasswordShort => 'Al menos 4 caracteres.';
  String get appPasswordMismatch => 'Las dos contraseñas no son iguales.';
  String get appPasswordWrong => 'Contraseña incorrecta';
  String get appPasswordSetDone => 'La contraseña quedó puesta — la app la pedirá desde el próximo inicio.';
  String get appPasswordRemoved => 'La contraseña se fue; la app se abre libremente.';
  String get appPasswordUnlock => 'La app está bloqueada';
  String get appPasswordUnlockHint => 'Escribe la contraseña de la app para continuar.';
  String get wn39MapKinds => 'El mapa vuelve a tener tipos: el plano de siempre (predeterminado), el globo 3D, la Tierra satelital y un plano 2D moderno.';
  String get wn39EyeIp => 'La tarjeta de ubicación lleva un ojo: tócalo para ver la dirección de salida del tráfico y copiarla.';
  String get wn39Profile => 'Las cuentas llevan su propio nombre y foto de perfil, y la app puede abrirse tras una contraseña.';
  String get wn39Smart => 'La conexión inteligente creció: la ubicación más rápida por latencia real y el paso de QUIC para llamadas y juegos.';
  String get wn39Flight => 'El cambio de país vuela más suave — la cámara sigue el círculo máximo — y los marcadores de la rueda de banderas están más cerca de las banderas.';
  String get wn39ToastEverywhere => 'La nota dinámica está en todas partes: cada guardado, copia y fallo lleva la misma píldora de vidrio animada.';
  String get wn39Updates => 'Las actualizaciones mantienen el almacenamiento limpio: el instalador reemplaza la versión vieja y no queda ningún paquete.';
  String get wnDesignsRemoved => 'El selector de diseño de la app se ha ido: la app vuelve a vestir su monocromo original; su acento y su tema quedan como estaban.';
  String get wnDnsAdded => 'DNS manual: IP simples, DNS sobre HTTPS y DNS sobre TLS — se muestra y comprueba el tipo de cada línea al escribir.';
  String get wnSmartImproved => 'La conexión inteligente ahora muestra lo que respondió la red: el transporte elegido y la versión de IP que conservó, en vivo.';
  String get wnProtectionImproved => 'El interruptor de corte avisa cuando su guarda está de pie, y la página de apps muestra cuántas elegiste.';
  String get wnWelcomeImproved => 'La bienvenida abre con un escudo que respira sobre una aurora a la deriva, y la página de cuentas resume el mes de un vistazo.';
  String bypassAppsCount(String n) => 'Elegidas: {n}'.replaceFirst('{n}', n);
}
