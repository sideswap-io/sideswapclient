import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_network_access_onboarding.dart';
import 'package:sideswap/desktop/settings/d_settings_network_access.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// Both surfaces render the same `DSettingsNetworkAccessContent`, whose
/// `networkAccessTabProvider` defaults to the server tab. Either tab renders
/// inside the same fixed 446px box, so the tab choice does not change the
/// vertical extent these tests assert; the default is used deliberately.
void main() {
  late MockWallet wallet;
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    when(() => wallet.goBack()).thenReturn(true);
    routeRecorder = RouteRecorder();
  });

  /// Pushes [surface] on top of an empty page, so the route its primary action
  /// pops is not the root route -- which `Navigator.pop` refuses to remove,
  /// leaving the tap with no observable effect at all.
  Future<void> pump(WidgetTester tester, Size view, Widget surface) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              walletProvider.overrideWithValue(wallet),
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
            MaterialPageRoute<void>(builder: (_) => Scaffold(body: surface)),
          ),
        );
        await tester.pumpAndSettle();
      });

  /// The dialog's *own* scroll owner, not "the one `Scrollable` in the tree".
  final ownScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  group('DSettingsNetworkAccess', () {
    final saveOrBack = find.byType(DSettingsNetworkAccessSaveOrBackButton);

    testWidgets('at the design height the layout is unchanged and the scroll '
        'owner has zero extent', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, const DSettingsNetworkAccess());

      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(of: ownScrollView, matching: saveOrBack),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and the action stays live', (
      tester,
    ) async {
      final errors = captureOverflow();

      await pump(tester, floor, const DSettingsNetworkAccess());

      expect(verticalOverflows(errors), isEmpty);
      expect(saveOrBack.hitTestable(), findsOneWidget);
      // Nothing needs saving, so the button is BACK. Its `Navigator.pop` is
      // intercepted by the surface's own `PopScope(canPop: false)`, which
      // routes the back intent through the wallet instead.
      await tapAndDrain(tester, saveOrBack);
      verify(() => wallet.goBack()).called(1);
    });
  });

  group('DNetworkAccessOnboarding', () {
    final saveOrBack = find.byType(DNetworkAccessOnboardingSaveOrBackButton);

    testWidgets('at the design height the layout is unchanged and the scroll '
        'owner has zero extent', (tester) async {
      final errors = captureOverflow();

      await pump(tester, designHeight, const DNetworkAccessOnboarding());

      expect(ownScrollView, findsOneWidget);
      expect(
        find.descendant(of: ownScrollView, matching: saveOrBack),
        findsNothing,
      );
      expect(extentOf(tester, ownScrollView), 0);
      expect(verticalOverflows(errors), isEmpty);
    });

    testWidgets('at the floor nothing overflows and the action stays live', (
      tester,
    ) async {
      final errors = captureOverflow();

      await pump(tester, floor, const DNetworkAccessOnboarding());

      expect(verticalOverflows(errors), isEmpty);
      expect(saveOrBack.hitTestable(), findsOneWidget);
      await tapAndDrain(tester, saveOrBack);
      expect(routeRecorder.pops, 1);
    });
  });
}
