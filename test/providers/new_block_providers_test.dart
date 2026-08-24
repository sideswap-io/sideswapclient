import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/new_block_providers.dart';

import '../utils.dart';

void main() {
  group('NewBlockNotifier', () {
    group('build', () {
      test('initializes with 0', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(newBlockProvider), 0);
      });
    });

    group('update', () {
      test('increments state by 1 on single call', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<int>();
        container.listen(
          newBlockProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 0)]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(newBlockProvider.notifier);
        notifier.update();

        verifyInOrder([() => listener(0, 1)]);
        verifyNoMoreInteractions(listener);
        expect(container.read(newBlockProvider), 1);
      });

      test('increments state multiple times sequentially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<int>();
        container.listen(
          newBlockProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 0)]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(newBlockProvider.notifier);

        notifier.update();
        verifyInOrder([() => listener(0, 1)]);
        verifyNoMoreInteractions(listener);

        notifier.update();
        verifyInOrder([() => listener(1, 2)]);
        verifyNoMoreInteractions(listener);

        notifier.update();
        verifyInOrder([() => listener(2, 3)]);
        verifyNoMoreInteractions(listener);

        expect(container.read(newBlockProvider), 3);
      });

      test('updates state correctly with listener tracking', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<int>();
        container.listen(
          newBlockProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, 0)]);

        final notifier = container.read(newBlockProvider.notifier);
        notifier.update();

        expect(container.read(newBlockProvider), 1);
      });
    });

    group('state transitions', () {
      test('maintains correct state across multiple notifier reads', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final notifier1 = container.read(newBlockProvider.notifier);
        notifier1.update();
        expect(container.read(newBlockProvider), 1);

        final notifier2 = container.read(newBlockProvider.notifier);
        notifier2.update();
        expect(container.read(newBlockProvider), 2);

        // Both should refer to the same notifier instance
        expect(identical(notifier1, notifier2), true);
      });

      test('state is isolated per container', () {
        final container1 = ProviderContainer.test();
        final container2 = ProviderContainer.test();
        addTearDown(container1.dispose);
        addTearDown(container2.dispose);

        expect(container1.read(newBlockProvider), 0);
        expect(container2.read(newBlockProvider), 0);

        container1.read(newBlockProvider.notifier).update();
        expect(container1.read(newBlockProvider), 1);
        expect(container2.read(newBlockProvider), 0);
      });
    });
  });
}
