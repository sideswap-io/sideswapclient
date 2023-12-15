import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class AssetSelectorItem extends Equatable {
  final String assetId;
  final String ticker;

  const AssetSelectorItem({
    required this.assetId,
    required this.ticker,
  });

  @override
  List<Object?> get props => [assetId, ticker];
}

final assetSelectorProvider =
    AutoDisposeProviderFamily<List<AssetSelectorItem>, MarketType>(
        (ref, marketType) {
  // Only show token assets that we could sell or buy
  final tokenAssetsToSell = ref
      .watch(balancesNotifierProvider)
      .entries
      .where((e) => e.key.account == AccountType.reg && e.value > 0)
      .map((e) => e.key.assetId);
  final tokenAssetsToBuy = ref
      .watch(marketRequestOrderListProvider)
      .where((e) => e.marketType == MarketType.token)
      .map((e) => e.assetId);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
  final assetsList = ref.watch(assetsStateProvider).values.toList();

  final validTokenAssets = Set<String>.from(tokenAssetsToSell);
  validTokenAssets.addAll(tokenAssetsToBuy);

  return assetsList
      .where((e) =>
          e.assetId != liquidAssetId &&
          e.assetId != bitcoinAssetId &&
          assetMarketType(e) == marketType &&
          (marketType != MarketType.token ||
              validTokenAssets.contains(e.assetId)))
      .map((e) => AssetSelectorItem(assetId: e.assetId, ticker: e.ticker))
      .toList();
});
