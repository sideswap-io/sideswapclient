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
    @required this.visibleToggles,
    this.onTap,
  });

  final _swapIconSize = 48.w;
  final bool visibleToggles;
  final VoidCallback onTap;

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
                  final serverFeePercentPegIn = watch(walletProvider)
                          .serverStatus
                          ?.serverFeePercentPegIn ??
                      0;
                  final serverFeePercentPegOut = watch(walletProvider)
                          .serverStatus
                          ?.serverFeePercentPegOut ??
                      0;

                  final _recvAmount = watch(swapProvider).swapRecvAmount ?? 0;
                  final _assetSend = watch(swapProvider).swapSendAsset ?? '';
                  final _assetRecv = watch(swapProvider).swapRecvAsset ?? '';
                  final _sendAmount = watch(swapProvider).swapSendAmount ?? 0;
                  final _networkFee = watch(swapProvider).swapNetworkFee ?? 0;
                  final _amountBitcoin = _assetSend == kLiquidBitcoinTicker
                      ? _sendAmount
                      : _recvAmount;
                  // Client is paying network fees, show price that the dealer will get
                  final _amountBitcoinAdjusted =
                      _assetSend == kLiquidBitcoinTicker
                          ? _amountBitcoin - _networkFee
                          : _amountBitcoin + _networkFee;
                  final _amountAsset = _assetSend != kLiquidBitcoinTicker
                      ? _sendAmount
                      : _recvAmount;
                  final _priceSwap = _amountBitcoinAdjusted != 0
                      ? _amountAsset / _amountBitcoinAdjusted
                      : 0.0;

                  final _asset = _assetSend != kLiquidBitcoinTicker
                      ? _assetSend
                      : _assetRecv;
                  final _assetPrice = watch(walletProvider).prices[_asset];
                  final _priceBroadcast = _assetPrice != null
                      ? (_assetSend != kLiquidBitcoinTicker
                          ? _assetPrice.ask
                          : _assetPrice.bid)
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
                  final _swapType = context.read(swapProvider).swapType();
                  final _tickerAsset = _assetSend != kLiquidBitcoinTicker
                      ? _assetSend
                      : _assetRecv;
                  final _swapText =
                      '1 $kLiquidBitcoinTicker = $_priceStr $_tickerAsset';
                  var _percentConversion =
                      _sendAmount != 0 ? 100.0 * _recvAmount / _sendAmount : 0;
                  if (_swapType != SwapType.atomic && _percentConversion == 0) {
                    // display conversion for peg in/out
                    _percentConversion = _assetSend == kLiquidBitcoinTicker
                        ? 100 - serverFeePercentPegOut
                        : 100 - serverFeePercentPegIn;
                  }
                  var _conversionStr = _percentConversion.toStringAsFixed(2);
                  var _conversionText = 'Conversion rate ${_conversionStr}%';
                  final _priceText = _swapType == SwapType.atomic
                      ? _swapText
                      : _conversionText;

                  return Visibility(
                    visible: _swapType != SwapType.atomic || _price != 0,
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
