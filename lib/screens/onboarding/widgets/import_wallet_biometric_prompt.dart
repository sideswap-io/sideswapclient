import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/wallet_biometric_prompt.dart';

class ImportWalletBiometricPrompt extends ConsumerWidget {
  const ImportWalletBiometricPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WalletBiometricPrompt(
      onYesPressed: () async {
        if (await ref.read(walletProvider).walletBiometricEnable() == false) {
          return;
        }

        ref.read(walletProvider).loginAndLoadMainPage();
      },
      onNoPressed: () async {
        if (await ref.read(walletProvider).walletBiometricSkip() == false) {
          return;
        }

        ref.read(walletProvider).loginAndLoadMainPage();
      },
    );
  }
}
