import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    Key? key,
    required this.requestOrder,
    this.useTokenMarketView = false,
    this.onTap,
  }) : super(key: key);

  final RequestOrder requestOrder;
  final bool useTokenMarketView;
  final void Function()? onTap;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  String createdAt = '';
  String expire = '';
  Timer? expireTimer;

  final descriptionStyle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF00C5FF),
  );

  final amountStyle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  final coloredContainerStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  final Color alternativeBackground = const Color(0xFF196087);

  @override
  void initState() {
    super.initState();

    expire = widget.requestOrder.getExpireDescription();
    createdAt = widget.requestOrder.getCreatedAtFormatted();

    expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        expire = widget.requestOrder.getExpireDescription();
      });
    });
  }

  @override
  void dispose() {
    expireTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assets = context.read(walletProvider).assets;
    Image? assetIcon, bitcoinIcon;
    var assetTicker = '';
    bool isToken = false;

    var bitcoinTicker = '';
    for (var asset in assets.values) {
      if (asset.ticker == kLiquidBitcoinTicker) {
        bitcoinIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        bitcoinTicker = asset.ticker;
      }
      if (asset.assetId == widget.requestOrder.assetId) {
        isToken =
            context.read(requestOrderProvider).isAssetToken(asset.assetId);
        assetIcon =
            context.read(walletProvider).assetImagesSmall[asset.assetId];
        assetTicker = asset.ticker;
      }
    }

    final isPricedInLiquid = context
        .read(requestOrderProvider)
        .isPricedInLiquid(widget.requestOrder.assetId);

    final sendBitcoins = widget.requestOrder.sendBitcoins;
    final deliverAmount = sendBitcoins
        ? widget.requestOrder.bitcoinAmountWithFee
        : widget.requestOrder.assetAmount;
    final deliverTicker = sendBitcoins ? bitcoinTicker : assetTicker;
    final deliverPrecision = context
            .read(walletProvider)
            .getAssetByTicker(deliverTicker)
            ?.precision ??
        0;
    final deliverAmountStr =
        amountStr(deliverAmount, precision: deliverPrecision);
    final deliverIcon = sendBitcoins ? bitcoinIcon : assetIcon;
    final receiveAmount = sendBitcoins
        ? widget.requestOrder.assetAmount
        : widget.useTokenMarketView
            ? widget.requestOrder.bitcoinAmount
            : widget.requestOrder.bitcoinAmountWithFee;
    final receiveTicker = sendBitcoins ? assetTicker : bitcoinTicker;
    final receivePrecision = context
            .read(walletProvider)
            .getAssetByTicker(receiveTicker)
            ?.precision ??
        0;
    final receiveAmountStr =
        amountStr(receiveAmount, precision: receivePrecision);
    final receiveIcon = sendBitcoins ? assetIcon : bitcoinIcon;
    final priceTicker = isPricedInLiquid ? bitcoinTicker : assetTicker;
    final priceIcon = sendBitcoins
        ? receiveIcon
        : isPricedInLiquid
            ? receiveIcon
            : deliverIcon;
    var priceAmount = isPricedInLiquid
        ? priceStr(1 / widget.requestOrder.price)
        : priceStr(widget.requestOrder.price);
    final dollarConversion = context
        .read(requestOrderProvider)
        .dollarConversionFromString(
            context.read(walletProvider).liquidAssetId() ?? '',
            receiveAmountStr);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: const Color(0xFF135579),
        child: InkWell(
          onTap: widget.onTap ??
              () {
                context
                    .read(walletProvider)
                    .setOrderRequestView(widget.requestOrder);
              },
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (isToken) ...[
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: deliverIcon,
                              ),
                            ),
                          ],
                          Text(
                            isToken
                                ? deliverTicker
                                : '$bitcoinTicker / $assetTicker',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (widget.useTokenMarketView) ...[
                        ColoredContainer(
                          horizontalPadding: 8.w,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Icon(
                                  Icons.watch_later,
                                  size: 14.h,
                                  color: const Color(0xFF00C5FF),
                                ),
                              ),
                              Text(
                                expire,
                                style: coloredContainerStyle,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        ColoredContainer(
                          child: Text(
                            isToken ? 'Token market'.tr() : 'Swap market'.tr(),
                            style: coloredContainerStyle,
                          ),
                        ),
                      ]
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: const Divider(
                      thickness: 1,
                      height: 1,
                      color: Color(0xFF2B6F95),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount'.tr(),
                        style: descriptionStyle,
                      ),
                      Row(
                        children: [
                          Text(
                            sendBitcoins
                                ? '$deliverAmountStr $deliverTicker'
                                : isToken
                                    ? '$deliverAmountStr $deliverTicker'
                                    : '$receiveAmountStr $receiveTicker',
                            style: amountStyle,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: sendBitcoins
                                  ? deliverIcon
                                  : isToken
                                      ? deliverIcon
                                      : receiveIcon,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price'.tr(),
                          style: descriptionStyle,
                        ),
                        Row(
                          children: [
                            Text(
                              '$priceAmount $priceTicker',
                              style: amountStyle,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: priceIcon,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isToken) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total price'.tr(),
                            style: descriptionStyle,
                          ),
                          Row(
                            children: [
                              Text(
                                '$receiveAmountStr $receiveTicker',
                                style: amountStyle,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                  child: receiveIcon,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (widget.useTokenMarketView) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '',
                            style: descriptionStyle,
                          ),
                          Row(
                            children: [
                              Text(
                                '≈ $dollarConversion',
                                style: amountStyle.copyWith(
                                    color: const Color(0xFF709EBA)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const Divider(
                        thickness: 1,
                        height: 1,
                        color: Color(0xFF2B6F95),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.requestOrder.indexPrice != 0) ...[
                          ColoredContainer(
                            backgroundColor: alternativeBackground,
                            borderColor: alternativeBackground,
                            child: Text(
                              'Tracking'.tr(),
                              style: coloredContainerStyle,
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              if (!isToken) ...[
                                Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: ColoredContainer(
                                    backgroundColor: alternativeBackground,
                                    borderColor: alternativeBackground,
                                    child: Text(
                                      'Limit'.tr(),
                                      style: coloredContainerStyle,
                                    ),
                                  ),
                                ),
                              ],
                              ColoredContainer(
                                backgroundColor: alternativeBackground,
                                borderColor: alternativeBackground,
                                child: Text(
                                  widget.requestOrder.private
                                      ? 'Private'.tr()
                                      : 'Public'.tr(),
                                  style: coloredContainerStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                        Row(
                          children: [
                            if (!isToken) ...[
                              Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: sendBitcoins
                                    ? ColoredContainer(
                                        child: Text(
                                          'Sell'.tr(),
                                          style: coloredContainerStyle,
                                        ),
                                        backgroundColor: const Color(0xFFFF7878)
                                            .withOpacity(0.14),
                                        borderColor: const Color(0xFFFF7878),
                                      )
                                    : ColoredContainer(
                                        child: Text(
                                          'Buy'.tr(),
                                          style: coloredContainerStyle,
                                        ),
                                        backgroundColor: const Color(0xFF2CCCBF)
                                            .withOpacity(0.14),
                                        borderColor: const Color(0xFF2CCCBF),
                                      ),
                              ),
                            ],
                            ColoredContainer(
                              horizontalPadding: 8.w,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: Icon(
                                      Icons.watch_later,
                                      size: 14.h,
                                      color: const Color(0xFF00C5FF),
                                    ),
                                  ),
                                  Text(
                                    expire,
                                    style: coloredContainerStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
