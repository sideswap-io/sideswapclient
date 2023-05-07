import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/pay/widgets/ticker_amount_textfield.dart';

class PaymentSendAmount extends StatefulWidget {
  const PaymentSendAmount({
    super.key,
    this.controller,
    required this.focusNode,
    this.onDropdownChanged,
    required this.dropdownValue,
    required this.validate,
    this.availableDropdownAssets,
  });

  final TextEditingController? controller;
  final FocusNode focusNode;
  final void Function(AccountAsset)? onDropdownChanged;
  final void Function(String) validate;
  final AccountAsset dropdownValue;
  final List<AccountAsset>? availableDropdownAssets;

  @override
  PaymentSendAmountState createState() => PaymentSendAmountState();
}

class PaymentSendAmountState extends State<PaymentSendAmount> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final sendAssets = widget.availableDropdownAssets ??
            ref.watch(walletProvider).sendAssets();
        final showError =
            ref.watch(paymentProvider.select((p) => p.insufficientFunds));
        return TickerAmountTextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          showError: showError,
          availableAssets: sendAssets,
          onDropdownChanged: widget.onDropdownChanged,
          dropdownValue: widget.dropdownValue,
          showAccountsInPopup: true,
          onChanged: (value) {
            widget.validate(value);
            final newValue = replaceCharacterOnPosition(
              input: value,
            );

            if (widget.controller != null) {
              widget.controller!.value = fixCursorPosition(
                  controller: widget.controller!, newValue: newValue);
            }
          },
        );
      },
    );
  }
}
