import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/amount_to_string_model.dart';

final amountToStringProvider =
    AutoDisposeProvider((ref) => AmountToString(ref: ref));

class AmountToString {
  Ref ref;

  AmountToString({
    required this.ref,
  });

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

// Can't be used with riverpod 2.2.0 because https://github.com/rrousselGit/riverpod/issues/1733 
// final amountToStringProviderFamily =
//     Provider.family.autoDispose<String, AmountToStringParameters>((ref, arg) {
//   final provider = ref.watch(amountToStringProvider);
//   return provider.amountToString(arg);
// });

// final amountToStringNamedProviderFamily =
//     AutoDisposeProviderFamily<String, AmountToStringNamedParameters>(
//         (ref, arg) {
//   final provider = ref.watch(amountToStringProvider);
//   return provider.amountToStringNamed(arg);
// });
