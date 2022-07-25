import 'package:flutter/material.dart';

class CustomBigButton extends StatelessWidget {
  const CustomBigButton({
    super.key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.enabled = true,
    this.textStyle,
    this.buttonStyle,
    this.textColor,
    OutlinedBorder? shape,
    this.side,
    this.child,
  }) : shape = shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            );

  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool enabled;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;
  final Color? textColor;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 60,
      height: height ?? 54,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: buttonStyle ??
            TextButton.styleFrom(
              padding: EdgeInsets.zero,
              primary: enabled
                  ? textColor ?? Colors.white
                  : textColor?.withOpacity(0.5) ??
                      Colors.white.withOpacity(0.5),
              backgroundColor: enabled
                  ? backgroundColor ?? const Color(0xFF2A6D92)
                  : backgroundColor == Colors.transparent
                      ? Colors.transparent
                      : backgroundColor?.withOpacity(0.5) ??
                          const Color(0xFF2A6D92).withOpacity(0.5),
              shape: shape,
              side: side,
            ),
        child: child != null
            ? Opacity(
                opacity: enabled ? 1.0 : 0.5,
                child: child,
              )
            : Text(
                text ?? '',
                overflow: TextOverflow.fade,
                style: textStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
              ),
      ),
    );
  }
}
