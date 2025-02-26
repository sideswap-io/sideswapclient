import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/wallet.dart';

enum CustomBackButtonType { backArrow, close }

class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({
    this.onPressed,
    this.buttonType = CustomBackButtonType.backArrow,
    this.width = 24,
    this.height = 24,
    this.color = SideSwapColors.freshAir,
    super.key,
  });

  final void Function()? onPressed;
  final CustomBackButtonType buttonType;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      height: height,
      child: IconButton(
        onPressed:
            onPressed ??
            () {
              FocusManager.instance.primaryFocus?.unfocus();
              ref.read(walletProvider).goBack();
            },
        icon: switch (buttonType) {
          CustomBackButtonType.backArrow => SvgPicture.asset(
            'assets/back_arrow.svg',
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          CustomBackButtonType.close => SvgPicture.asset(
            'assets/close.svg',
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        },
      ),
    );
  }
}
