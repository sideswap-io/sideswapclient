import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/country_phone_number.dart';
import 'package:sideswap/screens/onboarding/widgets/sms_digit_code.dart';

class ConfirmPhone extends ConsumerStatefulWidget {
  const ConfirmPhone({super.key});

  @override
  ConfirmPhoneState createState() => ConfirmPhoneState();
}

class ConfirmPhoneState extends ConsumerState<ConfirmPhone> {
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
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          if (confirmPhoneData != null) {
            await confirmPhoneData!.onConfirmPhoneBack!(context);
          }
        }
      },
      enableInsideTopPadding: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 38),
            child: Text(
              'Confirm phone number'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: CountryPhoneNumber(
              phoneNumberCallback: phoneNumberValidator,
              focusNode: _numberFocusNode,
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final step = ref.watch(phoneProvider).smsCodeStep;
              if (step != SmsCodeStep.hidden) {
                return const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: SmsDigitCode(),
                );
              } else {
                return const SizedBox();
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
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomBigButton(
                    height: 54,
                    width: double.maxFinite,
                    enabled: phoneStep == PhoneRegisterStep.numberEntered,
                    backgroundColor: SideSwapColors.brightTurquoise,
                    textColor: Colors.white,
                    text: 'SEND SMS WITH CODE'.tr(),
                    onPressed: () {
                      ref.read(phoneProvider).sendPhoneNumber();
                    },
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomBigButton(
                    height: 54,
                    width: double.maxFinite,
                    enabled: enabledSmsButton,
                    backgroundColor: SideSwapColors.brightTurquoise,
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
