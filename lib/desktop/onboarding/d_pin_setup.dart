import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_text_field.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/pin_available_provider.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DPinSetup extends ConsumerWidget {
  const DPinSetup({Key? key, this.onEscapeKey}) : super(key: key);

  final VoidCallback? onEscapeKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;

    final isNewWallet = ref.read(pinSetupProvider).isNewWallet;

    if (isNewWallet) {
      return SideSwapScaffoldPage(
        onEscapeKey: onEscapeKey ??
            () {
              ref.read(pinSetupProvider).onBack();
              if (ref.read(pinSetupProvider).isNewWallet) {
                ref.read(walletProvider).setNewWalletPinWelcome();
              }
            },
        content: const DPinSetupContent(),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          ref.read(walletProvider).settingsViewPage();
          return false;
        },
        child: DContentDialog(
          title: DContentDialogTitle(
            content: Text('Enable PIN protection'.tr()),
            onClose: () {
              ref.read(walletProvider).settingsViewPage();
            },
          ),
          actions: [
            Center(
              child: DCustomTextBigButton(
                onPressed: () {
                  ref.read(walletProvider).settingsViewPage();
                },
                child: Text(
                  'BACK'.tr(),
                ),
              ),
            ),
          ],
          style: const DContentDialogThemeData().merge(settingsDialogTheme),
          constraints: const BoxConstraints(maxWidth: 580, maxHeight: 645),
          content: const DPinSetupContent(),
        ),
      );
    }
  }
}

class DPinSetupContent extends HookConsumerWidget {
  const DPinSetupContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstPinOldValue = useState('');
    final secondPinOldValue = useState('');
    final _firstPinFocusNode = useFocusNode();
    final _secondPinFocusNode = useFocusNode();

    useEffect(() {
      _firstPinFocusNode.requestFocus();
      _firstPinFocusNode.addListener(() {
        if (_firstPinFocusNode.hasFocus) {
          Future.microtask(() => ref.read(pinSetupProvider).setFirstPinState());
        }
      });
      return;
    }, [_firstPinFocusNode]);

    useEffect(() {
      _secondPinFocusNode.addListener(() {
        if (_secondPinFocusNode.hasFocus) {
          Future.microtask(
              () => ref.read(pinSetupProvider).setSecondPinState());
        }
      });
      return;
    }, [_secondPinFocusNode]);

    useEffect(() {
      final subscription =
          ref.read(pinKeyboardProvider).keyPressedSubject.listen((value) {
        Future.microtask(() => ref.read(pinSetupProvider).onKeyEntered(value));
      });
      return subscription.cancel;
    }, [ref.read(pinKeyboardProvider).keyPressedSubject]);

    ref.listen(pinKeyboardIndexProvider, (_, __) {});
    ref.listen<PinSetupProvider>(pinSetupProvider, (_, next) {
      firstPinOldValue.value = next.firstPin;
      secondPinOldValue.value = next.secondPin;
      if (next.fieldState == PinFieldState.firstPin &&
          !_firstPinFocusNode.hasFocus) {
        _firstPinFocusNode.requestFocus();
      }

      if (next.fieldState == PinFieldState.secondPin &&
          !_secondPinFocusNode.hasFocus) {
        _secondPinFocusNode.requestFocus();
      }
    });

    final isNewWallet = ref.read(pinSetupProvider).isNewWallet;
    final isPinEnabled = ref.watch(pinAvailableProvider);

    return Center(
      child: SizedBox(
        width: 344,
        height: 458,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Set your PIN (6-8 chars)'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF00C5FF),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Consumer(
                builder: ((context, ref, child) {
                  final pin = ref.watch(pinSetupProvider).firstPin;
                  final fieldState = ref.watch(pinSetupProvider).fieldState;
                  if (fieldState == PinFieldState.firstPin) {
                    _firstPinFocusNode.requestFocus();
                  }
                  final enabled = ref.watch(pinSetupProvider).firstPinEnabled;

                  return DPinTextField(
                    focusNode: _firstPinFocusNode,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    enabled: enabled,
                    pin: pin,
                    onChanged: (value) {
                      if (firstPinOldValue.value == value) {
                        return;
                      }

                      if (firstPinOldValue.value.length > value.length) {
                        ref.read(pinKeyboardIndexProvider).pinIndex = 10;
                        ref.read(pinKeyboardProvider).keyPressed(9);
                        return;
                      }

                      final lastCharacter = value
                          .substring((value.length - 1).clamp(0, value.length));
                      final index = int.tryParse(lastCharacter) ?? -1;
                      ref.read(pinKeyboardIndexProvider).pinIndex = index;
                      ref.read(pinKeyboardProvider).keyPressed(index - 1);
                    },
                    onSubmitted: (_) {
                      ref.read(pinKeyboardProvider).keyPressed(11);
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirm your PIN'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF00C5FF),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Consumer(
                builder: ((context, ref, child) {
                  final pin = ref.watch(pinSetupProvider).secondPin;
                  final fieldState = ref.watch(pinSetupProvider).fieldState;
                  if (fieldState == PinFieldState.secondPin) {
                    _secondPinFocusNode.requestFocus();
                  }
                  final enabled = ref.watch(pinSetupProvider).secondPinEnabled;
                  final state = ref.watch(pinSetupProvider).state;
                  final errorMessage = ref.watch(pinSetupProvider).errorMessage;
                  return DPinTextField(
                    focusNode: _secondPinFocusNode,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    enabled: enabled,
                    pin: pin,
                    error: state == PinSetupState.error,
                    errorMessage: errorMessage,
                    onChanged: (value) {
                      if (secondPinOldValue.value == value) {
                        return;
                      }

                      if (secondPinOldValue.value.length > value.length) {
                        ref.read(pinKeyboardIndexProvider).pinIndex = 10;
                        ref.read(pinKeyboardProvider).keyPressed(9);
                        return;
                      }

                      final lastCharacter = value
                          .substring((value.length - 1).clamp(0, value.length));
                      final index = int.tryParse(lastCharacter) ?? -1;
                      ref.read(pinKeyboardIndexProvider).pinIndex = index;
                      ref.read(pinKeyboardProvider).keyPressed(index - 1);
                    },
                    onSubmitted: (_) {
                      ref.read(pinKeyboardProvider).keyPressed(11);
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: DPinKeyboard(
                acceptType: isNewWallet
                    ? ref.watch(pinSetupProvider).fieldState ==
                            PinFieldState.secondPin
                        ? PinKeyboardAcceptType.save
                        : PinKeyboardAcceptType.icon
                    : isPinEnabled
                        ? PinKeyboardAcceptType.disable
                        : PinKeyboardAcceptType.enable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
