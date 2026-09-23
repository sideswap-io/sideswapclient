import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_login_dialog.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_stokr_login_dialog.dart';

import '../helpers/dialog_height_harness.dart';

/// Every call site of both dialogs passes a body that is literally
/// `SizedBox(width: 628, height: 400, ...)`:
/// `d_pegx_login_dialog_body.dart:25-27`, `d_stokr_login_dialog_body.dart:13-15`,
/// `d_pegx_submit_amp_dialog_body.dart:53-55` and
/// `d_pegx_submit_finish_dialog_body.dart:21-23`. That fixed box *is* the
/// tallest realistic state, and standing in for it here keeps the numbers
/// font-independent: `--no-test-assets` block-font metrics cannot move a box
/// whose height is a literal.
const bodyKey = Key('body');
const body = SizedBox(key: bodyKey, width: 628, height: 400);

/// A body taller than the bound, to prove the bound is a bound: the dialog
/// scrolls the shortfall instead of overflowing.
const tallBodyKey = Key('tall-body');
const tallBody = SizedBox(key: tallBodyKey, width: 628, height: 1200);

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget Function(Widget content, VoidCallback onClose) build, {
    required Size view,
    Widget content = body,
    VoidCallback? onClose,
  }) =>
      pumpSurface(tester, view: view, child: build(content, onClose ?? () {}));

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  /// The two dialogs are the same shell around a caller-supplied body, so the
  /// same four cases run against both. Each carries its own measured natural
  /// height: 20 + 44 + 20 of title chrome over the 400 px body. They agree
  /// because the two shells are identical, not because one number was copied
  /// from the other -- each was measured against its own dialog.
  final dialogs = <String, (double, Widget Function(Widget, VoidCallback))>{
    'DPegxLoginDialog': (
      484,
      (content, onClose) =>
          DPegxLoginDialog(content: content, onClose: onClose),
    ),
    'DStokrLoginDialog': (
      484,
      (content, onClose) =>
          DStokrLoginDialog(content: content, onClose: onClose),
    ),
  };

  dialogs.forEach((name, spec) {
    final (naturalHeightOf, build) = spec;
    group(name, () {
      testWidgets('declares a height bound at its measured natural height', (
        tester,
      ) async {
        await pump(tester, build, view: unbounded);

        // The bound is the dialog's own, read off the widget rather than the
        // rendered box, so an unbounded parent cannot make the assertion
        // vacuous.
        final constraints = tester
            .widget<DContentDialog>(find.byType(DContentDialog))
            .constraints;
        expect(constraints.maxHeight, naturalHeightOf);
        expect(naturalHeight(tester), naturalHeightOf);
      });

      testWidgets('at the design height its scroll owner has zero extent', (
        tester,
      ) async {
        await pump(tester, build, view: designHeight);

        expect(ownScrollView, findsOneWidget);
        // The one match is the wrapper's own scroll owner: the body is inside
        // it and the title's close button is not.
        expect(
          find.descendant(of: ownScrollView, matching: find.byKey(bodyKey)),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: ownScrollView,
            matching: find.byIcon(Icons.close),
          ),
          findsNothing,
        );
        // `extentOf` is the strict form: it throws on a second `Scrollable`
        // inside the dialog, so it also asserts the dialog gained none.
        expect(extentOf(tester, ownScrollView), 0);
        // The layout is unchanged: the body still renders at its own height.
        expect(tester.getSize(find.byKey(bodyKey)).height, 400);
      });

      testWidgets('at the floor there is no vertical overflow and the close '
          'control is hit-testable and live', (tester) async {
        final errors = captureErrors();
        var closed = false;

        await pump(tester, build, view: floor, onClose: () => closed = true);

        // Neither dialog has an `actions` slot; its only control is the close
        // button in the title, which the wrapper keeps outside the scroll body
        // exactly as it keeps `actions`.
        expect(
          find.descendant(
            of: ownScrollView,
            matching: find.byIcon(Icons.close),
          ),
          findsNothing,
        );
        expect(find.byIcon(Icons.close).hitTestable(), findsOneWidget);
        // The tap runs inside `runAsync` too: `DHoverButton` starts a 100 ms
        // press timer that fake async never settles.
        await tester.runAsync(() async {
          await tester.tap(find.byIcon(Icons.close));
          await tester.pump();
        });
        expect(closed, isTrue);
        expect(verticalOverflows(errors), isEmpty);
      });

      testWidgets('a body taller than the bound scrolls instead of '
          'overflowing', (tester) async {
        final errors = captureErrors();

        await pump(tester, build, view: unbounded, content: tallBody);

        // The bound binds: the dialog stops at its declared height rather than
        // growing with the content.
        expect(naturalHeight(tester), naturalHeightOf);
        expect(extentOf(tester, ownScrollView), greaterThan(0));
        expect(verticalOverflows(errors), isEmpty);
      });
    });
  });
}
