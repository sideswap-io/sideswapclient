import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:path_drawing/path_drawing.dart';

import 'package:sideswap/screens/flavor_config.dart';

String svgPath =
    'M189.568 39.155C406.065 68.7224 862.337 301.845 1112.99 232.041C1363.64 162.237 1125.85 -236.525 1125.85 -236.525L1642.53 373.917C1531.33 1017.01 -231.083 -394.312 397.165 1001.09C152.528 923.93 25.112 561.522 25.112 561.522C-85.0035 201.454 -26.9288 9.5875 189.568 39.155Z';

class BackgroundPainter extends CustomPainter {
  final double topPadding;

  BackgroundPainter({this.topPadding = 0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    var rect = Offset.zero & size;

    if (FlavorConfig.isDesktop) {
      paint.shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF005474), Color(0xFF00203F)],
        stops: [0.0, 1.0],
      ).createShader(rect);
    } else {
      paint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF005474), Color(0xFF00203F)],
        stops: [0.0, 1.0],
      ).createShader(rect);
    }

    canvas.drawRect(rect, paint);

    var path =
        Path()..addPath(
          parseSvgPathData(svgPath),
          Offset(14, -topPadding + topPadding / 2),
        );

    paint = Paint();

    if (FlavorConfig.isDesktop) {
      paint.shader = LinearGradient(
        begin: const Alignment(0.5, 0.0713),
        end: const Alignment(0.75, 1.0),
        colors: [
          const Color(0xFFE6F5FE).withValues(alpha: 0.02),
          const Color(0xFFE6F5FE).withValues(alpha: 0),
        ],
      ).createShader(rect);

      final storage = Matrix4Transform().left(200).up(340).matrix4.storage;
      path = path.transform(storage);
    } else {
      paint.shader = LinearGradient(
        begin: const Alignment(0.25, 0.0713),
        end: const Alignment(0.5, 1.0),
        colors: [
          const Color(0xFFE6F5FE).withValues(alpha: 0.02),
          const Color(0xFFE6F5FE).withValues(alpha: 0),
        ],
      ).createShader(rect);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
