import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../core/android_core.dart';
import '../l10n/app_localizations.dart';
import 'motion.dart';
import 'sound.dart' show AppSounds, SoundCue;
import 'widgets.dart';

/// The account's own face and the app's own lock, both kept in the app's
/// settings (nothing leaves the device): the avatar is one of the ten
/// gradients below, the lock a salted SHA-256 the accounts page sets and
/// the app asks for when it opens.

/// The avatar presets: ten gradients, each with its own light. The key
/// the settings keep is 'g0'…'g9'; anything else reads as no choice.
class AccountAvatarPresets {
  AccountAvatarPresets._();

  /// The ten gradients, first to last.
  static const gradients = <List<Color>>[
    [Color(0xFF3D6BFF), Color(0xFF7FB0FF)],
    [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    [Color(0xFF00897B), Color(0xFF4DD0B1)],
    [Color(0xFFE05A8A), Color(0xFFFF9EB5)],
    [Color(0xFFF29B38), Color(0xFFFFC97A)],
    [Color(0xFF5E6B7A), Color(0xFF9FB0C0)],
    [Color(0xFF2E7D32), Color(0xFF81C784)],
    [Color(0xFF00838F), Color(0xFF4DD0E1)],
    [Color(0xFF6D4C41), Color(0xFFBCAAA4)],
    [Color(0xFF4527A0), Color(0xFF7C4DFF)],
  ];

  static const keys = [
    'g0', 'g1', 'g2', 'g3', 'g4',
    'g5', 'g6', 'g7', 'g8', 'g9',
  ];

  /// The gradient [key] names, or null when it names none.
  static List<Color>? of(String key) {
    final i = keys.indexOf(key);
    return i < 0 ? null : gradients[i];
  }
}

/// The account's own picture, chosen by hand: picked from the gallery,
/// made small enough to carry (512 px wide, PNG), and kept in the app's
/// data folder beside the settings file. The avatar's key then says
/// 'img:' and the file's path, so the presets' keys ('g0'…) stay what
/// they always were, and nothing leaves the device either way.
class AccountPhoto {
  AccountPhoto._();

  /// The key's mark that it names a file, and its path after it.
  static const prefix = 'img:';

  /// The picture is kept small: an avatar at the biggest size the app
  /// draws it (64 px) needs a fraction of this, and the file stays
  /// light on the storage too.
  static const maxWidth = 512;

  static bool isPhoto(String? key) => key != null && key.startsWith(prefix);

  static String pathOf(String key) => key.substring(prefix.length);

  /// Picks a picture, shrinks it, saves it, and names it the account's
  /// avatar. True when it landed; false when the user backed out or the
  /// pick could not be used (the note says so).
  static Future<bool> choose(
    BuildContext context,
    AppSettings settings,
    String accountId,
  ) async {
    final l = AppLocalizations.of(context);
    Uint8List? bytes;
    try {
      if (Platform.isAndroid) {
        // The phone's own dialog (the backup's read shows why): a
        // provider can be slow, and file_selector's copy would read
        // only what it says.
        bytes = await AndroidCore.openFile(
          mimes: const ['image/jpeg', 'image/png', 'image/webp'],
        );
      } else {
        final picked = await openFile(
          acceptedTypeGroups: const [
            XTypeGroup(label: 'images', mimeTypes: [
              'image/jpeg',
              'image/png',
              'image/webp',
            ]),
          ],
        );
        bytes = picked == null ? null : await picked.readAsBytes();
      }
      if (bytes == null || bytes.isEmpty) return false;
      // A picture this big is no avatar, and decoding it would take the
      // phone's breath for nothing.
      if (bytes.lengthInBytes > 32 * 1024 * 1024) {
        if (context.mounted) {
          showToast(context, l.avatarPhotoFailed, mark: ToastMark.alert);
        }
        return false;
      }
      final settingsFile = settings.file;
      if (settingsFile == null) return false;

      // Down to one width, the aspect kept: the decoder does the
      // resize itself, so no whole-size decode ever sits in memory.
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: maxWidth,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      frame.image.dispose();
      final encoded = data?.buffer.asUint8List();
      if (encoded == null || encoded.isEmpty) return false;

      final dir = Directory(
        '${settingsFile.parent.path}${Platform.pathSeparator}avatars',
      );
      await dir.create(recursive: true);
      final file = File(
        '${dir.path}${Platform.pathSeparator}$accountId.png',
      );
      // The picture it replaces goes: nothing keeps a file the avatar
      // no longer names.
      final previous = settings.accountAvatars[accountId];
      if (isPhoto(previous)) {
        try {
          final old = File(pathOf(previous!));
          if (await old.exists()) await old.delete();
        } on IOException {
          // An old picture that will not leave is no reason to stop.
        }
      }
      await file.writeAsBytes(encoded, flush: true);
      settings.update(accountAvatars: {
        ...settings.accountAvatars,
        accountId: '$prefix${file.path}',
      });
      return true;
    } on Exception {
      return false;
    } on Error {
      return false;
    }
  }
}

/// An account's avatar: the picture the user picked by hand, or the
/// gradient they chose with the account's first letter over it, or the
/// quiet monogram when they have not picked anything. The same face
/// everywhere an account's name stands.
class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    super.key,
    required this.name,
    required this.avatarKey,
    required this.active,
    this.size = 44,
  });

  final String name;
  final String avatarKey;
  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photo = AccountPhoto.isPhoto(avatarKey)
        ? File(AccountPhoto.pathOf(avatarKey))
        : null;
    final colors = photo == null ? AccountAvatarPresets.of(avatarKey) : null;
    final trimmed = name.trim();
    final initial = trimmed.isEmpty
        ? '?'
        : trimmed.characters.first.toUpperCase();
    final monogram = Text(
      initial,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: colors == null
            ? theme.colorScheme.onSurface
            : Colors.white,
      ),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: colors == null
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
        color: colors == null
            ? (active
                  ? theme.colorScheme.primary.withValues(alpha: 0.16)
                  : theme.colorScheme.surfaceContainerHighest)
            : null,
        border: active
            ? Border.all(color: theme.colorScheme.primary, width: 1.6)
            : null,
        boxShadow: colors == null
            ? null
            : [
                BoxShadow(
                  color: colors.first.withValues(alpha: 0.35),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                ),
              ],
      ),
      alignment: Alignment.center,
      clipBehavior: photo == null ? Clip.none : Clip.antiAlias,
      child: photo == null
          ? monogram
          // The picture the user chose, filling the circle; a file that
          // went missing under it falls back to the monogram, the face
          // stays an account's face either way.
          : Image.file(
              photo,
              width: size,
              height: size,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, _, _) => monogram,
            ),
    );
  }
}

