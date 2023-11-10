import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_text_field.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class DPinSetup extends ConsumerWidget {
  const DPinSetup({super.key, this.onEscapeKey});

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
              Future.microtask(() {
                if (ref.read(pinSetupProvider).isNewWallet) {
                  ref.read(walletProvider).setNewWalletPinWelcome();
                  return;
                }
                ref.read(pinSetupProvider).onBack();
              });
            },
        content: const DPinSetupContent(),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          ref.read(walletProvider).settingsViewPage();
          return true;
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
                width: 266,
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
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstPinOldValue = useState('');
    final secondPinOldValue = useState('');
    final firstPinFocusNode = useFocusNode(skipTraversal: true);
    final secondPinFocusNode = useFocusNode(skipTraversal: true);

    useEffect(() {
      firstPinFocusNode.requestFocus();
      firstPinFocusNode.addListener(() {
        if (firstPinFocusNode.hasFocus) {
          Future.microtask(() => ref.read(pinSetupProvider).setFirstPinState());
        }
      });
      return;
    }, [firstPinFocusNode]);

    useEffect(() {
      secondPinFocusNode.addListener(() {
        if (secondPinFocusNode.hasFocus) {
          Future.microtask(
              () => ref.read(pinSetupProvider).setSecondPinState());
        }
      });
      return;
    }, [secondPinFocusNode]);

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
          !firstPinFocusNode.hasFocus) {
        firstPinFocusNode.requestFocus();
      }

      if (next.fieldState == PinFieldState.secondPin &&
          !secondPinFocusNode.hasFocus) {
        secondPinFocusNode.requestFocus();
      }
    });

    final isNewWallet = ref.read(pinSetupProvider).isNewWallet;
    final isPinEnabled = ref.watch(pinAvailableProvider);

    final firstPinKeyboardFocusNode = useFocusNode();
    final secondPinKeyboardFocusNode = useFocusNode();

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
                  'Set your PIN (6-8 digits)'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
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
                    firstPinFocusNode.requestFocus();
                  }
                  final enabled = ref.watch(pinSetupProvider).firstPinEnabled;

                  return RawKeyboardListener(
                    focusNode: firstPinKeyboardFocusNode,
                    onKey: (RawKeyEvent event) {
                      if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
                        secondPinFocusNode.requestFocus();
                      }
                    },
                    child: DPinTextField(
                      focusNode: firstPinFocusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      enabled: enabled,
                      pin: pin,
                      onChanged: (value) {
                        ref
                            .read(pinKeyboardProvider)
                            .onDesktopKeyChanged(firstPinOldValue.value, value);
                      },
                      onSubmitted: (_) {
                        ref.read(pinKeyboardProvider).keyPressed(11);
                      },
                    ),
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
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
                    secondPinFocusNode.requestFocus();
                  }
                  final enabled = ref.watch(pinSetupProvider).secondPinEnabled;
                  final state = ref.watch(pinSetupProvider).state;
                  final errorMessage = ref.watch(pinSetupProvider).errorMessage;
                  return RawKeyboardListener(
                    focusNode: secondPinKeyboardFocusNode,
                    onKey: (RawKeyEvent event) {
                      if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
                        firstPinFocusNode.requestFocus();
                      }
                    },
                    child: DPinTextField(
                      focusNode: secondPinFocusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      enabled: enabled,
                      pin: pin,
                      error: state == PinSetupStateEnum.error,
                      errorMessage: errorMessage,
                      onChanged: (value) {
                        ref.read(pinKeyboardProvider).onDesktopKeyChanged(
                            secondPinOldValue.value, value);
                      },
                      onSubmitted: (_) {
                        ref.read(pinKeyboardProvider).keyPressed(11);
                      },
                    ),
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
