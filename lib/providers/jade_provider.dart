import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'jade_provider.g.dart';
part 'jade_provider.freezed.dart';

@freezed
sealed class JadeBluetoothPermissionState with _$JadeBluetoothPermissionState {
  const factory JadeBluetoothPermissionState.empty() =
      JadeBluetoothPermissionStateEmpty;
  const factory JadeBluetoothPermissionState.request() =
      JadeBluetoothPermissionStateRequest;
}

@riverpod
class JadeBluetoothPermissionStateNotifier
    extends _$JadeBluetoothPermissionStateNotifier {
  @override
  JadeBluetoothPermissionState build() {
    return const JadeBluetoothPermissionState.empty();
  }

  void setPermissionState(JadeBluetoothPermissionState value) {
    state = value;
  }
}

@riverpod
void jadeRescan(Ref ref) {
  ref.watch(walletProvider).jadeRescan();
  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    ref.watch(walletProvider).jadeRescan();
  });

  ref.onDispose(() {
    timer.cancel();
  });
}

@Riverpod(keepAlive: true)
class JadeDeviceNotifier extends _$JadeDeviceNotifier {
  @override
  JadeDevicesState build() {
    return const JadeDevicesStateUnavailable();
  }

  void setState(JadeDevicesState jadeDevicesState) {
    if (FlavorConfig.isDesktop) {
      state = jadeDevicesState;
      return;
    }

    state = switch (jadeDevicesState) {
      JadeDevicesStateAvailable(devices: List<From_JadePorts_Port> devices) =>
        () {
          logger.d(devices);
          for (final device in devices) {
            if (device.jadeId.toLowerCase().contains('jade')) {
              return JadeDevicesState.available(devices: [device]);
            }
          }
          return const JadeDevicesState.unavailable();
        }(),
      _ => jadeDevicesState,
    };
  }
}

@riverpod
class JadeStatusNotifier extends _$JadeStatusNotifier {
  @override
  JadeStatus build() {
    listenSelf((_, next) {
      logger.d('${jadeStatusNotifierProvider.name}: $next');
    });

    return const JadeStatusIdle();
  }

  void setJadeStatus(JadeStatus jadeStatus) {
    state = jadeStatus;
  }
}

@riverpod
class JadeOnboardingRegistrationNotifier
    extends _$JadeOnboardingRegistrationNotifier {
  @override
  JadeOnboardingRegistrationState build() {
    return const JadeOnboardingRegistrationStateIdle();
  }

  void setState(
    JadeOnboardingRegistrationState jadeOnboardingRegistrationState,
  ) {
    state = jadeOnboardingRegistrationState;
  }
}

@riverpod
bool jadeRegistrationButtonEnabled(Ref ref) {
  final serverLoginState = ref.watch(serverLoginNotifierProvider);
  final jadeOnboardingRegistrationState = ref.watch(
    jadeOnboardingRegistrationNotifierProvider,
  );
  return (jadeOnboardingRegistrationState ==
          JadeOnboardingRegistrationStateIdle() &&
      serverLoginState == ServerLoginStateLogout());
}

@riverpod
bool isJadeWallet(Ref ref) {
  final jadeId = ref.watch(configurationProvider).jadeId;

  return jadeId.isNotEmpty;
}

@riverpod
class JadeInfoDialogNotifier extends _$JadeInfoDialogNotifier {
  @override
  DialogRoute<dynamic>? build() {
    return null;
  }

