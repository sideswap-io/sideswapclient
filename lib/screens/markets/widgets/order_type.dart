import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class OrderType extends StatelessWidget {
  const OrderType({
    Key? key,
    this.backgroundColor = const Color(0xFF014767),
    required this.value,
    this.onToggle,
  }) : super(key: key);

  final Color backgroundColor;
  final bool value;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        color: backgroundColor,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: 8.h, bottom: 8.h, left: 12.w, right: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order type:'.tr(),
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SwitchButton(
              width: 142.w,
              height: 35.h,
              borderRadius: 8.r,
              borderWidth: 2.r,
              activeText: 'Public'.tr(),
              inactiveText: 'Private'.tr(),
              value: value,
              onToggle: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
