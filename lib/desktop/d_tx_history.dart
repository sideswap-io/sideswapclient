import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_amount.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_confs.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_date.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_header.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_link.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_row.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_type.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_wallet.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DTxHistory extends StatelessWidget {
  const DTxHistory({
    super.key,
    this.horizontalPadding = 32,
    this.newTxsOnly = false,
  });

  final double horizontalPadding;
  final bool newTxsOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
          child: DTxHistoryRow(children: [
            DTxHistoryHeader(text: 'Date'.tr()),
            DTxHistoryHeader(text: 'Wallet'.tr()),
            DTxHistoryHeader(text: 'Type'.tr()),
            DTxHistoryHeader(text: 'Sent'.tr()),
            DTxHistoryHeader(text: 'Received'.tr()),
            DTxHistoryHeader(text: 'Confirmations'.tr()),
            DTxHistoryHeader(text: 'Link'.tr()),
          ]),
        ),
        Expanded(
          child: DTxHistoryTransaction(
            horizontalPadding: horizontalPadding,
            newTxsOnly: newTxsOnly,
          ),
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

    if (txList.isEmpty) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              height: 1,
              color: SideSwapColors.jellyBean,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions'.tr(),
            style: const TextStyle(
              color: Color(0xFF87C1E1),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final transItem = txList[index];
        final transItemHelper = ref.watch(transItemHelperProvider(transItem));

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                height: 1,
                color: SideSwapColors.jellyBean,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: 1),
              child: DTransparentButton(
                child: DTxHistoryRow(
                  children: [
                    DTxHistoryDate(
                        dateFormatDate: dateFormatDate,
                        dateFormatTime: dateFormatTime,
                        tx: transItem),
                    DTxHistoryWallet(tx: transItem),
                    DTxHistoryType(transItem: transItem),
                    DTxHistoryAmount(
                      balance: transItemHelper.getSentBalance(
                          liquidAssetId, bitcoinAssetId),
                      multipleOutputs: transItemHelper.getSentMultipleOutputs(),
                    ),
                    DTxHistoryAmount(
                      balance: transItemHelper.getRecvBalance(
                          liquidAssetId, bitcoinAssetId),
                      multipleOutputs: transItemHelper.getRecvMultipleOutputs(),
                    ),
                    DTxHistoryConfs(tx: transItem),
                    DTxHistoryLink(txid: transItem.tx.txid),
                  ],
                ),
                onPressed: () {
                  final allPegsById = ref.read(allPegsByIdProvider);
                  ref.read(desktopDialogProvider).showTx(transItem,
                      isPeg: allPegsById.containsKey(transItem.id));
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
