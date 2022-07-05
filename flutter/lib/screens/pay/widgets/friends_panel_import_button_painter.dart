import 'package:flutter/material.dart';

class FriendsPanelImportButtonPainter extends CustomPainter {
  FriendsPanelImportButtonPainter({required this.percent});
  final int percent;

  @override
  void paint(Canvas canvas, Size size) {
    // gradient
    // final xOffset = ((size.width + 10) / 100) * percent;
    final xOffset = (size.width / 100) * percent;
    final paint = Paint()..color = const Color(0xFF00C5FF);
    final rect = Offset.zero & size;
    canvas.drawRect(rect, paint);

    paint.color = Colors.white;
    final progressRect =
        Rect.fromLTRB(0, size.height - 2, xOffset, size.height);
    canvas.drawRect(progressRect, paint);

    // TODO: gradient?
    // paint.shader = ui.Gradient.linear(
    //   Offset(-5 + xOffset, size.height / 2),
    //   Offset(0 + xOffset, size.height / 2),
    //   [
    //     Color(0xFF00C5FF),
    //     Colors.white,
    //     Color(0xFF00C5FF),
    //   ],
    //   [
    //     0,
    //     0.5,
    //     1.0,
    //   ],
    // );
    // canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
