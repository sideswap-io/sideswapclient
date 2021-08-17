import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/helpers.dart';

enum OrderDetailsDataType {
  submit,
  quote,
  sign,
}

extension OrderDetailsDataEx on OrderDetailsData {
  bool isDataAvailable() {
    return orderId.isNotEmpty &&
        bitcoinAmountStr.isNotEmpty &&
        priceAmountStr.isNotEmpty &&
        assetAmountStr.isNotEmpty &&
        assetId.isNotEmpty;
  }

  String get bitcoinAmountStr {
    return amountStr(bitcoinAmount, precision: bitcoinPrecision);
  }

  String get assetAmountStr {
    return amountStr(assetAmount, precision: assetPrecision);
  }

  String get feeStr {
    return amountStr(fee, precision: bitcoinPrecision);
  }

  String get bitcoinAmountWithFeeStr {
    return sellBitcoin
        ? amountStr(bitcoinAmount + fee, precision: bitcoinPrecision)
        : amountStr(bitcoinAmount - fee, precision: bitcoinPrecision);
  }

  String get priceAmountStr {
    return priceStr(priceAmount);
  }

  String get priceAmountInvertedStr {
    return priceStr(1 / priceAmount);
  }
}

class OrderDetailsData {
  OrderDetailsData({
    required this.bitcoinAmount,
    required this.bitcoinPrecision,
    required this.priceAmount,
    required this.assetAmount,
    required this.assetPrecision,
    required this.assetId,
    this.orderType,
    this.sellBitcoin = true,
    required this.orderId,
    this.accept = false,
    required this.fee,
    this.isTracking = false,
    this.private = false,
    this.autoSign = false,
    this.own = false,
    this.indexPrice = 0,
  });

  final int bitcoinAmount;
  final int bitcoinPrecision;
  final double priceAmount;
  final int assetAmount;
  final int assetPrecision;
  final String assetId;
  final OrderDetailsDataType? orderType;
  final bool sellBitcoin;
  final String orderId;
  final bool accept;
  final int fee;
  final bool isTracking;
  final bool private;
  final bool autoSign;
  final bool own;
  final double indexPrice;

  factory OrderDetailsData.empty() {
    return OrderDetailsData(
      bitcoinAmount: 0,
      bitcoinPrecision: 0,
      priceAmount: 0,
      assetAmount: 0,
      assetPrecision: 0,
      fee: 0,
      assetId: '',
      orderId: '',
    );
  }

  factory OrderDetailsData.fromRequestOrder(
      RequestOrder requestOrder, Reader read) {
    final sendBitcoins = requestOrder.sendBitcoins;
    final assetPrecision = read(walletProvider)
        .getPrecisionForAssetId(assetId: requestOrder.assetId);
    final bitcoinPrecision = read(walletProvider)
        .getPrecisionForTicker(ticker: kLiquidBitcoinTicker);
    final orderDetailsData = OrderDetailsData(
      bitcoinAmount: requestOrder.bitcoinAmount,
      bitcoinPrecision: bitcoinPrecision,
      priceAmount: requestOrder.price,
      assetAmount: requestOrder.assetAmount,
      assetPrecision: assetPrecision,
      assetId: requestOrder.assetId,
      sellBitcoin: sendBitcoins,
      orderId: requestOrder.orderId,
      fee: requestOrder.serverFee,
      private: requestOrder.private,
      autoSign: requestOrder.autoSign,
      own: requestOrder.own,
      isTracking: requestOrder.indexPrice != 0,
      indexPrice: requestOrder.indexPrice,
    );

    return orderDetailsData;
  }

  OrderDetailsData copyWith({
    int? bitcoinAmount,
    int? bitcoinPrecision,
    double? priceAmount,
    int? assetAmount,
    int? assetPrecision,
    String? assetId,
    OrderDetailsDataType? orderType,
    bool? sellBitcoin,
    String? orderId,
    bool? accept,
    int? fee,
    bool? isTracking,
    bool? private,
    bool? autoSign,
    bool? own,
    double? indexPrice,
  }) {
    return OrderDetailsData(
      bitcoinAmount: bitcoinAmount ?? this.bitcoinAmount,
      bitcoinPrecision: bitcoinPrecision ?? this.bitcoinPrecision,
      priceAmount: priceAmount ?? this.priceAmount,
      assetAmount: assetAmount ?? this.assetAmount,
      assetPrecision: assetPrecision ?? this.assetPrecision,
      assetId: assetId ?? this.assetId,
      orderType: orderType ?? this.orderType,
      sellBitcoin: sellBitcoin ?? this.sellBitcoin,
      orderId: orderId ?? this.orderId,
      accept: accept ?? this.accept,
      fee: fee ?? this.fee,
      isTracking: isTracking ?? this.isTracking,
      private: private ?? this.private,
      autoSign: autoSign ?? this.autoSign,
      own: own ?? this.own,
      indexPrice: indexPrice ?? this.indexPrice,
    );
  }

  @override
  String toString() {
    return 'OrderDetailsData(bitcoinAmount: $bitcoinAmount, bitcoinPrecision: $bitcoinPrecision, priceAmount: $priceAmount, assetAmount: $assetAmount, assetPrecision: $assetPrecision, assetId: $assetId, orderType: $orderType, sellBitcoin: $sellBitcoin, orderId: $orderId, accept: $accept, fee: $fee, isTracking: $isTracking, private: $private, autoSign: $autoSign, own: $own, indexPrice: $indexPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderDetailsData &&
        other.bitcoinAmount == bitcoinAmount &&
        other.bitcoinPrecision == bitcoinPrecision &&
        other.priceAmount == priceAmount &&
        other.assetAmount == assetAmount &&
        other.assetPrecision == assetPrecision &&
        other.assetId == assetId &&
        other.orderType == orderType &&
        other.sellBitcoin == sellBitcoin &&
        other.orderId == orderId &&
        other.accept == accept &&
        other.fee == fee &&
        other.isTracking == isTracking &&
        other.private == private &&
        other.autoSign == autoSign &&
        other.own == own &&
        other.indexPrice == indexPrice;
  }

  @override
  int get hashCode {
    return bitcoinAmount.hashCode ^
        bitcoinPrecision.hashCode ^
        priceAmount.hashCode ^
        assetAmount.hashCode ^
        assetPrecision.hashCode ^
        assetId.hashCode ^
        orderType.hashCode ^
        sellBitcoin.hashCode ^
        orderId.hashCode ^
        accept.hashCode ^
        fee.hashCode ^
        isTracking.hashCode ^
        private.hashCode ^
        autoSign.hashCode ^
        own.hashCode ^
        indexPrice.hashCode;
  }
}
