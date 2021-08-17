import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

final requestOrderProvider = ChangeNotifierProvider<RequestOrderProvider>(
    (ref) => RequestOrderProvider(ref.read));

extension DurationExtensions on Duration {
  String toHoursMinutes() {
    if (inMinutes.remainder(60) > 0) {
      return '${inHours.remainder(24)}h ${inMinutes.remainder(60)}m';
    }

    return '${inHours}h';
  }

  String toMinutes() {
    if (inMinutes.remainder(60) > 0) {
      return '$inMinutes min';
    }

    return toSeconds();
  }

  String toSeconds() {
    return '$inSeconds sec';
  }
}

class RequestOrderProvider extends ChangeNotifier {
  final Reader read;

  RequestOrderProvider(this.read) {
    final assets = deliverAssets();
    if (_deliverAssetId.isEmpty) {
      if (assets.isNotEmpty) {
        _deliverAssetId = assets.first;
      } else {
        _deliverAssetId = read(walletProvider).liquidAssetId() ?? '';
      }
    }
  }

  RequestOrder? currentRequestOrderView;

  final _externalOrders = <String>[];
  String indexPrice = '';

  /// Insert order id or session id to distinguis between external or in app
  /// created swap orders
  void insertExternalOrder(String id) {
    _externalOrders.add(id);
  }

  bool isOrderExternal(String id) {
    return _externalOrders.any((element) => element == id);
  }

  bool isAssetToken(String? assetId) {
    if (assetId == null) {
      return true;
    }

    return !read(walletProvider).assets[assetId]!.swapMarket;
  }

  bool isZeroPrecision(String? assetId) {
    final precision =
        read(walletProvider).getPrecisionForAssetId(assetId: assetId);

    return precision == 0;
  }

  bool isPricedInLiquid(String? assetId) {
    if ((assetId == read(walletProvider).tetherAssetId() ||
        assetId == read(walletProvider).eurxAssetId())) {
      return false;
    } else if ((isAssetToken(assetId) && isZeroPrecision(assetId)) ||
        assetId == read(walletProvider).liquidAssetId()) {
      return true;
    }

    return false;
  }

  bool isDeliverToken() {
    final assetId = isDeliverLiquid()
        ? read(requestOrderProvider).receiveAssetId
        : read(requestOrderProvider).deliverAssetId;
    return read(requestOrderProvider).isAssetToken(assetId);
  }

  bool isDeliverLiquid() {
    return read(requestOrderProvider).deliverAssetId ==
        read(walletProvider).liquidAssetId();
  }

  String tokenAssetId() {
    return isDeliverLiquid()
        ? read(requestOrderProvider).receiveAssetId
        : read(requestOrderProvider).deliverAssetId;
  }

  List<String> liquidAssets() {
    return read(walletProvider)
        .assets
        .keys
        .where((element) => element != read(walletProvider).bitcoinAssetId())
        .toList();
  }

  String _deliverAssetId = '';

  String get deliverAssetId {
    if (realDeliverBalance() == 0 &&
        _deliverAssetId != read(walletProvider).liquidAssetId()) {
      _deliverAssetId =
          deliverAssets().firstWhere((element) => element != receiveAssetId);
    }

    return _deliverAssetId;
  }

  set deliverAssetId(String value) {
    _deliverAssetId = value;
    _receiveAssetId = receiveAssets().first;
    notifyListeners();
    updateIndexPrice();
  }

  Asset? deliverAsset() {
    return read(walletProvider)
        .assets
        .values
        .firstWhere((element) => element.assetId == _deliverAssetId);
  }

  int deliverPrecision() {
    return deliverAsset()?.precision ?? 0;
  }

  String deliverTicker() {
    return read(walletProvider).assets[_deliverAssetId]?.ticker ?? '';
  }

  List<String> deliverAssets() {
    final assets = liquidAssets();
    assets.removeWhere((element) {
      if (element == read(walletProvider).liquidAssetId()) {
        return false;
      }

      if (read(balancesProvider).balances[element] == 0) {
        return true;
      }

      return false;
    });

    return assets;
  }

  String deliverBalance() {
    final balance = realDeliverBalance();
    final precision = deliverPrecision();

    return amountStr(balance, precision: precision);
  }

  int realDeliverBalance() {
    return read(balancesProvider).balances[_deliverAssetId] ?? 0;
  }

  String? _receiveAssetId;
  String get receiveAssetId {
    return _receiveAssetId ??= receiveAssets().first;
  }

