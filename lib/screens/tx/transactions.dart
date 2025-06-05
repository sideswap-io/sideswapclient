import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/csv_export_button.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';
import 'package:sideswap/screens/tx/widgets/tx_list_item.dart';

class Transactions extends HookConsumerWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactions = ref.watch(distinctTransactionsForAccountProvider);
    final loadTransactionsState = ref.watch(
      loadTransactionsStateNotifierProvider,
    );
    final pageStorageKeyData = ref.watch(pageStorageKeyDataProvider);
    final storageKey = useMemoized(() => PageStorageKey(pageStorageKeyData));

    useEffect(() {
      ref.read(allTxsNotifierProvider.notifier).loadTransactions();

      return;
    }, const []);

    return SideSwapScaffold(
      appBar: AppBar(
        backgroundColor: SideSwapColors.chathamsBlue,
        flexibleSpace: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                CustomBackButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () {
                    ref.invalidate(pageStorageKeyDataProvider);
                    ref.read(walletProvider).goBack();
                  },
                ),
                Text(
                  'Transactions'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const CsvExportButton(),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.invalidate(pageStorageKeyDataProvider);
          ref.read(walletProvider).goBack();
        }
      },
      backgroundColor: SideSwapColors.chathamsBlue,
      sideSwapBackground: false,
      body: SafeArea(
        child: Stack(
          children: [
            ScrollConfiguration(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: TxListItem(txItem: allTransactions[index]),
                            )
                          : const EmptyTxListItem();
                    },
                    itemCount: allTransactions.isNotEmpty
                        ? allTransactions.length
                        : 10,
                  ),
                ],
              ),
            ),
            switch (loadTransactionsState) {
              LoadTransactionsStateLoading() => const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: SideSwapColors.jellyBean,
                  ),
                ),
              ),
              _ => const SizedBox(),
            },
          ],
        ),
      ),
    );
  }
}
