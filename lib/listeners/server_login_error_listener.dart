import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

/// Answers a failed login at the root of the mobile app.
///
/// Everywhere except the locked screen this is unchanged: a modal, then
/// `Status.noWallet`, then the provider is invalidated.
class ServerLoginErrorListener extends HookConsumerWidget {
  const ServerLoginErrorListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverLoginState = ref.watch(serverLoginProvider);

    useEffect(() {
      switch (serverLoginState) {
        // ADR-0008 decision 3. A failed unlock does not claim the wallet is
        // gone: sending the user to CREATE NEW WALLET / IMPORT is a statement
        // about their wallet, and here it is false -- the encrypted mnemonic is
        // still on the device. WalletLocked renders the failure itself.
        //
        // It still invalidates, and that is not optional: FirstLaunchPage
        // disables all three of CREATE NEW WALLET, IMPORT and Jade while this
        // provider holds an error, and the provider is keepAlive, so a user who
        // later reaches Status.noWallet would face three dead buttons.
        //
        // Unqualified, so a null message is invalidated here too. The arm below
        // deliberately keeps its narrower pattern: widening it would give every
        // other caller a modal it does not have today.
        //
        // The Future.microtask is load-bearing, not ceremony. WalletLocked
        // captures the message into its own state, and this effect runs while
        // that screen is still being built on the cold-start path -- deferring
        // the invalidate is what lets the screen observe the error before it is
        // cleared. Inlining it empties the screen.
        case ServerLoginStateError()
            when ref.read(pageStatusProvider) == Status.lockedWalet:
          Future.microtask(() {
            ref.invalidate(serverLoginProvider);
          });
        case ServerLoginStateError(message: final String msg):
          Future.microtask(() async {
            await ref.read(utilsProvider).showErrorDialog(msg);
            ref.read(pageStatusProvider.notifier).setStatus(Status.noWallet);
            ref.invalidate(serverLoginProvider);
          });
        default:
          break;
      }

      return;
    }, [serverLoginState]);

    return const SizedBox();
  }
}
