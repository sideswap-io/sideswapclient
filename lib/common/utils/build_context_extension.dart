import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size calculateTextSize({required String text, required TextStyle style}) {
    /// defaultTextStyle is needed, because Text widget is mergin it with given style!
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(this);
    final mergedStyle = defaultTextStyle.style.merge(style);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: mergedStyle),
      textDirection: Directionality.of(this),
      textScaler: MediaQuery.of(this).textScaler,
    )..layout();

    return textPainter.size;
  }
}
