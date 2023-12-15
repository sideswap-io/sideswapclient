import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';

import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/markets/widgets/modify_price_dialog.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/duration_extension.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'markets_provider.g.dart';

enum RequestOrderType {
  order,
}

extension RequestOrderEx on RequestOrder {
  DateTime getCreatedAt() {
    return DateTime.fromMillisecondsSinceEpoch(createdAt);
  }

  String getCreatedAtFormatted() {
    final shortFormat = DateFormat('MMM d, yyyy');
    return shortFormat.format(getCreatedAt());
  }

  Duration? getExpiresAt() {
    if (expiresAt == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(expiresAt!)
        .difference(DateTime.now());
  }

  bool isExpired() {
    final expiresAt = getExpiresAt();
    return expiresAt != null && expiresAt.isNegative;
  }

  Duration? getExpireDuration() {
    if (expiresAt == null) {
      return null;
    }
    final expireAt = DateTime.fromMillisecondsSinceEpoch(expiresAt!);
    final duration = expireAt.difference(DateTime.now());
    return duration;
  }

  String getExpireDescription() {
    final duration = getExpireDuration();
    return duration.toStringCustom();
  }

  int get bitcoinAmountWithFee {
    return sendBitcoins ? bitcoinAmount + serverFee : bitcoinAmount - serverFee;
  }
}

// TODO (malcolmpl): fix this - AccountAsset instead of assetId (and maybe marketType, as accountasset is include type?)
class RequestOrder {
  final String orderId;
  final String assetId;
  final int bitcoinAmount;
  final int serverFee;
  final int assetAmount;
  final double price;
  final int createdAt;
  final int? expiresAt;
  final RequestOrderType requestOrderType = RequestOrderType.order;
  final bool private;
  final bool sendBitcoins;
  final bool twoStep;
  final bool autoSign;
  final bool own;
  final MarketType marketType;
  final double indexPrice;
  final bool isNew;
  RequestOrder({
    required this.orderId,
    required this.assetId,
    required this.bitcoinAmount,
    required this.serverFee,
    required this.assetAmount,
    required this.price,
    required this.createdAt,
    required this.expiresAt,
    required this.private,
    required this.sendBitcoins,
    required this.twoStep,
    required this.autoSign,
    required this.own,
    required this.marketType,
    required this.indexPrice,
    required this.isNew,
  });

  @override
  String toString() {
    return 'RequestOrder(orderId: $orderId, assetId: $assetId, bitcoinAmount: $bitcoinAmount, serverFee: $serverFee, assetAmount: $assetAmount, price: $price, createdAt: $createdAt, expiresAt: $expiresAt, private: $private, sendBitcoins: $sendBitcoins, autoSign: $autoSign, own: $own, marketType: $marketType, indexPrice: $indexPrice, isNew: $isNew)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestOrder &&
        other.orderId == orderId &&
        other.assetId == assetId &&
        other.bitcoinAmount == bitcoinAmount &&
        other.serverFee == serverFee &&
        other.assetAmount == assetAmount &&
        other.price == price &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.private == private &&
        other.sendBitcoins == sendBitcoins &&
        other.autoSign == autoSign &&
        other.own == own &&
        other.marketType == marketType &&
        other.indexPrice == indexPrice &&
        other.isNew == isNew;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        assetId.hashCode ^
        bitcoinAmount.hashCode ^
        serverFee.hashCode ^
        assetAmount.hashCode ^
        price.hashCode ^
        createdAt.hashCode ^
        expiresAt.hashCode ^
        private.hashCode ^
        sendBitcoins.hashCode ^
        autoSign.hashCode ^
        own.hashCode ^
        marketType.hashCode ^
        indexPrice.hashCode ^
        isNew.hashCode;
  }

  bool isSell() {
    // On stablecoin market we sell/buy L-BTC for asset
    // On AMP/token market we sell/buy asset for L-BTC
    return (marketType == MarketType.stablecoin) != sendBitcoins;
  }
}

enum SubscribedMarket {
  none,
  token,
  asset,
}

final marketsProvider =
    ChangeNotifierProvider<MarketsProvider>((ref) => MarketsProvider(ref));

class MarketsProvider extends ChangeNotifier {
  final Ref ref;

