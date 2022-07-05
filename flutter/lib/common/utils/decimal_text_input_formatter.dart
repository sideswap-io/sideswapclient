import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';

// From https://stackoverflow.com/a/57496055
class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var truncated = newValue.text;
    var newSelection = newValue.selection;

    if (newValue.text.contains(',')) {
      truncated = newValue.text.replaceFirst(RegExp(','), '.');
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}

// From https://stackoverflow.com/a/54456978
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange});

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (decimalRange == 0) {
      return TextEditingValue(
        text: newValue.text,
        selection: newValue.selection,
        composing: TextRange.empty,
      );
    }

    if (newValue.text.isEmpty) {
      return newValue;
    }

    final decimalValue = Decimal.tryParse(newValue.text);
    if (decimalValue == null) {
      return oldValue;
    }

    var newSelection = newValue.selection;
    var truncated = newValue.text;

    var value = newValue.text;

    if (value.contains('.') &&
        value.substring(value.indexOf('.') + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == '.') {
      truncated = '0.';

      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class DecimalCutterTextInputFormatter extends TextInputFormatter {
  DecimalCutterTextInputFormatter(
      {this.decimalRange = 8,
      int range = 8,
      bool activatedNegativeValues = false}) {
    final dp = decimalRange > 0 ? '([.][0-9]{0,$decimalRange}){0,1}' : '';
    var number = '[0-9]*$dp';
    if (range > 0) {
      number = '([0-9]{0,$range})$dp';
    }

    if (activatedNegativeValues) {
      _exp = RegExp('^((((-){0,1})|((-){0,1}[0-9]$number))){0,1}\$');
    } else {
      _exp = RegExp('^($number){0,1}\$');
    }
  }

  late RegExp _exp;
  int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }

    final splitted = oldValue.text.split('.');
    if (splitted.length > 1) {
      if (splitted[1].length < decimalRange) {
        splitted[1] = splitted[1].substring(0, splitted[1].length);
      } else {
        splitted[1] = splitted[1].substring(0, decimalRange);
      }
      final changedText =
          decimalRange == 0 ? splitted[0] : '${splitted[0]}.${splitted[1]}';
      return TextEditingValue(
          text: changedText,
          selection: TextSelection.fromPosition(
              TextPosition(offset: changedText.length)));
    }
    return oldValue;
  }
}
