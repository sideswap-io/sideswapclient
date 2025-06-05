import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pin_models.dart';

import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'pin_protection_provider.g.dart';
part 'pin_protection_provider.freezed.dart';

enum PinKeyboardAcceptType { icon, enable, disable, unlock, save }

@riverpod
class PinProtectionStateNotifier extends _$PinProtectionStateNotifier {
  @override
  PinProtectionState build() {
    return const PinProtectionState.idle();
  }

  void setPinProtectionState(PinProtectionState value) {
    state = value;
  }
}

@riverpod
class PinCodeProtectionNotifier extends _$PinCodeProtectionNotifier {
  @override
  String build() {
    return '';
  }

  void setPinCode(String value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class PinDecryptedDataNotifier extends _$PinDecryptedDataNotifier {
  @override
  PinDecryptedData build() {
    return PinDecryptedData(false);
  }

  void setPinDecryptedData(PinDecryptedData value) {
    state = value;
  }
}

@freezed
sealed class PinUnlockState with _$PinUnlockState {
  const factory PinUnlockState.empty() = PinUnlockStateEmpty;
  const factory PinUnlockState.success() = PinUnlockStateSuccess;
  const factory PinUnlockState.wrong() = PinUnlockStateWrong;
  const factory PinUnlockState.failed() = PinUnlockStateFailed;
}

@riverpod
class PinUnlockStateNotifier extends _$PinUnlockStateNotifier {
  @override
  PinUnlockState build() {
    return const PinUnlockStateEmpty();
  }

  void setPinUnlockState(PinUnlockState value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
PinProtectionHelper pinProtectionHelper(Ref ref) {
  return PinProtectionHelper(ref: ref);
}

class PinProtectionHelper {
  final Ref ref;

  PinProtectionHelper({required this.ref});

  Future<bool> Function(String?, bool, PinKeyboardAcceptType)?
  onPinBlockadeCallback;
  int wrongCount = 0;

  Future<bool> pinBlockadeUnlocked({
    String? title,
    bool showBackButton = true,
    PinKeyboardAcceptType iconType = PinKeyboardAcceptType.unlock,
  }) async {
    if (onPinBlockadeCallback != null) {
      return await onPinBlockadeCallback!(title, showBackButton, iconType);
    }
    return false;
  }

  void init() {
    ref.invalidate(pinCodeProtectionNotifierProvider);
    ref.invalidate(pinProtectionStateNotifierProvider);
  }

  void deinit() {
    ref.invalidate(pinCodeProtectionNotifierProvider);
    ref.invalidate(pinProtectionStateNotifierProvider);
  }

  void onKeyEntered(PinKeyEnum key) {
    final pinProtectionState = ref.read(pinProtectionStateNotifierProvider);
    if (pinProtectionState == const PinProtectionState.waiting()) {
      return;
    }

    ref
        .read(pinProtectionStateNotifierProvider.notifier)
        .setPinProtectionState(const PinProtectionState.idle());

    switch (key) {
      case PinKeyEnum.zero:
        _onNumber('0');
        break;
      case PinKeyEnum.one:
        _onNumber('1');
        break;
      case PinKeyEnum.two:
        _onNumber('2');
        break;
      case PinKeyEnum.three:
        _onNumber('3');
        break;
      case PinKeyEnum.four:
        _onNumber('4');
        break;
      case PinKeyEnum.five:
        _onNumber('5');
        break;
      case PinKeyEnum.six:
        _onNumber('6');
        break;
      case PinKeyEnum.seven:
        _onNumber('7');
        break;
      case PinKeyEnum.eight:
        _onNumber('8');
        break;
      case PinKeyEnum.nine:
        _onNumber('9');
        break;
      case PinKeyEnum.backspace:
        _onBackspace();
        break;
      case PinKeyEnum.enter:
        _onEnter();
        break;
    }
  }

  void resetCounter() {
    wrongCount = 0;
  }

  void _onNumber(String number) {
    final pinCode = ref.read(pinCodeProtectionNotifierProvider);
    if (pinCode.length == ref.read(pinHelperProvider).maxPinLength) {
      return;
    }

    final newPinCode = '$pinCode$number';
    ref.read(pinCodeProtectionNotifierProvider.notifier).setPinCode(newPinCode);
  }

  void _onBackspace() {
    final pinCode = ref.read(pinCodeProtectionNotifierProvider);
    if (pinCode.isEmpty) {
      return;
    }

    final newPinCode = pinCode.substring(0, pinCode.length - 1);
    ref.read(pinCodeProtectionNotifierProvider.notifier).setPinCode(newPinCode);
  }

  void _onEnter() {
    final pinCode = ref.read(pinCodeProtectionNotifierProvider);
    if (pinCode.length < ref.read(pinHelperProvider).minPinLength) {
      ref
          .read(pinProtectionStateNotifierProvider.notifier)
          .setPinProtectionState(
            PinProtectionState.error(message: 'PIN code is too short'.tr()),
          );
      ref.invalidate(pinCodeProtectionNotifierProvider);
      return;
    }

    ref
        .read(pinProtectionStateNotifierProvider.notifier)
        .setPinProtectionState(const PinProtectionState.waiting());

    ref.read(walletProvider).sendDecryptPin(pinCode);
  }

  Future<void> onPinDecrypted(PinDecryptedData pinDecryptedData) async {
    ref.invalidate(pinProtectionStateNotifierProvider);

    logger.d(pinDecryptedData);

    ref
        .read(pinDecryptedDataNotifierProvider.notifier)
        .setPinDecryptedData(pinDecryptedData);

    if (pinDecryptedData.success) {
      wrongCount = 0;
      ref
          .read(pinUnlockStateNotifierProvider.notifier)
          .setPinUnlockState(const PinUnlockState.success());
      return;
    }

    ref.invalidate(pinCodeProtectionNotifierProvider);

    if (pinDecryptedData.error?.errorCode ==
        From_DecryptPin_ErrorCode.WRONG_PIN) {
      wrongCount += 1;
    }

    if (wrongCount >= 3) {
      ref
          .read(pinUnlockStateNotifierProvider.notifier)
          .setPinUnlockState(const PinUnlockState.failed());
      await ref.read(walletProvider).settingsDeletePromptConfirm();
      return;
    }

    final errorMessage = switch (pinDecryptedData.error?.errorCode) {
      From_DecryptPin_ErrorCode.NETWORK_ERROR => 'Connection failed'.tr(),
      From_DecryptPin_ErrorCode.WRONG_PIN when wrongCount == 1 =>
        'Wrong PIN code. Two attempts left.'.tr(),
      From_DecryptPin_ErrorCode.WRONG_PIN when wrongCount == 2 =>
        'Wrong PIN code. Last attempt left.'.tr(),
      _ => 'Unknown error'.tr(args: [pinDecryptedData.error?.errorMsg ?? '']),
    };

    ref
        .read(pinProtectionStateNotifierProvider.notifier)
        .setPinProtectionState(PinProtectionStateError(message: errorMessage));

    ref
        .read(pinUnlockStateNotifierProvider.notifier)
        .setPinUnlockState(const PinUnlockState.wrong());
  }
}
