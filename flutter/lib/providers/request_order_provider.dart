import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

extension DurationExtensions on Duration? {
  String toStringCustom() {
    final duration = this;
    if (duration == null || duration.inSeconds == 0) {
      return unlimitedTtl;
    }

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    }
    return '${duration.inSeconds}s';
  }

  String toStringCustomShort() {
    final duration = this;
    if (duration == null || duration.inSeconds == 0) {
      return unlimitedTtl;
    }

    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }
}

final requestOrderProvider = ChangeNotifierProvider<RequestOrderProvider>(
    (ref) => RequestOrderProvider(ref));

class RequestOrderProvider extends ChangeNotifier {
  final Ref ref;

  RequestOrderProvider(this.ref) {
    _deliverAssetId =
        AccountAsset(AccountType.reg, ref.read(liquidAssetIdProvider));
  }

  bool isSellOrder() {
    // Receive AMP order is always a buy, all else is always a sell
    return receiveAssetId.account != AccountType.amp;
  }

  bool isDeliverToken() {
    final assetId = isDeliverLiquid() ? receiveAssetId : deliverAssetId;
    return ref.read(assetUtilsProvider).isAssetToken(assetId: assetId.asset);
  }

  bool isDeliverLiquid() {
    return deliverAssetId.asset == ref.read(liquidAssetIdProvider);
  }

  AccountAsset tokenAccountAsset() {
    return isDeliverLiquid() ? receiveAssetId : deliverAssetId;
  }

  late AccountAsset _deliverAssetId;
  AccountAsset get deliverAssetId {
    return _deliverAssetId;
  }

  set deliverAssetId(AccountAsset value) {
    _deliverAssetId = value;
    _receiveAssetId = receiveAssets().first;
    notifyListeners();
    // updateIndexPrice();
  }

  void validateDeliverAsset() {
    final allDeliverAccounts = deliverAssets();
    // This would deselect currently selected asset if it goes to 0
    final validDeliver = allDeliverAccounts.contains(deliverAssetId);
    if (!validDeliver) {
      deliverAssetId = allDeliverAccounts.first;
    }
  }

  Asset? deliverAsset() {
    return ref.read(assetsStateProvider)[_deliverAssetId.asset];
  }

  int deliverPrecision() {
    return deliverAsset()?.precision ?? 0;
  }

  String deliverTicker() {
    return ref.read(assetUtilsProvider).tickerForAssetId(_deliverAssetId.asset);
  }

  List<AccountAsset> deliverAssets() {
    final liquid = ref.read(liquidAssetIdProvider);
    final assets = ref
        .read(balancesProvider)
        .balances
        .entries
        .where((item) =>
            item.value > 0 ||
            (item.key.asset == liquid && item.key.account == AccountType.reg))
        .map((item) => item.key)
        .toList();
    assets.sort();
    return assets;
  }

