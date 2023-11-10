import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';

class WorkingOrderButton extends StatelessWidget {
  const WorkingOrderButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            icon,
            width: 14,
            height: 14,
            colorFilter: ColorFilter.mode(
                states.isHovering
                    ? Colors.white
                    : SideSwapColors.brightTurquoise,
                BlendMode.srcIn),
          ),
        );
      },
      onPressed: onPressed,
    );
  }
}
