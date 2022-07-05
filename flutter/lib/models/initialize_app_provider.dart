import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/assets_precache_provider.dart';
import 'package:sideswap/models/wallet.dart';

final initializeAppProvider = FutureProvider<bool>((ref) async {
  await ref.read(assetsPrecacheChangeNotifier).precache();
  await ref.read(walletProvider).startClient();

  return true;
});
