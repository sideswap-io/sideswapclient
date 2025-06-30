import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_tx_providers.g.dart';

@riverpod
class NewTxNotifier extends _$NewTxNotifier {
  @override
  int build() {
    return 0;
  }

  void update() {
    ref.notifyListeners();
  }
}
