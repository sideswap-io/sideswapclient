import 'package:freezed_annotation/freezed_annotation.dart';

part 'amount_to_string_model.freezed.dart';

@freezed
sealed class AmountToStringParameters with _$AmountToStringParameters {
  factory AmountToStringParameters({
    required int amount,
    @Default(false) bool forceSign,
    @Default(8) int precision,
    @Default(true) bool trailingZeroes,
    @Default(false) bool useNumberFormatter,
  }) = _AmountToStringParameters;
}

@freezed
sealed class AmountToStringNamedParameters
    with _$AmountToStringNamedParameters {
  factory AmountToStringNamedParameters({
    required int amount,
    required String ticker,
    @Default(false) bool forceSign,
    @Default(8) int precision,
    @Default(true) bool trailingZeroes,
    @Default(false) bool useNumberFormatter,
  }) = _AmountToStringNamedParameters;
}
