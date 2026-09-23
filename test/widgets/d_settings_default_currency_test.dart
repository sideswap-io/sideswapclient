import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/settings/d_settings_default_currency.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/wallet.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/surface_floor.dart';

class MockWallet extends Mock implements SideswapWallet {}

/// Thirty currencies -- the tallest realistic state, and well past what the
/// 446px list box shows at once.
class FakeConversionRates extends ConversionRatesNotifier {
  @override
  ConversionRates build() => ConversionRates(
    usdConversionRates: [
      for (var i = 0; i < 30; i++)
        ConversionRate(name: 'CUR$i', rate: Decimal.one),
    ],
  );
}

void main() {
  late MockWallet wallet;

  setUp(() {
    installSurfaceTestEnv();
    wallet = MockWallet();
    when(() => wallet.goBack()).thenReturn(true);
  });

  Future<void> pump(WidgetTester tester, Size view) =>
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
              conversionRatesProvider.overrideWith(FakeConversionRates.new),
            ],
            child: MaterialApp(
              // `--no-test-assets` has no ink shader.
              theme: ThemeData(splashFactory: NoSplash.splashFactory),
              home: const Scaffold(body: DSettingsDefaultCurrency()),
            ),
          ),
        );
      });

  /// The content's own scrollable -- this surface takes `ScrollOwner.child`.
  final contentScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(CustomScrollView),
  );

  /// The wrapper's scrollable, which must never appear here: a second owner
  /// nested inside the content's swallows the wheel.
  final wrapperScrollView = find.descendant(
    of: find.byType(DContentDialog),
    matching: find.byType(SingleChildScrollView),
  );

  final backButton = find.byType(DCustomTextBigButton);

  testWidgets('at the design height the currency list is the only scrollable '
      'and the wrapper adds none', (tester) async {
    final errors = captureOverflow();

    await pump(tester, designHeight);

    expect(contentScrollView, findsOneWidget);
    expect(wrapperScrollView, findsNothing);
    // The `Flexible` half of the contract is present -- this content brings no
    // flex of its own, so finding one proves the dialog handed the list the
    // room it has.
    expect(
      find.descendant(
        of: find.byType(DContentDialog),
        matching: find.byType(Flexible),
      ),
      findsWidgets,
    );
    // The list owns the scrolling, and the pinned BACK button is outside it.
    expect(extentOf(tester, contentScrollView), greaterThan(0));
    expect(
      find.descendant(of: contentScrollView, matching: backButton),
      findsNothing,
    );
    expect(verticalOverflows(errors), isEmpty);
  });

  testWidgets('at the floor nothing overflows and BACK stays live', (
    tester,
  ) async {
    final errors = captureOverflow();

    await pump(tester, floor);

    expect(wrapperScrollView, findsNothing);
    expect(verticalOverflows(errors), isEmpty);
    expect(backButton.hitTestable(), findsOneWidget);
    // BACK's `Navigator.pop` is intercepted by the surface's own
    // `PopScope(canPop: false)`, which routes the back intent through the
    // wallet instead.
    await tapAndDrain(tester, backButton);
    verify(() => wallet.goBack()).called(1);
  });
}
