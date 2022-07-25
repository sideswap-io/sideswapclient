import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_available_provider.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_text_field.dart';

class PinSetup extends ConsumerStatefulWidget {
  const PinSetup({super.key});

  @override
  PinSetupState createState() => PinSetupState();
}

class PinSetupState extends ConsumerState<PinSetup> {
  late FocusNode _firstPinFocusNode;
  late FocusNode _secondPinFocusNode;
  StreamSubscription<PinKey>? keyPressedSubscription;

  @override
  void initState() {
    _firstPinFocusNode = FocusNode();
    _secondPinFocusNode = FocusNode();

    keyPressedSubscription =
        ref.read(pinKeyboardProvider).keyPressedSubject.listen((pinKey) {
      ref.read(pinSetupProvider).onKeyEntered(pinKey);
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
      backgroundColor: const Color(0xFF135579),
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: 'Protect your wallet'.tr(),
        onPressed: () {
          ref.read(pinSetupProvider).onBack();
        },
      ),
      onWillPop: () async {
        ref.read(pinSetupProvider).onBack();
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
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: Color(0xFF23729D),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          'Set your PIN (6-8 digits)'.tr(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C5FF),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 16, right: 16),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final pin = ref.watch(pinSetupProvider).firstPin;
                            final fieldState =
                                ref.watch(pinSetupProvider).fieldState;
                            if (fieldState == PinFieldState.firstPin) {
                              _firstPinFocusNode.requestFocus();
                            }
                            final enabled =
                                ref.watch(pinSetupProvider).firstPinEnabled;

                            return PinTextField(
                              enabled: enabled,
                              pin: pin,
                              focusNode: _firstPinFocusNode,
                              onTap: ref.read(pinSetupProvider).onTap,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: Text(
                          'Confirm your PIN'.tr(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C5FF),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 16, right: 16),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final pin = ref.watch(pinSetupProvider).secondPin;
                            final fieldState =
                                ref.watch(pinSetupProvider).fieldState;
                            if (fieldState == PinFieldState.secondPin) {
                              _secondPinFocusNode.requestFocus();
                            }
                            final enabled =
                                ref.watch(pinSetupProvider).secondPinEnabled;
                            final state = ref.watch(pinSetupProvider).state;
                            final errorMessage =
                                ref.watch(pinSetupProvider).errorMessage;

                            return PinTextField(
                              enabled: enabled,
                              error: state == PinSetupStateEnum.error,
                              errorMessage: errorMessage,
                              pin: pin,
                              focusNode: _secondPinFocusNode,
                              onTap: ref.read(pinSetupProvider).onTap,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final isNewWallet =
                                ref.read(pinSetupProvider).isNewWallet;
                            final isPinEnabled =
                                ref.watch(pinAvailableProvider);
                            return PinKeyboard(
                              acceptType: isNewWallet
                                  ? ref.watch(pinSetupProvider).fieldState ==
                                          PinFieldState.secondPin
                                      ? PinKeyboardAcceptType.save
                                      : PinKeyboardAcceptType.icon
                                  : isPinEnabled
                                      ? PinKeyboardAcceptType.disable
                                      : PinKeyboardAcceptType.enable,
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
