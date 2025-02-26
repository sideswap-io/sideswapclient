import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';

class DAssetListTileAmount extends ConsumerWidget {
  const DAssetListTileAmount({super.key, required this.accountAsset});

  final AccountAsset accountAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultCurrencyAssetBalance = ref.watch(
      accountAssetBalanceInDefaultCurrencyStringProvider(accountAsset),
    );
    final assetBalance = ref.watch(
      accountAssetBalanceStringProvider(accountAsset),
    );
    final defaultCurrencyTicker = ref.watch(defaultCurrencyTickerProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$defaultCurrencyAssetBalance $defaultCurrencyTicker',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 13,
            letterSpacing: 0.07,
            color: SideSwapColors.cornFlower,
          ),
        ),
        Text(
          assetBalance,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(letterSpacing: -0.2),
        ),
      ],
    );
  }
}
