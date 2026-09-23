import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';

Future<void> _pump(
  WidgetTester tester, {
  bool? enabled,
  PinKeyboardAcceptType acceptType = PinKeyboardAcceptType.icon,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: enabled == null
              ? PinKeyboard(acceptType: acceptType)
              : PinKeyboard(enabled: enabled, acceptType: acceptType),
        ),
      ),
    ),
  );
}

List<InkWell> _keys(WidgetTester tester) =>
    tester.widgetList<InkWell>(find.byType(InkWell)).toList();

void main() {
  testWidgets('every key is live while the keyboard is open', (tester) async {
    await _pump(tester, enabled: true);

    final keys = _keys(tester);
    expect(keys, hasLength(12));
    for (final key in keys) {
      expect(key.onTap, isNotNull);
    }
  });

  testWidgets('every key is dead while the keyboard is closed', (tester) async {
    await _pump(tester, enabled: false);

    final keys = _keys(tester);
    expect(keys, hasLength(12));
    for (final key in keys) {
      expect(key.onTap, isNull);
    }
  });

  testWidgets('the keyboard is open unless it is told otherwise', (
    tester,
  ) async {
    await _pump(tester);

    for (final key in _keys(tester)) {
      expect(key.onTap, isNotNull);
    }
  });

  testWidgets('each key draws its own disabled border and fill', (
    tester,
  ) async {
    await _pump(tester, enabled: true);
    final live = _decorations(tester);

    await _pump(tester, enabled: false);
    final dead = _decorations(tester);

    expect(live, hasLength(12));
    expect(dead, hasLength(12));
    for (var index = 0; index < live.length; index++) {
      expect(dead[index].border, isNot(live[index].border));
    }

    // Only the accept key carries a fill; the digit keys are transparent in
    // both states.
    expect(dead.last.color, isNot(live.last.color));
  });

  testWidgets('each key dims its own label while the keyboard is closed', (
    tester,
  ) async {
    await _pump(tester, enabled: true);
    final live = tester.widget<Text>(find.text('1')).style?.color;

    await _pump(tester, enabled: false);
    final dead = tester.widget<Text>(find.text('1')).style?.color;

    expect(dead, isNot(live));
  });

  testWidgets('the accept key dims its own label', (tester) async {
    // The word labels take their colour from the ambient text style, so the
    // key dims them itself. The `icon` accept type is the only one the busy
    // state never shows, and it is the only one the default covers.
    await _pump(
      tester,
      enabled: true,
      acceptType: PinKeyboardAcceptType.enable,
    );

    expect(
      find.ancestor(
        of: find.text('ENABLE'),
        matching: find.byType(Opacity),
      ),
      findsNothing,
    );

    await _pump(
      tester,
      enabled: false,
      acceptType: PinKeyboardAcceptType.enable,
    );

    expect(
      tester
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.text('ENABLE'),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity,
      0.5,
    );
  });
}

List<BoxDecoration> _decorations(WidgetTester tester) => tester
    .widgetList<Container>(
      find.descendant(
        of: find.byType(InkWell),
        matching: find.byType(Container),
      ),
    )
    .map((container) => container.decoration! as BoxDecoration)
    .toList();
