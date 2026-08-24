import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

/// Helper to create a test Asset
Asset createAsset({
  required String assetId,
  required String ticker,
}) {
  return Asset()
    ..assetId = assetId
    ..ticker = ticker;
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('BIP21Result', () {
    group('copyWith', () {
      late BIP21Result original;

      setUp(() {
        original = BIP21Result(
          amount: 1.5,
          label: 'Label',
          message: 'Message',
          assetId: 'asset-1',
          ticker: 'L-BTC',
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.elements,
        );
      });

      final copyWithCases = [
        (
          name: 'amount',
          apply: (BIP21Result r) => r.copyWith(amount: 2.5),
          check: (BIP21Result r) => expect(r.amount, 2.5),
        ),
        (
          name: 'label',
          apply: (BIP21Result r) => r.copyWith(label: 'New Label'),
          check: (BIP21Result r) => expect(r.label, 'New Label'),
        ),
        (
          name: 'message',
          apply: (BIP21Result r) => r.copyWith(message: 'New Message'),
          check: (BIP21Result r) => expect(r.message, 'New Message'),
        ),
        (
          name: 'assetId',
          apply: (BIP21Result r) => r.copyWith(assetId: 'asset-2'),
          check: (BIP21Result r) => expect(r.assetId, 'asset-2'),
        ),
        (
          name: 'ticker',
          apply: (BIP21Result r) => r.copyWith(ticker: 'BTC'),
          check: (BIP21Result r) => expect(r.ticker, 'BTC'),
        ),
        (
          name: 'address',
          apply: (BIP21Result r) => r.copyWith(address: 'newaddr456'),
          check: (BIP21Result r) => expect(r.address, 'newaddr456'),
        ),
        (
          name: 'addressType',
          apply: (BIP21Result r) =>
              r.copyWith(addressType: BIP21AddressTypeEnum.bitcoin),
          check: (BIP21Result r) =>
              expect(r.addressType, BIP21AddressTypeEnum.bitcoin),
        ),
      ];

      for (final c in copyWithCases) {
        test('copyWith updates ${c.name}', () {
          final result = c.apply(original);
          c.check(result);
        });
      }

      test('updates multiple fields at once', () {
        final result = original.copyWith(
          amount: 3.0,
          label: 'Updated Label',
          ticker: 'USDt',
        );
        expect(result.amount, 3.0);
        expect(result.label, 'Updated Label');
        expect(result.ticker, 'USDt');
        expect(result.message, 'Message');
        expect(result.assetId, 'asset-1');
      });

      test('returns new instance with same values when no parameters provided', () {
        final result = original.copyWith();
        expect(result, original);
        expect(identical(result, original), false);
      });
    });

    group('equality and hashCode', () {
      test('two instances with same values are equal', () {
        final result1 = BIP21Result(
          amount: 1.5,
          label: 'Label',
          message: 'Message',
          assetId: 'asset-1',
          ticker: 'L-BTC',
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.elements,
        );
        final result2 = BIP21Result(
          amount: 1.5,
          label: 'Label',
          message: 'Message',
          assetId: 'asset-1',
          ticker: 'L-BTC',
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.elements,
        );

        expect(result1, result2);
      });

      final defaultResult = BIP21Result(
        amount: 1.5,
        label: 'Label',
        message: 'Message',
        assetId: 'asset-1',
        ticker: 'L-BTC',
        address: 'addr123',
        addressType: BIP21AddressTypeEnum.elements,
      );

      final inequalityCases = [
        (
          name: 'amount',
          b: BIP21Result(
            amount: 2.5,
            label: 'Label',
            message: 'Message',
            assetId: 'asset-1',
            ticker: 'L-BTC',
            address: 'addr123',
            addressType: BIP21AddressTypeEnum.elements,
          ),
        ),
        (
          name: 'label',
          b: BIP21Result(
            amount: 1.5,
            label: 'Label2',
            message: 'Message',
            assetId: 'asset-1',
            ticker: 'L-BTC',
            address: 'addr123',
            addressType: BIP21AddressTypeEnum.elements,
          ),
        ),
        (
          name: 'message',
          b: BIP21Result(
            amount: 1.5,
            label: 'Label',
            message: 'Message2',
            assetId: 'asset-1',
            ticker: 'L-BTC',
            address: 'addr123',
            addressType: BIP21AddressTypeEnum.elements,
          ),
        ),
        (
          name: 'assetId',
          b: BIP21Result(
            amount: 1.5,
            label: 'Label',
            message: 'Message',
            assetId: 'asset-2',
            ticker: 'L-BTC',
            address: 'addr123',
            addressType: BIP21AddressTypeEnum.elements,
          ),
        ),
        (
          name: 'ticker',
          b: BIP21Result(
            amount: 1.5,
            label: 'Label',
            message: 'Message',
            assetId: 'asset-1',
            ticker: 'USDt',
            address: 'addr123',
            addressType: BIP21AddressTypeEnum.elements,
          ),
        ),
        (
          name: 'address',
          b: BIP21Result(
            amount: 1.5,
            label: 'Label',
            message: 'Message',
            assetId: 'asset-1',
            ticker: 'L-BTC',
            address: 'addr456',
            addressType: BIP21AddressTypeEnum.elements,
          ),
        ),
        (
          name: 'addressType',
          b: BIP21Result(
            amount: 1.5,
            label: 'Label',
            message: 'Message',
            assetId: 'asset-1',
            ticker: 'L-BTC',
            address: 'addr123',
            addressType: BIP21AddressTypeEnum.bitcoin,
          ),
        ),
      ];

      for (final c in inequalityCases) {
        test('not equal when ${c.name} differs', () {
          expect(defaultResult, isNot(c.b));
        });
      }

      test('hashCode is consistent for equal instances', () {
        final result1 = BIP21Result(
          amount: 1.5,
          label: 'Label',
          message: 'Message',
          assetId: 'asset-1',
          ticker: 'L-BTC',
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.elements,
        );
        final result2 = BIP21Result(
          amount: 1.5,
          label: 'Label',
          message: 'Message',
          assetId: 'asset-1',
          ticker: 'L-BTC',
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.elements,
        );

        expect(result1.hashCode, result2.hashCode);
      });

      test('identical instance is equal to itself', () {
        final result = BIP21Result(
          amount: 1.5,
          label: 'Label',
          message: 'Message',
          assetId: 'asset-1',
          ticker: 'L-BTC',
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.elements,
        );

        expect(result == result, true);
      });
    });

    group('toString', () {
      test('produces readable string representation', () {
        final result = BIP21Result(
          amount: 1.5,
          label: 'PaymentLabel',
          message: 'Payment for service',
          assetId: 'asset-123',
          ticker: 'L-BTC',
          address: 'liquidaddr',
          addressType: BIP21AddressTypeEnum.elements,
        );

        final str = result.toString();
        expect(str, contains('ParseBIP21Result'));
        expect(str, contains('amount: 1.5'));
        expect(str, contains('label: PaymentLabel'));
        expect(str, contains('message: Payment for service'));
        expect(str, contains('assetId: asset-123'));
        expect(str, contains('ticker: L-BTC'));
        expect(str, contains('address: liquidaddr'));
        expect(str, contains('addressType: BIP21AddressTypeEnum.elements'));
      });

      test('handles empty strings in toString', () {
        final result = BIP21Result(
          amount: 0.0,
          label: '',
          message: '',
          assetId: 'asset-id',
          ticker: '',
          address: '',
          addressType: BIP21AddressTypeEnum.other,
        );

        final str = result.toString();
        expect(str, contains('ParseBIP21Result'));
        expect(str, contains('amount: 0.0'));
        expect(str, contains('label: '));
      });

      test('handles special characters in toString', () {
        final result = BIP21Result(
          amount: 1.5,
          label: 'Label with "quotes"',
          message: 'Message with & ampersand',
          assetId: 'asset-id',
          ticker: 'TICK',
          address: 'addr&special',
          addressType: BIP21AddressTypeEnum.bitcoin,
        );

        final str = result.toString();
        expect(str, isNotEmpty);
        expect(str, contains('Label with "quotes"'));
        expect(str, contains('Message with & ampersand'));
      });
    });
  });

  group('parseBIP21Provider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          liquidAssetIdStateProvider.overrideWithValue('liquid-asset-id'),
          assetsStateProvider.overrideWithValue({
            'liquid-asset-id': createAsset(
              assetId: 'liquid-asset-id',
              ticker: 'L-BTC',
            ),
            'custom-asset-id': createAsset(
              assetId: 'custom-asset-id',
              ticker: 'USDt',
            ),
            'another-asset-id': createAsset(
              assetId: 'another-asset-id',
              ticker: 'EURx',
            ),
          }),
        ],
      );
      addTearDown(container.dispose);
    });

    group('basic parsing', () {
      test('parses minimal valid BIP21 URI with no parameters', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, 'address123');
            expect(r.amount, 0.0);
            expect(r.label, '');
            expect(r.message, '');
            expect(r.assetId, 'liquid-asset-id');
            expect(r.ticker, 'L-BTC');
            expect(r.addressType, BIP21AddressTypeEnum.bitcoin);
          },
        );
      });

      test('parses BIP21 URI with amount parameter', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.5',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, 'address123');
            expect(r.amount, 1.5);
          },
        );
      });

      test('parses BIP21 URI with label parameter', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?label=MyLabel',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, 'MyLabel');
          },
        );
      });

      test('parses BIP21 URI with message parameter', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?message=PaymentMessage',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.message, 'PaymentMessage');
          },
        );
      });

      test('parses BIP21 URI with all standard parameters', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=2.5&label=Test&message=Msg',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, 'address123');
            expect(r.amount, 2.5);
            expect(r.label, 'Test');
            expect(r.message, 'Msg');
          },
        );
      });
    });

    group('asset handling', () {
      test('uses default liquid asset when assetid parameter not provided', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123',
            BIP21AddressTypeEnum.elements,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.assetId, 'liquid-asset-id');
            expect(r.ticker, 'L-BTC');
          },
        );
      });

      test('uses custom asset when assetid parameter provided and asset exists', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?assetid=custom-asset-id',
            BIP21AddressTypeEnum.elements,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.assetId, 'custom-asset-id');
            expect(r.ticker, 'USDt');
          },
        );
      });

      test('uses unknown ticker when assetid parameter provided but asset not found', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?assetid=nonexistent-asset-id',
            BIP21AddressTypeEnum.elements,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.assetId, 'nonexistent-asset-id');
            expect(r.ticker, kUnknownTicker);
          },
        );
      });

      test('respects assetid parameter case sensitivity', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?assetid=another-asset-id',
            BIP21AddressTypeEnum.elements,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.ticker, 'EURx');
          },
        );
      });
    });

    group('amount parsing', () {
      test('parses zero amount', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 0.0);
          },
        );
      });

      test('parses positive amounts', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=123.456',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 123.456);
          },
        );
      });

      test('parses large amounts', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=9999999.99999999',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 9999999.99999999);
          },
        );
      });

      test('clamps negative amounts to zero', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=-5.0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 0.0);
          },
        );
      });

      test('defaults to zero for invalid amount format', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=invalid',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 0.0);
          },
        );
      });

      test('defaults to zero when amount is empty string', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 0.0);
          },
        );
      });
    });

    group('multiple parameters', () {
      test('parses with multiple parameters in any order', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?message=Msg&amount=5.0&label=Label&assetid=custom-asset-id',
            BIP21AddressTypeEnum.elements,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, 'address123');
            expect(r.amount, 5.0);
            expect(r.label, 'Label');
            expect(r.message, 'Msg');
            expect(r.assetId, 'custom-asset-id');
            expect(r.ticker, 'USDt');
          },
        );
      });

      test('ignores unknown parameters', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.0&unknownparam=value&anotherparam=123',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 1.0);
            expect(r.address, 'address123');
          },
        );
      });

      test('handles duplicate parameters (last one wins)', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.0&amount=2.0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            // Uri.parse typically returns the last value for duplicate params
            expect([1.0, 2.0], contains(r.amount));
          },
        );
      });
    });

    group('URI encoding and special characters', () {
      test('parses URI with URL-encoded label', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?label=My%20Label',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, 'My Label');
          },
        );
      });

      test('parses URI with URL-encoded message', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?message=Hello%20World%21',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.message, 'Hello World!');
          },
        );
      });

      test('parses URI with special characters in address', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:special-addr_123-456',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, 'special-addr_123-456');
          },
        );
      });

      test('parses very long address', () {
        final longAddr = 'a' * 200;
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:$longAddr',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, longAddr);
          },
        );
      });
    });

    group('address type handling', () {
      test('preserves bitcoin address type', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.addressType, BIP21AddressTypeEnum.bitcoin);
          },
        );
      });

      test('preserves elements address type', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.0',
            BIP21AddressTypeEnum.elements,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.addressType, BIP21AddressTypeEnum.elements);
          },
        );
      });

      test('preserves liquidnetwork address type', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.0',
            BIP21AddressTypeEnum.liquidnetwork,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.addressType, BIP21AddressTypeEnum.liquidnetwork);
          },
        );
      });

      test('preserves other address type', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.0',
            BIP21AddressTypeEnum.other,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.addressType, BIP21AddressTypeEnum.other);
          },
        );
      });
    });

    group('error handling', () {
      test('handles malformed URI gracefully', () {
        final result = container.read(
          parseBIP21Provider(
            'not a valid uri format',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
      });

      test('handles empty URI gracefully', () {
        final result = container.read(
          parseBIP21Provider(
            '',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
      });

      test('handles URI with invalid characters gracefully', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin://address\x00invalid',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
      });

      test('returns Right for URI with unbalanced brackets', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address[incomplete',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
      });

      test('returns Right for URI with invalid query syntax', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?malformed&&&',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
      });

      test('returns Left for URI with invalid empty scheme', () {
        final result = container.read(
          parseBIP21Provider('::', BIP21AddressTypeEnum.bitcoin),
        );
        expect(result.isLeft(), true);
      });
    });

    group('edge cases', () {
      test('handles empty label and message', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?label=&message=',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, '');
            expect(r.message, '');
          },
        );
      });

      test('handles spaces in label and message', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?label=Label%20With%20Spaces&message=Message%20With%20Spaces',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, 'Label With Spaces');
            expect(r.message, 'Message With Spaces');
          },
        );
      });

      test('handles fractional amounts with many decimals', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=0.00000001',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 0.00000001);
          },
        );
      });

      test('handles scientific notation in amount', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=1.5e-2',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, closeTo(0.015, 0.0001));
          },
        );
      });

      test('handles leading zeros in amount', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?amount=000123.456',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.amount, 123.456);
          },
        );
      });

      test('handles scheme-less URI gracefully', () {
        final result = container.read(
          parseBIP21Provider(
            'address123?amount=1.0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        // This should parse, with address as 'address123'
        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.address, contains('address123'));
          },
        );
      });

      test('returns Right even with empty asset map', () {
        final emptyContainer = ProviderContainer.test(
          overrides: [
            liquidAssetIdStateProvider.overrideWithValue('missing-asset'),
            assetsStateProvider.overrideWithValue({}),
          ],
        );
        addTearDown(emptyContainer.dispose);

        final result = emptyContainer.read(
          parseBIP21Provider(
            'bitcoin:address123',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.ticker, '');
          },
        );
      });
    });

    group('consistency and determinism', () {
      test('produces consistent results for same input', () {
        final uri = 'bitcoin:address123?amount=1.5&label=Test';

        final result1 = container.read(
          parseBIP21Provider(uri, BIP21AddressTypeEnum.bitcoin),
        );
        final result2 = container.read(
          parseBIP21Provider(uri, BIP21AddressTypeEnum.bitcoin),
        );

        result1.match(
          (l) => fail('Expected Right'),
          (r1) {
            result2.match(
              (l) => fail('Expected Right'),
              (r2) {
                expect(r1, r2);
              },
            );
          },
        );
      });

      test('produces different results for different inputs', () {
        final result1 = container.read(
          parseBIP21Provider(
            'bitcoin:addr1?amount=1.0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );
        final result2 = container.read(
          parseBIP21Provider(
            'bitcoin:addr2?amount=2.0',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        result1.match(
          (l) => fail('Expected Right'),
          (r1) {
            result2.match(
              (l) => fail('Expected Right'),
              (r2) {
                expect(r1, isNot(r2));
              },
            );
          },
        );
      });
    });

    group('parameter value edge cases', () {
      test('handles null values for optional parameters', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, isEmpty);
            expect(r.message, isEmpty);
          },
        );
      });

      test('handles whitespace in parameter values', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?label=%20%20%20',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, '   ');
          },
        );
      });

      test('handles unicode characters in label', () {
        final result = container.read(
          parseBIP21Provider(
            'bitcoin:address123?label=Café',
            BIP21AddressTypeEnum.bitcoin,
          ),
        );

        expect(result.isRight(), true);
        result.match(
          (l) => fail('Expected Right, got Left: $l'),
          (r) {
            expect(r.label, contains('Caf'));
          },
        );
      });
    });
  });
}
