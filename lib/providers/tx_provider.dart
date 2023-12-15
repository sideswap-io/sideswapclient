import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'tx_provider.g.dart';

@Riverpod(keepAlive: true)
class AllTxsNotifier extends _$AllTxsNotifier {
  @override
  Map<String, TransItem> build() {
    return {};
  }

  void update({required From_UpdatedTxs txs}) {
    final allTxs = {...state};

    for (var item in txs.items) {
      allTxs[item.id] = item;
    }

    state = allTxs;
  }

  void remove({required From_RemovedTxs txs}) {
    final allTxs = {...state};

    for (var txid in txs.txids) {
      allTxs.remove(txid);
    }

    state = allTxs;
  }

  void clear() {
    state = {};
  }
}

@riverpod
List<TransItem> allTxsSorted(AllTxsSortedRef ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final allPegsById = ref.watch(allPegsByIdProvider);

  final allTxsSorted = allTxs.values.toList()..addAll(allPegsById.values);
  allTxsSorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return allTxsSorted;
}

@riverpod
List<TransItem> allNewTxsSorted(AllNewTxsSortedRef ref) {
  final allTxsSorted = ref.watch(allTxsSortedProvider);

  final allNewTxsSorted = <TransItem>[];
  allNewTxsSorted.addAll(allTxsSorted);
  allNewTxsSorted.removeWhere((e) => !e.hasConfs());
  return allNewTxsSorted;
}
