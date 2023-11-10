import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

final allPegsNotifierProvider =
    AutoDisposeNotifierProvider<AllPegsNotifier, Map<String, List<TransItem>>>(
        AllPegsNotifier.new);

class AllPegsNotifier
    extends AutoDisposeNotifier<Map<String, List<TransItem>>> {
  @override
  Map<String, List<TransItem>> build() {
    ref.keepAlive();
    return {};
  }

  void update({required From_UpdatedPegs pegs}) {
    state[pegs.orderId] = pegs.items;
    ref.notifyListeners();
  }

  void clear() {
    state.clear();
    ref.notifyListeners();
  }
}

final allPegsByIdProvider = AutoDisposeProvider<Map<String, TransItem>>((ref) {
  ref.keepAlive();

  final allPegsById = <String, TransItem>{};
  final allPegs = ref.watch(allPegsNotifierProvider);

  for (var key in allPegs.keys) {
    final peg = allPegs[key]!;

    for (var item in peg) {
      allPegsById[item.id] = item;
    }
  }

  return allPegsById;
});
