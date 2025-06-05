import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class PinListener extends ConsumerWidget {
  const PinListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pinSetupCallerNotifierProvider, (_, _) {});
    ref.listen<PinSetupExitState>(pinSetupExitNotifierProvider, (_, next) {
      final caller = ref.read(pinSetupCallerNotifierProvider);

      (switch (next) {
        PinSetupExitStateBack() => () {
          (switch (caller) {
            PinSetupCallerStateSettings() => () {
              ref.read(walletProvider).settingsViewPage();
            },
            PinSetupCallerStatePinWelcome() => () async {
              await ref.read(walletProvider).setPinWelcome();
            },
            PinSetupCallerStateNewWalletPinWelcome() => () {
              ref.read(walletProvider).setNewWalletPinWelcome();
            },
            _ => () {},
          }());
        },
        PinSetupExitStateSuccess() => () {
          (switch (caller) {
            PinSetupCallerStateSettings() => () {
              ref.read(walletProvider).settingsViewPage();
            },
            PinSetupCallerStatePinWelcome() => () {
              ref.read(walletProvider).loginAndLoadMainPage();
            },
            PinSetupCallerStateNewWalletPinWelcome() => () {
              ref.read(walletProvider).newWalletBackupPrompt();
            },
            _ => () {},
          }());
        },
        _ => () {},
      }());

      ref
          .read(pinSetupCallerNotifierProvider.notifier)
          .setPinSetupCallerState(const PinSetupCallerState.empty());
    });
    return const SizedBox();
  }
}
