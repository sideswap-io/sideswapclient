import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/delete_wallet_providers.dart';

import '../utils.dart';

void main() {
  group('LaunchPageDeleteWalletNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('returns empty state on initialization', () {
        final state = container.read(launchPageDeleteWalletProvider);
        expect(
          state,
          isA<LaunchPageDeleteWalletStateEmpty>(),
        );
      });

      test('initial state matches LaunchPageDeleteWalletState.empty()', () {
        final state = container.read(launchPageDeleteWalletProvider);
        expect(
          state,
          const LaunchPageDeleteWalletStateEmpty(),
        );
      });
    });

    group('setState', () {
      test('updates state to delete when called with delete state', () {
        final notifier =
            container.read(launchPageDeleteWalletProvider.notifier);
        notifier.setState(const LaunchPageDeleteWalletStateDelete());

        final state = container.read(launchPageDeleteWalletProvider);
        expect(
          state,
          isA<LaunchPageDeleteWalletStateDelete>(),
        );
      });

      test('updates state from delete back to empty', () {
        final notifier =
            container.read(launchPageDeleteWalletProvider.notifier);
        notifier.setState(const LaunchPageDeleteWalletStateDelete());
        notifier.setState(const LaunchPageDeleteWalletStateEmpty());

        final state = container.read(launchPageDeleteWalletProvider);
        expect(
          state,
          isA<LaunchPageDeleteWalletStateEmpty>(),
        );
      });

      test('notifies listeners when state changes from empty to delete', () {
        final listener = ProviderListener<LaunchPageDeleteWalletState>();
        container.listen(
          launchPageDeleteWalletProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([
          () => listener(
            null,
            const LaunchPageDeleteWalletStateEmpty(),
          ),
        ]);
        verifyNoMoreInteractions(listener);

        final notifier =
            container.read(launchPageDeleteWalletProvider.notifier);
        notifier.setState(const LaunchPageDeleteWalletStateDelete());

        verifyInOrder([
          () => listener(
            const LaunchPageDeleteWalletStateEmpty(),
            const LaunchPageDeleteWalletStateDelete(),
          ),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('notifies listeners when state changes from delete to empty', () {
        final listener = ProviderListener<LaunchPageDeleteWalletState>();
        final notifier =
            container.read(launchPageDeleteWalletProvider.notifier);

        // Set initial state to delete
        notifier.setState(const LaunchPageDeleteWalletStateDelete());

        // Listen after state is already delete
        container.listen(
          launchPageDeleteWalletProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([
          () => listener(
            null,
            const LaunchPageDeleteWalletStateDelete(),
          ),
        ]);
        verifyNoMoreInteractions(listener);

        // Change back to empty
        notifier.setState(const LaunchPageDeleteWalletStateEmpty());

        verifyInOrder([
          () => listener(
            const LaunchPageDeleteWalletStateDelete(),
            const LaunchPageDeleteWalletStateEmpty(),
          ),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('can set state multiple times in sequence', () {
        final notifier =
            container.read(launchPageDeleteWalletProvider.notifier);

        notifier.setState(const LaunchPageDeleteWalletStateDelete());
        var state = container.read(launchPageDeleteWalletProvider);
        expect(state, isA<LaunchPageDeleteWalletStateDelete>());

        notifier.setState(const LaunchPageDeleteWalletStateEmpty());
        state = container.read(launchPageDeleteWalletProvider);
        expect(state, isA<LaunchPageDeleteWalletStateEmpty>());

        notifier.setState(const LaunchPageDeleteWalletStateDelete());
        state = container.read(launchPageDeleteWalletProvider);
        expect(state, isA<LaunchPageDeleteWalletStateDelete>());
      });
    });

    group('overrideWithValue', () {
      test('overrides provider with specified state', () {
        final overrideContainer = ProviderContainer.test(
          overrides: [
            launchPageDeleteWalletProvider
                .overrideWithValue(const LaunchPageDeleteWalletStateDelete()),
          ],
        );
        addTearDown(overrideContainer.dispose);

        final state = overrideContainer.read(launchPageDeleteWalletProvider);
        expect(state, const LaunchPageDeleteWalletStateDelete());
      });

      test('overrideWithValue with empty state', () {
        final overrideContainer = ProviderContainer.test(
          overrides: [
            launchPageDeleteWalletProvider
                .overrideWithValue(const LaunchPageDeleteWalletStateEmpty()),
          ],
        );
        addTearDown(overrideContainer.dispose);

        final state = overrideContainer.read(launchPageDeleteWalletProvider);
        expect(state, const LaunchPageDeleteWalletStateEmpty());
      });
    });
  });

  group('LaunchPageDeleteWalletState', () {
    test('empty state can be created and compared', () {
      const state1 = LaunchPageDeleteWalletStateEmpty();
      const state2 = LaunchPageDeleteWalletStateEmpty();
      expect(state1, state2);
    });

    test('delete state can be created and compared', () {
      const state1 = LaunchPageDeleteWalletStateDelete();
      const state2 = LaunchPageDeleteWalletStateDelete();
      expect(state1, state2);
    });

    test('empty and delete states are not equal', () {
      const emptyState = LaunchPageDeleteWalletStateEmpty();
      const deleteState = LaunchPageDeleteWalletStateDelete();
      expect(emptyState, isNot(deleteState));
    });
  });
}
