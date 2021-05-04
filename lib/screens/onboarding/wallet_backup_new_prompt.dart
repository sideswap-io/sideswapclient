import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';
import 'package:sideswap/screens/onboarding/widgets/wallet_backup_new_prompt_dialog.dart';

class WalletBackupNewPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 56.h),
                    child: SvgPicture.asset(
                      'assets/shield_big.svg',
                      width: 182.w,
                      height: 202.h,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 113.h),
                    child: SvgPicture.asset(
                      'assets/locker.svg',
                      width: 54.w,
                      height: 73.h,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Do you wish to backup your wallet?'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
              child: Text(
                'Protect your assets by ensuring you save the 12 work recovery phrase which can restore your wallet'
                    .tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 32.h),
              child: PageDots(
                maxSelectedDots: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomBigButton(
                width: double.infinity,
                height: 54.h,
                text: 'YES'.tr(),
                backgroundColor: Color(0xFF00C5FF),
                onPressed: () {
                  context.read(walletProvider).backupNewWalletEnable();
                },
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
                  textColor: Color(0xFF00C5FF),
                  backgroundColor: Colors.transparent,
                  onPressed: () async {
                    showWalletBackupDialog(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
