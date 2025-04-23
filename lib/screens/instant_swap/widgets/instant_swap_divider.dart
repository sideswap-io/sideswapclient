import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/instant_swap/widgets/d_instant_swap_divider_button.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';

class InstantSwapDivider extends HookConsumerWidget {
  final Color? backgroundColor;
  final double radius;
  final double height;

  const InstantSwapDivider({
    this.height = 48,
    this.radius = 48,
    this.backgroundColor = SideSwapColors.blumine,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onPressedCallback = useCallback(() {
      final optionTopAsset = ref.read(exchangeTopAssetProvider);

      final optionBottomAsset = ref.read(exchangeBottomAssetProvider);

      optionTopAsset.match(
        () {},
        (topAsset) => optionBottomAsset.match(() {}, (bottomAsset) {
          ref.read(exchangeTopAssetProvider.notifier).setState(bottomAsset);
          ref.read(exchangeBottomAssetProvider.notifier).setState(topAsset);
        }),
      );
    });

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Column(
            children: [
              Spacer(),
              Flexible(
                child: Container(
                  height: height / 2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: backgroundColor,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                const SizedBox(width: 16),
                switch (FlavorConfig.isDesktop) {
                  true => DInstantSwapDividerButton(
                    radius: radius,
                    onPressed: onPressedCallback,
                  ),
                  _ => InstantSwapDividerButton(
                    radius: radius,
                    onPressed: onPressedCallback,
                  ),
                },
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, child) {
                    final optionQuoteIndexPrice = ref.watch(
                      exchangeIndexPriceProvider,
                    );

                    return optionQuoteIndexPrice.match(() => const SizedBox(), (
                      quoteIndexPrice,
                    ) {
                      final priceString = quoteIndexPrice.priceString();
                      if (priceString.isEmpty) {
                        return const SizedBox();
                      }

                      return RoundedTextLabel(text: priceString);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InstantSwapDividerButtonBody extends ConsumerWidget {
  const InstantSwapDividerButtonBody({this.radius = 48, super.key});

  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: radius,
      height: radius,
      child: Center(
        child: SvgPicture.asset(
          'assets/swap_arrows.svg',
          width: 22,
          height: 22,
        ),
      ),
    );
  }
}

class InstantSwapDividerButton extends ConsumerWidget {
  const InstantSwapDividerButton({
    this.radius = 48,
    this.onPressed,
    this.buttonStyle,
    super.key,
  });

  final void Function()? onPressed;
  final double radius;
  final InstantSwapDividerButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultButtonStyle =
        Theme.of(
          context,
        ).extension<InstantSwapDividerButtonStyle>()?.buttonStyle ??
        TextButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.zero,
          backgroundColor: SideSwapColors.brightTurquoise,
        );

    return TextButton(
      onPressed: onPressed,
      style: defaultButtonStyle,
      child: InstantSwapDividerButtonBody(radius: radius),
    );
  }
}

class InstantSwapDividerButtonStyle
    extends ThemeExtension<InstantSwapDividerButtonStyle> {
  final ButtonStyle? buttonStyle;

  InstantSwapDividerButtonStyle({this.buttonStyle});

  @override
  InstantSwapDividerButtonStyle copyWith({ButtonStyle? buttonStyle}) {
    return InstantSwapDividerButtonStyle(
      buttonStyle: buttonStyle ?? this.buttonStyle,
    );
  }

  @override
  InstantSwapDividerButtonStyle lerp(
    covariant ThemeExtension<InstantSwapDividerButtonStyle>? other,
    double t,
  ) {
    if (other is! InstantSwapDividerButtonStyle) {
      return this;
    }

    return InstantSwapDividerButtonStyle(
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }
}
