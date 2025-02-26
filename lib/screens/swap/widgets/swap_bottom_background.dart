import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class SwapBottomBackground extends StatelessWidget {
  const SwapBottomBackground({super.key, required this.middle});

  final double middle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: middle),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SideSwapColors.blumine,
        ),
      ),
    );
  }
}
