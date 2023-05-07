import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

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
            width: 169,
            height: 202,
            decoration: const ShapeDecoration(
              shape: BiometricShapeBorder(
                borderLength: 41,
                borderWidth: 6,
                borderRadius: 12,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.fingerprint,
                size: 72,
                color: Color(0xFFCAF3FF),
              ),
            ),
          ),
        ),
        Center(
          //heightFactor: 6,
          child: Padding(
            padding: const EdgeInsets.only(top: 63),
            child: Container(
              width: 169,
              height: 28,
              color: SideSwapColors.chathamsBlue.withOpacity(0.79),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 91),
            child: Container(
              width: 259,
              height: 3,
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
            padding: const EdgeInsets.only(top: 94),
            child: Opacity(
              opacity: 1.0,
              child: Container(
                width: 259,
                height: 84,
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
