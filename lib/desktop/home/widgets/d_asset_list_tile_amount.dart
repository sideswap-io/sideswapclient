import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DAssetListTileAmount extends ConsumerWidget {
  const DAssetListTileAmount({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultCurrencyTicker = ref.watch(defaultCurrencyTickerProvider);
    final defaultCurrencyAssetBalance = ref.watch(
      assetBalanceInDefaultCurrencyStringProvider(asset),
    );
    final assetBalance = ref.watch(assetBalanceStringProvider(asset));

    return SizedBox(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$defaultCurrencyAssetBalance $defaultCurrencyTicker',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: SideSwapColors.cornFlower),
          ),
          Text(
            assetBalance,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(letterSpacing: -0.2),
          ),
        ],
      ),
    );
  }
}
