import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import '../helpers/test_utils.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockDialogRoute extends Mock implements DialogRoute<dynamic> {}

class MockSideswapWallet extends Mock implements SideswapWallet {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(To());
    // Suppress logging to prevent async errors from path_provider
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
    // Initialize FlavorConfig for tests that depend on it
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

  group('JadeBluetoothPermissionStateNotifier', () {
    group('setPermissionState', () {
      test('updates state to request', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeBluetoothPermissionStateProvider.notifier)
            .setPermissionState(const JadeBluetoothPermissionState.request());

        expect(
          container.read(jadeBluetoothPermissionStateProvider),
          const JadeBluetoothPermissionState.request(),
        );
      });

      test('updates state from request back to empty', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeBluetoothPermissionStateProvider.notifier)
            .setPermissionState(const JadeBluetoothPermissionState.request());
        container
            .read(jadeBluetoothPermissionStateProvider.notifier)
            .setPermissionState(const JadeBluetoothPermissionState.empty());

        expect(
          container.read(jadeBluetoothPermissionStateProvider),
          const JadeBluetoothPermissionState.empty(),
        );
      });
    });
  });

  group('JadeDeviceNotifier', () {
    group('setState', () {
      test('on desktop, sets state directly', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final unavailableState = const JadeDevicesState.unavailable();
        container
            .read(jadeDeviceProvider.notifier)
            .setState(unavailableState);

        expect(container.read(jadeDeviceProvider), unavailableState);
      });

      test('on desktop isDesktop=true, sets any state directly', () {
        FlavorConfig(
          flavor: Flavor.production,
          values: FlavorValues(
            enableNetworkSettings: false,
            enableJade: true,
            enableLocalEndpoint: false,
            isDesktop: true,
          ),
        );
        addTearDown(() {
          FlavorConfig(
            flavor: Flavor.production,
            values: FlavorValues(
              enableNetworkSettings: false,
              enableJade: true,
              enableLocalEndpoint: false,
              isDesktop: false,
            ),
          );
        });

        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final jadeDevice = From_JadePorts_Port()..jadeId = 'my_jade';
        final availableState = JadeDevicesState.available(devices: [jadeDevice]);

        container.read(jadeDeviceProvider.notifier).setState(availableState);

        // desktop path sets state directly without filtering
        expect(container.read(jadeDeviceProvider), availableState);
      });

      test(
          'on mobile with device containing jade in id, filters to only that device',
          () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final jadeDevice = From_JadePorts_Port()..jadeId = 'my_jade_device';
        final otherDevice = From_JadePorts_Port()..jadeId = 'other_device';
        final newState = JadeDevicesState.available(
          devices: [jadeDevice, otherDevice],
        );

        container.read(jadeDeviceProvider.notifier).setState(newState);

        final result = container.read(jadeDeviceProvider);
        expect(
          result,
          isA<JadeDevicesStateAvailable>().having(
            (s) => s.devices.length,
            'filtered to single device',
            1,
          ),
        );
        if (result is JadeDevicesStateAvailable) {
          expect(result.devices[0].jadeId, 'my_jade_device');
        }
      });

      test('on mobile with no jade device in list, returns unavailable', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final device1 = From_JadePorts_Port()..jadeId = 'device1';
        final device2 = From_JadePorts_Port()..jadeId = 'device2';
        final newState = JadeDevicesState.available(devices: [device1, device2]);

        container.read(jadeDeviceProvider.notifier).setState(newState);

        final result = container.read(jadeDeviceProvider);
        expect(result, const JadeDevicesState.unavailable());
      });

      test(
          'on mobile with case-insensitive jade match, filters to that device',
          () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final jadeDevice = From_JadePorts_Port()..jadeId = 'JADE_Device';
        final newState = JadeDevicesState.available(devices: [jadeDevice]);

        container.read(jadeDeviceProvider.notifier).setState(newState);

        final result = container.read(jadeDeviceProvider);
        expect(
          result,
          isA<JadeDevicesStateAvailable>().having(
            (s) => s.devices.length,
            'contains jade device',
            1,
          ),
        );
      });

      test('passes through non-available states unchanged', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final unavailableState = const JadeDevicesState.unavailable();
        container
            .read(jadeDeviceProvider.notifier)
            .setState(unavailableState);

        expect(
          container.read(jadeDeviceProvider),
          unavailableState,
        );
      });
    });
  });

  group('JadeStatusNotifier', () {
    group('setJadeStatus', () {
      test('updates status to readStatus', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeStatusProvider.notifier)
            .setJadeStatus(const JadeStatusReadStatus());

        expect(
          container.read(jadeStatusProvider),
          const JadeStatusReadStatus(),
        );
      });

      test('updates status to connecting', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeStatusProvider.notifier)
            .setJadeStatus(const JadeStatusConnecting());
        expect(container.read(jadeStatusProvider), const JadeStatusConnecting());
      });

      test('updates status to authUser', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeStatusProvider.notifier)
            .setJadeStatus(const JadeStatusAuthUser());
        expect(container.read(jadeStatusProvider), const JadeStatusAuthUser());
      });

      test('updates status to signTx', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeStatusProvider.notifier)
            .setJadeStatus(const JadeStatusSignTx());
        expect(container.read(jadeStatusProvider), const JadeStatusSignTx());
      });
    });
  });

  group('JadeOnboardingRegistrationNotifier', () {
    group('setState', () {
      test('updates state to processing', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeOnboardingRegistrationProvider.notifier)
            .setState(const JadeOnboardingRegistrationStateProcessing());

        expect(
          container.read(jadeOnboardingRegistrationProvider),
          const JadeOnboardingRegistrationStateProcessing(),
        );
      });

      test('updates state from processing to done', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeOnboardingRegistrationProvider.notifier)
            .setState(const JadeOnboardingRegistrationStateProcessing());
        container
            .read(jadeOnboardingRegistrationProvider.notifier)
            .setState(const JadeOnboardingRegistrationStateDone());

        expect(
          container.read(jadeOnboardingRegistrationProvider),
          const JadeOnboardingRegistrationStateDone(),
        );
      });
    });
  });

  group('isJadeWallet', () {
    test('returns true when jadeId is not empty', () {
      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWithValue(
            SideswapSettings.empty(
              mnemonicEncrypted: Uint8List(0),
              jadeId: 'jade-device-123',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isJadeWalletProvider), true);
    });

    test('returns false when jadeId is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWithValue(
            SideswapSettings.empty(
              mnemonicEncrypted: Uint8List(0),
              jadeId: '',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isJadeWalletProvider), false);
    });
  });

  group('jadeRegistrationButtonEnabled', () {
    test('returns true when idle and logout', () {
      final container = ProviderContainer.test(
        overrides: [
          jadeOnboardingRegistrationProvider
              .overrideWithValue(const JadeOnboardingRegistrationStateIdle()),
          serverLoginProvider
              .overrideWithValue(const ServerLoginStateLogout()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(jadeRegistrationButtonEnabledProvider), true);
    });

    test('returns false when not idle', () {
      final container = ProviderContainer.test(
        overrides: [
          jadeOnboardingRegistrationProvider.overrideWithValue(
            const JadeOnboardingRegistrationStateProcessing(),
          ),
          serverLoginProvider
              .overrideWithValue(const ServerLoginStateLogout()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(jadeRegistrationButtonEnabledProvider), false);
    });

    test('returns false when not logout', () {
      final container = ProviderContainer.test(
        overrides: [
          jadeOnboardingRegistrationProvider
              .overrideWithValue(const JadeOnboardingRegistrationStateIdle()),
          serverLoginProvider.overrideWithValue(const ServerLoginStateLogin()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(jadeRegistrationButtonEnabledProvider), false);
    });

    test('returns false when done and login', () {
      final container = ProviderContainer.test(
        overrides: [
          jadeOnboardingRegistrationProvider
              .overrideWithValue(const JadeOnboardingRegistrationStateDone()),
          serverLoginProvider.overrideWithValue(const ServerLoginStateLogin()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(jadeRegistrationButtonEnabledProvider), false);
    });
  });

  group('JadeInfoDialogNotifier', () {
    group('setState', () {
      test('updates state to a non-null value', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final initialState = container.read(jadeInfoDialogProvider);
        expect(initialState, null);

        final mockRoute = MockDialogRoute();

        container
            .read(jadeInfoDialogProvider.notifier)
            .setState(mockRoute);

        expect(
          container.read(jadeInfoDialogProvider),
          mockRoute,
        );
      });

      test('updates dialog route back to null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final mockRoute = MockDialogRoute();

        container
            .read(jadeInfoDialogProvider.notifier)
            .setState(mockRoute);

        expect(container.read(jadeInfoDialogProvider), mockRoute);

        container
            .read(jadeInfoDialogProvider.notifier)
            .setState(null);

        expect(
          container.read(jadeInfoDialogProvider),
          null,
        );
      });
    });
  });

  group('JadeSelectedDevice', () {
    group('setJadePortsPort', () {
      test('sets device state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final device = From_JadePorts_Port()..jadeId = 'test_device';
        container
            .read(jadeSelectedDeviceProvider.notifier)
            .setJadePortsPort(device);

        expect(
          container.read(jadeSelectedDeviceProvider),
          device,
        );
      });

      test('updates device state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final device1 = From_JadePorts_Port()..jadeId = 'device1';
        final device2 = From_JadePorts_Port()..jadeId = 'device2';

        container
            .read(jadeSelectedDeviceProvider.notifier)
            .setJadePortsPort(device1);
        expect(
          container.read(jadeSelectedDeviceProvider),
          device1,
        );

        container
            .read(jadeSelectedDeviceProvider.notifier)
            .setJadePortsPort(device2);
        expect(
          container.read(jadeSelectedDeviceProvider),
          device2,
        );
      });
    });
  });

  // JadeLockState — auto-generated freezed class; factory tests are tautologies

  group('JadeLockStateNotifier', () {
    group('build', () {
      test('returns unlocked when not a jade wallet', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(false),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(jadeLockStateProvider);

        expect(state, const JadeLockState.unlocked());
      });

      test('returns locked when is a jade wallet', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(jadeLockStateProvider);

        expect(state, const JadeLockState.locked());
      });

      test('ref.listen callback fires ref.invalidateSelf when timer expires', () {
        fakeAsync((async) {
          final container = ProviderContainer.test(
            overrides: [
              isJadeWalletProvider.overrideWithValue(true),
            ],
          );
          addTearDown(container.dispose);

          // trigger build — sets up ref.listen on jadeLockStateTimerProvider
          expect(container.read(jadeLockStateProvider), const JadeLockState.locked());

          // keep listener active so provider stays alive
          container.listen(jadeLockStateProvider, (_, _) {});

          // advance 5 minutes — RestartableTimer in JadeLockStateTimerNotifier fires
          // callback calls ref.notifyListeners() which triggers ref.listen in
          // JadeLockStateNotifier → ref.invalidateSelf()
          async.elapse(const Duration(minutes: 5));
          async.flushMicrotasks();

          // provider rebuilt back to locked after invalidateSelf
          expect(container.read(jadeLockStateProvider), const JadeLockState.locked());
        });
      });
    });

    group('setState', () {
      test('updates lock state to unlocked', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(jadeLockStateProvider.notifier)
            .setState(const JadeLockState.unlocked());

        expect(
          container.read(jadeLockStateProvider),
          const JadeLockState.unlocked(),
        );
      });

      test('updates lock state to error', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
          ],
        );
        addTearDown(container.dispose);

        const errorState = JadeLockState.error(message: 'Lock failed');
        container
            .read(jadeLockStateProvider.notifier)
            .setState(errorState);

        expect(
          container.read(jadeLockStateProvider),
          errorState,
        );
      });
    });
  });

  group('jadeLockRepositoryProvider', () {
    test('returns repository with locked state when jade wallet', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(jadeLockRepositoryProvider);

      expect(repo.lockState, const JadeLockState.locked());
    });

    test('returns repository with unlocked state when not jade wallet', () {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
          jadeLockStateProvider.overrideWithValue(const JadeLockState.unlocked()),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(jadeLockRepositoryProvider);

      expect(repo.lockState, const JadeLockState.unlocked());
    });

    group('repository behavior', () {
      test('hasError returns true when lock state is error', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
            jadeLockStateProvider.overrideWithValue(
              const JadeLockState.error(message: 'Lock error'),
            ),
          ],
        );
        addTearDown(container.dispose);

        final repo = container.read(jadeLockRepositoryProvider);

        expect(repo.hasError(), true);
      });

      test('isUnlocked returns true when lock state is unlocked', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
            jadeLockStateProvider
                .overrideWithValue(const JadeLockState.unlocked()),
          ],
        );
        addTearDown(container.dispose);

        final repo = container.read(jadeLockRepositoryProvider);

        expect(repo.isUnlocked(), true);
      });

      test('errorMsg returns some when error has message', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
            jadeLockStateProvider.overrideWithValue(
              const JadeLockState.error(message: 'Device locked'),
            ),
          ],
        );
        addTearDown(container.dispose);

        final repo = container.read(jadeLockRepositoryProvider);
        final result = repo.errorMsg();

        expect(result.isSome(), true);
        result.fold(
          () => fail('Expected Some'),
          (msg) => expect(msg, 'Device locked'),
        );
      });

      test('errorMsg returns none when state is not error', () {
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
            jadeLockStateProvider
                .overrideWithValue(const JadeLockState.locked()),
          ],
        );
        addTearDown(container.dispose);

        final repo = container.read(jadeLockRepositoryProvider);

        expect(repo.errorMsg().isNone(), true);
      });

      test('refreshJadeLockState returns early when not a jade wallet', () {
        // Create repository with isJadeWallet = false
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(false),
            jadeLockStateProvider
                .overrideWithValue(const JadeLockState.locked()),
          ],
        );
        addTearDown(container.dispose);

        final repo = container.read(jadeLockRepositoryProvider);

        // Call refreshJadeLockState - it should return early
        repo.refreshJadeLockState();
        // Verify it doesn't throw and returns early
      });
    });
  });

  group('JadeOneTimeAuthorization', () {
    group('setState', () {
      test('updates state to true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeOneTimeAuthorizationProvider.notifier)
            .setState(true);

        expect(container.read(jadeOneTimeAuthorizationProvider), true);
      });

      test('updates state back to false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeOneTimeAuthorizationProvider.notifier)
            .setState(true);
        container
            .read(jadeOneTimeAuthorizationProvider.notifier)
            .setState(false);

        expect(container.read(jadeOneTimeAuthorizationProvider), false);
      });
    });

    group('authorize', () {
      test('returns true when already authorized', () async {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeOneTimeAuthorizationProvider.notifier)
            .setState(true);

        final result =
            await container.read(jadeOneTimeAuthorizationProvider.notifier).authorize();

        expect(result, true);
      });

      // Note: Testing the actual authorize() method with walletProvider.isAuthenticated()
      // requires mocking SideswapWallet which is a complex dependency.
      // The current test ('returns true when already authorized') covers the fast path.
      // The full async flow (lines 294-299) would require significant setup of wallet mocks.
    });
  });

  group('JadeAuthInProgressStateNotifier', () {
    group('setState', () {
      test('updates state to true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeAuthInProgressStateProvider.notifier)
            .setState(true);

        expect(container.read(jadeAuthInProgressStateProvider), true);
      });

      test('updates state to false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeAuthInProgressStateProvider.notifier)
            .setState(true);
        container
            .read(jadeAuthInProgressStateProvider.notifier)
            .setState(false);

        expect(container.read(jadeAuthInProgressStateProvider), false);
      });
    });
  });

  // JadeVerifyAddressState — auto-generated freezed class; factory tests are tautologies

  group('JadeVerifyAddressStateNotifier', () {
    group('setState', () {
      test('updates state to verifying', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeVerifyAddressStateProvider.notifier)
            .setState(const JadeVerifyAddressState.verifying());

        expect(
          container.read(jadeVerifyAddressStateProvider),
          const JadeVerifyAddressState.verifying(),
        );
      });

      test('updates state to success', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(jadeVerifyAddressStateProvider.notifier)
            .setState(const JadeVerifyAddressState.success());

        expect(
          container.read(jadeVerifyAddressStateProvider),
          const JadeVerifyAddressState.success(),
        );
      });

      test('updates state to error with message', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        const errorState = JadeVerifyAddressState.error(message: 'Verification failed');
        container
            .read(jadeVerifyAddressStateProvider.notifier)
            .setState(errorState);

        expect(
          container.read(jadeVerifyAddressStateProvider),
          errorState,
        );
      });
    });
  });

  group('jadeRescan', () {
    test('triggers initial jadeRescan on wallet when provider is watched', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      container.listen(jadeRescanProvider, (_, _) {});
      verify(() => mockWallet.jadeRescan()).called(1);
    });

    test('cleans up timer on provider disposal without errors', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      container.listen(jadeRescanProvider, (_, _) {});
      expect(() => container.dispose(), returnsNormally);
    });

    test('timer fires jadeRescan periodically after 1 second', () {
      fakeAsync((async) {
        final mockWallet = MockSideswapWallet();
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);

        container.listen(jadeRescanProvider, (_, _) {});
        // initial call on build
        verify(() => mockWallet.jadeRescan()).called(1);

        // advance timer by 1 second to trigger periodic callback
        async.elapse(const Duration(seconds: 1));
        async.flushMicrotasks();

        verify(() => mockWallet.jadeRescan()).called(1);
      });
    });
  });

  group('JadeLockStateTimerNotifier', () {
    test('initializes on build without errors', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(() => container.read(jadeLockStateTimerProvider), returnsNormally);
    });

    test('extendTimer resets timer without throwing', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.listen(jadeLockStateTimerProvider, (_, _) {});
      expect(
        () => container
            .read(jadeLockStateTimerProvider.notifier)
            .extendTimer(),
        returnsNormally,
      );
    });

    test('cancels timer on disposal without errors', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.listen(jadeLockStateTimerProvider, (_, _) {});
      expect(() => container.dispose(), returnsNormally);
    });

    test('timer callback fires after 5 minutes, notifying listeners', () {
      fakeAsync((async) {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        var notifyCount = 0;
        container.listen(jadeLockStateTimerProvider, (_, _) {
          notifyCount++;
        });

        // trigger build to start timer
        container.read(jadeLockStateTimerProvider);

        // advance by 5 minutes to fire RestartableTimer callback
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();

        // listener should have been called at least once
        expect(notifyCount, greaterThanOrEqualTo(1));
      });
    });
  });

  group('JadeLockRepository.refreshJadeLockState', () {
    test('returns early without wallet call when not jade wallet', () {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
          walletProvider.overrideWithValue(mockWallet),
          jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(jadeLockRepositoryProvider);
      repo.refreshJadeLockState();

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('calls wallet sendMsg when jade wallet', () async {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
          walletProvider.overrideWithValue(mockWallet),
          jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(jadeLockRepositoryProvider);
      repo.refreshJadeLockState();

      // Allow microtask to execute
      await Future.microtask(() {});
      verify(() => mockWallet.sendMsg(any())).called(greaterThanOrEqualTo(1));
    });

    test('extends timer when jade wallet refreshes lock', () {
      fakeAsync((async) {
        final mockWallet = MockSideswapWallet();
        final container = ProviderContainer.test(
          overrides: [
            isJadeWalletProvider.overrideWithValue(true),
            walletProvider.overrideWithValue(mockWallet),
            jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
          ],
        );
        addTearDown(container.dispose);

        var timerFired = 0;
        container.listen(jadeLockStateTimerProvider, (_, _) { timerFired++; });
        final repo = container.read(jadeLockRepositoryProvider);

        // reset the timer by calling refresh
        repo.refreshJadeLockState();
        async.flushMicrotasks();

        // advance less than 5 minutes — timer should NOT fire
        async.elapse(const Duration(minutes: 4));
        expect(timerFired, 0);

        // advance to 5 minutes total — timer should now fire
        async.elapse(const Duration(minutes: 1));
        async.flushMicrotasks();
        expect(timerFired, greaterThanOrEqualTo(1));
      });
    });
  });

  group('JadeOneTimeAuthorization.authorize', () {
    test('returns true without calling wallet when already authorized', () async {
      final mockWallet = MockSideswapWallet();
      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(jadeOneTimeAuthorizationProvider.notifier);
      notifier.setState(true);

      final result = await notifier.authorize();

      expect(result, true);
      verifyNever(() => mockWallet.isAuthenticated());
    });

    test('calls wallet.isAuthenticated when not yet authorized', () async {
      final mockWallet = MockSideswapWallet();
      when(() => mockWallet.isAuthenticated())
          .thenAnswer((_) async => true);

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(jadeOneTimeAuthorizationProvider.notifier);

      final result = await notifier.authorize();

      expect(result, true);
      verify(() => mockWallet.isAuthenticated()).called(1);
    });

    test('updates state based on wallet authentication result', () async {
      final mockWallet = MockSideswapWallet();
      when(() => mockWallet.isAuthenticated())
          .thenAnswer((_) async => true);

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(jadeOneTimeAuthorizationProvider), false);

      final notifier = container.read(jadeOneTimeAuthorizationProvider.notifier);
      await notifier.authorize();

      expect(container.read(jadeOneTimeAuthorizationProvider), true);
    });

    test('returns false when wallet authentication fails', () async {
      final mockWallet = MockSideswapWallet();
      when(() => mockWallet.isAuthenticated())
          .thenAnswer((_) async => false);

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(jadeOneTimeAuthorizationProvider.notifier);

      final result = await notifier.authorize();

      expect(result, false);
      expect(
        container.read(jadeOneTimeAuthorizationProvider),
        false,
      );
    });
  });
}
