// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The user moves from the loading screen straight into the unlocking locked
/// screen, and the dots must not appear to jump between them.
///
/// **This does not discharge that acceptance criterion**, which is explicitly
/// device-verified: the two screens reach the same y through different
/// arithmetic, and one of the terms is a text line box that depends on the font
/// actually in use. Under the test font the two agree exactly; on a device the
/// offset may need retuning, and this test going red is the signal that it does
/// — not proof that the screens are wrong.
void main() {
  late MockWallet wallet;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
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
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  testWidgets('the dots land at the same height on both screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SafeArea(child: PreLauchAnimation())),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    final loadingDots = tester.getTopLeft(find.byType(PulsingDots)).dy;
    await tester.pumpWidget(const SizedBox.shrink());

    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWith((ref) => wallet),
        pinAvailableProvider.overrideWithValue(false),
      ],
    );
    container
        .read(serverLoginProvider.notifier)
        .setServerLoginState(const ServerLoginState.loginProcessing());

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            extensions: [CustomBigButtonStyle()],
          ),
          home: const WalletLocked(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    final unlockingDots = tester.getTopLeft(find.byType(PulsingDots)).dy;

    expect(unlockingDots, closeTo(loadingDots, 1));

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
