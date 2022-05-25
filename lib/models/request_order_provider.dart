import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

final requestOrderProvider = ChangeNotifierProvider<RequestOrderProvider>(
    (ref) => RequestOrderProvider(ref));

extension DurationExtensions on Duration {
  String toStringCustom() {
    if (inDays > 0) {
      return '${inDays}d ${inHours.remainder(24)}h';
    }
    if (inHours > 0) {
      return '${inHours}h ${inMinutes.remainder(60)}m';
    }
    if (inMinutes > 0) {
      return '${inMinutes}m ${inSeconds.remainder(60)}s';
    }
    return '${inSeconds}s';
  }

  String toStringCustomShort() {
    if (inDays > 0) {
      return '${inDays}d';
    }
    if (inHours > 0) {
      return '${inHours}h';
    }
    if (inMinutes > 0) {
      return '${inMinutes}m';
    }
    return '${inSeconds}s';
  }
}

class RequestOrderProvider extends ChangeNotifier {
  final Ref ref;

  RequestOrderProvider(this.ref) {
    _deliverAssetId = AccountAsset(
        AccountType.regular, ref.read(walletProvider).liquidAssetId());
  }

  RequestOrder? currentRequestOrderView;

  String indexPrice = '';

  bool isAssetToken(String? assetId) {
    if (assetId == null) {
      return true;
    }

    return !ref.read(walletProvider).assets[assetId]!.swapMarket;
  }

  bool isZeroPrecision(String? assetId) {
    final precision =
        ref.read(walletProvider).getPrecisionForAssetId(assetId: assetId);

    return precision == 0;
  }

  bool isSellOrder() {
    // Receive AMP order is always a buy, all else is always a sell
    return receiveAssetId.account != AccountType.amp;
  }

  bool isDeliverToken() {
    final assetId = isDeliverLiquid() ? receiveAssetId : deliverAssetId;
    return isAssetToken(assetId.asset);
  }

  bool isDeliverLiquid() {
    return deliverAssetId.asset == ref.read(walletProvider).liquidAssetId();
  }

  AccountAsset tokenAccountAsset() {
    return isDeliverLiquid() ? receiveAssetId : deliverAssetId;
  }

  List<String> liquidAssets() {
    return ref
        .read(walletProvider)
        .assets
        .keys
        .where(
            (element) => element != ref.read(walletProvider).bitcoinAssetId())
        .toList();
  }

  late AccountAsset _deliverAssetId;
  AccountAsset get deliverAssetId {
    return _deliverAssetId;
  }

  set deliverAssetId(AccountAsset value) {
    _deliverAssetId = value;
    _receiveAssetId = receiveAssets().first;
    notifyListeners();
    updateIndexPrice();
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
    return ref
        .read(walletProvider)
        .assets
        .values
        .firstWhere((element) => element.assetId == _deliverAssetId.asset);
  }

  int deliverPrecision() {
    return deliverAsset()?.precision ?? 0;
  }

  String deliverTicker() {
    return ref.read(walletProvider).assets[_deliverAssetId.asset]?.ticker ?? '';
  }

  List<AccountAsset> deliverAssets() {
    final liquid = ref.read(walletProvider).liquidAssetId();
    final assets = ref
        .read(balancesProvider)
        .balances
        .entries
        .where((item) =>
            item.value > 0 ||
            (item.key.asset == liquid &&
                item.key.account == AccountType.regular))
        .map((item) => item.key)
        .toList();
    assets.sort();
    return assets;
  }

  List<AccountAsset> disabledAssets() {
    final wallet = ref.read(walletProvider);
    final ampAssets = wallet.ampAssets;
    final allAssets = wallet.assets;
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

    return amountStr(balance, precision: precision);
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
    return ref
        .read(walletProvider)
        .assets
        .values
        .firstWhere((element) => element.assetId == receiveAssetId.asset);
  }

  int receivePrecision() {
    return receiveAsset()?.precision ?? 0;
  }

  String receiveTicker() {
    return ref.read(walletProvider).assets[receiveAssetId]?.ticker ?? '';
  }

  List<AccountAsset> receiveAssets() {
    if (deliverTicker() == kLiquidBitcoinTicker) {
      return ref
          .read(walletProvider)
          .assets
          .values
          .where((e) =>
              (e.swapMarket || e.ampMarket) && e.ticker != kLiquidBitcoinTicker)
          .map((e) => AccountAsset(
              e.ampMarket ? AccountType.amp : AccountType.regular, e.assetId))
          .toList();
    }

    final liquid = ref.read(walletProvider).liquidAssetId();
    return [AccountAsset(AccountType.regular, liquid)];
  }

  String dollarConversion(String assetId, num amount) {
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

  String dollarConversionFromString(String assetId, String amount) {
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
        .read(walletProvider)
        .getPrecisionForAssetId(assetId: receiveAssetId.asset);
    return amountStr(balance ?? 0, precision: precision);
  }

  Asset? _priceAsset;

  bool isStablecoinMarket() {
    final tokenAssetId = tokenAccountAsset().asset;
    final tokenAsset = ref.read(walletProvider).assets[tokenAssetId]!;
    return tokenAsset.swapMarket;
  }

  Asset get priceAsset {
    final newPriceAsset = getPriceAsset();
    if (_priceAsset == newPriceAsset) {
      return newPriceAsset;
    }

    _priceAsset = newPriceAsset;

    ref.read(marketsProvider).subscribeIndexPrice(tokenAccountAsset().asset);

    return newPriceAsset;
  }

  Asset getPriceAsset() {
    final assetId = tokenAccountAsset().asset;
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[assetId]!;
    if (asset.swapMarket) {
      return asset;
    }
    return wallet.assets[wallet.liquidAssetId()]!;
  }

  Image? priceAssetIcon() {
    return ref.read(walletProvider).assetImagesSmall[priceAsset.assetId];
  }

  void updateIndexPrice() {
    final sendLiquid =
        deliverAssetId.asset == ref.read(walletProvider).liquidAssetId();
    final assetId = !sendLiquid ? deliverAssetId : receiveAssetId;

    var priceBroadcast =
        ref.read(marketsProvider).getIndexPriceForAsset(assetId.asset);

    if (priceBroadcast == 0) {
      // Let's display now only average value
      final assetPrice = ref.read(walletProvider).prices[assetId];
      final ask = assetPrice?.ask ?? .0;
      final bid = assetPrice?.bid ?? .0;
      priceBroadcast = (ask + bid) / 2;
    }

    if (priceBroadcast == 0) {
      indexPrice = '';
      notifyListeners();
      return;
    }

    indexPrice = priceBroadcast.toStringAsFixed(2);
    notifyListeners();
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

  String tickerForAssetId(String assetId) {
    return ref
        .read(walletProvider)
        .assets
        .values
        .firstWhere((element) => element.assetId == assetId)
        .ticker;
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
