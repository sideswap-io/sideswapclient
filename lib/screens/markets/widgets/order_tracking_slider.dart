import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:xrange/xrange.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_thumb_shape.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_track_shape.dart';

class OrderTrackingSlider extends StatelessWidget {
  const OrderTrackingSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.minPercent = -3,
    this.maxPercent = 3,
    this.asset,
    this.icon,
    this.price = '',
    this.dollarConversion = '',
    this.invertColors,
  });

  final double value;
  final void Function(double)? onChanged;
  final int minPercent;
  final int maxPercent;
  final Asset? asset;
  final Widget? icon;
  final String price;
  final String dollarConversion;
  final bool? invertColors;

  final trackingValueStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  final negativeColor = SideSwapColors.bitterSweet;
  final positiveColor = SideSwapColors.turquoise;
  final circleNegativeColor = const Color(0xFF3E475F);
  final circlePositiveColor = const Color(0xFF147385);

  @override
  Widget build(BuildContext context) {
    final ticker = asset!.ticker;

    final startColor = invertColors == true ? positiveColor : negativeColor;
    final endColor = invertColors == true ? negativeColor : positiveColor;
    final circleStartColor =
        invertColors == true ? circlePositiveColor : circleNegativeColor;
    final circleEndColor =
        invertColors == true ? circleNegativeColor : circlePositiveColor;

    return Container(
      height: 115,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF043857),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price per unit'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
                  ),
                ),
                if (dollarConversion.isNotEmpty) ...[
                  Text(
                    '≈ $dollarConversion',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF709EBA),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              height: 29,
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: icon,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          ticker,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: SideSwapColors.glacier,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 27,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: OrderTrackingSliderThumbShape(
                  minValue: minPercent.toDouble(),
                  maxValue: maxPercent.toDouble(),
                  negativeColor: startColor,
                  positiveColor: endColor,
                  circleNegativeColor: circleStartColor,
                  circlePositiveColor: circleEndColor,
                ),
                trackShape: OrderTrackingSliderTrackShape(
                  minValue: minPercent.toDouble(),
                  maxValue: maxPercent.toDouble(),
                  negativeColor: startColor,
                  positiveColor: endColor,
                ),
                trackHeight: 10,
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  return Slider(
                    min: minPercent.toDouble(),
                    max: maxPercent.toDouble(),
                    value: value,
                    onChanged: (value) {
                      final newMin = maxPercent.abs() - minPercent.abs();
                      final newMax =
                          ((maxPercent.abs() + minPercent.abs()) * 100);
                      final index = convertToNewRange(
                        value: value,
                        minValue: minPercent.toDouble(),
                        maxValue: maxPercent.toDouble(),
                        newMin: newMin.toDouble(),
                        newMax: newMax.toDouble(),
                      ).toInt();

                      final range =
                          NumRange.closed(minPercent * 100, maxPercent * 100);
                      final rangeValue = range.values(step: 1).toList()[index];
                      final newValue = rangeValue / 100.0;

                      ref
                          .read(orderPriceFieldSliderValueProvider.notifier)
                          .setValue(newValue);
                      onChanged?.call(newValue);
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$minPercent%',
                  style: trackingValueStyle.copyWith(
                    color: startColor,
                  ),
                ),
                Text(
                  '$value%',
                  style: trackingValueStyle,
                ),
                Text(
                  '$maxPercent%',
                  style: trackingValueStyle.copyWith(
                    color: endColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
