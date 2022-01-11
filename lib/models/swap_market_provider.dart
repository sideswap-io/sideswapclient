import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

final swapMarketProvider = ChangeNotifierProvider<SwapMarketProvider>(
    (ref) => SwapMarketProvider(ref.read));

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
  Reader read;

  SwapMarketProvider(
    this.read,
  );

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
    return read(walletProvider)
        .assets
        .values
        .where((e) => e.swapMarket | e.ampMarket)
        .map((e) => e.assetId)
        .toList();
  }

  Product getDefaultProduct() {
    return Product(
      assetId: read(walletProvider).tetherAssetId(),
      displayName: '$kLiquidBitcoinTicker / $kTetherTicker',
      ticker: kTetherTicker,
    );
  }

  List<Product> getProducts() {
    final newList = <Product>[];
    newList.add(getDefaultProduct());
    final wallet = read(walletProvider);

    newList.addAll(read(swapMarketProvider).getProductsAssetId().map((e) {
      final asset = wallet.assets[e]!;
      final displayName = asset.ampMarket
          ? '${asset.ticker} / $kLiquidBitcoinTicker'
          : '$kLiquidBitcoinTicker / ${asset.ticker}';
      return Product(
        assetId: e,
        displayName: displayName,
        ticker: asset.ticker,
      );
    }).toList());

    return newList.toSet().toList();
  }

  void updateSwapMarketOrders(List<RequestOrder> requestOrders) {
    final newOrders = requestOrders
        .where((e) =>
            !e.private &&
            (e.marketType != MarketType.token) &&
            !DateTime.fromMillisecondsSinceEpoch(e.expiresAt)
                .difference(DateTime.now())
                .isNegative)
        .toList();

    if (const ListEquality<RequestOrder>()
        .equals(swapMarketOrders, newOrders)) {
      return;
    }

    swapMarketOrders.clear();
    swapMarketOrders.addAll(newOrders);

    updateOffers();

    notifyListeners();
  }

  bool isBid(bool sendBitcoins, bool isAmp) {
    return sendBitcoins == isAmp;
  }

  void updateOffers() {
    final isAmp =
        read(walletProvider).assets[currentProduct.assetId]?.ampMarket ?? false;
    bidOffers.clear();
    bidOffers.addAll(swapMarketOrders
        .where((e) =>
            isBid(e.sendBitcoins, isAmp) && e.assetId == currentProduct.assetId)
        .sorted((a, b) => b.price.compareTo(a.price)));
    askOffers.clear();
    askOffers.addAll(swapMarketOrders
        .where((e) =>
            !isBid(e.sendBitcoins, isAmp) &&
            e.assetId == currentProduct.assetId)
        .sorted((a, b) => a.price.compareTo(b.price)));
  }

  int getMaxSwapOrderLength() {
    return max(bidOffers.length, askOffers.length);
  }
}
