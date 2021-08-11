import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/wallet.dart';

final pinSetupProvider = ChangeNotifierProvider<PinSetupProvider>(
    (ref) => PinSetupProvider(ref.read));

enum PinFieldState {
  firstPin,
  secondPin,
}

enum PinSetupState {
  idle,
  error,
  done,
}

class PinSetupProvider extends ChangeNotifier {
  final Reader read;

  PinSetupProvider(this.read) {
    onSuccess = _onDefaultSuccess;
    onBack = _onDefaultBack;
  }

  static const minPinLength = 4;
  static const maxPinLength = 8;

  PinFieldState fieldState = PinFieldState.firstPin;
  PinSetupState state = PinSetupState.idle;

  StreamSubscription<PinData>? pinEnryptedSubscription;

  String _firstPin = '';
  String get firstPin => _firstPin;
  set firstPin(String value) {
    if (!firstPinEnabled) {
      return;
    }

    _firstPin = value;
    state = PinSetupState.idle;
  }

  String _secondPin = '';
  String get secondPin => _secondPin;
  set secondPin(String value) {
    if (!secondPinEnabled) {
      return;
    }

    _secondPin = value;
    state = PinSetupState.idle;
  }

  bool _firstPinEnabled = true;
  set firstPinEnabled(bool value) => _firstPinEnabled = value;
  bool get firstPinEnabled {
    if (state == PinSetupState.done) {
      return false;
    }

    return _firstPinEnabled;
  }

  bool _secondPinEnabled = false;
  set secondPinEnabled(bool value) => _secondPinEnabled = value;
  bool get secondPinEnabled {
    if (state == PinSetupState.done) {
      return false;
    }

    return _secondPinEnabled;
  }

  bool isNewWallet = false;
  late VoidCallback onSuccess;
  late VoidCallback onBack;

  String errorMessage = '';

  void _onDefaultSuccess() {}
  void _onDefaultBack() {}

  void init({
    required void Function(BuildContext context) onSuccessCallback,
    required void Function(BuildContext context) onBackCallback,
  }) {
    final context = read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      logger.w('Context cannot be null');
      return;
    }

    onSuccess = () {
      onSuccessCallback(context);
    };
    onBack = () {
      onBackCallback(context);
    };

    _clearStates();
  }

  void _done() {
    state = PinSetupState.done;
    notifyListeners();

    Future.microtask(() {
      _clearStates();
      notifyListeners();
    });
  }

  void _clearStates() {
    state = PinSetupState.idle;
    fieldState = PinFieldState.firstPin;
    firstPin = '';
    firstPinEnabled = true;
    secondPin = '';
    secondPinEnabled = false;
    errorMessage = '';
  }

  Future<void> onKeyEntered(PinKey key) async {
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
    if (fieldState == PinFieldState.firstPin) {
      _onFirstPinNumber(number);
      return;
    }

    _onSecondPinNumber(number);
  }

  void _onFirstPinNumber(String number) {
    if (firstPin.length == maxPinLength) {
      return;
    }

    firstPin = '$_firstPin$number';

    if (firstPin.length >= 4) {
      secondPinEnabled = true;
    }
    notifyListeners();
  }

  void _onSecondPinNumber(String number) {
    if (secondPin.length == maxPinLength) {
      return;
    }

    secondPin = '$_secondPin$number';
    notifyListeners();
  }

  void _onBackspace() {
    if (fieldState == PinFieldState.firstPin) {
      if (firstPin.isEmpty || !firstPinEnabled) {
        return;
      }

      firstPin = firstPin.substring(0, _firstPin.length - 1);

      if (firstPin.length < 4) {
        secondPin = '';
        secondPinEnabled = false;
      }
      notifyListeners();
      return;
    }

    if (secondPin.isEmpty || !secondPinEnabled) {
      return;
    }

    secondPin = secondPin.substring(0, secondPin.length - 1);
    notifyListeners();
  }

  Future<void> _onEnter() async {
    if (state == PinSetupState.done) {
      return;
    }

    if (fieldState == PinFieldState.firstPin && secondPinEnabled) {
      fieldState = PinFieldState.secondPin;
      notifyListeners();
      return;
    }

    if (fieldState == PinFieldState.secondPin && secondPinEnabled) {
      if (firstPin != secondPin) {
        state = PinSetupState.error;
        errorMessage = "PIN code doesn't match".tr();
        notifyListeners();
        return;
      } else {
        await _sendPin(firstPin);
        return;
      }
    }
  }

  void onTap() {
    if (fieldState == PinFieldState.firstPin) {
      fieldState = PinFieldState.secondPin;
    } else {
      fieldState = PinFieldState.firstPin;
    }

    notifyListeners();
  }

  Future<void> _sendPin(String pin) async {
    await pinEnryptedSubscription?.cancel();
    pinEnryptedSubscription =
        read(walletProvider).pinEncryptDataSubject.listen(_onPinData);
    read(walletProvider).sendEncryptPin(pin);
    state = PinSetupState.done;
    notifyListeners();
  }

  void _onPinData(PinData pinData) async {
    await pinEnryptedSubscription?.cancel();
    logger.d(pinData);

    if (pinData.error.isNotEmpty) {
      errorMessage = 'Error setup new PIN code'.tr();
      state = PinSetupState.error;
      notifyListeners();
      return;
    }

    logger.d('PIN OK');

    _done();
    await read(walletProvider).setPinSuccess();
  }
}
