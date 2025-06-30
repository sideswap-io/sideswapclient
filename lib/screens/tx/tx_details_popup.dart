import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/tx_details.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/tx/widgets/peg_details.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TxDetailsPopup extends ConsumerWidget {
  const TxDetailsPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionCurrentTxid = ref.watch(currentTxPopupItemNotifierProvider);

    return SideSwapPopup(
      onClose: () {
        ref.invalidate(marketQuoteNotifierProvider);
        ref.invalidate(acceptQuoteNotifierProvider);
        ref.read(walletProvider).goBack();
      },
      child: optionCurrentTxid.match(() => const SizedBox(), (txid) {
        final allTxs = ref.watch(allTxsNotifierProvider);

        final transItem = allTxs[txid];

        if (transItem == null) {
          return const SizedBox();
        }

        return switch (transItem.whichItem()) {
          TransItem_Item.tx => TxDetails(),
          TransItem_Item.peg => PegDetails(),
          TransItem_Item.notSet => const SizedBox(),
        };
      }),
    );
  }
}