  MarketsProvider(this.ref);

  String _subscribedIndexPriceAssetId = '';

  SubscribedMarket subscribedMarket = SubscribedMarket.none;

  void subscribeTokenMarket() {
    subscribedMarket = SubscribedMarket.token;
    final msg = To();
    msg.subscribe = To_Subscribe();
    msg.subscribe.markets.add(To_Subscribe_Market(assetId: null));
    ref.read(walletProvider).sendMsg(msg);
  }

  void subscribeSwapMarket(String? assetId) {
    if (assetId == null || assetId.isEmpty) {
      return;
    }
    final asset = ref.read(assetsStateProvider)[assetId];

    subscribedMarket = SubscribedMarket.asset;
    final msg = To();
    msg.subscribe = To_Subscribe();
    if (asset?.ampMarket == true || asset?.swapMarket == true) {
      msg.subscribe.markets.add(To_Subscribe_Market(assetId: assetId));
    }
    // Subscribe to the token market constantly to show new assets in the product selector
    msg.subscribe.markets.add(To_Subscribe_Market(assetId: null));
    ref.read(walletProvider).sendMsg(msg);
  }

  void unsubscribeMarket() {
    subscribedMarket = SubscribedMarket.none;
    final msg = To();
    msg.subscribe = To_Subscribe();
    ref.read(walletProvider).sendMsg(msg);
  }

  void subscribeIndexPrice(String? assetId) {
    if (assetId == null) {
      logger.w("Asset id is null!");
      return;
    }

    // don't subscribe liquid
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    if (assetId == liquidAssetId) {
      return;
    }

    // don't subscribe if already subscribed
    if (assetId == _subscribedIndexPriceAssetId) {
      return;
    }

    unsubscribeIndexPrice();
    _subscribedIndexPriceAssetId = assetId;

    final msg = To();
    msg.subscribePrice = AssetId();
    msg.subscribePrice.assetId = assetId;
    ref.read(walletProvider).sendMsg(msg);
  }

  void unsubscribeIndexPrice() {
    if (_subscribedIndexPriceAssetId.isEmpty) {
      return;
    }

    final msg = To();
    msg.unsubscribePrice = AssetId();
    msg.unsubscribePrice.assetId = _subscribedIndexPriceAssetId;
    ref.read(walletProvider).sendMsg(msg);

    _subscribedIndexPriceAssetId = '';
  }

  String subscribedIndexPriceAssetId() {
    return _subscribedIndexPriceAssetId;
  }

  Future<void> onModifyPrice(WidgetRef ref, RequestOrder? requestOrder) async {
    if (requestOrder == null) {
      return;
    }

    final price =
        ref.read(marketRequestOrderByIdProvider(requestOrder.orderId))?.price ??
            0;
    final priceStr = priceStrForEdit(price);

    final TextEditingController controller = TextEditingController()
      ..text = priceStr;

    final context = ref.read(navigatorKeyProvider).currentContext;
    if (context == null) {
      return;
    }

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            final assetId = requestOrder.assetId;
            final asset = ref
                .watch(assetsStateProvider.select((value) => value[assetId]));
            final liquidAsset =
                ref.watch(assetUtilsProvider).regularLiquidAsset();
            final priceAsset = asset?.swapMarket == true ? asset : liquidAsset;
            final icon = ref
                .watch(assetImageProvider)
                .getSmallImage(priceAsset?.assetId);
            final assetPrecision = ref
                .watch(assetUtilsProvider)
                .getPrecisionForAssetId(assetId: requestOrder.assetId);
            final orderDetailsData =
                OrderDetailsData.fromRequestOrder(requestOrder, assetPrecision);
            return ModifyPriceDialog(
              controller: controller,
              orderDetailsData: orderDetailsData,
              asset: priceAsset,
              productAsset: asset,
              icon: icon,
            );
          },
        );
      },
    );
  }
}

