import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class ModifyPriceDialog extends ConsumerStatefulWidget {
  const ModifyPriceDialog({
    super.key,
    required this.controller,
    required this.orderDetailsData,
    this.asset,
    this.icon,
  });

  final TextEditingController controller;
  final Asset? asset;
  final Image? icon;
  final OrderDetailsData orderDetailsData;

  @override
  ModifyPriceDialogState createState() => ModifyPriceDialogState();
}

class ModifyPriceDialogState extends ConsumerState<ModifyPriceDialog> {
  late FocusNode focusNode;
  double sliderValue = 0;
  BuildContext? currentContext;
  String priceConversion = '';
  bool inversePrice = false;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));

    currentContext = ref.read(walletProvider).navigatorKey.currentContext;

    widget.controller.addListener(() {
      updateDollarConversion(ref);
    });

    inversePrice = !widget.orderDetailsData.sellBitcoin;

    if (widget.orderDetailsData.isTracking) {
      final indexPrice = ref
              .read(marketsProvider)
              .getRequestOrderById(widget.orderDetailsData.orderId)
              ?.indexPrice ??
          0;
      sliderValue =
          double.tryParse(((indexPrice - 1) * 100).toStringAsFixed(2)) ?? 0;
    } else {
      final indexPrice = ref
          .read(marketsProvider)
          .getIndexPriceForAsset(widget.asset?.assetId ?? '');
      final orderPrice = ref
              .read(marketsProvider)
              .getRequestOrderById(widget.orderDetailsData.orderId)
              ?.price ??
          0;
      0;
      if (indexPrice != 0 && orderPrice != 0) {
        sliderValue = double.tryParse(
                ((orderPrice - indexPrice) / indexPrice * 100)
                    .toStringAsFixed(2)) ??
            0;
        if (sliderValue > kEditPriceMaxPercent) {
          sliderValue = kEditPriceMaxPercent.toDouble();
        }
        if (sliderValue < -kEditPriceMaxPercent) {
          sliderValue = -kEditPriceMaxPercent.toDouble();
        }
      }
    }

    ref
        .read(marketsProvider)
        .subscribeIndexPrice(widget.orderDetailsData.assetId);
  }

  @override
  void dispose() {
    focusNode.dispose();
    if (currentContext != null) {
      ref.read(marketsProvider).unsubscribeIndexPrice();
    }
    super.dispose();
  }

  void afterBuild(BuildContext context) async {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void onSubmit() {
    final isToken = ref
        .read(requestOrderProvider)
        .isAssetToken(widget.orderDetailsData.assetId);

    if (widget.orderDetailsData.isTracking) {
      final indexPrice = 1 + sliderValue / 100;
      ref.read(requestOrderProvider).modifyOrderPrice(
            widget.orderDetailsData.orderId,
            isToken: isToken,
            indexPrice: indexPrice,
          );
      Navigator.of(context).pop();
      return;
    }

    var price = widget.controller.text;
    ref.read(requestOrderProvider).modifyOrderPrice(
          widget.orderDetailsData.orderId,
          isToken: isToken,
          price: price,
        );
    Navigator.of(context).pop();
  }

  void updateDollarConversion(WidgetRef ref) {
    final priceAssetId = widget.asset?.assetId ?? '';
    setState(() {
      if (priceAssetId == ref.read(walletProvider).tetherAssetId()) {
        priceConversion = '';
      } else {
        priceConversion = ref
            .read(requestOrderProvider)
            .dollarConversionFromString(priceAssetId, widget.controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticker = ref
        .read(requestOrderProvider)
        .tickerForAssetId(widget.asset?.assetId ?? '');
    final trackingPriceFixed = ref
        .read(marketsProvider)
        .calculateTrackingPrice(sliderValue, widget.asset?.assetId ?? '');
    final trackingPrice =
        '${replaceCharacterOnPosition(input: trackingPriceFixed)} $ticker';
    final tracking = widget.orderDetailsData.isTracking;
    var displaySlider = tracking;
    final isToken = ref
        .read(requestOrderProvider)
        .isAssetToken(widget.orderDetailsData.assetId);
    final indexPrice =
        ref.read(marketsProvider).getIndexPriceStr(widget.asset?.assetId ?? '');
    if (!tracking && (!isToken && indexPrice.isNotEmpty)) {
      displaySlider = true;
    }

    if (displaySlider) {
      widget.controller.text = trackingPriceFixed;
    }
    updateDollarConversion(ref);

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
                        child: Stack(
                          children: [
                            Positioned(
                              right: 12.h,
                              top: 12.h,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(42.w),
                                child: InkWell(
                                  onTap: () {
                                    ref.read(walletProvider).cancelOrder(
                                        widget.orderDetailsData.orderId);
                                    Navigator.of(context).pop();
                                  },
                                  borderRadius: BorderRadius.circular(42.w),
                                  child: Container(
                                    width: 48.w,
                                    height: 48.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/delete.svg',
                                        width: 24.w,
                                        height: 24.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
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
                                      sliderValue: sliderValue,
                                      tracking:
                                          widget.orderDetailsData.isTracking,
                                      trackingPrice: trackingPrice,
                                      dollarConversion: priceConversion,
                                      displaySlider: displaySlider,
                                      onSliderChanged: (value) {
                                        setState(() {
                                          sliderValue = value;
                                        });
                                      },
                                      invertColors: inversePrice,
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
                          ],
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
