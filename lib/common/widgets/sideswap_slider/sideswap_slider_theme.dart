import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider.dart';

class SideSwapSliderTrackMark {
  final double value;

  SideSwapSliderTrackMark({required this.value});
}

class SideSwapSliderThemeData with Diagnosticable {
  final SideSwapSliderTrackShape? trackShape;
  final SideSwapSliderTrackMarkShape? trackMarkShape;
  final List<SideSwapSliderTrackMark>? trackMarks;
  final SideSwapSliderComponentShape? thumbShape;
  final SideSwapSliderHatchMarkShape? hatchMarkShape;
  final double? trackHeight;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeTrackMarkColor;
  final Color? inactiveTrackMarkColor;
  final SideSwapSliderAxisInteraction? axisInteraction;

  SideSwapSliderThemeData({
    this.trackShape,
    this.trackMarkShape,
    this.trackMarks,
    this.thumbShape,
    this.hatchMarkShape,
    this.trackHeight,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeTrackMarkColor,
    this.inactiveTrackMarkColor,
    this.axisInteraction,
  });

  SideSwapSliderThemeData copyWith({
    SideSwapSliderTrackShape? trackShape,
    SideSwapSliderTrackMarkShape? trackMarkShape,
    List<SideSwapSliderTrackMark>? trackMarks,
    SideSwapSliderComponentShape? thumbShape,
    SideSwapSliderHatchMarkShape? hatchMarkShape,
    double? trackHeight,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? activeTrackMarkColor,
    Color? inactiveTrackMarkColor,
    Gradient? leftGradient,
    Gradient? rightGradient,
    SideSwapSliderAxisInteraction? axisInteraction,
  }) {
    return SideSwapSliderThemeData(
      trackShape: trackShape ?? this.trackShape,
      trackMarkShape: trackMarkShape ?? this.trackMarkShape,
      trackMarks: trackMarks ?? this.trackMarks,
      thumbShape: thumbShape ?? this.thumbShape,
      hatchMarkShape: hatchMarkShape ?? this.hatchMarkShape,
      trackHeight: trackHeight ?? this.trackHeight,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      activeTrackMarkColor: activeTrackMarkColor ?? this.activeTrackColor,
      inactiveTrackMarkColor: inactiveTrackMarkColor ?? this.inactiveTrackColor,
      axisInteraction: axisInteraction ?? this.axisInteraction,
    );
  }

  @override
  bool operator ==(covariant SideSwapSliderThemeData other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other.trackShape == trackShape &&
        other.trackMarkShape == trackMarkShape &&
        other.trackMarks == trackMarks &&
        other.thumbShape == thumbShape &&
        other.hatchMarkShape == hatchMarkShape &&
        other.trackHeight == trackHeight &&
        other.activeTrackColor == activeTrackColor &&
        other.inactiveTrackColor == inactiveTrackColor &&
        other.activeTrackMarkColor == activeTrackMarkColor &&
        other.inactiveTrackMarkColor == inactiveTrackMarkColor &&
        other.axisInteraction == axisInteraction;
  }

  @override
  int get hashCode =>
      trackShape.hashCode ^
      trackMarkShape.hashCode ^
      trackMarks.hashCode ^
      thumbShape.hashCode ^
      hatchMarkShape.hashCode ^
      trackHeight.hashCode ^
      activeTrackColor.hashCode ^
      inactiveTrackColor.hashCode ^
      activeTrackMarkColor.hashCode ^
      inactiveTrackMarkColor.hashCode ^
      axisInteraction.hashCode;
}

abstract class SideSwapSliderTrackShape {
  const SideSwapSliderTrackShape();

  Rect getPrefferedRect({
    required RenderBox parentBox,
    required Offset offset,
    required SideSwapSliderThemeData themeData,
  });

  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required Offset thumbCenter,
    required SideSwapSliderThemeData themeData,
  });
}

class SideSwapDefaultSliderTrackShape extends SideSwapSliderTrackShape {
  final Gradient? leftGradient;
  final Gradient? rightGradient;

  SideSwapDefaultSliderTrackShape({
    required this.leftGradient,
    required this.rightGradient,
  });

