import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';

part 'pin_available_provider.g.dart';

@riverpod
bool pinAvailable(Ref ref) {
  return ref.watch(configurationProvider).usePinProtection;
}

@riverpod
bool isPinAvailable(Ref ref) {
  final isJadeWallet = ref.watch(isJadeWalletProvider);
  if (isJadeWallet) {
    return false;
  }

  return true;
}
