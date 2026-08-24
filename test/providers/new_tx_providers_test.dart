import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/new_tx_providers.dart';

import '../utils.dart';

void main() {
  group('NewTxNotifier', () {
    group('build', () {
      test('returns initial state 0', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(newTxProvider), 0);
      });
    });

    group('update', () {
      test('notifies listeners when called', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<int>();
        container.listen(newTxProvider, listener.call, fireImmediately: true);

        // Verify initial state notification
        verifyInOrder([() => listener(null, 0)]);
        verifyNoMoreInteractions(listener);

        // Call update() and verify listener fires even though state value doesn't change
        container.read(newTxProvider.notifier).update();

        // Listener should fire with same state value
        verifyInOrder([() => listener(0, 0)]);
        verifyNoMoreInteractions(listener);
      });

      test('notifies listeners multiple times on repeated calls', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<int>();
        container.listen(newTxProvider, listener.call, fireImmediately: true);

        verifyInOrder([() => listener(null, 0)]);
        verifyNoMoreInteractions(listener);

        // Call update multiple times
        container.read(newTxProvider.notifier).update();
        container.read(newTxProvider.notifier).update();

        // Should notify each time
        verifyInOrder([
          () => listener(0, 0),
          () => listener(0, 0),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('state remains unchanged after update', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        expect(container.read(newTxProvider), 0);

        container.read(newTxProvider.notifier).update();

        expect(container.read(newTxProvider), 0);
      });
    });
  });
}
