import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';

class ChartButton extends StatelessWidget {
  const ChartButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/chart.svg',
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Chart'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
      onPressed: onPressed,
    );
  }
}
