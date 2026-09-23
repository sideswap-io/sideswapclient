import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';
import 'package:sideswap/providers/config_provider.dart';

import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

part 'pin_setup_provider.g.dart';

/// How long a setup attempt may stay outstanding before the screen tells the
/// user to restart the app. The client answers every request it takes, so a
/// reply that does not arrive means a wedged worker loop, and nothing in the
/// client is left to ask. ADR-0013 decision 14.
const pinSetupAttemptOverdueAfter = Duration(seconds: 20);

/// The one record that a setup attempt is in flight. ADR-0013 decisions 4
/// and 14.
///
/// It is `keepAlive` and watches nothing on purpose. `_clearStates()`, leaving
/// the screen and re-entering it must all leave an outstanding attempt
/// outstanding, so that a reply can only belong to the attempt that is still
/// held. Only a reply, or a send that never left, gives it back.
@Riverpod(keepAlive: true)
class PinSetupAttempt extends _$PinSetupAttempt {
  Timer? _overdueTimer;

  @override
  PinSetupAttemptState build() {
    ref.onDispose(_cancelOverdue);
    return const PinSetupAttemptState.none();
  }

  /// Takes the attempt. Does nothing when one is already outstanding: at most
  /// one may be held at a time.
  void open() {
    if (state is PinSetupAttemptStateOutstanding) {
      return;
    }

    state = const PinSetupAttemptState.outstanding();
    _overdueTimer = Timer(pinSetupAttemptOverdueAfter, () {
      state = const PinSetupAttemptState.outstanding(overdue: true);
    });
  }

  /// Gives the attempt back. Safe with nothing outstanding.
  void release() {
    _cancelOverdue();
    state = const PinSetupAttemptState.none();
  }

  void _cancelOverdue() {
    _overdueTimer?.cancel();
    _overdueTimer = null;
  }
}

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
        .read(pinSetupStateProvider.notifier)
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
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.idle());
  }
}

/// Derived, with no setter. The field is open exactly while no setup attempt is
/// outstanding. ADR-0013 decision 1.
@riverpod
class FirstPinEnabled extends _$FirstPinEnabled {
  @override
  bool build() {
    final attempt = ref.watch(pinSetupAttemptProvider);

    return attempt is! PinSetupAttemptStateOutstanding;
  }
}

/// Derived, with no setter. The confirm field is open while the first PIN is
/// long enough for confirming it to mean anything, and no attempt is
/// outstanding. ADR-0013 decisions 1 and 2.
@riverpod
class SecondPinEnabled extends _$SecondPinEnabled {
  @override
  bool build() {
    final attempt = ref.watch(pinSetupAttemptProvider);
    if (attempt is PinSetupAttemptStateOutstanding) {
      return false;
    }

    final firstPin = ref.watch(firstPinProvider);

    return firstPin.length >= PinHelper._minPinLength;
  }
}

@riverpod
PinHelper pinHelper(Ref ref) {
  return PinHelper(ref: ref);
}

class PinHelper {
  final Ref ref;

  PinHelper({required this.ref});

  /// The PIN is six to eight digits. Six is the number the screen's own label
  /// states, and the confirm field's threshold is symmetric on it.
  static const _minPinLength = 6;
  static const _maxPinLength = 8;

  int get minPinLength => _minPinLength;
  int get maxPinLength => _maxPinLength;

  void onSuccess() {
    ref
        .read(pinSetupExitProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.success());
  }

  void onBack() {
    ref
        .read(pinSetupExitProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.back());
  }

  void initPinSetupSettings() {
    ref
        .read(pinSetupExitProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.empty());
    ref
        .read(pinSetupCallerProvider.notifier)
        .setPinSetupCallerState(const PinSetupCallerState.settings());
    _clearStates();
    ref.read(pageStatusProvider.notifier).setStatus(Status.pinSetup);
  }

  void initPinSetupNewWalletPinWelcome() {
    ref
        .read(pinSetupExitProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.empty());
    ref
        .read(pinSetupCallerProvider.notifier)
        .setPinSetupCallerState(
          const PinSetupCallerState.newWalletPinWelcome(),
        );
    _clearStates();
    ref.read(pageStatusProvider.notifier).setStatus(Status.pinSetup);
  }

