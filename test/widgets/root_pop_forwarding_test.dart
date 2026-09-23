import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/app_main.dart';

/// The root `PopScope` sits on the root route, above a pages-driven navigator
/// that owns its own routes. Without forwarding, a screen inside that
/// navigator never sees the system back gesture.
void main() {
  Widget harness({
    required GlobalKey<NavigatorState> navigatorKey,
    required List<Page<Object?>> pages,
    required List<String> removed,
  }) {
    return MaterialApp(
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) =>
            handleRootPopInvoked(didPop, navigatorKey),
        child: Navigator(
          key: navigatorKey,
          onDidRemovePage: (page) => removed.add('${page.name}'),
          pages: pages,
        ),
      ),
    );
  }

  group('handleRootPopInvoked', () {
    testWidgets('reaches the handler of a single-page stack', (tester) async {
      final hits = <bool>[];
      final navigatorKey = GlobalKey<NavigatorState>();
      final removed = <String>[];

      await tester.pumpWidget(
        harness(
          navigatorKey: navigatorKey,
          removed: removed,
          pages: [
            MaterialPage<Widget>(
              name: 'only',
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) => hits.add(didPop),
                child: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.binding.handlePopRoute();
        await tester.pump();
      });

      expect(hits, [false]);
      expect(removed, isEmpty);
    });

    testWidgets('leaves a stack that can pop alone', (tester) async {
      // Removing a page here would desync the navigator from the pages list
      // that produced it, so the gesture stays inert, as it is today.
      final navigatorKey = GlobalKey<NavigatorState>();
      final removed = <String>[];

      await tester.pumpWidget(
        harness(
          navigatorKey: navigatorKey,
          removed: removed,
          pages: const [
            MaterialPage<Widget>(
              name: 'first',
              child: Text('first page', textDirection: TextDirection.ltr),
            ),
            MaterialPage<Widget>(
              name: 'second',
              child: Text('second page', textDirection: TextDirection.ltr),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.binding.handlePopRoute();
        await tester.pump();
      });
      await tester.pumpAndSettle();

      expect(removed, isEmpty);
      expect(find.text('second page'), findsOneWidget);
    });

    testWidgets('does nothing when the route already popped', (tester) async {
      final hits = <bool>[];
      final navigatorKey = GlobalKey<NavigatorState>();
      final removed = <String>[];

      await tester.pumpWidget(
        harness(
          navigatorKey: navigatorKey,
          removed: removed,
          pages: [
            MaterialPage<Widget>(
              name: 'only',
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) => hits.add(didPop),
                child: const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      handleRootPopInvoked(true, navigatorKey);
      await tester.pump();

      expect(hits, isEmpty);
    });
  });
}
