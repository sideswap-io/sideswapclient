import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

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
    ref.read(walletProvider).status = Status.paymentAmountPage;
    notifyListeners();
  }

  void selectPaymentSend(String amount, AccountAsset accountAsset,
      {Friend? friend, String? address}) {
    // TODO: handle friend payment send
    if (address == null) {
      logger.e('Address is null');
      return;
    }

    ref.read(walletProvider).selectedWalletAsset = accountAsset;
    if (!ref.read(walletProvider).isAddrValid(address, AddrType.elements)) {
      logger.e('Invalid address $address');
      return;
    }

    final precision = ref
        .read(walletProvider)
        .getPrecisionForAssetId(assetId: accountAsset.asset);
    final _amount =
        ref.read(walletProvider).parseAssetAmount(amount, precision: precision);
    final balance = ref
        .read(balancesProvider)
        .balances[ref.read(walletProvider).selectedWalletAsset];
    if (balance == null) {
      logger.e('Wrong balance for selected wallet asset');
      return;
    }

    if (_amount == null || _amount <= 0 || _amount > balance) {
      logger.e('Incorrect amount $_amount');
      return;
    }

    sendAddrParsed = address;
    sendAmountParsed = _amount;

    final createTx = CreateTx();
    createTx.addr = sendAddrParsed;
    createTx.balance = Balance();
    createTx.balance.amount = Int64(sendAmountParsed);
    createTx.balance.assetId =
        ref.read(walletProvider).selectedWalletAsset!.asset;
    createTx.account = getAccount(accountAsset.account);
    ref.read(walletProvider).createTx(createTx);

    notifyListeners();
  }
}
