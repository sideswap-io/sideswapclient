import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';

part 'biometric_available_provider.g.dart';

@riverpod
bool isBiometricEnabled(IsBiometricEnabledRef ref) {
  return ref.watch(configProvider).useBiometricProtection;
}
