import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/common/utils/number_spaced_formatter.dart';

class AmountTextField extends ConsumerWidget {
  const AmountTextField({
    this.controller,
    this.focusNode,
    this.precision = 8,
    this.disabledAmount = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int precision;
  final bool disabledAmount;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: disabledAmount,
      cursorColor: Colors.white,
      textAlign: TextAlign.end,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: textInputAction,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: disabledAmount ? null : '0.00',
        hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
        ),
      ),
      inputFormatters: [
        CommaTextInputFormatter(),
        if (precision == 0) ...[
          FilteringTextInputFormatter.deny(RegExp('[\\-|,\\ .A-Za-z]')),
        ] else ...[
          FilteringTextInputFormatter.deny(RegExp('[\\-|,\\ ]A-Za-z')),
        ],
        DecimalTextInputFormatter(decimalRange: precision),
        NumberSpacedFormatter(),
      ],
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(color: Colors.white),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
    );
  }
}
