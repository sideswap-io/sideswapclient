import 'package:flutter/material.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class OrderTrackingSliderThumbShape extends SliderComponentShape {
  OrderTrackingSliderThumbShape({
    this.minValue = 0,
    this.maxValue = 0,
    this.negativeColor = SideSwapColors.bitterSweet,
    this.positiveColor = SideSwapColors.turquoise,
    this.circleNegativeColor = SideSwapColors.policeBlue,
    this.circlePositiveColor = SideSwapColors.metallicSeaweed,
    this.customRadius,
    this.stokeRatio = 0.214285,
  });

  final double minValue;
  final double maxValue;
  final MaterialColor negativeColor;
  final MaterialColor positiveColor;
  final MaterialColor circleNegativeColor;
  final MaterialColor circlePositiveColor;

  var borderColor = SideSwapColors.navyBlue;
  var circleColor = SideSwapColors.prussianBlue;
  final double? customRadius;
  final double defaultRadius = 14.0;
  final double stokeRatio;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(customRadius ?? defaultRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final newValue = convertToNewRange(
      value: value,
      minValue: 0,
      maxValue: 1,
      newMin: minValue.toDouble(),
      newMax: maxValue.toDouble(),
    );

    if (newValue < 0) {
      borderColor = negativeColor;
      circleColor = circleNegativeColor;
    }
    if (newValue > 0) {
      borderColor = positiveColor;
      circleColor = circlePositiveColor;
    }

    final paintCircle = Paint()..color = circleColor;
    final radius = customRadius ?? defaultRadius;
    final paintBorder = Paint()
      ..color = borderColor
      ..strokeWidth = radius * stokeRatio
      ..style = PaintingStyle.stroke;

    context.canvas.drawCircle(center, radius, paintCircle);
    context.canvas.drawCircle(center, radius, paintBorder);
  }
}
