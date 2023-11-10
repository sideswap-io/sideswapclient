import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class TopSwapButtons extends StatelessWidget {
  const TopSwapButtons({
    super.key,
    required this.onPegInPressed,
    required this.onPegOutPressed,
  });

  final _colorToggleBackgroundMobile = const Color(0xFF043857);
  final _colorToggleBackgroundDesktop = const Color(0xFF062D44);

  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = const Color(0xFF709EBA);
  final VoidCallback onPegInPressed;
  final VoidCallback onPegOutPressed;

  @override
  Widget build(BuildContext context) {
    final colorToggleBackground = FlavorConfig.isDesktop
        ? _colorToggleBackgroundDesktop
        : _colorToggleBackgroundMobile;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: colorToggleBackground,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final swapPegOut =
              ref.watch(swapProvider).swapType() == SwapType.pegOut;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SwapButton(
                  color: !swapPegOut ? _colorToggleOn : colorToggleBackground,
                  text: 'Peg-In'.tr(),
                  textColor:
                      !swapPegOut ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onPegInPressed,
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: swapPegOut ? _colorToggleOn : colorToggleBackground,
                  text: 'Peg-Out'.tr(),
                  textColor:
                      swapPegOut ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onPegOutPressed,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
