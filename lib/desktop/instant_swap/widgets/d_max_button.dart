import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';

class DMaxButton extends ConsumerWidget {
  final double? width;
  final double? height;
  final void Function()? onPressed;
  final DMaxButtonStyle? style;

  const DMaxButton({
    this.width,
    this.height,
    this.onPressed,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultButtonStyle =
        style?.buttonStyle ??
        Theme.of(context).extension<DMaxButtonStyle>()?.buttonStyle;

    return DButton(
      onPressed: onPressed,
      style: defaultButtonStyle,
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: Text('MAX'.tr())),
      ),
    );
  }
}

class DMaxButtonStyle extends ThemeExtension<DMaxButtonStyle> {
  const DMaxButtonStyle({this.buttonStyle});

  final DButtonStyle? buttonStyle;

  @override
  DMaxButtonStyle lerp(ThemeExtension<DMaxButtonStyle> other, double t) {
    if (other is! DMaxButtonStyle) {
      return this;
    }

    return DMaxButtonStyle(
      buttonStyle: DButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }

  @override
  DMaxButtonStyle copyWith({DButtonStyle? buttonStyle}) =>
      DMaxButtonStyle(buttonStyle: buttonStyle ?? this.buttonStyle);
}
