import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';

class UiStatesListener extends ConsumerWidget {
  const UiStatesListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(uiStateArgsNotifierProvider, (((_, next) {
      final navigationItemEnum = next.navigationItemEnum;

      if (navigationItemEnum != WalletMainNavigationItemEnum.markets) {
        ref
            .read(marketAssetSubscriberNotifierProvider.notifier)
            .unsubscribeAll();
      }

      if (navigationItemEnum != WalletMainNavigationItemEnum.markets &&
          navigationItemEnum != WalletMainNavigationItemEnum.swap) {
        if (ref.read(indexPriceSubscriberNotifierProvider).isNotEmpty) {
          ref
              .read(indexPriceSubscriberNotifierProvider.notifier)
              .unsubscribeAll();
        }
      }

      if (navigationItemEnum != WalletMainNavigationItemEnum.swap) {
        ref
            .read(subscribePriceStreamNotifierProvider.notifier)
            .unsubscribeFromPriceStream();
      }
    })));

    return const SizedBox();
  }
}
