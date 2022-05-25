import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_base_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';

enum IconButtonMode { tiny, small, large }

class DIconButton extends DBaseButton {
  const DIconButton({
    super.key,
    required Widget icon,
    required super.onPressed,
    super.onLongPress,
    super.onTapUp,
    super.onTapDown,
    super.onTapCancel,
    super.focusNode,
    super.autofocus = false,
    super.style,
    this.iconButtonMode,
    super.cursor,
  }) : super(
          child: icon,
        );

  final IconButtonMode? iconButtonMode;

  @override
  DButtonStyle defaultStyleOf(BuildContext context) {
    final container = ProviderContainer();
    final brightness = container.read(desktopAppThemeProvider).brightness;
    final disabledColor = container.read(desktopAppThemeProvider).disabledColor;

    final isIconSmall = SmallIconButton.of(context) != null ||
        iconButtonMode == IconButtonMode.tiny;
    final isSmall = iconButtonMode != null
        ? iconButtonMode != IconButtonMode.large
        : SmallIconButton.of(context) != null;
    return DButtonStyle(
      iconSize: ButtonState.all(isIconSmall ? 11.0 : null),
      padding: ButtonState.all(isSmall
          ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)
          : const EdgeInsets.all(8.0)),
      backgroundColor: ButtonState.resolveWith((states) {
        return states.isDisabled
            ? DButtonThemeData.buttonColor(brightness, states)
            : DButtonThemeData.uncheckedInputColor(
                brightness, disabledColor, states);
      }),
      foregroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) return disabledColor;
        return null;
      }),
      shape: ButtonState.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      )),
    );
  }

  @override
  DButtonStyle? themeStyleOf(BuildContext context) {
    return DButtonTheme.of(context).iconButtonStyle;
  }
}

class SmallIconButton extends InheritedWidget {
  const SmallIconButton({
    super.key,
    required super.child,
  });

  static SmallIconButton? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SmallIconButton>();
  }

  @override
  bool updateShouldNotify(SmallIconButton oldWidget) {
    return true;
  }
}