/// The account avatar's own picker: the user's own picture, the ten
/// gradients, the live preview over them, and the reset to the plain
/// monogram.
Future<void> showAvatarPicker(
  BuildContext context,
  AppSettings settings,
  String accountId,
  String name,
  String currentKey,
) async {
  final l = AppLocalizations.of(context);
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: AccountAvatar(
                name: name,
                avatarKey: currentKey,
                active: true,
                size: 64,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l.accountProfile,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                // The account's own picture first: a pick from the
                // gallery, kept in the app's data folder. The presets
                // stand after it, and the reset is still the way back
                // to the plain monogram.
                _AvatarPhotoChoice(
                  selected: AccountPhoto.isPhoto(currentKey),
                  onTap: () async {
                    final ok = await AccountPhoto.choose(
                      context,
                      settings,
                      accountId,
                    );
                    if (!context.mounted) return;
                    if (ok) {
                      Navigator.pop(context);
                    } else {
                      showToast(
                        context,
                        l.avatarPhotoFailed,
                        mark: ToastMark.alert,
                      );
                    }
                  },
                ),
                for (var i = 0; i < AccountAvatarPresets.gradients.length; i++)
                  _AvatarChoice(
                    colors: AccountAvatarPresets.gradients[i],
                    presetKey: AccountAvatarPresets.keys[i],
                    initial: name.trim().isEmpty
                        ? '?'
                        : name.trim().characters.first.toUpperCase(),
                    selected: currentKey == AccountAvatarPresets.keys[i],
                    onTap: () {
                      settings.update(accountAvatars: {
                        ...settings.accountAvatars,
                        accountId: AccountAvatarPresets.keys[i],
                      });
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  final next = {...settings.accountAvatars}..remove(accountId);
                  settings.update(accountAvatars: next);
                  Navigator.pop(context);
                },
                child: Text(l.avatarReset),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The picker's own first choice: the account's picture from the
/// gallery — a photo chip in the row's own language, lit when the
/// account wears a picture now.
class _AvatarPhotoChoice extends StatelessWidget {
  const _AvatarPhotoChoice({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: l.avatarPhoto,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surfaceContainerHighest,
            border: selected
                ? Border.all(color: theme.colorScheme.primary, width: 2.4)
                : null,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_outlined,
            size: 22,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.colors,
    required this.presetKey,
    required this.initial,
    required this.selected,
    required this.onTap,
  });

  final List<Color> colors;
  final String presetKey;
  final String initial;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: presetKey,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            border: selected
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2.4,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// The account's rename: a field with the name it carries now, saved to
/// the settings when it lands.
Future<void> showRenameAccountDialog(
  BuildContext context,
  AppSettings settings,
  String accountId,
  String currentName,
) async {
  final l = AppLocalizations.of(context);
  final controller = TextEditingController(text: currentName);
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.accountRename),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 40,
        decoration: InputDecoration(labelText: l.accountRenameLabel),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isEmpty || name == currentName) {
              Navigator.pop(context);
              return;
            }
            settings.update(accountNames: {
              ...settings.accountNames,
              accountId: name,
            });
            Navigator.pop(context);
          },
          child: Text(l.save),
        ),
      ],
    ),
  );
}

