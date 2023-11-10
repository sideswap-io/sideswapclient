import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class DErrorIcon extends StatelessWidget {
  const DErrorIcon({
    super.key,
    this.width = 60,
    this.height = 60,
  });

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
          color: SideSwapColors.bitterSweet,
          style: BorderStyle.solid,
          width: 3,
        ),
        color: SideSwapColors.chathamsBlue,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/error.svg',
          width: 23,
          height: 23,
          colorFilter: const ColorFilter.mode(
              SideSwapColors.bitterSweet, BlendMode.srcIn),
        ),
      ),
    );
  }
}
