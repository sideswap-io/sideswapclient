import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';

// A synthetic body, so the numbers below are font-independent.
const bodyKey = Key('body');
const actionKey = Key('action');
const contentScrollKey = Key('content-scroll');

const popupWidth = 580.0;
const popupHeight = 605.0;

/// A production design height above the supported floor -- `d_send_popup.dart`
/// declares exactly this one.
const tallPopupHeight = 710.0;

const body = SizedBox(key: bodyKey, height: 600, width: 300);

Widget actionButton(VoidCallback onTap) => GestureDetector(
  key: actionKey,
  behavior: HitTestBehavior.opaque,
  onTap: onTap,
  child: const SizedBox(height: 48, width: 200),
);

const scrollingBody = SingleChildScrollView(key: contentScrollKey, child: body);

const spacedTopKey = Key('spaced-top');
const spacedBottomKey = Key('spaced-bottom');

/// The shape of the four surfaces that state `ScrollOwner.child` while owning
/// no scrollable of their own: a `Spacer()` pushes the bottom row to the floor
/// of a popup that declares its height.
const spacedBody = Column(
  children: [
    SizedBox(key: spacedTopKey, height: 100, width: 300),
    Spacer(),
    SizedBox(key: spacedBottomKey, height: 44, width: 300),
  ],
);

/// The supported floor and the design height of ADR-0014, as client areas.
const floor = Size(1072, 620);
const designHeight = Size(1072, 840);
const unbounded = Size(1072, 2000);

