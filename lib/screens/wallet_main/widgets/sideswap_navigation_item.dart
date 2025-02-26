import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideSwapNavigationItemIcon extends StatelessWidget {
  const SideSwapNavigationItemIcon(this.assetName, {super.key});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: SvgPicture.asset(assetName, width: 32),
    );
  }
}
