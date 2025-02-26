import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';
import 'package:sideswap/providers/config_provider.dart';

import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

part 'pin_setup_provider.g.dart';

@riverpod
class PinDataNotifier extends _$PinDataNotifier {
  @override
  PinDataState build() {
    return const PinDataState.empty();
  }

  void setPinDataState(PinDataState value) {
    state = value;
  }
}

@riverpod
class PinSetupCallerNotifier extends _$PinSetupCallerNotifier {
  @override
  PinSetupCallerState build() {
    return const PinSetupCallerState.empty();
  }

  void setPinSetupCallerState(PinSetupCallerState value) {
    state = value;
  }
}

@riverpod
class PinSetupExitNotifier extends _$PinSetupExitNotifier {
  @override
  PinSetupExitState build() {
    return const PinSetupExitState.empty();
  }

  void setPinSetupExitState(PinSetupExitState value) {
    state = value;
  }
}

@riverpod
class PinFieldStateNotifier extends _$PinFieldStateNotifier {
  @override
  PinFieldState build() {
    return const PinFieldState.first();
  }

  void setPinFieldState(PinFieldState value) {
    state = value;
  }
}

@riverpod
class PinSetupStateNotifier extends _$PinSetupStateNotifier {
  @override
  PinSetupState build() {
    return const PinSetupState.idle();
  }

  void setPinSetupState(PinSetupState value) {
    state = value;
  }
}

@riverpod
class FirstPinNotifier extends _$FirstPinNotifier {
  @override
  String build() {
    return '';
  }

  void setFirstPin(String value) {
    final firstPinEnabled = ref.read(firstPinEnabledProvider);
    if (!firstPinEnabled) {
      return;
    }

    state = value;
    ref
        .read(pinSetupStateNotifierProvider.notifier)
        .setPinSetupState(const PinSetupState.idle());
  }
}

@riverpod
class SecondPinNotifier extends _$SecondPinNotifier {
  @override
  String build() {
    return '';
  }

  void setSecondPin(String value) {
    final secondPinEnabled = ref.read(secondPinEnabledProvider);
    if (!secondPinEnabled) {
      return;
    }

    state = value;
    ref
        .read(pinSetupStateNotifierProvider.notifier)
        .setPinSetupState(const PinSetupState.idle());
  }
}

@riverpod
class FirstPinEnabled extends _$FirstPinEnabled {
  @override
  bool build() {
    final pinSetupState = ref.watch(pinSetupStateNotifierProvider);
    if (pinSetupState == const PinSetupState.done()) {
      return false;
    }

    return true;
  }

  void setFirstPinEnabled(bool value) {
    state = value;
  }
}

@riverpod
class SecondPinEnabled extends _$SecondPinEnabled {
  @override
  bool build() {
    final pinSetupState = ref.watch(pinSetupStateNotifierProvider);

    if (pinSetupState == const PinSetupState.done()) {
      return false;
    }

    return false;
  }

  void setSecondPinEnabled(bool value) {
    state = value;
  }
}

@riverpod
PinHelper pinHelper(Ref ref) {
  return PinHelper(ref: ref);
}

class PinHelper {
  final Ref ref;

  PinHelper({required this.ref});

  static const _minPinLength = 6;
  static const _maxPinLength = 8;

  int get minPinLength => _minPinLength;
  int get maxPinLength => _maxPinLength;

  void onSuccess() {
    ref
        .read(pinSetupExitNotifierProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.success());
  }

  void onBack() {
    ref
        .read(pinSetupExitNotifierProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.back());
  }

