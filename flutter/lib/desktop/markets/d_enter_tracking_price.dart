import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_thumb_shape.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_track_shape.dart';

class DEnterTrackingPrice extends StatelessWidget {
  const DEnterTrackingPrice({
    super.key,
    required this.trackingToggled,
    required this.trackingValue,
    required this.invertColors,
    required this.onTrackingChanged,
    required this.onTrackingToggle,
  });

  final bool trackingToggled;
  final double trackingValue;
  final bool invertColors;
  final ValueChanged<double> onTrackingChanged;
  final ValueChanged<bool>? onTrackingToggle;

  @override
  Widget build(BuildContext context) {
    const negativeColor = SideSwapColors.bitterSweet;
    const positiveColor = SideSwapColors.turquoise;
    const circleNegativeColor = Color(0xFF3E475F);
    const circlePositiveColor = Color(0xFF147385);

    const maxPercent = 1;
    const minPercent = -maxPercent;
    final startColor = invertColors ? positiveColor : negativeColor;
    final endColor = invertColors ? negativeColor : positiveColor;
    final circleStartColor =
        invertColors ? circlePositiveColor : circleNegativeColor;
    final circleEndColor =
        invertColors ? circleNegativeColor : circlePositiveColor;
    const percentTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    const minPercentStr = '$minPercent%';
    const maxPercentStr = '+$maxPercent%';
    final valueStr = '${trackingValue > 0 ? '+' : ''}$trackingValue%';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: SideSwapColors.chathamsBlue,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Track index price'.tr(),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
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
                activeColor: SideSwapColors.brightTurquoise,
                inactiveColor: const Color(0xFF0B4160),
                toggleColor: Colors.white,
              ),
            ],
          ),
          if (trackingToggled)
            Column(
              children: [
                const SizedBox(height: 4),
                SizedBox(
                  height: 22,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: OrderTrackingSliderThumbShape(
                        minValue: minPercent.toDouble(),
                        maxValue: maxPercent.toDouble(),
                        negativeColor: startColor,
                        positiveColor: endColor,
                        circleNegativeColor: circleStartColor,
                        circlePositiveColor: circleEndColor,
                        customRadius: 10,
                        stokeRatio: 0.3,
                      ),
                      trackShape: OrderTrackingSliderTrackShape(
                        minValue: minPercent.toDouble(),
                        maxValue: maxPercent.toDouble(),
                        negativeColor: startColor,
                        positiveColor: endColor,
                        trackColor: SideSwapColors.navyBlue,
                      ),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      min: minPercent.toDouble(),
                      max: maxPercent.toDouble(),
                      value: trackingValue,
                      onChanged: (value) {
                        onTrackingChanged(roundTrackerValue(value));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 8, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        minPercentStr,
                        style: percentTextStyle
                            .merge(TextStyle(color: startColor)),
                      ),
                      Text(
                        valueStr,
                        style: percentTextStyle,
                      ),
                      Text(
                        maxPercentStr,
                        style:
                            percentTextStyle.merge(TextStyle(color: endColor)),
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
