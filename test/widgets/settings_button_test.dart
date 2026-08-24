import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';

void main() {
  Future<void> pumpButton(
    WidgetTester tester, {
    required bool disabled,
    required VoidCallback onPressed,
  }) => tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SettingsButton(
            type: SettingsButtonType.recovery,
            text: 'Export',
            disabled: disabled,
            onPressed: onPressed,
          ),
        ),
      ),
    ),
  );

  group('SettingsButton', () {
    testWidgets('disabled: tap performs no action and renders dimmed', (
      tester,
    ) async {
      var tapped = false;
      await pumpButton(
        tester,
        disabled: true,
        onPressed: () => tapped = true,
      );

      await tester.tap(find.byType(SettingsButton));
      await tester.pump();

      expect(tapped, isFalse);

      final opacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, lessThan(1.0));
    });

    testWidgets('enabled: tap fires the callback and is not dimmed', (
      tester,
    ) async {
      var tapped = false;
      await pumpButton(
        tester,
        disabled: false,
        onPressed: () => tapped = true,
      );

      await tester.tap(find.byType(SettingsButton));
      await tester.pump();

      expect(tapped, isTrue);

      // The enabled tree carries no dimming layer around the button.
      expect(
        find.ancestor(
          of: find.byType(TextButton),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });
  });
}
