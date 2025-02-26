import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
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
  }
}

@riverpod
List<AccountType> balanceUniqueAccountTypes(Ref ref) {
  final balances = ref.watch(balancesNotifierProvider);
  return balances.keys.map((e) => e.account).toSet().toList();
}

@riverpod
int outputsBalanceForAsset(Ref ref, AccountAsset accountAsset) {
  final outputsData = ref.watch(outputsReaderNotifierProvider);

  return switch (outputsData) {
    Right(value: final r) when r.receivers != null && r.receivers!.isNotEmpty =>
      () {
        final receivers = [...r.receivers!];
        receivers.retainWhere(
          (element) =>
              element.assetId == accountAsset.assetId &&
              element.account == accountAsset.account.id,
        );
        return receivers.fold(
          0,
          (previousValue, element) => previousValue + (element.satoshi ?? 0),
        );
      }(),
    _ => 0,
  };
}

/// Inputs related providers
@riverpod
int selectedInputsBalanceForAsset(Ref ref, AccountAsset accountAsset) {
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);

  return switch (selectedInputs) {
    List<UtxosItem> items when items.isNotEmpty => () {
      final inputs = [...items];
      inputs.retainWhere(
        (element) =>
            element.assetId == accountAsset.assetId &&
            element.account == accountAsset.account.id,
      );
      return inputs.fold(
        0,
        (previousValue, element) => previousValue + (element.amount ?? 0),
      );
    }(),
    _ => 0,
  };
}

@riverpod
int maxAvailableBalanceWithInputsForAccountAsset(
  Ref ref,
  AccountAsset accountAsset,
) {
  return ref.watch(selectedInputsBalanceForAssetProvider(accountAsset));
}

@riverpod
int balanceWithInputsForAccountAsset(Ref ref, AccountAsset accountAsset) {
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);

  final outputsBalance = ref.watch(
    outputsBalanceForAssetProvider(accountAsset),
  );
  final allBalances = ref.watch(balancesNotifierProvider);

  if (selectedInputs.isNotEmpty) {
    final selectedInputsBalance = ref.watch(
      selectedInputsBalanceForAssetProvider(accountAsset),
    );
    return selectedInputsBalance - outputsBalance;
  }

  return (allBalances[accountAsset] ?? 0) - outputsBalance;
}

@riverpod
String balanceStringWithInputsForAccountAsset(
  Ref ref,
  AccountAsset accountAsset,
) {
  final walletBalance = ref.watch(
    balanceWithInputsForAccountAssetProvider(accountAsset),
  );
  final asset = ref.watch(assetsStateProvider)[accountAsset.assetId];
  final assetPrecision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: asset?.assetId);
  final amountProvider = ref.watch(amountToStringProvider);
  final balanceStr = amountProvider.amountToString(
    AmountToStringParameters(amount: walletBalance, precision: assetPrecision),
  );
  return balanceStr;
}

@riverpod
String balanceStringWithInputs(Ref ref) {
  final selected = ref.watch(sendAssetNotifierProvider);
  return ref.watch(balanceStringWithInputsForAccountAssetProvider(selected));
}

@riverpod
Decimal accountAssetBalanceWithInputsInDefaultCurrency(
  Ref ref,
  AccountAsset accountAsset,
) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioUsdPrice = portfolioPrices[accountAsset.assetId];
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);
  final assetBalanceStr = ref.watch(
    balanceStringWithInputsForAccountAssetProvider(accountAsset),
  );

  return switch (assetPortfolioUsdPrice) {
    double assetPortfolioUsdPrice => () {
      final assetBalance = Decimal.tryParse(assetBalanceStr) ?? Decimal.zero;
      final assetPortfolioUsdPriceDecimal =
          Decimal.tryParse('$assetPortfolioUsdPrice') ?? Decimal.zero;
      return assetBalance * assetPortfolioUsdPriceDecimal * rateMultiplier;
    }(),
    _ => Decimal.zero,
  };
}

@riverpod
String accountAssetBalanceWithInputsInDefaultCurrencyString(
  Ref ref,
  AccountAsset accountAsset,
) {
  final defaultCurrencyAssetBalance = ref.watch(
    accountAssetBalanceWithInputsInDefaultCurrencyProvider(accountAsset),
  );
  return defaultCurrencyAssetBalance.toStringAsFixed(2);
}

