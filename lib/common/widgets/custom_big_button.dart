import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/screens/flavor_config.dart';

class CustomBigButton extends StatelessWidget {
  const CustomBigButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textStyle,
    this.buttonStyle,
    this.textColor,
    OutlinedBorder? shape,
    this.side,
    this.child,
  }) : shape =
           shape ??
           const RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(8)),
           );

  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final Color? textColor;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return SizedBox(
      width: width ?? 60,
      height: height ?? 54,
      child:
          switch (FlavorConfig.isDesktop) {
            true => () {
              final desktopButtonStyle = Theme.of(
                context,
              ).extension<DCustomBigButtonStyle>()!.buttonStyle?.merge(
                DButtonStyle(
                  textStyle: ButtonState.all(
                    textStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                  foregroundColor: ButtonState.resolveWith((states) {
                    return switch (states) {
                      Set<ButtonStates>() when states.isDisabled =>
                        textColor?.withValues(alpha: 0.5) ??
                            Colors.white.withValues(alpha: 0.5),
                      Set<ButtonStates>() when states.isPressing =>
                        textColor ?? Colors.white,
                      Set<ButtonStates>() when states.isHovering =>
                        textColor ?? Colors.white,
                      _ => textColor ?? Colors.white,
                    };
                  }),
                  backgroundColor: ButtonState.resolveWith((states) {
                    return switch (states) {
                      Set<ButtonStates>() when states.isDisabled =>
                        backgroundColor?.withValues(alpha: 0.5) ??
                            SideSwapColors.lapisLazuli.withValues(alpha: 0.5),
                      Set<ButtonStates>() when states.isPressing =>
                        backgroundColor?.lerpWith(Colors.black, 0.15) ??
                            SideSwapColors.lapisLazuli.lerpWith(
                              Colors.black,
                              0.15,
                            ),
                      Set<ButtonStates>() when states.isHovering =>
                        backgroundColor?.lerpWith(Colors.black, 0.1) ??
                            SideSwapColors.lapisLazuli.lerpWith(
                              Colors.black,
                              0.1,
                            ),
                      _ => backgroundColor ?? SideSwapColors.lapisLazuli,
                    };
                  }),
                  border: ButtonState.all(side ?? BorderSide.none),
                  shape: ButtonState.all(shape),
                ),
              );

              return DButton(
                onPressed: enabled ? onPressed : null,
                cursor: enabled ? SystemMouseCursors.click : null,
                style: desktopButtonStyle,
                child: switch (child) {
                  Widget child => Opacity(
                    opacity: enabled ? 1.0 : 0.5,
                    child: child,
                  ),
                  _ => Center(
                    child: Text(text ?? '', overflow: TextOverflow.fade),
                  ),
                },
              );
            },
            _ => () {
              final mobileButtonStyle =
                  buttonStyle ??
                  Theme.of(
                    context,
                  ).extension<CustomBigButtonStyle>()!.buttonStyle?.copyWith(
                    shape: WidgetStatePropertyAll(shape),
                    side: WidgetStatePropertyAll(side),
                    textStyle: WidgetStatePropertyAll(
                      textStyle ?? Theme.of(context).textTheme.bodyLarge,
                    ),
                    foregroundColor: WidgetStateColor.resolveWith((states) {
                      return switch (states) {
                        Set<WidgetState>()
                            when states.contains(WidgetState.disabled) =>
                          textColor?.withValues(alpha: 0.5) ??
                              Colors.white.withValues(alpha: 0.5),
                        Set<WidgetState>()
                            when states.contains(WidgetState.hovered) =>
                          textColor ?? Colors.white,
                        Set<WidgetState>()
                            when states.contains(WidgetState.pressed) =>
                          textColor ?? Colors.white,
                        _ => textColor ?? Colors.white,
                      };
                    }),
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      return switch (states) {
                        Set<WidgetState>()
                            when states.contains(WidgetState.disabled) =>
                          backgroundColor?.withValues(alpha: 0.5) ??
                              SideSwapColors.lapisLazuli.withValues(alpha: 0.5),
                        Set<WidgetState>()
                            when states.contains(WidgetState.hovered) =>
                          backgroundColor?.lerpWith(Colors.black, 0.1) ??
                              SideSwapColors.lapisLazuli.lerpWith(
                                Colors.black,
                                0.1,
                              ),
                        Set<WidgetState>()
                            when states.contains(WidgetState.pressed) =>
                          backgroundColor?.lerpWith(Colors.black, 0.15) ??
                              SideSwapColors.lapisLazuli.lerpWith(
                                Colors.black,
                                0.15,
                              ),
                        _ => backgroundColor ?? SideSwapColors.lapisLazuli,
                      };
                    }),
                  );

              return TextButton(
                onPressed: enabled ? onPressed : null,
                style: mobileButtonStyle,
                child:
                    child != null
                        ? Opacity(opacity: enabled ? 1.0 : 0.5, child: child)
                        : Text(text ?? '', overflow: TextOverflow.fade),
              );
            },
          }(),
    );
  }
}

class DCustomBigButtonStyle extends ThemeExtension<DCustomBigButtonStyle> {
  final DButtonStyle? buttonStyle;

  DCustomBigButtonStyle({this.buttonStyle});

  @override
  DCustomBigButtonStyle copyWith({DButtonStyle? buttonStyle}) {
    return DCustomBigButtonStyle(buttonStyle: buttonStyle ?? this.buttonStyle);
  }

  @override
  DCustomBigButtonStyle lerp(
    covariant ThemeExtension<DCustomBigButtonStyle>? other,
    double t,
  ) {
    if (other is! DCustomBigButtonStyle) {
      return this;
    }

    return DCustomBigButtonStyle(
      buttonStyle: DButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }
}

class CustomBigButtonStyle extends ThemeExtension<CustomBigButtonStyle> {
  final ButtonStyle? buttonStyle;

  CustomBigButtonStyle({this.buttonStyle});

  @override
  CustomBigButtonStyle copyWith({ButtonStyle? buttonStyle}) {
    return CustomBigButtonStyle(buttonStyle: buttonStyle ?? this.buttonStyle);
  }

  @override
  CustomBigButtonStyle lerp(
    covariant ThemeExtension<CustomBigButtonStyle>? other,
    double t,
  ) {
    if (other is! CustomBigButtonStyle) {
      return this;
    }

    return CustomBigButtonStyle(
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }
}
