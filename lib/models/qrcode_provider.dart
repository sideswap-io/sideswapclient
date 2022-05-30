import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/models/wallet.dart';

final qrcodeResultModelProvider = StateProvider.autoDispose<QrCodeResultModel>(
    (ref) => const QrCodeResultModelEmpty());

final qrcodeProvider = ChangeNotifierProvider<QrCodeNotifierProvider>(
    (ref) => QrCodeNotifierProvider(ref));

enum QrCodeResultType {
  merchant,
  client,
}

enum QrCodeAddressType {
  elements,
  bitcoin,
  liquidnetwork,
  other,
}

class QrCodeResult {
  String? address;
  QrCodeAddressType? addressType;
  QrCodeResultType? type;
  double? amount;
  String? ticker;
  String? message;
  String? label;
  int? bitMask;
  bool? error;
  String? errorMessage;
  String? assetId;

  QrCodeResult({
    this.address,
    this.addressType,
    this.amount,
    this.ticker,
    this.message,
    this.label,
    this.bitMask,
    this.error,
    this.errorMessage,
    this.assetId,
  });

  QrCodeResult copyWith({
    String? address,
    QrCodeAddressType? addressType,
    double? amount,
    String? ticker,
    String? message,
    String? label,
    int? bitMask,
    bool? error,
    String? errorMessage,
    String? orderId,
    String? assetId,
  }) {
    return QrCodeResult(
      address: address ?? this.address,
      addressType: addressType ?? this.addressType,
      amount: amount ?? this.amount,
      ticker: ticker ?? this.ticker,
      message: message ?? this.message,
      label: label ?? this.label,
      bitMask: bitMask ?? this.bitMask,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      assetId: assetId ?? this.assetId,
    );
  }

  @override
  String toString() {
    return 'QrCodeResult(address: $address, addressType: $addressType, amount: $amount, ticker: $ticker, message: $message, label: $label, bitMask: $bitMask, error: $error, errorMessage: $errorMessage, assetId: $assetId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QrCodeResult &&
        other.address == address &&
        other.addressType == addressType &&
        other.amount == amount &&
        other.ticker == ticker &&
        other.message == message &&
        other.label == label &&
        other.bitMask == bitMask &&
        other.error == error &&
        other.errorMessage == errorMessage &&
        other.assetId == assetId;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        addressType.hashCode ^
        amount.hashCode ^
        ticker.hashCode ^
        message.hashCode ^
        label.hashCode ^
        bitMask.hashCode ^
        error.hashCode ^
        errorMessage.hashCode ^
        assetId.hashCode;
  }
}

// scheme:address_or_merchant_token?T=M;100.00;L-BTC;message;0
// T=
// M - as merchant, C - as client;
// amount;
// asset;
// url encoded message - 64 characters? - we need here something small, maybe even 32 characters;
// bit mask;

class QrCodeNotifierProvider extends ChangeNotifier {
  final Ref ref;
  QrCodeResult _result = QrCodeResult();

  QrCodeNotifierProvider(this.ref);

  QrCodeResult parseDynamicQrCode(String qrCode) {
    if (qrCode.isEmpty) {
      return _emitError('Empty qr code'.tr());
    }

    _result = QrCodeResult();

    // check is it static qr code
    final wallet = ref.read(walletProvider);
    if (wallet.isAddrValid(qrCode, AddrType.bitcoin)) {
      _result.address = qrCode;
      _result.addressType = QrCodeAddressType.bitcoin;
      notifyListeners();
      return _result;
    }

    if (wallet.isAddrValid(qrCode, AddrType.elements)) {
      _result.address = qrCode;
      _result.addressType = QrCodeAddressType.elements;
      notifyListeners();
      return _result;
    }

    final url = Uri.parse(qrCode);

    if (url.scheme == 'bitcoin') {
      return parseBIP21(qrCode: qrCode, addressType: QrCodeAddressType.bitcoin);
    }

    if (url.scheme == 'liquidnetwork') {
      return parseBIP21(
          qrCode: qrCode, addressType: QrCodeAddressType.liquidnetwork);
    }

    // TODO: do we really need this?
    // scheme could be anything so any random qr code is valid too
    // check other bip21 schemes
    // if (url.scheme != 'sideswap' && url.scheme != 'https') {
    //   return parseBIP21(qrCode: qrCode, addressType: QrCodeAddressType.other);
    // }

    if (url.scheme == 'sideswap') {
      return parseSideSwapAddress(qrCode);
    }

    _emitError('Invalid QR code'.tr());

    _result.error = true;
    _result.errorMessage = 'Invalid QR code'.tr();
    notifyListeners();

    return _result;
  }