final marketsIndexPriceProvider =
    AutoDisposeNotifierProvider<MarketsIndexPriceProvider, Map<String, double>>(
        MarketsIndexPriceProvider.new);

class MarketsIndexPriceProvider
    extends AutoDisposeNotifier<Map<String, double>> {
  @override
  Map<String, double> build() {
    ref.keepAlive();
    return {};
  }

  void setIndexPrice(String assetId, double? ind) {
    if (assetId.isEmpty) {
      return;
    }

    final indexPriceMap = {...state};

    if (ind != null) {
      indexPriceMap[assetId] = ind;
      state = indexPriceMap;
      return;
    }

    indexPriceMap.remove(assetId);
    state = indexPriceMap;
  }
}

@riverpod
IndexPriceForAsset indexPriceForAsset(
    IndexPriceForAssetRef ref, String? assetId) {
  final indexPrice = ref.watch(marketsIndexPriceProvider);
  final isAmp = ref.watch(assetUtilsProvider).isAmpMarket(assetId: assetId);
  return IndexPriceForAsset(indexPrice[assetId] ?? 0, assetId, isAmp);
}

class IndexPriceForAsset {
  final double indexPrice;
  final String? assetId;
  final bool isAmp;

  IndexPriceForAsset(this.indexPrice, this.assetId, this.isAmp);

  String getIndexPriceStr() {
    if (indexPrice == 0) {
      return '';
    }
    return priceStr(indexPrice, isAmp);
  }

  String calculateTrackingPrice(double sliderValue) {
    final indexPrice = getIndexPriceStr();
    final indexPriceValue = double.tryParse(indexPrice) ?? 0;

    final trackingPriceValue =
        indexPriceValue + indexPriceValue * (sliderValue / 100);
    return trackingPriceValue.toStringAsFixed(2);
  }
}

final marketsLastIndexPriceProvider = AutoDisposeNotifierProvider<
    MarketsLastIndexPriceProvider,
    Map<String, double>>(MarketsLastIndexPriceProvider.new);

class MarketsLastIndexPriceProvider
    extends AutoDisposeNotifier<Map<String, double>> {
  @override
  Map<String, double> build() {
    ref.keepAlive();
    return {};
  }

  void setLastIndexPrice(String assetId, double? last) {
    if (assetId.isEmpty) {
      return;
    }

    final lastIndexPriceMap = {...state};

    if (last != null) {
      lastIndexPriceMap[assetId] = last;
      state = lastIndexPriceMap;
      return;
    }

    lastIndexPriceMap.remove(assetId);
    state = lastIndexPriceMap;
  }
}

@riverpod
double lastIndexPriceForAsset(LastIndexPriceForAssetRef ref, String? assetId) {
  final lastIndexPriceMap = ref.watch(marketsLastIndexPriceProvider);
  return lastIndexPriceMap[assetId] ?? 0;
}

@riverpod
String lastStringIndexPriceForAsset(
    LastStringIndexPriceForAssetRef ref, String? assetId) {
  final lastIndexPrice = ref.watch(lastIndexPriceForAssetProvider(assetId));

  if (lastIndexPrice == 0) {
    return '';
  }

  final asset = ref.watch(assetsStateProvider)[assetId];
  final assetUtils = ref.watch(assetUtilsProvider);

  final precision = assetUtils.getPrecisionForAssetId(assetId: asset?.assetId);
  final isPricedInLiquid = assetUtils.isPricedInLiquid(asset: asset);

  return priceStr(lastIndexPrice, isPricedInLiquid,
      precision: precision == 0 ? 8 : precision);
}

final indexPriceButtonProvider =
    AutoDisposeStateNotifierProvider<IndexPriceProvider, String>(
        (ref) => IndexPriceProvider(ref));

class IndexPriceProvider extends StateNotifier<String> {
  final Ref ref;

  IndexPriceProvider(this.ref) : super('0');

  void setIndexPrice(String value) {
    if (mounted) {
      state = value;
      ref.notifyListeners();
    }
  }
}

final marketRequestOrdersProvider = AutoDisposeNotifierProvider<
    MarketOrdersProvider, Map<String, RequestOrder>>(MarketOrdersProvider.new);