  List<AccountAsset> disabledAssets() {
    final ampAssets = ref.read(ampAssetsStateProvider);
    final allAssets = ref.read(assetsStateProvider);
    final asset = deliverAssets().where((item) {
      final asset = allAssets[item.asset]!;
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
    return asset;
  }

  String deliverBalance() {
    final balance = realDeliverBalance();
    final precision = deliverPrecision();

    return ref.read(amountToStringProvider).amountToString(
        AmountToStringParameters(amount: balance, precision: precision));
  }

  int realDeliverBalance() {
    return ref.read(balancesProvider).balances[_deliverAssetId] ?? 0;
  }

  AccountAsset? _receiveAssetId;
  AccountAsset get receiveAssetId {
    return _receiveAssetId ??= receiveAssets().first;
  }

  set receiveAssetId(AccountAsset value) {
    _receiveAssetId = value;
    notifyListeners();
  }

  Asset? receiveAsset() {
    return ref.read(assetsStateProvider)[receiveAssetId.asset];
  }

  int receivePrecision() {
    return receiveAsset()?.precision ?? 0;
  }

  String receiveTicker() {
    return ref.read(assetUtilsProvider).tickerForAssetId(receiveAssetId.asset);
  }

  List<AccountAsset> receiveAssets() {
    if (deliverTicker() == kLiquidBitcoinTicker) {
      final assets = ref.read(assetsStateProvider);
      return assets.values
          .where((e) =>
              (e.swapMarket || e.ampMarket) && e.ticker != kLiquidBitcoinTicker)
          .map((e) => AccountAsset(
              e.ampMarket ? AccountType.amp : AccountType.reg, e.assetId))
          .toList();
    }

    final liquid = ref.read(liquidAssetIdProvider);
    return [AccountAsset(AccountType.reg, liquid)];
  }

  String dollarConversion(String? assetId, num amount) {
    final amountUsd = ref.read(walletProvider).getAmountUsd(assetId, amount);

    if (amountUsd == 0) {
      return '';
    }

    var dollarConversion = '0.0';
    dollarConversion = amountUsd.toStringAsFixed(2);
    dollarConversion = replaceCharacterOnPosition(
        input: dollarConversion,
        currencyChar: 'USD',
        currencyCharAlignment: CurrencyCharAlignment.end);

    return dollarConversion;
  }

  String dollarConversionFromString(String? assetId, String amount) {
    if (amount.isEmpty) {
      return '';
    }

    final amountParsed = double.tryParse(amount) ?? 0;
    if (amountParsed == 0) {
      return '';
    }

    return dollarConversion(assetId, amountParsed);
  }

  String receiveBalance() {
    final balance = ref.read(balancesProvider).balances[receiveAssetId];
    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: receiveAssetId.asset);
    return ref.read(amountToStringProvider).amountToString(
        AmountToStringParameters(amount: balance ?? 0, precision: precision));
  }

  Asset? _priceAsset;

  bool isStablecoinMarket() {
    return marketType() == MarketType.stablecoin;
  }

  MarketType marketType() {
    final tokenAssetId = tokenAccountAsset().asset;
    final tokenAsset = ref.read(assetsStateProvider)[tokenAssetId];
    if (tokenAsset?.swapMarket == true) {
      return MarketType.stablecoin;
    }
    if (tokenAsset?.ampMarket == true) {
      return MarketType.amp;
    }
    return MarketType.token;
  }

  Asset? get priceAsset {
    final newPriceAsset = getPriceAsset();
    if (_priceAsset == newPriceAsset) {
      return newPriceAsset;
    }

    _priceAsset = newPriceAsset;

    ref.read(marketsProvider).subscribeIndexPrice(tokenAccountAsset().asset);

    return newPriceAsset;
  }

  Asset? getPriceAsset() {
    final assetId = tokenAccountAsset().asset;
    final asset = ref.read(assetsStateProvider)[assetId];
    if (asset?.swapMarket == true) {
      return asset!;
    }

    return ref.read(assetUtilsProvider).liquidAsset();
  }

  String calculateReceiveAmount(String deliverAmount, String priceAmount) {
    final deliverAmountStr = deliverAmount.replaceAll(' ', '');
    final priceAmountStr = priceAmount.replaceAll(' ', '');
    var amountParsed = Decimal.zero;

    final deliverAmountParsed =
        Decimal.tryParse(deliverAmountStr) ?? Decimal.zero;
    final priceAmountParsed = Decimal.tryParse(priceAmountStr) ?? Decimal.zero;

    // FIXME: Include server fee here
    if (isStablecoinMarket() == isDeliverLiquid()) {
      amountParsed = deliverAmountParsed * priceAmountParsed;
    } else {
      if (priceAmountParsed != Decimal.zero) {
        amountParsed = deliverAmountParsed / priceAmountParsed;
      }
    }

    if (amountParsed == Decimal.zero) {
      return '';
    }

    final precision = receiveAsset()!.precision;
    return amountParsed.toStringAsFixed(precision);
  }

  String calculateDeliverAmount(String receiveAmount, String priceAmount) {
    final receiveAmountStr = receiveAmount.replaceAll(' ', '');
    final priceAmountStr = priceAmount.replaceAll(' ', '');
    var amountParsed = Decimal.zero;

    final receiveAmountParsed =
        Decimal.tryParse(receiveAmountStr) ?? Decimal.zero;
    final priceAmountParsed = Decimal.tryParse(priceAmountStr) ?? Decimal.zero;

    if (isStablecoinMarket() == isDeliverLiquid()) {
      if (priceAmountParsed != Decimal.zero) {
        amountParsed = receiveAmountParsed / priceAmountParsed;
      }
    } else {
      amountParsed = receiveAmountParsed * priceAmountParsed;
    }

    if (amountParsed == Decimal.zero) {
      return '';
    }

    final precision = deliverAsset()?.precision ?? 0;

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

  String getAddressToShare(OrderDetailsData orderDetailsData) {
    return getAddressToShareById(orderDetailsData.orderId);
  }

  String getAddressToShareById(String orderId) {
    final shareAddress = 'https://app.sideswap.io/submit/?order_id=$orderId';

    return shareAddress;
  }
}

final currentRequestOrderViewProvider =
    AutoDisposeStateProvider<RequestOrder?>((ref) {
  ref.keepAlive();
  return null;
});

final requestOrderIndexPriceProvider = AutoDisposeProvider<String>((ref) {
  final deliverAccountAsset =
      ref.watch(requestOrderProvider.select((value) => value.deliverAssetId));
  final receiveAccountAsset =
      ref.watch(requestOrderProvider.select((value) => value.receiveAssetId));

  final sendLiquid =
      deliverAccountAsset.asset == ref.watch(liquidAssetIdProvider);
  final accountAsset = !sendLiquid ? deliverAccountAsset : receiveAccountAsset;

  var priceBroadcast =
      ref.watch(indexPriceForAssetProvider(accountAsset.asset)).indexPrice;

  if (priceBroadcast == 0) {
    // Let's display now only average value
    final assetPrice = ref.watch(walletAssetPrices)[accountAsset.asset];
    final ask = assetPrice?.ask ?? .0;
    final bid = assetPrice?.bid ?? .0;
    priceBroadcast = (ask + bid) / 2;
  }

  if (priceBroadcast == 0) {
    return '';
  }

  return priceBroadcast.toStringAsFixed(2);
});
