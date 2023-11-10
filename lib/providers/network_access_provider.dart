import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';

final networkAccessProvider =
    Provider<NetworkAccessProvider>((ref) => NetworkAccessProvider(ref));

enum SettingsNetworkType {
  blockstream,
  sideswap,
  personal,
}

class NetworkAccessProvider {
  NetworkAccessProvider(this.ref);

  final Ref ref;

  set networkType(SettingsNetworkType type) {
    ref.read(configProvider).setSettingsNetworkType(type);
  }
}
