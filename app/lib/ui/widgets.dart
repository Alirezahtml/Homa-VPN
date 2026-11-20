import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_info.dart';
import '../core/android_core.dart';
import '../core/core_api.dart';
import '../core/models.dart';
import '../core/ports.dart';
import '../core/remote_flags.dart';
import '../core/updates.dart';
import '../l10n/app_localizations.dart';
import '../platform.dart';
import 'accent.dart';
import 'country_names.dart';
import 'design.dart';
import 'design_style.dart';
import 'format.dart';
import 'glass.dart';
import 'local_country_names.dart';
import 'motion.dart';
import 'sound.dart' show AppSounds, SoundCue;

/// Where a Firefox Account is made: Mozilla's site.
const firefoxAccountSignUpUrl = 'https://accounts.firefox.com/';

/// Where an account made with Google or Apple sign-in gets a password.
const firefoxAccountSetPasswordUrl =
    'https://accounts.firefox.com/reset_password/';

/// The program's logo, its tile (assets/logo.png, the official brand
/// mark), [size] logical pixels square; the black face of the brand in
/// the dark theme, the white one in the light theme.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? 'assets/logo_dark.png' : 'assets/logo.png',
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
    );
  }
}

/// The brand's wordmark alone — the eagle head and the HOMA letters —
/// without a tile, for the pages' headers: [height] logical pixels tall.
/// The asset comes in the theme's own face: white art on the night, the
/// day's near-black on the light theme, matching the text exactly.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      dark ? 'assets/wordmark_dark.png' : 'assets/wordmark.png',
      height: height,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
    );
  }
}

/// Status colors that read in both themes. The palette is monochrome:
/// a full-contrast point for the good state, a mid gray for the ones
/// that wait; trouble shows full contrast again, and the icons and the
/// words carry what the color used to. A chosen accent ([AppAccent])
/// takes the full-contrast points; the grays stay gray.
abstract final class StatusColors {
  static bool get _dark =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  static Color get good {
    final accent = AppAccent.current;
    if (accent != null) return accentForTheme(accent, _dark);
    return _dark ? Colors.white : const Color(0xFF0A0A0A);
  }

  static Color get busy => const Color(0xFF8A8A8A);

  static Color get bad {
    final accent = AppAccent.current;
    if (accent != null) return accentForTheme(accent, _dark);
    return _dark ? Colors.white : const Color(0xFF0A0A0A);
  }

  static Color get idle => const Color(0xFF8A8A8A);
}

/// How the app presents the engine state.
class PhaseLook {
  const PhaseLook(this.label, this.color, this.hint);

  final String label;
  final Color color;

  /// What the state means for states that need it, in the user's words
  /// where the core gives a code ([stateText]); empty otherwise.
  final String hint;

  static PhaseLook of(AppLocalizations l, CoreStatus s) {
    if (s.connectPending) {
      return PhaseLook(l.stateConnecting, StatusColors.busy, '');
    }
    if (s.connectFailure.isNotEmpty) {
      return PhaseLook(l.stateOff, StatusColors.idle, '');
    }
    final message = stateText(l, s.state);
    return switch (s.state.phase) {
      // Connected in either mode on the computer (Proxy or System proxy).
      // Asleep (no traffic yet, or idle) still counts as connected: the
      // proxy wakes on the first connection.
      Phase.running => PhaseLook(l.stateConnected, StatusColors.good, ''),
      Phase.starting => PhaseLook(l.stateConnecting, StatusColors.busy, ''),
      // The core's own words name its web dashboard; the app has a page.
      Phase.waiting when s.totalAccounts == 0 => PhaseLook(
        l.stateWaiting,
        StatusColors.busy,
        l.waitingForAccount,
      ),
      // No enabled account, but some exist: they are all turned off.
      Phase.waiting when s.state.code == StateCode.noAccounts => PhaseLook(
        l.stateWaiting,
        StatusColors.busy,
        l.waitingForEnabledAccount,
      ),
      Phase.waiting => PhaseLook(l.stateWaiting, StatusColors.busy, message),
      Phase.error when s.state.proxyPortInUse => PhaseLook(
        l.stateError,
        StatusColors.bad,
        l.proxyPortInUse('${portOf(s.state.address) ?? s.state.address}'),
      ),
      Phase.error => PhaseLook(l.stateError, StatusColors.bad, message),
      // Turned off on the phone.
      Phase.off => PhaseLook(l.stateOff, StatusColors.idle, ''),
      _ => PhaseLook(l.stateUnknown, StatusColors.idle, message),
    };
  }
}

/// A word that stands on the home's map — the state's word
/// ("Connecting…", "Connected"), the chosen country's name — in a
/// capsule of its own: a translucent surface, a hairline edge and a
/// soft drop shadow give it the layer the bare words never had, so it
/// reads over the world's outlines in both themes. No blur sits behind
/// it (a saveLayer's cost, and the slow GPUs pay it every frame): the
/// fill and the shadow alone carry the depth.
class StatusCapsule extends StatelessWidget {
  const StatusCapsule({
    super.key,
    required this.child,
    this.dark,
    this.dot = false,
    this.dotColor,
    this.dotBreathes = false,
  });

  final Widget child;

  /// Which mode's glass to wear; read from the theme when left out.
  final bool? dark;

  /// The state's own dot before the word: a point of the state's color,
  /// so the state reads at a glance before the word does.
  final bool dot;

  /// The dot's color (the state's own); the word's edge gray without it.
  final Color? dotColor;

  /// While the connection is still being made the dot breathes — one
  /// ring swelling out of it, slow and light; still otherwise, and
  /// nothing repaints.
  final bool dotBreathes;

