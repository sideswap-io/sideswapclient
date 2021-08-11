import 'package:flutter_riverpod/flutter_riverpod.dart';

final balancesProvider = StateNotifierProvider<BalancesNotifier, Balances>(
    (ref) => BalancesNotifier());

class Balances {
  const Balances({
    this.balances = const {},
  });

  final Map<String, int> balances;

  Balances copyWith({
    Map<String, int>? balances,
  }) {
    return Balances(
      balances: balances ?? this.balances,
    );
  }
}

class BalancesNotifier extends StateNotifier<Balances> {
  BalancesNotifier() : super(const Balances());

  void updateBalance({required String key, required int value}) {
    final _balances = Map<String, int>.from(state.balances);
    _balances.update(key, (_) => value, ifAbsent: () => value);

    state = state.copyWith(balances: _balances);
  }

  void removeBalance({required String key}) {
    state.balances.remove(key);
  }

  void clear() {
    state.balances.clear();
  }
}
