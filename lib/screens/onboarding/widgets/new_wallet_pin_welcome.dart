import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/desktop/onboarding/d_pin_welcome.dart';

import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/pin_welcome.dart';

class NewWalletPinWelcome extends ConsumerWidget {
  const NewWalletPinWelcome({Key? key}) : super(key: key);

  void onYesPressedCallback(WidgetRef ref) {
    ref.read(pinSetupProvider).initPinSetupNewWalletPinWelcome();
  }

  Future<void> onNoPressedCallback(WidgetRef ref) async {
    // important - clear new wallet state in pin provider!
    ref.read(pinSetupProvider).isNewWallet = false;
    await ref.read(walletProvider).newWalletBiometricPrompt();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlavorConfig.isDesktop
        ? DPinWelcome(
            onYesPressed: () {
              onYesPressedCallback(ref);
            },
            onNoPressed: () async {
              await onNoPressedCallback(ref);
            },
          )
        : PinWelcome(
            onYesPressed: () {
              onYesPressedCallback(ref);
            },
            onNoPressed: () async {
              await onNoPressedCallback(ref);
            },
          );
  }
}
