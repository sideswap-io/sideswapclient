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
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DUnconfirmedTx extends StatelessWidget {
  const DUnconfirmedTx({super.key});

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SizedBox(
            height: 43,
            child: DefaultTextStyle(
              style: const TextStyle().merge(
                Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: SideSwapColors.glacier),
              ),
              child: DTxHistoryRow(
                flexes: const [183, 97, 137, 205, 205, 125, 26],
                children: [
                  DTxHistoryHeader(text: 'Date'.tr()),
                  DTxHistoryHeader(text: 'Wallet'.tr()),
                  DTxHistoryHeader(text: 'Type'.tr()),
                  DTxHistoryHeader(text: 'Sent'.tr()),
                  DTxHistoryHeader(text: 'Received'.tr()),
                  DTxHistoryHeader(text: 'Confirmations'.tr()),
                  DTxHistoryHeader(text: 'Link'.tr()),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Divider(
            height: 1,
            thickness: 0,
            color: SideSwapColors.jellyBean,
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final allNewTxSorted = ref.watch(allNewTxsSortedProvider);
            final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
            final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);

            final txList = allNewTxSorted;

            return switch (txList.isEmpty) {
              true => Padding(
                  padding: const EdgeInsets.only(top: 63),
                  child: Text(
                    'No unconfirmed transactions'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: SideSwapColors.glacier),
                  ),
                ),
              false => Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CustomScrollView(
                      slivers: [
                        SliverList.builder(
                          itemBuilder: (context, index) {
                            final tx = txList[index];
                            final type =
                                tx.hasPeg() ? TxType.unknown : txType(tx.tx);
                            final sentBalance = getSentBalance(
                                tx, type, liquidAssetId, bitcoinAssetId);
                            final recvBalance = getRecvBalance(
                                tx, type, liquidAssetId, bitcoinAssetId);
                            final recvMultipleOutputs =
                                getRecvMultipleOutputs(tx);
                            return DTransparentButton(
                              onPressed: () {
                                final allPegsById =
                                    ref.read(allPegsByIdProvider);
                                ref.read(desktopDialogProvider).showTx(tx.id,
                                    isPeg: allPegsById.containsKey(tx.id));
                              },
                              child: DTxHistoryRow(
                                flexes: const [183, 97, 137, 205, 205, 125, 26],
                                children: [
                                  DTxHistoryDate(
                                    dateFormatDate: dateFormatDate,
                                    dateFormatTime: dateFormatTime,
                                    tx: tx,
                                    dateTextStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    timeTextStyle: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color:
                                              SideSwapColors.airSuperiorityBlue,
                                        ),
                                  ),
                                  DTxHistoryWallet(
                                    tx: tx,
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  DTxHistoryType(
                                    tx: tx,
                                    txType: type,
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  DTxHistoryAmount(
                                    balance: sentBalance,
                                    multipleOutputs: false,
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  DTxHistoryAmount(
                                    balance: recvBalance,
                                    multipleOutputs: recvMultipleOutputs,
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  DTxHistoryConfs(
                                    tx: tx,
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  DTxHistoryLink(txid: tx.tx.txid),
                                ],
                              ),
                            );
                          },
                          itemCount: txList.length,
                        ),
                      ],
                    ),
                  ),
                ),
            };
          },
        ),
      ],
    );
  }
}
