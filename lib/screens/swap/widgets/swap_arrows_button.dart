import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/screen_utils.dart';

class SwapArrowsButton extends StatelessWidget {
  const SwapArrowsButton({
    Key key,
    @required this.radius,
    this.onTap,
    this.color = const Color(0xFF00C5FF),
  }) : super(key: key);

  final double radius;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkResponse(
        onTap: onTap,
        child: Container(
          width: radius,
          height: radius,
          child: Center(
            child: SvgPicture.asset(
              'assets/swap_arrows.svg',
              width: 22.w,
              height: 22.w,
            ),
          ),
        ),
      ),
    );
  }
}
