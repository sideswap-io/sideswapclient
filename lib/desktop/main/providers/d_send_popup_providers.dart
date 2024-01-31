// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'd_send_popup_providers.g.dart';

@riverpod
class SendPopupAmountNotifier extends _$SendPopupAmountNotifier {
  @override
  String build() {
    return '';
  }

  void setAmount(String amount) {
    state = amount;
  }
}

@riverpod
class SendPopupAddressNotifier extends _$SendPopupAddressNotifier {
  @override
  String build() {
    return '';
  }

  void setAddress(String address) {
    state = address;
  }
}

@riverpod
class SendPopupSelectedAccountAssetNotifier
    extends _$SendPopupSelectedAccountAssetNotifier {
  @override
  AccountAsset build() {
    final accountAsset = ref.watch(sendAssetNotifierProvider);
    return accountAsset;
  }

  void setSelectedAsset(AccountAsset accountAsset) {
    state = accountAsset;
  }
}

@riverpod
class SendPopupReceiveConversionNotifier
    extends _$SendPopupReceiveConversionNotifier {
  @override
  String build() {
    final selectedAccountAsset =
        ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
    final amount = ref.watch(sendPopupAmountNotifierProvider);
    final conversion = ref.watch(dollarConversionFromStringProvider(
        selectedAccountAsset.assetId, amount));
    return conversion;
  }

  void setState(String value) {
    state = value;
  }
}

/// Accept only liquidnetwork or elements address type
@riverpod
bool sendPopupButtonEnabled(SendPopupButtonEnabledRef ref) {
  final parseAddressResult = ref.watch(sendPopupParseAddressProvider);
  final amountString = ref.watch(sendPopupAmountNotifierProvider);
  final selectedAccountAsset =
      ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
  final balanceString = ref.watch(balanceStringProvider(selectedAccountAsset));

  final amount = double.tryParse(amountString) ?? 0.0;
  final balance = double.tryParse(balanceString) ?? 0.0;

  return switch (parseAddressResult) {
    Left(value: final _) => false,
    Right(value: final r) => () {
        final properNetwork = switch (r.addressType) {
          BIP21AddressTypeEnum.elements ||
          BIP21AddressTypeEnum.liquidnetwork =>
            true,
          _ => false,
        };
        return properNetwork && amount > 0 && amount <= balance;
      }(),
  };
}

@riverpod
bool sendPopupShowInsufficientFunds(SendPopupShowInsufficientFundsRef ref) {
  final amountString = ref.watch(sendPopupAmountNotifierProvider);
  final selectedAccountAsset =
      ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
  final balanceString = ref.watch(balanceStringProvider(selectedAccountAsset));

  final amount = double.tryParse(amountString) ?? 0.0;
  final balance = double.tryParse(balanceString) ?? 0.0;

  return amount > balance;
}

@riverpod
String? sendPopupDollarConversion(SendPopupDollarConversionRef ref) {
  final receiveConversion =
      ref.watch(sendPopupReceiveConversionNotifierProvider);
  final showInsufficientFunds =
      ref.watch(sendPopupShowInsufficientFundsProvider);

  return showInsufficientFunds ? null : receiveConversion;
}

class SendPopupAddressResult {
  final String address;
  final BIP21AddressTypeEnum addressType;
  final double amount;
  final String assetId;

  SendPopupAddressResult({
    required this.address,
    required this.addressType,
    required this.amount,
    required this.assetId,
  });

  SendPopupAddressResult copyWith({
    String? address,
    BIP21AddressTypeEnum? addressType,
    double? amount,
    String? assetId,
  }) {
    return SendPopupAddressResult(
      address: address ?? this.address,
      addressType: addressType ?? this.addressType,
      amount: amount ?? this.amount,
      assetId: assetId ?? this.assetId,
    );
  }

  @override
  String toString() {
    return 'SendPopupAddressResult(address: $address, addressType: $addressType, amount: $amount, assetId: $assetId)';
  }

  (String, BIP21AddressTypeEnum, double, String) _equality() =>
      (address, addressType, amount, assetId);

  @override
  bool operator ==(covariant SendPopupAddressResult other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
Either<Exception, SendPopupAddressResult> sendPopupParseAddress(
    SendPopupParseAddressRef ref) {
  final address = ref.watch(sendPopupAddressNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);

  if (ref.watch(isAddrTypeValidProvider(address, AddrType.bitcoin))) {
    return Right(
      SendPopupAddressResult(
        address: address,
        addressType: BIP21AddressTypeEnum.bitcoin,
        amount: 0,
        assetId: bitcoinAssetId,
      ),
    );
  }

  if (ref.watch(isAddrTypeValidProvider(address, AddrType.elements))) {
    return Right(
      SendPopupAddressResult(
        address: address,
        addressType: BIP21AddressTypeEnum.elements,
        amount: 0,
        assetId: liquidAssetId,
      ),
    );
  }

  try {
    final url = Uri.parse(address);

    if (url.scheme == 'bitcoin') {
      final result =
          ref.watch(parseBIP21Provider(address, BIP21AddressTypeEnum.bitcoin));

      return result.match(
        (l) => Left(l),
        (r) => Right(
          SendPopupAddressResult(
            address: r.address,
            addressType: r.addressType,
            amount: r.amount,
            assetId: r.assetId.isEmpty ? liquidAssetId : r.assetId,
          ),
        ),
      );
    }

    if (url.scheme == 'liquidnetwork') {
      final result = ref.watch(
          parseBIP21Provider(address, BIP21AddressTypeEnum.liquidnetwork));

      return result.match(
        (l) => Left(l),
        (r) => Right(
          SendPopupAddressResult(
            address: r.address,
            addressType: r.addressType,
            amount: r.amount,
            assetId: r.assetId.isEmpty ? liquidAssetId : r.assetId,
          ),
        ),
      );
    }
  } catch (e) {
    logger.e(e);
  }

  return Left(Exception('Invalid address'));
}