  @override
  Widget build(BuildContext context) {
    final d = dark ?? Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: dot
          ? const EdgeInsets.fromLTRB(15, 7, 20, 7)
          : const EdgeInsets.symmetric(horizontal: 19, vertical: 7),
      decoration: BoxDecoration(
        color: d
            ? Colors.black.withValues(alpha: 0.42)
            : Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: d
              ? Colors.white.withValues(alpha: 0.16)
              : Colors.black.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: d
                ? Colors.black.withValues(alpha: 0.45)
                : Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            _CapsuleDot(
              color: dotColor ?? (d ? Colors.white : const Color(0xFF0A0A0A)),
              breathe: dotBreathes,
            ),
            const SizedBox(width: 9),
          ],
          child,
        ],
      ),
    );
  }
}

/// The capsule's own dot: the state's point of light, and while it
/// breathes one ring swelling out of it and dying — the connecting
/// state's quiet pulse. No ring and no clock while it rests.
class _CapsuleDot extends StatefulWidget {
  const _CapsuleDot({required this.color, required this.breathe});

  final Color color;
  final bool breathe;

  @override
  State<_CapsuleDot> createState() => _CapsuleDotState();
}

class _CapsuleDotState extends State<_CapsuleDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    _setPulse();
  }

  @override
  void didUpdateWidget(_CapsuleDot old) {
    super.didUpdateWidget(old);
    if (old.breathe != widget.breathe) _setPulse();
  }

  void _setPulse() {
    if (widget.breathe) {
      if (!_c.isAnimating) _c.repeat();
    } else {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
    );
    if (!widget.breathe) return dot;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 7 + 9 * t,
              height: 7 + 9 * t,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.color.withValues(alpha: (1 - t) * 0.45),
                  width: 1.3,
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: dot,
    );
  }
}

/// The engine state in the user's words, by its code; the core's own
/// English for a state without one, or with a code this app does not know.
String stateText(AppLocalizations l, EngineState s) => switch (s.code) {
  StateCode.waitingForNetwork => l.waitingForNetwork,
  StateCode.noAccounts => l.waitingForAccount,
  StateCode.noUsableAccount => l.failNoAccount,
  StateCode.startFailed when portOf(s.address) != null => l.proxyStartFailed(
    '${portOf(s.address)}',
  ),
  _ => s.message,
};

/// Words a [CoreUnavailable] for people.
String describeProblem(AppLocalizations l, CoreUnavailable e) =>
    switch (e.problem) {
      CoreProblem.starting => l.startingCore,
      CoreProblem.notAnswering => l.errNotAnswering,
      CoreProblem.refused => l.errRefused,
      CoreProblem.portInUse => l.errPortInUse(
        '${portOf(e.detail) ?? e.detail}',
      ),
      CoreProblem.noCore => l.errNoCore(e.detail),
      CoreProblem.exited => l.errCoreExited(e.detail),
    };

/// The color of a real delay, by how fast the answer came: green when
/// quick, amber when it takes a moment, orange when slow, red when very
/// slow. The one place the app leaves its monochrome palette: a number
/// alone cannot say "fast" at a glance, and the same order reads on the
/// phone, the computer, and both themes (a touch darker in the day's).
Color delayColor(int ms) {
  final dark =
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
  return switch (ms) {
    < 200 => dark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
    < 450 => dark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
    < 800 => dark ? const Color(0xFFFB923C) : const Color(0xFFC2410C),
    _ => dark ? const Color(0xFFF87171) : const Color(0xFFB91C1C),
  };
}

/// Mozilla lists its recommended location as a country of its own, code
/// REC (named "Recomended Location").
bool isRecommendedPlace(String code) => code.toUpperCase() == 'REC';

/// A location's name for people: the recommended location in the user's
/// language, otherwise the country's name ([countryName]).
String locationName(AppLocalizations l, String code, String name) =>
    isRecommendedPlace(code)
    ? l.recommendedLocation
    : countryName(l, code, name);

/// The phone home's colors: a pure black night and the state's light.
/// The state's light follows the chosen accent ([AppAccent.current]); the
/// surfaces stay pure black either way.
abstract final class Midnight {
  static const top = Color(0xFF0A0A0A);
  static const bottom = Colors.black;

  static Color get connected {
    final accent = AppAccent.current;
    if (accent != null) return accentForTheme(accent, true);
    return Colors.white;
  }

  static const busy = Color(0xFFBFBFBF);

  static Color get error => connected;

  static const idle = Color(0xFF8A8A8A);
  static const muted = Color(0xFF9E9E9E);
}

/// A dark theme for the phone's home: the monochrome design's pure black
/// surfaces, the chosen accent taking the lights only.
ThemeData midnightTheme(ThemeData base) {
  const scheme = ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    primaryContainer: Color(0xFF2A2A2A),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFF1E1E1E),
    onSecondaryContainer: Colors.white,
    tertiaryContainer: Color(0xFF1E1E1E),
    onTertiaryContainer: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFF9E9E9E),
    outline: Color(0xFF3A3A3A),
    outlineVariant: Color(0xFF262626),
    inverseSurface: Colors.white,
    onInverseSurface: Colors.black,
    inversePrimary: Color(0xFF0A0A0A),
    surfaceTint: Colors.transparent,
    surfaceContainerHighest: Color(0xFF161616),
    surfaceContainerHigh: Color(0xFF1A1A1A),
    surfaceContainer: Color(0xFF111111),
    surfaceContainerLow: Color(0xFF0C0C0C),
    surfaceContainerLowest: Colors.black,
  );
  final accent = AppAccent.current;
  return ThemeData(
    colorScheme: accent == null
        ? scheme
        : scheme.copyWith(
            primary: accent,
            onPrimary: AppAccent.onAccent(accent),
            secondary: accent,
            onSecondary: AppAccent.onAccent(accent),
            tertiary: accent,
            onTertiary: AppAccent.onAccent(accent),
          ),
    fontFamily: base.textTheme.bodyMedium?.fontFamily,
    // The night map's own theme keeps the base theme's faces, the
    // language's and the fallbacks' both.
    fontFamilyFallback: base.textTheme.bodyMedium?.fontFamilyFallback,
  );
}

