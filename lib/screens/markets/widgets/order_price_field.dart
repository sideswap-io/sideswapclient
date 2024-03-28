import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/order_price_text_field.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class OrderPriceField extends ConsumerWidget {
  const OrderPriceField({
    super.key,
    this.controller,
    required this.asset,
    required this.productAsset,
    this.icon,
    this.focusNode,
    this.currencyConversion = '',
    this.onEditingComplete,
    this.tracking = false,
    this.onToggleTracking,
    this.onSliderChanged,
    this.displaySlider = false,
    this.invertColors,
  });

  final TextEditingController? controller;
  final Asset? asset;
  final Asset? productAsset;
  final Widget? icon;
  final FocusNode? focusNode;
  final String currencyConversion;
  final void Function()? onEditingComplete;
  final bool tracking;
  final void Function(bool)? onToggleTracking;
  final void Function(double)? onSliderChanged;
  final bool displaySlider;
  final bool? invertColors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToken =
        ref.watch(assetUtilsProvider).isAssetToken(assetId: asset?.assetId);
    final marketType = getMarketType(productAsset);
    final indexPriceStr = ref
        .watch(indexPriceForAssetProvider(asset?.assetId))
        .getIndexPriceStr();
    final lastPriceStr =
        ref.watch(lastStringIndexPriceForAssetProvider(productAsset?.assetId));
    var minPercent = -kEditPriceMaxTrackingPercent;
    var maxPercent = kEditPriceMaxTrackingPercent;
    if (!tracking && (!isToken && indexPriceStr.isNotEmpty)) {
      minPercent = -kEditPriceMaxPercent;
      maxPercent = kEditPriceMaxPercent;
    }

    return SizedBox(
      height: isToken ? 135 : 188,
      child: Column(
        children: [
          SizedBox(
            height: 37,
            child: Row(
              mainAxisAlignment: marketType == MarketType.stablecoin
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    if (marketType == MarketType.stablecoin &&
                            indexPriceStr.isEmpty ||
                        marketType != MarketType.stablecoin &&
                            lastPriceStr.isEmpty) {
                      return const SizedBox();
                    }

                    return GestureDetector(
                      onTap: () {
                        setControllerValue(
                            controller,
                            marketType == MarketType.stablecoin
                                ? indexPriceStr
                                : lastPriceStr);
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
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Text(
                            marketType == MarketType.stablecoin
                                ? '${replaceCharacterOnPosition(input: indexPriceStr)} ${asset?.ticker ?? ''}'
                                : '$lastPriceStr L-BTC',
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
                if (asset?.swapMarket == true)
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
              child: Consumer(
                builder: (context, ref, child) {
                  final sliderValue =
                      ref.watch(orderPriceFieldSliderValueProvider);
                  return OrderTrackingSlider(
                    value: sliderValue,
                    onChanged: onSliderChanged,
                    minPercent: minPercent,
                    maxPercent: maxPercent,
                    icon: icon,
                    asset: asset,
                    price: controller?.text ?? '',
                    currencyConversion: currencyConversion,
                    invertColors: invertColors,
                  );
                },
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
                productAsset: productAsset,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
