import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

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

final getBalanceAccountProvider =
    AutoDisposeProviderFamily<AccountAsset?, Asset?>((ref, asset) {
  return AccountAsset(
    asset?.ampMarket == true ? AccountType.amp : AccountType.reg,
    asset?.assetId,
  );
});

final balanceStringProvider =
    Provider.family.autoDispose<String, AccountAsset>((ref, account) {
  final selected = ref.watch(sendAssetProvider);
  final asset = ref.watch(assetsStateProvider)[account.assetId];
  final assetPrecision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: asset?.assetId);
  final balance = ref.watch(balancesProvider).balances[selected] ?? 0;
  final amountProvider = ref.watch(amountToStringProvider);
  final balanceStr = amountProvider.amountToString(
      AmountToStringParameters(amount: balance, precision: assetPrecision));
  return balanceStr;
});
