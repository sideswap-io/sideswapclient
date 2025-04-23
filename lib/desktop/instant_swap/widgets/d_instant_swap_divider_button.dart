import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/screens/instant_swap/widgets/instant_swap_divider.dart';

class DInstantSwapDividerButton extends HookConsumerWidget {
  final double radius;
  final DInstantSwapDividerButtonStyle? style;
  final void Function()? onPressed;

  const DInstantSwapDividerButton({
    this.radius = 48,
    this.onPressed,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultButtonStyle =
        Theme.of(
          context,
        ).extension<DInstantSwapDividerButtonStyle>()?.buttonStyle ??
        DButtonStyle(
          padding: ButtonState.all(EdgeInsets.zero),
          shape: ButtonState.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          ),
          backgroundColor: ButtonState.resolveWith((states) {
            return switch (states) {
              Set<ButtonStates>() when states.isDisabled =>
                SideSwapColors.brightTurquoise.toAccentColor().darker,
              Set<ButtonStates>() when states.isPressing => SideSwapColors
                  .brightTurquoise
                  .lerpWith(Colors.black, 0.25),
              Set<ButtonStates>() when states.isHovering => SideSwapColors
                  .brightTurquoise
                  .lerpWith(Colors.black, 0.2),
              _ => SideSwapColors.brightTurquoise,
            };
          }),
        );

    return DButton(
      style: defaultButtonStyle,
      onPressed: onPressed,
      child: InstantSwapDividerButtonBody(radius: radius),
    );
  }
}

class DInstantSwapDividerButtonStyle
    extends ThemeExtension<DInstantSwapDividerButtonStyle> {
  final DButtonStyle? buttonStyle;

  DInstantSwapDividerButtonStyle({this.buttonStyle});

  @override
  ThemeExtension<DInstantSwapDividerButtonStyle> copyWith({
    DButtonStyle? buttonStyle,
  }) {
    return DInstantSwapDividerButtonStyle(
      buttonStyle: buttonStyle ?? this.buttonStyle,
    );
  }

  @override
  ThemeExtension<DInstantSwapDividerButtonStyle> lerp(
    covariant ThemeExtension<DInstantSwapDividerButtonStyle>? other,
    double t,
  ) {
    if (other is! DInstantSwapDividerButtonStyle) {
      return this;
    }

    return DInstantSwapDividerButtonStyle(
      buttonStyle: DButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }
}
