import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class MultipleOutputsIcon extends StatelessWidget {
  const MultipleOutputsIcon({super.key, this.width = 20, this.height = 20});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: MultipleOutputsPainter()),
    );
  }
}

class MultipleOutputsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    final backgroundPaint =
        Paint()
          ..color = SideSwapColors.lapisLazuli
          ..style = PaintingStyle.fill;
    canvas.drawCircle(rect.center, rect.width / 2, backgroundPaint);

    final dotPaint =
        Paint()
          ..color = SideSwapColors.brightTurquoise
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      rect.center.translate(-rect.center.dx * 0.3, -rect.center.dy * 0.3),
      rect.width * 0.1,
      dotPaint,
    );

    canvas.drawCircle(
      rect.center.translate(rect.center.dx * 0.3, -rect.center.dy * 0.3),
      rect.width * 0.1,
      dotPaint,
    );

    canvas.drawCircle(
      rect.center.translate(-rect.center.dx * 0.3, rect.center.dy * 0.3),
      rect.width * 0.1,
      dotPaint,
    );

    canvas.drawCircle(
      rect.center.translate(rect.center.dx * 0.3, rect.center.dy * 0.3),
      rect.width * 0.1,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
