import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/choose_avatar_image.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class ImportAvatar extends ConsumerWidget {
  ImportAvatar({super.key});

  final double avatarRadius = 200.w;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 56.h),
                child: Container(
                  width: avatarRadius,
                  height: avatarRadius,
                  decoration: BoxDecoration(
                    color: const Color(0xFF135579),
                    borderRadius: BorderRadius.all(
                      Radius.circular(avatarRadius),
                    ),
                    border: Border.all(
                      color: const Color(0xFF00C5FF),
                      width: 6.w,
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.h),
                      child: SvgPicture.asset('assets/avatar.svg'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Text(
                  'Want to add an avatar?'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: const PageDots(
                  maxSelectedDots: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomBigButton(
                  height: 54.h,
                  width: double.maxFinite,
                  text: 'YES'.tr(),
                  textColor: Colors.white,
                  backgroundColor: const Color(0xFF00C5FF),
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const ChooseAvatarImage();
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomBigButton(
                    height: 54.h,
                    width: double.maxFinite,
                    text: 'NOT NOW'.tr(),
                    textColor: const Color(0xFF00C5FF),
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      ref.read(walletProvider).setAssociatePhoneWelcome();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
