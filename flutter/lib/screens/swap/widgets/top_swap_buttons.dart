import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class TopSwapButtons extends StatelessWidget {
  const TopSwapButtons({
    super.key,
    required this.onSwapPressed,
    required this.onPegPressed,
    required this.isDesktop,
  });

  final _colorToggleBackgroundMobile = const Color(0xFF043857);
  final _colorToggleBackgroundDesktop = const Color(0xFF062D44);

  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = const Color(0xFF709EBA);
  final VoidCallback onSwapPressed;
  final VoidCallback onPegPressed;

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final colorToggleBackground = isDesktop
        ? _colorToggleBackgroundDesktop
        : _colorToggleBackgroundMobile;
    return Container(
      width: double.maxFinite, //286.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: colorToggleBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final swapPeg = ref.watch(swapProvider.select((p) => p.swapPeg));
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SwapButton(
                  color: !swapPeg ? _colorToggleOn : colorToggleBackground,
                  text: 'Swap'.tr(),
                  textColor:
                      !swapPeg ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onSwapPressed,
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: swapPeg ? _colorToggleOn : colorToggleBackground,
                  text: 'Peg-In/Out'.tr(),
                  textColor: swapPeg ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onPegPressed,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
