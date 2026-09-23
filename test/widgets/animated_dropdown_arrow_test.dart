import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';

/// The cosine of the rotation the effect currently applies.
///
/// [Transform.rotate] keeps no angle, only the matrix it built from one, so
/// read the angle back out of the matrix. A quarter of the way round is the
/// only value this widget ever holds, so the cosine alone separates the two
/// resting positions: 1.0 at zero turns, -1.0 at half a turn.
double rotationCosine(WidgetTester tester) {
  final transform = tester.widget<Transform>(
    find
        .descendant(
          of: find.byType(AnimatedDropdownArrow),
          matching: find.byType(Transform),
        )
        .first,
  );

  return transform.transform.storage[0];
}

void main() {
  group('AnimatedDropdownArrow does not animate when it is mounted', () {
    // Both branches of the initFrom parameter. The widget must come up already
    // at its target, because a caller mounts it inside a menu that opens and
    // closes: an animation on mount plays every time the menu appears.
    //
    // The initFrom: 1 case is what keeps the onInit callback in the widget.
    // Delete that callback and this test goes red: Animate starts its internal
    // controller at 0, so the arrow turns half a circle on the first mount.

    testWidgets('when initFrom is 1 and the target is 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedDropdownArrow(target: 1, initFrom: 1),
          ),
        ),
      );

      final atMount = rotationCosine(tester);
      await tester.pumpAndSettle();

      expect(atMount, closeTo(-1, 1e-9));
      expect(rotationCosine(tester), closeTo(-1, 1e-9));
    });

    testWidgets('when initFrom is left at 0 and the target is 0', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnimatedDropdownArrow(target: 0)),
        ),
      );

      final atMount = rotationCosine(tester);
      await tester.pumpAndSettle();

      expect(atMount, closeTo(1, 1e-9));
      expect(rotationCosine(tester), closeTo(1, 1e-9));
    });
  });
}
