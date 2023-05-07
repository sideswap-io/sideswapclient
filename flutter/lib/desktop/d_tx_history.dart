import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_amount.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_confs.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_date.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_header.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_link.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_row.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_type.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/balances.dart';

class DTxHistory extends StatelessWidget {
  const DTxHistory({
    Key? key,
    this.horizontalPadding = 32,
    this.newTxsOnly = false,
  }) : super(key: key);

  final double horizontalPadding;
  final bool newTxsOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
          child: DTxHistoryRow(list: [
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
    Key? key,
    required this.newTxsOnly,
    required this.horizontalPadding,
  }) : super(key: key);

  final double horizontalPadding;
  final bool newTxsOnly;

  static DateFormat dateFormatDate = DateFormat('y-MM-dd ');
  static DateFormat dateFormatTime = DateFormat('HH:mm:ss');

  Balance getSentBalance(
      TransItem tx, TxType txType, String liquidBitcoin, String bitcoin) {
    if (tx.hasPeg()) {
      return Balance(
          amount: tx.peg.amountSend,
          assetId: tx.peg.isPegIn ? bitcoin : liquidBitcoin);
    }

    switch (txType) {
      case TxType.sent:
        final balance = tx.tx.balances.length == 1
            ? tx.tx.balances.first
            : tx.tx.balances.firstWhere((e) => e.assetId != liquidBitcoin);
        final amount = balance.assetId == liquidBitcoin
            ? -balance.amount - tx.tx.networkFee
            : -balance.amount;
        return Balance(amount: amount, assetId: balance.assetId);
      case TxType.swap:
        final balance = tx.tx.balances.firstWhere((e) => e.amount < 0);
        return Balance(amount: -balance.amount, assetId: balance.assetId);
      case TxType.received:
      case TxType.internal:
      case TxType.unknown:
        return Balance();
    }
  }

  Balance getRecvBalance(
      TransItem tx, TxType txType, String liquidBitcoin, String bitcoin) {
    if (tx.hasPeg()) {
      return Balance(
          amount: tx.peg.amountRecv,
          assetId: tx.peg.isPegIn ? liquidBitcoin : bitcoin);
    }

    switch (txType) {
      case TxType.received:
      case TxType.swap:
        final balance = tx.tx.balances.firstWhere((e) => e.amount > 0);
        return Balance(amount: balance.amount, assetId: balance.assetId);
      case TxType.sent:
      case TxType.internal:
      case TxType.unknown:
        return Balance();
    }
  }

  bool getRecvMultipleOutputs(TransItem tx) {
    return tx.tx.balances.where((e) => e.amount > 0).length > 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liquidAssetId = ref.watch(liquidAssetIdProvider);
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
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        final tx = txList[index];
        final type = tx.hasPeg() ? TxType.unknown : txType(tx.tx);
        final sentBalance =
            getSentBalance(tx, type, liquidAssetId, bitcoinAssetId);
        final recvBalance =
            getRecvBalance(tx, type, liquidAssetId, bitcoinAssetId);
        final recvMultipleOutputs = getRecvMultipleOutputs(tx);

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
                  list: [
                    DTxHistoryDate(
                        dateFormatDate: dateFormatDate,
                        dateFormatTime: dateFormatTime,
                        tx: tx),
                    DTxHistoryWallet(tx: tx),
                    DTxHistoryType(tx: tx, txType: type),
                    DTxHistoryAmount(
                      balance: sentBalance,
                      multipleOutputs: false,
                    ),
                    DTxHistoryAmount(
                      balance: recvBalance,
                      multipleOutputs: recvMultipleOutputs,
                    ),
                    DTxHistoryConfs(tx: tx),
                    DTxHistoryLink(txid: tx.tx.txid),
                  ],
                ),
                onPressed: () {
                  final allPegsById = ref.read(allPegsByIdProvider);
                  desktopShowTx(context, tx.id,
                      isPeg: allPegsById.containsKey(tx.id));
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
