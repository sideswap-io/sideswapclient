import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class UiHistoryOrder extends ConvertAmount {
  final Map<String, Asset> assetsState;
  final HistoryOrder historyOrder;
  final AbstractAssetImageRepository assetImageRepository;
  final AbstractSatoshiRepository satoshiRepository;
  final AssetUtils assetUtils;

  UiHistoryOrder({
    required AmountToString amountToString,
    required this.assetsState,
    required this.assetImageRepository,
    required this.satoshiRepository,
    required this.assetUtils,
    required this.historyOrder,
  }) : super(amountToString);

  int get id => historyOrder.id.toInt();
  OrderId get orderId => historyOrder.orderId;
  AssetPair get assetPair => historyOrder.assetPair;
  TradeDir get tradeDir => historyOrder.tradeDir;
  int get baseAmount => historyOrder.baseAmount.toInt();
  int get quoteAmount => historyOrder.quoteAmount.toInt();
  double get price => historyOrder.price;
  HistStatus get histStatus => historyOrder.status;
  String get txId => historyOrder.txid;

  String get date {
    final longFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    return longFormat.format(
      DateTime.fromMillisecondsSinceEpoch(
        historyOrder.id.toInt(),
        isUtc: false,
      ),
    );
  }

  String get status {
    return switch (histStatus) {
      HistStatus.CANCELLED => 'Cancelled'.tr(),
      HistStatus.CONFIRMED => 'Confirmed'.tr(),
      HistStatus.ELAPSED => 'Elapsed'.tr(),
      HistStatus.MEMPOOL => 'Mempool'.tr(),
      HistStatus.REPLACED => 'Replaced'.tr(),
      HistStatus.TX_CONFLICT => 'Tx conflict'.tr(),
      HistStatus.TX_NOT_FOUND => 'Tx not found'.tr(),
      HistStatus.UTXO_INVALIDATED => 'Utxo invalidated'.tr(),
      _ => '',
    };
  }

  String get statusDescription {
    return switch (histStatus) {
      HistStatus.CANCELLED => 'Order cancelled by the user'.tr(),
      HistStatus.CONFIRMED => 'Swap succeed and tx is confirmed'.tr(),
      HistStatus.ELAPSED => 'Order elapsed'.tr(),
      HistStatus.MEMPOOL => 'Swap succeed and tx is mempool'.tr(),
      HistStatus.REPLACED =>
        'Offline order UTXO replaced by some other offline order'.tr(),
      HistStatus.TX_CONFLICT =>
        'Error: Swap tx broadcast succeed, but different tx was confirmed'.tr(),
      HistStatus.TX_NOT_FOUND =>
        'Server error: Swap tx broadcast succeed, but its current state is unknown'
            .tr(),
      HistStatus.UTXO_INVALIDATED =>
        'Offline order UTXO spent by some other tx'.tr(),
      _ => '',
    };
  }

  String get tradeDirDescription =>
      tradeDir == TradeDir.SELL ? 'Sell'.tr() : 'Buy'.tr();

  Option<Asset> get sentAsset {
    final asset = assetsState[assetPair.base];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  Widget get sentIcon {
    return sentAsset.match(
      () => SizedBox(),
      (asset) => assetImageRepository.getVerySmallImage(asset.assetId),
    );
  }

  Option<Asset> get receivedAsset {
    final asset = assetsState[assetPair.quote];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  Widget get receivedIcon {
    return receivedAsset.match(
      () => SizedBox(),
      (asset) => assetImageRepository.getVerySmallImage(asset.assetId),
    );
  }

  Option<Asset> get priceAsset {
    final asset = assetsState[assetPair.quote];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  Widget get priceIcon {
    return priceAsset.match(
      () => SizedBox(),
      (asset) => assetImageRepository.getVerySmallImage(asset.assetId),
    );
  }

  int get sentAmountPrecision {
    return assetUtils.getPrecisionForAssetId(assetId: assetPair.base);
  }

  String get sentAmountString {
    return super.amountToString.amountToString(
      AmountToStringParameters(
        amount: baseAmount,
        precision: sentAmountPrecision,
      ),
    );
  }

  int get receivedAmountPrecision {
    return assetUtils.getPrecisionForAssetId(assetId: assetPair.quote);
  }

  String get receivedAmountString {
    return super.amountToString.amountToString(
      AmountToStringParameters(
        amount: quoteAmount,
        precision: receivedAmountPrecision,
      ),
    );
  }

  int get priceAmountPrecision {
    return sentAmountPrecision;
  }

  String get priceAmountString {
    final priceDecimal = Decimal.tryParse((price).toString());
    final priceSatoshi = satoshiRepository.satoshiForAmount(
      amount: priceDecimal.toString(),
      assetId: assetPair.quote,
    );

    return super.amountToString.amountToString(
      AmountToStringParameters(
        amount: priceSatoshi,
        precision: priceAmountPrecision,
      ),
    );
  }

  String get confirmations {
    return '';
  }
}
