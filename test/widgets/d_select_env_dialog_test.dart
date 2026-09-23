import 'dart:typed_data';

// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_first_launch.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/dialog_height_harness.dart';
import '../helpers/fake_configuration.dart';

class _MockWallet extends Mock implements SideswapWallet {}

void main() {
  // `Localization` is a process-wide singleton, so it is (re)loaded in setUp
  // per docs/TESTING.md -- never setUpAll, which would leak under a random
  // seed.
  setUp(() {
    Localization.load(const Locale('en'));
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
      configurationProvider.overrideWith(
        () => FakeConfiguration(
          SideswapSettings.empty(mnemonicEncrypted: Uint8List.fromList([])),
        ),
      ),
    ],
    child: const DSelectEnvDialog(),
  );

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  SideswapWallet buildWallet() {
    final wallet = _MockWallet();
    when(wallet.goBack).thenReturn(true);
    return wallet;
  }

  group('DSelectEnvDialog height bound', () {
    testWidgets('declares a height bound at its measured natural height', (
      tester,
    ) async {
      captureErrors();

      await pump(tester, view: unbounded, wallet: buildWallet());

      final constraints = tester
          .widget<DContentDialog>(find.byType(DContentDialog))
          .constraints;
      expect(constraints.maxHeight, 329);
      expect(constraints.maxWidth, 628);
      // The bound is exactly the natural height, not below it. The tallest
      // realistic state is the debug build's four environments -- `envValues()`
      // returns two in release (`lib/providers/wallet.dart:110-118`), and a
      // test binary is always a debug build.
      expect(find.byType(DRadioButton), findsNWidgets(4));
      expect(naturalHeight(tester), 329);
    });

    testWidgets('at the design height its scroll owner has zero extent', (
      tester,
    ) async {
      captureErrors();

      await pump(tester, view: designHeight, wallet: buildWallet());

      expect(ownScrollView, findsOneWidget);
      expect(firstExtentOf(tester, ownScrollView), 0);
      // The layout is unchanged: every environment row still renders.
      expect(find.byType(DRadioButton), findsNWidgets(4));
    });

    testWidgets('at the floor there is no vertical overflow and the actions '
        'row is hit-testable and live', (tester) async {
      final errors = captureErrors();
      final wallet = buildWallet();

      await pump(tester, view: floor, wallet: wallet);

      // The actions stay outside the scroll body...
      expect(
        find.descendant(of: ownScrollView, matching: find.text('CANCEL')),
        findsNothing,
      );
      // ...and are reachable rather than merely present.
      expect(find.text('CANCEL').hitTestable(), findsOneWidget);
      expect(find.text('CLOSE').hitTestable(), findsOneWidget);
      // CANCEL, not the first action: that one calls `exit(0)`
      // (`d_first_launch.dart`), which would kill the test isolate.
      await tester.runAsync(() async {
        await tester.tap(find.text('CANCEL'));
        await tester.pump();
      });
      verify(wallet.goBack).called(1);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('CANCEL pops the dialog route it is shown on', (tester) async {
      captureErrors();
      final wallet = buildWallet();

      // The dialog used to be an inline `showDialog` builder inside
      // `DFirstLaunch`, so its CANCEL closure captured the *page's* context.
      // As its own widget it captures the dialog route's context instead, and
      // that is the identity this case pins: pumped on a real route, CANCEL
      // must close that route rather than pop past it or nothing at all.
      await tester.runAsync(() async {
        tester.view.physicalSize = designHeight;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              walletProvider.overrideWithValue(wallet),
              configurationProvider.overrideWith(
                () => FakeConfiguration(
                  SideswapSettings.empty(
                    mnemonicEncrypted: Uint8List.fromList([]),
                  ),
                ),
              ),
            ],
            child: MaterialApp(
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () => showDialog<void>(
                      // The same two flags `DFirstLaunch` passes.
                      useRootNavigator: false,
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => const DSelectEnvDialog(),
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
      });

      expect(find.byType(DSelectEnvDialog), findsOneWidget);

      await tester.runAsync(() async {
        await tester.tap(find.text('CANCEL'));
        await tester.pumpAndSettle();
      });

      expect(find.byType(DSelectEnvDialog), findsNothing);
      expect(find.text('open'), findsOneWidget);
      verify(wallet.goBack).called(1);
    });
  });
}
