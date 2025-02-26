import 'package:flutter/material.dart';

class SideSwapChip extends StatelessWidget {
  const SideSwapChip({
    super.key,
    this.width,
    this.height,
    this.decoration,
    this.margin,
    this.padding,
    this.textStyle,
    this.text = '',
  });

  final double? width;
  final double? height;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration:
          decoration ??
          ShapeDecoration(
            color: const Color(0x664893BC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
