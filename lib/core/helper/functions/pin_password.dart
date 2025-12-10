import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

Future<String?> promptForPinCreation(
  BuildContext context, {
  required String title,
  String? confirmTitle,
}) async {
  String? pinResult;
  await screenLockCreate(
    context: context,
    title: Text(title, style: const TextStyle(color: Colors.white)),
    confirmTitle: confirmTitle != null
        ? Text(confirmTitle, style: const TextStyle(color: Colors.white))
        : null,
    canCancel: true,
    cancelButton: const Icon(Icons.close, color: Colors.white),
    onConfirmed: (pin) {
      pinResult = pin;
      Navigator.of(context).pop();
    },
    config: const ScreenLockConfig(backgroundColor: Colors.black54),
    keyPadConfig: KeyPadConfig(
      buttonConfig: KeyPadButtonConfig(
        fontSize: 24,
        foregroundColor: Colors.white,
      ),
    ),
    deleteButton: const Icon(Icons.backspace, color: Colors.white),
    secretsConfig: SecretsConfig(
      secretConfig: SecretConfig(
        enabledColor: Colors.white,
        disabledColor: Colors.white38,
      ),
    ),
  );
  return pinResult;
}

Future<bool> promptForPinVerification(
  BuildContext context, {
  required String title,
  required String correctPin,
  bool canCancel = true,
}) async {
  bool verified = false;
  await screenLock(
    context: context,
    title: Text(title, style: const TextStyle(color: Colors.white)),
    correctString: correctPin,
    canCancel: canCancel,
    cancelButton: const Icon(Icons.close, color: Colors.white),
    onUnlocked: () {
      verified = true;
      Navigator.of(context).pop();
    },
    config: const ScreenLockConfig(backgroundColor: Colors.black54),
    deleteButton: const Icon(Icons.backspace, color: Colors.white),
    keyPadConfig: KeyPadConfig(
      buttonConfig: KeyPadButtonConfig(
        fontSize: 24,
        foregroundColor: Colors.white,
      ),
    ),
    secretsConfig: SecretsConfig(
      secretConfig: SecretConfig(
        enabledColor: Colors.white,
        disabledColor: Colors.white38,
      ),
    ),
  );
  return verified;
}
