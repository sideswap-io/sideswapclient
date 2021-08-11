import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/widgets/ticker_amount_textfield.dart';

class PaymentSendAmount extends StatefulWidget {
  const PaymentSendAmount({
    Key? key,
    this.controller,
    required this.focusNode,
    this.onDropdownChanged,
    required this.dropdownValue,
    required this.validate,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode focusNode;
  final void Function(String)? onDropdownChanged;
  final void Function(String) validate;
  final String dropdownValue;

  @override
  _PaymentSendAmountState createState() => _PaymentSendAmountState();
}

class _PaymentSendAmountState extends State<PaymentSendAmount> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final sendAssets = watch(walletProvider).sendAssets();
        return TickerAmountTextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          showError: watch(paymentProvider).insufficientFunds,
          availableAssets: sendAssets,
          onDropdownChanged: widget.onDropdownChanged,
          dropdownValue: widget.dropdownValue,
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
