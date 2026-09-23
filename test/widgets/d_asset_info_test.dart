import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/main/d_asset_info.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

/// The tallest realistic state: an asset that carries every optional detail
/// row -- domain, agent link and a long id -- so the body is at its longest.
Asset _asset() => Asset(
  assetId: 'a' * 64,
  ticker: 'TEST',
  name: 'Test asset with a long name',
  domain: 'example.com',
  domainAgentLink: 'https://example.com/agent',
);

/// The screen asks for asset details on mount, which goes to the wallet. The
/// empty details map the notifier already builds is the state under test; only
/// the request is stubbed out.
class FakeTokenMarket extends TokenMarketNotifier {
  @override
  void requestAssetDetails({required String? assetId}) {}
}

void main() {
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    routeRecorder = RouteRecorder();
  });

  /// Pushes the popup on top of an empty page, so the route its actions pop is
  /// not the root route -- which `Navigator.pop` refuses to remove, leaving the
  /// tap with no observable effect at all.
  Future<void> pump(WidgetTester tester, Size view) => tester.runAsync(
    () async {
      sizeView(tester, view);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tokenMarketProvider.overrideWith(FakeTokenMarket.new),
            configurationProvider.overrideWith(
              () => FakeConfiguration(
                SideswapSettings.empty(
                  mnemonicEncrypted: Uint8List.fromList([]),
                  jadeId: '',
                ),
              ),
            ),
          ],
          child: MaterialApp(
            // `--no-test-assets` has no ink shader.
            theme: ThemeData(splashFactory: NoSplash.splashFactory),
            navigatorObservers: [routeRecorder],
            home: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );
      unawaited(
        Navigator.of(tester.element(find.byType(Scaffold))).push(
          MaterialPageRoute<void>(builder: (_) => DAssetInfo(asset: _asset())),
        ),
      );
      await tester.pumpAndSettle();
    },
  );

  /// The popup's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DPopupWithClose),
    matching: find.byType(SingleChildScrollView),
  );

  final swapButton = find.widgetWithText(CustomIconButton, 'Swap');

  testWidgets('at the design height the body is unscrolled and the actions row '
      'sits outside the scroll region', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(ownScrollView, findsOneWidget);
    expect(
      find.descendant(of: ownScrollView, matching: swapButton),
      findsNothing,
    );
    expect(extentOf(tester, ownScrollView), 0);
    expect(verticalOverflows(errors), isEmpty);
    // The Swap/Send band sits at the card's bottom edge. 24px of slack is the
    // label padding under the icon, inside the band itself.
    expectPinnedToCardBottom(tester, swapButton, slack: 24);
  });

  testWidgets('at the floor nothing overflows and the actions row is reachable '
      'without scrolling', (tester) async {
    final errors = captureOverflow();

    await pump(tester, floor);

    expect(verticalOverflows(errors), isEmpty);
    // With the row pinned outside the scroll body, and the card sized to its
    // content rather than to a declared 632, the remainder needs no scrolling
    // at the floor at all.
    expect(extentOf(tester, ownScrollView), 0);
    // Reachable at the floor without scrolling: the whole row is inside the
    // client area, not merely present in the tree.
    expect(
      tester.getBottomLeft(swapButton).dy,
      lessThanOrEqualTo(floor.height),
    );
    expect(swapButton.hitTestable(), findsOneWidget);
    await tapAndDrain(tester, swapButton);
    expect(routeRecorder.pops, 1);
  });
}
