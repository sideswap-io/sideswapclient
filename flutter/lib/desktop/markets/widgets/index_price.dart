import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class IndexPrice extends ConsumerWidget {
  const IndexPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAssetId = ref.watch(marketSelectedAssetIdProvider);
    final asset = ref
        .watch(assetsStateProvider.select((value) => value[selectedAssetId]));
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
    final indexPrice =
        ref.watch(indexPriceForAssetProvider(selectedAssetId)).indexPrice;
    final lastPrice = ref
        .watch(lastIndexPriceForAssetProvider(selectedAssetId))
        .lastIndexPrice;
    final indexPriceStr = priceStr(indexPrice, pricedInLiquid);
    final lastPriceStr = priceStr(lastPrice, pricedInLiquid);
    final icon =
        ref.watch(assetImageProvider).getVerySmallImage(selectedAssetId);
    final buttonStyle =
        ref.watch(desktopAppThemeProvider).buttonThemeData.defaultButtonStyle;

    return Visibility(
      visible: indexPrice != 0 || lastPrice != 0,
      child: Row(
        children: [
          Container(
            width: 1,
            color: const Color(0xFF28749E),
          ),
          DButton(
            cursor: SystemMouseCursors.click,
            style: buttonStyle?.merge(
              DButtonStyle(
                padding: ButtonState.all(EdgeInsets.zero),
                border: ButtonState.all(BorderSide.none),
                shape: ButtonState.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            child: SizedBox(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        indexPrice != 0
                            ? 'Index price:'.tr()
                            : 'Last price:'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF3983AD),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        indexPrice != 0 ? indexPriceStr : lastPriceStr,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      icon,
                      const SizedBox(width: 3),
                      Text(
                        asset?.ticker ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onPressed: () {
              ref.read(indexPriceButtonProvider.notifier).setIndexPrice(
                  indexPrice != 0 ? indexPriceStr : lastPriceStr);
            },
          ),
          Container(
            width: 1,
            color: const Color(0xFF28749E),
          ),
        ],
      ),
    );
  }
}