  void initPinSetupSettings() {
    ref
        .read(pinSetupExitNotifierProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.empty());
    ref
        .read(pinSetupCallerNotifierProvider.notifier)
        .setPinSetupCallerState(const PinSetupCallerState.settings());
    _clearStates();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.pinSetup);
  }

  void initPinSetupNewWalletPinWelcome() {
    ref
        .read(pinSetupExitNotifierProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.empty());
    ref
        .read(pinSetupCallerNotifierProvider.notifier)
        .setPinSetupCallerState(
          const PinSetupCallerState.newWalletPinWelcome(),
        );
    _clearStates();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.pinSetup);
  }

  void initPinSetupPinWelcome() {
    ref
        .read(pinSetupExitNotifierProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.empty());
    ref
        .read(pinSetupCallerNotifierProvider.notifier)
        .setPinSetupCallerState(const PinSetupCallerState.pinWelcome());
    _clearStates();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.pinSetup);
  }

  void _done() {
    ref
        .read(pinSetupStateNotifierProvider.notifier)
        .setPinSetupState(const PinSetupState.done());

    _clearStates();
  }

  void _clearStates() {
    ref.invalidate(pinSetupStateNotifierProvider);
    ref.invalidate(pinFieldStateNotifierProvider);

    ref.invalidate(firstPinNotifierProvider);
    ref.invalidate(firstPinEnabledProvider);

    ref.invalidate(secondPinNotifierProvider);
    ref.invalidate(secondPinEnabledProvider);
  }

  void onKeyEntered(PinKeyEnum key) async {
    return switch (key) {
      PinKeyEnum.zero => _onNumber('0'),
      PinKeyEnum.one => _onNumber('1'),
      PinKeyEnum.two => _onNumber('2'),
      PinKeyEnum.three => _onNumber('3'),
      PinKeyEnum.four => _onNumber('4'),
      PinKeyEnum.five => _onNumber('5'),
      PinKeyEnum.six => _onNumber('6'),
      PinKeyEnum.seven => _onNumber('7'),
      PinKeyEnum.eight => _onNumber('8'),
      PinKeyEnum.nine => _onNumber('9'),
      PinKeyEnum.backspace => _onBackspace(),
      PinKeyEnum.enter => _onEnter(),
    };
  }

  void _onNumber(String number) {
    final pinFieldState = ref.read(pinFieldStateNotifierProvider);
    if (pinFieldState == const PinFieldStateFirst()) {
      _onFirstPinNumber(number);
      return;
    }

    _onSecondPinNumber(number);
  }

  void _onFirstPinNumber(String number) {
    final firstPin = ref.read(firstPinNotifierProvider);
    if (firstPin.length == _maxPinLength) {
      return;
    }

    final newFirstPin = '$firstPin$number';

    if (newFirstPin.length >= _minPinLength) {
      ref.read(secondPinEnabledProvider.notifier).setSecondPinEnabled(true);
    }

    ref.read(firstPinNotifierProvider.notifier).setFirstPin(newFirstPin);
  }

  void _onSecondPinNumber(String number) {
    final secondPin = ref.read(secondPinNotifierProvider);
    if (secondPin.length == _maxPinLength) {
      return;
    }

    final newSecondPin = '$secondPin$number';
    ref.read(secondPinNotifierProvider.notifier).setSecondPin(newSecondPin);
  }

  void _onBackspace() {
    final firstPin = ref.read(firstPinNotifierProvider);
    final firstPinEnabled = ref.read(firstPinEnabledProvider);

    final pinFieldState = ref.read(pinFieldStateNotifierProvider);
    if (pinFieldState == const PinFieldStateFirst()) {
      if (firstPin.isEmpty || !firstPinEnabled) {
        return;
      }

      final newFirstPin = firstPin.substring(0, firstPin.length - 1);

      if (newFirstPin.length < 4) {
        ref.read(secondPinNotifierProvider.notifier).setSecondPin('');
        ref.read(secondPinEnabledProvider.notifier).setSecondPinEnabled(false);
      }

      ref.read(firstPinNotifierProvider.notifier).setFirstPin(newFirstPin);
      return;
    }

    final secondPin = ref.read(secondPinNotifierProvider);
    final secondPinEnabled = ref.read(secondPinEnabledProvider);

    if (secondPin.isEmpty || !secondPinEnabled) {
      return;
    }

    final newSecondPin = secondPin.substring(0, secondPin.length - 1);
    ref.read(secondPinNotifierProvider.notifier).setSecondPin(newSecondPin);
  }

  void _onEnter() async {
    final pinSetupState = ref.read(pinSetupStateNotifierProvider);
    if (pinSetupState == const PinSetupState.done()) {
      return;
    }

    final pinFieldState = ref.read(pinFieldStateNotifierProvider);
    final secondPinEnabled = ref.read(secondPinEnabledProvider);

    if (pinFieldState == const PinFieldState.first() && secondPinEnabled) {
      ref
          .read(pinFieldStateNotifierProvider.notifier)
          .setPinFieldState(const PinFieldState.second());
      return;
    }

    final firstPin = ref.read(firstPinNotifierProvider);
    final secondPin = ref.read(secondPinNotifierProvider);
    if (pinFieldState == const PinFieldState.second() && secondPinEnabled) {
      if (firstPin != secondPin) {
        ref
            .read(pinSetupStateNotifierProvider.notifier)
            .setPinSetupState(
              PinSetupState.error(message: "PIN code doesn't match".tr()),
            );
        return;
      } else {
        _prepareToSendPin(firstPin);
        return;
      }
    }
  }

  void onTap() {
    final secondPinEnabled = ref.read(secondPinEnabledProvider);
    if (!secondPinEnabled) {
      return;
    }

    final pinFieldState = ref.read(pinFieldStateNotifierProvider);
    if (pinFieldState == const PinFieldState.first()) {
      ref
          .read(pinFieldStateNotifierProvider.notifier)
          .setPinFieldState(const PinFieldState.second());
      return;
    }

    ref
        .read(pinFieldStateNotifierProvider.notifier)
        .setPinFieldState(const PinFieldState.first());
  }

  void _prepareToSendPin(String pin) async {
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
    ref
        .read(pinSetupStateNotifierProvider.notifier)
        .setPinSetupState(
          PinSetupState.error(message: 'Biometric authentication failed'.tr()),
        );
  }

  void _sendPin(String pin) {
    final result = ref.read(walletProvider).sendEncryptPin(pin);

    if (!result) {
      ref
          .read(pinSetupStateNotifierProvider.notifier)
          .setPinSetupState(
            PinSetupState.error(
              message: 'Error setup new PIN code - mnemonic error'.tr(),
            ),
          );
      return;
    }

    ref
        .read(pinSetupStateNotifierProvider.notifier)
        .setPinSetupState(const PinSetupState.done());
  }

  void onPinData(PinDataState pinDataState) async {
    logger.d(pinDataState);

    if (pinDataState is PinDataStateError) {
      ref
          .read(pinSetupStateNotifierProvider.notifier)
          .setPinSetupState(
            PinSetupState.error(message: 'Error setup new PIN code'.tr()),
          );
      return;
    }

    logger.d('PIN OK');

    _done();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.pinSuccess);
    enablePinProtection();
  }

  void enablePinProtection() {
    ref.read(configurationProvider.notifier).setUseBiometricProtection(false);
    ref.read(configurationProvider.notifier).setUsePinProtection(true);
  }
}
