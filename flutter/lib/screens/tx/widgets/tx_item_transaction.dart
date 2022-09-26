import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';

class TxItemTransaction extends StatelessWidget {
  const TxItemTransaction({
    super.key,
    required this.transItem,
    required this.assetId,
    required this.accountType,
  });

  final TransItem transItem;
  final String assetId;
  final AccountType accountType;
  static const double itemHeight = 46.0;

  @override
  Widget build(BuildContext context) {
    final type = txType(transItem.tx);
    final txCircleImageType = txTypeToImageType(type: type);
    final status = txItemToStatus(transItem);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: itemHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TxCircleImage(txCircleImageType: txCircleImageType),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            txTypeName(type),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          Consumer(
                            builder: ((context, ref, _) {
                              final asset = ref
                                  .watch(walletProvider)
                                  .getAssetById(assetId);
                              final amount =
                                  txAssetAmount(transItem.tx, assetId);
                              final ticker = asset?.ticker;
                              final precision = ref
                                  .watch(walletProvider)
                                  .getPrecisionForAssetId(assetId: assetId);
                              final balanceStr =
                                  '${amountStr(amount, forceSign: true, precision: precision)} $ticker';
                              final balanceColor = balanceStr.contains('+')
                                  ? const Color(0xFFB3FF85)
                                  : Colors.white;

                              return Text(
                                balanceStr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: balanceColor,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TODO: Fix that when Joe Doe will be available
                            /*
                            Text(
                              'Joe Doe (fixme)',
                              style: const TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF709EBA),
                              ),
                            ),
                            Spacer(),
                            */
                            Text(
                              status,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF709EBA),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
