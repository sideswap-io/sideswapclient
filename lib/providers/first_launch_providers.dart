import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_launch_providers.g.dart';
part 'first_launch_providers.freezed.dart';

@freezed
sealed class FirstLaunchStateType with _$FirstLaunchStateType {
  const factory FirstLaunchStateType.empty() = FirstLaunchStateTypeEmpty;
  const factory FirstLaunchStateType.createWallet() =
      FirstLaunchStateTypeCreateWallet;
  const factory FirstLaunchStateType.importWallet() =
      FirstLaunchStateTypeImportWallet;
}

@Riverpod(keepAlive: true)
class FirstLaunchStateNotifier extends _$FirstLaunchStateNotifier {
  @override
  FirstLaunchStateType build() {
    return const FirstLaunchStateTypeEmpty();
  }

  void setFirstLaunchState(FirstLaunchStateType value) {
    state = value;
  }
}
