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
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
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
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;

    final firstLaunchState = ref.watch(firstLaunchStateNotifierProvider);

    if (firstLaunchState != const FirstLaunchStateEmpty()) {
      return SideSwapScaffoldPage(
        onEscapeKey:
            onEscapeKey ??
            () {
              Future.microtask(() {
                ref.read(walletProvider).setNewWalletPinWelcome();
                ref.read(pinHelperProvider).onBack();
              });
            },
        content: const DPinSetupContent(),
      );
    } else {
      return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            ref.read(walletProvider).settingsViewPage();
          }
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
                child: Text('BACK'.tr()),
              ),
            ),
          ],
          style: const DContentDialogThemeData().merge(defaultDialogTheme),
          constraints: const BoxConstraints(maxWidth: 580, maxHeight: 645),
          content: const DPinSetupContent(),
        ),
      );
    }
  }
}

class DPinSetupContent extends HookConsumerWidget {
  const DPinSetupContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstPinFocusNode = useFocusNode();
    final secondPinFocusNode = useFocusNode();

    final pinKeyStream = ref.watch(pinKeyboardHelperProvider).pinKeyStream;

    useEffect(() {
      pinKeyStream.listen((pinKey) {
        ref.read(pinHelperProvider).onKeyEntered(pinKey);
      });

      return;
    }, [pinKeyStream]);

    ref.listen(pinKeyboardIndexProvider, (_, __) {});

    final pinFieldState = ref.watch(pinFieldStateNotifierProvider);

    useEffect(() {
      if (pinFieldState == const PinFieldState.first() &&
          !firstPinFocusNode.hasFocus) {
        firstPinFocusNode.requestFocus();
      }

      if (pinFieldState == const PinFieldState.second() &&
          !secondPinFocusNode.hasFocus) {
        secondPinFocusNode.requestFocus();
      }
      return;
    }, [pinFieldState]);

    final isPinEnabled = ref.watch(pinAvailableProvider);

    useEffect(() {
      firstPinFocusNode.addListener(() {
        if (firstPinFocusNode.hasFocus) {
          Future.microtask(() {
            ref
                .read(pinFieldStateNotifierProvider.notifier)
                .setPinFieldState(const PinFieldState.first());
          });
        }
      });
      return;
    }, [firstPinFocusNode]);

    useEffect(() {
      secondPinFocusNode.addListener(() {
        if (secondPinFocusNode.hasFocus) {
          Future.microtask(() {
            ref
                .read(pinFieldStateNotifierProvider.notifier)
                .setPinFieldState(const PinFieldState.second());
          });
        }
      });
      return;
    }, [secondPinFocusNode]);

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
                  final firstPin = ref.watch(firstPinNotifierProvider);
                  final firstPinEnabled = ref.watch(firstPinEnabledProvider);

                  return DPinTextField(
                    focusNode: firstPinFocusNode,
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    enabled: firstPinEnabled,
                    pin: firstPin,
                    onChanged: (value) {
                      ref
                          .read(pinKeyboardHelperProvider)
                          .onDesktopKeyChanged(firstPin, value);
                    },
                    onSubmitted: (_) {
                      ref.read(pinKeyboardHelperProvider).keyPressed(11);
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
                  final secondPin = ref.watch(secondPinNotifierProvider);
                  if (pinFieldState == const PinFieldState.second()) {
                    secondPinFocusNode.requestFocus();
                  }
                  final secondPinEnabled = ref.watch(secondPinEnabledProvider);
                  final pinSetupState = ref.watch(
                    pinSetupStateNotifierProvider,
                  );
                  final errorMessage =
                      (pinSetupState is PinSetupStateError)
                          ? pinSetupState.message
                          : '';

                  return DPinTextField(
                    focusNode: secondPinFocusNode,
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    enabled: secondPinEnabled,
                    pin: secondPin,
                    error: pinSetupState is PinSetupStateError,
                    errorMessage: errorMessage,
                    onChanged: (value) {
                      ref
                          .read(pinKeyboardHelperProvider)
                          .onDesktopKeyChanged(secondPin, value);
                    },
                    onSubmitted: (_) {
                      ref.read(pinKeyboardHelperProvider).keyPressed(11);
                    },
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Consumer(
                builder: (context, ref, child) {
                  final firstLaunchState = ref.watch(
                    firstLaunchStateNotifierProvider,
                  );

                  return DPinKeyboard(
                    acceptType:
                        (firstLaunchState != const FirstLaunchStateEmpty())
                            ? pinFieldState == const PinFieldState.second()
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
    );
  }
}
