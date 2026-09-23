/// The order form fixed its body at 331 px inside a `Flexible` column, so a
/// markets page shorter than the panel squeezed the body and clipped CONTINUE
/// out of sight. `Flexible` alone squeezes and clips: ADR-0014 decision 8.
/// These tests measure both tabs of the panel at both page heights.
///
/// Both tabs now take the same shape (#267): a body that sizes to its content
/// inside a *maximum* of 331 px, one scroll owner, a scrollbar thumb, and
/// CONTINUE as the last element of the scroll body rather than a pinned band.
/// See the amendment to ADR-0014 decision 8.
///
/// "One scroll owner" is asserted as one `CustomScrollView` per tab, not as
/// one `Scrollable`: every `EditableText` in the form builds a `Scrollable` of
/// its own, so a bare descendant count can never be one.
library;

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

/// The one market the panel is subscribed to. The panel renders nothing at all
/// while either the asset pair or the market info is `None`.
final _assetPair = AssetPair(base: 'base', quote: 'quote');
final _marketInfo = MarketInfo(assetPair: _assetPair);

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

class FakeSubscribedAssetPair extends MarketSubscribedAssetPairNotifier {
  @override
  Option<AssetPair> build() => Option.of(_assetPair);
}

/// Puts the panel on the market-order tab. The notifier starts on the limit
/// tab, so without this the market form is never built.
class FakeMarketTypeSwitchState extends MarketTypeSwitchStateNotifier {
  @override
  MarketTypeSwitchState build() => MarketTypeSwitchState.market();
}

/// Puts the form on the sell side. The notifier starts on `BUY`, and the two
/// sides render different error rows, so both are measured.
class FakeSellTradeDirState extends TradeDirStateNotifier {
  @override
  TradeDir build() => TradeDir.SELL;
}

/// A quote error long enough to outgrow the box the error rows used to scroll
/// inside. The body has to grow with it instead.
const _longQuoteError =
    'The market rejected this order because the quote expired before it '
    'reached the server, and the price has moved far enough since that the '
    'order can no longer be filled at the amount that was asked for. Enter '
    'the amount again to request a fresh quote.';

/// A page height with room to spare, so the panel takes its natural height and
/// nothing about today's layout changes.
const _tallColumnHeight = 620.0;

/// The height the markets page leaves the order column at the supported floor,
/// once the page splits the shortfall the way ADR-0014 decision 11 asks.
///
/// The ADR measures 506 px of page content at a 620 px client; the page spends
/// 16 of it on its own padding and 16 on the gap, and the transactions panel
/// keeps its 227 px minimum. 506 - 16 - 16 - 227 = 247. The page half of that
/// split is issue #258's; the panel has to survive the height either way, so
/// the number is used here as the short case, not as a promise about the page.
const _floorColumnHeight = 247.0;

