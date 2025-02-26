import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_base_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/theme.dart';

class DButton extends DBaseButton {
  /// Creates a button.
  const DButton({
    super.key,
    required super.child,
    required super.onPressed,
    super.onLongPress,
    super.focusNode,
    super.autofocus = false,
    super.style,
    super.cursor,
  });

  @override
  DButtonStyle defaultStyleOf(BuildContext context) {
    final container = ProviderContainer();
    final shadowColor =
        container.read(desktopAppThemeNotifierProvider).shadowColor;
    final brightness =
        container.read(desktopAppThemeNotifierProvider).brightness;
    final disabledColor =
        container.read(desktopAppThemeNotifierProvider).disabledColor;

    return DButtonStyle(
      elevation: ButtonState.resolveWith((states) {
        if (states.isPressing) return 0.0;
        return 0.3;
      }),
      shadowColor: ButtonState.all(shadowColor),
      padding: ButtonState.all(
        const EdgeInsets.only(left: 11.0, top: 5.0, right: 11.0, bottom: 6.0),
      ),
      shape: ButtonState.all(
        RoundedRectangleBorder(
          side: BorderSide(
            color:
                brightness.isLight
                    ? const Color.fromRGBO(0, 0, 0, 0.09)
                    : const Color.fromRGBO(255, 255, 255, 0.05),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      backgroundColor: ButtonState.resolveWith((states) {
        return DButtonThemeData.buttonColor(brightness, states);
      }),
      foregroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) return disabledColor;
        return DButtonThemeData.buttonColor(
          brightness,
          states,
        ).basedOnLuminance().toAccentColor()[states.isPressing
            ? brightness.isLight
                ? 'lighter'
                : 'dark'
            : 'normal'];
      }),
    );
  }

  @override
  DButtonStyle? themeStyleOf(BuildContext context) {
    return DButtonTheme.of(context).defaultButtonStyle;
  }
}
