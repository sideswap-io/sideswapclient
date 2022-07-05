import 'package:flutter/material.dart';

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double radius;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 1.0,
    this.overlayColor = const Color(0x88000000),
    this.radius = 23,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
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
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    const lineSize = 50;

    final innerLeftTop1 = Offset(rect.left, rect.top + radius + lineSize);
    final innerLeftTop2 = Offset(rect.left + radius + lineSize, rect.top);
    final innerRightTop1 = Offset(rect.right - radius - lineSize, rect.top);
    final innerRightTop2 = Offset(rect.right, rect.top + radius + lineSize);
    final innerRightBottom1 =
        Offset(rect.right, rect.bottom - radius - lineSize);
    final innerRightBottom2 =
        Offset(rect.right - radius - lineSize, rect.bottom);
    final innerLeftBottom1 = Offset(rect.left + radius + lineSize, rect.bottom);
    final innerLeftBottom2 = Offset(rect.left, rect.bottom - radius - lineSize);

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    //Draw top right corner
    canvas
      ..drawPath(
          Path()
            ..moveTo(innerRightTop1.dx, innerRightTop1.dy)
            ..lineTo(innerRightTop1.dx + lineSize, innerRightTop1.dy)
            ..arcToPoint(
                Offset(innerRightTop2.dx, innerRightTop2.dy - lineSize),
                radius: Radius.circular(radius))
            ..lineTo(innerRightTop2.dx, innerRightTop2.dy),
          paint)
      //Draw bottom right corner
      ..drawPath(
          Path()
            ..moveTo(innerRightBottom1.dx, innerRightBottom1.dy)
            ..lineTo(innerRightBottom1.dx, innerRightBottom1.dy + lineSize)
            ..arcToPoint(
                Offset(innerRightBottom2.dx + lineSize, innerRightBottom2.dy),
                radius: Radius.circular(radius))
            ..lineTo(innerRightBottom2.dx, innerRightBottom2.dy),
          paint)
      ..drawPath(
          Path()
            ..moveTo(innerLeftBottom1.dx, innerLeftBottom1.dy)
            ..lineTo(innerLeftBottom1.dx - lineSize, innerLeftBottom1.dy)
            ..arcToPoint(
                Offset(innerLeftBottom2.dx, innerLeftBottom2.dy + lineSize),
                radius: Radius.circular(radius))
            ..lineTo(innerLeftBottom2.dx, innerLeftBottom2.dy),
          paint)
      ..drawPath(
          Path()
            ..moveTo(innerLeftTop1.dx, innerLeftTop1.dy)
            ..lineTo(innerLeftTop1.dx, innerLeftTop1.dy - lineSize)
            ..arcToPoint(Offset(innerLeftTop2.dx - lineSize, innerLeftTop2.dy),
                radius: Radius.circular(radius))
            ..lineTo(innerLeftTop2.dx, innerLeftTop2.dy),
          paint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
