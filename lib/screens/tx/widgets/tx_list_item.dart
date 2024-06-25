import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/tx/widgets/tx_item_date.dart';
import 'package:sideswap/screens/tx/widgets/tx_item_transaction.dart';

class TxListItem extends HookConsumerWidget {
  const TxListItem({
    super.key,
    required this.txItem,
  });

  final TxItem txItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        txItem.showDate
            ? Column(
                children: [
                  TxItemDate(
                    createdAt: txItem.createdAt,
                  ),
                  const SizedBox(height: 8),
                ],
              )
            : Container(),
        TextButton(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsets.zero),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            backgroundColor:
                const WidgetStatePropertyAll(SideSwapColors.blueSapphire),
          ),
          onPressed: () {
            ref.read(walletProvider).showTxDetails(txItem.item);
          },
          child: TxItemTransaction(
            transItem: txItem.item,
            accountType: selectedAccountType,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
