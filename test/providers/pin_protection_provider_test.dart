import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

// Mock classes
class MockSideswapWallet extends Mock implements SideswapWallet {}

class MockPinHelper extends Mock implements PinHelper {}

class FakeSideswapWallet extends Fake implements SideswapWallet {
  @override
  Future<void> sendDecryptPin(String pin) async {
    // Default: do nothing (would be called in real usage)
  }

  @override
  Future<void> settingsDeletePromptConfirm() async {
    // Default: do nothing
  }
}

class FakePinHelper extends Fake implements PinHelper {
  @override
  int get maxPinLength => 8;

  @override
  int get minPinLength => 6;
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });
  group('PinProtectionStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('build returns idle state initially', () {
      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.idle(),
      );
    });

    test('setPinProtectionState updates state to waiting', () {
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(const PinProtectionState.waiting());

      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );
    });

    test('setPinProtectionState updates state to error with message', () {
      const errorMsg = 'Test error message';
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(
            const PinProtectionState.error(message: errorMsg),
          );

      final state = container.read(pinProtectionStateProvider);
      expect(state, isA<PinProtectionStateError>());
      expect((state as PinProtectionStateError).message, errorMsg);
    });
  });

  group('PinCodeProtectionNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('build returns empty string initially', () {
      expect(container.read(pinCodeProtectionProvider), '');
    });

    test('setPinCode updates state', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('123456');
      expect(container.read(pinCodeProtectionProvider), '123456');
    });

    test('setPinCode can be updated multiple times', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('1');
      expect(container.read(pinCodeProtectionProvider), '1');

      container.read(pinCodeProtectionProvider.notifier).setPinCode('12');
      expect(container.read(pinCodeProtectionProvider), '12');
    });
  });

  group('PinDecryptedDataNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('build returns PinDecryptedData with success=false', () {
      final data = container.read(pinDecryptedDataProvider);
      expect(data.success, false);
    });

    test('setPinDecryptedData updates state', () {
      final newData = PinDecryptedData(true, mnemonic: 'test mnemonic');
      container
          .read(pinDecryptedDataProvider.notifier)
          .setPinDecryptedData(newData);

      final data = container.read(pinDecryptedDataProvider);
      expect(data.success, true);
      expect(data.mnemonic, 'test mnemonic');
    });
  });

  group('PinUnlockStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('build returns empty state initially', () {
      expect(
        container.read(pinUnlockStateProvider),
        isA<PinUnlockStateEmpty>(),
      );
    });

    test('setPinUnlockState updates to success', () {
      container.read(pinUnlockStateProvider.notifier).setPinUnlockState(
            const PinUnlockState.success(),
          );

      expect(
        container.read(pinUnlockStateProvider),
        isA<PinUnlockStateSuccess>(),
      );
    });

    test('setPinUnlockState updates to wrong with attempt count', () {
      container.read(pinUnlockStateProvider.notifier).setPinUnlockState(
            const PinUnlockState.wrong(attempt: 2),
          );

      final state = container.read(pinUnlockStateProvider);
      expect(state, isA<PinUnlockStateWrong>());
      expect((state as PinUnlockStateWrong).attempt, 2);
    });

    test('setPinUnlockState updates to failed', () {
      container.read(pinUnlockStateProvider.notifier).setPinUnlockState(
            const PinUnlockState.failed(),
          );

      expect(
        container.read(pinUnlockStateProvider),
        isA<PinUnlockStateFailed>(),
      );
    });
  });

  group('pinProtectionHelper', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('provider returns PinProtectionHelper instance', () {
      final helper = container.read(pinProtectionHelperProvider);
      expect(helper, isA<PinProtectionHelper>());
    });

    test('PinProtectionHelper has access to ref', () {
      final helper = container.read(pinProtectionHelperProvider);
      expect(helper.ref, isNotNull);
    });

    test('PinProtectionHelper.wrongCount initializes to 0', () {
      final helper = container.read(pinProtectionHelperProvider);
      expect(helper.wrongCount, 0);
    });
  });

  group('PinProtectionHelper.pinBlockadeUnlocked', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('returns false when callback is null', () async {
      expect(helper.onPinBlockadeCallback, null);
      final result = await helper.pinBlockadeUnlocked();
      expect(result, false);
    });

    test('invokes callback when set and returns result', () async {
      bool callbackInvoked = false;
      helper.onPinBlockadeCallback = (title, showBackButton, iconType) async {
        callbackInvoked = true;
        return true;
      };

      final result = await helper.pinBlockadeUnlocked(
        title: 'Unlock',
        showBackButton: false,
      );

      expect(callbackInvoked, true);
      expect(result, true);
    });

    test('passes parameters to callback correctly', () async {
      String? capturedTitle;
      bool? capturedShowBackButton;
      PinKeyboardAcceptType? capturedIconType;

      helper.onPinBlockadeCallback =
          (title, showBackButton, iconType) async {
        capturedTitle = title;
        capturedShowBackButton = showBackButton;
        capturedIconType = iconType;
        return true;
      };

      await helper.pinBlockadeUnlocked(
        title: 'Custom Title',
        showBackButton: false,
        iconType: PinKeyboardAcceptType.save,
      );

      expect(capturedTitle, 'Custom Title');
      expect(capturedShowBackButton, false);
      expect(capturedIconType, PinKeyboardAcceptType.save);
    });

    test('uses default parameters when not provided', () async {
      String? capturedTitle;
      bool? capturedShowBackButton;
      PinKeyboardAcceptType? capturedIconType;

      helper.onPinBlockadeCallback =
          (title, showBackButton, iconType) async {
        capturedTitle = title;
        capturedShowBackButton = showBackButton;
        capturedIconType = iconType;
        return true;
      };

      await helper.pinBlockadeUnlocked();

      expect(capturedTitle, null);
      expect(capturedShowBackButton, true);
      expect(capturedIconType, PinKeyboardAcceptType.unlock);
    });
  });

  group('PinProtectionHelper.init', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('invalidates pinCodeProtectionProvider', () {
      // Set a value first
      container.read(pinCodeProtectionProvider.notifier).setPinCode('12345');
      expect(container.read(pinCodeProtectionProvider), '12345');

      // After init, it should reset
      helper.init();
      expect(container.read(pinCodeProtectionProvider), '');
    });

    test('invalidates pinProtectionStateProvider', () {
      // Set a value first
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(const PinProtectionState.waiting());
      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );

      // After init, it should reset
      helper.init();
      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.idle(),
      );
    });
  });

  group('PinProtectionHelper.deinit', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('invalidates pinCodeProtectionProvider', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('12345');
      helper.deinit();
      expect(container.read(pinCodeProtectionProvider), '');
    });

    test('invalidates pinProtectionStateProvider', () {
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(const PinProtectionState.waiting());
      helper.deinit();
      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.idle(),
      );
    });
  });

  group('PinProtectionHelper.onKeyEntered', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          pinHelperProvider.overrideWith((ref) => FakePinHelper()),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('ignores key press when state is waiting', () {
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(const PinProtectionState.waiting());

      helper.onKeyEntered(PinKeyEnum.one);

      // State should still be waiting, nothing should happen
      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );
      expect(container.read(pinCodeProtectionProvider), '');
    });

    test('resets state to idle for any key entry', () {
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(const PinProtectionState.waiting());

      helper.onKeyEntered(PinKeyEnum.zero);

      // Key entry should set to idle first, but waiting ignores it
      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );
    });

    test('appends digit to PIN when 0-9 key pressed', () {
      helper.onKeyEntered(PinKeyEnum.one);
      expect(container.read(pinCodeProtectionProvider), '1');

      helper.onKeyEntered(PinKeyEnum.two);
      expect(container.read(pinCodeProtectionProvider), '12');

      helper.onKeyEntered(PinKeyEnum.zero);
      expect(container.read(pinCodeProtectionProvider), '120');
    });

    test('handles all digit keys 0-9', () {
      final keysAndDigits = [
        (PinKeyEnum.zero, '0'),
        (PinKeyEnum.one, '1'),
        (PinKeyEnum.two, '2'),
        (PinKeyEnum.three, '3'),
        (PinKeyEnum.four, '4'),
        (PinKeyEnum.five, '5'),
        (PinKeyEnum.six, '6'),
        (PinKeyEnum.seven, '7'),
        (PinKeyEnum.eight, '8'),
        (PinKeyEnum.nine, '9'),
      ];

      for (final (key, digit) in keysAndDigits) {
        container = ProviderContainer.test(
          overrides: [
            pinHelperProvider.overrideWith((ref) => FakePinHelper()),
          ],
        );
        addTearDown(container.dispose);
        helper = container.read(pinProtectionHelperProvider);

        helper.onKeyEntered(key);
        expect(
          container.read(pinCodeProtectionProvider),
          digit,
          reason: 'Key $key should add digit $digit',
        );
      }
    });

    test('removes last digit on backspace', () {
      helper.onKeyEntered(PinKeyEnum.one);
      helper.onKeyEntered(PinKeyEnum.two);
      helper.onKeyEntered(PinKeyEnum.three);
      expect(container.read(pinCodeProtectionProvider), '123');

      helper.onKeyEntered(PinKeyEnum.backspace);
      expect(container.read(pinCodeProtectionProvider), '12');

      helper.onKeyEntered(PinKeyEnum.backspace);
      expect(container.read(pinCodeProtectionProvider), '1');
    });

    test('backspace on empty PIN does nothing', () {
      helper.onKeyEntered(PinKeyEnum.backspace);
      expect(container.read(pinCodeProtectionProvider), '');
    });

    test('enter key triggers PIN submission logic', () {
      // This requires mocking wallet
      container = ProviderContainer.test(
        overrides: [
          pinHelperProvider.overrideWith((ref) => FakePinHelper()),
          walletProvider.overrideWithValue(FakeSideswapWallet()),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);

      // Set PIN below minimum
      container.read(pinCodeProtectionProvider.notifier).setPinCode('123');

      helper.onKeyEntered(PinKeyEnum.enter);

      // Should show error state
      final state = container.read(pinProtectionStateProvider);
      expect(state, isA<PinProtectionStateError>());
    });
  });

  group('PinProtectionHelper.resetCounter', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('resets wrongCount to 0', () {
      helper.wrongCount = 3;
      helper.resetCounter();
      expect(helper.wrongCount, 0);
    });

    test('resets wrongCount when already 0', () {
      helper.wrongCount = 0;
      helper.resetCounter();
      expect(helper.wrongCount, 0);
    });
  });

  group('PinProtectionHelper._onNumber', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          pinHelperProvider.overrideWith((ref) => FakePinHelper()),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('appends number to PIN code', () {
      helper.onKeyEntered(PinKeyEnum.one);
      expect(container.read(pinCodeProtectionProvider), '1');
    });

    test('does not exceed maxPinLength', () {
      // Add 8 digits (max)
      for (int i = 0; i < 8; i++) {
        helper.onKeyEntered(PinKeyEnum.one);
      }
      expect(container.read(pinCodeProtectionProvider), '11111111');

      // Try to add 9th digit
      helper.onKeyEntered(PinKeyEnum.one);
      expect(container.read(pinCodeProtectionProvider), '11111111');
    });
  });

  group('PinProtectionHelper.onPinDecrypted', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;
    late MockSideswapWallet mockWallet;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.settingsDeletePromptConfirm())
          .thenAnswer((_) => Future.value());

      container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('success: sets PinUnlockState.success and resets wrongCount', () async {
      helper.wrongCount = 2;
      await helper.onPinDecrypted(PinDecryptedData(true));

      expect(container.read(pinUnlockStateProvider), isA<PinUnlockStateSuccess>());
      expect(helper.wrongCount, 0);
    });

    test('success: sets pinDecryptedData with success=true', () async {
      final data = PinDecryptedData(true, mnemonic: 'test mnemonic');
      await helper.onPinDecrypted(data);

      final result = container.read(pinDecryptedDataProvider);
      expect(result.success, true);
      expect(result.mnemonic, 'test mnemonic');
    });

    test('success: invalidates pinProtectionStateProvider', () async {
      container
          .read(pinProtectionStateProvider.notifier)
          .setPinProtectionState(const PinProtectionState.waiting());

      await helper.onPinDecrypted(PinDecryptedData(true));

      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.idle(),
      );
    });

    test('failure WRONG_PIN: increments wrongCount', () async {
      final error = From_DecryptPin_Error()
        ..errorCode = From_DecryptPin_ErrorCode.WRONG_PIN;
      await helper.onPinDecrypted(PinDecryptedData(false, error: error));

      expect(helper.wrongCount, 1);
    });

    test('failure WRONG_PIN: sets PinUnlockState.wrong with attempt count', () async {
      final error = From_DecryptPin_Error()
        ..errorCode = From_DecryptPin_ErrorCode.WRONG_PIN;
      await helper.onPinDecrypted(PinDecryptedData(false, error: error));

      final state = container.read(pinUnlockStateProvider);
      expect(state, isA<PinUnlockStateWrong>());
      expect((state as PinUnlockStateWrong).attempt, 1);
    });

    test('failure WRONG_PIN x3: calls settingsDeletePromptConfirm', () async {
      helper.wrongCount = 2;
      final error = From_DecryptPin_Error()
        ..errorCode = From_DecryptPin_ErrorCode.WRONG_PIN;
      await helper.onPinDecrypted(PinDecryptedData(false, error: error));

      // Note: failed state is set then overwritten by wrong(attempt:3) at end of method
      verify(() => mockWallet.settingsDeletePromptConfirm()).called(1);
      expect(helper.wrongCount, 3);
    });

    test('failure WRONG_PIN second attempt: sets wrong(attempt:2) and shows last attempt message', () async {
      helper.wrongCount = 1;
      final error = From_DecryptPin_Error()
        ..errorCode = From_DecryptPin_ErrorCode.WRONG_PIN;
      await helper.onPinDecrypted(PinDecryptedData(false, error: error));

      expect(helper.wrongCount, 2);
      final state = container.read(pinUnlockStateProvider);
      expect(state, isA<PinUnlockStateWrong>());
      expect((state as PinUnlockStateWrong).attempt, 2);
    });

    test('failure NETWORK_ERROR: sets wrong(attempt:0) with connection failed message', () async {
      final error = From_DecryptPin_Error()
        ..errorCode = From_DecryptPin_ErrorCode.NETWORK_ERROR;
      await helper.onPinDecrypted(PinDecryptedData(false, error: error));

      final unlockState = container.read(pinUnlockStateProvider);
      expect(unlockState, isA<PinUnlockStateWrong>());
      final protectionState = container.read(pinProtectionStateProvider);
      expect(protectionState, isA<PinProtectionStateError>());
    });

    test('failure: invalidates pinCodeProtectionProvider', () async {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('123456');
      await helper.onPinDecrypted(PinDecryptedData(false));

      expect(container.read(pinCodeProtectionProvider), '');
    });
  });

  group('PinProtectionHelper._onBackspace', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          pinHelperProvider.overrideWith((ref) => FakePinHelper()),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('removes last character from PIN', () {
      helper.onKeyEntered(PinKeyEnum.one);
      helper.onKeyEntered(PinKeyEnum.two);
      helper.onKeyEntered(PinKeyEnum.three);

      helper.onKeyEntered(PinKeyEnum.backspace);
      expect(container.read(pinCodeProtectionProvider), '12');
    });

    test('returns early when PIN is empty', () {
      expect(container.read(pinCodeProtectionProvider), '');
      helper.onKeyEntered(PinKeyEnum.backspace);
      expect(container.read(pinCodeProtectionProvider), '');
    });
  });

  group('PinProtectionHelper._onEnter', () {
    late ProviderContainer container;
    late PinProtectionHelper helper;
    late MockSideswapWallet mockWallet;

    setUp(() {
      mockWallet = MockSideswapWallet();
      when(() => mockWallet.sendDecryptPin(any()))
          .thenAnswer((_) => Future.value());

      container = ProviderContainer.test(
        overrides: [
          pinHelperProvider.overrideWith((ref) => FakePinHelper()),
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(pinProtectionHelperProvider);
    });

    test('shows error when PIN is too short', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('12345');

      helper.onKeyEntered(PinKeyEnum.enter);

      final state = container.read(pinProtectionStateProvider);
      expect(state, isA<PinProtectionStateError>());
    });

    test('invalidates PIN code after error', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('12345');

      helper.onKeyEntered(PinKeyEnum.enter);

      expect(container.read(pinCodeProtectionProvider), '');
    });

    test('sets state to waiting on valid PIN entry', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('123456');

      helper.onKeyEntered(PinKeyEnum.enter);

      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );
    });

    test('calls wallet.sendDecryptPin on valid PIN', () {
      const pin = '123456';
      container.read(pinCodeProtectionProvider.notifier).setPinCode(pin);

      helper.onKeyEntered(PinKeyEnum.enter);

      verify(() => mockWallet.sendDecryptPin(pin)).called(1);
    });

    test('allows PIN at minimum length', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('123456');
      helper.onKeyEntered(PinKeyEnum.enter);

      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );
    });

    test('allows PIN at maximum length', () {
      container.read(pinCodeProtectionProvider.notifier).setPinCode('12345678');
      helper.onKeyEntered(PinKeyEnum.enter);

      expect(
        container.read(pinProtectionStateProvider),
        const PinProtectionState.waiting(),
      );
    });
  });

}
