import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_block_providers.g.dart';

@riverpod
class NewBlockNotifier extends _$NewBlockNotifier {
  @override
  int build() {
    return 0;
  }

  void update() {
    state = state + 1;
  }
}
