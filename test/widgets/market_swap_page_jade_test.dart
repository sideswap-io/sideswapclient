// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/market_swap_page.dart';

import '../helpers/jade_lock_repository.dart';

void main() {
  setUp(() {
    Localization.load(const Locale('en'));
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

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  testWidgets(
    'locked jade trade button refreshes the current repository, not the one '
    'that was current when the button was first built',
    (tester) async {
      final first = lockedJadeLockRepository();
      final second = lockedJadeLockRepository();

      final container = ProviderContainer.test(
        overrides: lockedJadeOverrides(first: first, second: second),
      );
      addTearDown(container.dispose);

      // The page and its buttons resolve colours through the app's theme
      // extensions, so build the real mobile theme rather than a bare one.
      final themeData = container.read(mobileAppThemeProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(
              brightness: themeData.brightness,
              textTheme: themeData.textTheme,
              colorScheme: themeData.darkScheme,
              scaffoldBackgroundColor: themeData.scaffoldBackgroundColor,
              extensions: themeData.themeExtensions,
              // The tap builds a TextButton ink splash, and the default
              // factory loads `shaders/ink_sparkle.frag`, which
              // `--no-test-assets` does not provide.
              splashFactory: NoSplash.splashFactory,
            ),
            home: const MarketSwapPage(),
          ),
        ),
      );

      // The provider rebuilds and hands out a new repository instance.
      useSecondJadeLockRepository(container);
      await tester.pump();

      await tester.tap(find.byType(MarketOrderButton));
      await tester.pump();

      verify(second.refreshJadeLockState).called(1);
      verifyNever(first.refreshJadeLockState);
    },
  );
}
