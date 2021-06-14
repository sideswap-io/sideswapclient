import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ImportContactsSuccess extends StatelessWidget {
  const ImportContactsSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Success!'.tr(),
        descriptionWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Your contacts has been successfully linked to the wallet'.tr(),
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        button: 'CONTINUE'.tr(),
        onPressed: () async {
          await context.read(walletProvider).loginAndLoadMainPage();
        },
      ),
    );
  }
}
