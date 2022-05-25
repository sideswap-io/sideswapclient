import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/config_provider.dart';

final networkAccessProvider =
    Provider<NetworkAccessProvider>((ref) => NetworkAccessProvider(ref));

enum SettingsNetworkType {
  blockstream,
  sideswap,
  custom,
}

class NetworkAccessProvider {
  NetworkAccessProvider(this.ref);

  final Ref ref;

  set networkType(SettingsNetworkType type) {
    ref.read(configProvider).setSettingsNetworkType(type);
  }
}
