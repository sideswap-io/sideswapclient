import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/settings/d_settings_logs.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

void main() {
  late MockWallet wallet;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    // `goBack()` returns bool, so an unstubbed call throws on the null return
    // before the tap's effect can be observed.
    when(() => wallet.goBack()).thenReturn(true);
  });

  // Every button here resolves its theme through a throwaway
  // `ProviderContainer` whose dispose timer never settles under fake async, so
  // the pump runs inside `runAsync` -- prior art: test/widgets/d_settings_test.dart.
  Future<void> pump(WidgetTester tester, Size view) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [walletProvider.overrideWithValue(wallet)],
            child: MaterialApp(
              // `--no-test-assets` has no ink shader.
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: const Scaffold(body: DSettingsLogs()),
            ),
          ),
        );
      });

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  final backButton = find.byType(DCustomTextBigButton);

  testWidgets('at the design height the layout is unchanged and the scroll '
      'owner has zero extent', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(ownScrollView, findsOneWidget);
    // The one match is the wrapper's own owner: the pinned BACK button is
    // outside it.
    expect(
      find.descendant(of: ownScrollView, matching: backButton),
      findsNothing,
    );
    expect(extentOf(tester, ownScrollView), 0);
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor nothing overflows and BACK stays live', (
    tester,
  ) async {
    final errors = captureOverflow();

    await pump(tester, floor);

    expect(verticalOverflows(errors), isEmpty);
    expect(backButton.hitTestable(), findsOneWidget);
    await tapAndDrain(tester, backButton);
    verify(() => wallet.goBack()).called(1);
  });
}
