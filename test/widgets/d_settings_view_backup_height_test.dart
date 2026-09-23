// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/settings/d_settings_view_backup.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/dialog_height_harness.dart';

class _MockWallet extends Mock implements SideswapWallet {}

/// The tallest realistic state: a 24-word recovery phrase, which is what
/// `wordCount` reports when the wallet holds 24 words
/// (`d_settings_view_backup.dart:88`).
final _words = List.generate(24, (i) => 'word${i + 1}');

/// The body the dialog's own `maxHeight` leaves once title and actions chrome
/// are taken -- 735 minus 187. The removed `SizedBox` fixed it at 430, which
/// was 118 px short of what a 24-word phrase needs.
const bodyDesignHeight = 548.0;

void main() {
  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random
  // seed.
  setUp(() {
    Localization.load(const Locale('en'));
    // Back the platform clipboard channel so the copy action resolves without
    // a missing-plugin error -- prior art:
    // test/widgets/d_wallet_descriptors_test.dart.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async => null,
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
    overrides: [walletProvider.overrideWithValue(wallet)],
    child: const DSettingsViewBackup(),
  );

  SideswapWallet buildWallet({int wordCount = 24}) {
    final wallet = _MockWallet();
    when(wallet.getMnemonicWords).thenReturn(_words.take(wordCount).toList());
    when(wallet.goBack).thenReturn(true);
    return wallet;
  }

  /// The dialog's *own* scroll owner is the content's `CustomScrollView`
  /// (`d_settings_view_backup.dart`), not "the one `Scrollable` in the tree":
  /// `DMnemonicTable` is a shrink-wrapped `GridView` inside that body.
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(CustomScrollView),
  );

  /// The slot the dialog hands its body -- the nearest `Center` enclosing the
  /// body's own scroll view, found by ancestry rather than by position because
  /// the title's close button and the actions row both wrap their own content
  /// in a `Center`.
  ///
  /// A `Center` under bounded constraints sizes to `constraints.biggest`, so
  /// this measures what the bound leaves the body, not what the body asked
  /// for. That is exactly the quantity under test: the height used to be
  /// fixed here by a `SizedBox` and is now handed down from the dialog.
  double bodySlotHeight(WidgetTester tester) => tester
      .getSize(
        find
            .ancestor(
              of: find.byType(CustomScrollView),
              matching: find.byType(Center),
            )
            .first,
      )
      .height;

  group('DSettingsViewBackup height bound', () {
    testWidgets('declares a height bound, and the body carries no height of '
        'its own', (tester) async {
      final errors = captureErrors();

      await pump(tester, view: unbounded, wallet: buildWallet());

      final constraints = tester
          .widget<DContentDialog>(find.byType(DContentDialog))
          .constraints;
      expect(constraints.maxHeight, 735);
      expect(constraints.maxWidth, 580);
      // The height is expressed once, on the dialog: the body is content-sized
      // and takes the room the bound leaves it.
      expect(naturalHeight(tester), 735);
      expect(bodySlotHeight(tester), bodyDesignHeight);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the design height the twelve-word phrase has nothing to '
        'scroll', (tester) async {
      final errors = captureErrors();

      await pump(
        tester,
        view: designHeight,
        wallet: buildWallet(wordCount: 12),
      );

      // `ScrollOwner.child`: the wrapper adds no `SingleChildScrollView` of
      // its own, so the content's `CustomScrollView` is the single owner.
      expect(
        find.descendant(
          of: find.byType(DContentDialog),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );
      expect(ownScrollView, findsOneWidget);
      // The layout is unchanged: the body is exactly the height the removed
      // `SizedBox` used to fix.
      expect(bodySlotHeight(tester), bodyDesignHeight);
      // Twelve words fit the 430 px body, so the design state scrolls nothing.
      expect(firstExtentOf(tester, ownScrollView), 0);
      expect(gridExtent(tester), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the design height the tallest realistic phrase has '
        'nothing to scroll either', (tester) async {
      final errors = captureErrors();

      await pump(tester, view: designHeight, wallet: buildWallet());

      // 24 words is the tallest realistic state, and the bound is measured
      // from it: at the design height the dialog has the room it asked for
      // and its own scroll owner has nothing to carry. Under the old 430 px
      // body this scrolled 118 px with 105 px of window still unused.
      expect(bodySlotHeight(tester), bodyDesignHeight);
      expect(firstExtentOf(tester, ownScrollView), 0);
      expect(gridExtent(tester), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor there is no vertical overflow and the actions '
        'row is hit-testable and live', (tester) async {
      final errors = captureErrors();
      final wallet = buildWallet();

      await pump(tester, view: floor, wallet: wallet);

      // The floor is shorter than the dialog wants, so the body yields and
      // the shortfall becomes scroll extent on the owner the content already
      // had -- not an overflow, and not a second owner.
      expect(bodySlotHeight(tester), lessThan(bodyDesignHeight));
      expect(firstExtentOf(tester, ownScrollView), greaterThan(0));
      // The action stays outside the scroll body...
      expect(
        find.descendant(of: ownScrollView, matching: find.text('BACK')),
        findsNothing,
      );
      // ...and is reachable rather than merely present.
      expect(find.text('BACK').hitTestable(), findsOneWidget);
      await tester.runAsync(() async {
        await tester.tap(find.text('BACK'));
        await tester.pump();
      });
      verify(wallet.goBack).called(1);
      expect(gridExtent(tester), 0);
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
