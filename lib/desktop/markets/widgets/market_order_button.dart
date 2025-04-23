import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/screens/flavor_config.dart';

class MarketOrderButton extends ConsumerWidget {
  const MarketOrderButton({
    super.key,
    required this.isSell,
    this.onPressed,
    this.text,
    this.height = 54,
  });

  final bool isSell;
  final VoidCallback? onPressed;
  final String? text;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textDescription = text ?? 'Continue'.tr().toUpperCase();
    final color =
        isSell
            ? Theme.of(context).extension<MarketColorsStyle>()!.sellColor
            : Theme.of(context).extension<MarketColorsStyle>()!.buyColor;

    final isMobile = !FlavorConfig.isDesktop;

    return Center(
      child: switch (isMobile) {
        true => CustomBigButton(
          width: double.infinity,
          height: height,
          text: textDescription,
          backgroundColor: SideSwapColors.brightTurquoise,
          onPressed: onPressed,
        ),
        _ => DCustomFilledBigButton(
          width: 344,
          height: height ?? 54,
          onPressed: onPressed,
          style: DButtonStyle(
            padding: ButtonState.all(EdgeInsets.zero),
            textStyle: ButtonState.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            backgroundColor: ButtonState.resolveWith((states) {
              if (states.isDisabled) {
                return color?.lerpWith(Colors.black, 0.3);
              }
              if (states.isPressing) {
                return color?.lerpWith(Colors.black, 0.2);
              }
              if (states.isHovering) {
                return color?.lerpWith(Colors.black, 0.1);
              }
              return color;
            }),
            foregroundColor: ButtonState.resolveWith((states) {
              if (states.isDisabled) {
                return Colors.white.lerpWith(Colors.black, 0.3);
              }
              return Colors.white;
            }),
            shape: ButtonState.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            border: ButtonState.resolveWith((states) {
              return const BorderSide(color: Colors.transparent, width: 1);
            }),
          ),
          child: Text(textDescription),
        ),
      },
    );
  }
}
