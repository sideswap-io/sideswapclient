import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DErrorIcon extends StatelessWidget {
  const DErrorIcon({
    Key? key,
    this.width = 66,
    this.height = 66,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF7878),
          style: BorderStyle.solid,
          width: 3,
        ),
        color: const Color(0xFF135579),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/error.svg',
          width: 20,
          height: 20,
          color: const Color(0xFFFF7878),
        ),
      ),
    );
  }
}
