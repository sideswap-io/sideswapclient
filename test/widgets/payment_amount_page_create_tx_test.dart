import 'dart:convert';
import 'dart:io';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

class MockDialogPresenter extends Mock implements DialogPresenter {}

class MockBuildContext extends Mock implements BuildContext {}

class MockNavigatorKey extends Mock implements GlobalKey<NavigatorState> {
  MockNavigatorKey(this._context);

  final BuildContext? _context;

  @override
  BuildContext? get currentContext => _context;
}

/// The amount screen must move the user only when a created transaction
/// *arrives*. A transaction that was already stored -- one that a previous
/// send left behind -- is not evidence that anybody is waiting for it
/// (ADR-0012, decision 4).
void main() {
  late MockWallet wallet;
  late MockDialogPresenter presenter;

  CreatedTx createdTx({int addressees = 1}) {
    final tx = CreatedTx();
    for (var i = 0; i < addressees; i++) {
      tx.addressees.add(AddressAmount(address: 'addr$i', amount: Int64(1000)));
    }
    return tx;
  }

  setUpAll(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
    registerFallbackValue(MockBuildContext());
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
    presenter = MockDialogPresenter();
    when(
      () => presenter.showErrorDialog(
        any(),
        any(),
        buttonText: any(named: 'buttonText'),
      ),
    ).thenAnswer((_) async {});
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

  Future<ProviderContainer> pumpAmountPage(
    WidgetTester tester, {
    CreateTxState? storedState,
  }) async {
    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWithValue(wallet),
        navigatorKeyProvider.overrideWithValue(
          MockNavigatorKey(MockBuildContext()),
        ),
        utilsProvider.overrideWith(
          (ref) => UtilsProvider(ref, presenter: presenter),
        ),
      ],
    );
    if (storedState != null) {
      container
          .read(createTxStateProvider.notifier)
          .setCreateTxState(storedState);
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            // CustomAppBar and CustomBigButton read these with a null check.
            extensions: [
              CustomBackButtonStyle.standard(),
              CustomBigButtonStyle(),
            ],
          ),
          home: const PaymentAmountPage(),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  group('PaymentAmountPage, a stored created transaction', () {
    testWidgets('navigates nothing when it was stored before the mount', (
      tester,
    ) async {
      final container = await pumpAmountPage(
        tester,
        storedState: CreateTxState.created(createdTx()),
      );
      await tester.pump();

      expect(
        container.read(pageStatusProvider),
        isNot(Status.paymentSend),
      );
    });
  });

  group('PaymentAmountPage, a created transaction that arrives', () {
    testWidgets('opens the confirmation screen', (tester) async {
      final container = await pumpAmountPage(tester);

      container
          .read(createTxStateProvider.notifier)
          .setCreateTxState(CreateTxState.created(createdTx()));
      await tester.pump();
      await tester.pump();

      expect(container.read(pageStatusProvider), Status.paymentSend);
    });
  });

  group('PaymentAmountPage, a core error that arrives', () {
    testWidgets('shows the dialog and clears the create-tx state', (
      tester,
    ) async {
      final container = await pumpAmountPage(tester);

      container
          .read(createTxStateProvider.notifier)
          .setCreateTxState(const CreateTxState.error(errorMsg: 'boom'));
      await tester.pump();
      await tester.pump();

      verify(
        () => presenter.showErrorDialog(
          any(),
          'boom',
          buttonText: any(named: 'buttonText'),
        ),
      ).called(1);
      expect(container.read(createTxStateProvider), isA<CreateTxStateEmpty>());
      expect(container.read(pageStatusProvider), isNot(Status.paymentSend));
    });

    testWidgets('an error stored before the mount shows no dialog', (
      tester,
    ) async {
      final container = await pumpAmountPage(
        tester,
        storedState: const CreateTxState.error(errorMsg: 'boom'),
      );
      await tester.pump();

      verifyNever(
        () => presenter.showErrorDialog(
          any(),
          any(),
          buttonText: any(named: 'buttonText'),
        ),
      );
      expect(container.read(createTxStateProvider), isA<CreateTxStateError>());
    });
  });
}
