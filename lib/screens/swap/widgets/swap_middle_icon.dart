import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';
import 'package:sideswap/screens/swap/widgets/swap_arrows_button.dart';

class SwapMiddleIcon extends ConsumerWidget {
  SwapMiddleIcon({
    Key? key,
    required this.visibleToggles,
    this.onTap,
    this.visible = true,
  }) : super(key: key);

  final _swapIconSize = 48.w;
  final bool visibleToggles;
  final VoidCallback? onTap;
  final bool visible;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _swapType = watch(swapProvider).swapType();
    final _topPadding = _swapType != SwapType.atomic
        ? visibleToggles
            ? 275.h
            : 205.h
        : 205.h;

    return Padding(
      padding: EdgeInsets.only(top: _topPadding - _swapIconSize / 2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            SwapArrowsButton(
              radius: _swapIconSize,
              onTap: onTap,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Consumer(
                builder: (context, watch, _) {
                  final wallet = watch(walletProvider);
                  final swap = watch(swapProvider);

                  final serverFeePercentPegIn =
                      wallet.serverStatus?.serverFeePercentPegIn ?? 0;
                  final serverFeePercentPegOut =
                      wallet.serverStatus?.serverFeePercentPegOut ?? 0;

                  final _recvAmount = swap.swapRecvAmount;
                  final _assetSend = swap.swapSendAsset ?? '';
                  final _assetRecv = swap.swapRecvAsset ?? '';
                  final _sendLiquid = _assetSend == wallet.liquidAssetId();
                  final _sendAmount = swap.swapSendAmount;
                  final _networkFee = swap.swapNetworkFee;
                  final _amountBitcoin =
                      _sendLiquid ? _sendAmount : _recvAmount;
                  // Client is paying network fees, show price that the dealer will get
                  final _amountBitcoinAdjusted = _sendLiquid
                      ? _amountBitcoin - _networkFee
                      : _amountBitcoin + _networkFee;
                  final _amountAsset = !_sendLiquid ? _sendAmount : _recvAmount;
                  final _priceSwap = _amountBitcoinAdjusted != 0
                      ? _amountAsset / _amountBitcoinAdjusted
                      : 0.0;

                  final _asset = !_sendLiquid ? _assetSend : _assetRecv;
                  final _assetPrice = wallet.prices[_asset];
                  final _priceBroadcast = _assetPrice != null
                      ? (!_sendLiquid ? _assetPrice.ask : _assetPrice.bid)
                      : 0.0;

                  final _price = _priceSwap != 0 ? _priceSwap : _priceBroadcast;
                  var _precision = 0;
                  if (_price > 1000) {
                    _precision = 0;
                  } else if (_price > 1) {
                    _precision = 2;
                  } else if (_price > 0.01) {
                    _precision = 4;
                  } else {
                    _precision = 6;
                  }
                  final _priceStr = _price.toStringAsFixed(_precision);
                  final _swapType = swap.swapType();
                  final _assetId = _assetSend != wallet.liquidAssetId()
                      ? _assetSend
                      : _assetRecv;
                  final _assetTicker =
                      wallet.getAssetById(_assetId)?.ticker ?? kUnknownTicker;
                  final _swapText =
                      '1 $kLiquidBitcoinTicker = $_priceStr $_assetTicker';
                  var _percentConversion =
                      _sendAmount != 0 ? 100.0 * _recvAmount / _sendAmount : 0;
                  if (_swapType != SwapType.atomic && _percentConversion == 0) {
                    // display conversion for peg in/out
                    _percentConversion = _sendLiquid
                        ? 100 - serverFeePercentPegOut
                        : 100 - serverFeePercentPegIn;
                  }
                  var _conversionStr = _percentConversion.toStringAsFixed(2);
                  var _conversionText = 'Conversion rate $_conversionStr%';
                  final _priceText = _swapType == SwapType.atomic
                      ? _swapText
                      : _conversionText;

                  return Visibility(
                    visible: (_swapType != SwapType.atomic || _price != 0) &&
                        visible &&
                        (wallet.serverStatus != null),
                    child: RoundedTextLabel(
                      text: _priceText,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
