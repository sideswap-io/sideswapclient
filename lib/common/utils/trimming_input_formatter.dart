import 'package:flutter/services.dart';

class TrimmingTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.trim(),
      selection: TextSelection.collapsed(offset: newValue.text.trim().length),
    );
  }
}
