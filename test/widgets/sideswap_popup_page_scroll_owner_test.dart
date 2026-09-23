import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/screens/flavor_config.dart';

// A synthetic body, so the numbers below are font-independent.
const titleKey = Key('title');
const bodyKey = Key('body');
const actionKey = Key('action');
const contentScrollKey = Key('content-scroll');

const title = SizedBox(key: titleKey, height: 20, width: 200);
const body = SizedBox(key: bodyKey, height: 600, width: 300);

Widget actionButton(VoidCallback onTap) => GestureDetector(
  key: actionKey,
  behavior: HitTestBehavior.opaque,
  onTap: onTap,
  child: const SizedBox(height: 48, width: 200),
);

const scrollingBody = SingleChildScrollView(
  key: contentScrollKey,
  child: body,
);

/// The supported floor and the design height of ADR-0014, as client areas.
const floor = Size(1072, 620);
const designHeight = Size(1072, 840);
const unbounded = Size(1072, 2000);

void main() {
  // `SideSwapScaffoldPage` paints its background through `BackgroundPainter`,
  // which reads the static `FlavorConfig.isDesktop`. Per docs/TESTING.md the
  // static store is re-initialised in `setUp` -- never `setUpAll`, which would
  // leak into whatever runs next under a random seed.
  setUp(() {
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

  // The dialog theme and the title's close button both resolve the desktop
  // theme through a throwaway `ProviderContainer` whose dispose timer never
  // settles under fake async, so every pump runs inside `runAsync` -- prior
  // art: test/widgets/d_settings_test.dart.
  Future<void> pump(
    WidgetTester tester, {
    required Size view,
    ScrollOwner? scrollOwner,
    Widget content = body,
    VoidCallback? onAction,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = view;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: scrollOwner == null
              ? SideSwapPopupPage(
                  title: title,
                  content: content,
                  actions: [actionButton(onAction ?? () {})],
                )
              : SideSwapPopupPage(
                  scrollOwner: scrollOwner,
                  title: title,
                  content: content,
                  actions: [actionButton(onAction ?? () {})],
                ),
        ),
      ),
    );
  });

  /// The page's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(SideSwapPopupPage),
    matching: find.byType(SingleChildScrollView),
  );

  double extentOf(WidgetTester tester, Finder scrollView) => tester
      .state<ScrollableState>(
        find.descendant(of: scrollView, matching: find.byType(Scrollable)),
      )
      .position
      .maxScrollExtent;

  /// The dialog's outer `Column` is `MainAxisSize.min`, so its rendered height
  /// is the surface's natural height.
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

  group('the default owner', () {
    testWidgets('is `wrapper`: it scrolls the body and pins the actions', (
      tester,
    ) async {
      await pump(tester, view: designHeight);

      // The same assertions the `ScrollOwner.wrapper` group makes, against a
      // page constructed without the argument.
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

    testWidgets('at the floor scrolls and keeps the action pinned, '
        'hit-testable and live', (tester) async {
      final errors = captureErrors();
      var tapped = false;

      await pump(
        tester,
        view: floor,
        scrollOwner: ScrollOwner.wrapper,
        onAction: () => tapped = true,
      );

      expect(extentOf(tester, ownScrollView), greaterThan(0));
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

  group('ScrollOwner.child', () {
    testWidgets('adds no scroll owner of its own on top of the content\'s', (
      tester,
    ) async {
      final errors = captureErrors();

      await pump(
        tester,
        view: floor,
        scrollOwner: ScrollOwner.child,
        content: scrollingBody,
      );

      // Exactly one scroll view under the page, and it is the content's. A
      // second one here would be the dead zone ADR-0014 decision 9 forbids.
      expect(ownScrollView, findsOneWidget);
      expect(tester.widget(ownScrollView).key, contentScrollKey);
      expect(extentOf(tester, ownScrollView), greaterThan(0));
      expect(find.byKey(actionKey).hitTestable(), findsOneWidget);
      expect(verticalOverflows(errors), isEmpty);
    });
  });
}
