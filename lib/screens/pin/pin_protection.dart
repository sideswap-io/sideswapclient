import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_text_field.dart';

class PinProtection extends StatelessWidget {
  const PinProtection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      backgroundColor: Color(0xFF135579),
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: 'Unlock your wallet'.tr(),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
      onWillPop: () async {
        Navigator.of(context).pop(false);
        return false;
      },
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: PinProtectionBody(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PinProtectionBody extends StatefulWidget {
  PinProtectionBody({
    Key? key,
  }) : super(key: key);

  @override
  _PinProtectionBodyState createState() => _PinProtectionBodyState();
}

class _PinProtectionBodyState extends State<PinProtectionBody> {
  final pinFocusNode = FocusNode();
  StreamSubscription<PinKey>? keyPressedSubscription;

  @override
  void initState() {
    keyPressedSubscription =
        context.read(pinKeyboardProvider).keyPressedSubject.listen((pinKey) {
      context.read(pinProtectionProvider).onKeyEntered(pinKey);
    });

    pinFocusNode.requestFocus();
    context.read(pinProtectionProvider).init(onUnlockCallback: () {
      Navigator.of(context).pop(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    keyPressedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              'Enter your PIN'.tr(),
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00C5FF),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
            child: Consumer(
              builder: (context, watch, child) {
                final pin = watch(pinProtectionProvider).pinCode;
                final state = watch(pinProtectionProvider).state;
                final errorMessage = watch(pinProtectionProvider).errorMessage;

                return PinTextField(
                  pin: pin,
                  enabled: state != PinProtectionState.waiting,
                  error: state == PinProtectionState.error,
                  errorMessage: errorMessage,
                  focusNode: pinFocusNode,
                  onTap: () => pinFocusNode.requestFocus(),
                );
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 32.h),
            child: PinKeyboard(
              showUnlock: true,
            ),
          ),
        ],
      ),
    );
  }
}
