import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/network_access_provider.dart';

final networkTypeProvider = Provider<SettingsNetworkType>((ref) {
  return ref.watch(configProvider).settingsNetworkType;
});
