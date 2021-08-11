import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';

final pinProtectionProvider = ChangeNotifierProvider<PinProtectionProvider>(
    (ref) => PinProtectionProvider(ref.read));

enum PinProtectionState {
  idle,
  waiting,
  error,
}

class PinProtectionProvider extends ChangeNotifier {
  final Reader read;

  PinProtectionProvider(this.read);

  Future<bool> Function()? onPinBlockadeCallback;

  Future<bool> pinBlockadeUnlocked() async {
    if (onPinBlockadeCallback != null) {
      return await onPinBlockadeCallback!();
    }
    return false;
  }

  VoidCallback? onUnlock;

  StreamSubscription<PinDecryptedData>? pinDecryptedSubscription;
  PinProtectionState state = PinProtectionState.idle;

  String pinCode = '';
  String errorMessage = '';

  void init({required VoidCallback onUnlockCallback}) {
    pinCode = '';
    state = PinProtectionState.idle;
    onUnlock = onUnlockCallback;
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
        read(walletProvider).pinDecryptDataSubject.listen(_onPinDecrypted);

    read(walletProvider).sendDecryptPin(pinCode);
  }

  void _onPinDecrypted(PinDecryptedData pinDecryptedData) async {
    state = PinProtectionState.idle;
    notifyListeners();

    await pinDecryptedSubscription?.cancel();
    logger.d(pinDecryptedData);

    if (pinDecryptedData.success) {
      if (onUnlock != null) {
        onUnlock!();
      }
      return;
    }

    pinCode = '';
    errorMessage = 'Wrong PIN code'.tr();
    state = PinProtectionState.error;
    notifyListeners();
  }
}