  void initPinSetupPinWelcome() {
    ref
        .read(pinSetupExitProvider.notifier)
        .setPinSetupExitState(const PinSetupExitState.empty());
    ref
        .read(pinSetupCallerProvider.notifier)
        .setPinSetupCallerState(const PinSetupCallerState.pinWelcome());
    _clearStates();
    ref.read(pageStatusProvider.notifier).setStatus(Status.pinSetup);
  }

  /// Clears what the form has to say. It deliberately does not touch the
  /// attempt: re-entering the screen with one outstanding must show it as
  /// outstanding. ADR-0013 decisions 4 and 14.
  void _clearStates() {
    ref.invalidate(pinSetupStateProvider);
    ref.invalidate(pinFieldStateProvider);

    ref.invalidate(firstPinProvider);
    ref.invalidate(secondPinProvider);
  }

  void onKeyEntered(PinKeyEnum key) {
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
    final pinFieldState = ref.read(pinFieldStateProvider);
    if (pinFieldState == const PinFieldStateFirst()) {
      _onFirstPinNumber(number);
      return;
    }

    _onSecondPinNumber(number);
  }

  void _onFirstPinNumber(String number) {
    final firstPin = ref.read(firstPinProvider);
    if (firstPin.length == _maxPinLength) {
      return;
    }

    final newFirstPin = '$firstPin$number';

    ref.read(firstPinProvider.notifier).setFirstPin(newFirstPin);
  }

  void _onSecondPinNumber(String number) {
    final secondPin = ref.read(secondPinProvider);
    if (secondPin.length == _maxPinLength) {
      return;
    }

    final newSecondPin = '$secondPin$number';
    ref.read(secondPinProvider.notifier).setSecondPin(newSecondPin);
  }

  void _onBackspace() {
    final firstPin = ref.read(firstPinProvider);
    final firstPinEnabled = ref.read(firstPinEnabledProvider);

    final pinFieldState = ref.read(pinFieldStateProvider);
    if (pinFieldState == const PinFieldStateFirst()) {
      if (firstPin.isEmpty || !firstPinEnabled) {
        return;
      }

      final newFirstPin = firstPin.substring(0, firstPin.length - 1);

      // Clear before shortening: the confirm field is still open here, and it
      // closes on the write below. A confirmation of the old PIN must not stand
      // beside a new first PIN. ADR-0013 decision 3.
      if (newFirstPin.length < _minPinLength) {
        ref.read(secondPinProvider.notifier).setSecondPin('');
      }

      ref.read(firstPinProvider.notifier).setFirstPin(newFirstPin);
      return;
    }

    final secondPin = ref.read(secondPinProvider);
    final secondPinEnabled = ref.read(secondPinEnabledProvider);

    if (secondPin.isEmpty || !secondPinEnabled) {
      return;
    }

    final newSecondPin = secondPin.substring(0, secondPin.length - 1);
    ref.read(secondPinProvider.notifier).setSecondPin(newSecondPin);
  }

  void _onEnter() {
    // A second ENABLE while an attempt is outstanding does nothing at all.
    // ADR-0013 decision 14.
    final attempt = ref.read(pinSetupAttemptProvider);
    if (attempt is PinSetupAttemptStateOutstanding) {
      return;
    }

    final pinFieldState = ref.read(pinFieldStateProvider);
    final secondPinEnabled = ref.read(secondPinEnabledProvider);

    if (pinFieldState == const PinFieldState.first() && secondPinEnabled) {
      ref
          .read(pinFieldStateProvider.notifier)
          .setPinFieldState(const PinFieldState.second());
      return;
    }

    final firstPin = ref.read(firstPinProvider);
    final secondPin = ref.read(secondPinProvider);
    if (pinFieldState == const PinFieldState.second() && secondPinEnabled) {
      if (firstPin != secondPin) {
        ref
            .read(pinSetupStateProvider.notifier)
            .setPinSetupState(
              PinSetupState.error(message: "PIN code doesn't match".tr()),
            );
        return;
      }

      _prepareToSendPin(firstPin);
    }
  }

  void onTap() {
    final secondPinEnabled = ref.read(secondPinEnabledProvider);
    if (!secondPinEnabled) {
      return;
    }

    final pinFieldState = ref.read(pinFieldStateProvider);
    if (pinFieldState == const PinFieldState.first()) {
      ref
          .read(pinFieldStateProvider.notifier)
          .setPinFieldState(const PinFieldState.second());
      return;
    }

    ref
        .read(pinFieldStateProvider.notifier)
        .setPinFieldState(const PinFieldState.first());
  }

