import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

class PinWelcome extends StatelessWidget {
  const PinWelcome({
    Key key,
    this.onYesPressed,
    this.onNoPressed,
  }) : super(key: key);

  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  @override
  Widget build(BuildContext context) {
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
                  child: PinWelcomeBody(
                    onYesPressed: onYesPressed,
                    onNoPressed: onNoPressed,
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

class PinWelcomeBody extends StatelessWidget {
  const PinWelcomeBody({
    Key key,
    this.onYesPressed,
    this.onNoPressed,
  }) : super(key: key);

  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 56.h),
              child: SvgPicture.asset(
                'assets/locker2.svg',
                width: 156.w,
                height: 202.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: Text(
                'Do you wish to set a PIN to protect your wallet?'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                'Protect your wallet with the PIN'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            CustomBigButton(
              width: double.maxFinite,
              height: 54.h,
              backgroundColor: Color(0xFF00C5FF),
              text: 'YES'.tr(),
              onPressed: onYesPressed ??
                  () {
                    context.read(walletProvider).setPinSetup(
                      onSuccessCallback: (BuildContext context) async {
                        if (FlavorConfig.isProduction() &&
                            FlavorConfig
                                .instance.values.enableOnboardingUserFeatures) {
                          context.read(walletProvider).setImportAvatar();
                        } else {
                          await context
                              .read(walletProvider)
                              .loginAndLoadMainPage();
                        }
                      },
                      onBackCallback: (BuildContext context) async {
                        await context.read(walletProvider).setPinWelcome();
                      },
                    );
                  },
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
              child: CustomBigButton(
                width: double.maxFinite,
                height: 54.h,
                backgroundColor: Colors.transparent,
                text: 'NOT NOW'.tr(),
                textColor: Color(0xFF00C5FF),
                onPressed: onNoPressed ??
                    () async {
                      await context
                          .read(walletProvider)
                          .setImportWalletBiometricPrompt();
                    },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
