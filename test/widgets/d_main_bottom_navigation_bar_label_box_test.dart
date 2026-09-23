import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/d_main_bottom_navigation_bar.dart';
import 'package:sideswap/providers/locales_provider.dart';

/// The labels of the desktop bottom navigation bar must lay out in a line box
/// that the font decides. `mainBottomNavigationBarButtonStyle` used to set
/// `height: 0.12`, which gave every label a 1.2 px line box while the glyphs
/// painted outside it -- a condition `flutter_test` reports no overflow for,
/// because the box fits its parent. Only a measurement catches it (#269).
void main() {
  /// The bar labels its buttons through `.tr()`, and no translation asset loads
  /// under `--no-test-assets`, so every label falls back to its own key.
  const labels = <String>[
    'Home',
    'Swap Markets',
    'Instant Swap',
    'Peg-In/Out',
    'Transactions',
    'Addresses',
  ];

  const fontSize = 10.0;
  const barHeight = 56.0;
  const bottomGap = 5.0;

  /// `DButton` schedules timers that never settle under fake async, so the pump
  /// runs inside `runAsync` -- prior art: test/widgets/d_settings_test.dart.
  Future<void> pumpBar(WidgetTester tester) => tester.runAsync(() async {
    tester.view.physicalSize = const Size(1200, 400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localesProvider.overrideWithValue('en')],
        child: MaterialApp(
          theme: ThemeData(splashFactory: NoSplash.splashFactory),
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: DesktopMainBottomNavigationBar(
                onTap: (_) {},
                currentIndex: 0,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  });

  testWidgets('every label inherits an unset line height', (tester) async {
    await pumpBar(tester);

    for (final label in labels) {
      final style = DefaultTextStyle.of(
        tester.element(find.text(label)),
      ).style;
      expect(style.height, isNull, reason: label);

      // The label must not put the value back locally either: the fix belongs
      // to the theme, and `ToolbarButton` overrides no `height` of its own.
      final text = tester.widget<Text>(find.text(label));
      expect(text.style?.height, isNull, reason: label);
    }
  });

  testWidgets('every label lays out in a line box the font size explains', (
    tester,
  ) async {
    await pumpBar(tester);

    for (final label in labels) {
      final height = tester.getSize(find.text(label)).height;
      expect(height, greaterThanOrEqualTo(fontSize), reason: label);
      expect(height, lessThanOrEqualTo(2 * fontSize), reason: label);
    }
  });

  testWidgets('the bar still measures 56 px', (tester) async {
    await pumpBar(tester);

    expect(
      tester.getSize(find.byType(DesktopMainBottomNavigationBar)).height,
      barHeight,
    );
  });

  testWidgets('every label keeps a 5 px gap under it', (tester) async {
    await pumpBar(tester);

    final barBottom = tester
        .getRect(find.byType(DesktopMainBottomNavigationBar))
        .bottom;

    for (final label in labels) {
      final labelBottom = tester.getRect(find.text(label)).bottom;
      expect(barBottom - labelBottom, bottomGap, reason: label);
    }
  });
}
