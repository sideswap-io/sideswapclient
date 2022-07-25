import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_bottom_buttons.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row_notes.dart';

class SwapSummary extends ConsumerWidget {
  const SwapSummary({
    super.key,
    required this.ticker,
    required this.delivered,
    required this.received,
    required this.price,
    required this.type,
    required this.txCircleImageType,
    required this.timestampStr,
    required this.status,
    required this.balances,
    required this.networkFee,
    required this.confs,
    required this.tx,
    required this.txId,
  });

  final String ticker;
  final String delivered;
  final String received;
  final String price;
  final TxType type;
  final TxCircleImageType txCircleImageType;
  final String timestampStr;
  final String status;
  final List<TxBalance> balances;
  final int networkFee;
  final Confs confs;
  final Tx tx;
  final String txId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TxCircleImage(
              txCircleImageType: txCircleImageType,
              width: 24,
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                txTypeName(type),
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
            timestampStr,
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
        if (type == TxType.swap) ...[
          TxDetailsRow(
            description: 'Delivered'.tr(),
            details: delivered,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TxDetailsRow(
              description: 'Received'.tr(),
              details: received,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TxDetailsRow(
              description: 'Price'.tr(),
              details: price,
            ),
          ),
        ] else ...[
          ...List<Widget>.generate(balances.length, (index) {
            final balance = balances[index];
            final asset = ref.read(walletProvider).assets[balance.assetId];
            final ticker = asset != null ? asset.ticker : kUnknownTicker;
            final balanceStr = amountStr(balance.amount.toInt(),
                precision: asset?.precision ?? 8);
            return TxDetailsRow(
              description: 'Amount'.tr(),
              details: '$balanceStr $ticker',
            );
          }),
          if (type == TxType.sent) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12),
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
          padding: const EdgeInsets.only(top: 12),
          child: TxDetailsRow(
            description: 'Status'.tr(),
            details: status,
            detailsColor:
                (confs.count != 0) ? const Color(0xFF709EBA) : Colors.white,
          ),
        ),
        if (type != TxType.swap) ...[
          // notes
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TxDetailsRowNotes(
              tx: tx,
            ),
          ),
        ],
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: DottedLine(
            dashColor: Colors.white,
            dashGapColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TxDetailsColumn(
            description: 'Transaction ID'.tr(),
            details: txId,
            isCopyVisible: true,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: double.maxFinite,
            height: 54,
            child: TxDetailsBottomButtons(
              id: txId,
              isLiquid: true,
            ),
          ),
        ),
      ],
    );
  }
}
