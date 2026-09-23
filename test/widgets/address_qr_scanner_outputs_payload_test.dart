import 'dart:async';
import 'dart:convert';
import 'dart:io';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/qr_scanner/address_qr_scanner.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The scanner is the one place all three mobile entrances share: the pay
/// screen address field, the home bottom panel and the swap screen each hand
/// their own snackbar callback to the same `onQrViewCreated`. Driving that
/// method is what covers all three at once.
void main() {
  const payload =
      '{"type":"sideswap_app","version":"2","receivers":[{"address":"addr1"}]}';
  const emptyOutputs = Left<OutputsError, OutputsData>(
    OutputsErrorOutputsDataIsEmpty(),
  );

  late MockWallet wallet;

  // A loaded outputs payload, so that `verifyNever(createTx)` below is an
  // assertion rather than a tautology: with these overrides in place the send
  // helper WOULD reach createTx if anything still called it.
  final loadedOutputs = [
    outputsCreatorProvider.overrideWithValue(
      Right<OutputsError, OutputsData>(
        OutputsData(
          receivers: const [
            OutputsReceiver(address: 'addr1', assetId: 'asset1', satoshi: 5000),
          ],
        ),
      ),
    ),
    deductFeeFromOutputProvider.overrideWithValue(false),
    payjoinRadioButtonIndexProvider.overrideWithValue(0),
    payjoinFeeAssetProvider.overrideWithValue(null),
  ];

  setUpAll(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
    registerFallbackValue(CreateTx());
  });

  setUp(() {
    wallet = MockWallet();
    // The shipped English copy, so the assertions read the string the user
    // sees rather than one this test made up.
    Localization.load(
      const Locale('en'),
      translations: Translations(
        (jsonDecode(File('assets/translations/en.json').readAsStringSync())
                as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value)),
      ),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  /// Pumps a route that owns a context and a ref, and returns a driver that
  /// runs the scanner's scan handler against them.
  Future<
    ({
      ProviderContainer container,
      List<String> errors,
      List<QrCodeResultModel> models,
      Future<void> Function(String code, {BIP21AddressTypeEnum? expectedAddress})
      scan,
    })
  >
  pumpScanner(WidgetTester tester, {ProviderContainer? container}) async {
    final scopedContainer = container ?? ProviderContainer.test(
      overrides: [walletProvider.overrideWithValue(wallet), ...loadedOutputs],
    );
    final errors = <String>[];
    // qrCodeResultModelProvider is auto-disposed. Without a live listener it
    // would drop back to empty the moment the scanner stops reading it, and
    // every "still empty" assertion would pass for the wrong reason.
    final models = <QrCodeResultModel>[];
    scopedContainer.listen(
      qrCodeResultModelProvider,
      (previous, next) => models.add(next),
      fireImmediately: true,
    );
    late BuildContext capturedContext;
    late WidgetRef capturedRef;

    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: scopedContainer,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          // InkSparkle loads a shader asset that --no-test-assets does not
          // serve; the default splash would abort the pump.
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: const SizedBox.shrink(),
        ),
      ),
    );

    // The scanner pops its own route when it is done, so it needs one.
    unawaited(
      navigatorKey.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => Consumer(
            builder: (innerContext, innerRef, child) {
              capturedContext = innerContext;
              capturedRef = innerRef;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    return (
      container: scopedContainer,
      errors: errors,
      models: models,
      scan: (String code, {BIP21AddressTypeEnum? expectedAddress}) async {
        await const AddressQrScanner().onQrViewCreated(
          capturedContext,
          capturedRef,
          code,
          expectedAddress,
          (String message) {
            errors.add(message);
            return null;
          },
        );
        await tester.pumpAndSettle();
      },
    );
  }

  group('AddressQrScanner, an outputs payload', () {
    testWidgets('is declined with the desktop-import message', (tester) async {
      final harness = await pumpScanner(tester);

      await harness.scan(payload);

      expect(harness.errors, ['This file can only be imported on desktop']);
      expect(harness.models, everyElement(isA<QrCodeResultModelEmpty>()));
    });

    testWidgets('sends no transaction and writes no outputs', (tester) async {
      final harness = await pumpScanner(tester);

      await harness.scan(payload);

      verifyNever(() => wallet.createTx(any()));
      expect(harness.container.read(outputsReaderProvider), emptyOutputs);
    });

    testWidgets('is declined on the swap screen, which expects a bitcoin QR', (
      tester,
    ) async {
      final harness = await pumpScanner(tester);

      await harness.scan(payload, expectedAddress: BIP21AddressTypeEnum.bitcoin);

      expect(harness.errors, ['This file can only be imported on desktop']);
      expect(harness.models, everyElement(isA<QrCodeResultModelEmpty>()));
      verifyNever(() => wallet.createTx(any()));
    });

    testWidgets('the send helper does reach createTx with these overrides', (
      tester,
    ) async {
      // A control for every verifyNever above: without it they would pass
      // against a helper that could never call createTx at all.
      final harness = await pumpScanner(tester);

      harness.container.read(paymentHelperProvider).outputsPaymentSend();

      verify(() => wallet.createTx(any())).called(1);
    });
  });

  group('AddressQrScanner, any other JSON QR', () {
    testWidgets('reports the generic message and writes no outputs', (
      tester,
    ) async {
      final harness = await pumpScanner(tester);

      await harness.scan('{"type":"other","version":"2"}');

      expect(harness.errors, ['Invalid QR code']);
      expect(harness.models, everyElement(isA<QrCodeResultModelEmpty>()));
      expect(harness.container.read(outputsReaderProvider), emptyOutputs);
      verifyNever(() => wallet.createTx(any()));
    });
  });

  group('AddressQrScanner, an ordinary QR', () {
    testWidgets('a plain Liquid address still sets the scan result', (
      tester,
    ) async {
      const address = 'VJLplainaddress';
      final harness = await pumpScanner(
        tester,
        container: ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(wallet),
            ...loadedOutputs,
            isAddrTypeValidProvider(
              address,
              AddrType.elements,
            ).overrideWithValue(true),
            isAddrTypeValidProvider(
              address,
              AddrType.bitcoin,
            ).overrideWithValue(false),
          ],
        ),
      );

      await harness.scan(address);

      expect(harness.errors, isEmpty);
      expect(harness.models.last, isA<QrCodeResultModelData>());
      expect(
        (harness.models.last as QrCodeResultModelData).result?.address,
        address,
      );
    });
  });
}
