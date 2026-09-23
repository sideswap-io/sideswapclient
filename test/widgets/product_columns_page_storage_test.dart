/// The market product picker is *not* a visit-scoped list.
///
/// It keeps a column offset across a close and an open of the picker, on
/// desktop and on mobile alike, through its own `PageStorage` and the shared
/// random key of `pageStorageKeyDataProvider`. See the `Visit` term in
/// CONTEXT.md: issue #296 scopes the desktop shell's store to the visit and
/// leaves this mechanism alone. These tests are the regression guard for that
/// promise -- nothing here asserts new behaviour.
///
/// The key is memoized per element with no dependency list, so an invalidation
/// of the shared key reaches a column only on its next mount. That is why the
/// second pair of tests invalidates first and remounts after.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/product_columns.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap/screens/markets/widgets/market_product_columns.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/ignore_overflow.dart';
import '../helpers/surface_floor.dart';

/// Enough markets in one type for a column to scroll past the test's offset.
const _rowCount = 60;

List<MarketInfo> _markets() => List.generate(
  _rowCount,
  (index) => MarketInfo(
    assetPair: AssetPair(base: 'base$index', quote: 'quote$index'),
    type: MarketType_.STABLECOIN,
  ),
);

void main() {
  late ProviderContainer container;

  setUp(() {
    installSurfaceTestEnv();
    container = ProviderContainer.test();
    container.read(marketsProvider.notifier).setState(_markets());
  });

  /// Mounts [child] behind a switch the test can turn off and on again, under a
  /// `PageStorage` whose bucket is built above that switch and so outlives an
  /// unmount of [child].
  ///
  /// The columns declare no height of their own, so the `SizedBox` is what
  /// bounds the viewport; without it the column would have no scroll extent
  /// and every offset assertion would pass against zero.
  Future<ValueNotifier<bool>> pumpColumns(
    WidgetTester tester,
    Widget child,
  ) async {
    final mounted = ValueNotifier(true);
    addTearDown(mounted.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          // --no-test-assets has no shaders/ink_sparkle.frag, so the default
          // ink splash cannot paint.
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Scaffold(
            body: PageStorage(
              bucket: PageStorageBucket(),
              child: ValueListenableBuilder<bool>(
                valueListenable: mounted,
                builder: (_, isMounted, _) => isMounted
                    ? SizedBox(height: 300, width: 400, child: child)
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    return mounted;
  }

  /// Unmounts the column and mounts it again under the same bucket.
  ///
  /// [widget] is the column's own type rather than the `.first`-scoped finder
  /// the assertions use: a `.first` finder throws on an empty match instead of
  /// reporting one, so it cannot state that the column went away.
  Future<void> remount(
    WidgetTester tester,
    ValueNotifier<bool> mounted,
    Finder widget,
  ) async {
    mounted.value = false;
    await tester.pump();
    expect(widget, findsNothing);

    mounted.value = true;
    await tester.pump();
  }

  Future<void> scrollTo(
    WidgetTester tester,
    Finder column,
    double offset,
  ) async {
    expect(extentOf(tester, column), greaterThan(offset));
    scrollPositionOf(tester, column).jumpTo(offset);
    await tester.pump();
  }

  group('ProductColumns', () {
    final widget = find.byType(ProductColumns);
    // The first column, which is the STABLECOIN group the fixture fills. The
    // other two are empty and render a bare `SizedBox`.
    final column = find
        .descendant(of: widget, matching: find.byType(CustomScrollView))
        .first;

    testWidgets('restores its column offset after unmount and remount', (
      tester,
    ) async {
      // A market row lays out to the app's own font; the block font of
      // --no-test-assets is wider. Layout is not what this test asserts.
      ignoreOverflow();
      final mounted = await pumpColumns(tester, const ProductColumns());
      await scrollTo(tester, column, 120);

      await remount(tester, mounted, widget);

      expect(offsetOf(tester, column), 120);
    });

    testWidgets('starts at the top after the shared key is invalidated', (
      tester,
    ) async {
      ignoreOverflow();
      final mounted = await pumpColumns(tester, const ProductColumns());
      await scrollTo(tester, column, 120);

      container.invalidate(pageStorageKeyDataProvider);
      await remount(tester, mounted, widget);

      expect(offsetOf(tester, column), 0);
    });
  });

  group('MobileProductColumns', () {
    final widget = find.byType(MobileProductColumns);
    final column = find
        .descendant(of: widget, matching: find.byType(CustomScrollView))
        .first;

    testWidgets('restores its offset after unmount and remount', (
      tester,
    ) async {
      ignoreOverflow();
      final mounted = await pumpColumns(tester, const MobileProductColumns());
      await scrollTo(tester, column, 120);

      await remount(tester, mounted, widget);

      expect(offsetOf(tester, column), 120);
    });

    testWidgets('starts at the top after the shared key is invalidated', (
      tester,
    ) async {
      ignoreOverflow();
      final mounted = await pumpColumns(tester, const MobileProductColumns());
      await scrollTo(tester, column, 120);

      container.invalidate(pageStorageKeyDataProvider);
      await remount(tester, mounted, widget);

      expect(offsetOf(tester, column), 0);
    });
  });
}