  @override
  Rect getPrefferedRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SideSwapSliderThemeData themeData,
  }) {
    assert(themeData.trackHeight! > 0, 'trackHeight must be > 0');

    final padding = themeData.trackHeight!;
    final thumbSize = themeData.thumbShape?.getPrefferedSize() ?? Size.zero;
    final maxTrackHeight = math.max(themeData.trackHeight!, thumbSize.height);

    final double trackLeft = offset.dx + padding;
    final double trackTop =
        offset.dy + (maxTrackHeight - themeData.trackHeight!) / 2;
    final double trackRight = trackLeft + parentBox.size.width - padding * 2;
    final double trackBottom = trackTop + themeData.trackHeight!;

    return Rect.fromLTRB(trackLeft, trackTop, trackRight, trackBottom);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required Offset thumbCenter,
    required SideSwapSliderThemeData themeData,
  }) {
    assert(themeData.activeTrackColor != null);
    assert(themeData.inactiveTrackColor != null);
    assert(themeData.axisInteraction != null);

    final canvas = context.canvas;

    final activePaint = Paint()..color = themeData.activeTrackColor!;
    final inactivePaint = Paint()..color = themeData.inactiveTrackColor!;

    final trackRect = getPrefferedRect(
      parentBox: parentBox,
      offset: offset,
      themeData: themeData,
    );

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    if (themeData.axisInteraction == SideSwapSliderAxisInteraction.left) {
      final drawTrackRect = Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx,
        trackRect.bottom,
      );

      final leftGradientPaint =
          Paint()..shader = leftGradient?.createShader(trackRect);

      // draw active side
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          drawTrackRect,
          topLeft: trackRadius,
          bottomLeft: trackRadius,
        ),
        leftGradient != null ? leftGradientPaint : activePaint,
      );

      // draw inactive side
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          thumbCenter.dx,
          trackRect.top,
          trackRect.right,
          trackRect.bottom,
          topRight: trackRadius,
          bottomRight: trackRadius,
        ),
        inactivePaint,
      );
    }

    if (themeData.axisInteraction == SideSwapSliderAxisInteraction.right) {
      final drawTrackRect = Rect.fromLTRB(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
      );

      final rightGradientPaint =
          Paint()..shader = rightGradient?.createShader(trackRect);

      // draw active side
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          drawTrackRect,
          topRight: trackRadius,
          bottomRight: trackRadius,
        ),
        rightGradient != null ? rightGradientPaint : activePaint,
      );

      // draw inactive side
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          trackRect.left,
          trackRect.top,
          thumbCenter.dx,
          trackRect.bottom,
          topLeft: trackRadius,
          bottomLeft: trackRadius,
        ),
        inactivePaint,
      );
    }

    if (themeData.axisInteraction == SideSwapSliderAxisInteraction.center) {
      // draw inactive background
      canvas.drawRRect(
        RRect.fromRectAndRadius(trackRect, trackRadius),
        inactivePaint,
      );

      if (thumbCenter.dx < trackRect.center.dx) {
        // draw active left side
        final drawTrackRect = Rect.fromPoints(
          Offset(thumbCenter.dx, trackRect.top),
          Offset(trackRect.center.dx, trackRect.bottom),
        );

        final leftTrackRect = Rect.fromLTRB(
          trackRect.left,
          trackRect.top,
          trackRect.center.dx,
          trackRect.bottom,
        );

        final leftGradientPaint =
            Paint()..shader = leftGradient?.createShader(leftTrackRect);

        canvas.drawRect(
          drawTrackRect,
          leftGradient != null ? leftGradientPaint : activePaint,
        );
      } else {
        // draw active right side
        final drawTrackRect = Rect.fromPoints(
          Offset(trackRect.center.dx, trackRect.top),
          Offset(thumbCenter.dx, trackRect.bottom),
        );

        final rightTrackRect = Rect.fromLTRB(
          trackRect.center.dx,
          trackRect.top,
          trackRect.right,
          trackRect.bottom,
        );

        final rightGradientPaint =
            Paint()..shader = rightGradient?.createShader(rightTrackRect);

        canvas.drawRect(
          drawTrackRect,
          rightGradient != null ? rightGradientPaint : activePaint,
        );
      }
    }
  }
}

abstract class SideSwapSliderTrackMarkShape {
  const SideSwapSliderTrackMarkShape();

  Size getPreferredSize({required SideSwapSliderThemeData themeData});

  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required Offset thumbCenter,
    required SideSwapSliderThemeData themeData,
    required List<SideSwapSliderTrackMark> marks,
    required double min,
    required double max,
  });
}

class SideSwapDefaultSliderTrackMarkShape extends SideSwapSliderTrackMarkShape {
  final double? markRadius;

  const SideSwapDefaultSliderTrackMarkShape({this.markRadius});

