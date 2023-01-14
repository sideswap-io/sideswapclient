import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/order_price_text_field.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderPriceField extends ConsumerWidget {
  const OrderPriceField({
    super.key,
    required this.controller,
    required this.asset,
    required this.productAsset,
    this.icon,
    this.focusNode,
    this.dollarConversion = '',
    this.onEditingComplete,
    this.tracking = false,
    this.onToggleTracking,
    required this.sliderValue,
    required this.onSliderChanged,
    this.trackingPrice = '',
    this.displaySlider = false,
    required this.invertColors,
  });

  final TextEditingController controller;
  final Asset asset;
  final Asset productAsset;
  final Image? icon;
  final FocusNode? focusNode;
  final String dollarConversion;
  final void Function()? onEditingComplete;
  final bool tracking;
  final void Function(bool)? onToggleTracking;
  final double sliderValue;
  final void Function(double)? onSliderChanged;
  final String trackingPrice;
  final bool displaySlider;
  final bool invertColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToken = ref.read(requestOrderProvider).isAssetToken(asset.assetId);
    final marketType = getMarketType(productAsset);
    final indexPrice =
        ref.read(marketsProvider).getIndexPriceStr(asset.assetId);
    final lastPrice =
        ref.read(marketsProvider).getLastPriceStr(productAsset.assetId);
    var minPercent = -kEditPriceMaxTrackingPercent;
    var maxPercent = kEditPriceMaxTrackingPercent;
    if (!tracking && (!isToken && indexPrice.isNotEmpty)) {
      minPercent = -kEditPriceMaxPercent;
      maxPercent = kEditPriceMaxPercent;
    }

    return SizedBox(
      height: isToken ? 129 : 188,
      child: Column(
        children: [
          SizedBox(
            height: 34,
            child: Row(
              mainAxisAlignment: marketType == MarketType.stablecoin
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    var indexPrice = ref
                        .watch(marketsProvider)
                        .getIndexPriceStr(asset.assetId);
                    if (displaySlider && onSliderChanged != null) {
                      Future.microtask(() => onSliderChanged!(sliderValue));
                    }

                    if (marketType == MarketType.stablecoin &&
                            indexPrice.isEmpty ||
                        marketType != MarketType.stablecoin &&
                            lastPrice.isEmpty) {
                      return Container();
                    }

                    return GestureDetector(
                      onTap: () {
                        setValue(
                            controller,
                            marketType == MarketType.stablecoin
                                ? indexPrice
                                : lastPrice);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            marketType == MarketType.stablecoin
                                ? 'Index price:'.tr()
                                : 'Last price:'.tr(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00C5FF),
                            ),
                          ),
                          Text(
                            marketType == MarketType.stablecoin
                                ? '${replaceCharacterOnPosition(input: indexPrice)} ${asset.ticker}'
                                : '$lastPrice L-BTC',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (asset.swapMarket)
                  SwitchButton(
                    width: 142,
                    height: 35,
                    borderRadius: 8,
                    borderWidth: 2,
                    activeText: 'Tracking'.tr(),
                    inactiveText: 'Limit'.tr(),
                    value: tracking,
                    onToggle: onToggleTracking,
                  ),
              ],
            ),
          ),
          if (displaySlider) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OrderTrackingSlider(
                value: sliderValue,
                onChanged: onSliderChanged,
                minPercent: minPercent,
                maxPercent: maxPercent,
                icon: icon,
                asset: asset,
                price: controller.text,
                dollarConversion: dollarConversion,
                invertColors: invertColors,
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OrderPriceTextField(
                icon: icon,
                asset: asset,
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
