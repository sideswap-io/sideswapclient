import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/screen_utils.dart';

class SideSwapNavigationItemIcon extends StatelessWidget {
  const SideSwapNavigationItemIcon(this.assetName, {Key? key, this.height})
      : super(key: key);

  final String assetName;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32.w,
      height: 30.h,
      child: SvgPicture.asset(
        assetName,
        width: height,
      ),
    );
  }
}
