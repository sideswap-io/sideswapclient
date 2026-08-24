import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/first_launch_providers.dart';

import '../utils.dart';

void main() {
  group('FirstLaunchStateNotifier', () {
    group('build', () {
      test('returns empty state initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(firstLaunchStateProvider);

        expect(state, isA<FirstLaunchStateTypeEmpty>());
      });
    });

    group('setFirstLaunchState', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer.test();
        addTearDown(container.dispose);
      });

      test('updates state to create wallet', () {
        final listener = ProviderListener<FirstLaunchStateType>();
        container.listen(
          firstLaunchStateProvider,
          listener.call,
          fireImmediately: true,
        );

        final initialState = container.read(firstLaunchStateProvider);
        expect(initialState, isA<FirstLaunchStateTypeEmpty>());

        final createWalletState = const FirstLaunchStateTypeCreateWallet();
        container
            .read(firstLaunchStateProvider.notifier)
            .setFirstLaunchState(createWalletState);

        verifyInOrder([
          () => listener(null, initialState),
          () => listener(initialState, createWalletState),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('updates state to import wallet', () {
        final listener = ProviderListener<FirstLaunchStateType>();
        container.listen(
          firstLaunchStateProvider,
          listener.call,
          fireImmediately: true,
        );

        final initialState = container.read(firstLaunchStateProvider);
        expect(initialState, isA<FirstLaunchStateTypeEmpty>());

        final importWalletState = const FirstLaunchStateTypeImportWallet();
        container
            .read(firstLaunchStateProvider.notifier)
            .setFirstLaunchState(importWalletState);

        verifyInOrder([
          () => listener(null, initialState),
          () => listener(initialState, importWalletState),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('updates state back to empty', () {
        final createWalletState = const FirstLaunchStateTypeCreateWallet();
        final emptyState = const FirstLaunchStateTypeEmpty();

        // Set to non-empty state first
        container
            .read(firstLaunchStateProvider.notifier)
            .setFirstLaunchState(createWalletState);

        final listener = ProviderListener<FirstLaunchStateType>();
        container.listen(
          firstLaunchStateProvider,
          listener.call,
          fireImmediately: true,
        );

        container
            .read(firstLaunchStateProvider.notifier)
            .setFirstLaunchState(emptyState);

        verifyInOrder([
          () => listener(null, createWalletState),
          () => listener(createWalletState, emptyState),
        ]);
        verifyNoMoreInteractions(listener);
      });
    });
  });
}
