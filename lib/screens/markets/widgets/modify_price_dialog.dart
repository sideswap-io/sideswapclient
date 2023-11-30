import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/markets/widgets/order_price_field.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

// TODO (malcolmpl): change slider value to provider
class ModifyPriceDialog extends ConsumerStatefulWidget {
  const ModifyPriceDialog({
    super.key,
    required this.controller,
    required this.orderDetailsData,
    required this.asset,
    required this.productAsset,
    this.icon,
  });

  final TextEditingController controller;
  final Asset? asset;
  final Asset? productAsset;
  final Widget? icon;
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

    currentContext = ref.read(navigatorKeyProvider).currentContext;

    markets = ref.read(marketsProvider);

    widget.controller.addListener(() {
      updateDollarConversion();
    });

    inversePrice = !widget.orderDetailsData.sellBitcoin;

    if (widget.orderDetailsData.isTracking) {
      final indexPrice = ref
              .read(marketRequestOrderByIdProvider(
                  widget.orderDetailsData.orderId))
              ?.indexPrice ??
          0;
      sliderValue =
          double.tryParse(((indexPrice - 1) * 100).toStringAsFixed(2)) ?? 0;
    } else {
      final indexPrice = ref
          .read(indexPriceForAssetProvider(widget.asset?.assetId))
          .indexPrice;
      final orderPrice = ref
              .read(marketRequestOrderByIdProvider(
                  widget.orderDetailsData.orderId))
              ?.price ??
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

    markets.subscribeIndexPrice(widget.orderDetailsData.assetId);
  }

  late MarketsProvider markets;

  @override
  void dispose() {
    focusNode.dispose();
    if (currentContext != null) {
      markets.unsubscribeIndexPrice();
    }
    super.dispose();
  }

  void afterBuild(BuildContext context) async {
    FocusScope.of(context).requestFocus(focusNode);
  }

  void onSubmit() {
    final isToken = ref
        .read(assetUtilsProvider)
        .isAssetToken(assetId: widget.orderDetailsData.assetId);

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

  void updateDollarConversion() {
    final priceAssetId = widget.asset?.assetId;
    setState(() {
      if (priceAssetId == ref.read(tetherAssetIdStateProvider)) {
        priceConversion = '';
      } else {
        priceConversion = ref.read(dollarConversionFromStringProvider(
            priceAssetId, widget.controller.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackingPriceFixed = ref
        .watch(indexPriceForAssetProvider(widget.asset?.assetId))
        .calculateTrackingPrice(sliderValue);
    final tracking = widget.orderDetailsData.isTracking;
    var displaySlider = tracking;
    final isToken = ref
        .watch(assetUtilsProvider)
        .isAssetToken(assetId: widget.orderDetailsData.assetId);
    final indexPriceStr = ref
        .watch(indexPriceForAssetProvider(widget.asset?.assetId))
        .getIndexPriceStr();
    if (!tracking && (!isToken && indexPriceStr.isNotEmpty)) {
      displaySlider = true;
    }

    if (displaySlider) {
      widget.controller.text = trackingPriceFixed;
    }
    updateDollarConversion();

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
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
                  padding: const EdgeInsets.only(top: 26, left: 16, right: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 430,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: SideSwapColors.blumine,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(42),
                                child: InkWell(
                                  onTap: () {
                                    ref.read(walletProvider).cancelOrder(
                                        widget.orderDetailsData.orderId);
                                    Navigator.of(context).pop();
                                  },
                                  borderRadius: BorderRadius.circular(42),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/delete.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 24, left: 16, right: 16),
                              child: Column(
                                children: [
                                  Text(
                                    'Modify Price'.tr(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 33),
                                    child: OrderPriceField(
                                      controller: widget.controller,
                                      focusNode: focusNode,
                                      asset: widget.asset,
                                      productAsset: widget.productAsset,
                                      icon: widget.icon,
                                      onEditingComplete: onSubmit,
                                      tracking:
                                          widget.orderDetailsData.isTracking,
                                      dollarConversion: priceConversion,
                                      displaySlider: displaySlider,
                                      invertColors: inversePrice,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: CustomBigButton(
                                      width: double.maxFinite,
                                      height: 54,
                                      text: 'SUBMIT'.tr(),
                                      backgroundColor:
                                          SideSwapColors.brightTurquoise,
                                      onPressed: onSubmit,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 16),
                                    child: CustomBigButton(
                                      width: double.maxFinite,
                                      height: 54,
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
