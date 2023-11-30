import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/network_access_provider.dart';

part 'network_type_provider.g.dart';

// TODO (malcolmpl): remove after apply network settings?
@riverpod
SettingsNetworkType networkType(NetworkTypeRef ref) {
  return ref.watch(configProvider).settingsNetworkType;
}
