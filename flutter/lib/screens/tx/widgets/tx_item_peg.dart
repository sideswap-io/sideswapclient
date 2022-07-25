import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';

class TxItemPeg extends StatelessWidget {
  const TxItemPeg({
    super.key,
    required this.transItem,
    required this.assetId,
  });

  final TransItem transItem;
  final String assetId;

  static const double itemHeight = 46.0;

  @override
  Widget build(BuildContext context) {
    final status = txItemToStatus(transItem, isPeg: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: itemHeight,
          child: Row(
            children: [
              TxCircleImage(
                txCircleImageType: transItem.peg.isPegIn
                    ? TxCircleImageType.pegIn
                    : TxCircleImageType.pegOut,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  transItem.peg.isPegIn ? 'Peg-In'.tr() : 'Peg-Out'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, _) {
                    final asset =
                        ref.watch(walletProvider).getAssetById(assetId);
                    final payout = amountStrNamed(
                        transItem.peg.amountRecv.toInt(), asset?.ticker ?? '');

                    return Text(
                      payout,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFB3FF85),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF709EBA),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
