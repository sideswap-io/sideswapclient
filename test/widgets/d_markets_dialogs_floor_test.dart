import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_edit_order_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_limit_panel_review_order_dialog.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockUiOwnOrder extends Mock implements UiOwnOrder {}

/// A public, price-tracking SELL order -- the branch that renders the tracking
/// slider, which is the dialog's tallest realistic state.
MockUiOwnOrder _order() {
  final asset = Asset(
    assetId: 'base',
    ticker: 'BASE',
    name: 'Base',
    precision: 8,
  );
  final quote = Asset(
    assetId: 'quote',
    ticker: 'QUOTE',
    name: 'Quote',
    precision: 8,
  );
  final order = MockUiOwnOrder();
  when(() => order.baseAsset).thenReturn(Option.of(asset));
  when(() => order.quoteAsset).thenReturn(Option.of(quote));
  when(() => order.tradeDir).thenReturn(TradeDir.SELL);
  when(() => order.amountString).thenReturn('1.00000000');
  when(() => order.amountTextInputString).thenReturn('1');
  when(() => order.amountDecimal).thenReturn(Decimal.one);
  when(() => order.total).thenReturn('2.00000000');
  when(() => order.priceMobileString).thenReturn('2.00');
  when(() => order.orderTypeDescription).thenReturn('Public');
  when(() => order.isPriceTracking).thenReturn(true);
  when(() => order.priceTracking).thenReturn(Decimal.zero);
  when(() => order.priceTrackingPercent).thenReturn(Decimal.zero);
  when(() => order.orderId).thenReturn(OrderId());
  when(() => order.assetPair).thenReturn(AssetPair());
  when(() => order.ownOrder).thenReturn(OwnOrder());
  when(() => order.offlineSwapType).thenReturn(const OfflineSwapType.empty());
  return order;
}

/// Overrides the notifier rather than its value: the dialog reads
/// `.notifier` on this provider, which `overrideWithValue` does not supply.
class FakeEditOrder extends MarketEditDetailsOrderNotifier {
  final MockUiOwnOrder order = _order();

  @override
  Option<UiOwnOrder> build() => Option.of(order);
}

void main() {
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    routeRecorder = RouteRecorder();
  });

  /// Both dialogs dereference `Theme.of(context).extension<...>()!`, so the
  /// pump builds the real desktop theme rather than a bare one. Prior art:
  /// test/widgets/market_limit_page_jade_test.dart.
  Future<void> pump(
    WidgetTester tester,
    Size view,
    Widget surface, {
    List<Override> extraOverrides = const [],
    String? routeName,
  }) => tester.runAsync(() async {
    sizeView(tester, view);
    final container = ProviderContainer.test(
      overrides: [
        ...extraOverrides,
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(
              mnemonicEncrypted: Uint8List.fromList([]),
              jadeId: '',
            ),
          ),
        ),
      ],
    );
    final themeData = container.read(desktopAppThemeProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            brightness: themeData.brightness,
            textTheme: themeData.textTheme,
            extensions: themeData.themeExtensions,
            // `--no-test-assets` has no ink shader.
            splashFactory: NoSplash.splashFactory,
          ),
          navigatorObservers: [routeRecorder],
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    // Pushed under the route name production gives it: both dialogs close with
    // `popUntil(route.settings.name != <name>)`, so without the name the tap
    // has nothing to remove and no observable effect.
    unawaited(
      Navigator.of(tester.element(find.byType(Scaffold))).push(
        MaterialPageRoute<void>(
          settings: RouteSettings(name: routeName),
          builder: (_) => Scaffold(body: surface),
        ),
      ),
    );
    // Not `pumpAndSettle`: the tracking slider and the TTL menu arrow keep
    // animations alive, and an indefinite animation never settles.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  group('DLimitPanelReviewOrderDialog', () {
    final submit = find.byType(LimitReviewSubmit);

    testWidgets('at the design height the body is unscrolled and SUBMIT sits '
        'outside the scroll region', (tester) async {
      final errors = captureOverflow();

      await pump(
        tester,
        designHeight,
        const DLimitPanelReviewOrderDialog(),
        routeName: limitPanelReviewOrderRouteName,
      );

      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(of: ownScrollView, matching: submit),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and SUBMIT is reachable '
        'without scrolling', (tester) async {
      final errors = captureOverflow();

      await pump(
        tester,
        floor,
        const DLimitPanelReviewOrderDialog(),
        routeName: limitPanelReviewOrderRouteName,
      );

      expect(verticalOverflows(errors), isEmpty);
      expect(tester.getBottomLeft(submit).dy, lessThanOrEqualTo(floor.height));
      expect(submit.hitTestable(), findsOneWidget);
      // Not tapped: submitting needs a subscribed asset pair the harness does
      // not build, and without one the button is disabled and its callback
      // returns immediately. The pinned row's reachability is what this
      // surface's floor test can honestly assert.
    });
  });

  group('DEditOrderDialog', () {
    final backButton = find.widgetWithText(DCustomButton, 'Back');

    testWidgets('at the design height the body is unscrolled', (tester) async {
      final errors = captureOverflow();

      await pump(
        tester,
        designHeight,
        const DEditOrderDialog(),
        extraOverrides: [
          marketEditDetailsOrderProvider.overrideWith(FakeEditOrder.new),
        ],
        routeName: orderEditRouteName,
      );

      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(of: ownScrollView, matching: backButton),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and Back is reachable without '
        'scrolling', (tester) async {
      final errors = captureOverflow();

      await pump(
        tester,
        floor,
        const DEditOrderDialog(),
        extraOverrides: [
          marketEditDetailsOrderProvider.overrideWith(FakeEditOrder.new),
        ],
        routeName: orderEditRouteName,
      );

      expect(verticalOverflows(errors), isEmpty);
      expect(
        tester.getBottomLeft(backButton).dy,
        lessThanOrEqualTo(floor.height),
      );
      expect(backButton.hitTestable(), findsOneWidget);
      // Back closes the edit route, which is the callback firing.
      await tapAndDrain(tester, backButton);
      expect(routeRecorder.pops, 1);
    });
  });
}
