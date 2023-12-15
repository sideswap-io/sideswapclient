import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DAssetListTileAmount extends ConsumerWidget {
  const DAssetListTileAmount({
    super.key,
    required this.accountAsset,
  });

  final AccountAsset accountAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountBalance =
        ref.watch(balancesNotifierProvider)[accountAsset] ?? 0;
    final asset = ref.watch(
        assetsStateProvider.select((value) => value[accountAsset.assetId]));
    final balanceStr = ref.watch(amountToStringProvider).amountToString(
        AmountToStringParameters(
            amount: accountBalance, precision: asset?.precision ?? 0));
    final balance = double.tryParse(balanceStr) ?? .0;
    final amountUsd =
        ref.watch(amountUsdProvider(accountAsset.assetId, balance));
    var dollarConversion = '0.0';
    dollarConversion = amountUsd.toStringAsFixed(2);
    final visibleConversion =
        ref.read(walletProvider).isAmountUsdAvailable(asset?.assetId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        switch (visibleConversion) {
          true => Text(
              '$dollarConversion USD',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 13,
                  letterSpacing: 0.07,
                  color: SideSwapColors.cornFlower),
            ),
          false => Text(
              '0.00 USD',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 13,
                  letterSpacing: 0.07,
                  color: SideSwapColors.cornFlower),
            ),
        },
        Text(
          balanceStr,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(letterSpacing: -0.2),
        ),
      ],
    );
  }
}
