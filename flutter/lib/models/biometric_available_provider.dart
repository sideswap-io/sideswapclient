import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/config_provider.dart';

final biometricAvailableProvider = Provider<bool>((ref) {
  return ref.watch(configProvider).useBiometricProtection;
});
