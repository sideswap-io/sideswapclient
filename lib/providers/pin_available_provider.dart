import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';

final pinAvailableProvider = Provider<bool>((ref) {
  return ref.watch(configProvider).usePinProtection;
});
