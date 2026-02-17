import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';

class UiStatesListener extends HookConsumerWidget {
  const UiStatesListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pegRepository = ref.watch(pegRepositoryProvider);
    final walletMainArguments = ref.watch(uiStateArgsProvider);
    final libClientState = ref.watch(libClientStateProvider);
    final serverConnected = ref.watch(serverConnectionProvider);

    ref.listen(uiStateArgsProvider, (prev, next) {
      (switch (prev?.navigationItemEnum) {
        // cleanup when leaving swap markets page
        WalletMainNavigationItemEnum.swap => () {
          ref.read(quoteEventProvider.notifier).stopQuotes();
        },
        // cleanup when leaving instant swap page
        WalletMainNavigationItemEnum.markets => () {
          ref.read(chartsProvider.notifier).chartUnsubscribe();
          ref.read(quoteEventProvider.notifier).stopQuotes();
          ref.read(marketPublicOrdersProvider.notifier).marketUnsubscribe();
        },
        _ => () {},
      })();
    });

    useEffect(
      () {
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
