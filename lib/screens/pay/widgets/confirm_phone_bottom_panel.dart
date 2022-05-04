import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/confirm_phone.dart';
import 'package:sideswap/screens/pay/payment_confirm_phone_success.dart';

class ConfirmPhoneBottomPanel extends StatelessWidget {
  const ConfirmPhoneBottomPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 227.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.w),
          topRight: Radius.circular(16.w),
        ),
        color: const Color(0xFF135579),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 29.h),
            child: Text(
              'SideSwap Friends'.tr(),
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h, left: 28.w, right: 28.w),
            child: Text(
              'Confirm your phone number to send funds to friends'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Padding(
              padding: EdgeInsets.only(bottom: 36.h, left: 16.w, right: 16.w),
              child: Consumer(
                builder: (context, ref, _) {
                  return CustomBigButton(
                    width: double.maxFinite,
                    height: 54.h,
                    text: 'CONFIRM PHONE NUMBER'.tr(),
                    backgroundColor: const Color(0xFF003251),
                    textColor: const Color(0xFF00B4E9),
                    onPressed: () async {
                      ref.read(phoneProvider).setConfirmPhoneData(
                            confirmPhoneData: ConfirmPhoneData(
                              onConfirmPhoneBack: (context) async {
                                Navigator.of(context).pop();
                              },
                              onConfirmPhoneSuccess: (context) async {
                                await Navigator.of(context, rootNavigator: true)
                                    .push<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentConfirmPhoneSuccess(),
                                  ),
                                );
                              },
                              onConfirmPhoneDone: (context) async {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                ref.read(walletProvider).setImportContacts();
                              },
                              onImportContactsBack: (context) async {},
                              onImportContactsDone: (context) async {
                                ref.read(walletProvider).selectPaymentPage();
                              },
                              onImportContactsSuccess: (context) async {
                                ref.read(walletProvider).selectPaymentPage();
                              },
                            ),
                          );

                      await Navigator.of(context, rootNavigator: true)
                          .push<void>(
                        MaterialPageRoute(
                          builder: (context) => const ConfirmPhone(),
                        ),
                      );
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}
