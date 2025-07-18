import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_assets_list.dart';
import 'package:sideswap/desktop/home/widgets/d_background_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_assets_panel_header.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';

class DWalletAssetsPanel extends StatelessWidget {
  const DWalletAssetsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return DBackgroundPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final allVisibleAssets = ref.watch(allVisibleAssetsProvider);

              final defaultCurrencyConversion = ref.watch(
                assetsTotalDefaultCurrencyBalanceStringProvider(
                  allVisibleAssets,
                ),
              );
              final defaultCurrencyTicker = ref.watch(
                defaultCurrencyTickerProvider,
              );

              final lbtcConversion = ref.watch(
                assetsTotalLbtcBalanceProvider(allVisibleAssets),
              );

              return DAssetsPanelHeader(
                totalValueLabel: 'Total Value'.tr(),
                totalValue: '$defaultCurrencyConversion $defaultCurrencyTicker',
                totalBtcValue: '$lbtcConversion L-BTC',
              );
            },
          ),
          Flexible(
            child: Consumer(
              builder: (context, ref, _) {
                final allVisibleAssets = ref.watch(allVisibleAssetsProvider);
                return DAssetsList(assets: allVisibleAssets);
              },
            ),
          ),
        ],
      ),
    );
  }
}
