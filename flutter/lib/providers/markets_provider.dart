import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/utils/market_helpers.dart';

import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/modify_price_dialog.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/common/helpers.dart';

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

  void subscribeSwapMarket(String assetId) {
    if (assetId.isEmpty) {
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
    assert(assetId != ref.read(liquidAssetIdProvider));

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

    final context = ref.read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final assetId = requestOrder.assetId;
        final asset =
            ref.watch(assetsStateProvider.select((value) => value[assetId]));
        final liquidAsset = ref.watch(assetUtilsProvider).liquidAsset();
        final priceAsset = asset?.swapMarket == true ? asset : liquidAsset;
        final icon =
            ref.watch(assetImageProvider).getSmallImage(priceAsset?.assetId);
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

    if (ind != null) {
      state[assetId] = ind;
      ref.notifyListeners();
      return;
    }

    state.remove(assetId);
    ref.notifyListeners();
  }
}

final indexPriceForAssetProvider =
    AutoDisposeProviderFamily<IndexPriceForAssetProvider, String?>((ref, arg) {
  final indexPrice = ref.watch(marketsIndexPriceProvider);
  final isAmp = ref.watch(assetUtilsProvider).isAmpMarket(assetId: arg);
  return IndexPriceForAssetProvider(indexPrice[arg] ?? 0, arg, isAmp);
});

class IndexPriceForAssetProvider {
  final double indexPrice;
  final String? assetId;
  final bool isAmp;

  IndexPriceForAssetProvider(this.indexPrice, this.assetId, this.isAmp);

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

    if (last != null) {
      state[assetId] = last;
      ref.notifyListeners();
      return;
    }

    state.remove(assetId);
    ref.notifyListeners();
  }
}

final lastIndexPriceForAssetProvider =
    AutoDisposeProviderFamily<LastIndexPriceForAssetProvider, String?>(
        (ref, arg) {
  final lastIndexPrice = ref.watch(marketsLastIndexPriceProvider);
  final isAmp = ref.watch(assetUtilsProvider).isAmpMarket(assetId: arg);
  return LastIndexPriceForAssetProvider(lastIndexPrice[arg] ?? 0, arg, isAmp);
});

class LastIndexPriceForAssetProvider {
  final double lastIndexPrice;
  final String? assetId;
  final bool isAmp;

  LastIndexPriceForAssetProvider(this.lastIndexPrice, this.assetId, this.isAmp);

  String getLastPriceStr() {
    if (lastIndexPrice == 0) {
      return '';
    }
    return priceStr(lastIndexPrice, isAmp);
  }
}

final indexPriceButtonProvider =
    AutoDisposeStateNotifierProvider<IndexPriceProvider, String>(
        (ref) => IndexPriceProvider(ref));

class IndexPriceProvider extends StateNotifier<String> {
  final Ref ref;

  IndexPriceProvider(this.ref) : super('0');

  void setIndexPrice(String value) {
    state = "0";
    state = value;
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

final marketSelectedAssetIdProvider = AutoDisposeStateProvider<String>((ref) {
  ref.keepAlive();
  final tetherAssetId = ref.watch(tetherAssetIdProvider);
  return tetherAssetId;
});
