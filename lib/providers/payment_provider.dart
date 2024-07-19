import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/friends_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'payment_provider.freezed.dart';
part 'payment_provider.g.dart';

@freezed
class CreateTxState with _$CreateTxState {
  const factory CreateTxState.empty() = CreateTxStateEmpty;
  const factory CreateTxState.creating() = CreateTxStateCreating;
}

@freezed
class SendTxState with _$SendTxState {
  const factory SendTxState.empty() = SendTxStateEmpty;
  const factory SendTxState.sending() = SendTxStateSending;
}

@Riverpod(keepAlive: true)
class CreateTxStateNotifier extends _$CreateTxStateNotifier {
  @override
  CreateTxState build() {
    return const CreateTxStateEmpty();
  }

  void setCreateTxState(CreateTxState createTxState) {
    state = createTxState;
  }
}

@Riverpod(keepAlive: true)
class SendTxStateNotifier extends _$SendTxStateNotifier {
  @override
  SendTxState build() {
    return const SendTxStateEmpty();
  }

  void setSendTxState(SendTxState sendTxState) {
    state = sendTxState;
  }
}

@riverpod
int? parseAssetAmount(ParseAssetAmountRef ref,
    {required String amount, required int precision}) {
  if (precision < 0 || precision > 8) {
    return null;
  }

  final newValue = amount.replaceAll(' ', '');
  final newAmount = Decimal.tryParse(newValue);

  if (newAmount == null) {
    return null;
  }

  final amountDec = newAmount * Decimal.fromInt(pow(10, precision).toInt());

  final amountInt = amountDec.toBigInt().toInt();

  if (Decimal.fromInt(amountInt) != amountDec) {
    return null;
  }

  return amountInt;
}

@riverpod
int satoshiForAmount(SatoshiForAmountRef ref,
    {required String assetId, required String amount}) {
  final precision =
      ref.watch(assetUtilsProvider).getPrecisionForAssetId(assetId: assetId);
  return ref.watch(
          parseAssetAmountProvider(amount: amount, precision: precision)) ??
      0;
}

@Riverpod(keepAlive: true)
class PaymentInsufficientFundsNotifier
    extends _$PaymentInsufficientFundsNotifier {
  @override
  bool build() {
    return false;
  }

  void setInsufficientFunds(bool value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class PaymentSendAddressParsedNotifier
    extends _$PaymentSendAddressParsedNotifier {
  @override
  String build() {
    return '';
  }

  void setSendAddressParsed(String address) {
    state = address;
  }
}

@Riverpod(keepAlive: true)
class PaymentSendAmountParsedNotifier
    extends _$PaymentSendAmountParsedNotifier {
  @override
  int build() {
    return 0;
  }

  void setSendAmountParsed(int amount) {
    state = amount;
  }
}

@Riverpod(keepAlive: true)
class PaymentCreatedTxNotifier extends _$PaymentCreatedTxNotifier {
  @override
  CreatedTx? build() {
    return null;
  }

  void setCreatedTx(CreatedTx? createdTx) {
    state = createdTx;
  }

  int sendNetworkFee() => state?.networkFee.toInt() ?? 0;
}

@Riverpod(keepAlive: true)
class PaymentAmountPageArgumentsNotifier
    extends _$PaymentAmountPageArgumentsNotifier {
  @override
  PaymentAmountPageArguments build() {
    return PaymentAmountPageArguments();
  }

  void setPaymentAmountPageArguments(PaymentAmountPageArguments arguments) {
    state = arguments;
  }
}

@riverpod
PaymentHelper paymentHelper(PaymentHelperRef ref) {
  final outputsData = ref.watch(outputsCreatorProvider);
  final selectedAccountAsset =
      ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
  return PaymentHelper(ref, outputsData, selectedAccountAsset);
}

class PaymentHelper {
  final Ref ref;
  final Either<OutputsError, OutputsData> outputsData;
  final AccountAsset accountAsset;

  PaymentHelper(this.ref, this.outputsData, this.accountAsset);

  String? outputsPaymentSend({
    List<UtxosItem>? selectedInputs,
    bool isMaxSelected = false,
  }) {
    return switch (outputsData) {
      Left(value: final l) => l.message,
      Right(value: final r) => () {
          final addressAmounts = r.receivers?.map((e) {
            // set greedy flag only when outputs contains only one item (first one is always entered by user in ui) and max is pressed
            final greedyFlag = switch (r.receivers?.length) {
              1 => () {
                  if (selectedInputs?.isNotEmpty == true) {
                    final maxAssetBalance = ref.read(
                        maxAvailableBalanceWithInputsForAccountAssetProvider(
                            accountAsset));
                    return (maxAssetBalance == e.satoshi && isMaxSelected);
                  }

                  final maxAssetBalance = ref.read(
                      maxAvailableBalanceForAccountAssetProvider(accountAsset));
                  return (maxAssetBalance == e.satoshi && isMaxSelected);
                }(),
              _ => false,
            };

            return AddressAmount(
              address: e.address,
              amount: Int64(e.satoshi ?? 0),
              assetId: e.assetId,
              isGreedy: greedyFlag,
            );
          }).toList();

          final utxos =
              selectedInputs?.map((e) => OutPoint(txid: e.txid, vout: e.vout));

          final createTx = CreateTx(
            addressees: addressAmounts,
            account: getAccount(accountAsset.account),
            utxos: utxos,
          );

          ref.read(walletProvider).createTx(createTx);
        }(),
    };
  }

  void selectPaymentSend(String amount, AccountAsset accountAsset,
      {Friend? friend, String? address, bool isGreedy = false}) {
    // TODO: handle friend payment send
    if (address == null) {
      logger.e('Address is null');
      return;
    }

    /// Used only in mobile - it should be removed if outputs are added to mobile?
    Future.microtask(() => ref
        .read(selectedWalletAccountAssetNotifierProvider.notifier)
        .setAccountAsset(accountAsset));

    if (!ref.read(isAddrTypeValidProvider(address, AddrType.elements))) {
      logger.e('Invalid address $address');
      return;
    }

    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset.assetId);
    final internalAmount = ref
        .read(parseAssetAmountProvider(amount: amount, precision: precision));
    final balance = ref.read(balancesNotifierProvider)[accountAsset];
    if (balance == null) {
      logger.e('Wrong balance for selected wallet asset');
      return;
    }

    if (internalAmount == null ||
        internalAmount <= 0 ||
        internalAmount > balance) {
      logger.e('Incorrect amount $amount');
      return;
    }

    /// Used only in mobile - it should be removed if outputs are added to mobile?
    ref
        .read(paymentSendAddressParsedNotifierProvider.notifier)
        .setSendAddressParsed(address);
    ref
        .read(paymentSendAmountParsedNotifierProvider.notifier)
        .setSendAmountParsed(internalAmount);

    final addressAmount = AddressAmount();
    addressAmount.address = address;
    addressAmount.amount = Int64(internalAmount);
    addressAmount.assetId = accountAsset.assetId ?? '';
    addressAmount.isGreedy = isGreedy && internalAmount == balance;

    final createTx = CreateTx(
        addressees: [addressAmount], account: getAccount(accountAsset.account));

    ref.read(walletProvider).createTx(createTx);
  }
}