  void setState(DialogRoute<dynamic>? value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class JadeSelectedDevice extends _$JadeSelectedDevice {
  @override
  From_JadePorts_Port? build() {
    return null;
  }

  void setJadePortsPort(From_JadePorts_Port device) {
    state = device;
  }
}

@freezed
sealed class JadeLockState with _$JadeLockState {
  const factory JadeLockState.locked() = JadeLockStateLocked;
  const factory JadeLockState.unlocked() = JadeLockStateUnlocked;
  const factory JadeLockState.error({String? message}) = JadeLockStateError;
}

const int _oneMinute = 60;
const int _fiveMinutes = 5 * _oneMinute;

@riverpod
class JadeLockStateTimerNotifier extends _$JadeLockStateTimerNotifier {
  RestartableTimer? _timer;

  @override
  void build() {
    _timer?.cancel();
    _timer = RestartableTimer(Duration(seconds: _fiveMinutes), () {
      ref.notifyListeners();
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });
  }

  void extendTimer() {
    _timer?.reset();
  }
}

@riverpod
class JadeLockStateNotifier extends _$JadeLockStateNotifier {
  @override
  JadeLockState build() {
    final isJadeWallet = ref.watch(isJadeWalletProvider);

    if (!isJadeWallet) {
      return JadeLockState.unlocked();
    }

    ref.listen(jadeLockStateTimerNotifierProvider, (_, _) {
      ref.invalidateSelf();
    });

    return JadeLockState.locked();
  }

  void setState(JadeLockState lockState) {
    state = lockState;
  }
}

abstract class AbstractJadeLockRepository {
  JadeLockState get lockState;
  bool hasError();
  bool isUnlocked();
  Option<String> errorMsg();
  void refreshJadeLockState();
}

class JadeLockRepository implements AbstractJadeLockRepository {
  final Ref ref;
  final JadeLockState _lockState;
  final bool isJadeWallet;

  JadeLockRepository({
    required this.ref,
    required this.isJadeWallet,
    JadeLockState lockState = const JadeLockState.locked(),
  }) : _lockState = lockState;

  @override
  JadeLockState get lockState => _lockState;

  @override
  bool hasError() {
    return _lockState is JadeLockStateError;
  }

  @override
  bool isUnlocked() {
    return _lockState is JadeLockStateUnlocked;
  }

  @override
  Option<String> errorMsg() {
    return switch (_lockState) {
      JadeLockStateError(message: String message) => Option.of(message),
      _ => Option.none(),
    };
  }

  @override
  void refreshJadeLockState() {
    if (!isJadeWallet) {
      logger.w('Its not a jade wallet!');
      return;
    }

    Future.microtask(() {
      final msg = To();
      msg.jadeUnlock = Empty();
      ref.read(walletProvider).sendMsg(msg);

      ref.read(jadeLockStateTimerNotifierProvider.notifier).extendTimer();
    });
  }
}

@riverpod
AbstractJadeLockRepository jadeLockRepository(Ref ref) {
  final lockState = ref.watch(jadeLockStateNotifierProvider);
  final isJadeWallet = ref.watch(isJadeWalletProvider);

  return JadeLockRepository(
    ref: ref,
    isJadeWallet: isJadeWallet,
    lockState: lockState,
  );
}

@riverpod
class JadeOneTimeAuthorization extends _$JadeOneTimeAuthorization {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }

  Future<bool> authorize() async {
    if (state) {
      return true;
    }

    ref.read(jadeAuthInProgressStateNotifierProvider.notifier).setState(true);
    final authSucceed = await ref.read(walletProvider).isAuthenticated();
    ref.invalidate(jadeAuthInProgressStateNotifierProvider);
    state = authSucceed;

    return state;
  }
}

@Riverpod(keepAlive: true)
class JadeAuthInProgressStateNotifier
    extends _$JadeAuthInProgressStateNotifier {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}

@freezed
sealed class JadeVerifyAddressState with _$JadeVerifyAddressState {
  const factory JadeVerifyAddressState.idle() = JadeVerifyAddressStateIdle;
  const factory JadeVerifyAddressState.verifying() =
      JadeVerifyAddressStateVerifying;
  const factory JadeVerifyAddressState.success() =
      JadeVerifyAddressStateSuccess;
  const factory JadeVerifyAddressState.error({String? message}) =
      JadeVerifyAddressStateError;
}

@riverpod
class JadeVerifyAddressStateNotifier extends _$JadeVerifyAddressStateNotifier {
  @override
  JadeVerifyAddressState build() {
    return const JadeVerifyAddressState.idle();
  }

  void setState(JadeVerifyAddressState state) {
    this.state = state;
  }
}
