import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/tx/widgets/tx_item_date.dart';
import 'package:sideswap/screens/tx/widgets/tx_item_peg.dart';
import 'package:sideswap/screens/tx/widgets/tx_item_transaction.dart';

class TxListItem extends StatelessWidget {
  final String assetId;
  final AccountType accountType;
  final TxItem txItem;
  const TxListItem({
    super.key,
    required this.assetId,
    required this.accountType,
    required this.txItem,
  });

  static const itemHeight = 50.0;
  static const itemWithDateHeight = 95.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: txItem.showDate ? itemWithDateHeight : itemHeight,
        child: Column(
          children: [
            txItem.showDate
                ? TxItemDate(
                    createdAt: txItem.createdAt,
                  )
                : Container(),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Consumer(
                  builder: (context, ref, _) {
                    return InkWell(
                      onTap: () {
                        ref.read(walletProvider).showTxDetails(txItem.item);
                      },
                      child: txItem.item.whichItem() == TransItem_Item.tx
                          ? TxItemTransaction(
                              assetId: assetId,
                              transItem: txItem.item,
                              accountType: accountType,
                            )
                          : TxItemPeg(
                              assetId: assetId,
                              transItem: txItem.item,
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
