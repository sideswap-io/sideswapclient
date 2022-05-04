import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';

class UiStatesListener extends ConsumerWidget {
  const UiStatesListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UiStateArgsChangeNotifierProvider>(uiStateArgsProvider,
        (((_, next) {
      final navigationItem = next.walletMainArguments.navigationItem;

      if (navigationItem != WalletMainNavigationItem.markets) {
        if (ref.read(marketsProvider).subscribedMarket !=
            SubscribedMarket.none) {
          ref.read(marketsProvider).unsubscribeMarket();
        }
      }

      if (navigationItem != WalletMainNavigationItem.markets &&
          navigationItem != WalletMainNavigationItem.swap) {
        if (ref
            .read(marketsProvider)
            .subscribedIndexPriceAssetId()
            .isNotEmpty) {
          ref.read(marketsProvider).unsubscribeIndexPrice();
        }
      }

      if (navigationItem != WalletMainNavigationItem.swap) {
        ref.read(walletProvider).unsubscribeFromPriceStream();
      }
    })));

    return Container();
  }
}
