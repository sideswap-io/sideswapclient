import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'accounts_providers.g.dart';

@riverpod
List<AccountAsset> mobileAvailableAssets(MobileAvailableAssetsRef ref) {
  final balances = ref.watch(balancesProvider);
  final disabledAccounts = ref.watch(walletProvider).disabledAccounts;
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final allAccounts = ref.watch(allAlwaysShowAccountAssetsProvider);

  // Always show accounts with positive balance
  final alwaysEnabledAccounts = balances.balances.entries
      .where((e) => e.value > 0)
      .map((e) => e.key)
      .toSet();
  // Always show regular L-BTC account
  alwaysEnabledAccounts.add(AccountAsset(AccountType.reg, liquidAssetId));
  final availableAssets = allAccounts
      .where((item) =>
          !disabledAccounts.contains(item) ||
          alwaysEnabledAccounts.contains(item))
      .toList();

  return availableAssets;
}

@riverpod
({double amountUsd, String dollarConversion}) accountItemDollarConversion(
    AccountItemDollarConversionRef ref, AccountAsset accountAsset) {
  final precision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: accountAsset.assetId);
  final balance = ref.watch(balancesProvider).balances[accountAsset] ?? 0;
  final amountString = ref.watch(amountToStringProvider).amountToString(
        AmountToStringParameters(
          amount: balance,
          precision: precision,
        ),
      );
  final amount = precision == 0
      ? int.tryParse(amountString) ?? 0
      : double.tryParse(amountString) ?? .0;
  final amountUsd =
      ref.watch(walletProvider).getAmountUsd(accountAsset.assetId, amount);
  var dollarConversion = '0.0';
  dollarConversion = amountUsd.toStringAsFixed(2);
  dollarConversion =
      replaceCharacterOnPosition(input: dollarConversion, currencyChar: '\$');

  return (amountUsd: amountUsd, dollarConversion: dollarConversion);
}

@riverpod
String? accountItemAmount(AccountItemAmountRef ref, AccountAsset accountAsset) {
  final asset = ref.watch(
      assetsStateProvider.select((value) => value[accountAsset.assetId]));
  final precision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: accountAsset.assetId);
  final balance = ref.watch(balancesProvider).balances[accountAsset] ?? 0;
  final amountProvider = ref.watch(amountToStringProvider);
  final amountString = amountProvider.amountToString(
    AmountToStringParameters(
      amount: balance,
      precision: precision,
    ),
  );
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);

  if (asset?.assetId == bitcoinAssetId) {
    return null;
  }

  return amountString;
}
