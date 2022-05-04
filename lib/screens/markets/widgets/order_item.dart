import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderItem extends ConsumerStatefulWidget {
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

class _OrderItemState extends ConsumerState<OrderItem> {
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
    final wallet = ref.read(walletProvider);
    final assets = wallet.assets;
    final bitcoinAsset = assets[wallet.liquidAssetId()]!;
    final asset = assets[widget.requestOrder.assetId]!;
    final isStablecoin = asset.swapMarket;
    final bitcoinIcon = wallet.assetImagesSmall[wallet.liquidAssetId()]!;
    final assetIcon = wallet.assetImagesSmall[asset.assetId];
    final assetTicker = asset.ticker;
    final isToken = widget.requestOrder.marketType == MarketType.token;
    final isAmp = widget.requestOrder.marketType == MarketType.amp;
    final bitcoinTicker = bitcoinAsset.ticker;

    final sendBitcoins = widget.requestOrder.sendBitcoins;
    final sendAsset = sendBitcoins ? bitcoinAsset : asset;
    final recvAsset = sendBitcoins ? asset : bitcoinAsset;

    final deliverTicker = sendAsset.ticker;
    final bitcoinAmountStr = amountStr(widget.requestOrder.bitcoinAmount);
    final assetAmountStr =
        amountStr(widget.requestOrder.assetAmount, precision: asset.precision);
    final deliverIcon = sendBitcoins ? bitcoinIcon : assetIcon;
    final buyAmount = sendBitcoins
        ? widget.requestOrder.assetAmount
        : widget.requestOrder.bitcoinAmount;
    final receiveTicker = sendBitcoins ? assetTicker : bitcoinTicker;
    final receivePrecision = recvAsset.precision;
    final buyAmountStr = amountStr(buyAmount, precision: receivePrecision);
    final receiveIcon = sendBitcoins ? assetIcon : bitcoinIcon;
    final totalPrice = sendBitcoins
        ? widget.requestOrder.assetAmount
        : widget.requestOrder.bitcoinAmount;
    final totalPriceStr = amountStr(totalPrice, precision: receivePrecision);
    final priceTicker = isStablecoin ? assetTicker : bitcoinTicker;
    final priceIcon = isStablecoin ? assetIcon : bitcoinIcon;
    final priceAmount = priceStrForMarket(
        widget.requestOrder.price, widget.requestOrder.marketType);
    final dollarConversionRecv = ref
        .read(requestOrderProvider)
        .dollarConversionFromString(wallet.liquidAssetId(), buyAmountStr);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: const Color(0xFF135579),
        child: InkWell(
          onTap: widget.onTap ??
              () {
                wallet.setOrderRequestView(widget.requestOrder);
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
                                : (isAmp
                                    ? '$assetTicker / $bitcoinTicker'
                                    : '$bitcoinTicker / $assetTicker'),
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (isAmp) const AmpFlag()
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
                            widget.requestOrder.marketType ==
                                    MarketType.stablecoin
                                ? '$bitcoinAmountStr $kLiquidBitcoinTicker'
                                : '$assetAmountStr $assetTicker',
                            style: amountStyle,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: widget.requestOrder.marketType ==
                                      MarketType.stablecoin
                                  ? bitcoinIcon
                                  : assetIcon,
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
                                '$totalPriceStr $receiveTicker',
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
                                '≈ $dollarConversionRecv',
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
                                child: sendBitcoins != isAmp
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
