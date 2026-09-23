/// Mounting `MarketLimitPage` under the harness needs three things the sibling
/// swap-page test does not. Measured here, recorded because the other market
/// pages will hit the same three.
///
/// 1. The LAST pump of the test must be `pumpAndSettle`, not `pump`.
///    `LimitTtlPopupMenu` mounts `AnimatedDropdownArrow` inside a
///    `PopupMenuButton`, so `flutter_animate` runs `_AnimateState._restart`
///    under an `_OverlayPortalElement`. That schedules a zero-duration timer
///    during the frame's own build phase, which the frame that created it
///    cannot run. The timer survives every later plain `pump`, so a test that
///    ends on one ends with the timer still pending. Only the final pump has
///    to settle; the earlier ones may stay plain. The widget is not at fault:
///    mounted on its own it settles, and `animated_dropdown_arrow_test.dart`
///    holds that.
/// 2. `splashFactory: NoSplash.splashFactory`. The default ink splash loads
///    `shaders/ink_sparkle.frag`, which `--no-test-assets` does not provide.
/// 3. The overflow filter, because the page lays out to the app's own font.
library;

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/market_limit_page.dart';

import '../helpers/ignore_overflow.dart';
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
      ignoreOverflow();

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
              // The default ink splash loads `shaders/ink_sparkle.frag`, which
              // `--no-test-assets` does not provide.
              splashFactory: NoSplash.splashFactory,
            ),
            home: const MarketLimitPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The provider rebuilds and hands out a new repository instance.
      useSecondJadeLockRepository(container);
      await tester.pump();

      await tester.tap(find.byType(MarketOrderButton));
      await tester.pumpAndSettle();

      verify(second.refreshJadeLockState).called(1);
      verifyNever(first.refreshJadeLockState);
    },
  );
}
