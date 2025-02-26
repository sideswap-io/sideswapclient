import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_history_orders_row.dart';
import 'package:sideswap/desktop/widgets/d_tx_blinded_url_icon_button.dart';
import 'package:sideswap/models/ui_history_order.dart';

class DWorkingHistoryOrderItem extends ConsumerWidget {
  const DWorkingHistoryOrderItem({required this.historyOrder, super.key});

  final UiHistoryOrder historyOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DWorkingHistoryOrdersRow(
      children: [
        Text(historyOrder.date),
        Text(historyOrder.tradeDirDescription),
        Row(
          children: [
            historyOrder.sentIcon,
            SizedBox(width: 4),
            Text(historyOrder.sentAmountString),
          ],
        ),
        Row(
          children: [
            historyOrder.receivedIcon,
            SizedBox(width: 4),
            Text(historyOrder.receivedAmountString),
          ],
        ),
        Tooltip(
          message: historyOrder.statusDescription,
          child: Text(historyOrder.status),
        ),
        switch (historyOrder.txId.isNotEmpty) {
          true => DTxBlindedUrlIconButton(
            txid: historyOrder.txId,
            isLiquid: true,
            unblinded: false,
          ),
          false => SizedBox(),
        },
      ],
    );
  }
}
