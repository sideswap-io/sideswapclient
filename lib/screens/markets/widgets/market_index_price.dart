import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';

class MarketIndexPrice extends ConsumerWidget {
  const MarketIndexPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexPrice = ref.watch(marketIndexPriceProvider);
    final lastPrice = ref.watch(marketLastPriceProvider);

    final headerText = indexPrice.match(
      () => lastPrice.match(() => '', (_) => 'Last price:'.tr()),
      (_) => 'Index price:'.tr(),
    );

    final valueText = indexPrice.match(
      () => lastPrice.match(() => '', (value) => value.lastPrice),
      (value) => value.indexPrice,
    );

    final icon = indexPrice.match(
      () => lastPrice.match(
        () => null,
        (value) => value.quoteAsset.match(
          () => null,
          (asset) => ref
              .watch(assetImageRepositoryProvider)
              .getSmallImage(asset.assetId),
        ),
      ),
      (value) => value.quoteAsset.match(
        () => null,
        (asset) => ref
            .watch(assetImageRepositoryProvider)
            .getSmallImage(asset.assetId),
      ),
    );

    final ticker = indexPrice.match(
      () => lastPrice.match(
        () => '',
        (value) => value.quoteAsset.match(() => '', (asset) => asset.ticker),
      ),
      (value) => value.quoteAsset.match(() => '', (asset) => asset.ticker),
    );

    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: SideSwapColors.blueSapphire,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.zero,
          ),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        onPressed: () {
          ref
              .read(indexPriceButtonAsyncNotifierProvider.notifier)
              .setIndexPrice(valueText);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              headerText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 15,
                height: 0.08,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              valueText,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 15, height: 0.08),
            ),
            const SizedBox(width: 6),
            SizedBox(width: 16, child: icon),
            const SizedBox(width: 6),
            Text(
              ticker,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 15, height: 0.08),
            ),
          ],
        ),
      ),
    );
  }
}
