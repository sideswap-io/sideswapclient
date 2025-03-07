import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'jade_model.freezed.dart';

@freezed
sealed class JadeOnboardingRegistrationState
    with _$JadeOnboardingRegistrationState {
  const factory JadeOnboardingRegistrationState.idle() =
      JadeOnboardingRegistrationStateIdle;
  const factory JadeOnboardingRegistrationState.processing() =
      JadeOnboardingRegistrationStateProcessing;
  const factory JadeOnboardingRegistrationState.done() =
      JadeOnboardingRegistrationStateDone;
}

class JadeStatusException implements Exception {}

@freezed
sealed class JadeStatus with _$JadeStatus {
  const JadeStatus._();

  const factory JadeStatus.idle() = JadeStatusIdle;
  const factory JadeStatus.readStatus() = JadeStatusReadStatus;
  const factory JadeStatus.authUser() = JadeStatusAuthUser;
  const factory JadeStatus.signTx() = JadeStatusSignTx;
  const factory JadeStatus.masterBlindingKey() = JadeStatusMasterBlindingKey;
  const factory JadeStatus.signOfflineSwap() = JadeStatusSignOfflineSwap;
  const factory JadeStatus.signSwap() = JadeStatusSignSwap;
  const factory JadeStatus.signSwapOutput() = JadeStatusSignSwapOutput;
  const factory JadeStatus.connecting() = JadeStatusConnecting;
  const factory JadeStatus.signMessage() = JadeStatusSignMessage;

  factory JadeStatus.fromStatus(From_JadeStatus_Status status) {
    return switch (status) {
      From_JadeStatus_Status.AUTH_USER => const JadeStatusAuthUser(),
      From_JadeStatus_Status.IDLE => const JadeStatusIdle(),
      From_JadeStatus_Status.READ_STATUS => const JadeStatusReadStatus(),
      From_JadeStatus_Status.MASTER_BLINDING_KEY =>
        const JadeStatusMasterBlindingKey(),
      From_JadeStatus_Status.SIGN_TX => const JadeStatusSignTx(),
      From_JadeStatus_Status.SIGN_OFFLINE_SWAP =>
        const JadeStatusSignOfflineSwap(),
      From_JadeStatus_Status.SIGN_SWAP => const JadeStatusSignSwap(),
      From_JadeStatus_Status.SIGN_SWAP_OUTPUT =>
        const JadeStatusSignSwapOutput(),
      From_JadeStatus_Status.CONNECTING => const JadeStatusConnecting(),
      From_JadeStatus_Status.SIGN_MESSAGE => const JadeStatusSignMessage(),
      _ => throw JadeStatusException(),
    };
  }

  From_JadeStatus_Status toStatus() {
    return switch (this) {
      JadeStatusIdle() => From_JadeStatus_Status.IDLE,
      JadeStatusReadStatus() => From_JadeStatus_Status.READ_STATUS,
      JadeStatusAuthUser() => From_JadeStatus_Status.AUTH_USER,
      JadeStatusSignTx() => From_JadeStatus_Status.SIGN_TX,
      JadeStatusMasterBlindingKey() =>
        From_JadeStatus_Status.MASTER_BLINDING_KEY,
      JadeStatusSignOfflineSwap() => From_JadeStatus_Status.SIGN_OFFLINE_SWAP,
      JadeStatusSignSwap() => From_JadeStatus_Status.SIGN_SWAP,
      JadeStatusSignSwapOutput() => From_JadeStatus_Status.SIGN_SWAP_OUTPUT,
      JadeStatusConnecting() => From_JadeStatus_Status.CONNECTING,
      JadeStatusSignMessage() => From_JadeStatus_Status.SIGN_MESSAGE,
    };
  }
}

@freezed
sealed class JadeDevicesState with _$JadeDevicesState {
  const factory JadeDevicesState.unavailable() = JadeDevicesStateUnavailable;
  const factory JadeDevicesState.available({
    required List<From_JadePorts_Port> devices,
  }) = JadeDevicesStateAvailable;
}

@freezed
sealed class JadePort with _$JadePort {
  JadePort._();

  factory JadePort({required From_JadePorts_Port fromJadePortsPort}) =
      _JadePort;

  String get jadeId => fromJadePortsPort.jadeId;
  String get port => fromJadePortsPort.port;
}
