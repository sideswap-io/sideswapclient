import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';

import '../utils.dart';

void main() {
  group('AmountToString', () {
    late AmountToString amountToString;
    late ProviderContainer ref;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      ref = createContainer(
        overrides: [
          localesNotifierProvider.overrideWith(LocalesNotifierMock.new),
        ],
      );
      final localesNotifier = ref.read(localesNotifierProvider.notifier);
      localesNotifier.state = 'en_US';

      amountToString = ref.read(amountToStringProvider);
    });

    group('amountToString', () {
      test('should format amount correctly with default parameters', () {
        final params = AmountToStringParameters(
          amount: 123456789,
          precision: 2,
        );
        final result = amountToString.amountToString(params);
        expect(result, '1234567.89');
      });

      test('should format amount correctly with trailing zeroes', () {
        final params = AmountToStringParameters(
          amount: 123456789,
          precision: 4,
          trailingZeroes: true,
        );
        final result = amountToString.amountToString(params);
        expect(result, '12345.6789');
      });

      test('should format amount correctly without trailing zeroes', () {
        final params = AmountToStringParameters(
          amount: 1234567890,
          precision: 4,
          trailingZeroes: false,
        );
        final result = amountToString.amountToString(params);
        expect(result, '123456.789');
      });

      test('should format negative amount correctly', () {
        final params = AmountToStringParameters(
          amount: -123456789,
          precision: 2,
        );
        final result = amountToString.amountToString(params);
        expect(result, '-1234567.89');
      });

      test('should format positive amount with force sign', () {
        final params = AmountToStringParameters(
          amount: 123456789,
          precision: 2,
          forceSign: true,
        );
        final result = amountToString.amountToString(params);
        expect(result, '+1234567.89');
      });

      test('should format zero amount correctly', () {
        final params = AmountToStringParameters(amount: 0, precision: 2);
        final result = amountToString.amountToString(params);
        expect(result, '0.00');
      });

      test('should format amount with thousand separator', () {
        final params = AmountToStringParameters(
          amount: 123456789000,
          precision: 2,
          useNumberFormatter: true,
        );
        final result = amountToString.amountToString(params);
        expect(result, '1,234,567,890.00');
      });

      test('should format amount with thousand separator with fraction', () {
        final params = AmountToStringParameters(
          amount: 123456789123,
          precision: 2,
          useNumberFormatter: true,
        );
        final result = amountToString.amountToString(params);
        expect(result, '1,234,567,891.23');
      });

      test('should format amount correctly when precision is 0', () {
        final params = AmountToStringParameters(
          amount: 123456789,
          precision: 0,
        );
        final result = amountToString.amountToString(params);
        expect(result, '123456789');
      });

      test('should format amount correctly when precision is 8', () {
        final params = AmountToStringParameters(
          amount: 123456789,
          precision: 8,
        );
        final result = amountToString.amountToString(params);
        expect(result, '1.23456789');
      });
    });

    group('amountToStringNamed', () {
      test('should format amount with ticker', () {
        final params = AmountToStringNamedParameters(
          amount: 123456789,
          precision: 2,
          ticker: 'BTC',
        );
        final result = amountToString.amountToStringNamed(params);
        expect(result, '1234567.89 BTC');
      });
    });

    group('amountToMobileFormatted', () {
      test('should format integer amount with one decimal place', () {
        final result = amountToString.amountToMobileFormatted(
          amount: Decimal.one,
          precision: 8,
        );
        expect(result, '1.0');
      });

      test(
        'should truncate amount to its scale when scale is less than or equal to 4',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.003'),
            precision: 8,
          );
          expect(result, '1.003');
        },
      );

      test(
        'should display at least one digit after the decimal when scale is 0',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.0'),
            precision: 8,
          );
          expect(result, '1.0');
        },
      );

      test(
        'should display at least one digit after the decimal when scale is 0 and no integer',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('0.0'),
            precision: 8,
          );
          expect(result, '0.0');
        },
      );

      test('should truncate amount to scale 4 if contains integer part', () {
        final result = amountToString.amountToMobileFormatted(
          amount: Decimal.parse('1.000008'),
          precision: 8,
          forceScaleWithInteger: true,
        );
        expect(result, '1.0');
      });

      test(
        'should truncate amount to scale 4 if contains integer part or to truncated scale if truncated scale 4 has a fraction',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.010008'),
            precision: 8,
            forceScaleWithInteger: true,
          );
          expect(result, '1.01');
        },
      );

      test(
        'should truncate amount to scale 4 if contains integer part but if fraction is not 0 then use scale == precision',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.000008'),
            precision: 8,
            forceScaleWithInteger: false,
          );
          expect(result, '1.000008');
        },
      );

      test('should truncate amount via toString if only decimal', () {
        final result = amountToString.amountToMobileFormatted(
          amount: Decimal.parse('0.000008'),
          precision: 8,
        );
        expect(result, '0.000008');
      });

      test('should truncate amount to specified precision', () {
        final result = amountToString.amountToMobileFormatted(
          amount: Decimal.parse('1.123456789'),
          precision: 4,
        );
        expect(result, '1.1234');
      });

      test(
        'should truncate amount to scale 4 if contains integer part and scale > 4 and forceScaleWithInteger is true',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.00000008'),
            precision: 8,
            forceScaleWithInteger: true,
          );
          expect(result, '1.0');
        },
      );
      test(
        'should truncate amount to scale 8 if contains integer part and scale > 8 and forceScaleWithInteger is true',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.000000008'),
            precision: 8,
            forceScaleWithInteger: true,
          );
          expect(result, '1.0');
        },
      );

      test(
        'should not truncate if forceScaleWithInteger is true and there is no integer part',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('0.00000008'),
            precision: 8,
            forceScaleWithInteger: true,
          );
          expect(result, '0.00000008');
        },
      );
      test(
        'should truncate amount to scale == precision if contains integer part and scale > 4 and forceScaleWithInteger is false',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.00000008'),
            precision: 8,
            forceScaleWithInteger: false,
          );
          expect(result, '1.00000008');
        },
      );
      test(
        'should truncate amount to scale 8 if contains integer part and scale > 8 and forceScaleWithInteger is false',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.000000008'),
            precision: 8,
            forceScaleWithInteger: false,
          );
          expect(result, '1.0');
        },
      );
      test(
        'should not truncate if forceScaleWithInteger is false and there is no integer part',
        () {
          final result = amountToString.amountToMobileFormatted(
            amount: Decimal.parse('0.00000008'),
            precision: 8,
            forceScaleWithInteger: false,
          );
          expect(result, '0.00000008');
        },
      );
    });
  });
}
