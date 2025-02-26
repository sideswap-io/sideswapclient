import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';

class DCustomButton extends StatelessWidget {
  const DCustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.focusNode,
    this.autofocus = false,
    this.isFilled = false,
  });

  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final buttonThemes =
            ref.watch(desktopAppThemeNotifierProvider).buttonThemeData;
        final style =
            isFilled
                ? buttonThemes.filledButtonStyle
                : buttonThemes.defaultButtonStyle;
        return SizedBox(
          width: width,
          height: height,
          child: DButton(
            onPressed: onPressed,
            focusNode: focusNode,
            autofocus: autofocus,
            style: style,
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
