import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

final ordersPanelProvider = AutoDisposeProvider<Iterable<RequestOrder>>((ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  return ref
      .watch(marketRequestOrderListProvider)
      .where((e) => e.assetId == selectedAccountAsset.assetId && !e.private);
});

final ordersPanelBidsProvider = AutoDisposeProvider<List<RequestOrder>>((ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final orders = ref.watch(ordersPanelProvider);
  final selectedAsset = ref.watch(assetsStateProvider
      .select((value) => value[selectedAccountAsset.assetId]));
  final pricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
  final bids = orders.where((e) => e.sendBitcoins == pricedInLiquid).toList();
  bids.sort(compareRequestOrder(-1));
  return bids;
});

final ordersPanelAsksProvider = AutoDisposeProvider<List<RequestOrder>>((ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final orders = ref.watch(ordersPanelProvider);
  final selectedAsset = ref.watch(assetsStateProvider
      .select((value) => value[selectedAccountAsset.assetId]));
  final pricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
  final asks = orders.where((e) => e.sendBitcoins != pricedInLiquid).toList();
  asks.sort(compareRequestOrder(1));
  return asks;
});