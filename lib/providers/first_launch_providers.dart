import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_launch_providers.g.dart';
part 'first_launch_providers.freezed.dart';

@freezed
sealed class FirstLaunchState with _$FirstLaunchState {
  const factory FirstLaunchState.empty() = FirstLaunchStateEmpty;
  const factory FirstLaunchState.createWallet() = FirstLaunchStateCreateWallet;
  const factory FirstLaunchState.importWallet() = FirstLaunchStateImportWallet;
}

@Riverpod(keepAlive: true)
class FirstLaunchStateNotifier extends _$FirstLaunchStateNotifier {
  @override
  FirstLaunchState build() {
    return const FirstLaunchStateEmpty();
  }

  void setFirstLaunchState(FirstLaunchState value) {
    state = value;
  }
}