  void _prepareToSendPin(String pin) async {
    // The attempt opens before the biometric prompt, so the await gap is inside
    // the lock rather than beside it. ADR-0013 decision 4.
    //
    // The notifier is taken now and held: it belongs to the container, so it
    // outlives this helper and can still give the attempt back after the screen
    // is gone.
    final attempt = ref.read(pinSetupAttemptProvider.notifier);
    attempt.open();

    // A new attempt has nothing to say yet, so the last failure's message goes.
    // It is also what makes the next failure a transition *into* `error`, which
    // is the one focus trigger of decision 9, and what stops a stale message
    // from masking the threshold message of decision 14.
    ref
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(const PinSetupState.idle());

    try {
      if (ref.read(isBiometricEnabledProvider)) {
        final authenticated = await ref.read(walletProvider).isAuthenticated();

        // Liveness first, then state. BACK during the biometric prompt disposes
        // this helper, and nothing left the app, so nothing is owed a reply.
        // ADR-0013 decision 16.
        if (!ref.mounted) {
          attempt.release();
          return;
        }

        if (!authenticated) {
          logger.e('Biometric authentication failed on sending pin');
          _failAttempt('Biometric authentication failed'.tr());
          return;
        }
      }

      _sendPin(pin);
    } catch (e) {
      // Nothing left the app: sendMsg is the last statement on the path, and
      // everything that can throw runs before it. ADR-0013 decision 15.
      logger.e('PIN setup threw on the send path: $e');

      // The attempt goes back through the notifier taken above, because the
      // throw may be the teardown itself. Liveness first, then state: a form
      // that is gone is owed no message, and reading through a dead `Ref`
      // would throw here and leave the attempt held for the life of the
      // process. ADR-0013 decisions 15 and 16.
      attempt.release();
      if (!ref.mounted) {
        return;
      }

      _setFormMessage('Error setup new PIN code'.tr());
    }
  }

  /// Hands the PIN to the client. Once it is away the attempt stays outstanding
  /// until the reply lands; only a send that never left gives it back here.
  void _sendPin(String pin) {
    if (!ref.read(walletProvider).sendEncryptPin(pin)) {
      _failAttempt('Error setup new PIN code - mnemonic error'.tr());
    }
  }

  /// Gives the attempt back and tells the form what went wrong. Every path that
  /// reaches it left nothing with the client, so no reply is owed.
  void _failAttempt(String message) {
    ref.read(pinSetupAttemptProvider.notifier).release();
    _setFormMessage(message);
  }

  void _setFormMessage(String message) {
    ref
        .read(pinSetupStateProvider.notifier)
        .setPinSetupState(PinSetupState.error(message: message));
  }

  void onPinData(PinDataState pinDataState) {
    logger.d(pinDataState);

    // With one attempt outstanding there is nothing to disambiguate: the reply
    // can only belong to it. With none outstanding the reply belongs to nothing
    // and changes nothing. ADR-0013 decision 14.
    final attempt = ref.read(pinSetupAttemptProvider);
    if (attempt is! PinSetupAttemptStateOutstanding) {
      logger.w('PIN reply with no attempt outstanding; changing nothing');
      return;
    }

    // Anything that is not a whole blob is a failure. The configuration stores
    // a blob that is not whole as no blob at all, so accepting one would raise
    // the flag over nothing to unlock the wallet with.
    if (pinDataState is! PinDataStateData || !pinDataState.isWhole) {
      _failAttempt('Error setup new PIN code'.tr());
      return;
    }

    logger.d('PIN OK');

    // Committed in full, whatever screen is showing, and the attempt is given
    // back only after the commit has succeeded.
    ref
        .read(configurationProvider.notifier)
        .activatePinProtection(pinDataState);
    // The form is cleared before the page changes, the order the screen had
    // before this change, so nothing watching the new page can read a stale
    // PIN out of it.
    _clearStates();
    ref.read(pageStatusProvider.notifier).setStatus(Status.pinSuccess);
    ref.read(pinSetupAttemptProvider.notifier).release();
  }
}
