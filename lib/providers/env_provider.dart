import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

part 'env_provider.g.dart';

@riverpod
class Env extends _$Env {
  @override
  int build() {
    final env = ref.watch(configProvider.select((value) => value.env));
    return env;
  }

  Future<void> setEnv(int env) async {
    await ref.read(configProvider).setEnv(env);
  }

  void restart() {
    exit(0);
  }

  bool isTestnet() {
    return state == SIDESWAP_ENV_TESTNET || state == SIDESWAP_ENV_LOCAL_TESTNET;
  }
}
