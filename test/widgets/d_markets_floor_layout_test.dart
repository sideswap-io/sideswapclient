// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/desktop_page_heights.dart';
import '../helpers/fake_shared_preferences.dart';
import '../helpers/ignore_overflow.dart';

class MockWallet extends Mock implements SideswapWallet {}

Asset _asset(String id, String ticker) => Asset(
  assetId: id,
  name: ticker,
  ticker: ticker,
  icon: '',
  precision: 8,
  swapMarket: true,
  domain: '',
  unregistered: false,
  ampMarket: false,
  domainAgent: '',
  instantSwaps: false,
);

final _marketInfo = MarketInfo()
  ..assetPair = (AssetPair()
    ..base = 'base'
    ..quote = 'quote')
  ..feeAsset = AssetType.BASE;

void main() {
  late MockWallet wallet;
  late FakeSharedPreferences prefs;

  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    wallet = MockWallet();
    prefs = FakeSharedPreferences();
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
        isDesktop: true,
      ),
    );
  });

  /// A subscribed market showing the *market* order form. Without every one of
  /// these overrides `MarketPanel` returns a `SizedBox()` and the order form
  /// does not render at all, which would make every assertion below vacuous.
  ProviderContainer makeContainer({bool market = true}) {
    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWith((ref) => wallet),
        sharedPreferencesProvider.overrideWithValue(prefs),
        navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
        localesProvider.overrideWithValue('en'),
        subscribedMarketInfoProvider.overrideWithValue(Option.of(_marketInfo)),
        baseAssetByMarketInfoProvider(_marketInfo)
            .overrideWithValue(Option.of(_asset('base', 'BASE'))),
        quoteAssetByMarketInfoProvider(_marketInfo)
            .overrideWithValue(Option.of(_asset('quote', 'QUOTE'))),
        marketSubscribedBaseAssetProvider.overrideWithValue(
          Option.of(_asset('base', 'BASE')),
        ),
        marketSubscribedQuoteAssetProvider.overrideWithValue(
          Option.of(_asset('quote', 'QUOTE')),
        ),
      ],
    );
    if (market) {
      container
          .read(marketTypeSwitchStateProvider.notifier)
          .setState(MarketTypeSwitchState.market());
    }
    return container;
  }

  /// The desktop panels resolve their theme through throwaway
  /// `ProviderContainer`s whose dispose timers never settle under fake async,
  /// so every pump runs inside `runAsync` -- prior art:
  /// test/widgets/d_settings_test.dart.
  Future<void> pumpMarkets(
    WidgetTester tester,
    ProviderContainer container, {
    required double content,
  }) => tester.runAsync(() async {
    tester.view.physicalSize = Size(1072, content);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(
            splashFactory: NoSplash.splashFactory,
            extensions: container.read(desktopAppThemeProvider).themeExtensions,
          ),
          home: const Scaffold(body: DMarkets()),
        ),
      ),
    );
    await tester.pump();
  });

  double heightOf(WidgetTester tester, Finder finder) =>
      tester.getSize(finder).height;

  /// The page's *own* scroll owner. `OrdersView`, the tab bodies and the order
  /// form's own error list all bring scrollables of their own; a page-level
  /// owner would be a `DScrollWhenShort`, and this page gains none. It yields
  /// height instead, and the order form keeps the scrollables it already owns
  /// — `ScrollOwner.child` of ADR-0014 decision 9. A scroll view added around
  /// the order column would nest over those and swallow the wheel.
  ///
  /// `MarketPanel` owns one scroll view of its own — the order form's body,
  /// which carries CONTINUE at its end (#267) — so it is excluded here. A
  /// finder that counted it too would fail on a page that gained no owner at
  /// all.
  /// The order form's own owner, asserted alongside [ownScrollView] so the
  /// exclusion above cannot hide a second owner nested inside `MarketPanel`.
  final orderFormScrollView = find.descendant(
    of: find.byType(MarketPanel),
    matching: find.byType(CustomScrollView),
  );

  final ownScrollView = find.byElementPredicate((element) {
    if (element.widget is! DScrollWhenShort) {
      return false;
    }
    var underMarkets = false;
    var underOrderForm = false;
    element.visitAncestorElements((ancestor) {
      if (ancestor.widget is MarketPanel) {
        underOrderForm = true;
      }
      if (ancestor.widget is DMarkets) {
        underMarkets = true;
      }
      return true;
    });
    return underMarkets && !underOrderForm;
  });

  testWidgets('at the design height the order column and the history panel '
      'keep the heights they have today', (tester) async {
    final errors = captureOverflowErrors();
    final container = makeContainer();
    await pumpMarkets(tester, container, content: designContent);

    expect(heightOf(tester, find.byType(MarketOrderPanel)), 466);
    expect(heightOf(tester, find.byType(DTxAndOrdersPanel)), 228);
    expect(ownScrollView, findsNothing);
    expect(orderFormScrollView, findsOneWidget);
    // Zero since #267. The form used to be a stack of fixed boxes that the
    // block font of `--no-test-assets` pushed about 14 px past the layout it
    // was built for; it now sizes to its content, so the block font moves the
    // scroll extent instead of the page. ADR-0014 decision 13 records the same
    // caution — a layout test bounds the box, the on-device check bounds the
    // glyphs.
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor the history panel and the order column split the '
      'shortfall', (tester) async {
    final errors = captureOverflowErrors();
    final container = makeContainer();
    await pumpMarkets(tester, container, content: floorContent);

    // Before: the history panel took its whole 228 px first and the order
    // column absorbed the entire shortfall at 246 px. Both halves in one
    // test: either alone is satisfiable by a fix that moves height the wrong
    // way.
    expect(heightOf(tester, find.byType(DTxAndOrdersPanel)), lessThan(228));
    expect(heightOf(tester, find.byType(MarketOrderPanel)), greaterThan(246));
    expect(ownScrollView, findsNothing);
    expect(orderFormScrollView, findsOneWidget);
    // The page overflowed by 234 px at the floor before #258 split the
    // shortfall, and by the order form's own excess after it. #267 made the
    // form size to the column it lives in, so nothing overflows at all now.
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor the default limit form does not overflow', (
    tester,
  ) async {
    final errors = captureOverflowErrors();
    // `MarketTypeSwitchStateNotifier` builds to `limit()`, so this is the
    // state the page opens in.
    final container = makeContainer(market: false);
    await pumpMarkets(tester, container, content: floorContent);

    expect(heightOf(tester, find.byType(DTxAndOrdersPanel)), lessThan(228));
    expect(heightOf(tester, find.byType(MarketOrderPanel)), greaterThan(246));
    expect(verticalOverflows(errors), isEmpty);
    // No `orderFormScrollView` here: the limit state subscribes to no market,
    // so `MarketPanel` builds a `SizedBox()` and owns nothing to find.
    expect(ownScrollView, findsNothing);
  });

  testWidgets('at the floor the order action is one scroll away', (
    tester,
  ) async {
    final errors = captureOverflowErrors();
    await pumpMarkets(tester, makeContainer(), content: floorContent);

    // `captureOverflowErrors` diverts overflow away from the error handler, so
    // without this the test would pass on an overflowing page.
    expect(verticalOverflows(errors), isEmpty);

    // Before #267 the market order form was 339 px of fixed boxes in a column
    // that has 226 px for it at the floor, so its action was pushed outside
    // the panel at `Rect.fromLTRB(33, 437, 376, 483)` and could not be
    // reached at all. The form now sizes to the column and carries CONTINUE
    // at the end of its own scroll body, so the action is inside the panel
    // and hit-testable.
    // The action is the last element of the order form's own scroll body, so
    // at the floor it is one wheel scroll away rather than already on screen.
    // `hitTestable()` rather than the bare type: the button is already in
    // the tree 12 px below the fold, so a plain finder stops the scroll before
    // it has moved anything.
    final button = find.byType(MarketOrderButton).hitTestable();
    await tester.scrollUntilVisible(
      button,
      120,
      scrollable: find
          .descendant(of: orderFormScrollView, matching: find.byType(Scrollable))
          .first,
    );
    expect(button, findsOneWidget);
  });
}
