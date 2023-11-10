import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_wallet_backup_skip_prompt_providers.freezed.dart';
part 'new_wallet_backup_skip_prompt_providers.g.dart';

@freezed
class SkipForNowState with _$SkipForNowState {
  const factory SkipForNowState.empty() = SkipForNowStateEmpty;
  const factory SkipForNowState.skipped() = SkipForNowStateSkipped;
}

@riverpod
class SkipForNowNotifier extends _$SkipForNowNotifier {
  @override
  SkipForNowState build() {
    return const SkipForNowStateEmpty();
  }

  void setSkipState(SkipForNowState value) {
    state = value;
  }
}
