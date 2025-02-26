import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';
import 'package:easy_localization/easy_localization.dart';

part 'market_type_buttons.g.dart';

enum SelectedMarketTypeButtonEnum { swap, orders }

@Riverpod(keepAlive: true)
class SelectedMarketTypeButtonNotifier
    extends _$SelectedMarketTypeButtonNotifier {
  @override
  SelectedMarketTypeButtonEnum build() {
    return SelectedMarketTypeButtonEnum.swap;
  }

  void setSelectedMarketType(
    SelectedMarketTypeButtonEnum selectedMarketTypeEnum,
  ) {
    state = selectedMarketTypeEnum;
  }
}

class MarketTypeButtons extends ConsumerWidget {
  const MarketTypeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMarketType = ref.watch(
      selectedMarketTypeButtonNotifierProvider,
    );

    return Container(
      width: double.maxFinite,
      height: 36,
      decoration: BoxDecoration(
        color: SideSwapColors.prussianBlue,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SwapButton(
              color:
                  selectedMarketType == SelectedMarketTypeButtonEnum.swap
                      ? SideSwapColors.cyanCornflowerBlue
                      : SideSwapColors.prussianBlue,
              text: 'Markets'.tr(),
              textColor:
                  selectedMarketType == SelectedMarketTypeButtonEnum.swap
                      ? Colors.white
                      : SideSwapColors.ceruleanFrost,
              onPressed: () {
                ref
                    .read(selectedMarketTypeButtonNotifierProvider.notifier)
                    .setSelectedMarketType(SelectedMarketTypeButtonEnum.swap);
              },
            ),
          ),
          Flexible(
            child: SwapButton(
              color:
                  selectedMarketType == SelectedMarketTypeButtonEnum.orders
                      ? SideSwapColors.cyanCornflowerBlue
                      : SideSwapColors.prussianBlue,
              text: 'Orders'.tr(),
              textColor:
                  selectedMarketType == SelectedMarketTypeButtonEnum.orders
                      ? Colors.white
                      : SideSwapColors.ceruleanFrost,
              onPressed: () {
                ref
                    .read(selectedMarketTypeButtonNotifierProvider.notifier)
                    .setSelectedMarketType(SelectedMarketTypeButtonEnum.orders);
              },
            ),
          ),
        ],
      ),
    );
  }
}
