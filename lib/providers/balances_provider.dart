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
    // Make sure all old balances from that account are cleared,
    // because it won't be set here if balance goes to 0.
    // This will prevent showning old balance when new balance is 0.
    final balances = {...state};
    balances.removeWhere((key, value) => key.account == newBalances.account);
    for (final balance in newBalances.balances) {
      final accountAsset = AccountAsset(newBalances.account, balance.assetId);
      balances[accountAsset] = balance.amount.toInt();
    }

    state = balances;
  }
}

@riverpod
Map<String, int> assetBalance(Ref ref) {
  final balances = ref.watch(balancesNotifierProvider);
  final balanceMap = <String, int>{};
  for (final accountAsset in balances.keys) {
    if (accountAsset.assetId == null) {
      continue;
    }

    final current = balanceMap[accountAsset.assetId!] ?? 0;
    balanceMap[accountAsset.assetId!] = current + (balances[accountAsset] ?? 0);
  }

  return balanceMap;
}

@riverpod
int outputsBalanceForAsset(Ref ref, String assetId) {
  final outputsData = ref.watch(outputsReaderNotifierProvider);

  return switch (outputsData) {
    Right(value: final r) when r.receivers != null && r.receivers!.isNotEmpty =>
      () {
        final receivers = [...r.receivers!];
        receivers.retainWhere((element) => element.assetId == assetId);
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
int selectedInputsBalanceForAsset(Ref ref, String assetId) {
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);

  return switch (selectedInputs) {
    List<UtxosItem> items when items.isNotEmpty => () {
      final inputs = [...items];
      inputs.retainWhere((element) => element.assetId == assetId);
      return inputs.fold(
        0,
        (previousValue, element) => previousValue + (element.amount ?? 0),
      );
    }(),
    _ => 0,
  };
}

@riverpod
int maxAvailableBalanceWithInputsForAsset(Ref ref, String assetId) {
  return ref.watch(selectedInputsBalanceForAssetProvider(assetId));
}

@riverpod
int balanceWithInputsForAsset(Ref ref, String assetId) {
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);

  final outputsBalance = ref.watch(outputsBalanceForAssetProvider(assetId));
  final allBalances = ref.watch(assetBalanceProvider);

  if (selectedInputs.isNotEmpty) {
    final selectedInputsBalance = ref.watch(
      selectedInputsBalanceForAssetProvider(assetId),
    );
    return selectedInputsBalance - outputsBalance;
  }

  return (allBalances[assetId] ?? 0) - outputsBalance;
}

@riverpod
String balanceStringWithInputsForAsset(Ref ref, String assetId) {
  final walletBalance = ref.watch(balanceWithInputsForAssetProvider(assetId));
  final asset = ref.watch(assetsStateProvider)[assetId];
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
  final selectedAssetId = ref.watch(sendAssetIdNotifierProvider);
  return ref.watch(balanceStringWithInputsForAssetProvider(selectedAssetId));
}

@riverpod
Decimal assetBalanceWithInputsInDefaultCurrency(Ref ref, String assetId) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioUsdPrice = portfolioPrices[assetId];
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);
  final assetBalanceStr = ref.watch(
    balanceStringWithInputsForAssetProvider(assetId),
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
String assetBalanceWithInputsInDefaultCurrencyString(Ref ref, String assetId) {
  final defaultCurrencyAssetBalance = ref.watch(
    assetBalanceWithInputsInDefaultCurrencyProvider(assetId),
  );
  return defaultCurrencyAssetBalance.toStringAsFixed(2);
}

/// Balance providers without inputs

@riverpod
int availableBalanceForAssetId(Ref ref, String assetId) {
  return ref.watch(assetBalanceProvider)[assetId] ?? 0;
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
String assetsTotalLbtcBalance(Ref ref, Iterable<Asset> assets) {
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

  final amountUsdDecimal = ref.watch(_assetsTotalUsdBalanceProvider(assets));
  final amountLbtc = liquidIndexPriceDecimal > Decimal.zero
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
String _assetsTotalUsdBalanceString(Ref ref, Iterable<Asset> assets) {
  Decimal amountUsdDecimal = ref.watch(_assetsTotalUsdBalanceProvider(assets));

  var dollarConversion = '0.0';
  dollarConversion = amountUsdDecimal.toStringAsFixed(2);
  return dollarConversion;
}

@riverpod
Decimal _assetsTotalUsdBalance(Ref ref, Iterable<Asset> assets) {
  var amountUsdDecimalSum = Decimal.zero;

  for (final asset in assets) {
    amountUsdDecimalSum += ref.watch(_assetBalanceInUsdProvider(asset));
  }

  return amountUsdDecimalSum;
}

@riverpod
Decimal _assetBalanceInUsd(Ref ref, Asset asset) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioPrice = portfolioPrices[asset.assetId];

  return switch (assetPortfolioPrice) {
    double assetPortfolioPrice => () {
      final assetBalanceStr = ref.watch(assetBalanceStringProvider(asset));
      final assetBalance = Decimal.tryParse(assetBalanceStr) ?? Decimal.zero;
      final assetPortfolioPriceDecimal =
          Decimal.tryParse('$assetPortfolioPrice') ?? Decimal.zero;
      return assetBalance * assetPortfolioPriceDecimal;
    },
    _ => () {
      return Decimal.zero;
    },
  }();
}

@riverpod
String _assetBalanceInUsdString(Ref ref, Asset asset) {
  final usdAssetBalance = ref.watch(_assetBalanceInUsdProvider(asset));
  return usdAssetBalance.toStringAsFixed(2);
}

/// Default currency converters ============
@riverpod
String assetsTotalDefaultCurrencyBalanceString(
  Ref ref,
  Iterable<Asset> assets,
) {
  Decimal amountDefaultCurrencyDecimal = ref.watch(
    assetsTotalDefaultCurrencyBalanceProvider(assets),
  );

  var defaultCurrencyConversion = '0.0';
  defaultCurrencyConversion = amountDefaultCurrencyDecimal.toStringAsFixed(2);
  return defaultCurrencyConversion;
}

@riverpod
Decimal assetsTotalDefaultCurrencyBalance(Ref ref, Iterable<Asset> assets) {
  final assetBalances = assets.map(
    (e) => ref.watch(assetBalanceInDefaultCurrencyProvider(e)),
  );

  return assetBalances.fold(
    Decimal.zero,
    (previousValue, element) => previousValue + element,
  );
}

@riverpod
Decimal assetBalanceInDefaultCurrency(Ref ref, Asset asset) {
  final portfolioPrices = ref.watch(portfolioPricesNotifierProvider);
  final assetPortfolioUsdPrice = portfolioPrices[asset.assetId];
  final rateMultiplier = ref.watch(defaultConversionRateMultiplierProvider);
  final assetBalanceStr = ref.watch(assetBalanceStringProvider(asset));

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
String assetBalanceInDefaultCurrencyString(Ref ref, Asset asset) {
  final defaultCurrencyAssetBalance = ref.watch(
    assetBalanceInDefaultCurrencyProvider(asset),
  );
  return defaultCurrencyAssetBalance.toStringAsFixed(2);
}

/// Asset balance ============
@riverpod
String assetBalanceString(Ref ref, Asset asset) {
  final amountToString = ref.watch(amountToStringProvider);
  final assetBalance = ref.watch(assetBalanceProvider);
  final balanceAmount = assetBalance[asset.assetId] ?? 0;

  return amountToString.amountToString(
    AmountToStringParameters(amount: balanceAmount, precision: asset.precision),
  );
}

@riverpod
Decimal assetBalanceDecimal(Ref ref, Asset asset) {
  final assetBalanceString = ref.watch(assetBalanceStringProvider(asset));
  final assetBalanceDecimal =
      Decimal.tryParse(assetBalanceString) ?? Decimal.zero;
  return assetBalanceDecimal;
}

@riverpod
double assetBalanceDouble(Ref ref, Asset asset) {
  final assetBalanceDecimal = ref.watch(assetBalanceDecimalProvider(asset));
  return assetBalanceDecimal.toDouble();
}

@riverpod
String availableBalanceForAssetIdAsString(Ref ref, String? assetId) {
  if (assetId == null) {
    return '0';
  }

  final assetBalance = ref.watch(availableBalanceForAssetIdProvider(assetId));
  final asset = ref.watch(assetsStateProvider)[assetId];

  return switch (asset) {
    Asset() => () {
      final balanceStr = ref
          .watch(amountToStringProvider)
          .amountToString(
            AmountToStringParameters(
              amount: assetBalance,
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
