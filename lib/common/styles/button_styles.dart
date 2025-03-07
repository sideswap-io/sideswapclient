import 'package:flutter/material.dart';

class SideswapButtonStyle extends ThemeExtension<SideswapButtonStyle> {
  const SideswapButtonStyle({required this.style});

  final ButtonStyle style;

  @override
  SideswapButtonStyle copyWith({ButtonStyle? style}) =>
      SideswapButtonStyle(style: style ?? this.style);

  @override
  SideswapButtonStyle lerp(
    ThemeExtension<SideswapButtonStyle> other,
    double t,
  ) {
    if (other is! SideswapButtonStyle) {
      return this;
    }

    return SideswapButtonStyle(
      style: ButtonStyle.lerp(style, other.style, t) ?? const ButtonStyle(),
    );
  }
}

class WorkingOrderItemCancelButtonStyle
    extends ThemeExtension<WorkingOrderItemCancelButtonStyle> {
  const WorkingOrderItemCancelButtonStyle({this.style});

  final ButtonStyle? style;

  @override
  WorkingOrderItemCancelButtonStyle copyWith() {
    return WorkingOrderItemCancelButtonStyle(style: style);
  }

  @override
  WorkingOrderItemCancelButtonStyle lerp(
    ThemeExtension<WorkingOrderItemCancelButtonStyle> other,
    double t,
  ) {
    if (other is! WorkingOrderItemCancelButtonStyle) {
      return this;
    }

    return WorkingOrderItemCancelButtonStyle(
      style: ButtonStyle.lerp(style, other.style, t),
    );
  }
}

class SideswapNoButtonStyle extends ThemeExtension<SideswapNoButtonStyle> {
  const SideswapNoButtonStyle({this.style});

  final ButtonStyle? style;

  @override
  SideswapNoButtonStyle copyWith() {
    return SideswapNoButtonStyle(style: style);
  }

  @override
  SideswapNoButtonStyle lerp(
    ThemeExtension<SideswapNoButtonStyle> other,
    double t,
  ) {
    if (other is! SideswapNoButtonStyle) {
      return this;
    }

    return SideswapNoButtonStyle(
      style: ButtonStyle.lerp(style, other.style, t),
    );
  }
}

class SideswapYesButtonStyle extends ThemeExtension<SideswapYesButtonStyle> {
  const SideswapYesButtonStyle({this.style});

  final ButtonStyle? style;

  @override
  SideswapYesButtonStyle copyWith() {
    return SideswapYesButtonStyle(style: style);
  }

  @override
  SideswapYesButtonStyle lerp(
    ThemeExtension<SideswapYesButtonStyle> other,
    double t,
  ) {
    if (other is! SideswapYesButtonStyle) {
      return this;
    }

    return SideswapYesButtonStyle(
      style: ButtonStyle.lerp(style, other.style, t),
    );
  }
}
