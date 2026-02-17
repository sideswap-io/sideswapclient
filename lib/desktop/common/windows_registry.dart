import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

Future<void> registerProtocol(String scheme) async {
  if (!Platform.isWindows) {
    return;
  }

  final appPath = Platform.resolvedExecutable;

  final protocolRegKey = 'Software\\Classes\\$scheme';
  final protocolRegValue = RegistryValue.string('URL Protocol', '');

  final protocolCmdRegKey = 'shell\\open\\command';
  final protocolCmdRegValue = RegistryValue.string('', '"$appPath" "%1"');

  final regKey = Registry.currentUser.createKey(protocolRegKey);
  regKey.createValue(protocolRegValue);
  regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
}
