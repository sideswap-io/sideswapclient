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
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/widgets/home_bottom_panel.dart';
import 'package:sideswap/screens/pay/payment_page.dart';
import 'package:sideswap/screens/qr_scanner/address_qr_scanner.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';
class MockWallet extends Mock implements SideswapWallet {}

/// The mobile scan listeners no longer have an outputs-payload branch. What is
/// left must still route an ordinary scan to the amount form, and nothing on
/// this path may reach the outputs send helper.
void main() {
  late MockWallet wallet;

  const payload =
      '{"type":"sideswap_app","version":"2","receivers":[{"address":"addr1"}]}';

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
    registerFallbackValue(AddrType.elements);
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

  setUp(() {
    wallet = MockWallet();
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

  /// Mounts [entryPoint] and pushes a second route, so the scanner callback
  /// the entry point opens has a route of its own to pop. Returns the
  /// container plus a driver that runs the real scanner against it.
  Future<
    ({
      ProviderContainer container,
      List<String> errors,
      Future<void> Function(String code) scan,
    })
  >
  pumpEntryPoint(WidgetTester tester, Widget entryPoint) async {
    final container = ProviderContainer.test(
      overrides: [walletProvider.overrideWithValue(wallet), ...loadedOutputs],
    );
    final errors = <String>[];
    final navigatorKey = GlobalKey<NavigatorState>();
    late BuildContext capturedContext;
    late WidgetRef capturedRef;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            extensions: [
              CustomBackButtonStyle.standard(),
              CustomBigButtonStyle(),
            ],
          ),
          home: Scaffold(body: entryPoint),
        ),
      ),
    );
    await tester.pump();

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
      container: container,
      errors: errors,
      scan: (String code) async {
        await const AddressQrScanner().onQrViewCreated(
          capturedContext,
          capturedRef,
          code,
          null,
          (String message) {
            errors.add(message);
            return null;
          },
        );
        await tester.pumpAndSettle();
      },
    );
  }

  Future<ProviderContainer> pumpPanel(WidgetTester tester) async {
    final harness = await pumpEntryPoint(tester, const HomeBottomPanel());
    return harness.container;
  }

  group('HomeBottomPanel, the scan listener', () {
    testWidgets('routes an ordinary scan result to the amount form', (
      tester,
    ) async {
      final container = await pumpPanel(tester);

      container
          .read(qrCodeResultModelProvider.notifier)
          .setModel(
            QrCodeResultModelData(
              result: QrCodeResult(address: 'VJLplainaddress'),
            ),
          );
      await tester.pump();
      await tester.pump();

      expect(container.read(pageStatusProvider), Status.paymentAmountPage);
      expect(
        container.read(paymentAmountPageArgumentsProvider).result?.address,
        'VJLplainaddress',
      );
      verifyNever(() => wallet.createTx(any()));
    });

    testWidgets('a version 2 payload routes nothing and sends nothing', (
      tester,
    ) async {
      final harness = await pumpEntryPoint(tester, const HomeBottomPanel());

      await harness.scan(payload);

      expect(harness.errors, ['This file can only be imported on desktop']);
      expect(
        harness.container.read(pageStatusProvider),
        isNot(Status.paymentAmountPage),
      );
      expect(
        harness.container.read(paymentAmountPageArgumentsProvider).result,
        isNull,
      );
      expect(
        harness.container.read(createTxStateProvider),
        isA<CreateTxStateEmpty>(),
      );
      verifyNever(() => wallet.createTx(any()));
    });

    testWidgets('the send helper does reach createTx when it has receivers', (
      tester,
    ) async {
      // A control for the verifyNever assertions above: without it they would
      // pass against a helper that can never call createTx at all.
      final container = await pumpPanel(tester);

      container.read(paymentHelperProvider).outputsPaymentSend();

      verify(() => wallet.createTx(any())).called(1);
    });
  });

  group('PaymentPage, the scan listener', () {
    Future<ProviderContainer> pumpPayPage(WidgetTester tester) async {
      when(
        () => wallet.commonAddrErrorStr(any(), any()),
      ).thenReturn('');
      final container = ProviderContainer.test(
        overrides: [walletProvider.overrideWithValue(wallet), ...loadedOutputs],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              extensions: [
                CustomBackButtonStyle.standard(),
                CustomBigButtonStyle(),
              ],
            ),
            home: const PaymentPage(),
          ),
        ),
      );
      await tester.pump();
      return container;
    }

    testWidgets('fills the address field from an ordinary scan result', (
      tester,
    ) async {
      final container = await pumpPayPage(tester);

      container
          .read(qrCodeResultModelProvider.notifier)
          .setModel(
            QrCodeResultModelData(
              result: QrCodeResult(address: 'VJLplainaddress'),
            ),
          );
      await tester.pump();
      await tester.pump();

      expect(find.text('VJLplainaddress'), findsOneWidget);
      verifyNever(() => wallet.createTx(any()));
    });

    testWidgets('a version 2 payload routes nothing and sends nothing', (
      tester,
    ) async {
      when(() => wallet.commonAddrErrorStr(any(), any())).thenReturn('');
      final harness = await pumpEntryPoint(tester, const PaymentPage());

      await harness.scan(payload);

      expect(harness.errors, ['This file can only be imported on desktop']);
      expect(find.text(payload), findsNothing);
      expect(
        harness.container.read(pageStatusProvider),
        isNot(Status.paymentAmountPage),
      );
      expect(
        harness.container.read(createTxStateProvider),
        isA<CreateTxStateEmpty>(),
      );
      verifyNever(() => wallet.createTx(any()));
    });
  });
}
