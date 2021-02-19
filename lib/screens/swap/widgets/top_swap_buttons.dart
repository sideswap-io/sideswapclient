import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class TopSwapButtons extends StatelessWidget {
  TopSwapButtons({
    Key key,
    this.onSwapPressed,
    this.onPegPressed,
  }) : super(key: key);

  final _colorToggleBackground = Color(0xFF043857);
  final _colorToggleOn = Color(0xFF1F7EB1);
  final _colorToggleTextOn = Color(0xFFFFFFFF);
  final _colorToggleTextOff = Color(0xFF709EBA);
  final VoidCallback onSwapPressed;
  final VoidCallback onPegPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite, //286.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: _colorToggleBackground,
        borderRadius: BorderRadius.all(Radius.circular(10.0.w)),
      ),
      child: Consumer(
        builder: (context, watch, child) {
          final _swapPeg = watch(swapProvider).swapPeg;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SwapButton(
                  color: !_swapPeg ? _colorToggleOn : _colorToggleBackground,
                  text: 'Swap'.tr(),
                  textColor:
                      !_swapPeg ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onSwapPressed,
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: _swapPeg ? _colorToggleOn : _colorToggleBackground,
                  text: 'Peg-In/Out'.tr(),
                  textColor:
                      _swapPeg ? _colorToggleTextOn : _colorToggleTextOff,
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
