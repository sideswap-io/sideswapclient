import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';

import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/wallet.dart';

final pinSetupProvider =
    ChangeNotifierProvider<PinSetupProvider>((ref) => PinSetupProvider(ref));

enum PinFieldState {
  firstPin,
  secondPin,
}

enum PinSetupStateEnum {
  idle,
  error,
  done,
}

class PinSetupProvider extends ChangeNotifier {
  final Ref ref;

  PinSetupProvider(this.ref);

  static const minPinLength = 6;
  static const maxPinLength = 8;

  PinFieldState fieldState = PinFieldState.firstPin;
  PinSetupStateEnum state = PinSetupStateEnum.idle;

  StreamSubscription<PinData>? pinEnryptedSubscription;

  String _firstPin = '';
  String get firstPin => _firstPin;
  set firstPin(String value) {
    if (!firstPinEnabled) {
      return;
    }

    _firstPin = value;
    state = PinSetupStateEnum.idle;
    errorMessage = '';
    notifyListeners();
  }

  String _secondPin = '';
  String get secondPin => _secondPin;
  set secondPin(String value) {
    if (!secondPinEnabled) {
      return;
    }

    _secondPin = value;
    state = PinSetupStateEnum.idle;
    errorMessage = '';
    notifyListeners();
  }

  bool _firstPinEnabled = true;
  set firstPinEnabled(bool value) {
    _firstPinEnabled = value;
    notifyListeners();
  }

  bool get firstPinEnabled {
    if (state == PinSetupStateEnum.done) {
      return false;
    }

    return _firstPinEnabled;
  }

  bool _secondPinEnabled = false;
  set secondPinEnabled(bool value) {
    _secondPinEnabled = value;
    notifyListeners();
  }

  bool get secondPinEnabled {
    if (state == PinSetupStateEnum.done) {
      return false;
    }

    return _secondPinEnabled;
  }

  bool _isNewWallet = false;
  bool get isNewWallet => _isNewWallet;
  set isNewWallet(bool value) {
    _isNewWallet = value;
    notifyListeners();
  }

  String errorMessage = '';

  void onSuccess() {
    ref.read(pinSetupExitStateProvider.notifier).state =
        const PinSetupExitState.success();
  }

  void onBack() {
    ref.read(pinSetupExitStateProvider.notifier).state =
        const PinSetupExitState.back();
  }

  void initPinSetupSettings() {
    ref.read(pinSetupExitStateProvider.notifier).state =
        const PinSetupExitState.empty();
    ref.read(pinSetupCallerStateProvider.notifier).state =
        const PinSetupCallerState.settings();
    _clearStates();
    ref.read(walletProvider).setPinSetup();
  }

  void initPinSetupNewWalletPinWelcome() {
    ref.read(pinSetupExitStateProvider.notifier).state =
        const PinSetupExitState.empty();
    ref.read(pinSetupCallerStateProvider.notifier).state =
        const PinSetupCallerState.newWalletPinWelcome();
    _clearStates();
    ref.read(walletProvider).setPinSetup();
  }

  void initPinSetupPinWelcome() {
    ref.read(pinSetupExitStateProvider.notifier).state =
        const PinSetupExitState.empty();
    ref.read(pinSetupCallerStateProvider.notifier).state =
        const PinSetupCallerState.pinWelcome();
    _clearStates();
    ref.read(walletProvider).setPinSetup();
  }

  void _done() {
    state = PinSetupStateEnum.done;
    notifyListeners();

    Future.microtask(() {
      _clearStates();
      notifyListeners();
    });
  }

  void _clearStates() {
    state = PinSetupStateEnum.idle;
    fieldState = PinFieldState.firstPin;
    firstPin = '';
    firstPinEnabled = true;
    secondPin = '';
    secondPinEnabled = false;
    errorMessage = '';
    notifyListeners();
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

    if (firstPin.length >= minPinLength) {
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
    if (state == PinSetupStateEnum.done) {
      return;
    }

    if (fieldState == PinFieldState.firstPin && secondPinEnabled) {
      fieldState = PinFieldState.secondPin;
      notifyListeners();
      return;
    }

    if (fieldState == PinFieldState.secondPin && secondPinEnabled) {
      if (firstPin != secondPin) {
        state = PinSetupStateEnum.error;
        errorMessage = "PIN code doesn't match".tr();
        notifyListeners();
        return;
      } else {
        await _prepareToSendPin(firstPin);
        return;
      }
    }
  }

  void onTap() {
    if (!secondPinEnabled) {
      return;
    }

    if (fieldState == PinFieldState.firstPin) {
      fieldState = PinFieldState.secondPin;
    } else {
      fieldState = PinFieldState.firstPin;
    }

    notifyListeners();
  }

  void setFirstPinState() {
    fieldState = PinFieldState.firstPin;
    notifyListeners();
  }

  void setSecondPinState() {
    fieldState = PinFieldState.secondPin;
    notifyListeners();
  }

  Future<void> _prepareToSendPin(String pin) async {
    await pinEnryptedSubscription?.cancel();
    pinEnryptedSubscription =
        ref.read(walletProvider).pinEncryptDataSubject.listen(_onPinData);
    if (ref.read(isBiometricEnabledProvider)) {
      if (await ref.read(walletProvider).isAuthenticated()) {
        _sendPin(pin);
        return;
      }
    } else {
      _sendPin(pin);
      return;
    }

    logger.e('Biometric authentication failed on sending pin');
    errorMessage = 'Biometric authentication failed'.tr();
    state = PinSetupStateEnum.error;
    notifyListeners();
  }

  void _sendPin(String pin) {
    final result = ref.read(walletProvider).sendEncryptPin(pin);

    if (!result) {
      errorMessage = 'Error setup new PIN code - mnemonic error'.tr();
      state = PinSetupStateEnum.error;
      notifyListeners();
      return;
    }

    state = PinSetupStateEnum.done;
    notifyListeners();
  }

  void _onPinData(PinData pinData) async {
    await pinEnryptedSubscription?.cancel();
    logger.d(pinData);

    if (pinData.error.isNotEmpty) {
      errorMessage = 'Error setup new PIN code'.tr();
      state = PinSetupStateEnum.error;
      notifyListeners();
      return;
    }

    logger.d('PIN OK');

    _done();
    await ref.read(walletProvider).setPinSuccess();
  }
}

final pinSetupCallerStateProvider =
    StateProvider.autoDispose<PinSetupCallerState>(
        (ref) => const PinSetupCallerState.empty());

final pinSetupExitStateProvider = StateProvider.autoDispose<PinSetupExitState>(
    (ref) => const PinSetupExitState.empty());
