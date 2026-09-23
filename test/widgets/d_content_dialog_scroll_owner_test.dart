import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';

// A synthetic body, so the numbers below are font-independent: nothing here
// renders text, and `--no-test-assets` block-font metrics cannot move a box
// whose height is a literal.
const titleKey = Key('title');
const bodyKey = Key('body');
const actionKey = Key('action');
const contentScrollKey = Key('content-scroll');

const title = SizedBox(key: titleKey, height: 44, width: 300);
const body = SizedBox(key: bodyKey, height: 600, width: 300);

/// The primary action. The key sits on the gesture detector itself so
/// [WidgetTester.tap] lands on the widget the finder found.
Widget actionButton(VoidCallback onTap) => GestureDetector(
  key: actionKey,
  behavior: HitTestBehavior.opaque,
  onTap: onTap,
  child: const SizedBox(height: 48, width: 200),
);

/// The content when the *content* is meant to own the scrollable.
const scrollingBody = SingleChildScrollView(
  key: contentScrollKey,
  child: body,
);

/// The supported floor and the design height of ADR-0014, as client areas.
const floor = Size(1072, 620);
const designHeight = Size(1072, 840);

/// Tall enough that nothing bounds the dialog, so it takes its natural height.
const unbounded = Size(1072, 2000);

