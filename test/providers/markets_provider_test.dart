import 'package:decimal/decimal.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/widgets.dart' show Locale, SizedBox;
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockUiOwnOrder extends Mock implements UiOwnOrder {}

class MockAbstractSatoshiRepository extends Mock
    implements AbstractSatoshiRepository {}

class MockAmountToString extends Mock implements AmountToString {}

class MockAbstractAssetImageRepository extends Mock
    implements AbstractAssetImageRepository {}

class MockSideswapWallet extends Mock implements SideswapWallet {}

class MockQuoteSuccess extends Mock implements QuoteSuccess {}

void main() {
  setUpAll(() {
    registerFallbackValue(AmountToStringParameters(amount: 0));
    registerFallbackValue(To());
    Localization.load(
      const Locale('en'),
      translations: Translations({
        'Stablecoins': 'Stablecoins',
        'AMP Listings': 'AMP Listings',
        'Token Market': 'Token Market',
        'Continue': 'Continue',
        'Unlock': 'Unlock',
      }),
    );
  });

  tearDownAll(() {
    // Reset Localization singleton to avoid bleeding into other test files
    Localization.load(const Locale('en'));
  });

  group('marketTypeName', () {

    test('returns Stablecoins for STABLECOIN', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(
        container.read(marketTypeNameProvider(MarketType_.STABLECOIN)),
        'Stablecoins',
      );
    });

    test('returns AMP Listings for AMP', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(
        container.read(marketTypeNameProvider(MarketType_.AMP)),
        'AMP Listings',
      );
    });

    test('returns Token Market for TOKEN', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(
        container.read(marketTypeNameProvider(MarketType_.TOKEN)),
        'Token Market',
      );
    });
  });

  group('assetMarketType', () {
    test('returns STABLECOIN when asset.swapMarket is true', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(swapMarket: true, ampMarket: false);
      final result = container.read(assetMarketTypeProvider(asset));
      expect(result, MarketType_.STABLECOIN);
    });

    test('returns AMP when asset.ampMarket is true', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(swapMarket: false, ampMarket: true);
      final result = container.read(assetMarketTypeProvider(asset));
      expect(result, MarketType_.AMP);
    });

    test('returns TOKEN when asset is null', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(assetMarketTypeProvider(null));
      expect(result, MarketType_.TOKEN);
    });

    test('returns TOKEN when neither swapMarket nor ampMarket is true', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(swapMarket: false, ampMarket: false);
      final result = container.read(assetMarketTypeProvider(asset));
      expect(result, MarketType_.TOKEN);
    });
  });

  group('TradeDirStateNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is BUY', () {
      expect(container.read(tradeDirStateProvider), TradeDir.BUY);
    });

    test('setSide updates state', () {
      container.read(tradeDirStateProvider.notifier).setSide(TradeDir.SELL);
      expect(container.read(tradeDirStateProvider), TradeDir.SELL);
    });

  });

  group('MarketsNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty list', () {
      expect(container.read(marketsProvider), []);
    });

    test('setState replaces entire list', () {
      final markets = [
        MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD')),
        MarketInfo(assetPair: AssetPair(base: 'ETH', quote: 'USD')),
      ];
      container.read(marketsProvider.notifier).setState(markets);
      expect(container.read(marketsProvider), markets);
    });

    test('addMarketInfo appends to list', () {
      final market1 = MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD'));
      final market2 = MarketInfo(assetPair: AssetPair(base: 'ETH', quote: 'USD'));

      container.read(marketsProvider.notifier).addMarketInfo(market1);
      container.read(marketsProvider.notifier).addMarketInfo(market2);

      expect(container.read(marketsProvider), [market1, market2]);
    });

    test('removeAssetPair removes matching market by assetPair', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final otherAssetPair = AssetPair(base: 'ETH', quote: 'USD');
      final market1 = MarketInfo(assetPair: assetPair);
      final market2 = MarketInfo(assetPair: otherAssetPair);

      container.read(marketsProvider.notifier).setState([market1, market2]);
      container.read(marketsProvider.notifier).removeAssetPair(assetPair);

      expect(container.read(marketsProvider), [market2]);
    });

    test('removeAssetPair does nothing if assetPair not found', () {
      final market = MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD'));
      container.read(marketsProvider.notifier).addMarketInfo(market);

      final nonExistentAssetPair = AssetPair(base: 'XYZ', quote: 'USD');
      container.read(marketsProvider.notifier).removeAssetPair(nonExistentAssetPair);

      expect(container.read(marketsProvider), [market]);
    });
  });

  group('marketInfoByMarketType', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns empty list when no markets present', () {
      final result = container.read(
        marketInfoByMarketTypeProvider(MarketType_.STABLECOIN),
      );
      expect(result, []);
    });

    test('filters markets by type STABLECOIN', () {
      final stableMarket = MarketInfo(
        type: MarketType_.STABLECOIN,
        assetPair: AssetPair(base: 'USDT', quote: 'USD'),
      );
      final ampMarket = MarketInfo(
        type: MarketType_.AMP,
        assetPair: AssetPair(base: 'AMP', quote: 'USD'),
      );
      final tokenMarket = MarketInfo(
        type: MarketType_.TOKEN,
        assetPair: AssetPair(base: 'ETH', quote: 'USD'),
      );

      container
          .read(marketsProvider.notifier)
          .setState([stableMarket, ampMarket, tokenMarket]);

      final result = container.read(
        marketInfoByMarketTypeProvider(MarketType_.STABLECOIN),
      );
      expect(result, [stableMarket]);
    });

    test('filters markets by type AMP', () {
      final stableMarket = MarketInfo(
        type: MarketType_.STABLECOIN,
        assetPair: AssetPair(base: 'USDT', quote: 'USD'),
      );
      final ampMarket = MarketInfo(
        type: MarketType_.AMP,
        assetPair: AssetPair(base: 'AMP', quote: 'USD'),
      );

      container.read(marketsProvider.notifier).setState([stableMarket, ampMarket]);

      final result = container.read(
        marketInfoByMarketTypeProvider(MarketType_.AMP),
      );
      expect(result, [ampMarket]);
    });

    test('filters markets by type TOKEN', () {
      final ampMarket = MarketInfo(
        type: MarketType_.AMP,
        assetPair: AssetPair(base: 'AMP', quote: 'USD'),
      );
      final tokenMarket = MarketInfo(
        type: MarketType_.TOKEN,
        assetPair: AssetPair(base: 'ETH', quote: 'USD'),
      );

      container.read(marketsProvider.notifier).setState([ampMarket, tokenMarket]);

      final result = container.read(
        marketInfoByMarketTypeProvider(MarketType_.TOKEN),
      );
      expect(result, [tokenMarket]);
    });
  });

  group('stableMarkets', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns STABLECOIN markets', () {
      final stableMarket = MarketInfo(
        type: MarketType_.STABLECOIN,
        assetPair: AssetPair(base: 'USDT', quote: 'USD'),
      );
      final otherMarket = MarketInfo(
        type: MarketType_.TOKEN,
        assetPair: AssetPair(base: 'ETH', quote: 'USD'),
      );

      container.read(marketsProvider.notifier).setState([stableMarket, otherMarket]);

      final result = container.read(stableMarketsProvider);
      expect(result, [stableMarket]);
    });

    test('returns empty list when no stable markets', () {
      final tokenMarket = MarketInfo(
        type: MarketType_.TOKEN,
        assetPair: AssetPair(base: 'ETH', quote: 'USD'),
      );
      container.read(marketsProvider.notifier).setState([tokenMarket]);

      final result = container.read(stableMarketsProvider);
      expect(result, []);
    });
  });

  group('MarketSideStateNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is base', () {
      expect(container.read(marketSideStateProvider), MarketSideState.base());
    });

    test('setState updates to quote', () {
      container
          .read(marketSideStateProvider.notifier)
          .setState(MarketSideState.quote());
      expect(container.read(marketSideStateProvider), MarketSideState.quote());
    });

  });

  group('MarketTypeSwitchStateNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is limit', () {
      expect(
        container.read(marketTypeSwitchStateProvider),
        MarketTypeSwitchState.limit(),
      );
    });

    test('setState updates to market', () {
      container
          .read(marketTypeSwitchStateProvider.notifier)
          .setState(MarketTypeSwitchState.market());
      expect(
        container.read(marketTypeSwitchStateProvider),
        MarketTypeSwitchState.market(),
      );
    });

  });

  group('OrderAmount', () {
    test('asString returns decimal as string', () {
      final amount = OrderAmount(
        amount: Decimal.parse('123.456'),
        satoshi: 12345600,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount.asString(), '123.456');
    });

    test('asDouble returns decimal as double', () {
      final amount = OrderAmount(
        amount: Decimal.parse('123.456'),
        satoshi: 12345600,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount.asDouble(), 123.456);
    });

    test('asSatoshi returns satoshi value', () {
      final amount = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount.asSatoshi(), 150000000);
    });

    test('equality based on all fields', () {
      final amount1 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final amount2 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount1, amount2);
    });

    test('inequality when amount differs', () {
      final amount1 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final amount2 = OrderAmount(
        amount: Decimal.parse('2.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount1, isNot(amount2));
    });

    test('inequality when satoshi differs', () {
      final amount1 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final amount2 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 250000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount1, isNot(amount2));
    });

    test('inequality when assetId differs', () {
      final amount1 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final amount2 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'eth',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount1, isNot(amount2));
    });

    test('inequality when assetPair differs', () {
      final amount1 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final amount2 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'ETH', quote: 'USD'),
      );
      expect(amount1, isNot(amount2));
    });

    test('copyWith updates specific fields', () {
      final original = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final modified = original.copyWith(assetId: 'eth');
      expect(modified.amount, original.amount);
      expect(modified.satoshi, original.satoshi);
      expect(modified.assetId, 'eth');
      expect(modified.assetPair, original.assetPair);
    });

    test('hash code consistent with equality', () {
      final amount1 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final amount2 = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      expect(amount1.hashCode, amount2.hashCode);
    });

    test('toString returns expected format', () {
      final amount = OrderAmount(
        amount: Decimal.parse('1.5'),
        satoshi: 150000000,
        assetId: 'btc',
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
      );
      final result = amount.toString();

      expect(
        result,
        contains('OrderAmount(amount: 1.5, satoshi: 150000000, assetId: btc'),
      );
    });
  });

  group('MarketOrderAmountControllerNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty string', () {
      expect(container.read(marketOrderAmountControllerProvider), '');
    });

    test('setState updates state', () {
      container
          .read(marketOrderAmountControllerProvider.notifier)
          .setState('100.5');
      expect(container.read(marketOrderAmountControllerProvider), '100.5');
    });

    test('setState with zero amount', () {
      container
          .read(marketOrderAmountControllerProvider.notifier)
          .setState('0');
      expect(container.read(marketOrderAmountControllerProvider), '0');
    });
  });

  group('marketOrderAmount', () {
    test('returns zero OrderAmount when no subscribed pair', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final result = container.read(marketOrderAmountProvider);
      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test('returns zero OrderAmount when amount string empty', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockRepo = MockAbstractSatoshiRepository();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketOrderAmountProvider);
      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, 'BTC');
      expect(result.assetPair, assetPair);
    });

    test('returns OrderAmount with parsed amount and satoshi', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockRepo = MockAbstractSatoshiRepository();
      when(
        () => mockRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(150000000);
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketOrderAmountControllerProvider.overrideWithValue('1.5'),
          satoshiRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketOrderAmountProvider);
      expect(result.amount, Decimal.parse('1.5'));
      expect(result.satoshi, 150000000);
      expect(result.assetId, 'BTC');
    });

    test('uses quote assetId when side is not Base', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockRepo = MockAbstractSatoshiRepository();
      when(
        () => mockRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(100);
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketOrderAmountControllerProvider.overrideWithValue('1.0'),
          marketSideStateProvider.overrideWithValue(MarketSideState.quote()),
          satoshiRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketOrderAmountProvider);
      expect(result.assetId, 'USD');
    });
  });

  group('marketOrderTradeButtonEnabled', () {
    test('returns false when no quote success', () {
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteSuccessProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketOrderTradeButtonEnabledProvider);
      expect(result, false);
    });

    test('returns false when amount is zero', () {
      final mockAmountToString = MockAmountToString();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('0');
      final quoteSuccess = QuoteSuccess(
        mockAmountToString,
        From_Quote_Success(),
        AssetPair(base: 'BTC', quote: 'USD'),
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteSuccessProvider.overrideWithValue(
            Option.of(quoteSuccess),
          ),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'BTC',
              assetPair: AssetPair(base: 'BTC', quote: 'USD'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketOrderTradeButtonEnabledProvider);
      expect(result, false);
    });

    test('returns true when quote success and amount > 0', () {
      final mockAmountToString = MockAmountToString();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('1.5');
      final quoteSuccess = QuoteSuccess(
        mockAmountToString,
        From_Quote_Success(),
        AssetPair(base: 'BTC', quote: 'USD'),
        AssetType.BASE,
        TradeDir.SELL,
        AssetType.BASE,
        {},
        1,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteSuccessProvider.overrideWithValue(
            Option.of(quoteSuccess),
          ),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.5'),
              satoshi: 150000000,
              assetId: 'BTC',
              assetPair: AssetPair(base: 'BTC', quote: 'USD'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketOrderTradeButtonEnabledProvider);
      expect(result, true);
    });
  });

  group('MarketOrderAggregateVolumeProvider class', () {
    test('asString with precision 0', () {
      final provider = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('100'),
        price: Decimal.parse('50000'),
        precision: 0,
      );
      final result = provider.asString();
      expect(result, '500000000000000');
    });

    test('asString with non-zero precision', () {
      final provider = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000.5'),
        precision: 8,
      );
      final result = provider.asString();
      expect(result, '75000.75000000');
    });

    test('asDouble returns valid double', () {
      final provider = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      final result = provider.asDouble();
      expect(result, 75000.0);
    });

    test('asDecimal calculation', () {
      final provider = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1'),
        price: Decimal.parse('1'),
        precision: 0,
      );
      final result = provider.asDecimal();
      expect(result, Decimal.parse('100000000'));
    });

    test('equality based on all fields', () {
      final provider1 = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      final provider2 = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      expect(provider1, provider2);
    });

    test('inequality when amount differs', () {
      final provider1 = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      final provider2 = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('2.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      expect(provider1, isNot(provider2));
    });

    test('copyWith updates specific fields', () {
      final original = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      final modified = original.copyWith(amount: Decimal.parse('2.5'));
      expect(modified.amount, Decimal.parse('2.5'));
      expect(modified.price, original.price);
      expect(modified.precision, original.precision);
    });

    test('hash code consistent with equality', () {
      final provider1 = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      final provider2 = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      expect(provider1.hashCode, provider2.hashCode);
    });

    test('toString returns expected format', () {
      final provider = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1.5'),
        price: Decimal.parse('50000'),
        precision: 8,
      );
      final result = provider.toString();
      expect(result, 'MarketOrderAggregateVolumeProvider(amount: 1.5, price: 50000, precision: 8)');
    });
  });

  group('LimitTtlFlag', () {
    final flagCases = [
      (flag: LimitTtlFlag.oneHour(), seconds: Int64(3600), desc: '1h'),
      (flag: LimitTtlFlag.sixHours(), seconds: Int64(21600), desc: '6h'),
      (flag: LimitTtlFlag.twelveHours(), seconds: Int64(43200), desc: '12h'),
      (flag: LimitTtlFlag.twentyFourHours(), seconds: Int64(86400), desc: '24h'),
      (flag: LimitTtlFlag.threeDays(), seconds: Int64(259200), desc: '1d'),
      (flag: LimitTtlFlag.oneWeek(), seconds: Int64(604800), desc: '7d'),
      (flag: LimitTtlFlag.oneMonth(), seconds: Int64(2592000), desc: '30d'),
    ];

    for (final tc in flagCases) {
      test('${tc.desc} seconds returns ${tc.seconds}', () {
        expect(tc.flag.seconds(), tc.seconds);
      });
      test('${tc.desc} description returns ${tc.desc}', () {
        expect(tc.flag.description(), tc.desc);
      });
    }

    test('unlimited seconds returns null', () {
      final flag = LimitTtlFlag.unlimited();
      expect(flag.seconds(), null);
    });

    test('unlimited description returns Unlimited', () {
      final flag = LimitTtlFlag.unlimited();
      expect(flag.description(), 'Unlimited');
    });
  });

  group('LimitTtlFlagNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is unlimited', () {
      expect(
        container.read(limitTtlFlagProvider),
        LimitTtlFlag.unlimited(),
      );
    });

    final allFlags = [
      LimitTtlFlag.oneHour(),
      LimitTtlFlag.sixHours(),
      LimitTtlFlag.twelveHours(),
      LimitTtlFlag.twentyFourHours(),
      LimitTtlFlag.threeDays(),
      LimitTtlFlag.oneWeek(),
      LimitTtlFlag.oneMonth(),
    ];

    for (final flag in allFlags) {
      test('setState updates to $flag', () {
        container
            .read(limitTtlFlagProvider.notifier)
            .setState(flag);
        expect(container.read(limitTtlFlagProvider), flag);
      });
    }
  });

  group('LimitOrderAmountControllerNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty string', () {
      expect(container.read(limitOrderAmountControllerProvider), '');
    });

    test('setState updates state', () {
      container
          .read(limitOrderAmountControllerProvider.notifier)
          .setState('100.5');
      expect(container.read(limitOrderAmountControllerProvider), '100.5');
    });
  });

  group('LimitOrderPriceControllerNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty string', () {
      expect(container.read(limitOrderPriceControllerProvider), '');
    });

    test('setState updates state', () {
      container
          .read(limitOrderPriceControllerProvider.notifier)
          .setState('50000.5');
      expect(container.read(limitOrderPriceControllerProvider), '50000.5');
    });
  });

  group('MarketEditOrderAmountControllerNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty string', () {
      expect(container.read(marketEditOrderAmountControllerProvider), '');
    });

    test('setState updates state', () {
      container
          .read(marketEditOrderAmountControllerProvider.notifier)
          .setState('50.25');
      expect(container.read(marketEditOrderAmountControllerProvider), '50.25');
    });
  });

  group('MarketEditOrderPriceControllerNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty string', () {
      expect(container.read(marketEditOrderPriceControllerProvider), '');
    });

    test('setState updates state', () {
      container
          .read(marketEditOrderPriceControllerProvider.notifier)
          .setState('60000.75');
      expect(container.read(marketEditOrderPriceControllerProvider), '60000.75');
    });
  });

  group('OrderSubmitNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(orderSubmitProvider);
      expect(state, Option.none());
    });

    test('setState wraps value in Option', () {
      final orderSubmit = From_OrderSubmit();
      container
          .read(orderSubmitProvider.notifier)
          .setState(orderSubmit);
      final state = container.read(orderSubmitProvider);
      expect(state, Option.of(orderSubmit));
    });
  });

  group('OrderSubmitSuccessNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(orderSubmitSuccessProvider);
      expect(state.isNone(), true);
    });

    test('setState sets state to Some(order)', () {
      final orderId = OrderId(id: Int64(123));
      final order = MockUiOwnOrder();
      when(() => order.orderId).thenReturn(orderId);

      container.read(orderSubmitSuccessProvider.notifier).setState(order);
      final state = container.read(orderSubmitSuccessProvider);

      expect(state.isSome(), true);
      expect(state.getOrElse(() => MockUiOwnOrder()), order);
    });

    test('setState skips if orderId matches', () {
      final orderId = OrderId(id: Int64(123));
      final order1 = MockUiOwnOrder();
      when(() => order1.orderId).thenReturn(orderId);
      final order2 = MockUiOwnOrder();
      when(() => order2.orderId).thenReturn(orderId);

      container.read(orderSubmitSuccessProvider.notifier).setState(order1);
      final stateAfterFirst = container.read(orderSubmitSuccessProvider);

      container.read(orderSubmitSuccessProvider.notifier).setState(order2);
      final stateAfterSecond = container.read(orderSubmitSuccessProvider);

      // Second setState should not update state (returns early)
      expect(stateAfterFirst, stateAfterSecond);
    });

    test('setState updates if orderId differs', () {
      final orderId1 = OrderId(id: Int64(123));
      final orderId2 = OrderId(id: Int64(456));
      final order1 = MockUiOwnOrder();
      when(() => order1.orderId).thenReturn(orderId1);
      final order2 = MockUiOwnOrder();
      when(() => order2.orderId).thenReturn(orderId2);

      container.read(orderSubmitSuccessProvider.notifier).setState(order1);
      final stateAfterFirst = container.read(orderSubmitSuccessProvider);

      container.read(orderSubmitSuccessProvider.notifier).setState(order2);
      final stateAfterSecond = container.read(orderSubmitSuccessProvider);

      // State should change when orderId differs
      expect(stateAfterFirst.getOrElse(() => MockUiOwnOrder()), order1);
      expect(stateAfterSecond.getOrElse(() => MockUiOwnOrder()), order2);
      expect(stateAfterFirst, isNot(stateAfterSecond));
    });
  });

  group('OrderSubmitErrorNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(orderSubmitErrorProvider);
      expect(state, Option.none());
    });

    test('setState wraps error message in Option', () {
      container
          .read(orderSubmitErrorProvider.notifier)
          .setState('Error message');
      final state = container.read(orderSubmitErrorProvider);
      expect(state, Option.of('Error message'));
    });
  });

  group('OrderSubmitUnregisteredGaidNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(orderSubmitUnregisteredGaidProvider);
      expect(state, Option.none());
    });

    test('setState wraps domain agent in Option', () {
      container
          .read(orderSubmitUnregisteredGaidProvider.notifier)
          .setState('domain.agent');
      final state = container.read(orderSubmitUnregisteredGaidProvider);
      expect(state, Option.of('domain.agent'));
    });
  });

  group('MarketEditOrderErrorNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(marketEditOrderErrorProvider);
      expect(state, Option.none());
    });

    test('setState wraps error message in Option', () {
      container
          .read(marketEditOrderErrorProvider.notifier)
          .setState('Edit failed');
      final state = container.read(marketEditOrderErrorProvider);
      expect(state, Option.of('Edit failed'));
    });
  });

  group('MarketEditDetailsOrderNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(marketEditDetailsOrderProvider);
      expect(state.isNone(), true);
    });

    test('setState sets state when not offline twoStep', () {
      final order = MockUiOwnOrder();
      when(() => order.offlineSwapType).thenReturn(OfflineSwapType.empty());

      container.read(marketEditDetailsOrderProvider.notifier).setState(order);
      final state = container.read(marketEditDetailsOrderProvider);

      expect(state.isSome(), true);
      expect(state.getOrElse(() => MockUiOwnOrder()), order);
    });

    test('setState throws MarketEditDetailsOfflineOrderException when offlineSwapType is twoStep', () {
      final order = MockUiOwnOrder();
      when(() => order.offlineSwapType).thenReturn(OfflineSwapType.twoStep());

      expect(
        () => container.read(marketEditDetailsOrderProvider.notifier).setState(order),
        throwsA(isA<MarketEditDetailsOfflineOrderException>()),
      );
    });
  });

  group('MarketEditDetailsOfflineOrderException', () {
    test('toString returns message', () {
      const message = 'Offline order cant be edited';
      final exception = MarketEditDetailsOfflineOrderException(message);
      expect(exception.toString(), message);
    });

    test('constructor stores message', () {
      const message = 'Test error message';
      final exception = MarketEditDetailsOfflineOrderException(message);
      expect(exception.message, message);
    });
  });

  group('MarketHistoryTotal', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is zero', () {
      expect(container.read(marketHistoryTotalProvider), 0);
    });

    test('setState updates total', () {
      container.read(marketHistoryTotalProvider.notifier).setState(42);
      expect(container.read(marketHistoryTotalProvider), 42);
    });
  });

  group('MarketHistoryOrderNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty list', () {
      expect(container.read(marketHistoryOrderProvider), []);
    });

    test('loadHistory adds new orders', () {
      final order1 = HistoryOrder(id: Int64(1));
      final order2 = HistoryOrder(id: Int64(2));
      final loadHistory = From_LoadHistory(list: [order1, order2]);

      container.read(marketHistoryOrderProvider.notifier).loadHistory(loadHistory);

      final state = container.read(marketHistoryOrderProvider);
      expect(state.length, 2);
      expect(state[0].id, Int64(1));
      expect(state[1].id, Int64(2));
    });

    test('loadHistory updates existing orders by id', () {
      final original = HistoryOrder(id: Int64(1));
      final loadHistory1 = From_LoadHistory(list: [original]);
      container
          .read(marketHistoryOrderProvider.notifier)
          .loadHistory(loadHistory1);

      final updated = HistoryOrder(id: Int64(1));
      final loadHistory2 = From_LoadHistory(list: [updated]);
      container
          .read(marketHistoryOrderProvider.notifier)
          .loadHistory(loadHistory2);

      final state = container.read(marketHistoryOrderProvider);
      expect(state.length, 1);
      expect(state[0].id, Int64(1));
    });

    test('loadHistory adds new and updates existing in same call', () {
      final existing = HistoryOrder(id: Int64(1));
      final loadHistory1 = From_LoadHistory(list: [existing]);
      container
          .read(marketHistoryOrderProvider.notifier)
          .loadHistory(loadHistory1);

      final updatedExisting = HistoryOrder(id: Int64(1));
      final newOrder = HistoryOrder(id: Int64(2));
      final loadHistory2 = From_LoadHistory(list: [updatedExisting, newOrder]);
      container
          .read(marketHistoryOrderProvider.notifier)
          .loadHistory(loadHistory2);

      final state = container.read(marketHistoryOrderProvider);
      expect(state.length, 2);
    });

    test('historyUpdated adds new order when not found', () {
      final order = HistoryOrder(id: Int64(42));
      final historyUpdated = From_HistoryUpdated(order: order);

      container
          .read(marketHistoryOrderProvider.notifier)
          .historyUpdated(historyUpdated);

      final state = container.read(marketHistoryOrderProvider);
      expect(state.length, 1);
      expect(state[0].id, Int64(42));
    });

    test('historyUpdated updates existing order by id', () {
      final original = HistoryOrder(id: Int64(10));
      final loadHistory = From_LoadHistory(list: [original]);
      container
          .read(marketHistoryOrderProvider.notifier)
          .loadHistory(loadHistory);

      final updated = HistoryOrder(id: Int64(10));
      final historyUpdated = From_HistoryUpdated(order: updated);
      container
          .read(marketHistoryOrderProvider.notifier)
          .historyUpdated(historyUpdated);

      final state = container.read(marketHistoryOrderProvider);
      expect(state.length, 1);
      expect(state[0].id, Int64(10));
    });
  });

  group('MarketLimitOrderTypeNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is public', () {
      expect(
        container.read(marketLimitOrderTypeProvider),
        OrderType.public(),
      );
    });

    test('setState updates to private', () {
      container
          .read(marketLimitOrderTypeProvider.notifier)
          .setState(OrderType.private());
      expect(
        container.read(marketLimitOrderTypeProvider),
        OrderType.private(),
      );
    });

    test('setState updates to public', () {
      container
          .read(marketLimitOrderTypeProvider.notifier)
          .setState(OrderType.private());
      container
          .read(marketLimitOrderTypeProvider.notifier)
          .setState(OrderType.public());
      expect(
        container.read(marketLimitOrderTypeProvider),
        OrderType.public(),
      );
    });
  });

  group('MarketStartOrderNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(marketStartOrderProvider);
      expect(state, Option.none());
    });

    test('setState wraps value in Option', () {
      final startOrder = From_StartOrder();
      container.read(marketStartOrderProvider.notifier).setState(startOrder);
      final state = container.read(marketStartOrderProvider);
      expect(state.isSome(), true);
    });
  });

  group('MarketStartOrderErrorNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(marketStartOrderErrorProvider);
      expect(state, Option.none());
    });

    test('setState wraps error in Option', () {
      final error = StartOrderError(error: 'Test error', orderId: 123);
      container
          .read(marketStartOrderErrorProvider.notifier)
          .setState(error);
      final state = container.read(marketStartOrderErrorProvider);
      expect(state, Option.of(error));
    });
  });

  group('addressToShareByOrder', () {
    test('returns URL with privateId for private order', () {
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.orderType).thenReturn(const OrderTypePrivate());
      when(() => mockOrder.orderId).thenReturn(OrderId(id: Int64(42)));
      when(() => mockOrder.privateId).thenReturn('secret123');
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        addressToShareByOrderProvider(mockOrder),
      );
      expect(result, 'https://app.sideswap.io/swap/?order_id=42&private_id=secret123');
    });

    test('returns URL without privateId for public order', () {
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.orderType).thenReturn(const OrderTypePublic());
      when(() => mockOrder.orderId).thenReturn(OrderId(id: Int64(42)));
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        addressToShareByOrderProvider(mockOrder),
      );
      expect(result, 'https://app.sideswap.io/swap/?order_id=42');
    });
  });

  group('IndexPriceButtonAsyncNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is loading', () {
      final state = container.read(indexPriceButtonAsyncProvider);
      expect(state, isA<AsyncLoading<String>>());
    });

    test('setIndexPrice updates state to data', () {
      container
          .read(indexPriceButtonAsyncProvider.notifier)
          .setIndexPrice('12345.67');
      final state = container.read(indexPriceButtonAsyncProvider);
      expect(state.maybeMap(data: (d) => d.value, orElse: () => null), '12345.67');
    });
  });

  group('MarketPublicOrdersNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty map', () {
      expect(container.read(marketPublicOrdersProvider), {});
    });

    test('setOrders adds new assetPair with orders', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final order = PublicOrder();

      container
          .read(marketPublicOrdersProvider.notifier)
          .setOrders(assetPair, [order]);

      final state = container.read(marketPublicOrdersProvider);
      expect(state[assetPair]!.length, 1);
    });

    test('setOrders replaces existing orders for assetPair', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final order1 = PublicOrder();
      final order2 = PublicOrder();

      container
          .read(marketPublicOrdersProvider.notifier)
          .setOrders(assetPair, [order1]);

      container
          .read(marketPublicOrdersProvider.notifier)
          .setOrders(assetPair, [order2]);

      final state = container.read(marketPublicOrdersProvider);
      expect(state[assetPair]!.length, 1);
    });

    test('setOrders with multiple orders adds all', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orders = [PublicOrder(), PublicOrder()];

      container
          .read(marketPublicOrdersProvider.notifier)
          .setOrders(assetPair, orders);

      final state = container.read(marketPublicOrdersProvider);
      expect(state[assetPair]!.length, 2);
    });

    test('orderCreated adds new order when not found', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId(id: Int64(1));
      final order = PublicOrder(assetPair: assetPair, orderId: orderId);

      container.read(marketPublicOrdersProvider.notifier).orderCreated(order);

      final state = container.read(marketPublicOrdersProvider);
      expect(state[assetPair]!.length, 1);
      expect(state[assetPair]![0].orderId, orderId);
    });

    test('orderCreated updates existing order by orderId', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId(id: Int64(1));
      final order1 = PublicOrder(assetPair: assetPair, orderId: orderId);
      final order2 = PublicOrder(assetPair: assetPair, orderId: orderId);

      container.read(marketPublicOrdersProvider.notifier).orderCreated(order1);
      container.read(marketPublicOrdersProvider.notifier).orderCreated(order2);

      final state = container.read(marketPublicOrdersProvider);
      // Still only 1 order since same orderId → update branch
      expect(state[assetPair]!.length, 1);
    });

    test('removeOrder removes order from state', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final order = PublicOrder();

      container
          .read(marketPublicOrdersProvider.notifier)
          .setOrders(assetPair, [order]);

      final orderId = OrderId();
      container
          .read(marketPublicOrdersProvider.notifier)
          .removeOrder(orderId);

      final state = container.read(marketPublicOrdersProvider);
      expect(state[assetPair], isEmpty);
    });

    test('marketSubscribe sends subscribe message via wallet', () {
      final mockWallet = MockSideswapWallet();
      final c = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(c.dispose);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      c.read(marketPublicOrdersProvider.notifier).marketSubscribe(assetPair);

      final captured = verify(() => mockWallet.sendMsg(captureAny())).captured;
      expect(captured, hasLength(1));
      expect((captured.single as To).hasMarketSubscribe(), true);
    });

    test('marketUnsubscribe sends unsubscribe message via wallet', () {
      final mockWallet = MockSideswapWallet();
      final c = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(c.dispose);

      c.read(marketPublicOrdersProvider.notifier).marketUnsubscribe();

      final captured = verify(() => mockWallet.sendMsg(captureAny())).captured.single as To;
      expect(captured.hasMarketUnsubscribe(), true);
    });

    test('build listener calls marketSubscribe when asset pair changes', () {
      final mockWallet = MockSideswapWallet();
      final c = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(c.dispose);

      // Initialize notifier — triggers build with ref.listen
      c.read(marketPublicOrdersProvider.notifier);

      // Mutate upstream to trigger listener
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      c.read(marketSubscribedAssetPairProvider.notifier).setState(assetPair);

      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('build listener None branch is no-op when asset pair changes to None', () {
      final mockWallet = MockSideswapWallet();
      final c = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(c.dispose);

      c.read(marketPublicOrdersProvider.notifier);

      // Set Some first to establish a change baseline
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      c.read(marketSubscribedAssetPairProvider.notifier).setState(assetPair);
      clearInteractions(mockWallet);

      // Set back to None — triggers the None branch (() => () {})
      c.read(marketSubscribedAssetPairProvider.notifier).state = Option.none();

      // None branch is a no-op; wallet should not be called
      verifyNever(() => mockWallet.sendMsg(any()));
      // Provider state unchanged
      expect(c.read(marketPublicOrdersProvider), isEmpty);
    });
  });

  group('DebouncedMarketPublicOrders', () {
    test('build returns empty map initially', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(debouncedMarketPublicOrdersProvider);
      expect(result, isEmpty);
    });

    test('upstream marketPublicOrders changes trigger stream sink', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      // Initialize both providers
      container.read(debouncedMarketPublicOrdersProvider);
      container.read(marketPublicOrdersProvider);

      // Upstream change adds to stream sink via ref.listen
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final order = PublicOrder(assetPair: assetPair);
      // Setting orders updates upstream, which ref.listen picks up
      container.read(marketPublicOrdersProvider.notifier).setOrders(assetPair, [order]);

      // Upstream state is updated synchronously
      final upstream = container.read(marketPublicOrdersProvider);
      expect(upstream.containsKey(assetPair), true);
      expect(upstream[assetPair]!.length, 1);
    });

    test('dispose closes stream without error', () {
      final container = ProviderContainer.test();
      // Initialize the provider
      container.read(debouncedMarketPublicOrdersProvider);
      // Disposing should not throw
      expect(() => container.dispose(), returnsNormally);
    });
  });

  group('MarketOwnOrdersNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty list', () {
      expect(container.read(marketOwnOrdersProvider), []);
    });

    test('setState replaces entire list', () {
      final order1 = OwnOrder();
      final order2 = OwnOrder();

      container
          .read(marketOwnOrdersProvider.notifier)
          .setState([order1, order2]);

      expect(container.read(marketOwnOrdersProvider).length, 2);
    });

    test('setState clears list when given empty list', () {
      final order1 = OwnOrder();

      container
          .read(marketOwnOrdersProvider.notifier)
          .setState([order1]);
      expect(container.read(marketOwnOrdersProvider).length, 1);

      container
          .read(marketOwnOrdersProvider.notifier)
          .setState([]);

      expect(container.read(marketOwnOrdersProvider).length, 0);
    });

    test('orderCreated adds new order when orderId not found', () {
      final orderId = OrderId(id: Int64(100));
      final order = OwnOrder(orderId: orderId);

      container.read(marketOwnOrdersProvider.notifier).orderCreated(order);

      final state = container.read(marketOwnOrdersProvider);
      expect(state.length, 1);
      expect(state[0].orderId, orderId);
    });

    test('orderCreated updates existing order when orderId matches', () {
      final orderId = OrderId(id: Int64(100));
      final order1 = OwnOrder(orderId: orderId);
      final order2 = OwnOrder(orderId: orderId);

      container.read(marketOwnOrdersProvider.notifier).orderCreated(order1);
      container.read(marketOwnOrdersProvider.notifier).orderCreated(order2);

      // Update branch: still 1 order, replaced in place
      final state = container.read(marketOwnOrdersProvider);
      expect(state.length, 1);
      expect(state[0].orderId, orderId);
    });

    test('removeOrder removes order from state', () {
      final order = OwnOrder();

      container
          .read(marketOwnOrdersProvider.notifier)
          .setState([order]);

      final orderId = OrderId();
      container
          .read(marketOwnOrdersProvider.notifier)
          .removeOrder(orderId);

      final state = container.read(marketOwnOrdersProvider);
      expect(state, isEmpty);
    });

    test('removeOrder handles empty list gracefully', () {
      container
          .read(marketOwnOrdersProvider.notifier)
          .setState([]);

      final orderId = OrderId();
      container
          .read(marketOwnOrdersProvider.notifier)
          .removeOrder(orderId);

      expect(container.read(marketOwnOrdersProvider).length, 0);
    });
  });

  group('marketUiOwnOrders', () {
    test('returns empty list when no own orders', () {
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      final container = ProviderContainer.test(
        overrides: [
          marketOwnOrdersProvider.overrideWithValue([]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketUiOwnOrdersProvider);
      expect(result, isEmpty);
    });

    test('returns mapped UiOwnOrder list when orders exist', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId(id: Int64(1));
      final order = OwnOrder(orderId: orderId, assetPair: assetPair);
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('0');
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);
      final container = ProviderContainer.test(
        overrides: [
          marketOwnOrdersProvider.overrideWithValue([order]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketUiOwnOrdersProvider);
      expect(result.length, 1);
      expect(result.first.orderId, orderId);
    });

    test('uses assetMarketType when quote asset exists in assetsState', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId(id: Int64(1));
      final order = OwnOrder(orderId: orderId, assetPair: assetPair);
      final quoteAsset = Asset(assetId: 'USD', precision: 2);
      quoteAsset.freeze();
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('0');
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);
      final container = ProviderContainer.test(
        overrides: [
          marketOwnOrdersProvider.overrideWithValue([order]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({'USD': quoteAsset}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketUiOwnOrdersProvider);
      expect(result.length, 1);
      expect(result.first.orderId, orderId);
    });

    test('marketUiOwnOrderById returns Some when order found', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId(id: Int64(42));
      final order = OwnOrder(orderId: orderId, assetPair: assetPair);
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('0');
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);
      final container = ProviderContainer.test(
        overrides: [
          marketOwnOrdersProvider.overrideWithValue([order]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketUiOwnOrderByIdProvider(orderId));
      expect(result.isSome(), true);
    });

    test('marketUiOwnOrderById returns None when order not found', () {
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      final container = ProviderContainer.test(
        overrides: [
          marketOwnOrdersProvider.overrideWithValue([]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);
      final missingId = OrderId(id: Int64(99));
      final result = container.read(marketUiOwnOrderByIdProvider(missingId));
      expect(result.isNone(), true);
    });
  });

  group('MarketSubscribedAssetPairNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is none', () {
      final state = container.read(marketSubscribedAssetPairProvider);
      expect(state.isNone(), true);
    });

    test('setState wraps assetPair in Option.some', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      final state = container.read(marketSubscribedAssetPairProvider);
      expect(state.isSome(), true);
      expect(state.getOrElse(() => AssetPair()), assetPair);
    });
  });

  group('MarketPriceNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty map', () {
      expect(container.read(marketPriceProvider), {});
    });

    test('setState adds price for assetPair', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketPrice = From_MarketPrice(
        assetPair: assetPair,
        indPrice: 50000.0,
        lastPrice: 49990.0,
      );

      container
          .read(marketPriceProvider.notifier)
          .setState(marketPrice);

      final state = container.read(marketPriceProvider);
      expect(state[assetPair]?.indexPrice, 50000.0);
      expect(state[assetPair]?.lastPrice, 49990.0);
    });

    test('setState updates price for existing assetPair', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketPrice1 = From_MarketPrice(
        assetPair: assetPair,
        indPrice: 50000.0,
        lastPrice: 49990.0,
      );
      final marketPrice2 = From_MarketPrice(
        assetPair: assetPair,
        indPrice: 51000.0,
        lastPrice: 50990.0,
      );

      container
          .read(marketPriceProvider.notifier)
          .setState(marketPrice1);
      container
          .read(marketPriceProvider.notifier)
          .setState(marketPrice2);

      final state = container.read(marketPriceProvider);
      expect(state[assetPair]?.indexPrice, 51000.0);
      expect(state[assetPair]?.lastPrice, 50990.0);
    });
  });

  group('subscribedMarketInfo', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns none when no assetPair subscribed', () {
      final result = container.read(subscribedMarketInfoProvider);
      expect(result.isNone(), true);
    });

    test('returns none when subscribed assetPair not in markets', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      final result = container.read(subscribedMarketInfoProvider);
      expect(result.isNone(), true);
    });

    test('returns marketInfo when subscribed assetPair exists in markets', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);

      container
          .read(marketsProvider.notifier)
          .setState([marketInfo]);
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      final result = container.read(subscribedMarketInfoProvider);
      expect(result.isSome(), true);
      expect(result.getOrElse(() => MarketInfo()), marketInfo);
    });
  });

  group('marketSubscribedBaseAsset', () {
    test('returns none when no subscribed market', () {
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketSubscribedBaseAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns none when asset not in assetsState', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);

      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketSubscribedBaseAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns some(asset) when asset exists', () {
      final asset = Asset()..ticker = 'BTC';
      asset.freeze();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);

      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          assetsStateProvider.overrideWithValue({'BTC': asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketSubscribedBaseAssetProvider);
      expect(result.isSome(), true);
      expect(result.getOrElse(() => Asset()), asset);
    });
  });

  group('marketSubscribedQuoteAsset', () {
    test('returns none when no subscribed market', () {
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketSubscribedQuoteAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns none when asset not in assetsState', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);

      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          assetsStateProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketSubscribedQuoteAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns some(asset) when asset exists', () {
      final asset = Asset()..ticker = 'USD';
      asset.freeze();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);

      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          assetsStateProvider.overrideWithValue({'USD': asset}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketSubscribedQuoteAssetProvider);
      expect(result.isSome(), true);
      expect(result.getOrElse(() => Asset()), asset);
    });
  });

  group('subscribedMarketProductName', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns empty string when no subscribed market', () {
      final result = container.read(subscribedMarketProductNameProvider);
      expect(result, '');
    });

    test('returns empty string when base asset not found', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);

      container.read(marketsProvider.notifier).setState([marketInfo]);
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      final result = container.read(subscribedMarketProductNameProvider);
      expect(result, '');
    });

    test('returns empty string when quote asset not found', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);
      final baseAsset = Asset(assetId: 'BTC', ticker: 'BTC');

      final localContainer = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          baseAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.of(baseAsset)),
          quoteAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.none()),
        ],
      );
      addTearDown(localContainer.dispose);

      final result = localContainer.read(subscribedMarketProductNameProvider);
      expect(result, '');
    });

    test('returns ticker pair when both assets found', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);
      final baseAsset = Asset(assetId: 'BTC', ticker: 'BTC');
      final quoteAsset = Asset(assetId: 'USD', ticker: 'USD');

      final localContainer = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          baseAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.of(baseAsset)),
          quoteAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.of(quoteAsset)),
        ],
      );
      addTearDown(localContainer.dispose);

      final result = localContainer.read(subscribedMarketProductNameProvider);
      expect(result, 'BTC / USD');
    });
  });

  group('limitOrderAmount', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns zero amount when no subscribed asset pair', () {
      final result = container.read(limitOrderAmountProvider);
      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test('returns zero amount when controller is empty', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      final result = container.read(limitOrderAmountProvider);
      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, 'BTC');
      expect(result.assetPair, assetPair);
    });

    test('parses decimal amount when controller has valid value', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(limitOrderAmountControllerProvider.notifier)
          .setState('1.5');

      final result = container.read(limitOrderAmountProvider);
      expect(result.amount, Decimal.parse('1.5'));
      expect(result.assetId, 'BTC');
    });

    test('returns zero amount when parse fails', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(limitOrderAmountControllerProvider.notifier)
          .setState('invalid');

      final result = container.read(limitOrderAmountProvider);
      expect(result.amount, Decimal.zero);
    });
  });

  group('limitOrderPrice', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns zero when no subscribed asset pair', () {
      final result = container.read(limitOrderPriceProvider);
      expect(result.amount, Decimal.zero);
      expect(result.satoshi, 0);
      expect(result.assetId, '');
    });

    test('returns zero price when controller is empty', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      final result = container.read(limitOrderPriceProvider);
      expect(result.amount, Decimal.zero);
      expect(result.assetId, 'USD');
      expect(result.assetPair, assetPair);
    });

    test('uses quote asset as price asset when side is base', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(marketSideStateProvider.notifier)
          .setState(MarketSideState.base());
      container
          .read(limitOrderPriceControllerProvider.notifier)
          .setState('50000');

      final result = container.read(limitOrderPriceProvider);
      expect(result.assetId, 'USD');
    });

    test('uses base asset as price asset when side is quote', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(marketSideStateProvider.notifier)
          .setState(MarketSideState.quote());
      container
          .read(limitOrderPriceControllerProvider.notifier)
          .setState('0.00002');

      final result = container.read(limitOrderPriceProvider);
      expect(result.assetId, 'BTC');
    });

    test('parses decimal price when controller has valid value', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(limitOrderPriceControllerProvider.notifier)
          .setState('50000.5');

      final result = container.read(limitOrderPriceProvider);
      expect(result.amount, Decimal.parse('50000.5'));
    });
  });

  group('limitOrderTradeButtonEnabled', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false with default state', () {
      final result = container.read(limitOrderTradeButtonEnabledProvider);
      expect(result, false);
    });

    test('returns true when amount and price are set', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final asset = Asset()..ticker = 'BTC';
      asset.freeze();
      final marketInfo = MarketInfo(assetPair: assetPair);

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          marketSubscribedBaseAssetProvider
              .overrideWithValue(Option.of(asset)),
          limitOrderAmountControllerProvider.overrideWithValue('1.0'),
          limitOrderPriceControllerProvider.overrideWithValue('50000'),
          limitInsufficientAmountProvider.overrideWithValue(false),
          limitInsufficientPriceProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(limitOrderTradeButtonEnabledProvider);
      expect(result, true);
    });
  });

  group('limitInsufficientAmount', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when amount is zero', () {
      final result = container.read(limitInsufficientAmountProvider);
      expect(result, false);
    });

    test('returns false when no fee asset available', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(limitOrderAmountControllerProvider.notifier)
          .setState('1.0');

      final result = container.read(limitInsufficientAmountProvider);
      expect(result, false);
    });

  });

  group('limitInsufficientPrice', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when price is zero', () {
      final result = container.read(limitInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when no fee asset available', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(limitOrderPriceControllerProvider.notifier)
          .setState('50000');

      final result = container.read(limitInsufficientPriceProvider);
      expect(result, false);
    });

  });

  group('marketEditOrderAcceptEnabled', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns false when no order set', () {
      final result = container.read(marketEditOrderAcceptEnabledProvider);
      expect(result, false);
    });

    test('returns false when amount satoshi is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final zeroAmount = OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: 'BTC',
        assetPair: assetPair,
      );
      final c = ProviderContainer.test(
        overrides: [
          marketEditOrderAmountProvider.overrideWithValue(Option.of(zeroAmount)),
          marketEditOrderPriceProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(marketEditOrderAcceptEnabledProvider), false);
    });

    test('returns false when price is None', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final nonZeroAmount = OrderAmount(
        amount: Decimal.parse('1.0'),
        satoshi: 100000000,
        assetId: 'BTC',
        assetPair: assetPair,
      );
      final c = ProviderContainer.test(
        overrides: [
          marketEditOrderAmountProvider.overrideWithValue(Option.of(nonZeroAmount)),
          marketEditOrderPriceProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(marketEditOrderAcceptEnabledProvider), false);
    });

    test('returns false when price satoshi is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final nonZeroAmount = OrderAmount(
        amount: Decimal.parse('1.0'),
        satoshi: 100000000,
        assetId: 'BTC',
        assetPair: assetPair,
      );
      final zeroPrice = OrderAmount(
        amount: Decimal.zero,
        satoshi: 0,
        assetId: 'USD',
        assetPair: assetPair,
      );
      final c = ProviderContainer.test(
        overrides: [
          marketEditOrderAmountProvider.overrideWithValue(Option.of(nonZeroAmount)),
          marketEditOrderPriceProvider.overrideWithValue(Option.of(zeroPrice)),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(marketEditOrderAcceptEnabledProvider), false);
    });

    test('returns true when both amount and price satoshi are non-zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final nonZeroAmount = OrderAmount(
        amount: Decimal.parse('1.0'),
        satoshi: 100000000,
        assetId: 'BTC',
        assetPair: assetPair,
      );
      final nonZeroPrice = OrderAmount(
        amount: Decimal.parse('50000'),
        satoshi: 5000000000000,
        assetId: 'USD',
        assetPair: assetPair,
      );
      final c = ProviderContainer.test(
        overrides: [
          marketEditOrderAmountProvider.overrideWithValue(Option.of(nonZeroAmount)),
          marketEditOrderPriceProvider.overrideWithValue(Option.of(nonZeroPrice)),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(marketEditOrderAcceptEnabledProvider), true);
    });
  });

  group('marketSatoshiIndexPrice', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns none when no subscribed asset pair', () {
      final result = container.read(marketSatoshiIndexPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns none when market price is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketPrice = From_MarketPrice(
        assetPair: assetPair,
        indPrice: 0.0,
        lastPrice: 0.0,
      );

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(marketPriceProvider.notifier)
          .setState(marketPrice);

      final result = container.read(marketSatoshiIndexPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns none when satoshi result is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketPrice = From_MarketPrice(
        assetPair: assetPair,
        indPrice: 1.0,
        lastPrice: 1.0,
      );

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(marketPriceProvider.notifier)
          .setState(marketPrice);

      final result = container.read(marketSatoshiIndexPriceProvider);
      // Will be none because satoshi conversion fails without asset state
      expect(result.isNone(), true);
    });

    test('returns Some with satoshi and quoteAsset when asset and price exist', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quoteAsset = Asset(assetId: 'USD', precision: 2);
      quoteAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(500);

      final c = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          marketPriceProvider.overrideWithValue({assetPair: (indexPrice: 50000.0, lastPrice: 0.0)}),
          assetsStateProvider.overrideWithValue({'USD': quoteAsset}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(c.dispose);

      final result = c.read(marketSatoshiIndexPriceProvider);
      expect(result.isSome(), true);
      final value = result.getOrElse(() => throw Exception('none'));
      expect(value.satoshiIndexPrice, 500);
      expect(value.quoteAsset.isSome(), true);
    });
  });

  group('marketIndexPrice', () {
    test('returns none when no satoshi index price', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final result = container.read(marketIndexPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns None when satoshiIndexPrice is 0', () {
      final asset = Asset(assetId: 'USD', precision: 2);
      asset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          marketSatoshiIndexPriceProvider.overrideWithValue(
            Option.of((satoshiIndexPrice: 0, quoteAsset: Option.of(asset))),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketIndexPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with formatted price when satoshiIndexPrice > 0', () {
      final asset = Asset(assetId: 'USD', precision: 2);
      asset.freeze();
      final mockAmountToString = MockAmountToString();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('50000');
      final container = ProviderContainer.test(
        overrides: [
          marketSatoshiIndexPriceProvider.overrideWithValue(
            Option.of(
              (satoshiIndexPrice: 5000000000000, quoteAsset: Option.of(asset)),
            ),
          ),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketIndexPriceProvider);
      expect(result.isSome(), true);
      final value = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(value.indexPrice, '50000');
    });
  });

  group('marketDecimalIndexPrice', () {
    test('returns none when no market index price', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final result = container.read(marketDecimalIndexPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with parsed decimal when indexPrice valid', () {
      final asset = Asset(assetId: 'USD', precision: 2);
      asset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          marketIndexPriceProvider.overrideWithValue(
            Option.of(
              (indexPrice: '50000.50', quoteAsset: Option.of(asset)),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketDecimalIndexPriceProvider);
      expect(result.isSome(), true);
      final value = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(value.decimalIndexPrice, Decimal.parse('50000.50'));
    });
  });

  group('marketSatoshiLastPrice', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('returns none when no subscribed asset pair', () {
      final result = container.read(marketSatoshiLastPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns none when market price is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketPrice = From_MarketPrice(
        assetPair: assetPair,
        indPrice: 0.0,
        lastPrice: 0.0,
      );

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      container
          .read(marketPriceProvider.notifier)
          .setState(marketPrice);

      final result = container.read(marketSatoshiLastPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with satoshi and quoteAsset when asset and lastPrice exist', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quoteAsset = Asset(assetId: 'USD', precision: 2);
      quoteAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(480);

      final c = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          marketPriceProvider.overrideWithValue({assetPair: (indexPrice: 0.0, lastPrice: 48000.0)}),
          assetsStateProvider.overrideWithValue({'USD': quoteAsset}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(c.dispose);

      final result = c.read(marketSatoshiLastPriceProvider);
      expect(result.isSome(), true);
      final value = result.getOrElse(() => throw Exception('none'));
      expect(value.satoshiLastPrice, 480);
      expect(value.quoteAsset.isSome(), true);
    });

    test('returns None when asset exists but satoshi is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quoteAsset = Asset(assetId: 'USD', precision: 2);
      quoteAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);

      final c = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(Option.of(assetPair)),
          marketPriceProvider.overrideWithValue({assetPair: (indexPrice: 0.0, lastPrice: 48000.0)}),
          assetsStateProvider.overrideWithValue({'USD': quoteAsset}),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(c.dispose);

      final result = c.read(marketSatoshiLastPriceProvider);
      expect(result.isNone(), true);
    });
  });

  group('marketLastPrice', () {
    test('returns none when no satoshi last price', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final result = container.read(marketLastPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns None when satoshiLastPrice is 0', () {
      final asset = Asset(assetId: 'USD', precision: 2);
      asset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          marketSatoshiLastPriceProvider.overrideWithValue(
            Option.of((satoshiLastPrice: 0, quoteAsset: Option.of(asset))),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketLastPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with formatted price when satoshiLastPrice > 0', () {
      final asset = Asset(assetId: 'USD', precision: 2);
      asset.freeze();
      final mockAmountToString = MockAmountToString();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('50000');
      final container = ProviderContainer.test(
        overrides: [
          marketSatoshiLastPriceProvider.overrideWithValue(
            Option.of(
              (satoshiLastPrice: 5000000000000, quoteAsset: Option.of(asset)),
            ),
          ),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketLastPriceProvider);
      expect(result.isSome(), true);
      final value = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(value.lastPrice, '50000');
    });
  });

  group('marketDecimalLastPrice', () {
    test('returns none when no market last price', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final result = container.read(marketDecimalLastPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with parsed decimal', () {
      final asset = Asset(assetId: 'USD', precision: 2);
      asset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          marketLastPriceProvider.overrideWithValue(
            Option.of(
              (lastPrice: '50000.50', quoteAsset: Option.of(asset)),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketDecimalLastPriceProvider);
      expect(result.isSome(), true);
      final value = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(value.decimalLastPrice, Decimal.parse('50000.50'));
    });
  });

  group('marketLimitOrderAggregateVolume', () {
    test('uses quoteAsset precision when quoteAsset is Some', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quoteAsset = Asset(assetId: 'USD', precision: 8);
      quoteAsset.freeze();
      final orderAmount = OrderAmount(
        amount: Decimal.parse('1.0'),
        satoshi: 100000000,
        assetId: 'BTC',
        assetPair: assetPair,
      );
      final orderPrice = OrderAmount(
        amount: Decimal.parse('50000'),
        satoshi: 5000000000000,
        assetId: 'USD',
        assetPair: assetPair,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.of(quoteAsset)),
          limitOrderAmountProvider.overrideWithValue(orderAmount),
          limitOrderPriceProvider.overrideWithValue(orderPrice),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregateVolumeProvider);
      expect(result.precision, 8);
    });

    test('uses precision 0 when quoteAsset is None', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderAmount = OrderAmount(
        amount: Decimal.parse('1.0'),
        satoshi: 100000000,
        assetId: 'BTC',
        assetPair: assetPair,
      );
      final orderPrice = OrderAmount(
        amount: Decimal.parse('50000'),
        satoshi: 5000000000000,
        assetId: 'USD',
        assetPair: assetPair,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(orderAmount),
          limitOrderPriceProvider.overrideWithValue(orderPrice),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregateVolumeProvider);
      expect(result.precision, 0);
    });
  });

  group('marketLimitOrderAggregatedVolumeWithTicker', () {
    test('returns volume string without ticker when no quote asset', () {
      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('2'),
        price: Decimal.parse('3'),
        precision: 0,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregatedVolumeWithTickerProvider);
      // No ticker appended
      expect(result, '600000000');
    });

    test('returns volume string with ticker when quote asset exists', () {
      final mockAsset = Asset()..ticker = 'USDt';
      mockAsset.freeze();
      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('2'),
        price: Decimal.parse('3'),
        precision: 0,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregatedVolumeWithTickerProvider);
      expect(result, endsWith('USDt'));
    });
  });

  group('marketLimitOrderAggregateVolumeTooHigh', () {
    test('returns true when no quote asset', () {
      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('1'),
        price: Decimal.parse('1'),
        precision: 0,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregateVolumeTooHighProvider);
      expect(result, true);
    });

    test('returns true when volume > balance', () {
      final mockAsset = Asset();
      mockAsset.freeze();
      // amount * price * kCoin / 10^0 = 5 * 10 * 100000000 = 5000000000
      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.parse('5'),
        price: Decimal.parse('10'),
        precision: 0,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          assetBalanceStringProvider(mockAsset).overrideWithValue('1'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregateVolumeTooHighProvider);
      expect(result, true);
    });

    test('returns false when volume <= balance', () {
      final mockAsset = Asset();
      mockAsset.freeze();
      final aggregateVolume = MarketOrderAggregateVolumeProvider(
        amount: Decimal.zero,
        price: Decimal.zero,
        precision: 0,
      );
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          marketLimitOrderAggregateVolumeProvider.overrideWithValue(aggregateVolume),
          assetBalanceStringProvider(mockAsset).overrideWithValue('999999999'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitOrderAggregateVolumeTooHighProvider);
      expect(result, false);
    });
  });

  group('marketLimitPriceBalance', () {
    test('returns empty string when no quote asset', () {
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitPriceBalanceProvider);
      expect(result, '');
    });

    test('returns balance when quote asset exists', () {
      final mockAsset = Asset();
      mockAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset).overrideWithValue('12345'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitPriceBalanceProvider);
      expect(result, '12345');
    });
  });

  group('marketLimitAmountBalance', () {
    test('returns empty string when no base asset', () {
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedBaseAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitAmountBalanceProvider);
      expect(result, '');
    });

    test('returns balance when base asset exists', () {
      final mockAsset = Asset();
      mockAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(mockAsset),
          ),
          assetBalanceStringProvider(mockAsset).overrideWithValue('99999'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketLimitAmountBalanceProvider);
      expect(result, '99999');
    });
  });

  group('marketEditOrderAmount', () {
    test('returns None when no order set', () {
      final mockSatoshi = MockAbstractSatoshiRepository();
      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshi),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketEditOrderAmountProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(OrderAmount) when order exists with valid amount', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.assetPair).thenReturn(assetPair);
      when(() => mockOrder.offlineSwapType).thenReturn(OfflineSwapType.empty());
      final mockSatoshi = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshi.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(150000000);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshi),
          marketEditOrderAmountControllerProvider.overrideWithValue('1.5'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketEditOrderAmountProvider);
      expect(result.isSome(), true);
      final orderAmount = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(orderAmount.amount, Decimal.parse('1.5'));
      expect(orderAmount.satoshi, 150000000);
      expect(orderAmount.assetId, 'BTC');
      expect(orderAmount.assetPair, assetPair);
    });

    test('returns OrderAmount with zero satoshi when amount is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.assetPair).thenReturn(assetPair);
      when(() => mockOrder.offlineSwapType).thenReturn(OfflineSwapType.empty());
      final mockSatoshi = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshi.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshi),
          marketEditOrderAmountControllerProvider.overrideWithValue('0'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketEditOrderAmountProvider);
      expect(result.isSome(), true);
      final orderAmount = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(orderAmount.amount, Decimal.zero);
      expect(orderAmount.satoshi, 0);
    });
  });

  group('marketEditOrderPrice', () {
    test('returns None when no order set', () {
      final mockSatoshi = MockAbstractSatoshiRepository();
      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider.overrideWithValue(Option.none()),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshi),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketEditOrderPriceProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(OrderAmount) when order exists with valid price', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.assetPair).thenReturn(assetPair);
      when(() => mockOrder.offlineSwapType).thenReturn(OfflineSwapType.empty());
      final mockSatoshi = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshi.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(5000000000);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshi),
          marketEditOrderPriceControllerProvider.overrideWithValue('50000'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketEditOrderPriceProvider);
      expect(result.isSome(), true);
      final orderAmount = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(orderAmount.amount, Decimal.parse('50000'));
      expect(orderAmount.satoshi, 5000000000);
      expect(orderAmount.assetId, 'USD');
      expect(orderAmount.assetPair, assetPair);
    });

    test('returns OrderAmount with zero satoshi when price is zero', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.assetPair).thenReturn(assetPair);
      when(() => mockOrder.offlineSwapType).thenReturn(OfflineSwapType.empty());
      final mockSatoshi = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshi.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);

      final container = ProviderContainer.test(
        overrides: [
          marketEditDetailsOrderProvider
              .overrideWithValue(Option.of(mockOrder)),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshi),
          marketEditOrderPriceControllerProvider.overrideWithValue('0'),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketEditOrderPriceProvider);
      expect(result.isSome(), true);
      final orderAmount = result.getOrElse(
        () => throw Exception('unexpected none'),
      );
      expect(orderAmount.amount, Decimal.zero);
      expect(orderAmount.satoshi, 0);
    });
  });

  group('MarketMinimalAmountsNotifier', () {
    late ProviderContainer container;
    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('initial state is empty map', () {
      expect(container.read(marketMinimalAmountsNotfierProvider), {});
    });

    test('setState populates map with asset IDs and amounts', () {
      final container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('liquid-id'),
          tetherAssetIdStateProvider.overrideWithValue('usdt-id'),
          eurxAssetIdStateProvider.overrideWithValue('eurx-id'),
        ],
      );
      addTearDown(container.dispose);

      final minMarketAmounts = From_MinMarketAmounts(
        lbtc: Int64(1000),
        usdt: Int64(2000),
        eurx: Int64(3000),
      );

      container
          .read(marketMinimalAmountsNotfierProvider.notifier)
          .setState(minMarketAmounts);

      final state = container.read(marketMinimalAmountsNotfierProvider);
      expect(state['liquid-id'], 1000);
      expect(state['usdt-id'], 2000);
      expect(state['eurx-id'], 3000);
      expect(state.length, 3);
    });
  });

  group('marketQuoteError', () {
    test('returns None when no quote', () {
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no error', () {
      final quote = From_Quote();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(QuoteError) when quote has error', () {
      final quote = From_Quote()..error = 'test error';
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteErrorProvider);
      expect(result.isSome(), true);
      final err = result.getOrElse(() => throw Exception('none'));
      expect(err.error, 'test error');
    });

    test('returns None when startOrder is Some (bypass branch)', () {
      final quote = From_Quote()..error = 'test error';
      final startOrder = From_StartOrder();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteErrorProvider);
      expect(result.isNone(), true);
    });
  });

  group('marketQuoteLowBalanceError', () {
    test('returns None when no quote', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no lowBalance', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote(assetPair: assetPair);
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when startOrder is Some (bypass branch)', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote(assetPair: assetPair)
        ..lowBalance = From_Quote_LowBalance();
      final startOrder = From_StartOrder();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when no subscribed assetPair', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()..lowBalance = From_Quote_LowBalance();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(Option.none()),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote assetPair does not match subscribed', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final differentPair = AssetPair(base: 'ETH', quote: 'USD');
      final quote = From_Quote()
        ..lowBalance = From_Quote_LowBalance()
        ..assetPair = differentPair;
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when subscribedMarketInfo is None', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote()
        ..lowBalance = From_Quote_LowBalance()
        ..assetPair = assetPair;
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(QuoteLowBalance) when all conditions met', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);
      final quote = From_Quote()
        ..lowBalance = From_Quote_LowBalance()
        ..assetPair = assetPair
        ..orderId = Int64(1)
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL;
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(
            Option.of(marketInfo),
          ),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteLowBalanceErrorProvider);
      expect(result.isSome(), true);
    });
  });

  group('marketQuoteSuccess', () {
    test('returns None when no quote', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no success', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote(assetPair: assetPair);
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when startOrder is Some (bypass branch)', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote(assetPair: assetPair)
        ..success = From_Quote_Success();
      final startOrder = From_StartOrder();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when no subscribed assetPair', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()..success = From_Quote_Success();
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(Option.none()),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote assetPair does not match subscribed', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final differentPair = AssetPair(base: 'ETH', quote: 'USD');
      final quote = From_Quote()
        ..success = From_Quote_Success()
        ..assetPair = differentPair;
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when subscribedMarketInfo is None', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote()
        ..success = From_Quote_Success()
        ..assetPair = assetPair;
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(QuoteSuccess) when all conditions met', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final marketInfo = MarketInfo(assetPair: assetPair);
      final quote = From_Quote()
        ..success = From_Quote_Success()
        ..assetPair = assetPair
        ..orderId = Int64(1)
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL;
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          subscribedMarketInfoProvider.overrideWithValue(
            Option.of(marketInfo),
          ),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteSuccessProvider);
      expect(result.isSome(), true);
    });
  });

  group('marketQuoteUnregisteredGaid', () {
    test('returns None when no quote', () {
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteUnregisteredGaidProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no unregisteredGaid', () {
      final quote = From_Quote();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteUnregisteredGaidProvider);
      expect(result.isNone(), true);
    });

    test('returns Some when quote has unregisteredGaid', () {
      final gaid = From_Quote_UnregisteredGaid(domainAgent: 'agent.example');
      final quote = From_Quote()..unregisteredGaid = gaid;
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteUnregisteredGaidProvider);
      expect(result.isSome(), true);
    });

    test('returns None when startOrder is Some (bypass branch)', () {
      final gaid = From_Quote_UnregisteredGaid(domainAgent: 'agent.example');
      final quote = From_Quote()..unregisteredGaid = gaid;
      final startOrder = From_StartOrder();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketQuoteUnregisteredGaidProvider);
      expect(result.isNone(), true);
    });
  });

  group('marketAcceptQuoteSuccess', () {
    test('returns None when no acceptQuote', () {
      final container = ProviderContainer.test(
        overrides: [
          acceptQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketAcceptQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when acceptQuote has no success', () {
      final acceptQuote = From_AcceptQuote();
      final container = ProviderContainer.test(
        overrides: [
          acceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketAcceptQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with txid when acceptQuote has success', () {
      final success = From_AcceptQuote_Success(txid: 'abc123');
      final acceptQuote = From_AcceptQuote()..success = success;
      final container = ProviderContainer.test(
        overrides: [
          acceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketAcceptQuoteSuccessProvider);
      expect(result.isSome(), true);
      final txid = result.getOrElse(() => throw Exception('none'));
      expect(txid, 'abc123');
    });
  });

  group('marketAcceptQuoteError', () {
    test('returns None when no acceptQuote', () {
      final container = ProviderContainer.test(
        overrides: [
          acceptQuoteProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketAcceptQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when acceptQuote has no error', () {
      final acceptQuote = From_AcceptQuote();
      final container = ProviderContainer.test(
        overrides: [
          acceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketAcceptQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns Some with error string when acceptQuote has error', () {
      final acceptQuote = From_AcceptQuote()..error = 'quote failed';
      final container = ProviderContainer.test(
        overrides: [
          acceptQuoteProvider.overrideWithValue(Option.of(acceptQuote)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketAcceptQuoteErrorProvider);
      expect(result.isSome(), true);
      final err = result.getOrElse(() => throw Exception('none'));
      expect(err, 'quote failed');
    });
  });

  group('marketStartOrderQuoteSuccess', () {
    test('returns None when no quote', () {
      final mockAmountToString = MockAmountToString();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no success', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when startOrder is None', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()..success = From_Quote_Success();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when orderId mismatch', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()
        ..orderId = Int64(1)
        ..success = From_Quote_Success();
      final startOrder = From_StartOrder()..orderId = Int64(2);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns None when orderId matches but startOrder has no success', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()
        ..success = From_Quote_Success()
        ..orderId = Int64(123);
      final startOrder = From_StartOrder()..orderId = Int64(123);
      // startOrder has NO success set
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteSuccessProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(QuoteSuccess) when orderId matches and startOrder has success', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote()
        ..success = From_Quote_Success()
        ..assetPair = assetPair
        ..orderId = Int64(123)
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL;
      final startOrder = From_StartOrder()
        ..orderId = Int64(123)
        ..success = From_StartOrder_Success();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteSuccessProvider);
      expect(result.isSome(), true);
    });
  });

  group('marketStartOrderLowBalanceError', () {
    test('returns None when no quote', () {
      final mockAmountToString = MockAmountToString();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no lowBalance', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when startOrder is None', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()..lowBalance = From_Quote_LowBalance();
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when orderId mismatch', () {
      final mockAmountToString = MockAmountToString();
      final quote = From_Quote()
        ..orderId = Int64(1)
        ..lowBalance = From_Quote_LowBalance();
      final startOrder = From_StartOrder()..orderId = Int64(2);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderLowBalanceErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(QuoteLowBalance) when orderId matches and has lowBalance', () {
      final mockAmountToString = MockAmountToString();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final quote = From_Quote()
        ..orderId = Int64(5)
        ..lowBalance = From_Quote_LowBalance()
        ..assetPair = assetPair
        ..assetType = AssetType.BASE
        ..tradeDir = TradeDir.SELL;
      final startOrder = From_StartOrder()..orderId = Int64(5);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
          assetsStateProvider.overrideWithValue({}),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderLowBalanceErrorProvider);
      expect(result.isSome(), true);
    });
  });

  group('marketStartOrderQuoteError', () {
    test('returns None when no quote', () {
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when startOrder is None', () {
      final quote = From_Quote()..error = 'err';
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when quote has no error', () {
      final quote = From_Quote()..orderId = Int64(1);
      final startOrder = From_StartOrder()..orderId = Int64(1);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns None when orderId mismatch', () {
      final quote = From_Quote()
        ..orderId = Int64(1)
        ..error = 'err';
      final startOrder = From_StartOrder()..orderId = Int64(2);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteErrorProvider);
      expect(result.isNone(), true);
    });

    test('returns Some(QuoteError) when quote has error and orderId matches', () {
      final quote = From_Quote()
        ..orderId = Int64(5)
        ..error = 'start err';
      final startOrder = From_StartOrder()..orderId = Int64(5);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketStartOrderQuoteErrorProvider);
      expect(result.isSome(), true);
      final err = result.getOrElse(() => throw Exception('none'));
      expect(err.error, 'start err');
    });
  });

  group('marketStartOrderUnregisteredGaid', () {
    test('returns None when no quote', () {
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.none()),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(
        marketStartOrderUnregisteredGaidProvider,
      );
      expect(result.isNone(), true);
    });

    test('returns None when startOrder is None', () {
      final gaid = From_Quote_UnregisteredGaid(domainAgent: 'agent');
      final quote = From_Quote()..unregisteredGaid = gaid;
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(
        marketStartOrderUnregisteredGaidProvider,
      );
      expect(result.isNone(), true);
    });

    test('returns None when orderId mismatch', () {
      final gaid = From_Quote_UnregisteredGaid(domainAgent: 'agent');
      final quote = From_Quote()
        ..orderId = Int64(1)
        ..unregisteredGaid = gaid;
      final startOrder = From_StartOrder()..orderId = Int64(2);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(
        marketStartOrderUnregisteredGaidProvider,
      );
      expect(result.isNone(), true);
    });

    test('returns None when orderId matches but quote has no unregisteredGaid', () {
      final quote = From_Quote()..orderId = Int64(7);
      // quote has NO unregisteredGaid set
      final startOrder = From_StartOrder()..orderId = Int64(7);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(
        marketStartOrderUnregisteredGaidProvider,
      );
      expect(result.isNone(), true);
    });

    test('returns Some when orderId matches and has unregisteredGaid', () {
      final gaid = From_Quote_UnregisteredGaid(domainAgent: 'agent');
      final quote = From_Quote()
        ..orderId = Int64(7)
        ..unregisteredGaid = gaid;
      final startOrder = From_StartOrder()..orderId = Int64(7);
      final container = ProviderContainer.test(
        overrides: [
          marketQuoteProvider.overrideWithValue(Option.of(quote)),
          marketStartOrderProvider.overrideWithValue(Option.of(startOrder)),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(
        marketStartOrderUnregisteredGaidProvider,
      );
      expect(result.isSome(), true);
    });
  });

  group('limitFeeAsset', () {
    test('returns None when no subscribed market', () {
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(Option.none()),
          marketSubscribedBaseAssetProvider.overrideWithValue(Option.none()),
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitFeeAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns None when no base asset', () {
      final marketInfo = MarketInfo(
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
        feeAsset: AssetType.BASE,
      );
      final quoteAsset = Asset(assetId: 'USD');
      quoteAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(
            Option.of(marketInfo),
          ),
          marketSubscribedBaseAssetProvider.overrideWithValue(Option.none()),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(quoteAsset),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitFeeAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns None when no quote asset', () {
      final marketInfo = MarketInfo(
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
        feeAsset: AssetType.BASE,
      );
      final baseAsset = Asset(assetId: 'BTC');
      baseAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(
            Option.of(marketInfo),
          ),
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(baseAsset),
          ),
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitFeeAssetProvider);
      expect(result.isNone(), true);
    });

    test('returns base asset when feeAsset is BASE', () {
      final marketInfo = MarketInfo(
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
        feeAsset: AssetType.BASE,
      );
      final baseAsset = Asset(assetId: 'BTC');
      baseAsset.freeze();
      final quoteAsset = Asset(assetId: 'USD');
      quoteAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(
            Option.of(marketInfo),
          ),
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(baseAsset),
          ),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(quoteAsset),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitFeeAssetProvider);
      expect(result.isSome(), true);
      final asset = result.getOrElse(() => throw Exception('none'));
      expect(asset.assetId, 'BTC');
    });

    test('returns quote asset when feeAsset is QUOTE', () {
      final marketInfo = MarketInfo(
        assetPair: AssetPair(base: 'BTC', quote: 'USD'),
        feeAsset: AssetType.QUOTE,
      );
      final baseAsset = Asset(assetId: 'BTC');
      baseAsset.freeze();
      final quoteAsset = Asset(assetId: 'USD');
      quoteAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          subscribedMarketInfoProvider.overrideWithValue(
            Option.of(marketInfo),
          ),
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(baseAsset),
          ),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(quoteAsset),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitFeeAssetProvider);
      expect(result.isSome(), true);
      final asset = result.getOrElse(() => throw Exception('none'));
      expect(asset.assetId, 'USD');
    });
  });

  group('limitMinimumFeeAmount', () {
    test('returns empty string when no fee asset', () {
      final mockAmountToString = MockAmountToString();
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.none()),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitMinimumFeeAmountProvider);
      expect(result, '');
    });

    test('returns formatted amount when fee asset exists', () {
      final feeAsset = Asset(assetId: 'BTC', precision: 8);
      feeAsset.freeze();
      final mockAmountToString = MockAmountToString();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('0.001');
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'BTC': 100000,
          }),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitMinimumFeeAmountProvider);
      expect(result, '0.001');
    });
  });

  group('limitInsufficientAmount inner branch', () {
    test('returns true when all conditions met (feeAsset == baseAsset == orderAmount assetId and satoshi < minimal)', () {
      final feeAsset = Asset(assetId: 'BTC', precision: 8);
      feeAsset.freeze();
      final baseAsset = Asset(assetId: 'BTC', precision: 8);
      baseAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(500);
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(baseAsset),
          ),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'BTC': 1000,
          }),
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(AssetPair(base: 'BTC', quote: 'USD')),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('0.000005'),
              satoshi: 500,
              assetId: 'BTC',
              assetPair: AssetPair(base: 'BTC', quote: 'USD'),
            ),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitInsufficientAmountProvider);
      expect(result, true);
    });

    test('returns false when feeAsset != baseAsset', () {
      final feeAsset = Asset(assetId: 'USD', precision: 2);
      feeAsset.freeze();
      final baseAsset = Asset(assetId: 'BTC', precision: 8);
      baseAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(500);
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(baseAsset),
          ),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'USD': 1000,
          }),
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(AssetPair(base: 'BTC', quote: 'USD')),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('0.000005'),
              satoshi: 500,
              assetId: 'USD',
              assetPair: AssetPair(base: 'BTC', quote: 'USD'),
            ),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitInsufficientAmountProvider);
      expect(result, false);
    });

    test('returns false when feeAsset is Some but baseAsset is None', () {
      final feeAsset = Asset(assetId: 'BTC', precision: 8);
      feeAsset.freeze();
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketSubscribedBaseAssetProvider.overrideWithValue(Option.none()),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.0'),
              satoshi: 100000000,
              assetId: 'BTC',
              assetPair: AssetPair(base: 'BTC', quote: 'USD'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitInsufficientAmountProvider);
      expect(result, false);
    });
  });

  group('limitInsufficientPrice inner branch', () {
    test('returns true when feeAsset == quoteAsset and multiplied satoshi < minimal', () {
      final feeAsset = Asset(assetId: 'USD', precision: 2);
      feeAsset.freeze();
      final quoteAsset = Asset(assetId: 'USD', precision: 2);
      quoteAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(50);
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(quoteAsset),
          ),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'USD': 1000,
          }),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50000'),
              satoshi: 5000000000000,
              assetId: 'USD',
              assetPair: assetPair,
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('0.000001'),
              satoshi: 100,
              assetId: 'BTC',
              assetPair: assetPair,
            ),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitInsufficientPriceProvider);
      expect(result, true);
    });

    test('returns false when feeAsset != quoteAsset', () {
      final feeAsset = Asset(assetId: 'BTC', precision: 8);
      feeAsset.freeze();
      final quoteAsset = Asset(assetId: 'USD', precision: 2);
      quoteAsset.freeze();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(50);
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(quoteAsset),
          ),
          marketMinimalAmountsNotfierProvider.overrideWithValue({
            'BTC': 1000,
          }),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50000'),
              satoshi: 5000000000000,
              assetId: 'USD',
              assetPair: assetPair,
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('0.000001'),
              satoshi: 100,
              assetId: 'BTC',
              assetPair: assetPair,
            ),
          ),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitInsufficientPriceProvider);
      expect(result, false);
    });

    test('returns false when feeAsset is Some but quoteAsset is None', () {
      final feeAsset = Asset(assetId: 'USD', precision: 2);
      feeAsset.freeze();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          limitFeeAssetProvider.overrideWithValue(Option.of(feeAsset)),
          marketSubscribedQuoteAssetProvider.overrideWithValue(Option.none()),
          limitOrderPriceProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('50000'),
              satoshi: 5000000000000,
              assetId: 'USD',
              assetPair: assetPair,
            ),
          ),
          limitOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.0'),
              satoshi: 100000000,
              assetId: 'BTC',
              assetPair: assetPair,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(limitInsufficientPriceProvider);
      expect(result, false);
    });
  });

  group('MarketLimitOfflineSwap', () {
    tearDown(() {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: false,
        ),
      );
    });

    test('returns twoStep when not jade wallet and mobile', () {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: false,
        ),
      );
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketLimitOfflineSwapProvider);
      expect(result, isA<OfflineSwapTypeTwoStep>());
    });

    test('returns twoStep when jade wallet on mobile', () {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: false,
        ),
      );
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketLimitOfflineSwapProvider);
      expect(result, isA<OfflineSwapTypeTwoStep>());
    });

    test('returns disabled when desktop and not jade wallet', () {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);
      final result = container.read(marketLimitOfflineSwapProvider);
      expect(result, isA<OfflineSwapTypeEmpty>());
    });
  });

  group('MarketQuoteNotifier', () {
    test('build returns initial quote event state', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);

      final result = container.read(marketQuoteProvider);
      expect(result.isNone(), true);
    });

    test('stop quotes when market type changes', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);

      // Initialize notifier
      container.read(marketQuoteProvider.notifier);

      // Mutate upstream marketTypeSwitchStateProvider → triggers _stopQuotes
      container
          .read(marketTypeSwitchStateProvider.notifier)
          .setState(MarketTypeSwitchState.market());

      // _stopQuotes → quoteEventProvider.notifier.stopQuotes() → sendMsg
      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('stop quotes when marketSideState changes', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);

      container
          .read(marketSideStateProvider.notifier)
          .setState(MarketSideState.quote());

      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('stop quotes when tradeDir changes', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);

      container
          .read(tradeDirStateProvider.notifier)
          .setSide(TradeDir.SELL);

      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('_startQuotes stops when no subscribed asset pair', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);

      // Set assetPair then clear → listener fires _startQuotes → None → _stopQuotes
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      clearInteractions(mockWallet);

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .state = Option.none();

      // _startQuotes → None branch → _stopQuotes → sendMsg
      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('_startQuotes returns early when orderAmount assetPair mismatch', () {
      final mockWallet = MockSideswapWallet();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final differentPair = AssetPair(base: 'ETH', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.0'),
              satoshi: 100000000,
              assetId: 'BTC',
              assetPair: differentPair,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);
      clearInteractions(mockWallet);

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      // _startQuotes → assetPair mismatch → return (no startQuotes call, no stopQuotes)
      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('_startQuotes returns early when orderAmount satoshi is zero', () {
      final mockWallet = MockSideswapWallet();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.zero,
              satoshi: 0,
              assetId: 'BTC',
              assetPair: assetPair,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);
      clearInteractions(mockWallet);

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      // _startQuotes → satoshi==0 → return (no startQuotes call)
      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('_startQuotes calls startQuotes when all conditions met', () {
      final mockWallet = MockSideswapWallet();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.0'),
              satoshi: 100000000,
              assetId: 'BTC',
              assetPair: assetPair,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);
      clearInteractions(mockWallet);

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      // _startQuotes → happy path → startQuotes → sendMsg
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('_startQuotes stops existing quotes when state isSome and no startOrder', () {
      final mockWallet = MockSideswapWallet();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.0'),
              satoshi: 100000000,
              assetId: 'BTC',
              assetPair: assetPair,
            ),
          ),
          quoteEventProvider.overrideWithBuild((ref, notifier) => Option.of(From_Quote())),
        ],
      );
      addTearDown(container.dispose);

      container.read(marketQuoteProvider.notifier);
      clearInteractions(mockWallet);

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      // state.isSome() && startOrder.isNone() → _stopQuotes first, then startQuotes
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('_startQuotes triggered by marketOrderAmount change', () async {
      // Line 734: ref.listen(marketOrderAmountProvider, ...) { _startQuotes(); }
      // Key: do NOT override marketSubscribedAssetPairProvider — use real notifier.
      final mockWallet = MockSideswapWallet();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(100000000);
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
        ],
      );
      addTearDown(container.dispose);

      // Initialize notifier with no assetPair set
      container.listen(marketQuoteProvider, (_, _) {});

      // Set assetPair — triggers listener 728 (_startQuotes early return)
      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);
      clearInteractions(mockWallet);

      // Flush pending provider rebuilds
      await container.pump();

      // Change amount → marketOrderAmount recomputes → listener 732 fires _startQuotes
      container
          .read(marketOrderAmountControllerProvider.notifier)
          .setState('1.0');

      // Flush pending rebuilds and listener notifications
      await container.pump();

      // _startQuotes → full path → startQuotes → sendMsg
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('_startQuotes uses quote assetId when sideState is Quote', () {
      final mockWallet = MockSideswapWallet();
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketOrderAmountProvider.overrideWithValue(
            OrderAmount(
              amount: Decimal.parse('1.0'),
              satoshi: 100000000,
              assetId: 'USD',
              assetPair: assetPair,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Set side to Quote so assetId = assetPair.quote = 'USD'
      container
          .read(marketSideStateProvider.notifier)
          .setState(MarketSideState.quote());
      container.read(marketQuoteProvider.notifier);
      clearInteractions(mockWallet);

      container
          .read(marketSubscribedAssetPairProvider.notifier)
          .setState(assetPair);

      // _startQuotes → assetId = 'USD' (quote), matches orderAmount → startQuotes called
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

  });

  group('marketUiHistoryOrders', () {
    test('returns empty list when no history orders', () {
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      final container = ProviderContainer.test(
        overrides: [
          marketHistoryOrderProvider.overrideWithValue([]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketUiHistoryOrdersProvider);
      expect(result, isEmpty);
    });

    test('returns mapped UiHistoryOrder list when orders exist', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId(id: Int64(1));
      final historyOrder = HistoryOrder(
        orderId: orderId,
        assetPair: assetPair,
      );
      final mockAmountToString = MockAmountToString();
      final mockImageRepo = MockAbstractAssetImageRepository();
      final mockSatoshiRepo = MockAbstractSatoshiRepository();
      when(
        () => mockAmountToString.amountToString(any()),
      ).thenReturn('0');
      when(
        () => mockSatoshiRepo.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(0);
      final container = ProviderContainer.test(
        overrides: [
          marketHistoryOrderProvider.overrideWithValue([historyOrder]),
          amountToStringProvider.overrideWithValue(mockAmountToString),
          assetsStateProvider.overrideWithValue({}),
          assetImageRepositoryProvider.overrideWithValue(mockImageRepo),
          satoshiRepositoryProvider.overrideWithValue(mockSatoshiRepo),
          assetUtilsProvider.overrideWith((ref) => AssetUtils(ref, assets: {})),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(marketUiHistoryOrdersProvider);
      expect(result.length, 1);
      expect(result.first.orderId, orderId);
      expect(result.first.historyOrder, historyOrder);
    });
  });

  group('orderExpireDescription', () {
    test('returns empty string when order is None', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        orderExpireDescriptionProvider(Option.none()),
      );
      expect(result, '');
    });

    test('returns expireDescription when order is Some', () {
      final mockOrder = MockUiOwnOrder();
      when(() => mockOrder.expireDescription).thenReturn('5m');
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        orderExpireDescriptionProvider(Option.of(mockOrder)),
      );
      expect(result, '5m');
    });

    test('dispose cancels timer without error', () {
      final container = ProviderContainer.test();
      container.read(orderExpireDescriptionProvider(Option.none()));
      expect(() => container.dispose(), returnsNormally);
    });

    test('timer triggers provider rebuild via invalidateSelf', () {
      fakeAsync((async) {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final mockOrder = MockUiOwnOrder();
        var callCount = 0;
        when(() => mockOrder.expireDescription).thenAnswer((_) {
          callCount++;
          return '${5 - callCount}m';
        });

        container.listen(
          orderExpireDescriptionProvider(Option.of(mockOrder)),
          (_, _) {},
        );

        // Initial read to activate provider
        container.read(
          orderExpireDescriptionProvider(Option.of(mockOrder)),
        );

        // Advance timer to trigger invalidateSelf
        async.elapse(Duration(seconds: 2));

        // Provider should have rebuilt (callCount increased)
        expect(callCount, greaterThan(1));
      });
    });
  });

  group('marketOrderButtonText', () {
    test('returns CONTINUE when not jade wallet', () {
      final container = ProviderContainer.test(
        overrides: [isJadeWalletProvider.overrideWithValue(false)],
      );
      addTearDown(container.dispose);
      expect(container.read(marketOrderButtonTextProvider), 'CONTINUE');
    });

    test('returns CONTINUE when jade wallet and unlocked', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          jadeLockStateProvider.overrideWithValue(const JadeLockState.unlocked()),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(marketOrderButtonTextProvider), 'CONTINUE');
    });

    test('returns UNLOCK when jade wallet and locked', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(marketOrderButtonTextProvider), 'UNLOCK');
    });

    test('returns UNLOCK when jade wallet and error state', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          jadeLockStateProvider.overrideWithValue(
            const JadeLockState.error(message: 'test'),
          ),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(marketOrderButtonTextProvider), 'UNLOCK');
    });
  });

  group('baseAssetIconByMarketInfo', () {
    test('returns SizedBox when no base asset', () {
      final marketInfo = MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD'));
      final container = ProviderContainer.test(
        overrides: [
          baseAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(baseAssetIconByMarketInfoProvider(marketInfo));
      expect(result, isA<SizedBox>());
    });

    test('returns image from repository when base asset exists', () {
      final mockRepo = MockAbstractAssetImageRepository();
      when(() => mockRepo.getSmallImage(any())).thenReturn(SizedBox());

      final asset = Asset()..assetId = 'btc_asset_id';
      final marketInfo = MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD'));
      final container = ProviderContainer.test(
        overrides: [
          baseAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.of(asset)),
          assetImageRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(baseAssetIconByMarketInfoProvider(marketInfo));
      expect(result, isA<SizedBox>());
      verify(() => mockRepo.getSmallImage('btc_asset_id')).called(1);
    });
  });

  group('quoteAssetIconByMarketInfo', () {
    test('returns SizedBox when no quote asset', () {
      final marketInfo = MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD'));
      final container = ProviderContainer.test(
        overrides: [
          quoteAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(quoteAssetIconByMarketInfoProvider(marketInfo));
      expect(result, isA<SizedBox>());
    });

    test('returns image from repository when quote asset exists', () {
      final mockRepo = MockAbstractAssetImageRepository();
      when(() => mockRepo.getSmallImage(any())).thenReturn(SizedBox());

      final asset = Asset()..assetId = 'usd_asset_id';
      final marketInfo = MarketInfo(assetPair: AssetPair(base: 'BTC', quote: 'USD'));
      final container = ProviderContainer.test(
        overrides: [
          quoteAssetByMarketInfoProvider(marketInfo).overrideWithValue(Option.of(asset)),
          assetImageRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(quoteAssetIconByMarketInfoProvider(marketInfo));
      expect(result, isA<SizedBox>());
      verify(() => mockRepo.getSmallImage('usd_asset_id')).called(1);
    });
  });

  group('MarketTradeNotifier', () {
    test('prepareSwapTrade sets quote success when Some', () {
      final mockQuoteSuccess = MockQuoteSuccess();
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(marketTradeProvider.notifier).prepareSwapTrade(
        optionQuoteSuccess: Option.of(mockQuoteSuccess),
      );

      final state = container.read(previewOrderQuoteSuccessProvider);
      expect(state.isSome(), true);
    });

    test('prepareSwapTrade does nothing when None', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(marketTradeProvider.notifier).prepareSwapTrade(
        optionQuoteSuccess: Option.none(),
      );

      final state = container.read(previewOrderQuoteSuccessProvider);
      expect(state.isNone(), true);
    });

    test('prepareSwapTrade sets modifiers when provided', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(marketTradeProvider.notifier).prepareSwapTrade(
        optionQuoteSuccess: Option.none(),
        optionModifiers: Option.of(
          PreviewOrderDialogModifiers(showOrderType: false),
        ),
      );

      final state = container.read(previewOrderDialogModifiersProvider);
      expect(state.showOrderType, false);
    });

    test('cleanupAfterDialog invalidates previewOrderQuoteSuccess', () {
      final mockQuoteSuccess = MockQuoteSuccess();
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container
          .read(previewOrderQuoteSuccessProvider.notifier)
          .setState(mockQuoteSuccess);
      expect(container.read(previewOrderQuoteSuccessProvider).isSome(), true);

      container.read(marketTradeProvider.notifier).cleanupAfterDialog();

      expect(container.read(previewOrderQuoteSuccessProvider).isNone(), true);
    });
  });
}
