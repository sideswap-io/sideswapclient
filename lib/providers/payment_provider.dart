import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/friends_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

final paymentProvider =
    ChangeNotifierProvider<PaymentProvider>((ref) => PaymentProvider(ref));

class PaymentProvider with ChangeNotifier {
  final Ref ref;

  PaymentProvider(this.ref);

  bool _insufficientFunds = false;
  bool get insufficientFunds => _insufficientFunds;
  set insufficientFunds(bool insufficientFunds) {
    _insufficientFunds = insufficientFunds;
    notifyListeners();
  }

  String _sendAddrParsed = '';
  String get sendAddrParsed => _sendAddrParsed;
  set sendAddrParsed(String sendAddrParsed) {
    _sendAddrParsed = sendAddrParsed;
    notifyListeners();
  }

  int _sendAmountParsed = 0;
  int get sendAmountParsed => _sendAmountParsed;
  set sendAmountParsed(int sendAmountParsed) {
    _sendAmountParsed = sendAmountParsed;
    notifyListeners();
  }

  CreatedTx? _createdTx;
  CreatedTx? get createdTx => _createdTx;
  set createdTx(CreatedTx? value) {
    _createdTx = value;
    notifyListeners();
  }

  int get sendNetworkFee => _createdTx?.networkFee.toInt() ?? 0;

  PaymentAmountPageArguments paymentAmountPageArguments =
      PaymentAmountPageArguments();

  void selectPaymentAmountPage(PaymentAmountPageArguments arguments) {
    paymentAmountPageArguments = arguments;
    ref
        .read(pageStatusStateProvider.notifier)
        .setStatus(Status.paymentAmountPage);
  }

  void selectPaymentSend(String amount, AccountAsset accountAsset,
      {Friend? friend, String? address}) {
    // TODO: handle friend payment send
    if (address == null) {
      logger.e('Address is null');
      return;
    }

    ref
        .read(selectedWalletAccountAssetNotifierProvider.notifier)
        .setAccountAsset(accountAsset);
    if (!ref.read(isAddrTypeValidProvider(address, AddrType.elements))) {
      logger.e('Invalid address $address');
      return;
    }

    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset.assetId);
    final internalAmount =
        ref.read(walletProvider).parseAssetAmount(amount, precision: precision);
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

    sendAddrParsed = address;
    sendAmountParsed = internalAmount;

    final createTx = CreateTx();
    createTx.addr = sendAddrParsed;
    createTx.balance = Balance();
    createTx.balance.amount = Int64(sendAmountParsed);
    createTx.balance.assetId = accountAsset.assetId ?? '';
    createTx.account = getAccount(accountAsset.account);
    ref.read(walletProvider).createTx(createTx);

    notifyListeners();
  }
}
