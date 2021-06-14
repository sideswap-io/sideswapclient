import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';

enum OrderType {
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
    this.orderType = OrderType.submit,
    this.sellBitcoin = true,
    this.accept = false,
    this.indexPrice = false,
  });

  final String bitcoinAmount;
  final String priceAmount;
  final String assetAmount;
  final String assetId;
  final OrderType orderType;
  final bool sellBitcoin;
  final String orderId;
  final bool accept;
  final String fee;
  final bool indexPrice;

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
    OrderType? orderType,
    bool? sellBitcoin,
    String? orderId,
    bool? accept,
    String? fee,
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
    );
  }
}

class OrderDetails extends StatelessWidget {
  OrderDetails({
    Key? key,
    required this.placeOrderData,
    this.enabled = true,
  })  : _defaultTextStyle = GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        super(key: key);

  final OrderDetailsData placeOrderData;
  final TextStyle _defaultTextStyle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final assets = context.read(walletProvider).assets;
    Image? assetIcon, bitcoinIcon;
    var assetTicker = '';

    var bitcoinTicker = '';
    for (var asset in assets.values) {
      if (asset.ticker == kLiquidBitcoinTicker) {
        bitcoinIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        bitcoinTicker = asset.ticker;
      }
      if (asset.assetId == placeOrderData.assetId) {
        assetIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        assetTicker = asset.ticker;
      }
    }

    final sellBitcoin = placeOrderData.sellBitcoin;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 157.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderItemRow(
              text: sellBitcoin ? 'Sell'.tr() : 'Buy'.tr(),
              textStyle: _defaultTextStyle,
              amount: placeOrderData.bitcoinAmount,
              ticker: bitcoinTicker,
              icon: bitcoinIcon,
              enabled: enabled,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFF337BA3),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: OrderItemRow(
                text: 'Price'.tr(),
                textStyle: _defaultTextStyle,
                amount: placeOrderData.priceAmount,
                ticker: assetTicker,
                icon: assetIcon,
                enabled: enabled,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFF337BA3),
              ),
            ),
            if (placeOrderData.fee.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: OrderItemRow(
                  text: 'Fee'.tr(),
                  textStyle: _defaultTextStyle,
                  amount: placeOrderData.fee,
                  ticker: bitcoinTicker,
                  icon: bitcoinIcon,
                  enabled: enabled,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFF337BA3),
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: OrderItemRow(
                text: sellBitcoin ? 'Receive'.tr() : 'Deliver'.tr(),
                textStyle: _defaultTextStyle,
                amount: placeOrderData.assetAmount,
                ticker: assetTicker,
                icon: assetIcon,
                enabled: enabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.amount,
    required this.ticker,
    required this.icon,
    this.enabled = false,
  }) : super(key: key);

  final String text;
  final TextStyle textStyle;
  final String amount;
  final String ticker;
  final Image? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: textStyle,
        ),
        Spacer(),
        enabled
            ? Text(
                '$amount ',
                style: textStyle,
              )
            : SpinKitCircle(
                color: Colors.white,
                size: 24.w,
              ),
        Text(
          enabled && ticker.isNotEmpty ? '$ticker' : '',
          style: textStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Container(
            width: 24.w,
            height: 24.w,
            child: icon,
          ),
        ),
      ],
    );
  }
}
