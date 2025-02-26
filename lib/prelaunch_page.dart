import 'dart:math' as math show sin, pi;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/screens/flavor_config.dart';

class PreLaunchPage extends StatelessWidget {
  const PreLaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (FlavorConfig.isDesktop) {
      true => const SideSwapScaffoldPage(content: PreLauchAnimation()),
      _ => const SideSwapScaffold(body: SafeArea(child: PreLauchAnimation())),
    };
  }
}

class PreLauchAnimation extends HookConsumerWidget {
  const PreLauchAnimation({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    final delays = useMemoized(() => [.0, .25, .5, .75, 1.0]);
    const counter = 5;

    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: FlavorConfig.isDesktop ? 200 : 180),
            child: Center(
              child: SvgPicture.asset(
                'assets/logo.svg',
                width: 110,
                height: 108,
              ),
            ),
          ),
        ),
        FlavorConfig.isDesktop
            ? Container()
            : Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'Wallet loading...'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 241),
            child: SizedBox(
              width: 66,
              height: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...List<Widget>.generate(
                    counter,
                    (i) => FadeTransition(
                      opacity: DelayTween(
                        begin: 0.2,
                        end: 1.0,
                        delay: delays[i],
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
