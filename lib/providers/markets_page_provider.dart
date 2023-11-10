import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

final marketsPageListenerProvider = AutoDisposeProvider((ref) {
  ref.keepAlive();
  final selectedAssetId = ref.watch(marketSelectedAssetIdStateProvider);
  final selectedAsset = ref.watch(assetsStateProvider)[selectedAssetId];
  final isProduct =
      ref.watch(assetUtilsProvider).isProduct(asset: selectedAsset);

  if (isProduct) {
    ref.watch(marketsProvider).subscribeIndexPrice(selectedAssetId);
    ref.watch(marketsProvider).subscribeSwapMarket(selectedAssetId);
  } else {
    ref.watch(marketsProvider).subscribeTokenMarket();
  }

  ref.onCancel(() {
    ref.read(marketsProvider).unsubscribeIndexPrice();
    ref.read(marketsProvider).unsubscribeMarket();
  });
});
