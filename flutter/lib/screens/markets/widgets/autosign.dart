import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class AutoSign extends StatelessWidget {
  const AutoSign({
    super.key,
    this.backgroundColor = const Color(0xFF014767),
    required this.value,
    this.onToggle,
  });

  final Color backgroundColor;
  final bool value;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        color: backgroundColor,
      ),
      child: Padding(
        padding:
            EdgeInsets.only(top: 6.h, bottom: 12.h, left: 12.w, right: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Auto-sign'.tr(),
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
                  activeText: 'On'.tr(),
                  inactiveText: 'Off'.tr(),
                  value: value,
                  onToggle: onToggle,
                ),
              ],
            ),
            Text(
              'If someone confirms your order in the order book, SideSwap will automatically confirm the order'
                  .tr(),
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF569BBA),
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
