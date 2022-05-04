import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';

class DPinIconButton extends HookWidget {
  const DPinIconButton(
      {Key? key, this.onPressed, this.enabled = true, this.obscureText = false})
      : super(key: key);

  final VoidCallback? onPressed;
  final bool enabled;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        obscureText ? const Color(0xFF84ADC6) : const Color(0xFF00C5FF);

    final hoover = useState(false);
    final tapDown = useState(false);

    return FocusableActionDetector(
      enabled: enabled,
      onShowHoverHighlight: (v) {
        if (v) {
          hoover.value = true;
        } else {
          hoover.value = false;
          tapDown.value = false;
        }
      },
      child: DIconButton(
        onPressed: onPressed,
        onTapDown: () {
          tapDown.value = true;
        },
        cursor: SystemMouseCursors.basic,
        style: DButtonStyle(
          backgroundColor: ButtonState.all(Colors.transparent),
        ),
        icon: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: hoover.value
              ? tapDown.value
                  ? iconColor.toAccentColor().darkest
                  : iconColor.toAccentColor().darker
              : iconColor,
          size: 22,
        ),
      ),
    );
  }
}
