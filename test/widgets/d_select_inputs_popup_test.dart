import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/main/d_select_inputs_popup.dart';
import 'package:sideswap/providers/config_provider.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

void main() {
  late RouteRecorder routeRecorder;

  setUp(() {
    installSurfaceTestEnv();
    routeRecorder = RouteRecorder();
  });

  /// Pushes the popup on top of an empty page, so CONTINUE's `Navigator.pop`
  /// has a route to remove -- it refuses to remove the root one.
  Future<void> pump(WidgetTester tester, Size view) =>
      tester.runAsync(() async {
        sizeView(tester, view);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
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
            MaterialPageRoute<void>(builder: (_) => const DSelectInputsPopup()),
          ),
        );
        // Not `pumpAndSettle`: the inputs list shows a spinner while it
        // loads, and an indefinite animation never settles.
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
      });

  /// The wrapper's scrollable, which must never appear here: the inputs list
  /// owns this surface's scrolling, and a second owner over it swallows the
  /// wheel.
  final wrapperScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  final continueButton = find.widgetWithText(DCustomButton, 'CONTINUE');

  /// The flexible inputs list -- the part of the body that gives room back
  /// when the window is short.
  double listHeight(WidgetTester tester) =>
      tester.getSize(find.byType(DInputsList)).height;

  testWidgets('at the design height the inputs list is at its design size and '
      'the wrapper adds no scrollable', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(wrapperScrollView, findsNothing);
    // CONTINUE is pinned, and nothing scrolls: the 808px dialog fits the
    // design window whole.
    expect(continueButton, findsOneWidget);
    expect(listHeight(tester), greaterThan(0));
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor the inputs list yields the shortfall, nothing '
      'overflows and CONTINUE stays live', (tester) async {
    // Installed before the first pump: the block font makes the wallet row
    // overflow horizontally, and an overflow raised before the handler is in
    // place is recorded against the test.
    final errors = captureOverflow();

    await pump(tester, designHeight);
    final designListHeight = listHeight(tester);

    await resizeTo(tester, floor);

    expect(wrapperScrollView, findsNothing);
    // The list really did give room back rather than the surface fitting
    // anyway, which is what keeps the no-overflow assertion below meaningful.
    expect(listHeight(tester), lessThan(designListHeight));
    expect(verticalOverflows(errors), isEmpty);
    expect(continueButton.hitTestable(), findsOneWidget);
    await tapAndDrain(tester, continueButton);
    expect(routeRecorder.pops, 1);
  });
}
