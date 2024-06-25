import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
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
void jadeRescan(JadeRescanRef ref) {
  ref.watch(walletProvider).jadeRescan();
  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    ref.watch(walletProvider).jadeRescan();
  });

  ref.onDispose(() {
    timer.cancel();
  });
}

@riverpod
class JadeDeviceNotifier extends _$JadeDeviceNotifier {
  @override
  JadeDevicesState build() {
    ref.keepAlive();
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
    ref.listenSelf((_, next) {
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
      JadeOnboardingRegistrationState jadeOnboardingRegistrationState) {
    state = jadeOnboardingRegistrationState;
  }
}

@riverpod
bool isJadeWallet(IsJadeWalletRef ref) {
  final jadeId = ref.watch(configurationProvider).jadeId;

  if (jadeId.isNotEmpty) {
    return true;
  }

  return false;
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

@riverpod
class JadeOrderIdTimerNotifier extends _$JadeOrderIdTimerNotifier {
  @override
  String build() {
    return '';
  }

  void setOrderId(String orderId) {
    state = orderId;
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
