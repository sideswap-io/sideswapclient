import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/screens/flavor_config.dart';

class AssetTickerButton extends HookConsumerWidget {
  const AssetTickerButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (FlavorConfig.isDesktop) {
      true => () {
        final buttonStyle =
            ref.watch(desktopAppThemeNotifierProvider).buttonWithoutBorderStyle;

        return DButton(style: buttonStyle, onPressed: onPressed, child: child);
      },
      _ => () {
        final style =
            Theme.of(
              context,
            ).extension<AssetTickerButtonMobileStyle>()?.style ??
            ButtonStyle();
        return TextButton(onPressed: onPressed, style: style, child: child);
      },
    }();
  }
}

class AssetTickerButtonMobileStyle
    extends ThemeExtension<AssetTickerButtonMobileStyle> {
  final ButtonStyle? style;

  AssetTickerButtonMobileStyle({this.style});

  @override
  AssetTickerButtonMobileStyle copyWith({ButtonStyle? style}) {
    return AssetTickerButtonMobileStyle(style: style ?? this.style);
  }

  @override
  AssetTickerButtonMobileStyle lerp(
    covariant ThemeExtension<AssetTickerButtonMobileStyle>? other,
    double t,
  ) {
    if (other is! AssetTickerButtonMobileStyle) {
      return this;
    }

    return AssetTickerButtonMobileStyle(
      style: ButtonStyle.lerp(style, other.style, t),
    );
  }
}
