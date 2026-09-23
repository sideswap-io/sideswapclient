import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/widgets/pulsing_dots.dart';

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

class PreLauchAnimation extends StatelessWidget {
  const PreLauchAnimation({super.key});

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
        const Center(
          // The offset stays here, not in PulsingDots: this screen is a plain
          // top-down column and WalletLocked stacks a shrinking gap, the logo
          // and a second shrinking gap, so the two reach the same y through
          // different arithmetic.
          child: Padding(
            padding: EdgeInsets.only(top: 241),
            child: PulsingDots(),
          ),
        ),
      ],
    );
  }
}
