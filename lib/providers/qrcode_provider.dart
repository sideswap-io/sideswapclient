import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';

import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/outputs_providers.dart';

part 'qrcode_provider.g.dart';

@riverpod
class QrCodeResultModelNotifier extends _$QrCodeResultModelNotifier {
  @override
  QrCodeResultModel build() {
    return const QrCodeResultModelEmpty();
  }

  void setModel(QrCodeResultModel model) {
    state = model;
  }
}

@riverpod
QrCodeHelper qrcodeHelper(Ref ref) {
  return QrCodeHelper(ref);
}

enum QrCodeResultType { merchant, client }

class QrCodeResult {
  String? address;
  BIP21AddressTypeEnum? addressType;
  QrCodeResultType? type;
  double? amount;
  String? ticker;
  String? message;
  String? label;
  int? bitMask;
  bool? error;
  String? errorMessage;
  String? assetId;
  OutputsData? outputsData;

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
    this.outputsData,
  });

  QrCodeResult copyWith({
    String? address,
    BIP21AddressTypeEnum? addressType,
    double? amount,
    String? ticker,
    String? message,
    String? label,
    int? bitMask,
    bool? error,
    String? errorMessage,
    String? orderId,
    String? assetId,
    OutputsData? outputsData,
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
      outputsData: outputsData ?? this.outputsData,
    );
  }

  @override
  String toString() {
    return 'QrCodeResult(address: $address, addressType: $addressType, amount: $amount, ticker: $ticker, message: $message, label: $label, bitMask: $bitMask, error: $error, errorMessage: $errorMessage, assetId: $assetId, outputsData: $outputsData)';
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
        other.assetId == assetId &&
        other.outputsData == outputsData;
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
        assetId.hashCode ^
        outputsData.hashCode;
  }
}

// scheme:address_or_merchant_token?T=M;100.00;L-BTC;message;0
// T=
// M - as merchant, C - as client;
// amount;
// asset;
// url encoded message - 64 characters? - we need here something small, maybe even 32 characters;
// bit mask;

class QrCodeHelper {
  final Ref ref;
  QrCodeResult _result = QrCodeResult();

  QrCodeHelper(this.ref);

  Future<Either<Exception, QrCodeResult>> parseDynamicQrCode(
    String qrCode,
  ) async {
    if (qrCode.isEmpty) {
      return Right(_emitError('Empty qr code'.tr()));
    }

    _result = QrCodeResult();

    // check is it static qr code
    if (ref.read(isAddrTypeValidProvider(qrCode, AddrType.bitcoin))) {
      _result.address = qrCode;
      _result.addressType = BIP21AddressTypeEnum.bitcoin;
      return Right(_result);
    }

    if (ref.read(isAddrTypeValidProvider(qrCode, AddrType.elements))) {
      _result.address = qrCode;
      _result.addressType = BIP21AddressTypeEnum.elements;
      return Right(_result);
    }

    try {
      final url = Uri.parse(qrCode);

      if (url.scheme == 'bitcoin') {
        final bip21Result = ref.read(
          parseBIP21Provider(qrCode, BIP21AddressTypeEnum.bitcoin),
        );
        return bip21Result.match(
          (l) => Left(l),
          (r) => Right(
            QrCodeResult(
              address: r.address,
              addressType: r.addressType,
              amount: r.amount,
              ticker: r.ticker,
              message: r.message,
              label: r.label,
              assetId: r.assetId,
            ),
          ),
        );
      }

      if (url.scheme == 'liquidnetwork') {
        final bip21Result = ref.read(
          parseBIP21Provider(qrCode, BIP21AddressTypeEnum.liquidnetwork),
        );
        return bip21Result.match(
          (l) => Left(l),
          (r) => Right(
            QrCodeResult(
              address: r.address,
              addressType: r.addressType,
              amount: r.amount,
              ticker: r.ticker,
              message: r.message,
              label: r.label,
              assetId: r.assetId,
            ),
          ),
        );
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

      return Right(_result);
    } catch (e) {
      logger.w(e);
    }

    // maybe it's a json?
    try {
      await ref
          .read(outputsReaderNotifierProvider.notifier)
          .decodeJsonString(qrCode);
      final outputsData = ref.read(outputsReaderNotifierProvider);
      return outputsData.match(
        (l) {
          return Right(_emitError(l.message ?? ''));
        },
        (r) {
          return Right(QrCodeResult(outputsData: r));
        },
      );
    } catch (e) {
      logger.e(e);

      _emitError('Invalid QR code'.tr());

      _result.error = true;
      _result.errorMessage = 'Invalid QR code'.tr();

      return Right(_result);
    }
  }

  Either<Exception, QrCodeResult> parseSideSwapAddress(String qrCode) {
    final url = Uri.parse(qrCode);
    final queryParams = url.queryParameters;

    if (queryParams.isEmpty) {
      logger.w('Invalid qr code');
      return Right(_emitError('Invalid QR code'.tr()));
    }

    _result.address = url.path;
    _result.addressType = BIP21AddressTypeEnum.other;
    if (_result.address != null && _result.address!.isEmpty) {
      logger.w('Empty qr code address');
      return Right(_emitError('Invalid QR code'.tr()));
    }

    String? data;

    if (queryParams.containsKey('T')) {
      data = queryParams['T'];
    }

    if (data == null) {
      logger.w('Wrong qr code');
      return Right(_emitError(''.tr()));
    }

    final dataList = data.split(';');

    if (dataList.length < 5) {
      logger.w('Wrong qr code data');
      return Right(_emitError('Invalid QR code'.tr()));
    }

    if (dataList[0] == 'M') {
      _result.type = QrCodeResultType.merchant;
    }

    if (dataList[0] == 'C') {
      _result.type = QrCodeResultType.client;
    }

    if (_result.type == null) {
      logger.w('Invalid merchant type');
      return Right(_emitError('Invalid QR code'.tr()));
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
      return Right(_emitError('Invalid QR code'.tr()));
    }

    logger.d(_result);

    return Right(QrCodeResult());
  }

  QrCodeResult _emitError(String errorMessage) {
    _result = QrCodeResult();
    _result.error = true;
    _result.errorMessage = errorMessage;
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
