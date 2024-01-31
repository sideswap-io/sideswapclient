import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'swap_market_provider.g.dart';

class Product {
  final AccountAsset accountAsset;
  final String ticker;
  final String displayName;

  Product({
    required this.accountAsset,
    required this.ticker,
    required this.displayName,
  });

  Product copyWith({
    AccountAsset? accountAsset,
    String? ticker,
    String? displayName,
  }) {
    return Product(
      accountAsset: accountAsset ?? this.accountAsset,
      ticker: ticker ?? this.ticker,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  String toString() =>
      'Product(accountAsset: $accountAsset, ticker: $ticker, displayName: $displayName)';

  (AccountAsset, String, String) _equality() =>
      (accountAsset, ticker, displayName);

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
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final asset = ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);

  if (asset == null) {
    return Product(
      accountAsset: AccountAsset(AccountType.reg, tetherAssetId),
      displayName: '$kLiquidBitcoinTicker / $kTetherTicker',
      ticker: kTetherTicker,
    );
  }

  final displayName = asset.swapMarket == true
      ? '$kLiquidBitcoinTicker / ${asset.ticker}'
      : '${asset.ticker} / $kLiquidBitcoinTicker';

  return Product(
      accountAsset: selectedAccountAsset,
      ticker: asset.ticker,
      displayName: displayName);
}

final swapMarketOrdersProvider = AutoDisposeProvider<List<RequestOrder>>((ref) {
  final marketRequestOrderList = ref.watch(marketRequestOrderListProvider);

  return marketRequestOrderList.where((e) => !e.private).toList();
});

final maxSwapOrderLengthProvider = AutoDisposeProvider<int>((ref) {
  final bids = ref.watch(ordersPanelBidsProvider);
  final asks = ref.watch(ordersPanelAsksProvider);

  return max(bids.length, asks.length);
});
