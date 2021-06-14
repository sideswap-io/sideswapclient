import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class RoundedTextLabel extends StatelessWidget {
  RoundedTextLabel({
    Key? key,
    required this.text,
    this.color = const Color(0xFFA8D6EA),
    this.allRectRadius = false,
    this.height,
  }) : super(key: key);

  final String text;
  final Color color;
  final bool allRectRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Container(
        height: height ?? 26.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: allRectRadius ? Radius.circular(16.w) : Radius.zero,
            topRight: Radius.circular(16.w),
            bottomRight: Radius.circular(16.w),
            bottomLeft: Radius.circular(12.w),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: Color(0xFF05202F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
