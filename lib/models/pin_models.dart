import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_models.freezed.dart';

@freezed
class PinSetupCallerState with _$PinSetupCallerState {
  const factory PinSetupCallerState.empty() = PinSetupCallerStateEmpty;
  const factory PinSetupCallerState.settings() = PinSetupCallerStateSettings;
  const factory PinSetupCallerState.pinWelcome() =
      PinSetupCallerStatePinWelcome;
  const factory PinSetupCallerState.newWalletPinWelcome() =
      PinSetupCallerStateNewWalletPinWelcome;
}

@freezed
class PinSetupExitState with _$PinSetupExitState {
  const factory PinSetupExitState.empty() = PinSetupExitStateEmpty;
  const factory PinSetupExitState.back() = PinSetupExitStateBack;
  const factory PinSetupExitState.success() = PinSetupExitStateSuccess;
}
