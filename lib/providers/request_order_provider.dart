import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'request_order_provider.g.dart';

class OrderEntryAccountAsset {
  final AccountAsset accountAsset;
  final List<AccountAsset> accountAssetList;

  OrderEntryAccountAsset({
    required this.accountAsset,
    required this.accountAssetList,
  });

  @override
  String toString() =>
      'OrderEntryAccountAsset(accountAsset: $accountAsset, accountAssetList: $accountAssetList)';

  (AccountAsset, List<AccountAsset>) _equality() =>
      (accountAsset, accountAssetList);

  @override
  bool operator ==(covariant OrderEntryAccountAsset other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

class OrderEntryProductPair {
  final OrderEntryAccountAsset deliver;
  final OrderEntryAccountAsset receive;
  OrderEntryProductPair({
    required this.deliver,
    required this.receive,
  });

  @override
  String toString() =>
      'OrderEntryProduct(deliver: $deliver, receive: $receive)';

  (OrderEntryAccountAsset, OrderEntryAccountAsset) _equality() =>
      (deliver, receive);

  @override
  bool operator ==(covariant OrderEntryProductPair other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
OrderEntryProductPair defaultOrderEntryProduct(
    DefaultOrderEntryProductRef ref) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
  final defaultDeliverAccountAsset =
      AccountAsset(AccountType.reg, liquidAssetId);
  final defaultReceiveAccountAsset =
      AccountAsset(AccountType.reg, tetherAssetId);

  return OrderEntryProductPair(
    deliver: OrderEntryAccountAsset(
      accountAsset: defaultDeliverAccountAsset,
      accountAssetList: [defaultDeliverAccountAsset],
    ),
    receive: OrderEntryAccountAsset(
      accountAsset: defaultReceiveAccountAsset,
      accountAssetList: [defaultReceiveAccountAsset],
    ),
  );
}

@riverpod
OrderEntryProductPair orderEntryProduct(OrderEntryProductRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final selectedAsset =
      ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final pricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);

  final regularAccountAssets = ref.watch(regularVisibleAccountAssetsProvider);
  final ampAccountAssets = ref.watch(ampVisibleAccountAssetsProvider);

  final makeOrderSide = ref.watch(makeOrderSideStateProvider);
  final liquidAccountAsset = ref.watch(makeOrderLiquidAccountAssetProvider);

  if (liquidAccountAsset == null) {
    logger.w('Unable to build AccountAsset for liquid account asset');
    final defaultValue = ref.watch(defaultOrderEntryProductProvider);
    return defaultValue;
  }

  final accountAssetPair = switch (makeOrderSide) {
    MakeOrderSide.sell => (
        deliver: pricedInLiquid ? selectedAccountAsset : liquidAccountAsset,
        receive: pricedInLiquid ? liquidAccountAsset : selectedAccountAsset
      ),
    MakeOrderSide.buy => (
        deliver: pricedInLiquid ? liquidAccountAsset : selectedAccountAsset,
        receive: pricedInLiquid ? selectedAccountAsset : liquidAccountAsset
      ),
  };

  final availableAssetList = switch (selectedAccountAsset.account) {
    AccountType(isAmp: true) => [...ampAccountAssets],
    AccountType(isAmp: false) => [...regularAccountAssets],
  };

  // don't allow for user to choose liquid asset from dropdown, everything will blow up
  availableAssetList.remove(liquidAccountAsset);

  final availableDeliverAssetList =
      accountAssetPair.deliver == liquidAccountAsset
          ? [liquidAccountAsset]
          : availableAssetList;
  final availableReceiveAssetList =
      accountAssetPair.receive == liquidAccountAsset
          ? [liquidAccountAsset]
          : availableAssetList;

  return OrderEntryProductPair(
    deliver: OrderEntryAccountAsset(
      accountAsset: accountAssetPair.deliver,
      accountAssetList: availableDeliverAssetList,
    ),
    receive: OrderEntryAccountAsset(
      accountAsset: accountAssetPair.receive,
      accountAssetList: availableReceiveAssetList,
    ),
  );
}

@riverpod
OrderEntryAccountAsset deliverOrderEntryAccountAsset(
    DeliverOrderEntryAccountAssetRef ref) {
  final deliverAccountAsset =
      ref.watch(requestOrderDeliverAccountAssetProvider);
  final deliverAccountType = deliverAccountAsset.account;

  final accountAssetsWithBalances = ref
      .watch(balancesNotifierProvider)
      .entries
      .where((element) => element.value > 0)
      .map((e) => e.key)
      .toList();

  final accountAssetList = <AccountAsset>[];
  if (deliverAccountType == AccountType.reg) {
    final regularAccountAssets = ref.watch(regularVisibleAccountAssetsProvider);
    accountAssetList.addAll(regularAccountAssets);
  } else {
    final ampAccountAssets = ref.watch(ampVisibleAccountAssetsProvider);
    accountAssetList.addAll(ampAccountAssets);
  }

  if (accountAssetList.isEmpty) {
    return OrderEntryAccountAsset(
      accountAsset: deliverAccountAsset,
      accountAssetList: [deliverAccountAsset],
    );
  }

  final deliverAccountAssetList = [accountAssetList, accountAssetsWithBalances]
      .map((e) => e.toSet())
      .reduce((value, element) => value.intersection(element))
      .toList();

  return OrderEntryAccountAsset(
    accountAsset: deliverAccountAsset,
    accountAssetList: deliverAccountAssetList,
  );
}

@riverpod
OrderEntryAccountAsset receiveOrderEntryAccountAsset(
    ReceiveOrderEntryAccountAssetRef ref) {
  final receiveAccountAsset =
      ref.watch(requestOrderReceiveAccountAssetProvider);
  final receiveAccountType = receiveAccountAsset.account;

  final accountAssetsWithBalances = ref
      .watch(balancesNotifierProvider)
      .entries
      .where((element) => element.value > 0)
      .map((e) => e.key)
      .toList();

  final accountAssetList = <AccountAsset>[];
  if (receiveAccountType == AccountType.reg) {
    final regularAccountAssets = ref.watch(regularVisibleAccountAssetsProvider);
    accountAssetList.addAll(regularAccountAssets);
  } else {
    final ampAccountAssets = ref.watch(ampVisibleAccountAssetsProvider);
    accountAssetList.addAll(ampAccountAssets);
  }

  if (accountAssetList.isEmpty) {
    return OrderEntryAccountAsset(
      accountAsset: receiveAccountAsset,
      accountAssetList: [receiveAccountAsset],
    );
  }

  final receiveAccountAssetList = [accountAssetList, accountAssetsWithBalances]
      .map((e) => e.toSet())
      .reduce((value, element) => value.intersection(element))
      .toList();

  if (!receiveAccountAssetList
      .any((element) => element.assetId == receiveAccountAsset.assetId)) {
    receiveAccountAssetList.add(receiveAccountAsset);
  }

  if (!receiveAccountAssetList
      .any((element) => element == receiveAccountAsset)) {
    logger.d('error');
  }

  return OrderEntryAccountAsset(
    accountAsset: receiveAccountAsset,
    accountAssetList: receiveAccountAssetList,
  );
}

@Riverpod(keepAlive: true)
class RequestOrderDeliverAccountAsset
    extends _$RequestOrderDeliverAccountAsset {
  @override
  AccountAsset build() {
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final defaultDeliverAccountAsset =
        AccountAsset(AccountType.reg, liquidAssetId);
    return defaultDeliverAccountAsset;
  }

  void setDeliverAccountAsset(AccountAsset value) {
    logger.d('Set Deliver to: $value');
    state = value;
  }
}

@Riverpod(keepAlive: true)
class RequestOrderReceiveAccountAsset
    extends _$RequestOrderReceiveAccountAsset {
  @override
  AccountAsset build() {
    final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
    final defaultReceiveAccountAsset =
        AccountAsset(AccountType.reg, tetherAssetId);
    return defaultReceiveAccountAsset;
  }

  void setReceiveAccountAsset(AccountAsset value) {
    logger.d('Set Receive to: $value');
    state = value;
  }
}

// TODO (malcolmpl): move functions to providers
final requestOrderProvider =
    AutoDisposeChangeNotifierProvider<RequestOrderProvider>((ref) {
  ref.keepAlive();
  final deliverOrderEntry = ref.watch(deliverOrderEntryAccountAssetProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  return RequestOrderProvider(
    ref,
    deliverOrderEntry,
    liquidAssetId,
  );
});

@riverpod
String deliverHintText(DeliverHintTextRef ref) {
  final precision = ref.watch(deliverAssetPrecisionProvider);
  final hint = DecimalCutterTextInputFormatter(
    decimalRange: precision,
  )
      .formatEditUpdate(const TextEditingValue(text: '0.00000000'),
          const TextEditingValue(text: '0.00000000'))
      .text;

  return hint;
}

@riverpod
String receiveHintText(ReceiveHintTextRef ref) {
  final precision = ref.watch(receiveAssetPrecisionProvider);
  final hint = DecimalCutterTextInputFormatter(
    decimalRange: precision,
  )
      .formatEditUpdate(const TextEditingValue(text: '0.00000000'),
          const TextEditingValue(text: '0.00000000'))
      .text;

  return hint;
}

@riverpod
bool isDeliverLiquid(IsDeliverLiquidRef ref) {
  final deliverAccountAsset = ref.watch(deliverOrderEntryAccountAssetProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  return deliverAccountAsset.accountAsset.assetId == liquidAssetId;
}

@riverpod
AccountAsset tokenAccountAsset(TokenAccountAssetRef ref) {
  final isDeliverLiquid = ref.watch(isDeliverLiquidProvider);
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final receiveAccountAsset = orderEntryProductPair.receive.accountAsset;
  final deliverAccountAsset = orderEntryProductPair.deliver.accountAsset;
  return isDeliverLiquid ? receiveAccountAsset : deliverAccountAsset;
}

@riverpod
bool selectedAssetIsToken(SelectedAssetIsTokenRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  return ref
      .watch(assetUtilsProvider)
      .isAssetToken(assetId: selectedAccountAsset.assetId);
}

@riverpod
Asset? deliverAsset(DeliverAssetRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final assetMap = ref.watch(assetsStateProvider);
  return assetMap[orderEntryProductPair.deliver.accountAsset.assetId];
}

@riverpod
int deliverAssetPrecision(DeliverAssetPrecisionRef ref) {
  final deliverAsset = ref.watch(deliverAssetProvider);
  return deliverAsset?.precision ?? 0;
}

@riverpod
String deliverAssetTicker(DeliverAssetTickerRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);

  return ref
      .watch(assetUtilsProvider)
      .tickerForAssetId(orderEntryProductPair.deliver.accountAsset.assetId);
}

@riverpod
List<AccountAsset> deliverAccountAssetList(DeliverAccountAssetListRef ref) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final balances = ref.watch(balancesNotifierProvider);

  final assets = balances.entries
      .where((item) =>
          item.value > 0 ||
          (item.key.assetId == liquidAssetId &&
              item.key.account == AccountType.reg))
      .map((item) => item.key)
      .toList();
  assets.sort();

  return assets;
}

@riverpod
List<AccountAsset> disableAccountAssetList(DisableAccountAssetListRef ref) {
  final ampAssets = ref.watch(ampAssetsNotifierProvider);
  final allAssets = ref.watch(assetsStateProvider);
  final deliverAccountAssetList = ref.watch(deliverAccountAssetListProvider);

  final assetList = deliverAccountAssetList.where((item) {
    final asset = allAssets[item.assetId];
    if (asset == null) {
      return true;
    }

    if (asset.unregistered) {
      return true;
    }
    final isAmpAsset = ampAssets.contains(asset.assetId);
    final isAmpAccount = item.account == AccountType.amp;
    if (isAmpAsset != isAmpAccount) {
      return true;
    }
    return false;
  }).toList();

  return assetList;
}

@riverpod
String deliverBalance(DeliverBalanceRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final balances = ref.watch(balancesNotifierProvider);

  final balance = balances[orderEntryProductPair.deliver.accountAsset] ?? 0;
  final precision = ref.watch(deliverAssetPrecisionProvider);

  return ref.watch(amountToStringProvider).amountToString(
      AmountToStringParameters(amount: balance, precision: precision));
}

@riverpod
Asset? receiveAsset(ReceiveAssetRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final assetsMap = ref.watch(assetsStateProvider);
  return assetsMap[orderEntryProductPair.receive.accountAsset.assetId];
}

@riverpod
int receiveAssetPrecision(ReceiveAssetPrecisionRef ref) {
  final receiveAsset = ref.watch(receiveAssetProvider);
  return receiveAsset?.precision ?? 0;
}

@riverpod
String defaultCurrencyConversion(
    DefaultCurrencyConversionRef ref, String? assetId, num amount) {
  ref.watch(requestOrderIndexPriceProvider);
  final defaultCurrencyAmount =
      ref.watch(amountUsdInDefaultCurrencyProvider(assetId, amount));

  if (defaultCurrencyAmount == Decimal.zero) {
    return '0.0';
  }

  if (assetId == null || assetId.isEmpty) {
    return '';
  }

  var conversion = defaultCurrencyAmount.toStringAsFixed(2);
  final defaultCurrencyTicker = ref.watch(defaultCurrencyTickerProvider);

  conversion = replaceCharacterOnPosition(
      input: conversion,
      currencyChar: defaultCurrencyTicker,
      currencyCharAlignment: CurrencyCharAlignment.end);

  return conversion;
}

@riverpod
String defaultCurrencyConversionFromString(
    DefaultCurrencyConversionFromStringRef ref,
    String? assetId,
    String amount) {
  if (amount.isEmpty) {
    return '';
  }

  final amountParsed = double.tryParse(amount) ?? 0;
  if (amountParsed == 0) {
    return '';
  }

  return ref.watch(defaultCurrencyConversionProvider(assetId, amountParsed));
}

@riverpod
String receiveBalance(ReceiveBalanceRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final balances = ref.watch(balancesNotifierProvider);

  final balance = balances[orderEntryProductPair.receive.accountAsset];
  final precision = ref.watch(receiveAssetPrecisionProvider);
  return ref.watch(amountToStringProvider).amountToString(
      AmountToStringParameters(amount: balance ?? 0, precision: precision));
}

@riverpod
MarketType marketType(MarketTypeRef ref) {
  final tokenAssetId = ref.watch(tokenAccountAssetProvider).assetId;
  final tokenAsset = ref.watch(assetsStateProvider)[tokenAssetId];
  if (tokenAsset?.swapMarket == true) {
    return MarketType.stablecoin;
  }
  if (tokenAsset?.ampMarket == true) {
    return MarketType.amp;
  }
  return MarketType.token;
}

@riverpod
bool isStablecoinMarket(IsStablecoinMarketRef ref) {
  final marketType = ref.watch(marketTypeProvider);
  return marketType == MarketType.stablecoin;
}

// TODO (malcolmpl): move functions to providers
class RequestOrderProvider extends ChangeNotifier {
  final Ref ref;

  RequestOrderProvider(
    this.ref,
    OrderEntryAccountAsset deliverOrderEntry,
    this.liquidAssetId,
  ) {
    _deliverOrderEntry = deliverOrderEntry;
  }

  late final OrderEntryAccountAsset _deliverOrderEntry;
  final String liquidAssetId;

  void validateDeliverAsset() {
    final allDeliverAccounts = ref.read(deliverAccountAssetListProvider);
    // This would deselect currently selected asset if it goes to 0
    final validDeliver =
        allDeliverAccounts.contains(_deliverOrderEntry.accountAsset);
    if (!validDeliver) {
      // TODO (malcolmpl): change this to marketSelectedAssetIdStateProvider
      ref
          .read(requestOrderDeliverAccountAssetProvider.notifier)
          .setDeliverAccountAsset(allDeliverAccounts.first);
    }
  }

  String calculateReceiveAmount(String deliverAmount, String priceAmount) {
    final deliverAmountStr = deliverAmount.replaceAll(' ', '');
    final priceAmountStr = priceAmount.replaceAll(' ', '');
    var amountParsed = Decimal.zero;

    final deliverAmountParsed =
        Decimal.tryParse(deliverAmountStr) ?? Decimal.zero;
    final priceAmountParsed = Decimal.tryParse(priceAmountStr) ?? Decimal.zero;
    final receiveAssetPrecision = ref.read(receiveAssetPrecisionProvider);

    // TODO (malcolmpl): Include server fee here
    final isDeliverLiquid = ref.read(isDeliverLiquidProvider);
    final isStablecoinMarket = ref.read(isStablecoinMarketProvider);
    if (isStablecoinMarket == isDeliverLiquid) {
      amountParsed = deliverAmountParsed * priceAmountParsed;
    } else {
      if (priceAmountParsed != Decimal.zero) {
        amountParsed = (deliverAmountParsed / priceAmountParsed)
            .toDecimal(scaleOnInfinitePrecision: receiveAssetPrecision);
      }
    }

    if (amountParsed == Decimal.zero) {
      return '';
    }

    return amountParsed.toStringAsFixed(receiveAssetPrecision);
  }

  String calculateDeliverAmount(String receiveAmount, String priceAmount) {
    final receiveAmountStr = receiveAmount.replaceAll(' ', '');
    final priceAmountStr = priceAmount.replaceAll(' ', '');
    var amountParsed = Decimal.zero;

    final receiveAmountParsed =
        Decimal.tryParse(receiveAmountStr) ?? Decimal.zero;
    final priceAmountParsed = Decimal.tryParse(priceAmountStr) ?? Decimal.zero;

    final isDeliverLiquid = ref.read(isDeliverLiquidProvider);
    final isStablecoinMarket = ref.read(isStablecoinMarketProvider);
    if (isStablecoinMarket == isDeliverLiquid) {
      if (priceAmountParsed != Decimal.zero) {
        amountParsed = (receiveAmountParsed / priceAmountParsed).toDecimal();
      }
    } else {
      amountParsed = receiveAmountParsed * priceAmountParsed;
    }

    if (amountParsed == Decimal.zero) {
      return '';
    }

    final precision = ref.read(deliverAssetPrecisionProvider);

    return amountParsed.toStringAsFixed(precision);
  }

  void modifyOrderPrice(
    String orderId, {
    bool isToken = false,
    String? price,
    double? indexPrice,
  }) {
    if (price == null) {
      if (indexPrice == null) {
        return;
      }

      ref
          .read(walletProvider)
          .modifyOrderPrice(orderId, indexPrice: indexPrice);
      return;
    }

    var newPrice = double.tryParse(price) ?? 0;
    if (newPrice <= 0) {
      return;
    }

    ref.read(walletProvider).modifyOrderPrice(orderId, price: newPrice);
  }
}

@riverpod
String addressToShareByOrderId(AddressToShareByOrderIdRef ref, String orderId) {
  return 'https://app.sideswap.io/submit/?order_id=$orderId';
}

@Riverpod(keepAlive: true)
class CurrentRequestOrderView extends _$CurrentRequestOrderView {
  @override
  RequestOrder? build() {
    return null;
  }

  void setCurrentRequestOrderView(RequestOrder? requestOrder) {
    state = requestOrder;
  }
}

@riverpod
String requestOrderIndexPrice(RequestOrderIndexPriceRef ref) {
  final deliverAccountAsset =
      ref.watch(deliverOrderEntryAccountAssetProvider).accountAsset;
  final receiveAccountAsset =
      ref.watch(receiveOrderEntryAccountAssetProvider).accountAsset;

  final sendLiquid =
      deliverAccountAsset.assetId == ref.watch(liquidAssetIdStateProvider);
  final accountAsset = !sendLiquid ? deliverAccountAsset : receiveAccountAsset;

  var priceBroadcast =
      ref.watch(indexPriceForAssetProvider(accountAsset.assetId)).indexPrice;

  if (priceBroadcast == 0) {
    // Let's display now only average value
    final assetPrice =
        ref.watch(walletAssetPricesNotifierProvider)[accountAsset.assetId];
    final ask = assetPrice?.ask ?? .0;
    final bid = assetPrice?.bid ?? .0;
    priceBroadcast = (ask + bid) / 2;
  }

  if (priceBroadcast == 0) {
    return '';
  }

  return priceBroadcast.toStringAsFixed(2);
}

@riverpod
class OrderPriceFieldSliderValue extends _$OrderPriceFieldSliderValue {
  @override
  double build() {
    // cleanup slider value when tracking is selected or deselected
    ref.listen(trackingSelectedProvider, (_, __) {
      state = 0;
    });
    return 0;
  }

  void setValue(double value) {
    state = value;
  }
}

@riverpod
String deliverDefaultCurrencyConversion(
    DeliverDefaultCurrencyConversionRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
  if (orderEntryProductPair.deliver.accountAsset.assetId == tetherAssetId) {
    return '';
  }

  final deliverAmount = ref.watch(orderEntryDeliverAmountProvider);
  final deliverConversion = ref.watch(
      defaultCurrencyConversionFromStringProvider(
          orderEntryProductPair.deliver.accountAsset.assetId,
          deliverAmount.toDisplay()));

  return deliverConversion;
}

@riverpod
String receiveDefaultCurrencyConversion(
    ReceiveDefaultCurrencyConversionRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
  if (orderEntryProductPair.receive.accountAsset.assetId == tetherAssetId) {
    return '';
  }

  final receiveAmount = ref.watch(orderEntryReceiveAmountProvider);
  final receiveConversion = ref.watch(
      defaultCurrencyConversionFromStringProvider(
          orderEntryProductPair.receive.accountAsset.assetId,
          receiveAmount.toDisplay()));

  return receiveConversion;
}

@riverpod
String priceDefaultCurrencyConversion(PriceDefaultCurrencyConversionRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final selectedAsset =
      ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final indexPrice = ref
      .read(indexPriceForAssetProvider(selectedAccountAsset.assetId))
      .indexPrice;
  final lastPrice =
      ref.read(lastIndexPriceForAssetProvider(selectedAccountAsset.assetId));
  final isPricedInLiquid =
      ref.read(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
  final indexPriceStr = priceStr(indexPrice, isPricedInLiquid);
  final lastPriceStr = priceStr(lastPrice, isPricedInLiquid);
  final targetIndexPriceStr = indexPrice != 0 ? indexPriceStr : lastPriceStr;
  final indexPriceDefaultCurrencyConversion = ref.watch(
      defaultCurrencyConversionFromStringProvider(
          selectedAccountAsset.assetId, targetIndexPriceStr));

  if (selectedAccountAsset.assetId == ref.watch(tetherAssetIdStateProvider)) {
    return '';
  }

  return indexPriceDefaultCurrencyConversion;
}

class OrderEntryAmount {
  final String _amount;
  final int precision;

  OrderEntryAmount({
    String amount = '',
    required this.precision,
  }) : _amount = amount;

  double toDouble() {
    return double.tryParse(toDecimal().toStringAsFixed(precision)) ?? 0;
  }

  Decimal toDecimal() {
    final amountDecimal = Decimal.tryParse(_amount) ?? Decimal.zero;
    return amountDecimal
        .toRational()
        .toDecimal(scaleOnInfinitePrecision: precision);
  }

  String toDisplay() {
    return _amount;
  }

  (String, int) _equality() => (_amount, precision);

  @override
  bool operator ==(covariant OrderEntryAmount other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
class OrderEntryDeliverAmount extends _$OrderEntryDeliverAmount {
  @override
  OrderEntryAmount build() {
    final deliverPrecision = ref.watch(deliverAssetPrecisionProvider);
    return OrderEntryAmount(precision: deliverPrecision);
  }

  void setDeliverAmount(String amount) {
    final deliverPrecision = ref.read(deliverAssetPrecisionProvider);
    state = OrderEntryAmount(amount: amount, precision: deliverPrecision);
  }
}

@riverpod
class OrderEntryReceiveAmount extends _$OrderEntryReceiveAmount {
  @override
  OrderEntryAmount build() {
    final priceAmount = ref.watch(priceAmountProvider);
    final deliverAmount = ref.watch(orderEntryDeliverAmountProvider);
    final receivePrecision = ref.watch(receiveAssetPrecisionProvider);

    final isSellOrder = ref.watch(isSellOrderProvider);
    final selectedAssetIsToken = ref.watch(selectedAssetIsTokenProvider);

    if (isSellOrder || selectedAssetIsToken) {
      final newAmount = (deliverAmount.toDecimal() * priceAmount.toDecimal())
          .toStringAsFixed(receivePrecision);
      return OrderEntryAmount(amount: newAmount, precision: receivePrecision);
    }

    if (priceAmount.toDecimal() != Decimal.zero) {
      final newAmount = (deliverAmount.toDecimal() / priceAmount.toDecimal())
          .toDecimal(scaleOnInfinitePrecision: receivePrecision)
          .toStringAsFixed(receivePrecision);
      return OrderEntryAmount(amount: newAmount, precision: receivePrecision);
    }

    return OrderEntryAmount(precision: receivePrecision);
  }

  void setReceiveAmount(String amount) {
    final receivePrecision = ref.read(receiveAssetPrecisionProvider);
    state = OrderEntryAmount(amount: amount, precision: receivePrecision);
  }
}

@riverpod
bool isSellOrder(IsSellOrderRef ref) {
  final orderEntryProductPair = ref.watch(orderEntryProductProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  return orderEntryProductPair.deliver.accountAsset.assetId == liquidAssetId;
}

@riverpod
bool isTracking(IsTrackingRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final indexPrice =
      ref.watch(indexPriceForAssetProvider(selectedAccountAsset.assetId));
  final selectedAssetIsToken = ref.watch(selectedAssetIsTokenProvider);
  final trackingSelected = ref.watch(trackingSelectedProvider);
  return trackingSelected &&
      !selectedAssetIsToken &&
      indexPrice.getIndexPriceStr().isNotEmpty;
}

@riverpod
bool canToggleTracking(CanToggleTrackingRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final indexPrice =
      ref.watch(indexPriceForAssetProvider(selectedAccountAsset.assetId));
  final selectedAssetIsToken = ref.watch(selectedAssetIsTokenProvider);
  if (selectedAssetIsToken || indexPrice.getIndexPriceStr().isEmpty) {
    return false;
  }

  return true;
}

@riverpod
class TrackingSelected extends _$TrackingSelected {
  @override
  bool build() {
    return false;
  }

  void setValue(bool value) {
    state = value;
  }
}

@riverpod
class PriceAmount extends _$PriceAmount {
  @override
  OrderEntryAmount build() {
    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);
    final selectedAsset =
        ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
    final precision = selectedAsset?.precision ?? 0;

    ref.listen(trackingPriceFixedProvider, (_, next) {
      calculateTracking();
    });

    ref.listen(trackingSelectedProvider, (_, __) {
      calculateTracking();
    });

    return OrderEntryAmount(precision: precision);
  }

  void setPrice(String value) {
    final selectedAccountAsset =
        ref.read(marketSelectedAccountAssetStateProvider);
    final selectedAsset =
        ref.read(assetsStateProvider)[selectedAccountAsset.assetId];
    final precision = selectedAsset?.precision ?? 0;
    state = OrderEntryAmount(amount: value, precision: precision);
  }

  void calculateTracking() {
    final selectedAccountAsset =
        ref.read(marketSelectedAccountAssetStateProvider);
    final selectedAsset =
        ref.read(assetsStateProvider)[selectedAccountAsset.assetId];
    final precision = selectedAsset?.precision ?? 0;
    final trackingSelected = ref.read(trackingSelectedProvider);
    final trackingPriceFixed = ref.read(trackingPriceFixedProvider);
    if (!trackingSelected) {
      return;
    }

    if ((double.tryParse(trackingPriceFixed) ?? 0) != 0) {
      state =
          OrderEntryAmount(amount: trackingPriceFixed, precision: precision);
    }
  }
}

@riverpod
String trackingPriceFixed(TrackingPriceFixedRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final indexPrice =
      ref.watch(indexPriceForAssetProvider(selectedAccountAsset.assetId));
  final sliderValue = ref.watch(orderPriceFieldSliderValueProvider);
  return indexPrice.calculateTrackingPrice(sliderValue);
}

@riverpod
class OrderReviewTtlChangedFlag extends _$OrderReviewTtlChangedFlag {
  @override
  bool build() {
    return false;
  }

  // one time change
  void setTtlChanged() {
    state = true;
  }
}

@riverpod
class OrderReviewTtl extends _$OrderReviewTtl {
  @override
  int build() {
    return kInfTtl;
  }

  void setTtl(int ttl) {
    state = ttl;
  }
}

@riverpod
class OrderReviewPublic extends _$OrderReviewPublic {
  @override
  bool build() {
    return true;
  }

  void setPublic(bool value) {
    state = value;
  }
}

@riverpod
class OrderReviewTwoStep extends _$OrderReviewTwoStep {
  @override
  bool build() {
    return true;
  }

  void setTwoStep(bool value) {
    state = value;
  }
}
