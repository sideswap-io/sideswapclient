import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_text_field.dart';

class PinSetup extends StatefulWidget {
  PinSetup({Key? key}) : super(key: key);

  @override
  _PinSetupState createState() => _PinSetupState();
}

class _PinSetupState extends State<PinSetup> {
  final _firstPinFocusNode = FocusNode();
  final _secondPinFocusNode = FocusNode();
  StreamSubscription<PinKey>? keyPressedSubscription;

  @override
  void initState() {
    keyPressedSubscription =
        context.read(pinKeyboardProvider).keyPressedSubject.listen((pinKey) {
      context.read(pinSetupProvider).onKeyEntered(pinKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    keyPressedSubscription?.cancel();
    _firstPinFocusNode.dispose();
    _secondPinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      backgroundColor: Color(0xFF135579),
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: 'Protect your wallet'.tr(),
        onPressed: () {
          context.read(pinSetupProvider).onBack();
        },
      ),
      onWillPop: () async {
        context.read(pinSetupProvider).onBack();
        return false;
      },
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: Color(0xFF23729D),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: Text(
                          'Set your PIN (4-8 chars)'.tr(),
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C5FF),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                        child: Consumer(
                          builder: (context, watch, child) {
                            final pin = watch(pinSetupProvider).firstPin;
                            final fieldState =
                                watch(pinSetupProvider).fieldState;
                            if (fieldState == PinFieldState.firstPin) {
                              _firstPinFocusNode.requestFocus();
                            }
                            final enabled =
                                watch(pinSetupProvider).firstPinEnabled;

                            return PinTextField(
                              enabled: enabled,
                              pin: pin,
                              focusNode: _firstPinFocusNode,
                              onTap: context.read(pinSetupProvider).onTap,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 22.h),
                        child: Text(
                          'Confirm your PIN'.tr(),
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C5FF),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
                        child: Consumer(
                          builder: (context, watch, child) {
                            final pin = watch(pinSetupProvider).secondPin;
                            final fieldState =
                                watch(pinSetupProvider).fieldState;
                            if (fieldState == PinFieldState.secondPin) {
                              _secondPinFocusNode.requestFocus();
                            }
                            final enabled =
                                watch(pinSetupProvider).secondPinEnabled;
                            final state = watch(pinSetupProvider).state;
                            final errorMessage =
                                watch(pinSetupProvider).errorMessage;

                            return PinTextField(
                              enabled: enabled,
                              error: state == PinSetupState.error,
                              errorMessage: errorMessage,
                              pin: pin,
                              focusNode: _secondPinFocusNode,
                              onTap: context.read(pinSetupProvider).onTap,
                            );
                          },
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: Consumer(
                          builder: (context, watch, child) {
                            return PinKeyboard(
                              onlyAccept: watch(pinSetupProvider).fieldState ==
                                  PinFieldState.secondPin,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
