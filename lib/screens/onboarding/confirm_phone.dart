import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/country_phone_number.dart';
import 'package:sideswap/screens/onboarding/widgets/sms_digit_code.dart';

class ConfirmPhone extends ConsumerStatefulWidget {
  const ConfirmPhone({Key? key}) : super(key: key);

  @override
  _ConfirmPhoneState createState() => _ConfirmPhoneState();
}

class _ConfirmPhoneState extends ConsumerState<ConfirmPhone> {
  late FocusNode _numberFocusNode;
  ConfirmPhoneData? confirmPhoneData;

  @override
  void initState() {
    super.initState();
    _numberFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));

    confirmPhoneData = ref.read(phoneProvider).getConfirmPhoneData();
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) {
    var delay = ref.read(phoneProvider).getSmsDelay();
    if (delay < 0) {
      ref.read(phoneProvider).setBarier(false);
      FocusScope.of(context).requestFocus(_numberFocusNode);
    }
  }

  void phoneNumberValidator(CountryCode countryCode, String phoneNumber) {
    logger
        .d('Country code: ${countryCode.dialCode} phone number: $phoneNumber');

    ref.read(phoneProvider).setPhoneNumber(countryCode, phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      onClose: () async {
        if (confirmPhoneData != null) {
          await confirmPhoneData!.onConfirmPhoneBack!(context);
        }
      },
      onWillPop: () async {
        if (confirmPhoneData != null) {
          await confirmPhoneData!.onConfirmPhoneBack!(context);
        }
        return false;
      },
      enableInsideTopPadding: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 38.h),
            child: Text(
              'Confirm phone number'.tr(),
              style: GoogleFonts.roboto(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.h),
            child: CountryPhoneNumber(
              phoneNumberCallback: phoneNumberValidator,
              focusNode: _numberFocusNode,
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final step = ref.watch(phoneProvider).smsCodeStep;
              if (step != SmsCodeStep.hidden) {
                return Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: const SmsDigitCode(),
                );
              } else {
                return Container();
              }
            },
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              final phoneStep = ref.watch(phoneProvider).phoneRegisterStep;
              final smsStep = ref.watch(phoneProvider).smsCodeStep;

              final enabledSmsButton = (smsStep == SmsCodeStep.fullyEntered ||
                  smsStep == SmsCodeStep.codeAccepted ||
                  smsStep == SmsCodeStep.wrongCode);

              if (smsStep == SmsCodeStep.hidden) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: CustomBigButton(
                    height: 54.h,
                    width: double.maxFinite,
                    enabled: phoneStep == PhoneRegisterStep.numberEntered,
                    backgroundColor: const Color(0xFF00C5FF),
                    textColor: Colors.white,
                    text: 'SEND SMS WITH CODE'.tr(),
                    onPressed: () {
                      ref.read(phoneProvider).sendPhoneNumber();
                    },
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: CustomBigButton(
                    height: 54.h,
                    width: double.maxFinite,
                    enabled: enabledSmsButton,
                    backgroundColor: const Color(0xFF00C5FF),
                    textColor: Colors.white,
                    text: 'CONFIRM'.tr(),
                    onPressed: () {
                      ref.read(phoneProvider).verifySmsCode();
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
