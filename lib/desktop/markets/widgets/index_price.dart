import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class IndexPrice extends ConsumerWidget {
  const IndexPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexPrice = ref.watch(marketIndexPriceProvider);
    final lastPrice = ref.watch(marketLastPriceProvider);

    return indexPrice.match(
      () => lastPrice.match(
        () => SizedBox(),
        (value) => IndexPriceRow(
          price: value.lastPrice,
          optionAsset: value.quoteAsset,
          description: 'Last price:'.tr(),
        ),
      ),
      (value) => IndexPriceRow(
        price: value.indexPrice,
        optionAsset: value.quoteAsset,
        description: 'Index price:'.tr(),
      ),
    );
  }
}

class IndexPriceRow extends ConsumerWidget {
  const IndexPriceRow({
    required this.price,
    required this.optionAsset,
    required this.description,
    super.key,
  });

  final String price;
  final Option<Asset> optionAsset;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref
            .watch(desktopAppThemeNotifierProvider)
            .buttonThemeData
            .defaultButtonStyle;

    return Row(
      children: [
        DButton(
          cursor: SystemMouseCursors.click,
          style: buttonStyle?.merge(
            DButtonStyle(
              padding: ButtonState.all(EdgeInsets.zero),
              border: ButtonState.all(BorderSide.none),
              shape: ButtonState.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ),
          child: SizedBox(
            height: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF3983AD),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 5),
                    optionAsset.match(() => SizedBox(), (asset) {
                      final icon = ref
                          .watch(assetImageRepositoryProvider)
                          .getVerySmallImage(asset.assetId);
                      return icon;
                    }),
                    const SizedBox(width: 3),
                    optionAsset.match(() => SizedBox(), (asset) {
                      return Text(
                        asset.ticker,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          onPressed: () {
            ref
                .read(indexPriceButtonAsyncNotifierProvider.notifier)
                .setIndexPrice(price);
          },
        ),
      ],
    );
  }
}
