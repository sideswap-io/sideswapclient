import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/wallet_biometric_prompt.dart';

class ImportWalletBiometricPrompt extends StatelessWidget {
  const ImportWalletBiometricPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WalletBiometricPrompt(
      onYesPressed: () async {
        if (await context.read(walletProvider).walletBiometricEnable() ==
            false) {
          return;
        }

        if (FlavorConfig.isProduction() &&
            FlavorConfig.instance.values.enableOnboardingUserFeatures) {
          context.read(walletProvider).setImportAvatar();
        } else {
          await context.read(walletProvider).loginAndLoadMainPage();
        }
      },
      onNoPressed: () async {
        if (await context.read(walletProvider).walletBiometricSkip() == false) {
          return;
        }

        if (FlavorConfig.isProduction() &&
            FlavorConfig.instance.values.enableOnboardingUserFeatures) {
          context.read(walletProvider).setImportAvatar();
        } else {
          await context.read(walletProvider).loginAndLoadMainPage();
        }
      },
    );
  }
}
