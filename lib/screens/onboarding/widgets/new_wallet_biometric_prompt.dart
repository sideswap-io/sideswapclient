import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/wallet_biometric_prompt.dart';

class NewWalletBiometricPrompt extends ConsumerWidget {
  const NewWalletBiometricPrompt({super.key});

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
