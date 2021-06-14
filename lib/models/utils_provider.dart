import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/swap/widgets/quote_expired_dialog.dart';

enum SettingsDialogIcon {
  error,
  restart,
}

final kErrorQuoteExpired = 'quote expired';

final utilsProvider = Provider((ref) => UtilsProvider(ref.read));

class UtilsProvider {
  final Reader read;

  UtilsProvider(this.read);

  Future<void> settingsErrorDialog({
    required String title,
    String description = '',
    required String buttonText,
    required VoidCallback onPressed,
    String secondButtonText = '',
    VoidCallback? onSecondPressed,
    SettingsDialogIcon icon = SettingsDialogIcon.error,
  }) async {
    final context = read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    final Widget? iconWidget;
    final Color? borderColor;

    switch (icon) {
      case SettingsDialogIcon.error:
        iconWidget = SvgPicture.asset(
          'assets/error.svg',
          width: 22.w,
          height: 22.w,
          color: Color(0xFFFF7878),
        );
        borderColor = Color(0xFFFF7878);
        break;
      case SettingsDialogIcon.restart:
        iconWidget = SvgPicture.asset(
          'assets/restart.svg',
          width: 22.w,
          height: 22.w,
          color: Color(0xFF00C5FF),
        );
        borderColor = Color(0xFF00C5FF);
        break;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
              color: Color(0xFF1C6086),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 66.w,
                    height: 66.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.w),
                      border: Border.all(
                        color: borderColor!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: iconWidget,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        description,
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54.h,
                      text: buttonText,
                      backgroundColor: Color(0xFF00C5FF),
                      onPressed: onPressed,
                    ),
                  ),
                  if (secondButtonText.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54.h,
                        text: secondButtonText,
                        backgroundColor: Colors.transparent,
                        textColor: Color(0xFF00C5FF),
                        onPressed: onSecondPressed,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorDialog(String errorDescription,
      {String? buttonText}) async {
    final context = read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    if (errorDescription == kErrorQuoteExpired) {
      showQuoteExpiredDialog(context);
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
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
                            errorDescription,
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
                        text: buttonText ?? 'TRY AGAIN'.tr(),
                        backgroundColor: Color(0xFF00C5FF),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
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
