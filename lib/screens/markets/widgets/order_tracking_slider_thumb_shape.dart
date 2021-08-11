import 'package:flutter/material.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';

class OrderTrackingSliderThumbShape extends SliderComponentShape {
  OrderTrackingSliderThumbShape({
    this.minValue = 0,
    this.maxValue = 0,
    this.negativeColor = const Color(0xFFFF7878),
    this.positiveColor = const Color(0xFF2CCCBF),
    this.circleNegativeColor = const Color(0xFF3E475F),
    this.circlePositiveColor = const Color(0xFF147385),
  });

  final double minValue;
  final double maxValue;
  final Color negativeColor;
  final Color positiveColor;
  final Color circleNegativeColor;
  final Color circlePositiveColor;

  var borderColor = const Color(0xFF1B8BC8);
  var circleColor = const Color(0xFF043857);
  final radius = 14.0.r;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
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
    final paintBorder = Paint()
      ..color = borderColor
      ..strokeWidth = radius * 0.214285
      ..style = PaintingStyle.stroke;

    context.canvas.drawCircle(center, radius, paintCircle);
    context.canvas.drawCircle(center, radius, paintBorder);
  }
}
