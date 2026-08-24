import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap/providers/server_status_providers.dart';

import '../utils.dart';

void main() {
  group('PegInMinimumAmount', () {
    test('initializes with default value of 0', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(pegInMinimumAmountProvider), 0);
    });

    test('updates state when setState is called', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<int>();

      container.listen(
        pegInMinimumAmountProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, 0)]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(pegInMinimumAmountProvider.notifier);
      notifier.setState(1000);

      verifyInOrder([() => listener(0, 1000)]);
      verifyNoMoreInteractions(listener);
      expect(container.read(pegInMinimumAmountProvider), 1000);
    });

    test('updates state multiple times', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(pegInMinimumAmountProvider.notifier);

      notifier.setState(100);
      expect(container.read(pegInMinimumAmountProvider), 100);

      notifier.setState(200);
      expect(container.read(pegInMinimumAmountProvider), 200);
    });
  });

  group('PegInServerFeePercent', () {
    test('initializes with default value of 0.0', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(pegInServerFeePercentProvider), 0.0);
    });

    test('updates state when setState is called', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<double>();

      container.listen(
        pegInServerFeePercentProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, 0.0)]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(pegInServerFeePercentProvider.notifier);
      notifier.setState(2.5);

      verifyInOrder([() => listener(0.0, 2.5)]);
      verifyNoMoreInteractions(listener);
      expect(container.read(pegInServerFeePercentProvider), 2.5);
    });

    test('updates state with different decimal values', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(pegInServerFeePercentProvider.notifier);

      notifier.setState(0.5);
      expect(container.read(pegInServerFeePercentProvider), 0.5);

      notifier.setState(1.25);
      expect(container.read(pegInServerFeePercentProvider), 1.25);

      notifier.setState(10.0);
      expect(container.read(pegInServerFeePercentProvider), 10.0);
    });
  });

  group('PegOutMinimumAmount', () {
    test('initializes with default value of 0', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(pegOutMinimumAmountProvider), 0);
    });

    test('updates state when setState is called', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<int>();

      container.listen(
        pegOutMinimumAmountProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, 0)]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(pegOutMinimumAmountProvider.notifier);
      notifier.setState(5000);

      verifyInOrder([() => listener(0, 5000)]);
      verifyNoMoreInteractions(listener);
      expect(container.read(pegOutMinimumAmountProvider), 5000);
    });

    test('updates state multiple times', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(pegOutMinimumAmountProvider.notifier);

      notifier.setState(500);
      expect(container.read(pegOutMinimumAmountProvider), 500);

      notifier.setState(1500);
      expect(container.read(pegOutMinimumAmountProvider), 1500);
    });
  });

  group('PegOutServerFeePercent', () {
    test('initializes with default value of 0.0', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(pegOutServerFeePercentProvider), 0.0);
    });

    test('updates state when setState is called', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<double>();

      container.listen(
        pegOutServerFeePercentProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, 0.0)]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(pegOutServerFeePercentProvider.notifier);
      notifier.setState(1.75);

      verifyInOrder([() => listener(0.0, 1.75)]);
      verifyNoMoreInteractions(listener);
      expect(container.read(pegOutServerFeePercentProvider), 1.75);
    });

    test('updates state with different decimal values', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(pegOutServerFeePercentProvider.notifier);

      notifier.setState(0.25);
      expect(container.read(pegOutServerFeePercentProvider), 0.25);

      notifier.setState(3.5);
      expect(container.read(pegOutServerFeePercentProvider), 3.5);

      notifier.setState(15.0);
      expect(container.read(pegOutServerFeePercentProvider), 15.0);
    });
  });

  group('BitcoinFeeRates', () {
    test('initializes with empty list', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      expect(container.read(bitcoinFeeRatesProvider), isEmpty);
    });

    test('updates state when setState is called with single fee rate', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<List<FeeRate>>();

      container.listen(
        bitcoinFeeRatesProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, [])]);
      verifyNoMoreInteractions(listener);

      final feeRate = FeeRate(value: 100);
      final notifier = container.read(bitcoinFeeRatesProvider.notifier);
      notifier.setState([feeRate]);

      final result = container.read(bitcoinFeeRatesProvider);
      expect(result, hasLength(1));
      expect(result[0].value, 100);
    });

    test('sorts fee rates by value in ascending order', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(bitcoinFeeRatesProvider.notifier);

      final feeRates = [
        FeeRate(value: 300),
        FeeRate(value: 100),
        FeeRate(value: 200),
      ];

      notifier.setState(feeRates);

      final result = container.read(bitcoinFeeRatesProvider);
      expect(result, hasLength(3));
      expect(result[0].value, 100);
      expect(result[1].value, 200);
      expect(result[2].value, 300);
    });

    test('creates new list and does not mutate input', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(bitcoinFeeRatesProvider.notifier);

      final originalList = [
        FeeRate(value: 200),
        FeeRate(value: 100),
      ];

      notifier.setState(originalList);

      expect(originalList[0].value, 200);
      expect(originalList[1].value, 100);
    });

    test('handles multiple state updates with different orderings', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(bitcoinFeeRatesProvider.notifier);

      // First update
      var feeRates = [
        FeeRate(value: 50),
        FeeRate(value: 150),
        FeeRate(value: 100),
      ];
      notifier.setState(feeRates);
      var result = container.read(bitcoinFeeRatesProvider);
      expect(result.map((e) => e.value), [50, 100, 150]);

      // Second update with different order
      feeRates = [
        FeeRate(value: 300),
        FeeRate(value: 100),
        FeeRate(value: 200),
      ];
      notifier.setState(feeRates);
      result = container.read(bitcoinFeeRatesProvider);
      expect(result.map((e) => e.value), [100, 200, 300]);
    });

    test('handles empty list update', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(bitcoinFeeRatesProvider.notifier);

      notifier.setState([FeeRate(value: 100)]);
      expect(container.read(bitcoinFeeRatesProvider), hasLength(1));

      notifier.setState([]);
      expect(container.read(bitcoinFeeRatesProvider), isEmpty);
    });

    test('handles duplicate values in fee rates', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final notifier = container.read(bitcoinFeeRatesProvider.notifier);

      final feeRates = [
        FeeRate(value: 100),
        FeeRate(value: 100),
        FeeRate(value: 50),
      ];

      notifier.setState(feeRates);

      final result = container.read(bitcoinFeeRatesProvider);
      expect(result, hasLength(3));
      expect(result[0].value, 50);
      expect(result[1].value, 100);
      expect(result[2].value, 100);
    });
  });
}
