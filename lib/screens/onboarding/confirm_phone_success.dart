import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ConfirmPhoneSuccess extends StatelessWidget {
  ConfirmPhoneSuccess({
    Key? key,
  }) : super(key: key);

  final _defaultTextStyle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

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
        descriptionWidget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Your number '.tr(),
                style: _defaultTextStyle,
              ),
              TextSpan(
                text: context.read(phoneProvider).countryPhoneNumber,
                style: _defaultTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' has been successfully linked to the wallet'.tr(),
                style: _defaultTextStyle,
              ),
            ],
          ),
        ),
        buttonText: 'CONTINUE'.tr(),
        onPressed: () async {
          final confirmPhoneData =
              context.read(phoneProvider).getConfirmPhoneData();
          await confirmPhoneData.onConfirmPhoneDone!(context);
        },
      ),
    );
  }
}
