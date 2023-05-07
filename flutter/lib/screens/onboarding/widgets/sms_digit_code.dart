import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/phone_provider.dart';

class SmsDigitCode extends ConsumerStatefulWidget {
  const SmsDigitCode({
    super.key,
  });

  @override
  SmsDigitCodeState createState() => SmsDigitCodeState();
}

class SmsDigitCodeState extends ConsumerState<SmsDigitCode> {
  final TextStyle _defaultPinStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: Color(0xFF002241),
  );

  void validate(String value) {
    ref.read(phoneProvider).setSmsCode(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 107,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter the 4 digit code from SMS'.tr(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              final step = ref.watch(phoneProvider).smsCodeStep;
              return Container(
                width: double.maxFinite,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    color: step == SmsCodeStep.wrongCode
                        ? SideSwapColors.bitterSweet
                        : Colors.white,
                  ),
                ),
                child: PinPut(
                  eachFieldConstraints:
                      const BoxConstraints(maxHeight: 54, minWidth: 80),
                  fieldsCount: 4,
                  preFilledWidget: Container(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  separatorPositions: const [1, 2, 3],
                  separator: const SizedBox(
                    height: 54,
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: Color(0xFFCCDEE9),
                    ),
                  ),
                  fieldsAlignment: MainAxisAlignment.spaceEvenly,
                  eachFieldMargin: EdgeInsets.zero,
                  eachFieldPadding: EdgeInsets.zero,
                  textStyle: step == SmsCodeStep.wrongCode
                      ? _defaultPinStyle.copyWith(
                          color: SideSwapColors.bitterSweet)
                      : _defaultPinStyle,
                  pinAnimationType: PinAnimationType.scale,
                  withCursor: true,
                  cursor: Text(
                    '|',
                    style: _defaultPinStyle,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp('[\\-|,.\\ ]'),
                    ),
                  ],
                  onChanged: validate,
                ),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final step = ref.watch(phoneProvider).smsCodeStep;
              return SizedBox(
                height: 23,
                child: Visibility(
                  visible: step == SmsCodeStep.wrongCode,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Wrong code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: SideSwapColors.bitterSweet,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
