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
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/ignore_overflow.dart';
import '../helpers/jade_lock_repository.dart';

/// The real notifier starts at `Option.none()`, which makes `LimitPanel` render
/// an empty `SizedBox` and hides the button this test taps.
class _FixedAssetPair extends MarketSubscribedAssetPairNotifier {
  _FixedAssetPair(this._assetPair);

  final AssetPair _assetPair;

  @override
  Option<AssetPair> build() => Option.of(_assetPair);
}

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

void main() {
  setUp(() {
    Localization.load(const Locale('en'), translations: Translations({}));
    // The panel's order button renders the desktop branch; the mobile one
    // reads a `CustomBigButtonStyle` theme extension this harness has not got.
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

  tearDownAll(() {
    Localization.load(const Locale('en'), translations: Translations({}));
  });

  testWidgets(
    'locked jade trade button refreshes the current repository, not the one '
    'that was current when the button was first built',
    (tester) async {
      ignoreOverflow();

      final first = lockedJadeLockRepository();
      final second = lockedJadeLockRepository();

      final baseAsset = _asset('base', 'BASE');
      final quoteAsset = _asset('quote', 'QUOTE');
      final assetPair = AssetPair(
        base: baseAsset.assetId,
        quote: quoteAsset.assetId,
      );
      final marketInfo = MarketInfo()
        ..assetPair = assetPair
        ..feeAsset = AssetType.BASE;

      final container = ProviderContainer.test(
        overrides: [
          marketSubscribedBaseAssetProvider.overrideWithValue(
            Option.of(baseAsset),
          ),
          marketSubscribedQuoteAssetProvider.overrideWithValue(
            Option.of(quoteAsset),
          ),
          marketSubscribedAssetPairProvider.overrideWith(
            () => _FixedAssetPair(assetPair),
          ),
          // Derived from the live market list, which is empty here, so the
          // panel would render nothing without this.
          subscribedMarketInfoProvider.overrideWithValue(Option.of(marketInfo)),
          ...lockedJadeOverrides(first: first, second: second),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            // The order button dereferences this extension; without it the
            // panel throws rather than falling back to a default colour.
            theme: ThemeData().copyWith(
              extensions: [
                MarketColorsStyle(
                  sellColor: SideSwapColors.bitterSweet,
                  buyColor: SideSwapColors.turquoise,
                ),
              ],
            ),
            home: const Scaffold(body: LimitPanel()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The provider rebuilds and hands out a new repository instance.
      useSecondJadeLockRepository(container);
      await tester.pump();

      await tester.tap(find.byType(MarketOrderButton));
      await tester.pump();

      verify(second.refreshJadeLockState).called(1);
      verifyNever(first.refreshJadeLockState);

      // Two harness artifacts, drained in order. The desktop hover button
      // starts a 100ms timer on tap-up (`d_hover_button.dart:175`), and the
      // rebuild that timer causes resolves `DFocusTheme.of`
      // (`d_focus.dart:125`), which reads a throwaway ProviderContainer and
      // leaves riverpod a zero-duration dispose timer behind.
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(Duration.zero);
    },
  );
}