/// Balance providers without inputs

@riverpod
int totalMaxAvailableBalanceForAsset(Ref ref, String assetId) {
  final accounts = ref.watch(balanceUniqueAccountTypesProvider);
  return accounts
      .map(
        (e) => ref.watch(
          maxAvailableBalanceForAccountAssetProvider(AccountAsset(e, assetId)),
        ),
      )
      .fold(0, (previous, nextElement) => previous + nextElement);
}

@riverpod
int maxAvailableBalanceForAccountAsset(Ref ref, AccountAsset accountAsset) {
  return ref.watch(balancesNotifierProvider)[accountAsset] ?? 0;
}

@riverpod
Decimal amountUsdInDefaultCurrency(Ref ref, String? assetId, num amount) {
  final amountUsd = ref.watch(amountUsdProvider(assetId, amount));
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);
  return (amountUsd * rateMultiplier).round(scale: 2);
}

@riverpod
Decimal amountUsd(Ref ref, String? assetId, num amount) {
  if (assetId == null) {
    return Decimal.zero;
  }

  final assetPrice = ref.watch(portfolioPricesNotifierProvider)[assetId];

  final internalAssetPrice = Decimal.tryParse('$assetPrice') ?? Decimal.zero;

  if (internalAssetPrice == Decimal.zero) {
    return Decimal.zero;
  }

  final amountDecimal = Decimal.tryParse('$amount') ?? Decimal.zero;

  final price = (internalAssetPrice * amountDecimal);
  return price;
}

@riverpod
bool isAmountUsdAvailable(Ref ref, String? assetId) {
  if (assetId == null) {
    return false;
  }

  final assetPrice = ref.watch(portfolioPricesNotifierProvider)[assetId];

  return assetPrice != null;
}

@riverpod
String defaultCurrencyConversion(Ref ref, String? assetId, num amount) {
  final defaultCurrencyAmount = ref.watch(
    amountUsdInDefaultCurrencyProvider(assetId, amount),
  );

  if (defaultCurrencyAmount == Decimal.zero) {
    return '0.0';
  }

  if (assetId == null || assetId.isEmpty) {
    return '';
  }

  return defaultCurrencyAmount.toStringAsFixed(2);
}

@riverpod
String defaultCurrencyConversionWithTicker(
  Ref ref,
  String? assetId,
  num amount,
) {
  var conversion = ref.watch(
    defaultCurrencyConversionProvider(assetId, amount),
  );

  final defaultCurrencyTicker = ref.watch(defaultCurrencyTickerProvider);

  conversion = replaceCharacterOnPosition(
    input: conversion,
    currencyChar: defaultCurrencyTicker,
    currencyCharAlignment: CurrencyCharAlignment.end,
  );

  return conversion;
}

@riverpod
String defaultCurrencyConversionFromString(
  Ref ref,
  String? assetId,
  String amount,
) {
  if (amount.isEmpty) {
    return '';
  }

  final amountParsed = double.tryParse(amount) ?? 0;
  if (amountParsed == 0) {
    return '';
  }

  return ref.watch(
    defaultCurrencyConversionWithTickerProvider(assetId, amountParsed),
  );
}

/// Total LBTC ============
@riverpod
String accountAssetsTotalLbtcBalance(
  Ref ref,
  List<AccountAsset> accountAssets,
) {
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

  final amountUsdDecimal = ref.watch(
    _accountAssetsTotalUsdBalanceProvider(accountAssets),
  );
  final amountLbtc =
      liquidIndexPriceDecimal > Decimal.zero
          ? (amountUsdDecimal / liquidIndexPriceDecimal).toDecimal(
            scaleOnInfinitePrecision: assetPrecision,
          )
          : Decimal.zero;

  return liquidIndexPrice > 0
      ? amountLbtc.toStringAsFixed(assetPrecision)
      : '0.0';
}

/// USD currency converters ============
@riverpod
String _accountAssetsTotalUsdBalanceString(
  Ref ref,
  List<AccountAsset> accountAssets,
) {
  Decimal amountUsdDecimal = ref.watch(
    _accountAssetsTotalUsdBalanceProvider(accountAssets),
  );

  var dollarConversion = '0.0';
  dollarConversion = amountUsdDecimal.toStringAsFixed(2);
  return dollarConversion;
}

