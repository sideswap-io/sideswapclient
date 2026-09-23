import 'dart:async';
import 'dart:typed_data';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/test_utils.dart';

class MockSideswapWallet extends Mock implements SideswapWallet {}

const _blob = PinDataStateData(
  salt: 'salt',
  encryptedData: 'encrypted',
  pinIdentifier: 'identifier',
  hmac: 'hmac',
);

/// Builds a container with the setup screen's providers held open.
///
/// Every provider here is auto-dispose, and the screen holds them by watching
/// them. Without the listens a provider written on an asynchronous path is
/// disposed before the assertion reads it, and reports its default instead of
/// what the code wrote.
ProviderContainer _container({
  SideswapWallet? wallet,
  bool biometricEnabled = false,
  bool holdHelper = true,
}) {
  final container = ProviderContainer.test(
    overrides: [
      if (wallet != null) walletProvider.overrideWithValue(wallet),
      isBiometricEnabledProvider.overrideWithValue(biometricEnabled),
      configurationProvider.overrideWith(
        () => FakeConfiguration(
          SideswapSettings.empty(
            mnemonicEncrypted: Uint8List(0),
            usePinProtection: false,
            useBiometricProtection: false,
          ),
        ),
      ),
    ],
  );

  // `holdHelper: false` models the screen being gone: nothing holds the
  // auto-dispose helper, so its `Ref` dies at the next microtask.
  if (holdHelper) {
    container.listen(pinHelperProvider, (_, _) {});
  }
  container.listen(pinSetupStateProvider, (_, _) {});
  container.listen(pinFieldStateProvider, (_, _) {});
  container.listen(firstPinProvider, (_, _) {});
  container.listen(secondPinProvider, (_, _) {});
  container.listen(firstPinEnabledProvider, (_, _) {});
  container.listen(secondPinEnabledProvider, (_, _) {});
  container.listen(pinSetupCallerProvider, (_, _) {});
  container.listen(pinSetupExitProvider, (_, _) {});
  container.listen(pinDataProvider, (_, _) {});
  container.listen(pageStatusProvider, (_, _) {});

  return container;
}

