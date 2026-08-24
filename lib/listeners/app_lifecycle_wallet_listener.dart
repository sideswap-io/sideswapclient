import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/app_state_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class AppLifecycleWalletListener extends ConsumerWidget {
  const AppLifecycleWalletListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(currentAppLifecycleProvider, (prev, next) {
      next.match(
        () {},
        (state) => ref.read(walletProvider).handleAppStateChange(state),
      );
    });
    return const SizedBox();
  }
}
