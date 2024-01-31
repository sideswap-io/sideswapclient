import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';

class DButtonStyle with Diagnosticable {
  const DButtonStyle({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.elevation,
    this.padding,
    this.border,
    this.shape,
    this.iconSize,
  });

  final ButtonState<TextStyle?>? textStyle;

  final ButtonState<Color?>? backgroundColor;

  final ButtonState<Color?>? foregroundColor;

  final ButtonState<Color?>? shadowColor;

  final ButtonState<double?>? elevation;

  final ButtonState<EdgeInsetsGeometry?>? padding;

  final ButtonState<BorderSide?>? border;

  final ButtonState<OutlinedBorder?>? shape;

  final ButtonState<double?>? iconSize;

  DButtonStyle? merge(DButtonStyle? other) {
    if (other == null) return this;
    return DButtonStyle(
      textStyle: other.textStyle ?? textStyle,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      shadowColor: other.shadowColor ?? shadowColor,
      elevation: other.elevation ?? elevation,
      padding: other.padding ?? padding,
      border: other.border ?? border,
      shape: other.shape ?? shape,
      iconSize: other.iconSize ?? iconSize,
    );
  }

  static DButtonStyle lerp(DButtonStyle? a, DButtonStyle? b, double t) {
    return DButtonStyle(
      textStyle:
          ButtonState.lerp(a?.textStyle, b?.textStyle, t, TextStyle.lerp),
      backgroundColor: ButtonState.lerp(
          a?.backgroundColor, b?.backgroundColor, t, Color.lerp),
      foregroundColor: ButtonState.lerp(
          a?.foregroundColor, b?.foregroundColor, t, Color.lerp),
      shadowColor:
          ButtonState.lerp(a?.shadowColor, b?.shadowColor, t, Color.lerp),
      elevation: ButtonState.lerp(a?.elevation, b?.elevation, t, lerpDouble),
      padding:
          ButtonState.lerp(a?.padding, b?.padding, t, EdgeInsetsGeometry.lerp),
      border: ButtonState.lerp(a?.border, b?.border, t, (a, b, t) {
        if (a == null && b == null) return null;
        if (a == null) return b;
        if (b == null) return a;
        return BorderSide.lerp(a, b, t);
      }),
      shape: ButtonState.lerp(a?.shape, b?.shape, t, (a, b, t) {
        return ShapeBorder.lerp(a, b, t) as OutlinedBorder;
      }),
      iconSize: ButtonState.lerp(
        a?.iconSize,
        b?.iconSize,
        t,
        lerpDouble,
      ),
    );
  }
}

class DButtonTheme extends InheritedTheme {
  const DButtonTheme({
    super.key,
    required super.child,
    required this.data,
  });

  final DButtonThemeData data;

  static Widget merge({
    Key? key,
    required DButtonThemeData data,
    required Widget child,
  }) {
    return Builder(builder: (BuildContext context) {
      return DButtonTheme(
        key: key,
        data: _getInheritedButtonThemeData(context)?.merge(data) ?? data,
        child: child,
      );
    });
  }

  static DButtonThemeData of(BuildContext context) {
    final container = ProviderContainer();
    final buttonThemeData =
        container.read(desktopAppThemeNotifierProvider).buttonThemeData;
    return buttonThemeData.merge(_getInheritedButtonThemeData(context));
  }

  static DButtonThemeData? _getInheritedButtonThemeData(BuildContext context) {
    final DButtonTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<DButtonTheme>();
    return buttonTheme?.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DButtonTheme oldWidget) {
    return oldWidget.data != data;
  }
}

@immutable
class DButtonThemeData with Diagnosticable {
  final DButtonStyle? defaultButtonStyle;
  final DButtonStyle? filledButtonStyle;
  final DButtonStyle? textButtonStyle;
  final DButtonStyle? outlinedButtonStyle;
  final DButtonStyle? iconButtonStyle;

  const DButtonThemeData({
    this.defaultButtonStyle,
    this.filledButtonStyle,
    this.textButtonStyle,
    this.outlinedButtonStyle,
    this.iconButtonStyle,
  });

  const DButtonThemeData.all(DButtonStyle? style)
      : defaultButtonStyle = style,
        filledButtonStyle = style,
        textButtonStyle = style,
        outlinedButtonStyle = style,
        iconButtonStyle = style;

  static DButtonThemeData lerp(
    DButtonThemeData? a,
    DButtonThemeData? b,
    double t,
  ) {
    return const DButtonThemeData();
  }

  DButtonThemeData merge(DButtonThemeData? style) {
    if (style == null) return this;
    return DButtonThemeData(
      outlinedButtonStyle: style.outlinedButtonStyle ?? outlinedButtonStyle,
      filledButtonStyle: style.filledButtonStyle ?? filledButtonStyle,
      textButtonStyle: style.textButtonStyle ?? textButtonStyle,
      defaultButtonStyle: style.defaultButtonStyle ?? defaultButtonStyle,
      iconButtonStyle: style.iconButtonStyle ?? iconButtonStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<DButtonStyle>(
          'outlinedButtonStyle', outlinedButtonStyle))
      ..add(DiagnosticsProperty<DButtonStyle>(
          'filledButtonStyle', filledButtonStyle))
      ..add(
          DiagnosticsProperty<DButtonStyle>('textButtonStyle', textButtonStyle))
      ..add(DiagnosticsProperty<DButtonStyle>(
          'defaultButtonStyle', defaultButtonStyle))
      ..add(DiagnosticsProperty<DButtonStyle>(
          'iconButtonStyle', iconButtonStyle));
  }

  static Color buttonColor(Brightness brightness, Set<ButtonStates> states) {
    late Color color;
    if (brightness == Brightness.light) {
      if (states.isPressing) {
        color = const Color(0xFFf2f2f2);
      } else if (states.isHovering) {
        color = const Color(0xFFF6F6F6);
      } else {
        color = Colors.white;
      }
      return color;
    } else {
      if (states.isPressing) {
        color = const Color(0xFF272727);
      } else if (states.isHovering) {
        color = const Color(0xFF323232);
      } else {
        color = const Color(0xFF2b2b2b);
      }
      return color;
    }
  }

  static Color checkedInputColor(ThemeData theme, Set<ButtonStates> states) {
    final bool isDark = theme.brightness == Brightness.dark;
    return states.isPressing
        ? isDark
            ? theme.colorScheme.secondary
            : theme.colorScheme.secondary
        : states.isHovering
            ? isDark
                ? theme.colorScheme.secondary
                : theme.colorScheme.secondary
            : theme.colorScheme.secondary;
  }

  static Color uncheckedInputColor(
      Brightness brightness, Color disabledColor, Set<ButtonStates> states) {
    if (brightness == Brightness.light) {
      if (states.isDisabled) return disabledColor;
      if (states.isPressing) return const Color(0xFF221D08).withOpacity(0.155);
      if (states.isHovering) return const Color(0xFF221D08).withOpacity(0.055);
      return Colors.transparent;
    } else {
      if (states.isDisabled) return disabledColor;
      if (states.isPressing) return const Color(0xFFFFF3E8).withOpacity(0.080);
      if (states.isHovering) return const Color(0xFFFFF3E8).withOpacity(0.12);
      return Colors.transparent;
    }
  }
}
