import 'dart:ui';
import 'package:flutter/material.dart';

class BiometricShapeBorder extends ShapeBorder {
  BiometricShapeBorder({
    this.borderWidth = 6.0,
    this.borderLength = 41,
    this.borderRadius = 8,
    this.borderColor = const Color(0xFF00C5FF),
    this.backgroundColor = const Color(0xFF135579),
  });

  final double borderWidth;
  final double borderLength;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    final _halfBorderWidth = borderWidth / 2;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Color(0xFF135579)
      ..style = PaintingStyle.fill;

    final topLeftX = rect.topLeft.dx + _halfBorderWidth;
    final topLeftY = rect.topLeft.dy + _halfBorderWidth;
    final topRightX = rect.topRight.dx - _halfBorderWidth;
    final topRightY = rect.topRight.dy + _halfBorderWidth;

    final bottomLeftX = rect.bottomLeft.dx + _halfBorderWidth;
    final bottomLeftY = rect.bottomLeft.dy - _halfBorderWidth;
    final bottomRightX = rect.bottomRight.dx - _halfBorderWidth;
    final bottomRightY = rect.bottomRight.dy - _halfBorderWidth;

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRRect(
          RRect.fromLTRBAndCorners(
            rect.topLeft.dx,
            rect.topLeft.dy,
            rect.bottomRight.dx,
            rect.bottomRight.dy,
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
            bottomLeft: Radius.circular(borderRadius),
            bottomRight: Radius.circular(borderRadius),
          ),
          backgroundPaint)
      ..restore();

    final topLeftLine = Path()
      ..moveTo(topLeftX, topLeftY + borderLength)
      ..lineTo(topLeftX, topLeftY + borderRadius / 2)
      ..arcToPoint(Offset(topLeftX + borderRadius / 2, topLeftY),
          radius: Radius.circular(borderRadius / 2))
      ..lineTo(topLeftX + borderLength, topLeftY);

    final topRightLine = Path()
      ..moveTo(topRightX, topRightY + borderLength)
      ..lineTo(topRightX, topRightY + borderRadius / 2)
      ..arcToPoint(Offset(topRightX - borderRadius / 2, topRightY),
          radius: Radius.circular(borderRadius / 2), clockwise: false)
      ..lineTo(topRightX - borderLength, topRightY);

    final bottomRightLine = Path()
      ..moveTo(bottomRightX - borderLength, bottomRightY)
      ..lineTo(bottomRightX - borderRadius / 2, bottomRightY)
      ..arcToPoint(Offset(bottomRightX, bottomRightY - borderRadius / 2),
          radius: Radius.circular(borderRadius / 2), clockwise: false)
      ..lineTo(bottomRightX, bottomRightY - borderLength);

    final bottomLeftLine = Path()
      ..moveTo(bottomLeftX, bottomLeftY - borderLength)
      ..lineTo(bottomLeftX, bottomLeftY - borderRadius / 2)
      ..arcToPoint(Offset(bottomLeftX + borderRadius / 2, bottomLeftY),
          radius: Radius.circular(borderRadius / 2), clockwise: false)
      ..lineTo(bottomLeftX + borderLength, bottomLeftY);

    canvas
      ..drawPath(topLeftLine, borderPaint)
      ..drawPath(topRightLine, borderPaint)
      ..drawPath(bottomRightLine, borderPaint)
      ..drawPath(bottomLeftLine, borderPaint)
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }
}
