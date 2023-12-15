import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/amount_to_string_model.dart';

part 'amount_to_string_provider.g.dart';

@riverpod
AmountToString amountToString(AmountToStringRef ref) {
  return AmountToString();
}

class AmountToString {
  String amountToString(AmountToStringParameters arg) {
    const int kCoin = 100000000;

    var sign = '';
    var amount = arg.amount;
    var forceSign = arg.forceSign;
    var precision = arg.precision;

    if (amount < 0) {
      sign = '-';
      amount = -amount;
    } else if (forceSign && amount > 0) {
      sign = '+';
    }
    final bitAmount = amount ~/ kCoin;
    final satAmount = amount % kCoin;
    final satAmountStr = satAmount.toString().padLeft(8, '0');
    final newAmount =
        Decimal.tryParse('$bitAmount$satAmountStr') ?? Decimal.zero;
    final power =
        Decimal.tryParse(pow(10, precision).toStringAsFixed(precision)) ??
            Decimal.zero;
    final amountWithPrecision = newAmount / power;
    if (precision == 0) {
      return sign + amountWithPrecision.toBigInt().toString();
    }
    return sign + (newAmount / power).toDecimal().toStringAsFixed(precision);
  }

  String amountToStringNamed(AmountToStringNamedParameters arg) {
    final value = amountToString(AmountToStringParameters(
        amount: arg.amount,
        forceSign: arg.forceSign,
        precision: arg.precision));
    return '$value ${arg.ticker}';
  }
}
