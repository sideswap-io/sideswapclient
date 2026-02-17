import 'dart:ui';

import 'package:flutter/material.dart';

class NotificationMenuStyle extends ThemeExtension<NotificationMenuStyle> {
  const NotificationMenuStyle({required this.decoration, this.padding});

  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;

  @override
  NotificationMenuStyle copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
  }) {
    return NotificationMenuStyle(
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
    );
  }

  @override
  NotificationMenuStyle lerp(
    ThemeExtension<NotificationMenuStyle> other,
    double t,
  ) {
    if (other is! NotificationMenuStyle) {
      return this;
    }
    return NotificationMenuStyle(
      decoration: Decoration.lerp(decoration, other.decoration, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
    );
  }
}

class NotificationItemConnectRequestStyle
    extends ThemeExtension<NotificationItemConnectRequestStyle> {
  final double? height;
  final Decoration? decoration;
  final TextStyle? titleTextStyle;
  final Color? dividerColor;
  final TextStyle? subtitleHeaderTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? descriptionTextStyle;
  final TextStyle? privacyHeaderTextStyle;
  final TextStyle? privacyTextStyle;
  final TextStyle? cancelledTextStyle;

  const NotificationItemConnectRequestStyle({
    this.height,
    this.decoration,
    this.titleTextStyle,
    this.dividerColor,
    this.subtitleTextStyle,
    this.subtitleHeaderTextStyle,
    this.descriptionTextStyle,
    this.privacyHeaderTextStyle,
    this.privacyTextStyle,
    this.cancelledTextStyle,
  });

  @override
  NotificationItemConnectRequestStyle copyWith({
    double? height,
    Decoration? decoration,
    TextStyle? titleTextStyle,
    Color? dividerColor,
    TextStyle? subtitleHeaderTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? descriptionTextStyle,
    TextStyle? privacyHeaderTextStyle,
    TextStyle? privacyTextStyle,
    TextStyle? cancelledTextStyle,
  }) {
    return NotificationItemConnectRequestStyle(
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      dividerColor: dividerColor ?? this.dividerColor,
      subtitleHeaderTextStyle:
          subtitleHeaderTextStyle ?? this.subtitleHeaderTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
      privacyHeaderTextStyle:
          privacyHeaderTextStyle ?? this.privacyHeaderTextStyle,
      privacyTextStyle: privacyTextStyle ?? this.privacyTextStyle,
      cancelledTextStyle: cancelledTextStyle ?? this.cancelledTextStyle,
    );
  }

  @override
  NotificationItemConnectRequestStyle lerp(
    ThemeExtension<NotificationItemConnectRequestStyle> other,
    double t,
  ) {
    if (other is! NotificationItemConnectRequestStyle) {
      return this;
    }
    return NotificationItemConnectRequestStyle(
      height: lerpDouble(height, other.height, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      subtitleHeaderTextStyle: TextStyle.lerp(
        subtitleHeaderTextStyle,
        other.subtitleHeaderTextStyle,
        t,
      ),
      subtitleTextStyle: TextStyle.lerp(
        subtitleTextStyle,
        other.subtitleTextStyle,
        t,
      ),
      descriptionTextStyle: TextStyle.lerp(
        descriptionTextStyle,
        other.descriptionTextStyle,
        t,
      ),
      privacyHeaderTextStyle: TextStyle.lerp(
        privacyHeaderTextStyle,
        other.privacyHeaderTextStyle,
        t,
      ),
      privacyTextStyle: TextStyle.lerp(
        privacyTextStyle,
        other.privacyTextStyle,
        t,
      ),
      cancelledTextStyle: TextStyle.lerp(
        cancelledTextStyle,
        other.cancelledTextStyle,
        t,
      ),
    );
  }
}

class NotificationItemSignRequestStyle
    extends ThemeExtension<NotificationItemSignRequestStyle> {
  final double? height;
  final Decoration? decoration;
  final TextStyle? titleTextStyle;
  final Color? dividerColor;
  final TextStyle? cancelledTextStyle;

  const NotificationItemSignRequestStyle({
    this.height,
    this.decoration,
    this.titleTextStyle,
    this.dividerColor,
    this.cancelledTextStyle,
  });

  @override
  NotificationItemSignRequestStyle copyWith({
    double? height,
    Decoration? decoration,
    TextStyle? titleTextStyle,
    Color? dividerColor,
    TextStyle? cancelledTextStyle,
  }) {
    return NotificationItemSignRequestStyle(
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      dividerColor: dividerColor ?? this.dividerColor,
      cancelledTextStyle: cancelledTextStyle ?? this.cancelledTextStyle,
    );
  }

  @override
  NotificationItemSignRequestStyle lerp(
    ThemeExtension<NotificationItemSignRequestStyle> other,
    double t,
  ) {
    if (other is! NotificationItemSignRequestStyle) {
      return this;
    }
    return NotificationItemSignRequestStyle(
      height: lerpDouble(height, other.height, t),
      decoration: Decoration.lerp(decoration, other.decoration, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      cancelledTextStyle: TextStyle.lerp(
        cancelledTextStyle,
        other.cancelledTextStyle,
        t,
      ),
    );
  }
}