/// A country's name in the app's language; in English (and for a country
/// without a translation) the server list's name [name], else the English
/// name of its code, else the code. A [name] that is only the code (the core
/// sends the code when the server list does not name the country) counts as
/// no name.
String countryName(AppLocalizations l, String code, [String name = '']) {
  final upper = code.toUpperCase();
  final local = localCountryNames[l.localeName]?[upper];
  if (local != null) return local;
  final named = name.isNotEmpty && name.toUpperCase() != upper;
  return named ? name : countryNames[upper] ?? code;
}

/// A key that sorts names the way people of [language] expect, which
/// String.compareTo (code units) does not: accented Latin letters next to
/// their base letter; the Persian letters پ چ ژ ک گ in their place in the
/// alphabet rather than after the Arabic ones; in Arabic, alif with or
/// without hamza as one letter, and ه before و.
String nameSortKey(String language, String name) {
  final lower = name.toLowerCase();
  final out = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    final i = switch (language) {
      'fa' => _persianOrder.indexOf(ch),
      'ar' => _arabicOrder.indexWhere((letter) => letter.contains(ch)),
      _ => -1,
    };
    // Letters in alphabet order from U+0E00, past every Latin letter.
    out.write(i >= 0 ? String.fromCharCode(0x0E00 + i) : _latinBase[ch] ?? ch);
  }
  return out.toString();
}

const _persianOrder = 'آاأإبپتثجچحخدذرزژسشصضطظعغفقکكگلمنوؤهةیيئ';

/// The Arabic alphabet; the forms in one entry sort as one letter.
const _arabicOrder = [
  'اأإآ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', 'س', 'ش', 'ص', //
  'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ك', 'ل', 'م', 'ن', 'هة', 'وؤ', 'يىئ',
];

/// Accented Latin letters by their base letter, for sorting.
const _latinBase = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'ă': 'a', //
  'ạ': 'a', 'ả': 'a', 'ấ': 'a', 'ầ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a', //
  'ắ': 'a', 'ằ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a', 'ç': 'c', 'đ': 'd', //
  'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ẹ': 'e', 'ẻ': 'e', 'ẽ': 'e', //
  'ế': 'e', 'ề': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e', 'ə': 'e', 'ğ': 'g', //
  // The dot Dart's toLowerCase leaves after the i of Turkish İ.
  '̇': '',
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ı': 'i', 'ỉ': 'i', //
  'ĩ': 'i', 'ị': 'i', 'ñ': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', //
  'ö': 'o', 'ő': 'o', 'ø': 'o', 'ơ': 'o', 'ọ': 'o', 'ỏ': 'o', 'ố': 'o', //
  'ồ': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o', 'ớ': 'o', 'ờ': 'o', 'ở': 'o', //
  'ỡ': 'o', 'ợ': 'o', 'ş': 's', 'š': 's', 'ù': 'u', 'ú': 'u', 'û': 'u', //
  'ü': 'u', 'ű': 'u', 'ư': 'u', 'ụ': 'u', 'ủ': 'u', 'ũ': 'u', 'ứ': 'u', //
  'ừ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u', 'ý': 'y', 'ỳ': 'y', 'ỷ': 'y', //
  'ỹ': 'y', 'ỵ': 'y', 'ž': 'z',
};

/// Why connecting fails, in the user's words, and the core's own text for
/// the details: from the newer of the last failed wake and the last failed
/// test. Only a network failure (or an unknown one) asks to check the
/// internet.
({String text, String detail, String code}) failureText(
  AppLocalizations l,
  ProxyInfo? proxy,
  ConnectionTest? test,
) {
  final failed = test != null && !test.ok ? test : null;
  var code = '';
  var detail = '';
  if (proxy != null &&
      proxy.wakeError.isNotEmpty &&
      (failed?.at == null ||
          (proxy.wakeFailedAt?.isAfter(failed!.at!) ?? false))) {
    (code, detail) = (proxy.wakeErrorCode, proxy.wakeError);
  } else if (failed != null) {
    (code, detail) = (failed.errorCode, failed.error);
  }
  return (text: failureCodeText(l, code), detail: detail, code: code);
}

/// What a [Failure] code means, in the user's words.
String failureCodeText(AppLocalizations l, String code) {
  return switch (code) {
    Failure.noNetwork => l.failNoInternet,
    Failure.unreachable => l.failUnreachable,
    Failure.upstreamProxy => l.failUpstreamProxy,
    Failure.insideVpn => l.failInsideVpn,
    Failure.refused => l.failRefused,
    Failure.locationRefused => l.failLocationRefused,
    Failure.signIn => l.failSignIn,
    Failure.quota => l.failQuota,
    Failure.notEntitled => l.failNotEntitled,
    Failure.region => l.failRegion,
    Failure.server => l.failServer,
    Failure.noAccount => l.failNoAccount,
    Failure.testSite => l.failTestSite,
    // The core's own words only on a long press (detail).
    Failure.other => l.failOther,
    _ => l.connectRetrying,
  };
}

