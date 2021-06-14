import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/wallet_biometric_prompt.dart';

class NewWalletBiometricPrompt extends StatelessWidget {
  const NewWalletBiometricPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WalletBiometricPrompt(
      onYesPressed: () async {
        if (!await context.read(walletProvider).walletBiometricEnable()) {
          return;
        }

        context.read(walletProvider).newWalletBackupPrompt();
      },
      onNoPressed: () async {
        if (!await context.read(walletProvider).walletBiometricSkip()) {
          return;
        }

        context.read(walletProvider).newWalletBackupPrompt();
      },
    );
  }
}
