import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

final allTxsNotifierProvider =
    AutoDisposeNotifierProvider<AllTxsNotifier, Map<String, TransItem>>(
        AllTxsNotifier.new);

class AllTxsNotifier extends AutoDisposeNotifier<Map<String, TransItem>> {
  @override
  Map<String, TransItem> build() {
    ref.keepAlive();
    return {};
  }

  void update({required From_UpdatedTxs txs}) {
    for (var item in txs.items) {
      state[item.id] = item;
    }

    ref.notifyListeners();
  }

  void remove({required From_RemovedTxs txs}) {
    for (var txid in txs.txids) {
      state.remove(txid);
    }

    ref.notifyListeners();
  }

  void clear() {
    state.clear();
    ref.notifyListeners();
  }
}

final allTxsSortedProvider = AutoDisposeProvider<List<TransItem>>((ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final allPegsById = ref.watch(allPegsByIdProvider);

  final allTxsSorted = allTxs.values.toList()..addAll(allPegsById.values);
  allTxsSorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return allTxsSorted;
});

final allNewTxsSortedProvider = AutoDisposeProvider<List<TransItem>>((ref) {
  final allTxsSorted = ref.watch(allTxsSortedProvider);

  final allNewTxsSorted = <TransItem>[];
  allNewTxsSorted.addAll(allTxsSorted);
  allNewTxsSorted.removeWhere((e) => !e.hasConfs());
  return allNewTxsSorted;
});
