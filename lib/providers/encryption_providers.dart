import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/encryption.dart';

part 'encryption_providers.g.dart';

@Riverpod(keepAlive: true)
AbstractEncryptionRepository encryptionRepository(Ref ref) {
  return EncryptionRepository();
}
