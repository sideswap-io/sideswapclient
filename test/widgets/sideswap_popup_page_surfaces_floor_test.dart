/// ADR-0014 floor sweep, `SideSwapPopupPage` family.
///
/// Issue #268. Every surface here is mounted in its tallest realistic provider
/// state at [designHeight] and at [floor]. At the design height the page's own
/// scroll owner has nothing to scroll; at the floor nothing overflows
/// vertically and the surface's pinned action is `hitTestable()`.
///
/// **When a `textScale` appears at a call site, read the comment beside it.**
/// `--no-test-assets` gives the wrong glyph metrics, so a surface can carry a
/// vertical overflow or a scroll extent that production never has. The rule
/// this sweep applies before calling one an artefact rather than a defect, and
/// every call site records its own figures against it:
///
/// 1. the figure is the same at the design height and at the floor, and the
///    surface sits in a box whose height is a literal below the floor, so the
///    window height never reaches it; and
/// 2. the figure falls to zero at a mild text scale.
///
/// A figure that survives a scale of 0.5 fails the rule and is filed as a
/// defect instead -- that is what separated `WalletLocked` (85px at 1.0, 72px
/// at 0.5, issue #294) from the artefacts the sweep ruled out. A test that
/// runs at a scale states its property of the surface *at that scale*.
///
/// **What the rule cannot do.** Shrinking the text shrinks real content as
/// well as block-font noise, so part 2 alone cannot tell a glyph artefact from
/// a content overflow that a smaller font happens to absorb. What the rule
/// does establish is part 1: the box is correct and the window height is not
/// what fills it. docs/TESTING.md draws the same line -- a layout test at the
/// floor bounds the box, not the glyphs, and the glyph fit is what the
/// on-device check is for. Every surface carrying a scale here is therefore
/// also on the manual-test list of the pull request, to be confirmed at
/// 1280x720 with the production font.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
// Riverpod 3 does not export `Override` from its Flutter entry point -- prior
// art: test/helpers/settings_container.dart.
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_import_wallet_error.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_failed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_succeed.dart';
import 'package:sideswap/desktop/pin/d_pin_protection.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

