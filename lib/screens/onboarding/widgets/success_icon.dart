import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class SuccessIcon extends StatelessWidget {
  const SuccessIcon({
    super.key,
    this.width = 66,
    this.height = 66,
    this.decoration,
    this.icon,
  });

  final double width;
  final double height;
  final Decoration? decoration;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: decoration ??
          BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: SideSwapColors.brightTurquoise,
              style: BorderStyle.solid,
              width: 3,
            ),
            color: SideSwapColors.chathamsBlue,
          ),
      child: Center(
        child: icon ??
            SvgPicture.asset(
              'assets/success.svg',
              width: 28,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFCAF3FF), BlendMode.srcIn),
            ),
      ),
    );
  }
}
