import 'package:flutter/services.dart';
import 'package:sideswap/common/helpers.dart';

class NumberSpacedFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final changedValue = replaceCharacterOnPosition(
      input: newValue.text,
    );

    if (newValue.text.compareTo(oldValue.text) != 0) {
      final selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;

      final newSelection = changedValue.length - selectionIndexFromTheRight;

      return TextEditingValue(
        text: changedValue,
        selection: TextSelection.collapsed(
            offset: (newSelection >= 0) ? newSelection : 0),
      );
    }

    return TextEditingValue(
      text: changedValue,
      selection: TextSelection.collapsed(offset: changedValue.length),
    );
  }
}
