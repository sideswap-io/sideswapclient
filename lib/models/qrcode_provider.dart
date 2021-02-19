import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/wallet.dart';

final qrcodeProvider = ChangeNotifierProvider<QrCodeNotifierProvider>(
    (ref) => QrCodeNotifierProvider(ref.read));

enum QrCodeResultType {
  merchant,
  client,
}

class QrCodeResult {
  String address;
  QrCodeResultType type;
  double amount;
  String asset;
  String message;
  String label;
  int bitMask;
  bool error;
  String errorMessage;

  QrCodeResult({
    this.address,
    this.amount,
    this.asset,
    this.message,
    this.label,
    this.bitMask,
    this.error,
    this.errorMessage,
  });

  QrCodeResult copyWith({
    String address,
    double amount,
    String asset,
    String message,
    String label,
    int bitMask,
    bool error,
    String errorMessage,
  }) {
    return QrCodeResult(
      address: address ?? this.address,
      amount: amount ?? this.amount,
      asset: asset ?? this.asset,
      message: message ?? this.message,
      label: label ?? this.label,
      bitMask: bitMask ?? this.bitMask,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'QrCodeResult(address: $address, amount: $amount, asset: $asset, message: $message, label: $label, bitMask: $bitMask, error: $error, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is QrCodeResult &&
        o.address == address &&
        o.amount == amount &&
        o.asset == asset &&
        o.message == message &&
        o.label == label &&
        o.bitMask == bitMask &&
        o.error == error &&
        o.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        amount.hashCode ^
        asset.hashCode ^
        message.hashCode ^
        label.hashCode ^
        bitMask.hashCode ^
        error.hashCode ^
        errorMessage.hashCode;
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
  final Reader read;
  QrCodeResult _result;

  QrCodeNotifierProvider(this.read);

  QrCodeResult parseDynamicQrCode(String qrCode) {
    if (qrCode == null) {
      return _emitError('Empty qr code'.tr());
    }

    _result = QrCodeResult();

    // check is it static qr code
    final wallet = read(walletProvider);
    if (wallet.isAddrValid(qrCode, AddrType.bitcoin) ||
        wallet.isAddrValid(qrCode, AddrType.elements)) {
      _result.address = qrCode;
      notifyListeners();
      return _result;
    }

    final url = Uri.parse(qrCode ?? '');

    if (url.scheme == 'bitcoin') {
      return parseBitcoinAddress(qrCode);
    }

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
    if (_result.address.isEmpty) {
      logger.w('Empty qr code address');
      return _emitError('Invalid QR code'.tr());
    }

    String data;

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
      _result.asset = dataList[2].isNotEmpty ? dataList[2] : null;
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

  QrCodeResult parseBitcoinAddress(String qrCode) {
    final btcUrl = Uri.parse(qrCode);
    final btcParams = btcUrl.queryParameters;

    if (btcParams.containsKey('amount')) {
      _result.amount = double.tryParse(btcParams['amount']);
    }

    if (btcParams.containsKey('label')) {
      _result.label = btcParams['label'];
    }

    if (btcParams.containsKey('message')) {
      _result.message = btcParams['message'];
    }

    _result.address = btcUrl.path;

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
    @required String address,
    QrCodeResultType type = QrCodeResultType.client,
    double amount,
    String asset,
    String message,
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
