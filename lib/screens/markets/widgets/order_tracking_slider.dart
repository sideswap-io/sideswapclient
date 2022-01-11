import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xrange/xrange.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_thumb_shape.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_track_shape.dart';

class OrderTrackingSlider extends StatelessWidget {
  OrderTrackingSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.minPercent = -3,
    this.maxPercent = 3,
    this.asset,
    this.icon,
    this.price = '',
    this.dollarConversion = '',
    required this.invertColors,
  }) : super(key: key);

  final double value;
  final void Function(double)? onChanged;
  final int minPercent;
  final int maxPercent;
  final Asset? asset;
  final Image? icon;
  final String price;
  final String dollarConversion;
  final bool invertColors;

  final trackingValueStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  final negativeColor = const Color(0xFFFF7878);
  final positiveColor = const Color(0xFF2CCCBF);
  final circleNegativeColor = const Color(0xFF3E475F);
  final circlePositiveColor = const Color(0xFF147385);

  @override
  Widget build(BuildContext context) {
    final ticker = asset!.ticker;

    final startColor = invertColors ? positiveColor : negativeColor;
    final endColor = invertColors ? negativeColor : positiveColor;
    final circleStartColor =
        invertColors ? circlePositiveColor : circleNegativeColor;
    final circleEndColor =
        invertColors ? circleNegativeColor : circlePositiveColor;

    return Container(
      height: 143.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.r),
        color: const Color(0xFF043857),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 14.h, left: 16.w, right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF00C5FF),
                  ),
                ),
                if (dollarConversion.isNotEmpty) ...[
                  Text(
                    '≈ $dollarConversion',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF709EBA),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: SizedBox(
              height: 29.h,
              child: Row(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24.r,
                        height: 24.r,
                        child: icon,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          ticker,
                          style: GoogleFonts.roboto(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF84ADC6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: GoogleFonts.roboto(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 27.h,
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
                trackHeight: 10.h,
              ),
              child: Slider(
                min: minPercent.toDouble(),
                max: maxPercent.toDouble(),
                value: value,
                onChanged: (value) {
                  if (onChanged == null) {
                    return;
                  }

                  final newMin = maxPercent.abs() - minPercent.abs();
                  final newMax = ((maxPercent.abs() + minPercent.abs()) * 100);
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

                  onChanged!(newValue);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 14.h, left: 16.w, right: 16.w),
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
