import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/assets_precache_provider.dart';
import 'package:sideswap/providers/wallet.dart';

final initializeAppProvider = FutureProvider<bool>((ref) async {
  await ref.read(assetsPrecacheChangeNotifier).precache();
  await ref.read(walletProvider).startClient();

  return true;
});
