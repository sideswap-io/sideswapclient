import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

part 'new_market_type_buttons.g.dart';

enum SelectedMarketTypeEnum {
  orders,
  tokenMarket,
  swapMarket,
}

@riverpod
class SelectedMarketType extends _$SelectedMarketType {
  @override
  SelectedMarketTypeEnum build() {
    return SelectedMarketTypeEnum.orders;
  }

  void setSelectedMarketType(SelectedMarketTypeEnum selectedMarketTypeEnum) {
    state = selectedMarketTypeEnum;
  }
}

class MarketTypeButtons extends ConsumerWidget {
  const MarketTypeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMarketType = ref.watch(selectedMarketTypeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 36,
        decoration: const BoxDecoration(
          color: SideSwapColors.prussianBlue,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: SwapButton(
                text: 'Orders'.tr(),
                color: selectedMarketType == SelectedMarketTypeEnum.orders
                    ? SideSwapColors.cyanCornflowerBlue
                    : SideSwapColors.prussianBlue,
                textColor: selectedMarketType == SelectedMarketTypeEnum.orders
                    ? Colors.white
                    : SideSwapColors.ceruleanFrost,
                onPressed: () {
                  ref
                      .read(selectedMarketTypeProvider.notifier)
                      .setSelectedMarketType(SelectedMarketTypeEnum.orders);
                },
              ),
            ),
            Expanded(
              child: SwapButton(
                text: 'Token market'.tr(),
                color: selectedMarketType == SelectedMarketTypeEnum.tokenMarket
                    ? SideSwapColors.cyanCornflowerBlue
                    : SideSwapColors.prussianBlue,
                textColor:
                    selectedMarketType == SelectedMarketTypeEnum.tokenMarket
                        ? Colors.white
                        : SideSwapColors.ceruleanFrost,
                onPressed: () {
                  ref
                      .read(selectedMarketTypeProvider.notifier)
                      .setSelectedMarketType(
                          SelectedMarketTypeEnum.tokenMarket);
                },
              ),
            ),
            Expanded(
              child: SwapButton(
                text: 'Swap market'.tr(),
                color: selectedMarketType == SelectedMarketTypeEnum.swapMarket
                    ? SideSwapColors.cyanCornflowerBlue
                    : SideSwapColors.prussianBlue,
                textColor:
                    selectedMarketType == SelectedMarketTypeEnum.swapMarket
                        ? Colors.white
                        : SideSwapColors.ceruleanFrost,
                onPressed: () {
                  ref
                      .read(selectedMarketTypeProvider.notifier)
                      .setSelectedMarketType(SelectedMarketTypeEnum.swapMarket);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
