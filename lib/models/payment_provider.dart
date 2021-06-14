import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

final paymentProvider = Provider((ref) => PaymentProvider(ref.read));

class PaymentProvider with ChangeNotifier {
  final Reader read;

  PaymentProvider(this.read);

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

  String _sendResultError = '';
  String get sendResultError => _sendResultError;
  set sendResultError(String sendResultError) {
    _sendResultError = sendResultError;
    notifyListeners();
  }

  int _sendNetworkFee = 0;
  int get sendNetworkFee => _sendNetworkFee;
  set sendNetworkFee(int sendNetworkFee) {
    _sendNetworkFee = sendNetworkFee;
    notifyListeners();
  }

  PaymentAmountPageArguments paymentAmountPageArguments =
      PaymentAmountPageArguments();

  void selectPaymentAmountPage(PaymentAmountPageArguments arguments) {
    paymentAmountPageArguments = arguments;
    read(walletProvider).status = Status.paymentAmountPage;
    notifyListeners();
  }

  void selectPaymentSend(String? address, String amount, String assetId) {
    if (address == null) {
      logger.e('Address is null');
      return;
    }

    read(walletProvider).selectedWalletAsset = assetId;
    if (!read(walletProvider).isAddrValid(address, AddrType.elements)) {
      logger.e('Invalid address $address');
      return;
    }
    final _amount = read(walletProvider).parseBitcoinAmount(amount);
    final balance =
        read(walletProvider).balances[read(walletProvider).selectedWalletAsset];
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

    final msg = To();
    msg.createTx = To_CreateTx();
    msg.createTx.addr = sendAddrParsed;
    msg.createTx.balance = Balance();
    msg.createTx.balance.amount = Int64(sendAmountParsed);
    msg.createTx.balance.assetId = read(walletProvider).selectedWalletAsset;
    read(walletProvider).sendMsg(msg);

    notifyListeners();
  }
}
