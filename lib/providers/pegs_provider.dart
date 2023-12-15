import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'pegs_provider.g.dart';

@Riverpod(keepAlive: true)
class AllPegsNotifier extends _$AllPegsNotifier {
  @override
  Map<String, List<TransItem>> build() {
    return {};
  }

  void update({required From_UpdatedPegs pegs}) {
    final allPegs = {...state};
    allPegs[pegs.orderId] = pegs.items;
    state = allPegs;
  }

  void clear() {
    state = {};
  }
}

@Riverpod(keepAlive: true)
Map<String, TransItem> allPegsById(AllPegsByIdRef ref) {
  final allPegsByIdMap = <String, TransItem>{};
  final allPegs = ref.watch(allPegsNotifierProvider);

  for (var key in allPegs.keys) {
    final peg = allPegs[key]!;

    for (var item in peg) {
      allPegsByIdMap[item.id] = item;
    }
  }

  return allPegsByIdMap;
}
