import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/locales_provider.dart';

part 'amount_to_string_provider.g.dart';

@riverpod
AmountToString amountToString(Ref ref) {
  final locale = ref.watch(localesNotifierProvider);
  return AmountToString(locale: locale);
}

class AmountToString {
  final String locale;

  AmountToString({required this.locale});

  String amountToString(AmountToStringParameters arg) {
    const int kCoin = 100000000;

    var sign = '';
    var amount = arg.amount;
    var forceSign = arg.forceSign;
    var precision = arg.precision;
    final formatterThousandsSeparator = NumberFormat("#,##0.00######", locale)
      ..maximumFractionDigits = arg.precision;

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
    final resultAmount = (newAmount / power).toDecimal();

    final resultAmountWithTrailingZeroes =
        arg.trailingZeroes
            ? resultAmount.toStringAsFixed(precision)
            : resultAmount.toString();
    final decimalTrailingZeroes =
        Decimal.tryParse(resultAmountWithTrailingZeroes) ?? Decimal.zero;

    final doubleTrailingZeroes = decimalTrailingZeroes.toDouble();
    final formatted = formatterThousandsSeparator.format(doubleTrailingZeroes);

    final resultAmountWithNumberFormatter =
        arg.useNumberFormatter ? formatted : resultAmountWithTrailingZeroes;

    return sign + resultAmountWithNumberFormatter;
  }

  String amountToStringNamed(AmountToStringNamedParameters arg) {
    final value = amountToString(
      AmountToStringParameters(
        amount: arg.amount,
        forceSign: arg.forceSign,
        precision: arg.precision,
        useNumberFormatter: arg.useNumberFormatter,
      ),
    );
    return '$value ${arg.ticker}';
  }

  ///
  /// truncate amount to it's precision
  /// if amount is integer, return it with one digit after the decimal point (1 => 1.0)
  /// if amount scale <=4 truncate it to this scale and display at least with one digit after the decimal point (1.003 => 1.003, 1 => 1.0)
  /// if amount scale > 4 truncate it to scale 4, if still is there a fraction then truncate it to existing scale (1.0100001 => 1.01)
  /// if amount contains integer and decimal truncate it to scale 4 and then truncate it again in `toString` (1.01 => 1.01, 1 => 1.0)
  /// if amount is only decimal part then truncate it via toString (0.000008 => 0.000008, 0.1000 => 0.1)
  String amountToMobileFormatted({
    required Decimal amount,
    required int precision,
    bool forceScaleWithInteger = true,
  }) {
    if (amount.scale > precision) {
      amount = amount.truncate(scale: precision);
    }

    if (amount.isInteger) {
      final amountTruncated = amount.truncate(scale: 1);
      final amountAsString = amountTruncated.toStringAsFixed(1);
      return amountAsString;
    }

    if (amount.scale <= 4) {
      final amountTruncated = amount.truncate(scale: amount.scale);
      final amountAsString = amountTruncated.toStringAsFixed(
        amount.scale == 0 ? 1 : amount.scale,
      );
      return amountAsString;
    }

    if (forceScaleWithInteger) {
      var integerPart = amount.truncate(scale: 0);
      if (integerPart > Decimal.zero) {
        final amountTruncated = amount.truncate(scale: 4);
        if (amountTruncated.isInteger) {
          return amountTruncated.toStringAsFixed(1);
        }

        integerPart = amountTruncated.truncate(scale: 0);
        if (integerPart > Decimal.zero) {
          final fraction = amountTruncated - integerPart;
          final fractionTruncated = fraction.truncate(scale: 4);
          final newScale =
              fractionTruncated > Decimal.zero ? amountTruncated.scale : 1;
          final amountAsString = amountTruncated.toStringAsFixed(newScale);
          return amountAsString;
        }
      }
    }

    return amount.toString();
  }
}
