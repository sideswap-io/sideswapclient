import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

class PinListener extends ConsumerWidget {
  const PinListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pinSetupCallerStateProvider, (_, __) {});
    ref.listen<PinSetupExitState>(pinSetupExitStateProvider, (_, next) {
      final caller = ref.read(pinSetupCallerStateProvider);
      next.when(
          empty: () {},
          back: () {
            caller.when(
                empty: () {},
                settings: () {
                  ref.read(walletProvider).settingsViewPage();
                },
                pinWelcome: () async {
                  await ref.read(walletProvider).setPinWelcome();
                },
                newWalletPinWelcome: () {
                  ref.read(walletProvider).setNewWalletPinWelcome();
                });
          },
          success: () {
            caller.when(
                empty: () {},
                settings: () {
                  ref.read(walletProvider).settingsViewPage();
                },
                pinWelcome: () {
                  if (FlavorConfig.isProduction &&
                      FlavorConfig.enableOnboardingUserFeatures) {
                    ref.read(walletProvider).setImportAvatar();
                  } else {
                    ref.read(walletProvider).loginAndLoadMainPage();
                  }
                },
                newWalletPinWelcome: () {
                  ref.read(walletProvider).newWalletBackupPrompt();
                });
          });

      ref.read(pinSetupCallerStateProvider.notifier).state =
          const PinSetupCallerState.empty();
    });
    return Container();
  }
}
