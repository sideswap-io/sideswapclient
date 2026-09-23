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
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';

/// Names the constant-height box that holds the message under the confirm
/// field.
const dPinSetupMessageReserveKey = Key('d-pin-setup-message-reserve');

/// The gap between the confirm field and the message under it.
const dPinSetupMessageGap = 8.0;

/// The height reserved under the confirm field, present whether or not there is
/// a message. Constant, so the field never changes size when a message appears.
/// ADR-0013 decision 8; the number is measured by
/// `test/widgets/pin_setup_message_reserve_test.dart`.
const dPinSetupMessageReserveHeight = 36.0;

/// The style the reserve is measured against.
const dPinSetupMessageTextStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: SideSwapColors.bitterSweet,
);

/// The width the message lays out in.
const dPinSetupFieldWidth = 344.0;

class DPinSetup extends ConsumerWidget {
  const DPinSetup({super.key, this.onEscapeKey});

  final VoidCallback? onEscapeKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeProvider)
        .defaultDialogTheme;

    final firstLaunchState = ref.watch(firstLaunchStateProvider);

    if (firstLaunchState != const FirstLaunchStateTypeEmpty()) {
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
          scrollOwner: ScrollOwner.wrapper,
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
    // Holds the auto-dispose helper up for as long as the screen is here, so
    // its `Ref` cannot die underneath the biometric await. It is not enough on
    // its own -- `_prepareToSendPin` re-checks `ref.mounted` too. ADR-0013
    // decision 16.
    ref.listen(pinHelperProvider, (_, _) {});

    final firstPinFocusNode = useFocusNode();
    final secondPinFocusNode = useFocusNode();

    // The one explicit trigger that returns focus to the confirm field. It is
    // scheduled rather than issued here: riverpod notifies synchronously, so
    // the field is still built disabled at this point and would refuse focus.
    // ADR-0013 decision 9.
    ref.listen(pinSetupStateProvider, (previous, next) {
      if (next is! PinSetupStateError || previous is PinSetupStateError) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }

        secondPinFocusNode.requestFocus();
      });
    });

    final pinKeyStream = ref.watch(pinKeyboardHelperProvider).pinKeyStream;

    useEffect(() {
      pinKeyStream.listen((pinKey) {
        ref.read(pinHelperProvider).onKeyEntered(pinKey);
      });

      return;
    }, [pinKeyStream]);

    ref.listen(pinKeyboardIndexProvider, (_, _) {});

    final pinFieldState = ref.watch(pinFieldStateProvider);

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
                .read(pinFieldStateProvider.notifier)
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
                .read(pinFieldStateProvider.notifier)
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
                  final firstPin = ref.watch(firstPinProvider);
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
                  final secondPin = ref.watch(secondPinProvider);
                  final secondPinEnabled = ref.watch(secondPinEnabledProvider);
                  final pinSetupState = ref.watch(pinSetupStateProvider);
                  final attempt = ref.watch(pinSetupAttemptProvider);
                  final overdue =
                      attempt is PinSetupAttemptStateOutstanding &&
                      attempt.overdue;

                  final message = switch (pinSetupState) {
                    PinSetupStateError(:final message) => message,
                    _ when overdue => pinSetupTakingLongerKey.tr(),
                    _ => '',
                  };

                  return Column(
                    children: [
                      DPinTextField(
                        focusNode: secondPinFocusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        enabled: secondPinEnabled,
                        pin: secondPin,
                        error: pinSetupState is PinSetupStateError,
                        onChanged: (value) {
                          ref
                              .read(pinKeyboardHelperProvider)
                              .onDesktopKeyChanged(secondPin, value);
                        },
                        onSubmitted: (_) {
                          ref.read(pinKeyboardHelperProvider).keyPressed(11);
                        },
                      ),
                      // The space is reserved whether or not there is a
                      // message, so the field never changes size when one
                      // appears. ADR-0013 decision 8.
                      SizedBox(
                        key: dPinSetupMessageReserveKey,
                        width: dPinSetupFieldWidth,
                        height: dPinSetupMessageReserveHeight,
                        child: message.isEmpty
                            ? null
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: dPinSetupMessageGap,
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    message,
                                    style: dPinSetupMessageTextStyle,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Consumer(
                builder: (context, ref, child) {
                  final firstLaunchState = ref.watch(firstLaunchStateProvider);

                  final acceptType = switch (firstLaunchState) {
                    FirstLaunchStateTypeEmpty() => switch (isPinEnabled) {
                      true => switch (pinFieldState) {
                        PinFieldStateSecond() => PinKeyboardAcceptType.disable,
                        _ => PinKeyboardAcceptType.icon,
                      },
                      _ => switch (pinFieldState) {
                        PinFieldStateSecond() => PinKeyboardAcceptType.enable,
                        _ => PinKeyboardAcceptType.icon,
                      },
                    },
                    _ => switch (pinFieldState) {
                      PinFieldStateSecond() => PinKeyboardAcceptType.save,
                      _ => PinKeyboardAcceptType.icon,
                    },
                  };

                  final keyboardEnabled = ref.watch(firstPinEnabledProvider);

                  return DPinKeyboard(
                    acceptType: acceptType,
                    enabled: keyboardEnabled,
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
