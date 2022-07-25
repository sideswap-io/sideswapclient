import 'package:flutter/material.dart';

import 'package:sideswap/screens/home/widgets/rounded_button.dart';

class RoundedButtonWithLabel extends StatelessWidget {
  const RoundedButtonWithLabel({
    super.key,
    this.onTap,
    this.label,
    this.child,
    this.buttonBackground,
  });
  final VoidCallback? onTap;
  final String? label;
  final Widget? child;
  final Color? buttonBackground;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedButton(
          width: 72,
          heigh: 72,
          onTap: onTap,
          color: buttonBackground,
          child: child,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            label ?? '',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
