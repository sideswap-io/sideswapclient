import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_text_field.dart';

class PinSetup extends HookConsumerWidget {
  const PinSetup({super.key});
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

    return SideSwapScaffold(
      backgroundColor: SideSwapColors.chathamsBlue,
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: 'Protect your wallet'.tr(),
        onPressed: () {
          ref.read(pinHelperProvider).onBack();
        },
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(pinHelperProvider).onBack();
        }
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
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 16,
                            right: 16,
                          ),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final firstPin = ref.watch(
                                firstPinNotifierProvider,
                              );
                              final pinFieldState = ref.watch(
                                pinFieldStateNotifierProvider,
                              );
                              if (pinFieldState == const PinFieldStateFirst()) {
                                firstPinFocusNode.requestFocus();
                              }
                              final firstPinEnabled = ref.watch(
                                firstPinEnabledProvider,
                              );

                              return PinTextField(
                                enabled: firstPinEnabled,
                                pin: firstPin,
                                focusNode: firstPinFocusNode,
                                onTap: ref.read(pinHelperProvider).onTap,
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
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 16,
                            right: 16,
                          ),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final secondPin = ref.watch(
                                secondPinNotifierProvider,
                              );
                              final pinFieldState = ref.watch(
                                pinFieldStateNotifierProvider,
                              );
                              if (pinFieldState ==
                                  const PinFieldState.second()) {
                                secondPinFocusNode.requestFocus();
                              }
                              final secondPinEnabled = ref.watch(
                                secondPinEnabledProvider,
                              );
                              final pinSetupState = ref.watch(
                                pinSetupStateNotifierProvider,
                              );
                              final errorMessage =
                                  (pinSetupState is PinSetupStateError)
                                      ? pinSetupState.message
                                      : '';

                              return PinTextField(
                                enabled: secondPinEnabled,
                                error: (pinSetupState is PinSetupStateError),
                                errorMessage: errorMessage,
                                pin: secondPin,
                                focusNode: secondPinFocusNode,
                                onTap: ref.read(pinHelperProvider).onTap,
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final firstLaunchState = ref.watch(
                                firstLaunchStateNotifierProvider,
                              );
                              final isPinEnabled = ref.watch(
                                pinAvailableProvider,
                              );
                              final pinFieldState = ref.watch(
                                pinFieldStateNotifierProvider,
                              );
                              return PinKeyboard(
                                acceptType:
                                    firstLaunchState !=
                                            const FirstLaunchStateEmpty()
                                        ? pinFieldState ==
                                                const PinFieldState.second()
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
          },
        ),
      ),
    );
  }
}
