import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/math_providers.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class MockSatoshiRepository extends Mock implements AbstractSatoshiRepository {}

class MockAmountToString extends Mock implements AmountToString {}

void main() {
  setUpAll(() {
    registerFallbackValue(const RequestOrderSortFlag.all());
    registerFallbackValue(AmountToStringParameters(amount: 0));
    registerFallbackValue(Decimal.zero);
    // Initialize FlavorConfig singleton (mobile by default)
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

  group('RequestOrderSortFlagNotifier', () {
    group('build', () {
      test('initial state is all', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(requestOrderSortFlagProvider);

        expect(state, isA<RequestOrderSortFlagAll>());
      });
    });

    group('setSortFlag', () {
      test('updates state to online', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(requestOrderSortFlagProvider.notifier)
            .setSortFlag(const RequestOrderSortFlag.online());

        expect(
          container.read(requestOrderSortFlagProvider),
          isA<RequestOrderSortFlagOnline>(),
        );
      });

      test('updates state to offline', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(requestOrderSortFlagProvider.notifier)
            .setSortFlag(const RequestOrderSortFlag.offline());

        expect(
          container.read(requestOrderSortFlagProvider),
          isA<RequestOrderSortFlagOffline>(),
        );
      });

      test('state changes trigger listener callbacks', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<RequestOrderSortFlag>();
        container.listen(requestOrderSortFlagProvider, listener.call,
            fireImmediately: true);

        // Verify initial state callback
        verify(
          () => listener(null, const RequestOrderSortFlag.all()),
        ).called(1);
        verifyNoMoreInteractions(listener);

        container
            .read(requestOrderSortFlagProvider.notifier)
            .setSortFlag(const RequestOrderSortFlag.online());

        // Verify state change callback
        verify(
          () => listener(
            const RequestOrderSortFlag.all(),
            const RequestOrderSortFlag.online(),
          ),
        ).called(1);
        verifyNoMoreInteractions(listener);
      });
    });
  });

  group('internalUiOrders', () {
    test('returns empty list when asset pair is none', () {
      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            const Option.none(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider);

      expect(orders, isEmpty);
    });

    test('creates public orders from public order map', () {
      final assetPair = AssetPair(
        base: 'BTC',
        quote: 'USD',
      );
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider);

      expect(orders, hasLength(1));
      expect(orders.first.orderType, isA<InternalUiOrderTypePublic>());
    });

    test('handles multiple orders from different trade directions', () {
      final assetPair = AssetPair(
        base: 'BTC',
        quote: 'USD',
      );
      final publicOrder1 = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final publicOrder2 = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.SELL,
        amount: Int64(2000),
        price: 51000.0,
      );
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder1, publicOrder2]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();

      expect(orders, hasLength(2));
      expect(
        orders.map((o) => o.tradeDir).toSet(),
        {TradeDir.BUY, TradeDir.SELL},
      );
    });


  });

  group('maxOrderAmount', () {
    test('returns zero when both bid and ask lists are empty', () {
      final container = ProviderContainer.test(
        overrides: [
          ordersBidsProvider.overrideWithValue([]),
          ordersAsksProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final maxAmount = container.read(maxOrderAmountProvider);

      expect(maxAmount, Decimal.zero);
    });
  });

  group('ordersBids', () {
    test('returns empty when no buy orders exist', () {
      final container = ProviderContainer.test(
        overrides: [
          internalUiOrdersProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final bids = container.read(ordersBidsProvider);

      expect(bids, isEmpty);
    });

    test('filters to only buy orders', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 50000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(1000),
                price: 51000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final bids = container.read(ordersBidsProvider);

      expect(bids, hasLength(1));
      expect(bids.first.tradeDir, TradeDir.BUY);
    });

    test('sorts buy orders by price descending', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 50000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 49000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 51000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final bids = container.read(ordersBidsProvider).toList();

      expect(bids, hasLength(3));
      expect(bids[0].price, 51000.0);
      expect(bids[1].price, 50000.0);
      expect(bids[2].price, 49000.0);
    });
  });

  group('ordersAsks', () {
    test('returns empty when no sell orders exist', () {
      final container = ProviderContainer.test(
        overrides: [
          internalUiOrdersProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final asks = container.read(ordersAsksProvider);

      expect(asks, isEmpty);
    });

    test('filters to only sell orders', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 50000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(1000),
                price: 51000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final asks = container.read(ordersAsksProvider);

      expect(asks, hasLength(1));
      expect(asks.first.tradeDir, TradeDir.SELL);
    });

    test('sorts sell orders by price ascending', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(1000),
                price: 51000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(1000),
                price: 52000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(1000),
                price: 50000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final asks = container.read(ordersAsksProvider).toList();

      expect(asks, hasLength(3));
      expect(asks[0].price, 50000.0);
      expect(asks[1].price, 51000.0);
      expect(asks[2].price, 52000.0);
    });
  });

  group('mapRange', () {
    test('maps value from input range to output range', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        mapRangeProvider(50, 0, 100, 0, 1),
      );

      expect(result, Decimal.tryParse('0.5'));
    });

    test('handles value at minimum of input range', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        mapRangeProvider(0, 0, 100, 0, 1),
      );

      expect(result, Decimal.zero);
    });

    test('handles value at maximum of input range', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(
        mapRangeProvider(100, 0, 100, 0, 1),
      );

      expect(result, Decimal.one);
    });

    test('returns zero when calculation causes division by zero', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      // Division by zero scenario: inMax == inMin
      final result = container.read(
        mapRangeProvider(50, 100, 100, 0, 1),
      );

      expect(result, Decimal.zero);
    });
  });

  group('ordersPanelBids', () {
    test('returns empty when no bids exist', () {
      final container = ProviderContainer.test(
        overrides: [
          ordersBidsProvider.overrideWithValue([]),
          maxOrderAmountProvider.overrideWithValue(Decimal.zero),
          mathHelperProvider.overrideWithValue(MathHelper()),
        ],
      );
      addTearDown(container.dispose);

      final panelBids = container.read(ordersPanelBidsProvider);

      expect(panelBids, isEmpty);
    });

    test('calculates amount percent for bid orders', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(500),
                price: 50000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          mathHelperProvider.overrideWithValue(MathHelper()),
        ],
      );
      addTearDown(container.dispose);

      final panelBids = container.read(ordersPanelBidsProvider).toList();

      expect(panelBids, hasLength(1));
      expect(panelBids[0].amountPercent, closeTo(1.0, 1e-9));
    });

    test('maps percent values within 0 to 1 range', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 50000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(500),
                price: 49000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          mathHelperProvider.overrideWithValue(MathHelper()),
        ],
      );
      addTearDown(container.dispose);

      final panelBids = container.read(ordersPanelBidsProvider).toList();

      expect(panelBids, hasLength(2));
      for (final bid in panelBids) {
        expect(bid.amountPercent, lessThanOrEqualTo(1.0));
        expect(bid.amountPercent, greaterThanOrEqualTo(0.0));
      }
    });
  });

  group('ordersPanelAsks', () {
    test('returns empty when no asks exist', () {
      final container = ProviderContainer.test(
        overrides: [
          ordersAsksProvider.overrideWithValue([]),
          maxOrderAmountProvider.overrideWithValue(Decimal.zero),
          mathHelperProvider.overrideWithValue(MathHelper()),
        ],
      );
      addTearDown(container.dispose);

      final panelAsks = container.read(ordersPanelAsksProvider);

      expect(panelAsks, isEmpty);
    });

    test('calculates amount percent for ask orders', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(500),
                price: 51000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          mathHelperProvider.overrideWithValue(MathHelper()),
        ],
      );
      addTearDown(container.dispose);

      final panelAsks = container.read(ordersPanelAsksProvider).toList();

      expect(panelAsks, hasLength(1));
      expect(panelAsks[0].amountPercent, closeTo(1.0, 1e-9));
    });

    test('maps percent values within 0 to 1 range', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(1000),
                price: 51000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(500),
                price: 52000.0,
              ),
            ]
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          mathHelperProvider.overrideWithValue(MathHelper()),
        ],
      );
      addTearDown(container.dispose);

      final panelAsks = container.read(ordersPanelAsksProvider).toList();

      expect(panelAsks, hasLength(2));
      for (final ask in panelAsks) {
        expect(ask.amountPercent, lessThanOrEqualTo(1.0));
        expect(ask.amountPercent, greaterThanOrEqualTo(0.0));
      }
    });
  });

  group('InternalUiOrder getters', () {
    late AssetPair assetPair;
    late PublicOrder publicOrder;
    late MockSatoshiRepository satoshiRepository;
    late ProviderContainer container;

    setUp(() {
      assetPair = AssetPair(base: 'BTC', quote: 'USD');
      publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      satoshiRepository = MockSatoshiRepository();

      container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);
    });

    test('orderId delegates to PublicOrder', () {
      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.orderId, isNotNull);
    });

    test('assetPair delegates to PublicOrder', () {
      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.assetPair, assetPair);
    });

    test('tradeDir delegates to PublicOrder', () {
      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.tradeDir, TradeDir.BUY);
    });

    test('amount delegates to PublicOrder', () {
      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.amount, 1000);
    });

    test('price delegates to PublicOrder', () {
      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.price, 50000.0);
    });

    test('amount is 0 when order is none', () {
      final emptyContainer = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            const Option.none(),
          ),
        ],
      );
      addTearDown(emptyContainer.dispose);
      final orders = emptyContainer.read(internalUiOrdersProvider).toList();
      expect(orders, isEmpty);
    });
  });

  group('InternalUiOrder amountString', () {
    test('returns amountToString result', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();
      final mockAmountToString = MockAmountToString();

      when(() => mockAmountToString.amountToString(any())).thenReturn('1,000');

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          assetUtilsProvider.overrideWith(
            (ref) => AssetUtils(ref, assets: {}),
          ),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.amountString, '1,000');
    });
  });

  group('InternalUiOrder priceString', () {
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

    test('falls back to Decimal.zero when price is NaN', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final nanPriceOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: double.nan,
      );
      final satoshiRepository = MockSatoshiRepository();
      final mockAmountToString = MockAmountToString();

      when(
        () => mockAmountToString.amountToMobileFormatted(
          amount: any(named: 'amount'),
          precision: any(named: 'precision'),
        ),
      ).thenReturn('0.0');

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [nanPriceOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          assetUtilsProvider.overrideWith(
            (ref) => AssetUtils(ref, assets: {}),
          ),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      // The key verification: priceString returns without throwing — Decimal.zero fallback was used
      expect(() => orders.first.priceString, returnsNormally);
    });

    test('mobile path uses amountToMobileFormatted', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();
      final mockAmountToString = MockAmountToString();

      when(
        () => mockAmountToString.amountToMobileFormatted(
          amount: any(named: 'amount'),
          precision: any(named: 'precision'),
        ),
      ).thenReturn('50,000');

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          assetUtilsProvider.overrideWith(
            (ref) => AssetUtils(ref, assets: {}),
          ),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.priceString, '50,000');
    });

    test('desktop path uses satoshiRepository and amountToString', () {
      FlavorConfig(
        flavor: Flavor.production,
        values: FlavorValues(
          enableNetworkSettings: false,
          enableJade: false,
          enableLocalEndpoint: false,
          isDesktop: true,
        ),
      );

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();
      final mockAmountToString = MockAmountToString();

      when(
        () => satoshiRepository.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).thenReturn(5000000000);
      when(() => mockAmountToString.amountToString(any())).thenReturn('50,000');

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
          assetUtilsProvider.overrideWith(
            (ref) => AssetUtils(ref, assets: {}),
          ),
          amountToStringProvider.overrideWithValue(mockAmountToString),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.priceString, '50,000');

      verify(
        () => satoshiRepository.satoshiForAmount(
          amount: any(named: 'amount'),
          assetId: any(named: 'assetId'),
        ),
      ).called(1);
    });
  });

  group('InternalUiOrder copyWith', () {
    test('copyWith changes orderType and preserves other fields', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      final order = orders.first;
      final copy = order.copyWith(orderType: const InternalUiOrderType.own());

      expect(copy.orderType, isA<InternalUiOrderTypeOwn>());
      expect(copy.amount, order.amount);
      expect(copy.price, order.price);
    });

    test('copyWith preserves amountPercent when not specified', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      final order = orders.first;
      final copy = order.copyWith(amountPercent: 0.75);

      expect(copy.amountPercent, 0.75);
      expect(copy.orderType, order.orderType);
    });
  });

  group('InternalUiOrder toString, == and hashCode', () {
    test('toString contains InternalUiOrder', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.toString(), contains('InternalUiOrder'));
    });

    test('orders with same fields are equal', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      );
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      final order = orders.first;
      final copy = order.copyWith();
      expect(order == copy, isTrue);
      expect(order.hashCode, copy.hashCode);
    });
  });

  group('internalUiOrders own order matching', () {
    test('marks matching public order as own', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final orderId = OrderId();
      final publicOrder =
          PublicOrder(
            assetPair: assetPair,
            tradeDir: TradeDir.BUY,
            amount: Int64(1000),
            price: 50000.0,
          )..orderId = orderId;
      final ownOrder = OwnOrder()..orderId = orderId;
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([ownOrder]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.orderType, isA<InternalUiOrderTypeOwn>());
    });

    test('public order stays public when own order list is empty', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final publicOrder = PublicOrder(
        assetPair: assetPair,
        tradeDir: TradeDir.BUY,
        amount: Int64(1000),
        price: 50000.0,
      )..orderId = OrderId(id: Int64(42));
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue(
            {assetPair: [publicOrder]},
          ),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final orders = container.read(internalUiOrdersProvider).toList();
      expect(orders.first.orderType, isA<InternalUiOrderTypePublic>());
    });
  });

  group('maxOrderAmount non-empty', () {
    test('returns max of bids and asks amounts', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(1000),
                price: 50000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(2000),
                price: 51000.0,
              ),
            ],
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final maxAmount = container.read(maxOrderAmountProvider);
      expect(maxAmount, Decimal.fromInt(2000));
    });

    test('returns bid amount when bids exceed asks', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final satoshiRepository = MockSatoshiRepository();

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedAssetPairProvider.overrideWithValue(
            Option.of(assetPair),
          ),
          debouncedMarketPublicOrdersProvider.overrideWithValue({
            assetPair: [
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.BUY,
                amount: Int64(3000),
                price: 50000.0,
              ),
              PublicOrder(
                assetPair: assetPair,
                tradeDir: TradeDir.SELL,
                amount: Int64(500),
                price: 51000.0,
              ),
            ],
          }),
          marketOwnOrdersProvider.overrideWithValue([]),
          satoshiRepositoryProvider.overrideWithValue(satoshiRepository),
        ],
      );
      addTearDown(container.dispose);

      final maxAmount = container.read(maxOrderAmountProvider);
      expect(maxAmount, Decimal.fromInt(3000));
    });
  });
}