/// The soft warning when the public IP is in another country than the
/// chosen one, with both countries named; null without a mismatch, and
/// always for the recommended location and the fastest one, which choose
/// no country.
String? exitMismatchText(AppLocalizations l, CoreStatus status) {
  final m = status.exitMismatch;
  final selection = status.selection.trim().toLowerCase();
  if (m == null ||
      selection.isEmpty ||
      selection == 'fastest' ||
      isRecommendedPlace(selection)) {
    return null;
  }
  return l.exitMismatch(
    countryName(l, m.exitCountryCode, m.exitCountryName),
    countryName(l, m.chosenCountryCode, m.chosenCountryName),
  );
}

/// Whether [code] says Mozilla refused the location the user chose, which
/// the home answers with a button to the recommended location.
bool isLocationRefused(String code) => code == Failure.locationRefused;

/// Where the phone's traffic goes, for its home page.
class HomePlace {
  const HomePlace(this.flag, this.name, this.caption, {this.auto = false});

  /// A country code for the flag ('REC' for the recommended location).
  final String flag;
  final String name;

  /// The line above the name: how the location is chosen, or what it is.
  final String caption;

  /// Chosen by the app (recommended or fastest): the caption says so.
  final bool auto;
}

/// The phone home's location. While connected: the country the traffic
/// leaves from (for the recommended location, the exit's country), under
/// how it was chosen; otherwise the chosen location.
HomePlace homeLocation(
  AppLocalizations l,
  CoreStatus status, {
  required bool connected,
}) {
  final proxy = status.proxy;
  final exit = status.exit;
  final selection = status.selection.toLowerCase();
  final auto = switch (selection) {
    '' => l.recommendedLocation,
    'fastest' => l.modeFastest,
    _ => null,
  };
  if (connected && proxy != null) {
    final (code, name) = !isRecommendedPlace(proxy.countryCode)
        ? (proxy.countryCode, proxy.countryName)
        : exit != null && exit.countryCode.length == 2
        ? (exit.countryCode, exit.countryName)
        : ('', '');
    if (code.isNotEmpty) {
      return HomePlace(
        code,
        countryName(l, code, name),
        auto ?? l.connectedTo,
        auto: auto != null,
      );
    }
  }
  if (auto != null) return HomePlace('REC', auto, l.homeLocation);
  return HomePlace(
    status.selection.toUpperCase(),
    countryName(l, status.selection, status.selectionName),
    l.homeLocation,
  );
}

/// The notes the home pages show: not the ports Mozilla refuses, which
/// apps (every app, in the phone's VPN) try before falling back to 443;
/// the logs keep those.
List<Notice> homeNotices(List<Notice> notices) => [
  for (final n in notices)
    if (n.kind != 'port') n,
];

/// A country's flag in the design's own cut — the rounded plate, the
/// medal, the squircle or the ruled plate; a star for the recommended
/// location, and the code in a small box when there is no flag for it.
class CountryFlag extends StatelessWidget {
  const CountryFlag({super.key, required this.code, this.width = 28});

  final String code;
  final double width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = DesignStyle.of(context);
    final shape = style.flagShape;
    // The flag's box: the plate's own 3:2, except the circle — the
    // medal — whose diameter is the plate's height, the art cropped to
    // its middle band, the way the system's own tables show flags.
    final height = width * 3 / 4;
    final boxWidth = shape == FlagShape.circle ? height : width;
    final edge = scheme.outlineVariant.withValues(alpha: 0.6);
    final fallback = Container(
      width: boxWidth,
      height: height,
      alignment: Alignment.center,
      color: scheme.secondaryContainer,
      child: Text(
        code.toUpperCase(),
        style: TextStyle(
          fontSize: height * 0.45,
          fontWeight: FontWeight.w700,
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
    // The art fills the box whole: the circle and the squircle crop it
    // (cover), the plate keeps the paper's margin under its second rule.
    Widget art() => SizedBox(
      width: boxWidth,
      height: height,
      child: isRecommendedPlace(code)
            ? Container(
                alignment: Alignment.center,
                color: scheme.primaryContainer,
                // Mozilla's own mark: the recommended location is
                // Mozilla's recommender's pick, and the mark says so.
                child: SvgPicture.asset(
                  'assets/brand/mozilla_logo.svg',
                  width: height * 0.72,
                  height: height * 0.72,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    scheme.onPrimaryContainer,
                    BlendMode.srcIn,
                  ),
                  errorBuilder: (_, _, _) => Icon(
                    Icons.auto_awesome_rounded,
                    size: height * 0.7,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              )
            : code.length != 2
            ? fallback
            : bundledFlags.contains(code.toLowerCase())
            ? SvgPicture.asset(
                'assets/flags/${code.toLowerCase()}.svg',
                width: boxWidth,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              )
            // Not carried: from the core, the code until it arrives.
            : FutureBuilder(
                future: RemoteFlags.load(code.toLowerCase()),
                builder: (context, snapshot) => switch (snapshot.data) {
                  final svg? => SvgPicture.memory(
                    svg,
                    width: boxWidth,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => fallback,
                  ),
                  null => fallback,
                },
              ),
    );
    return switch (shape) {
      // The medal: the round cut, the hairline's edge.
      FlagShape.circle => Container(
        width: boxWidth,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: edge, width: 0.5)),
        child: art(),
      ),
      // The squircle: the continuous corners, no knee in the bend.
      FlagShape.squircle => Container(
        width: boxWidth,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(height * 0.42),
            side: BorderSide(color: edge, width: 0.5),
          ),
        ),
        child: art(),
      ),
      // The printed plate: the double rule around the art, the paper's
      // own margin between the rules.
      FlagShape.plate => Container(
        width: boxWidth,
        height: height,
        padding: const EdgeInsets.all(2.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.75), width: 0.9),
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            border: Border.all(color: edge.withValues(alpha: 0.7), width: 0.5),
          ),
          child: art(),
        ),
      ),
      // The soft rounded rectangle the older designs wear.
      FlagShape.rounded => Container(
        width: boxWidth,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(style.smallFlagRound),
          border: Border.all(color: edge, width: 0.5),
        ),
        child: art(),
      ),
    };
  }
}

