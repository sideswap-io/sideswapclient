// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/duration_extension.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class UiOwnOrder extends ConvertAmount {
  final OwnOrder ownOrder;
  final DateTime timestamp;
  final Map<String, Asset> assetsState;
  final AbstractAssetImageRepository assetImageRepository;
  final AbstractSatoshiRepository satoshiRepository;
  final AssetUtils assetUtils;
  final MarketType_ marketType;
  final String locale;

  UiOwnOrder({
    required AmountToString amountToString,
    required this.ownOrder,
    required this.assetsState,
    required this.assetImageRepository,
    required this.satoshiRepository,
    required this.assetUtils,
    required this.marketType,
    required this.locale,
  }) : timestamp = DateTime.timestamp(),
       super(amountToString);

  OrderId get orderId => ownOrder.orderId;
  AssetPair get assetPair => ownOrder.assetPair;
  TradeDir get tradeDir => ownOrder.tradeDir;
  String get privateId => ownOrder.privateId;
  int get activeAmount => ownOrder.activeAmount.toInt();
  bool get exclamationMark => activeAmount == 0;
  bool get questionMark => !exclamationMark && activeAmount < amount;
  OrderType get orderType => switch (ownOrder.privateId.isEmpty) {
    true => OrderType.public(),
    _ => OrderType.private(),
  };
  String get orderTypeDescription => switch (orderType) {
    OrderTypePrivate() => 'Private'.tr(),
    _ => 'Public'.tr(),
  };
  OfflineSwapType get offlineSwapType => switch (ownOrder.twoStep) {
    true => OfflineSwapType.twoStep(),
    _ => OfflineSwapType.empty(),
  };
  String get offlineSwapTypeDescription => switch (offlineSwapType) {
    OfflineSwapTypeTwoStep() => 'Offline'.tr(),
    _ => 'Online'.tr(),
  };

  DateTime get endDateTime {
    return timestamp.add(Duration(seconds: ownOrder.ttlSeconds.toInt()));
  }

  int? get ttl {
    if (ownOrder.ttlSeconds == 0) {
      return null;
    }

    final now = DateTime.timestamp();
    final diff = endDateTime.difference(now);
    return diff.inSeconds <= 0 ? null : diff.inSeconds;
  }

  Duration get expireDuration {
    return endDateTime.difference(DateTime.now());
  }

  String get expireDescription {
    if (ownOrder.ttlSeconds == 0) {
      return '∞';
    }

    return expireDuration.toStringCustom();
  }

  String get productName {
    final optionBaseAsset = baseAsset;
    final optionQuoteAsset = quoteAsset;

    return optionBaseAsset.match(
      () => '',
      (baseAsset) => optionQuoteAsset.match(
        () => '',
        (quoteAsset) => '${baseAsset.ticker} / ${quoteAsset.ticker}',
      ),
    );
  }

  Option<Asset> get baseAsset {
    final asset = assetsState[ownOrder.assetPair.base];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  Option<Asset> get quoteAsset {
    final asset = assetsState[ownOrder.assetPair.quote];
    if (asset == null) {
      return Option.none();
    }

    return Option.of(asset);
  }

  String get total {
    return quoteAsset.match(
      () => () {
        return '0.0';
      },
      (asset) => () {
        final precision = assetUtils.getPrecisionForAssetId(
          assetId: asset.assetId,
        );

        final totalDecimal = amountDecimal * priceDecimal;

        final formatterThousandsSeparator = NumberFormat(
          "#,##0.0#######",
          locale,
        );
        final totalAsString =
            precision > 0
                ? totalDecimal.toStringAsFixed(precision)
                : totalDecimal.toString();
        final totalAsDecimal = Decimal.tryParse(totalAsString) ?? Decimal.zero;

        return formatterThousandsSeparator.format(totalAsDecimal.toDouble());
      },
    )();
  }

  String get totalMobileString {
    return quoteAsset.match(
      () {
        return '0.0';
      },
      (asset) {
        final precision = assetUtils.getPrecisionForAssetId(
          assetId: asset.assetId,
        );

        final totalDecimal = amountDecimal * priceDecimal;

        return super.amountToString.amountToMobileFormatted(
          amount: totalDecimal,
          precision: precision,
          forceScaleWithInteger: false,
        );
      },
    );
  }

  Widget get totalIcon => priceIcon;
  String get totalTicker => priceTicker;

  int get amount => ownOrder.origAmount.toInt();
  int get amountPrecision =>
      assetUtils.getPrecisionForAssetId(assetId: assetPair.base);
  Decimal get amountDecimal {
    final amountAsString = super.amountToString.amountToString(
      AmountToStringParameters(amount: amount, precision: amountPrecision),
    );
    return Decimal.tryParse(amountAsString) ?? Decimal.zero;
  }

  String get amountTextInputString {
    return amountDecimal.toString();
  }

  String get amountString {
    return super.amountToString.amountToString(
      AmountToStringParameters(
        amount: amount,
        precision: amountPrecision,
        useNumberFormatter: true,
      ),
    );
  }

  String get amountMobileString {
    final bitAmount = amount ~/ kCoin;
    final satAmount = amount % kCoin;
    final satAmountStr = satAmount.toString().padLeft(8, '0');
    final decimalAmount =
        Decimal.tryParse('$bitAmount$satAmountStr') ?? Decimal.zero;
    final power =
        Decimal.tryParse(
          pow(10, amountPrecision).toStringAsFixed(amountPrecision),
        ) ??
        Decimal.zero;
    final resultAmount = (decimalAmount / power).toDecimal();
    return super.amountToString.amountToMobileFormatted(
      amount: resultAmount,
      precision: amountPrecision,
    );
  }

  Widget get amountIcon {
    return baseAsset.match(
      () => SizedBox(),
      (asset) => assetImageRepository.getVerySmallImage(asset.assetId),
    );
  }

  String get amountTicker {
    return baseAsset.match(() => '', (asset) => asset.ticker);
  }

  double get price => ownOrder.price;
  int get pricePrecision =>
      assetUtils.getPrecisionForAssetId(assetId: assetPair.quote);
  Decimal get priceDecimal {
    return Decimal.tryParse((price).toString()) ?? Decimal.zero;
  }

  String get priceString {
    final priceSatoshi = satoshiRepository.satoshiForAmount(
      amount: priceDecimal.toString(),
      assetId: assetPair.quote,
    );
    return super.amountToString.amountToString(
      AmountToStringParameters(
        amount: priceSatoshi,
        precision: pricePrecision,
        useNumberFormatter: true,
      ),
    );
  }

  String get priceTextInputString {
    return priceDecimal.toString();
  }

  String get priceMobileString {
    return super.amountToString.amountToMobileFormatted(
      amount: priceDecimal,
      precision: pricePrecision,
    );
  }

  Widget get priceIcon {
    return quoteAsset.match(
      () => SizedBox(),
      (asset) => assetImageRepository.getVerySmallImage(asset.assetId),
    );
  }

  String get priceTicker {
    return quoteAsset.match(() => '', (asset) => asset.ticker);
  }

  bool get isAmp {
    return quoteAsset.match(
      () {
        return false;
      },
      (asset) {
        return asset.ampMarket;
      },
    );
  }

  UiOwnOrder copyWith({
    AmountToString? amountToString,
    OwnOrder? ownOrder,
    DateTime? timestamp,
    Map<String, Asset>? assetsState,
    AbstractAssetImageRepository? assetImageRepository,
    AbstractSatoshiRepository? satoshiRepository,
    AssetUtils? assetUtils,
    MarketType_? marketType,
    String? locale,
  }) {
    return UiOwnOrder(
      amountToString: amountToString ?? this.amountToString,
      ownOrder: ownOrder ?? this.ownOrder,
      assetsState: assetsState ?? this.assetsState,
      assetImageRepository: assetImageRepository ?? this.assetImageRepository,
      satoshiRepository: satoshiRepository ?? this.satoshiRepository,
      assetUtils: assetUtils ?? this.assetUtils,
      marketType: marketType ?? this.marketType,
      locale: locale ?? this.locale,
    );
  }

  @override
  String toString() {
    return 'UiOwnOrder(ownOrder: $ownOrder, timestamp: $timestamp, assetsState: $assetsState, assetImageRepository: $assetImageRepository, satoshiRepository: $satoshiRepository, assetUtils: $assetUtils, marketType: $marketType, locale: $locale)';
  }

  @override
  bool operator ==(covariant UiOwnOrder other) {
    if (identical(this, other)) return true;

    return other.ownOrder == ownOrder &&
        other.timestamp == timestamp &&
        mapEquals(other.assetsState, assetsState) &&
        other.assetImageRepository == assetImageRepository &&
        other.satoshiRepository == satoshiRepository &&
        other.assetUtils == assetUtils &&
        other.marketType == marketType &&
        other.locale == locale;
  }

  @override
  int get hashCode {
    return ownOrder.hashCode ^
        timestamp.hashCode ^
        assetsState.hashCode ^
        assetImageRepository.hashCode ^
        satoshiRepository.hashCode ^
        assetUtils.hashCode ^
        marketType.hashCode ^
        locale.hashCode;
  }
}