class MarketOrdersProvider
    extends AutoDisposeNotifier<Map<String, RequestOrder>> {
  final _marketRequestOrders = <String, RequestOrder>{};

  @override
  Map<String, RequestOrder> build() {
    ref.keepAlive();

    return _marketRequestOrders;
  }

  void insertOrder(RequestOrder order) {
    _marketRequestOrders[order.orderId] = order;
    ref.notifyListeners();

    if (ref.read(currentRequestOrderViewProvider)?.orderId == order.orderId) {
      ref.read(currentRequestOrderViewProvider.notifier).state = order;
    }
  }

  void removeOrder(String orderId) {
    _marketRequestOrders.remove(orderId);
    ref.notifyListeners();

    if (orderId == ref.read(currentRequestOrderViewProvider)?.orderId) {
      ref.read(walletProvider).setRegistered();
    }
  }

  void clearOrders() {
    _marketRequestOrders.clear();
    ref.notifyListeners();
  }
}

final marketRequestOrderListProvider =
    AutoDisposeProvider<List<RequestOrder>>((ref) {
  final marketRequestOrders = ref.watch(marketRequestOrdersProvider);

  return marketRequestOrders.values.toList();
});

final marketRequestOrderByIdProvider =
    AutoDisposeProviderFamily<RequestOrder?, String>((ref, arg) {
  final marketRequestOrders = ref.watch(marketRequestOrdersProvider);
  return marketRequestOrders[arg];
});

final marketOwnRequestOrdersProvider =
    AutoDisposeProvider<List<RequestOrder>>((ref) {
  final marketRequestOrders = ref.watch(marketRequestOrderListProvider);
  return marketRequestOrders.where((e) => e.own == true).toList();
});

@Riverpod(keepAlive: true)
class MarketSelectedAccountAssetState
    extends _$MarketSelectedAccountAssetState {
  @override
  AccountAsset build() {
    final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
    return AccountAsset(AccountType.reg, tetherAssetId);
  }

  void setSelectedAccountAsset(AccountAsset accountAsset) {
    state = accountAsset;
  }
}

final makeOrderBalanceAccountAssetProvider =
    AutoDisposeProvider<AccountAsset?>((ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final selectedAsset =
      ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final pricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
  final makeOrderSide = ref.watch(makeOrderSideStateProvider);
  final isSell = makeOrderSide == MakeOrderSide.sell;
  final balanceAssetAccount = pricedInLiquid == isSell
      ? selectedAccountAsset
      : AccountAsset(selectedAccountAsset.account, liquidAssetId);
  final allAccountAssets = ref.watch(allAccountAssetsProvider);

  return allAccountAssets.where((e) => e == balanceAssetAccount).firstOrNull;
});

class MakeOrderBalance {
  late final String balanceString;
  late final int balanceSatoshi;
  late final String ticker;
  late final String assetId;

  MakeOrderBalance({
    required this.balanceString,
    required this.balanceSatoshi,
    required this.ticker,
    required this.assetId,
  });

  double asDouble() {
    return double.tryParse(balanceString) ?? 0.0;
  }

  Decimal asDecimal() {
    return Decimal.tryParse(balanceString) ?? Decimal.zero;
  }

  (String, int, String) _equality() => (balanceString, balanceSatoshi, ticker);

  @override
  bool operator ==(covariant MakeOrderBalance other) {
    if (identical(this, other)) {
      return true;
    }
    return other._equality() == _equality();
  }

  @override
  int get hashCode {
    return _equality().hashCode;
  }
}

