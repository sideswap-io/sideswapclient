import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_wallet_providers.freezed.dart';
part 'delete_wallet_providers.g.dart';

@freezed
sealed class LaunchPageDeleteWalletState with _$LaunchPageDeleteWalletState {
  const factory LaunchPageDeleteWalletState.empty() =
      LaunchPageDeleteWalletStateEmpty;
  const factory LaunchPageDeleteWalletState.delete() =
      LaunchPageDeleteWalletStateDelete;
}

@riverpod
class LaunchPageDeleteWalletNotifier extends _$LaunchPageDeleteWalletNotifier {
  @override
  LaunchPageDeleteWalletState build() {
    return const LaunchPageDeleteWalletStateEmpty();
  }

  void setState(LaunchPageDeleteWalletState value) {
    state = value;
  }
}
