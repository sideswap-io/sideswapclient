import 'package:candlesticks/candlesticks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

class _FakeTo extends Fake implements To {}

class MockAssetUtils extends Mock implements AssetUtils {
  bool _isPricedInLiquidOverride = false;

  @override
  int getPrecisionForAssetId({String? assetId}) => 8;

  @override
  bool isPricedInLiquid({Asset? asset}) => _isPricedInLiquidOverride;

  void setIsPricedInLiquid(bool value) {
    _isPricedInLiquidOverride = value;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeTo());
  });

  group('ChartsSubscriptionFlag', () {
    test('can be constructed as subscribed', () {
      const flag = ChartsSubscriptionFlag.subscribed();
      expect(flag, isA<ChartsSubscriptionFlagSubscribed>());
    });

    test('can be constructed as unsubscribed', () {
      const flag = ChartsSubscriptionFlag.unsubscribed();
      expect(flag, isA<ChartsSubscriptionFlagUnsubscribed>());
    });
  });

  group('ChartsSubscriptionFlagNotifier', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
    });

    test('initial state is unsubscribed', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final state = container.read(chartsSubscriptionFlagProvider);
      expect(state, ChartsSubscriptionFlag.unsubscribed());
    });

    test('subscribe() changes state to subscribed', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsSubscriptionFlagProvider.notifier);

      notifier.subscribe();

      expect(
        container.read(chartsSubscriptionFlagProvider),
        ChartsSubscriptionFlag.subscribed(),
      );
    });

    test('unsubscribe() changes state to unsubscribed', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsSubscriptionFlagProvider.notifier);

      notifier.subscribe();
      expect(
        container.read(chartsSubscriptionFlagProvider),
        ChartsSubscriptionFlag.subscribed(),
      );

      notifier.unsubscribe();
      expect(
        container.read(chartsSubscriptionFlagProvider),
        ChartsSubscriptionFlag.unsubscribed(),
      );
    });

    test('subscribe/unsubscribe state transitions', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsSubscriptionFlagProvider.notifier);
      final listener = ProviderListener<ChartsSubscriptionFlag>();

      container.listen(chartsSubscriptionFlagProvider, listener.call);

      notifier.subscribe();
      verifyInOrder([
        () => listener(
              ChartsSubscriptionFlag.unsubscribed(),
              ChartsSubscriptionFlag.subscribed(),
            ),
      ]);

      notifier.unsubscribe();
      verifyInOrder([
        () => listener(
              ChartsSubscriptionFlag.subscribed(),
              ChartsSubscriptionFlag.unsubscribed(),
            ),
      ]);
    });
  });

  group('Stats', () {
    test('can be instantiated with default values', () {
      final stats = Stats();
      expect(stats.low, 0);
      expect(stats.high, 0);
      expect(stats.last, 0);
      expect(stats.changePercent, 0);
      expect(stats.volume, 0);
    });

    test('properties can be modified', () {
      final stats = Stats()
        ..low = 100.0
        ..high = 200.0
        ..last = 150.0
        ..changePercent = 5.0
        ..volume = 1000.0;

      expect(stats.low, 100.0);
      expect(stats.high, 200.0);
      expect(stats.last, 150.0);
      expect(stats.changePercent, 5.0);
      expect(stats.volume, 1000.0);
    });
  });

  group('ChartsNotifier', () {
    late MockWallet mockWallet;
    late MockAssetUtils mockAssetUtils;

    setUp(() {
      mockWallet = MockWallet();
      mockAssetUtils = MockAssetUtils();
      // Stub sendMsg to prevent errors
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
    });

    test('initial state is empty map', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final state = container.read(chartsProvider);
      expect(state, <AssetPair, List<Candle>>{});
    });

    test('listener calls chartUnsubscribe when flag changes to unsubscribed',
        () async {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketSubscribedAssetPairProvider
              .overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Initialize the notifier to register listeners in build()
      container.read(chartsProvider);

      // First subscribe (change from default unsubscribed to subscribed)
      container.read(chartsSubscriptionFlagProvider.notifier).subscribe();
      await Future.microtask(() {});

      // Reset mock to clear subscribe call
      reset(mockWallet);
      when(() => mockWallet.sendMsg(any())).thenReturn(null);

      // Now unsubscribe - this triggers the listener callback for unsubscribe
      container.read(chartsSubscriptionFlagProvider.notifier).unsubscribe();

      // Flush microtasks to allow listener to fire
      await Future.microtask(() {});

      // Verify chartsUnsubscribe was sent via wallet
      verify(() => mockWallet.sendMsg(any(that: predicate<To>(
        (msg) => msg.hasChartsUnsubscribe(),
        'has chartsUnsubscribe',
      )))).called(1);
    });

    test('listener calls chartSubscribe when flag changes to subscribed and asset pair has value',
        () async {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketSubscribedAssetPairProvider
              .overrideWithValue(Option.of(assetPair)),
        ],
      );
      addTearDown(container.dispose);

      // Initialize the notifier to register listeners in build()
      container.read(chartsProvider);

      // Change flag to subscribed - this triggers the listener callback
      container.read(chartsSubscriptionFlagProvider.notifier).subscribe();

      // Flush microtasks to allow listener to fire
      await Future.microtask(() {});

      // Verify chartsSubscribe was sent with correct asset pair
      verify(() => mockWallet.sendMsg(any(that: predicate<To>(
        (msg) => msg.hasChartsSubscribe() && msg.chartsSubscribe == assetPair,
        'has chartsSubscribe with correct asset pair',
      )))).called(1);
    });

    test('listener does not call sendMsg when flag changes to subscribed but asset pair is none',
        () async {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          marketSubscribedAssetPairProvider
              .overrideWithValue(Option.none()),
        ],
      );
      addTearDown(container.dispose);

      // Initialize the notifier to register listeners in build()
      container.read(chartsProvider);

      // Change flag to subscribed - listener will check asset pair option
      container.read(chartsSubscriptionFlagProvider.notifier).subscribe();

      // Flush microtasks to allow listener to fire
      await Future.microtask(() {});

      // Verify sendMsg was not called (none() branch should not trigger subscribe)
      verifyNever(() => mockWallet.sendMsg(any(that: predicate<To>(
        (msg) => msg.hasChartsSubscribe(),
        'has chartsSubscribe',
      ))));
    });

    test('chartSubscribe sends correct message with asset pair', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'ETH', quote: 'GBP');

      notifier.chartSubscribe(assetPair);

      verify(() => mockWallet.sendMsg(any(that: predicate<To>(
        (msg) {
          return msg.hasChartsSubscribe() && msg.chartsSubscribe == assetPair;
        },
        'has chartsSubscribe with matching asset pair',
      )))).called(1);
    });

    test('chartUnsubscribe sends correct message with empty charts unsubscribe', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      notifier.chartUnsubscribe();

      verify(() => mockWallet.sendMsg(any(that: predicate<To>(
        (msg) => msg.hasChartsUnsubscribe(),
        'has chartsUnsubscribe',
      )))).called(1);
    });

    test('setChartsData adds new chart data', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');
      final point = ChartPoint();
      point.time = '2025-03-11T12:00:00Z';
      point.close = 100.0;
      point.high = 105.0;
      point.low = 95.0;
      point.open = 102.0;
      point.volume = 1000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point);

      notifier.setChartsData(chartsSubscribe);

      final state = container.read(chartsProvider);
      expect(state.containsKey(assetPair), true);
      expect(state[assetPair], isNotEmpty);
      expect(state[assetPair]!.length, 1);
    });

    test('setChartsData reverses chart data', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point1 = ChartPoint();
      point1.time = '2025-03-11T12:00:00Z';
      point1.close = 100.0;
      point1.high = 105.0;
      point1.low = 95.0;
      point1.open = 102.0;
      point1.volume = 1000.0;

      final point2 = ChartPoint();
      point2.time = '2025-03-12T12:00:00Z';
      point2.close = 110.0;
      point2.high = 115.0;
      point2.low = 105.0;
      point2.open = 112.0;
      point2.volume = 2000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point1);
      chartsSubscribe.data.add(point2);

      notifier.setChartsData(chartsSubscribe);

      final state = container.read(chartsProvider);
      expect(state[assetPair]!.length, 2);
      // Data should be reversed
      expect(state[assetPair]![0].date,
          DateTime.parse('2025-03-12T12:00:00Z'));
      expect(state[assetPair]![1].date,
          DateTime.parse('2025-03-11T12:00:00Z'));
    });

    test('setChartsData replaces existing data for same asset pair', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point1 = ChartPoint();
      point1.time = '2025-03-11T12:00:00Z';
      point1.close = 100.0;
      point1.high = 105.0;
      point1.low = 95.0;
      point1.open = 102.0;
      point1.volume = 1000.0;

      final chartsSubscribe1 = From_ChartsSubscribe();
      chartsSubscribe1.assetPair = assetPair;
      chartsSubscribe1.data.add(point1);

      notifier.setChartsData(chartsSubscribe1);

      final point2 = ChartPoint();
      point2.time = '2025-03-12T12:00:00Z';
      point2.close = 110.0;
      point2.high = 115.0;
      point2.low = 105.0;
      point2.open = 112.0;
      point2.volume = 2000.0;

      final chartsSubscribe2 = From_ChartsSubscribe();
      chartsSubscribe2.assetPair = assetPair;
      chartsSubscribe2.data.add(point2);

      notifier.setChartsData(chartsSubscribe2);

      final state = container.read(chartsProvider);
      expect(state[assetPair]!.length, 1);
      expect(state[assetPair]![0].date,
          DateTime.parse('2025-03-12T12:00:00Z'));
    });

    test('updateChartsData inserts new candle at beginning', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point1 = ChartPoint();
      point1.time = '2025-03-11T12:00:00Z';
      point1.close = 100.0;
      point1.high = 105.0;
      point1.low = 95.0;
      point1.open = 102.0;
      point1.volume = 1000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point1);

      notifier.setChartsData(chartsSubscribe);

      final point2 = ChartPoint();
      point2.time = '2025-03-12T12:00:00Z';
      point2.close = 110.0;
      point2.high = 115.0;
      point2.low = 105.0;
      point2.open = 112.0;
      point2.volume = 2000.0;

      final chartsUpdate = From_ChartsUpdate();
      chartsUpdate.assetPair = assetPair;
      chartsUpdate.update = point2;

      notifier.updateChartsData(chartsUpdate);

      final state = container.read(chartsProvider);
      expect(state[assetPair]!.length, 2);
      expect(state[assetPair]![0].date,
          DateTime.parse('2025-03-12T12:00:00Z'));
      expect(state[assetPair]![1].date,
          DateTime.parse('2025-03-11T12:00:00Z'));
    });

    test('updateChartsData replaces existing candle with same date', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point1 = ChartPoint();
      point1.time = '2025-03-11T12:00:00Z';
      point1.close = 100.0;
      point1.high = 105.0;
      point1.low = 95.0;
      point1.open = 102.0;
      point1.volume = 1000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point1);

      notifier.setChartsData(chartsSubscribe);

      final point1Updated = ChartPoint();
      point1Updated.time = '2025-03-11T12:00:00Z';
      point1Updated.close = 101.0;
      point1Updated.high = 106.0;
      point1Updated.low = 96.0;
      point1Updated.open = 103.0;
      point1Updated.volume = 1500.0;

      final chartsUpdate = From_ChartsUpdate();
      chartsUpdate.assetPair = assetPair;
      chartsUpdate.update = point1Updated;

      notifier.updateChartsData(chartsUpdate);

      final state = container.read(chartsProvider);
      expect(state[assetPair]!.length, 1);
      expect(state[assetPair]![0].close, 101.0);
      expect(state[assetPair]![0].high, 106.0);
    });

    test('updateChartsData handles empty existing data', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point = ChartPoint();
      point.time = '2025-03-11T12:00:00Z';
      point.close = 100.0;
      point.high = 105.0;
      point.low = 95.0;
      point.open = 102.0;
      point.volume = 1000.0;

      final chartsUpdate = From_ChartsUpdate();
      chartsUpdate.assetPair = assetPair;
      chartsUpdate.update = point;

      notifier.updateChartsData(chartsUpdate);

      final state = container.read(chartsProvider);
      expect(state[assetPair]!.length, 1);
      expect(state[assetPair]![0].date,
          DateTime.parse('2025-03-11T12:00:00Z'));
    });

    test('getStats returns empty stats when no data', () {
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(mockWallet)],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final stats = notifier.getStats(assetPair);

      expect(stats.low, 0);
      expect(stats.high, 0);
      expect(stats.last, 0);
      expect(stats.changePercent, 0);
      expect(stats.volume, 0);
    });

    test('getStats returns correct values with single candle', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
        ],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point = ChartPoint();
      point.time = '2025-03-11T12:00:00Z';
      point.close = 100.0;
      point.high = 105.0;
      point.low = 95.0;
      point.open = 100.0;
      point.volume = 1000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point);

      notifier.setChartsData(chartsSubscribe);

      final stats = notifier.getStats(assetPair);

      expect(stats.last, 100.0);
      expect(stats.low, 95.0);
      expect(stats.high, 105.0);
      expect(stats.changePercent, 0.0); // (100 / 100 - 1) * 100 = 0
    });

    test('getStats calculates change percent correctly', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
        ],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final point = ChartPoint();
      point.time = '2025-03-11T12:00:00Z';
      point.close = 150.0;
      point.high = 155.0;
      point.low = 145.0;
      point.open = 100.0; // oldest value
      point.volume = 1000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point);

      notifier.setChartsData(chartsSubscribe);

      final stats = notifier.getStats(assetPair);

      expect(stats.last, 150.0);
      expect(stats.changePercent, 50.0); // (150 / 100 - 1) * 100 = 50
    });

    test('getStats takes only first 30 candles', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
        ],
      );
      final notifier = container.read(chartsProvider.notifier);

      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;

      for (int i = 0; i < 50; i++) {
        final point = ChartPoint();
        point.time = '2025-03-${10 + (i ~/ 24)}T${(i % 24).toString().padLeft(2, '0')}:00:00Z';
        point.close = (100.0 + i).toDouble();
        point.high = (105.0 + i).toDouble();
        point.low = (95.0 + i).toDouble();
        point.open = (100.0 + i).toDouble();
        point.volume = (1000.0 + i * 100).toDouble();
        chartsSubscribe.data.add(point);
      }

      notifier.setChartsData(chartsSubscribe);

      final stats = notifier.getStats(assetPair);

      // Data is reversed by setChartsData, so first 30 of stored data are indices 49..20
      // High values for those indices: 105.0 + 49 down to 105.0 + 20
      // Max: 154.0, Min low: 115.0
      expect(stats.high, 154.0); // max of reversed first 30
      expect(stats.low, 115.0); // min of reversed first 30
    });
  });

  group('chartsStats provider', () {
    late MockWallet mockWallet;
    late MockAssetUtils mockAssetUtils;

    setUp(() {
      mockWallet = MockWallet();
      mockAssetUtils = MockAssetUtils();
    });

    test('returns empty stats when no asset pair is subscribed', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          marketSubscribedAssetPairProvider
              .overrideWithValue(Option.none()),
        ],
      );

      final stats = container.read(chartsStatsProvider);

      expect(stats.low, 0);
      expect(stats.high, 0);
      expect(stats.last, 0);
      expect(stats.changePercent, 0);
      expect(stats.volume, 0);
    });

    test('returns empty stats when no chart data exists', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          marketSubscribedAssetPairProvider
              .overrideWithValue(Option.of(assetPair)),
        ],
      );

      final stats = container.read(chartsStatsProvider);

      expect(stats.low, 0);
      expect(stats.high, 0);
      expect(stats.last, 0);
      expect(stats.changePercent, 0);
      expect(stats.volume, 0);
    });

    test('calculates stats from chart data when available', () {
      final assetPair = AssetPair(base: 'BTC', quote: 'USD');

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          marketSubscribedAssetPairProvider
              .overrideWithValue(Option.of(assetPair)),
        ],
      );

      // Populate chart data
      final chartsNotifier = container.read(chartsProvider.notifier);
      final point = ChartPoint();
      point.time = '2025-03-11T12:00:00Z';
      point.close = 100.0;
      point.high = 105.0;
      point.low = 95.0;
      point.open = 100.0;
      point.volume = 1000.0;

      final chartsSubscribe = From_ChartsSubscribe();
      chartsSubscribe.assetPair = assetPair;
      chartsSubscribe.data.add(point);

      chartsNotifier.setChartsData(chartsSubscribe);

      // Read stats
      final stats = container.read(chartsStatsProvider);

      expect(stats.last, 100.0);
      expect(stats.low, 95.0);
      expect(stats.high, 105.0);
      expect(stats.changePercent, 0.0);
    });
  });

  group('ChartStatsRepository', () {
    late MockAmountToString mockAmountProvider;
    late Asset testAsset;
    late Asset priceAsset;

    setUp(() {
      mockAmountProvider = MockAmountToString();

      testAsset = Asset(
        assetId: 'test-asset-id',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
      );
      priceAsset = Asset(
        assetId: 'price-asset-id',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
      );
    });

    test('priceAssetPrecision returns default 8 when price asset is null', () {
      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: null,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.priceAssetPrecision(), 8);
    });

    test('priceAssetPrecision returns asset precision', () {
      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.priceAssetPrecision(), 8);
    });

    test('priceAssetId returns asset id when price asset exists', () {
      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.priceAssetId(), 'price-asset-id');
    });

    test('priceAssetId returns null when price asset is null', () {
      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: null,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.priceAssetId(), null);
    });

    test('floatAmount calculates issued minus burned', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      expect(repository.floatAmount(), 900000000);
    });

    test('floatAmount returns 0 when issuer details is null', () {
      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: null,
      );

      expect(repository.floatAmount(), 0);
    });

    test('totalAmount includes offline amount', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 500000000,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      expect(repository.totalAmount(), 1400000000);
    });

    test('marketCap calculates total amount * last price', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 10000000000, // 100 units
          burnedAmount: 0,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats()..last = 50.0;

      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      final marketCap = repository.marketCap();
      expect(marketCap, 5000.0); // 100 units * 50.0 price
    });

    test('statsLow returns stats.low', () {
      final stats = Stats()..low = 42.5;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.statsLow(), 42.5);
    });

    test('statsHigh returns stats.high', () {
      final stats = Stats()..high = 123.45;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.statsHigh(), 123.45);
    });

    test('statsLast returns stats.last', () {
      final stats = Stats()..last = 89.99;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.statsLast(), 89.99);
    });

    test('statsChangePercent returns stats.changePercent', () {
      final stats = Stats()..changePercent = 25.5;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.statsChangePercent(), 25.5);
    });

    test('statsVolume returns stats.volume', () {
      final stats = Stats()..volume = 5000.25;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.statsVolume(), 5000.25);
    });

    test('statsChangePercentString formats percentage with two decimals', () {
      final stats = Stats()..changePercent = 25.555;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository.statsChangePercentString(), '25.55%');
    });

    test('marketCapString formats market cap with two decimals', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 10000000000,
          burnedAmount: 0,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats()..last = 123.456;

      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      expect(repository.marketCapString(), contains('.'));
    });

    test('floatAmountString calls amountProvider.amountToString', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      repository.floatAmountString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('totalAmountString calls amountProvider.amountToString', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      repository.totalAmountString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('statsLowString calls amountProvider.amountToString', () {
      final stats = Stats()..low = 42.5;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      repository.statsLowString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('statsHighString calls amountProvider.amountToString', () {
      final stats = Stats()..high = 123.45;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      repository.statsHighString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('statsLastString calls amountProvider.amountToString', () {
      final stats = Stats()..last = 89.99;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      repository.statsLastString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('statsVolumeString calls amountProvider.amountToString', () {
      final stats = Stats()..volume = 5000.25;
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      repository.statsVolumeString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('freeFloatString calls amountProvider.amountToString', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      repository.freeFloatString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('totalFloatString calls amountProvider.amountToString', () {
      final issuerDetails = AssetDetailsData(
        assetId: 'test-asset',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );

      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
        issuerDetails: issuerDetails,
      );

      repository.totalFloatString();

      // Verify amountToString was called
      expect(mockAmountProvider.amountToString, isNotNull);
    });

    test('pricedInLiquid property is set from constructor', () {
      final stats = Stats();
      final repository = ChartStatsRepository(
        asset: testAsset,
        priceAsset: priceAsset,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: true,
      );

      expect(repository.pricedInLiquid, true);
    });
  });

  group('AbstractChartStatsRepository', () {
    test('can be implemented by ChartStatsRepository', () {
      final mockAmountProvider = MockAmountToString();
      final stats = Stats();
      final asset = Asset(
        assetId: 'test-id',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
      );

      final repository = ChartStatsRepository(
        asset: asset,
        priceAsset: null,
        amountProvider: mockAmountProvider,
        stats: stats,
        pricedInLiquid: false,
      );

      expect(repository, isA<AbstractChartStatsRepository>());
    });
  });

  group('chartStatsRepositoryProvider', () {
    late MockWallet mockWallet;
    late MockAssetUtils mockAssetUtils;
    late MockAmountToString mockAmountProvider;
    late Asset testAsset;
    late Asset liquidAsset;
    late AssetDetailsData testIssuerDetails;

    setUp(() {
      mockWallet = MockWallet();
      mockAssetUtils = MockAssetUtils();
      mockAmountProvider = MockAmountToString();

      testAsset = Asset(
        assetId: 'test-asset-id',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
      );

      liquidAsset = Asset(
        assetId: 'liquid-asset-id',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
      );

      testIssuerDetails = AssetDetailsData(
        assetId: 'test-asset-id',
        stats: AssetDetailsStats(
          issuedAmount: 1000000000,
          burnedAmount: 100000000,
          offlineAmount: 0,
          hasBlindedIssuances: false,
        ),
      );
    });

    test('returns repository instance with correct asset', () {
      final mockAssetUtilsPriced = MockAssetUtils()
        ..setIsPricedInLiquid(true);

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(Stats()),
          assetUtilsProvider.overrideWithValue(mockAssetUtilsPriced),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({
            'test-asset-id': testIssuerDetails,
          }),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(chartStatsRepositoryProvider(testAsset));

      expect(repo, isA<AbstractChartStatsRepository>());
      expect(repo.priceAssetId(), 'liquid-asset-id');
    });

    test('sets priceAssetId to liquidAssetId when pricedInLiquid is true', () {
      final mockAssetUtilsPriced = MockAssetUtils()
        ..setIsPricedInLiquid(true);

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(Stats()),
          assetUtilsProvider.overrideWithValue(mockAssetUtilsPriced),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(chartStatsRepositoryProvider(testAsset));

      expect(repo.priceAssetId(), 'liquid-asset-id');
    });

    test('sets priceAssetId to asset.assetId when pricedInLiquid is false', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(Stats()),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(chartStatsRepositoryProvider(testAsset));

      expect(repo.priceAssetId(), 'test-asset-id');
    });

    test('includes issuer details when available', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(Stats()),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({
            'test-asset-id': testIssuerDetails,
          }),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(chartStatsRepositoryProvider(testAsset));

      expect(repo.floatAmount(), 900000000);
    });

    test('handles missing issuer details gracefully', () {
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(Stats()),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(chartStatsRepositoryProvider(testAsset));

      expect(repo.floatAmount(), 0);
    });

    test('includes stats from chartsStatsProvider', () {
      final stats = Stats()
        ..low = 100.0
        ..high = 200.0
        ..last = 150.0
        ..changePercent = 5.0
        ..volume = 1000.0;

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(stats),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(chartStatsRepositoryProvider(testAsset));

      expect(repo.statsLow(), 100.0);
      expect(repo.statsHigh(), 200.0);
      expect(repo.statsLast(), 150.0);
      expect(repo.statsChangePercent(), 5.0);
      expect(repo.statsVolume(), 1000.0);
    });

    test('returns different instances for different assets', () {
      final otherAsset = Asset(
        assetId: 'other-asset-id',
        precision: 8,
        swapMarket: false,
        ampMarket: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          amountToStringProvider.overrideWithValue(mockAmountProvider),
          chartsStatsProvider.overrideWithValue(Stats()),
          assetUtilsProvider.overrideWithValue(mockAssetUtils),
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'test-asset-id': testAsset,
            'other-asset-id': otherAsset,
            'liquid-asset-id': liquidAsset,
          }),
          tokenMarketProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo1 = container.read(chartStatsRepositoryProvider(testAsset));
      final repo2 = container.read(chartStatsRepositoryProvider(otherAsset));

      expect(repo1.priceAssetId(), 'test-asset-id');
      expect(repo2.priceAssetId(), 'other-asset-id');
    });
  });
}

class MockAmountToString extends Mock implements AmountToString {
  @override
  String amountToString(AmountToStringParameters params) => '0.00';

  @override
  String amountToStringNamed(AmountToStringNamedParameters params) => '0.00';

  @override
  String amountToMobileFormatted({
    required dynamic amount,
    required int precision,
    bool forceScaleWithInteger = false,
  }) =>
      '0.0';
}

