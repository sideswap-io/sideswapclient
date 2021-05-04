import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/country_codes.dart';
import 'package:sideswap/models/countries_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/wait_sms_confirmation.dart';

typedef PhoneNumberCallback = void Function(CountryCode, String);

class CountryPhoneNumber extends StatefulWidget {
  const CountryPhoneNumber({
    Key key,
    @required this.phoneNumberCallback,
    this.focusNode,
  }) : super(key: key);

  final PhoneNumberCallback phoneNumberCallback;
  final FocusNode focusNode;

  @override
  _CountryPhoneNumberState createState() => _CountryPhoneNumberState();
}

class _CountryPhoneNumberState extends State<CountryPhoneNumber> {
  CountryCode _visibleCountryCode;
  String _visiblePhoneNumber;
  FocusNode _phoneFocusNode;
  TextEditingController _controller;
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
      List<DropdownMenuItem<CountryCode>>(codes.length);

  @override
  void initState() {
    super.initState();

    _phoneFocusNode = widget.focusNode;
    _controller = TextEditingController();

    _visibleCountryCode = context.read(phoneProvider).countryCode;
    _menuItems = context
        .read(countriesProvider)
        .countries
        .map(
          (e) => DropdownMenuItem<CountryCode>(
            child: Row(
              children: [
                Text(
                  e.isoUnicodeFlag,
                  style: _flagStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Text(
                    e.iso3Code,
                    style: _defaultTextStyle,
                  ),
                ),
              ],
            ),
            value: e,
          ),
        )
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) {
    final phoneNumber = context.read(phoneProvider).phoneNumber ?? '';
    _visiblePhoneNumber = phoneNumber;
    _controller.clear();
    _controller.text = phoneNumber;
    setState(() {
      _visibleCountryCode = context.read(phoneProvider).countryCode;
      _counter = context.read(phoneProvider).getSmsDelay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Color(0xFF00B4E9),
            ),
          ),
          Spacer(),
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
                    Container(
                      height: 54.h,
                      width: 112.w,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<CountryCode>(
                            dropdownColor: Colors.white,
                            value: _visibleCountryCode,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFF00B4E9),
                            ),
                            items: _menuItems,
                            onChanged: (value) {
                              setState(() {
                                _visibleCountryCode = value;
                              });
                              widget.phoneNumberCallback(
                                  _visibleCountryCode, _visiblePhoneNumber);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFFCCDEE9),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      child: Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Container(
                              width: 56.w,
                              child: Text(
                                '+${_visibleCountryCode.dialCode}',
                                style: _defaultTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Container(
                          child: TextField(
                            controller: _controller,
                            focusNode: _phoneFocusNode,
                            cursorColor: Colors.black,
                            style: _defaultTextStyle,
                            autofillHints: [
                              AutofillHints.telephoneNumberNational,
                            ],
                            keyboardType: TextInputType.numberWithOptions(),
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\-|,.\\ ]')),
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _controller.value =
                                  FilteringTextInputFormatter.deny(
                                          RegExp('[\\-|,.\\ ]'))
                                      .formatEditUpdate(
                                          _controller.value, _controller.value);
                              _controller.value =
                                  FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'))
                                      .formatEditUpdate(
                                          _controller.value, _controller.value);
                              _visiblePhoneNumber = _controller.value.text;
                              widget.phoneNumberCallback(
                                  _visibleCountryCode, _visiblePhoneNumber);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, watch, child) {
                    final barier = watch(phoneProvider).barier;
                    if (barier && _phoneFocusNode.hasPrimaryFocus) {
                      _phoneFocusNode.unfocus();
                    }
                    return Visibility(
                      visible: barier,
                      child: Container(
                        color: Color(0xFF135579).withOpacity(.5),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              final delay = watch(phoneProvider).getSmsDelay();
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
