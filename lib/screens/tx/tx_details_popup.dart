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
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _transItem = watch(walletProvider).txDetails;
    final wallet = watch(walletProvider);
    final _ticker = wallet.getAssetById(wallet.selectedWalletAsset)?.ticker ??
        kLiquidBitcoinTicker;

    return SideSwapPopup(
      child: Builder(
        builder: (context) {
          if (_transItem.whichItem() == TransItem_Item.tx) {
            final _type = txType(_transItem.tx);
            final _txCircleImageType = txTypeToImageType(type: _type);
            final _timestampStr = txDateStrLong(
                DateTime.fromMillisecondsSinceEpoch(
                    _transItem.createdAt.toInt()));

            final _status = txItemToStatus(_transItem);
            var _delivered = '';
            var _received = '';
            var _price = '';

            if (_type == TxType.swap) {
              final _balanceDelivered =
                  _transItem.tx.balances.firstWhere((e) => e.amount < 0);
              final _balanceReceived =
                  _transItem.tx.balances.firstWhere((e) => e.amount >= 0);
              final _deliveredPrecision = context
                  .read(walletProvider)
                  .getPrecisionForAssetId(assetId: _balanceDelivered.assetId);
              _delivered =
                  '${amountStr(_balanceDelivered.amount.toInt().abs(), precision: _deliveredPrecision)}';

              final _assetSentTicker =
                  wallet.getAssetById(_balanceDelivered.assetId)?.ticker ??
                      kUnknownTicker;
              final _assetRecvTicker =
                  wallet.getAssetById(_balanceReceived.assetId)?.ticker ??
                      kUnknownTicker;
              _delivered = replaceCharacterOnPosition(
                input: _delivered,
                currencyChar: _assetSentTicker,
                currencyCharAlignment: CurrencyCharAlignment.end,
              );
              final _receivedPrecision = context
                  .read(walletProvider)
                  .getPrecisionForAssetId(assetId: _balanceReceived.assetId);
              _received =
                  '${amountStr(_balanceReceived.amount.toInt(), precision: _receivedPrecision)}';
              _received = replaceCharacterOnPosition(
                input: _received,
                currencyChar: _assetRecvTicker,
                currencyCharAlignment: CurrencyCharAlignment.end,
              );

              final pricePrecision = 2;
              final sentBitcoin = _assetSentTicker == kLiquidBitcoinTicker;
              final assetPrecision =
                  sentBitcoin ? _receivedPrecision : _deliveredPrecision;
              final bitcoinAmountFull = (sentBitcoin
                      ? _balanceDelivered.amount
                      : _balanceReceived.amount)
                  .toInt()
                  .abs();
              final assetAmount = (sentBitcoin
                      ? _balanceReceived.amount
                      : _balanceDelivered.amount)
                  .toInt()
                  .abs();
              final networkFee = _transItem.tx.networkFee.toInt().abs();
              final bitcoinAmountAjusted = sentBitcoin
                  ? bitcoinAmountFull - networkFee
                  : bitcoinAmountFull + networkFee;
              final price = toFloat(assetAmount, precision: assetPrecision) /
                  toFloat(bitcoinAmountAjusted);
              _price = price.toStringAsFixed(pricePrecision);
              final assetTicker =
                  sentBitcoin ? _assetRecvTicker : _assetSentTicker;
              _price = replaceCharacterOnPosition(
                input: _price,
                currencyChar: assetTicker,
                currencyCharAlignment: CurrencyCharAlignment.end,
              );
              _price = '1 $kLiquidBitcoinTicker = $_price';
            }

            final _balances = _transItem.tx.balances;
            final _networkFee = _transItem.tx.networkFee.toInt();
            final _confs = _transItem.confs;
            final _tx = _transItem.tx;

            return SwapSummary(
              ticker: _ticker,
              delivered: _delivered,
              received: _received,
              price: _price,
              type: _type,
              txCircleImageType: _txCircleImageType,
              timestampStr: _timestampStr,
              status: _status,
              balances: _balances,
              networkFee: _networkFee,
              confs: _confs,
              tx: _tx,
              txId: _tx.txid,
            );
          }

          return TxDetailsPeg(
            transItem: _transItem,
          );
        },
      ),
    );
  }
}
