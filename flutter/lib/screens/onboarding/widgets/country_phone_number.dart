import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/providers/countries_provider.dart';
import 'package:sideswap/providers/phone_provider.dart';
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

  final TextStyle _flagStyle = const TextStyle(
    fontSize: 17,
  );

  final TextStyle _defaultTextStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: Color(0xFF002241),
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
                  padding: const EdgeInsets.only(left: 8),
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
      height: 117,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone number'.tr(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00B4E9),
            ),
          ),
          const Spacer(),
          Container(
            height: 54,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 54,
                      width: 112,
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
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: VerticalDivider(
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
                          padding: const EdgeInsets.only(left: 16),
                          child: SizedBox(
                            width: 56,
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
                        padding: const EdgeInsets.only(right: 16),
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
                        color: SideSwapColors.chathamsBlue.withOpacity(.5),
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
                padding: const EdgeInsets.only(top: 8),
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
