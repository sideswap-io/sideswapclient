import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/inputs_providers.dart';

import '../utils.dart';

void main() {
  group('InputsWalletFlagType', () {
    test('regular factory creates InputsWalletFlagTypeRegular', () {
      final flag = InputsWalletFlagType.regular();
      expect(flag, isA<InputsWalletFlagTypeRegular>());
    });

    test('amp factory creates InputsWalletFlagTypeAmp', () {
      final flag = InputsWalletFlagType.amp();
      expect(flag, isA<InputsWalletFlagTypeAmp>());
    });

    test('regular and amp are not equal', () {
      final regular = InputsWalletFlagType.regular();
      final amp = InputsWalletFlagType.amp();
      expect(regular, isNot(equals(amp)));
    });

    test('same type instances are equal', () {
      final regular1 = InputsWalletFlagType.regular();
      final regular2 = InputsWalletFlagType.regular();
      expect(regular1, equals(regular2));
    });
  });

  group('InputsWalletFlagNotifier', () {
    group('build', () {
      test('returns InputsWalletFlagType.regular() initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(
          container.read(inputsWalletFlagProvider),
          isA<InputsWalletFlagTypeRegular>(),
        );
      });

      test('initial state equals default regular type', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final state = container.read(inputsWalletFlagProvider);
        expect(state, equals(InputsWalletFlagType.regular()));
      });
    });

    group('setInputsWalletTypeFlag', () {
      test('updates state to provided value', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsWalletFlagProvider.notifier);

        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.amp());

        expect(
          container.read(inputsWalletFlagProvider),
          isA<InputsWalletFlagTypeAmp>(),
        );
      });

      test('can switch from regular to amp', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsWalletFlagProvider.notifier);

        expect(
          container.read(inputsWalletFlagProvider),
          isA<InputsWalletFlagTypeRegular>(),
        );

        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.amp());

        expect(
          container.read(inputsWalletFlagProvider),
          isA<InputsWalletFlagTypeAmp>(),
        );
      });

      test('can switch from amp back to regular', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsWalletFlagProvider.notifier);

        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.amp());
        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.regular());

        expect(
          container.read(inputsWalletFlagProvider),
          isA<InputsWalletFlagTypeRegular>(),
        );
      });

      test('notifies listeners on state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<InputsWalletFlagType>();
        container.listen(
          inputsWalletFlagProvider,
          listener.call,
          fireImmediately: true,
        );

        clearInteractions(listener);

        final previous = container.read(inputsWalletFlagProvider);
        container.read(inputsWalletFlagProvider.notifier)
            .setInputsWalletTypeFlag(InputsWalletFlagType.amp());
        final next = container.read(inputsWalletFlagProvider);

        verify(() => listener(previous, next)).called(1);
      });

      test('multiple consecutive updates are applied', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsWalletFlagProvider.notifier);

        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.amp());
        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.regular());
        notifier.setInputsWalletTypeFlag(InputsWalletFlagType.amp());

        expect(
          container.read(inputsWalletFlagProvider),
          isA<InputsWalletFlagTypeAmp>(),
        );
      });
    });
  });

  group('InputsTxItem', () {
    test('can be created with all fields', () {
      final item = InputsTxItem(tx: '0xabc', satoshi: 1000);
      expect(item.tx, equals('0xabc'));
      expect(item.satoshi, equals(1000));
    });

    test('can be created with null tx', () {
      final item = InputsTxItem(tx: null, satoshi: 500);
      expect(item.tx, isNull);
      expect(item.satoshi, equals(500));
    });

    test('can be created with null satoshi', () {
      final item = InputsTxItem(tx: '0xdef', satoshi: null);
      expect(item.tx, equals('0xdef'));
      expect(item.satoshi, isNull);
    });

    test('can be created with both null', () {
      final item = InputsTxItem();
      expect(item.tx, isNull);
      expect(item.satoshi, isNull);
    });

    test('equality based on field values', () {
      final item1 = InputsTxItem(tx: '0xabc', satoshi: 1000);
      final item2 = InputsTxItem(tx: '0xabc', satoshi: 1000);
      expect(item1, equals(item2));
    });

    test('inequality when tx differs', () {
      final item1 = InputsTxItem(tx: '0xabc', satoshi: 1000);
      final item2 = InputsTxItem(tx: '0xdef', satoshi: 1000);
      expect(item1, isNot(equals(item2)));
    });

    test('inequality when satoshi differs', () {
      final item1 = InputsTxItem(tx: '0xabc', satoshi: 1000);
      final item2 = InputsTxItem(tx: '0xabc', satoshi: 2000);
      expect(item1, isNot(equals(item2)));
    });
  });

  group('InputsAddressItem', () {
    test('can be created with all fields', () {
      final txItems = [InputsTxItem(tx: '0xabc', satoshi: 100)];
      final item = InputsAddressItem(
        address: 'addr123',
        txAmount: 5,
        comment: 'test',
        satoshi: 1000,
        inputsTx: txItems,
      );
      expect(item.address, equals('addr123'));
      expect(item.txAmount, equals(5));
      expect(item.comment, equals('test'));
      expect(item.satoshi, equals(1000));
      expect(item.inputsTx, equals(txItems));
    });

    test('can be created with null fields', () {
      final item = InputsAddressItem();
      expect(item.address, isNull);
      expect(item.txAmount, isNull);
      expect(item.comment, isNull);
      expect(item.satoshi, isNull);
      expect(item.inputsTx, isNull);
    });

    test('can be created with partial fields', () {
      final item = InputsAddressItem(address: 'addr456', satoshi: 500);
      expect(item.address, equals('addr456'));
      expect(item.txAmount, isNull);
      expect(item.comment, isNull);
      expect(item.satoshi, equals(500));
      expect(item.inputsTx, isNull);
    });

    test('equality based on all fields', () {
      final txItems = [InputsTxItem(tx: '0xabc')];
      final item1 = InputsAddressItem(
        address: 'addr123',
        txAmount: 5,
        comment: 'test',
        satoshi: 1000,
        inputsTx: txItems,
      );
      final item2 = InputsAddressItem(
        address: 'addr123',
        txAmount: 5,
        comment: 'test',
        satoshi: 1000,
        inputsTx: txItems,
      );
      expect(item1, equals(item2));
    });

    test('can hold nested InputsTxItem list', () {
      final txItems = [
        InputsTxItem(tx: '0x111', satoshi: 100),
        InputsTxItem(tx: '0x222', satoshi: 200),
      ];
      final item = InputsAddressItem(
        address: 'addr',
        inputsTx: txItems,
      );
      expect(item.inputsTx, hasLength(2));
      expect(item.inputsTx?.first.tx, equals('0x111'));
      expect(item.inputsTx?.last.tx, equals('0x222'));
    });
  });

  group('InputsItem', () {
    test('can be created with inputs list', () {
      final addresses = [
        InputsAddressItem(address: 'addr1'),
        InputsAddressItem(address: 'addr2'),
      ];
      final item = InputsItem(inputs: addresses);
      expect(item.inputs, equals(addresses));
      expect(item.inputs, hasLength(2));
    });

    test('can be created with null inputs', () {
      final item = InputsItem();
      expect(item.inputs, isNull);
    });

    test('can be created with empty inputs list', () {
      final item = InputsItem(inputs: []);
      expect(item.inputs, isEmpty);
    });

    test('equality based on inputs', () {
      final addresses = [InputsAddressItem(address: 'addr1')];
      final item1 = InputsItem(inputs: addresses);
      final item2 = InputsItem(inputs: addresses);
      expect(item1, equals(item2));
    });

    test('can hold nested InputsAddressItem list with InputsTxItem', () {
      final txItems = [InputsTxItem(tx: '0xabc')];
      final addresses = [
        InputsAddressItem(address: 'addr', inputsTx: txItems),
      ];
      final item = InputsItem(inputs: addresses);
      expect(item.inputs?.first.inputsTx, equals(txItems));
    });
  });

  group('InputsNotifier', () {
    group('build', () {
      test('returns empty list initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(inputsProvider), isEmpty);
      });

      test('initial state is list type', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(
          container.read(inputsProvider),
          isA<List<InputsItem>>(),
        );
      });
    });

    group('setInputsItems', () {
      test('updates state with provided list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final items = [InputsItem(inputs: [])];
        final notifier = container.read(inputsProvider.notifier);

        notifier.setInputsItems(items);

        expect(container.read(inputsProvider), equals(items));
      });

      test('replaces entire list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsProvider.notifier);

        final items1 = [InputsItem(inputs: [InputsAddressItem(address: 'a')])];
        notifier.setInputsItems(items1);
        expect(container.read(inputsProvider), equals(items1));

        final items2 = [InputsItem(inputs: [InputsAddressItem(address: 'b')])];
        notifier.setInputsItems(items2);
        expect(container.read(inputsProvider), equals(items2));
      });

      test('can set to empty list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsProvider.notifier);

        notifier.setInputsItems([InputsItem()]);
        notifier.setInputsItems([]);

        expect(container.read(inputsProvider), isEmpty);
      });

      test('notifies listeners on state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<List<InputsItem>>();
        container.listen(
          inputsProvider,
          listener.call,
          fireImmediately: true,
        );

        clearInteractions(listener);

        final previous = container.read(inputsProvider);
        final items = [InputsItem(inputs: [])];
        container.read(inputsProvider.notifier).setInputsItems(items);
        final next = container.read(inputsProvider);

        verify(() => listener(previous, next)).called(1);
      });

      test('can set complex nested structure', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsProvider.notifier);

        final txItems = [
          InputsTxItem(tx: '0x111', satoshi: 100),
          InputsTxItem(tx: '0x222', satoshi: 200),
        ];
        final addresses = [
          InputsAddressItem(
            address: 'addr1',
            txAmount: 2,
            satoshi: 300,
            inputsTx: txItems,
          ),
        ];
        final items = [InputsItem(inputs: addresses)];

        notifier.setInputsItems(items);

        expect(container.read(inputsProvider), equals(items));
        expect(
          container.read(inputsProvider).first.inputs?.first.address,
          equals('addr1'),
        );
      });

      test('multiple consecutive updates are applied', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(inputsProvider.notifier);

        notifier.setInputsItems([]);
        notifier.setInputsItems([InputsItem()]);
        notifier.setInputsItems([]);

        expect(container.read(inputsProvider), isEmpty);
      });
    });
  });

  group('SelectedInputsNotifier', () {
    group('build', () {
      test('returns empty list initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(selectedInputsProvider), isEmpty);
      });

      test('initial state is list type', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(
          container.read(selectedInputsProvider),
          isA<List<InputsTxItem>>(),
        );
      });
    });

    group('setSelectedInputs', () {
      test('updates state with provided list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final items = [InputsTxItem(tx: '0xabc', satoshi: 100)];
        final notifier = container.read(selectedInputsProvider.notifier);

        notifier.setSelectedInputs(items);

        expect(container.read(selectedInputsProvider), equals(items));
      });

      test('replaces entire list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(selectedInputsProvider.notifier);

        final items1 = [InputsTxItem(tx: '0xabc')];
        notifier.setSelectedInputs(items1);
        expect(container.read(selectedInputsProvider), equals(items1));

        final items2 = [InputsTxItem(tx: '0xdef')];
        notifier.setSelectedInputs(items2);
        expect(container.read(selectedInputsProvider), equals(items2));
      });

      test('can set to empty list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(selectedInputsProvider.notifier);

        notifier.setSelectedInputs([InputsTxItem(tx: '0xabc')]);
        notifier.setSelectedInputs([]);

        expect(container.read(selectedInputsProvider), isEmpty);
      });

      test('can hold multiple items', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(selectedInputsProvider.notifier);

        final items = [
          InputsTxItem(tx: '0x111', satoshi: 100),
          InputsTxItem(tx: '0x222', satoshi: 200),
          InputsTxItem(tx: '0x333', satoshi: 300),
        ];
        notifier.setSelectedInputs(items);

        expect(container.read(selectedInputsProvider), equals(items));
        expect(container.read(selectedInputsProvider), hasLength(3));
      });

      test('notifies listeners on state change', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<List<InputsTxItem>>();
        container.listen(
          selectedInputsProvider,
          listener.call,
          fireImmediately: true,
        );

        clearInteractions(listener);

        final previous = container.read(selectedInputsProvider);
        final items = [InputsTxItem(tx: '0xabc')];
        container.read(selectedInputsProvider.notifier)
            .setSelectedInputs(items);
        final next = container.read(selectedInputsProvider);

        verify(() => listener(previous, next)).called(1);
      });

      test('multiple consecutive updates are applied', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(selectedInputsProvider.notifier);

        notifier.setSelectedInputs([InputsTxItem(tx: '0x111')]);
        notifier.setSelectedInputs([InputsTxItem(tx: '0x222')]);
        notifier.setSelectedInputs([]);

        expect(container.read(selectedInputsProvider), isEmpty);
      });

      test('preserves item field values in list', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(selectedInputsProvider.notifier);

        final items = [
          InputsTxItem(tx: '0xabc', satoshi: 999),
          InputsTxItem(tx: '0xdef', satoshi: 888),
        ];
        notifier.setSelectedInputs(items);

        final state = container.read(selectedInputsProvider);
        expect(state[0].tx, equals('0xabc'));
        expect(state[0].satoshi, equals(999));
        expect(state[1].tx, equals('0xdef'));
        expect(state[1].satoshi, equals(888));
      });
    });
  });
}
