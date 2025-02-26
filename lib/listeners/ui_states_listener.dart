import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';

class UiStatesListener extends HookConsumerWidget {
  const UiStatesListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pegRepository = ref.watch(pegRepositoryProvider);
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);
    final libClientState = ref.watch(libClientStateProvider);
    final serverConnected = ref.watch(serverConnectionNotifierProvider);

    useEffect(
      () {
        if (walletMainArguments.navigationItemEnum !=
            WalletMainNavigationItemEnum.swap) {
          ref
              .read(subscribePriceStreamNotifierProvider.notifier)
              .unsubscribeFromPriceStream();
        }

        (switch (walletMainArguments.navigationItemEnum) {
          WalletMainNavigationItemEnum.pegs => () {},
          _ => pegRepository.setActivePage,
        }());

        return;
      },
      [walletMainArguments.navigationItemEnum, libClientState, serverConnected],
    );

    return const SizedBox();
  }
}
