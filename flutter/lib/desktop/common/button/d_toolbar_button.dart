import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  bool get enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: ((context, states) {
        final child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: SizedBox(
            height: 34,
            child: Center(
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: name.isNotEmpty
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: states.isHovering
                                ? const Color(0xFF00C5FF)
                                : Colors.white,
                          )
                        : null,
                    child: Center(
                      child: SvgPicture.asset(
                        icon,
                        width: name.isNotEmpty ? 8 : 18,
                        height: name.isNotEmpty ? 8 : 18,
                        color: name.isNotEmpty
                            ? const Color(0xFF021C36)
                            : states.isHovering
                                ? const Color(0xFF00C5FF)
                                : Colors.white,
                      ),
                    ),
                  ),
                  if (name.isNotEmpty) const SizedBox(width: 6),
                  if (name.isNotEmpty)
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        color: states.isHovering
                            ? const Color(0xFF00C5FF)
                            : Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );

        final background = Container(
          color: states.isHovering
              ? states.isPressing
                  ? Colors.transparent.toAccentColor().darker
                  : Colors.transparent.toAccentColor().dark
              : Colors.transparent,
          child: child,
        );

        final focusBorder = DFocusBorder(
          focused: states.isFocused,
          child: background,
        );

        return Semantics(
          container: true,
          button: true,
          enabled: enabled,
          child: focusBorder,
        );
      }),
      onPressed: onPressed,
    );
  }
}
