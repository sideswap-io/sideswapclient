// `DAmpRegister` at the two ADR-0014 client areas.
//
// The page is a full desktop route on `SideSwapScaffoldPage`, which has no
// `scrollOwner` of its own, so the surface pins its own action and scrolls its
// own body. At the design height the body fits and the scroll extent is zero;
// at the floor the body scrolls by what the `Column` used to overflow by. The
// exact figure is font-dependent, so no test asserts it.
//
// The body's height does not vary with the provider state: each
// `AmpServiceRegisterBox` is a literal 333px high whatever it holds, so no
// asset fixture makes it taller. Both arms of the page's switch are laid out
// here anyway -- the default arm renders NOT NOW, `_RegisteredStokrGaid`
// renders CONTINUE -- because they use different button widgets. Measured, the
// two arms land on the same geometry at both heights; the tests are what keeps
// that true.
//
// Two consequences this file records but deliberately does not assert:
//
// - Each register box holds a bounded inner `CustomScrollView`. Per decision 9
//   the wheel over a box reaches that inner list first, so the page's own
//   scroll body has a dead zone over each box wherever the list can still move.
// - At the floor the two REGISTER buttons inside the boxes sit below the fold:
//   scoping the CONTINUE finder by type alone finds one of them first, and it
//   is not hit-testable. Only the page's own action is pinned. Shrinking the
//   333px boxes is what would put REGISTER back on screen, and that changes the
//   design-height layout, which this issue forbids.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/onboarding/d_amp_register.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// Holds the registered arm of the page's switch, the one that renders
/// CONTINUE.
///
/// The page calls `refreshAmpStatus()` on every build, which posts a microtask
/// that drives this notifier back to `StokrGaidStateLoading`. Swallowing the
/// setter is what keeps the arm under test on screen.
class _RegisteredStokrGaid extends StokrGaidNotifier {
  @override
  StokrGaidState build() => const StokrGaidStateRegistered();

  @override
  void setStokrGaidState(StokrGaidState value) {}
}

void main() {
  setUp(installSurfaceTestEnv);

  Future<void> pump(
    WidgetTester tester,
    Size view, {
    List<Override> overrides = const [],
  }) => tester.runAsync(() async {
    sizeView(tester, view);
    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWithValue(MockWallet()),
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(
              mnemonicEncrypted: Uint8List.fromList([]),
              jadeId: '',
            ),
          ),
        ),
        ...overrides,
      ],
    );
    // The sweep's theme, not Material's default: the page reads NOT NOW and the
    // disclaimer through `Theme.of(context)`, and those two set the height of
    // the pinned block every assertion below is measured against.
    final themeData = container.read(desktopAppThemeProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            brightness: themeData.brightness,
            textTheme: themeData.textTheme,
            extensions: themeData.themeExtensions,
            // `--no-test-assets` has no ink shader.
            splashFactory: NoSplash.splashFactory,
          ),
          home: const DAmpRegister(),
        ),
      ),
    );
    // Not `pumpAndSettle`: `refreshAmpStatus()` posts a microtask on every
    // build. One further pump lands the state it sets.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  final primary = find.byType(DCustomTextBigButton);

  testWidgets('at the design height nothing overflows', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(verticalOverflows(errors), isEmpty);
    expect(primary.hitTestable(), findsOneWidget);
  });

  testWidgets('at the floor nothing overflows and the primary control is '
      'reachable', (tester) async {
    final errors = captureOverflow();

    await pump(tester, floor);

    // Red before the `Expanded` wrapper went in: `A RenderFlex overflowed by
    // 64 pixels on the bottom.` at lib/desktop/onboarding/d_amp_register.dart,
    // measured under the default Material theme. That shortfall is what the
    // body now scrolls by instead -- asserted below.
    expect(verticalOverflows(errors), isEmpty);
    expect(tester.getBottomLeft(primary).dy, lessThanOrEqualTo(floor.height));
    expect(primary.hitTestable(), findsOneWidget);
  });

  // The page's own scroll body, scoped to its wrapper: each register box holds
  // a bounded `CustomScrollView` of its own, so "the one `Scrollable` in the
  // tree" would be the wrong one.
  final bodyScrollView = find
      .descendant(
        of: find.byType(SideSwapScaffoldPage),
        matching: find.byType(SingleChildScrollView),
      )
      .first;
  final title = find.text('Register your AMP ID to trade securities');
  final disclaimer = find.textContaining('If you skip this step');

  // The page's own padding, `EdgeInsets.only(top: 70, bottom: 59)` at
  // lib/desktop/onboarding/d_amp_register.dart:89. The title sits at the top of
  // it and the disclaimer at the bottom of it, at both window heights.
  const contentTop = 70.0;
  const contentBottom = 59.0;

  testWidgets('the design height renders as it did before the body scrolled', (
    tester,
  ) async {
    await pump(tester, designHeight);

    // Nothing scrolls at the design height, so the body sits where the
    // `Spacer()` used to put it. No golden pixel figures: the block font makes
    // text heights meaningless, and the viewport is the taller of the two.
    expect(extentOf(tester, bodyScrollView), 0);
    expect(tester.getRect(title.first).top, contentTop);
    expect(
      tester.getBottomLeft(disclaimer.first).dy,
      designHeight.height - contentBottom,
    );
  });

  testWidgets('the floor scrolls the body by what the column used to overflow '
      'by', (tester) async {
    await pump(tester, floor);

    // The figure itself is font- and theme-dependent, so only its sign is
    // asserted. The issue measured 64 under the default Material theme.
    expect(extentOf(tester, bodyScrollView), greaterThan(0));
    expect(
      tester.getBottomLeft(disclaimer.first).dy,
      floor.height - contentBottom,
    );
  });

  group('the registered arm, the one that renders CONTINUE', () {
    List<Override> registered() => [
      stokrGaidProvider.overrideWith(_RegisteredStokrGaid.new),
    ];
    // Scoped through its label, not `find.byType(...).first`: each register box
    // holds a `DCustomFilledBigButton` of its own, labelled REGISTER, and those
    // sit inside the scroll body.
    final continueButton = find.ancestor(
      of: find.text('CONTINUE'),
      matching: find.byType(DCustomFilledBigButton),
    );

    testWidgets('at the design height nothing overflows', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, overrides: registered());

      // The page really is in the arm the override describes. Without this the
      // assertions below would pass on the NOT NOW arm, whose button is a
      // different height.
      expect(find.text('CONTINUE'), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
      expect(extentOf(tester, bodyScrollView), 0);
      expect(
        tester.getBottomLeft(disclaimer.first).dy,
        designHeight.height - contentBottom,
      );
    });

    testWidgets('at the floor nothing overflows and CONTINUE is reachable', (
      tester,
    ) async {
      final errors = captureOverflow();

      await pump(tester, floor, overrides: registered());

      expect(find.text('CONTINUE'), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
      expect(
        tester.getBottomLeft(continueButton).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(continueButton.hitTestable(), findsOneWidget);
    });
  });
}