  @override
  Size getPreferredSize({required SideSwapSliderThemeData themeData}) {
    assert(themeData.trackHeight! > 0, 'trackHeight must be > 0');
    return Size.fromRadius(markRadius ?? themeData.trackHeight! / 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required Offset thumbCenter,
    required SideSwapSliderThemeData themeData,
    required List<SideSwapSliderTrackMark> marks,
    required double min,
    required double max,
  }) {
    assert(themeData.trackHeight != null);
    assert(themeData.trackShape != null);
    assert(themeData.axisInteraction != null);
    assert(themeData.activeTrackMarkColor != null);
    assert(themeData.inactiveTrackMarkColor != null);

    if (marks.isEmpty) {
      return;
    }
    final padding = themeData.trackHeight!;
    final trackRect = themeData.trackShape!.getPrefferedRect(
      parentBox: parentBox,
      offset: offset,
      themeData: themeData,
    );

    final trackMarkPadding = padding + padding / 2;
    final double adjustedTrackWidth = trackRect.width - padding;

    for (final mark in marks) {
      assert(
        mark.value >= min && mark.value <= max,
        'value must be between min and max. value: ${mark.value}, min: $min, max: $max',
      );
      final markCenter = Offset(
        offset.dx +
            trackMarkPadding +
            ((adjustedTrackWidth) * (mark.value - min) / (max - min)),
        trackRect.center.dy,
      );

      final xOffset = markCenter.dx - thumbCenter.dx;

      final color = switch (themeData.axisInteraction!) {
        SideSwapSliderAxisInteraction.left when xOffset > 0 =>
          themeData.inactiveTrackMarkColor!,
        SideSwapSliderAxisInteraction.right when xOffset < 0 =>
          themeData.inactiveTrackMarkColor!,
        SideSwapSliderAxisInteraction.center
            when (markCenter.dx < trackRect.center.dx &&
                    markCenter.dx < thumbCenter.dx) ||
                (markCenter.dx > trackRect.center.dx &&
                    markCenter.dx > thumbCenter.dx) =>
          themeData.inactiveTrackMarkColor!,
        _ => themeData.activeTrackMarkColor!,
      };

      final trackMarkPaint = Paint()..color = color;
      final trackMarkRadius = getPreferredSize(themeData: themeData).width / 2;

      context.canvas.drawCircle(markCenter, trackMarkRadius, trackMarkPaint);
    }
  }
}

abstract class SideSwapSliderComponentShape {
  Size getPrefferedSize();

  void paint(
    PaintingContext context,
    Offset offset,
    Offset thumbCenter, {
    required RenderBox parentBox,
    required SideSwapSliderThemeData themeData,
  });
}

class SideSwapDefaultSliderThumbShape extends SideSwapSliderComponentShape {
  final double thumbRadius;
  final Color? thumbColor;
  final Color? frameColor;
  final Color? leftColor;
  final Color? rightColor;
  final double? strokeRatio;

  SideSwapDefaultSliderThumbShape({
    this.thumbRadius = 10,
    this.thumbColor,
    this.frameColor,
    this.leftColor,
    this.rightColor,
    this.strokeRatio = 0.2,
  });

  @override
  Size getPrefferedSize() {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Offset thumbCenter, {
    required RenderBox parentBox,
    required SideSwapSliderThemeData themeData,
  }) {
    assert(themeData.activeTrackColor != null);
    assert(themeData.trackShape != null);

    final circlePaint =
        Paint()
          ..color =
              thumbColor != null ? thumbColor! : themeData.activeTrackColor!
          ..style = PaintingStyle.fill;

    final strokeWidth = thumbRadius * strokeRatio!;
    context.canvas.drawCircle(
      thumbCenter,
      thumbRadius - (strokeWidth / 2),
      circlePaint,
    );

    // draw frame
    final trackRect = themeData.trackShape!.getPrefferedRect(
      parentBox: parentBox,
      offset: offset,
      themeData: themeData,
    );
    if (frameColor != null && strokeRatio != null) {
      final internalFrameColor = switch (themeData.axisInteraction) {
        SideSwapSliderAxisInteraction.center
            when thumbCenter.dx < trackRect.center.dx =>
          leftColor!,
        SideSwapSliderAxisInteraction.center
            when thumbCenter.dx > trackRect.center.dx =>
          rightColor!,
        _ => frameColor!,
      };

      final framePaint =
          Paint()
            ..color = internalFrameColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth;

      context.canvas.drawCircle(
        thumbCenter,
        thumbRadius - (strokeWidth / 2),
        framePaint,
      );
    }
  }
}

abstract class SideSwapSliderHatchMarkShape {
  // Top padding from the track bottom
  final double padding;
  final double density;
  final double? markWidth;
  final double markHeight;
  final Color? activeColor;
  final Color? inactiveColor;

  SideSwapSliderHatchMarkShape({
    this.padding = .0,
    this.density = .0,
    this.markWidth = 1.0,
    this.markHeight = 10.0,
    this.activeColor,
    this.inactiveColor,
  });