@riverpod
Decimal _accountAssetsTotalUsdBalance(
  Ref ref,
  List<AccountAsset> accountAssets,
) {
  var amountUsdDecimalSum = Decimal.zero;

  for (final accountAsset in accountAssets) {
    amountUsdDecimalSum += ref.watch(
      _accountAssetBalanceInUsdProvider(accountAsset),
    );
  }

  return amountUsdDecimalSum;
}

@riverpod
Decimal _accountAssetBalanceInUsd(Ref ref, AccountAsset accountAsset) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioPrice = portfolioPrices[accountAsset.assetId];

  return switch (assetPortfolioPrice) {
    double assetPortfolioPrice => () {
      final assetBalanceStr = ref.watch(
        accountAssetBalanceStringProvider(accountAsset),
      );
      final assetBalance = Decimal.tryParse(assetBalanceStr) ?? Decimal.zero;
      final assetPortfolioPriceDecimal =
          Decimal.tryParse('$assetPortfolioPrice') ?? Decimal.zero;
      return assetBalance * assetPortfolioPriceDecimal;
    }(),
    _ => Decimal.zero,
  };
}

@riverpod
String _accountAssetBalanceInUsdString(Ref ref, AccountAsset accountAsset) {
  final usdAssetBalance = ref.watch(
    _accountAssetBalanceInUsdProvider(accountAsset),
  );
  return usdAssetBalance.toStringAsFixed(2);
}

/// Default currency converters ============
@riverpod
String accountAssetsTotalDefaultCurrencyBalanceString(
  Ref ref,
  List<AccountAsset> accountAssets,
) {
  Decimal amountDefaultCurrencyDecimal = ref.watch(
    accountAssetsTotalDefaultCurrencyBalanceProvider(accountAssets),
  );

  var defaultCurrencyConversion = '0.0';
  defaultCurrencyConversion = amountDefaultCurrencyDecimal.toStringAsFixed(2);
  return defaultCurrencyConversion;
}

@riverpod
Decimal accountAssetsTotalDefaultCurrencyBalance(
  Ref ref,
  List<AccountAsset> accountAssets,
) {
  var amountDefaultCurrencyDecimalSum = Decimal.zero;

  for (final accountAsset in accountAssets) {
    amountDefaultCurrencyDecimalSum += ref.watch(
      accountAssetBalanceInDefaultCurrencyProvider(accountAsset),
    );
  }

  return amountDefaultCurrencyDecimalSum;
}

@riverpod
Decimal accountAssetBalanceInDefaultCurrency(
  Ref ref,
  AccountAsset accountAsset,
) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioUsdPrice = portfolioPrices[accountAsset.assetId];
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);
  final assetBalanceStr = ref.watch(
    accountAssetBalanceStringProvider(accountAsset),
  );

  return switch (assetPortfolioUsdPrice) {
    double assetPortfolioUsdPrice => () {
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
  Ref ref,
  AccountAsset accountAsset,
) {
  final defaultCurrencyAssetBalance = ref.watch(
    accountAssetBalanceInDefaultCurrencyProvider(accountAsset),
  );
  return defaultCurrencyAssetBalance.toStringAsFixed(2);
}

/// Asset balance ============
@riverpod
String accountAssetBalanceString(Ref ref, AccountAsset accountAsset) {
  final accountBalance = ref.watch(balancesNotifierProvider)[accountAsset] ?? 0;
  final asset = ref.watch(assetsStateProvider)[accountAsset.assetId];

  return switch (asset) {
    Asset() => () {
      final balanceStr = ref
          .watch(amountToStringProvider)
          .amountToString(
            AmountToStringParameters(
              amount: accountBalance,
              precision: asset.precision,
            ),
          );
      return balanceStr;
    }(),
    _ => '0',
  };
}

@riverpod
String defaultCurrencyTicker(Ref ref) {
  final defaultConversionRate = ref.watch(
    defaultConversionRateNotifierProvider,
  );
  return defaultConversionRate?.name ?? '';
}
