import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/csv_export_button.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/markets/widgets/regular_flag.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';
import 'package:sideswap/screens/tx/widgets/tx_list_item.dart';

class Transactions extends HookConsumerWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);
    final allTransactions = ref.watch(distinctTransactionsForAccountProvider);

    final pageStorageKeyData = ref.watch(pageStorageKeyDataProvider);
    final storageKey = useMemoized(() => PageStorageKey(pageStorageKeyData));

    return SideSwapScaffold(
      appBar: AppBar(
        backgroundColor: SideSwapColors.chathamsBlue,
        flexibleSpace: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                CustomBackButton(
                  color: SideSwapColors.freshAir,
                  onPressed: () {
                    ref.invalidate(pageStorageKeyDataProvider);
                    ref.read(walletProvider).goBack();
                  },
                ),
                Text(
                  'Transactions'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                switch (selectedAccountType) {
                  AccountType accountType when accountType.isAmp =>
                    const AmpFlag(
                      textStyle: TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  _ => const RegularFlag(
                      textStyle: TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                },
                const Spacer(),
                const CsvExportButton(),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.invalidate(pageStorageKeyDataProvider);
          ref.read(walletProvider).goBack();
        }
      },
      backgroundColor: SideSwapColors.chathamsBlue,
      sideSwapBackground: false,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: allTransactions.isEmpty
              ? ScrollConfiguration.of(context).copyWith(scrollbars: false)
              : ScrollConfiguration.of(context),
          child: CustomScrollView(
            key: storageKey,
            physics: allTransactions.isEmpty
                ? const NeverScrollableScrollPhysics()
                : null,
            slivers: [
              SliverList.builder(
                itemBuilder: (context, index) {
                  return allTransactions.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TxListItem(txItem: allTransactions[index]),
                        )
                      : const EmptyTxListItem();
                },
                itemCount:
                    allTransactions.isNotEmpty ? allTransactions.length : 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
