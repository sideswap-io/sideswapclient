import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

Future<void> registerProtocol(String scheme) async {
  if (!Platform.isWindows) {
    return;
  }

  final appPath = Platform.resolvedExecutable;

  final protocolRegKey = 'Software\\Classes\\$scheme';
  final protocolCmdRegKey = 'shell\\open\\command';

  final regKey = CURRENT_USER.create(protocolRegKey);
  regKey.setValue('URL Protocol', RegistryValue.string(''));
  regKey
      .create(protocolCmdRegKey)
      .setValue('', RegistryValue.string('"$appPath" "%1"'));
}
