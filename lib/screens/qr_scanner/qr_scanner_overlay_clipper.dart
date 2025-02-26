import 'package:flutter/material.dart';

class QrScannerOverlayClipper extends CustomClipper<Path> {
  final double innerWidth;
  final double innerHeight;
  final double radius;

  QrScannerOverlayClipper({
    this.innerWidth = 0,
    this.innerHeight = 0,
    this.radius = 23,
  });

  @override
  Path getClip(Size size) {
    final innerLeftTop1 = Offset(
      size.width / 2 - innerWidth / 2,
      size.height / 2 - innerHeight / 2 + radius,
    );
    final innerLeftTop2 = Offset(
      size.width / 2 - innerWidth / 2 + radius,
      size.height / 2 - innerHeight / 2,
    );
    final innerRightTop1 = Offset(
      size.width / 2 + innerWidth / 2 - radius,
      size.height / 2 - innerHeight / 2,
    );
    final innerRightTop2 = Offset(
      size.width / 2 + innerWidth / 2,
      size.height / 2 - innerHeight / 2 + radius,
    );
    final innerRightBottom1 = Offset(
      size.width / 2 + innerWidth / 2,
      size.height / 2 + innerHeight / 2 - radius,
    );
    final innerRightBottom2 = Offset(
      size.width / 2 + innerWidth / 2 - radius,
      size.height / 2 + innerHeight / 2,
    );
    final innerLeftBottom1 = Offset(
      size.width / 2 - innerWidth / 2 + radius,
      size.height / 2 + innerHeight / 2,
    );
    final innerLeftBottom2 = Offset(
      size.width / 2 - innerWidth / 2,
      size.height / 2 + innerHeight / 2 - radius,
    );

    Path path =
        Path()
          ..moveTo(innerRightTop1.dx, innerRightTop1.dy)
          ..arcToPoint(innerRightTop2, radius: Radius.circular(radius))
          ..lineTo(innerRightBottom1.dx, innerRightBottom1.dy)
          ..arcToPoint(innerRightBottom2, radius: Radius.circular(radius))
          ..lineTo(innerLeftBottom1.dx, innerLeftBottom1.dy)
          ..arcToPoint(innerLeftBottom2, radius: Radius.circular(radius))
          ..lineTo(innerLeftTop1.dx, innerLeftTop1.dy)
          ..arcToPoint(innerLeftTop2, radius: Radius.circular(radius))
          ..close();

    Path path2 =
        Path()
          ..addRect(
            Rect.fromPoints(
              const Offset(0, 0),
              Offset(size.width, size.height),
            ),
          )
          ..addPath(path, Offset.zero)
          ..close();

    path2.fillType = PathFillType.evenOdd;

    return path2;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
