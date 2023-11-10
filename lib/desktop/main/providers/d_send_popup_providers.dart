import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/wallet.dart';

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
    final accountAsset = ref.watch(sendAssetProvider);
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
    final conversion = ref
        .watch(requestOrderProvider)
        .dollarConversionFromString(selectedAccountAsset.assetId, amount);
    return conversion;
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
bool sendPopupButtonEnabled(SendPopupButtonEnabledRef ref) {
  final isAddressValid = ref.watch(sendPopupIsAddressValidProvider);
  final amountString = ref.watch(sendPopupAmountNotifierProvider);
  final selectedAccountAsset =
      ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
  final balanceString = ref.watch(balanceStringProvider(selectedAccountAsset));

  final amount = double.tryParse(amountString) ?? 0.0;
  final balance = double.tryParse(balanceString) ?? 0.0;

  return isAddressValid && amount > 0 && amount <= balance;
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
bool sendPopupIsAddressValid(SendPopupIsAddressValidRef ref) {
  final address = ref.watch(sendPopupAddressNotifierProvider);
  final isAddressValid =
      ref.watch(walletProvider).isAddrValid(address, AddrType.elements);

  return isAddressValid;
}

@riverpod
String? sendPopupDollarConversion(SendPopupDollarConversionRef ref) {
  final receiveConversion =
      ref.watch(sendPopupReceiveConversionNotifierProvider);
  final showInsufficientFunds =
      ref.watch(sendPopupShowInsufficientFundsProvider);

  return showInsufficientFunds ? null : receiveConversion;
}