/// The name of a routing region (`routing.region`) in the UI language.
String regionName(AppLocalizations l, String code) => switch (code) {
  'ir' => l.regionIr,
  'cn' => l.regionCn,
  'ru' => l.regionRu,
  'af' => l.regionAf,
  'tr' => l.regionTr,
  'id' => l.regionId,
  'br' => l.regionBr,
  _ => l.regionNone,
};

/// The languages, each in its own words.
const languageNames = {
  'en': 'English',
  'fa': 'فارسی',
  'ar': 'العربية',
  'zh': '简体中文',
  'zh_Hant': '繁體中文',
  'ru': 'Русский',
  'es': 'Español',
  'pt': 'Português (Brasil)',
  'tr': 'Türkçe',
  'fr': 'Français',
  'hu': 'Magyar',
  'id': 'Bahasa Indonesia',
  'az': 'Azərbaycan dili',
  'vi': 'Tiếng Việt',
  'bn': 'বাংলা',
};

/// Bundled UI fonts for every language the app speaks: Vazirmatn for
/// the Persian and the Arabic, Noto Sans SC for Simplified Chinese,
/// Noto Sans TC for Traditional, Noto Sans Bengali for Bengali, and
/// Inter — whose Latin, Cyrillic and Greek cover the rest. No language
/// reads in the phone's own face anymore; every one reads in the app's.
String? languageFont(String code) => switch (code) {
  'fa' || 'ar' => 'Vazirmatn',
  'zh' => 'NotoSansSC',
  'zh_Hant' => 'NotoSansTC',
  'bn' => 'NotoSansBengali',
  _ => 'Inter',
};

/// The bundled faces a text falls back through when the language's own
/// face misses a glyph — a Latin brand name inside Persian, a symbol
/// inside Chinese — the app's other faces before the phone's fonts.
List<String> fontFallbacks(String? font) => switch (font) {
  'Vazirmatn' => ['Inter', 'NotoSansSC', 'NotoSansTC', 'NotoSansBengali'],
  'NotoSansSC' => ['NotoSansTC', 'Inter', 'Vazirmatn', 'NotoSansBengali'],
  'NotoSansTC' => ['NotoSansSC', 'Inter', 'Vazirmatn', 'NotoSansBengali'],
  'NotoSansBengali' => ['Inter', 'NotoSansSC', 'NotoSansTC', 'Vazirmatn'],
  _ => ['Vazirmatn', 'NotoSansSC', 'NotoSansTC', 'NotoSansBengali'],
};

/// A title or label in its own language's font.
TextStyle? languageStyle(String code) => switch (languageFont(code)) {
  final font? => TextStyle(fontFamily: font),
  null => null,
};

/// The display's own face: the app's titles, the home's state word and
/// the stat values read in it — Space Grotesk's geometric voice for the
/// Latin languages (a face the phone's default could never be confused
/// with), and the language's own face for the rest: Vazirmatn for the
/// Persian and the Arabic, Noto Sans SC/TC for the Chinese, Noto Sans
/// Bengali for Bengali.
String displayFont(String code) => switch (code) {
  'fa' || 'ar' => 'Vazirmatn',
  'zh' => 'NotoSansSC',
  'zh_Hant' => 'NotoSansTC',
  'bn' => 'NotoSansBengali',
  _ => 'SpaceGrotesk',
};

/// The faces a display text falls back through — a Persian word inside
/// an English title, a Latin letter inside a Chinese one — the app's
/// other bundled faces before the phone's fonts.
List<String> displayFallbacks(String font) => switch (font) {
  'Vazirmatn' => [
    'SpaceGrotesk',
    'Inter',
    'NotoSansSC',
    'NotoSansTC',
    'NotoSansBengali',
  ],
  'NotoSansSC' => [
    'NotoSansTC',
    'SpaceGrotesk',
    'Inter',
    'Vazirmatn',
    'NotoSansBengali',
  ],
  'NotoSansTC' => [
    'NotoSansSC',
    'SpaceGrotesk',
    'Inter',
    'Vazirmatn',
    'NotoSansBengali',
  ],
  'NotoSansBengali' => [
    'SpaceGrotesk',
    'Inter',
    'NotoSansSC',
    'NotoSansTC',
    'Vazirmatn',
  ],
  _ => ['Inter', 'Vazirmatn', 'NotoSansSC', 'NotoSansTC', 'NotoSansBengali'],
};

/// The theme's display voice: the face the titles, the state word and
/// the stat values wear — set once by the app's theme (buildTheme), read
/// wherever a page needs its own display text.
class HomaTypefaces extends ThemeExtension<HomaTypefaces> {
  const HomaTypefaces({required this.display, required this.displayFallback});

  final String display;
  final List<String> displayFallback;

