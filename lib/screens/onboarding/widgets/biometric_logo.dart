import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/onboarding/widgets/biometric_shape_border.dart';

class BiometricLogo extends StatelessWidget {
  const BiometricLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 169.w,
            height: 202.h,
            decoration: ShapeDecoration(
              shape: BiometricShapeBorder(
                borderLength: 41.w,
                borderWidth: 6,
                borderRadius: 12.w,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fingerprint,
                size: 72.h,
                color: const Color(0xFFCAF3FF),
              ),
            ),
          ),
        ),
        Center(
          //heightFactor: 6,
          child: Padding(
            padding: EdgeInsets.only(top: 63.h),
            child: Container(
              width: 169.w,
              height: 28.h,
              color: const Color(0xFF135579).withOpacity(0.79),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 91.h),
            child: Container(
              width: 259.w,
              height: 3.h,
              decoration: const BoxDecoration(
                color: Color(0xFFCAF3FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 94.h),
            child: Opacity(
              opacity: 1.0,
              child: Container(
                width: 259.w,
                height: 84.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF418AA6).withOpacity(0.6),
                      Colors.white.withOpacity(0),
                    ],
                    stops: const [-0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
