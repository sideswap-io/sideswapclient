import 'package:fixnum/fixnum.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
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
  const factory CreateTxState.created(CreatedTx createdTx) =
      CreateTxStateCreated;
  const factory CreateTxState.error({String? errorMsg}) = CreateTxStateError;
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
PaymentHelper paymentHelper(Ref ref) {
  final outputsData = ref.watch(outputsCreatorProvider);
  final selectedAccountAsset = ref.watch(
    sendPopupSelectedAccountAssetNotifierProvider,
  );
  final deductFeeFromOutput = ref.watch(deductFeeFromOutputNotifierProvider);
  final deductIndex = ref.watch(payjoinRadioButtonIndexNotifierProvider);
  final feeAsset = ref.watch(payjoinFeeAssetNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);

  return PaymentHelper(
    ref,
    outputsData: outputsData,
    accountAsset: selectedAccountAsset,
    deductFeeFromOutput: deductFeeFromOutput,
    deductIndex: deductIndex,
    feeAsset: feeAsset,
    liquidAssetId: liquidAssetId,
    satoshiRepository: satoshiRepository,
  );
}

class PaymentHelper {
  final Ref ref;
  final Either<OutputsError, OutputsData> outputsData;
  final AccountAsset accountAsset;
  final bool deductFeeFromOutput;
  final int deductIndex;
  final Asset? feeAsset;
  final String liquidAssetId;
  final AbstractSatoshiRepository satoshiRepository;

  PaymentHelper(
    this.ref, {
    required this.outputsData,
    required this.accountAsset,
    required this.deductFeeFromOutput,
    required this.deductIndex,
    required this.satoshiRepository,
    this.feeAsset,
    required this.liquidAssetId,
  });

  String? outputsPaymentSend({List<UtxosItem>? selectedInputs}) {
    return switch (outputsData) {
      Left(value: final l) => l.message,
      Right(value: final r) => () {
        if (r.receivers == null) {
          return;
        }

        final addressAmounts =
            r.receivers!.map((e) {
              return AddressAmount(
                address: e.address,
                amount: Int64(e.satoshi ?? 0),
                assetId: e.assetId,
              );
            }).toList();

        final utxos = selectedInputs?.map(
          (selectedInput) =>
              OutPoint(txid: selectedInput.txid, vout: selectedInput.vout),
        );

        final account = Account();
        account.id =
            ((selectedInputs?.length ?? 0) > 0
                ? selectedInputs?.first.account
                : accountAsset.account.id) ??
            0;

        final createTx = CreateTx(
          addressees: addressAmounts,
          account: account,
          utxos: utxos,
          deductFeeOutput: deductFeeFromOutput ? deductIndex : null,
          feeAssetId:
              feeAsset?.assetId != liquidAssetId ? feeAsset?.assetId : null,
        );

        ref.read(walletProvider).createTx(createTx);
      }(),
    };
  }

  void selectPaymentSend(
    String amount,
    AccountAsset accountAsset, {
    String? address,
    bool isGreedy = false,
  }) {
    if (address == null) {
      logger.e('Address is null');
      return;
    }

    /// Used only in mobile - it should be removed if outputs are added to mobile?
    Future.microtask(
      () => ref
          .read(selectedWalletAccountAssetNotifierProvider.notifier)
          .setAccountAsset(accountAsset),
    );

    if (!ref.read(isAddrTypeValidProvider(address, AddrType.elements))) {
      logger.e('Invalid address $address');
      return;
    }

    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset.assetId);
    final internalAmount = satoshiRepository.parseAssetAmount(
      amount: amount,
      precision: precision,
    );
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

    final liquidAssetId = ref.read(liquidAssetIdStateProvider);

    final addressAmount = AddressAmount();
    addressAmount.address = address;
    addressAmount.amount = Int64(internalAmount);
    addressAmount.assetId = accountAsset.assetId ?? '';
    final shouldDeductFeeOutput =
        isGreedy &&
        internalAmount == balance &&
        liquidAssetId == accountAsset.assetId;

    final createTx = CreateTx(
      addressees: [addressAmount],
      account: getAccount(accountAsset.account),
      deductFeeOutput: shouldDeductFeeOutput ? 0 : null,
    );

    ref.read(walletProvider).createTx(createTx);
  }
}

class CreatedTxHelper {
  final String? _networkFee;
  final String? _serverFee;
  final CreatedTx? createdTx;

  CreatedTxHelper({String? networkFee, String? serverFee, this.createdTx})
    : _networkFee = networkFee,
      _serverFee = serverFee;

  String feePerByte() {
    return '${createdTx?.feePerByte.toStringAsFixed(3) ?? 0} s/b';
  }

  String txSize() {
    return '${createdTx?.size.toString() ?? 0} Bytes / ${createdTx?.vsize.toString() ?? 0} VBytes';
  }

  String networkFee() {
    return _networkFee ?? '';
  }

  bool hasServerFee() {
    return (createdTx?.serverFee.toInt() ?? 0) != 0;
  }

  String serverFee() {
    return _serverFee ?? '';
  }

  String vsize() {
    return '${createdTx?.discountVsize.toString() ?? ''} vB';
  }

  String inputCount() {
    return createdTx?.inputCount.toString() ?? '';
  }

  String outputCount() {
    return createdTx?.outputCount.toString() ?? '';
  }
}

@riverpod
CreatedTxHelper createdTxHelper(Ref ref, CreatedTx? createdTx) {
  final amountProvider = ref.watch(amountToStringProvider);
  final networkFee = amountProvider.amountToStringNamed(
    AmountToStringNamedParameters(
      amount: createdTx?.networkFee.toInt() ?? 0,
      ticker: 'L-BTC',
    ),
  );

  final feeAssetId = createdTx?.req.feeAssetId;
  final feeAssetTicker = ref
      .read(assetUtilsProvider)
      .tickerForAssetId(feeAssetId);

  final serverFee = amountProvider.amountToStringNamed(
    AmountToStringNamedParameters(
      amount: createdTx?.serverFee.toInt() ?? 0,
      ticker: feeAssetTicker,
    ),
  );

  return CreatedTxHelper(
    networkFee: networkFee,
    serverFee: serverFee,
    createdTx: createdTx,
  );
}
