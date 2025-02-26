import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class DBackgroundPanel extends StatelessWidget {
  const DBackgroundPanel({
    super.key,
    this.child,
    this.constraints = const BoxConstraints(minWidth: 512, minHeight: 469),
    this.decoration,
  });

  final Widget? child;
  final BoxConstraints? constraints;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration:
          decoration ??
          ShapeDecoration(
            color: SideSwapColors.chathamsBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      child: child,
    );
  }
}
