import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/wallet.dart';

class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({
    this.onPressed,
    this.style,
    this.icon = Icons.close,
    super.key,
  });

  final void Function()? onPressed;
  final CustomBackButtonStyle? style;
  final IconData? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultStyle =
        style ?? Theme.of(context).extension<CustomBackButtonStyle>();

    return SizedBox(
      width: defaultStyle?.width ?? 48,
      height: defaultStyle?.height ?? 48,
      child: IconButton(
        iconSize: defaultStyle?.iconSize ?? 24,
        onPressed:
            onPressed ??
            () {
              FocusManager.instance.primaryFocus?.unfocus();
              ref.read(walletProvider).goBack();
            },
        icon: Icon(
          icon,
          size: defaultStyle?.iconSize ?? 24,
          color: defaultStyle?.color ?? SideSwapColors.freshAir,
        ),
      ),
    );
  }
}

class CustomBackButtonStyle extends ThemeExtension<CustomBackButtonStyle> {
  final double? width;
  final double? height;
  final double? iconSize;
  final Color? color;

  CustomBackButtonStyle({
    this.width = 48,
    this.height = 48,
    this.iconSize = 24,
    this.color = SideSwapColors.freshAir,
  });

  CustomBackButtonStyle.standard({
    double width = 48,
    double height = 48,
    double iconSize = 24,
    Color? color,
  }) : this(width: width, height: height, iconSize: iconSize, color: color);

  CustomBackButtonStyle.small({
    double width = 40,
    double height = 40,
    double iconSize = 20,
    Color? color,
  }) : this(width: width, height: height, iconSize: iconSize, color: color);

  CustomBackButtonStyle.large({
    double width = 56,
    double height = 56,
    double iconSize = 24,
    Color? color,
  }) : this(width: width, height: height, iconSize: iconSize, color: color);

  @override
  CustomBackButtonStyle copyWith({
    double? width,
    double? height,
    double? iconSize,
    Color? color,
  }) {
    return CustomBackButtonStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      color: color ?? this.color,
    );
  }

  @override
  CustomBackButtonStyle lerp(
    covariant ThemeExtension<CustomBackButtonStyle>? other,
    double t,
  ) {
    if (other is! CustomBackButtonStyle) {
      return this;
    }

    return CustomBackButtonStyle(
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      color: Color.lerp(color, other.color, t),
    );
  }
}
