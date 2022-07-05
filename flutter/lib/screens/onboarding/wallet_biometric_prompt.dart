import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/onboarding/widgets/biometric_logo.dart';

class WalletBiometricPrompt extends StatelessWidget {
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  const WalletBiometricPrompt({
    super.key,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 56.h),
              child: const BiometricLogo(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.h, left: 40.w, right: 40.w),
              child: Text(
                'Do you wish to activate biometric authentication?'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                'Protect your keys by enabling biometric authentication'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomBigButton(
                width: double.infinity,
                height: 54.h,
                text: 'YES'.tr(),
                backgroundColor: const Color(0xFF00C5FF),
                onPressed: onYesPressed,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54.h,
                  text: 'NOT NOW'.tr(),
                  textColor: const Color(0xFF00C5FF),
                  backgroundColor: Colors.transparent,
                  onPressed: onNoPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
