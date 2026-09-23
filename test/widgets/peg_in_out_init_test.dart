// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pegs/peg_in_out.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The mobile twin of `d_peg_in_out_init_test.dart`: the peg screen must not
/// reset swap state from inside its own build.
void main() {
  late MockWallet wallet;

  setUp(() {
    Localization.load(const Locale('en'));
    wallet = MockWallet();
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

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  ProviderContainer makeContainer() => ProviderContainer.test(
    overrides: [walletProvider.overrideWith((ref) => wallet)],
  );

  Future<void> pumpPegScreen(WidgetTester tester, ProviderContainer container) =>
      tester.runAsync(() async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: ThemeData(
                extensions: container
                    .read(mobileAppThemeProvider)
                    .themeExtensions,
              ),
              home: const Scaffold(body: PegInOut()),
            ),
          ),
        );
      });

  testWidgets('mounts cleanly with nothing else listening', (tester) async {
    final container = makeContainer();
    await pumpPegScreen(tester, container);

    expect(tester.takeException(), isNull);
  });

  testWidgets('mounts while another subtree listens to the swap state', (
    tester,
  ) async {
    final container = makeContainer();
    // Stands in for the peg subtree that outlives one mount and reaches the
    // next: the screen the user left open behind the settings dialog.
    container.listen(swapNetworkErrorProvider, (_, _) {});

    await pumpPegScreen(tester, container);

    expect(tester.takeException(), isNull);
  });
}
