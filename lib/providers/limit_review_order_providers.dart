import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';

part 'limit_review_order_providers.g.dart';

@riverpod
class MarketLimitTrackIndexPriceStateNotifier
    extends _$MarketLimitTrackIndexPriceStateNotifier {
  @override
  bool build() {
    ref.listen(marketLimitOfflineSwapProvider, (_, next) {
      if (next == OfflineSwapTypeTwoStep()) {
        state = false;
      }
    });

    return false;
  }

  void setState(bool value) {
    state = value;
  }
}

class TrackingValue {
  final double _trackingValue;

  TrackingValue({required double trackingValue})
    : _trackingValue = trackingValue;

  double asDouble() {
    return _trackingValue;
  }

  Decimal asDecimal() {
    return Decimal.tryParse('$_trackingValue') ?? Decimal.zero;
  }

  Decimal asDecimalPercent() {
    final percent = (asDecimal() / Decimal.fromInt(100)).toDecimal();
    return Decimal.one + percent;
  }

  TrackingValue copyWith({double? trackingValue}) {
    return TrackingValue(trackingValue: trackingValue ?? _trackingValue);
  }

  @override
  String toString() => 'TrackingValue(_trackingValue: $_trackingValue)';

  @override
  bool operator ==(covariant TrackingValue other) {
    if (identical(this, other)) return true;

    return other._trackingValue == _trackingValue;
  }

  @override
  int get hashCode => _trackingValue.hashCode;
}

@riverpod
class MarketLimitTrackIndexPriceValueNotifier
    extends _$MarketLimitTrackIndexPriceValueNotifier {
  @override
  TrackingValue build() {
    ref.listen(marketLimitOfflineSwapProvider, (_, next) {
      if (next == OfflineSwapTypeTwoStep()) {
        state = TrackingValue(trackingValue: .0);
      }
    });

    return TrackingValue(trackingValue: .0);
  }

  void setState(TrackingValue value) {
    state = value;
  }
}

@riverpod
OrderAmount limitReviewOrderPrice(Ref ref) {
  final orderAmount = ref.watch(limitOrderPriceProvider);

  final trackingState = ref.watch(
    marketLimitTrackIndexPriceStateNotifierProvider,
  );
  final trackingValue = ref.watch(
    marketLimitTrackIndexPriceValueNotifierProvider,
  );

  if (orderAmount.amount == Decimal.zero || orderAmount.assetId.isEmpty) {
    return orderAmount;
  }

  if (trackingState) {
    final optionDecimalIndexPrice = ref.watch(marketDecimalIndexPriceProvider);
    final optionDecimalLastPrice = ref.watch(marketDecimalLastPriceProvider);

    final decimalIndexPrice = optionDecimalIndexPrice.match(
      () => optionDecimalLastPrice.match(
        () => Decimal.zero,
        (indexPrice) => indexPrice.decimalLastPrice,
      ),
      (indexPrice) => indexPrice.decimalIndexPrice,
    );

    final decimalPrice = decimalIndexPrice * trackingValue.asDecimalPercent();

    final satoshiRepository = ref.watch(satoshiRepositoryProvider);

    final amountSatoshi = satoshiRepository.satoshiForAmount(
      amount: decimalPrice.toString(),
      assetId: orderAmount.assetId,
    );

    return orderAmount.copyWith(amount: decimalPrice, satoshi: amountSatoshi);
  }

  return orderAmount;
}

@riverpod
MarketOrderAggregateVolumeProvider limitReviewOrderAggregateVolume(Ref ref) {
  final aggregateVolume = ref.watch(marketLimitOrderAggregateVolumeProvider);
  final trackingState = ref.watch(
    marketLimitTrackIndexPriceStateNotifierProvider,
  );

  if (trackingState) {
    final orderPrice = ref.watch(limitReviewOrderPriceProvider);

    return aggregateVolume.copyWith(price: orderPrice.amount);
  }

  return aggregateVolume;
}

@riverpod
bool limitReviewOrderAggregateVolumeTooHigh(Ref ref) {
  final aggregateVolume = ref.watch(limitReviewOrderAggregateVolumeProvider);
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

  return optionQuoteAsset.match(() => true, (quoteAsset) {
    final assetBalance = ref.watch(assetBalanceStringProvider(quoteAsset));

    final balance = double.tryParse(assetBalance) ?? .0;
    return aggregateVolume.asDouble() > balance;
  });
}

@riverpod
bool limitReviewOrderInsufficientPrice(Ref ref) {
  final optionFeeAsset = ref.watch(limitFeeAssetProvider);
  final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
  final minimalAmounts = ref.watch(marketMinimalAmountsNotfierProvider);
  final priceAmount = ref.watch(limitReviewOrderPriceProvider);
  final orderAmount = ref.watch(limitOrderAmountProvider);

  if (priceAmount.amount == Decimal.zero) {
    return false;
  }

  return optionFeeAsset.match(
    () {
      return false;
    },
    (feeAsset) {
      return optionQuoteAsset.match(
        () {
          return false;
        },
        (quoteAsset) {
          if ((orderAmount.amount * priceAmount.amount) == Decimal.zero) {
            return false;
          }

          final satoshiRepository = ref.watch(satoshiRepositoryProvider);

          final multipliedAmount = (orderAmount.amount * priceAmount.amount);
          final multipliedSatoshi = satoshiRepository.satoshiForAmount(
            amount: multipliedAmount.toString(),
            assetId: feeAsset.assetId,
          );

          final minimalAmount = minimalAmounts[feeAsset.assetId] ?? 0;
          if (feeAsset.assetId == quoteAsset.assetId &&
              feeAsset.assetId == priceAmount.assetId &&
              multipliedSatoshi < minimalAmount) {
            return true;
          }

          return false;
        },
      );
    },
  );
}

@riverpod
bool limitReviewOrderSubmitButtonEnabled(Ref ref) {
  final insufficientAmount = ref.watch(limitInsufficientAmountProvider);
  final insufficientPrice = ref.watch(
    limitReviewOrderInsufficientPriceProvider,
  );
  if (insufficientAmount || insufficientPrice) {
    return false;
  }

  final optionOrderSubmit = ref.watch(orderSubmitNotifierProvider);
  if (optionOrderSubmit.isSome()) {
    return false;
  }

  final limitAmount = ref.watch(limitOrderAmountProvider);
  final limitPrice = ref.watch(limitOrderPriceProvider);

  if (limitAmount.amount == Decimal.zero || limitPrice.amount == Decimal.zero) {
    return false;
  }

  return true;
}

class TrackingRangeConverter {
  double toRangeWithPrecision(
    double value, {
    int precision = 2,
    double origMinValue = 0.0,
    double origMaxValue = 1.0,
    double newMin = -5.0,
    double newMax = 5.0,
  }) {
    final converted =
        ((((value - origMinValue) * (newMax - newMin)) /
                    (origMaxValue - origMinValue)) +
                newMin)
            .toStringAsFixed(precision);
    return double.tryParse(converted) ?? 0;
  }
}

@riverpod
TrackingRangeConverter trackingRangeConverter(Ref ref) {
  return TrackingRangeConverter();
}
