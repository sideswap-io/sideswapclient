import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

final swapMarketProvider = ChangeNotifierProvider<SwapMarketProvider>(
    (ref) => SwapMarketProvider(ref));

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

  SwapMarketProvider(this.ref);

  final swapMarketOrders = <RequestOrder>[];
  final bidOffers = <RequestOrder>[];
  final askOffers = <RequestOrder>[];
  Product? _currentProduct;

  set currentProduct(Product value) {
    if (_currentProduct != value) {
      _currentProduct = value;
      updateOffers();
      notifyListeners();
    }
  }

  Product get currentProduct => _currentProduct ?? getDefaultProduct();

  List<String> getProductsAssetId() {
    return ref
        .read(walletProvider)
        .assets
        .values
        .where((e) => e.swapMarket | e.ampMarket)
        .map((e) => e.assetId)
        .toList();
  }

  Product getDefaultProduct() {
    return Product(
      assetId: ref.read(walletProvider).tetherAssetId(),
      displayName: '$kLiquidBitcoinTicker / $kTetherTicker',
      ticker: kTetherTicker,
    );
  }

  Product getProductFromAssetId(String assetId) {
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[assetId]!;
    final displayName = asset.swapMarket
        ? '$kLiquidBitcoinTicker / ${asset.ticker}'
        : '${asset.ticker} / $kLiquidBitcoinTicker';
    return Product(
      assetId: assetId,
      displayName: displayName,
      ticker: asset.ticker,
    );
  }

  void updateSwapMarketOrders(List<RequestOrder> requestOrders) {
    final newOrders = requestOrders.where((e) => !e.private).toList();

    if (const ListEquality<RequestOrder>()
        .equals(swapMarketOrders, newOrders)) {
      return;
    }

    swapMarketOrders.clear();
    swapMarketOrders.addAll(newOrders);

    updateOffers();

    notifyListeners();
  }

  bool isBid(bool sendBitcoins, MarketType marketType) {
    return sendBitcoins != (marketType == MarketType.stablecoin);
  }

  void updateOffers() {
    bidOffers.clear();
    bidOffers.addAll(swapMarketOrders
        .where((e) =>
            isBid(e.sendBitcoins, e.marketType) &&
            e.assetId == currentProduct.assetId)
        .sorted((a, b) => b.price.compareTo(a.price)));
    askOffers.clear();
    askOffers.addAll(swapMarketOrders
        .where((e) =>
            !isBid(e.sendBitcoins, e.marketType) &&
            e.assetId == currentProduct.assetId)
        .sorted((a, b) => a.price.compareTo(b.price)));
  }

  int getMaxSwapOrderLength() {
    return max(bidOffers.length, askOffers.length);
  }
}
