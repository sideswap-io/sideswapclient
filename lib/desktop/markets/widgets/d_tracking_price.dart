import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider_theme.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';

class DTrackingPriceStyle extends ThemeExtension<DTrackingPriceStyle> {
  final Color? negativeColor;
  final Color? positiveColor;
  final Color? circleNegativeColor;
  final Color? circlePositiveColor;
  final TextStyle? textStyle;
  final Color? switchActiveColor;
  final Color? switchInactiveColor;
  final Color? switchToggleColor;

  DTrackingPriceStyle({
    required this.negativeColor,
    required this.positiveColor,
    required this.circleNegativeColor,
    required this.circlePositiveColor,
    required this.textStyle,
    required this.switchActiveColor,
    required this.switchInactiveColor,
    required this.switchToggleColor,
  });

  @override
  DTrackingPriceStyle copyWith({
    Color? negativeColor,
    Color? positiveColor,
    Color? circleNegativeColor,
    Color? circlePositiveColor,
    TextStyle? textStyle,
    Decoration? decoration,
    Color? switchActiveColor,
    Color? switchInactiveColor,
    Color? switchToggleColor,
  }) {
    return DTrackingPriceStyle(
      negativeColor: negativeColor ?? this.negativeColor,
      positiveColor: positiveColor ?? this.positiveColor,
      circleNegativeColor: circleNegativeColor ?? this.circleNegativeColor,
      circlePositiveColor: circlePositiveColor ?? this.circlePositiveColor,
      textStyle: textStyle ?? this.textStyle,
      switchActiveColor: switchActiveColor ?? this.switchActiveColor,
      switchInactiveColor: switchInactiveColor ?? this.switchInactiveColor,
      switchToggleColor: switchToggleColor ?? this.switchToggleColor,
    );
  }

  @override
  DTrackingPriceStyle lerp(
    covariant ThemeExtension<DTrackingPriceStyle>? other,
    double t,
  ) {
    if (other is! DTrackingPriceStyle) {
      return this;
    }

    return DTrackingPriceStyle(
      negativeColor: Color.lerp(negativeColor, other.negativeColor, t),
      positiveColor: Color.lerp(positiveColor, other.positiveColor, t),
      circleNegativeColor: Color.lerp(
        circleNegativeColor,
        other.circleNegativeColor,
        t,
      ),
      circlePositiveColor: Color.lerp(
        circlePositiveColor,
        other.circlePositiveColor,
        t,
      ),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      switchActiveColor: Color.lerp(
        switchActiveColor,
        other.switchActiveColor,
        t,
      ),
      switchInactiveColor: Color.lerp(
        switchInactiveColor,
        other.switchInactiveColor,
        t,
      ),
      switchToggleColor: Color.lerp(
        switchToggleColor,
        other.switchToggleColor,
        t,
      ),
    );
  }
}

class DTrackingPrice extends ConsumerWidget {
  const DTrackingPrice({
    super.key,
    required this.trackingToggled,
    required this.trackingValue,
    required this.invertColors,
    required this.onTrackingChanged,
    required this.onTrackingToggle,
    this.maxPercent = 1,
    this.style,
  });

  final bool trackingToggled;
  final double trackingValue;
  final bool invertColors;
  final ValueChanged<double> onTrackingChanged;
  final ValueChanged<bool>? onTrackingToggle;
  final DTrackingPriceStyle? style;
  final double maxPercent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingPriceStyle =
        style ?? Theme.of(context).extension<DTrackingPriceStyle>();

    final defaultStyle = DTrackingPriceStyle(
      negativeColor:
          trackingPriceStyle?.negativeColor ?? SideSwapColors.bitterSweet,
      positiveColor:
          trackingPriceStyle?.positiveColor ?? SideSwapColors.turquoise,
      circleNegativeColor:
          trackingPriceStyle?.circleNegativeColor ?? SideSwapColors.policeBlue,
      circlePositiveColor:
          trackingPriceStyle?.circlePositiveColor ??
          SideSwapColors.metallicSeaweed,
      textStyle:
          trackingPriceStyle?.textStyle ??
          Theme.of(context).textTheme.titleSmall,
      switchActiveColor:
          trackingPriceStyle?.switchActiveColor ??
          SideSwapColors.brightTurquoise,
      switchInactiveColor:
          trackingPriceStyle?.switchInactiveColor ?? SideSwapColors.ataneoBlue,
      switchToggleColor: trackingPriceStyle?.switchToggleColor ?? Colors.white,
    );

