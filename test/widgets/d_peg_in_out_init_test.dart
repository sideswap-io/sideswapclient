// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pegs/d_peg_in_out.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// The peg screen must not reset swap state from inside its own build: the
/// reset is a `ref.invalidate`, and riverpod answers one with a scheduled
/// refresh - `setState` on the enclosing `ProviderScope` - whenever the
/// invalidated provider still has a mounted listener.
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
        isDesktop: true,
      ),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  ProviderContainer makeContainer() => ProviderContainer.test(
    overrides: [walletProvider.overrideWith((ref) => wallet)],
  );

  void useDesktopSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// The screen is built with the desktop theme it is built with in the app:
  /// its buttons read `DCustomBigButtonStyle` from the theme with a null check.
  ///
  /// The peg screen renders DButtons, each resolving its theme through
  /// throwaway ProviderContainers that leave dispose timers on riverpod's
  /// scheduler; those never settle under fake async, so the pump runs inside
  /// `runAsync`.
  Future<void> pumpPegScreen(WidgetTester tester, ProviderContainer container) =>
      tester.runAsync(() async {
        useDesktopSurface(tester);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: ThemeData(
                extensions: container
                    .read(desktopAppThemeProvider)
                    .themeExtensions,
              ),
              home: const DPegInOut(),
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