@riverpod
MakeOrderBalance makeOrderBalance(MakeOrderBalanceRef ref) {
  final accountAsset = ref.watch(makeOrderBalanceAccountAssetProvider);

  return switch (accountAsset) {
    final accountAsset? => () {
        final assetPrecision = ref
            .watch(assetUtilsProvider)
            .getPrecisionForAssetId(assetId: accountAsset.assetId);
        final balance = ref.watch(balancesNotifierProvider)[accountAsset] ?? 0;
        final amountProvider = ref.watch(amountToStringProvider);
        final ticker = ref.watch(assetsStateProvider
            .select((value) => value[accountAsset.assetId]?.ticker ?? ''));
        final balanceStr = amountProvider.amountToString(
            AmountToStringParameters(
                amount: balance, precision: assetPrecision));

        return MakeOrderBalance(
          balanceString: balanceStr,
          balanceSatoshi: balance,
          ticker: ticker,
          assetId: accountAsset.assetId ?? '',
        );
      }(),
    _ => MakeOrderBalance(
        balanceString: '0',
        balanceSatoshi: 0,
        ticker: '',
        assetId: '',
      ),
  };
}

enum MakeOrderSide {
  sell,
  buy,
}

@Riverpod(keepAlive: true)
class MakeOrderSideState extends _$MakeOrderSideState {
  @override
  MakeOrderSide build() {
    return MakeOrderSide.sell;
  }

  void setSide(MakeOrderSide side) {
    state = side;
  }
}

@riverpod
AccountAsset? marketOrderAggregateVolumeAccountAsset(
    MarketOrderAggregateVolumeAccountAssetRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final selectedAsset =
      ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final pricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final allAccountAssets = ref.watch(allAccountAssetsProvider);

  final assetId = pricedInLiquid ? liquidAssetId : selectedAccountAsset.assetId;

  return allAccountAssets.where((e) => e.assetId == assetId).firstOrNull;
}

@riverpod
String marketOrderAggregateVolumeTicker(
    MarketOrderAggregateVolumeTickerRef ref) {
  final accountAsset =
      ref.watch(marketOrderAggregateVolumeAccountAssetProvider);
  final assetState = ref.watch(assetsStateProvider);

  return switch (accountAsset) {
    final accountAsset? => assetState[accountAsset.assetId]?.ticker ?? '',
    _ => '',
  };
}

@riverpod
MarketOrderAggregateVolumeProvider marketOrderAggregateVolume(
    MarketOrderAggregateVolumeRef ref) {
  final amount = ref.watch(marketOrderAmountNotifierProvider);
  final price = ref.watch(marketOrderPriceNotifierProvider);
  final accountAsset =
      ref.watch(marketOrderAggregateVolumeAccountAssetProvider);
  final assetPrecision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: accountAsset?.assetId);

  return MarketOrderAggregateVolumeProvider(
    amount: amount.asString(),
    price: price.asString(),
    accountAsset: accountAsset,
    assetPrecision: assetPrecision,
  );
}

class MarketOrderAggregateVolumeProvider {
  final String amount;
  final String price;
  final AccountAsset? accountAsset;
  final int assetPrecision;
  late Decimal amountWithPrecision;
  late Decimal multipliedInSat;
  late Decimal power;

  MarketOrderAggregateVolumeProvider({
    required this.amount,
    required this.price,
    required this.accountAsset,
    required this.assetPrecision,
  }) {
    final amountDecimal = Decimal.tryParse(amount) ?? Decimal.zero;
    final priceDecimal = Decimal.tryParse(price) ?? Decimal.zero;
    multipliedInSat = amountDecimal * priceDecimal * Decimal.fromInt(kCoin);
    power = Decimal.tryParse(
            pow(10, assetPrecision).toStringAsFixed(assetPrecision)) ??
        Decimal.zero;
    amountWithPrecision = (multipliedInSat / power).toDecimal();
  }

  String asString() {
    if (assetPrecision == 0) {
      return amountWithPrecision.toBigInt().toString();
    }

    return (multipliedInSat / power)
        .toDecimal()
        .toStringAsFixed(assetPrecision);
  }

  double asDouble() {
    return double.tryParse(asString()) ?? 0.0;
  }

  (String, String, AccountAsset?, int, Decimal, Decimal, Decimal) _equality() =>
      (
        amount,
        price,
        accountAsset,
        assetPrecision,
        amountWithPrecision,
        multipliedInSat,
        power
      );

  @override
  bool operator ==(covariant MarketOrderAggregateVolumeProvider other) {
    if (identical(this, other)) {
      return true;
    }
    return other._equality() == _equality();
  }

