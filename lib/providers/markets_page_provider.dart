import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'markets_page_provider.g.dart';

// use this provider from MarketsPageListener widget!
@riverpod
void marketsPageListener(MarketsPageListenerRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final selectedAsset =
      ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final isProduct =
      ref.watch(assetUtilsProvider).isProduct(asset: selectedAsset);

  if (isProduct) {
    ref
        .watch(marketsProvider)
        .subscribeIndexPrice(selectedAccountAsset.assetId);
    ref
        .watch(marketsProvider)
        .subscribeSwapMarket(selectedAccountAsset.assetId);
  } else {
    ref.watch(marketsProvider).subscribeTokenMarket();
  }

  ref.onCancel(() {
    ref.read(marketsProvider).unsubscribeIndexPrice();
    ref.read(marketsProvider).unsubscribeMarket();
  });
}
