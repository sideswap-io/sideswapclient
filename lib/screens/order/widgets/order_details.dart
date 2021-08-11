import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';

enum OrderDetailsDataType {
  submit,
  quote,
  sign,
}

class OrderDetailsData {
  OrderDetailsData({
    required this.bitcoinAmount,
    required this.priceAmount,
    required this.assetAmount,
    required this.assetId,
    required this.orderId,
    required this.fee,
    this.orderType,
    this.sellBitcoin = true,
    this.accept = false,
    this.isTracking = false,
    this.private = false,
    this.autoSign = false,
    this.own = false,
    this.indexPrice = 0,
  });

  final String bitcoinAmount;
  final String priceAmount;
  final String assetAmount;
  final String assetId;
  final OrderDetailsDataType? orderType;
  final bool sellBitcoin;
  final String orderId;
  final bool accept;
  final String fee;
  final bool isTracking;
  final bool private;
  final bool autoSign;
  final bool own;
  final double indexPrice;

  factory OrderDetailsData.empty() {
    return OrderDetailsData(
      bitcoinAmount: '',
      priceAmount: '',
      assetAmount: '',
      assetId: '',
      orderId: '',
      fee: '',
    );
  }

  factory OrderDetailsData.fromRequestOrder(
      RequestOrder requestOrder, Reader read) {
    final sendBitcoins = requestOrder.sendBitcoins;
    final assetPrecision = read(walletProvider)
        .getPrecisionForAssetId(assetId: requestOrder.assetId);
    final assetAmount =
        amountStr(requestOrder.assetAmount, precision: assetPrecision);
    final bitcoinPrecision = read(walletProvider)
        .getPrecisionForTicker(ticker: kLiquidBitcoinTicker);
    final bitcoinAmount =
        amountStr(requestOrder.bitcoinAmount, precision: bitcoinPrecision);
    final fee = amountStr(requestOrder.serverFee, precision: bitcoinPrecision);
    final orderDetailsData = OrderDetailsData(
      bitcoinAmount: bitcoinAmount,
      priceAmount: requestOrder.price.toStringAsFixed(2),
      assetAmount: assetAmount,
      assetId: requestOrder.assetId,
      sellBitcoin: sendBitcoins,
      orderId: requestOrder.orderId,
      fee: fee,
      private: requestOrder.private,
      autoSign: requestOrder.autoSign,
      own: requestOrder.own,
      isTracking: requestOrder.indexPrice != 0,
      indexPrice: requestOrder.indexPrice,
    );

    return orderDetailsData;
  }

  bool isDataAvailable() {
    return orderId.isNotEmpty &&
        bitcoinAmount.isNotEmpty &&
        priceAmount.isNotEmpty &&
        assetAmount.isNotEmpty &&
        assetId.isNotEmpty;
  }

  OrderDetailsData copyWith({
    String? bitcoinAmount,
    String? priceAmount,
    String? assetAmount,
    String? assetId,
    OrderDetailsDataType? orderType,
    bool? sellBitcoin,
    String? orderId,
    bool? accept,
    String? fee,
    bool? private,
    bool? autoSign,
    bool? own,
    bool? isTracking,
    double? indexPrice,
  }) {
    return OrderDetailsData(
      bitcoinAmount: bitcoinAmount ?? this.bitcoinAmount,
      priceAmount: priceAmount ?? this.priceAmount,
      assetAmount: assetAmount ?? this.assetAmount,
      assetId: assetId ?? this.assetId,
      orderType: orderType ?? this.orderType,
      sellBitcoin: sellBitcoin ?? this.sellBitcoin,
      orderId: orderId ?? this.orderId,
      accept: accept ?? this.accept,
      fee: fee ?? this.fee,
      private: private ?? this.private,
      autoSign: autoSign ?? this.autoSign,
      own: own ?? this.own,
      isTracking: isTracking ?? this.isTracking,
      indexPrice: indexPrice ?? this.indexPrice,
    );
  }
}