    final startColor =
        invertColors
            ? defaultStyle.positiveColor!
            : defaultStyle.negativeColor!;
    final endColor =
        invertColors
            ? defaultStyle.negativeColor!
            : defaultStyle.positiveColor!;
    final circleStartColor =
        invertColors
            ? defaultStyle.circlePositiveColor!
            : defaultStyle.circleNegativeColor!;
    final circleEndColor =
        invertColors
            ? defaultStyle.circleNegativeColor!
            : defaultStyle.circlePositiveColor!;
    final textStyle = defaultStyle.textStyle!;

    final minPercent = -maxPercent;
    final minPercentStr = '$minPercent%';
    final maxPercentStr = '+$maxPercent%';
    final valueStr = '${trackingValue > 0 ? '+' : ''}$trackingValue%';

    final trackingRangeConverter = ref.watch(trackingRangeConverterProvider);

    return ColoredContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 34,
            child: Row(
              children: [
                Text('Track index price'.tr(), style: textStyle),
                const Spacer(),
                FlutterSwitch(
                  disabled: onTrackingToggle == null,
                  value: trackingToggled,
                  onToggle: (value) {
                    onTrackingToggle!(value);
                  },
                  width: 40,
                  height: 22,
                  toggleSize: 18,
                  padding: 2,
                  activeColor: defaultStyle.switchActiveColor!,
                  inactiveColor: defaultStyle.switchInactiveColor!,
                  toggleColor: defaultStyle.switchToggleColor!,
                ),
              ],
            ),
          ),
          if (trackingToggled)
            Column(
              children: [
                const SizedBox(height: 8),
                SideSwapSlider(
                  min: minPercent,
                  max: maxPercent,
                  value: trackingValue,
                  themeData: SideSwapSliderThemeData(
                    axisInteraction: SideSwapSliderAxisInteraction.center,
                    activeTrackColor: endColor,
                    inactiveTrackMarkColor: startColor,
                    activeTrackMarkColor: Colors.white,
                    inactiveTrackColor: SideSwapColors.navyBlue,
                    trackShape: SideSwapDefaultSliderTrackShape(
                      leftGradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          startColor,
                          SideSwapColors.navyBlue
                              .withValues(alpha: 0.24)
                              .withValues(alpha: .1),
                        ],
                      ),
                      rightGradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          SideSwapColors.navyBlue
                              .withValues(alpha: 0.24)
                              .withValues(alpha: .1),
                          endColor,
                        ],
                      ),
                    ),
                    hatchMarkShape: SideSwapDefaultSliderHatchMarkShape(
                      markHeight: 0,
                      padding: 4.0,
                    ),
                    thumbShape: SideSwapDefaultSliderThumbShape(
                      thumbColor:
                          trackingValue < 0
                              ? circleStartColor
                              : trackingValue > 0
                              ? circleEndColor
                              : SideSwapColors.prussianBlue,
                      frameColor: SideSwapColors.navyBlue,
                      leftColor: startColor,
                      rightColor: endColor,
                    ),
                  ),
                  marks: [
                    SideSwapSliderTrackMark(value: -5),
                    SideSwapSliderTrackMark(value: -4),
                    SideSwapSliderTrackMark(value: -3),
                    SideSwapSliderTrackMark(value: -2),
                    SideSwapSliderTrackMark(value: -1),
                    SideSwapSliderTrackMark(value: 0),
                    SideSwapSliderTrackMark(value: 1),
                    SideSwapSliderTrackMark(value: 2),
                    SideSwapSliderTrackMark(value: 3),
                    SideSwapSliderTrackMark(value: 4),
                    SideSwapSliderTrackMark(value: 5),
                  ],
                  onChanged: (value) {
                    final newValue = trackingRangeConverter
                        .toRangeWithPrecision(value);
                    onTrackingChanged(newValue);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 8,
                    bottom: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        minPercentStr,
                        style: textStyle.copyWith(color: startColor),
                      ),
                      Text(valueStr, style: textStyle),
                      Text(
                        maxPercentStr,
                        style: textStyle.copyWith(color: endColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
