import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MaxButton extends ConsumerWidget {
  final double? width;
  final double? height;
  final void Function()? onPressed;
  final MaxButtonStyle? style;

  const MaxButton({
    this.width,
    this.height,
    required this.onPressed,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultButtonStyle =
        style?.buttonStyle ??
        Theme.of(context).extension<MaxButtonStyle>()?.buttonStyle;

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed ?? () {},
        style: defaultButtonStyle,
        child: Text('MAX'.tr()),
      ),
    );
  }
}

class MaxButtonStyle extends ThemeExtension<MaxButtonStyle> {
  const MaxButtonStyle({this.buttonStyle});

  final ButtonStyle? buttonStyle;

  @override
  MaxButtonStyle lerp(ThemeExtension<MaxButtonStyle> other, double t) {
    if (other is! MaxButtonStyle) {
      return this;
    }

    return MaxButtonStyle(
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }

  @override
  MaxButtonStyle copyWith({ButtonStyle? buttonStyle}) =>
      MaxButtonStyle(buttonStyle: buttonStyle ?? this.buttonStyle);
}
