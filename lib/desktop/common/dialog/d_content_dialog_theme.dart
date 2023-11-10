import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/d_typography.dart';
import 'package:sideswap/desktop/theme.dart';

@immutable
class DContentDialogThemeData {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? bodyPadding;

  final Decoration? decoration;
  final Color? barrierColor;

  final DButtonThemeData? actionThemeData;
  final double? actionsSpacing;
  final Decoration? actionsDecoration;
  final EdgeInsetsGeometry? actionsPadding;

  final TextStyle? titleStyle;
  final TextStyle? bodyStyle;

  const DContentDialogThemeData({
    this.decoration,
    this.barrierColor,
    this.titlePadding,
    this.bodyPadding,
    this.padding,
    this.actionsSpacing,
    this.actionThemeData,
    this.actionsDecoration,
    this.actionsPadding,
    this.titleStyle,
    this.bodyStyle,
  });

  factory DContentDialogThemeData.standard(
      {Color? menuColor, Color? micaBackgroundColor, DTypography? typography}) {
    final container = ProviderContainer();
    final themeMenuColor = container.read(desktopAppThemeProvider).menuColor;
    final themeMicaBackgroundColor =
        container.read(desktopAppThemeProvider).micaBackgroundColor;
    final themeTypography = container.read(desktopAppThemeProvider).typography;

    return DContentDialogThemeData(
      decoration: BoxDecoration(
        color: menuColor ?? themeMenuColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: kElevationToShadow[6],
      ),
      padding: const EdgeInsets.all(20),
      titlePadding: const EdgeInsets.only(bottom: 12),
      actionsSpacing: 10,
      actionsDecoration: BoxDecoration(
        color: micaBackgroundColor ?? themeMicaBackgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        boxShadow: kElevationToShadow[1],
      ),
      actionsPadding: const EdgeInsets.all(20),
      barrierColor: Colors.grey[200]?.withOpacity(0.8),
      titleStyle: typography?.title ?? themeTypography.title,
      bodyStyle: typography?.body ?? themeTypography.body,
    );
  }

  static DContentDialogThemeData lerp(
    DContentDialogThemeData? a,
    DContentDialogThemeData? b,
    double t,
  ) {
    return DContentDialogThemeData(
      decoration: Decoration.lerp(a?.decoration, b?.decoration, t),
      barrierColor: Color.lerp(a?.barrierColor, b?.barrierColor, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      bodyPadding: EdgeInsetsGeometry.lerp(a?.bodyPadding, b?.bodyPadding, t),
      titlePadding:
          EdgeInsetsGeometry.lerp(a?.titlePadding, b?.titlePadding, t),
      actionsSpacing: lerpDouble(a?.actionsSpacing, b?.actionsSpacing, t),
      actionThemeData:
          DButtonThemeData.lerp(a?.actionThemeData, b?.actionThemeData, t),
      actionsDecoration:
          Decoration.lerp(a?.actionsDecoration, b?.actionsDecoration, t),
      actionsPadding:
          EdgeInsetsGeometry.lerp(a?.actionsPadding, b?.actionsPadding, t),
      titleStyle: TextStyle.lerp(a?.titleStyle, b?.titleStyle, t),
      bodyStyle: TextStyle.lerp(a?.bodyStyle, b?.bodyStyle, t),
    );
  }

  DContentDialogThemeData merge(DContentDialogThemeData? style) {
    if (style == null) return this;
    return DContentDialogThemeData(
      decoration: style.decoration ?? decoration,
      barrierColor: style.barrierColor ?? barrierColor,
      padding: style.padding ?? padding,
      bodyPadding: style.bodyPadding ?? bodyPadding,
      titlePadding: style.titlePadding ?? titlePadding,
      actionsSpacing: style.actionsSpacing ?? actionsSpacing,
      actionThemeData: style.actionThemeData ?? actionThemeData,
      actionsDecoration: style.actionsDecoration ?? actionsDecoration,
      actionsPadding: style.actionsPadding ?? actionsPadding,
      titleStyle: style.titleStyle ?? titleStyle,
      bodyStyle: style.bodyStyle ?? bodyStyle,
    );
  }
}
