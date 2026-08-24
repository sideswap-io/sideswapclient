import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

part 'env_provider.g.dart';

@riverpod
class Env extends _$Env {
  @override
  int build() {
    final env = ref.watch(configurationProvider).env;
    return env;
  }

  void setEnv(int env) {
    ref.read(configurationProvider.notifier).setEnv(env);
  }

  bool isTestnet() {
    return state == SIDESWAP_ENV_TESTNET || state == SIDESWAP_ENV_LOCAL_TESTNET;
  }
}
