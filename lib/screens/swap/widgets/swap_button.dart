import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class SwapButton extends StatelessWidget {
  const SwapButton({
    Key? key,
    this.color,
    required this.text,
    this.textColor,
    this.onPressed,
  }) : super(key: key);

  final Color? color;
  final Color? textColor;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0.w),
      child: Container(
        //width: 139.w,
        height: 36.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0.w),
          ),
          color: color,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: GoogleFonts.roboto(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
