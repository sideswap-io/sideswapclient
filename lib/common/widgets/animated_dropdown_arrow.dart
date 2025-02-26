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
          onInit: (controller) {
            controller.forward(from: initFrom);
          },
        )
        .rotate(begin: 0, end: -0.5, duration: duration);
  }
}
