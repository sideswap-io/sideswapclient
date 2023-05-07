import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';

final pinProtectionProvider = ChangeNotifierProvider<PinProtectionProvider>(
    (ref) => PinProtectionProvider(ref));

enum PinProtectionState {
  idle,
  waiting,
  error,
}

enum PinKeyboardAcceptType {
  icon,
  enable,
  disable,
  unlock,
  save,
}

class PinProtectionProvider extends ChangeNotifier {
  final Ref ref;

  PinProtectionProvider(this.ref);

  Future<bool> Function(String?, bool, PinKeyboardAcceptType)?
      onPinBlockadeCallback;

  Future<bool> pinBlockadeUnlocked(
      {String? title,
      bool showBackButton = true,
      PinKeyboardAcceptType iconType = PinKeyboardAcceptType.unlock}) async {
    if (onPinBlockadeCallback != null) {
      return await onPinBlockadeCallback!(title, showBackButton, iconType);
    }
    return false;
  }

  VoidCallback? onUnlock;
  VoidCallback? onUnlockFailed;

  StreamSubscription<PinDecryptedData>? pinDecryptedSubscription;
  PinProtectionState state = PinProtectionState.idle;

  String pinCode = '';
  String errorMessage = '';
  int wrongCount = 0;

  void init({
    required VoidCallback onUnlockCallback,
    VoidCallback? onUnlockFailedCallback,
  }) {
    pinCode = '';
    errorMessage = '';
    state = PinProtectionState.idle;
    onUnlock = onUnlockCallback;
    onUnlockFailed = onUnlockFailedCallback;
  }

  void deinit() {
    pinCode = '';
    state = PinProtectionState.idle;
    pinDecryptedSubscription?.cancel();
  }

  Future<void> onKeyEntered(PinKey key) async {
    if (state == PinProtectionState.waiting) {
      return;
    }

    state = PinProtectionState.idle;
    notifyListeners();

    switch (key) {
      case PinKey.zero:
        _onNumber('0');
        break;
      case PinKey.one:
        _onNumber('1');
        break;
      case PinKey.two:
        _onNumber('2');
        break;
      case PinKey.three:
        _onNumber('3');
        break;
      case PinKey.four:
        _onNumber('4');
        break;
      case PinKey.five:
        _onNumber('5');
        break;
      case PinKey.six:
        _onNumber('6');
        break;
      case PinKey.seven:
        _onNumber('7');
        break;
      case PinKey.eight:
        _onNumber('8');
        break;
      case PinKey.nine:
        _onNumber('9');
        break;
      case PinKey.backspace:
        _onBackspace();
        break;
      case PinKey.enter:
        await _onEnter();
        break;
    }
  }

  void reset() {
    wrongCount = 0;
  }

  void _onNumber(String number) {
    if (pinCode.length == PinSetupProvider.maxPinLength) {
      return;
    }

    pinCode = '$pinCode$number';
    notifyListeners();
  }

  void _onBackspace() {
    if (pinCode.isEmpty) {
      return;
    }

    pinCode = pinCode.substring(0, pinCode.length - 1);
    notifyListeners();
  }

  Future<void> _onEnter() async {
    if (pinCode.length < PinSetupProvider.minPinLength) {
      state = PinProtectionState.error;
      pinCode = '';
      errorMessage = 'PIN code is too short'.tr();
      notifyListeners();
      return;
    }

    state = PinProtectionState.waiting;
    errorMessage = '';
    notifyListeners();

    await pinDecryptedSubscription?.cancel();
    pinDecryptedSubscription =
        ref.read(walletProvider).pinDecryptDataSubject.listen(_onPinDecrypted);

    ref.read(walletProvider).sendDecryptPin(pinCode);
  }

  void _onPinDecrypted(PinDecryptedData pinDecryptedData) async {
    state = PinProtectionState.idle;
    notifyListeners();

    await pinDecryptedSubscription?.cancel();
    logger.d(pinDecryptedData);

    if (pinDecryptedData.success) {
      wrongCount = 0;
      if (onUnlock != null) {
        onUnlock!();
      }
      return;
    }

    pinCode = '';
    switch (pinDecryptedData.error) {
      case 'PinError':
        errorMessage = 'Connection failed'.tr();
        break;
      case 'BlockModeError':
        wrongCount += 1;
        switch (wrongCount) {
          case 1:
            errorMessage = 'Wrong PIN code. Two attempts remaining.'.tr();
            break;
          case 2:
            errorMessage = 'Wrong PIN code. Last attempt remaining.'.tr();
            break;
          default:
            ref.read(walletProvider).settingsDeletePromptConfirm();
            return;
        }
        break;
      default:
        errorMessage = 'Unknown error'.tr(args: [pinDecryptedData.error]);
        break;
    }
    state = PinProtectionState.error;
    notifyListeners();

    if (onUnlockFailed != null) {
      onUnlockFailed!();
    }
  }
}