  Size getPreferredSize();

  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required Offset thumbCenter,
    required SideSwapSliderThemeData themeData,
    required List<SideSwapSliderHatchMarkLabel> labels,
    required TextDirection defaultTextDirection,
    required TextStyle defaultTextStyle,
    required double min,
    required double max,
  });
}

/// TODO (malcolmpl): need fixes
///   1. track rect needs to be shorter by max of most distant text label widths to draw it properly
///   2. when track is shorter then track marks are drawn in wrong places
class SideSwapDefaultSliderHatchMarkShape extends SideSwapSliderHatchMarkShape {
  SideSwapDefaultSliderHatchMarkShape({
    super.padding,
    super.density,
    super.markWidth,
    super.markHeight,
    super.activeColor = Colors.black,
    super.inactiveColor = Colors.grey,
  });

  @override
  Size getPreferredSize() {
    return Size(100 * density * (markWidth ?? 0), padding + markHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required Offset thumbCenter,
    required SideSwapSliderThemeData themeData,
    required List<SideSwapSliderHatchMarkLabel> labels,
    required TextDirection defaultTextDirection,
    required TextStyle defaultTextStyle,
    required double min,
    required double max,
  }) {
    assert(activeColor != null);

    final hatchMarkPaint =
        Paint()
          ..color = activeColor!
          ..strokeCap = StrokeCap.square
          ..strokeWidth = 1.0
          ..style = PaintingStyle.fill;

    final trackRect =
        themeData.trackShape?.getPrefferedRect(
          parentBox: parentBox,
          offset: offset,
          themeData: themeData,
        ) ??
        Rect.zero;

    final thumbSize = themeData.thumbShape?.getPrefferedSize() ?? Size.zero;

    final topPadding = math.max(trackRect.height, thumbSize.height) + padding;
    final trackMarkPadding =
        (themeData.trackHeight ?? .0) + (themeData.trackHeight ?? .0) / 2;
    final leftPadding =
        (trackMarkPadding - (markWidth ?? .0) / 2).roundToDouble();
    // width from the first to the last of the track mark point - same as in render object paint method
    final adjustedTrackWidth = trackRect.width - (themeData.trackHeight ?? .0);

    final hatchMarkDensity = 100 * density;
    final hatchMarkSpacer =
        hatchMarkDensity == 0 ? 0 : (adjustedTrackWidth / hatchMarkDensity);

    for (int i = 0; i <= hatchMarkDensity; i++) {
      context.canvas.drawRect(
        Rect.fromPoints(
          Offset(
            leftPadding + offset.dx + (i * hatchMarkSpacer),
            offset.dy + topPadding,
          ),
          Offset(
            leftPadding + offset.dx + (i * hatchMarkSpacer) + (markWidth ?? .0),
            offset.dy + topPadding + markHeight,
          ),
        ),
        hatchMarkPaint,
      );
    }

    if (labels.isEmpty) {
      return;
    }

    for (var label in labels) {
      assert(
        label.value >= min && label.value <= max,
        'value must be between min and max. value: ${label.value}, min: $min, max: $max',
      );
      final textStyle = defaultTextStyle.merge(label.style);
      final textPainter = TextPainter(
        text: TextSpan(text: label.label, style: textStyle),
        textDirection: defaultTextDirection,
      )..layout();

      final markCenter = Offset(
        leftPadding +
            offset.dx +
            ((adjustedTrackWidth) * (label.value - min) / (max - min)),
        trackRect.center.dy,
      );
      final yOffset = offset.dy + topPadding;

      final labelHatchMarkPaint =
          Paint()
            ..color = label.markColor ?? Colors.transparent
            ..strokeCap = StrokeCap.square
            ..strokeWidth = 1.0
            ..style = PaintingStyle.fill;

      var xOffset = markCenter.dx - (label.markWidth! / 2);

      // draw label mark
      context.canvas.drawRect(
        Rect.fromPoints(
          Offset(xOffset, yOffset),
          Offset(xOffset + label.markWidth!, yOffset + label.markHeight!),
        ),
        label.markColor != null ? labelHatchMarkPaint : hatchMarkPaint,
      );

      // draw label text
      xOffset = markCenter.dx - textPainter.width / 2;
      if (xOffset < trackRect.left) {
        xOffset = trackRect.left;
      }

      textPainter.paint(
        context.canvas,
        Offset(xOffset, yOffset + label.markHeight!),
      );
    }
  }
}

class SideSwapSliderHatchMarkLabel {
  final String label;
  final TextStyle? style;
  final double value;
  final double? markWidth;
  final double? markHeight;
  final Color? markColor;

  SideSwapSliderHatchMarkLabel({
    required this.label,
    this.style,
    required this.value,
    this.markWidth = 2.0,
    this.markHeight = 10.0,
    this.markColor,
  });
}
