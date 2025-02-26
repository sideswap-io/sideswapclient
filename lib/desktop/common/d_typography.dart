import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DTypography with Diagnosticable {
  final TextStyle? display;
  final TextStyle? titleLarge;
  final TextStyle? title;
  final TextStyle? subtitle;
  final TextStyle? bodyLarge;
  final TextStyle? bodyStrong;
  final TextStyle? body;
  final TextStyle? caption;

  const DTypography({
    this.display,
    this.titleLarge,
    this.title,
    this.subtitle,
    this.bodyLarge,
    this.bodyStrong,
    this.body,
    this.caption,
  });

  factory DTypography.standard({Brightness? brightness, Color? color}) {
    assert(brightness != null || color != null);
    color ??= brightness == Brightness.light ? Colors.black : Colors.white;
    return DTypography(
      display: TextStyle(
        fontSize: 42,
        color: color,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        fontSize: 34,
        color: color,
        fontWeight: FontWeight.w500,
      ),
      title: TextStyle(fontSize: 22, color: color, fontWeight: FontWeight.w600),
      subtitle: TextStyle(
        fontSize: 28,
        color: color,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: color,
        fontWeight: FontWeight.normal,
      ),
      bodyStrong: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: FontWeight.w600,
      ),
      body: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: FontWeight.normal,
      ),
      caption: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static DTypography lerp(DTypography? a, DTypography? b, double t) {
    return DTypography(
      display: TextStyle.lerp(a?.display, b?.display, t),
      titleLarge: TextStyle.lerp(a?.titleLarge, b?.titleLarge, t),
      title: TextStyle.lerp(a?.title, b?.title, t),
      subtitle: TextStyle.lerp(a?.subtitle, b?.subtitle, t),
      bodyLarge: TextStyle.lerp(a?.bodyLarge, b?.bodyLarge, t),
      bodyStrong: TextStyle.lerp(a?.bodyStrong, b?.bodyStrong, t),
      body: TextStyle.lerp(a?.body, b?.body, t),
      caption: TextStyle.lerp(a?.caption, b?.caption, t),
    );
  }

  /// Copy this with a new [typography]
  DTypography merge(DTypography? typography) {
    if (typography == null) return this;
    return DTypography(
      display: typography.display ?? display,
      titleLarge: typography.titleLarge ?? titleLarge,
      title: typography.title ?? title,
      subtitle: typography.subtitle ?? subtitle,
      bodyLarge: typography.bodyLarge ?? bodyLarge,
      bodyStrong: typography.bodyStrong ?? bodyStrong,
      body: typography.body ?? body,
      caption: typography.caption ?? caption,
    );
  }

  DTypography apply({
    String? fontFamily,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    Color? displayColor,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
  }) {
    return DTypography(
      display: display?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      titleLarge: titleLarge?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      title: title?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      subtitle: subtitle?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      bodyLarge: bodyLarge?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      bodyStrong: bodyStrong?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      body: body?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
      caption: caption?.apply(
        color: displayColor,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontFamily: fontFamily,
        fontSizeFactor: fontSizeFactor,
        fontSizeDelta: fontSizeDelta,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('header', display));
    properties.add(DiagnosticsProperty<TextStyle>('titleLarge', titleLarge));
    properties.add(DiagnosticsProperty<TextStyle>('title', title));
    properties.add(DiagnosticsProperty<TextStyle>('subtitle', subtitle));
    properties.add(DiagnosticsProperty<TextStyle>('bodyLarge', bodyLarge));
    properties.add(DiagnosticsProperty<TextStyle>('bodyStrong', bodyStrong));
    properties.add(DiagnosticsProperty<TextStyle>('body', body));
    properties.add(DiagnosticsProperty<TextStyle>('caption', caption));
  }
}
