import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/d_focus.dart';

class DTopToolbarButton extends StatelessWidget {
  const DTopToolbarButton({
    super.key,
    this.name = '',
    required this.icon,
    this.onPressed,
  });

  final String name;
  final String icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: ((context, states) {
        return Semantics(
          container: true,
          button: true,
          enabled: onPressed != null,
          child: DFocusBorder(
            focused: states.isFocused,
            child: Container(
              color: states.isHovering
                  ? states.isPressing
                      ? Colors.transparent.toAccentColor().darker
                      : Colors.transparent.toAccentColor().dark
                  : Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                child: SizedBox(
                  height: 34,
                  child: Center(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          icon,
                          width: 18,
                          height: 18,
                        ),
                        ...switch (name.isNotEmpty) {
                          true => [
                              const SizedBox(width: 6),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: states.isHovering
                                      ? SideSwapColors.brightTurquoise
                                      : Colors.white,
                                ),
                              ),
                            ],
                          _ => [const SizedBox()],
                        },
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      onPressed: onPressed,
    );
  }
}
