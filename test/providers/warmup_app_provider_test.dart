import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/assets_precache_provider.dart';
import 'package:sideswap/providers/licenses_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap_logger/custom_logger.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

class _FakeNetworkSettingsNotifier extends NetworkSettingsNotifier {
  @override
  NetworkSettingsModel build() => const NetworkSettingsModel.empty();

  @override
  void applySettings() {}
}

ProviderContainer _makeContainer({
  bool clearImageCacheResult = true,
  bool licensesLoaderResult = true,
  bool assetsPrecacheResult = true,
  Future<bool> Function()? clearImageCacheOverride,
  Future<bool> Function()? licensesLoaderOverride,
  Future<bool> Function()? assetsPrecacheOverride,
}) {
  final container = ProviderContainer.test(
    overrides: [
      networkSettingsProvider.overrideWith(_FakeNetworkSettingsNotifier.new),
      clearImageCacheFutureProvider.overrideWith(
        (_) async => clearImageCacheOverride != null
            ? await clearImageCacheOverride()
            : clearImageCacheResult,
      ),
      licensesLoaderFutureProvider.overrideWith(
        (_) async => licensesLoaderOverride != null
            ? await licensesLoaderOverride()
            : licensesLoaderResult,
      ),
      assetsPrecacheFutureProvider.overrideWith(
        (_) async => assetsPrecacheOverride != null
            ? await assetsPrecacheOverride()
            : assetsPrecacheResult,
      ),
    ],
  );
  return container;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('WarmupApp', () {
    group('build', () {
      test('returns uninitialized state initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final state = container.read(warmupAppProvider);
        expect(state.value, const WarmupAppState.uninitialized());
      });
    });

    group('reinitialize', () {
      test('resets state to uninitialized', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        // Initialize first to test the transition
        container.read(warmupAppProvider);
        container
            .read(warmupAppProvider.notifier)
            .state = const AsyncValue.data(WarmupAppState.initialized());
        expect(container.read(warmupAppProvider).value,
            const WarmupAppState.initialized());

        // Reinitialize
        container.read(warmupAppProvider.notifier).reinitialize();

        expect(container.read(warmupAppProvider).value,
            const WarmupAppState.uninitialized());
      });

      test('transitions to uninitialized from loading state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container.read(warmupAppProvider);
        // Simulate loading state
        container
            .read(warmupAppProvider.notifier)
            .state = const AsyncValue.loading();
        expect(container.read(warmupAppProvider).isLoading, true);

        // Reinitialize should set to uninitialized (data state)
        container.read(warmupAppProvider.notifier).reinitialize();

        expect(container.read(warmupAppProvider).value,
            const WarmupAppState.uninitialized());
      });

      test('transitions to uninitialized from error state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container.read(warmupAppProvider);
        // Simulate error state
        container
            .read(warmupAppProvider.notifier)
            .state = AsyncValue.error('Test error', StackTrace.current);
        expect(container.read(warmupAppProvider).hasError, true);

        // Reinitialize should set to uninitialized (data state)
        container.read(warmupAppProvider.notifier).reinitialize();

        expect(container.read(warmupAppProvider).value,
            const WarmupAppState.uninitialized());
      });
    });

    group('initializeApp', () {
      test('happy path: all futures true → state becomes initialized', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        await container.read(warmupAppProvider.notifier).initializeApp();

        expect(container.read(warmupAppProvider).value,
            const WarmupAppState.initialized());
      });

      test('early return: already initialized → no-op', () async {
        final container = _makeContainer();
        addTearDown(container.dispose);

        container
            .read(warmupAppProvider.notifier)
            .state = const AsyncValue.data(WarmupAppState.initialized());

        await container.read(warmupAppProvider.notifier).initializeApp();

        expect(container.read(warmupAppProvider).value,
            const WarmupAppState.initialized());
      });

      for (final testCase in [
        (
          label: 'v1 false: clearImageCache returns false → throws',
          clearResult: false,
          licensesResult: true,
          assetsResult: true,
        ),
        (
          label: 'v2 false: licensesLoader returns false → throws',
          clearResult: true,
          licensesResult: false,
          assetsResult: true,
        ),
        (
          label: 'v3 false: assetsPrecache returns false → throws',
          clearResult: true,
          licensesResult: true,
          assetsResult: false,
        ),
      ]) {
        test(testCase.label, () async {
          final container = _makeContainer(
            clearImageCacheResult: testCase.clearResult,
            licensesLoaderResult: testCase.licensesResult,
            assetsPrecacheResult: testCase.assetsResult,
          );
          addTearDown(container.dispose);

          await expectLater(
            container.read(warmupAppProvider.notifier).initializeApp(),
            throwsA(equals('WarmupApp failed')),
          );
        });
      }

      test('ParallelWaitError: future throws → throws ParallelWaitError', () async {
        final thrownError = Exception('clearImageCache failed');
        final container = ProviderContainer.test(
          overrides: [
            networkSettingsProvider.overrideWith(_FakeNetworkSettingsNotifier.new),
            // overrideWithValue(AsyncError) is needed because keepAlive providers
            // enter retry mode (AsyncLoading) when overrideWith throws, so
            // provider.future never completes; AsyncError state completes immediately.
            clearImageCacheFutureProvider.overrideWithValue(
                AsyncError(thrownError, StackTrace.empty)),
            licensesLoaderFutureProvider.overrideWith((_) => true),
            assetsPrecacheFutureProvider.overrideWith((_) => true),
          ],
        );
        addTearDown(container.dispose);

        await expectLater(
          container.read(warmupAppProvider.notifier).initializeApp(),
          throwsA(isA<ParallelWaitError<dynamic, dynamic>>()),
        );
      });
    });
  });

  group('navigatorKey', () {
    test('returns a GlobalKey<NavigatorState>', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final key = container.read(navigatorKeyProvider);

      expect(key, isA<GlobalKey>());
      expect(key.currentState, isNull);
    });

    test('returns the same instance on multiple reads (keepAlive: true)', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final key1 = container.read(navigatorKeyProvider);
      final key2 = container.read(navigatorKeyProvider);

      expect(key1, same(key2));
    });

    test('returns different instances in different containers', () {
      final container1 = ProviderContainer.test();
      addTearDown(container1.dispose);
      final container2 = ProviderContainer.test();
      addTearDown(container2.dispose);

      final key1 = container1.read(navigatorKeyProvider);
      final key2 = container2.read(navigatorKeyProvider);

      expect(key1, isNot(same(key2)));
    });

    test('key can hold NavigatorState reference', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final key = container.read(navigatorKeyProvider);

      // Key should be able to be used with navigator
      expect(key.currentWidget, isNull); // No widget attached in test
      expect(key.currentContext, isNull); // No context in test
      expect(key.currentState, isNull); // No state in test
    });
  });

  group('WarmupAppState', () {
    test('uninitialized states are equal', () {
      const state1 = WarmupAppState.uninitialized();
      const state2 = WarmupAppState.uninitialized();

      expect(state1, state2);
    });

    test('initialized states are equal', () {
      const state1 = WarmupAppState.initialized();
      const state2 = WarmupAppState.initialized();

      expect(state1, state2);
    });

    test('uninitialized and initialized states are not equal', () {
      const uninitialized = WarmupAppState.uninitialized();
      const initialized = WarmupAppState.initialized();

      expect(uninitialized, isNot(initialized));
    });
  });
}