void main() {
  // `DContentDialogThemeData.standard()` resolves the desktop theme through a
  // throwaway `ProviderContainer` whose dispose timer never settles under fake
  // async, so every pump runs inside `runAsync` -- prior art:
  // test/widgets/d_settings_test.dart.
  Future<void> pump(
    WidgetTester tester, {
    required Size view,
    ScrollOwner? scrollOwner,
    Widget? content = body,
    VoidCallback? onAction,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = view;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          // `--no-test-assets` has no ink shader.
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Scaffold(
            body: scrollOwner == null
                ? DContentDialog(
                    title: title,
                    content: content,
                    actions: [actionButton(onAction ?? () {})],
                  )
                : DContentDialog(
                    scrollOwner: scrollOwner,
                    title: title,
                    content: content,
                    actions: [actionButton(onAction ?? () {})],
                  ),
          ),
        ),
      ),
    );
  });

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  double extentOf(WidgetTester tester, Finder scrollView) => tester
      .state<ScrollableState>(
        find.descendant(of: scrollView, matching: find.byType(Scrollable)),
      )
      .position
      .maxScrollExtent;

  /// The dialog's outer `Column` is `MainAxisSize.min`, so its rendered height
  /// is the dialog's natural height. The synthetic parts contain no `Column`,
  /// so `.first` is unambiguously the dialog's own.
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
  /// vertical one can be asserted explicitly.
  ///
  /// `ignoreOverflow()` from test/helpers/ignore_overflow.dart would swallow
  /// the very overflow these tests assert the absence of. Only overflow is
  /// diverted here; every other framework error still reaches the handler the
  /// tester installed and still fails the test.
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
    addTearDown(() => FlutterError.onError = previous);
    return errors;
  }

  Iterable<String> verticalOverflows(List<String> errors) => errors.where(
    (e) => e.contains('overflowed') && e.contains('on the bottom'),
  );

  group('the default owner', () {
    testWidgets('is `wrapper`: it scrolls the body and pins the actions', (
      tester,
    ) async {
      await pump(tester, view: designHeight);

      // The same assertions the `ScrollOwner.wrapper` group makes, against a
      // dialog constructed without the argument.
      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(bodyKey)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(actionKey)),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(tester.getSize(find.byKey(bodyKey)).height, 600);
    });

    testWidgets('at the floor scrolls the shortfall and keeps the action '
        'pinned, hit-testable and live', (tester) async {
      final errors = captureErrors();
      var tapped = false;

      await pump(tester, view: unbounded);
      final natural = naturalHeight(tester);

      await pump(tester, view: floor, onAction: () => tapped = true);

      expect(extentOf(tester, ownScrollView), natural - floor.height);
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(actionKey)),
        findsNothing,
      );
      expect(find.byKey(actionKey).hitTestable(), findsOneWidget);
      await tester.tap(find.byKey(actionKey));
      expect(tapped, isTrue);
      expect(verticalOverflows(errors), isEmpty);
    });
  });

  // `content` is optional on every owner, so no owner may dereference it
  // unconditionally.
  for (final scrollOwner in ScrollOwner.values) {
    testWidgets('builds without content under $scrollOwner', (tester) async {
      await pump(
        tester,
        view: designHeight,
        scrollOwner: scrollOwner,
        content: null,
      );

      expect(find.byType(DContentDialog), findsOneWidget);
      expect(find.byKey(titleKey), findsOneWidget);
      expect(find.byKey(actionKey), findsOneWidget);
    });
  }

  group('ScrollOwner.wrapper', () {
    testWidgets('has zero scroll extent at the design height', (tester) async {
      await pump(tester, view: designHeight, scrollOwner: ScrollOwner.wrapper);

      expect(ownScrollView, findsOneWidget);
      // The one match is the wrapper's own scroll owner, not a scrollable the
      // content brought: the body is inside it and the action is not.
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(bodyKey)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(actionKey)),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(tester.getSize(find.byKey(bodyKey)).height, 600);
    });

    testWidgets('has zero scroll extent one pixel above its natural height', (
      tester,
    ) async {
      await pump(tester, view: unbounded, scrollOwner: ScrollOwner.wrapper);
      final natural = naturalHeight(tester);

      await pump(
        tester,
        view: Size(floor.width, natural + 1),
        scrollOwner: ScrollOwner.wrapper,
      );

      expect(extentOf(tester, ownScrollView), 0);
      expect(tester.getSize(find.byKey(bodyKey)).height, 600);
    });

    testWidgets('scrolls exactly one pixel below its natural height', (
      tester,
    ) async {
      await pump(tester, view: unbounded, scrollOwner: ScrollOwner.wrapper);
      final natural = naturalHeight(tester);

      await pump(
        tester,
        view: Size(floor.width, natural - 1),
        scrollOwner: ScrollOwner.wrapper,
      );

      expect(extentOf(tester, ownScrollView), 1);
    });

    testWidgets('at the floor scrolls the shortfall and keeps the action '
        'pinned, hit-testable and live', (tester) async {
      final errors = captureErrors();
      var tapped = false;

      await pump(tester, view: unbounded, scrollOwner: ScrollOwner.wrapper);
      final natural = naturalHeight(tester);

      await pump(
        tester,
        view: floor,
        scrollOwner: ScrollOwner.wrapper,
        onAction: () => tapped = true,
      );

      expect(extentOf(tester, ownScrollView), natural - floor.height);
      // The action stays outside the scroll body...
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(actionKey)),
        findsNothing,
      );
      // ...and is reachable rather than merely present.
      expect(find.byKey(actionKey).hitTestable(), findsOneWidget);
      await tester.tap(find.byKey(actionKey));
      expect(tapped, isTrue);
      expect(verticalOverflows(errors), isEmpty);
    });
  });

  group('ScrollOwner.child', () {
    testWidgets('leaves the single scrollable to the content', (tester) async {
      final errors = captureErrors();

      await pump(
        tester,
        view: floor,
        scrollOwner: ScrollOwner.child,
        content: scrollingBody,
      );

      // Exactly one scroll view under the dialog, and it is the content's.
      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(DContentDialog),
          matching: find.byKey(contentScrollKey),
        ),
        findsOneWidget,
      );
      expect(tester.widget(ownScrollView).key, contentScrollKey);
      // The content was given the room it has and scrolls the rest itself.
      expect(extentOf(tester, ownScrollView), greaterThan(0));
      expect(find.byKey(actionKey).hitTestable(), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
