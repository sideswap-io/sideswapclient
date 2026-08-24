import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_settings_button.dart';

void main() {
  // DButton resolves its theme through throwaway ProviderContainers that leave
  // dispose timers on riverpod's scheduler; those never settle under the test
  // binding's fake async, so the pump/tap run inside `runAsync` where the real
  // event loop lets them fire.
  Future<void> pumpAndTap(
    WidgetTester tester, {
    required bool disabled,
    required VoidCallback onPressed,
  }) => tester.runAsync(() async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: DSettingsButton(
              title: 'Export',
              icon: DSettingsButtonIcon.export,
              disabled: disabled,
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(DSettingsButton));
    await tester.pump();
  });

  group('DSettingsButton', () {
    testWidgets('disabled: tap performs no action and renders dimmed', (
      tester,
    ) async {
      var tapped = false;
      await pumpAndTap(
        tester,
        disabled: true,
        onPressed: () => tapped = true,
      );

      expect(tapped, isFalse);

      final opacity = tester.widget<Opacity>(
        find.ancestor(
          of: find.byType(DCustomFilledBigButton),
          matching: find.byType(Opacity),
        ),
      );
      expect(opacity.opacity, lessThan(1.0));
    });

    testWidgets('enabled: tap fires the callback and is not dimmed', (
      tester,
    ) async {
      var tapped = false;
      await pumpAndTap(
        tester,
        disabled: false,
        onPressed: () => tapped = true,
      );

      expect(tapped, isTrue);

      expect(
        find.ancestor(
          of: find.byType(DCustomFilledBigButton),
          matching: find.byType(Opacity),
        ),
        findsNothing,
      );
    });
  });
}
