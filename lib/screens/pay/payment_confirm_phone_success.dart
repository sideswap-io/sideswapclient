import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/providers/contact_provider.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class PaymentConfirmPhoneSuccess extends ConsumerStatefulWidget {
  const PaymentConfirmPhoneSuccess({super.key});

  @override
  PaymentConfirmPhoneSuccessState createState() =>
      PaymentConfirmPhoneSuccessState();
}

class PaymentConfirmPhoneSuccessState
    extends ConsumerState<PaymentConfirmPhoneSuccess> {
  final _defaultTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  StreamSubscription<int>? percentageLoadedSubscription;
  int percent = 0;

  @override
  void initState() {
    super.initState();

    percentageLoadedSubscription =
        ref.read(contactProvider).percentageLoaded.listen(onPercentageLoaded);
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
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: SideSwapColors.brightTurquoise,
                    style: BorderStyle.solid,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/success.svg',
                    width: 33,
                    height: 33,
                    colorFilter: const ColorFilter.mode(
                        Color(0xFFCAF3FF), BlendMode.srcIn),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(
                'Success!'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                child: Consumer(
                  builder: (context, ref, _) {
                    final countryPhoneNumber = ref.watch(
                        phoneProvider.select((p) => p.countryPhoneNumber));
                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your number '.tr(),
                            style: _defaultTextStyle,
                          ),
                          TextSpan(
                            text: countryPhoneNumber,
                            style: _defaultTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' has been successfully linked to the wallet'
                                .tr(),
                            style: _defaultTextStyle,
                          ),
                        ],
                      ),
                    );
                  },
                )),
            const Spacer(),
            Container(
              height: 324,
              color: const Color(0xFF004666),
              child: Center(
                child: Consumer(
                  builder: (context, ref, _) {
                    final contactsLoadingState = ref.watch(
                        contactProvider.select((p) => p.contactsLoadingState));

                    if (contactsLoadingState == ContactsLoadingState.done) {
                      Future.microtask(() async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ref.read(walletProvider).selectPaymentPage();
                      });
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Text(
                            'Want to import contacts?'.tr(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: contactsLoadingState ==
                              ContactsLoadingState.running,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32, right: 16, left: 16),
                            child: SideSwapProgressBar(
                              percent: percent,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: CustomBigButton(
                            width: double.maxFinite,
                            height: 54,
                            text: 'IMPORT CONTACTS'.tr(),
                            backgroundColor: SideSwapColors.brightTurquoise,
                            enabled: contactsLoadingState !=
                                ContactsLoadingState.running,
                            onPressed: () {
                              ref.read(contactProvider).loadContacts();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 15, left: 16, right: 16),
                          child: CustomBigButton(
                            width: double.maxFinite,
                            height: 54,
                            text: 'NOT NOW'.tr(),
                            backgroundColor: Colors.transparent,
                            enabled: contactsLoadingState !=
                                ContactsLoadingState.running,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              ref.read(walletProvider).selectPaymentPage();
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
