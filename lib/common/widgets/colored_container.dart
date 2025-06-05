import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';

class ColoredContainer extends StatelessWidget {
  const ColoredContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.theme,
  });

  final Widget? child;
  final double? width;
  final double? height;
  final ColoredContainerStyle? theme;

  @override
  Widget build(BuildContext context) {
    final containerTheme =
        theme ?? Theme.of(context).extension<ColoredContainerStyle>()!;
    final defaultTheme = ColoredContainerStyle(
      backgroundColor: SideSwapColors.navyBlue,
      borderColor: SideSwapColors.navyBlue,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      borderWidth: 1,
    );

    final borderWidth = containerTheme.borderWidth ?? defaultTheme.borderWidth!;
    final defaultPadding = containerTheme.padding ?? defaultTheme.padding!;
    final padding = defaultPadding.subtract(
      EdgeInsets.symmetric(horizontal: borderWidth, vertical: borderWidth),
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: containerTheme.borderColor ?? defaultTheme.borderColor!,
          width: borderWidth,
        ),
        color: containerTheme.backgroundColor ?? defaultTheme.backgroundColor,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
