import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/pay/widgets/ticker_amount_textfield.dart';

class PaymentSendAmount extends ConsumerWidget {
  const PaymentSendAmount({
    super.key,
    this.controller,
    required this.focusNode,
    this.onDropdownChanged,
    required this.validate,
    required this.dropdownValue,
    this.availableDropdownAssets,
    this.onChanged,
  });

  final TextEditingController? controller;
  final FocusNode focusNode;
  final void Function(AccountAsset)? onDropdownChanged;
  final void Function(String) validate;
  final AccountAsset dropdownValue;
  final List<AccountAsset>? availableDropdownAssets;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final sendAssets =
            availableDropdownAssets ?? ref.watch(walletProvider).sendAssets();
        final showError = ref.watch(paymentInsufficientFundsNotifierProvider);

        return TickerAmountTextField(
          focusNode: focusNode,
          controller: controller,
          showError: showError,
          availableAssets: sendAssets,
          onDropdownChanged: onDropdownChanged,
          dropdownValue: dropdownValue,
          showAccountsInPopup: true,
          onChanged: (value) {
            validate(value);

            controller?.text = value;

            onChanged?.call(value);
          },
        );
      },
    );
  }
}