  @override
  int get hashCode {
    return _equality().hashCode;
  }
}

@riverpod
String marketOrderAggregateVolumeWithTicker(
    MarketOrderAggregateVolumeWithTickerRef ref) {
  final ticker = ref.watch(marketOrderAggregateVolumeTickerProvider);
  final aggregateVolume = ref.watch(marketOrderAggregateVolumeProvider);

  return '${aggregateVolume.asString()} $ticker';
}

class MarketOrderAmount {
  late final Decimal amount;

  MarketOrderAmount({required String value}) {
    amount = Decimal.tryParse(value) ?? Decimal.zero;
  }

  String asString() {
    return amount.toString();
  }

  double asDouble() {
    return amount.toDouble();
  }

  (Decimal,) _equality() => (amount,);

  @override
  bool operator ==(covariant MarketOrderAmount other) {
    if (identical(this, other)) {
      return true;
    }
    return other._equality() == _equality();
  }

  @override
  int get hashCode {
    return _equality().hashCode;
  }
}

@riverpod
class MarketOrderAmountNotifier extends _$MarketOrderAmountNotifier {
  @override
  MarketOrderAmount build() {
    return MarketOrderAmount(value: '0.0');
  }

  void setOrderAmount(String amount) {
    final amountDecimal = Decimal.tryParse(amount) ?? Decimal.zero;
    if (state.amount != amountDecimal) {
      state = MarketOrderAmount(value: amount);
    }
  }
}

@riverpod
class MarketOrderPriceNotifier extends _$MarketOrderPriceNotifier {
  @override
  MarketOrderAmount build() {
    return MarketOrderAmount(value: '0.0');
  }

  void setOrderPrice(String price) {
    final priceDecimal = Decimal.tryParse(price) ?? Decimal.zero;
    if (state.amount != priceDecimal) {
      state = MarketOrderAmount(value: price);
    }
  }
}

@riverpod
bool makeOrderAggregateVolumeTooHigh(MakeOrderAggregateVolumeTooHighRef ref) {
  final aggregateVolume = ref.watch(marketOrderAggregateVolumeProvider);
  final balance = ref.watch(makeOrderBalanceProvider);

  return aggregateVolume.asDouble() > balance.asDouble();
}

@riverpod
AccountAsset? makeOrderLiquidAccountAsset(MakeOrderLiquidAccountAssetRef ref) {
  final allAccountAssets = ref.watch(allAccountAssetsProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  return allAccountAssets.where((e) => e.assetId == liquidAssetId).firstOrNull;
}

@riverpod
bool selectedAssetIsToken(SelectedAssetIsTokenRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final asset = ref.watch(assetsStateProvider
      .select((value) => value[selectedAccountAsset.assetId]));
  return asset?.ampMarket == false && asset?.swapMarket == false;
}

@riverpod
String targetIndexPrice(TargetIndexPriceRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final asset = ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final isPricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);

  final indexPrice = ref
      .watch(indexPriceForAssetProvider(selectedAccountAsset.assetId))
      .indexPrice;
  final lastPrice =
      ref.watch(lastIndexPriceForAssetProvider(selectedAccountAsset.assetId));
  final indexPriceStr = priceStr(indexPrice, isPricedInLiquid);
  final lastPriceStr = priceStr(lastPrice, isPricedInLiquid);
  final targetIndexPriceStr = indexPrice != 0 ? indexPriceStr : lastPriceStr;
  return targetIndexPriceStr;
}

@riverpod
String selectedAssetTicker(SelectedAssetTickerRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final ticker = ref.watch(assetsStateProvider
      .select((value) => value[selectedAccountAsset.assetId]?.ticker ?? ''));
  return ticker;
}

@riverpod
OrderEntryCallbackHandlers orderEntryCallbackHandlers(
    OrderEntryCallbackHandlersRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final makeOrderSide = ref.watch(makeOrderSideStateProvider);
  final isSell = makeOrderSide == MakeOrderSide.sell;
  final asset = ref.read(assetsStateProvider)[selectedAccountAsset.assetId];

  return OrderEntryCallbackHandlers(
    ref: ref,
    selectedAccountAsset: selectedAccountAsset,
    isSell: isSell,
    asset: asset,
  );
}

