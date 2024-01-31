import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'orders_panel_provider.freezed.dart';
part 'orders_panel_provider.g.dart';

@freezed
class RequestOrderSortFlag with _$RequestOrderSortFlag {
  const factory RequestOrderSortFlag.all() = RequestOrderSortFlagAll;
  const factory RequestOrderSortFlag.online() = RequestOrderSortFlagOnline;
  const factory RequestOrderSortFlag.offline() = RequestOrderSortFlagOffline;
}

@riverpod
class RequestOrderSortFlagNotifier extends _$RequestOrderSortFlagNotifier {
  @override
  RequestOrderSortFlag build() {
    return const RequestOrderSortFlagAll();
  }

  void setSortFlag(RequestOrderSortFlag sortFlag) {
    state = sortFlag;
  }
}

@riverpod
Iterable<RequestOrder> ordersPanel(OrdersPanelRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);

  final requestOrderSortFlag = ref.watch(requestOrderSortFlagNotifierProvider);

  final requestOrders = ref
      .watch(marketRequestOrderListProvider)
      .where((e) => e.assetId == selectedAccountAsset.assetId && !e.private);

  return switch (requestOrderSortFlag) {
    RequestOrderSortFlagOnline() =>
      requestOrders.where((element) => element.twoStep == false),
    RequestOrderSortFlagOffline() =>
      requestOrders.where((element) => element.twoStep == true),
    _ => requestOrders,
  };
}

@riverpod
List<RequestOrder> ordersPanelBids(OrdersPanelBidsRef ref) {
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
}

@riverpod
List<RequestOrder> ordersPanelAsks(OrdersPanelAsksRef ref) {
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
}

@riverpod
int ordersPanelFilterBadgeCounter(OrdersPanelFilterBadgeCounterRef ref) {
  final requestOrderSortFlag = ref.watch(requestOrderSortFlagNotifierProvider);

  return switch (requestOrderSortFlag) {
    RequestOrderSortFlagAll() => 0,
    _ => 1,
  };
}
