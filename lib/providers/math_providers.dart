import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'math_providers.g.dart';

@riverpod
MathHelper mathHelper(Ref ref) {
  return MathHelper();
}

class MathHelper {
  Decimal mapRange(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    return Decimal.tryParse(
          ((value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin)
              .toString(),
        ) ??
        Decimal.zero;
  }
}
