import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_text_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';

class DPinProtection extends HookConsumerWidget {
  const DPinProtection({
    super.key,
    this.title,
    this.showBackButton = true,
    this.iconType = PinKeyboardAcceptType.unlock,
  });

  final String? title;
  final bool showBackButton;
  final PinKeyboardAcceptType iconType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();

    final pinUnlockState = ref.watch(pinUnlockStateNotifierProvider);

    useAsyncEffect(() async {
      return switch (pinUnlockState) {
        PinUnlockStateEmpty() => () {}(),
        PinUnlockStateSuccess() => () {
          Navigator.of(context).pop(true);
        }(),
        PinUnlockStateFailed() => () {
          Navigator.of(context).pop(false);
        }(),
        PinUnlockStateWrong() => () {
          focusNode.requestFocus();
        }(),
      };
    }, [pinUnlockState]);

    useEffect(() {
      focusNode.requestFocus();
      ref.read(pinProtectionHelperProvider).init();
      return;
    }, [focusNode]);

    final pinKeyStream = ref.watch(pinKeyboardHelperProvider).pinKeyStream;

    useEffect(() {
      pinKeyStream.listen((pinKey) {
        ref.read(pinProtectionHelperProvider).onKeyEntered(pinKey);
      });

      return;
    }, [pinKeyStream]);

    final pinCode = ref.watch(pinCodeProtectionNotifierProvider);

    useEffect(() {
      focusNode.requestFocus();

      return;
    }, [pinCode]);

    return SideSwapPopupPage(
      onClose: () {
        Navigator.of(context).pop(false);
      },
      hideClose: !showBackButton,
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 606),
      title: Center(child: Text(title ?? 'Unlock your wallet'.tr())),
      content: SizedBox(
        width: 580,
        height: 432,
        child: Center(
          child: SizedBox(
            width: 260,
            child: Column(
              children: [
                Text(
                  'Enter your PIN'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Consumer(
                    builder: ((context, ref, child) {
                      final pinProtectionState = ref.watch(
                        pinProtectionStateNotifierProvider,
                      );

                      return DPinTextField(
                        focusNode: focusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        pin: pinCode,
                        enabled:
                            pinProtectionState !=
                            const PinProtectionState.waiting(),
                        error: pinProtectionState is PinProtectionStateError,
                        errorMessage:
                            (pinProtectionState is PinProtectionStateError)
                                ? pinProtectionState.message ?? ''
                                : '',
                        onChanged: (value) {
                          ref
                              .read(pinKeyboardHelperProvider)
                              .onDesktopKeyChanged(pinCode, value);
                        },
                        onSubmitted: (_) {
                          ref.read(pinKeyboardHelperProvider).keyPressed(11);
                        },
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final firstLaunchState = ref.watch(
                        firstLaunchStateNotifierProvider,
                      );
                      final pinFieldState = ref.watch(
                        pinFieldStateNotifierProvider,
                      );

                      return DPinKeyboard(
                        width: 260,
                        height: 206,
                        acceptType:
                            (firstLaunchState != const FirstLaunchState.empty())
                                ? pinFieldState == const PinFieldState.second()
                                    ? PinKeyboardAcceptType.save
                                    : PinKeyboardAcceptType.icon
                                : iconType,
                      );
                    },
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      actions:
          showBackButton
              ? [
                Center(
                  child: DCustomTextBigButton(
                    width: 260,
                    height: 44,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Back'.tr()),
                  ),
                ),
              ]
              : null,
    );
  }
}
