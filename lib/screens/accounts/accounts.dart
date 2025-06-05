import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/wallet_assets.dart';

class Accounts extends HookConsumerWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Flexible(
          child: Stack(
            children: [
              WalletAssets(),
              Consumer(
                builder: (context, ref, child) {
                  final syncComplete = ref.watch(syncCompleteStateProvider);
                  return switch (syncComplete) {
                    false => const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                    _ => const SizedBox(),
                  };
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
