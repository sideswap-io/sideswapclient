import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/pin_welcome.dart';

class NewWalletPinWelcome extends StatelessWidget {
  const NewWalletPinWelcome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinWelcome(
      onYesPressed: () {
        context.read(walletProvider).setPinSetup(
          onSuccessCallback: (BuildContext context) {
            context.read(walletProvider).newWalletBackupPrompt();
          },
          onBackCallback: (BuildContext context) async {
            await context.read(walletProvider).setNewWalletPinWelcome();
          },
        );
      },
      onNoPressed: () async {
        // important - clear new wallet state in pin provider!
        context.read(pinSetupProvider).isNewWallet = false;
        await context.read(walletProvider).newWalletBiometricPrompt();
      },
    );
  }
}
