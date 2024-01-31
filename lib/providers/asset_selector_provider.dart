import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'asset_selector_provider.g.dart';

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

@riverpod
List<AssetSelectorItem> assetSelector(
    AssetSelectorRef ref, MarketType marketType) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
  final assetsList = ref.watch(assetsStateProvider).values.toList();

  final newAssetSet = assetsList
      .where((e) =>
          e.assetId != liquidAssetId &&
          e.assetId != bitcoinAssetId &&
          assetMarketType(e) == marketType)
      .toSet();

  return switch (marketType) {
    MarketType.token => ref.watch(tokenAssetSelectorProvider(newAssetSet)),
    _ => newAssetSet
        .map((e) => AssetSelectorItem(assetId: e.assetId, ticker: e.ticker))
        .toList(),
  };
}

@Riverpod(keepAlive: true)
class TokenMarketOrder extends _$TokenMarketOrder {
  @override
  List<String> build() {
    return [];
  }

  void setTokenMarketOrder(List<String> values) {
    state = values;
  }
}

@riverpod
List<AssetSelectorItem> tokenAssetSelector(
    TokenAssetSelectorRef ref, Set<Asset> assetList) {
  final tokenOrderAssets = ref.watch(tokenMarketOrderProvider);

  final assetListCopy = [...assetList];
  final assetItems = <AssetSelectorItem>[];

  // create asset items in BE order
  for (final assetId in tokenOrderAssets) {
    final asset =
        assetListCopy.firstWhereOrNull((element) => element.assetId == assetId);
    (switch (asset) {
      Asset() => () {
          assetItems.add(
              AssetSelectorItem(assetId: asset.assetId, ticker: asset.ticker));
          assetListCopy.remove(asset);
        }(),
      _ => () {}(),
    });
  }

  // add the rest if any
  assetItems.addAll(assetListCopy
      .where((element) => !element.unregistered)
      .map((e) => AssetSelectorItem(assetId: e.assetId, ticker: e.ticker))
      .toList());

  return assetItems;
}
