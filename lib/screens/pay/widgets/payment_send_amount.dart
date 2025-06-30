import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/payment_provider.dart';
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
  final void Function(String)? onDropdownChanged;
  final void Function(String) validate;
  final String dropdownValue;
  final List<String>? availableDropdownAssets;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final showError = ref.watch(paymentInsufficientFundsNotifierProvider);

        return TickerAmountTextField(
          focusNode: focusNode,
          controller: controller,
          showError: showError,
          availableAssets: availableDropdownAssets ?? [],
          onDropdownChanged: onDropdownChanged,
          dropdownValue: dropdownValue,
          showAccountsInPopup: true,
          onChanged: (value) {
            validate(value);

            onChanged?.call(value);
          },
        );
      },
    );
  }
}
