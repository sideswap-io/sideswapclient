import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedDropdownArrow extends StatelessWidget {
  const AnimatedDropdownArrow({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 150),
    this.width,
    this.height,
    this.initFrom = 0,
    this.iconColor = Colors.white,
  });

  final double target;
  final Duration? duration;
  final double? width;
  final double? height;
  final double? initFrom;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
          'assets/arrow_down.svg',
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        )
        .animate(
          target: target,
          // Not redundant with target, and not dead: Animate starts its
          // internal controller at 0, then animates to target. A caller that
          // rests at target 1 would therefore turn the arrow half a circle
          // every time it is mounted. This callback puts the controller at
          // initFrom first, so the distance to travel is zero.
          // test/widgets/animated_dropdown_arrow_test.dart holds this.
          onInit: (controller) {
            controller.forward(from: initFrom);
          },
        )
        .rotate(begin: 0, end: -0.5, duration: duration);
  }
}
