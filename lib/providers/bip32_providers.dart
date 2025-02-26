import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'bip32_providers.g.dart';

class BIP21Result {
  final double amount;
  final String label;
  final String message;
  final String assetId;
  final String ticker;
  final String address;
  final BIP21AddressTypeEnum addressType;

  BIP21Result({
    required this.amount,
    required this.label,
    required this.message,
    required this.assetId,
    required this.ticker,
    required this.address,
    required this.addressType,
  });

  BIP21Result copyWith({
    double? amount,
    String? label,
    String? message,
    String? assetId,
    String? ticker,
    String? address,
    BIP21AddressTypeEnum? addressType,
  }) {
    return BIP21Result(
      amount: amount ?? this.amount,
      label: label ?? this.label,
      message: message ?? this.message,
      assetId: assetId ?? this.assetId,
      ticker: ticker ?? this.ticker,
      address: address ?? this.address,
      addressType: addressType ?? this.addressType,
    );
  }

  @override
  String toString() {
    return 'ParseBIP21Result(amount: $amount, label: $label, message: $message, assetId: $assetId, ticker: $ticker, address: $address, addressType: $addressType)';
  }

  (double, String, String, String, String, String, BIP21AddressTypeEnum)
  _equality() => (
    amount,
    label,
    message,
    assetId,
    ticker,
    address,
    addressType,
  );

  @override
  bool operator ==(covariant BIP21Result other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
Either<Exception, BIP21Result> parseBIP21(
  Ref ref,
  String address,
  BIP21AddressTypeEnum addressType,
) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  try {
    final url = Uri.parse(address);
    final params = url.queryParameters;

    var amount = .0;
    var label = '';
    var message = '';
    var assetId = liquidAssetId;
    final asset = ref.watch(assetsStateProvider)[assetId];
    var ticker = asset?.ticker ?? '';

    if (params.containsKey('amount')) {
      amount = double.tryParse(params['amount'] ?? '0') ?? 0;
      if (amount < 0) {
        amount = 0;
      }
    }

    if (params.containsKey('label')) {
      label = params['label'] ?? '';
    }

    if (params.containsKey('message')) {
      message = params['message'] ?? '';
    }

    if (params.containsKey('assetid')) {
      assetId = params['assetid'] ?? '';
      final asset = ref.watch(assetsStateProvider)[assetId];
      ticker = asset != null ? asset.ticker : kUnknownTicker;
    }

    final parsedAddress = url.path;

    return Right(
      BIP21Result(
        amount: amount,
        label: label,
        message: message,
        assetId: assetId,
        ticker: ticker,
        address: parsedAddress,
        addressType: addressType,
      ),
    );
  } catch (e) {
    logger.e(e);
    return Left(Exception('Invalid BIP21 address'));
  }
}