/// Drives the form to a filled, matching pair sitting on the confirm field.
void _fillMatchingPins(ProviderContainer container, String pin) {
  container.read(firstPinProvider.notifier).setFirstPin(pin);
  container
      .read(pinFieldStateProvider.notifier)
      .setPinFieldState(const PinFieldState.second());
  container.read(secondPinProvider.notifier).setSecondPin(pin);
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  group('PinDataNotifier', () {
    test('starts empty', () {
      final container = _container();

      expect(container.read(pinDataProvider), const PinDataState.empty());
    });

    test('holds the reply it is given', () {
      final container = _container();

      container
          .read(pinDataProvider.notifier)
          .setPinDataState(const PinDataState.error(message: 'boom'));

      expect(
        container.read(pinDataProvider),
        const PinDataState.error(message: 'boom'),
      );
    });
  });

  group('PinSetupCallerNotifier', () {
    test('starts empty', () {
      final container = _container();

      expect(
        container.read(pinSetupCallerProvider),
        const PinSetupCallerState.empty(),
      );
    });

    test('holds the caller it is given', () {
      final container = _container();

      container
          .read(pinSetupCallerProvider.notifier)
          .setPinSetupCallerState(const PinSetupCallerState.settings());

      expect(
        container.read(pinSetupCallerProvider),
        const PinSetupCallerState.settings(),
      );
    });
  });

  group('PinSetupExitNotifier', () {
    test('starts empty', () {
      final container = _container();

      expect(
        container.read(pinSetupExitProvider),
        const PinSetupExitState.empty(),
      );
    });

    test('holds the exit it is given', () {
      final container = _container();

      container
          .read(pinSetupExitProvider.notifier)
          .setPinSetupExitState(const PinSetupExitState.back());

      expect(
        container.read(pinSetupExitProvider),
        const PinSetupExitState.back(),
      );
    });
  });

  group('PinFieldStateNotifier', () {
    test('starts on the first field', () {
      final container = _container();

      expect(
        container.read(pinFieldStateProvider),
        const PinFieldState.first(),
      );
    });

    test('holds the field it is given', () {
      final container = _container();

      container
          .read(pinFieldStateProvider.notifier)
          .setPinFieldState(const PinFieldState.second());

      expect(
        container.read(pinFieldStateProvider),
        const PinFieldState.second(),
      );
    });
  });

  group('PinSetupStateNotifier', () {
    test('starts idle', () {
      final container = _container();

      expect(container.read(pinSetupStateProvider), const PinSetupState.idle());
    });

    test('holds the message it is given', () {
      final container = _container();

      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));

      expect(
        container.read(pinSetupStateProvider),
        const PinSetupState.error(message: 'wrong'),
      );
    });
  });

  group('PinSetupAttempt', () {
    test('starts with no attempt outstanding', () {
      final container = _container();

      expect(
        container.read(pinSetupAttemptProvider),
        const PinSetupAttemptState.none(),
      );
    });

    test('open holds the attempt', () {
      final container = _container();

      container.read(pinSetupAttemptProvider.notifier).open();

      expect(
        container.read(pinSetupAttemptProvider),
        const PinSetupAttemptState.outstanding(),
      );

      container.read(pinSetupAttemptProvider.notifier).release();
    });

    test('open does nothing while an attempt is outstanding', () {
      fakeAsync((async) {
        final container = _container();

        container.read(pinSetupAttemptProvider.notifier).open();
        async.elapse(pinSetupAttemptOverdueAfter);
        container.read(pinSetupAttemptProvider.notifier).open();

        // The second open neither restarted the wait nor replaced the attempt.
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.outstanding(overdue: true),
        );

        container.read(pinSetupAttemptProvider.notifier).release();
      });
    });

    test('release gives the attempt back', () {
      final container = _container();

      container.read(pinSetupAttemptProvider.notifier).open();
      container.read(pinSetupAttemptProvider.notifier).release();

      expect(
        container.read(pinSetupAttemptProvider),
        const PinSetupAttemptState.none(),
      );
    });

    test('release with nothing outstanding changes nothing', () {
      final container = _container();

      container.read(pinSetupAttemptProvider.notifier).release();

      expect(
        container.read(pinSetupAttemptProvider),
        const PinSetupAttemptState.none(),
      );
    });

    test('the attempt goes overdue after the threshold, and stays held', () {
      fakeAsync((async) {
        final container = _container();

        container.read(pinSetupAttemptProvider.notifier).open();
        async.elapse(pinSetupAttemptOverdueAfter);

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.outstanding(overdue: true),
        );

        container.read(pinSetupAttemptProvider.notifier).release();
      });
    });

    test('a released attempt never goes overdue', () {
      fakeAsync((async) {
        final container = _container();

        container.read(pinSetupAttemptProvider.notifier).open();
        container.read(pinSetupAttemptProvider.notifier).release();
        async.elapse(pinSetupAttemptOverdueAfter * 2);

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
      });
    });

    test('disposing the container cancels the wait', () {
      fakeAsync((async) {
        final container = _container();

        container.read(pinSetupAttemptProvider.notifier).open();
        container.dispose();
        async.elapse(pinSetupAttemptOverdueAfter * 2);

        // No timer survives the container, so nothing writes to a dead
        // notifier.
        expect(async.pendingTimers, isEmpty);
      });
    });
  });

  group('FirstPinEnabled', () {
    test('is open while no attempt is outstanding', () {
      final container = _container();

      expect(container.read(firstPinEnabledProvider), isTrue);
    });

    test('closes while an attempt is outstanding', () {
      final container = _container();

      container.read(pinSetupAttemptProvider.notifier).open();

      expect(container.read(firstPinEnabledProvider), isFalse);

      container.read(pinSetupAttemptProvider.notifier).release();
    });

    test('opens again when the attempt is given back', () {
      final container = _container();

      container.read(pinSetupAttemptProvider.notifier).open();
      container.read(pinSetupAttemptProvider.notifier).release();

      expect(container.read(firstPinEnabledProvider), isTrue);
    });

    test('a form message leaves it open', () {
      final container = _container();

      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));

      expect(container.read(firstPinEnabledProvider), isTrue);
    });
  });

  group('SecondPinEnabled', () {
    test('is closed while the first PIN is short', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('12345');

      expect(container.read(secondPinEnabledProvider), isFalse);
    });

    test('opens at six characters', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');

      expect(container.read(secondPinEnabledProvider), isTrue);
    });

    test('closes again below six characters', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');
      container.read(firstPinProvider.notifier).setFirstPin('12345');

      expect(container.read(secondPinEnabledProvider), isFalse);
    });

    test('closes while an attempt is outstanding, however long the PIN', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');
      container.read(pinSetupAttemptProvider.notifier).open();

      expect(container.read(secondPinEnabledProvider), isFalse);

      container.read(pinSetupAttemptProvider.notifier).release();
    });

    test('a form message leaves it open', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');
      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));

      expect(container.read(secondPinEnabledProvider), isTrue);
    });
  });

  group('FirstPinNotifier', () {
    test('takes the value while the field is open', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');

      expect(container.read(firstPinProvider), '123456');
    });

    test('refuses the value while the field is closed', () {
      final container = _container();

      container.read(pinSetupAttemptProvider.notifier).open();
      container.read(firstPinProvider.notifier).setFirstPin('123456');

      expect(container.read(firstPinProvider), '');

      container.read(pinSetupAttemptProvider.notifier).release();
    });

    test('the first keystroke clears the message', () {
      final container = _container();

      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));
      container.read(firstPinProvider.notifier).setFirstPin('1');

      expect(container.read(pinSetupStateProvider), const PinSetupState.idle());
    });
  });

  group('SecondPinNotifier', () {
    test('takes the value while the field is open', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');
      container.read(secondPinProvider.notifier).setSecondPin('654321');

      expect(container.read(secondPinProvider), '654321');
    });

    test('refuses the value while the field is closed', () {
      final container = _container();

      container.read(secondPinProvider.notifier).setSecondPin('654321');

      expect(container.read(secondPinProvider), '');
    });

    test('the first keystroke clears the message', () {
      final container = _container();

      container.read(firstPinProvider.notifier).setFirstPin('123456');
      container
          .read(pinSetupStateProvider.notifier)
          .setPinSetupState(const PinSetupState.error(message: 'wrong'));
      container.read(secondPinProvider.notifier).setSecondPin('6');

      expect(container.read(pinSetupStateProvider), const PinSetupState.idle());
    });
  });

  group('PinHelper', () {
    test('states the PIN length the screen label states', () {
      final container = _container();
      final helper = container.read(pinHelperProvider);

      expect(helper.minPinLength, 6);
      expect(helper.maxPinLength, 8);
    });

    test('onSuccess reports success', () {
      final container = _container();

      container.read(pinHelperProvider).onSuccess();

      expect(
        container.read(pinSetupExitProvider),
        const PinSetupExitState.success(),
      );
    });

    test('onBack reports back', () {
      final container = _container();

      container.read(pinHelperProvider).onBack();

      expect(
        container.read(pinSetupExitProvider),
        const PinSetupExitState.back(),
      );
    });

    group('entering the screen', () {
      test('from settings', () {
        final container = _container();

        container.read(pinHelperProvider).initPinSetupSettings();

        expect(
          container.read(pinSetupCallerProvider),
          const PinSetupCallerState.settings(),
        );
        expect(
          container.read(pinSetupExitProvider),
          const PinSetupExitState.empty(),
        );
        expect(container.read(pageStatusProvider), Status.pinSetup);
      });

      test('from the new wallet welcome', () {
        final container = _container();

        container.read(pinHelperProvider).initPinSetupNewWalletPinWelcome();

        expect(
          container.read(pinSetupCallerProvider),
          const PinSetupCallerState.newWalletPinWelcome(),
        );
        expect(
          container.read(pinSetupExitProvider),
          const PinSetupExitState.empty(),
        );
        expect(container.read(pageStatusProvider), Status.pinSetup);
      });

      test('from the PIN welcome', () {
        final container = _container();

        container.read(pinHelperProvider).initPinSetupPinWelcome();

        expect(
          container.read(pinSetupCallerProvider),
          const PinSetupCallerState.pinWelcome(),
        );
        expect(
          container.read(pinSetupExitProvider),
          const PinSetupExitState.empty(),
        );
        expect(container.read(pageStatusProvider), Status.pinSetup);
      });

      test('clears what the form had to say', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container.read(secondPinProvider.notifier).setSecondPin('654321');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container
            .read(pinSetupStateProvider.notifier)
            .setPinSetupState(const PinSetupState.error(message: 'wrong'));

        container.read(pinHelperProvider).initPinSetupSettings();

        expect(container.read(firstPinProvider), '');
        expect(container.read(secondPinProvider), '');
        expect(
          container.read(pinFieldStateProvider),
          const PinFieldState.first(),
        );
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
      });

      test('leaves an outstanding attempt outstanding', () {
        final container = _container();

        container.read(pinSetupAttemptProvider.notifier).open();
        container.read(pinHelperProvider).initPinSetupSettings();

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.outstanding(),
        );
        expect(container.read(firstPinEnabledProvider), isFalse);

        container.read(pinSetupAttemptProvider.notifier).release();
      });
    });

    group('onKeyEntered', () {
      test('every digit key appends its digit', () {
        const keys = [
          PinKeyEnum.one,
          PinKeyEnum.two,
          PinKeyEnum.three,
          PinKeyEnum.four,
          PinKeyEnum.five,
          PinKeyEnum.six,
          PinKeyEnum.seven,
          PinKeyEnum.eight,
        ];

        final container = _container();
        final helper = container.read(pinHelperProvider);

        for (final key in keys) {
          helper.onKeyEntered(key);
        }

        expect(container.read(firstPinProvider), '12345678');
      });

      test('the nine key appends a nine', () {
        final container = _container();

        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.nine);

        expect(container.read(firstPinProvider), '9');
      });

      test('the zero key appends a zero', () {
        final container = _container();

        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.zero);

        expect(container.read(firstPinProvider), '0');
      });

      test('backspace removes the last digit', () {
        final container = _container();
        final helper = container.read(pinHelperProvider);

        helper.onKeyEntered(PinKeyEnum.one);
        helper.onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(firstPinProvider), '');
      });

      test('enter moves to the confirm field once it is open', () {
        final container = _container();
        final helper = container.read(pinHelperProvider);

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        helper.onKeyEntered(PinKeyEnum.enter);

        expect(
          container.read(pinFieldStateProvider),
          const PinFieldState.second(),
        );
      });
    });

    group('typing', () {
      test('the first PIN stops at eight digits', () {
        final container = _container();
        final helper = container.read(pinHelperProvider);

        container.read(firstPinProvider.notifier).setFirstPin('12345678');
        helper.onKeyEntered(PinKeyEnum.nine);

        expect(container.read(firstPinProvider), '12345678');
      });

      test('the confirm PIN takes digits once the field is open', () {
        final container = _container();
        final helper = container.read(pinHelperProvider);

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        helper.onKeyEntered(PinKeyEnum.seven);

        expect(container.read(secondPinProvider), '7');
      });

      test('the confirm PIN stops at eight digits', () {
        final container = _container();
        final helper = container.read(pinHelperProvider);

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(secondPinProvider.notifier).setSecondPin('12345678');
        helper.onKeyEntered(PinKeyEnum.nine);

        expect(container.read(secondPinProvider), '12345678');
      });
    });

    group('backspace', () {
      test('does nothing on an empty first PIN', () {
        final container = _container();

        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(firstPinProvider), '');
      });

      test('does nothing while the first field is closed', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container.read(pinSetupAttemptProvider.notifier).open();
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(firstPinProvider), '123456');

        container.read(pinSetupAttemptProvider.notifier).release();
      });

      test('shortening the first PIN below six clears the confirm PIN', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container.read(secondPinProvider.notifier).setSecondPin('123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(firstPinProvider), '12345');
        expect(container.read(secondPinProvider), '');
        expect(container.read(secondPinEnabledProvider), isFalse);
      });

      test('shortening the first PIN to six keeps the confirm PIN', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('1234567');
        container.read(secondPinProvider.notifier).setSecondPin('123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(firstPinProvider), '123456');
        expect(container.read(secondPinProvider), '123456');
      });

      test('removes the last digit of the confirm PIN', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(secondPinProvider.notifier).setSecondPin('123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(secondPinProvider), '12345');
      });

      test('does nothing on an empty confirm PIN', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(secondPinProvider), '');
      });

      test('does nothing while the confirm field is closed', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(secondPinProvider.notifier).setSecondPin('123456');
        container.read(pinSetupAttemptProvider.notifier).open();
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.backspace);

        expect(container.read(secondPinProvider), '123456');

        container.read(pinSetupAttemptProvider.notifier).release();
      });
    });

    group('onTap', () {
      test('does nothing while the confirm field is closed', () {
        final container = _container();

        container.read(pinHelperProvider).onTap();

        expect(
          container.read(pinFieldStateProvider),
          const PinFieldState.first(),
        );
      });

      test('moves to the confirm field', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container.read(pinHelperProvider).onTap();

        expect(
          container.read(pinFieldStateProvider),
          const PinFieldState.second(),
        );
      });

      test('moves back to the first field', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(pinHelperProvider).onTap();

        expect(
          container.read(pinFieldStateProvider),
          const PinFieldState.first(),
        );
      });
    });

    group('ENABLE', () {
      test('does nothing while the confirm field is closed', () {
        final container = _container();

        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        expect(
          container.read(pinFieldStateProvider),
          const PinFieldState.first(),
        );
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
      });

      test('does nothing on the confirm field while it is closed', () {
        final container = _container();

        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
      });

      test('does nothing while an attempt is outstanding', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenReturn(true);
        final container = _container(wallet: wallet);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        verify(() => wallet.sendEncryptPin('123456')).called(1);

        container.read(pinSetupAttemptProvider.notifier).release();
      });

      test('mismatched PINs keep both fields open and both values', () {
        final wallet = MockSideswapWallet();
        final container = _container(wallet: wallet);

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container
            .read(pinFieldStateProvider.notifier)
            .setPinFieldState(const PinFieldState.second());
        container.read(secondPinProvider.notifier).setSecondPin('654321');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
        expect(container.read(firstPinProvider), '123456');
        expect(container.read(secondPinProvider), '654321');
        expect(container.read(firstPinEnabledProvider), isTrue);
        expect(container.read(secondPinEnabledProvider), isTrue);
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        verifyNever(() => wallet.sendEncryptPin(any()));
      });

      test('matching PINs send the PIN and hold the attempt', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenReturn(true);
        final container = _container(wallet: wallet);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        verify(() => wallet.sendEncryptPin('123456')).called(1);
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.outstanding(),
        );
        expect(container.read(firstPinEnabledProvider), isFalse);
        expect(container.read(secondPinEnabledProvider), isFalse);

        container.read(pinSetupAttemptProvider.notifier).release();
      });

      test('a refused send gives the attempt back with a message', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenReturn(false);
        final container = _container(wallet: wallet);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
        expect(container.read(firstPinEnabledProvider), isTrue);
      });
    });

    group('the biometric prompt', () {
      test('an accepted prompt sends the PIN', () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.isAuthenticated()).thenAnswer((_) async => true);
        when(() => wallet.sendEncryptPin(any())).thenReturn(true);
        final container = _container(wallet: wallet, biometricEnabled: true);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);
        await Future<void>.delayed(Duration.zero);

        verify(() => wallet.sendEncryptPin('123456')).called(1);
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.outstanding(),
        );

        container.read(pinSetupAttemptProvider.notifier).release();
      });

      test('a refused prompt gives the attempt back with a message', () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.isAuthenticated()).thenAnswer((_) async => false);
        final container = _container(wallet: wallet, biometricEnabled: true);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => wallet.sendEncryptPin(any()));
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
      });

      test('a thrown prompt gives the attempt back with a message', () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.isAuthenticated()).thenThrow(Exception('no sensor'));
        final container = _container(wallet: wallet, biometricEnabled: true);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);
        await Future<void>.delayed(Duration.zero);

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
        expect(container.read(firstPinEnabledProvider), isTrue);
      });

      test('a thrown send gives the attempt back with a message', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenThrow(Exception('no id'));
        final container = _container(wallet: wallet);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
        expect(container.read(firstPinEnabledProvider), isTrue);
      });

      test('opening an attempt clears the last failure message', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenReturn(true);
        final container = _container(wallet: wallet);

        _fillMatchingPins(container, '123456');
        container
            .read(pinSetupStateProvider.notifier)
            .setPinSetupState(const PinSetupState.error(message: 'stale'));
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        // A new attempt has nothing to say yet. Keeping the old message would
        // make the next failure no transition at all, so the focus would never
        // come back, and it would mask the threshold message.
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );

        container.read(pinSetupAttemptProvider.notifier).release();
      });

      test('a repeat failure is a fresh transition into the message', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenReturn(true);
        final container = _container(wallet: wallet);
        final seen = <PinSetupState>[];
        container.listen(pinSetupStateProvider, (_, next) => seen.add(next));

        _fillMatchingPins(container, '123456');
        for (var attempt = 0; attempt < 2; attempt++) {
          container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);
          container
              .read(pinHelperProvider)
              .onPinData(const PinDataState.error(message: 'server said no'));
        }

        // Both failures are observable, not just the first.
        expect(seen.whereType<PinSetupStateError>(), hasLength(2));
      });

      test('a throw after the screen is gone still gives the attempt back',
          () async {
        final completer = Completer<bool>();
        final wallet = MockSideswapWallet();
        when(
          () => wallet.isAuthenticated(),
        ).thenAnswer((_) => completer.future);
        final container = _container(
          wallet: wallet,
          biometricEnabled: true,
          holdHelper: false,
        );

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        // BACK during the prompt takes the helper away, and the cancelled
        // prompt then throws. Releasing through the helper's own dead `Ref`
        // would throw here and hold the attempt for the life of the process.
        await Future<void>.delayed(Duration.zero);
        completer.completeError(Exception('prompt cancelled'));
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => wallet.sendEncryptPin(any()));
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
      });

      test('leaving during the prompt gives the attempt back and stops', () async {
        final completer = Completer<bool>();
        final wallet = MockSideswapWallet();
        when(
          () => wallet.isAuthenticated(),
        ).thenAnswer((_) => completer.future);
        final container = _container(
          wallet: wallet,
          biometricEnabled: true,
          holdHelper: false,
        );

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        // BACK during the prompt takes the screen, and the helper, away.
        await Future<void>.delayed(Duration.zero);
        completer.complete(true);
        await Future<void>.delayed(Duration.zero);

        verifyNever(() => wallet.sendEncryptPin(any()));
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
      });
    });

    group('onPinData', () {
      test('a reply with no attempt outstanding changes nothing', () {
        final container = _container();

        container.read(pinHelperProvider).onPinData(_blob);

        expect(container.read(configurationProvider).usePinProtection, isFalse);
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
        expect(container.read(pageStatusProvider), isNot(Status.pinSuccess));
      });

      test('a server failure gives the attempt back and keeps both PINs', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container.read(secondPinProvider.notifier).setSecondPin('123456');
        container.read(pinSetupAttemptProvider.notifier).open();

        container
            .read(pinHelperProvider)
            .onPinData(const PinDataState.error(message: 'server said no'));

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
        expect(container.read(firstPinProvider), '123456');
        expect(container.read(secondPinProvider), '123456');
        expect(container.read(firstPinEnabledProvider), isTrue);
        expect(container.read(secondPinEnabledProvider), isTrue);
      });

      test('ENABLE after a server failure retries with no retyping', () {
        final wallet = MockSideswapWallet();
        when(() => wallet.sendEncryptPin(any())).thenReturn(true);
        final container = _container(wallet: wallet);

        _fillMatchingPins(container, '123456');
        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);
        container
            .read(pinHelperProvider)
            .onPinData(const PinDataState.error(message: 'server said no'));

        container.read(pinHelperProvider).onKeyEntered(PinKeyEnum.enter);

        verify(() => wallet.sendEncryptPin('123456')).called(2);
        expect(container.read(firstPinProvider), '123456');
        expect(container.read(secondPinProvider), '123456');

        container.read(pinSetupAttemptProvider.notifier).release();
      });

      test('a blob that is not whole is a failure', () {
        final container = _container();

        container.read(pinSetupAttemptProvider.notifier).open();
        container.read(pinHelperProvider).onPinData(
          const PinDataState.data(
            salt: '',
            encryptedData: 'encrypted',
            pinIdentifier: 'identifier',
            hmac: 'hmac',
          ),
        );

        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(
          container.read(pinSetupStateProvider),
          isA<PinSetupStateError>(),
        );
        expect(container.read(configurationProvider).usePinProtection, isFalse);
      });

      test('a whole blob is committed, and the attempt given back', () {
        final container = _container();

        container.read(firstPinProvider.notifier).setFirstPin('123456');
        container.read(pinSetupAttemptProvider.notifier).open();

        container.read(pinHelperProvider).onPinData(_blob);

        final settings = container.read(configurationProvider);
        expect(settings.usePinProtection, isTrue);
        expect(settings.pinDataState, _blob);
        expect(container.read(pageStatusProvider), Status.pinSuccess);
        expect(
          container.read(pinSetupAttemptProvider),
          const PinSetupAttemptState.none(),
        );
        expect(container.read(firstPinProvider), '');
        expect(
          container.read(pinSetupStateProvider),
          const PinSetupState.idle(),
        );
      });
    });
  });
}
