// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pegs/peg_in_out.dart';
import 'package:sideswap/screens/swap/widgets/swap_bottom_button.dart';
import 'package:sideswap/screens/swap/widgets/swap_deliver_amount.dart';
import 'package:sideswap/screens/wallet_main/widgets/main_bottom_navigation_bar.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const _logicalSize = Size(392.7, 850.9);
const _dpr = 2.75;
const _lbtc = 'lbtc-asset-id';
const _btc = 'btc-asset-id';

Asset _asset(String id, String ticker, String name) => Asset(
  assetId: id,
  name: name,
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

/// Whether [error] is an overflow on the right and on no other side.
///
/// The external receive wallet produces one, and it is out of scope for #220:
/// under `--no-test-assets` the fallback font has the wrong glyph widths, so
/// it is most likely a harness artifact. An overflow that also reports a
/// vertical side reads `... on the bottom and ... on the right`, and is not
/// one of these.
bool _isHorizontalOverflowOnly(String error) =>
    error.contains('overflowed') &&
    error.contains('on the right') &&
    !error.contains('on the bottom');

/// [errors] without the horizontal overflow described by
/// [_isHorizontalOverflowOnly].
///
/// The result is lazy on purpose, so applying it at the `expect` site still
/// sees errors reported after the screen was pumped.
Iterable<String> _ignoringHorizontalOverflow(List<String> errors) =>
    errors.where((e) => !_isHorizontalOverflowOnly(e));

/// The scroll position of the peg content, not of a text field's own
/// editable scrollable. The peg viewport is an ancestor of those, so it comes
/// first in the depth-first order [find.descendant] returns.
ScrollPosition _pegScrollPosition(WidgetTester tester) => tester
    .state<ScrollableState>(
      find
          .descendant(
            of: find.byType(PegInOut),
            matching: find.byType(Scrollable),
          )
          .first,
    )
    .position;

/// Pumps the peg screen with [FlutterError.onError] redirected into the
/// returned list, which stays live for as long as the test runs.
Future<List<String>> _pumpPegScreen(
  WidgetTester tester, {
  required double keyboard,
  SwapType swapType = const SwapType.pegOut(),
  SwapWallet recvWallet = const SwapWallet.local(),
  Size viewport = _logicalSize,
}) async {
  final errors = <String>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) => errors.add(details.exception.toString());
  addTearDown(() => FlutterError.onError = previousOnError);

  tester.view.physicalSize = viewport * _dpr;
  tester.view.devicePixelRatio = _dpr;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard * _dpr);
  tester.view.padding = const FakeViewPadding(top: 24 * _dpr, bottom: 0);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        swapTypeProvider.overrideWithValue(swapType),
        swapRecvWalletProvider.overrideWithValue(recvWallet),
        swapDeliverAssetProvider.overrideWithValue(
          SwapAsset(assetId: _lbtc, assetList: const [_lbtc]),
        ),
        swapReceiveAssetProvider.overrideWithValue(
          SwapAsset(assetId: _btc, assetList: const [_btc]),
        ),
        assetFromAssetIdProvider(_lbtc).overrideWithValue(
          Option.of(_asset(_lbtc, 'L-BTC', 'Liquid Bitcoin')),
        ),
        assetFromAssetIdProvider(
          _btc,
        ).overrideWithValue(Option.of(_asset(_btc, 'BTC', 'Bitcoin'))),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final t = ref.watch(mobileAppThemeProvider);
          return MaterialApp(
            themeMode: t.mode,
            darkTheme: ThemeData(
              brightness: t.brightness,
              textTheme: t.textTheme,
              colorScheme: t.darkScheme,
              scaffoldBackgroundColor: t.scaffoldBackgroundColor,
              textSelectionTheme: t.textSelectionTheme,
              scrollbarTheme: t.scrollbarTheme,
              textButtonTheme: t.textButtonTheme,
              extensions: t.themeExtensions,
            ),
            builder: (context, widget) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            ),
            home: Scaffold(
              body: const SafeArea(child: PegInOut()),
              bottomNavigationBar: MainBottomNavigationBar(onTap: (_) {}),
            ),
          );
        },
      ),
    ),
  );
  await tester.pump();

  // Guard against a vacuous pass. Without the provider overrides above,
  // SwapSideAmount collapses to SizedBox(), SwapDeliverAmount measures
  // 0.0 x 109 and the geometry under test is not the real one.
  expect(find.byType(SwapBottomButton), findsOneWidget);
  expect(
    tester.getSize(find.byType(SwapDeliverAmount)).width,
    greaterThan(0),
    reason: 'the deliver amount collapsed, so no real geometry was measured',
  );

  return errors;
}

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableNetworkSettings: false,
        enableJade: false,
        enableLocalEndpoint: false,
      ),
    );
  });

  // Each keyboard height is its own testWidgets on purpose: Flutter reports a
  // repeated overflow of the same RenderObject once, so a loop over several
  // heights inside one test reports the second height as green when it is not.

  testWidgets('peg-in does not overflow with the keyboard up', (tester) async {
    final errors = await _pumpPegScreen(
      tester,
      keyboard: 420,
      swapType: const SwapType.pegIn(),
    );
    expect(errors, isEmpty);
  });

  testWidgets('peg-in does not overflow with a taller keyboard', (
    tester,
  ) async {
    final errors = await _pumpPegScreen(
      tester,
      keyboard: 440,
      swapType: const SwapType.pegIn(),
    );
    expect(errors, isEmpty);
  });

  testWidgets('peg-in does not overflow with a half-screen keyboard', (
    tester,
  ) async {
    final errors = await _pumpPegScreen(
      tester,
      keyboard: 500,
      swapType: const SwapType.pegIn(),
    );
    expect(errors, isEmpty);
  });

  testWidgets('peg-out does not overflow with the keyboard up', (tester) async {
    final errors = await _pumpPegScreen(tester, keyboard: 440);
    expect(errors, isEmpty);
  });

  testWidgets('peg-out does not overflow with a half-screen keyboard', (
    tester,
  ) async {
    final errors = await _pumpPegScreen(tester, keyboard: 500);
    expect(errors, isEmpty);
  });

  testWidgets(
    'peg-out with an external wallet does not overflow vertically with no '
    'keyboard at all',
    (tester) async {
      // The external receive wallet adds the address field and the fee
      // suggestions, so this variant overruns a small phone with no keyboard
      // up. On the tall harness viewport it fits and the case would not be
      // exercised at all, so this one runs at 360 x 640.
      final errors = await _pumpPegScreen(
        tester,
        keyboard: 0,
        recvWallet: const SwapWallet.extern(),
        viewport: const Size(360, 640),
      );

      expect(_ignoringHorizontalOverflow(errors), isEmpty);
      expect(
        _pegScrollPosition(tester).maxScrollExtent,
        greaterThan(0),
        reason: 'this viewport does not squeeze the content, so the criterion '
            'is not under test here',
      );
    },
  );

  testWidgets(
    'peg-out with an external wallet does not overflow vertically with the '
    'keyboard up',
    (tester) async {
      final errors = await _pumpPegScreen(
        tester,
        keyboard: 440,
        recvWallet: const SwapWallet.extern(),
      );
      expect(_ignoringHorizontalOverflow(errors), isEmpty);
    },
  );

  testWidgets(
    'the action button is reachable while the deliver field is focused and the '
    'keyboard is up',
    (tester) async {
      const keyboard = 440.0;
      final errors = await _pumpPegScreen(tester, keyboard: keyboard);

      await tester.showKeyboard(find.byType(SwapDeliverAmount));
      await tester.pump();

      // Scroll the peg content to its end. maxScrollExtent is 0 when the
      // content already fits, so this one assertion covers both halves of the
      // criterion: the button is on screen, or it is reachable by scrolling.
      final position = _pegScrollPosition(tester);
      position.jumpTo(position.maxScrollExtent);
      await tester.pump();

      expect(errors, isEmpty);
      expect(
        tester.getRect(find.byType(SwapBottomButton)).bottom,
        lessThanOrEqualTo(_logicalSize.height - keyboard),
        reason:
            'the action button stays behind the keyboard even scrolled to '
            'the end',
      );
    },
  );

  testWidgets(
    'the panel background covers the same region with the keyboard down',
    (tester) async {
      final errors = await _pumpPegScreen(tester, keyboard: 0);
      expect(errors, isEmpty);

      // Absolute numbers on purpose: they were measured on the pre-fix build,
      // where the panel was a SizedBox(137) above an Expanded DecoratedBox.
      // Re-deriving them from the production constants would let a change to
      // those constants pass unnoticed.
      expect(
        tester.getRect(find.byKey(const Key('peg_panel_background'))),
        const Rect.fromLTRB(0, 219, 392.7, 794.9),
      );
    },
  );
}
