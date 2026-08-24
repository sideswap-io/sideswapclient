import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../utils.dart';

class MockSideswapWallet extends Mock implements SideswapWallet {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Suppress all logging
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(To());
    // Suppress logging to prevent async errors from platform services
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('AssetDetailsStats', () {
    test('creates instance with required values', () {
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      expect(stats.issuedAmount, 100);
      expect(stats.burnedAmount, 50);
      expect(stats.offlineAmount, 25);
      expect(stats.hasBlindedIssuances, true);
    });

    test('copyWith updates specified fields', () {
      final original = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(issuedAmount: 200);

      expect(updated.issuedAmount, 200);
      expect(updated.burnedAmount, 50);
      expect(updated.offlineAmount, 25);
      expect(updated.hasBlindedIssuances, true);
    });

    test('copyWith with all fields', () {
      final original = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(
        issuedAmount: 200,
        burnedAmount: 75,
        offlineAmount: 40,
        hasBlindedIssuances: false,
      );

      expect(updated.issuedAmount, 200);
      expect(updated.burnedAmount, 75);
      expect(updated.offlineAmount, 40);
      expect(updated.hasBlindedIssuances, false);
    });

    test('equality compares all fields', () {
      final stats1 = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );
      final stats2 = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );
      final stats3 = AssetDetailsStats(
        issuedAmount: 101,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      expect(stats1, stats2);
      expect(stats1, isNot(stats3));
    });

    test('hashCode is consistent with equality', () {
      final stats1 = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );
      final stats2 = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      expect(stats1.hashCode, stats2.hashCode);
    });

    test('identical instances are equal', () {
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      expect(stats, stats);
    });

    test('toString returns formatted string', () {
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final str = stats.toString();
      expect(str, contains('issuedAmount: 100'));
      expect(str, contains('burnedAmount: 50'));
      expect(str, contains('offlineAmount: 25'));
      expect(str, contains('hasBlindedIssuances: true'));
    });

    test('copyWith with null issuedAmount keeps original value', () {
      final original = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(issuedAmount: null);

      expect(updated.issuedAmount, 100);
      expect(updated.burnedAmount, 50);
      expect(updated.offlineAmount, 25);
      expect(updated.hasBlindedIssuances, true);
    });

    test('copyWith with null burnedAmount keeps original value', () {
      final original = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(burnedAmount: null);

      expect(updated.issuedAmount, 100);
      expect(updated.burnedAmount, 50);
      expect(updated.offlineAmount, 25);
      expect(updated.hasBlindedIssuances, true);
    });

    test('copyWith with null offlineAmount keeps original value', () {
      final original = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(offlineAmount: null);

      expect(updated.issuedAmount, 100);
      expect(updated.burnedAmount, 50);
      expect(updated.offlineAmount, 25);
      expect(updated.hasBlindedIssuances, true);
    });

