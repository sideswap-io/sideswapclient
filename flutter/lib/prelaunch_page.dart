import 'dart:math' as math show sin, pi;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/initialize_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';

class PreLaunchPage extends ConsumerStatefulWidget {
  const PreLaunchPage({
    super.key,
  });

  @override
  PreLaunchPageState createState() => PreLaunchPageState();
}

class PreLaunchPageState extends ConsumerState<PreLaunchPage> {
  @override
  void initState() {
    super.initState();

    // initialize app
    ref.read(initializeAppProvider);
  }

  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isDesktop) {
      return const SideSwapScaffoldPage(
        content: PreLaunchPageBody(),
      );
    }

    return const SideSwapScaffold(
      body: SafeArea(
        child: PreLaunchPageBody(),
      ),
    );
  }
}

class PreLaunchPageBody extends StatefulWidget {
  const PreLaunchPageBody({super.key});

  @override
  State<PreLaunchPageBody> createState() => _PreLaunchPageBodyState();
}

class _PreLaunchPageBodyState extends State<PreLaunchPageBody>
    with SingleTickerProviderStateMixin {
  final _counter = 5;
  final _color = const Color(0xFF00C5FF);
  final List<double> delays = [.0, .25, .5, .75, 1.0];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..addListener(() => setState(() {}))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    _counter,
                    (i) => FadeTransition(
                      opacity:
                          DelayTween(begin: 0.2, end: 1.0, delay: delays[i])
                              .animate(_controller),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _color,
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
