import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';

void showQuoteExpiredDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Container(
          width: 343.w,
          height: 417.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.w),
            ),
            color: Color(0xFF1C6086),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF135579),
                    border: Border.all(
                      color: Color(0xFFFF7878),
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 20.w,
                      height: 22.h,
                      color: Color(0xFFFF7878),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Text(
                    'Quote expired'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Container(
                    height: 88.h,
                    child: SingleChildScrollView(
                      child: Text(
                        'The swap signing period elapsed. Please restart for fresh quotes.'
                            .tr(),
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                CustomBigButton(
                  width: 279.w,
                  height: 54.h,
                  text: 'Continue'.tr(),
                  backgroundColor: Color(0xFF00C5FF),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
