import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';

void main() {
  group('DelayTween', () {
    // Worked by hand from the definition, not recomputed the way the code
    // does it: lerp(t) interpolates begin..end by (sin((t - delay) * 2pi) + 1) / 2.
    // With begin 0.2 and end 1.0 that is 0.2 + 0.8 * phase.
    test('a zero delay is at its trough when the controller is at zero', () {
      final tween = DelayTween(begin: 0.2, end: 1.0, delay: 0);

      // sin(0) == 0 -> phase 0.5 -> 0.2 + 0.8 * 0.5.
      expect(tween.lerp(0), closeTo(0.6, 1e-9));
    });

    test('a zero delay peaks a quarter of the way through', () {
      final tween = DelayTween(begin: 0.2, end: 1.0, delay: 0);

      // sin(pi / 2) == 1 -> phase 1.0 -> end.
      expect(tween.lerp(0.25), closeTo(1.0, 1e-9));
    });

    test('the delay shifts the peak later by exactly the delay', () {
      final tween = DelayTween(begin: 0.2, end: 1.0, delay: 0.25);

      // The same peak the undelayed tween reaches at 0.25.
      expect(tween.lerp(0.5), closeTo(1.0, 1e-9));
    });

    test('evaluate reads the animation value through the same curve', () {
      final tween = DelayTween(begin: 0.2, end: 1.0, delay: 0);

      expect(
        tween.evaluate(const AlwaysStoppedAnimation<double>(0.25)),
        closeTo(1.0, 1e-9),
      );
    });
  });

  group('PulsingDots', () {
    // The controller repeats forever, so pumpAndSettle would never return --
    // every pump here is an explicit duration, and the tree is unmounted at the
    // end of each test so the ticker does not outlive it.
    Future<void> pumpDots(WidgetTester tester) => tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: PulsingDots()))),
    );

    // MaterialApp's own page transition contributes FadeTransitions of its
    // own, so every finder here is scoped to the widget under test.
    final dotFades = find.descendant(
      of: find.byType(PulsingDots),
      matching: find.byType(FadeTransition),
    );

    testWidgets('renders five dots in a 66x10 row', (tester) async {
      await pumpDots(tester);
      await tester.pump(const Duration(milliseconds: 100));

      expect(dotFades, findsNWidgets(5));

      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(PulsingDots),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(box.width, 66);
      expect(box.height, 10);

      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(PulsingDots),
          matching: find.byType(Row),
        ),
      );
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('each dot is a 10x10 turquoise circle', (tester) async {
      await pumpDots(tester);
      await tester.pump(const Duration(milliseconds: 100));

      final dots = tester
          .widgetList<Container>(
            find.descendant(
              of: dotFades,
              matching: find.byType(Container),
            ),
          )
          .toList();

      expect(dots, hasLength(5));
      for (final dot in dots) {
        final decoration = dot.decoration! as BoxDecoration;
        expect(decoration.shape, BoxShape.circle);
        expect(decoration.color, SideSwapColors.brightTurquoise);
        expect(dot.constraints?.maxWidth, 10);
        expect(dot.constraints?.maxHeight, 10);
      }

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('the dots pulse out of phase with one another', (tester) async {
      await pumpDots(tester);
      await tester.pump(const Duration(milliseconds: 300));

      final opacities = tester
          .widgetList<FadeTransition>(dotFades)
          .map((f) => f.opacity.value)
          .toSet();

      // The behavioural claim is "pulsing", not any particular easing: if the
      // per-dot delays survived, the five dots cannot all share one opacity.
      expect(opacities.length, greaterThanOrEqualTo(3));

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('the dots keep animating as the controller repeats', (
      tester,
    ) async {
      await pumpDots(tester);
      await tester.pump(const Duration(milliseconds: 100));

      final first = tester
          .widget<FadeTransition>(dotFades.first)
          .opacity
          .value;

      await tester.pump(const Duration(milliseconds: 300));

      final later = tester
          .widget<FadeTransition>(dotFades.first)
          .opacity
          .value;

      expect(later, isNot(closeTo(first, 1e-6)));

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
