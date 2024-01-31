import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/screens/tx/share_external_explorer_dialog.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_bottom_buttons.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class PegDetails extends ConsumerStatefulWidget {
  const PegDetails({
    super.key,
    required this.transItem,
  });

  final TransItem transItem;

  @override
  TxDetailsPegState createState() => TxDetailsPegState();
}

class TxDetailsPegState extends ConsumerState<PegDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final amountProvider = ref.watch(amountToStringProvider);
    final transItemHelper =
        ref.watch(transItemHelperProvider(widget.transItem));

    final amountSendStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: widget.transItem.peg.amountSend.toInt()));
    final amountSend = double.tryParse(amountSendStr) ?? 0;
    final amountRecvStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: widget.transItem.peg.amountRecv.toInt()));
    final amountRecv = double.tryParse(amountRecvStr) ?? 0;
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
              width: 24,
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                isPegIn ? 'Peg-In'.tr() : 'Peg-Out'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 11),
          child: Text(
            transItemHelper.txDateTimeStr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: SizedBox(),
        ),
        Consumer(builder: (context, ref, child) {
          final details = amountProvider.amountToStringNamed(
              AmountToStringNamedParameters(
                  amount: widget.transItem.peg.amountSend.toInt(),
                  ticker: sendTicker));
          return TxDetailsRow(
            description: isPegIn
                ? 'BTC Peg-in amount'.tr()
                : 'L-BTC Peg-out amount'.tr(),
            details: details,
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Consumer(
            builder: (context, ref, child) {
              final details = amountProvider.amountToStringNamed(
                  AmountToStringNamedParameters(
                      amount: widget.transItem.peg.amountRecv.toInt(),
                      ticker: recvTicker));
              return TxDetailsRow(
                description:
                    isPegIn ? 'L-BTC received'.tr() : 'BTC received'.tr(),
                details: isPegIn ? details : '$details - txFee',
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TxDetailsRow(
            description: 'Conversion rate'.tr(),
            details: conversionRate,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TxDetailsRow(
            description: 'Status'.tr(),
            details: transItemHelper.txStatus(),
            detailsColor: widget.transItem.confs.count != 0
                ? SideSwapColors.airSuperiorityBlue
                : Colors.white,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12.5),
          child: DottedLine(
            dashColor: Colors.white,
            dashGapColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.5),
          child: TxDetailsColumn(
            description: isPegIn
                ? 'BTC Peg-in address'.tr()
                : 'L-BTC delivery address'.tr(),
            details: widget.transItem.peg.addrSend,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TxDetailsColumn(
            description: isPegIn
                ? 'L-BTC receiving address'.tr()
                : 'BTC receiving address'.tr(),
            details: widget.transItem.peg.addrRecv,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TxDetailsColumn(
            description: 'Transaction ID'.tr(),
            details: widget.transItem.peg.txidSend,
            isCopyVisible: true,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
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
