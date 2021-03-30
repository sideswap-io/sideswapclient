import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_bottom_buttons.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row_notes.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class SwapSummary extends StatelessWidget {
  SwapSummary({
    Key key,
    this.ticker,
    this.delivered,
    this.received,
    this.price,
    this.type,
    this.txCircleImageType,
    this.timestampStr,
    this.status,
    this.balances,
    this.networkFee,
    this.confs,
    this.tx,
    this.txId,
  }) : super(key: key);

  final String ticker;
  final String delivered;
  final String received;
  final String price;
  final TxType type;
  final TxCircleImageType txCircleImageType;
  final String timestampStr;
  final String status;
  final List<Balance> balances;
  final int networkFee;
  final Confs confs;
  final Tx tx;
  final String txId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TxCircleImage(
              txCircleImageType: txCircleImageType,
              width: 24.w,
              height: 24.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                txTypeName(type),
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 11.h),
          child: Text(
            timestampStr,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: SizedBox(),
        ),
        if (type == TxType.swap) ...[
          TxDetailsRow(
            description: 'Delivered'.tr(),
            details: delivered,
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: TxDetailsRow(
              description: 'Received'.tr(),
              details: received,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: TxDetailsRow(
              description: 'Price'.tr(),
              details: price,
            ),
          ),
        ] else ...[
          ...List<Widget>.generate(balances.length, (index) {
            final balance = balances[index];
            final asset = context.read(walletProvider).assets[balance.assetId];
            final ticker = asset != null ? asset.ticker : kUnknownTicker;
            final balanceStr = amountStr(balance.amount.toInt());
            return TxDetailsRow(
              description: 'Amount'.tr(),
              details: '$balanceStr $ticker',
            );
          }),
          if (type == TxType.sent) ...[
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: TxDetailsRow(
                description: 'Network Fee'.tr(),
                details: amountStrNamed(
                  networkFee == 0 ? networkFee : -networkFee,
                  kLiquidBitcoinTicker,
                  forceSign: networkFee == 0 ? false : true,
                ),
              ),
            ),
          ],
        ],
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: TxDetailsRow(
            description: 'Status'.tr(),
            details: status ?? '',
            detailsColor: (confs != null && confs?.count != 0)
                ? Color(0xFF709EBA)
                : Colors.white,
          ),
        ),
        if (tx != null && type != TxType.swap) ...[
          // notes
          Padding(
            padding: EdgeInsets.only(top: 20.5.h),
            child: TxDetailsRowNotes(
              tx: tx,
            ),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(top: 20.5.h),
          child: FDottedLine(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: TxDetailsColumn(
            description: 'Transaction ID'.tr(),
            details: txId,
            isCopyVisible: true,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 40.h),
          child: TxDetailsBottomButtons(
            id: txId,
            isLiquid: true,
          ),
        ),
      ],
    );
  }
}
