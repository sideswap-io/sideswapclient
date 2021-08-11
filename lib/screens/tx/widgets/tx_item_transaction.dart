import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';

class TxItemTransaction extends StatelessWidget {
  const TxItemTransaction({
    Key? key,
    required this.transItem,
    required this.assetId,
  }) : super(key: key);

  final TransItem transItem;
  final String assetId;
  static final double itemHeight = 46.h;

  @override
  Widget build(BuildContext context) {
    final wallet = context.read(walletProvider);
    final asset = wallet.getAssetById(assetId);
    final amount = txAssetAmount(transItem.tx, assetId);
    final ticker = asset?.ticker;
    final precision =
        context.read(walletProvider).getPrecisionForAssetId(assetId: assetId);
    final balanceStr =
        '${amountStr(amount, forceSign: true, precision: precision)} $ticker';
    final balanceColor =
        balanceStr.contains('+') ? const Color(0xFFB3FF85) : Colors.white;
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
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            txTypeName(type),
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            balanceStr,
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                              color: balanceColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TODO: Fix that when Joe Doe will be available
                            /*
                            Text(
                              'Joe Doe (fixme)',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF709EBA),
                              ),
                            ),
                            Spacer(),
                            */
                            Text(
                              status,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF709EBA),
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
