import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class InstantSwapHeader extends ConsumerWidget {
  const InstantSwapHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionExchangeSide = ref.watch(exchangeSideProvider);

    return optionExchangeSide.match(
      () {
        return const SizedBox();
      },
      (side) {
        final optionAsset = ref.watch(
          assetFromAssetIdProvider(side.accountAsset.assetId),
        );
        return optionAsset.match(
          () => const SizedBox(),
          (asset) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  switch (side) {
                    ExchangeSideSell() => Text(
                      'Sell {}'.tr(args: [asset.ticker]),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    _ => Text(
                      'Buy {}'.tr(args: [asset.ticker]),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  },
                  Text('Placeholder EURx 1 = L-BTC 0.00003333'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
