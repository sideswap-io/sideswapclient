import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'jade_model.freezed.dart';

@freezed
class JadeOnboardingRegistrationState with _$JadeOnboardingRegistrationState {
  const factory JadeOnboardingRegistrationState.idle() =
      JadeOnboardingRegistrationStateIdle;
  const factory JadeOnboardingRegistrationState.processing() =
      JadeOnboardingRegistrationStateProcessing;
  const factory JadeOnboardingRegistrationState.done() =
      JadeOnboardingRegistrationStateDone;
}

@freezed
class JadeStatus with _$JadeStatus {
  const JadeStatus._();

  const factory JadeStatus.idle() = JadeStatusIdle;
  const factory JadeStatus.readStatus() = JadeStatusReadStatus;
  const factory JadeStatus.authUser() = JadeStatusAuthUser;
  const factory JadeStatus.signTx() = JadeStatusSignTx;
  const factory JadeStatus.masterBlindingKey() = JadeStatusMasterBlindingKey;
  const factory JadeStatus.signOfflineSwap() = JadeStatusSignOfflineSwap;
  const factory JadeStatus.signSwap() = JadeStatusSignSwap;
  const factory JadeStatus.signSwapOutput() = JadeStatusSignSwapOutput;

  factory JadeStatus.fromStatus(From_JadeStatus_Status status) {
    switch (status) {
      case From_JadeStatus_Status.AUTH_USER:
        return const JadeStatusAuthUser();
      case From_JadeStatus_Status.IDLE:
        return const JadeStatusIdle();
      case From_JadeStatus_Status.READ_STATUS:
        return const JadeStatusReadStatus();
      case From_JadeStatus_Status.MASTER_BLINDING_KEY:
        return const JadeStatusMasterBlindingKey();

      case From_JadeStatus_Status.SIGN_TX:
        return const JadeStatusSignTx();
      case From_JadeStatus_Status.SIGN_OFFLINE_SWAP:
        return const JadeStatus.signOfflineSwap();
      case From_JadeStatus_Status.SIGN_SWAP:
        return const JadeStatus.signSwap();
      case From_JadeStatus_Status.SIGN_SWAP_OUTPUT:
        return const JadeStatus.signSwapOutput();

      default:
        return const JadeStatus.idle();
    }
  }

  From_JadeStatus_Status toStatus() {
    return when(idle: () {
      return From_JadeStatus_Status.IDLE;
    }, readStatus: () {
      return From_JadeStatus_Status.READ_STATUS;
    }, authUser: () {
      return From_JadeStatus_Status.AUTH_USER;
    }, signTx: () {
      return From_JadeStatus_Status.SIGN_TX;
    }, masterBlindingKey: () {
      return From_JadeStatus_Status.MASTER_BLINDING_KEY;
    }, signSwap: () {
      return From_JadeStatus_Status.SIGN_SWAP;
    }, signSwapOutput: () {
      return From_JadeStatus_Status.SIGN_SWAP_OUTPUT;
    }, signOfflineSwap: () {
      return From_JadeStatus_Status.SIGN_OFFLINE_SWAP;
    });
  }
}

@freezed
class JadeDevicesState with _$JadeDevicesState {
  const factory JadeDevicesState.unavailable() = JadeDevicesStateUnavailable;
  const factory JadeDevicesState.available(
      {required List<From_JadePorts_Port> devices}) = JadeDevicesStateAvailable;
}

@freezed
class JadePort with _$JadePort {
  JadePort._();

  factory JadePort({
    required From_JadePorts_Port fromJadePortsPort,
  }) = _JadePort;

  String get jadeId => fromJadePortsPort.jadeId;
  String get port => fromJadePortsPort.port;
}
