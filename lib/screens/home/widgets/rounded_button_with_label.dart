import 'package:flutter/material.dart';

import 'package:sideswap/screens/home/widgets/rounded_button.dart';

class RoundedButtonWithLabel extends StatelessWidget {
  const RoundedButtonWithLabel({
    super.key,
    this.onTap,
    this.label,
    this.child,
    this.buttonBackground,
    this.iconWidth = 72,
    this.iconHeight = 72,
    this.labelPadding = const EdgeInsets.only(top: 12),
    this.labelTextStyle = const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    this.iconBorderRadius,
  });
  final VoidCallback? onTap;
  final String? label;
  final Widget? child;
  final Color? buttonBackground;
  final double? iconWidth;
  final double? iconHeight;
  final EdgeInsetsGeometry labelPadding;
  final TextStyle labelTextStyle;
  final BorderRadius? iconBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedButton(
          width: iconWidth,
          height: iconHeight,
          onTap: onTap,
          color: buttonBackground,
          borderRadius: iconBorderRadius,
          child: child,
        ),
        Padding(
          padding: labelPadding,
          child: Text(label ?? '', style: labelTextStyle),
        ),
      ],
    );
  }
}
