import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwapArrowsButton extends StatelessWidget {
  const SwapArrowsButton({
    super.key,
    required this.radius,
    this.onTap,
    this.color = const Color(0xFF00C5FF),
  });

  final double radius;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkResponse(
        onTap: onTap,
        child: SizedBox(
          width: radius,
          height: radius,
          child: Center(
            child: SvgPicture.asset(
              'assets/swap_arrows.svg',
              width: 22,
              height: 22,
            ),
          ),
        ),
      ),
    );
  }
}
