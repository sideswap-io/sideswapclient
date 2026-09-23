// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/home/d_home.dart';
import 'package:sideswap/desktop/home/widgets/d_asset_list_tile.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_wallet_assets_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/desktop_page_heights.dart';
import '../helpers/fake_shared_preferences.dart';

class MockWallet extends Mock implements SideswapWallet {}

class MockDesktopDialog extends Mock implements DesktopDialog {}

void main() {
  late MockWallet wallet;
  late FakeSharedPreferences prefs;
  late MockDesktopDialog desktopDialog;

  setUpAll(() {
    registerFallbackValue(Asset());
  });

  setUp(() {
    Localization.load(const Locale('en'));
    wallet = MockWallet();
    prefs = FakeSharedPreferences();
    desktopDialog = MockDesktopDialog();
    when(() => desktopDialog.showAssetInfoDialog(any())).thenReturn(null);
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

  List<Asset> assets(int count) => List.generate(
    count,
    (i) => Asset(assetId: 'asset-$i', ticker: 'TICK$i', name: 'Asset $i'),
  );

  ProviderContainer makeContainer({int assetCount = 8}) {
    final container = ProviderContainer.test(
      overrides: [
        walletProvider.overrideWith((ref) => wallet),
        sharedPreferencesProvider.overrideWithValue(prefs),
        navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
        localesProvider.overrideWithValue('en'),
        allVisibleAssetsProvider.overrideWithValue(assets(assetCount)),
        desktopDialogProvider.overrideWithValue(desktopDialog),
      ],
    );
    // A synced wallet. The page's other `Stack` child is the sync spinner,
    // and while it shows it covers the middle of the page -- including the
    // asset rows underneath it, which would then not be `hitTestable`.
    container.read(syncCompleteStateProvider.notifier).setState(true);
    return container;
  }

  /// The desktop panels resolve their theme through throwaway
  /// `ProviderContainer`s whose dispose timers never settle under fake async,
  /// so every pump runs inside `runAsync` -- prior art:
  /// test/widgets/d_settings_test.dart.
  Future<void> pumpHome(
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
          home: const Scaffold(body: DHome()),
        ),
      ),
    );
    await tester.pump();
  });

  double heightOf(WidgetTester tester, Finder finder) =>
      tester.getSize(finder).height;

  /// The page's *own* scroll owner, not "the one `Scrollable` in the tree" --
  /// the same distinction test/widgets/d_content_dialog_scroll_owner_test.dart
  /// draws. `DAssetsList` brings a `CustomScrollView`, the tab bodies bring
  /// theirs and `TabBar(isScrollable: true)` brings a `SingleChildScrollView`
  /// of its own; none of them is the page's. A page-level owner would be a
  /// `DScrollWhenShort`, and `DHome` gains none: it yields height instead of
  /// scrolling.
  final ownScrollView = find.descendant(
    of: find.byType(DHome),
    matching: find.byType(DScrollWhenShort),
  );

  testWidgets('at the design height the two panels keep the heights they have '
      'today, and the page owns no scrollable', (tester) async {
    final container = makeContainer();
    await pumpHome(tester, container, content: designContent);

    expect(heightOf(tester, find.byType(DWalletAssetsPanel)), 418);
    expect(heightOf(tester, find.byType(DTxAndOrdersPanel)), 228);
    expect(ownScrollView, findsNothing);
  });

  testWidgets('at the floor the transactions panel yields the height the '
      'assets panel gains', (tester) async {
    final container = makeContainer();
    await pumpHome(tester, container, content: floorContent);

    // Today: tx 228 and assets 198, because the panel is laid out in the
    // column's non-flex pass against an unbounded main axis and takes its
    // whole intrinsic height first.
    expect(heightOf(tester, find.byType(DTxAndOrdersPanel)), lessThan(228));
    expect(heightOf(tester, find.byType(DWalletAssetsPanel)), greaterThan(198));
    expect(ownScrollView, findsNothing);
  });

  testWidgets('at the floor the wallet shows more assets than it does today', (
    tester,
  ) async {
    final container = makeContainer();
    await pumpHome(tester, container, content: floorContent);

    // "The wallet shows two assets" is the defect ADR-0014 decision 11 names.
    expect(find.byType(DAssetListTile).hitTestable(), findsAtLeast(3));
  });

  testWidgets('at the floor an asset row is reachable and live', (
    tester,
  ) async {
    final container = makeContainer();
    await pumpHome(tester, container, content: floorContent);

    // The page has no primary action of its own -- opening an asset is the
    // interaction the floor has to keep. It is worth asserting because a
    // reachable-looking row is not the same as a reachable one: the sync
    // spinner this page draws over the middle of itself covers exactly the
    // rows the floor leaves visible.
    final tile = find.byType(DAssetListTile).hitTestable().first;
    await tester.runAsync(() async {
      await tester.tap(tile);
      await tester.pump();
    });

    verify(() => desktopDialog.showAssetInfoDialog(any())).called(1);
  });
}
