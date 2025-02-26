import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';

part 'biometric_available_provider.g.dart';

@riverpod
bool isBiometricEnabled(Ref ref) {
  return ref.watch(configurationProvider).useBiometricProtection;
}

@riverpod
FutureOr<bool> isBiometricAvailable(Ref ref) async {
  final isJadeWallet = ref.watch(isJadeWalletProvider);
  if (isJadeWallet) {
    return false;
  }

  final encryptionRepository = ref.watch(encryptionRepositoryProvider);
  return encryptionRepository.canAuthenticate();
}
