import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_models.freezed.dart';
part 'pin_models.g.dart';

@freezed
sealed class PinSetupCallerState with _$PinSetupCallerState {
  const factory PinSetupCallerState.empty() = PinSetupCallerStateEmpty;
  const factory PinSetupCallerState.settings() = PinSetupCallerStateSettings;
  const factory PinSetupCallerState.pinWelcome() =
      PinSetupCallerStatePinWelcome;
  const factory PinSetupCallerState.newWalletPinWelcome() =
      PinSetupCallerStateNewWalletPinWelcome;
}

@freezed
sealed class PinSetupExitState with _$PinSetupExitState {
  const factory PinSetupExitState.empty() = PinSetupExitStateEmpty;
  const factory PinSetupExitState.back() = PinSetupExitStateBack;
  const factory PinSetupExitState.success() = PinSetupExitStateSuccess;
}

@freezed
sealed class PinFieldState with _$PinFieldState {
  const factory PinFieldState.first() = PinFieldStateFirst;
  const factory PinFieldState.second() = PinFieldStateSecond;
}

/// Whether a setup attempt is outstanding. ADR-0013 decisions 4 and 14: this
/// is the only record that a round trip is in progress, and exclusivity is what
/// supplies the attempt's identity, so it carries no correlation number.
@freezed
sealed class PinSetupAttemptState with _$PinSetupAttemptState {
  const factory PinSetupAttemptState.none() = PinSetupAttemptStateNone;

  /// [overdue] says the wait passed the threshold. It changes the message and
  /// nothing else: the attempt is still held.
  const factory PinSetupAttemptState.outstanding({
    @Default(false) bool overdue,
  }) = PinSetupAttemptStateOutstanding;
}

/// The message decision 14's threshold puts under the confirm field. The client
/// answers every request, so a reply that never arrives means a wedged worker
/// loop, and only a restart recovers it.
const pinSetupTakingLongerKey =
    'This is taking longer than usual. '
    'Close and reopen the app before trying again.';

/// Every message the PIN setup screen can put under the confirm field.
///
/// The desktop reserve is sized against this set, in every locale, by
/// `test/widgets/pin_setup_message_reserve_test.dart`. ADR-0013 decision 8.
const pinSetupMessageKeys = <String>[
  "PIN code doesn't match",
  'Error setup new PIN code',
  'Error setup new PIN code - mnemonic error',
  'Biometric authentication failed',
  pinSetupTakingLongerKey,
];

@freezed
sealed class PinSetupState with _$PinSetupState {
  const factory PinSetupState.idle() = PinSetupStateIdle;
  const factory PinSetupState.error({required String message}) =
      PinSetupStateError;
}

@freezed
sealed class PinDataState with _$PinDataState {
  const factory PinDataState.empty() = PinDataStateEmpty;
  const factory PinDataState.error({required String message}) =
      PinDataStateError;
  const factory PinDataState.data({
    required String salt,
    required String encryptedData,
    required String pinIdentifier,
    required String hmac,
  }) = PinDataStateData;

  factory PinDataState.fromJson(Map<String, dynamic> json) =>
      _$PinDataStateFromJson(json);
}

extension PinDataStateDataWholeness on PinDataStateData {
  /// Whether the configuration will store this blob. It requires these three
  /// fields and stores a blob missing any of them as no blob at all, so a
  /// blob that is not whole must never raise the PIN protection flag.
  ///
  /// `hmac` is absent on purpose: the proto marks it optional where the other
  /// three are required.
  bool get isWhole =>
      salt.isNotEmpty && encryptedData.isNotEmpty && pinIdentifier.isNotEmpty;
}

@freezed
sealed class PinProtectionState with _$PinProtectionState {
  const factory PinProtectionState.idle() = PinProtectionStateIdle;
  const factory PinProtectionState.waiting() = PinProtectionStateWaiting;
  const factory PinProtectionState.error({String? message}) =
      PinProtectionStateError;
}
