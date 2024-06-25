import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class PasswordIconButton extends StatelessWidget {
  const PasswordIconButton({
    super.key,
    this.onPressed,
    this.enabled = true,
    this.obscureText = false,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        obscureText ? SideSwapColors.glacier : SideSwapColors.brightTurquoise;

    return IconButton(
      onPressed: enabled ? onPressed : null,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      icon: Icon(
        obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: iconColor,
        size: 22,
      ),
    );
  }
}
