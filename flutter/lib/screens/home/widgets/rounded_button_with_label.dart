import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';

class RoundedButtonWithLabel extends StatelessWidget {
  const RoundedButtonWithLabel({
    super.key,
    this.onTap,
    this.label,
    this.child,
    this.buttonBackground,
  });
  final VoidCallback? onTap;
  final String? label;
  final Widget? child;
  final Color? buttonBackground;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedButton(
          width: 72.w,
          heigh: 72.w,
          onTap: onTap,
          color: buttonBackground,
          child: child,
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text(
            label ?? '',
            style: GoogleFonts.roboto(
              fontSize: 17.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
