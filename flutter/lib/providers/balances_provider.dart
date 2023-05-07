import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

final balancesProvider = ChangeNotifierProvider<BalancesNotifier>((ref) {
  return BalancesNotifier(ref);
});

class BalancesNotifier with ChangeNotifier {
  final Ref ref;
  final balances = <AccountAsset, int>{};

  BalancesNotifier(this.ref);

  void updateBalances(From_BalanceUpdate newBalances) {
    final accountType = getAccountType(newBalances.account);
    // Make sure all old balances from that account are cleared,
    // because it won't be set here if balance goes to 0.
    // This will prevent showning old balance when new balance is 0.
    balances.removeWhere((key, value) => key.account == accountType);
    for (final balance in newBalances.balances) {
      final accountAsset = AccountAsset(accountType, balance.assetId);
      balances[accountAsset] = balance.amount.toInt();
    }
    notifyListeners();
  }

  void clear() {
    balances.clear();
    notifyListeners();
  }
}
