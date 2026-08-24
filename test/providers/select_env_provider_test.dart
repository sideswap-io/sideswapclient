import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/select_env_provider.dart';

import '../utils.dart';

void main() {
  group('SelectEnvDialog', () {
    group('build', () {
      test('returns false as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(selectEnvDialogProvider), false);
      });
    });

    group('setSelectEnvDialog', () {
      test('sets state to true when value is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(true);
        expect(container.read(selectEnvDialogProvider), true);
      });

      test('sets state to false when value is false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(true);
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(false);
        expect(container.read(selectEnvDialogProvider), false);
      });

      test('notifies listeners when state changes', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();
        container.listen(selectEnvDialogProvider, listener.call, fireImmediately: true);
        verifyInOrder([() => listener(null, false)]);
        verifyNoMoreInteractions(listener);

        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(true);
        verifyInOrder([() => listener(false, true)]);
        verifyNoMoreInteractions(listener);
      });

      test('can toggle state multiple times', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(true);
        expect(container.read(selectEnvDialogProvider), true);
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(false);
        expect(container.read(selectEnvDialogProvider), false);
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(true);
        expect(container.read(selectEnvDialogProvider), true);
      });
    });
  });

  group('SelectedEnv', () {
    group('build', () {
      test('returns envProvider value on initialization', () {
        final container = ProviderContainer.test(
          overrides: [
            envProvider.overrideWithValue(1),
          ],
        );
        addTearDown(container.dispose);
        expect(container.read(selectedEnvProvider), 1);
      });

      test('watches envProvider and reflects its initial value', () {
        final container = ProviderContainer.test(
          overrides: [
            envProvider.overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);
        expect(container.read(selectedEnvProvider), 0);
      });
    });

    group('setSelectedEnv', () {
      test('updates state to provided value', () async {
        final container = ProviderContainer.test(
          overrides: [
            envProvider.overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);
        await container.read(selectedEnvProvider.notifier).setSelectedEnv(2);
        expect(container.read(selectedEnvProvider), 2);
      });

      test('notifies listeners when state changes', () async {
        final container = ProviderContainer.test(
          overrides: [
            envProvider.overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);
        final listener = ProviderListener<int>();
        container.listen(selectedEnvProvider, listener.call, fireImmediately: true);
        verifyInOrder([() => listener(null, 0)]);
        verifyNoMoreInteractions(listener);

        await container.read(selectedEnvProvider.notifier).setSelectedEnv(1);
        verifyInOrder([() => listener(0, 1)]);
        verifyNoMoreInteractions(listener);
      });

      test('can set state multiple times to different values', () async {
        final container = ProviderContainer.test(
          overrides: [
            envProvider.overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);
        await container.read(selectedEnvProvider.notifier).setSelectedEnv(1);
        expect(container.read(selectedEnvProvider), 1);
        await container.read(selectedEnvProvider.notifier).setSelectedEnv(3);
        expect(container.read(selectedEnvProvider), 3);
      });
    });
  });

  group('SelectEnvTap', () {
    group('build', () {
      test('returns 0 as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(selectEnvTapProvider), 0);
      });
    });

    group('setTap', () {
      test('increments state by 1 when state is less than 7', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        container.read(selectEnvTapProvider.notifier).setTap();
        expect(container.read(selectEnvTapProvider), 1);
      });

      test('increments state to 7', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        for (int i = 0; i < 7; i++) {
          container.read(selectEnvTapProvider.notifier).setTap();
        }
        expect(container.read(selectEnvTapProvider), 7);
      });

      test('resets state to 0 when state exceeds 7', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        for (int i = 0; i < 8; i++) {
          container.read(selectEnvTapProvider.notifier).setTap();
        }
        expect(container.read(selectEnvTapProvider), 0);
      });

      test('triggers selectEnvDialog when state exceeds 7', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();
        container.listen(selectEnvDialogProvider, listener.call, fireImmediately: true);
        verifyInOrder([() => listener(null, false)]);
        verifyNoMoreInteractions(listener);

        // Tap 8 times to exceed 7
        for (int i = 0; i < 8; i++) {
          container.read(selectEnvTapProvider.notifier).setTap();
        }

        // Verify selectEnvDialog was set to true
        verifyInOrder([() => listener(false, true)]);
        verifyNoMoreInteractions(listener);
      });

      test('notifies listeners with incremented state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<int>();
        container.listen(selectEnvTapProvider, listener.call, fireImmediately: true);
        verifyInOrder([() => listener(null, 0)]);
        verifyNoMoreInteractions(listener);

        container.read(selectEnvTapProvider.notifier).setTap();
        verifyInOrder([() => listener(0, 1)]);
        verifyNoMoreInteractions(listener);
      });

      test('sequence of taps increments correctly then resets', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<int>();
        container.listen(selectEnvTapProvider, listener.call, fireImmediately: true);
        verifyInOrder([() => listener(null, 0)]);
        clearInteractions(listener);

        // Tap 8 times
        for (int i = 0; i < 8; i++) {
          container.read(selectEnvTapProvider.notifier).setTap();
        }

        // Verify sequence: 1, 2, 3, 4, 5, 6, 7, 8, 0 (state increments then resets)
        verifyInOrder([
          () => listener(0, 1),
          () => listener(1, 2),
          () => listener(2, 3),
          () => listener(3, 4),
          () => listener(4, 5),
          () => listener(5, 6),
          () => listener(6, 7),
          () => listener(7, 8),
          () => listener(8, 0),
        ]);
        verifyNoMoreInteractions(listener);
      });

      test('resets state and triggers dialog on every 8th tap', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        // First sequence: tap 8 times
        for (int i = 0; i < 8; i++) {
          container.read(selectEnvTapProvider.notifier).setTap();
        }
        expect(container.read(selectEnvTapProvider), 0);
        expect(container.read(selectEnvDialogProvider), true);

        // Reset dialog
        container.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(false);
        expect(container.read(selectEnvDialogProvider), false);

        // Second sequence: tap 8 more times
        for (int i = 0; i < 8; i++) {
          container.read(selectEnvTapProvider.notifier).setTap();
        }
        expect(container.read(selectEnvTapProvider), 0);
        expect(container.read(selectEnvDialogProvider), true);
      });
    });
  });
}