class OrderEntryCallbackHandlers {
  final Ref ref;
  final AccountAsset selectedAccountAsset;
  final bool isSell;
  final Asset? asset;

  OrderEntryCallbackHandlers({
    required this.ref,
    required this.selectedAccountAsset,
    required this.isSell,
    required this.asset,
  });

  void reset(
    TextEditingController controllerAmount,
    TextEditingController controllerPrice,
    ValueNotifier<double> trackingValue,
    ValueNotifier<bool> trackingToggled,
  ) {
    controllerAmount.clear();
    controllerPrice.clear();
    trackingValue.value = 0.0;
    trackingToggled.value = false;
  }

  void submit(
    TextEditingController controllerAmount,
    TextEditingController controllerPrice,
    ValueNotifier<bool> trackingToggled,
    ValueNotifier<double> trackingValue,
  ) {
    final amount = double.tryParse(controllerAmount.text) ?? 0.0;
    final price = double.tryParse(controllerPrice.text) ?? 0.0;
    final isAssetAmount = !(asset?.swapMarket == true);
    final indexPrice = trackingToggled.value
        ? trackerValueToIndexPrice(trackingValue.value)
        : null;
    final account = ref.read(accountAssetFromAssetProvider(asset));
    final sign = isSell ? -1 : 1;
    final amountWithSign = amount * sign;

    ref.read(walletProvider).submitOrder(
          selectedAccountAsset.assetId,
          amountWithSign,
          price,
          isAssetAmount: isAssetAmount,
          indexPrice: indexPrice,
          account: account.account,
        );
    ref.read(indexPriceButtonProvider.notifier).setIndexPrice('0');
    reset(controllerAmount, controllerPrice, trackingValue, trackingToggled);
  }

  void handleMax(
      TextEditingController controllerAmount, FocusNode focusNodePrice) {
    final assetPrecision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: selectedAccountAsset.assetId);
    final isPricedInLiquid =
        ref.read(assetUtilsProvider).isPricedInLiquid(asset: asset);

    final marketSide = ref.read(makeOrderSideStateProvider);
    // on buy side calculate max amount based on index price and buying power
    if (marketSide == MakeOrderSide.buy) {
      final indexPrice = ref
          .read(indexPriceForAssetProvider(selectedAccountAsset.assetId))
          .indexPrice;
      final lastPrice = ref
          .read(lastIndexPriceForAssetProvider(selectedAccountAsset.assetId));
      final indexPriceStr = priceStr(indexPrice, isPricedInLiquid);
      final lastPriceStr = priceStr(lastPrice, isPricedInLiquid);
      final targetIndexPriceStr =
          indexPrice != 0 ? indexPriceStr : lastPriceStr;
      ref
          .read(indexPriceButtonProvider.notifier)
          .setIndexPrice(targetIndexPriceStr);

      final orderBalance = ref.read(makeOrderBalanceProvider);

      final targetIndexPrice =
          Decimal.tryParse(targetIndexPriceStr) ?? Decimal.zero;
      final balance = orderBalance.asDecimal();
      if (targetIndexPrice != Decimal.zero) {
        final targetAmount = (balance / targetIndexPrice)
            .toDecimal(scaleOnInfinitePrecision: assetPrecision)
            .toStringAsFixed(assetPrecision);
        setControllerValue(controllerAmount, targetAmount);
        return;
      }
    }

    // for sell side insert max balance only
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    final account = isPricedInLiquid
        ? ref.read(accountAssetFromAssetProvider(asset))
        : AccountAsset(AccountType.reg, liquidAssetId);
    final balance = ref.read(balancesNotifierProvider)[account] ?? 0;
    final amountProvider = ref.read(amountToStringProvider);
    final balanceStr = amountProvider.amountToString(
        AmountToStringParameters(amount: balance, precision: assetPrecision));
    setControllerValue(controllerAmount, balanceStr);
    focusNodePrice.requestFocus();
  }
}
