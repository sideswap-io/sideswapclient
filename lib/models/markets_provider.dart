import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_market_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/modify_price_dialog.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/common/helpers.dart';

final marketsProvider =
    ChangeNotifierProvider<MarketsProvider>((ref) => MarketsProvider(ref));

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

  Duration getExpiresAt() {
    return DateTime.fromMillisecondsSinceEpoch(expiresAt)
        .difference(DateTime.now());
  }

  bool isExpired() {
    return getExpiresAt().isNegative;
  }

  Duration getExpireDuration() {
    final expireAt = DateTime.fromMillisecondsSinceEpoch(expiresAt);
    final duration = expireAt.difference(DateTime.now());
    return duration;
  }

  String getExpireDescription() {
    return getExpireDuration().toStringCustom();
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
  final int expiresAt;
  final RequestOrderType requestOrderType = RequestOrderType.order;
  final bool private;
  final bool sendBitcoins;
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

class MarketsProvider extends ChangeNotifier {
  final Ref ref;

  MarketsProvider(this.ref) {
    ref.read(walletProvider).serverConnection.listen(onServerConnectionChanged);
  }

  final Map<String, RequestOrder> _marketOrders = <String, RequestOrder>{};
  List<RequestOrder> get marketOrders => _marketOrders.values.toList();

  final _indexPriceMap = <String, double>{};
  final _lastPriceMap = <String, double>{};
  String _subscribedIndexPriceAssetId = '';

  SubscribedMarket subscribedMarket = SubscribedMarket.none;

  void onServerConnectionChanged(bool value) {
    if (!value) {
      clearOrders();
    }
  }

  void clearOrders() {
    _marketOrders.clear();
    notifyListeners();
  }

  RequestOrder? getRequestOrderById(String orderId) {
    final index =
        marketOrders.indexWhere((element) => element.orderId == orderId);
    if (index < 0) {
      return null;
    }

    return marketOrders[index];
  }

  void insertOrder(RequestOrder order) {
    _marketOrders[order.orderId] = order;
    if (ref.read(requestOrderProvider).currentRequestOrderView?.orderId ==
        order.orderId) {
      ref.read(requestOrderProvider).currentRequestOrderView = order;
    }
    notifyListeners();

    ref
        .read(swapMarketProvider)
        .updateSwapMarketOrders(_marketOrders.values.toList());
    ref
        .read(tokenMarketProvider)
        .updateTokenMarketOrders(_marketOrders.values.toList());
  }

  void removeOrder(String orderId) {
    _marketOrders.remove(orderId);
    if (orderId ==
        ref.read(requestOrderProvider).currentRequestOrderView?.orderId) {
      ref.read(walletProvider).setRegistered();
    }
    notifyListeners();

    ref
        .read(swapMarketProvider)
        .updateSwapMarketOrders(_marketOrders.values.toList());
    ref
        .read(tokenMarketProvider)
        .updateTokenMarketOrders(_marketOrders.values.toList());
  }

  void subscribeTokenMarket() {
    subscribedMarket = SubscribedMarket.token;
    final msg = To();
    msg.subscribe = To_Subscribe();
    msg.subscribe.markets.add(To_Subscribe_Market(assetId: null));
    ref.read(walletProvider).sendMsg(msg);
  }

  void subscribeSwapMarket(String assetId, {bool withTokenMaket = false}) {
    if (assetId.isEmpty) {
      return;
    }

    subscribedMarket = SubscribedMarket.asset;
    final msg = To();
    msg.subscribe = To_Subscribe();
    msg.subscribe.markets.add(To_Subscribe_Market(assetId: assetId));
    if (withTokenMaket) {
      msg.subscribe.markets.add(To_Subscribe_Market(assetId: null));
    }
    ref.read(walletProvider).sendMsg(msg);
  }

  void unsubscribeMarket() {
    subscribedMarket = SubscribedMarket.none;
    final msg = To();
    msg.subscribe = To_Subscribe();
    ref.read(walletProvider).sendMsg(msg);
  }

  void subscribeIndexPrice(String assetId) {
    assert(assetId != ref.read(walletProvider).liquidAssetId());

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

  double getIndexPriceForAsset(String assetId) {
    return _indexPriceMap[assetId] ?? 0;
  }

  double getLastPriceForAsset(String assetId) {
    return _lastPriceMap[assetId] ?? 0;
  }

  void setIndexLastPrice(String assetId, double? ind, double? last) {
    if (assetId.isEmpty) {
      return;
    }

    if (ind != null) {
      _indexPriceMap[assetId] = ind;
    } else {
      _indexPriceMap.remove(assetId);
    }

    if (last != null) {
      _lastPriceMap[assetId] = last;
    } else {
      _lastPriceMap.remove(assetId);
    }

    notifyListeners();

    ref.read(requestOrderProvider).updateIndexPrice();
  }

  String getIndexPriceStr(String assetId) {
    final isAmp = ref.read(walletProvider).assets[assetId]?.ampMarket ?? false;
    var price = getIndexPriceForAsset(assetId);
    if (price == 0) {
      return '';
    }
    return priceStr(price, isAmp);
  }

  String getLastPriceStr(String assetId) {
    final isAmp = ref.read(walletProvider).assets[assetId]?.ampMarket ?? false;
    var price = getLastPriceForAsset(assetId);
    if (price == 0) {
      return '';
    }
    return priceStr(price, isAmp);
  }

  String calculateTrackingPrice(double sliderValue, String assetId) {
    final indexPrice = getIndexPriceStr(assetId);
    final indexPriceValue = double.tryParse(indexPrice) ?? 0;

    final trackingPriceValue =
        indexPriceValue + indexPriceValue * (sliderValue / 100);
    return trackingPriceValue.toStringAsFixed(2);
  }

  List<RequestOrder> getOwnOrders() {
    return marketOrders.where((e) => e.own == true).toList();
  }

  Future<void> onModifyPrice(WidgetRef ref, RequestOrder? requestOrder) async {
    if (requestOrder == null) {
      return;
    }

    final price = ref
            .read(marketsProvider)
            .getRequestOrderById(requestOrder.orderId)
            ?.price ??
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
        final wallet = ref.read(walletProvider);
        final assetId = requestOrder.assetId;
        final asset = wallet.assets[assetId]!;
        final liquidAsset = wallet.assets[wallet.liquidAssetId()]!;
        final priceAsset = asset.swapMarket ? asset : liquidAsset;
        final icon = wallet.assetImagesSmall[priceAsset.assetId];
        final assetPrecision = ref
            .read(walletProvider)
            .getPrecisionForAssetId(assetId: requestOrder.assetId);
        final orderDetailsData =
            OrderDetailsData.fromRequestOrder(requestOrder, assetPrecision);
        return ModifyPriceDialog(
          controller: controller,
          orderDetailsData: orderDetailsData,
          asset: priceAsset,
          icon: icon,
        );
      },
    );
  }
}
