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
      horizontalPadding: 12,
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: containerTheme.borderColor ?? defaultTheme.borderColor!,
        ),
        color: containerTheme.backgroundColor ?? defaultTheme.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              containerTheme.horizontalPadding ??
              defaultTheme.horizontalPadding!,
          vertical: 5,
        ),
        child: child,
      ),
    );
  }
}
