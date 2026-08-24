import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/providers/limit_edit_order_providers.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockUiOwnOrder extends Mock implements UiOwnOrder {}

class MockAbstractSatoshiRepository extends Mock
    implements AbstractSatoshiRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(Decimal.zero);
    registerFallbackValue('');
  });

  group('limitEditOrderPrice', () {
    late MockAbstractSatoshiRepository mockSatoshiRepository;

    setUp(() {
      mockSatoshiRepository = MockAbstractSatoshiRepository();
    });

    test('returns empty OrderAmount when order is not set', () {
      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider.overrideWithValue(None()),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
      expect(result.assetPair, AssetPair());
    });

    test('returns empty OrderAmount when order has no quote asset', () {
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(None());

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test('returns empty OrderAmount when order amount is zero', () {
      final mockAsset = Asset();
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.zero);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test('returns empty OrderAmount when quote asset id is empty', () {
      final mockAsset = Asset()..assetId = '';
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test('returns empty OrderAmount when isPriceTracking is false', () {
      final testAssetId = 'test_asset';
      final mockAsset = Asset()..assetId = testAssetId;
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));
      when(() => mockOrder.isPriceTracking).thenReturn(false);
      when(() => mockOrder.assetPair).thenReturn(AssetPair());

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test(
        'computes price from index price when isPriceTracking is true and index price is available',
        () {
      final testAssetId = 'test_asset';
      final mockAsset = Asset()..assetId = testAssetId;
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));
      when(() => mockOrder.isPriceTracking).thenReturn(true);
      when(() => mockOrder.assetPair).thenReturn(AssetPair());

      final indexPrice = Decimal.fromInt(50);
      final trackingValue = TrackingValue(trackingValue: 1.0);
      const expectedSatoshi = 5050;

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(expectedSatoshi);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(trackingValue),
          marketDecimalIndexPriceProvider.overrideWithValue(
            Some((
              decimalIndexPrice: indexPrice,
              quoteAsset: Some(mockAsset),
            )),
          ),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      // With trackingValue 1.0: asDecimalPercent() = 1 + (1.0/100) = 1.01
      // expectedAmount = 50 * 1.01 = 50.5
      final expectedAmount = Decimal.fromInt(50) * Decimal.parse('1.01');
      expect(result.amount, expectedAmount);
      expect(result.satoshi, expectedSatoshi);
      expect(result.assetId, testAssetId);
      expect(result.assetPair, AssetPair());

      verify(() => mockSatoshiRepository.satoshiForAmount(
            amount: expectedAmount.toString(),
            assetId: testAssetId,
          )).called(1);
    });

    test(
        'uses last price when index price is not available but last price is',
        () {
      final testAssetId = 'test_asset';
      final mockAsset = Asset()..assetId = testAssetId;
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));
      when(() => mockOrder.isPriceTracking).thenReturn(true);
      when(() => mockOrder.assetPair).thenReturn(AssetPair());

      final lastPrice = Decimal.fromInt(45);
      final trackingValue = TrackingValue(trackingValue: 1.0);
      const expectedSatoshi = 4545;

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(expectedSatoshi);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(trackingValue),
          marketDecimalIndexPriceProvider.overrideWithValue(None()),
          marketDecimalLastPriceProvider.overrideWithValue(
            Some((
              decimalLastPrice: lastPrice,
              quoteAsset: Some(mockAsset),
            )),
          ),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      // With trackingValue 1.0: asDecimalPercent() = 1 + (1.0/100) = 1.01
      // expectedAmount = 45 * 1.01 = 45.45
      final expectedAmount = Decimal.fromInt(45) * Decimal.parse('1.01');
      expect(result.amount, expectedAmount);
      expect(result.satoshi, expectedSatoshi);
      expect(result.assetId, testAssetId);

      verify(() => mockSatoshiRepository.satoshiForAmount(
            amount: expectedAmount.toString(),
            assetId: testAssetId,
          )).called(1);
    });

    test(
        'returns zero price when neither index price nor last price is available',
        () {
      final testAssetId = 'test_asset';
      final mockAsset = Asset()..assetId = testAssetId;
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));
      when(() => mockOrder.isPriceTracking).thenReturn(true);
      when(() => mockOrder.assetPair).thenReturn(AssetPair());

      final trackingValue = TrackingValue(trackingValue: 1.0);
      const expectedSatoshi = 0;

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(expectedSatoshi);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(trackingValue),
          marketDecimalIndexPriceProvider.overrideWithValue(None()),
          marketDecimalLastPriceProvider.overrideWithValue(None()),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.amount, Decimal.zero);
      expect(result.satoshi, expectedSatoshi);

      verify(() => mockSatoshiRepository.satoshiForAmount(
            amount: '0',
            assetId: testAssetId,
          )).called(1);
    });

    test('applies tracking value multiplier to computed price', () {
      final testAssetId = 'test_asset';
      final mockAsset = Asset()..assetId = testAssetId;
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));
      when(() => mockOrder.isPriceTracking).thenReturn(true);
      when(() => mockOrder.assetPair).thenReturn(AssetPair());

      final indexPrice = Decimal.fromInt(100);
      final trackingValue = TrackingValue(trackingValue: 0.8);
      const expectedSatoshi = 8000;

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(expectedSatoshi);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(trackingValue),
          marketDecimalIndexPriceProvider.overrideWithValue(
            Some((
              decimalIndexPrice: indexPrice,
              quoteAsset: Some(mockAsset),
            )),
          ),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      final expectedPrice =
          indexPrice * trackingValue.asDecimalPercent();

      expect(result.amount, expectedPrice);
      expect(result.satoshi, expectedSatoshi);

      verify(() => mockSatoshiRepository.satoshiForAmount(
            amount: expectedPrice.toString(),
            assetId: testAssetId,
          )).called(1);
    });

    test('preserves asset pair from order', () {
      final testAssetId = 'test_asset';
      final mockAsset = Asset()..assetId = testAssetId;
      final testAssetPair = AssetPair()
        ..base = 'BTC'
        ..quote = 'USD';
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.quoteAsset).thenReturn(Some(mockAsset));
      when(() => mockOrder.amountDecimal).thenReturn(Decimal.fromInt(100));
      when(() => mockOrder.isPriceTracking).thenReturn(true);
      when(() => mockOrder.assetPair).thenReturn(testAssetPair);

      final indexPrice = Decimal.fromInt(50);
      final trackingValue = TrackingValue(trackingValue: 1.0);
      const expectedSatoshi = 5000;

      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(expectedSatoshi);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          marketLimitTrackIndexPriceValueProvider
              .overrideWithValue(trackingValue),
          marketDecimalIndexPriceProvider.overrideWithValue(
            Some((
              decimalIndexPrice: indexPrice,
              quoteAsset: Some(mockAsset),
            )),
          ),
          satoshiRepositoryProvider
              .overrideWithValue(mockSatoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitEditOrderPriceProvider);

      expect(result.assetPair, testAssetPair);
      expect(result.assetPair.base, 'BTC');
      expect(result.assetPair.quote, 'USD');
    });

  });
}