  QrCodeResult parseSideSwapAddress(String qrCode) {
    final url = Uri.parse(qrCode);
    final queryParams = url.queryParameters;

    if (queryParams.isEmpty) {
      logger.w('Invalid qr code');
      return _emitError('Invalid QR code'.tr());
    }

    _result.address = url.path;
    _result.addressType = QrCodeAddressType.other;
    if (_result.address != null && _result.address!.isEmpty) {
      logger.w('Empty qr code address');
      return _emitError('Invalid QR code'.tr());
    }

    String? data;

    if (queryParams.containsKey('T')) {
      data = queryParams['T'];
    }

    if (data == null) {
      logger.w('Wrong qr code');
      return _emitError(''.tr());
    }

    final dataList = data.split(';');

    if (dataList.length < 5) {
      logger.w('Wrong qr code data');
      return _emitError('Invalid QR code'.tr());
    }

    if (dataList[0] == 'M') {
      _result.type = QrCodeResultType.merchant;
    }

    if (dataList[0] == 'C') {
      _result.type = QrCodeResultType.client;
    }

    if (_result.type == null) {
      logger.w('Invalid merchant type');
      return _emitError('Invalid QR code'.tr());
    }

    try {
      _result.amount = double.tryParse(dataList[1]);
      _result.ticker = dataList[2].isNotEmpty ? dataList[2] : null;
      final decodedMessage = utf8.decode(base64Decode(dataList[3])).toString();
      _result.message = decodedMessage.isNotEmpty ? decodedMessage : null;
      _result.bitMask = int.tryParse(dataList[4]);
    } catch (e) {
      logger.e(e);
      logger.w('Wrong qr code data elements');
      return _emitError('Invalid QR code'.tr());
    }

    logger.d(_result);

    return QrCodeResult();
  }

  QrCodeResult parseBIP21({
    required String qrCode,
    required QrCodeAddressType addressType,
  }) {
    final url = Uri.parse(qrCode);
    final params = url.queryParameters;

    if (params.containsKey('amount')) {
      var amount = double.tryParse(params['amount'] ?? '0') ?? 0;
      if (amount < 0) {
        amount = 0;
      }
      _result.amount = amount;
    }

    if (params.containsKey('label')) {
      _result.label = params['label'];
    }

    if (params.containsKey('message')) {
      _result.message = params['message'];
    }

    if (params.containsKey('assetid')) {
      _result.assetId = params['assetid'];
      final asset = ref.read(walletProvider).assets[_result.assetId];
      _result.ticker = asset != null ? asset.ticker : kUnknownTicker;
    }

    _result.address = url.path;
    _result.addressType = addressType;

    logger.d(_result);
    notifyListeners();

    return _result;
  }

  QrCodeResult _emitError(String errorMessage) {
    _result = QrCodeResult();
    _result.error = true;
    _result.errorMessage = errorMessage;
    notifyListeners();
    return _result;
  }

  String createDynamicQrCodeUrl({
    required String address,
    QrCodeResultType type = QrCodeResultType.client,
    double? amount,
    String? asset,
    String? message,
    int bitMask = 0,
  }) {
    final dataList = <String>[];
    dataList
      ..add(type == QrCodeResultType.merchant ? 'M' : 'C')
      ..add(amount != null ? amount.toString() : '')
      ..add(asset ?? '')
      ..add(message != null ? base64Encode(utf8.encode(message)) : '')
      ..add(bitMask.toString());

    final data = dataList.join(';');

    final qrCodeUrl = 'sideswap:$address?T=$data';

    return qrCodeUrl;
  }
}
