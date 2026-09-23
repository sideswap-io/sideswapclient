// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/listeners/server_login_error_listener.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';

class MockWallet extends Mock implements SideswapWallet {}

class MockDialogPresenter extends Mock implements DialogPresenter {}

class MockBuildContext extends Mock implements BuildContext {}

class MockNavigatorKey extends Mock implements GlobalKey<NavigatorState> {
  MockNavigatorKey(this._context);

  final BuildContext? _context;

  @override
  BuildContext? get currentContext => _context;
}

/// The handoff between the root error handler and the locked screen.
///
/// These two are tested together because neither one alone can show the bug:
/// the handler must clear the error state, the screen must still be able to
/// render the message it carried, and only their *ordering* makes both true.
void main() {
  late MockWallet wallet;
  late MockDialogPresenter presenter;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(MockBuildContext());
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: false,
      ),
    );
  });

  setUp(() {
    Localization.load(const Locale('en'));
    wallet = MockWallet();
    when(() => wallet.unlockWallet()).thenAnswer((_) async {});
    presenter = MockDialogPresenter();
    when(
      () => presenter.showErrorDialog(any(), any(), buttonText: any(named: 'buttonText')),
    ).thenAnswer((_) async {});
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  testWidgets('a screen mounted onto a failure keeps it after the invalidate', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWith((ref) => wallet),
        pinAvailableProvider.overrideWithValue(false),
        navigatorKeyProvider.overrideWithValue(
          MockNavigatorKey(MockBuildContext()),
        ),
        utilsProvider.overrideWith(
          (ref) => UtilsProvider(ref, presenter: presenter),
        ),
      ],
    );
    container.read(pageStatusProvider.notifier).setStatus(Status.lockedWalet);
    // The cold-start path reaches the locked screen with an unlock already in
    // flight, so the failure can land before the screen exists.
    container
        .read(serverLoginProvider.notifier)
        .setServerLoginState(const ServerLoginState.error(message: 'bad mnemonic'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            extensions: [CustomBigButtonStyle()],
          ),
          // The build order the app itself uses: the listener is mounted ahead
          // of the router that puts this screen on screen.
          home: const Column(
            children: [
              ServerLoginErrorListener(),
              Expanded(child: WalletLocked()),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    // Both halves matter, and only the deferral makes them hold together. The
    // handler must defer its invalidate into a microtask so the screen observes
    // the error while building; run it inline and the provider is already back
    // to logout before the screen is built, the capture seeds nothing, and the
    // user is left staring at a screen that says nothing went wrong -- if the
    // synchronous provider write during build does not throw outright.
    expect(find.text('bad mnemonic'), findsOneWidget);
    expect(container.read(serverLoginProvider), const ServerLoginStateLogout());
    expect(tester.takeException(), isNull);

    // And no modal was raised over it.
    verifyNever(
      () => presenter.showErrorDialog(
        any(),
        any(),
        buttonText: any(named: 'buttonText'),
      ),
    );
  });
}
