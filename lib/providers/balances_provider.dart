import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
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
Decimal amountUsdInDefaultCurrency(
    AmountUsdInDefaultCurrencyRef ref, String? assetId, num amount) {
  final amountUsd = ref.watch(amountUsdProvider(assetId, amount));
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);
  return amountUsd * rateMultiplier;
}

@riverpod
Decimal amountUsd(AmountUsdRef ref, String? assetId, num amount) {
  if (assetId == null) {
    return Decimal.zero;
  }

  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final assetPrice = ref.watch(walletAssetPricesNotifierProvider)[assetId];
  final tetherPrice =
      ref.watch(walletAssetPricesNotifierProvider)[tetherAssetId];

  final tetherPriceBid =
      Decimal.tryParse('${tetherPrice?.bid ?? 0}') ?? Decimal.zero;
  final tetherPriceAsk =
      Decimal.tryParse('${tetherPrice?.ask ?? 0}') ?? Decimal.zero;
  final internalPriceNum = tetherPrice == null
      ? Decimal.zero
      : ((tetherPriceBid + tetherPriceAsk) / Decimal.fromInt(2))
          .toDecimal(scaleOnInfinitePrecision: 8);

  final assetPriceBid =
      Decimal.tryParse('${assetPrice?.bid ?? 0}') ?? Decimal.zero;
  final assetPriceAsk =
      Decimal.tryParse('${assetPrice?.ask ?? 0}') ?? Decimal.zero;
  final internalPriceDen = assetId == liquidAssetId
      ? Decimal.one
      : assetPrice == null
          ? Decimal.zero
          : ((assetPriceBid + assetPriceAsk) / Decimal.fromInt(2))
              .toDecimal(scaleOnInfinitePrecision: 8);

  if (internalPriceDen == Decimal.zero || internalPriceNum == Decimal.zero) {
    return Decimal.zero;
  }

  final price = (internalPriceNum / internalPriceDen)
      .toDecimal(scaleOnInfinitePrecision: 8);

  final amountDecimal = Decimal.tryParse('$amount') ?? Decimal.zero;

  return amountDecimal * price;
}

/// Total LBTC ============
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

  final amountUsdDecimal =
      ref.watch(_accountAssetsTotalUsdBalanceProvider(accountAssets));
  final amountLbtc = liquidIndexPriceDecimal > Decimal.zero
      ? (amountUsdDecimal / liquidIndexPriceDecimal)
          .toDecimal(scaleOnInfinitePrecision: assetPrecision)
      : Decimal.zero;

  return liquidIndexPrice > 0
      ? amountLbtc.toStringAsFixed(assetPrecision)
      : '0.0';
}

/// USD currency converters ============
@riverpod
String _accountAssetsTotalUsdBalanceString(
    _AccountAssetsTotalUsdBalanceStringRef ref,
    List<AccountAsset> accountAssets) {
  Decimal amountUsdDecimal =
      ref.watch(_accountAssetsTotalUsdBalanceProvider(accountAssets));

  var dollarConversion = '0.0';
  dollarConversion = amountUsdDecimal.toStringAsFixed(2);
  return dollarConversion;
}

@riverpod
Decimal _accountAssetsTotalUsdBalance(
    _AccountAssetsTotalUsdBalanceRef ref, List<AccountAsset> accountAssets) {
  var amountUsdDecimalSum = Decimal.zero;

  for (final accountAsset in accountAssets) {
    amountUsdDecimalSum +=
        ref.watch(_accountAssetBalanceInUsdProvider(accountAsset));
  }

  return amountUsdDecimalSum;
}

@riverpod
Decimal _accountAssetBalanceInUsd(
    _AccountAssetBalanceInUsdRef ref, AccountAsset accountAsset) {
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
String _accountAssetBalanceInUsdString(
    _AccountAssetBalanceInUsdStringRef ref, AccountAsset accountAsset) {
  final usdAssetBalance =
      ref.watch(_accountAssetBalanceInUsdProvider(accountAsset));
  return usdAssetBalance.toStringAsFixed(2);
}

/// Default currency converters ============
@riverpod
String accountAssetsTotalDefaultCurrencyBalanceString(
    AccountAssetsTotalDefaultCurrencyBalanceStringRef ref,
    List<AccountAsset> accountAssets) {
  Decimal amountDefaultCurrencyDecimal = ref
      .watch(accountAssetsTotalDefaultCurrencyBalanceProvider(accountAssets));

  var defaultCurrencyConversion = '0.0';
  defaultCurrencyConversion = amountDefaultCurrencyDecimal.toStringAsFixed(2);
  return defaultCurrencyConversion;
}

@riverpod
Decimal accountAssetsTotalDefaultCurrencyBalance(
    AccountAssetsTotalDefaultCurrencyBalanceRef ref,
    List<AccountAsset> accountAssets) {
  var amountDefaultCurrencyDecimalSum = Decimal.zero;

  for (final accountAsset in accountAssets) {
    amountDefaultCurrencyDecimalSum +=
        ref.watch(accountAssetBalanceInDefaultCurrencyProvider(accountAsset));
  }

  return amountDefaultCurrencyDecimalSum;
}

@riverpod
Decimal accountAssetBalanceInDefaultCurrency(
    AccountAssetBalanceInDefaultCurrencyRef ref, AccountAsset accountAsset) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioUsdPrice = portfolioPrices[accountAsset.assetId];
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);

  return switch (assetPortfolioUsdPrice) {
    double assetPortfolioUsdPrice => () {
        final assetBalanceStr =
            ref.watch(accountAssetBalanceStringProvider(accountAsset));
        final assetBalance = Decimal.tryParse(assetBalanceStr) ?? Decimal.zero;
        final assetPortfolioUsdPriceDecimal =
            Decimal.tryParse('$assetPortfolioUsdPrice') ?? Decimal.zero;
        return assetBalance * assetPortfolioUsdPriceDecimal * rateMultiplier;
      }(),
    _ => Decimal.zero,
  };
}

@riverpod
String accountAssetBalanceInDefaultCurrencyString(
    AccountAssetBalanceInDefaultCurrencyStringRef ref,
    AccountAsset accountAsset) {
  final defaultCurrencyAssetBalance =
      ref.watch(accountAssetBalanceInDefaultCurrencyProvider(accountAsset));
  return defaultCurrencyAssetBalance.toStringAsFixed(2);
}

/// Asset balance ============
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

@riverpod
String defaultCurrencyTicker(DefaultCurrencyTickerRef ref) {
  final defaultConversionRate =
      ref.watch(defaultConversionRateNotifierProvider);
  return defaultConversionRate?.name ?? '';
}
