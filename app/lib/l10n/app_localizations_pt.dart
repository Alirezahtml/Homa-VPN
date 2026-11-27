// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Deslize para conectar';

  @override
  String get slideToDisconnect => 'Deslize para desconectar';

  @override
  String get navOverview => 'Visão geral';

  @override
  String get navAccounts => 'Contas';

  @override
  String get navSettings => 'Configurações';

  @override
  String get stateConnected => 'Conectado';

  @override
  String get stateConnecting => 'Conectando…';

  @override
  String get stateWaiting => 'Aguardando';

  @override
  String get waitingForAccount =>
      'Adicione uma Firefox Account na página Contas para conectar.';

  @override
  String get waitingForEnabledAccount =>
      'Todas as contas estão desativadas. Ative uma na página Contas.';

  @override
  String get stateError => 'Erro';

  @override
  String get stateUnknown => 'Desconhecido';

  @override
  String get restartProxy => 'Reiniciar o proxy';

  @override
  String copied(String value) {
    return '$value copiado';
  }

  @override
  String get activeAccount => 'Conta ativa';

  @override
  String get noActiveAccount => 'Nenhuma conta ativa';

  @override
  String get quotaNotRead => 'Franquia ainda não verificada';

  @override
  String get unlimited => 'Ilimitado';

  @override
  String usedOf(String used, String limit) {
    return '$used de $limit usados';
  }

  @override
  String resets(String date) {
    return 'zera em $date';
  }

  @override
  String switchAt(int percent) {
    return 'Troca de conta em $percent%';
  }

  @override
  String get publicIp => 'IP público';

  @override
  String get testConnection => 'Testar conexão';

  @override
  String get testing => 'Testando…';

  @override
  String get testFailed => 'Falhou';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'agora mesmo';

  @override
  String minutesAgo(int n) {
    return 'há $n min';
  }

  @override
  String hoursAgo(int n) {
    return 'há $n h';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'às $time';
  }

  @override
  String durationDays(int d, int h) {
    return '${d}d ${h}h';
  }

  @override
  String durationHours(int h, int m) {
    return '${h}h ${m}min';
  }

  @override
  String durationMinutes(int m, int s) {
    return '${m}min ${s}s';
  }

  @override
  String durationSeconds(int s) {
    return '${s}s';
  }

  @override
  String accountsGuide(String size) {
    return 'Cada Firefox Account tem $size de franquia por mês. Você pode adicionar várias: quando uma acaba, o app passa sozinho para a próxima.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'Na ordem desta lista: cada uma até $percent%, a última até acabarem os dados.';
  }

  @override
  String get addAccount => 'Adicionar conta';

  @override
  String lowQuotaNotice(String size) {
    return 'A franquia desta conta está acabando. Adicione outra conta para ter mais $size.';
  }

  @override
  String get noAccounts => 'Nenhuma conta ainda';

  @override
  String get noAccountsHint => 'Adicione uma Firefox Account para conectar.';

  @override
  String get delayTestFailed =>
      'Não foi possível medir o atraso dos servidores. Verifique sua internet.';

  @override
  String get createAccountTitle => 'Não tem uma Firefox Account?';

  @override
  String get createAccountHint =>
      'Crie uma grátis em accounts.firefox.com, depois volte e toque em Adicionar conta.';

  @override
  String get moveUp => 'Mover para cima';

  @override
  String get moveDown => 'Mover para baixo';

  @override
  String get statusActive => 'Ativa';

  @override
  String get statusReady => 'Pronta';

  @override
  String get statusNeedsSignIn => 'Requer login';

  @override
  String get statusReserved => 'Reservada';

  @override
  String get statusUnavailable => 'Indisponível';

  @override
  String statusUnavailableUntil(String date) {
    return 'Indisponível até $date';
  }

  @override
  String get statusDisabled => 'Desativada';

  @override
  String get statusEnabled => 'Ativada';

  @override
  String get useNow => 'Usar agora';

  @override
  String get signInAgain => 'Entrar novamente';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Esta conta usou $percent% dos dados, então a próxima assumiu.';
  }

  @override
  String get reasonQuotaExhausted =>
      'A franquia deste mês acabou; volta a ser usada após a renovação mensal.';

  @override
  String get reasonSignInRequired => 'Entre de novo para usar esta conta.';

  @override
  String get reasonSignInConfirm =>
      'A Mozilla pede para confirmar o login: toque em «Entrar novamente» (só o código é necessário).';

  @override
  String reasonSignInFailed(String detail) {
    return 'O login automático falhou ($detail). Entre de novo.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'O último login automático parou de funcionar logo depois; a próxima tentativa é às $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'O login automático não terminou ($detail); nova tentativa às $time.';
  }

  @override
  String get reasonNotEntitled =>
      'A Mozilla recusou esta conta; nova tentativa mais tarde.';

  @override
  String get more => 'Mais';

  @override
  String get refreshQuota => 'Atualizar franquia';

  @override
  String get remove => 'Remover';

  @override
  String get removeTitle => 'Remover conta?';

  @override
  String removeBody(String name) {
    return '$name e o login salvo serão removidos deste computador. Você pode adicioná-la novamente depois.';
  }

  @override
  String get unlimitedQuota => 'Franquia ilimitada';

  @override
  String get signInTitle => 'Entrar';

  @override
  String get signInIntro => 'Entre com uma Firefox Account.';

  @override
  String get email => 'E-mail';

  @override
  String get emailInvalid => 'Digite o e-mail da conta';

  @override
  String get password => 'Senha';

  @override
  String get passwordEmpty => 'Digite a senha';

  @override
  String get show => 'Mostrar';

  @override
  String get hide => 'Ocultar';

  @override
  String get signIn => 'Entrar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get done => 'Concluído';

  @override
  String get close => 'Fechar';

  @override
  String get noBrowserTitle => 'Não há navegador neste dispositivo';

  @override
  String get noBrowserText =>
      'Abra este endereço no seu celular ou computador:';

  @override
  String get cancel => 'Cancelar';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get signingIn => 'Entrando…';

  @override
  String get accountReady => 'Conta pronta';

  @override
  String get accountReadyHint => 'Ela foi adicionada ao final da lista.';

  @override
  String get captchaLabel => 'Caracteres da imagem';

  @override
  String get codeLabel => 'Código';

  @override
  String get captchaBroken => 'Não foi possível mostrar a imagem do CAPTCHA.';

  @override
  String stepEmailCode(String email) {
    return 'A Mozilla enviou um código para $email. Digite-o aqui.';
  }

  @override
  String get stepTotp => 'Digite o código do seu app autenticador.';

  @override
  String stepUnblockCode(String email) {
    return 'A Mozilla considerou este login incomum e enviou um código de desbloqueio para $email. Digite-o aqui.';
  }

  @override
  String get stepCaptcha => 'Digite os caracteres da imagem.';

  @override
  String stepEmailLink(String email) {
    return 'Abra o link de confirmação que a Mozilla enviou para $email. O app continua automaticamente.';
  }

  @override
  String get signInFailed => 'A conta não foi adicionada.';

  @override
  String get signInCancelled => 'Entrada cancelada.';

  @override
  String get signInNoAccount => 'Não existe Firefox Account com este e-mail.';

  @override
  String get signInNoAccountHint =>
      'Confira o e-mail, ou crie com ele uma Firefox Account gratuita no site da Mozilla, confirme-a pela sua caixa de entrada e depois adicione-a aqui.';

  @override
  String get createAccountButton => 'Criar uma Firefox Account';

  @override
  String get signInWrongPassword => 'Senha incorreta.';

  @override
  String get signInNoPassword =>
      'Esta conta não tem senha: foi criada com o login do Google ou da Apple. Defina uma senha e depois entre aqui com ela.';

  @override
  String get setPasswordButton => 'Definir senha';

  @override
  String get signInTooManyAttempts =>
      'Tentativas demais. Aguarde um pouco e tente de novo.';

  @override
  String get signInUnblockRejected =>
      'O código de desbloqueio não foi aceito. Use o código do e-mail mais recente da Mozilla.';

  @override
  String get signInWrongCode =>
      'Código errado ou expirado. Use o código do e-mail mais recente da Mozilla; um código antigo para de funcionar quando um novo é enviado.';

  @override
  String get signInWrongTotp =>
      'Código errado. Digite o código que o app autenticador mostra agora.';

  @override
  String get signInTooManyCodes =>
      'Códigos errados demais. Comece a entrada de novo.';

  @override
  String get signInTimedOut => 'A entrada demorou demais. Comece de novo.';

  @override
  String get signInNetwork =>
      'Não foi possível alcançar a Mozilla. Verifique sua internet e tente de novo.';

  @override
  String get coreConnecting => 'Conectando ao núcleo…';

  @override
  String get coreLost =>
      'A conexão com o núcleo foi perdida. Tentando novamente…';

  @override
  String get cantReachCore => 'Não foi possível conectar ao núcleo';

  @override
  String get startingCore => 'Iniciando o núcleo…';

  @override
  String get retry => 'Tentar de novo';

  @override
  String errNoCore(String path) {
    return 'O núcleo não foi encontrado na pasta do app ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'O núcleo parou: $detail';
  }

  @override
  String get errNotAnswering => 'O núcleo não está respondendo.';

  @override
  String get errRefused =>
      'O núcleo recusou a conexão; talvez ele pertença a outra cópia do app.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get sectionGeneral => 'Geral';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get closeBehavior => 'Ao fechar a janela';

  @override
  String get closeAsk => 'Perguntar sempre';

  @override
  String get closeTray => 'Minimizar para a bandeja';

  @override
  String get closeQuit => 'Sair do app';

  @override
  String get sectionConnection => 'Conexão';

  @override
  String get localProxy => 'Proxy local';

  @override
  String get systemProxy => 'Proxy do sistema';

  @override
  String get sectionRouting => 'Roteamento';

  @override
  String get routingDirect => 'Conexão direta para sites locais';

  @override
  String get routingDirectHint =>
      'Sites e IPs do país escolhido não passam pela VPN: abrem mais rápido e não gastam a franquia.';

  @override
  String get region => 'País';

  @override
  String get regionIr => 'Irã';

  @override
  String get regionCn => 'China';

  @override
  String get regionRu => 'Rússia';

  @override
  String get regionAf => 'Afeganistão';

  @override
  String get regionTr => 'Turquia';

  @override
  String get regionId => 'Indonésia';

  @override
  String get regionBr => 'Brasil';

  @override
  String get regionNone => 'Nenhum';

  @override
  String get saved => 'Salvo';

  @override
  String get dataFolder => 'Pasta de dados';

  @override
  String get openFolder => 'Abrir pasta';

  @override
  String get unofficialNote =>
      'Cliente não oficial. Sem vínculo com a Mozilla.';

  @override
  String get closeTitle => 'Fechar a janela?';

  @override
  String get closeBody =>
      'Minimizada na bandeja, a VPN continua conectada. Ao sair, ela é desligada.';

  @override
  String get rememberChoice => 'Lembrar minha escolha';

  @override
  String get minimizeToTray => 'Minimizar para a bandeja';

  @override
  String get quit => 'Sair';

  @override
  String get trayOpen => 'Abrir';

  @override
  String get trayQuit => 'Sair';

  @override
  String get trayProxyOnly => 'Somente serviço de proxy';

  @override
  String get traySetSystemProxy => 'Definir proxy do sistema';

  @override
  String errPortInUse(String port) {
    return 'A porta $port está sendo usada por outro programa, por isso o app não consegue se conectar ao núcleo.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'A porta $port está sendo usada por outro programa, por isso o proxy não consegue iniciar.';
  }

  @override
  String get changePort => 'Trocar porta';

  @override
  String get portDialogTitle => 'Escolha uma porta';

  @override
  String portDialogBody(String port) {
    return 'A porta $port está ocupada. Uma porta livre é sugerida abaixo; você pode digitar outra.';
  }

  @override
  String get portChangeBody =>
      'Os apps se conectam a esta porta. Escolha uma entre 1024 e 65535.';

  @override
  String get portLabel => 'Porta';

  @override
  String get portInvalid => 'Digite uma porta de 1024 a 65535';

  @override
  String get portBusy => 'Esta porta também está em uso';

  @override
  String get portInUse => 'Outro programa usa esta porta';

  @override
  String get save => 'Salvar';

  @override
  String get proxyPort => 'Porta do proxy';

  @override
  String get appPort => 'Porta do app';

  @override
  String get welcomeTitle => 'Boas-vindas';

  @override
  String get welcomeBody =>
      'Escolha seu idioma e seu país. Os sites do seu país abrem diretamente, sem a VPN: mais rápido e sem gastar a franquia.';

  @override
  String get start => 'Começar';

  @override
  String routingSuggestTitle(String country) {
    return '$country: abrir sites diretamente?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Sites e IPs do país escolhido ($country) abririam diretamente, sem a VPN. Você pode mudar isso em Roteamento.';
  }

  @override
  String get yes => 'Sim';

  @override
  String get notNow => 'Agora não';

  @override
  String get navServers => 'Servidores';

  @override
  String get navLogs => 'Logs';

  @override
  String get realDelay => 'Latência real';

  @override
  String get statElapsed => 'Duração';

  @override
  String get statDown => 'Download';

  @override
  String get statUp => 'Upload';

  @override
  String noticePort(String port) {
    return 'O proxy da Mozilla não se conecta à porta $port. Apenas as portas 80, 443, 8080 e 8443 passam pela VPN.';
  }

  @override
  String get noticeCommand =>
      'Este tipo de conexão não é compatível com a VPN.';

  @override
  String noticeTimes(int count, String time) {
    return '$count vezes, última às $time';
  }

  @override
  String get dismiss => 'Dispensar';

  @override
  String get modeRecommended => 'Recomendado';

  @override
  String get modeFastest => 'Mais rápido';

  @override
  String get modeRecommendedHint => 'A Mozilla escolhe o local para você.';

  @override
  String get modeFastestHint => 'O local com menor latência a cada conexão.';

  @override
  String get testDelay => 'Testar latência real';

  @override
  String get testingDelay => 'Medindo…';

  @override
  String get search => 'Pesquisar';

  @override
  String get noAnswer => 'Sem resposta';

  @override
  String testedAgo(String ago) {
    return 'Testado $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered de $total responderam';
  }

  @override
  String get noServers =>
      'Nenhum servidor ainda. Eles aparecem assim que o núcleo se conectar à Mozilla.';

  @override
  String get levelAll => 'Todos';

  @override
  String get filter => 'Filtrar';

  @override
  String get follow => 'Rolagem automática';

  @override
  String get clear => 'Limpar';

  @override
  String get copyAll => 'Copiar';

  @override
  String get logsCopied => 'Logs copiados';

  @override
  String get noLogs => 'Nenhuma linha de log ainda.';

  @override
  String get sectionAccounts => 'Troca automática de conta';

  @override
  String get switchThreshold => 'Trocar de conta em';

  @override
  String get switchThresholdHint =>
      'A próxima conta assume quando esta porcentagem da franquia for consumida.';

  @override
  String get signInMethod => 'Método de login';

  @override
  String get signInMethodBrowser => 'Entrar pelo navegador';

  @override
  String get signInMethodApi => 'Entrar diretamente';

  @override
  String get browserSignInBroken => 'Não foi possível abrir a página de login.';

  @override
  String get browserSignInBlocked =>
      'A Mozilla não concluiu a última etapa para adicionar a conta (HTTP 406).';

  @override
  String get browserSignInFallback => 'Entrar com e-mail e senha';

  @override
  String get backupExport => 'Salvar backup';

  @override
  String get backupImport => 'Importar backup';

  @override
  String backupSaved(String name) {
    return 'Salvo: $name';
  }

  @override
  String get backupImportTitle => 'Adicionar estas contas?';

  @override
  String get backupAccountExists => 'Já adicionada; o login virá do arquivo';

  @override
  String get backupImportAction => 'Adicionar';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas adicionadas',
      one: '1 conta adicionada',
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
      'Um por linha: https://…/dns-query, tls://… ou um endereço IP.';

  @override
  String get dnsFallback => 'Usar o DNS do sistema como alternativa';

  @override
  String get testDns => 'Testar DNS';

  @override
  String get transport => 'Protocolo';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'Versão do IP';

  @override
  String get ipVersionAuto => 'Automático (IPv4 primeiro, depois IPv6)';

  @override
  String get ipVersionDual => 'Ambos ao mesmo tempo (dual-stack)';

  @override
  String get ipVersionV6First => 'IPv6 primeiro, depois IPv4';

  @override
  String get ipVersionV4 => 'Somente IPv4';

  @override
  String get ipVersionV6 => 'Somente IPv6';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'Tamanho do pacote da interface VPN, de 1280 a 9000. Vazio: automático.';

  @override
  String get tunMtuInvalid => 'Um número de 1280 a 9000, ou vazio';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Direto';

  @override
  String get directRulesHint =>
      'Os sites e endereços desta lista abrem sem a VPN, direto pela sua própria internet. As regras do país escolhido já estão aqui: adicione, altere ou remova linhas. Escolher outro país as substitui pelas dele.';

  @override
  String get restoreRegionRules => 'Restaurar as regras do país';

  @override
  String get blockRules => 'Bloquear';

  @override
  String get blockRulesHint =>
      'Os sites e endereços desta lista não abrem de jeito nenhum, nem direto nem pela VPN: para anúncios ou sites que você nunca quer acessar.';

  @override
  String get rulesTitle => 'Regras';

  @override
  String get ruleSyntaxTitle => 'Como escrever uma regra';

  @override
  String get resolveDomains => 'Aplicar regras de IP aos domínios';

  @override
  String get routingLists => 'Arquivos geo';

  @override
  String get listSource => 'Origem das listas';

  @override
  String get listSourceCustom => 'Definido manualmente';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Atualizado $ago';
  }

  @override
  String get updateLists => 'Atualizar os arquivos geo';

  @override
  String get listsUpdated => 'Os arquivos geo foram atualizados.';

  @override
  String get testDestination => 'Testar a rota de um site';

  @override
  String get destinationHint => 'Um nome, um endereço ou uma URL';

  @override
  String get check => 'Verificar';

  @override
  String get routeDirect => 'Vai direto';

  @override
  String get routeProxy => 'Passa pela VPN';

  @override
  String get routeBlock => 'Bloqueado';

  @override
  String ruleMatched(String rule) {
    return 'Regra: $rule';
  }

  @override
  String get portRefusedNote =>
      'O proxy da Mozilla não se conecta a esta porta.';

  @override
  String get sectionAdvanced => 'Avançado';

  @override
  String get tlsFragment => 'Fragmentação TLS';

  @override
  String get tlsFragmentOff => 'Desativado';

  @override
  String get tlsFragmentFirstByte => 'Primeiro byte';

  @override
  String get tlsFragmentSni => 'Nome do servidor (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Divide o cabeçalho TLS no primeiro byte (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Divide o nome do servidor (SNI) em vários pacotes TCP';

  @override
  String get tlsFragmentRecord => 'Registro TLS';

  @override
  String get tlsFragmentRecordHint =>
      'Divide o nome do servidor (SNI) em dois registros TLS';

  @override
  String get tlsFragmentOffHint => 'Conexão TLS normal';

  @override
  String get sectionBypass => 'Se a Mozilla estiver bloqueada';

  @override
  String get sharedRelay => 'Relay compartilhado';

  @override
  String get sharedRelayHint =>
      'Usar os relays compartilhados do aplicativo se a Mozilla bloquear sua região. Um relay pessoal ativado tem prioridade.';

  @override
  String get personalRelay => 'Relay pessoal';

  @override
  String get apiRelay => 'Servidor de retransmissão';

  @override
  String get apiRelayUse => 'Usar o servidor de retransmissão';

  @override
  String get apiRelayHint =>
      'Seu próprio Cloudflare Worker, ou relay.php na sua própria hospedagem.\nUsado só quando a Mozilla não responde diretamente: o login, as contas e a lista de servidores passam por ele, não o tráfego da VPN.';

  @override
  String get upstreamProxy => 'Proxy upstream';

  @override
  String get upstreamProxyOn => 'Proxy upstream ativado';

  @override
  String get upstreamProxyAddress => 'Endereço SOCKS5';

  @override
  String get upstreamProxyPort => 'Porta';

  @override
  String get upstreamProxyHint =>
      'A conexão com a Mozilla passa por este proxy, para redes que bloqueiam ou deixam a Mozilla lenta.\nSe o proxy roda neste dispositivo, deixe-o fora da VPN.';

  @override
  String get upstreamProxyInvalid =>
      'Digite o endereço do proxy, como 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Digite uma porta de 1 a 65535.';

  @override
  String get upstreamProxyOwn =>
      'Esse é o proxy do próprio aplicativo. Digite outro.';

  @override
  String get apiRelayInvalid => 'Deve ser um endereço https://.';

  @override
  String get listenAddress => 'Acesso ao proxy';

  @override
  String get listenLocal => '127.0.0.1 · somente este dispositivo';

  @override
  String get listenAll => '0.0.0.0 · todas as redes (LAN)';

  @override
  String get proxyUsername => 'Usuário do proxy';

  @override
  String get proxyPassword => 'Senha do proxy';

  @override
  String get proxyLoginHint =>
      'Os apps terão que usar este usuário e senha. Deixe os dois em branco para não exigir senha.';

  @override
  String get loginBothOrNone => 'Preencha os dois ou deixe os dois vazios.';

  @override
  String get proxyLogin => 'Usuário e senha do proxy';

  @override
  String get idleSleep => 'Pausar após inatividade de';

  @override
  String get sleepNever => 'Nunca';

  @override
  String sleepMinutes(int count) {
    return '$count minutos';
  }

  @override
  String get sleepHour => '1 hora';

  @override
  String get showPublicIp => 'Mostrar o IP público';

  @override
  String get hapticFeedback => 'Vibrar quando a conexão mudar';

  @override
  String get keepScreenOn => 'Manter a tela acesa enquanto conectado';

  @override
  String get showTraffic => 'Mostrar o tráfego ao vivo na página inicial';

  @override
  String get speedInNotification => 'Mostrar a velocidade na notificação';

  @override
  String get liveTraffic => 'Tráfego ao vivo';

  @override
  String get totalTraffic => 'Tráfego total';

  @override
  String get verboseLogs => 'Logs detalhados';

  @override
  String get webDashboard => 'Painel web';

  @override
  String get webDashboardOpen => 'Abrir';

  @override
  String get webDashboardHint => 'Configurações avançadas e mais ferramentas';

  @override
  String numberInvalid(int min, int max) {
    return 'Digite um número de $min a $max';
  }

  @override
  String get notifySwitchedTitle => 'Conta trocada';

  @override
  String notifySwitchedBody(String name) {
    return 'Usando agora $name.';
  }

  @override
  String get notifySignInTitle => 'Login necessário';

  @override
  String get notifySignInBody =>
      'Uma conta precisa fazer login novamente. Abra a página Contas.';

  @override
  String get navAbout => 'Sobre';

  @override
  String get appVersionLabel => 'Versão do app';

  @override
  String get coreVersionLabel => 'Versão do núcleo';

  @override
  String get checkUpdates => 'Verificar atualizações';

  @override
  String get checkingUpdates => 'Verificando…';

  @override
  String get upToDate => 'Você tem a versão mais recente.';

  @override
  String updateAvailable(String version) {
    return 'A versão $version está disponível.';
  }

  @override
  String updateRequired(String version) {
    return 'Atualize para a versão $version. Esta atualização é necessária.';
  }

  @override
  String get download => 'Baixar';

  @override
  String updateCheckFailed(String error) {
    return 'Não foi possível verificar atualizações: $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'Não foi possível acessar o GitHub. Verifique sua conexão com a internet e tente novamente.';

  @override
  String get updateNow => 'Atualizar';

  @override
  String updateDownloading(String version) {
    return 'Baixando a versão $version…';
  }

  @override
  String updateReady(String version) {
    return 'A versão $version está pronta para instalar.';
  }

  @override
  String updateInstalling(String version) {
    return 'Instalando a versão $version. O app vai fechar e abrir de novo.';
  }

  @override
  String updateFailed(String version) {
    return 'Não foi possível atualizar para a versão $version.';
  }

  @override
  String updateDone(String version) {
    return 'Atualizado para a versão $version.';
  }

  @override
  String updateRolledBack(String version) {
    return 'A atualização para a versão $version não terminou, então o app voltou para a versão anterior.';
  }

  @override
  String get repoNotSet => 'O repositório do GitHub ainda não foi definido.';

  @override
  String get sourceCode => 'Código-fonte';

  @override
  String get tapToConnect => 'Clique para conectar';

  @override
  String get tapToDisconnect => 'Clique para desconectar';

  @override
  String get startOnBoot => 'Iniciar com o sistema';

  @override
  String get connectOnStartup => 'Conectar ao iniciar o sistema';

  @override
  String get proxyServiceActive => 'Serviço de proxy ativo';

  @override
  String get navHome => 'Início';

  @override
  String get groupApp => 'App';

  @override
  String get groupNetwork => 'Rede';

  @override
  String get stateOff => 'Desconectado';

  @override
  String get tapToConnectPhone => 'Toque para conectar';

  @override
  String get tapToDisconnectPhone => 'Toque para desconectar';

  @override
  String get tapToConnectTv => 'Pressione OK para conectar';

  @override
  String get tapToDisconnectTv => 'Pressione OK para desconectar';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Local recomendado';

  @override
  String dataLeftOf(String limit) {
    return 'de $limit';
  }

  @override
  String get homeLocation => 'Local';

  @override
  String get connectedTo => 'Conectado a';

  @override
  String get vpnNotAllowed =>
      'A VPN precisa da sua permissão. Toque no botão de novo e permita.';

  @override
  String get dataUsedTitle => 'Dados usados';

  @override
  String get bypassApps => 'Proxy por app';

  @override
  String get connectRetrying =>
      'Não foi possível conectar. Verifique sua internet.';

  @override
  String get failUnreachable =>
      'Não foi possível alcançar os servidores da Mozilla. Tente outra conexão de internet.';

  @override
  String get failUpstreamProxy =>
      'Não foi possível alcançar a Mozilla pelo proxy upstream. Verifique se ele está em execução.';

  @override
  String get failInsideVpn => 'Esta internet já passa por uma VPN. Desative-a.';

  @override
  String get failRefused =>
      'O servidor da Mozilla recusou a conexão. Tente de novo em alguns minutos.';

  @override
  String get failLocationRefused =>
      'Este país não está disponível para sua conta. Escolha outro país.';

  @override
  String get useRecommendedLocation => 'Usar o local recomendado';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'País escolhido: $chosen. País do seu IP: $exit.';
  }

  @override
  String get failSignIn =>
      'O login desta conta expirou. Entre novamente na página Contas.';

  @override
  String get failQuota => 'Os dados deste mês acabaram. Adicione outra conta.';

  @override
  String get failNotEntitled =>
      'A Mozilla não permite que esta conta use a VPN. Adicione outra conta.';

  @override
  String get failRegion => 'A Mozilla não oferece o serviço no seu país.';

  @override
  String get failServer =>
      'O serviço da Mozilla está com um problema temporário. O app tentará de novo sozinho.';

  @override
  String get failNoAccount =>
      'Nenhuma conta está pronta. Abra a página Contas.';

  @override
  String get failTestSite =>
      'Conectado ao servidor, mas os sites não abrem. Tente outro país.';

  @override
  String get failOther => 'Não foi possível conectar. Tente de novo.';

  @override
  String get failNoInternet =>
      'Sem internet. Verifique o Wi-Fi ou os dados móveis.';

  @override
  String get waitingForNetwork => 'Aguardando conexão com a internet…';

  @override
  String proxyStartFailed(String port) {
    return 'O proxy não conseguiu iniciar na porta $port. Escolha outra porta.';
  }

  @override
  String get connectionSettings => 'Configurações de conexão';

  @override
  String get appModeExclude => 'Excluir apps selecionados';

  @override
  String get appModeInclude => 'Somente apps selecionados';

  @override
  String get appModeExcludeHint =>
      'Os apps selecionados se conectam diretamente, sem a VPN: por exemplo, apps de banco que recusam endereços estrangeiros.';

  @override
  String get appModeIncludeHint =>
      'Apenas os apps selecionados passam pela VPN; os outros se conectam diretamente.';

  @override
  String fromRegionList(String region) {
    return 'Sugerido pela lista: $region';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Modo de conexão';

  @override
  String get modeProxyHint =>
      'Apenas os apps configurados para usar o proxy passam por ele.';

  @override
  String get modeSystemProxyHint =>
      'O Windows e a maioria dos apps passam pelo proxy.';

  @override
  String get modeSystemProxyHintOther =>
      'Os navegadores e a maioria dos apps passam pelo proxy.';

  @override
  String get suggestedApps => 'Apps sugeridos';

  @override
  String get showSystemApps => 'Mostrar apps do sistema';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps sugeridos selecionados',
      one: '1 app sugerido selecionado',
      zero: 'Os apps sugeridos já estão selecionados',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Automático';

  @override
  String get locationsSection => 'Locais';

  @override
  String get dnsSummaryOk => 'O DNS criptografado está funcionando';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nomes não foram resolvidos',
      one: '1 nome não foi resolvido',
    );
    return '$_temp0';
  }

  @override
  String dnsVia(String server) {
    return 'via $server';
  }

  @override
  String dnsSummaryDiffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'O DNS da sua rede respondeu $count nomes com um endereço de bloqueio. Este app não usa esse DNS para eles.',
      one: 'O DNS da sua rede respondeu 1 nome com um endereço de bloqueio. Este app não usa esse DNS para ele.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Resposta:';

  @override
  String get dnsNetworkAnswer => 'DNS da rede:';

  @override
  String get dnsFiltered => 'filtrado';

  @override
  String get rulesSyntaxTitle => 'Uma regra por linha';

  @override
  String get ruleDomain => 'O site e seus subdomínios';

  @override
  String get ruleFull => 'Exatamente este nome';

  @override
  String get ruleKeyword => 'Nomes que contêm a palavra';

  @override
  String get ruleGeosite => 'Sites de uma tag nos arquivos geo';

  @override
  String get ruleGeoip => 'Endereços de um país nos arquivos geo';

  @override
  String get ruleIp => 'Um endereço ou uma rede';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Somente proxy';

  @override
  String get noNetwork =>
      'Sem conexão com a internet. Ative o Wi-Fi ou os dados móveis.';

  @override
  String get blockAds => 'Bloquear anúncios';

  @override
  String systemProxyTakenBy(String address) {
    return 'Outro programa mudou o proxy do sistema para $address, então o tráfego não passa pela VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Outro programa desativou o proxy do sistema, então o tráfego não passa pela VPN.';

  @override
  String get setSystemProxyAgain => 'Configurar de novo';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Todo o tráfego do $os passa pela VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'Aguardando permissão para instalar o serviço TUN…';

  @override
  String get tunInstallCancelled =>
      'O modo TUN precisa de permissão de administrador uma vez. Ela não foi dada, então o modo não mudou.';

  @override
  String tunInstallFailed(String error) {
    return 'Não foi possível instalar o serviço TUN: $error';
  }

  @override
  String get tunStarting => 'Iniciando o modo TUN…';

  @override
  String get tunFailed => 'O modo TUN não pôde iniciar. Tentando de novo…';

  @override
  String get tunLost => 'O modo TUN parou inesperadamente. Tentando de novo…';

  @override
  String get tunNotRunning =>
      'O serviço TUN não está em execução. Tentando de novo…';

  @override
  String get tunMissing => 'O serviço TUN não está instalado.';

  @override
  String get tunOutdated =>
      'O serviço TUN é mais antigo que este app. Instale-o de novo para usar o modo TUN.';

  @override
  String get tunAppOutdated =>
      'O serviço TUN é mais novo que este app. Atualize o app para usar o modo TUN.';

  @override
  String get tunBusy => 'Outra cópia do Homa VPN está usando o modo TUN.';

  @override
  String get tunNoDriver =>
      'O driver TUN do sistema não está disponível. Reinicie o computador e tente novamente.';

  @override
  String get tunInstall => 'Instalar';

  @override
  String get tunInstallAgain => 'Instalar de novo';

  @override
  String get trayTunMode => 'Modo TUN (todos os apps)';

  @override
  String get removeTunService => 'Remover o serviço TUN';

  @override
  String get removeTunServiceHint =>
      'Remove o serviço do sistema que o modo TUN usa. Escolher TUN de novo o instala outra vez.';

  @override
  String get tunServiceRemoved => 'O serviço TUN foi removido.';

  @override
  String get tunInstallPrompt =>
      'O Homa VPN quer instalar o serviço do modo TUN.';

  @override
  String get tunRemovePrompt =>
      'O Homa VPN quer remover o serviço do modo TUN.';

  @override
  String tunRemoveFailed(String error) {
    return 'Não foi possível remover o serviço TUN: $error';
  }

  @override
  String get sectionTun => 'Configurações de TUN';

  @override
  String get tunPrograms => 'Programas fora da VPN';

  @override
  String get tunProgramsHint =>
      'Eles se conectam diretamente, não pela Mozilla. Só para programas que funcionam sem VPN.';

  @override
  String get tunProgramsEmpty => 'Nenhum programa ainda.';

  @override
  String get addProgram => 'Adicionar programa';

  @override
  String get programFiles => 'Programas';

  @override
  String get tunProgramAll => 'Todo o tráfego';

  @override
  String get tunProgramAllHint => 'O programa inteiro se conecta diretamente.';

  @override
  String get tunProgramUdp => 'Só UDP';

  @override
  String get tunProgramUdpHint =>
      'Só o UDP dele se conecta diretamente; o resto passa pela VPN.';

  @override
  String get udpNoticeSetting => 'Aviso de UDP bloqueado';

  @override
  String udpNoticeBody(String program) {
    return 'O tráfego UDP de $program não passa pela VPN.';
  }

  @override
  String get dontShowAgain => 'Não mostrar de novo';

  @override
  String get addRunningProgram => 'Dos programas em execução';

  @override
  String get addProgramFile => 'Escolher um arquivo…';

  @override
  String get addProgramName => 'Digitar um nome…';

  @override
  String get programNameHint =>
      'O nome do arquivo de um programa, como steam.exe; * significa qualquer texto (steam* são todos os programas do Steam).';

  @override
  String get runningProgramsEmpty => 'Nenhum outro programa está em execução.';

  @override
  String get tabLog => 'Log';

  @override
  String get tabConnections => 'Conexões';

  @override
  String get connectionsEmpty => 'Ainda não há conexões.';

  @override
  String connectionsOpen(int count) {
    return '$count abertas';
  }

  @override
  String get connTime => 'Hora';

  @override
  String get connRoute => 'Regra';

  @override
  String get connDestination => 'Destino';

  @override
  String get connInbound => 'Entrada';

  @override
  String get connProtocol => 'Protocolo';

  @override
  String get connColumns => 'Colunas';

  @override
  String get connTraffic => 'Tráfego';

  @override
  String get connDuration => 'Duração';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Direto';

  @override
  String get connRouteBlocked => 'Bloqueado';

  @override
  String get connRoutePort => 'Porta recusada';

  @override
  String get connRouteFailed => 'Falhou';

  @override
  String get testRelay => 'Testar o relé';

  @override
  String get relayTestTitle => 'Teste do relé';

  @override
  String get relayTestHint =>
      'Verifica apenas o relé. Não envia pedidos à Mozilla nem dados da conta.';

  @override
  String get relayTestPassed => 'O relé está pronto';

  @override
  String get relayTestFailed => 'Não foi possível confirmar o estado do relé';

  @override
  String get relayTestCopy => 'Copiar relatório';

  @override
  String get relayTestInterrupted =>
      'O teste terminou antes de receber um resultado completo.';

  @override
  String get searchLocations => 'Pesquisar locais';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count locais',
      many: '$count de locais',
      one: '1 local',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Atualizações automáticas';

  @override
  String get autoInstallApkHint =>
      'As versões novas baixam sozinhas; o instalador pergunta antes de instalar.';

  @override
  String get installNow => 'Instalar';

  @override
  String get updateAllowInstall =>
      'Para instalar a atualização, permita que este aplicativo instale aplicativos.';

  @override
  String get allowInstall => 'Permitir';

  @override
  String get noResults => 'Nenhum local corresponde à pesquisa.';

  @override
  String get accentColor => 'Cor de destaque';

  @override
  String get accentMono => 'Monocromático (padrão)';

  @override
  String get accentCustom => 'Cor personalizada';

  @override
  String get accentEmber => 'Brasa';

  @override
  String get accentGold => 'Dourado';

  @override
  String get accentEmerald => 'Esmeralda';

  @override
  String get accentSapphire => 'Safira';

  @override
  String get accentAmethyst => 'Ametista';

  @override
  String get accentRose => 'Rosa';

  @override
  String get autoReconnect => 'Reconexão automática';

  @override
  String get autoReconnectHint =>
      'Religa a conexão sozinha quando ela cai sem você pedir.';

  @override
  String get androidOnlyHint => 'Somente no celular.';

  @override
  String get idleDisconnect => 'Desconectar quando ociosa';

  @override
  String get idleDisconnectHint =>
      'Encerra a sessão quando nenhum tráfego passa por um tempo.';

  @override
  String get idleTimeout => 'Espera de ociosidade';

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
  String get dataLimit => 'Limite de dados da sessão';

  @override
  String get dataLimitHint =>
      'Encerra a sessão quando o tráfego dela atinge o limite.';

  @override
  String get dataLimitAmount => 'Limite';

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
    return 'Não passou tráfego por $minutes minutos, então a conexão foi desconectada.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'A sessão atingiu o limite de $mb MB, então a conexão foi desconectada.';
  }

  @override
  String get protection => 'Proteção';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Se a VPN cair, o tráfego é retido — sem fugas — até religar.';

  @override
  String get alwaysOnVpn => 'VPN sempre ativa';

  @override
  String get alwaysOnVpnHint =>
      'Proteção do próprio Android: nenhuma conexão sem a VPN.';

  @override
  String get floatingIsland => 'Ilha flutuante';

  @override
  String get floatingIslandHint =>
      'Mostra a conexão sobre os outros apps enquanto você está fora do app.';

  @override
  String whatsNewTitle(String version) {
    return 'Novidades da versão $version';
  }

  @override
  String get whatsNewContinue => 'Entendi';

  @override
  String get whatsNewMenu => 'Novidades';

  @override
  String get whatsNewView => 'Ver novamente';

  @override
  String get updateServers => 'Atualizar servidores';

  @override
  String get updatingServers => 'A atualizar…';

  @override
  String serversUpdated(int count) {
    return '$count localizações da lista oficial da Mozilla';
  }

  @override
  String get serversUpdateFailed =>
      'Não foi possível atualizar a lista; a anterior foi mantida.';

  @override
  String get smartPickTitle => 'O mais rápido agora';

  @override
  String get smartPickUse => 'Usar';

  @override
  String get connectAtBoot => 'Ligar ao ligar o telefone';

  @override
  String get connectAtBootHint =>
      'Liga-se sozinho ao ligar o telefone, se a permissão de VPN já foi concedida.';

  @override
  String get gamingProfile => 'Perfil de jogos';

  @override
  String get gamingProfileHint =>
      'Mostra o atraso e a qualidade em vivo da conexão; combina com o servidor medido mais rápido.';

  @override
  String get diagnosticsRun => 'Executar diagnóstico';

  @override
  String get diagnosticsHint => 'Conexão, DNS e túnel, verificados num toque';

  @override
  String get diagnosticsTunnel => 'Túnel';

  @override
  String get diagnosticsTunnelUp => 'No ar e levando tráfego';

  @override
  String get diagnosticsTunnelDown => 'Fora';

  @override
  String get diagnosticsExit => 'País de saída';

  @override
  String get diagnosticsMismatch => 'A saída difere da escolha';

  @override
  String get diagnosticsConnection => 'Teste de ligação';

  @override
  String get diagnosticsPassed => 'Passou';

  @override
  String get diagnosticsFailed => 'Falhou';

  @override
  String get diagnosticsDnsFiltered => 'Resposta bloqueada ou filtrada';

  @override
  String get diagnosticsDnsOk => 'Respondeu';

  @override
  String get diagnosticsPrivacy =>
      'Nada aqui é guardado; os resultados ficam nesta janela e no registro do próprio núcleo.';

  @override
  String get diagnosticsAgain => 'Executar de novo';

  @override
  String get whatsNewAdded => 'Novo';

  @override
  String get whatsNewImproved => 'Melhorado';

  @override
  String get whatsNewFixed => 'Corrigido';

  @override
  String get wnWheelImproved =>
      'A roda de países foi redesenhada: a bandeira escolhida fica maior numa moldura de vidro com um brilho fino e um halo suave de luz atrás, as outras bandeiras ficam menores com profundidade, e o nome abaixo chega deslizando.';

  @override
  String get wnLiveImproved =>
      'Enquanto conectado, a notificação pede ao Android 16 para promovê-la como Live Update, como faz a implementação de referência; a duração continua contando e as velocidades seguem ativas.';

  @override
  String get wnL10nFixed =>
      'Esta página agora fala o idioma do app — todos os seus quinze idiomas, não só o inglês.';

  @override
  String get wnMarkFixed =>
      'A marca da Mozilla aparece limpa em seu ladrilho, arredondada como as bandeiras.';

  @override
  String get designTitle => 'Design da página inicial';

  @override
  String get designHint => 'Como a página inicial se organiza';

  @override
  String get designWheel => 'Roda';

  @override
  String get designWheelDesc =>
      'As bandeiras na sua roda de vidro, o interruptor abaixo';

  @override
  String get designBento => 'Bento';

  @override
  String get designBentoDesc =>
      'O design da própria caixa bento: as bandeiras no seu quadro de mosaicos, o mosaico de conexão, os números e o local como mosaicos de uma caixa calorosa';

  @override
  String get designPixel => 'Material You';

  @override
  String get designPixelDesc =>
      'Material You: superfícies tonais, cartões grandes e cheios, barra de indicador pastilha e títulos grandes — a voz própria do Android';

  @override
  String get notifFlag => 'Bandeira do país na notificação';

  @override
  String get notifFlagHint => 'A bandeira do próprio país ao lado do nome';

  @override
  String get wnDesignAdded =>
      'Uma configuração de design da página inicial: roda, mosaico ou cartão compacto';

  @override
  String get wnMapAdded =>
      'Um mapa-múndi vetorial real atrás da página inicial, o país escolhido iluminado';

  @override
  String get wnWheelAdded =>
      'A roda de bandeiras redesenhada: vidro mais profundo, movimento mais suave';

  @override
  String get wnFlagNotifAdded =>
      'A notificação pode mostrar a bandeira SVG do país, e pode ser desligada';

  @override
  String get wnColorRemoved =>
      'A página de cor personalizada foi removida; a lista de acentos mantém o HEX';

  @override
  String get whatsNewRemoved => 'Removido';

  @override
  String get wnCrashFixed =>
      'A aplicação já não para sozinha nos telefones com Android 16: a notificação pedia ao sistema algo que o telefone ainda não tinha.';

  @override
  String get wnFlagArtFixed =>
      'A aplicação já não se fecha sozinha ao abrir: a arte da bandeira da notificação devolvia um valor que o mensageiro do sistema recusa.';

  @override
  String get statSession => 'Sessão';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get wnTotalsAdded =>
      'A página inicial mostra o total que a sessão moveu, e um toque copia o IP público.';

  @override
  String get wnPolishImproved =>
      'A roda de bandeiras e a página de servidores ficaram mais arrumadas; os textos são compactos e o túnel Android leva o tráfego mais rápido.';

  @override
  String get valueSmart => 'Inteligente';

  @override
  String get wnSmartAdded =>
      'Conexão inteligente: MTU, protocolo e versão de IP seguem a rede, escolhidos por respostas reais e para a velocidade.';

  @override
  String get wnToastAdded =>
      'As confirmações chegam como uma nota suave ao estilo iOS, com uma marca que se desenha sozinha.';

  @override
  String get wnFlagsImproved =>
      'A roda de bandeiras fica limpa: nenhuma bandeira é cortada na borda da tela, elas aparecem inteiras e a escolha pousa com uma mola suave.';

  @override
  String get wnMapImproved =>
      'O mapa-múndi é desenhado maior e mais claro: sem continentes espremidos, litorais suaves e um halo brilhante na âncora.';

  @override
  String get dnsManual => 'DNS manual';

  @override
  String get dnsManualHint =>
      'Um endereço por linha: IP simples, https:// (DNS sobre HTTPS) ou tls://host (DNS sobre TLS). A primeira resposta vence.';

  @override
  String get dnsManualInvalid =>
      'Uma linha não é um endereço que o núcleo possa usar: IP simples, https://… ou tls://host.';

  @override
  String get killSwitchGuarded =>
      'Sob guarda: nada sai do telefone enquanto o túnel estiver fora.';

  @override
  String get accountsUsageTitle => 'Este mês';

  @override
  String get accountsCountLabel => 'contas';

  @override
  String get accountsUsageAverage => 'média da parte gasta das contas';

  @override
  String get wnDesignsAdded =>
      'Designs do app: o app inteiro pode vestir Neomorfismo suave ou Vidro aurora — cada página, cada cartão — em Ajustes → Geral.';

  @override
  String get wnWheelFixed =>
      'A meia-bandeira da roda sumiu: a prateleira sob a bandeira escolhida é uma poça de luz, não uma segunda bandeira, e nada é cortado na borda da tela.';

  @override
  String get wnMapReal =>
      'O mapa-múndi foi redesenhado com as fronteiras oficiais dos países — cada costa, ilha e enclave, fiel e na proporção real.';

  @override
  String get wnGlobeAdded =>
      'O mundo virou um globo: a bola de prata gira para mostrar o país escolhido, um pino brilhante e um cartão flutuante o marcam, e as rotas da conexão vão até os hubs.';

  @override
  String get wnWheelGlowImproved =>
      'A bandeira escolhida fica maior em uma moldura de vidro com seu halo azul, as vizinhas ficam claramente menores e os marcadores sob a roda mostram onde você está.';

  @override
  String get wnDesignsRemoved =>
      'O seletor de design do app saiu: o app volta a vestir seu monocromático original — seu destaque e seu tema ficam como estavam.';

  @override
  String get wnDnsAdded =>
      'DNS manual: IPs simples, DNS sobre HTTPS e DNS sobre TLS — o tipo de cada linha é mostrado e conferido ao digitar.';

  @override
  String get wnSmartImproved =>
      'A conexão inteligente agora mostra o que a rede respondeu: o transporte escolhido e a versão de IP mantida, em tempo real.';

  @override
  String get wnProtectionImproved =>
      'O kill switch avisa quando a sua guarda está de pé, e a página de apps mostra quantos você escolheu.';

  @override
  String get wnWelcomeImproved =>
      'A boas-vindas abre com um escudo que respira sobre uma aurora à deriva, e a página de contas resume o mês num relance.';

  @override
  String bypassAppsCount(String n) {
    return 'Escolhidos: $n';
  }

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get mapStyle => 'Estilo do mapa';

  @override
  String get mapStyleHint =>
      'O globo da página inicial é pintado como você escolher. A luz da conexão continua igual.';

  @override
  String get mapSilver => 'Prata';

  @override
  String get mapMidnight => 'Meia-noite';

  @override
  String get mapOcean => 'Oceano';

  @override
  String get mapMono => 'Mono';

  @override
  String get mapAurora => 'Aurora';

  @override
  String get batterySaver => 'Economia de bateria';

  @override
  String get batterySaverHint =>
      'Coloca o movimento do mapa em repouso enquanto conectado — a respiração do globo, o brilho da roda. A conexão em si continua exatamente igual.';

  @override
  String get connectOnOpen => 'Conectar ao abrir o app';

  @override
  String get connectOnOpenHint =>
      'Ativa a VPN ao abrir o app, com o último local que você escolheu.';

  @override
  String get speedTitle => 'Velocidade';

  @override
  String get parallelTunnels => 'Túneis paralelos';

  @override
  String get parallelTunnelsHint =>
      'Abre vários túneis para a Mozilla de uma vez e divide o tráfego entre eles, para que um túnel lento não limite mais a velocidade. Oito é o mais pesado para a bateria.';

  @override
  String get tunnels1 => 'Um — o mais estável';

  @override
  String get tunnels2 => 'Dois';

  @override
  String get tunnels4 => 'Quatro — mais rápido em redes lentas';

  @override
  String get tunnels8 => 'Oito — o mais rápido';

  @override
  String get connectionCap => 'Limite de conexões';

  @override
  String get connectionCapHint =>
      'Quantos apps podem falar pela VPN ao mesmo tempo; um limite menor economiza bateria e dados num telefone bem usado. Sem limite é o padrão.';

  @override
  String get capNone => 'Sem limite';

  @override
  String get verboseLogging => 'Diagnóstico detalhado';

  @override
  String get verboseLoggingHint =>
      'Escreve cada passo no registro — útil ao relatar um problema, um pouco mais pesado para a bateria.';

  @override
  String get wn38MapStylesAdded =>
      'Cinco estilos para o mapa: prata, meia-noite, oceano, mono e aurora — a nova página de Aparência nos ajustes escolhe, com prévia de cada um.';

  @override
  String get wn38ZoomAdded =>
      'O mapa dá zoom: pince com dois dedos, ou toque duas vezes para aproximar e voltar.';

  @override
  String get wn38OptionsAdded =>
      'Opções práticas: túneis paralelos para mais velocidade, limite de conexões, economia de bateria, conectar ao abrir o app e diagnóstico detalhado.';

  @override
  String get wn38SocialAdded =>
      'Instagram e Telegram agora também moram no fim desta página.';

  @override
  String get wn38FlightImproved =>
      'Escolher um país é um voo curto: a câmera recua, o globo gira, o pino cai com um pulo e as estradas se desenham sozinhas até os centros.';

  @override
  String get wn38EffectsImproved =>
      'O mapa fica mais rico: estrelas atrás do globo, uma grade de coordenadas, as luzes dos centros, um halo na borda e a sombra da terra.';

  @override
  String get wn38SpeedImproved =>
      'A opção de velocidade é real: os túneis paralelos abrem várias conexões de uma vez, e o núcleo divide o tráfego entre elas.';

  @override
  String get wn38NameFixed =>
      'O nome do país escolhido aparece uma vez — no cartão flutuante do mapa; a cópia sob as bandeiras se foi.';

  @override
  String get mapKind => 'Tipo de mapa';

  @override
  String get mapKindHint =>
      'Como o mundo da página inicial é mostrado: o mapa plano de sempre (padrão), seu acabamento moderno, a Terra noturna, a Terra de relevo, o globo de metal ou a Terra de satélite. As fronteiras são as oficiais reais em cada tipo.';

  @override
  String get mapKindClassic => 'Clássico';

  @override
  String get mapKindGlobe => 'Globo 3D';

  @override
  String get mapKindSatellite => 'Satélite';

  @override
  String get mapKindFlat => 'Plano 2D';

  @override
  String get mapKindHud => 'Radar';

  @override
  String get mapStyleGlobeHint =>
      'As cores que o globo 3D veste. O satélite carrega a sua própria Terra e os mapas planos a sua própria tinta.';

  @override
  String get aboutVersions => 'Versão';

  @override
  String get aboutChannels => 'Páginas de contato';

  @override
  String get checkUpdatesHint =>
      'Procurar uma versão mais nova; a encontrada é baixada e o instalador pergunta.';

  @override
  String get speedTestTitle => 'Teste de velocidade';

  @override
  String get speedTestRun => 'Medir';

  @override
  String get speedTestFailed => 'A medição não terminou.';

  @override
  String get speedTestThrough => 'Medido através do túnel.';

  @override
  String get speedTestDirect => 'Medido direto (o proxy está desligado).';

  @override
  String get speedTestHint =>
      'Um download e um upload pelo túnel dizem o que ele realmente carrega. O gráfico da página inicial também abre isto.';

  @override
  String get speedGraphHint => 'O último minuto do túnel · toque para medir';

  @override
  String get favoritePinned => 'Fixado. Toque longo outra vez para remover.';

  @override
  String get favoriteUnpinned => 'Removido.';

  @override
  String get shareReport => 'Compartilhar relatório';

  @override
  String get shareReportCopied => 'O relatório ficou na área de transferência.';

  @override
  String get batteryWizardTitle => 'Continuar vivo na bateria';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei e companhia matam apps de VPN depois de a tela bloquear. Tire este app da otimização de bateria para o túnel ficar ligado.';

  @override
  String get batteryWizardSteps =>
      'Nos ajustes do fabricante, permita também início automático e deixe o app em Sem restrições (Xiaomi), fora dos Apps adormecidos (Samsung) ou Início manual (Huawei).';

  @override
  String get batteryWizardState =>
      'A otimização de bateria pode parar o túnel.';

  @override
  String get batteryWizardPermit => 'Permitir';

  @override
  String get batteryWizardOk => 'O túnel está protegido da bateria.';

  @override
  String get batteryWizardOpen => 'Ajustes de bateria';

  @override
  String get usageTitle => 'Uso por app';

  @override
  String get usageRowHint => 'Quanto cada app usou';

  @override
  String get usageGrant => 'Abrir acesso de uso';

  @override
  String get usageGrantHint =>
      'O Android guarda o uso de dados por app atrás da permissão de acesso de uso. A página que o botão abre é do sistema; o app só lê os números.';

  @override
  String get usageEmpty => 'Nenhum uso registrado neste período.';

  @override
  String get usageToday => 'Hoje';

  @override
  String get usageWeek => 'Últimos 7 dias';

  @override
  String get usageMonth => 'Últimos 30 dias';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'O app é instalado fora da Google Play, por isso o Play Protect pode pedir uma verificação na primeira instalação. Toque uma vez em \"Verificar app\" — uma verificação limpa fica lembrada e as atualizações seguintes são instaladas sem este aviso.';

  @override
  String get smartLocation => 'Localização mais rápida';

  @override
  String get smartLocationHint =>
      'Cada início usa o servidor que o teste de latência do núcleo diz ser o mais rápido.';

  @override
  String get quicPass => 'Passagem QUIC';

  @override
  String get quicPassHint =>
      'O QUIC dos apps (UDP 443) passa pelo túnel: chamadas e jogos mantêm a velocidade em vez de cair para TCP.';

  @override
  String get accountRename => 'Renomear conta';

  @override
  String get accountRenameLabel => 'Nome da conta';

  @override
  String get accountProfile => 'Foto de perfil';

  @override
  String get avatarReset => 'Voltar à marca simples';

  @override
  String get accountSecurity => 'Senha do app';

  @override
  String get appPasswordOn => 'O app abre atrás de uma senha.';

  @override
  String get appPasswordOff => 'Sem senha: quem abrir o app entra.';

  @override
  String get appPasswordSet => 'Definir senha';

  @override
  String get appPasswordChange => 'Mudar senha';

  @override
  String get appPasswordRemove => 'Remover senha';

  @override
  String get appPasswordCurrent => 'Senha atual';

  @override
  String get appPasswordNew => 'Nova senha (4+ caracteres)';

  @override
  String get appPasswordConfirm => 'Repita a nova senha';

  @override
  String get appPasswordShort => 'Pelo menos 4 caracteres.';

  @override
  String get appPasswordMismatch => 'As duas senhas não são iguais.';

  @override
  String get appPasswordWrong => 'Senha incorreta';

  @override
  String get appPasswordSetDone =>
      'A senha está posta — o app a pedirá a partir do próximo início.';

  @override
  String get appPasswordRemoved => 'A senha se foi; o app abre livremente.';

  @override
  String get appPasswordUnlock => 'O app está bloqueado';

  @override
  String get appPasswordUnlockHint => 'Escreva a senha do app para continuar.';

  @override
  String get wn39MapKinds =>
      'O mapa volta a ter tipos: o plano de sempre (padrão), o globo 3D, a Terra de satélite e um plano 2D moderno.';

  @override
  String get wn39EyeIp =>
      'O cartão de localização traz um olho: toque para ver o endereço de saída do tráfego e copiá-lo.';

  @override
  String get wn39Profile =>
      'As contas carregam o próprio nome e foto de perfil, e o app pode abrir atrás de uma senha.';

  @override
  String get wn39Smart =>
      'A conexão inteligente cresceu: a localização mais rápida por latência real e a passagem QUIC para chamadas e jogos.';

  @override
  String get wn39Flight =>
      'A mudança de país voa mais suave — a câmera segue o círculo máximo — e os marcadores da roda de bandeiras ficam junto às bandeiras.';

  @override
  String get wn39ToastEverywhere =>
      'A nota dinâmica está em todo lugar: cada salvamento, cópia e falha veste a mesma pílula de vidro animada.';

  @override
  String get wn39Updates =>
      'As atualizações mantêm o armazenamento limpo: o instalador substitui a versão velha e nenhum pacote fica.';

  @override
  String get mapKindNight => 'Noite';

  @override
  String get mapKindTerrain => 'Relevo';

  @override
  String get wn40MapKindsNew =>
      'Dois novos acabamentos do mapa: a Terra noturna e a Terra de relevo.';

  @override
  String get wn40Flight =>
      'O globo 3D voa para o novo país num giro suave — nunca um salto.';

  @override
  String get wn40Mercator =>
      'Os mapas planos se desenham na projeção Mercator padrão: proporções verdadeiras, fronteiras padrão, nada comprimido.';

  @override
  String get wn40NameBack =>
      'O nome do país escolhido volta sob as bandeiras nos mapas planos.';

  @override
  String get wn40Speed =>
      'O túnel agora abre duas sessões paralelas por padrão — uma linha mais forte e estável.';

  @override
  String get wn40LockFixed =>
      'O cadeado do botão de conexão não pisca mais entre seus estados.';

  @override
  String get wn40IpRemoved => 'A janela de IP do cartão de local foi removida.';

  @override
  String get soundFeedback => 'Efeitos sonoros';

  @override
  String get soundFeedbackHint =>
      'Sons suaves ao tocar, nos interruptores e ao conectar ou desconectar';

  @override
  String get rateUnit => 'Unidade de velocidade';

  @override
  String get lockInBackground => 'Bloquear ao sair';

  @override
  String get lockBgNever => 'Nunca';

  @override
  String get lockBgNow => 'Logo em seguida';

  @override
  String get lockBgMin5 => 'Após 5 minutos';

  @override
  String get lockBgMin15 => 'Após 15 minutos';

  @override
  String get mb25600 => '25 GB';

  @override
  String get mb51200 => '50 GB';

  @override
  String get mb102400 => '100 GB';

  @override
  String get wn41Sound =>
      'O som de conexão acompanha a vibração: a VPN toca uma nota curta ao conectar ou desconectar (Ajustes → Geral).';

  @override
  String get wn41RateUnit =>
      'A velocidade é lida na unidade que você escolhe: o conhecido KB/s ou o Mbps da conexão.';

  @override
  String get wn41BackgroundLock =>
      'O app pode se bloquear na sua ausência: a senha é pedida de novo logo, após 5 ou após 15 minutos.';

  @override
  String get wn41BiggerLimits =>
      'O limite de dados da sessão sobe para 25, 50 ou 100 GB.';

  @override
  String get wn41Motion =>
      'Movimento novo: o orbe conectado respira, o visto se desenha sozinho, a palavra de estado desliza entre seus valores e uma senha errada sacode o campo.';

  @override
  String get wn41AboutFixed =>
      'A página Sobre fica arrumada: as duas páginas lado a lado, cada aviso na sua linha, nada comprimido.';

  @override
  String get wn41HapticFixed =>
      'O ajuste de vibração responde de novo: toda conexão e desconexão o segue, não só o deslizador.';

  @override
  String get copyIp => 'Copiar o IP';

  @override
  String get wn42Fonts =>
      'Cada idioma lê com a fonte própria do app: Noto Sans para os dois chineses e o bengali, Inter para os latinos e cirílicos — nenhum idioma depende mais das fontes do telefone.';

  @override
  String get wn42Sounds =>
      'Os sons do app agora são reais: um toque suave em cada seção, duas notas para os interruptores, uma nota que sobe e desce ao conectar e desconectar, um ping para o bloqueio — o interruptor de som governa todos.';

  @override
  String get wn42AboutFixed =>
      'A página Sobre centra o logotipo, o nome e a nota, e os identificadores de contato ficam inteiros numa linha, seja qual for a largura do telefone.';

  @override
  String get wn42Gaming =>
      'O perfil de jogo agora é real: a página de servidores remede os atrasos a cada meio minuto e destaca o mais rápido medido com o acento.';

  @override
  String get avatarPhoto => 'Sua foto';

  @override
  String get avatarPhotoFailed => 'Não foi possível usar essa imagem';

  @override
  String get tlsFragmentAuto => 'Automático';

  @override
  String get tlsFragmentAutoHint =>
      'Primeiro o hello completo; uma rede que corta TLS seguido corta o nome por si, por meia hora';

  @override
  String get accentDesign => 'A luz do próprio design';

  @override
  String get wn45Designs =>
      'Quatro novos visuais de início — Aurora, Neon, Crepúsculo e Sálvia — cada um veste todas as páginas com a sua paleta';

  @override
  String get wn45HelloAuto =>
      'O fragmentador TLS aprendeu: uma rede que mata o aperto de mão sem parar tem o nome cortado por si, e o túnel passa';

  @override
  String get wn45RelayRace =>
      'A recuperação do reteste agora prova três bordas de uma vez, e a rede filtrada acha o caminho mais cedo';

  @override
  String get wn45AccentFixed =>
      'O seletor de cor volta a iluminar a app — a sua cor deixara de chegar às páginas';

  @override
  String get wn45WhatsNewFixed =>
      'A página das novidades volta a mostrar as suas palavras — abria-se vazia';

  @override
  String get wn46Designs =>
      'Dois novos estilos dos designs de referência: o cartão de status iOS do éter e a esfera degradada do zed — cada um veste todo o app, e os quatro estilos anteriores partiram.';

  @override
  String get wn46Sounds =>
      'Os sons ganharam um conjunto profissional: uma onda para a conexão que começa, um acorde quando se estabelece, uma descida ao cair e uma nota abafada para o caminho bloqueado — uma voz de cada vez.';

  @override
  String get wn47Designs =>
      'Os dois visuais de referência agora vestem o aplicativo inteiro — cada página, não só a principal: o aether veste a estrutura iOS da primeira referência (a barra de entalhe curvo, as tabelas agrupadas, os crachás coloridos, as cores de estado do sistema) e o zed veste a expressiva da segunda (o dock flutuante, os cartões bem redondos, as bolhas de ferramentas arrastáveis).';

  @override
  String get wn47Fixes =>
      'Uma linha de ajustes que transbordava em telas estreitas agora se lê até o fim.';

  @override
  String get wn48Bars =>
      'As barras inferiores dos dois designs voltaram ao lugar: o círculo azul do aether pousa no recorte da sua própria aba e o círculo do zed já não tapa o nome por baixo.';

  @override
  String get wn48Fit =>
      'As telas iniciais voltam a caber na sua tela: o cartão do aether lê Disconnected até ao fim, o orbe do zed desce um passo quando a página fica estreita e, enquanto a ligação se faz, nem a pista pede deslizar para ligar nem a dica diz desligar ao mesmo tempo.';

  @override
  String get wn48Wheel =>
      'A roda de bandeiras dissolve um cartão antes que a borda do ecrã o corte, o local recomendado veste a marca da Mozilla num tamanho legível e a borda sul do mapa plano derrete-se na página em vez de acabar numa linha.';

  @override
  String get wn49States =>
      'Os dois designs de referência vestem os detalhes com que foram desenhados: o cartão do aether carrega as taxas da sessão como o de AetherST, o botão de energia respira com o brilho da referência e afunda sob o dedo, e a gota do zed se transforma entre suas formas enquanto o centro troca de si com um fade.';

  @override
  String get wn49Words =>
      '«A ligar» tem palavra em todo o lado agora: enquanto o túnel se constrói, o trilho do interruptor carrega «A ligar…», a marca do botão esvaece entre os seus estados, e o trilho respira ao ritmo próprio da ligação — nada desaparece sob o dedo.';

  @override
  String get wn49Sooner =>
      'O motor da ligação volta a ser o da versão original: o conjunto de retransmissões, as rotas alternativas e a memória delas, e o guarda dos pedidos repetidos levam o túnel — levanta-se mais cedo e aguenta.';

  @override
  String get wn49Mark =>
      'A localização recomendada veste a marca verdadeira da Mozilla VPN, e os botões de atualização vestem o glifo próprio da atualização.';

  @override
  String get wn50Notch =>
      'O traje dos dois designs sai da bagunça que guardava: a barra de entalhe do aether lê o centro do próprio círculo, o nome da aba escolhida veste a tinta da página nos dois visuais, e o brilho do círculo fica no círculo em vez de lavar o nome.';

  @override
  String get wn50Cards =>
      'A casa do zed dobra suas taxas dentro do bento: o cartão de taxas se une às duas células do bento e à linha da sessão, os últimos cartões da página liberam o assento do dock, e nada fica pela metade sob o dock quando a página rola até o fim.';

  @override
  String get wn50Veil =>
      'A faixa de status veste seu véu: o conteúdo desvanece sob o relógio em vez de colidir com ele, as páginas abertas do zed não começam mais sob o relógio, e suas ferramentas flutuantes mantêm livre o assento do dock.';

  @override
  String get wn50Ping =>
      'A pílula de ping do aether mede de novo com um toque, do jeito que a pílula da própria referência responde.';

  @override
  String get tapToChangeServer => 'Toque para mudar de servidor';

  @override
  String get wn51Smooth =>
      'A roda e a faixa de bandeiras giram como uma roda deve girar: o arrasto e a troca de país viajam agora no compositor — nada se remaqueta e nenhum brilho se redesenha enquanto as bandeiras giram; a roda gira suave e a página rola com ela.';

  @override
  String get wn51Zed =>
      'A casa do zed veste a estrutura da própria referência: os dois cartões de taxas ficam sob a marca (em repouso, nos seus zeros, quando o túnel descansa), a palavra do estado chega com a grande face do display sob a gota, e o lugar vive no brilhante cartão de servidor acima do dock — o chip pequeno e o nome repetido se foram.';

  @override
  String get wn51Aether =>
      'A casa do aether diz o lugar uma vez: a linha do nome repetido da faixa descansa, o cartão de status e o botão de energia guardam seus assentos, e a página se lê como uma coluna limpa.';

  @override
  String get wn51Veil =>
      'O véu do relógio cresceu um suspiro de altura e segura sua cor por toda a faixa do relógio: o conteúdo que rola por baixo dele desvanece inteiro, e suas palavras nunca alcançam o relógio.';

  @override
  String get wn52Speed =>
      'O túnel volta a correr à velocidade da própria rede: a interface da VPN fala o tamanho de pacote da linha (MTU 1500) em vez de um superdimensionado — os downloads retomam a velocidade plena e as chamadas seguem estáveis, sobretudo em dados móveis.';

  @override
  String get wn52Smart =>
      'O local mais rápido e o serviço recomendado escolhem de novo com honestidade: cada início mede os locais a fresco e leva o melhor de agora, em vez de cavalgar em silêncio o lugar escolhido antes.';

  @override
  String get wn52Motion =>
      'Trinta novas animações por todo o aplicativo: cada página e cartão pousa suave, os ladrilhos pressionados afundam e voltam, o ponto de conexão respira, as páginas abertas deslizam — todas param quando o sistema pede menos movimento.';

  @override
  String get wn52Pages =>
      'As páginas abertas chegam num deslize suave e o título da própria borda; ao gravar um ajuste, uma linha quieta percorre a secção.';

  @override
  String get wn56Button =>
      'O deslizador de ligação guarda a palavra durante todo o caminho — já não há um momento vazio entre «a ligar» e «ligado»: a palavra agora desliza entre os seus estados, e o escurecer de trabalho chega num fôlego.';

  @override
  String get wn56Capsule =>
      'A roda diz cada estado uma vez: sumiu a palavra de estado repetida sobre o deslizador — a própria pista a leva, e a página lê-se uma linha mais serena.';

  @override
  String get wn56Door =>
      'O teste de velocidade tem a sua própria porta no início: uma linha, um toque, e a medição abre-se — também antes da primeira ligação, não só quando o túnel corre.';

  @override
  String get wn56Wheel =>
      'A roda das bandeiras desliza: um impulso traz um país, e a aterragem assenta em vez de bater — o arrasto lê-se firme e estável, como um bom botão.';

  @override
  String get designGazette => 'Jornal';

  @override
  String get designGazetteDesc =>
      'Uma primeira página: o cabeçalho, as colunas pautadas e o carimbo de tinta — a calma do jornal, em papel e tinta';

  @override
  String get speedTestSizesTitle => 'Tamanho do teste';

  @override
  String get wn61Gta =>
      'O design GTA: o HUD do jogo — a roda de armas para as bandeiras, o túnel verde do radar, os painéis âmbar, a letra pesada e o seu próprio som';

  @override
  String get wn61Sound =>
      'O clique da roda: cada assento que o disco passa responde também ao ouvido';

  @override
  String get wn62Wheel =>
      'A roda de armas reconstruída: os assentos mantêm o espaçamento do jogo com qualquer número de países, o setor escolhido traz a cunha acesa da roda e um impulso arremessa o disco';

  @override
  String get wn62Map =>
      'O mapa da página inicial veste agora as cores de cada design — a água, a terra e a grade seguem o design da página';

  @override
  String get wn62HudMap =>
      'O mapa próprio do design GTA: a placa HUD do jogo — água profunda, costa neon, grade de radar âmbar e a varredura que percorre o mundo enquanto o túnel segue';

  @override
  String get wn62Aether =>
      'O controle de energia do design Aether reconstruído: o disco assenta num anel fino, o arco de ligação percorre o anel e a face usinada apanha a luz';

  @override
  String get wn62Gta =>
      'O painel de ligação GTA responde à mão — o painel inteiro cede ao tocar e a marca de energia recua enquanto a ligação é feita';

  @override
  String get speedTestSizeLight => 'Leve';

  @override
  String get speedTestSizeStandard => 'Padrão';

  @override
  String get speedTestSizeFull => 'Completo';

  @override
  String get speedTestJitter => 'Jitter';

  @override
  String gazetteEdition(int n) {
    return 'N.º $n';
  }

  @override
  String get gazetteBulletin => 'Boletim de segurança';

  @override
  String get gazetteLiveWire => 'Manchete ao vivo';

  @override
  String get wn56Speed =>
      'O teste de velocidade vive de novo: cada sentido mede na sua própria ligação e fala HTTP/1.1 simples, o envio já não morre quando a janela da descarga fecha — e o painel acrescenta o atraso do caminho, o jitter e um tamanho à escolha.';

  @override
  String get wn56Gazette =>
      'Um novo aspeto da casa: o jornal — uma primeira página com cabeçalho, colunas pautadas, teletipo ao vivo e o carimbo de tinta que pressiona quando o túnel corre.';

  @override
  String get designIos => 'iOS';

  @override
  String get designIosDesc =>
      'O próprio do sistema: tabelas agrupadas, o filete da barra de separadores, o cartão de estado e o botão cápsula — clareza na voz do sistema';

  @override
  String get gazetteSection => 'SEÇÃO';

  @override
  String get wn58Lock =>
      'O cadeado do botão mantém a sua tinta quando o túnel corre: a marca lê agora a superfície onde pisa — escura em botão claro, branca em escuro — o ícone nunca mais se afoga.';

  @override
  String get wn58Enter =>
      'A secção ligada respira: os números desvanecem e elevam-se enquanto o espaço cresce por baixo, e saem da mesma forma — os cartões deixaram de saltar entre dois fotogramas.';

  @override
  String get wn58Speed =>
      'O teste de velocidade corre mais leve: o painel repinta dez vezes por segundo no máximo, o ponteiro do varrimento anda em linha reta curta, e as faces fundem-se em vez de saltar.';

  @override
  String get wn58Ios =>
      'Um design novo: iOS — o próprio do sistema, das tabelas agrupadas e do filete da barra ao cartão de estado com o botão cápsula. Cada página, cartão, diálogo e ícone na voz do sistema, nos dois modos.';

  @override
  String get wn58Pixel =>
      'Um design novo: Pixel — o estilo Material You, superfícies tonais, cartões grandes e cheios, a barra de indicador pastilha e os títulos grandes. Cada página, cartão, diálogo e ícone na voz própria do Android, nos dois modos.';

  @override
  String get wn58Paper =>
      'O jornal é agora um jornal inteiro: a sua própria barra de secções com a vírgula impressa e o sublinhado, cabeçalho de secção para cada página aberta, e a caixa de papel pautada para cada grupo de definições — as linhas da imprensa chegaram a toda a app.';

  @override
  String get wn59Flags =>
      'As bandeiras vestem o corte de cada design: a medalha redonda no iOS e no aether, o squircle no zed, a placa pautada no gazette, os grandes arredondados do pixel — a roda, a fita e a bandeirola de cada linha seguem-nos.';

  @override
  String get wn59Map =>
      'O mapa-múndi é desenhado com a tinta do próprio design: o castanho quente do papel no gazette, o cinza da noite violeta no zed, o azulado tonal no pixel — o mundo de cada design pertence à sua página.';

  @override
  String get wn59Buttons =>
      'Os botões de ligação falam a voz do seu design: a grande pílula tonal do Material You no pixel, a cápsula do iOS que respira enquanto a ligação se estabelece, e os cartões de cada página a entrar com o movimento do seu design.';

  @override
  String get wn59Scroll =>
      'As rodas e as fitas rolam com a física do seu design: o salto do sistema, a paragem rápida do Material e o peso do papel que morre na dobra.';

  @override
  String get flagAllPlaces => 'Todos os lugares';

  @override
  String get gazetteRegions => 'Destinos';

  @override
  String get wn60Flags =>
      'Cada design agora mostra os países à sua maneira: o quadro de mosaicos do bento, os chips de filtro do pixel, as opções de cápsula do aether, o baralho de medalhas do iOS, o quadro paginado do zed e o índice de destinos da gaceta impresso como o próprio papel — a roda mantém a sua roda.';

  @override
  String get wn60Bento =>
      'O design bento permanece inteiro: a sua própria paleta calorosa de porcelana e carvão, a luz tangerina, a doca de mosaicos, os cabeçalhos de página squircle, os cartões tingidos e o quadro de bandeiras — cada página, em ambos os modos.';

  @override
  String get wn60Spacing =>
      'As páginas iniciais caminham num só ritmo: as faixas mortas entre as seções se foram, os cartões finais preenchem suas filas e cada vão respira com o espaçamento que o design guarda.';

  @override
  String get wn63Retired =>
      'Os designs aether e zed aposentaram: seus usuários vão para os designs que vestem sua estrutura — as tabelas do aether para o iOS, o bento do zed para o Bento';

  @override
  String get wn63Map =>
      'O mapa GTA lê-se como o do jogo: cada fronteira como estrada, um marcador âmbar em cada país de servidor, o lugar escolhido como waypoint com o seu feixe e o nome na placa, a bússola no canto';

  @override
  String get wn63Servers =>
      'A página de servidores veste a lista própria de cada design — a tabela agrupada do iOS, o índice pautado da gazeta, as vagas HUD do GTA, os cartões tonais do pixel, a prancha do bento';

  @override
  String get wn63Accounts =>
      'A página de contas também veste o design: os cartões no arredondado próprio do design, o botão de adicionar na voz do design, os títulos dos diálogos na face de exibição, os campos na moldura do design';

  @override
  String get wn63Wheel =>
      'A roda de armas reconstruída à medida do jogo: o círculo completo dos divisores, a cunha acesa em duas camadas, o arco do contador, o salto da abertura e o pulso da escolha';

  @override
  String get wn63Ios =>
      'O design iOS fica mais cheio: a lavagem de estado no cartão de status, os pontos de página do baralho de medalhas, o tique a cada encaixe';

  @override
  String get wn64Wheel =>
      'As medalhas da roda GTA sentam-se agora dentro do disco — doze lugares no ritmo do próprio jogo, nenhuma medalha na borda nem além da tela, e nenhuma encosta na vizinha';

  @override
  String get wn64Glass =>
      'A roda veste o vidro do jogo: o mundo desfoca suave sob o mostrador, a placa é um pouco translúcida, o brilho dela se reúne no topo';

  @override
  String get wn64Groups =>
      'Os grupos da própria home do iOS: a tabela da sessão — o endereço do túnel, um toque para a área de transferência — e as ações rápidas: o teste de velocidade, os ajustes de conexão, as contas';

  @override
  String get wn64Headers =>
      'O cabeçalho de cada página volta a ocupar a largura da página — a seta de volta fica na sua borda, não no meio da tela';

  @override
  String get wn64Pill =>
      'O rótulo da pílula Material You guarda seu respiro dentro das pontas arredondadas';

  @override
  String get wn64Map =>
      'As fronteiras do mapa GTA voltam à sua primeira veste — a costa guarda seu neon e a terra sua borda de tinta fina';

  @override
  String get wn64Name =>
      'O design Pixel responde pelo próprio nome: Material You';

  @override
  String get wn65Gone =>
      'O design GTA partiu: sua página inicial, suas páginas, sua paleta — ficam cinco designs, e um arquivo de ajustes que ainda o nomeie cai na roda';

  @override
  String get wn65Tight =>
      'A página inicial fica mais compacta em todos os designs: as faixas nuas que o resto da tela abria entre os cartões desapareceram — a roda, as peças, o jornal, as medalhas e os chips se seguem a um suspiro de distância, e a página rola onde antes se esticava';

  @override
  String get wn65Radar =>
      'O mapa que o design GTA carregava agora se sustenta com nome próprio: o radar — a mesma água profunda, a grade âmbar e a varredura, agora com seu próprio nome no seletor de mapas';

  @override
  String get wn67Port =>
      'A definição da porta de conexão parte: os servidores só respondem na porta que a própria lista de servidores lhes dá — forçar uma porta fechava todas as ligações, e uma configuração que ainda a traga larga-a no primeiro arranque';

  @override
  String get wn67Back =>
      'A ligação volta ao seu lugar — todo o resto fica onde o 1.0.65 deixou: os cinco designs, o mapa radar e o túnel estável';

  @override
  String get designUr =>
      'URnetwork';

  @override
  String get designUrDesc =>
      'Rosto da URnetwork: botão de conexão redondo, cartão de local e painel de estatísticas ao vivo deslizante';

  @override
  String get urConnect =>
      'Conectar';

  @override
  String get urDisconnect =>
      'Desconectar';

  @override
  String get urChangeLocation =>
      'Alterar';

  @override
  String get urStatsTitle =>
      'Estatísticas ao vivo';

  @override
  String get urStatsHint =>
      'Deslize para cima';

  @override
  String get urSpeedUp =>
      'Envio';

  @override
  String get urSpeedDown =>
      'Receção';

  @override
  String get urSessionTime =>
      'Conectado há';

  @override
  String get urSessionData =>
      'Dados da sessão';

  @override
  String get urExitLocation =>
      'Local de saída';

  @override
  String get urLastTest =>
      'Último teste';

  @override
  String get urNoData =>
      'Ainda sem dados';

  @override
  String get changeUi =>
      'Mudar UI/UX';

  @override
  String get wn68Toast =>
      'As notas flutuantes abandonam o desfoque: um efeito pesado a menos em cada aviso, os telefones fracos mantêm os seus quadros';

  @override
  String get wn68Stats =>
      'Arraste para cima a borda inferior da página inicial: velocidades ao vivo, a linha da sessão, o local de saída, o IP e o último teste — nada que o núcleo já não diga';

  @override
  String get wn68Ur =>
      'O design URnetwork entra no seletor: o botão de conexão redondo cujos pontos se reúnem quando o túnel chega, o cartão de local e o «Conectar» largo — escolha-o em Aparência';
}
