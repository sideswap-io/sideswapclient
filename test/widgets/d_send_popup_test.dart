import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/config_provider.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

void main() {
  setUp(() {
    installSurfaceTestEnv();
  });

  Future<void> pump(WidgetTester tester, Size view, Widget surface) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              configurationProvider.overrideWith(
                () => FakeConfiguration(
                  SideswapSettings.empty(
                    mnemonicEncrypted: Uint8List.fromList([]),
                    jadeId: '',
                  ),
                ),
              ),
            ],
            child: MaterialApp(
              // `--no-test-assets` has no ink shader.
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: const Scaffold(body: SizedBox.shrink()),
            ),
          ),
        );
        unawaited(
          Navigator.of(tester.element(find.byType(Scaffold)))
              .push(MaterialPageRoute<void>(builder: (_) => surface)),
        );
        await tester.pumpAndSettle();
      });

  /// The popup's *own* scroll owner, not "the one `Scrollable` in the tree":
  /// both surfaces contain a bounded inner outputs list of their own.
  final wrapperScrollView = find.descendant(
    of: find.byType(DPopupWithClose),
    matching: find.byType(SingleChildScrollView),
  );

  group('DSendPopupCreate', () {
    final reviewButton = find.widgetWithText(DCustomButton, 'REVIEW');

    testWidgets('at the design height the body is unscrolled and the buttons '
        'sit outside the scroll region', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, const DSendPopupCreate());

      expect(wrapperScrollView, findsOneWidget);
      expect(
        find.descendant(of: wrapperScrollView, matching: reviewButton),
        findsNothing,
      );
      expect(extentOf(tester, wrapperScrollView), 0);
      // The button row sits at the card's bottom edge; the slack is the row's
      // own 40px bottom padding.
      expectPinnedToCardBottom(tester, reviewButton, slack: 40);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and REVIEW is reachable '
        'without scrolling', (tester) async {
      final errors = captureOverflow();

      await pump(tester, floor, const DSendPopupCreate());

      expect(verticalOverflows(errors), isEmpty);
      expect(
        tester.getBottomLeft(reviewButton).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(reviewButton.hitTestable(), findsOneWidget);
    });
  });

  group('DSendPopupReview', () {
    final backButton = find.widgetWithText(DCustomButton, 'BACK');

    testWidgets('at the design height the outputs list is the only scrollable '
        'and the buttons sit outside it', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, const DSendPopupReview());

      // The review outputs list owns this surface's scrolling; the wrapper
      // adds none, so nothing nests inside it.
      expect(wrapperScrollView, findsNothing);
      expect(
        tester
            .widget<DPopupWithClose>(find.byType(DPopupWithClose))
            .scrollOwner,
        ScrollOwner.child,
      );
      // The buttons are pinned in `actions`, outside the body column.
      expect(
        find.descendant(
          of: find.byType(DPopupWithCloseContent),
          matching: backButton,
        ),
        findsOneWidget,
      );
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and BACK is reachable without '
        'scrolling', (tester) async {
      final errors = captureOverflow();

      await pump(tester, floor, const DSendPopupReview());

      expect(wrapperScrollView, findsNothing);
      expect(verticalOverflows(errors), isEmpty);
      expect(
        tester.getBottomLeft(backButton).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(backButton.hitTestable(), findsOneWidget);
    });
  });
}
