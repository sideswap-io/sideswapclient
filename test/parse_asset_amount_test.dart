import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/models/wallet.dart';

void main() {
  final container = ProviderContainer();
  group('parse asset amount precision', () {
    test('precision: -1', () {
      expect(
          container.read(walletProvider).parseAssetAmount('0', precision: -1),
          equals(null));
    });

    test('precision: 0', () {
      expect(container.read(walletProvider).parseAssetAmount('0', precision: 0),
          equals(0));
    });

    test('precision: 8', () {
      expect(container.read(walletProvider).parseAssetAmount('0', precision: 8),
          equals(0));
    });

    test('precision: 9', () {
      expect(container.read(walletProvider).parseAssetAmount('0', precision: 9),
          equals(null));
    });
  });

  group(
    'parse asset amount',
    () {
      test('value: 0, precision: 0', () {
        const value = '0';
        const precision = 0;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(0));
      });

      test('value: 1, precision: 0', () {
        const value = '1';
        const precision = 0;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(1));
      });

      test('value: 1.0, precision: 0', () {
        const value = '1.0';
        const precision = 0;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(1));
      });

      test('value: 1.1, precision: 0', () {
        const value = '1.1';
        const precision = 0;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(null));
      });

      test('value: 1.00000001, precision: 0', () {
        const value = '1.00000001';
        const precision = 0;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(null));
      });

      test('value: 0, precision: 2', () {
        const value = '0';
        const precision = 2;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(0));
      });

      test('value: 1, precision: 2', () {
        const value = '1';
        const precision = 2;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(100));
      });

      test('value: 1.0, precision: 2', () {
        const value = '1.0';
        const precision = 2;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(100));
      });

      test('value: 1.1, precision: 2', () {
        const value = '1.1';
        const precision = 2;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(110));
      });

      test('value: 1.01, precision: 2', () {
        const value = '1.01';
        const precision = 2;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(101));
      });

      test('value: 1.00000001, precision: 2', () {
        const value = '1.00000001';
        const precision = 2;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(null));
      });

      test('value: 0, precision: 8', () {
        const value = '0';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(0));
      });

      test('value: 1, precision: 8', () {
        const value = '1';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(100000000));
      });

      test('value: 1.0, precision: 8', () {
        const value = '1.0';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(100000000));
      });

      test('value: 1.1, precision: 8', () {
        const value = '1.1';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(110000000));
      });

      test('value: 1.01, precision: 8', () {
        const value = '1.01';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(101000000));
      });

      test('value: 1.00000001, precision: 8', () {
        const value = '1.00000001';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(100000001));
      });

      test('value: 1.001, precision: 8', () {
        const value = '1.001';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(100100000));
      });

      test('value: 1.0000000001, precision: 8', () {
        const value = '1.0000000001';
        const precision = 8;
        expect(
            container
                .read(walletProvider)
                .parseAssetAmount(value, precision: precision),
            equals(null));
      });
    },
  );
}
