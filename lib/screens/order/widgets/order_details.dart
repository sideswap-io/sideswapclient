import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';

enum OrderType {
  place,
  execute,
}

class OrderDetailsData {
  OrderDetailsData({
    @required this.buy,
    @required this.price,
    @required this.total,
    @required this.buyAsset,
    @required this.priceAsset,
    @required this.totalAsset,
    this.orderType = OrderType.place,
  });

  final double buy;
  final double price;
  final double total;
  final String buyAsset;
  final String priceAsset;
  final String totalAsset;
  final OrderType orderType;

  OrderDetailsData copyWith({
    double buy,
    double price,
    double total,
    String buyAsset,
    String priceAsset,
    String totalAsset,
    OrderType orderType,
  }) {
    return OrderDetailsData(
      buy: buy ?? this.buy,
      price: price ?? this.price,
      total: total ?? this.total,
      buyAsset: buyAsset ?? this.buyAsset,
      priceAsset: priceAsset ?? this.priceAsset,
      totalAsset: totalAsset ?? this.totalAsset,
      orderType: orderType ?? this.orderType,
    );
  }
}

class OrderDetails extends StatelessWidget {
  OrderDetails({Key key, @required this.placeOrderData})
      : _defaultTextStyle = GoogleFonts.roboto(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        super(key: key);

  final OrderDetailsData placeOrderData;
  final TextStyle _defaultTextStyle;

  @override
  Widget build(BuildContext context) {
    final assets = context.read(walletProvider).assets;
    Image buyIcon, priceIcon, totalIcon;
    for (var asset in assets.values) {
      if (asset.ticker == placeOrderData.buyAsset) {
        buyIcon = context.read(walletProvider).assetImagesSmall[asset.assetId];
      }
      if (asset.ticker == placeOrderData.priceAsset) {
        priceIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
      }
      if (asset.ticker == placeOrderData.totalAsset) {
        totalIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
      }
    }

    return Container(
      width: 343.w,
      height: 130.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        color: Color(0xFF135579),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderItemRow(
              text: 'Buy'.tr(),
              textStyle: _defaultTextStyle,
              amount: placeOrderData.buy,
              asset: placeOrderData.buyAsset,
              icon: buyIcon,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFF337BA3),
            ),
            OrderItemRow(
              text: 'Price'.tr(),
              textStyle: _defaultTextStyle,
              amount: placeOrderData.price,
              asset: placeOrderData.priceAsset,
              icon: priceIcon,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFF337BA3),
            ),
            OrderItemRow(
              text: 'Total'.tr(),
              textStyle: _defaultTextStyle,
              amount: placeOrderData.total,
              asset: placeOrderData.totalAsset,
              icon: totalIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({
    Key key,
    @required this.text,
    @required this.textStyle,
    @required this.amount,
    @required this.asset,
    @required this.icon,
  }) : super(key: key);

  final String text;
  final TextStyle textStyle;
  final double amount;
  final String asset;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: textStyle,
        ),
        Spacer(),
        Text(
          '${amount.toStringAsFixed(2)} ',
          style: textStyle,
        ),
        Text(
          '$asset',
          style: textStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: 11.w),
          child: Container(
            width: 22.w,
            height: 22.w,
            child: icon,
          ),
        ),
      ],
    );
  }
}
