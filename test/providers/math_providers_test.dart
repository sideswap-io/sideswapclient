import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/math_providers.dart';

void main() {
  group('mathHelperProvider', () {
    test('returns a MathHelper instance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final helper = container.read(mathHelperProvider);

      expect(helper, isA<MathHelper>());
    });

    test('returns new instance on each read', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final helper1 = container.read(mathHelperProvider);
      // Invalidate to force a new instance
      container.invalidate(mathHelperProvider);
      final helper2 = container.read(mathHelperProvider);

      expect(identical(helper1, helper2), false);
    });
  });

  group('MathHelper.mapRange', () {
    late MathHelper sut;

    setUp(() {
      sut = MathHelper();
    });

    test('maps value from input range to output range correctly', () {
      // Map 5 from [0, 10] to [0, 100]
      final result = sut.mapRange(5, 0, 10, 0, 100);

      expect(result, Decimal.parse('50'));
    });

    test('handles negative input range', () {
      // Map 0 from [-10, 10] to [0, 100]
      // (0 - (-10)) * (100 - 0) / (10 - (-10)) + 0 = 10 * 100 / 20 = 50
      final result = sut.mapRange(0, -10, 10, 0, 100);

      expect(result, Decimal.parse('50'));
    });

    test('handles negative output range', () {
      // Map 5 from [0, 10] to [-100, 0]
      // (5 - 0) * (0 - (-100)) / (10 - 0) + (-100) = 5 * 100 / 10 - 100 = -50
      final result = sut.mapRange(5, 0, 10, -100, 0);

      expect(result, Decimal.parse('-50'));
    });

    test('handles both negative ranges', () {
      // Map -5 from [-10, 10] to [-100, 0]
      // (-5 - (-10)) * (0 - (-100)) / (10 - (-10)) + (-100) = 5 * 100 / 20 - 100 = -75
      final result = sut.mapRange(-5, -10, 10, -100, 0);

      expect(result, Decimal.parse('-75'));
    });

    test('returns Decimal.zero when input range is zero (division by zero)', () {
      final result = sut.mapRange(5, 10, 10, 0, 100);

      expect(result, Decimal.zero);
    });

    test('handles floating point input values', () {
      // Map 2.5 from [0, 10] to [0, 100]
      final result = sut.mapRange(2.5, 0, 10, 0, 100);

      expect(result, Decimal.parse('25'));
    });

    test('handles floating point input range', () {
      // Map 0.5 from [0, 1] to [0, 100]
      final result = sut.mapRange(0.5, 0, 1, 0, 100);

      expect(result, Decimal.parse('50'));
    });

    test('handles floating point output range', () {
      // Map 5 from [0, 10] to [0, 1]
      final result = sut.mapRange(5, 0, 10, 0, 1);

      expect(result, Decimal.parse('0.5'));
    });

    test('maps minimum input value to minimum output value', () {
      final result = sut.mapRange(0, 0, 10, 100, 200);

      expect(result, Decimal.parse('100'));
    });

    test('maps maximum input value to maximum output value', () {
      final result = sut.mapRange(10, 0, 10, 100, 200);

      expect(result, Decimal.parse('200'));
    });

    test('handles inverted output range (outMin > outMax)', () {
      // Map 5 from [0, 10] to [100, 0]
      // (5 - 0) * (0 - 100) / (10 - 0) + 100 = 5 * (-100) / 10 + 100 = -50 + 100 = 50
      final result = sut.mapRange(5, 0, 10, 100, 0);

      expect(result, Decimal.parse('50'));
    });

    test('handles input value at midpoint of inverted range', () {
      // Map 0 from [-10, 10] to [100, 0]
      // (0 - (-10)) * (0 - 100) / (10 - (-10)) + 100 = 10 * (-100) / 20 + 100 = -50 + 100 = 50
      final result = sut.mapRange(0, -10, 10, 100, 0);

      expect(result, Decimal.parse('50'));
    });

    test('handles value outside input range (below)', () {
      final result = sut.mapRange(-5, 0, 10, 0, 100);

      expect(result, Decimal.parse('-50'));
    });

    test('handles value outside input range (above)', () {
      final result = sut.mapRange(15, 0, 10, 0, 100);

      expect(result, Decimal.parse('150'));
    });

    test('handles very small output range', () {
      final result = sut.mapRange(5, 0, 10, 0, 0.01);

      expect(result, Decimal.parse('0.005'));
    });

    test('handles very large numbers', () {
      final result = sut.mapRange(500000, 0, 1000000, 0, 1000000000);

      expect(result, Decimal.parse('500000000'));
    });

    test('handles fractional input/output values', () {
      // Map 0.75 from [0, 1] to [0, 0.1]
      final result = sut.mapRange(0.75, 0, 1, 0, 0.1);

      // Due to floating point precision, compare with tolerance
      expect(
        (result - Decimal.parse('0.075')).abs() < Decimal.parse('0.0001'),
        true,
      );
    });
  });
}
