import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';
import 'package:sideswap/screens/accounts/widgets/csv_export_button.dart';

class Accounts extends ConsumerWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncComplete = ref.watch(walletProvider).syncComplete;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    Text(
                      'Assets'.tr(),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    const CsvExportButton(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final uiStateArgs = ref.read(uiStateArgsProvider);
                          uiStateArgs.walletMainArguments =
                              uiStateArgs.walletMainArguments.copyWith(
                                  navigationItem:
                                      WalletMainNavigationItem.assetSelect);

                          ref.read(walletProvider).selectAvailableAssets();
                        },
                        borderRadius: BorderRadius.circular(21),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: SvgPicture.asset(
                                  'assets/filter.svg',
                                  width: 22,
                                  height: 21,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final wallet = ref.watch(walletProvider);
                      final balances = ref.watch(balancesProvider);
                      final disabledAccounts = wallet.disabledAccounts;
                      // Always show accounts with positive balance
                      final alwaysEnabledAccounts = balances.balances.entries
                          .where((e) => e.value > 0)
                          .map((e) => e.key)
                          .toSet();
                      // Always show regular L-BTC account
                      alwaysEnabledAccounts.add(AccountAsset(
                          AccountType.reg, wallet.liquidAssetId()));
                      final availableAssets = wallet
                          .getAllAccounts()
                          .where((item) =>
                              !disabledAccounts.contains(item) ||
                              alwaysEnabledAccounts.contains(item))
                          .toList();

                      return ListView(
                        shrinkWrap: true,
                        children: List<Widget>.generate(
                          availableAssets.length,
                          (index) {
                            final accountAsset = availableAssets[index];
                            final balance = ref
                                    .watch(balancesProvider)
                                    .balances[accountAsset] ??
                                0;
                            return AccountItem(
                              balance: balance,
                              accountAsset: availableAssets[index],
                              onSelected: (AccountAsset value) {
                                final uiStateArgs =
                                    ref.read(uiStateArgsProvider);
                                uiStateArgs.walletMainArguments =
                                    uiStateArgs.walletMainArguments.copyWith(
                                        navigationItem: WalletMainNavigationItem
                                            .assetDetails);
                                wallet.selectAssetDetails(accountAsset);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!syncComplete)
          const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}