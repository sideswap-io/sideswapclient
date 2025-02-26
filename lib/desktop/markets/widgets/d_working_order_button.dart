import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';

class DWorkingOrderButton extends ConsumerWidget {
  const DWorkingOrderButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(desktopAppThemeNotifierProvider).buttonWithoutBorderStyle;

    return DButton(
      style: buttonStyle?.merge(
        DButtonStyle(
          shape: ButtonState.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(width: 24, height: 24, child: icon),
    );
  }
}
