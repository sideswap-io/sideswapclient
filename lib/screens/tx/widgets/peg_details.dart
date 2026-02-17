import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/peg_out_edit_fee_rate_dialog.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/screens/tx/share_external_explorer_dialog.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_bottom_buttons.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';

class PegDetails extends ConsumerWidget {
  const PegDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionTransItem = ref.watch(pegDetailsTransItemProvider);

    return optionTransItem.match(() => const SizedBox.shrink(), (transItem) {
      final amountProvider = ref.watch(amountToStringProvider);
      final transItemHelper = ref.watch(transItemHelperProvider(transItem));

      final amountSendStr = amountProvider.amountToString(
        AmountToStringParameters(amount: transItem.peg.amountSend.toInt()),
      );
      final amountSend = double.tryParse(amountSendStr) ?? 0;
      final amountRecvStr = amountProvider.amountToString(
        AmountToStringParameters(amount: transItem.peg.amountRecv.toInt()),
      );
      final amountRecv = double.tryParse(amountRecvStr) ?? 0;
      var conversionReceived = .0;
      if (amountSend != 0 && amountRecv != 0) {
        conversionReceived = amountRecv * 100 / amountSend;
      }
      final isPegIn = transItem.peg.isPegIn;
      final sendTicker = isPegIn ? kBitcoinTicker : kLiquidBitcoinTicker;
      final recvTicker = isPegIn ? kLiquidBitcoinTicker : kBitcoinTicker;
      final conversionRate =
          '1 $sendTicker = ${conversionReceived.toStringAsFixed(2)}% $recvTicker';

      final pegOutNextBlockFeeRate = ref.watch(pegOutNextBlockFeeRateProvider);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TxCircleImage(
                txCircleImageType: isPegIn
                    ? TxCircleImageType.pegIn
                    : TxCircleImageType.pegOut,
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
          const SizedBox(height: 12),
          Text(
            transItemHelper.txDateTimeStr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          Consumer(
            builder: (context, ref, child) {
              final details = amountProvider.amountToStringNamed(
                AmountToStringNamedParameters(
                  amount: transItem.peg.amountSend.toInt(),
                  ticker: sendTicker,
                ),
              );
              return TxDetailsRow(
                description: isPegIn
                    ? 'BTC Peg-in amount'.tr()
                    : 'L-BTC Peg-out amount'.tr(),
                details: details,
              );
            },
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              final details = amountProvider.amountToStringNamed(
                AmountToStringNamedParameters(
                  amount: transItem.peg.amountRecv.toInt(),
                  ticker: recvTicker,
                ),
              );
              return TxDetailsRow(
                description: isPegIn
                    ? 'L-BTC received'.tr()
                    : 'BTC received'.tr(),
                details: isPegIn ? details : '$details - txFee',
              );
            },
          ),
          const SizedBox(height: 12),
          TxDetailsRow(
            description: 'Conversion rate'.tr(),
            details: conversionRate,
          ),
          const SizedBox(height: 12),
          PegDetailsSelectedFeeRate(),
          const SizedBox(height: 12),
          TxDetailsRow(
            description: 'Next block fee rate',
            details: pegOutNextBlockFeeRate,
          ),
          const SizedBox(height: 12),
          PegDetailsBitcoinNetworkFee(),
          const SizedBox(height: 12),
          TxDetailsRow(
            description: 'Status'.tr(),
            details: transItemHelper.txStatus().status,
            detailsColor: transItem.confs.count != 0
                ? SideSwapColors.airSuperiorityBlue
                : Colors.white,
          ),
          const SizedBox(height: 12),
          DottedLine(dashColor: Colors.white, dashGapColor: Colors.transparent),
          const SizedBox(height: 12),
          TxDetailsColumn(
            description: isPegIn
                ? 'BTC Peg-in address'.tr()
                : 'L-BTC delivery address'.tr(),
            details: transItem.peg.addrSend,
          ),
          const SizedBox(height: 12),
          TxDetailsColumn(
            description: isPegIn
                ? 'L-BTC receiving address'.tr()
                : 'BTC receiving address'.tr(),
            details: transItem.peg.addrRecv,
          ),
          const SizedBox(height: 12),
          TxDetailsColumn(
            description: 'Transaction ID'.tr(),
            details: transItem.peg.txidSend,
            isCopyVisible: true,
          ),
          const Spacer(),
          TxDetailsBottomButtons(
            id: transItem.peg.txidRecv,
            isLiquid: isPegIn,
            blindType: BlindType.unblinded,
            enabled: transItem.peg.hasTxidRecv(),
          ),
          const SizedBox(height: 40),
        ],
      );
    });
  }
}

class PegDetailsSelectedFeeRate extends ConsumerWidget {
  const PegDetailsSelectedFeeRate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionTransItem = ref.watch(pegDetailsTransItemProvider);

    return optionTransItem.match(() => const SizedBox.shrink(), (transItem) {
      final transItemHelper = ref.watch(transItemHelperProvider(transItem));

      final optionSelectedFeeRate = transItemHelper.selectedFeeRate();
      final availableForEdit = ref.watch(
        availablePegOrderFeeChangeProvider(transItem),
      );

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Selected fee rate',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          const Spacer(),
          Text(
            optionSelectedFeeRate.match(
              () => 'N/A',
              (value) => '$value sat/vbyte',
            ),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          ...switch (availableForEdit) {
            true => [
              SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  ref
                      .read(pegOutEditFeeRateDialogTransItemProvider.notifier)
                      .setState(transItem);

                  await Navigator.of(context).push(
                    RawDialogRoute<Widget>(
                      pageBuilder: (_, _, _) => PegOutEditFeeRateDialog(),
                    ),
                  );
                },
                icon: Icon(Icons.edit, color: Colors.white, size: 24),
              ),
            ],
            false => [const SizedBox.shrink()],
          },
        ],
      );
    });
  }
}

class PegDetailsBitcoinNetworkFee extends ConsumerWidget {
  const PegDetailsBitcoinNetworkFee({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionTransItem = ref.watch(pegDetailsTransItemProvider);

    return optionTransItem.match(() => const SizedBox.shrink(), (transItem) {
      final transItemHelper = ref.watch(transItemHelperProvider(transItem));
      final optionBitcoinNetworkFee = transItemHelper.bitcoinNetworkFee();

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bitcoin network fee',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          Text(
            optionBitcoinNetworkFee.match(
              () => 'N/A',
              (value) => '$value sats',
            ),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      );
    });
  }
}
