import 'dart:math';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'swap_market_provider.g.dart';

class Product {
  String assetId;
  String ticker;
  String displayName;

  Product({
    required this.assetId,
    required this.ticker,
    required this.displayName,
  });

  Product copyWith({
    String? assetId,
    String? ticker,
    String? displayName,
  }) {
    return Product(
      assetId: assetId ?? this.assetId,
      ticker: ticker ?? this.ticker,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  String toString() =>
      'Product(assetId: $assetId, ticker: $ticker, displayName: $displayName)';

  (String, String, String) _equality() => (assetId, ticker, displayName);

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) {
      return true;
    }

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
Product swapMarketCurrentProduct(SwapMarketCurrentProductRef ref) {
  final selectedAssetId = ref.watch(marketSelectedAssetIdStateProvider);
  final asset = ref.watch(assetsStateProvider)[selectedAssetId];
  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);

  if (asset == null) {
    return Product(
      assetId: tetherAssetId,
      displayName: '$kLiquidBitcoinTicker / $kTetherTicker',
      ticker: kTetherTicker,
    );
  }

  final displayName = asset.swapMarket == true
      ? '$kLiquidBitcoinTicker / ${asset.ticker}'
      : '${asset.ticker} / $kLiquidBitcoinTicker';

  return Product(
      assetId: selectedAssetId, ticker: asset.ticker, displayName: displayName);
}

final swapMarketOrdersProvider = AutoDisposeProvider<List<RequestOrder>>((ref) {
  final marketRequestOrderList = ref.watch(marketRequestOrderListProvider);

  return marketRequestOrderList.where((e) => !e.private).toList();
});

final swapMarketBidOffersProvider =
    AutoDisposeProvider<List<RequestOrder>>((ref) {
  final swapMarketOrders = ref.watch(swapMarketOrdersProvider);
  final currentProduct = ref.watch(swapMarketCurrentProductProvider);

  return swapMarketOrders
      .where((e) =>
          (e.sendBitcoins != (e.marketType == MarketType.stablecoin)) &&
          e.assetId == currentProduct.assetId)
      .sorted((a, b) => b.price.compareTo(a.price));
});

final swapMarketAskOffersProvider =
    AutoDisposeProvider<List<RequestOrder>>((ref) {
  final swapMarketOrders = ref.watch(swapMarketOrdersProvider);
  final currentProduct = ref.watch(swapMarketCurrentProductProvider);

  return swapMarketOrders
      .where((e) =>
          !(e.sendBitcoins != (e.marketType == MarketType.stablecoin)) &&
          e.assetId == currentProduct.assetId)
      .sorted((a, b) => a.price.compareTo(b.price));
});

final maxSwapOrderLengthProvider = AutoDisposeProvider<int>((ref) {
  final swapMarketBidOffers = ref.watch(swapMarketBidOffersProvider);
  final swapMarketAskOffers = ref.watch(swapMarketAskOffersProvider);

  return max(swapMarketBidOffers.length, swapMarketAskOffers.length);
});
