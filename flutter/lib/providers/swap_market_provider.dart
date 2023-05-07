import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

final swapMarketProvider =
    AutoDisposeChangeNotifierProvider<SwapMarketProvider>((ref) {
  final tetherAssetId = ref.watch(tetherAssetIdProvider);
  return SwapMarketProvider(ref, tetherAssetId);
});

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.assetId == assetId &&
        other.ticker == ticker &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => assetId.hashCode ^ ticker.hashCode ^ displayName.hashCode;
}

class SwapMarketProvider extends ChangeNotifier {
  final Ref ref;
  String tetherAssetId;

  SwapMarketProvider(this.ref, this.tetherAssetId);

  Product? _currentProduct;

  set currentProduct(Product value) {
    if (_currentProduct != value) {
      _currentProduct = value;
      notifyListeners();
    }
  }

  Product get currentProduct => _currentProduct ?? getDefaultProduct();

  Product getDefaultProduct() {
    return Product(
      assetId: tetherAssetId,
      displayName: '$kLiquidBitcoinTicker / $kTetherTicker',
      ticker: kTetherTicker,
    );
  }

  Product getProductFromAssetId(String assetId) {
    final asset = ref.read(assetsStateProvider)[assetId];
    final displayName = asset?.swapMarket == true
        ? '$kLiquidBitcoinTicker / ${asset?.ticker}'
        : '${asset?.ticker} / $kLiquidBitcoinTicker';

    return Product(
      assetId: assetId,
      displayName: displayName,
      ticker: asset?.ticker ?? '',
    );
  }
}

final swapMarketOrdersProvider = AutoDisposeProvider<List<RequestOrder>>((ref) {
  final marketRequestOrderList = ref.watch(marketRequestOrderListProvider);

  return marketRequestOrderList.where((e) => !e.private).toList();
});

final swapMarketBidOffersProvider =
    AutoDisposeProvider<List<RequestOrder>>((ref) {
  final swapMarketOrders = ref.watch(swapMarketOrdersProvider);
  final currentProduct = ref.watch(swapMarketProvider).currentProduct;

  return swapMarketOrders
      .where((e) =>
          (e.sendBitcoins != (e.marketType == MarketType.stablecoin)) &&
          e.assetId == currentProduct.assetId)
      .sorted((a, b) => b.price.compareTo(a.price));
});

final swapMarketAskOffersProvider =
    AutoDisposeProvider<List<RequestOrder>>((ref) {
  final swapMarketOrders = ref.watch(swapMarketOrdersProvider);
  final currentProduct = ref.watch(swapMarketProvider).currentProduct;

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
