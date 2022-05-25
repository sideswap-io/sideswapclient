import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/phone_provider.dart';

class SmsDigitCode extends ConsumerStatefulWidget {
  const SmsDigitCode({
    super.key,
  });

  @override
  SmsDigitCodeState createState() => SmsDigitCodeState();
}

class SmsDigitCodeState extends ConsumerState<SmsDigitCode> {
  final TextStyle _defaultPinStyle = GoogleFonts.roboto(
    fontSize: 22.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF002241),
  );

  void validate(String value) {
    ref.read(phoneProvider).setSmsCode(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 107.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter the 4 digit code from SMS'.tr(),
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00C5FF),
            ),
          ),
          const Spacer(),
          Consumer(
            builder: (context, ref, child) {
              final step = ref.watch(phoneProvider).smsCodeStep;
              return Container(
                width: double.maxFinite,
                height: 54.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.w),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    color: step == SmsCodeStep.wrongCode
                        ? const Color(0xFFFF7878)
                        : Colors.white,
                  ),
                ),
                child: PinPut(
                  eachFieldConstraints:
                      BoxConstraints(maxHeight: 54.h, minWidth: 80.w),
                  fieldsCount: 4,
                  preFilledWidget: Container(
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  separatorPositions: const [1, 2, 3],
                  separator: SizedBox(
                    height: 54.h,
                    child: const VerticalDivider(
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
                          color: const Color(0xFFFF7878))
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
                height: 23.h,
                child: Visibility(
                  visible: step == SmsCodeStep.wrongCode,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      'Wrong code',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFFFF7878),
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
