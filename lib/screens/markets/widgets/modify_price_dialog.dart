import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/order_price_field.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class ModifyPriceDialog extends StatefulWidget {
  const ModifyPriceDialog({
    Key? key,
    required this.controller,
    required this.orderDetailsData,
    this.asset,
    this.icon,
  }) : super(key: key);

  final TextEditingController controller;
  final Asset? asset;
  final Image? icon;
  final OrderDetailsData orderDetailsData;

  @override
  _ModifyPriceDialogState createState() => _ModifyPriceDialogState();
}

class _ModifyPriceDialogState extends State<ModifyPriceDialog> {
  late FocusNode focusNode;
  double sliderValue = 0;
  BuildContext? currentContext;
  String priceConversion = '';
  bool inversePrice = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild(context));

    currentContext = context.read(walletProvider).navigatorKey.currentContext;

    widget.controller.addListener(() {
      updateDollarConversion();
    });

    inversePrice = !widget.orderDetailsData.sellBitcoin;

    if (widget.orderDetailsData.isTracking) {
      sliderValue = double.tryParse(
              ((widget.orderDetailsData.indexPrice - 1) * 100)
                  .toStringAsFixed(2)) ??
          0;
    }

    context
        .read(marketsProvider)
        .subscribeIndexPrice(assetId: widget.orderDetailsData.assetId);
  }

  @override
  void dispose() {
    focusNode.dispose();
    if (currentContext != null) {
      currentContext!.read(marketsProvider).unsubscribeIndexPrice();
    }
    super.dispose();
  }

  void afterBuild(BuildContext context) async {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void onSubmit() {
    final isToken = context
        .read(requestOrderProvider)
        .isAssetToken(widget.orderDetailsData.assetId);

    if (widget.orderDetailsData.isTracking) {
      final indexPrice = 1 + (sliderValue / 100);
      context.read(requestOrderProvider).modifyOrderPrice(
            widget.orderDetailsData.orderId,
            isToken: isToken,
            indexPrice: indexPrice,
          );
      Navigator.of(context).pop();
      return;
    }

    var price = widget.controller.text;
    final pricedInLiquid = context
        .read(requestOrderProvider)
        .isPricedInLiquid(widget.orderDetailsData.assetId);
    context.read(requestOrderProvider).modifyOrderPrice(
          widget.orderDetailsData.orderId,
          isToken: isToken,
          price: price,
          isPricedInLiquid: pricedInLiquid,
        );
    Navigator.of(context).pop();
  }

  void updateDollarConversion() {
    final priceAssetId = widget.asset?.assetId ?? '';
    setState(() {
      if (priceAssetId == context.read(walletProvider).tetherAssetId()) {
        priceConversion = '';
      } else {
        priceConversion = context
            .read(requestOrderProvider)
            .dollarConversionFromString(priceAssetId, widget.controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticker = context
        .read(requestOrderProvider)
        .tickerForAssetId(widget.asset?.assetId ?? '');
    final trackingPriceFixed = context
        .read(marketsProvider)
        .calculateTrackingPrice(inversePrice ? -sliderValue : sliderValue,
            widget.asset?.assetId ?? '');
    final trackingPrice =
        '${replaceCharacterOnPosition(input: trackingPriceFixed)} $ticker';
    final tracking = widget.orderDetailsData.isTracking;
    var displaySlider = tracking;
    final isToken = context
        .read(requestOrderProvider)
        .isAssetToken(widget.orderDetailsData.assetId);
    final indexPrice = context
        .read(marketsProvider)
        .getIndexPriceStr(widget.asset?.assetId ?? '');
    if (!tracking && (!isToken && indexPrice.isNotEmpty)) {
      displaySlider = true;
    }

    if (displaySlider) {
      widget.controller.text = trackingPriceFixed;
    }
    updateDollarConversion();

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      insetPadding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(top: 26.h, left: 16.w, right: 16.w),
                  child: Column(
                    children: [
                      Container(
                        height: 410.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                          color: const Color(0xFF1C6086),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 24.h, left: 16.w, right: 16.w),
                          child: Column(
                            children: [
                              Text(
                                'Modify Price'.tr(),
                                style: GoogleFonts.roboto(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 33.h),
                                child: OrderPriceField(
                                  controller: widget.controller,
                                  focusNode: focusNode,
                                  asset: widget.asset,
                                  icon: widget.icon,
                                  onEditingComplete: onSubmit,
                                  description: 'Price'.tr(),
                                  sliderValue: sliderValue,
                                  tracking: widget.orderDetailsData.isTracking,
                                  trackingPrice: trackingPrice,
                                  dollarConversion: priceConversion,
                                  displaySlider: displaySlider,
                                  onSliderChanged: (value) {
                                    setState(() {
                                      sliderValue = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: CustomBigButton(
                                  width: double.maxFinite,
                                  height: 54.h,
                                  text: 'SUBMIT'.tr(),
                                  backgroundColor: const Color(0xFF00C5FF),
                                  onPressed: onSubmit,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16.h),
                                child: CustomBigButton(
                                  width: double.maxFinite,
                                  height: 54.h,
                                  text: 'CANCEL'.tr(),
                                  backgroundColor: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
