import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/wallet.dart';

void showDeleteWalletDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ), //this right here
        child: Container(
          width: 343.w,
          height: 417.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8.w),
            ),
            color: const Color(0xFF1C6086),
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
                    color: const Color(0xFF135579),
                    border: Border.all(
                      color: const Color(0xFFFF7878),
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/delete.svg',
                      width: 20.w,
                      height: 22.h,
                      color: const Color(0xFFFF7878),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Text(
                    'Are you sure to delete wallet?'.tr(),
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
                  child: SizedBox(
                    height: 88.h,
                    child: SingleChildScrollView(
                      child: Text(
                        'Please make sure you have backed up your wallet before proceeding.'
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
                const Spacer(),
                Consumer(
                  builder: (context, ref, _) {
                    return CustomBigButton(
                      width: 279.w,
                      height: 54.h,
                      text: 'YES'.tr(),
                      backgroundColor: const Color(0xFF00C5FF),
                      onPressed: () async {
                        if (await ref.read(walletProvider).isAuthenticated()) {
                          await ref
                              .read(walletProvider)
                              .settingsDeletePromptConfirm();
                        }
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 14.h),
                  child: CustomBigButton(
                    width: 279.w,
                    height: 54.h,
                    text: 'NO'.tr(),
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
