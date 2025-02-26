// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'd_send_popup_providers.g.dart';

@Riverpod(keepAlive: true)
class SendPopupAmountNotifier extends _$SendPopupAmountNotifier {
  @override
  String build() {
    return '';
  }

  void setAmount(String value) {
    final amount = value.replaceAll(' ', '');
    state = amount;
  }
}

@riverpod
Decimal sendPopupDecimalAmount(Ref ref) {
  final amount = ref.watch(sendPopupAmountNotifierProvider);
  if (amount.isEmpty) {
    return Decimal.zero;
  }

  return Decimal.tryParse(amount) ?? Decimal.zero;
}

@Riverpod(keepAlive: true)
class SendPopupAddressNotifier extends _$SendPopupAddressNotifier {
  @override
  String build() {
    return '';
  }

  void setAddress(String address) {
    state = address;
  }
}

@Riverpod(keepAlive: true)
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
    final selectedAccountAsset = ref.watch(
      sendPopupSelectedAccountAssetNotifierProvider,
    );
    final amount = ref.watch(sendPopupAmountNotifierProvider);
    final conversion = ref.watch(
      defaultCurrencyConversionFromStringProvider(
        selectedAccountAsset.assetId,
        amount,
      ),
    );
    return conversion;
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
class SendPopupValidDataInserted extends _$SendPopupValidDataInserted {
  @override
  FutureOr<bool> build() {
    final parseAddressResult = ref.watch(sendPopupParseAddressProvider);
    final amountString = ref.watch(sendPopupAmountNotifierProvider);
    final balanceString = ref.watch(balanceStringWithInputsProvider);

    return switch (parseAddressResult) {
      Left(value: final _) => future,
      Right(value: final r) => () {
        final amount = double.tryParse(amountString) ?? 0.0;
        final balance = double.tryParse(balanceString) ?? 0.0;

        final properNetwork = switch (r.addressType) {
          BIP21AddressTypeEnum.elements ||
          BIP21AddressTypeEnum.liquidnetwork => true,
          _ => false,
        };
        final enabled = properNetwork && amount > 0 && amount <= balance;
        return switch (enabled) {
          true => Future<bool>.value(enabled),
          _ => future,
        };
      }(),
    };
  }
}

@riverpod
class SendPopupAddMoreOutputsButtonEnabled
    extends _$SendPopupAddMoreOutputsButtonEnabled {
  @override
  FutureOr<bool> build() {
    final createTxState = ref.watch(createTxStateNotifierProvider);
    if (createTxState == const CreateTxStateCreating()) {
      return future;
    }

    return ref.watch(sendPopupValidDataInsertedProvider.future);
  }
}

/// Accept only liquidnetwork or elements address type
@riverpod
class SendPopupReviewButtonEnabled extends _$SendPopupReviewButtonEnabled {
  @override
  FutureOr<bool> build() {
    final createTxState = ref.watch(createTxStateNotifierProvider);
    if (createTxState == const CreateTxStateCreating()) {
      return future;
    }

    final outputsData = ref.watch(outputsReaderNotifierProvider);
    final sendPopupFuture = ref.watch(
      sendPopupValidDataInsertedProvider.future,
    );

    return switch (outputsData) {
      Right(value: _) => Future<bool>.value(true),
      _ => sendPopupFuture,
    };
  }
}

@riverpod
bool sendPopupShowInsufficientFunds(Ref ref) {
  final amountString = ref.watch(sendPopupAmountNotifierProvider);
  final balanceString = ref.watch(balanceStringWithInputsProvider);

  final amount = double.tryParse(amountString) ?? 0.0;
  final balance = double.tryParse(balanceString) ?? 0.0;

  return amount > balance;
}

@riverpod
String? sendPopupDefaultCurrencyConversion(Ref ref) {
  final receiveConversion = ref.watch(
    sendPopupReceiveConversionNotifierProvider,
  );
  final showInsufficientFunds = ref.watch(
    sendPopupShowInsufficientFundsProvider,
  );

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

  (String, BIP21AddressTypeEnum, double, String) _equality() => (
    address,
    addressType,
    amount,
    assetId,
  );

  @override
  bool operator ==(covariant SendPopupAddressResult other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
Either<Exception, SendPopupAddressResult> sendPopupParseAddress(Ref ref) {
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
      final result = ref.watch(
        parseBIP21Provider(address, BIP21AddressTypeEnum.bitcoin),
      );

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
        parseBIP21Provider(address, BIP21AddressTypeEnum.liquidnetwork),
      );

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
