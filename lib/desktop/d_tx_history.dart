import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_amount.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_confs.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_date.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_header.dart';
import 'package:sideswap/desktop/widgets/d_tx_blinded_url_icon_button.dart';
import 'package:sideswap/desktop/widgets/d_flexes_row.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_type.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DTxHistory extends HookConsumerWidget {
  const DTxHistory({
    super.key,
    this.horizontalPadding = 32,
    this.newTxsOnly = false,
  });

  final double horizontalPadding;
  final bool newTxsOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(txHistoryStateNotifierProvider.notifier).setVisible();

      return;
    }, const []);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
          child: DFlexesRow(
            children: [
              DTxHistoryHeader(text: 'Date'.tr()),
              DTxHistoryHeader(text: 'Type'.tr()),
              DTxHistoryHeader(text: 'Sent'.tr()),
              DTxHistoryHeader(text: 'Received'.tr()),
              DTxHistoryHeader(text: 'Confirmations'.tr()),
              DTxHistoryHeader(text: 'Link'.tr()),
            ],
          ),
        ),
        HookConsumer(
          builder: (context, ref, child) {
            final loadTransactionsState = ref.watch(
              loadTransactionsStateNotifierProvider,
            );

            useEffect(() {
              logger.d(loadTransactionsState);

              return;
            }, [loadTransactionsState]);

            return Flexible(
              child: Stack(
                children: [
                  DTxHistoryTransaction(
                    horizontalPadding: horizontalPadding,
                    newTxsOnly: newTxsOnly,
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
            );
          },
        ),
      ],
    );
  }
}

class DTxHistoryTransaction extends HookConsumerWidget {
  const DTxHistoryTransaction({
    super.key,
    required this.newTxsOnly,
    required this.horizontalPadding,
  });

  final double horizontalPadding;
  final bool newTxsOnly;

  static DateFormat dateFormatDate = DateFormat('y-MM-dd ');
  static DateFormat dateFormatTime = DateFormat('HH:mm:ss');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
    final allNewTxSorted = ref.watch(allNewTxsSortedProvider);
    final allTxSorted = ref.watch(allTxsSortedProvider);
    final txList = newTxsOnly ? allNewTxSorted : allTxSorted;
    final loadTransactionsState = ref.watch(
      loadTransactionsStateNotifierProvider,
    );

    useAsyncEffect(() async {
      await (switch (loadTransactionsState) {
        LoadTransactionsStateError() => () async {
          if (loadTransactionsState.errorMsg != null) {
            final flushbar = Flushbar<void>(
              messageText: Text(
                'Error loading transactions: {}'.tr(
                  args: [loadTransactionsState.errorMsg!],
                ),
              ),
              icon: const Icon(Icons.error, color: SideSwapColors.yellowOrange),
              duration: const Duration(seconds: 3),
              backgroundColor: SideSwapColors.chathamsBlue,
              onTap: (flushbar) {
                flushbar.dismiss();
              },
            );

            await flushbar.show(context);
          }
        }(),
        _ => () {}(),
      });

      return;
    }, [loadTransactionsState]);

    if (txList.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(height: 1, color: SideSwapColors.jellyBean),
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions'.tr(),
            style: const TextStyle(color: SideSwapColors.cornFlower),
          ),
        ],
      );
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final transItem = txList[index];
        final transItemHelper = ref.watch(transItemHelperProvider(transItem));
        final txIds = transItemHelper.txId();

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(height: 1, color: SideSwapColors.jellyBean),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 1,
              ),
              child: DTransparentButton(
                child: DFlexesRow(
                  children: [
                    DTxHistoryDate(
                      dateFormatDate: dateFormatDate,
                      dateFormatTime: dateFormatTime,
                      tx: transItem,
                      dateTextStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                      timeTextStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    DTxHistoryType(
                      transItem: transItem,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    DTxHistoryAmount(
                      balance: transItemHelper.getSentBalance(
                        liquidAssetId,
                        bitcoinAssetId,
                      ),
                      multipleOutputs: transItemHelper.getSentMultipleOutputs(),
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    DTxHistoryAmount(
                      balance: transItemHelper.getRecvBalance(
                        liquidAssetId,
                        bitcoinAssetId,
                      ),
                      multipleOutputs: transItemHelper.getRecvMultipleOutputs(),
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    DTxHistoryConfs(
                      tx: transItem,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    DTxBlindedUrlIconButton(
                      txid: txIds.txId,
                      isLiquid: txIds.isLiquid,
                      unblinded: txIds.unblinded,
                    ),
                  ],
                ),
                onPressed: () {
                  final allPegsById = ref.read(allPegsByIdProvider);
                  ref
                      .read(desktopDialogProvider)
                      .showTx(
                        transItem,
                        isPeg: allPegsById.containsKey(transItem.id),
                      );
                },
              ),
            ),
          ],
        );
      },
      itemCount: txList.length,
    );
  }
}
