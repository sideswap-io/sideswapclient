import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

part 'env_provider.g.dart';

@riverpod
class Env extends _$Env {
  @override
  int build() {
    final env = ref.watch(configurationProvider.select((value) => value.env));
    return env;
  }

  void setEnv(int env) {
    ref.read(configurationProvider.notifier).setEnv(env);
  }

  void restart() {
    exit(0);
  }

  bool isTestnet() {
    return state == SIDESWAP_ENV_TESTNET || state == SIDESWAP_ENV_LOCAL_TESTNET;
  }
}
