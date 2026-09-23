import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';

/// The pump runs inside `runAsync` because `DButton.defaultStyleOf` leaves
/// zero-duration riverpod dispose timers that never fire under the fake-async
/// binding.
Future<void> _pump(
  WidgetTester tester, {
  required bool enabled,
  PinKeyboardAcceptType acceptType = PinKeyboardAcceptType.icon,
}) => tester.runAsync(() async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: DPinKeyboard(enabled: enabled, acceptType: acceptType),
        ),
      ),
    ),
  );
  // The label colour rides an `AnimatedDefaultTextStyle`, so a second pump of
  // the same tree has to settle before the colour is the new one.
  await tester.pumpAndSettle();
});

Color? _iconColour(WidgetTester tester, IconData icon) =>
    tester.widget<Icon>(find.byIcon(icon)).color;

/// The colour a label actually renders in, ambient style resolved.
Color? _renderedColour(WidgetTester tester, String label) =>
    tester.renderObject<RenderParagraph>(find.text(label)).text.style?.color;

List<DCustomTextBigButton> _buttons(WidgetTester tester) =>
    tester.widgetList<DCustomTextBigButton>(
      find.byType(DCustomTextBigButton),
    ).toList();

void main() {
  testWidgets('every key is live while the keyboard is open', (tester) async {
    await _pump(tester, enabled: true);

    final buttons = _buttons(tester);
    expect(buttons, hasLength(12));
    for (final button in buttons) {
      expect(button.enabled, isTrue);
    }
  });

  testWidgets('every key is dead while the keyboard is closed', (tester) async {
    await _pump(tester, enabled: false);

    final buttons = _buttons(tester);
    expect(buttons, hasLength(12));
    for (final button in buttons) {
      expect(button.enabled, isFalse);
    }
  });

  testWidgets('the keyboard is open unless it is told otherwise', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: DPinKeyboard())),
        ),
      );
    });

    for (final button in _buttons(tester)) {
      expect(button.enabled, isTrue);
    }
  });

  testWidgets('each key draws its own disabled border', (tester) async {
    await _pump(tester, enabled: true);

    // Each button carries the border resolver, so each renders its own disabled
    // outline rather than the grid being dimmed as one block. The accept key is
    // a filled button with a transparent border in both states, and it has its
    // own arm below.
    for (final button in _buttons(tester).take(11)) {
      final border = button.style!.border!;

      expect(
        border.resolve(<ButtonStates>{ButtonStates.disabled})?.color,
        isNot(border.resolve(<ButtonStates>{})?.color),
      );
    }
  });

  testWidgets('each key dims its own label', (tester) async {
    await _pump(tester, enabled: true);
    final live = _renderedColour(tester, '1');

    await _pump(tester, enabled: false);

    expect(_renderedColour(tester, '1'), isNot(live));
  });

  testWidgets('the backspace and accept glyphs dim with the keyboard', (
    tester,
  ) async {
    await _pump(tester, enabled: true);
    final liveBackspace = _iconColour(tester, Icons.backspace_outlined);
    final liveAccept = _iconColour(tester, Icons.keyboard_return);

    await _pump(tester, enabled: false);

    // An icon carries its own colour, so the style resolvers cannot reach it.
    expect(_iconColour(tester, Icons.backspace_outlined), isNot(liveBackspace));
    expect(_iconColour(tester, Icons.keyboard_return), isNot(liveAccept));
  });

  testWidgets('the accept key dims its own label', (tester) async {
    await _pump(
      tester,
      enabled: true,
      acceptType: PinKeyboardAcceptType.enable,
    );
    final live = tester
        .widget<Text>(find.text('ENABLE'))
        .style
        ?.merge(DefaultTextStyle.of(tester.element(find.text('ENABLE'))).style);

    await _pump(
      tester,
      enabled: false,
      acceptType: PinKeyboardAcceptType.enable,
    );
    final dead = tester
        .widget<Text>(find.text('ENABLE'))
        .style
        ?.merge(DefaultTextStyle.of(tester.element(find.text('ENABLE'))).style);

    expect(dead?.color, isNot(live?.color));
  });
}
