import 'dart:math' as math show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sideswap/common/sideswap_colors.dart';

/// One entry per dot, in row order: how far into the cycle that dot lags.
const List<double> _dotDelays = [0.0, 0.25, 0.5, 0.75, 1.0];

/// The app's "waiting on the client" mark: five turquoise dots pulsing out of
/// phase with one another.
///
/// It owns its own geometry and timing and nothing positional -- no padding, no
/// alignment. `PreLaunchPage` and `WalletLocked` lay out differently and each
/// places this widget itself; no shared constant can express both offsets.
class PulsingDots extends HookWidget {
  const PulsingDots({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    return SizedBox(
      width: 66,
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final delay in _dotDelays)
            FadeTransition(
              opacity: DelayTween(
                begin: 0.2,
                end: 1.0,
                delay: delay,
              ).animate(controller),
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
