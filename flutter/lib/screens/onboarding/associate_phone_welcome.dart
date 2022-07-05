import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class AvatarClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final rect =
        Rect.fromLTRB(0.0, 0.0, size.width, size.height - size.height / 4.1);
    return rect;
  }

  @override
  bool shouldReclip(AvatarClipper oldClipper) {
    return true;
  }
}

class AssociatePhoneWelcome extends ConsumerWidget {
  const AssociatePhoneWelcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: ClipRect(
                                clipper: AvatarClipper(),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 56.h, right: 75.w),
                                  child: SizedBox(
                                    width: 192.w,
                                    height: 267.h,
                                    child: SvgPicture.asset(
                                      'assets/associate_phone.svg',
                                      width: 197.w,
                                      height: 267.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 290.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40.w),
                                child: Text(
                                  'Want to associate an phone number with your account?'
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 32.h),
                          child: const PageDots(
                            maxSelectedDots: 3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CustomBigButton(
                            width: double.maxFinite,
                            height: 54.h,
                            backgroundColor: const Color(0xFF00C5FF),
                            text: 'YES'.tr(),
                            onPressed: () {
                              ref.read(walletProvider).setConfirmPhone();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                            child: CustomBigButton(
                              width: double.maxFinite,
                              height: 54.h,
                              backgroundColor: Colors.transparent,
                              text: 'NOT NOW'.tr(),
                              textColor: const Color(0xFF00C5FF),
                              onPressed: () {
                                ref.read(walletProvider).setImportContacts();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