  set receiveAssetId(String value) {
    _receiveAssetId = value;
    notifyListeners();
  }

  Asset? receiveAsset() {
    return read(walletProvider)
        .assets
        .values
        .firstWhere((element) => element.assetId == receiveAssetId);
  }

  int receivePrecision() {
    return receiveAsset()?.precision ?? 0;
  }

  String receiveTicker() {
    return read(walletProvider).assets[receiveAssetId]?.ticker ?? '';
  }

  List<String> receiveAssets() {
    if (deliverTicker() == kLiquidBitcoinTicker) {
      return [
        read(walletProvider)
            .assets
            .values
            .firstWhere((element) => element.ticker == kTetherTicker)
            .assetId,
        read(walletProvider)
            .assets
            .values
            .firstWhere((element) => element.ticker == kEurxTicker)
            .assetId
      ];
    } else {
      return [
        read(walletProvider)
            .assets
            .values
            .firstWhere((element) => element.ticker == kLiquidBitcoinTicker)
            .assetId,
      ];
    }
  }

  String dollarConversion(String assetId, num amount) {
    final amountUsd = read(walletProvider).getAmountUsd(assetId, amount);

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
    final balance = read(balancesProvider).balances[receiveAssetId];
    final precision =
        read(walletProvider).getPrecisionForAssetId(assetId: receiveAssetId);
    return amountStr(balance ?? 0, precision: precision);
  }

  Asset? _priceAsset;

  Asset get priceAsset {
    final newPriceAsset = getPriceAsset();
    if (_priceAsset == newPriceAsset) {
      return newPriceAsset;
    }

    _priceAsset = newPriceAsset;

    read(marketsProvider).unsubscribeIndexPrice();
    read(marketsProvider).subscribeIndexPrice(assetId: newPriceAsset.assetId);

    return newPriceAsset;
  }

  Asset getPriceAsset({String? baseAssetId}) {
    baseAssetId ??= deliverAssetId;

    var assetId = baseAssetId;
    if (isPricedInLiquid(assetId)) {
      assetId = receiveAssetId;
    } else {
      assetId = baseAssetId;
    }

    return read(walletProvider)
        .assets
        .values
        .firstWhere((element) => element.assetId == assetId);
  }

  Image? priceAssetIcon() {
    return read(walletProvider).assetImagesSmall[priceAsset.assetId];
  }

  void updateIndexPrice() {
    final sendLiquid = deliverAssetId == read(walletProvider).liquidAssetId();
    final assetId = !sendLiquid ? deliverAssetId : receiveAssetId;

    var priceBroadcast = read(marketsProvider).getIndexPriceForAsset(assetId);

    if (priceBroadcast == 0) {
      // Let's display now only average value
      final assetPrice = read(walletProvider).prices[assetId];
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

    if (isPricedInLiquid(deliverAssetId)) {
      amountParsed = deliverAmountParsed * priceAmountParsed;
    } else {
      if (priceAmountParsed != Decimal.zero) {
        amountParsed = deliverAmountParsed / priceAmountParsed;
      }
    }

    if (amountParsed == Decimal.zero) {
      return '';
    }

    final precision = receiveAsset()?.precision ?? 0;

    return amountParsed.toStringAsFixed(precision);
  }

  void swapAssets() {
    if (deliverAssets()
        .firstWhere(
          (element) => element == receiveAssetId,
          orElse: () => '',
        )
        .isEmpty) {
      return;
    }

    final oldDeliverAsset = deliverAssetId;
    deliverAssetId = receiveAssetId;
    if (tickerForAssetId(oldDeliverAsset) == kTetherTicker ||
        tickerForAssetId(oldDeliverAsset) == kEurxTicker) {
      receiveAssetId = oldDeliverAsset;
    }
  }

  String tickerForAssetId(String assetId) {
    return read(walletProvider)
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
    bool isPricedInLiquid = false,
  }) {
    if (price == null) {
      if (indexPrice == null) {
        return;
      }

      read(walletProvider).modifyOrderPrice(orderId, indexPrice: indexPrice);
      return;
    }

    var newPrice = double.tryParse(price) ?? 0;
    if (newPrice <= 0) {
      return;
    }

    if (isPricedInLiquid) {
      newPrice = (1 / newPrice);
    }

    read(walletProvider).modifyOrderPrice(orderId, price: newPrice);
  }

  String getAddressToShare(OrderDetailsData orderDetailsData) {
    final shareAddress =
        'https://app.sideswap.io/submit/?order_id=${orderDetailsData.orderId}';

    return shareAddress;
  }
}
