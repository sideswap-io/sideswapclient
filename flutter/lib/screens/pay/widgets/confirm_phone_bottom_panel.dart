import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/confirm_phone.dart';
import 'package:sideswap/screens/pay/payment_confirm_phone_success.dart';

class ConfirmPhoneBottomPanel extends StatelessWidget {
  const ConfirmPhoneBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 227,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Color(0xFF135579),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 29),
            child: Text(
              'SideSwap Friends'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22, left: 28, right: 28),
            child: Text(
              'Confirm your phone number to send funds to friends'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.only(bottom: 36, left: 16, right: 16),
              child: Consumer(
                builder: (context, ref, _) {
                  return CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
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
