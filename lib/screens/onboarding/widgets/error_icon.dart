import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class ErrorIcon extends StatelessWidget {
  const ErrorIcon({
    super.key,
    this.width = 66,
    this.height = 66,
    this.decoration,
    this.icon,
    this.iconColor = const Color(0xFFCAF3FF),
  });

  final double width;
  final double height;
  final Decoration? decoration;
  final Widget? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration:
          decoration ??
          BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: SideSwapColors.bitterSweet,
              style: BorderStyle.solid,
              width: 3,
            ),
            color: SideSwapColors.chathamsBlue,
          ),
      child: Center(
        child:
            icon ??
            SvgPicture.asset(
              'assets/close.svg',
              width: height / 2.35,
              height: width / 3.3,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
      ),
    );
  }
}
