import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/swap_summary.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_peg.dart';

class TxDetailsPopup extends ConsumerWidget {
  const TxDetailsPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItem = ref.watch(walletProvider.select((p) => p.txDetails));
    final liquidAssetId = ref.watch(walletProvider).liquidAssetId();
    final asset = ref.watch(walletProvider
        .select((p) => p.selectedWalletAsset?.asset ?? liquidAssetId));
    final ticker = ref.watch(walletProvider).getAssetById(asset)?.ticker ??
        kLiquidBitcoinTicker;

    return SideSwapPopup(
      child: Builder(
        builder: (context) {
          if (transItem.whichItem() == TransItem_Item.tx) {
            final type = txType(transItem.tx);
            final txCircleImageType = txTypeToImageType(type: type);
            final timestampStr = txDateStrLong(
                DateTime.fromMillisecondsSinceEpoch(
                    transItem.createdAt.toInt()));

            final status = txItemToStatus(transItem);
            var delivered = '';
            var received = '';
            var targetPrice = '';
            var networkFee = 0;

            if (type == TxType.swap) {
              final balanceDelivered =
                  transItem.tx.balances.firstWhere((e) => e.amount < 0);
              final balanceReceived =
                  transItem.tx.balances.firstWhere((e) => e.amount >= 0);
              final assetSent = ref
                  .watch(walletProvider)
                  .getAssetById(balanceDelivered.assetId);
              final assetRecv = ref
                  .watch(walletProvider)
                  .getAssetById(balanceReceived.assetId);
              final deliveredPrecision = assetSent?.precision ?? 8;
              final receivedPrecision = assetRecv?.precision ?? 8;
              delivered = amountStr(balanceDelivered.amount.toInt().abs(),
                  precision: deliveredPrecision);
              final sentBitcoin = balanceDelivered.assetId == liquidAssetId;
              final asset = sentBitcoin ? assetRecv : assetSent;

              final assetSentTicker = assetSent?.ticker ?? kUnknownTicker;
              final assetRecvTicker = assetRecv?.ticker ?? kUnknownTicker;
              delivered = replaceCharacterOnPosition(
                input: delivered,
                currencyChar: assetSentTicker,
                currencyCharAlignment: CurrencyCharAlignment.end,
              );
              received = amountStr(balanceReceived.amount.toInt(),
                  precision: receivedPrecision);
              received = replaceCharacterOnPosition(
                input: received,
                currencyChar: assetRecvTicker,
                currencyCharAlignment: CurrencyCharAlignment.end,
              );

              final pricedInLiquid = !(asset?.swapMarket ?? false);
              final pricePrecision = pricedInLiquid ? 8 : 2;
              final assetPrecision = asset?.precision ?? 8;
              final bitcoinAmountFull = (sentBitcoin
                      ? balanceDelivered.amount
                      : balanceReceived.amount)
                  .toInt()
                  .abs();
              final assetAmount = (sentBitcoin
                      ? balanceReceived.amount
                      : balanceDelivered.amount)
                  .toInt()
                  .abs();
              networkFee = transItem.tx.networkFee.toInt().abs();
              final bitcoinAmountAjusted = sentBitcoin
                  ? bitcoinAmountFull - networkFee
                  : bitcoinAmountFull + networkFee;
              final priceOrig =
                  toFloat(assetAmount, precision: assetPrecision) /
                      toFloat(bitcoinAmountAjusted);
              final price = pricedInLiquid ? (1 / priceOrig) : priceOrig;
              final assetTicker =
                  sentBitcoin ? assetRecvTicker : assetSentTicker;
              targetPrice = price.toStringAsFixed(pricePrecision);
              targetPrice = replaceCharacterOnPosition(
                input: targetPrice,
                currencyChar:
                    pricedInLiquid ? kLiquidBitcoinTicker : assetTicker,
                currencyCharAlignment: CurrencyCharAlignment.end,
              );
              targetPrice = pricedInLiquid
                  ? '1 $assetTicker = $targetPrice'
                  : '1 $kLiquidBitcoinTicker = $targetPrice';
            }

            final balances = transItem.tx.balances;
            networkFee = transItem.tx.networkFee.toInt();
            final confs = transItem.confs;
            final tx = transItem.tx;

            return SwapSummary(
              ticker: ticker,
              delivered: delivered,
              received: received,
              price: targetPrice,
              type: type,
              txCircleImageType: txCircleImageType,
              timestampStr: timestampStr,
              status: status,
              balances: balances,
              networkFee: networkFee,
              confs: confs,
              tx: tx,
              txId: tx.txid,
            );
          }

          return TxDetailsPeg(
            transItem: transItem,
          );
        },
      ),
    );
  }
}
