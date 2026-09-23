// `DJadeImport` at the two ADR-0014 client areas.
//
// The page is built on `SideSwapScaffoldPage`, which has no `scrollOwner` of
// its own, so the surface pins its own controls and scrolls its own body --
// ADR-0014 decisions 8 and 10. Production mounts it through a
// `RawDialogRoute` (lib/providers/route_providers.dart:609); the harness below
// pushes it on a `MaterialPageRoute` instead, which gives the page the same
// client area and keeps the pump loop the sweep's other files use.
//
// Two states are laid out here, because the page's switch renders a different
// body in each: the default state, where no Jade is connected and the spinner
// branch is on screen, and the connected state, where `jadeDeviceProvider`
// holds one `From_JadePorts_Port` and the `JadeDevice` card with REGISTER
// replaces the spinner.
//
// The figures the tests read out are block-font measurements under
// `--no-test-assets`. Treat them as a regression record, not as production
// geometry.
//
// One case is deliberately not covered, and it is a real limitation rather
// than a gap: two or more connected Jades. Desktop keeps the whole device list
// (lib/providers/jade_provider.dart:61), the page renders one `JadeDevice`
// card per device, and at the floor the second card's REGISTER is below the
// fold. It cannot be pinned -- there is one button per card, not one per page.
// Prior art records the same for `DAmpRegister`'s register boxes; see
// test/widgets/d_amp_register_floor_test.dart. Acceptance criterion 2 asks for
// exactly one device, which is the case that fits.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/main/d_jade_import.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// One connected Jade, which is the state acceptance criterion 2 names.
///
/// The page renders a `JadeDevice` card per device, and the card carries the
/// REGISTER button the criterion asks to be reachable.
class _FakeJadeDevices extends JadeDeviceNotifier {
  @override
  JadeDevicesState build() => JadeDevicesState.available(
    devices: [From_JadePorts_Port(port: 'COM3', jadeId: 'jade-1')],
  );
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
    final themeData = container.read(desktopAppThemeProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            brightness: themeData.brightness,
            textTheme: themeData.textTheme,
            extensions: themeData.themeExtensions,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    unawaited(
      Navigator.of(tester.element(find.byType(Scaffold))).push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: DJadeImport()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  final back = find.widgetWithText(DCustomTextBigButton, 'Back');

  // The page's own scroll body, scoped to its wrapper rather than to "the one
  // `Scrollable` in the tree".
  final bodyScrollView = find
      .descendant(
        of: find.byType(SideSwapScaffoldPage),
        matching: find.byType(SingleChildScrollView),
      )
      .first;

  // Tied to the source line rather than to a rendered `SizedBox`: the page
  // draws four `SvgPicture`s and only this one is 178 wide.
  final jadeArtwork = find.byWidgetPredicate(
    (widget) => widget is SvgPicture && widget.width == 178,
  );

  // The two landmarks that straddle the scroll seam, measured on the page
  // before the seam existed. `SideSwapScaffoldPage` is constructed with the
  // default `padding: EdgeInsets.zero`, so the page contributes no top padding
  // of its own and the surface's own `EdgeInsets.all(24)` is all of it.
  //
  // Above the seam: the pinned navigation row, at the surface's own padding.
  const contentTop = 24.0;
  // The first thing inside the scroll body: the padding, the navigation row
  // and the 100px spacer that opens the body. Any error in the seam's offset
  // or in the flex moves this, so it is the whole of what the seam needs
  // proving by.
  //
  // Nothing further down is asserted by position. ADR-0014 decision 13 warns
  // that `--no-test-assets` gives the wrong font metrics, and every offset
  // below this one is a sum of block-font text heights -- a figure that churns
  // on a translation change without a layout change. Prior art takes the same
  // line: test/widgets/d_amp_register_floor_test.dart pins only its
  // padding-derived offsets. The measured before/after figures for the spinner
  // and for REGISTER are in the commit message instead.
  const artworkTop = 166.0;

  testWidgets('at the design height nothing overflows', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(verticalOverflows(errors), isEmpty);
    expect(back.hitTestable(), findsOneWidget);
  });

  testWidgets('at the floor nothing overflows and Back is reachable', (
    tester,
  ) async {
    final errors = captureOverflow();

    await pump(tester, floor);

    // Red today: `A RenderFlex overflowed by 20 pixels on the bottom.`
    // at lib/desktop/main/d_jade_import.dart:30.
    expect(verticalOverflows(errors), isEmpty);
    expect(tester.getBottomLeft(back).dy, lessThanOrEqualTo(floor.height));
    expect(back.hitTestable(), findsOneWidget);
    // The scroll view is what absorbs the shortfall, rather than something
    // else clipping it. The figure is font-dependent, so only its sign is
    // asserted; the issue measured the overflow at 20 px.
    expect(extentOf(tester, bodyScrollView), greaterThan(0));
  });

  testWidgets('the design height renders as it did before the body scrolled', (
    tester,
  ) async {
    await pump(tester, designHeight);

    // Nothing scrolls at the design height, and the two landmarks above and
    // below the scroll seam keep the offsets they had before it existed.
    expect(tester.getRect(back).top, contentTop);
    expect(tester.getRect(jadeArtwork.first).top, artworkTop);
    expect(extentOf(tester, bodyScrollView), 0);
  });

  final register = find.widgetWithText(DCustomFilledBigButton, 'REGISTER');

  group('the connected state, the one that renders REGISTER', () {
    List<Override> connected() => [
      jadeDeviceProvider.overrideWith(_FakeJadeDevices.new),
    ];

    testWidgets('at the design height nothing overflows', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, overrides: connected());

      // The page really is in the arm the override describes.
      expect(find.text('COM3'), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
      expect(tester.getRect(back).top, contentTop);
      expect(tester.getRect(jadeArtwork.first).top, artworkTop);
      expect(extentOf(tester, bodyScrollView), 0);
    });

    testWidgets('at the floor nothing overflows and REGISTER is reachable', (
      tester,
    ) async {
      final errors = captureOverflow();

      await pump(tester, floor, overrides: connected());

      expect(find.text('COM3'), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
      expect(tester.getBottomLeft(back).dy, lessThanOrEqualTo(floor.height));
      expect(
        tester.getBottomLeft(register).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(register.hitTestable(), findsOneWidget);
      // Not merely on screen: the connected body fits the floor whole, so
      // REGISTER is reachable without scrolling.
      expect(extentOf(tester, bodyScrollView), 0);
    });
  });
}
