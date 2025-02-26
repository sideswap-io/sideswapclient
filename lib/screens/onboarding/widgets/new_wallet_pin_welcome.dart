import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/d_pin_welcome.dart';
import 'package:sideswap/providers/first_launch_providers.dart';

import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/pin_welcome.dart';

class NewWalletPinWelcome extends ConsumerWidget {
  const NewWalletPinWelcome({super.key});

  void onYesPressedCallback(WidgetRef ref) {
    ref.read(pinHelperProvider).initPinSetupNewWalletPinWelcome();
  }

  Future<void> onNoPressedCallback(
    WidgetRef ref,
    FirstLaunchState firstLaunchState,
  ) async {
    return switch (firstLaunchState) {
      FirstLaunchStateImportWallet() => () async {
        await ref.read(walletProvider).setImportWalletBiometricPrompt();
      }(),
      _ => () async {
        await ref.read(walletProvider).newWalletBiometricPrompt();
      }(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstLaunchState = ref.watch(firstLaunchStateNotifierProvider);

    return FlavorConfig.isDesktop
        ? DPinWelcome(
          onYesPressed: () {
            onYesPressedCallback(ref);
          },
          onNoPressed: () async {
            await onNoPressedCallback(ref, firstLaunchState);
          },
        )
        : PinWelcome(
          onYesPressed: () {
            onYesPressedCallback(ref);
          },
          onNoPressed: () async {
            await onNoPressedCallback(ref, firstLaunchState);
          },
        );
  }
}
