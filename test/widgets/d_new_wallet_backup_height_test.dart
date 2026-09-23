// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

import '../helpers/dialog_height_harness.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// The twelve words the page reads out of the wallet in its post-frame
/// callback (`d_new_wallet_backup.dart:23-33`). Twelve is the only count this
/// page renders: its `DMnemonicTable` passes no `itemsCount`, so the widget's
/// own default of 12 stands (`d_mnemonic_table.dart:20`).
final _words = List.generate(12, (i) => 'word${i + 1}');

void main() {
  // `Localization` is a process-wide singleton and `FlavorConfig` a static
  // store, so per docs/TESTING.md both are re-initialised in setUp -- never
  // setUpAll, which would leak under a random seed. `BackgroundPainter` inside
  // `SideSwapScaffoldPage` reads `FlavorConfig.isDesktop`.
  setUp(() {
    Localization.load(const Locale('en'));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: true,
        enableJade: false,
        enableLocalEndpoint: false,
        isDesktop: true,
      ),
    );
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  Future<void> pump(
    WidgetTester tester, {
    required Size view,
    required SideswapWallet wallet,
  }) async {
    await pumpSurface(
      tester,
      view: view,
      overrides: [walletProvider.overrideWithValue(wallet)],
      child: const DNewWalletBackup(),
    );
    // The words land in a post-frame callback, so the grid's final content
    // needs one more frame -- still under `runAsync`, for the same reason the
    // first pump is.
    await tester.runAsync(() => tester.pump());
  }

  SideswapWallet buildWallet() {
    final wallet = _MockWallet();
    when(wallet.getMnemonicWords).thenReturn(_words);
    when(wallet.newWalletBackupPrompt).thenReturn(null);
    when(wallet.backupNewWalletCheck).thenReturn(null);
    return wallet;
  }

  /// The page's *own* scroll owner, not "the one `Scrollable` in the tree" --
  /// `DMnemonicTable` is a shrink-wrapped `GridView`, a second `Scrollable`
  /// that legitimately lives inside the body.
  final ownScrollView = find.descendant(
    of: find.byType(SideSwapPopupPage),
    matching: find.byType(SingleChildScrollView),
  );

  group('DNewWalletBackup height bound', () {
    testWidgets('declares a height bound at its measured natural height', (
      tester,
    ) async {
      captureErrors();

      await pump(tester, view: unbounded, wallet: buildWallet());

      final constraints = tester
          .widget<SideSwapPopupPage>(find.byType(SideSwapPopupPage))
          .constraints;
      expect(constraints.maxHeight, 574);
      expect(constraints.maxWidth, 628);
      // The bound is the measured natural height rounded up to a whole
      // pixel: unbounded, the surface renders at 573.24 -- the paragraph above
      // the grid is the only fractional part -- and 574 is the smallest whole
      // number that does not force it to scroll.
      expect(naturalHeight(tester), closeTo(573.24, 0.01));
    });

    testWidgets('at the design height its scroll owner has zero extent', (
      tester,
    ) async {
      captureErrors();

      await pump(tester, view: designHeight, wallet: buildWallet());

      expect(ownScrollView, findsOneWidget);
      expect(firstExtentOf(tester, ownScrollView), 0);
      // The single owner is the page's: the grid never takes a second one.
      expect(gridExtent(tester), 0);
      // The layout is unchanged: all twelve words still render.
      expect(find.text('word1'), findsOneWidget);
      expect(find.text('word12'), findsOneWidget);
    });

    testWidgets('at the floor there is no vertical overflow and the action is '
        'hit-testable and live', (tester) async {
      final errors = captureErrors();
      final wallet = buildWallet();

      await pump(tester, view: floor, wallet: wallet);

      // The action stays outside the scroll body...
      expect(
        find.descendant(
          of: ownScrollView,
          matching: find.text('CONFIRM YOUR WORDS'),
        ),
        findsNothing,
      );
      // ...and is reachable rather than merely present.
      expect(find.text('CONFIRM YOUR WORDS').hitTestable(), findsOneWidget);
      await tester.runAsync(() async {
        await tester.tap(find.text('CONFIRM YOUR WORDS'));
        await tester.pump();
      });
      verify(wallet.backupNewWalletCheck).called(1);
      // 574 fits inside the 620 px floor, so nothing scrolls even there --
      // the bound is what keeps a taller future body scrolling instead of
      // overflowing. The grid still owns nothing.
      expect(firstExtentOf(tester, ownScrollView), 0);
      expect(gridExtent(tester), 0);
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