  @override
  HomaTypefaces copyWith({String? display, List<String>? displayFallback}) =>
      HomaTypefaces(
        display: display ?? this.display,
        displayFallback: displayFallback ?? this.displayFallback,
      );

  @override
  HomaTypefaces lerp(HomaTypefaces? other, double t) =>
      other == null || t < 0.5 ? this : other;

  @override
  bool operator ==(Object other) =>
      other is HomaTypefaces &&
      other.display == display &&
      listEquals(other.displayFallback, displayFallback);

  @override
  int get hashCode => Object.hash(display, Object.hashAll(displayFallback));
}

/// The display face of the current theme, with the body's face behind it
/// when a page has no theme of its own to read (a dialog on a test).
HomaTypefaces typefacesOf(BuildContext context) =>
    Theme.of(context).extension<HomaTypefaces>() ??
    const HomaTypefaces(
      display: 'Inter',
      displayFallback: [
        'Vazirmatn',
        'NotoSansSC',
        'NotoSansTC',
        'NotoSansBengali',
      ],
    );

/// The rounded box every settings row's icon sits in: one quiet surface,
/// one radius, everywhere — the tiles read as a single system, as Pixel's
/// settings do.
class IconBox extends StatelessWidget {
  const IconBox({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // The aether's iOS table wears the colored rounded badges; the other
    // designs keep the neutral tile they always had.
    return DesignStyle.of(context).badge(context, icon);
  }
}

/// The margin around a page: narrower on a phone.
EdgeInsets pagePadding(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 600
    ? const EdgeInsets.fromLTRB(16, 16, 16, 20)
    : const EdgeInsets.fromLTRB(28, 24, 28, 28);

/// Marks a page opened with its own top bar (Android), which names it.
class OwnTopBar extends InheritedWidget {
  const OwnTopBar({super.key, required super.child});

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<OwnTopBar>() != null;

  @override
  bool updateShouldNotify(OwnTopBar oldWidget) => false;
}

/// A page's title; nothing when the page has its own top bar.
class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => OwnTopBar.of(context)
      ? const SizedBox.shrink()
      : Reveal(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              // The page's title reads in the display's own voice.
              fontFamily: typefacesOf(context).display,
              fontFamilyFallback: typefacesOf(context).displayFallback,
            ),
          ),
        );
}

/// A titled card section.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
  });

  final String? title;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The design's card: the flat bordered card the monochrome wears,
    // the tighter iOS group or the very-round bento card for the rest —
    // each of them glass now: the fill the ground breathes through, the
    // rim's own hair of light, and the one sheen when the card lands.
    final look = AppDesign.current.look(theme.brightness == Brightness.dark);
    final round = DesignStyle.of(context).cardRadius;
    Widget card = LiquidGlass(
      radius: round,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
    // The neumorphism's card is drawn twice: once for its dual shadow
    // (a Card paints no negative offsets), then itself over it.
    if (look.cardShadow.isNotEmpty) {
      card = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: look.cardShadow,
        ),
        child: card,
      );
    }
    return Reveal(child: GlassSheen(child: card));
  }
}

/// The color of a quota by the share used, as the web dashboard shows it:
/// amber from 10 points before the account-switch threshold, red from the
/// threshold (where another account takes over, or, with none left, the
/// last share is being used). Without a threshold, the core's default.
Color quotaColor(double usedPercent, double thresholdPercent) {
  final threshold = thresholdPercent > 0 ? thresholdPercent : 95.0;
  return usedPercent >= threshold
      ? StatusColors.bad
      : usedPercent >= threshold - 10
      ? StatusColors.busy
      : StatusColors.good;
}

/// A usage bar with the account-switch threshold marked.
class QuotaBar extends StatelessWidget {
  const QuotaBar({super.key, required this.percent, this.threshold = 0});

  final double percent;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final value = (percent / 100).clamp(0.0, 1.0);
    final color = quotaColor(percent, threshold);
    return SizedBox(
      height: 8,
      child: LayoutBuilder(
        builder: (context, box) => Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  color: color,
                  backgroundColor: scheme.surfaceContainerHighest,
                ),
              ),
            ),
            if (threshold > 0 && threshold < 100)
              PositionedDirectional(
                start: box.maxWidth * threshold / 100 - 1,
                top: -3,
                bottom: -3,
                child: Tooltip(
                  message: AppLocalizations.of(context)
                      .switchAt(threshold.round()),
                  child: Container(width: 2, color: scheme.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A small rounded label.
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.color, this.icon});

  final String text;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c),
          ),
        ],
      ),
    );
  }
}

/// Runs [action] and shows its error, if any, in a snack bar.
Future<bool> runShowingErrors(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
    return true;
  } on CoreApiException catch (e) {
    if (context.mounted) showError(context, e.message);
  } on CoreUnavailable catch (e) {
    if (context.mounted) {
      showError(context, describeProblem(AppLocalizations.of(context), e));
    }
  } on VpnNotAllowed {
    if (context.mounted) {
      showError(context, AppLocalizations.of(context).vpnNotAllowed);
    }
  }
  return false;
}

/// The note that confirms an action arrived, in the way of iOS: a dark,
/// blurred pill that springs up near the bottom edge, its mark drawing
/// itself as it lands, waits a beat, and eases away. Not a snack bar —
/// no wide box, no button; the word and the mark, and nothing else. The
/// mark is a vector drawn by hand (a stroke that completes itself), not
/// an emoji: the same clean icon at any size, in either theme.
///
/// A note still showing leaves when a new one arrives, so a queue never
/// stacks pills on top of each other.
OverlayEntry? _toastEntry;

