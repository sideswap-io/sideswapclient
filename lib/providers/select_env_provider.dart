import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/env_provider.dart';

part 'select_env_provider.g.dart';

@riverpod
class SelectEnvDialog extends _$SelectEnvDialog {
  @override
  bool build() {
    return false;
  }

  void setSelectEnvDialog(bool value) {
    state = value;
  }
}

@riverpod
class SelectedEnv extends _$SelectedEnv {
  @override
  int build() {
    final env = ref.watch(envProvider);
    return env;
  }

  Future<void> setSelectedEnv(int selectedEnv) async {
    state = selectedEnv;
  }
}

@riverpod
class SelectEnvTap extends _$SelectEnvTap {
  @override
  int build() {
    return 0;
  }

  void setTap() {
    state += 1;
    if (state > 7) {
      state = 0;
      ref.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(true);
    }
  }
}
