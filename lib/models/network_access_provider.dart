import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:sideswap/models/config_provider.dart';

final networkAccessProvider = ChangeNotifierProvider<NetworkAccessProvider>(
    (ref) => NetworkAccessProvider(ref.read));

enum SettingsNetworkType {
  sideswap,
  blockstream,
  custom,
}

class NetworkAccessProvider with ChangeNotifier {
  NetworkAccessProvider(this.read);

  final Reader read;

  set networkType(SettingsNetworkType type) {
    read(configProvider)
        .setSettingsNetworkType(type)
        .then((value) => notifyListeners());

    if (type != SettingsNetworkType.custom) {
      read(configProvider).setSettingsHost('');
      read(configProvider).setSettingsPort('');
      read(configProvider).setSettingsPassword('');
      read(configProvider).setSettingsUseTLS(false);
    }
  }

  SettingsNetworkType get networkType {
    return read(configProvider).settingsNetworkType;
  }
}
