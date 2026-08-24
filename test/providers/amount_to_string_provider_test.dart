import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';

import '../utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('amountToStringProvider', () {
    test('emits AmountToString and rebuilds when locale changes', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(localesProvider.notifier).setSelectedLang('en_US');

      final listener = ProviderListener<AmountToString>();
      container.listen(
        amountToStringProvider,
        listener.call,
        fireImmediately: true,
      );

      final initial = container.read(amountToStringProvider);
      verify(() => listener(null, initial)).called(1);
      expect(initial.locale, 'en_US');

      container.read(localesProvider.notifier).setSelectedLang('pl');

      final updated = container.read(amountToStringProvider);
      expect(updated.locale, 'pl');
    });
  });

  group('AmountToString', () {
    late AmountToString amountToString;
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      container.read(localesProvider.notifier).setSelectedLang('en_US');
      amountToString = container.read(amountToStringProvider);
    });

    group('amountToString', () {
      test('returns formatted amount with default parameters', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(amount: 123456789, precision: 2),
        );
        expect(result, '1234567.89');
      });

      test('returns formatted amount with trailing zeroes', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(
            amount: 123456789,
            precision: 4,
            trailingZeroes: true,
          ),
        );
        expect(result, '12345.6789');
      });

      test('returns formatted amount without trailing zeroes', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(
            amount: 1234567890,
            precision: 4,
            trailingZeroes: false,
          ),
        );
        expect(result, '123456.789');
      });

      test('emits negative sign when amount is below zero', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(amount: -123456789, precision: 2),
        );
        expect(result, '-1234567.89');
      });

      test('emits plus sign when forceSign is true and amount is positive', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(
            amount: 123456789,
            precision: 2,
            forceSign: true,
          ),
        );
        expect(result, '+1234567.89');
      });

      test('returns integer string when precision is zero', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(amount: 123456789, precision: 0),
        );
        expect(result, '123456789');
      });

      test('uses number formatter with scale conversion for large amounts', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(
            amount: 123456789000,
            precision: 2,
            useNumberFormatter: true,
          ),
        );
        expect(result, '1234567890.00');
      });

      test(
        'uses number formatter with scale conversion for amounts with fraction',
        () {
          final result = amountToString.amountToString(
            AmountToStringParameters(
              amount: 123456789123,
              precision: 2,
              useNumberFormatter: true,
            ),
          );
          expect(result, '1234567891.23');
        },
      );

      test('formats zero amount correctly', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(amount: 0, precision: 2),
        );
        expect(result, '0.00');
      });

      test('formats amount with precision 8', () {
        final result = amountToString.amountToString(
          AmountToStringParameters(amount: 123456789, precision: 8),
        );
        expect(result, '1.23456789');
      });
    });

    group('amountToStringNamed', () {
      test('appends ticker to formatted amount', () {
        final result = amountToString.amountToStringNamed(
          AmountToStringNamedParameters(
            amount: 123456789,
            precision: 2,
            ticker: 'BTC',
          ),
        );
        expect(result, '1234567.89 BTC');
      });
    });

    group('amountToMobileFormatted', () {
      test('returns integer with one decimal place when amount is integer', () {
        expect(
          amountToString.amountToMobileFormatted(
            amount: Decimal.one,
            precision: 8,
          ),
          '1.0',
        );
      });

      test('truncates to scale when scale <= 4', () {
        expect(
          amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.003'),
            precision: 8,
          ),
          '1.003',
        );
      });

      test('truncates to specified precision when scale > precision', () {
        expect(
          amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.123456789'),
            precision: 4,
          ),
          '1.1234',
        );
      });

      test('returns toString when only decimal part and scale > 4', () {
        expect(
          amountToString.amountToMobileFormatted(
            amount: Decimal.parse('0.000008'),
            precision: 8,
          ),
          '0.000008',
        );
      });

      test(
        'truncates to scale 4 when integer part and forceScaleWithInteger true',
        () {
          expect(
            amountToString.amountToMobileFormatted(
              amount: Decimal.parse('1.000008'),
              precision: 8,
              forceScaleWithInteger: true,
            ),
            '1.0',
          );
        },
      );

      test(
        'returns scale 4 truncated when integer part has fraction after truncation',
        () {
          expect(
            amountToString.amountToMobileFormatted(
              amount: Decimal.parse('1.010008'),
              precision: 8,
              forceScaleWithInteger: true,
            ),
            '1.01',
          );
        },
      );

      test('uses fractionTruncated > 0 branch for newScale', () {
        expect(
          amountToString.amountToMobileFormatted(
            amount: Decimal.parse('1.0100001'),
            precision: 8,
            forceScaleWithInteger: true,
          ),
          '1.01',
        );
      });

      test(
        'returns full precision when forceScaleWithInteger false and scale > 4',
        () {
          expect(
            amountToString.amountToMobileFormatted(
              amount: Decimal.parse('1.000008'),
              precision: 8,
              forceScaleWithInteger: false,
            ),
            '1.000008',
          );
        },
      );

      test(
        'returns toString when forceScaleWithInteger true but no integer part',
        () {
          expect(
            amountToString.amountToMobileFormatted(
              amount: Decimal.parse('0.00000008'),
              precision: 8,
              forceScaleWithInteger: true,
            ),
            '0.00000008',
          );
        },
      );
    });

    group('indexPriceFormatted', () {
      test('truncates amount to scale from scaleForAmount', () {
        expect(
          amountToString.indexPriceFormatted(Decimal.parse('1234.56789'), 8),
          '1234.56',
        );
      });

      test('returns truncated string without trailing zeroes', () {
        expect(
          amountToString.indexPriceFormatted(Decimal.parse('100.100'), 2),
          '100.1',
        );
      });
    });

    group('scaleForAmount', () {
      final cases = [
        (name: '', amount: Decimal.fromInt(1001), precision: 8, expected: 2),
        (name: '', amount: Decimal.fromInt(101), precision: 8, expected: 3),
        (name: '', amount: Decimal.fromInt(11), precision: 8, expected: 4),
        (name: '', amount: Decimal.parse('1.1'), precision: 8, expected: 5),
        (
          name: 'returns assetPrecision at exact threshold boundary: ',
          amount: Decimal.fromInt(1001),
          precision: 2,
          expected: 2,
        ),
        (
          name: 'returns assetPrecision at exact threshold boundary: ',
          amount: Decimal.fromInt(101),
          precision: 3,
          expected: 3,
        ),
        (
          name: 'returns assetPrecision at exact threshold boundary: ',
          amount: Decimal.fromInt(11),
          precision: 4,
          expected: 4,
        ),
        (
          name: 'returns assetPrecision at exact threshold boundary: ',
          amount: Decimal.parse('1.1'),
          precision: 5,
          expected: 5,
        ),
        (name: '', amount: Decimal.zero, precision: 8, expected: 8),
        (name: '', amount: Decimal.parse('0.5'), precision: 8, expected: 8),
      ];

      for (final c in cases) {
        test(
          '${c.name}scaleForAmount returns ${c.expected} for amount ${c.amount} precision ${c.precision}',
          () {
            expect(
              amountToString.scaleForAmount(c.amount, c.precision),
              c.expected,
            );
          },
        );
      }
    });
  });
}