void main() {
  setUp(installSurfaceTestEnv);

  Future<void> pump(
    WidgetTester tester,
    double columnHeight, {
    List<Override> extraOverrides = const [],
  }) => tester.runAsync(() async {
    sizeView(tester, Size(floor.width, columnHeight));
    final container = ProviderContainer.test(
      overrides: [
        ...extraOverrides,
        marketSubscribedAssetPairProvider.overrideWith(
          FakeSubscribedAssetPair.new,
        ),
        subscribedMarketInfoProvider.overrideWithValue(Option.of(_marketInfo)),
        // The market form matches on both assets and renders a bare `SizedBox`
        // while either is `None`, which would let a floor test pass on an
        // empty panel.
        marketSubscribedBaseAssetProvider.overrideWithValue(
          Option.of(_asset('base', 'BASE')),
        ),
        marketSubscribedQuoteAssetProvider.overrideWithValue(
          Option.of(_asset('quote', 'QUOTE')),
        ),
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
          home: Scaffold(
            // The page gives the panel exactly the height it has left, the way
            // the markets page's row does.
            body: SizedBox(
              height: columnHeight,
              child: const MarketOrderPanel(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    // `AnimatedDropdownArrow` runs under `flutter_animate`, which schedules a
    // zero-duration timer the creating frame cannot run; only a settling pump
    // drains it. Prior art: test/widgets/market_limit_page_jade_test.dart.
    await tester.pumpAndSettle();
  });

  /// The limit form's own scroll owner, scoped to the form rather than taken as
  /// "the one `Scrollable` in the tree".
  final limitScrollView = find.descendant(
    of: find.byType(LimitPanel),
    matching: find.byType(CustomScrollView),
  );

  /// The market form's own scroll owner.
  final marketScrollView = find.descendant(
    of: find.byType(MarketPanel),
    matching: find.byType(CustomScrollView),
  );

  /// The `Scrollable` that [scrollView] itself created, for
  /// `scrollUntilVisible`.
  ///
  /// `.first` for the reason [extentOf] takes it: finders walk depth-first from
  /// [scrollView], so its own `Scrollable` comes before the one every
  /// `EditableText` in the form builds.
  Finder scrollableOf(Finder scrollView) =>
      find.descendant(of: scrollView, matching: find.byType(Scrollable)).first;

  /// Scrolls [scrollView] until CONTINUE is on screen and returns its finder.
  ///
  /// The gesture is the wheel scroll the manual test plan asks for: the button
  /// is the last element of the scroll body, so at the floor it is reachable
  /// rather than already visible.
  Future<Finder> scrollToButton(WidgetTester tester, Finder scrollView) async {
    // `hitTestable()` rather than the bare type: where the button is already
    // in the tree just below the fold, a plain finder stops the scroll before
    // it has moved anything.
    final button = find.byType(MarketOrderButton).hitTestable();
    await tester.scrollUntilVisible(
      button,
      120,
      scrollable: scrollableOf(scrollView),
    );
    return button;
  }

  /// The scroll owners the whole order panel holds, whichever tab is up.
  ///
  /// Scoped to `MarketOrderPanel` rather than to a tab, so a second owner
  /// appearing between the panel root and the tab is caught too.
  final panelScrollViews = find.descendant(
    of: find.byType(MarketOrderPanel),
    matching: find.byType(CustomScrollView),
  );

  /// Asserts CONTINUE sits at the bottom edge of the form [panel] draws.
  ///
  /// [slack] is the padding between the button and that edge, so it is
  /// per-tab and exact: the market tab spends 6 + 1 + 6 px below the button
  /// and the limit tab 8 + 1 + 6. Prior art: `expectPinnedToCardBottom` in
  /// surface_floor.dart.
  void expectButtonAtFormBottom(
    WidgetTester tester,
    Finder panel, {
    required double slack,
  }) {
    expect(
      tester.getRect(panel).bottom -
          tester.getRect(find.byType(MarketOrderButton)).bottom,
      lessThanOrEqualTo(slack),
    );
  }

  group('limit order tab', () {
    testWidgets('with room to spare nothing overflows, the body does not '
        'scroll and CONTINUE sits at the bottom of the form', (tester) async {
      final errors = captureOverflow();

      await pump(tester, _tallColumnHeight);

      expect(find.byType(MarketOrderButton), findsOneWidget);
      expect(extentOf(tester, limitScrollView), 0);
      // Both tabs draw the same button. The market tab took the form's whole
      // width until it was given the fields' 8 px inset.
      expect(tester.getSize(find.byType(DCustomFilledBigButton)).width, 343);
      expectButtonAtFormBottom(tester, find.byType(LimitPanel), slack: 15);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor page height nothing overflows, the body scrolls '
        'and CONTINUE is one scroll away', (tester) async {
      final errors = captureOverflow();

      await pump(tester, _floorColumnHeight);

      expect(verticalOverflows(errors), isEmpty);
      expect(limitScrollView, findsOneWidget);
      expect(panelScrollViews, findsOneWidget);
      expect(extentOf(tester, limitScrollView), greaterThan(0));

      final button = await scrollToButton(tester, limitScrollView);
      expect(button, findsOneWidget);
      expect(
        tester.getRect(button).bottom,
        lessThanOrEqualTo(_floorColumnHeight),
      );
    });

    testWidgets('at the floor page height the sell side scrolls and CONTINUE '
        'is one scroll away', (tester) async {
      final errors = captureOverflow();

      // The sell side draws the amount field's MAX button, so the two sides
      // do not lay out to the same height.
      await pump(
        tester,
        _floorColumnHeight,
        extraOverrides: [
          tradeDirStateProvider.overrideWith(FakeSellTradeDirState.new),
        ],
      );

      expect(verticalOverflows(errors), isEmpty);
      expect(limitScrollView, findsOneWidget);
      expect(panelScrollViews, findsOneWidget);
      expect(extentOf(tester, limitScrollView), greaterThan(0));

      final button = await scrollToButton(tester, limitScrollView);
      expect(button, findsOneWidget);
    });
  });

  group('market order tab', () {
    final onMarketTab = [
      marketTypeSwitchStateProvider.overrideWith(FakeMarketTypeSwitchState.new),
    ];

    testWidgets('with room to spare nothing overflows, the body does not '
        'scroll and CONTINUE sits at the bottom of the form', (tester) async {
      final errors = captureOverflow();

      await pump(tester, _tallColumnHeight, extraOverrides: onMarketTab);

      expect(find.byType(MarketPanel), findsOneWidget);
      expect(extentOf(tester, marketScrollView), 0);
      expectButtonAtFormBottom(tester, find.byType(MarketPanel), slack: 13);
      expect(tester.getSize(find.byType(DCustomFilledBigButton)).width, 343);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor page height nothing overflows, the body scrolls '
        'and CONTINUE is one scroll away', (tester) async {
      final errors = captureOverflow();

      await pump(tester, _floorColumnHeight, extraOverrides: onMarketTab);

      expect(verticalOverflows(errors), isEmpty);
      // One scroll owner: the form scrolls as a single body, so a wheel
      // gesture over the quote rows moves the whole form. ADR-0014 decision 9.
      expect(marketScrollView, findsOneWidget);
      expect(panelScrollViews, findsOneWidget);
      expect(find.byType(DScrollWhenShort), findsNothing);
      expect(extentOf(tester, marketScrollView), greaterThan(0));

      final button = await scrollToButton(tester, marketScrollView);
      expect(button, findsOneWidget);
    });

    testWidgets('at the floor page height the sell side scrolls and CONTINUE '
        'is one scroll away', (tester) async {
      final errors = captureOverflow();

      await pump(
        tester,
        _floorColumnHeight,
        extraOverrides: [
          ...onMarketTab,
          tradeDirStateProvider.overrideWith(FakeSellTradeDirState.new),
        ],
      );

      expect(verticalOverflows(errors), isEmpty);
      expect(marketScrollView, findsOneWidget);
      expect(extentOf(tester, marketScrollView), greaterThan(0));

      final button = await scrollToButton(tester, marketScrollView);
      expect(button, findsOneWidget);
    });

    for (final (side, sideOverrides) in [
      ('buy', const <Override>[]),
      ('sell', [tradeDirStateProvider.overrideWith(FakeSellTradeDirState.new)]),
    ]) {
      testWidgets('at the floor page height a long quote error grows the '
          '$side body instead of scrolling inside a box', (tester) async {
        final errors = captureOverflow();

        await pump(
          tester,
          _floorColumnHeight,
          extraOverrides: [
            ...onMarketTab,
            ...sideOverrides,
            marketQuoteErrorProvider.overrideWithValue(
              Option.of(const QuoteError(error: _longQuoteError, orderId: 1)),
            ),
          ],
        );

        expect(verticalOverflows(errors), isEmpty);

        // The error lays out taller than the whole form, and the form's own
        // scroll content is taller still. A box of its own would scroll the
        // error internally and leave the form's content height unchanged, so
        // this is what proves the rows sit in the form's scroll body.
        final error = find.text(_longQuoteError);
        expect(error, findsOneWidget);
        final errorHeight = tester.getSize(error).height;
        expect(
          errorHeight,
          greaterThan(tester.getSize(find.byType(MarketPanel)).height),
        );
        expect(
          tester.getSize(marketScrollView).height +
              extentOf(tester, marketScrollView),
          greaterThan(errorHeight),
        );

        // ... and the whole of it is reachable: the last line is on screen
        // once the body is scrolled to its end.
        final button = await scrollToButton(tester, marketScrollView);
        expect(button, findsOneWidget);
        expect(
          tester.getRect(error).bottom,
          lessThanOrEqualTo(tester.getRect(find.byType(MarketPanel)).bottom),
        );
      });
    }

    testWidgets('at the floor page height the unregistered-AMP-ID error grows '
        'the body instead of scrolling inside a box', (tester) async {
      final errors = captureOverflow();

      await pump(
        tester,
        _floorColumnHeight,
        extraOverrides: [
          ...onMarketTab,
          marketQuoteUnregisteredGaidProvider.overrideWithValue(
            Option.of(
              QuoteUnregisteredGaid(
                orderId: Int64(1),
                quoteUnregisteredGaid: From_Quote_UnregisteredGaid(
                  domainAgent: 'agent.example.com',
                ),
              ),
            ),
          ),
        ],
      );

      expect(verticalOverflows(errors), isEmpty);
      // Four stacked rows and a link, none of them in a box of their own.
      expect(find.text('Unregistered AMP ID'), findsOneWidget);
      expect(find.text('https://agent.example.com'), findsOneWidget);
      expect(extentOf(tester, marketScrollView), greaterThan(0));

      final button = await scrollToButton(tester, marketScrollView);
      expect(button, findsOneWidget);
    });
  });

  group('scrollbar', () {
    for (final (name, overrides, tab) in [
      ('limit order tab', const <Override>[], LimitPanel),
      ('market order tab', [
        marketTypeSwitchStateProvider.overrideWith(
          FakeMarketTypeSwitchState.new,
        ),
      ], MarketPanel),
    ]) {
      testWidgets('$name shows a thumb when the body can scroll', (
        tester,
      ) async {
        final errors = captureOverflow();

        await pump(tester, _floorColumnHeight, extraOverrides: overrides);

        expect(verticalOverflows(errors), isEmpty);

        // Both halves in one test: a thumb-visible `Scrollbar` on a body that
        // has somewhere to scroll to. Either alone is satisfiable by a
        // scrollbar attached to nothing.
        final tabScrollView = find.descendant(
          of: find.byType(tab),
          matching: find.byType(CustomScrollView),
        );
        expect(extentOf(tester, tabScrollView), greaterThan(0));

        final scrollbar = find.descendant(
          of: find.byType(MarketOrderPanel),
          matching: find.byType(Scrollbar),
        );
        expect(scrollbar, findsOneWidget);
        expect(tester.widget<Scrollbar>(scrollbar).thumbVisibility, isTrue);
      });
    }
  });
}
