// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Homa VPN';

  @override
  String get slideToConnect => 'Glissez pour connecter';

  @override
  String get slideToDisconnect => 'Glissez pour déconnecter';

  @override
  String get navOverview => 'Aperçu';

  @override
  String get navAccounts => 'Comptes';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get stateConnected => 'Connecté';

  @override
  String get stateConnecting => 'Connexion…';

  @override
  String get stateWaiting => 'En attente';

  @override
  String get waitingForAccount =>
      'Ajoutez un Firefox Account sur la page Comptes pour vous connecter.';

  @override
  String get waitingForEnabledAccount =>
      'Tous les comptes sont désactivés. Activez-en un sur la page Comptes.';

  @override
  String get stateError => 'Erreur';

  @override
  String get stateUnknown => 'Inconnu';

  @override
  String get restartProxy => 'Redémarrer le proxy';

  @override
  String copied(String value) {
    return '$value copié';
  }

  @override
  String get activeAccount => 'Compte actif';

  @override
  String get noActiveAccount => 'Aucun compte actif';

  @override
  String get quotaNotRead => 'Consommation pas encore vérifiée';

  @override
  String get unlimited => 'Illimité';

  @override
  String usedOf(String used, String limit) {
    return '$used utilisés sur $limit';
  }

  @override
  String resets(String date) {
    return 'remise à zéro le $date';
  }

  @override
  String switchAt(int percent) {
    return 'Changement de compte à $percent %';
  }

  @override
  String get publicIp => 'IP publique';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String get testing => 'Test en cours…';

  @override
  String get testFailed => 'Échec';

  @override
  String milliseconds(int value) {
    return '$value ms';
  }

  @override
  String get justNow => 'à l\'instant';

  @override
  String minutesAgo(int n) {
    return 'il y a $n min';
  }

  @override
  String hoursAgo(int n) {
    return 'il y a $n h';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String atTime(String time) {
    return 'à $time';
  }

  @override
  String durationDays(int d, int h) {
    return '$d j $h h';
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
    return 'Chaque Firefox Account dispose de $size de données par mois. Vous pouvez en ajouter plusieurs : quand l’un est épuisé, l’application passe d’elle-même au suivant.';
  }

  @override
  String accountsOrderNote(int percent) {
    return 'Dans l’ordre de cette liste : chacun jusqu’à $percent %, le dernier jusqu’à épuisement de ses données.';
  }

  @override
  String get addAccount => 'Ajouter un compte';

  @override
  String lowQuotaNotice(String size) {
    return 'Les données de ce compte sont presque épuisées. Ajoutez un autre compte pour obtenir $size de plus.';
  }

  @override
  String get noAccounts => 'Aucun compte pour l\'instant';

  @override
  String get noAccountsHint =>
      'Ajoutez un Firefox Account pour vous connecter.';

  @override
  String get delayTestFailed =>
      'Impossible de mesurer le délai des serveurs. Vérifiez votre connexion.';

  @override
  String get createAccountTitle => 'Pas de Firefox Account ?';

  @override
  String get createAccountHint =>
      'Créez-en un gratuitement sur accounts.firefox.com, puis revenez et appuyez sur Ajouter un compte.';

  @override
  String get moveUp => 'Monter';

  @override
  String get moveDown => 'Descendre';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusNeedsSignIn => 'Reconnexion requise';

  @override
  String get statusReserved => 'Réservé';

  @override
  String get statusUnavailable => 'Indisponible';

  @override
  String statusUnavailableUntil(String date) {
    return 'Indisponible jusqu\'au $date';
  }

  @override
  String get statusDisabled => 'Désactivé';

  @override
  String get statusEnabled => 'Activé';

  @override
  String get useNow => 'Utiliser maintenant';

  @override
  String get signInAgain => 'Se reconnecter';

  @override
  String reasonQuotaThreshold(int percent) {
    return 'Ce compte a utilisé $percent % de ses données ; le compte suivant a pris le relais.';
  }

  @override
  String get reasonQuotaExhausted =>
      'Les données du mois sont épuisées ; il sera réutilisé après la remise à zéro mensuelle.';

  @override
  String get reasonSignInRequired =>
      'Reconnectez-vous pour utiliser ce compte.';

  @override
  String get reasonSignInConfirm =>
      'Mozilla demande de confirmer la connexion : appuyez sur « Se reconnecter » (seul le code est nécessaire).';

  @override
  String reasonSignInFailed(String detail) {
    return 'La connexion automatique a échoué ($detail). Reconnectez-vous.';
  }

  @override
  String reasonSignInWait(String time) {
    return 'La dernière connexion automatique a cessé de fonctionner peu après ; prochain essai à $time.';
  }

  @override
  String reasonSignInRetry(String detail, String time) {
    return 'La connexion automatique n’a pas abouti ($detail) ; nouvel essai à $time.';
  }

  @override
  String get reasonNotEntitled =>
      'Mozilla a refusé ce compte ; nouvel essai plus tard.';

  @override
  String get more => 'Plus';

  @override
  String get refreshQuota => 'Actualiser la consommation';

  @override
  String get remove => 'Supprimer';

  @override
  String get removeTitle => 'Supprimer le compte ?';

  @override
  String removeBody(String name) {
    return '$name et ses identifiants enregistrés seront supprimés de cet appareil. Vous pourrez l\'ajouter à nouveau plus tard.';
  }

  @override
  String get unlimitedQuota => 'Données illimitées';

  @override
  String get signInTitle => 'Connexion au compte';

  @override
  String get signInIntro => 'Connectez-vous avec un Firefox Account.';

  @override
  String get email => 'E-mail';

  @override
  String get emailInvalid => 'Saisissez l\'e-mail du compte';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordEmpty => 'Saisissez le mot de passe';

  @override
  String get show => 'Afficher';

  @override
  String get hide => 'Masquer';

  @override
  String get signIn => 'Se connecter';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get done => 'Terminé';

  @override
  String get close => 'Fermer';

  @override
  String get noBrowserTitle => 'Pas de navigateur sur cet appareil';

  @override
  String get noBrowserText =>
      'Ouvrez cette adresse sur votre téléphone ou votre ordinateur :';

  @override
  String get cancel => 'Annuler';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get signingIn => 'Connexion au compte…';

  @override
  String get accountReady => 'Compte prêt';

  @override
  String get accountReadyHint => 'Il a été ajouté en fin de liste.';

  @override
  String get captchaLabel => 'Caractères de l\'image';

  @override
  String get codeLabel => 'Code';

  @override
  String get captchaBroken => 'L\'image CAPTCHA n\'a pas pu être affichée.';

  @override
  String stepEmailCode(String email) {
    return 'Mozilla a envoyé un code à $email. Saisissez-le ici.';
  }

  @override
  String get stepTotp =>
      'Saisissez le code de votre application d\'authentification.';

  @override
  String stepUnblockCode(String email) {
    return 'Mozilla juge cette connexion inhabituelle et a envoyé un code de déblocage à $email. Saisissez-le ici.';
  }

  @override
  String get stepCaptcha => 'Tapez les caractères de l\'image.';

  @override
  String stepEmailLink(String email) {
    return 'Ouvrez le lien de confirmation envoyé par Mozilla à $email. La suite se fait automatiquement.';
  }

  @override
  String get signInFailed => 'Le compte n\'a pas été ajouté.';

  @override
  String get signInCancelled => 'Connexion annulée.';

  @override
  String get signInNoAccount =>
      'Aucun Firefox Account n\'existe pour cette adresse.';

  @override
  String get signInNoAccountHint =>
      'Vérifiez l\'adresse, ou créez avec elle un Firefox Account gratuit sur le site de Mozilla, confirmez-le depuis votre boîte de réception, puis ajoutez-le ici.';

  @override
  String get createAccountButton => 'Créer un Firefox Account';

  @override
  String get signInWrongPassword => 'Mot de passe incorrect.';

  @override
  String get signInNoPassword =>
      'Ce compte n\'a pas de mot de passe : il a été créé avec la connexion Google ou Apple. Définissez un mot de passe, puis connectez-vous ici avec.';

  @override
  String get setPasswordButton => 'Définir un mot de passe';

  @override
  String get signInTooManyAttempts =>
      'Trop de tentatives. Patientez un peu, puis réessayez.';

  @override
  String get signInUnblockRejected =>
      'Le code de déblocage n\'a pas été accepté. Utilisez le code du dernier e-mail de Mozilla.';

  @override
  String get signInWrongCode =>
      'Code incorrect ou expiré. Utilisez le code du dernier e-mail de Mozilla ; un ancien code ne fonctionne plus dès qu\'un nouveau est envoyé.';

  @override
  String get signInWrongTotp =>
      'Code incorrect. Saisissez le code que l\'application d\'authentification affiche maintenant.';

  @override
  String get signInTooManyCodes =>
      'Trop de codes incorrects. Recommencez la connexion.';

  @override
  String get signInTimedOut =>
      'La connexion a pris trop de temps. Recommencez.';

  @override
  String get signInNetwork =>
      'Impossible de joindre Mozilla. Vérifiez votre accès à Internet et réessayez.';

  @override
  String get coreConnecting => 'Connexion au moteur…';

  @override
  String get coreLost => 'Connexion au moteur perdue. Nouvelle tentative…';

  @override
  String get cantReachCore => 'Impossible de joindre le moteur';

  @override
  String get startingCore => 'Démarrage du moteur…';

  @override
  String get retry => 'Réessayer';

  @override
  String errNoCore(String path) {
    return 'Le moteur est introuvable dans le dossier de l\'application ($path).';
  }

  @override
  String errCoreExited(String detail) {
    return 'Le moteur s\'est arrêté : $detail';
  }

  @override
  String get errNotAnswering => 'Le moteur ne répond pas.';

  @override
  String get errRefused =>
      'Le moteur a refusé l\'application ; il appartient peut-être à une autre installation.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get sectionGeneral => 'Général';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get closeBehavior => 'À la fermeture de la fenêtre';

  @override
  String get closeAsk => 'Toujours demander';

  @override
  String get closeTray => 'Réduire dans la zone de notification';

  @override
  String get closeQuit => 'Quitter l\'application';

  @override
  String get sectionConnection => 'Connexion';

  @override
  String get localProxy => 'Proxy local';

  @override
  String get systemProxy => 'Proxy système';

  @override
  String get sectionRouting => 'Routage';

  @override
  String get routingDirect => 'Connexion directe pour les sites locaux';

  @override
  String get routingDirectHint =>
      'Les sites et IP du pays choisi contournent le VPN : ils s\'ouvrent plus vite et vous économisez des données.';

  @override
  String get region => 'Pays';

  @override
  String get regionIr => 'Iran';

  @override
  String get regionCn => 'Chine';

  @override
  String get regionRu => 'Russie';

  @override
  String get regionAf => 'Afghanistan';

  @override
  String get regionTr => 'Turquie';

  @override
  String get regionId => 'Indonésie';

  @override
  String get regionBr => 'Brésil';

  @override
  String get regionNone => 'Aucun';

  @override
  String get saved => 'Enregistré';

  @override
  String get dataFolder => 'Dossier de données';

  @override
  String get openFolder => 'Ouvrir le dossier';

  @override
  String get unofficialNote => 'Client non officiel. Non affilié à Mozilla.';

  @override
  String get closeTitle => 'Fermer la fenêtre ?';

  @override
  String get closeBody =>
      'Réduite dans la zone de notification, l\'application garde le VPN connecté. Si vous quittez, le VPN se déconnecte.';

  @override
  String get rememberChoice => 'Mémoriser mon choix';

  @override
  String get minimizeToTray => 'Réduire';

  @override
  String get quit => 'Quitter';

  @override
  String get trayOpen => 'Ouvrir';

  @override
  String get trayQuit => 'Quitter';

  @override
  String get trayProxyOnly => 'Service proxy seul';

  @override
  String get traySetSystemProxy => 'Définir le proxy système';

  @override
  String errPortInUse(String port) {
    return 'Le port $port est utilisé par un autre programme ; l\'application ne peut donc pas joindre son moteur.';
  }

  @override
  String proxyPortInUse(String port) {
    return 'Le port $port est utilisé par un autre programme ; le proxy ne peut donc pas démarrer.';
  }

  @override
  String get changePort => 'Changer de port';

  @override
  String get portDialogTitle => 'Choisir un port';

  @override
  String portDialogBody(String port) {
    return 'Le port $port est occupé. Un port libre est proposé ci-dessous ; vous pouvez en saisir un autre.';
  }

  @override
  String get portChangeBody =>
      'Les applications se connectent à ce port. Choisissez-en un entre 1024 et 65535.';

  @override
  String get portLabel => 'Port';

  @override
  String get portInvalid => 'Saisissez un port entre 1024 et 65535';

  @override
  String get portBusy => 'Ce port est aussi occupé';

  @override
  String get portInUse => 'Un autre programme utilise ce port';

  @override
  String get save => 'Enregistrer';

  @override
  String get proxyPort => 'Port du proxy';

  @override
  String get appPort => 'Port de l\'application';

  @override
  String get welcomeTitle => 'Bienvenue';

  @override
  String get welcomeBody =>
      'Choisissez votre langue et votre pays. Les sites de votre pays s\'ouvrent directement, sans le VPN : c\'est plus rapide et vous économisez des données.';

  @override
  String get start => 'Commencer';

  @override
  String routingSuggestTitle(String country) {
    return 'Connexion directe pour $country ?';
  }

  @override
  String routingSuggestBody(String country) {
    return 'Les sites et IP locaux ($country) s\'ouvriraient directement, sans le VPN. Vous pourrez modifier cela dans Routage.';
  }

  @override
  String get yes => 'Oui';

  @override
  String get notNow => 'Plus tard';

  @override
  String get navServers => 'Serveurs';

  @override
  String get navLogs => 'Journaux';

  @override
  String get realDelay => 'Latence réelle';

  @override
  String get statElapsed => 'Durée';

  @override
  String get statDown => 'Réception';

  @override
  String get statUp => 'Envoi';

  @override
  String noticePort(String port) {
    return 'Le proxy de Mozilla ne se connecte pas au port $port. Seuls les ports 80, 443, 8080 et 8443 passent par le VPN.';
  }

  @override
  String get noticeCommand =>
      'Ce type de connexion n\'est pas pris en charge par le VPN.';

  @override
  String noticeTimes(int count, String time) {
    return '$count fois, la dernière $time';
  }

  @override
  String get dismiss => 'Ignorer';

  @override
  String get modeRecommended => 'Recommandé';

  @override
  String get modeFastest => 'Le plus rapide';

  @override
  String get modeRecommendedHint => 'Mozilla choisit l\'emplacement pour vous.';

  @override
  String get modeFastestHint =>
      'L\'emplacement avec la latence la plus faible à chaque connexion.';

  @override
  String get testDelay => 'Tester la latence réelle';

  @override
  String get testingDelay => 'Mesure…';

  @override
  String get search => 'Rechercher';

  @override
  String get noAnswer => 'Pas de réponse';

  @override
  String testedAgo(String ago) {
    return 'Testé $ago';
  }

  @override
  String delaySummary(int answered, int total) {
    return '$answered sur $total ont répondu';
  }

  @override
  String get noServers =>
      'Aucun serveur pour l\'instant. Ils apparaîtront dès que la connexion à Mozilla sera établie.';

  @override
  String get levelAll => 'Tous';

  @override
  String get filter => 'Filtrer';

  @override
  String get follow => 'Défilement auto';

  @override
  String get clear => 'Effacer';

  @override
  String get copyAll => 'Tout copier';

  @override
  String get logsCopied => 'Journaux copiés';

  @override
  String get noLogs => 'Aucune ligne de journal pour l\'instant.';

  @override
  String get sectionAccounts => 'Changement automatique de compte';

  @override
  String get switchThreshold => 'Changer de compte à';

  @override
  String get switchThresholdHint =>
      'Le compte suivant prend le relais lorsque ce pourcentage des données est consommé.';

  @override
  String get signInMethod => 'Méthode de connexion';

  @override
  String get signInMethodBrowser => 'Connexion par le navigateur';

  @override
  String get signInMethodApi => 'Connexion directe';

  @override
  String get browserSignInBroken =>
      'La page de connexion n\'a pas pu être ouverte.';

  @override
  String get browserSignInBlocked =>
      'Mozilla n’a pas terminé la dernière étape de l’ajout du compte (HTTP 406).';

  @override
  String get browserSignInFallback => 'Connexion avec e-mail et mot de passe';

  @override
  String get backupExport => 'Enregistrer une sauvegarde';

  @override
  String get backupImport => 'Importer une sauvegarde';

  @override
  String backupSaved(String name) {
    return 'Enregistré : $name';
  }

  @override
  String get backupImportTitle => 'Ajouter ces comptes ?';

  @override
  String get backupAccountExists =>
      'Déjà ajouté ; sa connexion sera reprise du fichier';

  @override
  String get backupImportAction => 'Ajouter';

  @override
  String backupImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes ajoutés',
      one: '1 compte ajouté',
    );
    return '$_temp0';
  }

  @override
  String get sectionDns => 'DNS';

  @override
  String get dnsPreset => 'Serveurs DNS';

  @override
  String get dnsSystem => 'Système';

  @override
  String get dnsAuto => 'Auto (Cloudflare, Google, Quad9)';

  @override
  String get dnsCustom => 'Personnalisé';

  @override
  String get dnsCustomHint =>
      'Un par ligne : https://…/dns-query, tls://… ou une adresse IP.';

  @override
  String get dnsFallback => 'Utiliser le DNS du système en secours';

  @override
  String get testDns => 'Tester le DNS';

  @override
  String get transport => 'Protocole';

  @override
  String get transportH3 => 'HTTP/3 (QUIC)';

  @override
  String get ipVersion => 'Version IP';

  @override
  String get ipVersionAuto => 'Automatique (IPv4 d\'abord, puis IPv6)';

  @override
  String get ipVersionDual => 'Les deux à la fois (dual-stack)';

  @override
  String get ipVersionV6First => 'IPv6 d\'abord, puis IPv4';

  @override
  String get ipVersionV4 => 'IPv4 uniquement';

  @override
  String get ipVersionV6 => 'IPv6 uniquement';

  @override
  String get tunMtu => 'MTU';

  @override
  String get tunMtuHint =>
      'Taille des paquets de l\'interface VPN, de 1280 à 9000. Vide : automatique.';

  @override
  String get tunMtuInvalid => 'Un nombre de 1280 à 9000, ou vide';

  @override
  String get transportH2 => 'HTTP/2 (TCP)';

  @override
  String get transportH1 => 'HTTP/1.1 (TLS)';

  @override
  String get directRules => 'Direct';

  @override
  String get directRulesHint =>
      'Les sites et adresses de cette liste s’ouvrent sans le VPN, directement par votre propre connexion. Les règles du pays choisi y sont déjà : ajoutez, modifiez ou supprimez des lignes. Choisir un autre pays les remplace par les siennes.';

  @override
  String get restoreRegionRules => 'Rétablir les règles du pays';

  @override
  String get blockRules => 'Bloquer';

  @override
  String get blockRulesHint =>
      'Les sites et adresses de cette liste ne s’ouvrent pas du tout, ni directement ni par le VPN : pour les publicités ou les sites que vous ne voulez jamais ouvrir.';

  @override
  String get rulesTitle => 'Règles';

  @override
  String get ruleSyntaxTitle => 'Comment écrire une règle';

  @override
  String get resolveDomains => 'Appliquer les règles IP aux domaines';

  @override
  String get routingLists => 'Fichiers Geo';

  @override
  String get listSource => 'Source des listes';

  @override
  String get listSourceCustom => 'Saisie manuelle';

  @override
  String listsUpdatedAgo(String ago) {
    return 'Mis à jour $ago';
  }

  @override
  String get updateLists => 'Mettre à jour les fichiers Geo';

  @override
  String get listsUpdated => 'Les fichiers Geo ont été mis à jour.';

  @override
  String get testDestination => 'Vérifier le routage d\'un site';

  @override
  String get destinationHint => 'Un nom, une adresse ou une URL';

  @override
  String get check => 'Vérifier';

  @override
  String get routeDirect => 'Passe en direct';

  @override
  String get routeProxy => 'Passe par le VPN';

  @override
  String get routeBlock => 'Bloqué';

  @override
  String ruleMatched(String rule) {
    return 'Règle : $rule';
  }

  @override
  String get portRefusedNote =>
      'Le proxy de Mozilla ne se connecte pas à ce port.';

  @override
  String get sectionAdvanced => 'Avancé';

  @override
  String get tlsFragment => 'Fragmentation TLS';

  @override
  String get tlsFragmentOff => 'Désactivé';

  @override
  String get tlsFragmentFirstByte => 'Premier octet';

  @override
  String get tlsFragmentSni => 'Nom du serveur (SNI)';

  @override
  String get tlsFragmentFirstByteHint =>
      'Coupe l\'en-tête TLS au premier octet (0x16)';

  @override
  String get tlsFragmentSniHint =>
      'Répartit le nom du serveur (SNI) sur plusieurs paquets TCP';

  @override
  String get tlsFragmentRecord => 'Enregistrement TLS';

  @override
  String get tlsFragmentRecordHint =>
      'Répartit le nom du serveur (SNI) sur deux enregistrements TLS';

  @override
  String get tlsFragmentOffHint => 'Connexion TLS normale';

  @override
  String get sectionBypass => 'Si Mozilla est bloqué';

  @override
  String get sharedRelay => 'Relais partagé';

  @override
  String get sharedRelayHint =>
      'Utiliser les relais partagés de l’application si Mozilla bloque votre région. Un relais personnel activé est prioritaire.';

  @override
  String get personalRelay => 'Relais personnel';

  @override
  String get apiRelay => 'Serveur relais';

  @override
  String get apiRelayUse => 'Utiliser le serveur relais';

  @override
  String get apiRelayHint =>
      'Votre propre Cloudflare Worker, ou relay.php sur votre hébergement.\nUtilisé seulement quand Mozilla ne répond pas directement : la connexion, les comptes et la liste des serveurs passent par lui, pas le trafic du VPN.';

  @override
  String get upstreamProxy => 'Proxy amont';

  @override
  String get upstreamProxyOn => 'Proxy amont activé';

  @override
  String get upstreamProxyAddress => 'Adresse SOCKS5';

  @override
  String get upstreamProxyPort => 'Port';

  @override
  String get upstreamProxyHint =>
      'La connexion à Mozilla passe par ce proxy, pour les réseaux qui bloquent ou ralentissent Mozilla.\nSi le proxy tourne sur cet appareil, laissez-le hors du VPN.';

  @override
  String get upstreamProxyInvalid =>
      'Saisissez l\'adresse du proxy, par exemple 127.0.0.1.';

  @override
  String get upstreamProxyInvalidPort => 'Saisissez un port de 1 à 65535.';

  @override
  String get upstreamProxyOwn =>
      'C\'est le proxy de cette application. Saisissez-en un autre.';

  @override
  String get apiRelayInvalid => 'Doit être une adresse https://.';

  @override
  String get listenAddress => 'Accès au proxy';

  @override
  String get listenLocal => '127.0.0.1 · cet appareil uniquement';

  @override
  String get listenAll => '0.0.0.0 · tous les réseaux (LAN)';

  @override
  String get proxyUsername => 'Nom d\'utilisateur du proxy';

  @override
  String get proxyPassword => 'Mot de passe du proxy';

  @override
  String get proxyLoginHint =>
      'Les applications doivent s\'identifier avec ces informations. Laissez les deux vides pour ne pas exiger d\'identification.';

  @override
  String get loginBothOrNone =>
      'Remplissez les deux, ou laissez les deux vides.';

  @override
  String get proxyLogin => 'Identifiants du proxy';

  @override
  String get idleSleep => 'Veille après inactivité';

  @override
  String get sleepNever => 'Jamais';

  @override
  String sleepMinutes(int count) {
    return '$count minutes';
  }

  @override
  String get sleepHour => '1 heure';

  @override
  String get showPublicIp => 'Afficher l\'IP publique';

  @override
  String get hapticFeedback => 'Vibrer lorsque la connexion change';

  @override
  String get keepScreenOn => 'Garder l\'écran allumé pendant la connexion';

  @override
  String get showTraffic =>
      'Afficher le trafic en direct sur la page d\'accueil';

  @override
  String get speedInNotification => 'Afficher la vitesse dans la notification';

  @override
  String get liveTraffic => 'Trafic en direct';

  @override
  String get totalTraffic => 'Trafic total';

  @override
  String get verboseLogs => 'Journaux détaillés';

  @override
  String get webDashboard => 'Tableau de bord web';

  @override
  String get webDashboardOpen => 'Ouvrir';

  @override
  String get webDashboardHint => 'Paramètres avancés et plus d\'outils';

  @override
  String numberInvalid(int min, int max) {
    return 'Saisissez un nombre entre $min et $max';
  }

  @override
  String get notifySwitchedTitle => 'Changement de compte';

  @override
  String notifySwitchedBody(String name) {
    return 'Vous utilisez maintenant $name.';
  }

  @override
  String get notifySignInTitle => 'Reconnexion requise';

  @override
  String get notifySignInBody => 'Reconnectez un compte sur la page Comptes.';

  @override
  String get navAbout => 'À propos';

  @override
  String get appVersionLabel => 'Version de l\'application';

  @override
  String get coreVersionLabel => 'Version du moteur';

  @override
  String get checkUpdates => 'Rechercher des mises à jour';

  @override
  String get checkingUpdates => 'Vérification…';

  @override
  String get upToDate => 'Vous avez la dernière version.';

  @override
  String updateAvailable(String version) {
    return 'La version $version est disponible.';
  }

  @override
  String updateRequired(String version) {
    return 'Veuillez passer à la version $version. Cette mise à jour est nécessaire.';
  }

  @override
  String get download => 'Télécharger';

  @override
  String updateCheckFailed(String error) {
    return 'Impossible de rechercher des mises à jour : $error';
  }

  @override
  String get updateCheckNoNetwork =>
      'Impossible de joindre GitHub. Vérifiez votre connexion internet et réessayez.';

  @override
  String get updateNow => 'Mettre à jour';

  @override
  String updateDownloading(String version) {
    return 'Téléchargement de la version $version…';
  }

  @override
  String updateReady(String version) {
    return 'La version $version est prête à être installée.';
  }

  @override
  String updateInstalling(String version) {
    return 'Installation de la version $version. L\'application va se fermer puis se rouvrir.';
  }

  @override
  String updateFailed(String version) {
    return 'Impossible de passer à la version $version.';
  }

  @override
  String updateDone(String version) {
    return 'Mise à jour vers la version $version effectuée.';
  }

  @override
  String updateRolledBack(String version) {
    return 'La mise à jour vers la version $version n\'a pas abouti : l\'application est revenue à la version précédente.';
  }

  @override
  String get repoNotSet => 'Le dépôt GitHub n\'est pas encore défini.';

  @override
  String get sourceCode => 'Code source';

  @override
  String get tapToConnect => 'Cliquez pour vous connecter';

  @override
  String get tapToDisconnect => 'Cliquez pour vous déconnecter';

  @override
  String get startOnBoot => 'Lancer au démarrage';

  @override
  String get connectOnStartup => 'Se connecter au démarrage';

  @override
  String get proxyServiceActive => 'Service proxy actif';

  @override
  String get navHome => 'Accueil';

  @override
  String get groupApp => 'Application';

  @override
  String get groupNetwork => 'Réseau';

  @override
  String get stateOff => 'Déconnecté';

  @override
  String get tapToConnectPhone => 'Touchez pour vous connecter';

  @override
  String get tapToDisconnectPhone => 'Touchez pour vous déconnecter';

  @override
  String get tapToConnectTv => 'Appuyez sur OK pour vous connecter';

  @override
  String get tapToDisconnectTv => 'Appuyez sur OK pour vous déconnecter';

  @override
  String lanAddress(String address) {
    return 'LAN $address';
  }

  @override
  String get recommendedLocation => 'Emplacement recommandé';

  @override
  String dataLeftOf(String limit) {
    return 'sur $limit';
  }

  @override
  String get homeLocation => 'Emplacement';

  @override
  String get connectedTo => 'Connecté à';

  @override
  String get vpnNotAllowed =>
      'Le VPN a besoin de votre autorisation. Touchez à nouveau le bouton et autorisez-le.';

  @override
  String get dataUsedTitle => 'Données utilisées';

  @override
  String get bypassApps => 'Proxy par application';

  @override
  String get connectRetrying =>
      'Connexion impossible. Vérifiez votre internet.';

  @override
  String get failUnreachable =>
      'Impossible de joindre les serveurs de Mozilla. Essayez une autre connexion Internet.';

  @override
  String get failUpstreamProxy =>
      'Impossible de joindre Mozilla via le proxy amont. Vérifiez qu\'il fonctionne.';

  @override
  String get failInsideVpn =>
      'Cette connexion passe déjà par un VPN. Désactivez-le.';

  @override
  String get failRefused =>
      'Le serveur de Mozilla a refusé la connexion. Réessayez dans quelques minutes.';

  @override
  String get failLocationRefused =>
      'Ce pays n\'est pas ouvert à votre compte. Choisissez un autre pays.';

  @override
  String get useRecommendedLocation => 'Utiliser l\'emplacement recommandé';

  @override
  String exitMismatch(String exit, String chosen) {
    return 'Pays choisi : $chosen ; pays de votre IP : $exit.';
  }

  @override
  String get failSignIn =>
      'La connexion de ce compte a expiré. Reconnectez-vous depuis la page Comptes.';

  @override
  String get failQuota =>
      'Les données de ce mois sont épuisées. Ajoutez un autre compte.';

  @override
  String get failNotEntitled =>
      'Mozilla n\'autorise pas ce compte à utiliser le VPN. Ajoutez un autre compte.';

  @override
  String get failRegion =>
      'Mozilla ne propose pas son service dans votre pays.';

  @override
  String get failServer =>
      'Le service de Mozilla a un problème temporaire. L\'application réessaie d\'elle-même.';

  @override
  String get failNoAccount =>
      'Aucun compte n\'est prêt. Ouvrez la page Comptes.';

  @override
  String get failTestSite =>
      'Connecté au serveur, mais les sites ne s\'ouvrent pas. Essayez un autre pays.';

  @override
  String get failOther => 'Connexion impossible. Réessayez.';

  @override
  String get failNoInternet =>
      'Pas d\'internet. Vérifiez le Wi-Fi ou les données mobiles.';

  @override
  String get waitingForNetwork => 'En attente d\'une connexion internet…';

  @override
  String proxyStartFailed(String port) {
    return 'Le proxy n\'a pas pu démarrer sur le port $port. Choisissez un autre port.';
  }

  @override
  String get connectionSettings => 'Paramètres de connexion';

  @override
  String get appModeExclude => 'Exclure les applications choisies';

  @override
  String get appModeInclude => 'VPN uniquement pour les applications choisies';

  @override
  String get appModeExcludeHint =>
      'Les applications choisies se connectent directement, sans le VPN : par exemple les applications bancaires qui refusent les adresses étrangères.';

  @override
  String get appModeIncludeHint =>
      'Seules les applications choisies passent par le VPN ; les autres se connectent directement.';

  @override
  String fromRegionList(String region) {
    return 'Suggérée : liste $region';
  }

  @override
  String get modeProxy => 'Proxy';

  @override
  String get connectionMode => 'Mode de connexion';

  @override
  String get modeProxyHint =>
      'Seules les applications configurées pour utiliser le proxy passent par lui.';

  @override
  String get modeSystemProxyHint =>
      'Windows et la plupart des applications passent par le proxy.';

  @override
  String get modeSystemProxyHintOther =>
      'Les navigateurs et la plupart des applications passent par le proxy.';

  @override
  String get suggestedApps => 'Applications suggérées';

  @override
  String get showSystemApps => 'Afficher les applis système';

  @override
  String suggestedAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count applications suggérées sélectionnées',
      one: '1 application suggérée sélectionnée',
      zero: 'Les applications suggérées sont déjà sélectionnées',
    );
    return '$_temp0';
  }

  @override
  String get autoSection => 'Automatique';

  @override
  String get locationsSection => 'Emplacements';

  @override
  String get dnsSummaryOk => 'Le DNS chiffré fonctionne';

  @override
  String dnsSummaryFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count noms n\'ont pas été résolus',
      one: '1 nom n\'a pas été résolu',
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
          'Le DNS de votre réseau a renvoyé une adresse de filtrage pour $count noms. L\'application ignore ces réponses.',
      one: 'Le DNS de votre réseau a renvoyé une adresse de filtrage pour 1 nom. L\'application ignore cette réponse.',
    );
    return '$_temp0';
  }

  @override
  String get dnsAnswer => 'Réponse :';

  @override
  String get dnsNetworkAnswer => 'DNS du réseau :';

  @override
  String get dnsFiltered => 'filtré';

  @override
  String get rulesSyntaxTitle => 'Une règle par ligne';

  @override
  String get ruleDomain => 'Le site et ses sous-domaines';

  @override
  String get ruleFull => 'Exactement ce nom';

  @override
  String get ruleKeyword => 'Noms contenant le mot';

  @override
  String get ruleGeosite => 'Sites d\'un tag dans les fichiers Geo';

  @override
  String get ruleGeoip => 'Adresses d\'un pays dans les fichiers Geo';

  @override
  String get ruleIp => 'Une adresse ou un réseau';

  @override
  String get modeVpn => 'VPN';

  @override
  String get modeProxyOnly => 'Proxy uniquement';

  @override
  String get noNetwork =>
      'Pas de connexion Internet. Activez le Wi-Fi ou les données mobiles.';

  @override
  String get blockAds => 'Bloquer les publicités';

  @override
  String systemProxyTakenBy(String address) {
    return 'Un autre programme a réglé le proxy système sur $address ; le trafic ne passe donc plus par le VPN.';
  }

  @override
  String get systemProxyTakenOff =>
      'Un autre programme a désactivé le proxy système ; le trafic ne passe donc plus par le VPN.';

  @override
  String get setSystemProxyAgain => 'Le régler à nouveau';

  @override
  String get modeTun => 'TUN';

  @override
  String modeTunHint(String os) {
    return 'Tout le trafic de $os passe par le VPN.';
  }

  @override
  String get osWindows => 'Windows';

  @override
  String get osLinux => 'Linux';

  @override
  String get osMacos => 'macOS';

  @override
  String get tunInstallWaiting =>
      'En attente de l\'autorisation d\'installer le service TUN…';

  @override
  String get tunInstallCancelled =>
      'Le mode TUN a besoin une fois de l\'autorisation administrateur. Elle n\'a pas été donnée : le mode n\'a pas changé.';

  @override
  String tunInstallFailed(String error) {
    return 'Impossible d\'installer le service TUN : $error';
  }

  @override
  String get tunStarting => 'Démarrage du mode TUN…';

  @override
  String get tunFailed => 'Le mode TUN n\'a pas pu démarrer. Nouvel essai…';

  @override
  String get tunLost =>
      'Le mode TUN s\'est arrêté de manière inattendue. Nouvel essai…';

  @override
  String get tunNotRunning => 'Le service TUN ne fonctionne pas. Nouvel essai…';

  @override
  String get tunMissing => 'Le service TUN n\'est pas installé.';

  @override
  String get tunOutdated =>
      'Le service TUN est plus ancien que cette application. Réinstallez-le pour utiliser le mode TUN.';

  @override
  String get tunAppOutdated =>
      'Le service TUN est plus récent que cette application. Mettez l\'application à jour pour utiliser le mode TUN.';

  @override
  String get tunBusy => 'Une autre copie de Homa VPN utilise le mode TUN.';

  @override
  String get tunNoDriver =>
      'Le pilote TUN du système n\'est pas disponible. Redémarrez l\'ordinateur et réessayez.';

  @override
  String get tunInstall => 'Installer';

  @override
  String get tunInstallAgain => 'Réinstaller';

  @override
  String get trayTunMode => 'Mode TUN (toutes les applications)';

  @override
  String get removeTunService => 'Supprimer le service TUN';

  @override
  String get removeTunServiceHint =>
      'Supprime le service système utilisé par le mode TUN. Choisir TUN à nouveau le réinstalle.';

  @override
  String get tunServiceRemoved => 'Le service TUN a été supprimé.';

  @override
  String get tunInstallPrompt =>
      'Homa VPN veut installer le service du mode TUN.';

  @override
  String get tunRemovePrompt =>
      'Homa VPN veut supprimer le service du mode TUN.';

  @override
  String tunRemoveFailed(String error) {
    return 'Impossible de supprimer le service TUN : $error';
  }

  @override
  String get sectionTun => 'Réglages TUN';

  @override
  String get tunPrograms => 'Programmes hors VPN';

  @override
  String get tunProgramsHint =>
      'Ils se connectent directement, sans passer par Mozilla. Seulement pour les programmes qui fonctionnent sans VPN.';

  @override
  String get tunProgramsEmpty => 'Aucun programme pour l\'instant.';

  @override
  String get addProgram => 'Ajouter un programme';

  @override
  String get programFiles => 'Programmes';

  @override
  String get tunProgramAll => 'Tout le trafic';

  @override
  String get tunProgramAllHint => 'Tout le programme se connecte directement.';

  @override
  String get tunProgramUdp => 'UDP uniquement';

  @override
  String get tunProgramUdpHint =>
      'Seul son UDP se connecte directement ; le reste passe par le VPN.';

  @override
  String get udpNoticeSetting => 'Avis si l\'UDP est bloqué';

  @override
  String udpNoticeBody(String program) {
    return 'Le trafic UDP de $program ne passe pas par le VPN.';
  }

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get addRunningProgram => 'Parmi les programmes en cours';

  @override
  String get addProgramFile => 'Choisir un fichier…';

  @override
  String get addProgramName => 'Saisir un nom…';

  @override
  String get programNameHint =>
      'Le nom de fichier d\'un programme, comme steam.exe ; * remplace n\'importe quel texte (steam* désigne tous les programmes de Steam).';

  @override
  String get runningProgramsEmpty => 'Aucun autre programme n\'est en cours.';

  @override
  String get tabLog => 'Journal';

  @override
  String get tabConnections => 'Connexions';

  @override
  String get connectionsEmpty => 'Aucune connexion pour l\'instant.';

  @override
  String connectionsOpen(int count) {
    return '$count ouvertes';
  }

  @override
  String get connTime => 'Heure';

  @override
  String get connRoute => 'Règle';

  @override
  String get connDestination => 'Destination';

  @override
  String get connInbound => 'Entrée';

  @override
  String get connProtocol => 'Protocole';

  @override
  String get connColumns => 'Colonnes';

  @override
  String get connTraffic => 'Trafic';

  @override
  String get connDuration => 'Durée';

  @override
  String get connRouteVpn => 'Proxy';

  @override
  String get connRouteDirect => 'Direct';

  @override
  String get connRouteBlocked => 'Bloqué';

  @override
  String get connRoutePort => 'Port refusé';

  @override
  String get connRouteFailed => 'Échec';

  @override
  String get testRelay => 'Tester le relais';

  @override
  String get relayTestTitle => 'Test du relais';

  @override
  String get relayTestHint =>
      'Vérifie uniquement le relais. Aucune requête à Mozilla ni information de compte n’est envoyée.';

  @override
  String get relayTestPassed => 'Le relais est prêt';

  @override
  String get relayTestFailed => 'L’état du relais n’a pas pu être confirmé';

  @override
  String get relayTestCopy => 'Copier le rapport';

  @override
  String get relayTestInterrupted =>
      'Le test s’est terminé avant de recevoir un résultat complet.';

  @override
  String get searchLocations => 'Rechercher des lieux';

  @override
  String locationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lieux',
      many: '$count de lieux',
      one: '1 lieu',
    );
    return '$_temp0';
  }

  @override
  String get autoInstallApk => 'Mises à jour automatiques';

  @override
  String get autoInstallApkHint =>
      'Les nouvelles versions se téléchargent toutes seules ; l\'installateur demande avant d\'installer.';

  @override
  String get installNow => 'Installer';

  @override
  String get updateAllowInstall =>
      'Pour installer la mise à jour, autorisez cette application à installer des applications.';

  @override
  String get allowInstall => 'Autoriser';

  @override
  String get noResults => 'Aucun lieu ne correspond à la recherche.';

  @override
  String get accentColor => 'Couleur d\'accent';

  @override
  String get accentMono => 'Monochrome (par défaut)';

  @override
  String get accentCustom => 'Couleur personnalisée';

  @override
  String get accentEmber => 'Braise';

  @override
  String get accentGold => 'Doré';

  @override
  String get accentEmerald => 'Émeraude';

  @override
  String get accentSapphire => 'Saphir';

  @override
  String get accentAmethyst => 'Améthyste';

  @override
  String get accentRose => 'Rose';

  @override
  String get autoReconnect => 'Reconnexion automatique';

  @override
  String get autoReconnectHint =>
      'Remet la connexion toute seule si elle tombe sans votre demande.';

  @override
  String get androidOnlyHint => 'Sur le téléphone seulement.';

  @override
  String get idleDisconnect => 'Déconnecter si inactive';

  @override
  String get idleDisconnectHint =>
      'Termine la session quand plus rien ne passe pendant un moment.';

  @override
  String get idleTimeout => 'Délai d\'inactivité';

  @override
  String get minutes5 => '5 minutes';

  @override
  String get minutes10 => '10 minutes';

  @override
  String get minutes15 => '15 minutes';

  @override
  String get minutes30 => '30 minutes';

  @override
  String get minutes60 => '1 heure';

  @override
  String get dataLimit => 'Limite de données de la session';

  @override
  String get dataLimitHint =>
      'Termine la session quand son trafic atteint la limite.';

  @override
  String get dataLimitAmount => 'Limite';

  @override
  String get mb256 => '256 Mo';

  @override
  String get mb512 => '512 Mo';

  @override
  String get mb1024 => '1 Go';

  @override
  String get mb2048 => '2 Go';

  @override
  String get mb5120 => '5 Go';

  @override
  String get mb10240 => '10 Go';

  @override
  String autoStoppedIdle(int minutes) {
    return 'Plus rien ne passait depuis $minutes minutes ; la connexion a été coupée.';
  }

  @override
  String autoStoppedData(int mb) {
    return 'La session a atteint sa limite de $mb Mo ; la connexion a été coupée.';
  }

  @override
  String get protection => 'Protection';

  @override
  String get killSwitch => 'Kill Switch';

  @override
  String get killSwitchHint =>
      'Si le VPN tombe, le trafic est retenu — sans fuite — jusqu\'à la reconnexion.';

  @override
  String get alwaysOnVpn => 'VPN permanent';

  @override
  String get alwaysOnVpnHint =>
      'La protection d\'Android même : aucune connexion sans le VPN.';

  @override
  String get floatingIsland => 'Île flottante';

  @override
  String get floatingIslandHint =>
      'Affiche la connexion au-dessus des autres apps quand vous quittez l’app.';

  @override
  String whatsNewTitle(String version) {
    return 'Nouveautés de la version $version';
  }

  @override
  String get whatsNewContinue => 'Compris';

  @override
  String get whatsNewMenu => 'Nouveautés';

  @override
  String get whatsNewView => 'Revoir';

  @override
  String get updateServers => 'Mettre à jour les serveurs';

  @override
  String get updatingServers => 'Mise à jour…';

  @override
  String serversUpdated(int count) {
    return '$count emplacements de la liste officielle de Mozilla';
  }

  @override
  String get serversUpdateFailed =>
      'Impossible de mettre à jour la liste ; l\'ancienne est conservée.';

  @override
  String get smartPickTitle => 'Le plus rapide en ce moment';

  @override
  String get smartPickUse => 'Utiliser';

  @override
  String get connectAtBoot => 'Se connecter au démarrage du téléphone';

  @override
  String get connectAtBootHint =>
      'Se connecte tout seul au démarrage du téléphone, si l\'autorisation VPN est déjà accordée.';

  @override
  String get gamingProfile => 'Profil gaming';

  @override
  String get gamingProfileHint =>
      'Affiche le délai et la qualité en direct de la connexion ; se combine au serveur mesuré le plus rapide.';

  @override
  String get diagnosticsRun => 'Lancer le diagnostic';

  @override
  String get diagnosticsHint =>
      'Connexion, DNS et tunnel, vérifiés d\'un geste';

  @override
  String get diagnosticsTunnel => 'Tunnel';

  @override
  String get diagnosticsTunnelUp => 'Actif et transportant du trafic';

  @override
  String get diagnosticsTunnelDown => 'Hors service';

  @override
  String get diagnosticsExit => 'Pays de sortie';

  @override
  String get diagnosticsMismatch => 'La sortie diffère du choix';

  @override
  String get diagnosticsConnection => 'Test de connexion';

  @override
  String get diagnosticsPassed => 'Réussi';

  @override
  String get diagnosticsFailed => 'Échoué';

  @override
  String get diagnosticsDnsFiltered => 'Réponse bloquée ou filtrée';

  @override
  String get diagnosticsDnsOk => 'A répondu';

  @override
  String get diagnosticsPrivacy =>
      'Rien ici n\'est conservé ; les résultats restent dans cette fenêtre et dans le journal du noyau.';

  @override
  String get diagnosticsAgain => 'Relancer';

  @override
  String get whatsNewAdded => 'Nouveau';

  @override
  String get whatsNewImproved => 'Amélioré';

  @override
  String get whatsNewFixed => 'Corrigé';

  @override
  String get wnWheelImproved =>
      'La roue des pays est redessinée : le drapeau choisi se tient plus grand dans un cadre de verre avec un fin halo lumineux derrière lui, les autres drapeaux restent plus petits avec de la profondeur, et le nom du dessous arrive en glissant.';

  @override
  String get wnLiveImproved =>
      'Pendant la connexion, la notification demande à Android 16 de la promouvoir en Live Update, comme le fait l\'implémentation de référence ; la durée continue de compter et les vitesses restent vivantes.';

  @override
  String get wnL10nFixed =>
      'Cette page parle désormais la langue de l\'application — ses quinze langues, pas seulement l\'anglais.';

  @override
  String get wnMarkFixed =>
      'Le symbole de Mozilla repose proprement sur sa tuile, arrondi comme les drapeaux.';

  @override
  String get designTitle => 'Design de l’accueil';

  @override
  String get designHint => 'La mise en page de l’accueil';

  @override
  String get designWheel => 'Roue';

  @override
  String get designWheelDesc =>
      'Les drapeaux sur leur roue de verre, l’interrupteur dessous';

  @override
  String get designBento => 'Tuiles';

  @override
  String get designBentoDesc =>
      'Un plateau de tuiles arrondies : connexion, chiffres, lieu';

  @override
  String get designPixel => 'Compacte';

  @override
  String get designPixelDesc =>
      'Une seule carte calme : le lieu, l’interrupteur, les chiffres';

  @override
  String get notifFlag => 'Drapeau du pays dans la notification';

  @override
  String get notifFlagHint => 'Le drapeau du pays même, à côté de son nom';

  @override
  String get wnDesignAdded =>
      'Un réglage de design de l’accueil : roue, tuiles ou carte compacte';

  @override
  String get wnMapAdded =>
      'Une vraie carte du monde vectorielle derrière l’accueil, le pays choisi en lumière';

  @override
  String get wnWheelAdded =>
      'La roue des drapeaux redessinée : verre plus profond, mouvement plus doux';

  @override
  String get wnFlagNotifAdded =>
      'La notification peut montrer le drapeau SVG du pays, et peut être éteinte';

  @override
  String get wnColorRemoved =>
      'La page de couleur personnalisée a été retirée ; la liste garde son code HEX';

  @override
  String get whatsNewRemoved => 'Retiré';

  @override
  String get wnCrashFixed =>
      'L\'application ne s\'arrête plus d\'elle-même sur les téléphones Android 16 : la notification demandait au système quelque chose que le téléphone n\'avait pas encore.';

  @override
  String get wnFlagArtFixed =>
      'L\'application ne se ferme plus d\'elle-même à l\'ouverture : l\'image du drapeau de la notification renvoyait une valeur que le messager du système refuse.';

  @override
  String get statSession => 'Session';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get wnTotalsAdded =>
      'La page d\'accueil montre le total déplacé par la session, et un appui copie l\'IP publique.';

  @override
  String get wnPolishImproved =>
      'La roue des drapeaux et la page des serveurs sont plus nettes ; les textes sont compacts et le tunnel Android transporte le trafic plus vite.';

  @override
  String get valueSmart => 'Intelligent';

  @override
  String get wnSmartAdded =>
      'Connexion intelligente : MTU, protocole et version IP suivent le réseau, choisis d\'après des réponses réelles, pour la vitesse.';

  @override
  String get wnToastAdded =>
      'Les confirmations arrivent comme une note douce à la manière d\'iOS, avec un symbole qui se dessine.';

  @override
  String get wnFlagsImproved =>
      'La roue des drapeaux est nette : aucun drapeau n\'est coupé au bord de l\'écran, ils s\'affichent entiers, et le choix atterrit en douceur.';

  @override
  String get wnMapImproved =>
      'La carte du monde est dessinée plus grande et plus nette : pas de continents tassés, des côtes lisses et un halo lumineux à l\'ancre.';

  @override
  String get dnsManual => 'DNS manuel';

  @override
  String get dnsManualHint =>
      'Une adresse par ligne : IP simple, https:// (DNS over HTTPS) ou tls://host (DNS over TLS). La première réponse gagne.';

  @override
  String get dnsManualInvalid =>
      'Une ligne n\'est pas une adresse que le cœur peut utiliser : IP simple, https://… ou tls://host.';

  @override
  String get killSwitchGuarded =>
      'Sous garde : rien ne quitte le téléphone tant que le tunnel est coupé.';

  @override
  String get accountsUsageTitle => 'Ce mois-ci';

  @override
  String get accountsCountLabel => 'comptes';

  @override
  String get accountsUsageAverage => 'moyenne de la part dépensée des comptes';

  @override
  String get wnDesignsAdded =>
      'Designs de l\'appli : toute l\'appli peut porter le Néomorphisme doux ou le Verre aurore — chaque page, chaque carte — dans Réglages → Général.';

  @override
  String get wnWheelFixed =>
      'Le demi-drapeau de la roue a disparu : l\'étagère sous le drapeau choisi est une flaque de lumière, pas un second drapeau, et rien n\'est coupé au bord de l\'écran.';

  @override
  String get wnMapReal =>
      'La carte du monde est redessinée d\'après les frontières officielles — chaque côte, île et enclave, fidèle et à la vraie proportion.';

  @override
  String get wnGlobeAdded =>
      'Le monde est un globe : la boule d\'argent se tourne vers le pays choisi, un repère lumineux et une carte flottante le marquent, et les routes de la connexion filent vers les hubs.';

  @override
  String get wnWheelGlowImproved =>
      'Le drapeau choisi se tient plus grand dans un cadre de verre à l\'auréole bleue, les voisins sont visiblement plus petits et les repères sous la roue montrent où vous en êtes.';

  @override
  String get wnDesignsRemoved =>
      'Le sélecteur de design de l\'appli s\'en va : l\'appli remet son monocrome d\'origine — votre accent et votre thème restent tels quels.';

  @override
  String get wnDnsAdded =>
      'DNS manuel : IP simples, DNS over HTTPS et DNS over TLS — le type de chaque ligne est montré et vérifié à la saisie.';

  @override
  String get wnSmartImproved =>
      'La connexion intelligente montre désormais la réponse du réseau : le transport choisi et la version IP conservée, en direct.';

  @override
  String get wnProtectionImproved =>
      'L\'interrupteur d\'arrêt annonce quand sa garde se tient, et la page des applis compte celles que vous avez choisies.';

  @override
  String get wnWelcomeImproved =>
      'L\'accueil s\'ouvre sur un bouclier qui respire au-dessus d\'une aurore dérivante, et la page des comptes résume le mois d\'un coup d\'œil.';

  @override
  String bypassAppsCount(String n) {
    return 'Choisies : $n';
  }

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get mapStyle => 'Style de carte';

  @override
  String get mapStyleHint =>
      'Le globe de la page d\'accueil se peint comme vous choisissez. La lumière de connexion reste la même.';

  @override
  String get mapSilver => 'Argent';

  @override
  String get mapMidnight => 'Minuit';

  @override
  String get mapOcean => 'Océan';

  @override
  String get mapMono => 'Monochrome';

  @override
  String get mapAurora => 'Aurore';

  @override
  String get batterySaver => 'Économiseur de batterie';

  @override
  String get batterySaverHint =>
      'Met au repos le mouvement de la carte pendant la connexion — le souffle du globe, l\'éclat de la roue. La connexion reste exactement la même.';

  @override
  String get connectOnOpen => 'Connexion à l\'ouverture de l\'app';

  @override
  String get connectOnOpenHint =>
      'Établit le VPN à l\'ouverture de l\'app, avec le dernier lieu choisi.';

  @override
  String get speedTitle => 'Vitesse';

  @override
  String get parallelTunnels => 'Tunnels parallèles';

  @override
  String get parallelTunnelsHint =>
      'Ouvre plusieurs tunnels vers Mozilla à la fois et répartit le trafic entre eux, pour qu\'un tunnel lent ne plafonne plus la vitesse. Huit est le plus lourd pour la batterie.';

  @override
  String get tunnels1 => 'Un — le plus stable';

  @override
  String get tunnels2 => 'Deux';

  @override
  String get tunnels4 => 'Quatre — plus rapide sur les réseaux lents';

  @override
  String get tunnels8 => 'Huit — le plus rapide';

  @override
  String get connectionCap => 'Limite de connexions';

  @override
  String get connectionCapHint =>
      'Combien d\'apps peuvent parler par le VPN en même temps ; une limite plus basse économise batterie et données sur un téléphone bien occupé. Sans limite par défaut.';

  @override
  String get capNone => 'Sans limite';

  @override
  String get verboseLogging => 'Diagnostic détaillé';

  @override
  String get verboseLoggingHint =>
      'Écrit chaque étape dans le journal — utile pour signaler un problème, un peu plus lourd pour la batterie.';

  @override
  String get wn38MapStylesAdded =>
      'Cinq styles pour la carte : argent, minuit, océan, monochrome et aurore — la nouvelle page Apparence des réglages choisit, avec un aperçu de chacun.';

  @override
  String get wn38ZoomAdded =>
      'La carte zoome : pincez-la, ou touchez deux fois pour approcher puis revenir.';

  @override
  String get wn38OptionsAdded =>
      'Des options pratiques : tunnels parallèles pour plus de vitesse, limite de connexions, économiseur de batterie, connexion à l\'ouverture de l\'app et diagnostic détaillé.';

  @override
  String get wn38SocialAdded =>
      'Instagram et Telegram habitent aussi désormais au bas de cette page.';

  @override
  String get wn38FlightImproved =>
      'Choisir un pays est un petit vol : la caméra recule, le globe tourne, l\'épingle rebondit en se posant et les routes se dessinent seules vers les nœuds.';

  @override
  String get wn38EffectsImproved =>
      'La carte se lit plus riche : des étoiles derrière le globe, une grille de coordonnées, les lumières des nœuds, un halo au pourtour et l\'ombre des terres.';

  @override
  String get wn38SpeedImproved =>
      'L\'option vitesse est réelle : les tunnels parallèles ouvrent plusieurs connexions à la fois et le noyau répartit le trafic entre elles.';

  @override
  String get wn38NameFixed =>
      'Le nom du pays choisi s\'affiche une fois — sur la carte flottante de la carte du monde ; la copie sous les drapeaux est partie.';

  @override
  String get mapKind => 'Type de carte';

  @override
  String get mapKindHint =>
      'Comment le monde de la page d\'accueil est porté : la carte plate comme toujours (par défaut), son habillage moderne, la Terre de nuit, la Terre des reliefs, le ballon de métal ou la Terre satellite. Les frontières sont les vraies, officielles, dans chaque type.';

  @override
  String get mapKindClassic => 'Classique';

  @override
  String get mapKindGlobe => 'Globe 3D';

  @override
  String get mapKindSatellite => 'Satellite';

  @override
  String get mapKindFlat => 'Plate 2D';

  @override
  String get mapStyleGlobeHint =>
      'Les couleurs que porte le globe 3D. Le satellite porte sa propre Terre, et les cartes plates leur propre encre.';

  @override
  String get aboutVersions => 'Version';

  @override
  String get aboutChannels => 'Pages de contact';

  @override
  String get checkUpdatesHint =>
      'Chercher une version plus récente ; celle trouvée se télécharge et l\'installateur demande.';

  @override
  String get speedTestTitle => 'Test de vitesse';

  @override
  String get speedTestRun => 'Mesurer';

  @override
  String get speedTestFailed => 'La mesure n’a pas fini.';

  @override
  String get speedTestThrough => 'Mesuré à travers le tunnel.';

  @override
  String get speedTestDirect => 'Mesuré en direct (le proxy est éteint).';

  @override
  String get speedTestHint =>
      'Un téléchargement et un envoi à travers le tunnel disent ce qu’il porte vraiment. Le graphe de l’accueil ouvre aussi cet écran.';

  @override
  String get speedGraphHint =>
      'La dernière minute du tunnel · toucher pour mesurer';

  @override
  String get favoritePinned => 'Épinglé. Appui long à nouveau pour retirer.';

  @override
  String get favoriteUnpinned => 'Retiré.';

  @override
  String get shareReport => 'Partager le rapport';

  @override
  String get shareReportCopied => 'Le rapport est dans le presse-papiers.';

  @override
  String get batteryWizardTitle => 'Rester vivant sur la batterie';

  @override
  String get batteryWizardBody =>
      'Xiaomi, Samsung, Huawei et leurs pareils tuent les apps VPN après le verrouillage de l’écran. Sors cette app de l’optimisation de batterie pour que le tunnel reste allumé.';

  @override
  String get batteryWizardSteps =>
      'Dans les réglages du fabricant, permets aussi le démarrage auto et mets l’app en Aucune restriction (Xiaomi), hors apps en veille (Samsung) ou Lancement manuel (Huawei).';

  @override
  String get batteryWizardState =>
      'L’optimisation de batterie peut arrêter le tunnel.';

  @override
  String get batteryWizardPermit => 'Autoriser';

  @override
  String get batteryWizardOk => 'Le tunnel est protégé de la batterie.';

  @override
  String get batteryWizardOpen => 'Réglages de batterie';

  @override
  String get usageTitle => 'Usage par app';

  @override
  String get usageRowHint => 'Ce que chaque app a consommé';

  @override
  String get usageGrant => 'Ouvrir l’accès aux usages';

  @override
  String get usageGrantHint =>
      'Android garde l’usage de données par app derrière l’autorisation d’accès aux usages. La page qu’ouvre le bouton est celle du système ; l’app ne lit que les chiffres.';

  @override
  String get usageEmpty => 'Aucun usage enregistré sur la période.';

  @override
  String get usageToday => 'Aujourd’hui';

  @override
  String get usageWeek => '7 derniers jours';

  @override
  String get usageMonth => '30 derniers jours';

  @override
  String get playProtectTitle => 'Google Play Protect';

  @override
  String get playProtectBody =>
      'L\'application s\'installe hors de Google Play ; Play Protect peut donc demander une analyse au premier install. Touchez une fois « Scanner l\'application » — une analyse saine est retenue et les mises à jour suivantes s\'installent sans ce message.';

  @override
  String get smartLocation => 'Emplacement le plus rapide';

  @override
  String get smartLocationHint =>
      'Chaque démarrage utilise le serveur que le test de latence du noyau juge le plus rapide.';

  @override
  String get quicPass => 'Passage QUIC';

  @override
  String get quicPassHint =>
      'Le QUIC des applis (UDP 443) passe par le tunnel : appels et jeux gardent leur vitesse au lieu de retomber sur TCP.';

  @override
  String get accountRename => 'Renommer le compte';

  @override
  String get accountRenameLabel => 'Nom du compte';

  @override
  String get accountProfile => 'Photo de profil';

  @override
  String get avatarReset => 'Revenir à la marque simple';

  @override
  String get accountSecurity => 'Mot de passe de l\'app';

  @override
  String get appPasswordOn => 'L\'app s\'ouvre derrière un mot de passe.';

  @override
  String get appPasswordOff => 'Pas de mot de passe : qui ouvre l\'app entre.';

  @override
  String get appPasswordSet => 'Définir un mot de passe';

  @override
  String get appPasswordChange => 'Changer le mot de passe';

  @override
  String get appPasswordRemove => 'Supprimer le mot de passe';

  @override
  String get appPasswordCurrent => 'Mot de passe actuel';

  @override
  String get appPasswordNew => 'Nouveau mot de passe (4+ caractères)';

  @override
  String get appPasswordConfirm => 'Répétez le nouveau mot de passe';

  @override
  String get appPasswordShort => 'Au moins 4 caractères.';

  @override
  String get appPasswordMismatch =>
      'Les deux mots de passe ne sont pas les mêmes.';

  @override
  String get appPasswordWrong => 'Mot de passe incorrect';

  @override
  String get appPasswordSetDone =>
      'Le mot de passe est en place — l\'app le demandera au prochain démarrage.';

  @override
  String get appPasswordRemoved =>
      'Le mot de passe est parti ; l\'app s\'ouvre librement.';

  @override
  String get appPasswordUnlock => 'L\'app est verrouillée';

  @override
  String get appPasswordUnlockHint =>
      'Entrez le mot de passe de l\'app pour continuer.';

  @override
  String get wn39MapKinds =>
      'La carte redevient un choix de types : la plate de toujours (par défaut), le globe 3D, la Terre satellite et une plate 2D moderne.';

  @override
  String get wn39EyeIp =>
      'La carte d\'emplacement porte un œil : touchez-le pour voir l\'adresse de sortie du trafic et la copier.';

  @override
  String get wn39Profile =>
      'Les comptes portent leur propre nom et photo de profil, et l\'app peut s\'ouvrir derrière un mot de passe.';

  @override
  String get wn39Smart =>
      'La connexion intelligente s\'est complétée : l\'emplacement le plus rapide par latence réelle et le passage QUIC pour appels et jeux.';

  @override
  String get wn39Flight =>
      'Changer de pays vole plus souplement — la caméra suit le grand cercle — et les repères de la roue de drapeaux s\'approchent des drapeaux.';

  @override
  String get wn39ToastEverywhere =>
      'La note dynamique est partout : chaque sauvegarde, copie et échec porte la même pilule de verre animée.';

  @override
  String get wn39Updates =>
      'Les mises à jour gardent le stockage propre : l\'installateur remplace l\'ancienne version et aucun paquet ne reste.';

  @override
  String get mapKindNight => 'Nuit';

  @override
  String get mapKindTerrain => 'Relief';

  @override
  String get wn40MapKindsNew =>
      'Deux nouveaux habillages de la carte : la Terre de nuit et la Terre des reliefs.';

  @override
  String get wn40Flight =>
      'Le globe 3D vole vers le nouveau pays en un seul tour souple — jamais un saut.';

  @override
  String get wn40Mercator =>
      'Les cartes plates se dessinent en projection Mercator standard : proportions vraies, frontières standard, rien de comprimé.';

  @override
  String get wn40NameBack =>
      'Le nom du pays choisi revient sous les drapeaux sur les cartes plates.';

  @override
  String get wn40Speed =>
      'Le tunnel ouvre désormais deux sessions parallèles par défaut — une ligne plus forte et plus stable.';

  @override
  String get wn40LockFixed =>
      'Le cadenas du bouton de connexion ne clignote plus entre ses états.';

  @override
  String get wn40IpRemoved =>
      'La fenêtre IP de la carte de lieu a été retirée.';

  @override
  String get soundFeedback => 'Effets sonores';

  @override
  String get soundFeedbackHint =>
      'Des sons doux au toucher, sur les interrupteurs, à la connexion et à la déconnexion';

  @override
  String get rateUnit => 'Unité de vitesse';

  @override
  String get lockInBackground => 'Verrou après une absence';

  @override
  String get lockBgNever => 'Jamais';

  @override
  String get lockBgNow => 'Immédiatement';

  @override
  String get lockBgMin5 => 'Après 5 minutes';

  @override
  String get lockBgMin15 => 'Après 15 minutes';

  @override
  String get mb25600 => '25 Go';

  @override
  String get mb51200 => '50 Go';

  @override
  String get mb102400 => '100 Go';

  @override
  String get wn41Sound =>
      'Le son de connexion rejoint la vibration : le VPN joue une note courte à la connexion ou à la déconnexion (Réglages → Général).';

  @override
  String get wn41RateUnit =>
      'La vitesse se lit dans l\'unité choisie : le KB/s familier ou le Mbps de la connexion.';

  @override
  String get wn41BackgroundLock =>
      'L\'app peut se verrouiller en votre absence : le mot de passe se redemande immédiatement, après 5 ou après 15 minutes.';

  @override
  String get wn41BiggerLimits =>
      'La limite de données de la session monte à 25, 50 ou 100 Go.';

  @override
  String get wn41Motion =>
      'Nouveaux mouvements : l\'orbe connectée respire, la coche se dessine toute seule, le mot d\'état glisse entre ses valeurs, et un mot de passe erroné fait tressaillir le champ.';

  @override
  String get wn41AboutFixed =>
      'La page À propos se tient droite : les deux pages côte à côte, chaque note à sa ligne, rien de comprimé.';

  @override
  String get wn41HapticFixed =>
      'Le réglage de vibration répond de nouveau : chaque connexion et déconnexion le suit, pas seulement le curseur.';

  @override
  String get copyIp => 'Copier l\'adresse IP';

  @override
  String get wn42Fonts =>
      'Chaque langue lit avec la police propre à l\'app : Noto Sans pour les deux chinois et le bengali, Inter pour les langues latines et cyrilliques — plus aucune langue ne s\'appuie sur les polices du téléphone.';

  @override
  String get wn42Sounds =>
      'Les sons de l\'app sont réels désormais : un toucher doux dans chaque section, deux notes pour les interrupteurs, une note qui monte et descend à la connexion et à la déconnexion, un ping pour le verrou — l\'interrupteur sonore les gouverne tous.';

  @override
  String get wn42AboutFixed =>
      'La page À propos centre son logo, son nom et sa note, et les identifiants de contact restent entiers sur une ligne, quelle que soit la largeur du téléphone.';

  @override
  String get wn42Gaming =>
      'Le profil jeu est réel désormais : la page des serveurs remesure les délais chaque demi-minute et met en avant le plus rapide mesuré avec l\'accent.';

  @override
  String get avatarPhoto => 'Votre photo';

  @override
  String get avatarPhotoFailed => 'Impossible d\'utiliser cette image';

  @override
  String get designAether => 'Éther';

  @override
  String get designAetherDesc =>
      'Carte d\'état iOS : le mot d\'état et la durée de session sur une carte surélevée, avec un bouton d\'alimentation lumineux';

  @override
  String get designZed => 'Zed';

  @override
  String get designZedDesc =>
      'Une bulle dégradée : un orbe respirant en violet, rose et lime qui porte la durée de la session';

  @override
  String get tlsFragmentAuto => 'Automatique';

  @override
  String get tlsFragmentAutoHint =>
      'D\'abord le hello entier ; un réseau qui coupe sans fin TLS se coupe lui-même le nom, une demi-heure';

  @override
  String get accentDesign => 'La lumière du design même';

  @override
  String get wn45Designs =>
      'Quatre nouveaux looks d\'accueil — Aurore, Néon, Crépuscule et Sauge — chacun habille chaque page de sa propre palette';

  @override
  String get wn45HelloAuto =>
      'Le fragmenteur TLS a appris : un réseau qui tue la poignée de main sans fin voit son nom tronqué de lui-même, et le tunnel passe';

  @override
  String get wn45RelayRace =>
      'La reprise du relais teste désormais trois bords à la fois, et le réseau filtré retrouve son chemin plus tôt';

  @override
  String get wn45AccentFixed =>
      'Le sélecteur de couleur illumine à nouveau l\'app — sa couleur ne parvenait plus aux pages';

  @override
  String get wn45WhatsNewFixed =>
      'La page des nouveautés montre à nouveau ses mots — elle s\'ouvrait vide';

  @override
  String get wn46Designs =>
      'Deux nouveaux looks issus des designs de référence : la carte d\'état iOS de l\'éther et la bulle dégradée du zed — chacun habille toute l\'app, et les quatre looks précédents sont partis.';

  @override
  String get wn46Sounds =>
      'Les sons ont gagné un ensemble professionnel : une onde pour la connexion qui commence, un accord quand elle s\'établit, une descente quand elle se coupe et une note sourde pour la voie bloquée — une seule voix à la fois.';

  @override
  String get wn47Designs =>
      'Les deux looks de référence habillent maintenant toute l\'application — chaque page, pas seulement l\'accueil : aether porte la structure iOS de la première référence (la barre à encoche courbe, les tableaux groupés, les badges colorés, les couleurs d\'état du système) et zed porte celle, expressive, de la seconde (le dock flottant, les cartes très rondes, les bulles d\'outils déplaçables).';

  @override
  String get wn47Fixes =>
      'Une ligne de réglages qui débordait sur les écrans étroits se lit désormais jusqu\'au bout.';

  @override
  String get wn48Bars =>
      'Les barres du bas des deux designs tiennent de nouveau leur rang : le cercle bleu de l\'aether se pose dans l\'encoche de son onglet, et le cercle du zed ne couvre plus le nom au-dessous.';

  @override
  String get wn48Fit =>
      'Les pages d\'accueil tiennent de nouveau dans leur écran : la carte de l\'aether lit Disconnected jusqu\'au bout, l\'orbe du zed descend d\'un cran quand la page devient étroite, et pendant que la connexion se fait, ni la piste ne demande de glisser pour connecter ni le conseil ne dit déconnecter en même temps.';

  @override
  String get wn48Wheel =>
      'La roue des drapeaux dissout une carte avant que le bord de l\'écran ne la coupe, le lieu recommandé porte la marque de Mozilla à une taille lisible, et le bord sud de la carte plate fond dans la page au lieu de finir en ligne.';

  @override
  String get wn49States =>
      'Les deux designs de référence portent les détails pour lesquels ils ont été dessinés : la carte d\'aether affiche les débits de la session comme celle d\'AetherST, son bouton d\'alimentation respire avec la lueur de la référence et s\'enfonce sous le doigt, et la bulle de zed se transforme entre ses formes pendant que son centre passe d\'un état à l\'autre en fondu.';

  @override
  String get wn49Words =>
      '« Connexion » a maintenant un mot partout : pendant que le tunnel se construit, la piste de l\'interrupteur porte « Connexion… », la marque du bouton se fond entre ses états, et la piste respire au rythme de la connexion — rien ne disparaît sous le doigt.';

  @override
  String get wn49Sooner =>
      'Le moteur de la connexion redevient celui de la version d\'origine : le pool de relais, les routes alternatives et leur mémoire, et le garde des requêtes répétées portent le tunnel — il se lève plus tôt et tient.';

  @override
  String get wn49Mark =>
      'L\'emplacement recommandé porte la vraie marque de Mozilla VPN, et les boutons de mise à jour portent le glyphe propre de la mise à jour.';

  @override
  String get wn50Notch =>
      'Le vêtement des deux designs sort du désordre qu\'il gardait : la barre à encoche de l\'aether lit le centre du cercle lui-même, le nom de l\'onglet choisi porte l\'encre de la page sur les deux looks, et la lueur du cercle reste au cercle au lieu de laver le nom.';

  @override
  String get wn50Cards =>
      'L\'accueil du zed plie ses débits dans le bento : la carte des débits rejoint les deux cellules du bento et la rangée de la session, les dernières cartes de la page dégagent la place du dock, et rien ne reste à moitié sous le dock quand la page défile jusqu\'à son bout.';

  @override
  String get wn50Veil =>
      'La bande d\'état porte son voile : le contenu s\'estompe sous l\'horloge au lieu de la heurter, les pages poussées du zed ne commencent plus sous l\'horloge, et ses outils flottants laissent libre la place du dock.';

  @override
  String get wn50Ping =>
      'La pastille de ping de l\'aether mesure de nouveau d\'un toucher, comme répond la pastille de la référence elle-même.';

  @override
  String get tapToChangeServer => 'Touchez pour changer de serveur';

  @override
  String get wn51Smooth =>
      'La roue et la bande de drapeaux tournent comme une roue doit tourner : le glissement et le changement de pays voyagent maintenant dans le compositeur — rien ne se remet en page et aucune lueur ne se redessine pendant que les drapeaux tournent, si bien que la roue tourne souple et la page défile avec elle.';

  @override
  String get wn51Zed =>
      'L\'accueil de zed porte la structure de la référence elle-même : les deux cartes de débits se tiennent sous la marque (au repos, à leurs zéros, quand le tunnel repose), le mot de l\'état arrive dans la grande voix du display sous la bulle, et le lieu vit sur la carte de serveur lumineuse au-dessus du dock — la petite pastille et le nom répété sont partis.';

  @override
  String get wn51Aether =>
      'L\'accueil de l\'aether dit le lieu une fois : la ligne du nom répété de la bande se repose, la carte d\'état et le bouton d\'alimentation gardent leurs sièges, et la page se lit comme une colonne propre.';

  @override
  String get wn51Veil =>
      'Le voile de l\'horloge a grandi d\'une respiration et garde sa couleur sur toute la bande de l\'horloge : le contenu qui glisse dessous s\'estompe entier et ses mots n\'atteignent jamais l\'horloge.';

  @override
  String get wn52Speed =>
      'Le tunnel court de nouveau à la vitesse du réseau même : l\'interface VPN parle la taille de paquet de la ligne (MTU 1500) au lieu d\'une surdimensionnée ; les téléchargements reprennent toute leur vitesse et les appels restent stables, surtout en données mobiles.';

  @override
  String get wn52Smart =>
      'L\'emplacement le plus rapide et le service recommandé rechoisissent honnêtement : chaque démarrage mesure les emplacements à neuf et prend le meilleur du moment, au lieu de chevaucher en silence l\'endroit choisi avant.';

  @override
  String get wn52Motion =>
      'Trente nouvelles animations dans toute l\'app : chaque page et carte se pose en douceur, les tuiles pressées s\'enfoncent puis reviennent, le point de connexion respire, et les pages ouvertes glissent — chacune s\'immobilise quand le système demande moins de mouvement.';

  @override
  String get wn52Pages =>
      'Les pages ouvertes arrivent en un glissement doux et le titre depuis son propre bord ; pendant l\'enregistrement d\'un réglage, une ligne discrète traverse la section.';

  @override
  String get wn56Button =>
      'Le curseur de connexion garde son mot pendant tout le trajet — plus aucun instant vide entre « connexion » et « connecté » : le mot glisse à présent entre ses états, et l\'assombrissement d\'activité arrive en douceur.';

  @override
  String get wn56Capsule =>
      'La roue dit chaque état une seule fois : le mot d\'état répété au-dessus du curseur est parti — la piste le porte elle-même, et la page se lit d\'une ligne plus calme.';

  @override
  String get wn56Door =>
      'Le test de vitesse a sa propre porte sur l\'accueil : une rangée, un geste, et la mesure s\'ouvre — avant même la première connexion, pas seulement quand le tunnel porte.';

  @override
  String get wn56Wheel =>
      'La roue des drapeaux glisse : une impulsion amène un pays, et l\'atterrissage se pose au lieu de claquer — le geste se lit ferme et régulier, comme un bon cadran.';

  @override
  String get designGazette => 'Gazette';

  @override
  String get designGazetteDesc =>
      'Une « une » : le bandeau, les colonnes filetées et le tampon d\'encre — le calme du journal, en papier et encre';

  @override
  String get speedTestSizesTitle => 'Taille du test';

  @override
  String get speedTestSizeLight => 'Léger';

  @override
  String get speedTestSizeStandard => 'Standard';

  @override
  String get speedTestSizeFull => 'Complet';

  @override
  String get speedTestJitter => 'Gigue';

  @override
  String gazetteEdition(int n) {
    return 'N° $n';
  }

  @override
  String get gazetteBulletin => 'Bulletin de sécurité';

  @override
  String get gazetteLiveWire => 'Fil direct';

  @override
  String get wn56Speed =>
      'Le test de vitesse revit : chaque sens mesure sur sa propre connexion et parle HTTP/1.1, l\'envoi ne meurt plus quand la fenêtre du téléchargement se ferme — et le panneau ajoute le délai du chemin, sa gigue et une taille au choix.';

  @override
  String get wn56Gazette =>
      'Un nouveau look d\'accueil : la gazette — une « une » avec bandeau, colonnes filetées, téléscripteur en direct et le tampon d\'encre qui se pose quand le tunnel tient.';
}
