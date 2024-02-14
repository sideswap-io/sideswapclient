import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';

part 'pin_available_provider.g.dart';

@riverpod
bool pinAvailable(PinAvailableRef ref) {
  return ref.watch(configurationProvider).usePinProtection;
}
