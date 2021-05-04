import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/swap/widgets/quote_expired_dialog.dart';

final kErrorQuoteExpired = 'quote expired';

final utilsProvider = Provider((ref) => UtilsProvider(ref.read));

class UtilsProvider {
  final Reader read;

  UtilsProvider(this.read);

  void showErrorDialog(String text) {
    if (text == null) {
      return;
    }

    if (text == kErrorQuoteExpired) {
      showQuoteExpiredDialog(read(walletProvider).navigatorKey.currentContext);
      return;
    }

    showDialog<void>(
      context: read(walletProvider).navigatorKey.currentContext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ), //this right here
          child: Container(
            width: 343.w,
            height: 378.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
              color: Color(0xFF1C6086),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.w),
                        border: Border.all(
                          color: Color(0xFFFF7878),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/error.svg',
                          width: 23.w,
                          height: 23.w,
                          color: Color(0xFFFF7878),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(top: 32.h),
                      child: Container(
                        height: 75.h,
                        child: SingleChildScrollView(
                          child: Text(
                            text,
                            style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: CustomBigButton(
                        width: 279.w,
                        height: 54.h,
                        text: 'TRY AGAIN'.tr(),
                        backgroundColor: Color(0xFF00C5FF),
                        onPressed: () {
                          Navigator.of(
                                  read(walletProvider)
                                      .navigatorKey
                                      .currentContext,
                                  rootNavigator: true)
                              .pop();
                        },
                      ),
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
}
