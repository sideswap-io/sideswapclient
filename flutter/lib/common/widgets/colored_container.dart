import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class ColoredContainer extends StatelessWidget {
  const ColoredContainer({
    super.key,
    this.child,
    this.backgroundColor = SideSwapColors.navyBlue,
    this.borderColor = SideSwapColors.navyBlue,
    this.horizontalPadding = 12,
    this.width,
    this.height,
  });

  final Widget? child;
  final Color backgroundColor;
  final Color borderColor;
  final double horizontalPadding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: borderColor,
        ),
        color: backgroundColor,
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 5),
        child: child,
      ),
    );
  }
}
