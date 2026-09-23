import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_text_field.dart';

/// The pump runs inside `runAsync` because the suffix icon is a `DButton`, and
/// `DButton.defaultStyleOf` leaves zero-duration riverpod dispose timers that
/// never fire under the fake-async binding.
Future<void> _pump(
  WidgetTester tester, {
  bool error = false,
  bool enabled = true,
  bool autofocus = false,
  String pin = '',
}) => tester.runAsync(() async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: DPinTextField(
            error: error,
            enabled: enabled,
            autofocus: autofocus,
            pin: pin,
          ),
        ),
      ),
    ),
  );
});

TextField _field(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField));

void main() {
  testWidgets('never selects the whole PIN when it takes focus', (
    tester,
  ) async {
    await _pump(tester);

    // Stated, not inherited: the platform default is `true` on desktop.
    expect(_field(tester).selectAllOnFocus, isFalse);
  });

  testWidgets('takes focus only when it is told to', (tester) async {
    await _pump(tester);

    expect(_field(tester).autofocus, isFalse);

    await _pump(tester, autofocus: true);

    expect(_field(tester).autofocus, isTrue);
  });

  testWidgets('puts no message inside the field, on error or off', (
    tester,
  ) async {
    await _pump(tester);

    expect(_field(tester).decoration?.errorText, isNull);

    await _pump(tester, error: true);

    expect(_field(tester).decoration?.errorText, isNull);
  });

  testWidgets('keeps the same height on error as off it', (tester) async {
    await _pump(tester);
    final idle = tester.getSize(find.byType(TextField));

    await _pump(tester, error: true);
    final onError = tester.getSize(find.byType(TextField));

    expect(onError, idle);
    expect(idle.height, 49);
  });

  testWidgets('draws the red border on error, and none off it', (tester) async {
    await _pump(tester, error: true);

    final border = _field(tester).decoration?.focusedBorder;
    expect(border, isA<OutlineInputBorder>());
    expect(border?.borderSide.color, SideSwapColors.bitterSweet);

    await _pump(tester);

    // Off error the widget passes none, and the decoration's own transparent
    // border stands.
    expect(
      _field(tester).decoration?.focusedBorder?.borderSide.color,
      Colors.transparent,
    );
  });

  testWidgets('dims itself and refuses the pointer while it is closed', (
    tester,
  ) async {
    await _pump(tester, enabled: false);

    expect(_field(tester).enabled, isFalse);
    expect(
      tester
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.byType(TextField),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity,
      0.5,
    );
    expect(
      tester
          .widget<AbsorbPointer>(
            find
                .ancestor(
                  of: find.byType(TextField),
                  matching: find.byType(AbsorbPointer),
                )
                .first,
          )
          .absorbing,
      isTrue,
    );
  });

  testWidgets('brings the caret back to the end when a message appears', (
    tester,
  ) async {
    await _pump(tester, pin: '123456');
    _field(tester).controller!.selection = const TextSelection(
      baseOffset: 2,
      extentOffset: 4,
    );

    // A mismatch changes no digit, so only `error` tells the field to put the
    // caret back where backspace is useful.
    await _pump(tester, pin: '123456', error: true);

    final selection = _field(tester).controller!.selection;
    expect(selection.isCollapsed, isTrue);
    expect(selection.baseOffset, 6);
  });

  testWidgets('shows the PIN it is given, with the caret at the end', (
    tester,
  ) async {
    await _pump(tester, pin: '123456');

    final controller = _field(tester).controller!;
    expect(controller.text, '123456');
    expect(controller.selection.isCollapsed, isTrue);
    expect(controller.selection.baseOffset, 6);
  });
}
