import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/models/countries_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/wait_sms_confirmation.dart';

typedef PhoneNumberCallback = void Function(CountryCode, String);

class CountryPhoneNumber extends ConsumerStatefulWidget {
  const CountryPhoneNumber({
    super.key,
    required this.phoneNumberCallback,
    this.focusNode,
  });

  final PhoneNumberCallback phoneNumberCallback;
  final FocusNode? focusNode;

  @override
  CountryPhoneNumberState createState() => CountryPhoneNumberState();
}

class CountryPhoneNumberState extends ConsumerState<CountryPhoneNumber> {
  late CountryCode visibleCountryCode;
  String visiblePhoneNumber = '';
  late FocusNode phoneFocusNode;
  TextEditingController controller = TextEditingController();
  int _counter = 0;

  final TextStyle _flagStyle = GoogleFonts.roboto(
    fontSize: 17.sp,
  );

  final TextStyle _defaultTextStyle = GoogleFonts.roboto(
    fontSize: 17.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF002241),
  );

  List<DropdownMenuItem<CountryCode>> _menuItems =
      <DropdownMenuItem<CountryCode>>[];

  @override
  void initState() {
    super.initState();

    phoneFocusNode = widget.focusNode ?? FocusNode();

    visibleCountryCode = ref.read(phoneProvider).countryCode;
    _menuItems = ref
        .read(countriesProvider)
        .countries
        .map(
          (e) => DropdownMenuItem<CountryCode>(
            value: e,
            child: Row(
              children: [
                Text(
                  e.isoUnicodeFlag,
                  style: _flagStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    e.iso3Code ?? '',
                    style: _defaultTextStyle,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuild(ref, context));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void afterBuild(WidgetRef ref, BuildContext context) {
    final phoneNumber = ref.read(phoneProvider).phoneNumber;
    visiblePhoneNumber = phoneNumber;
    controller.clear();
    controller.text = phoneNumber;
    setState(() {
      visibleCountryCode = ref.read(phoneProvider).countryCode;
      _counter = ref.read(phoneProvider).getSmsDelay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 117.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone number'.tr(),
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00B4E9),
            ),
          ),
          const Spacer(),
          Container(
            height: 54.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 54.h,
                      width: 112.w,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<CountryCode>(
                            dropdownColor: Colors.white,
                            value: visibleCountryCode,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF00B4E9),
                            ),
                            items: _menuItems,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                visibleCountryCode = value;
                              });
                              widget.phoneNumberCallback(
                                  visibleCountryCode, visiblePhoneNumber);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFFCCDEE9),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(phoneFocusNode);
                      },
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: SizedBox(
                            width: 56.w,
                            child: Text(
                              '+${visibleCountryCode.dialCode}',
                              style: _defaultTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: TextField(
                          controller: controller,
                          focusNode: phoneFocusNode,
                          cursorColor: Colors.black,
                          style: _defaultTextStyle,
                          autofillHints: const [
                            AutofillHints.telephoneNumberNational,
                          ],
                          keyboardType: const TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\-|,.\\ ]')),
                          ],
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            controller.value = FilteringTextInputFormatter.deny(
                                    RegExp('[\\-|,.\\ ]'))
                                .formatEditUpdate(
                                    controller.value, controller.value);
                            controller.value =
                                FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'))
                                    .formatEditUpdate(
                                        controller.value, controller.value);
                            visiblePhoneNumber = controller.value.text;
                            widget.phoneNumberCallback(
                                visibleCountryCode, visiblePhoneNumber);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final barier = ref.watch(phoneProvider).barier;
                    if (barier && phoneFocusNode.hasPrimaryFocus) {
                      phoneFocusNode.unfocus();
                    }
                    return Visibility(
                      visible: barier,
                      child: Container(
                        color: const Color(0xFF135579).withOpacity(.5),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final delay = ref.watch(phoneProvider).getSmsDelay();
              if (_counter == 0 && delay != 0) {
                Future.microtask(() {
                  setState(() {
                    _counter = delay;
                  });
                });
              }

              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: WaitSmsConfirmation(
                  duration: Duration(seconds: _counter),
                  counter: _counter,
                  onEnd: () {
                    Future.microtask(() {
                      setState(() {
                        _counter = 0;
                      });
                    });
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