Future<void> showToast(
  BuildContext context,
  String message, {
  ToastMark mark = ToastMark.check,
  int maxLines = 2,
}) async {
  _toastEntry?.remove();
  // The note's own way out removes its entry, and the late binding lets
  // the closure name the entry it belongs to.
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _ToastNote(
      message: message,
      mark: mark,
      maxLines: maxLines,
      onDone: () {
        _toastEntry?.remove();
        if (_toastEntry == entry) _toastEntry = null;
      },
    ),
  );
  _toastEntry = entry;
  Overlay.of(context, rootOverlay: true).insert(entry);
}

/// The vector a toast draws beside its word. Every mark draws itself as
/// the note lands — the same clean stroke at any size, no emoji anywhere.
enum ToastMark {
  /// A check finishing its stroke: the work is done.
  check,

  /// Two sheets: the copy went to the clipboard.
  copy,

  /// An “i”: something worth knowing, nothing done.
  info,

  /// An exclamation: something went wrong, in the state's own red.
  alert,
}

/// One toast: its entrance (rise, fade, spring to size), its mark
/// drawing itself, a quiet hold, and its exit (sink and fade). Honors
/// the system's reduce-motion: then it only fades.
class _ToastNote extends StatefulWidget {
  const _ToastNote({
    required this.message,
    required this.mark,
    required this.maxLines,
    required this.onDone,
  });

  final String message;
  final ToastMark mark;
  final int maxLines;
  final VoidCallback onDone;

  @override
  State<_ToastNote> createState() => _ToastNoteState();
}

class _ToastNoteState extends State<_ToastNote> with TickerProviderStateMixin {
  late final AnimationController _in = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
  );
  late final AnimationController _draw = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );
  late final AnimationController _out = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  late final CurvedAnimation _inSpring = CurvedAnimation(
    parent: _in,
    curve: Curves.easeOutBack,
  );
  Timer? _hold;

  @override
  void initState() {
    super.initState();
    final still = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (still) {
      _in.value = _draw.value = 1;
      _hold = Timer(const Duration(milliseconds: 2200), _leave);
      return;
    }
    _in.forward();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _draw.forward();
    });
    _hold = Timer(const Duration(milliseconds: 2400), _leave);
  }

  @override
  void dispose() {
    _hold?.cancel();
    _in.dispose();
    _draw.dispose();
    _out.dispose();
    _inSpring.dispose();
    super.dispose();
  }

  void _leave() {
    _hold?.cancel();
    if (!_out.isAnimating && _out.value == 0) {
      _out.forward().whenCompleteOrCancel(widget.onDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Stack(
      children: [
        // Nothing blocks the page: the note floats, and a tap on it
        // alone sends it away.
        Positioned(
          left: 0,
          right: 0,
          bottom: media.padding.bottom + 28,
          child: IgnorePointer(
            ignoring: false,
            child: Center(
              child: FadeTransition(
                opacity: Tween(begin: 1.0, end: 0.0).animate(_out),
                child: SlideTransition(
                  position: Tween(begin: Offset.zero, end: const Offset(0, 0.4))
                      .animate(
                        CurvedAnimation(parent: _out, curve: Curves.easeIn),
                      ),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _in,
                      curve: Curves.easeOut,
                    ),
                    child: ScaleTransition(
                      scale: Tween(begin: 0.82, end: 1.0).animate(_inSpring),
                      child: GestureDetector(
                        onTap: _leave,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _ToastMarkView(mark: widget.mark, t: _draw),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      widget.message,
                                      maxLines: widget.maxLines,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The toast's mark, drawn as the [t] controller runs: a ring that
/// closes itself, then the mark's own stroke completing — vector lines
/// with round caps, the shape crisp at any size, no emoji anywhere. The
/// alert reads in the state's own red, the rest in the note's ink.
class _ToastMarkView extends StatelessWidget {
  const _ToastMarkView({required this.mark, required this.t});

  final ToastMark mark;
  final Animation<double> t;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: t,
      builder: (context, _) => CustomPaint(
        size: const Size(26, 26),
        painter: _ToastMarkPainter(progress: t.value, mark: mark),
      ),
    );
  }
}

class _ToastMarkPainter extends CustomPainter {
  _ToastMarkPainter({required this.progress, required this.mark});

  final double progress;
  final ToastMark mark;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final radius = size.width * 0.40;
    final paint = Paint()
      ..color = mark == ToastMark.alert ? const Color(0xFFFFB4AB) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    // The ring draws itself over the first half; the mark over the rest.
    final ring = Rect.fromCircle(center: c, radius: radius);
    canvas.drawArc(
      ring,
      -math.pi / 2,
      2 * math.pi * (progress * 2).clamp(0.0, 1.0),
      false,
      paint,
    );
    final draw = ((progress - 0.45) / 0.55).clamp(0.0, 1.0);
    if (draw <= 0) return;
    switch (mark) {
      case ToastMark.check:
        _stroke(
          canvas,
          paint,
          Path()
            ..moveTo(size.width * 0.32, size.height * 0.52)
            ..lineTo(size.width * 0.45, size.height * 0.65)
            ..lineTo(size.width * 0.70, size.height * 0.36),
          draw,
        );
      case ToastMark.copy:
        // The back sheet first (it appears whole by mid-draw), then the
        // front sheet draws over it.
        _stroke(
          canvas,
          paint,
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                size.width * 0.42,
                size.height * 0.22,
                size.width * 0.34,
                size.height * 0.42,
              ),
              const Radius.circular(3),
            ),
          ),
          (draw * 2).clamp(0.0, 1.0),
        );
        _stroke(
          canvas,
          paint,
          Path()..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                size.width * 0.24,
                size.height * 0.36,
                size.width * 0.42,
                size.height * 0.42,
              ),
              const Radius.circular(3),
            ),
          ),
          draw,
        );
      case ToastMark.info:
        // The dot lands, the stem rises.
        if (draw > 0.3) {
          canvas.drawCircle(
            Offset(size.width * 0.5, size.height * 0.32),
            1.6,
            paint..style = PaintingStyle.fill,
          );
        }
        _stroke(
          canvas,
          paint,
          Path()
            ..moveTo(size.width * 0.5, size.height * 0.48)
            ..lineTo(size.width * 0.5, size.height * 0.70),
          draw,
        );
      case ToastMark.alert:
        // The stem drops in, the dot closes the mark.
        _stroke(
          canvas,
          paint,
          Path()
            ..moveTo(size.width * 0.5, size.height * 0.28)
            ..lineTo(size.width * 0.5, size.height * 0.58),
          draw,
        );
        if (draw > 0.6) {
          canvas.drawCircle(
            Offset(size.width * 0.5, size.height * 0.72),
            1.6,
            paint..style = PaintingStyle.fill,
          );
        }
    }
  }

  /// Draws [path] up to [draw] of its own length.
  void _stroke(Canvas canvas, Paint paint, Path path, double draw) {
    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * draw), paint);
    }
  }

  @override
  bool shouldRepaint(_ToastMarkPainter old) =>
      old.progress != progress || old.mark != mark;
}

