import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'accounts_providers.g.dart';

@riverpod
List<AccountAsset> mobileAvailableAssets(MobileAvailableAssetsRef ref) {
  final balances = ref.watch(balancesNotifierProvider);
  final disabledAccounts = ref.watch(walletProvider).disabledAccounts;
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final allAccounts = ref.watch(allAlwaysShowAccountAssetsProvider);

  // Always show accounts with positive balance
  final alwaysEnabledAccounts =
      balances.entries.where((e) => e.value > 0).map((e) => e.key).toSet();
  // Always show regular L-BTC account
  alwaysEnabledAccounts.add(AccountAsset(AccountType.reg, liquidAssetId));
  final availableAssets = allAccounts
      .where((item) =>
          !disabledAccounts.contains(item) ||
          alwaysEnabledAccounts.contains(item))
      .toList();

  return availableAssets;
}
