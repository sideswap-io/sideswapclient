import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/tx_details.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/tx/widgets/peg_details.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TxDetailsPopup extends ConsumerWidget {
  const TxDetailsPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItem = ref.watch(walletProvider.select((p) => p.txDetails));

    return SideSwapPopup(
      onClose: () {
        ref.invalidate(marketQuoteNotifierProvider);
        ref.invalidate(acceptQuoteNotifierProvider);
        ref.read(walletProvider).goBack();
      },
      child: Builder(
        builder: (context) {
          if (transItem.whichItem() == TransItem_Item.tx) {
            return TxDetails(transItem: transItem);
          }

          return PegDetails(transItem: transItem);
        },
      ),
    );
  }
}
