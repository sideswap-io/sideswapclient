import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_depth_container.freezed.dart';

@freezed
sealed class OrderDepthSide with _$OrderDepthSide {
  const factory OrderDepthSide.left() = OrderDepthSideLeft;
  const factory OrderDepthSide.right() = OrderDepthSideRight;
}

class OrderDepthContainerPainer extends CustomPainter {
  final double depthPercent;
  final Color backgroundColor;
  final Color depthColor;
  final OrderDepthSide side;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final bool drawEmpty;

  OrderDepthContainerPainer({
    super.repaint,
    this.drawEmpty = false,
    required this.depthPercent,
    required this.backgroundColor,
    required this.depthColor,
    this.side = const OrderDepthSide.left(),
    required this.borderRadius,
    required this.border,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drawEmpty) {
      return;
    }

    final Paint backgroundPaint = Paint()..color = backgroundColor;
    final RRect backgroundRRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius?.resolve(TextDirection.ltr).topLeft ?? Radius.zero,
      topRight:
          borderRadius?.resolve(TextDirection.ltr).topRight ?? Radius.zero,
      bottomLeft:
          borderRadius?.resolve(TextDirection.ltr).bottomLeft ?? Radius.zero,
      bottomRight:
          borderRadius?.resolve(TextDirection.ltr).bottomRight ?? Radius.zero,
    );
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    if (border != null && border is Border) {
      final Border b = border as Border;
      final Paint borderPaint =
          Paint()
            ..color = b.top.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = b.top.width;
      canvas.drawRRect(backgroundRRect, borderPaint);
    }

    final double depthWidth = size.width * depthPercent;
    final Rect depthRect =
        side == OrderDepthSide.left()
            ? Rect.fromLTWH(0, 0, depthWidth, size.height)
            : Rect.fromLTWH(
              size.width - depthWidth,
              0,
              depthWidth,
              size.height,
            );

    final RRect depthRRect = RRect.fromRectAndCorners(
      depthRect,
      topLeft:
          side == OrderDepthSide.left()
              ? backgroundRRect.tlRadius
              : Radius.zero,
      topRight:
          side == OrderDepthSide.right()
              ? backgroundRRect.trRadius
              : Radius.zero,
      bottomLeft:
          side == OrderDepthSide.left()
              ? backgroundRRect.blRadius
              : Radius.zero,
      bottomRight:
          side == OrderDepthSide.right()
              ? backgroundRRect.brRadius
              : Radius.zero,
    );

    final Paint depthPaint = Paint()..color = depthColor;
    canvas.drawRRect(depthRRect, depthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! OrderDepthContainerPainer ||
        oldDelegate.drawEmpty != drawEmpty ||
        oldDelegate.depthPercent != depthPercent ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.depthColor != depthColor ||
        oldDelegate.side != side ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.border != border;
  }
}
