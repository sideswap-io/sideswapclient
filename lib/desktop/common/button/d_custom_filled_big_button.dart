import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/theme.dart';

class DCustomFilledBigButton extends StatelessWidget {
  const DCustomFilledBigButton({
    super.key,
    this.width = 266,
    this.height = 49,
    required this.onPressed,
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.style,
  });

  final double width;
  final double height;
  final void Function()? onPressed;
  final Widget? child;
  final FocusNode? focusNode;
  final bool autofocus;
  final DButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, _) {
        final filledButtonStyle = ref
            .watch(desktopAppThemeNotifierProvider)
            .buttonThemeData
            .filledButtonStyle;
        return DButton(
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          style: style ?? filledButtonStyle,
          child: SizedBox(
            width: width,
            height: height,
            child: Center(child: child),
          ),
        );
      }),
    );
  }
}
