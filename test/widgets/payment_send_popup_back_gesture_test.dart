import 'dart:convert';
import 'dart:io';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/app_main.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/payment_send_popup.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/test_utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The confirmation screen offers a close control. The system back gesture
/// must reach the same place: `SideSwapScaffold` defaults `canPop` to false,
/// so without a handler the gesture is simply inert.
void main() {
  late MockWallet wallet;

  CreatedTx createdTx({required int addressees}) {
    final tx = CreatedTx();
    for (var i = 0; i < addressees; i++) {
      tx.addressees.add(AddressAmount(address: 'addr$i', amount: Int64(1000)));
    }
    return tx;
  }

  setUpAll(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
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
    when(() => wallet.goBack()).thenReturn(true);
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

  Future<ProviderContainer> pumpPopup(
    WidgetTester tester, {
    required int addressees,
  }) async {
    final container = ProviderContainer.test(
      overrides: [walletProvider.overrideWithValue(wallet)],
    );
    container
        .read(createTxStateProvider.notifier)
        .setCreateTxState(
          CreateTxState.created(createdTx(addressees: addressees)),
        );

    // The real tree: a root PopScope over a nested pages-driven navigator.
    // Mounting the popup as MaterialApp.home instead would put its PopScope
    // on the root route and certify a structure the app has not got.
    final navigatorKey = GlobalKey<NavigatorState>();
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
          home: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) =>
                handleRootPopInvoked(didPop, navigatorKey),
            child: Navigator(
              key: navigatorKey,
              onDidRemovePage: (page) {},
              pages: const [
                MyPopupPage<Widget>(child: PaymentSendPopup()),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  Future<void> pressBack(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.binding.handlePopRoute();
      await tester.pump();
    });
  }

  group('PaymentSendPopup, the system back gesture', () {
    testWidgets('goes back for a single-receiver transaction', (tester) async {
      final container = await pumpPopup(tester, addressees: 1);

      await pressBack(tester);

      verify(() => wallet.goBack()).called(1);
      expect(container.read(createTxStateProvider), isA<CreateTxStateEmpty>());
      expect(container.read(pageStatusProvider), isNot(Status.registered));
    });

    testWidgets('returns to registered for a multi-receiver transaction', (
      tester,
    ) async {
      final container = await pumpPopup(tester, addressees: 2);

      await pressBack(tester);

      verifyNever(() => wallet.goBack());
      expect(container.read(pageStatusProvider), Status.registered);
      expect(container.read(createTxStateProvider), isA<CreateTxStateEmpty>());
    });
  });
}
