import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/wallet_biometric_prompt.dart';

class NewWalletBiometricPrompt extends ConsumerWidget {
  const NewWalletBiometricPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WalletBiometricPrompt(
      onYesPressed: () async {
        if (!await ref.read(walletProvider).walletBiometricEnable()) {
          return;
        }

        ref.read(walletProvider).newWalletBackupPrompt();
      },
      onNoPressed: () async {
        if (!await ref.read(walletProvider).walletBiometricSkip()) {
          return;
        }

        ref.read(walletProvider).newWalletBackupPrompt();
      },
    );
  }
}
