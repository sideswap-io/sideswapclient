import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/models/assets_precache_provider.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/wallet.dart';

final initializeAppProvider = FutureProvider<bool>((ref) async {
  await ref.read(configProvider).init();
  await ref.read(assetsPrecacheChangeNotifier).precache();
  await ref.read(walletProvider).startClient();

  return true;
});
