import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'wallet_account_providers.g.dart';

// Keeps the same assets as in assetsStateProvider but separated by account
@Riverpod(keepAlive: true)
class DefaultAccountsState extends _$DefaultAccountsState {
  @override
  Set<AccountAsset> build() {
    return <AccountAsset>{};
  }

  void insertAccountAsset({required AccountAsset accountAsset}) {
    state = {...state, accountAsset};
  }
}

@riverpod
List<AccountAsset> predefinedAccountAssets(Ref ref) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  return [
    AccountAsset(Account.REG, liquidAssetId),
    AccountAsset(Account.AMP_, liquidAssetId),
  ];
}

@riverpod
Iterable<Asset> predefinedAssets(Ref ref) {
  final predefinedAccountAssets = ref.watch(predefinedAccountAssetsProvider);
  final assetsState = ref.watch(assetsStateProvider);

  return predefinedAccountAssets
      .where((e) => e.assetId != null || e.assetId!.isNotEmpty)
      .map((e) => assetsState[e.assetId])
      .where((e) => e != null)
      .toSet()
      .map((e) => e!);
}

/// Needed by ui which want to display limited list of assets - ex. home page wallet
///
@riverpod
List<AccountAsset> allAlwaysShowAccountAssets(Ref ref) {
  final allAssets = ref.watch(accountAssetTransactionsProvider);
  final assets = ref.watch(assetsStateProvider);
  final predefinedAccountAssets = ref.watch(predefinedAccountAssetsProvider);
  // Use array to show registered on the server assets first
  final allAlwaysShowAccountAssets = <AccountAsset>[];
  allAlwaysShowAccountAssets.addAll(predefinedAccountAssets);

  for (final asset in assets.values) {
    if (asset.swapMarket && asset.alwaysShow) {
      allAlwaysShowAccountAssets.add(AccountAsset(Account.REG, asset.assetId));
    } else if (asset.ampMarket && asset.alwaysShow) {
      allAlwaysShowAccountAssets.add(AccountAsset(Account.AMP_, asset.assetId));
    }
  }

  final remainingAccountAssets = allAssets.keys.toSet().difference(
    allAlwaysShowAccountAssets.toSet(),
  );
  for (final account in remainingAccountAssets) {
    allAlwaysShowAccountAssets.add(account);
  }

  return allAlwaysShowAccountAssets;
}

@riverpod
Iterable<Asset> allAlwaysShowAssets(Ref ref) {
  final allAssets = ref.watch(assetTransactionsProvider);
  final assets = ref.watch(assetsStateProvider);
  final predefinedAssets = ref.watch(predefinedAssetsProvider);

  final allAlwaysShowAssets = <Asset>[];
  allAlwaysShowAssets.addAll(predefinedAssets);

  for (final asset in assets.values) {
    if (!asset.alwaysShow) {
      continue;
    }

    if (allAlwaysShowAssets.contains(asset)) {
      continue;
    }

    allAlwaysShowAssets.add(asset);
  }

  final remainingAssets = allAssets.keys.toSet().difference(
    allAlwaysShowAssets.map((e) => e.assetId).toSet(),
  );

  for (final assetId in remainingAssets) {
    final asset = assets[assetId];
    if (asset == null) {
      continue;
    }

    allAlwaysShowAssets.add(asset);
  }

  return allAlwaysShowAssets;
}

@riverpod
List<AccountAsset> allVisibleAccountAssets(Ref ref) {
  final allAccounts = ref.watch(allAlwaysShowAccountAssetsProvider);
  final defaultAccounts = ref.watch(defaultAccountsStateProvider);
  final balances = ref.watch(balancesNotifierProvider);

  final allVisibleAccounts = allAccounts
      .where((e) => defaultAccounts.contains(e) || (balances[e] ?? 0) > 0)
      .toList();

  return allVisibleAccounts;
}

@riverpod
List<AccountAsset> regularVisibleAccountAssets(Ref ref) {
  final allVisibleAccounts = ref.watch(allVisibleAccountAssetsProvider);
  final regularAccounts = allVisibleAccounts
      .where((e) => e.account == Account.REG)
      .toList();
  return regularAccounts;
}

@riverpod
List<AccountAsset> ampVisibleAccountAssets(Ref ref) {
  final allVisibleAccounts = ref.watch(allVisibleAccountAssetsProvider);
  final ampAccounts = allVisibleAccounts
      .where((e) => e.account == Account.AMP_)
      .toList();
  return ampAccounts;
}

/// Needed by ui parts which want to search assetid over all assets - ex. market
///
@riverpod
List<AccountAsset> allAccountAssets(Ref ref) {
  final allAssets = ref.watch(accountAssetTransactionsProvider);
  final assets = ref.watch(assetsStateProvider);
  final predefinedAccountAssets = ref.watch(predefinedAccountAssetsProvider);
  // Use array to show registered on the server assets first
  final allAccountAssets = <AccountAsset>[];
  allAccountAssets.addAll(predefinedAccountAssets);

  for (final asset in assets.values) {
    final accountAsset = switch (asset) {
      Asset(:final ampMarket, :final assetId) when ampMarket => AccountAsset(
        Account.AMP_,
        assetId,
      ),
      _ => AccountAsset(Account.REG, asset.assetId),
    };
    allAccountAssets.add(accountAsset);
  }

  final remainingAccountAssets = allAssets.keys.toSet().difference(
    allAccountAssets.toSet(),
  );
  for (final account in remainingAccountAssets) {
    allAccountAssets.add(account);
  }

  return allAccountAssets;
}

@riverpod
List<AccountAsset> regularAccountAssets(Ref ref) {
  final allAccountAssets = ref.watch(allAccountAssetsProvider);
  return allAccountAssets.where((e) => e.account == Account.REG).toList();
}

@riverpod
List<AccountAsset> ampAccountAssets(Ref ref) {
  final allAccountAssets = ref.watch(allAccountAssetsProvider);
  return allAccountAssets.where((e) => e.account == Account.AMP_).toList();
}

@riverpod
MarketType_ marketTypeForAccountAsset(Ref ref, AccountAsset? accountAsset) {
  final allAssets = ref.watch(assetsStateProvider);
  final asset = allAssets.values.firstWhereOrNull(
    (e) => e.assetId == accountAsset?.assetId,
  );
  return ref.watch(assetMarketTypeProvider(asset));
}

@riverpod
AccountAsset accountAssetFromAsset(Ref ref, Asset? asset) {
  return AccountAsset(
    asset?.ampMarket == true ? Account.AMP_ : Account.REG,
    asset?.assetId,
  );
}

/// Show assets which are:
/// 1. predefined
/// 2. have balance
/// 3. have flag always show
@riverpod
Iterable<Asset> allVisibleAssets(Ref ref) {
  final predefinedAssets = ref.watch(predefinedAssetsProvider);
  final assets = ref.watch(assetsStateProvider);
  final balances = ref.watch(assetBalanceProvider);

  return assets.keys
      .where(
        (assetId) =>
            predefinedAssets.map((e) => e.assetId).contains(assetId) ||
            (balances[assetId] ?? 0) > 0 ||
            assets[assetId]?.alwaysShow == true,
      )
      .toSet()
      .map((e) => assets[e])
      .where((e) => e != null)
      .map((e) => e!);
}
