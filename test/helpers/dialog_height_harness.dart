/// The shared harness behind the per-dialog height-bound tests of ADR-0014.
///
/// Every desktop surface that declares a `maxHeight` is checked the same way:
/// unbounded it must render at exactly its declared height, at the design
/// height its scroll owner must have nothing to scroll, and at the floor it
/// must neither overflow nor put its actions out of reach. The finders and
/// measurements those checks need live here once.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// Riverpod 3 does not export `Override` from its Flutter entry point -- prior
// art: test/helpers/settings_container.dart.
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';

/// The supported floor and the design height of ADR-0014, as client areas.
const floor = Size(1072, 620);
const designHeight = Size(1072, 840);

/// Tall enough that nothing bounds the surface, so it takes its natural
/// height.
const unbounded = Size(1072, 2000);

/// Mounts [child] alone in a desktop-sized window of [view].
///
/// `DContentDialogThemeData.standard()`, the dialog title's close button and
/// every `DButton` resolve the desktop theme through throwaway
/// `ProviderContainer`s whose dispose timers never settle under fake async, so
/// the pump runs inside `runAsync` -- prior art: test/widgets/d_settings_test.dart.
Future<void> pumpSurface(
  WidgetTester tester, {
  required Size view,
  required Widget child,
  List<Override> overrides = const [],
}) => tester.runAsync(() async {
  tester.view.physicalSize = view;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        // `--no-test-assets` has no ink shader.
        theme: ThemeData(splashFactory: NoSplash.splashFactory),
        home: Scaffold(body: child),
      ),
    ),
  );
});

/// The scroll extent of [scrollView], which must hold the only `Scrollable`
/// under it: `tester.state` throws on more than one match, so this doubles as
/// the assertion that the surface gained no second scrollable.
double extentOf(WidgetTester tester, Finder scrollView) => tester
    .state<ScrollableState>(
      find.descendant(of: scrollView, matching: find.byType(Scrollable)),
    )
    .position
    .maxScrollExtent;

/// The scroll extent of [scrollView] where a further `Scrollable` legitimately
/// lives inside the body -- a shrink-wrapped `DMnemonicTable` grid, say.
/// `.first` is the scroll view's *own* `Scrollable`: it is that widget's
/// direct descendant, so depth-first order puts it ahead of the inner one.
/// Use [gridExtent] to assert that the inner one stays inert.
double firstExtentOf(WidgetTester tester, Finder scrollView) => tester
    .state<ScrollableState>(
      find.descendant(of: scrollView, matching: find.byType(Scrollable)).first,
    )
    .position
    .maxScrollExtent;

/// The mnemonic grid's own extent. It shrink-wraps -- inside a
/// `SliverToBoxAdapter` where the body is a `CustomScrollView` -- so it must
/// never scroll:
/// a grid that scrolls inside the surface's scroll view is the nested-owner
/// dead zone ADR-0014 decision 9 forbids.
double gridExtent(WidgetTester tester) => tester
    .state<ScrollableState>(
      find.descendant(
        of: find.byType(DMnemonicTable),
        matching: find.byType(Scrollable),
      ),
    )
    .position
    .maxScrollExtent;

/// The surface's natural height. The outer `Column` of a `DContentDialog` --
/// which is what a `SideSwapPopupPage` builds too -- is `MainAxisSize.min`, so
/// its rendered height is the height the surface wants.
double naturalHeight(WidgetTester tester) => tester
    .getSize(
      find
          .descendant(
            of: find.byType(DContentDialog),
            matching: find.byType(Column),
          )
          .first,
    )
    .height;

/// Collects overflow errors for the rest of the test, so the absence of a
/// vertical one can be asserted explicitly. The blanket `ignoreOverflow()`
/// helper would swallow the very overflow these tests assert the absence of;
/// only overflow is diverted here, every other framework error still fails the
/// test.
///
/// Diverting is what makes the horizontal block-font noise of
/// `--no-test-assets` survivable, and it is also how a *vertical* overflow
/// could slip through unasserted -- so the teardown fails the test on one
/// whether or not the body remembered to look. Callers that want the list
/// (to assert on it mid-test, or to read the messages) still get it.
List<String> captureErrors() {
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.exceptionAsString();
    if (text.contains('overflowed')) {
      errors.add(text);
      return;
    }
    previous?.call(details);
  };
  addTearDown(() {
    FlutterError.onError = previous;
    expect(
      verticalOverflows(errors),
      isEmpty,
      reason: 'a vertical overflow was diverted by captureErrors()',
    );
  });
  return errors;
}

/// The bottom-overflow subset of [errors] -- the only direction these bounds
/// are about.
Iterable<String> verticalOverflows(List<String> errors) => errors.where(
  (e) => e.contains('overflowed') && e.contains('on the bottom'),
);
