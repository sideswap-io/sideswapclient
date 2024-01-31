import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/theme.dart';

class DCustomTextBigButton extends StatelessWidget {
  const DCustomTextBigButton({
    super.key,
    this.width,
    this.height,
    required this.onPressed,
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.style,
    this.padding,
  });

  final double? width;
  final double? height;
  final void Function()? onPressed;
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;
  final DButtonStyle? style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final defaultButtonStyle = ref
            .watch(desktopAppThemeNotifierProvider)
            .buttonThemeData
            .defaultButtonStyle;
        return DButton(
          onPressed: onPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          style: style ?? defaultButtonStyle,
          child: IntrinsicWidth(
            child: SizedBox(
              height: height ?? 49,
              width: width,
              child: Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
                child: Center(child: child),
              ),
            ),
          ),
        );
      },
    );
  }
}
