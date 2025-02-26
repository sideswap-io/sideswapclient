import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_keyboard.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_text_field.dart';

class PinProtection extends StatelessWidget {
  const PinProtection({
    super.key,
    this.title,
    this.iconType = PinKeyboardAcceptType.unlock,
  });

  final String? title;
  final PinKeyboardAcceptType iconType;

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      backgroundColor: SideSwapColors.chathamsBlue,
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: title ?? 'Unlock your wallet'.tr(),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(false);
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
                  child: PinProtectionBody(iconType: iconType),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PinProtectionBody extends HookConsumerWidget {
  const PinProtectionBody({required this.iconType, super.key});

  final PinKeyboardAcceptType iconType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinFocusNode = useFocusNode();

    final pinUnlockState = ref.watch(pinUnlockStateNotifierProvider);

    useAsyncEffect(() async {
      return switch (pinUnlockState) {
        PinUnlockStateEmpty() ||
        PinUnlockStateWrong() ||
        PinUnlockStateFailed() => () {}(),
        PinUnlockStateSuccess() => () {
          Navigator.of(context).pop(true);
        }(),
      };
    }, [pinUnlockState]);

    useEffect(() {
      pinFocusNode.requestFocus();
      ref.read(pinProtectionHelperProvider).init();

      return;
    }, const []);

    final pinKeyStream = ref.watch(pinKeyboardHelperProvider).pinKeyStream;

    useEffect(() {
      pinKeyStream.listen((pinKey) {
        ref.read(pinProtectionHelperProvider).onKeyEntered(pinKey);
      });

      return;
    }, [pinKeyStream]);

    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Divider(thickness: 1, height: 1, color: Color(0xFF23729D)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              'Enter your PIN'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Consumer(
              builder: (context, ref, _) {
                final pinCode = ref.watch(pinCodeProtectionNotifierProvider);
                final pinProtectionState = ref.watch(
                  pinProtectionStateNotifierProvider,
                );
                final errorMessage =
                    (pinProtectionState is PinProtectionStateError)
                        ? pinProtectionState.message ?? ''
                        : '';

                return PinTextField(
                  pin: pinCode,
                  enabled:
                      pinProtectionState != const PinProtectionState.waiting(),
                  error: pinProtectionState is PinProtectionStateError,
                  errorMessage: errorMessage,
                  focusNode: pinFocusNode,
                  onTap: () => pinFocusNode.requestFocus(),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Consumer(
              builder: ((context, ref, _) {
                final firstLaunchState = ref.watch(
                  firstLaunchStateNotifierProvider,
                );
                final pinFieldState = ref.watch(pinFieldStateNotifierProvider);
                return PinKeyboard(
                  acceptType:
                      firstLaunchState != const FirstLaunchState.empty()
                          ? pinFieldState == const PinFieldState.second()
                              ? PinKeyboardAcceptType.save
                              : PinKeyboardAcceptType.icon
                          : iconType,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
