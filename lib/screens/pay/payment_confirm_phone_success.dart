import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/models/contact_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/wallet.dart';

class PaymentConfirmPhoneSuccess extends StatefulWidget {
  const PaymentConfirmPhoneSuccess({Key? key}) : super(key: key);

  @override
  _PaymentConfirmPhoneSuccessState createState() =>
      _PaymentConfirmPhoneSuccessState();
}

class _PaymentConfirmPhoneSuccessState
    extends State<PaymentConfirmPhoneSuccess> {
  final _defaultTextStyle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  StreamSubscription<int>? percentageLoadedSubscription;
  int percent = 0;

  @override
  void initState() {
    super.initState();

    percentageLoadedSubscription = context
        .read(contactProvider)
        .percentageLoaded
        .listen(onPercentageLoaded);
  }

  @override
  void dispose() {
    percentageLoadedSubscription?.cancel();
    super.dispose();
  }

  void onPercentageLoaded(int value) {
    setState(() {
      percent = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      hideCloseButton: true,
      enableInsideHorizontalPadding: false,
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00C5FF),
                    style: BorderStyle.solid,
                    width: 4.w,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/success.svg',
                    width: 33.w,
                    height: 33.w,
                    color: const Color(0xFFCAF3FF),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22.h),
              child: Text(
                'Success!'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w),
              child: RichText(
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
            ),
            const Spacer(),
            Container(
              height: 324.h,
              color: const Color(0xFF004666),
              child: Center(
                child: Consumer(
                  builder: (context, watch, child) {
                    final contactsLoadingState =
                        watch(contactProvider).contactsLoadingState;

                    if (contactsLoadingState == ContactsLoadingState.done) {
                      Future.microtask(() async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        context.read(walletProvider).selectPaymentPage();
                      });
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 48.h),
                          child: Text(
                            'Want to import contacts?'.tr(),
                            style: GoogleFonts.roboto(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: contactsLoadingState ==
                              ContactsLoadingState.running,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 32.w, right: 16.w, left: 16.w),
                            child: SideSwapProgressBar(
                              percent: percent,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w),
                          child: CustomBigButton(
                            width: double.maxFinite,
                            height: 54.h,
                            text: 'IMPORT CONTACTS'.tr(),
                            backgroundColor: const Color(0xFF00C5FF),
                            enabled: contactsLoadingState !=
                                ContactsLoadingState.running,
                            onPressed: () {
                              context.read(contactProvider).loadContacts();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 7.h, bottom: 15.h, left: 16.w, right: 16.w),
                          child: CustomBigButton(
                            width: double.maxFinite,
                            height: 54.h,
                            text: 'NOT NOW'.tr(),
                            backgroundColor: Colors.transparent,
                            enabled: contactsLoadingState !=
                                ContactsLoadingState.running,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              context.read(walletProvider).selectPaymentPage();
                            },
                          ),
                        ),
                      ],
                    );
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