void main() {
  // `DIconButton` resolves the desktop theme through a throwaway
  // `ProviderContainer` whose dispose timer never settles under fake async, so
  // every pump runs inside `runAsync` -- prior art:
  // test/widgets/d_settings_test.dart.
  Future<void> pump(
    WidgetTester tester, {
    required Size view,
    ScrollOwner? scrollOwner,
    Widget child = body,
    Widget? actions,
    double? height,
    double? width,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = view;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: scrollOwner == null
              ? DPopupWithClose(
                  width: width,
                  height: height,
                  actions: actions,
                  child: child,
                )
              : DPopupWithClose(
                  width: width,
                  height: height,
                  actions: actions,
                  scrollOwner: scrollOwner,
                  child: child,
                ),
        ),
      ),
    );
  });

  /// The popup's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DPopupWithCloseContent),
    matching: find.byType(SingleChildScrollView),
  );

  /// The popup's decorated box: the widget the `width`/`height` land on.
  final popupBox = find.descendant(
    of: find.byType(DPopupWithCloseContent),
    matching: find.byType(ClipRRect),
  );

  double extentOf(WidgetTester tester, Finder scrollView) => tester
      .state<ScrollableState>(
        find.descendant(of: scrollView, matching: find.byType(Scrollable)),
      )
      .position
      .maxScrollExtent;

  /// The popup lays its body and actions out in a `MainAxisSize.min`
  /// `Column`, so that column's height is the popup's natural height. The
  /// synthetic parts contain no `Column` of their own.
  double naturalHeight(WidgetTester tester) => tester
      .getSize(
        find
            .descendant(
              of: find.byType(DPopupWithCloseContent),
              matching: find.byType(Column),
            )
            .first,
      )
      .height;

  /// See the note in d_content_dialog_scroll_owner_test.dart: the blanket
  /// `ignoreOverflow()` helper would swallow the very overflow asserted here,
  /// and only overflow is diverted -- every other framework error still
  /// reaches the tester's handler and still fails the test.
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

  testWidgets('pins the close button 20px inside the popup corner and keeps '
      'the declared height on the container', (tester) async {
    await pump(
      tester,
      view: designHeight,
      width: popupWidth,
      height: popupHeight,
    );

    // The close button is `Positioned`, so it no longer expands to fill the
    // popup the way the old `Align` did.
    final closePositioned = find.ancestor(
      of: find.byType(DIconButton),
      matching: find.byType(Positioned),
    );
    expect(closePositioned, findsOneWidget);
    final positioned = tester.widget<Positioned>(closePositioned);
    expect(positioned.top, 20);
    expect(positioned.right, 20);
    // A popup with a `height` still gets that height on its container.
    final popup = tester.getRect(popupBox);
    expect(popup.size, const Size(popupWidth, popupHeight));

    final close = tester.getRect(find.byType(DIconButton));
    expect(close.top, popup.top + 20);
    expect(close.right, popup.right - 20);
  });

  /// Opens the popup as a dismissible-barrier dialog route, the branch where
  /// `DPopupWithClose` renders its content without a `Scaffold` of its own.
  Future<void> pumpAsDialog(
    WidgetTester tester, {
    Widget? actions,
    VoidCallback? onClose,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = designHeight;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Builder(
            builder: (context) => GestureDetector(
              key: const Key('open'),
              behavior: HitTestBehavior.opaque,
              onTap: () => showDialog<void>(
                context: context,
                barrierDismissible: true,
                builder: (_) => DPopupWithClose(
                  width: popupWidth,
                  scrollOwner: ScrollOwner.wrapper,
                  onClose: onClose,
                  actions: actions,
                  child: body,
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('open')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('under a dismissible barrier it brings no Scaffold of its own '
      'and still pins the action', (tester) async {
    var tapped = false;
    await pumpAsDialog(tester, actions: actionButton(() => tapped = true));

    expect(
      find.descendant(
        of: find.byType(DPopupWithClose),
        matching: find.byType(Scaffold),
      ),
      findsNothing,
    );
    // The slots still reach the content: the wrapper scrolls, the action is
    // outside the scroll body and live.
    expect(ownScrollView, findsOneWidget);
    expect(
      find.descendant(of: ownScrollView, matching: find.byKey(actionKey)),
      findsNothing,
    );
    await tester.tap(find.byKey(actionKey));
    expect(tapped, isTrue);
  });

  testWidgets('the close button pops the route when no onClose is given', (
    tester,
  ) async {
    await pumpAsDialog(tester);
    expect(find.byType(DPopupWithCloseContent), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.byType(DIconButton));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });

    expect(find.byType(DPopupWithCloseContent), findsNothing);
  });

  group('the default owner', () {
    Future<void> pumpDefault(
      WidgetTester tester, {
      required Size view,
      VoidCallback? onAction,
    }) => pump(
      tester,
      view: view,
      width: popupWidth,
      actions: actionButton(onAction ?? () {}),
    );

    testWidgets('is `wrapper`: it scrolls the body and pins the actions', (
      tester,
    ) async {
      await pumpDefault(tester, view: designHeight);

      // The same assertions the `ScrollOwner.wrapper` group makes, against a
      // popup constructed without the argument.
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

      await pumpDefault(tester, view: unbounded);
      final natural = naturalHeight(tester);

      await pumpDefault(tester, view: floor, onAction: () => tapped = true);

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

  group('ScrollOwner.wrapper', () {
    Future<void> pumpWrapper(
      WidgetTester tester, {
      required Size view,
      VoidCallback? onAction,
    }) => pump(
      tester,
      view: view,
      scrollOwner: ScrollOwner.wrapper,
      width: popupWidth,
      actions: actionButton(onAction ?? () {}),
    );

    testWidgets('has zero scroll extent at the design height', (tester) async {
      await pumpWrapper(tester, view: designHeight);

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
      await pumpWrapper(tester, view: unbounded);
      final natural = naturalHeight(tester);

      await pumpWrapper(tester, view: Size(floor.width, natural + 1));

      expect(extentOf(tester, ownScrollView), 0);
    });

    testWidgets('scrolls exactly one pixel below its natural height', (
      tester,
    ) async {
      await pumpWrapper(tester, view: unbounded);
      final natural = naturalHeight(tester);

      await pumpWrapper(tester, view: Size(floor.width, natural - 1));

      expect(extentOf(tester, ownScrollView), 1);
    });

    testWidgets('at the floor scrolls the shortfall and keeps the action '
        'pinned, hit-testable and live', (tester) async {
      final errors = captureErrors();
      var tapped = false;

      await pumpWrapper(tester, view: unbounded);
      final natural = naturalHeight(tester);

      await pumpWrapper(tester, view: floor, onAction: () => tapped = true);

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

  // The shape every production call site has today: an explicit width and
  // height on the container. `Container(height:)` enforces the height against
  // the viewport, so at the floor the popup is clamped and the wrapper scrolls
  // the shortfall rather than overflowing.
  testWidgets('under wrapper a popup with a declared height is clamped to the '
      'floor and scrolls the shortfall', (tester) async {
    final errors = captureErrors();
    var tapped = false;

    await pump(
      tester,
      view: floor,
      scrollOwner: ScrollOwner.wrapper,
      width: popupWidth,
      height: tallPopupHeight,
      actions: actionButton(() => tapped = true),
    );

    expect(tester.getRect(popupBox).height, floor.height);
    expect(extentOf(tester, ownScrollView), greaterThan(0));
    expect(find.byKey(actionKey).hitTestable(), findsOneWidget);
    await tester.tap(find.byKey(actionKey));
    expect(tapped, isTrue);
    expect(verticalOverflows(errors), isEmpty);
  });

  group('ScrollOwner.child', () {
    testWidgets('leaves the single scrollable to the content', (tester) async {
      final errors = captureErrors();

      await pump(
        tester,
        view: floor,
        scrollOwner: ScrollOwner.child,
        width: popupWidth,
        child: scrollingBody,
        actions: actionButton(() {}),
      );

      expect(ownScrollView, findsOneWidget);
      expect(tester.widget(ownScrollView).key, contentScrollKey);
      expect(extentOf(tester, ownScrollView), greaterThan(0));
      expect(
        find.descendant(of: ownScrollView, matching: find.byKey(actionKey)),
        findsNothing,
      );
      expect(find.byKey(actionKey).hitTestable(), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
    });

    // The wrapper supplies the `Flexible` half and no scroll view, so a body
    // that fills a declared height still gets that height in full. Four
    // production surfaces depend on it: side_swap_scaffold.dart:69,
    // d_export_csv_popup.dart:28, d_open_tx_import.dart:97 and
    // d_notifications.dart:1654, each a `Spacer()` inside a declared-height
    // popup. An unbounded body would make `Spacer` throw instead.
    testWidgets('gives a flexing body the declared height in full', (
      tester,
    ) async {
      final errors = captureErrors();

      await pump(
        tester,
        view: designHeight,
        scrollOwner: ScrollOwner.child,
        width: popupWidth,
        height: popupHeight,
        child: spacedBody,
      );

      expect(tester.getRect(popupBox).height, popupHeight);
      expect(
        tester.getRect(find.byKey(spacedTopKey)).top,
        tester.getRect(popupBox).top,
      );
      expect(
        tester.getRect(find.byKey(spacedBottomKey)).bottom,
        tester.getRect(popupBox).bottom,
      );
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
