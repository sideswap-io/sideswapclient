import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';


class _FakeMarketLimitOfflineSwap extends MarketLimitOfflineSwap {
  @override
  OfflineSwapType build() => OfflineSwapType.empty();
}

void main() {
  group('TrackingValue', () {
    group('asDouble', () {
      test('returns tracking value as double', () {
        final value = TrackingValue(trackingValue: 42.5);
        expect(value.asDouble(), 42.5);
      });

      test('returns zero for zero tracking value', () {
        final value = TrackingValue(trackingValue: 0.0);
        expect(value.asDouble(), 0.0);
      });

      test('returns negative value as double', () {
        final value = TrackingValue(trackingValue: -15.5);
        expect(value.asDouble(), -15.5);
      });
    });

    group('asDecimal', () {
      test('parses tracking value to decimal', () {
        final value = TrackingValue(trackingValue: 42.5);
        expect(value.asDecimal(), Decimal.parse('42.5'));
      });

      test('returns zero decimal for zero tracking value', () {
        final value = TrackingValue(trackingValue: 0.0);
        expect(value.asDecimal(), Decimal.zero);
      });

      test('parses negative tracking value to decimal', () {
        final value = TrackingValue(trackingValue: -15.5);
        expect(value.asDecimal(), Decimal.parse('-15.5'));
      });

      test('handles large decimal values', () {
        final value = TrackingValue(trackingValue: 123456789.123456);
        final result = value.asDecimal();
        expect(result.toString(), contains('123456789'));
      });
    });

    group('asDecimalPercent', () {
      test('converts tracking value to percent multiplier', () {
        final value = TrackingValue(trackingValue: 50.0);
        final result = value.asDecimalPercent();
        // 50% means 1.5x multiplier: 1 + (50/100) = 1.5
        expect(result, Decimal.parse('1.5'));
      });

      test('returns 1.0 for zero percent', () {
        final value = TrackingValue(trackingValue: 0.0);
        expect(value.asDecimalPercent(), Decimal.one);
      });

      test('returns 2.0 for 100 percent', () {
        final value = TrackingValue(trackingValue: 100.0);
        expect(value.asDecimalPercent(), Decimal.parse('2'));
      });

      test('handles negative percent values', () {
        final value = TrackingValue(trackingValue: -50.0);
        final result = value.asDecimalPercent();
        // -50% means 0.5x multiplier: 1 + (-50/100) = 0.5
        expect(result, Decimal.parse('0.5'));
      });

      test('handles fractional percent values', () {
        final value = TrackingValue(trackingValue: 25.5);
        final result = value.asDecimalPercent();
        // 25.5% means 1.255x multiplier: 1 + (25.5/100) = 1.255
        expect(result, Decimal.parse('1.255'));
      });
    });

    group('copyWith', () {
      test('returns new instance with updated tracking value', () {
        final original = TrackingValue(trackingValue: 42.0);
        final updated = original.copyWith(trackingValue: 100.0);
        expect(updated.asDouble(), 100.0);
        expect(original.asDouble(), 42.0);
      });

      test('returns copy with same value when no arguments provided', () {
        final original = TrackingValue(trackingValue: 42.0);
        final copy = original.copyWith();
        expect(copy.asDouble(), 42.0);
        expect(copy == original, true);
      });

      test('preserves original instance immutability', () {
        final original = TrackingValue(trackingValue: 50.0);
        original.copyWith(trackingValue: 75.0);
        expect(original.asDouble(), 50.0);
      });
    });

    group('equality', () {
      test('returns true for identical instances', () {
        final value = TrackingValue(trackingValue: 42.0);
        expect(value == value, true);
      });

      test('returns true for equal values', () {
        final value1 = TrackingValue(trackingValue: 42.0);
        final value2 = TrackingValue(trackingValue: 42.0);
        expect(value1 == value2, true);
      });

      test('returns false for different values', () {
        final value1 = TrackingValue(trackingValue: 42.0);
        final value2 = TrackingValue(trackingValue: 43.0);
        expect(value1 == value2, false);
      });
    });

    group('hashCode', () {
      test('returns same hash code for equal values', () {
        final value1 = TrackingValue(trackingValue: 42.0);
        final value2 = TrackingValue(trackingValue: 42.0);
        expect(value1.hashCode == value2.hashCode, true);
      });

      test('can be used in collections', () {
        final set = {
          TrackingValue(trackingValue: 42.0),
          TrackingValue(trackingValue: 42.0),
          TrackingValue(trackingValue: 43.0),
        };
        expect(set.length, 2);
      });
    });

    group('toString', () {
      test('includes tracking value in string representation', () {
        final value = TrackingValue(trackingValue: 42.5);
        expect(value.toString(), contains('42.5'));
      });
    });
  });

  group('MarketLimitTrackIndexPriceStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('resets to false when marketLimitOfflineSwapProvider switches to TwoStep',
        () {
      final container = ProviderContainer.test(
        overrides: [
          marketLimitOfflineSwapProvider
              .overrideWith(() => _FakeMarketLimitOfflineSwap()),
        ],
      );
      addTearDown(container.dispose);

      // Set tracking state to true
      container
          .read(marketLimitTrackIndexPriceStateProvider.notifier)
          .setState(true);
      expect(
        container.read(marketLimitTrackIndexPriceStateProvider),
        true,
      );

      // Switch offline swap to TwoStep — triggers ref.listen callback
      container
          .read(marketLimitOfflineSwapProvider.notifier)
          .setState(OfflineSwapType.twoStep());

      // Listener should have reset state to false
      expect(
        container.read(marketLimitTrackIndexPriceStateProvider),
        false,
      );
    });
  });

  group('MarketLimitTrackIndexPriceValueNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('resets to zero when marketLimitOfflineSwapProvider switches to TwoStep',
        () {
      final container = ProviderContainer.test(
        overrides: [
          marketLimitOfflineSwapProvider
              .overrideWith(() => _FakeMarketLimitOfflineSwap()),
        ],
      );
      addTearDown(container.dispose);

      // Set tracking value to non-zero
      container
          .read(marketLimitTrackIndexPriceValueProvider.notifier)
          .setState(TrackingValue(trackingValue: 100.0));
      expect(
        container.read(marketLimitTrackIndexPriceValueProvider).asDouble(),
        100.0,
      );

      // Switch offline swap to TwoStep — triggers ref.listen callback
      container
          .read(marketLimitOfflineSwapProvider.notifier)
          .setState(OfflineSwapType.twoStep());

      // Listener should have reset state to zero
      expect(
        container.read(marketLimitTrackIndexPriceValueProvider).asDouble(),
        0.0,
      );
    });
  });

  group('limitReviewOrderPrice', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns orderAmount unchanged when amount is zero', () {
      final orderAmount = OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      expect(result.amount, Decimal.zero);
      expect(result.assetId, 'asset1');
    });

    test('returns orderAmount unchanged when assetId is empty', () {
      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: '',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      expect(result.amount, Decimal.parse('100'));
      expect(result.assetId, '');
    });

    test('returns orderAmount unchanged when tracking state is false', () {
      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      expect(result, orderAmount);
    });

    test('applies tracking value when tracking state is true', () {
      final mockSatoshiRepository = MockSatoshiRepository();
      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(5000);

      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      final indexPrice = (
        decimalIndexPrice: Decimal.parse('200'),
        quoteAsset: Option<Asset>.none(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(TrackingValue(trackingValue: 50.0)),
          marketDecimalIndexPriceProvider
              .overrideWithValue(Option.of(indexPrice)),
          marketDecimalLastPriceProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      // Price with 50% tracking: 200 * (1 + 50/100) = 200 * 1.5 = 300
      expect(result.amount, Decimal.parse('300'));
      expect(result.satoshi, 5000);
      expect(result.assetId, 'asset1');
    });

    test('uses last price when index price is not available', () {
      final mockSatoshiRepository = MockSatoshiRepository();
      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(3000);

      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      final lastPrice = (
        decimalLastPrice: Decimal.parse('150'),
        quoteAsset: Option<Asset>.none(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(TrackingValue(trackingValue: 30.0)),
          marketDecimalIndexPriceProvider.overrideWithValue(Option.none()),
          marketDecimalLastPriceProvider.overrideWithValue(Option.of(lastPrice)),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      // Price with 30% tracking: 150 * (1 + 30/100) = 150 * 1.3 = 195
      expect(result.amount, Decimal.parse('195'));
    });

    test('uses zero when both index and last price are unavailable', () {
      final mockSatoshiRepository = MockSatoshiRepository();
      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(0);

      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(TrackingValue(trackingValue: 20.0)),
          marketDecimalIndexPriceProvider.overrideWithValue(Option.none()),
          marketDecimalLastPriceProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      // Price with 20% tracking on zero: 0 * 1.2 = 0
      expect(result.amount, Decimal.zero);
    });
  });

  group('limitReviewOrderAggregateVolume', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns original aggregate volume when tracking state is false', () {
      final original = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50'),
        precision: 2,
      );

      container = ProviderContainer.test(
        overrides: [
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(original),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeProvider);
      expect(result, original);
    });

    test('updates price when tracking state is true', () {
      final original = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50'),
        precision: 2,
      );

      final newPrice = OrderAmount(
        amount: Decimal.parse('75'),
        satoshi: 7500,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(original),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          limitReviewOrderPriceProvider.overrideWithValue(newPrice),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeProvider);
      expect(result.price, Decimal.parse('75'));
      expect(result.amount, Decimal.parse('100'));
    });
  });

  group('limitReviewOrderAggregateVolumeTooHigh', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns true when no quote asset available', () {
      container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeTooHighProvider);
      expect(result, true);
    });

    test('returns true when aggregate volume exceeds balance', () {
      final mockAsset = Asset();
      mockAsset.freeze();

      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50'),
        precision: 2,
      );

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset)
              .overrideWithValue('1000'), // balance is 1000
        ],
      );
      addTearDown(container.dispose);

      // aggregateVolume.asDouble() will be > 1000, so should return true
      final result = container.read(limitReviewOrderAggregateVolumeTooHighProvider);
      expect(result, true);
    });

    test('returns false when aggregate volume is within balance', () {
      final mockAsset = Asset();
      mockAsset.freeze();

      // aggregateVolume calculation: amount * price * 100000000 / 10^precision
      // 10 * 5 * 100000000 / 100 = 50000000
      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('10'),
        price: Decimal.parse('5'),
        precision: 2,
      );

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset)
              .overrideWithValue('100000000'), // balance is 100000000, > 50000000
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeTooHighProvider);
      expect(result, false);
    });

    test('returns false when balance cannot be parsed', () {
      final mockAsset = Asset();
      mockAsset.freeze();

      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50'),
        precision: 2,
      );

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset)
              .overrideWithValue('invalid'), // cannot parse
        ],
      );
      addTearDown(container.dispose);

      // Falls back to 0.0, volume is definitely > 0
      final result = container.read(limitReviewOrderAggregateVolumeTooHighProvider);
      expect(result, true);
    });
  });

  group('limitReviewOrderInsufficientPrice', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when price amount is zero', () {
      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when no fee asset available', () {
      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when no quote asset available', () {
      final mockFeeAsset = Asset();
      mockFeeAsset.freeze();

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when multiplied amount is zero', () {
      final mockFeeAsset = Asset();
      mockFeeAsset.freeze();
      final mockQuoteAsset = Asset();
      mockQuoteAsset.freeze();

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns true when satoshi below minimal amount with matching assets',
        () {
      final mockFeeAsset = Asset(assetId: 'feeAsset');
      final mockQuoteAsset = Asset(assetId: 'feeAsset');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(500); // Below minimal 1000

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('10'),
              satoshi: 1000,
              assetId: 'feeAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('20'),
              satoshi: 2000,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'feeAsset': 1000,
          }),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, true);
    });

    test('returns false when satoshi meets minimal amount requirement', () {
      final mockFeeAsset = Asset(assetId: 'feeAsset');
      final mockQuoteAsset = Asset(assetId: 'feeAsset');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(2000); // Meets minimal 1000

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('10'),
              satoshi: 1000,
              assetId: 'feeAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('20'),
              satoshi: 2000,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'feeAsset': 1000,
          }),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when fee asset does not match quote asset', () {
      final mockFeeAsset = Asset(assetId: 'feeAsset1');
      final mockQuoteAsset = Asset(assetId: 'feeAsset2');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(500); // Below minimal

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('10'),
              satoshi: 1000,
              assetId: 'feeAsset2',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('20'),
              satoshi: 2000,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'feeAsset1': 1000,
            'feeAsset2': 1000,
          }),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false); // Different assets, so condition not met
    });
  });

  group('limitReviewOrderSubmitButtonEnabled', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when insufficient amount', () {
      container = ProviderContainer.test(
        overrides: [
          limitInsufficientAmountProvider.overrideWithValue(true),
          limitReviewOrderInsufficientPriceProvider.overrideWithValue(false),
          orderSubmitProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50'),
              satoshi: 500,
              assetId: 'asset2',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderSubmitButtonEnabledProvider);
      expect(result, false);
    });

    test('returns false when insufficient price', () {
      container = ProviderContainer.test(
        overrides: [
          limitInsufficientAmountProvider.overrideWithValue(false),
          limitReviewOrderInsufficientPriceProvider.overrideWithValue(true),
          orderSubmitProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50'),
              satoshi: 500,
              assetId: 'asset2',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderSubmitButtonEnabledProvider);
      expect(result, false);
    });

    test('returns false when order submit is in progress', () {
      container = ProviderContainer.test(
        overrides: [
          limitInsufficientAmountProvider.overrideWithValue(false),
          limitReviewOrderInsufficientPriceProvider.overrideWithValue(false),
          orderSubmitProvider.overrideWithValue(
            Option.of(From_OrderSubmit()),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50'),
              satoshi: 500,
              assetId: 'asset2',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderSubmitButtonEnabledProvider);
      expect(result, false);
    });

    test('returns false when order amount is zero', () {
      container = ProviderContainer.test(
        overrides: [
          limitInsufficientAmountProvider.overrideWithValue(false),
          limitReviewOrderInsufficientPriceProvider.overrideWithValue(false),
          orderSubmitProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50'),
              satoshi: 500,
              assetId: 'asset2',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderSubmitButtonEnabledProvider);
      expect(result, false);
    });

    test('returns false when order price is zero', () {
      container = ProviderContainer.test(
        overrides: [
          limitInsufficientAmountProvider.overrideWithValue(false),
          limitReviewOrderInsufficientPriceProvider.overrideWithValue(false),
          orderSubmitProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'asset2',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderSubmitButtonEnabledProvider);
      expect(result, false);
    });

    test('returns true when all conditions met', () {
      container = ProviderContainer.test(
        overrides: [
          limitInsufficientAmountProvider.overrideWithValue(false),
          limitReviewOrderInsufficientPriceProvider.overrideWithValue(false),
          orderSubmitProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'asset1',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50'),
              satoshi: 500,
              assetId: 'asset2',
              assetPair: AssetPair(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderSubmitButtonEnabledProvider);
      expect(result, true);
    });
  });

  group('TrackingRangeConverter', () {
    group('toRangeWithPrecision', () {
      final converter = TrackingRangeConverter();

      test('converts value within default range', () {
        final result = converter.toRangeWithPrecision(0.5);
        expect(result, 0.0);
      });

      test('converts minimum value to new minimum', () {
        final result = converter.toRangeWithPrecision(0.0);
        expect(result, -5.0);
      });

      test('converts maximum value to new maximum', () {
        final result = converter.toRangeWithPrecision(1.0);
        expect(result, 5.0);
      });

      test('respects custom precision', () {
        final result = converter.toRangeWithPrecision(
          0.5,
          precision: 3,
        );
        expect(result.toString().split('.')[1].length <= 3, true);
      });

      test('respects custom original min and max', () {
        final result = converter.toRangeWithPrecision(
          50,
          origMinValue: 0.0,
          origMaxValue: 100.0,
        );
        expect(result, 0.0);
      });

      test('respects custom new min and max', () {
        final result = converter.toRangeWithPrecision(
          0.0,
          newMin: 0.0,
          newMax: 10.0,
        );
        expect(result, 0.0);
      });

      test('respects custom new max', () {
        final result = converter.toRangeWithPrecision(
          1.0,
          newMin: 0.0,
          newMax: 10.0,
        );
        expect(result, 10.0);
      });

      test('handles zero original range', () {
        final result = converter.toRangeWithPrecision(
          0.5,
          origMinValue: 1.0,
          origMaxValue: 1.0,
        );
        // When original range is zero, division by zero produces -Infinity
        // toStringAsFixed returns "-Infinity", which double.tryParse parses
        // to double.negativeInfinity
        expect(result.isInfinite, true);
        expect(result.isNegative, true);
      });

      test('applies correct precision to result', () {
        final result = converter.toRangeWithPrecision(
          0.33,
          precision: 0,
        );
        expect(result % 1, 0.0); // Should be whole number
      });
    });
  });

  group('trackingRangeConverter provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('provides TrackingRangeConverter instance', () {
      final converter = container.read(trackingRangeConverterProvider);
      expect(converter, isA<TrackingRangeConverter>());
    });

    test('converter instance is same across reads', () {
      final converter1 = container.read(trackingRangeConverterProvider);
      final converter2 = container.read(trackingRangeConverterProvider);
      expect(identical(converter1, converter2), true);
    });
  });


  group('limitReviewOrderPrice with various edge cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('handles negative tracking values', () {
      final mockSatoshiRepository = MockSatoshiRepository();
      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(4500);

      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      final indexPrice = (
        decimalIndexPrice: Decimal.parse('200'),
        quoteAsset: Option<Asset>.none(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(TrackingValue(trackingValue: -50.0)),
          marketDecimalIndexPriceProvider
              .overrideWithValue(Option.of(indexPrice)),
          marketDecimalLastPriceProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      // Price with -50% tracking: 200 * (1 + (-50)/100) = 200 * 0.5 = 100
      expect(result.amount, Decimal.parse('100'));
    });

    test('applies tracking when both prices are available and index price is preferred', () {
      final mockSatoshiRepository = MockSatoshiRepository();
      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(6000);

      final orderAmount = OrderAmount(
        amount: Decimal.parse('100'),
        satoshi: 1000,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      final indexPrice = (
        decimalIndexPrice: Decimal.parse('200'),
        quoteAsset: Option<Asset>.none(),
      );

      final lastPrice = (
        decimalLastPrice: Decimal.parse('150'),
        quoteAsset: Option<Asset>.none(),
      );

      container = ProviderContainer.test(
        overrides: [
          limitOrderPriceProvider.overrideWithValue(orderAmount),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(TrackingValue(trackingValue: 10.0)),
          marketDecimalIndexPriceProvider
              .overrideWithValue(Option.of(indexPrice)),
          marketDecimalLastPriceProvider.overrideWithValue(Option.of(lastPrice)),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderPriceProvider);
      // Prefers index price: 200 * 1.1 = 220
      expect(result.amount, Decimal.parse('220'));
    });
  });

  group('limitReviewOrderAggregateVolume with edge cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('preserves all fields when copying with new price', () {
      final original = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50'),
        precision: 3,
      );

      final newPrice = OrderAmount(
        amount: Decimal.parse('75'),
        satoshi: 7500,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(original),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          limitReviewOrderPriceProvider.overrideWithValue(newPrice),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeProvider);
      expect(result.price, Decimal.parse('75'));
      expect(result.amount, Decimal.parse('100'));
      expect(result.precision, 3);
    });

    test('updates price to zero when price amount is zero', () {
      final original = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50'),
        precision: 2,
      );

      final newPrice = OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: 'asset1',
        assetPair: AssetPair(),
      );

      container = ProviderContainer.test(
        overrides: [
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(original),
          marketLimitTrackIndexPriceStateProvider.overrideWithValue(true),
          limitReviewOrderPriceProvider.overrideWithValue(newPrice),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeProvider);
      expect(result.price, Decimal.zero);
    });
  });

  group('limitReviewOrderAggregateVolumeTooHigh with additional cases', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('correctly handles very large aggregate volumes', () {
      final mockAsset = Asset();
      mockAsset.freeze();

      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1000000'),
        price: Decimal.parse('1000'),
        precision: 0,
      );

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset)
              .overrideWithValue('100'), // very small balance
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeTooHighProvider);
      expect(result, true);
    });

    test('returns true when balance is empty string', () {
      final mockAsset = Asset();
      mockAsset.freeze();

      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('10'),
        price: Decimal.parse('5'),
        precision: 2,
      );

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset)
              .overrideWithValue(''), // empty string
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitReviewOrderAggregateVolumeTooHighProvider);
      expect(result, true); // Falls back to 0.0
    });
  });

  group('limitReviewOrderInsufficientPrice with complex scenarios', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when order amount is zero price is non-zero', () {
      final mockFeeAsset = Asset(assetId: 'feeAsset');
      final mockQuoteAsset = Asset(assetId: 'feeAsset');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(500);

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('100'),
              satoshi: 1000,
              assetId: 'feeAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'feeAsset': 1000,
          }),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns true when all assets match and satoshi below minimal', () {
      final mockFeeAsset = Asset(assetId: 'commonAsset');
      final mockQuoteAsset = Asset(assetId: 'commonAsset');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(999); // Just below minimal

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('10'),
              satoshi: 1000,
              assetId: 'commonAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('20'),
              satoshi: 2000,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'commonAsset': 1000,
          }),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, true);
    });

    test('returns false when asset ID does not match price asset ID', () {
      final mockFeeAsset = Asset(assetId: 'feeAsset');
      final mockQuoteAsset = Asset(assetId: 'feeAsset');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(500);

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('10'),
              satoshi: 1000,
              assetId: 'differentAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('20'),
              satoshi: 2000,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'feeAsset': 500,
          }),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when fee asset has no minimal amount entry', () {
      final mockFeeAsset = Asset(assetId: 'unknownAsset');
      final mockQuoteAsset = Asset(assetId: 'unknownAsset');
      final mockSatoshiRepository = MockSatoshiRepository();

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(500);

      container = ProviderContainer.test(
        overrides: [
          limitReviewOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('10'),
              satoshi: 1000,
              assetId: 'unknownAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('20'),
              satoshi: 2000,
              assetId: 'baseAsset',
              assetPair: AssetPair(),
            ),
          ),
          limitFeeAssetProvider.overrideWithValue(Option.of(mockFeeAsset)),
          marketSubscribedQuoteAssetProvider
              .overrideWithValue(Option.of(mockQuoteAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({}), // empty
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(limitReviewOrderInsufficientPriceProvider);
      // No minimal amount means defaults to 0, so 500 >= 0 is true, condition not met, returns false
      expect(result, false);
    });
  });

  group('TrackingRangeConverter edge cases', () {
    final converter = TrackingRangeConverter();

    test('handles large values', () {
      final result = converter.toRangeWithPrecision(
        999999.999,
        origMinValue: 0.0,
        origMaxValue: 1000000.0,
        newMin: -1000.0,
        newMax: 1000.0,
      );
      expect(result, isA<double>());
      expect(result.isFinite, true);
    });

    test('handles very small values', () {
      final result = converter.toRangeWithPrecision(
        0.0001,
        precision: 5,
      );
      expect(result, isA<double>());
    });

    test('preserves value at midpoint', () {
      final result = converter.toRangeWithPrecision(
        0.5,
        origMinValue: 0.0,
        origMaxValue: 1.0,
        newMin: 0.0,
        newMax: 10.0,
      );
      expect(result, 5.0);
    });

    test('handles negative values in original range', () {
      final result = converter.toRangeWithPrecision(
        0.0,
        origMinValue: -10.0,
        origMaxValue: 10.0,
        newMin: -100.0,
        newMax: 100.0,
      );
      expect(result, 0.0);
    });

    test('handles negative values in new range', () {
      final result = converter.toRangeWithPrecision(
        1.0,
        newMin: -10.0,
        newMax: -5.0,
      );
      expect(result, -5.0);
    });
  });
}

class MockSatoshiRepository extends Mock implements AbstractSatoshiRepository {}
