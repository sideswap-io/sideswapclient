import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
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
      backgroundColor: const Color(0xFF135579),
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: title ?? 'Unlock your wallet'.tr(),
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
                  child: PinProtectionBody(
                    iconType: iconType,
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

class PinProtectionBody extends ConsumerStatefulWidget {
  const PinProtectionBody({
    super.key,
    required this.iconType,
  });

  final PinKeyboardAcceptType iconType;

  @override
  PinProtectionBodyState createState() => PinProtectionBodyState();
}

class PinProtectionBodyState extends ConsumerState<PinProtectionBody> {
  late FocusNode pinFocusNode;
  StreamSubscription<PinKey>? keyPressedSubscription;

  @override
  void initState() {
    pinFocusNode = FocusNode();

    keyPressedSubscription =
        ref.read(pinKeyboardProvider).keyPressedSubject.listen((pinKey) {
      ref.read(pinProtectionProvider).onKeyEntered(pinKey);
    });

    pinFocusNode.requestFocus();
    ref.read(pinProtectionProvider).init(onUnlockCallback: () {
      Navigator.of(context).pop(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    keyPressedSubscription?.cancel();
    pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              'Enter your PIN'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00C5FF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Consumer(
              builder: (context, ref, _) {
                final pin =
                    ref.watch(pinProtectionProvider.select((p) => p.pinCode));
                final state =
                    ref.watch(pinProtectionProvider.select((p) => p.state));
                final errorMessage = ref
                    .watch(pinProtectionProvider.select((p) => p.errorMessage));

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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Consumer(
              builder: ((context, ref, _) {
                final isNewWallet = ref.read(pinSetupProvider).isNewWallet;
                return PinKeyboard(
                  acceptType: isNewWallet
                      ? ref.watch(pinSetupProvider).fieldState ==
                              PinFieldState.secondPin
                          ? PinKeyboardAcceptType.save
                          : PinKeyboardAcceptType.icon
                      : widget.iconType,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
