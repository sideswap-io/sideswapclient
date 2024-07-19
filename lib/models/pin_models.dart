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

@freezed
sealed class PinSetupState with _$PinSetupState {
  const factory PinSetupState.idle() = PinSetupStateIdle;
  const factory PinSetupState.error({required String message}) =
      PinSetupStateError;
  const factory PinSetupState.done() = PinSetupStateDone;
}

@freezed
sealed class PinDataState with _$PinDataState {
  const factory PinDataState.empty() = PinDataStateEmpty;
  const factory PinDataState.error({required String message}) =
      PinDataStateError;
  const factory PinDataState.data(
      {required String salt,
      required String encryptedData,
      required String pinIdentifier,
      required String hmac}) = PinDataStateData;

  factory PinDataState.fromJson(Map<String, dynamic> json) =>
      _$PinDataStateFromJson(json);
}

@freezed
sealed class PinProtectionState with _$PinProtectionState {
  const factory PinProtectionState.idle() = PinProtectionStateIdle;
  const factory PinProtectionState.waiting() = PinProtectionStateWaiting;
  const factory PinProtectionState.error({String? message}) =
      PinProtectionStateError;
}
