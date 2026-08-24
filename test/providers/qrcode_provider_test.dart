import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/bip32_providers.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

class FakeQrCodeResultModel extends Fake implements QrCodeResultModel {}

class FakeOutputsReaderNotifier extends OutputsReaderNotifier {
  final Either<OutputsError, OutputsData> _outputsState;
  final bool decodeThrows;

  FakeOutputsReaderNotifier(this._outputsState, {this.decodeThrows = false});

  @override
  Either<OutputsError, OutputsData> build() => _outputsState;

  @override
  Future<bool> decodeJsonString(String jsonString) async {
    if (decodeThrows) throw Exception('JSON decode failed');
    state = _outputsState;
    return true;
  }
}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });
  group('QrCodeResultModelNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('returns empty model on initialization', () {
        final state = container.read(qrCodeResultModelProvider);
        expect(state, isA<QrCodeResultModelEmpty>());
      });
    });

    group('setModel', () {
      test('updates state to provided model', () {
        final model = QrCodeResultModelData(
          result: QrCodeResult(address: 'test_addr'),
        );

        container.read(qrCodeResultModelProvider.notifier).setModel(model);

        expect(container.read(qrCodeResultModelProvider), model);
      });

      test('replaces previous state completely', () {
        final model1 = QrCodeResultModelData(
          result: QrCodeResult(address: 'addr1'),
        );
        final model2 = QrCodeResultModelData(
          result: QrCodeResult(address: 'addr2'),
        );

        container.read(qrCodeResultModelProvider.notifier).setModel(model1);
        expect(container.read(qrCodeResultModelProvider), model1);

        container.read(qrCodeResultModelProvider.notifier).setModel(model2);
        expect(container.read(qrCodeResultModelProvider), model2);
      });

      test('can set model to empty', () {
        final model = QrCodeResultModelData(
          result: QrCodeResult(address: 'test'),
        );
        container.read(qrCodeResultModelProvider.notifier).setModel(model);

        container
            .read(qrCodeResultModelProvider.notifier)
            .setModel(const QrCodeResultModelEmpty());

        expect(
          container.read(qrCodeResultModelProvider),
          isA<QrCodeResultModelEmpty>(),
        );
      });
    });

    group('state change notification', () {
      test('state changes after setModel', () {
        final initialState = container.read(qrCodeResultModelProvider);
        expect(initialState, isA<QrCodeResultModelEmpty>());

        final newModel = QrCodeResultModelData(
          result: QrCodeResult(address: 'new_addr'),
        );
        container.read(qrCodeResultModelProvider.notifier).setModel(newModel);

        final newState = container.read(qrCodeResultModelProvider);
        expect(newState, newModel);
      });
    });
  });

  group('qrcodeHelperProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    test('provides QrCodeHelper instance', () {
      final helper = container.read(qrcodeHelperProvider);
      expect(helper, isA<QrCodeHelper>());
    });

    test('provides same instance within same container', () {
      final helper1 = container.read(qrcodeHelperProvider);
      final helper2 = container.read(qrcodeHelperProvider);
      expect(identical(helper1, helper2), true);
    });
  });

  group('QrCodeHelper.parseDynamicQrCode', () {
    late ProviderContainer container;
    late QrCodeHelper helper;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          isAddrTypeValidProvider('bitcoin_valid_addr', AddrType.bitcoin)
              .overrideWithValue(true),
          isAddrTypeValidProvider('', AddrType.bitcoin).overrideWithValue(false),
          isAddrTypeValidProvider('elements_valid_addr', AddrType.elements)
              .overrideWithValue(true),
          isAddrTypeValidProvider('invalid_addr', AddrType.bitcoin)
              .overrideWithValue(false),
          isAddrTypeValidProvider('invalid_addr', AddrType.elements)
              .overrideWithValue(false),
          isAddrTypeValidProvider('sideswap:token?T=C;;;;0', AddrType.bitcoin)
              .overrideWithValue(false),
          isAddrTypeValidProvider('sideswap:token?T=C;;;;0', AddrType.elements)
              .overrideWithValue(false),
          isAddrTypeValidProvider('unknown://addr', AddrType.bitcoin)
              .overrideWithValue(false),
          isAddrTypeValidProvider('unknown://addr', AddrType.elements)
              .overrideWithValue(false),
          isAddrTypeValidProvider('bitcoin:myaddr', AddrType.bitcoin)
              .overrideWithValue(false),
          isAddrTypeValidProvider('bitcoin:myaddr', AddrType.elements)
              .overrideWithValue(false),
          isAddrTypeValidProvider('liquidnetwork:myaddr', AddrType.bitcoin)
              .overrideWithValue(false),
          isAddrTypeValidProvider('liquidnetwork:myaddr', AddrType.elements)
              .overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);
      helper = container.read(qrcodeHelperProvider);
    });

    group('empty QR code', () {
      test('returns error for empty string', () async {
        final result = await helper.parseDynamicQrCode('');

        result.match(
          (l) => fail('Should return Right with error'),
          (r) {
            expect(r.error, true);
            expect(r.errorMessage, isNotEmpty);
          },
        );
      });
    });

    group('static address recognition', () {
      test('recognizes valid bitcoin address', () async {
        final result = await helper.parseDynamicQrCode('bitcoin_valid_addr');

        result.match(
          (l) => fail('Should return Right'),
          (r) {
            expect(r.address, 'bitcoin_valid_addr');
            expect(r.addressType, BIP21AddressTypeEnum.bitcoin);
            expect(r.error, isNull);
          },
        );
      });

      test('recognizes valid elements address', () async {
        final result = await helper.parseDynamicQrCode('elements_valid_addr');

        result.match(
          (l) => fail('Should return Right'),
          (r) {
            expect(r.address, 'elements_valid_addr');
            expect(r.addressType, BIP21AddressTypeEnum.elements);
            expect(r.error, isNull);
          },
        );
      });
    });

    group('BIP21 parsing - bitcoin scheme', () {
      test('returns bitcoin address result for bitcoin: scheme', () async {
        final result = await helper.parseDynamicQrCode('bitcoin:myaddr');

        result.match(
          (l) => fail('Expected Right'),
          (r) {
            expect(r.address, 'myaddr');
            expect(r.addressType, BIP21AddressTypeEnum.bitcoin);
            expect(r.error, isNull);
          },
        );
      });

      test('returns Left when bitcoin parseBIP21 fails', () async {
        final container = ProviderContainer.test(
          overrides: [
            isAddrTypeValidProvider('bitcoin:myaddr', AddrType.bitcoin)
                .overrideWithValue(false),
            isAddrTypeValidProvider('bitcoin:myaddr', AddrType.elements)
                .overrideWithValue(false),
            parseBIP21Provider('bitcoin:myaddr', BIP21AddressTypeEnum.bitcoin)
                .overrideWithValue(Left(Exception('parse error'))),
          ],
        );
        addTearDown(container.dispose);
        final h = container.read(qrcodeHelperProvider);

        final result = await h.parseDynamicQrCode('bitcoin:myaddr');

        result.match(
          (l) => expect(l, isA<Exception>()),
          (r) => fail('Expected Left'),
        );
      });

      test('returns liquidnetwork address result for liquidnetwork: scheme', () async {
        final result = await helper.parseDynamicQrCode('liquidnetwork:myaddr');

        result.match(
          (l) => fail('Expected Right'),
          (r) {
            expect(r.address, 'myaddr');
            expect(r.addressType, BIP21AddressTypeEnum.liquidnetwork);
            expect(r.error, isNull);
          },
        );
      });

      test('returns Left when liquidnetwork parseBIP21 fails', () async {
        final container = ProviderContainer.test(
          overrides: [
            isAddrTypeValidProvider('liquidnetwork:myaddr', AddrType.bitcoin)
                .overrideWithValue(false),
            isAddrTypeValidProvider('liquidnetwork:myaddr', AddrType.elements)
                .overrideWithValue(false),
            parseBIP21Provider(
              'liquidnetwork:myaddr',
              BIP21AddressTypeEnum.liquidnetwork,
            ).overrideWithValue(Left(Exception('parse error'))),
          ],
        );
        addTearDown(container.dispose);
        final h = container.read(qrcodeHelperProvider);

        final result = await h.parseDynamicQrCode('liquidnetwork:myaddr');

        result.match(
          (l) => expect(l, isA<Exception>()),
          (r) => fail('Expected Left'),
        );
      });
    });

    group('SideSwap custom scheme parsing', () {
      test('routes sideswap: scheme to parseSideSwapAddress', () async {
        final result = await helper.parseDynamicQrCode('sideswap:token?T=C;;;;0');

        result.match(
          (l) => fail('Expected Right'),
          (r) => expect(r.error, isNull),
        );
      });
    });

    group('invalid QR code handling', () {
      test('returns error for unknown scheme', () async {
        final result = await helper.parseDynamicQrCode('unknown://addr');

        result.match(
          (l) => fail('Expected Right with error'),
          (r) => expect(r.error, true),
        );
      });
    });

    group('JSON fallback path (outer try throws → falls to JSON decode)', () {
      const testUrl = 'bitcoin:throwtest';

      ProviderContainer makeContainer({
        required Either<OutputsError, OutputsData> outputsState,
        bool decodeThrows = false,
      }) =>
          ProviderContainer.test(
            overrides: [
              isAddrTypeValidProvider(testUrl, AddrType.bitcoin)
                  .overrideWithValue(false),
              isAddrTypeValidProvider(testUrl, AddrType.elements)
                  .overrideWithValue(false),
              parseBIP21Provider(testUrl, BIP21AddressTypeEnum.bitcoin)
                  .overrideWith((ref) => throw Exception('forced')),
              outputsReaderProvider.overrideWith(
                () => FakeOutputsReaderNotifier(outputsState,
                    decodeThrows: decodeThrows),
              ),
            ],
          );

      test('returns error when JSON decode throws', () async {
        final container = makeContainer(
          outputsState: const Left(OutputsErrorOutputsDataIsEmpty()),
          decodeThrows: true,
        );
        addTearDown(container.dispose);

        final result =
            await container.read(qrcodeHelperProvider).parseDynamicQrCode(testUrl);

        result.match(
          (l) => fail('Expected Right with error'),
          (r) => expect(r.error, true),
        );
      });

      test('returns error result when JSON decode returns Left', () async {
        final container = makeContainer(
          outputsState: const Left(OutputsErrorWrongTypeOfFile('bad')),
        );
        addTearDown(container.dispose);

        final result =
            await container.read(qrcodeHelperProvider).parseDynamicQrCode(testUrl);

        result.match(
          (l) => fail('Expected Right'),
          (r) => expect(r.error, true),
        );
      });

      test('returns outputs result when JSON decode returns Right', () async {
        final container = makeContainer(
          outputsState: Right(const OutputsData()),
        );
        addTearDown(container.dispose);

        final result =
            await container.read(qrcodeHelperProvider).parseDynamicQrCode(testUrl);

        result.match(
          (l) => fail('Expected Right'),
          (r) => expect(r.outputsData, isNotNull),
        );
      });
    });
  });

  group('QrCodeHelper.parseSideSwapAddress', () {
    late ProviderContainer container;
    late QrCodeHelper helper;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      helper = container.read(qrcodeHelperProvider);
    });

    String makeQr({
      required String address,
      required String type,
      String amount = '',
      String ticker = '',
      String message = '',
      String bitMask = '0',
    }) =>
        'sideswap:$address?T=$type;$amount;$ticker;$message;$bitMask';

    test('returns populated result for valid merchant QR', () {
      final encoded = base64Encode(utf8.encode('Payment'));
      final qr = makeQr(
        address: 'mytoken',
        type: 'M',
        amount: '100.0',
        ticker: 'L-BTC',
        message: encoded,
        bitMask: '3',
      );

      final result = helper.parseSideSwapAddress(qr);

      result.match(
        (l) => fail('Expected Right'),
        (r) {
          expect(r.address, 'mytoken');
          expect(r.addressType, BIP21AddressTypeEnum.other);
          expect(r.type, QrCodeResultType.merchant);
          expect(r.amount, 100.0);
          expect(r.ticker, 'L-BTC');
          expect(r.message, 'Payment');
          expect(r.bitMask, 3);
          expect(r.error, isNull);
        },
      );
    });

    test('returns client type for C flag', () {
      final qr = makeQr(address: 'token', type: 'C');

      final result = helper.parseSideSwapAddress(qr);

      result.match(
        (l) => fail('Expected Right'),
        (r) => expect(r.type, QrCodeResultType.client),
      );
    });

    test('returns null amount when field is empty', () {
      final qr = makeQr(address: 'token', type: 'C');

      final result = helper.parseSideSwapAddress(qr);

      result.match(
        (l) => fail('Expected Right'),
        (r) => expect(r.amount, isNull),
      );
    });

    test('returns null ticker when field is empty', () {
      final qr = makeQr(address: 'token', type: 'M');

      final result = helper.parseSideSwapAddress(qr);

      result.match(
        (l) => fail('Expected Right'),
        (r) => expect(r.ticker, isNull),
      );
    });

    test('returns error for empty query params', () {
      final result = helper.parseSideSwapAddress('sideswap:token');

      result.match(
        (l) => fail('Expected Right with error'),
        (r) => expect(r.error, true),
      );
    });

    test('returns error for empty address path', () {
      final result = helper.parseSideSwapAddress('sideswap:?T=M;;;0');

      result.match(
        (l) => fail('Expected Right with error'),
        (r) => expect(r.error, true),
      );
    });

    test('returns error when T parameter is missing', () {
      final result = helper.parseSideSwapAddress('sideswap:token?other=x');

      result.match(
        (l) => fail('Expected Right with error'),
        (r) => expect(r.error, true),
      );
    });

    test('returns error when T has fewer than 5 fields', () {
      final result = helper.parseSideSwapAddress('sideswap:token?T=M;100;L-BTC');

      result.match(
        (l) => fail('Expected Right with error'),
        (r) => expect(r.error, true),
      );
    });

    test('returns error for invalid type flag', () {
      // makeQr generates 5 fields: type;amount;ticker;message;bitMask
      final result = helper.parseSideSwapAddress(
        makeQr(address: 'token', type: 'X'),
      );

      result.match(
        (l) => fail('Expected Right with error'),
        (r) => expect(r.error, true),
      );
    });

    test('returns error for invalid base64 message', () {
      final result = helper.parseSideSwapAddress(
        'sideswap:token?T=M;;L-BTC;invalid!!!;0',
      );

      result.match(
        (l) => fail('Expected Right with error'),
        (r) => expect(r.error, true),
      );
    });
  });

  group('QrCodeHelper.createDynamicQrCodeUrl', () {
    late ProviderContainer container;
    late QrCodeHelper helper;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
      helper = container.read(qrcodeHelperProvider);
    });

    test('creates URL with merchant type and required fields', () {
      final url = helper.createDynamicQrCodeUrl(
        address: 'merchant_token',
        type: QrCodeResultType.merchant,
        amount: 100.0,
        asset: 'L-BTC',
        message: 'Payment',
        bitMask: 0,
      );

      expect(url, startsWith('sideswap:merchant_token?T=M;'));
      expect(url, contains('100'));
      expect(url, contains('L-BTC'));
    });

    test('creates URL with client type', () {
      final url = helper.createDynamicQrCodeUrl(
        address: 'client_addr',
        type: QrCodeResultType.client,
      );

      expect(url, contains('?T=C;'));
    });

    test('defaults to client type when not specified', () {
      final url = helper.createDynamicQrCodeUrl(address: 'addr');

      expect(url, contains('?T=C;'));
    });

    test('encodes message as base64', () {
      const message = 'Test Message';
      final expectedEncoded = base64Encode(utf8.encode(message));

      final url = helper.createDynamicQrCodeUrl(
        address: 'addr',
        message: message,
      );

      expect(url, contains(expectedEncoded));
    });

    test('handles null amount as empty string', () {
      final url = helper.createDynamicQrCodeUrl(address: 'addr');

      expect(url, contains(';'));
      final parts = url.split(';');
      expect(parts[1], isEmpty);
    });

    test('handles null asset as empty string', () {
      final url = helper.createDynamicQrCodeUrl(address: 'addr');

      final parts = url.split(';');
      expect(parts[2], isEmpty);
    });

    test('handles null message as empty string', () {
      final url = helper.createDynamicQrCodeUrl(address: 'addr');

      final parts = url.split(';');
      expect(parts[3], isEmpty);
    });

    test('includes bitMask with default value', () {
      final url = helper.createDynamicQrCodeUrl(address: 'addr');

      expect(url, contains(';0'));
    });

    test('creates valid SideSwap URL with all parameters', () {
      const address = 'my_token';
      const message = 'Custom message';
      const asset = 'USDt';
      const amount = 50.5;
      const bitMask = 1;

      final url = helper.createDynamicQrCodeUrl(
        address: address,
        type: QrCodeResultType.merchant,
        amount: amount,
        asset: asset,
        message: message,
        bitMask: bitMask,
      );

      expect(url, startsWith('sideswap:$address'));
      expect(url, contains('?T=M'));
      expect(url, contains('$amount'));
      expect(url, contains(asset));
      expect(url, contains(base64Encode(utf8.encode(message))));
      expect(url, contains('$bitMask'));
    });

    test('formats multiple semicolon-separated fields correctly', () {
      final url = helper.createDynamicQrCodeUrl(
        address: 'addr',
        amount: 123.45,
        asset: 'BTC',
        message: 'Msg',
        bitMask: 5,
      );

      final dataPart = url.split('?T=')[1];
      final fields = dataPart.split(';');

      expect(fields.length, 5);
      expect(fields[0], 'C');
      expect(fields[1], '123.45');
      expect(fields[2], 'BTC');
      expect(fields[4], '5');
    });
  });

  group('QrCodeResult', () {
    group('copyWith', () {
      late QrCodeResult original;

      setUp(() {
        original = QrCodeResult(
          address: 'addr123',
          addressType: BIP21AddressTypeEnum.bitcoin,
          amount: 1.5,
          ticker: 'BTC',
          message: 'Payment',
          label: 'Label',
          bitMask: 0,
          error: false,
          errorMessage: null,
          assetId: 'asset-1',
          outputsData: null,
        );
      });

      test('updates address when provided', () {
        final result = original.copyWith(address: 'newaddr');
        expect(result.address, 'newaddr');
        expect(result.amount, 1.5);
      });

      test('updates multiple fields at once', () {
        final result = original.copyWith(
          address: 'addr456',
          amount: 2.5,
          ticker: 'USDt',
        );
        expect(result.address, 'addr456');
        expect(result.amount, 2.5);
        expect(result.ticker, 'USDt');
        expect(result.message, 'Payment');
      });

      test('preserves unspecified fields', () {
        final result = original.copyWith(amount: 3.0);
        expect(result.amount, 3.0);
        expect(result.address, original.address);
        expect(result.ticker, original.ticker);
        expect(result.label, original.label);
      });

      test('returns new instance when no parameters provided', () {
        final result = original.copyWith();
        expect(result, original);
        expect(identical(result, original), false);
      });
    });

    group('equality and hashCode', () {
      test('two instances with same values are equal', () {
        final result1 = QrCodeResult(
          address: 'addr',
          amount: 1.5,
          ticker: 'BTC',
        );
        final result2 = QrCodeResult(
          address: 'addr',
          amount: 1.5,
          ticker: 'BTC',
        );

        expect(result1, result2);
      });

      test('instances with different addresses are not equal', () {
        final result1 = QrCodeResult(address: 'addr1');
        final result2 = QrCodeResult(address: 'addr2');

        expect(result1, isNot(result2));
      });

      test('hashCode is consistent for equal instances', () {
        final result1 = QrCodeResult(address: 'addr', amount: 1.5);
        final result2 = QrCodeResult(address: 'addr', amount: 1.5);

        expect(result1.hashCode, result2.hashCode);
      });

      test('hashCode differs for unequal instances', () {
        final result1 = QrCodeResult(address: 'addr1');
        final result2 = QrCodeResult(address: 'addr2');

        expect(result1.hashCode, isNot(result2.hashCode));
      });

      test('identical instance is equal to itself', () {
        final result = QrCodeResult(address: 'addr');
        expect(result, result);
      });
    });

    group('toString', () {
      test('produces readable string representation', () {
        final result = QrCodeResult(
          address: 'test_addr',
          amount: 1.5,
          ticker: 'BTC',
        );

        final str = result.toString();
        expect(str, contains('QrCodeResult'));
        expect(str, contains('address: test_addr'));
        expect(str, contains('amount: 1.5'));
        expect(str, contains('ticker: BTC'));
      });

      test('handles all null fields gracefully', () {
        final result = QrCodeResult();
        final str = result.toString();

        expect(str, isNotEmpty);
        expect(str, contains('QrCodeResult'));
      });
    });
  });

  group('QrCodeResultType enum', () {
    test('has merchant value', () {
      expect(QrCodeResultType.merchant, isA<QrCodeResultType>());
    });

    test('has client value', () {
      expect(QrCodeResultType.client, isA<QrCodeResultType>());
    });

    test('merchant and client are different', () {
      expect(
        QrCodeResultType.merchant == QrCodeResultType.client,
        false,
      );
    });
  });
}