/// What went wrong, said in the app's own dynamic note — the same soft
/// glass pill every notice wears, its mark the state's own red. The
/// message keeps more lines than the small notes, so a failure still
/// says what it failed at.
void showError(BuildContext context, String message) {
  showToast(context, message, mark: ToastMark.alert, maxLines: 5);
}

/// An on/off choice in a "⋮" menu, as narrow as its name: a check box
/// that shows the state, then the name (CheckedPopupMenuItem keeps a
/// check's room even when off, which leaves the menu wide and empty).
PopupMenuItem<void> checkMenuItem({
  required String label,
  required bool checked,
  required VoidCallback onTap,
}) => PopupMenuItem<void>(
  onTap: onTap,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        checked
            ? Icons.check_box_rounded
            : Icons.check_box_outline_blank_rounded,
        size: 22,
      ),
      const SizedBox(width: 12),
      Flexible(child: Text(label)),
    ],
  ),
);

/// The app's own switch: the Material switch with the ear added — a
/// short sound on every turn, rising on, falling off, following the
/// settings' sound switch. Every switch of the app is one of these, so
/// every section answers the same way.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;

  /// Null while a change is under way (or forbidden).
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => Switch(
    value: value,
    onChanged: onChanged == null
        ? null
        : (v) {
            AppSounds.play(v ? SoundCue.toggleOn : SoundCue.toggleOff);
            onChanged!(v);
          },
  );
}

/// A small on/off switch with its name beside it, for a page's toolbar
/// (auto-scroll in the logs); the name toggles it too.
class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: () => onChanged(!value),
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 8, end: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // A narrow phone, or a long name: the name gives way.
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 4),
          Transform.scale(
            scale: 0.75,
            child: AppSwitch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    ),
  );
}

/// Opens the web page [url]; on a device without a browser (a TV), says
/// to open it on a phone or a computer, with the address to read. Not for
/// the dashboard's link, which holds a sign-in and works on this device
/// only.
Future<void> openLink(BuildContext context, String url) async {
  if (await openUrl(url) || !context.mounted) return;
  await showLink(context, url);
}

/// Shows a readable address when no system handler can open it.
Future<void> showLink(BuildContext context, String url) async {
  final l = AppLocalizations.of(context);
  final theme = Theme.of(context);
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.noBrowserTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.noBrowserText),
          const SizedBox(height: 12),
          SelectableText(
            ltr(url),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          autofocus: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.close),
        ),
      ],
    ),
  );
}

/// The Download button, where the app does not install updates itself:
/// opens the release's file for this copy of the app ([downloadUrl]) as
/// [openLink] does.
Future<void> openDownload(BuildContext context, Release release) async {
  final url = await downloadUrl(release);
  if (context.mounted) await openLink(context, url);
}

/// No account yet: a large notice, with Add account where the page has no
/// such button of its own ([onAdd]).
class NoAccountsPanel extends StatelessWidget {
  const NoAccountsPanel({super.key, this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Panel(
      // Across the whole panel, so its middle is the panel's.
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Icon(
              Icons.group_add_outlined,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l.noAccounts,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l.noAccountsHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onAdd != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: Text(l.addAccount),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// One social channel's button: the glyph drawn in the page's own ink,
/// the handle beside it, the link opening when tapped. The About page and
/// the What's New page both carry it, so the makers' channels are never
/// more than the same two taps away.
class SocialChannelButton extends StatelessWidget {
  const SocialChannelButton({
    super.key,
    required this.glyph,
    required this.handle,
    required this.url,
  });

  /// The channel's own mark, as an SVG string.
  final String glyph;
  final String handle;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = ColorFilter.mode(theme.colorScheme.onSurface, BlendMode.srcIn);
    return OutlinedButton(
      onPressed: () => openLink(context, url),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(glyph, width: 18, height: 18, colorFilter: ink),
          const SizedBox(width: 8),
          // The handle never wraps and never clips: the pill shrinks its
          // words to fit the row it is given — the narrowest phone keeps
          // '@Aliem_061' on one line, whole.
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                handle,
                textDirection: TextDirection.ltr,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
