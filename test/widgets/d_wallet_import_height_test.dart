// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/onboarding/d_wallet_import.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

import '../helpers/dialog_height_harness.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// The tallest realistic state: 24 words, where the body's own box grows from
/// 350 to 540 (`d_wallet_import.dart:117`) and the grid gains four rows.
class _TwentyFourWords extends MnemonicWordsCounterNotifier {
  @override
  int build() => 24;
}

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
  }) => pumpSurface(
    tester,
    view: view,
    overrides: [
      walletProvider.overrideWithValue(wallet),
      // The word count must be 24 *before the first pump*: the grid reads
      // `mnemonicWordItemsProvider.notifier.length()` with `.read`, not
      // `.watch` (`d_wallet_import.dart:165-167`), so a later flip would
      // leave a twelve-tile grid inside the 540 px box.
      mnemonicWordsCounterProvider.overrideWith(_TwentyFourWords.new),
    ],
    child: const DWalletImport(),
  );

  /// Twenty-four already-correct words, so `mnemonicIsValid()` holds and the
  /// CONTINUE action is enabled -- the state in which its callback can be
  /// asserted to fire.
  final words = List.generate(24, (i) => 'word${i + 1}');

  SideswapWallet buildWallet() {
    final wallet = _MockWallet();
    when(wallet.getMnemonicWords).thenReturn(words);
    when(() => wallet.validateMnemonic(any())).thenReturn(true);
    when(() => wallet.importMnemonic(any())).thenReturn(null);
    when(wallet.goBack).thenReturn(true);
    return wallet;
  }

  /// The page's *own* scroll owner, not "the one `Scrollable` in the tree" --
  /// `DMnemonicTable` is a shrink-wrapped `GridView` inside the body.
  final ownScrollView = find.descendant(
    of: find.byType(SideSwapPopupPage),
    matching: find.byType(SingleChildScrollView),
  );

  group('DWalletImport height bound', () {
    testWidgets('declares a height bound at its measured natural height', (
      tester,
    ) async {
      captureErrors();

      await pump(tester, view: unbounded, wallet: buildWallet());

      final constraints = tester
          .widget<SideSwapPopupPage>(find.byType(SideSwapPopupPage))
          .constraints;
      expect(constraints.maxHeight, 719);
      expect(constraints.maxWidth, 628);
      // The bound is exactly the natural height, not below it.
      expect(naturalHeight(tester), 719);
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
      // The layout is unchanged: the 24-word toggle and all 24 tiles render.
      expect(
        tester.widget<DMnemonicTable>(find.byType(DMnemonicTable)).itemsCount,
        24,
      );
    });

    testWidgets('at the floor there is no vertical overflow and the action is '
        'hit-testable and live', (tester) async {
      final errors = captureErrors();
      final wallet = buildWallet();

      await pump(tester, view: floor, wallet: wallet);

      // The action stays outside the scroll body...
      expect(
        find.descendant(of: ownScrollView, matching: find.text('CONTINUE')),
        findsNothing,
      );
      // ...and is reachable rather than merely present.
      expect(find.text('CONTINUE').hitTestable(), findsOneWidget);
      await tester.runAsync(() async {
        await tester.tap(find.text('CONTINUE'));
        await tester.pump();
      });
      // The behaviour, not the call count: the whole 24-word mnemonic
      // reached the wallet.
      final captured = verify(() => wallet.importMnemonic(captureAny()))
          .captured;
      expect(captured, isNotEmpty);
      expect(captured.first, contains('word24'));
      // The shortfall scrolls rather than being clipped, and the grid still
      // owns nothing.
      expect(firstExtentOf(tester, ownScrollView), greaterThan(0));
      expect(gridExtent(tester), 0);
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
