import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_license.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// `DLicense` renders the full GPL agreement, so its only state is its tallest:
/// `firstLaunchStateProvider` picks which callback `I AGREE` runs, not how much
/// the page draws.
void main() {
  // `SideSwapScaffoldPage` paints through `BackgroundPainter`, which reads the
  // static `FlavorConfig.isDesktop`.
  late MockWallet wallet;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    when(() => wallet.startMnemonicImport()).thenReturn(null);
  });

  Future<void> pump(WidgetTester tester, Size view) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [walletProvider.overrideWithValue(wallet)],
            child: MaterialApp(
              // `--no-test-assets` has no ink shader.
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: const DLicense(),
            ),
          ),
        );
      });

  /// The terms viewer's own scrollable -- this surface takes
  /// `ScrollOwner.child`, so the page adds none of its own and this is the only
  /// one under the dialog.
  final contentScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  final agreeButton = find.byType(DCustomFilledBigButton);

  /// The terms box, whose design height is 550.
  double termsBoxHeight(WidgetTester tester) =>
      tester.getSize(contentScrollView).height;

  testWidgets('at the design height the terms box keeps its 550px and is the '
      'only scrollable', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(contentScrollView, findsOneWidget);
    // 16px of `Padding` sits between the box and the scroll view.
    expect(termsBoxHeight(tester), 550 - 16);
    expect(extentOf(tester, contentScrollView), greaterThan(0));
    // The pinned I AGREE button is outside the scroll region.
    expect(
      find.descendant(of: contentScrollView, matching: agreeButton),
      findsNothing,
    );
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor the terms box yields the shortfall, nothing '
      'overflows and I AGREE stays live', (tester) async {
    final errors = captureOverflow();

    await pump(tester, floor);

    expect(contentScrollView, findsOneWidget);
    // The box really did give room back rather than the surface fitting
    // anyway, which is what keeps the no-overflow assertion below meaningful.
    expect(termsBoxHeight(tester), lessThan(550 - 16));
    expect(verticalOverflows(errors), isEmpty);
    expect(agreeButton.hitTestable(), findsOneWidget);
    await tapAndDrain(tester, agreeButton);
    verify(() => wallet.setLicenseAccepted()).called(1);
  });
}
