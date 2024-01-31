import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    super.key,
    this.color,
    this.text,
    this.child,
    this.textColor,
    this.onPressed,
    this.textStyle,
  });

  final Color? color;
  final Color? textColor;
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: color,
        ),
        child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: EdgeInsets.zero,
            ),
            child: switch (child) {
              Widget child => child,
              _ => Center(
                  child: Text(
                    text ?? '',
                    maxLines: 1,
                    softWrap: false,
                    style: textStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500, color: textColor),
                  ),
                )
            }),
      ),
    );
  }
}
