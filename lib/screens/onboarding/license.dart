import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';

enum LicenseNextStep {
  createWallet,
  importWallet,
}

class LicenseTerms extends StatelessWidget {
  const LicenseTerms({
    Key? key,
    required this.nextStep,
  }) : super(key: key);

  final LicenseNextStep nextStep;

  Future<String> loadLicense() async {
    return await rootBundle.loadString('LICENSE');
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 38.h, left: 16.w, right: 16.w),
            child: Text(
              'Terms and conditions'.tr(),
              style: GoogleFonts.roboto(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Material(
              elevation: 3.0,
              color: Colors.transparent,
              shadowColor: Color(0xFF1E6389),
              child: Container(
                height: 421.h,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 8.w, right: 8.w, top: 8.w, bottom: 8.w),
                  child: SingleChildScrollView(
                    child: Center(
                      child: FutureBuilder(
                        future: loadLicense(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textScaleFactor: 1.03,
                              style: GoogleFonts.robotoMono(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(top: 32.h),
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 24.w,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
            child: CustomBigButton(
              width: double.infinity,
              height: 54.h,
              text: 'I AGREE'.tr(),
              backgroundColor: Color(0xFF00C5FF),
              onPressed: () async {
                await context.read(walletProvider).setLicenseAccepted();
                if (nextStep == LicenseNextStep.createWallet) {
                  await context
                      .read(walletProvider)
                      .setReviewLicenseCreateWallet();
                  return;
                }

                if (nextStep == LicenseNextStep.importWallet) {
                  context.read(walletProvider).startMnemonicImport();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
