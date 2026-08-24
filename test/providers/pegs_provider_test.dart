import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class _MockSideswapWallet extends Mock implements SideswapWallet {}

class _MockSwapHelper extends Mock implements SwapHelper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(To());
    registerFallbackValue(From_SubscribedValue());
    registerFallbackValue(From_UpdatedPegs());
  });

  group('PegSubscribedValues', () {
    test('creates instance with default values', () {
      const values = PegSubscribedValues();

      expect(values.pegInMinimumAmount, 0);
      expect(values.pegInWalletBalance, 0);
      expect(values.pegOutMinimumAmount, 0);
      expect(values.pegOutWalletBalance, 0);
      expect(values.pegOutNextBlockFeeRate, 0.0);
    });

    test('creates instance with custom values', () {
      const values = PegSubscribedValues(
        pegInMinimumAmount: 100,
        pegInWalletBalance: 200,
        pegOutMinimumAmount: 300,
        pegOutWalletBalance: 400,
        pegOutNextBlockFeeRate: 1.5,
      );

      expect(values.pegInMinimumAmount, 100);
      expect(values.pegInWalletBalance, 200);
      expect(values.pegOutMinimumAmount, 300);
      expect(values.pegOutWalletBalance, 400);
      expect(values.pegOutNextBlockFeeRate, 1.5);
    });

    test('copyWith updates specified fields', () {
      const original = PegSubscribedValues(
        pegInMinimumAmount: 100,
        pegInWalletBalance: 200,
      );

      final updated = original.copyWith(pegInMinimumAmount: 150);

      expect(updated.pegInMinimumAmount, 150);
      expect(updated.pegInWalletBalance, 200);
    });
  });

  group('AllPegsNotifier', () {
    test('builds empty map initially', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(allPegsProvider), isEmpty);
    });

    test('updates state with new pegs', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final item = TransItem();
      final update = From_UpdatedPegs()..orderId = 'order1';
      update.items.add(item);

      notifier.update(pegs: update);

      final state = container.read(allPegsProvider);
      expect(state['order1'], [item]);
    });

    test('replaces existing pegs for same order id', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final item1 = TransItem();
      final item2 = TransItem();

      final update1 = From_UpdatedPegs()..orderId = 'order1';
      update1.items.add(item1);
      notifier.update(pegs: update1);

      final update2 = From_UpdatedPegs()..orderId = 'order1';
      update2.items.add(item2);
      notifier.update(pegs: update2);

      final state = container.read(allPegsProvider);
      expect(state['order1'], [item2]);
    });

    test('preserves pegs for other orders', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final item1 = TransItem();
      final item2 = TransItem();

      final update1 = From_UpdatedPegs()..orderId = 'order1';
      update1.items.add(item1);
      notifier.update(pegs: update1);

      final update2 = From_UpdatedPegs()..orderId = 'order2';
      update2.items.add(item2);
      notifier.update(pegs: update2);

      final state = container.read(allPegsProvider);
      expect(state['order1'], [item1]);
      expect(state['order2'], [item2]);
    });
  });

  group('allPegsById', () {
    test('returns empty map when allPegs is empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(allPegsByIdProvider), isEmpty);
    });

    test('flattens all pegs into map keyed by id', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final item1 = TransItem()..id = 'peg1';
      final item2 = TransItem()..id = 'peg2';
      final item3 = TransItem()..id = 'peg3';

      final update1 = From_UpdatedPegs()..orderId = 'order1';
      update1.items.addAll([item1, item2]);
      notifier.update(pegs: update1);

      final update2 = From_UpdatedPegs()..orderId = 'order2';
      update2.items.add(item3);
      notifier.update(pegs: update2);

      final state = container.read(allPegsByIdProvider);
      expect(state['peg1'], item1);
      expect(state['peg2'], item2);
      expect(state['peg3'], item3);
      expect(state.length, 3);
    });

    test('rebuilds map when allPegs changes', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final item1 = TransItem()..id = 'peg1';

      final update1 = From_UpdatedPegs()..orderId = 'order1';
      update1.items.add(item1);
      notifier.update(pegs: update1);

      var state = container.read(allPegsByIdProvider);
      expect(state.length, 1);

      final item2 = TransItem()..id = 'peg2';
      final update2 = From_UpdatedPegs()..orderId = 'order2';
      update2.items.add(item2);
      notifier.update(pegs: update2);

      state = container.read(allPegsByIdProvider);
      expect(state.length, 2);
    });
  });

  group('PegSubscribedValueNotifier', () {
    test('builds empty state initially', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final state = container.read(pegSubscribedValueProvider);
      expect(state.pegInMinimumAmount, 0);
      expect(state.pegInWalletBalance, 0);
      // The zero balance is the default, not a value the server sent: the
      // readiness flag stays false so the copy can tell the two apart.
      expect(state.pegInWalletBalanceLoaded, isFalse);
      expect(state.pegOutMinimumAmount, 0);
      expect(state.pegOutWalletBalance, 0);
      expect(state.pegOutNextBlockFeeRate, 0.0);
    });

    test('updates peg in minimum amount', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);
      final update = From_SubscribedValue()..pegInMinAmount = Int64(1000);

      notifier.setState(update);

      final state = container.read(pegSubscribedValueProvider);
      expect(state.pegInMinimumAmount, 1000);
    });

    test('updates peg in wallet balance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);
      final update = From_SubscribedValue()..pegInWalletBalance = Int64(2000);

      notifier.setState(update);

      final state = container.read(pegSubscribedValueProvider);
      expect(state.pegInWalletBalance, 2000);
      // Guard taken: the server sent the field, so readiness flips to true.
      expect(state.pegInWalletBalanceLoaded, isTrue);
    });

    test('marks the wallet balance loaded even when the server sends zero', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);
      final update = From_SubscribedValue()..pegInWalletBalance = Int64(0);

      notifier.setState(update);

      final state = container.read(pegSubscribedValueProvider);
      // A server-confirmed zero is loaded: the flag tracks arrival, not value,
      // so a genuine zero limit is distinguishable from "not loaded".
      expect(state.pegInWalletBalance, 0);
      expect(state.pegInWalletBalanceLoaded, isTrue);
    });

    test('updates peg out minimum amount', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);
      final update = From_SubscribedValue()..pegOutMinAmount = Int64(3000);

      notifier.setState(update);

      final state = container.read(pegSubscribedValueProvider);
      expect(state.pegOutMinimumAmount, 3000);
    });

    test('updates peg out wallet balance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);
      final update = From_SubscribedValue()..pegOutWalletBalance = Int64(4000);

      notifier.setState(update);

      final state = container.read(pegSubscribedValueProvider);
      expect(state.pegOutWalletBalance, 4000);
    });

    test('updates peg out next block fee rate', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);
      final update = From_SubscribedValue()..pegOutNextBlockFeeRate = 5.5;

      notifier.setState(update);

      final state = container.read(pegSubscribedValueProvider);
      expect(state.pegOutNextBlockFeeRate, 5.5);
    });

    test('ignores update if field is not set in From_SubscribedValue', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);

      var update = From_SubscribedValue()..pegInMinAmount = Int64(100);
      notifier.setState(update);

      var state = container.read(pegSubscribedValueProvider);
      expect(state.pegInMinimumAmount, 100);
      expect(state.pegInWalletBalance, 0);
      // Guard not taken: a message without the balance field leaves readiness
      // false, so a still-unknown limit is never read as a genuine zero.
      expect(state.pegInWalletBalanceLoaded, isFalse);

      update = From_SubscribedValue();
      notifier.setState(update);

      state = container.read(pegSubscribedValueProvider);
      expect(state.pegInMinimumAmount, 100);
      expect(state.pegInWalletBalance, 0);
      expect(state.pegInWalletBalanceLoaded, isFalse);
    });

    test('handles multiple updates to same state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegSubscribedValueProvider.notifier);

      var update = From_SubscribedValue()..pegInMinAmount = Int64(100);
      notifier.setState(update);

      var state = container.read(pegSubscribedValueProvider);
      expect(state.pegInMinimumAmount, 100);

      update = From_SubscribedValue()..pegInMinAmount = Int64(200);
      notifier.setState(update);

      state = container.read(pegSubscribedValueProvider);
      expect(state.pegInMinimumAmount, 200);
    });

    test(
      'updates only the specified field when multiple fields could be set',
      () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier = container.read(pegSubscribedValueProvider.notifier);

        var update = From_SubscribedValue()..pegInMinAmount = Int64(100);
        notifier.setState(update);

        var state = container.read(pegSubscribedValueProvider);
        expect(state.pegInMinimumAmount, 100);
        expect(state.pegInWalletBalance, 0);

        update = From_SubscribedValue()..pegInWalletBalance = Int64(200);
        notifier.setState(update);

        state = container.read(pegSubscribedValueProvider);
        expect(state.pegInMinimumAmount, 100);
        expect(state.pegInWalletBalance, 200);
      },
    );
  });

  group('pegOrderIdForTransItem', () {
    test('returns none when trans item not found in any order', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final transItem = TransItem()..id = 'missing';
      final result = container.read(pegOrderIdForTransItemProvider(transItem));

      expect(result.isNone(), true);
    });

    test('returns some with order id when trans item found', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final transItem = TransItem()..id = 'peg1';

      final update = From_UpdatedPegs()..orderId = 'order1';
      update.items.add(transItem);
      notifier.update(pegs: update);

      final result = container.read(pegOrderIdForTransItemProvider(transItem));

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (orderId) {
        expect(orderId, 'order1');
      });
    });

    test('returns correct order id when trans item in multiple orders', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final transItem1 = TransItem()..id = 'peg1';
      final transItem2 = TransItem()..id = 'peg2';

      final update1 = From_UpdatedPegs()..orderId = 'order1';
      update1.items.add(transItem1);
      notifier.update(pegs: update1);

      final update2 = From_UpdatedPegs()..orderId = 'order2';
      update2.items.add(transItem2);
      notifier.update(pegs: update2);

      final result = container.read(pegOrderIdForTransItemProvider(transItem2));

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (orderId) {
        expect(orderId, 'order2');
      });
    });
  });

  group('PegOrderFeeData', () {
    test('creates instance with required fields', () {
      final feeData = PegOrderFeeData(
        feeRate: Decimal.fromInt(10),
        bitcoinNetworkFee: 1000,
      );

      expect(feeData.feeRate, Decimal.fromInt(10));
      expect(feeData.bitcoinNetworkFee, 1000);
    });
  });

  group('PegOrderFeesNotifier', () {
    test('builds empty map initially', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(container.read(pegOrderFeesProvider), isEmpty);
    });

    test('returns early when fee rate is zero', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegOrderFeesProvider.notifier);
      final update = From_UpdatedPegs()
        ..orderId = 'order1'
        ..feeRate = 0.0
        ..bitcoinNetworkFee = Int64(1000);

      notifier.setState(update);

      final state = container.read(pegOrderFeesProvider);
      expect(state, isEmpty);
    });

    test('stores fee data when fee rate is valid', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegOrderFeesProvider.notifier);
      final update = From_UpdatedPegs()
        ..orderId = 'order1'
        ..feeRate = 5.5
        ..bitcoinNetworkFee = Int64(1000);

      notifier.setState(update);

      final state = container.read(pegOrderFeesProvider);
      expect(state['order1'], isNotNull);
      expect(state['order1']!.feeRate, Decimal.parse('5.5'));
      expect(state['order1']!.bitcoinNetworkFee, 1000);
    });

    test('replaces fee data for existing order', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(pegOrderFeesProvider.notifier);

      var update = From_UpdatedPegs()
        ..orderId = 'order1'
        ..feeRate = 5.5
        ..bitcoinNetworkFee = Int64(1000);
      notifier.setState(update);

      update = From_UpdatedPegs()
        ..orderId = 'order1'
        ..feeRate = 6.5
        ..bitcoinNetworkFee = Int64(2000);
      notifier.setState(update);

      final state = container.read(pegOrderFeesProvider);
      expect(state['order1']!.feeRate, Decimal.parse('6.5'));
      expect(state['order1']!.bitcoinNetworkFee, 2000);
    });
  });

  group('pegOrderFeeRates', () {
    test('returns none when order id not found', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final transItem = TransItem()..id = 'missing';
      final result = container.read(pegOrderFeeRatesProvider(transItem));

      expect(result.isNone(), true);
    });

    test('returns none when fee data not found for order', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(allPegsProvider.notifier);
      final transItem = TransItem()..id = 'peg1';

      final update = From_UpdatedPegs()..orderId = 'order1';
      update.items.add(transItem);
      notifier.update(pegs: update);

      final result = container.read(pegOrderFeeRatesProvider(transItem));

      expect(result.isNone(), true);
    });

    test('returns some with fee data when both are found', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final allPegsNotifier = container.read(allPegsProvider.notifier);
      final transItem = TransItem()..id = 'peg1';

      final pegUpdate = From_UpdatedPegs()..orderId = 'order1';
      pegUpdate.items.add(transItem);
      allPegsNotifier.update(pegs: pegUpdate);

      final feesNotifier = container.read(pegOrderFeesProvider.notifier);
      final feeUpdate = From_UpdatedPegs()
        ..orderId = 'order1'
        ..feeRate = 5.5
        ..bitcoinNetworkFee = Int64(1000);
      feesNotifier.setState(feeUpdate);

      final result = container.read(pegOrderFeeRatesProvider(transItem));

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (feeData) {
        expect(feeData.feeRate, Decimal.parse('5.5'));
        expect(feeData.bitcoinNetworkFee, 1000);
      });
    });
  });

  group('availablePegOrderFeeChange', () {
    test('returns false when trans item has no peg', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final transItem = TransItem();
      final result = container.read(
        availablePegOrderFeeChangeProvider(transItem),
      );

      expect(result, false);
    });

    test('returns false when peg is peg-in', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final peg = Peg()..isPegIn = true;
      final transItem = TransItem()..peg = peg;
      final result = container.read(
        availablePegOrderFeeChangeProvider(transItem),
      );

      expect(result, false);
    });

    test('returns false when peg is peg-out but has received txid', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final peg = Peg()
        ..isPegIn = false
        ..txidRecv = 'received_txid';
      final transItem = TransItem()..peg = peg;
      final result = container.read(
        availablePegOrderFeeChangeProvider(transItem),
      );

      expect(result, false);
    });

    test('returns true when peg is peg-out and has empty received txid', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final peg = Peg()
        ..isPegIn = false
        ..txidRecv = '';
      final transItem = TransItem()..peg = peg;
      final result = container.read(
        availablePegOrderFeeChangeProvider(transItem),
      );

      expect(result, true);
    });
  });

  group('pegOutNextBlockFeeRate', () {
    test('delegates to pegRepository', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final pegSubscribedNotifier = container.read(
        pegSubscribedValueProvider.notifier,
      );
      final update = From_SubscribedValue()..pegOutNextBlockFeeRate = 3.5;
      pegSubscribedNotifier.setState(update);

      final result = container.read(pegOutNextBlockFeeRateProvider);

      expect(result, '3.5');
    });
  });

  group('PegOutEditFeeRateHelper', () {
    group('sliderValues', () {
      test('uses fallback when no two-block fee rate found', () {
        final helper = PegOutEditFeeRateHelper([], none());

        final values = helper.sliderValues();

        expect(values.minFee, 1.0);
        expect(values.maxFee, 1.5);
        expect(values.currentFee, 1.0);
      });

      test('uses two-block fee rate when available', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], none());

        final values = helper.sliderValues();

        expect(values.minFee, 1.0);
        expect(values.maxFee, 3.0);
        expect(values.currentFee, 2.0);
      });

      test('clamps current fee to max when selected is above max', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], some('5.0'));

        final values = helper.sliderValues();

        expect(values.currentFee, 3.0);
      });

      test('uses selected fee when it is below max', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], some('2.5'));

        final values = helper.sliderValues();

        expect(values.currentFee, 2.5);
      });

      test('rounds values to 2 decimal places', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.123456;
        final helper = PegOutEditFeeRateHelper([feeRate], none());

        final values = helper.sliderValues();

        expect(values.maxFee, 3.19);
        expect(values.currentFee, 2.12);
      });

      test('handles invalid selected fee string', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], some('invalid'));

        final values = helper.sliderValues();

        expect(values.currentFee, 2.0);
      });

      test('handles multiple fee rates and picks correct two-block rate', () {
        final feeRate1 = FeeRate()
          ..blocks = 1
          ..value = 3.0;
        final feeRate2 = FeeRate()
          ..blocks = 2
          ..value = 2.5;
        final feeRate3 = FeeRate()
          ..blocks = 3
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([
          feeRate1,
          feeRate2,
          feeRate3,
        ], none());

        final values = helper.sliderValues();

        expect(values.currentFee, 2.5);
      });
    });

    group('currentFeeStr', () {
      test('returns N/A when no fee is selected', () {
        final helper = PegOutEditFeeRateHelper([], none());

        expect(helper.currentFeeStr, 'N/A');
      });

      test('returns N/A when selected fee is invalid string', () {
        final helper = PegOutEditFeeRateHelper([], some('invalid'));

        expect(helper.currentFeeStr, 'N/A');
      });

      test('returns formatted fee string with sats suffix', () {
        final helper = PegOutEditFeeRateHelper([], some('2.5'));

        expect(helper.currentFeeStr, '2.50 sats');
      });

      test('formats fee with 2 decimal places', () {
        final helper = PegOutEditFeeRateHelper([], some('2.123'));

        expect(helper.currentFeeStr, '2.12 sats');
      });
    });

    group('defaultFeeRate', () {
      test('returns two-block fee rate when no selection', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], none());

        expect(helper.defaultFeeRate(), 2.0);
      });

      test('returns selected fee when valid and below max', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], some('2.5'));

        expect(helper.defaultFeeRate(), 2.5);
      });

      test('clamps selected fee to max', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], some('5.0'));

        expect(helper.defaultFeeRate(), 3.0);
      });

      test('returns fallback when no two-block rate found', () {
        final helper = PegOutEditFeeRateHelper([], none());

        expect(helper.defaultFeeRate(), 1.0);
      });

      test('handles invalid selected fee string', () {
        final feeRate = FeeRate()
          ..blocks = 2
          ..value = 2.0;
        final helper = PegOutEditFeeRateHelper([feeRate], some('invalid'));

        expect(helper.defaultFeeRate(), 2.0);
      });
    });
  });

  group('PegOutEditFeeRateResult', () {
    test('creates success variant', () {
      const result = PegOutEditFeeRateResult.success();

      result.when(
        success: () => expect(true, true),
        failure: (error) => fail('Expected success'),
      );
    });

    test('creates failure variant with error message', () {
      const error = 'Test error';
      const result = PegOutEditFeeRateResult.failure(error);

      result.when(
        success: () => fail('Expected failure'),
        failure: (msg) => expect(msg, error),
      );
    });
  });

  group('PegOutEditFeeRateResultStream', () {
    test('setResult updates state with success', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(
        pegOutEditFeeRateResultStreamProvider.notifier,
      );
      const result = PegOutEditFeeRateResult.success();

      notifier.setResult(result);

      final state = container.read(pegOutEditFeeRateResultStreamProvider);
      state.whenData((option) {
        option.match(() => fail('Expected some'), (r) => expect(r, result));
      });
    });

    test('setResult updates state with failure', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final notifier = container.read(
        pegOutEditFeeRateResultStreamProvider.notifier,
      );
      const result = PegOutEditFeeRateResult.failure('Test error');

      notifier.setResult(result);

      final state = container.read(pegOutEditFeeRateResultStreamProvider);
      state.whenData((option) {
        option.match(
          () => fail('Expected some'),
          (r) => r.when(
            success: () => fail('Expected failure'),
            failure: (msg) => expect(msg, 'Test error'),
          ),
        );
      });
    });
  });

  group('pegDetailsTransItem', () {
    test('returns none when no current txid', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(pegDetailsTransItemProvider);

      expect(result.isNone(), true);
    });

    test('returns trans item from allTxs when txid found', () {
      final txItem = TransItem()..id = 'tx1';
      final allTxsMap = {'tx1': txItem};

      final container2 = ProviderContainer.test(
        overrides: [
          currentTxPopupItemProvider.overrideWithValue(some('tx1')),
          allTxsProvider.overrideWithValue(allTxsMap),
          allPegsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container2.dispose);

      final result = container2.read(pegDetailsTransItemProvider);

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (item) {
        expect(item.id, 'tx1');
      });
    });

    test('returns peg trans item when found in allPegs by txidRecv', () {
      final pegItem = TransItem()..id = 'peg1';
      final peg = Peg()
        ..txidRecv = 'tx1'
        ..txidSend = '';
      pegItem.peg = peg;

      final allPegsMap = {
        'order1': [pegItem],
      };

      final container2 = ProviderContainer.test(
        overrides: [
          currentTxPopupItemProvider.overrideWithValue(some('tx1')),
          allPegsProvider.overrideWithValue(allPegsMap),
          allTxsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container2.dispose);

      final result = container2.read(pegDetailsTransItemProvider);

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (item) {
        expect(item.peg.txidRecv, 'tx1');
      });
    });

    test('returns peg trans item when found in allPegs by txidSend', () {
      final pegItem = TransItem()..id = 'peg2';
      final peg = Peg()
        ..txidRecv = ''
        ..txidSend = 'tx2';
      pegItem.peg = peg;

      final allPegsMap = {
        'order1': [pegItem],
      };

      final container2 = ProviderContainer.test(
        overrides: [
          currentTxPopupItemProvider.overrideWithValue(some('tx2')),
          allPegsProvider.overrideWithValue(allPegsMap),
          allTxsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container2.dispose);

      final result = container2.read(pegDetailsTransItemProvider);

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (item) {
        expect(item.peg.txidSend, 'tx2');
      });
    });

    test('prefers peg trans item over allTxs trans item', () {
      final txItem = TransItem()..id = 'tx_item';
      final pegItem = TransItem()..id = 'peg_item';
      final peg = Peg()
        ..txidRecv = 'tx1'
        ..txidSend = '';
      pegItem.peg = peg;

      final allTxsMap = {'tx1': txItem};
      final allPegsMap = {
        'order1': [pegItem],
      };

      final container2 = ProviderContainer.test(
        overrides: [
          currentTxPopupItemProvider.overrideWithValue(some('tx1')),
          allPegsProvider.overrideWithValue(allPegsMap),
          allTxsProvider.overrideWithValue(allTxsMap),
        ],
      );
      addTearDown(container2.dispose);

      final result = container2.read(pegDetailsTransItemProvider);

      expect(result.isSome(), true);
      result.match(() => fail('Expected Some'), (item) {
        expect(item.id, 'peg_item');
      });
    });

    test('returns none when txid not found in allTxs or allPegs', () {
      final container = ProviderContainer.test(
        overrides: [
          currentTxPopupItemProvider.overrideWithValue(some('nonexistent')),
          allTxsProvider.overrideWithValue({}),
          allPegsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(pegDetailsTransItemProvider);

      expect(result.isNone(), true);
    });
  });

  group('pegOutEditFeeRateHelper provider', () {
    test('creates helper with empty fee rates list', () {
      final container = ProviderContainer.test(
        overrides: [bitcoinFeeRatesProvider.overrideWithValue([])],
      );
      addTearDown(container.dispose);

      final helper = container.read(pegOutEditFeeRateHelperProvider(none()));

      expect(helper.sliderValues().minFee, 1.0);
      expect(helper.sliderValues().maxFee, 1.5);
    });

    test('creates helper with fee rates', () {
      final feeRate = FeeRate()
        ..blocks = 2
        ..value = 3.0;

      final container = ProviderContainer.test(
        overrides: [
          bitcoinFeeRatesProvider.overrideWithValue([feeRate]),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(pegOutEditFeeRateHelperProvider(none()));

      expect(helper.sliderValues().currentFee, 3.0);
    });

    test('creates helper with selected fee rate', () {
      final feeRate = FeeRate()
        ..blocks = 2
        ..value = 2.5;

      final container = ProviderContainer.test(
        overrides: [
          bitcoinFeeRatesProvider.overrideWithValue([feeRate]),
        ],
      );
      addTearDown(container.dispose);

      final helper = container.read(
        pegOutEditFeeRateHelperProvider(some('2.0')),
      );

      expect(helper.sliderValues().currentFee, 2.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Block B: extractValue
  // ---------------------------------------------------------------------------
  group('PegRepository.extractValue', () {
    Asset buildAsset({int precision = 8}) {
      return Asset()
        ..assetId = 'lbtc'
        ..ticker = 'L-BTC'
        ..precision = precision;
    }

    ProviderContainer makeContainer({
      required Asset? asset,
      int value = 100000000,
    }) {
      final assetsMap = asset != null
          ? <String, Asset>{'lbtc': asset}
          : <String, Asset>{};
      final container = ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(
            const LibClientState.initialized(),
          ),
          serverConnectionProvider.overrideWithValue(true),
          pegSubscribedValueProvider.overrideWithValue(
            PegSubscribedValues(pegInMinimumAmount: value),
          ),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          amountToStringProvider.overrideWithValue(
            AmountToString(locale: 'en'),
          ),
          assetsStateProvider.overrideWithValue(assetsMap),
        ],
      );
      return container;
    }

    test('returns formatted string when asset exists', () {
      final asset = buildAsset(precision: 8);
      final container = makeContainer(asset: asset, value: 100000000);
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      final result = repo.extractValue(100000000);

      expect(result, '1.0');
    });

    test('returns empty string when asset not in map', () {
      final container = makeContainer(asset: null, value: 100000000);
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      final result = repo.extractValue(100000000);

      expect(result, '');
    });

    test('returns formatted zero for value 0', () {
      final asset = buildAsset(precision: 8);
      final container = makeContainer(asset: asset, value: 0);
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      final result = repo.extractValue(0);

      expect(result, '0.0');
    });
  });

  // ---------------------------------------------------------------------------
  // Block C: delegation methods
  // ---------------------------------------------------------------------------
  group('PegRepository delegation methods', () {
    final asset = Asset()
      ..assetId = 'lbtc'
      ..ticker = 'L-BTC'
      ..precision = 8;

    ProviderContainer makeContainer(PegSubscribedValues values) {
      return ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(
            const LibClientState.initialized(),
          ),
          serverConnectionProvider.overrideWithValue(true),
          pegSubscribedValueProvider.overrideWithValue(values),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          amountToStringProvider.overrideWithValue(
            AmountToString(locale: 'en'),
          ),
          assetsStateProvider.overrideWithValue({'lbtc': asset}),
        ],
      );
    }

    final cases = [
      (
        name: 'pegInMinAmount',
        values: const PegSubscribedValues(pegInMinimumAmount: 50000000),
        fieldValue: (PegSubscribedValues v) => v.pegInMinimumAmount,
        method: (AbstractPegRepository r) => r.pegInMinAmount(),
      ),
      (
        name: 'pegInWalletBalance',
        values: const PegSubscribedValues(pegInWalletBalance: 200000000),
        fieldValue: (PegSubscribedValues v) => v.pegInWalletBalance,
        method: (AbstractPegRepository r) => r.pegInWalletBalance(),
      ),
      (
        name: 'pegOutMinAmount',
        values: const PegSubscribedValues(pegOutMinimumAmount: 300000000),
        fieldValue: (PegSubscribedValues v) => v.pegOutMinimumAmount,
        method: (AbstractPegRepository r) => r.pegOutMinAmount(),
      ),
      (
        name: 'pegOutWalletBalance',
        values: const PegSubscribedValues(pegOutWalletBalance: 400000000),
        fieldValue: (PegSubscribedValues v) => v.pegOutWalletBalance,
        method: (AbstractPegRepository r) => r.pegOutWalletBalance(),
      ),
    ];

    for (final c in cases) {
      test('${c.name} delegates to extractValue', () {
        final container = makeContainer(c.values);
        addTearDown(container.dispose);
        final repo = container.read(pegRepositoryProvider);

        final direct = repo.extractValue(c.fieldValue(c.values));
        final via = c.method(repo);

        expect(via, equals(direct));
        expect(via, isNotEmpty);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // Block D: pegInInstantCreditAvailable
  // ---------------------------------------------------------------------------
  group('PegRepository.pegInInstantCreditAvailable', () {
    ProviderContainer makeContainer({required int pegInWalletBalance}) {
      return ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(
            const LibClientState.initialized(),
          ),
          serverConnectionProvider.overrideWithValue(true),
          pegSubscribedValueProvider.overrideWithValue(
            PegSubscribedValues(pegInWalletBalance: pegInWalletBalance),
          ),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        ],
      );
    }

    test('is true when the instant credit limit is above zero', () {
      final container = makeContainer(pegInWalletBalance: 200000000);
      addTearDown(container.dispose);
      final repo = container.read(pegRepositoryProvider);

      expect(repo.pegInInstantCreditAvailable(), isTrue);
    });

    test('is false when the instant credit limit is zero', () {
      final container = makeContainer(pegInWalletBalance: 0);
      addTearDown(container.dispose);
      final repo = container.read(pegRepositoryProvider);

      expect(repo.pegInInstantCreditAvailable(), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Block D2: pegInWalletBalanceLoaded
  // ---------------------------------------------------------------------------
  group('PegRepository.pegInWalletBalanceLoaded', () {
    ProviderContainer makeContainer({required bool loaded}) {
      return ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(
            const LibClientState.initialized(),
          ),
          serverConnectionProvider.overrideWithValue(true),
          pegSubscribedValueProvider.overrideWithValue(
            PegSubscribedValues(pegInWalletBalanceLoaded: loaded),
          ),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        ],
      );
    }

    test('is true once the server has sent the instant credit limit', () {
      final container = makeContainer(loaded: true);
      addTearDown(container.dispose);
      final repo = container.read(pegRepositoryProvider);

      expect(repo.pegInWalletBalanceLoaded(), isTrue);
    });

    test('is false before the server has sent the instant credit limit', () {
      final container = makeContainer(loaded: false);
      addTearDown(container.dispose);
      final repo = container.read(pegRepositoryProvider);

      expect(repo.pegInWalletBalanceLoaded(), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Block A: setActivePage
  // ---------------------------------------------------------------------------
  group('PegRepository.setActivePage', () {
    late _MockSideswapWallet mockWallet;

    setUp(() {
      mockWallet = _MockSideswapWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
    });

    ProviderContainer makeContainer({
      required LibClientState libClientState,
      required bool serverConnected,
    }) {
      return ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          libClientStateProvider.overrideWithValue(libClientState),
          serverConnectionProvider.overrideWithValue(serverConnected),
          pegSubscribedValueProvider.overrideWithValue(
            const PegSubscribedValues(),
          ),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
        ],
      );
    }

    test('no-op when activePage equals currentActivePage', () {
      final container = makeContainer(
        libClientState: const LibClientState.initialized(),
        serverConnected: true,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.setActivePage(activePage: ActivePage.OTHER);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('no-op when libClientState is not initialized', () {
      final container = makeContainer(
        libClientState: const LibClientState.empty(),
        serverConnected: true,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.setActivePage(activePage: ActivePage.PEG_IN);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('no-op when server not connected', () {
      final container = makeContainer(
        libClientState: const LibClientState.initialized(),
        serverConnected: false,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.setActivePage(activePage: ActivePage.PEG_IN);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('happy path: sends msg and updates currentActivePage', () {
      final container = makeContainer(
        libClientState: const LibClientState.initialized(),
        serverConnected: true,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.setActivePage(activePage: ActivePage.PEG_IN);

      verify(
        () => mockWallet.sendMsg(
          any(
            that: isA<To>().having(
              (m) => m.activePage,
              'activePage',
              ActivePage.PEG_IN,
            ),
          ),
        ),
      ).called(1);
      expect((repo as PegRepository).currentActivePage, ActivePage.PEG_IN);
    });

    test('happy path: second call with same page is no-op after first', () {
      final container = makeContainer(
        libClientState: const LibClientState.initialized(),
        serverConnected: true,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.setActivePage(activePage: ActivePage.PEG_IN);
      repo.setActivePage(activePage: ActivePage.PEG_IN);

      verify(() => mockWallet.sendMsg(any())).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // Block D: getPegOutAmount
  // ---------------------------------------------------------------------------
  group('PegRepository.getPegOutAmount', () {
    late _MockSideswapWallet mockWallet;
    late _MockSwapHelper mockSwapHelper;

    setUp(() {
      mockWallet = _MockSideswapWallet();
      mockSwapHelper = _MockSwapHelper();
      when(
        () => mockWallet.getPegOutAmount(any(), any(), any()),
      ).thenReturn(null);
      when(() => mockSwapHelper.clearNetworkStates()).thenReturn(null);
    });

    ProviderContainer makeContainer({
      required SwapType swapType,
      required SwapPriceSubscribeState subscribeState,
      required Option<double> feeRate,
      int sendAmount = 0,
      int recvAmount = 0,
    }) {
      return ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
          libClientStateProvider.overrideWithValue(
            const LibClientState.initialized(),
          ),
          serverConnectionProvider.overrideWithValue(true),
          pegSubscribedValueProvider.overrideWithValue(
            const PegSubscribedValues(),
          ),
          liquidAssetIdStateProvider.overrideWithValue('lbtc'),
          swapTypeProvider.overrideWithValue(swapType),
          swapPriceSubscribeProvider.overrideWithValue(subscribeState),
          bitcoinCurrentFeeRateProvider.overrideWithValue(feeRate),
          swapSendSatoshiAmountProvider.overrideWithValue(sendAmount),
          swapRecvSatoshiAmountProvider.overrideWithValue(recvAmount),
          swapHelperProvider.overrideWithValue(mockSwapHelper),
        ],
      );
    }

    test('always calls clearNetworkStates', () {
      final container = makeContainer(
        swapType: const SwapType.pegIn(),
        subscribeState: const SwapPriceSubscribeState.empty(),
        feeRate: none(),
        sendAmount: 0,
        recvAmount: 0,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.getPegOutAmount();

      verify(() => mockSwapHelper.clearNetworkStates()).called(1);
    });

    test('does not call wallet when swapType is not pegOut', () {
      final container = makeContainer(
        swapType: const SwapType.pegIn(),
        subscribeState: const SwapPriceSubscribeState.send(),
        feeRate: some(1.0),
        sendAmount: 100000,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.getPegOutAmount();

      verifyNever(() => mockWallet.getPegOutAmount(any(), any(), any()));
    });

    test('does not call wallet when amounts are zero', () {
      final container = makeContainer(
        swapType: const SwapType.pegOut(),
        subscribeState: const SwapPriceSubscribeState.send(),
        feeRate: some(1.0),
        sendAmount: 0,
        recvAmount: 0,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.getPegOutAmount();

      verifyNever(() => mockWallet.getPegOutAmount(any(), any(), any()));
    });

    test('does not call wallet when feeRate is None', () {
      final container = makeContainer(
        swapType: const SwapType.pegOut(),
        subscribeState: const SwapPriceSubscribeState.send(),
        feeRate: none(),
        sendAmount: 100000,
        recvAmount: 0,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.getPegOutAmount();

      verifyNever(() => mockWallet.getPegOutAmount(any(), any(), any()));
    });

    test(
      'calls wallet.getPegOutAmount when pegOut, sendAmount > 0, feeRate is Some',
      () {
        const sendSats = 100000;
        final container = makeContainer(
          swapType: const SwapType.pegOut(),
          subscribeState: const SwapPriceSubscribeState.send(),
          feeRate: some(2.5),
          sendAmount: sendSats,
          recvAmount: 0,
        );
        addTearDown(container.dispose);

        final repo = container.read(pegRepositoryProvider);
        repo.getPegOutAmount();

        verify(() => mockWallet.getPegOutAmount(sendSats, null, 2.5)).called(1);
      },
    );

    test(
      'calls wallet.getPegOutAmount when pegOut, recvAmount > 0, feeRate is Some',
      () {
        const recvSats = 200000;
        final container = makeContainer(
          swapType: const SwapType.pegOut(),
          subscribeState: const SwapPriceSubscribeState.recv(),
          feeRate: some(1.5),
          sendAmount: 0,
          recvAmount: recvSats,
        );
        addTearDown(container.dispose);

        final repo = container.read(pegRepositoryProvider);
        repo.getPegOutAmount();

        verify(() => mockWallet.getPegOutAmount(null, recvSats, 1.5)).called(1);
      },
    );

    test('sendAmount null when subscribe state is recv', () {
      const recvSats = 300000;
      final container = makeContainer(
        swapType: const SwapType.pegOut(),
        subscribeState: const SwapPriceSubscribeState.recv(),
        feeRate: some(3.0),
        sendAmount: 999,
        recvAmount: recvSats,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.getPegOutAmount();

      // sendAmount is ignored (set to null) when subscribeState == recv
      verify(() => mockWallet.getPegOutAmount(null, recvSats, 3.0)).called(1);
    });

    test('recvAmount null when subscribe state is send', () {
      const sendSats = 400000;
      final container = makeContainer(
        swapType: const SwapType.pegOut(),
        subscribeState: const SwapPriceSubscribeState.send(),
        feeRate: some(4.0),
        sendAmount: sendSats,
        recvAmount: 888,
      );
      addTearDown(container.dispose);

      final repo = container.read(pegRepositoryProvider);
      repo.getPegOutAmount();

      // recvAmount ignored (null) when subscribeState == send
      verify(() => mockWallet.getPegOutAmount(sendSats, null, 4.0)).called(1);
    });

    test(
      'does not call wallet when subscribeState is empty (both amounts null)',
      () {
        final container = makeContainer(
          swapType: const SwapType.pegOut(),
          subscribeState: const SwapPriceSubscribeState.empty(),
          feeRate: some(1.0),
          sendAmount: 100000,
          recvAmount: 100000,
        );
        addTearDown(container.dispose);

        final repo = container.read(pegRepositoryProvider);
        repo.getPegOutAmount();

        verifyNever(() => mockWallet.getPegOutAmount(any(), any(), any()));
      },
    );
  });
}
