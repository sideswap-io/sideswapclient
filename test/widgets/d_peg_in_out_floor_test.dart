// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pegs/d_peg_in_out.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_button.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/desktop_page_heights.dart';
import '../helpers/fake_shared_preferences.dart';
import '../helpers/ignore_overflow.dart';

class MockWallet extends Mock implements SideswapWallet {}

class MockPegRepository extends Mock implements AbstractPegRepository {}

class MockSwapHelper extends Mock implements SwapHelper {}

void main() {
  late MockWallet wallet;
  late MockPegRepository pegRepository;
  late MockSwapHelper swapHelper;
  late FakeSharedPreferences prefs;

  setUpAll(() {
    registerFallbackValue(ActivePage.OTHER);
  });

  setUp(() {
    // The peg-in copy is interpolated, and `--no-test-assets` never runs
    // `EasyLocalization`'s asset loader -- prior art:
    // test/widgets/peg_in_info_lines_test.dart.
    Localization.load(const Locale('en'), translations: Translations({}));
    wallet = MockWallet();
    prefs = FakeSharedPreferences();
    // The loaded balance is what makes the peg-in body render its full copy,
    // and therefore what makes the page's real height observable at all.
    pegRepository = MockPegRepository();
    when(
      () => pegRepository.setActivePage(activePage: any(named: 'activePage')),
    ).thenReturn(null);
    when(pegRepository.pegInWalletBalanceLoaded).thenReturn(true);
    when(pegRepository.pegInInstantCreditAvailable).thenReturn(true);
    when(pegRepository.pegInWalletBalance).thenReturn('0.01');
    when(pegRepository.pegInMinAmount).thenReturn('0.0001');
    when(pegRepository.pegOutMinAmount).thenReturn('0.0001');
    when(pegRepository.pegOutWalletBalance).thenReturn('0.01');
    when(pegRepository.pegOutNextBlockFeeRate).thenReturn('1.0');
    when(pegRepository.getPegOutAmount).thenReturn(null);
    swapHelper = MockSwapHelper();
    when(swapHelper.switchToPegs).thenReturn(null);
    when(swapHelper.toggleAssets).thenReturn(null);
    when(swapHelper.swapAccept).thenReturn(null);
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

  ProviderContainer makeContainer({required SwapType swapType}) =>
      ProviderContainer.test(
        overrides: [
          walletProvider.overrideWith((ref) => wallet),
          sharedPreferencesProvider.overrideWithValue(prefs),
          navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
          localesProvider.overrideWithValue('en'),
          pegRepositoryProvider.overrideWith((ref) => pegRepository),
          swapHelperProvider.overrideWith((ref) => swapHelper),
          swapTypeProvider.overrideWithValue(swapType),
          swapEnabledStateProvider.overrideWithValue(true),
        ],
      );

  /// The screen's `DButton`s resolve their theme through throwaway
  /// `ProviderContainer`s whose dispose timers never settle under fake async,
  /// so every pump runs inside `runAsync` -- prior art:
  /// test/widgets/d_peg_in_out_init_test.dart.
  Future<void> pumpPeg(
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
          home: const DPegInOut(),
        ),
      ),
    );
    await tester.pump();
  });

  /// The page's own scroll owner: `DScrollWhenShort` on the peg-out branch,
  /// whose form is built of fixed boxes, and a plain scroll view over a
  /// *minimum* design height on the peg-in branch, whose body is growable
  /// copy. `DScrollWhenShort` is itself a `SingleChildScrollView`, so this
  /// finds exactly one of them either way — nothing under `DPegIn` or
  /// `DPegOut` brings a scroll view of its own.
  final ownScrollView = find.descendant(
    of: find.byType(DPegInOut),
    matching: find.byType(SingleChildScrollView),
  );

  double extentOf(WidgetTester tester) => tester
      .state<ScrollableState>(
        find
            .descendant(of: ownScrollView, matching: find.byType(Scrollable))
            .first,
      )
      .position
      .maxScrollExtent;

  double cardHeight(WidgetTester tester) => tester
      .getSize(
        find
            .descendant(
              of: find.byType(DPegInOut),
              matching: find.byType(Container),
            )
            .first,
      )
      .height;

  for (final (name, swapType) in [
    ('peg-in', const SwapType.pegIn()),
    ('peg-out', const SwapType.pegOut()),
  ]) {
    testWidgets('at the design height the $name card keeps its size and '
        'nothing scrolls', (tester) async {
      final errors = captureOverflowErrors();
      await pumpPeg(
        tester,
        makeContainer(swapType: swapType),
        content: designContent,
      );

      expect(cardHeight(tester), kPegCardHeight);
      expect(ownScrollView, findsOneWidget);
      expect(extentOf(tester), 0);
      expect(verticalOverflows(errors), isEmpty);
    });
  }

  testWidgets('at the floor the peg-in body scrolls instead of overflowing', (
    tester,
  ) async {
    final errors = captureOverflowErrors();
    await pumpPeg(
      tester,
      makeContainer(swapType: const SwapType.pegIn()),
      content: floorContent,
    );

    // Today the card squeezes to the viewport and the peg-in copy overflows
    // the bottom of it by 19 px.
    expect(verticalOverflows(errors), isEmpty);
    expect(extentOf(tester), greaterThan(0));
  });

  testWidgets('at the design height the peg-out action sits where it does '
      'today', (tester) async {
    await pumpPeg(
      tester,
      makeContainer(swapType: const SwapType.pegOut()),
      content: designContent,
    );

    // The card is centred in the 726 px content area, so its top is at 23.
    expect(tester.getRect(find.byType(SwapBottomButton)).top, 621);
    expect(tester.getRect(find.byType(SwapBottomButton)).bottom, 679);
  });

  testWidgets('at the floor the peg-out action is pinned outside the scroll '
      'body, reachable, and live', (tester) async {
    final errors = captureOverflowErrors();
    await pumpPeg(
      tester,
      makeContainer(swapType: const SwapType.pegOut()),
      content: floorContent,
    );

    // `SwapBottomButton` is hit-testable at the floor before this change too:
    // the `Container(height: 680)` clamps to the viewport under `Center`, and
    // the `Spacer()` above the button parks it at the bottom of the squeezed
    // card. What is new is that it is no longer part of the scroll body, so
    // it stays put whatever the body does.
    expect(
      find.descendant(
        of: ownScrollView,
        matching: find.byType(SwapBottomButton),
      ),
      findsNothing,
    );
    expect(extentOf(tester), greaterThan(0));
    expect(find.byType(SwapBottomButton).hitTestable(), findsOneWidget);
    expect(verticalOverflows(errors), isEmpty);

    await tester.runAsync(() async {
      await tester.tap(find.byType(SwapBottomButton));
      await tester.pump();
    });

    verify(swapHelper.swapAccept).called(1);
  });
}
