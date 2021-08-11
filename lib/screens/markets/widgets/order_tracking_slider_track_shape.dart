import 'package:flutter/material.dart';

class OrderTrackingSliderTrackShape extends RoundedRectSliderTrackShape {
  OrderTrackingSliderTrackShape({
    required this.minValue,
    required this.maxValue,
    this.inverse = false,
    this.negativeColor = const Color(0xFFFF7878),
    this.positiveColor = const Color(0xFF2CCCBF),
  });

  final double minValue;
  final double maxValue;
  final bool inverse;
  final Color negativeColor;
  final Color positiveColor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);

    final double thumbWidth =
        sliderTheme.thumbShape?.getPreferredSize(true, isDiscrete).width ?? 0;

    final double trackWidth = parentBox.size.width;
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final Rect trackRect = Rect.fromLTRB(
      offset.dx + thumbWidth / 2,
      offset.dy + (parentBox.size.height - trackHeight) / 2,
      trackWidth - thumbWidth / 2,
      trackHeight * 2,
    );

    final trackNegativeBackground = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      trackRect.left + thumbCenter.dx - thumbWidth,
      trackRect.bottom,
    );
    final trackPositiveBackground = Rect.fromLTRB(
      trackRect.left + thumbCenter.dx - thumbWidth,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    final padding = (trackHeight * 0.4) / 2;

    final negativeGradientRect = Rect.fromLTRB(
      trackRect.left + thumbWidth / 2,
      trackRect.top + padding,
      trackRect.left + trackRect.width / 2,
      trackRect.bottom - padding,
    );

    final negativeGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          negativeColor,
          negativeColor.withOpacity(.1),
        ],
      ).createShader(negativeGradientRect);

    final positiveGradientRect = Rect.fromLTRB(
      trackRect.left + trackRect.width / 2,
      trackRect.top + padding,
      trackRect.right - thumbWidth / 2,
      trackRect.bottom - padding,
    );

    final positiveGradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          positiveColor.withOpacity(.1),
          positiveColor,
        ],
      ).createShader(positiveGradientRect);

    final radius = Radius.circular(trackRect.height / 2);
    final isThumbOnLeftSide =
        thumbCenter.dx < (trackRect.left + trackRect.width) / 2;

    final trackPaint = Paint()..color = const Color(0xFF135579);

    // draw background
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      trackPaint,
    );

    if (isThumbOnLeftSide) {
      // draw gradient
      context.canvas.drawRect(negativeGradientRect, negativeGradientPaint);
      // cover gradient on left side
      context.canvas.drawRRect(
          RRect.fromRectAndRadius(trackNegativeBackground, radius), trackPaint);
    } else {
      // draw gradient
      context.canvas.drawRect(positiveGradientRect, positiveGradientPaint);
      // cover gradient on right side
      context.canvas.drawRRect(
          RRect.fromRectAndRadius(trackPositiveBackground, radius), trackPaint);
    }
  }
}