/// The app password's hash: SHA-256 over salt+password, ten rounds
/// repeated — slow enough to discourage a glance, quick enough to unlock
/// in a breath.
String lockHashOf(String password, String salt) {
  List<int> bytes = utf8.encode('$salt$password');
  for (var i = 0; i < 10; i++) {
    bytes = sha256.convert(bytes).bytes;
  }
  return base64Encode(bytes);
}

/// A fresh salt for a new password.
String newLockSalt() {
  final rnd = Random.secure();
  return base64Encode(List.generate(16, (_) => rnd.nextInt(256)));
}

/// Asks for the app password. True when the word is the right one; the
/// caller decides what it opens.
Future<bool> confirmAppPassword(
  BuildContext context,
  AppSettings settings,
  String title,
) async {
  final l = AppLocalizations.of(context);
  final controller = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        obscureText: true,
        decoration: InputDecoration(labelText: l.appPasswordCurrent),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            final hash = lockHashOf(controller.text, settings.lockSalt);
            Navigator.pop(context, hash == settings.lockHash);
          },
          child: Text(l.done),
        ),
      ],
    ),
  );
  return ok == true;
}

/// Sets or changes the app password: the current one when there is one,
/// then the new word twice. The hash and a fresh salt land in the
/// settings; the toast says so in the app's own dynamic note.
Future<void> showChangePasswordDialog(
  BuildContext context,
  AppSettings settings, {
  required bool hasPassword,
}) async {
  final l = AppLocalizations.of(context);
  final next = TextEditingController();
  final again = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // The page's own context, captured before the dialog opens: the toast
  // rides it after the dialog has left.
  final page = context;
  final confirmed = !hasPassword ||
      await confirmAppPassword(context, settings, l.appPasswordChange);
  if (!confirmed || !context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(hasPassword ? l.appPasswordChange : l.appPasswordSet),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: next,
              autofocus: true,
              obscureText: true,
              decoration: InputDecoration(labelText: l.appPasswordNew),
              validator: (v) =>
                  (v ?? '').length < 4 ? l.appPasswordShort : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: again,
              obscureText: true,
              decoration: InputDecoration(labelText: l.appPasswordConfirm),
              validator: (v) => v != next.text ? l.appPasswordMismatch : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (!(formKey.currentState?.validate() ?? false)) return;
            final salt = newLockSalt();
            settings.update(
              lockSalt: salt,
              lockHash: lockHashOf(next.text, salt),
            );
            settings.lockUnlocked = true;
            Navigator.pop(dialog);
            showToast(page, l.appPasswordSetDone, mark: ToastMark.check);
          },
          child: Text(l.save),
        ),
      ],
    ),
  );
}

/// Removes the app password, after the current one says it may.
Future<void> showRemovePasswordDialog(
  BuildContext context,
  AppSettings settings,
) async {
  final l = AppLocalizations.of(context);
  final confirmed = await confirmAppPassword(
    context,
    settings,
    l.appPasswordRemove,
  );
  if (!confirmed || !context.mounted) return;
  settings.update(lockSalt: '', lockHash: '');
  settings.lockUnlocked = true;
  showToast(context, l.appPasswordRemoved, mark: ToastMark.info);
}

/// The lock the app opens behind: the mark, the field, and the word that
/// lets the rest of the app come through. A wrong word says so in the
/// note's own red.
class LockPage extends StatefulWidget {
  const LockPage({super.key, required this.settings, required this.onUnlocked});

  final AppSettings settings;
  final VoidCallback onUnlocked;

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  /// The wrong word's counter: every bump replays the field's shake.
  int _shake = 0;

  void _try() {
    final hash = lockHashOf(_controller.text, widget.settings.lockSalt);
    if (hash == widget.settings.lockHash) {
      widget.settings.lockUnlocked = true;
      // The lock lets go with its own double ping.
      AppSounds.play(SoundCue.lock);
      widget.onUnlocked();
      return;
    }
    _controller.clear();
    _focus.requestFocus();
    setState(() => _shake++);
    showToast(context, AppLocalizations.of(context).appPasswordWrong,
        mark: ToastMark.alert);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogo(size: 64),
                const SizedBox(height: 18),
                Text(
                  l.appPasswordUnlock,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  l.appPasswordUnlockHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                Shake(
                  trigger: _shake,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: true,
                    obscureText: true,
                    onSubmitted: (_) => _try(),
                    decoration: InputDecoration(
                      labelText: l.appPasswordCurrent,
                      suffixIcon: IconButton(
                        onPressed: _try,
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