void main() {
  late MockWallet wallet;
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    routeRecorder = RouteRecorder();
    // The backup-check grid reads the wallet directly, and an unstubbed getter
    // throws on its null return before the layout can be measured.
    when(() => wallet.backupCheckAllWords).thenReturn({
      3: ['alpha', 'bravo', 'charlie'],
      6: ['delta', 'echo', 'foxtrot'],
      9: ['golf', 'hotel', 'india'],
      11: ['juliet', 'kilo', 'lima'],
    });
    when(() => wallet.backupCheckSelectedWords).thenReturn({});
  });

  /// Mounts [surface] alone in a desktop window of [view].
  ///
  /// The theme is the real desktop one, and the pump runs inside `runAsync`
  /// because every `DButton` resolves its focus theme through a throwaway
  /// `ProviderContainer` whose dispose timer never settles under fake async.
  ///
  /// The surface is *pushed* on a route above a blank home: `Navigator.pop`
  /// refuses to remove the root route, so a surface whose close or primary
  /// action pops would have no observable effect as the home.
  Future<void> pump(
    WidgetTester tester,
    Size view,
    Widget surface, {
    List<Override> overrides = const [],
    double textScale = 1.0,
  }) => tester.runAsync(() async {
    sizeView(tester, view);
    final container = ProviderContainer.test(
      overrides: [
        ...overrides,
        walletProvider.overrideWithValue(wallet),
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(
              mnemonicEncrypted: Uint8List.fromList([]),
              jadeId: '',
            ),
          ),
        ),
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
            // `--no-test-assets` has no ink shader.
            splashFactory: NoSplash.splashFactory,
          ),
          navigatorObservers: [routeRecorder],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    unawaited(
      Navigator.of(tester.element(find.byType(Scaffold))).push(
        MaterialPageRoute<void>(builder: (_) => Scaffold(body: surface)),
      ),
    );
    // Not `pumpAndSettle`: these pages keep a background animation alive, and
    // an indefinite animation never settles.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  /// The page's *own* scroll owner. `SideSwapPopupPage` adds none of its own:
  /// its whole layout is the `DContentDialog` below it, which owns the one
  /// scroll view the page has.
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  /// The two cases ADR-0014 decision 13 asks of every surface.
  void sweep(
    String name, {
    required Widget Function() build,
    required Finder Function() primary,
    List<Override> Function()? overrides,
    void Function()? tapped,
    double textScale = 1.0,
    Finder? evidence,
  }) {
    group(name, () {
      /// Mounts the surface at [view]. [build] and [overrides] are invoked
      /// per call, never hoisted: a shared widget or override list would leak
      /// the first test's state into the second.
      Future<void> mount(WidgetTester tester, Size view) => pump(
        tester,
        view,
        build(),
        overrides: overrides?.call() ?? const [],
        textScale: textScale,
      );

      testWidgets('at the design height the body is unscrolled', (
        tester,
      ) async {
        final errors = captureOverflow();

        await mount(tester, designHeight);

        // The surface really is in the state the overrides describe. Without
        // this a fake that silently failed to take would leave the tall branch
        // unrendered and every assertion below would pass on an empty page.
        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        expect(ownScrollView, findsOneWidget);
        // The one match is the wrapper's own owner: the pinned action is
        // outside it.
        expect(
          find.descendant(of: ownScrollView, matching: primary()),
          findsNothing,
        );
        expect(extentOf(tester, ownScrollView), 0);
        expect(verticalOverflows(errors), isEmpty);
      });

      testWidgets('at the floor nothing overflows and the pinned action is '
          'reachable', (tester) async {
        final errors = captureOverflow();

        await mount(tester, floor);

        if (evidence != null) {
          expect(evidence, findsOneWidget);
        }
        expect(verticalOverflows(errors), isEmpty);
        expect(
          tester.getBottomLeft(primary()).dy,
          lessThanOrEqualTo(floor.height),
        );
        expect(primary().hitTestable(), findsOneWidget);
        if (tapped != null) {
          await tapAndDrain(tester, primary());
          tapped();
        }
      });
    });
  }

  sweep(
    'DImportWalletError',
    build: () => const DImportWalletError(),
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'RETRY'),
    tapped: () => verify(() => wallet.startMnemonicImport()).called(1),
  );

  sweep(
    'DNewWalletBackupCheckFailed',
    build: () => const DNewWalletBackupCheckFailed(),
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'RETRY'),
    // The body carries 14px of scroll extent at the design height under the
    // `--no-test-assets` block font, and none at a text scale of 0.7. The page
    // declares `maxHeight: 420`, so the window height never reaches its body:
    // the extent is a glyph-metric artefact of the test font, not a floor
    // effect.
    textScale: 0.7,
    tapped: () => verify(() => wallet.backupNewWalletCheck()).called(1),
  );

  sweep(
    'DNewWalletBackupCheckSucceed',
    build: () => const DNewWalletBackupCheckSucceed(),
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'CONTINUE'),
    // Same block-font artefact as `DNewWalletBackupCheckFailed` above, 26px
    // here, against a declared `maxHeight: 446`.
    textScale: 0.7,
    tapped: () => verify(() => wallet.loginAndLoadMainPage()).called(1),
  );

  sweep(
    'DNewWalletBackupCheck',
    build: () => const DNewWalletBackupCheck(),
    primary: () => find.widgetWithText(DCustomFilledBigButton, 'CONFIRM'),
    // The four word rows are the page's whole body; without them the grid
    // renders empty and the height assertion would mean nothing.
    evidence: find.text('alpha'),
    // Not tapped: CONFIRM is disabled until all four words are selected, which
    // is the wallet's state and not this surface's layout.
  );

  sweep(
    'DPinProtection',
    build: () => const DPinProtection(),
    primary: () => find.widgetWithText(DCustomTextBigButton, 'Back'),
    tapped: () => expect(routeRecorder.pops, 1),
  );
}
