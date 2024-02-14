import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/portfolio_prices_providers.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'balances_provider.g.dart';

@Riverpod(keepAlive: true)
class BalancesNotifier extends _$BalancesNotifier {
  @override
  Map<AccountAsset, int> build() {
    return {};
  }

  void updateBalances(From_BalanceUpdate newBalances) {
    final accountType = getAccountType(newBalances.account);
    // Make sure all old balances from that account are cleared,
    // because it won't be set here if balance goes to 0.
    // This will prevent showning old balance when new balance is 0.
    final balances = {...state};
    balances.removeWhere((key, value) => key.account == accountType);
    for (final balance in newBalances.balances) {
      final accountAsset = AccountAsset(accountType, balance.assetId);
      balances[accountAsset] = balance.amount.toInt();
    }

    state = balances;
    ref.notifyListeners();
  }

  void clear() {
    state.clear();
    ref.notifyListeners();
  }
}

@riverpod
String balanceString(BalanceStringRef ref, AccountAsset accountAsset) {
  final selected = ref.watch(sendAssetNotifierProvider);
  final asset = ref.watch(assetsStateProvider)[accountAsset.assetId];
  final assetPrecision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: asset?.assetId);
  final balance = ref.watch(balancesNotifierProvider)[selected] ?? 0;
  final amountProvider = ref.watch(amountToStringProvider);
  final balanceStr = amountProvider.amountToString(
      AmountToStringParameters(amount: balance, precision: assetPrecision));
  return balanceStr;
}

@riverpod
double amountUsd(AmountUsdRef ref, String? assetId, num amount) {
  if (assetId == null) {
    return 0;
  }

  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final assetPrice = ref.watch(walletAssetPricesNotifierProvider)[assetId];
  final tetherPrice =
      ref.watch(walletAssetPricesNotifierProvider)[tetherAssetId];

  final internalPriceNum =
      tetherPrice == null ? 0 : (tetherPrice.bid + tetherPrice.ask) / 2;
  final internalPriceDen = assetId == liquidAssetId
      ? 1
      : assetPrice == null
          ? 0
          : (assetPrice.bid + assetPrice.ask) / 2;

  if (internalPriceDen == 0 || internalPriceNum == 0) {
    return 0;
  }

  final price = internalPriceNum / internalPriceDen;

  return amount * price;
}

@riverpod
String accountAssetsTotalUsdBalanceString(
    AccountAssetsTotalUsdBalanceStringRef ref,
    List<AccountAsset> accountAssets) {
  Decimal amountUsdDecimal =
      ref.watch(accountAssetsTotalUsdBalanceProvider(accountAssets));

  var dollarConversion = '0.0';
  dollarConversion = amountUsdDecimal.toStringAsFixed(2);
  return dollarConversion;
}

@riverpod
Decimal accountAssetsTotalUsdBalance(
    AccountAssetsTotalUsdBalanceRef ref, List<AccountAsset> accountAssets) {
  var amountUsdDecimalSum = Decimal.zero;

  for (final accountAsset in accountAssets) {
    amountUsdDecimalSum +=
        ref.watch(accountAssetBalanceInUsdProvider(accountAsset));
  }

  return amountUsdDecimalSum;
}

@riverpod
String accountAssetsTotalLbtcBalance(
    AccountAssetsTotalLbtcBalanceRef ref, List<AccountAsset> accountAssets) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final liquidIndexPrice = portfolioPrices[liquidAssetId];
  if (liquidIndexPrice == null) {
    return '0.0';
  }

  final liquidIndexPriceDecimal = Decimal.parse('$liquidIndexPrice');

  final assetPrecision = ref
      .read(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: liquidAssetId);

  final amountUsd =
      ref.watch(accountAssetsTotalUsdBalanceProvider(accountAssets));
  final amountUsdDecimal = Decimal.parse('$amountUsd');
  final amountLbtc = liquidIndexPriceDecimal > Decimal.zero
      ? (amountUsdDecimal / liquidIndexPriceDecimal)
          .toDecimal(scaleOnInfinitePrecision: assetPrecision)
      : Decimal.zero;

  return liquidIndexPrice > 0
      ? amountLbtc.toStringAsFixed(assetPrecision)
      : '0.0';
}

@riverpod
String accountAssetBalanceInUsdString(
    AccountAssetBalanceInUsdStringRef ref, AccountAsset accountAsset) {
  final usdAssetBalance =
      ref.watch(accountAssetBalanceInUsdProvider(accountAsset));
  return usdAssetBalance.toStringAsFixed(2);
}

@riverpod
Decimal accountAssetBalanceInUsd(
    AccountAssetBalanceInUsdRef ref, AccountAsset accountAsset) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioPrice = portfolioPrices[accountAsset.assetId];

  return switch (assetPortfolioPrice) {
    double assetPortfolioPrice => () {
        final assetBalanceStr =
            ref.watch(accountAssetBalanceStringProvider(accountAsset));
        final assetBalance = Decimal.tryParse(assetBalanceStr) ?? Decimal.zero;
        final assetPortfolioPriceDecimal =
            Decimal.tryParse('$assetPortfolioPrice') ?? Decimal.zero;
        return assetBalance * assetPortfolioPriceDecimal;
      }(),
    _ => Decimal.zero,
  };
}

@riverpod
String accountAssetBalanceString(
    AccountAssetBalanceStringRef ref, AccountAsset accountAsset) {
  final accountBalance = ref.watch(balancesNotifierProvider)[accountAsset] ?? 0;
  final asset = ref.watch(assetsStateProvider)[accountAsset.assetId];

  return switch (asset) {
    Asset() => () {
        final balanceStr = ref.watch(amountToStringProvider).amountToString(
            AmountToStringParameters(
                amount: accountBalance, precision: asset.precision));
        return balanceStr;
      }(),
    _ => '0',
  };
}
