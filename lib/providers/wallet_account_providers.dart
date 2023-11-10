import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

final defaultAccountsNotifierProvider =
    AutoDisposeNotifierProvider<DefaultAccountsNotifier, Set<AccountAsset>>(
        DefaultAccountsNotifier.new);

class DefaultAccountsNotifier extends AutoDisposeNotifier<Set<AccountAsset>> {
  @override
  Set<AccountAsset> build() {
    ref.keepAlive();
    return <AccountAsset>{};
  }

  void add({required AccountAsset accountAsset}) {
    state.add(accountAsset);
    ref.notifyListeners();
  }
}

// TODO: assetsStateProvider should not be used in the app
// because now we have 2 types of accounts, regular and amp.
// The same asset could belongs to both types.
// instead of searching assetId in assetsStateProvider map
// we should to know which account type is used and
// then we should search assetId for specified account type
final allAccountAssetsProvider = AutoDisposeProvider<List<AccountAsset>>((ref) {
  final allAssets = ref.watch(accountAssetTransactionsProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final assets = ref.watch(assetsStateProvider);
  // Use array to show registered on the server assets first
  final allAccountAssets = <AccountAsset>[];
  allAccountAssets.add(AccountAsset(AccountType.reg, liquidAssetId));

  for (final asset in assets.values) {
    if (asset.swapMarket && asset.alwaysShow) {
      allAccountAssets.add(AccountAsset(AccountType.reg, asset.assetId));
    } else if (asset.ampMarket && asset.alwaysShow) {
      allAccountAssets.add(AccountAsset(AccountType.amp, asset.assetId));
    }
  }

  final remainingAccountAssets =
      allAssets.keys.toSet().difference(allAccountAssets.toSet());
  for (final account in remainingAccountAssets) {
    allAccountAssets.add(account);
  }

  return allAccountAssets;
});

final allVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>((ref) {
  final allAccounts = ref.watch(allAccountAssetsProvider);
  final defaultAccounts = ref.watch(defaultAccountsNotifierProvider);
  final balances = ref.watch(balancesProvider);

  final allVisibleAccounts = allAccounts
      .where(
          (e) => defaultAccounts.contains(e) || (balances.balances[e] ?? 0) > 0)
      .toList();

  return allVisibleAccounts;
});

final regularAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>((ref) {
  final allVisibleAccounts = ref.watch(allVisibleAccountAssetsProvider);

  final regularAccounts =
      allVisibleAccounts.where((e) => e.account.isRegular).toList();
  return regularAccounts;
});

final ampAccountAssetsProvider = AutoDisposeProvider<List<AccountAsset>>((ref) {
  final allVisibleAccounts = ref.watch(allVisibleAccountAssetsProvider);

  final ampAccounts = allVisibleAccounts.where((e) => e.account.isAmp).toList();

  return ampAccounts;
});
