import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_market_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/modify_price_dialog.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

final marketsProvider =
    ChangeNotifierProvider<MarketsProvider>((ref) => MarketsProvider(ref.read));

enum RequestOrderType {
  order,
  payment,
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

  String getExpireDescription() {
    final expireAt = DateTime.fromMillisecondsSinceEpoch(expiresAt);
    final duration = expireAt.difference(DateTime.now());
    return duration.inHours.remainder(24) >= 1
        ? duration.toHoursMinutes()
        : duration.toMinutes();
  }

  int get bitcoinAmountWithFee {
    return sendBitcoins ? bitcoinAmount + serverFee : bitcoinAmount - serverFee;
  }

  String get priceStr {
    return price.toString();
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
  final bool tokenMarket;
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
    required this.tokenMarket,
    required this.indexPrice,
    required this.isNew,
  });

  RequestOrder copyWith({
    String? orderId,
    String? assetId,
    int? bitcoinAmount,
    int? serverFee,
    int? assetAmount,
    double? price,
    int? createdAt,
    int? expiresAt,
    bool? private,
    bool? sendBitcoins,
    bool? autoSign,
    bool? own,
    bool? tokenMarket,
    double? indexPrice,
    bool? isNew,
  }) {
    return RequestOrder(
      orderId: orderId ?? this.orderId,
      assetId: assetId ?? this.assetId,
      bitcoinAmount: bitcoinAmount ?? this.bitcoinAmount,
      serverFee: serverFee ?? this.serverFee,
      assetAmount: assetAmount ?? this.assetAmount,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      private: private ?? this.private,
      sendBitcoins: sendBitcoins ?? this.sendBitcoins,
      autoSign: autoSign ?? this.autoSign,
      own: own ?? this.own,
      tokenMarket: tokenMarket ?? this.tokenMarket,
      indexPrice: indexPrice ?? this.indexPrice,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  String toString() {
    return 'RequestOrder(orderId: $orderId, assetId: $assetId, bitcoinAmount: $bitcoinAmount, serverFee: $serverFee, assetAmount: $assetAmount, price: $price, createdAt: $createdAt, expiresAt: $expiresAt, private: $private, sendBitcoins: $sendBitcoins, autoSign: $autoSign, own: $own, tokenMarket: $tokenMarket, indexPrice: $indexPrice, isNew: $isNew)';
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
        other.tokenMarket == tokenMarket &&
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
        tokenMarket.hashCode ^
        indexPrice.hashCode ^
        isNew.hashCode;
  }
}

class MarketsProvider extends ChangeNotifier {
  Reader read;

  MarketsProvider(this.read) {
    read(walletProvider).serverConnection.listen(onServerConnectionChanged);
  }

  final Map<String, RequestOrder> _marketOrders = <String, RequestOrder>{};
  List<RequestOrder> get marketOrders => _marketOrders.values.toList();

  final _indexPriceMap = <String, double>{};
  String _subscribedIndexPriceAssetId = '';

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
    if (read(requestOrderProvider).currentRequestOrderView?.orderId ==
        order.orderId) {
      read(requestOrderProvider).currentRequestOrderView = order;
    }
    notifyListeners();

    read(swapMarketProvider)
        .updateSwapMarketOrders(_marketOrders.values.toList());
    read(tokenMarketProvider)
        .updateTokenMarketOrders(_marketOrders.values.toList());
  }

  void removeOrder(String orderId) {
    _marketOrders.remove(orderId);
    if (orderId ==
        read(requestOrderProvider).currentRequestOrderView?.orderId) {
      read(walletProvider).setRegistered();
    }
    notifyListeners();

    read(swapMarketProvider)
        .updateSwapMarketOrders(_marketOrders.values.toList());
    read(tokenMarketProvider)
        .updateTokenMarketOrders(_marketOrders.values.toList());
  }

  void subscribeTokenMarket() {
    final msg = To();
    msg.subscribe = To_Subscribe();
    msg.subscribe.market = To_Subscribe_Market.TOKENS;
    read(walletProvider).sendMsg(msg);
  }

  void subscribeSwapMarket(String assetId) {
    if (assetId.isEmpty) {
      return;
    }

    final msg = To();
    msg.subscribe = To_Subscribe();
    msg.subscribe.market = To_Subscribe_Market.ASSET;
    msg.subscribe.assetId = assetId;
    read(walletProvider).sendMsg(msg);
  }

  void unsubscribeMarket() {
    final msg = To();
    msg.subscribe = To_Subscribe();
    msg.subscribe.market = To_Subscribe_Market.NONE;
    read(walletProvider).sendMsg(msg);
  }

  void subscribeIndexPrice({String? assetId}) {
    // don't subscrive if already subscribed
    if (assetId == _subscribedIndexPriceAssetId) {
      return;
    }

    unsubscribeIndexPrice();
    if (assetId == null) {
      return;
    }

    _subscribedIndexPriceAssetId = assetId;

    final msg = To();
    msg.subscribePrice = To_SubscribePrice();
    msg.subscribePrice.assetId = assetId;
    read(walletProvider).sendMsg(msg);
  }

  void unsubscribeIndexPrice() {
    if (_subscribedIndexPriceAssetId.isEmpty) {
      return;
    }

    final msg = To();
    msg.unsubscribePrice = To_UnsubscribePrice();
    msg.unsubscribePrice.assetId = _subscribedIndexPriceAssetId;
    read(walletProvider).sendMsg(msg);

    _subscribedIndexPriceAssetId = '';
  }

  String subscribedIndexPriceAssetId() {
    return _subscribedIndexPriceAssetId;
  }

  double getIndexPriceForAsset(String assetId) {
    if (!_indexPriceMap.containsKey(assetId)) {
      return 0;
    }

    return _indexPriceMap[assetId] ?? 0;
  }

  void setIndexPrice(String assetId, double price) {
    if (assetId.isEmpty) {
      return;
    }

    _indexPriceMap[assetId] = price;
    notifyListeners();

    read(requestOrderProvider).updateIndexPrice();
  }

  String getIndexPriceStr(String assetId) {
    var priceBroadcast = getIndexPriceForAsset(assetId);

    if (priceBroadcast == 0) {
      // Let's display now only average value
      final assetPrice = read(walletProvider).prices[assetId];
      final ask = assetPrice?.ask ?? .0;
      final bid = assetPrice?.bid ?? .0;
      priceBroadcast = (ask + bid) / 2;
    }

    if (priceBroadcast == 0) {
      return '';
    }

    return priceBroadcast.toStringAsFixed(2);
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

  Future<void> onModifyPrice(RequestOrder? requestOrder) async {
    if (requestOrder == null) {
      return;
    }

    final price = read(marketsProvider)
            .getRequestOrderById(requestOrder.orderId)
            ?.price ??
        0;
    var priceStr = price.toString();
    final pricedInLiquid =
        read(requestOrderProvider).isPricedInLiquid(requestOrder.assetId);
    if (pricedInLiquid) {
      priceStr = (1 / requestOrder.price).toString();
    }

    final TextEditingController controller = TextEditingController()
      ..text = priceStr;

    final context = read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final assetId = requestOrder.assetId;
        final asset = context
            .read(requestOrderProvider)
            .getPriceAsset(baseAssetId: assetId);
        final icon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        final orderDetailsData =
            OrderDetailsData.fromRequestOrder(requestOrder, context.read);
        return ModifyPriceDialog(
          controller: controller,
          orderDetailsData: orderDetailsData,
          asset: asset,
          icon: icon,
        );
      },
    );
  }
}
