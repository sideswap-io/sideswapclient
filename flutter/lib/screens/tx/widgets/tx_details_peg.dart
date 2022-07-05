import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/tx/share_external_explorer_dialog.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_bottom_buttons.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';

class TxDetailsPeg extends StatefulWidget {
  const TxDetailsPeg({
    super.key,
    required this.transItem,
  });

  final TransItem transItem;

  @override
  TxDetailsPegState createState() => TxDetailsPegState();
}

class TxDetailsPegState extends State<TxDetailsPeg> {
  late String _timestampStr;
  late String _status;

  @override
  void initState() {
    super.initState();
    _timestampStr = txDateStrLong(DateTime.fromMillisecondsSinceEpoch(
        widget.transItem.createdAt.toInt()));
    _status = txItemToStatus(widget.transItem, isPeg: true);
  }

  @override
  Widget build(BuildContext context) {
    _status = txItemToStatus(widget.transItem, isPeg: true);
    final amountSend =
        double.tryParse(amountStr(widget.transItem.peg.amountSend.toInt())) ??
            0;
    final amountRecv =
        double.tryParse(amountStr(widget.transItem.peg.amountRecv.toInt())) ??
            0;
    var conversionReceived = .0;
    if (amountSend != 0 && amountRecv != 0) {
      conversionReceived = amountRecv * 100 / amountSend;
    }
    final isPegIn = widget.transItem.peg.isPegIn;
    final sendTicker = isPegIn ? kBitcoinTicker : kLiquidBitcoinTicker;
    final recvTicker = isPegIn ? kLiquidBitcoinTicker : kBitcoinTicker;
    final conversionRate =
        '1 $sendTicker = ${conversionReceived.toStringAsFixed(2)}% $recvTicker';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TxCircleImage(
              txCircleImageType:
                  isPegIn ? TxCircleImageType.pegIn : TxCircleImageType.pegOut,
              width: 24.w,
              height: 24.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                isPegIn ? 'Peg-In'.tr() : 'Peg-Out'.tr(),
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
            _timestampStr,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: const SizedBox(),
        ),
        TxDetailsRow(
          description:
              isPegIn ? 'BTC Peg-in amount'.tr() : 'L-BTC Peg-out amount'.tr(),
          details: amountStrNamed(
            widget.transItem.peg.amountSend.toInt(),
            sendTicker,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: TxDetailsRow(
            description: isPegIn ? 'L-BTC received'.tr() : 'BTC received'.tr(),
            details: amountStrNamed(
                  widget.transItem.peg.amountRecv.toInt(),
                  recvTicker,
                ) +
                (isPegIn ? '' : ' - txFee'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: TxDetailsRow(
            description: 'Conversion rate'.tr(),
            details: conversionRate,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: TxDetailsRow(
            description: 'Status'.tr(),
            details: _status,
            detailsColor: widget.transItem.confs.count != 0
                ? const Color(0xFF709EBA)
                : Colors.white,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.5.h),
          child: const DottedLine(
            dashColor: Colors.white,
            dashGapColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.5.h),
          child: TxDetailsColumn(
            description: isPegIn
                ? 'BTC Peg-in address'.tr()
                : 'L-BTC delivery address'.tr(),
            details: widget.transItem.peg.addrSend,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: TxDetailsColumn(
            description: isPegIn
                ? 'L-BTC receiving address'.tr()
                : 'BTC receiving address'.tr(),
            details: widget.transItem.peg.addrRecv,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: TxDetailsColumn(
            description: 'Transaction ID'.tr(),
            details: widget.transItem.peg.txidSend,
            isCopyVisible: true,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 40.h),
          child: TxDetailsBottomButtons(
            id: widget.transItem.peg.txidRecv,
            isLiquid: isPegIn,
            blindType: BlindType.unblinded,
            enabled: widget.transItem.peg.hasTxidRecv(),
          ),
        ),
      ],
    );
  }
}
