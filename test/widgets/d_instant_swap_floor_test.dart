// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/instant_swap/d_instant_swap.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/instant_swap/instant_swap.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/desktop_page_heights.dart';
import '../helpers/fake_shared_preferences.dart';
import '../helpers/ignore_overflow.dart';
import '../helpers/jade_lock_repository.dart';

class MockWallet extends Mock implements SideswapWallet {}

class MockAmountToString extends Mock implements AmountToString {}

QuoteSuccess _quoteSuccess() => QuoteSuccess(
  MockAmountToString(),
  From_Quote_Success()..priceTaker = 1.5,
  AssetPair()
    ..base = 'base'
    ..quote = 'quote',
  AssetType.BASE,
  TradeDir.SELL,
  AssetType.BASE,
  {},
  1,
);

void main() {
  late MockWallet wallet;
  late FakeSharedPreferences prefs;
  late MockJadeLockRepository jade;

  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    wallet = MockWallet();
    prefs = FakeSharedPreferences();
    // A locked jade: `acceptQuote` then asks the repository to refresh its
    // lock state and stops, which is the shallowest observable effect the
    // primary action has. What matters here is that the tap reaches it.
    jade = lockedJadeLockRepository();
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: true,
        enableLocalEndpoint: false,
        isDesktop: true,
      ),
    );
  });

  ProviderContainer makeContainer() => ProviderContainer.test(
    overrides: [
      walletProvider.overrideWith((ref) => wallet),
      sharedPreferencesProvider.overrideWithValue(prefs),
      navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
      localesProvider.overrideWithValue('en'),
      jadeLockRepositoryProvider.overrideWith((ref) => jade),
      jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
      exchangeSwapButtonEnabledProvider.overrideWithValue(true),
      exchangeQuoteSuccessProvider.overrideWithValue(
        Option.of(_quoteSuccess()),
      ),
    ],
  );

  /// The buttons resolve their theme through throwaway `ProviderContainer`s
  /// whose dispose timers never settle under fake async, so every pump runs
  /// inside `runAsync` -- prior art: test/widgets/d_settings_test.dart.
  Future<void> pumpSwap(
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
          home: const Scaffold(body: DInstantSwap()),
        ),
      ),
    );
    await tester.pump();
  });

  /// The page's own scroll owner.
  final ownScrollView = find.descendant(
    of: find.byType(DInstantSwap),
    matching: find.byType(DScrollWhenShort),
  );

  double extentOf(WidgetTester tester) => tester
      .state<ScrollableState>(
        find
            .descendant(of: ownScrollView, matching: find.byType(Scrollable))
            .first,
      )
      .position
      .maxScrollExtent;

  testWidgets('at the design height the card keeps its size, the primary '
      'action sits where it does today, and nothing scrolls', (tester) async {
    final errors = captureOverflowErrors();
    await pumpSwap(tester, makeContainer(), content: designContent);

    expect(ownScrollView, findsOneWidget);
    expect(extentOf(tester), 0);
    // The card and the button's place in it, unchanged.
    expect(tester.getSize(find.byType(InstantSwap)).height, 561);
    expect(tester.getRect(find.byType(InstantSwapButton)).top, 519);
    expect(tester.getRect(find.byType(InstantSwapButton)).bottom, 573);
    expect(find.byType(InstantSwapButton).hitTestable(), findsOneWidget);
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('leaves the form room to grow before its fixed body box clips', (
    tester,
  ) async {
    await pumpSwap(tester, makeContainer(), content: designContent);

    // `DScrollWhenShort` lays its child out in a box of a fixed height and
    // computes the scroll extent from the box, so content that outgrows the
    // box is clipped rather than scrolled -- its second documented
    // precondition. What keeps this body inside it is the backdrop below the
    // form, which yields first: a validation error line under an amount
    // field, or a longer translation, eats that slack long before anything
    // is clipped.
    final formBottom = tester
        .getRect(find.byType(InstantSwapBottomDropdownAmountTextField))
        .bottom;
    final actionTop = tester.getRect(find.byType(InstantSwapButton)).top;

    expect(actionTop - formBottom, greaterThan(200));
  });

  testWidgets('at the floor the primary action is pinned outside the scroll '
      'body, reachable, and live', (tester) async {
    final errors = captureOverflowErrors();
    final container = makeContainer();
    await pumpSwap(tester, container, content: floorContent);

    // Today the page needs 28 + 561 px of a 506 px content area, so it
    // overflows by 83 px and the button lies below the fold.
    expect(verticalOverflows(errors), isEmpty);
    expect(extentOf(tester), greaterThan(0));
    // The action stays outside the scroll body...
    expect(
      find.descendant(
        of: ownScrollView,
        matching: find.byType(InstantSwapButton),
      ),
      findsNothing,
    );
    // ...and is reachable rather than merely present.
    expect(find.byType(InstantSwapButton).hitTestable(), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.byType(InstantSwapButton));
      await tester.pump();
    });

    verify(jade.refreshJadeLockState).called(1);
  });

  testWidgets('keeps the primary action inside its own body by default, so '
      'the mobile page is unchanged', (tester) async {
    final container = makeContainer();
    await tester.runAsync(() async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(
              splashFactory: NoSplash.splashFactory,
              extensions: container
                  .read(desktopAppThemeProvider)
                  .themeExtensions,
            ),
            home: const Scaffold(body: InstantSwap()),
          ),
        ),
      );
      await tester.pump();
    });

    expect(
      find.descendant(
        of: find.byType(InstantSwap),
        matching: find.byType(DScrollWhenShort),
      ),
      findsNothing,
    );
    expect(find.byType(InstantSwapButton), findsOneWidget);
  });

  /// Every box the card paints the lighter `blumine` backdrop with, in
  /// top-to-bottom order, whatever widget paints it.
  List<Rect> blumineRects(WidgetTester tester) {
    bool isBlumine(Widget widget) => switch (widget) {
      ColoredBox(:final color) => color == SideSwapColors.blumine,
      DecoratedBox(decoration: BoxDecoration(:final color)) =>
        color == SideSwapColors.blumine,
      _ => false,
    };

    final rects = find
        .descendant(
          of: find.byType(InstantSwap),
          matching: find.byWidgetPredicate((widget) => isBlumine(widget)),
        )
        .evaluate()
        .map((element) {
          final box = element.renderObject! as RenderBox;
          return box.localToGlobal(Offset.zero) & box.size;
        })
        .toList();

    return rects..sort((a, b) => a.top.compareTo(b.top));
  }

  /// At the floor the body scrolls, so the fill sits partly below the fold
  /// and the pinned action alone paints the bottom of the card. The region
  /// stays unbroken either way.
  for (final (label, content) in [
    ('at the design height', designContent),
    ('at the floor', floorContent),
  ]) {
    testWidgets('$label it paints the backdrop as one unbroken region, the '
        'width of the card and down to its bottom edge', (tester) async {
      await pumpSwap(tester, makeContainer(), content: content);

      final card = tester.getRect(find.byType(InstantSwap));
      final rects = blumineRects(tester);
      expect(rects, isNotEmpty);

      // The pinned action paints the last of these boxes, so the region ends
      // exactly at the bottom of the card...
      var covered = rects.first.top;
      for (final rect in rects) {
        // ...every box spans the card, leaving no strip of the darker card
        // colour at either edge...
        expect(rect.left, card.left, reason: 'left edge of $rect');
        expect(rect.right, card.right, reason: 'right edge of $rect');
        // ...and each one starts no lower than the one above it ends, so no
        // horizontal band of the card colour cuts the region in two.
        expect(rect.top, lessThanOrEqualTo(covered), reason: 'gap above $rect');
        covered = covered > rect.bottom ? covered : rect.bottom;
      }
      // The region reaches the bottom edge of the card. At the floor it runs
      // past it: the fill is laid out at its design height and the scroll
      // viewport clips what hangs below, which paints nothing.
      expect(covered, greaterThanOrEqualTo(card.bottom));
    });
  }
}