    test('copyWith with null hasBlindedIssuances keeps original value', () {
      final original = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(hasBlindedIssuances: null);

      expect(updated.issuedAmount, 100);
      expect(updated.burnedAmount, 50);
      expect(updated.offlineAmount, 25);
      expect(updated.hasBlindedIssuances, true);
    });
  });

  group('AssetChartStats', () {
    test('creates instance with required values', () {
      final stats = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      expect(stats.low, 10.5);
      expect(stats.high, 20.5);
      expect(stats.last, 15.5);
    });

    test('copyWith updates specified fields', () {
      final original = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final updated = original.copyWith(low: 12.5);

      expect(updated.low, 12.5);
      expect(updated.high, 20.5);
      expect(updated.last, 15.5);
    });

    test('copyWith with all fields', () {
      final original = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final updated = original.copyWith(low: 8.5, high: 22.5, last: 18.0);

      expect(updated.low, 8.5);
      expect(updated.high, 22.5);
      expect(updated.last, 18.0);
    });

    test('equality compares all fields', () {
      final stats1 = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);
      final stats2 = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);
      final stats3 = AssetChartStats(low: 10.5, high: 20.5, last: 16.0);

      expect(stats1, stats2);
      expect(stats1, isNot(stats3));
    });

    test('hashCode is consistent with equality', () {
      final stats1 = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);
      final stats2 = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      expect(stats1.hashCode, stats2.hashCode);
    });

    test('identical instances are equal', () {
      final stats = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      expect(stats, stats);
    });

    test('toString returns formatted string', () {
      final stats = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final str = stats.toString();
      expect(str, contains('low: 10.5'));
      expect(str, contains('high: 20.5'));
      expect(str, contains('last: 15.5'));
    });

    test('copyWith with null low keeps original value', () {
      final original = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final updated = original.copyWith(low: null);

      expect(updated.low, 10.5);
      expect(updated.high, 20.5);
      expect(updated.last, 15.5);
    });

    test('copyWith with null high keeps original value', () {
      final original = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final updated = original.copyWith(high: null);

      expect(updated.low, 10.5);
      expect(updated.high, 20.5);
      expect(updated.last, 15.5);
    });

    test('copyWith with null last keeps original value', () {
      final original = AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final updated = original.copyWith(last: null);

      expect(updated.low, 10.5);
      expect(updated.high, 20.5);
      expect(updated.last, 15.5);
    });
  });

  group('AssetDetailsData', () {
    test('creates instance with required and optional values', () {
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );
      final chartStats =
          AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final data = AssetDetailsData(
        assetId: 'asset1',
        stats: stats,
        chartUrl: 'http://example.com',
        chartStats: chartStats,
      );

      expect(data.assetId, 'asset1');
      expect(data.stats, stats);
      expect(data.chartUrl, 'http://example.com');
      expect(data.chartStats, chartStats);
    });

    test('creates instance with nullable fields', () {
      final data =
          AssetDetailsData(assetId: 'asset1', stats: null, chartUrl: null);

      expect(data.assetId, 'asset1');
      expect(data.stats, isNull);
      expect(data.chartUrl, isNull);
      expect(data.chartStats, isNull);
    });

    test('copyWith updates specified fields', () {
      final original = AssetDetailsData(assetId: 'asset1');
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final updated = original.copyWith(stats: stats);

      expect(updated.assetId, 'asset1');
      expect(updated.stats, stats);
      expect(updated.chartUrl, isNull);
    });

    test('copyWith with all fields', () {
      final original = AssetDetailsData(assetId: 'asset1');
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );
      final chartStats =
          AssetChartStats(low: 10.5, high: 20.5, last: 15.5);

      final updated = original.copyWith(
        assetId: 'asset2',
        stats: stats,
        chartUrl: 'http://example.com',
        chartStats: chartStats,
      );

      expect(updated.assetId, 'asset2');
      expect(updated.stats, stats);
      expect(updated.chartUrl, 'http://example.com');
      expect(updated.chartStats, chartStats);
    });

    test('equality compares all fields', () {
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final data1 = AssetDetailsData(assetId: 'asset1', stats: stats);
      final data2 = AssetDetailsData(assetId: 'asset1', stats: stats);
      final data3 = AssetDetailsData(assetId: 'asset2', stats: stats);

      expect(data1, data2);
      expect(data1, isNot(data3));
    });

    test('hashCode is consistent with equality', () {
      final stats = AssetDetailsStats(
        issuedAmount: 100,
        burnedAmount: 50,
        offlineAmount: 25,
        hasBlindedIssuances: true,
      );

      final data1 = AssetDetailsData(assetId: 'asset1', stats: stats);
      final data2 = AssetDetailsData(assetId: 'asset1', stats: stats);

      expect(data1.hashCode, data2.hashCode);
    });

    test('identical instances are equal', () {
      final data = AssetDetailsData(assetId: 'asset1');

      expect(data, data);
    });

    test('toString returns formatted string', () {
      final data = AssetDetailsData(assetId: 'asset1');

      final str = data.toString();
      expect(str, contains('assetId: asset1'));
    });

    test('copyWith with null stats keeps original value', () {
      final original = AssetDetailsData(assetId: 'asset1');

      final updated = original.copyWith(stats: null);

      expect(updated.assetId, 'asset1');
      expect(updated.stats, isNull);
      expect(updated.chartUrl, isNull);
      expect(updated.chartStats, isNull);
    });

    test('copyWith with null chartUrl keeps original value', () {
      final original = AssetDetailsData(assetId: 'asset1', chartUrl: 'http://example.com');

      final updated = original.copyWith(chartUrl: null);

      expect(updated.assetId, 'asset1');
      expect(updated.chartUrl, 'http://example.com');
      expect(updated.stats, isNull);
    });

    test('copyWith with null chartStats keeps original value', () {
      final original = AssetDetailsData(
        assetId: 'asset1',
        chartStats: AssetChartStats(low: 10.5, high: 20.5, last: 15.5),
      );

      final updated = original.copyWith(chartStats: null);

      expect(updated.assetId, 'asset1');
      expect(updated.chartStats, isNotNull);
      expect(updated.chartStats?.low, 10.5);
    });

    test('copyWith with null assetId keeps original value', () {
      final original = AssetDetailsData(assetId: 'asset1');

      final updated = original.copyWith(assetId: null);

      expect(updated.assetId, 'asset1');
    });
  });

  group('TokenMarketDropdownValue', () {
    test('creates instance with required values', () {
      final value = TokenMarketDropdownValue(
        name: 'Bitcoin',
        assetId: 'asset1',
      );

      expect(value.name, 'Bitcoin');
      expect(value.assetId, 'asset1');
    });

    test('copyWith updates specified fields', () {
      final original =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      final updated = original.copyWith(name: 'Ethereum');

      expect(updated.name, 'Ethereum');
      expect(updated.assetId, 'asset1');
    });

    test('copyWith with all fields', () {
      final original =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      final updated = original.copyWith(name: 'Ethereum', assetId: 'asset2');

      expect(updated.name, 'Ethereum');
      expect(updated.assetId, 'asset2');
    });

    test('equality compares all fields', () {
      final value1 =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');
      final value2 =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');
      final value3 =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset2');

      expect(value1, value2);
      expect(value1, isNot(value3));
    });

    test('hashCode is consistent with equality', () {
      final value1 =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');
      final value2 =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      expect(value1.hashCode, value2.hashCode);
    });

    test('identical instances are equal', () {
      final value =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      expect(value, value);
    });

    test('toString returns formatted string', () {
      final value =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      final str = value.toString();
      expect(str, contains('name: Bitcoin'));
      expect(str, contains('assetId: asset1'));
    });

    test('copyWith with null name keeps original value', () {
      final original =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      final updated = original.copyWith(name: null);

      expect(updated.name, 'Bitcoin');
      expect(updated.assetId, 'asset1');
    });

    test('copyWith with null assetId keeps original value', () {
      final original =
          TokenMarketDropdownValue(name: 'Bitcoin', assetId: 'asset1');

      final updated = original.copyWith(assetId: null);

      expect(updated.name, 'Bitcoin');
      expect(updated.assetId, 'asset1');
    });
  });

  group('TokenMarketNotifier', () {
    test('builds empty map initially', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final state = container.read(tokenMarketProvider);

      expect(state, isEmpty);
    });

    test('insertAssetDetails adds new asset to state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      final data = AssetDetailsData(assetId: 'asset1');

      notifier.insertAssetDetails(data);

      final state = container.read(tokenMarketProvider);
      expect(state['asset1'], data);
      expect(state.length, 1);
    });

    test('insertAssetDetails updates existing asset in state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      final data1 = AssetDetailsData(assetId: 'asset1');
      final data2 = AssetDetailsData(
        assetId: 'asset1',
        chartUrl: 'http://example.com',
      );

      notifier.insertAssetDetails(data1);
      notifier.insertAssetDetails(data2);

      final state = container.read(tokenMarketProvider);
      expect(state['asset1'], data2);
      expect(state.length, 1);
    });

    test('insertAssetDetails preserves other assets in state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      final data1 = AssetDetailsData(assetId: 'asset1');
      final data2 = AssetDetailsData(assetId: 'asset2');

      notifier.insertAssetDetails(data1);
      notifier.insertAssetDetails(data2);

      final state = container.read(tokenMarketProvider);
      expect(state['asset1'], data1);
      expect(state['asset2'], data2);
      expect(state.length, 2);
    });

    test('insertAssetDetails triggers state update for listeners', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<Map<String, AssetDetailsData>>();

      container.listen(tokenMarketProvider, listener.call, fireImmediately: true);

      verifyInOrder([() => listener(null, {})]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(tokenMarketProvider.notifier);
      final data = AssetDetailsData(assetId: 'asset1');
      notifier.insertAssetDetails(data);

      verifyInOrder([() => listener({}, {'asset1': data})]);
      verifyNoMoreInteractions(listener);
    });

    test('requestAssetDetails returns early when assetId is null', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      notifier.requestAssetDetails(assetId: null);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('requestAssetDetails sends message when assetId is provided', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      notifier.requestAssetDetails(assetId: 'asset1');

      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('requestAssetDetails creates message with correct assetId', () {
      final mockWallet = MockSideswapWallet();
      final capturedMessage = <To>[];

      when(() => mockWallet.sendMsg(any())).thenAnswer((invocation) {
        capturedMessage.add(invocation.positionalArguments[0] as To);
      });

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      notifier.requestAssetDetails(assetId: 'asset123');

      expect(capturedMessage, hasLength(1));
      expect(capturedMessage[0].hasAssetDetails(), true);
      expect(capturedMessage[0].assetDetails.assetId, 'asset123');
    });

    test('requestAssetDetails with empty string assetId sends message', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(tokenMarketProvider.notifier);
      notifier.requestAssetDetails(assetId: '');

      verify(() => mockWallet.sendMsg(any())).called(1);
    });
  });
}
