import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_assets_list.dart';
import 'package:sideswap/desktop/home/widgets/d_background_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_assets_panel_header.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';

class DRegularWalletAssetsPanel extends StatelessWidget {
  const DRegularWalletAssetsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return DBackgroundPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final regularAccounts =
                  ref.watch(regularVisibleAccountAssetsProvider);
              final dollarConversion = ref.watch(
                  accountAssetsTotalUsdBalanceStringProvider(regularAccounts));

              final lbtcConversion = ref.watch(
                  accountAssetsTotalLbtcBalanceProvider(regularAccounts));

              return DAssetsPanelHeader(
                title: 'Regular wallet'.tr(),
                totalValueLabel: 'Total Value'.tr(),
                totalValue: '$dollarConversion USD',
                totalBtcValue: '$lbtcConversion L-BTC',
                walletType: 'Singlesig',
              );
            },
          ),
          Flexible(
            child: Consumer(
              builder: (context, ref, _) {
                final regularAccounts =
                    ref.watch(regularVisibleAccountAssetsProvider);
                return DAssetsList(
                  accountAssets: regularAccounts,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
