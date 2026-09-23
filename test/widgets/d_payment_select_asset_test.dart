import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/main/d_payment_select_asset.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/asset_item.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

/// Twenty assets -- the tallest realistic state, and well past what the popup
/// shows at once.
final _assetIds = [for (var i = 0; i < 20; i++) 'asset-$i'];

class FakeAssetsState extends AssetsState {
  @override
  Map<String, Asset> build() => {
    for (final id in _assetIds)
      id: Asset(assetId: id, ticker: 'TK$id', name: 'Asset $id', precision: 8),
  };
}

/// `DPaymentSelectAsset` is a picker: selecting a row *is* the action, so it has
/// no `actions` row of its own. The floor test asserts the equivalent -- a row
/// is hit-testable and its `onSelected` fires -- and says so rather than
/// pretending an actions row exists.
void main() {
  late List<Asset> selected;

  setUp(() {
    installSurfaceTestEnv();
    selected = [];
  });

  /// Pushes the popup on top of an empty page: picking a row pops the route,
  /// and `Navigator.pop` refuses to remove the root one.
  Future<void> pump(WidgetTester tester, Size view) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              assetsStateProvider.overrideWith(FakeAssetsState.new),
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
              home: const Scaffold(body: SizedBox.shrink()),
            ),
          ),
        );
        unawaited(
          Navigator.of(tester.element(find.byType(Scaffold))).push(
            MaterialPageRoute<void>(
              builder: (_) => DPaymentSelectAsset(
                availableAssets: _assetIds,
                disabledAssets: const [],
                onSelected: selected.add,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });

  /// The asset list's own scrollable -- this surface takes `ScrollOwner.child`.
  final contentScrollView = find.descendant(
    of: find.byType(DPopupWithClose),
    matching: find.byType(CustomScrollView),
  );

  /// The wrapper's scrollable, which must never appear here: a second owner
  /// nested inside the list's swallows the wheel.
  final wrapperScrollView = find.descendant(
    of: find.byType(DPopupWithClose),
    matching: find.byType(SingleChildScrollView),
  );

  testWidgets('at the design height the asset list is the only scrollable and '
      'the wrapper adds none', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(contentScrollView, findsOneWidget);
    expect(wrapperScrollView, findsNothing);
    // The picker's body already yields through its own `Flexible`, so the
    // owner declaration is what keeps a later edit from letting the wrapper
    // add a second scrollable over the list's.
    expect(
      tester.widget<DPopupWithClose>(find.byType(DPopupWithClose)).scrollOwner,
      ScrollOwner.child,
    );
    expect(extentOf(tester, contentScrollView), greaterThan(0));
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor the list yields the shortfall, nothing overflows '
      'and a row is live', (tester) async {
    // Installed before the first pump: an overflow raised before the handler
    // is in place is recorded against the test.
    final errors = captureOverflow();

    await pump(tester, designHeight);
    final designListHeight = tester.getSize(contentScrollView).height;

    await resizeTo(tester, floor);

    expect(wrapperScrollView, findsNothing);
    // The list really did give room back, rather than being shorter than the
    // window by construction, which is what keeps the no-overflow assertion
    // below meaningful.
    expect(
      tester.getSize(contentScrollView).height,
      lessThan(designListHeight),
    );
    expect(verticalOverflows(errors), isEmpty);
    final firstRow = find.byType(AssetItem).first;
    expect(firstRow.hitTestable(), findsOneWidget);
    await tapAndDrain(tester, firstRow);
    expect(selected.map((a) => a.assetId), [_assetIds.first]);
  });
}
