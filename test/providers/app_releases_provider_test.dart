import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:logger/logger.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/app_releases.dart';
import 'package:sideswap/providers/app_releases_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/fake_configuration.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  // Shared table-driven cases for newDesktopReleaseAvailable and showNewReleaseFuture
  final cases = [
    (
      description:
          'returns true when desktop build is greater than max(appBuildNumber, knownNewReleaseBuild)',
      knownNewReleaseBuild: 0,
      modelState: AsyncValue<AppReleasesModelState>.data(
        const AppReleasesModelState.data(
          AppReleasesModel(
            desktop: AppReleasesDesktop(build: appBuildNumber + 1),
          ),
        ),
      ),
      expected: true,
    ),
    (
      description:
          'returns true when desktop build is greater than knownNewReleaseBuild',
      knownNewReleaseBuild: appBuildNumber - 5,
      modelState: AsyncValue<AppReleasesModelState>.data(
        const AppReleasesModelState.data(
          AppReleasesModel(
            desktop: AppReleasesDesktop(build: appBuildNumber + 10),
          ),
        ),
      ),
      expected: true,
    ),
    (
      description:
          'returns false when desktop build equals max(appBuildNumber, knownNewReleaseBuild)',
      knownNewReleaseBuild: appBuildNumber + 5,
      modelState: AsyncValue<AppReleasesModelState>.data(
        AppReleasesModelState.data(
          AppReleasesModel(
            desktop: AppReleasesDesktop(build: appBuildNumber + 5),
          ),
        ),
      ),
      expected: false,
    ),
    (
      description: 'returns false when desktop build is less than app build number',
      knownNewReleaseBuild: 0,
      modelState: AsyncValue<AppReleasesModelState>.data(
        const AppReleasesModelState.data(
          AppReleasesModel(
            desktop: AppReleasesDesktop(build: appBuildNumber - 1),
          ),
        ),
      ),
      expected: false,
    ),
    (
      description: 'returns false when desktop is null',
      knownNewReleaseBuild: 0,
      modelState: AsyncValue<AppReleasesModelState>.data(
        const AppReleasesModelState.data(
          AppReleasesModel(desktop: null),
        ),
      ),
      expected: false,
    ),
    (
      description: 'returns false when state is empty',
      knownNewReleaseBuild: 0,
      modelState: AsyncValue<AppReleasesModelState>.data(
        const AppReleasesModelState.empty(),
      ),
      expected: false,
    ),
    (
      description: 'returns false when state is loading',
      knownNewReleaseBuild: 0,
      modelState: const AsyncValue<AppReleasesModelState>.loading(),
      expected: false,
    ),
    (
      description: 'returns false when state has error',
      knownNewReleaseBuild: 0,
      modelState: AsyncValue<AppReleasesModelState>.error(
        Exception('error'),
        StackTrace.empty,
      ),
      expected: false,
    ),
  ];

  group('newDesktopReleaseAvailable', () {
    for (final tc in cases) {
      test(tc.description, () {
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          knownNewReleaseBuild: tc.knownNewReleaseBuild,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(appReleasesStateProvider.notifier);
        notifier.state = tc.modelState;

        final result = notifier.newDesktopReleaseAvailable();
        expect(result, tc.expected);
      });
    }
  });

  group('ackNewDesktopRelease', () {
    test('updates knownNewReleaseBuild when state has data with desktop',
        () {
      final mockConfig = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        knownNewReleaseBuild: 100,
      );

      final latestBuild = appBuildNumber + 50;
      final modelData = AppReleasesModelState.data(
        AppReleasesModel(
          desktop: AppReleasesDesktop(build: latestBuild),
        ),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
        ],
      );
      addTearDown(container.dispose);

      final appReleasesNotifier =
          container.read(appReleasesStateProvider.notifier);
      appReleasesNotifier.state = AsyncValue.data(modelData);
      appReleasesNotifier.ackNewDesktopRelease();

      final updatedConfig = container.read(configurationProvider);
      expect(updatedConfig.knownNewReleaseBuild, latestBuild);
    });

    test('does nothing when state is empty', () {
      final mockConfig = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        knownNewReleaseBuild: 0,
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
        ],
      );
      addTearDown(container.dispose);

      final appReleasesNotifier =
          container.read(appReleasesStateProvider.notifier);
      appReleasesNotifier.state = AsyncValue.data(
        const AppReleasesModelState.empty(),
      );
      appReleasesNotifier.ackNewDesktopRelease();

      final updatedConfig = container.read(configurationProvider);
      expect(updatedConfig.knownNewReleaseBuild, 0);
    });

    test('does nothing when state is loading', () {
      final mockConfig = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        knownNewReleaseBuild: 0,
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
        ],
      );
      addTearDown(container.dispose);

      final appReleasesNotifier =
          container.read(appReleasesStateProvider.notifier);
      appReleasesNotifier.state = const AsyncValue.loading();
      appReleasesNotifier.ackNewDesktopRelease();

      final updatedConfig = container.read(configurationProvider);
      expect(updatedConfig.knownNewReleaseBuild, 0);
    });

    test('does nothing when state has error', () {
      final mockConfig = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        knownNewReleaseBuild: 0,
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
        ],
      );
      addTearDown(container.dispose);

      final appReleasesNotifier =
          container.read(appReleasesStateProvider.notifier);
      appReleasesNotifier.state =
          AsyncValue.error(Exception('error'), StackTrace.current);
      appReleasesNotifier.ackNewDesktopRelease();

      final updatedConfig = container.read(configurationProvider);
      expect(updatedConfig.knownNewReleaseBuild, 0);
    });

    test('does nothing when desktop is null', () {
      final mockConfig = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        knownNewReleaseBuild: 0,
      );

      final modelData = const AppReleasesModelState.data(
        AppReleasesModel(desktop: null),
      );

      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
        ],
      );
      addTearDown(container.dispose);

      final appReleasesNotifier =
          container.read(appReleasesStateProvider.notifier);
      appReleasesNotifier.state = AsyncValue.data(modelData);
      appReleasesNotifier.ackNewDesktopRelease();

      final updatedConfig = container.read(configurationProvider);
      expect(updatedConfig.knownNewReleaseBuild, 0);
    });
  });

  group('showNewReleaseFuture', () {
    for (final tc in cases) {
      test(tc.description, () {
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          knownNewReleaseBuild: tc.knownNewReleaseBuild,
        );

        final container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        container.read(appReleasesStateProvider.notifier).state = tc.modelState;

        final result = container.read(showNewReleaseFutureProvider);
        expect(result.value, tc.expected);
      });
    }
  });

  group('build() and getAppRelease()', () {
    final mockConfig = SideswapSettings.empty(
      mnemonicEncrypted: Uint8List.fromList([]),
      knownNewReleaseBuild: 0,
    );

    test('build returns data state when HTTP 200 with valid JSON', () {
      fakeAsync((async) {
        final mockClient = MockClient(
          (request) async =>
              http.Response('{"desktop":{"build":9999,"version":"1.0"}}', 200),
        );

        http.runWithClient(() {
          final container = ProviderContainer(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(mockConfig),
              ),
            ],
          );

          container.read(appReleasesStateProvider.future);
          async.flushMicrotasks();

          final state = container.read(appReleasesStateProvider);
          expect(state.hasValue, true);
          expect(state.hasError, false);
          expect(state.value, isA<AppReleasesModelStateData>());

          final data = state.value! as AppReleasesModelStateData;
          expect(data.model.desktop?.build, 9999);

          container.dispose();
        }, () => mockClient);
      });
    });

    test('build returns empty state when HTTP non-200', () {
      fakeAsync((async) {
        final mockClient = MockClient(
          (request) async => http.Response('Not Found', 404),
        );

        http.runWithClient(() {
          final container = ProviderContainer(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(mockConfig),
              ),
            ],
          );

          container.read(appReleasesStateProvider.future);
          async.flushMicrotasks();

          final state = container.read(appReleasesStateProvider);
          expect(state.hasValue, true);
          expect(state.value, isA<AppReleasesModelStateEmpty>());

          container.dispose();
        }, () => mockClient);
      });
    });

    test('build returns empty state and logs on exception', () {
      fakeAsync((async) {
        final mockClient = MockClient(
          (request) async => throw Exception('network error'),
        );

        http.runWithClient(() {
          final container = ProviderContainer(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(mockConfig),
              ),
            ],
          );

          container.read(appReleasesStateProvider.future);
          async.flushMicrotasks();

          final state = container.read(appReleasesStateProvider);
          expect(state.hasValue, true);
          expect(state.value, isA<AppReleasesModelStateEmpty>());

          container.dispose();
        }, () => mockClient);
      });
    });

    test('build creates timer that refreshes periodically', () {
      fakeAsync((async) {
        var callCount = 0;
        final mockClient = MockClient((request) async {
          callCount++;
          return http.Response(
            '{"desktop":{"build":${9000 + callCount}}}',
            200,
          );
        });

        http.runWithClient(() {
          final container = ProviderContainer(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(mockConfig),
              ),
            ],
          );

          // Listen to keep auto-dispose provider alive
          container.listen(appReleasesStateProvider, (_, _) {});

          // Trigger initial build (first HTTP call)
          container.read(appReleasesStateProvider.future);
          async.flushMicrotasks();
          expect(callCount, 1);

          // Advance 1 day to fire the Timer.periodic callback (lines 18-19)
          async.elapse(const Duration(days: 1));
          async.flushMicrotasks();

          // Timer callback called getAppRelease() again
          expect(callCount, 2);

          final state = container.read(appReleasesStateProvider);
          expect(state.hasValue, true);

          container.dispose();
        }, () => mockClient);
      });
    });

    test('dispose cancels timer', () {
      fakeAsync((async) {
        var callCount = 0;
        final mockClient = MockClient((request) async {
          callCount++;
          return http.Response('{"desktop":{"build":9999}}', 200);
        });

        http.runWithClient(() {
          final container = ProviderContainer(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(mockConfig),
              ),
            ],
          );

          // Listen to keep provider alive until dispose
          container.listen(appReleasesStateProvider, (_, _) {});

          // Trigger build — timer is created, ref.onDispose registered
          container.read(appReleasesStateProvider.future);
          async.flushMicrotasks();
          expect(callCount, 1);

          // Dispose triggers ref.onDispose -> timer.cancel() (lines 22-23)
          container.dispose();

          // Advance 1 day — timer is cancelled so no more HTTP calls
          async.elapse(const Duration(days: 1));
          async.flushMicrotasks();

          expect(callCount, 1);
        }, () => mockClient);
      });
    });
  });
}
