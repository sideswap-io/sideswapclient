import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_text_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:easy_localization/easy_localization.dart';
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

    final pinOldValue = useState('');

    useEffect(() {
      focusNode.requestFocus();
      ref.read(pinProtectionProvider).init(
        onUnlockCallback: () {
          Navigator.of(context).pop(true);
        },
        onUnlockFailedCallback: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            focusNode.requestFocus();
          });
        },
      );
      return;
    }, [focusNode]);

    useEffect(() {
      final subscription =
          ref.read(pinKeyboardProvider).keyPressedSubject.listen((pinKey) {
        Future.microtask(
            () => ref.read(pinProtectionProvider).onKeyEntered(pinKey));
      });
      return subscription.cancel;
    }, [ref.read(pinKeyboardProvider).keyPressedSubject]);

    ref.listen<PinProtectionProvider>(pinProtectionProvider, (_, next) {
      pinOldValue.value = next.pinCode;
      focusNode.requestFocus();
    });

    final isNewWallet = ref.read(pinSetupProvider).isNewWallet;

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
                      final pin = ref.watch(
                          pinProtectionProvider.select((p) => p.pinCode));
                      final state = ref
                          .watch(pinProtectionProvider.select((p) => p.state));
                      final errorMessage = ref.watch(
                          pinProtectionProvider.select((p) => p.errorMessage));

                      return DPinTextField(
                        focusNode: focusNode,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        pin: pin,
                        enabled: state != PinProtectionState.waiting,
                        error: state == PinProtectionState.error,
                        errorMessage: errorMessage,
                        onChanged: (value) {
                          ref
                              .read(pinKeyboardProvider)
                              .onDesktopKeyChanged(pinOldValue.value, value);
                        },
                        onSubmitted: (_) {
                          ref.read(pinKeyboardProvider).keyPressed(11);
                        },
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: DPinKeyboard(
                    width: 260,
                    height: 206,
                    acceptType: isNewWallet
                        ? ref.watch(pinSetupProvider).fieldState ==
                                PinFieldState.secondPin
                            ? PinKeyboardAcceptType.save
                            : PinKeyboardAcceptType.icon
                        : iconType,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      actions: showBackButton
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
              )
            ]
          : null,
    );
  }
}
