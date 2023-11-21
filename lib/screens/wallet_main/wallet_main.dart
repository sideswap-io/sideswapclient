import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/screens/accounts/accounts.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/accounts/assets_list.dart';
import 'package:sideswap/screens/home/home.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/markets.dart';
import 'package:sideswap/screens/swap/swap.dart';
import 'package:sideswap/screens/wallet_main/widgets/main_bottom_navigation_bar.dart';

final selectedMarketTypeProvider =
    AutoDisposeStateProvider<MarketSelectedType>((ref) {
  ref.keepAlive();
  return MarketSelectedType.swap;
});

class WalletMain extends HookConsumerWidget {
  const WalletMain({super.key});

  // Widget getChild(WalletMainNavigationItem navigationItem) {
  //   return switch (navigationItem) {
  //     WalletMainNavigationItem.home => const Home(),
  //     WalletMainNavigationItem.accounts => const Accounts(),
  //     WalletMainNavigationItem.assetSelect => const AssetSelectList(),
  //     WalletMainNavigationItem.assetDetails => const AssetDetails(),
  //     WalletMainNavigationItem.markets => Markets(
  //         selectedMarketType: selectedMarketType,
  //         onOrdersPressed: () {
  //           ref.read(selectedMarketTypeProvider.notifier).state =
  //               MarketSelectedType.orders;
  //           ref.read(marketsProvider).unsubscribeMarket();
  //           ref.read(marketsProvider).unsubscribeIndexPrice();
  //         },
  //         onSwapPressed: () {
  //           ref.read(selectedMarketTypeProvider.notifier).state =
  //               MarketSelectedType.swap;
  //         },
  //       ),
  //     WalletMainNavigationItem.swap => const SwapMain(key: ValueKey(false)),
  //     WalletMainNavigationItem.pegs => const SwapMain(key: ValueKey(true)),
  //     _ => Container(),
  //   };
  // }

  Future<bool> closeApp() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBackPressTime = useState(DateTime.now());

    return Consumer(
      builder: (context, ref, _) {
        final walletMainArguments =
            ref.watch(uiStateArgsProvider.select((p) => p.walletMainArguments));
        final currentPageIndex = walletMainArguments.currentIndex;
        final navigationItem = walletMainArguments.navigationItem;

        return SideSwapScaffold(
          onWillPop: () async {
            if (currentPageIndex == 0 &&
                navigationItem == WalletMainNavigationItem.home) {
              final now = DateTime.now();
              if (now.difference(currentBackPressTime.value) >
                  const Duration(seconds: 2, milliseconds: 700)) {
                currentBackPressTime.value = now;
                final flushbar = Flushbar<Widget>(
                  messageText: Text(
                    'Press back again to exit'.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                  animationDuration: const Duration(milliseconds: 150),
                  backgroundColor: const Color(0xFF0F4766),
                  onTap: (flushbar) {
                    flushbar.dismiss();
                  },
                  onStatusChanged: (status) async {
                    if (status == FlushbarStatus.DISMISSED) {
                      final now = DateTime.now();
                      if (now.difference(currentBackPressTime.value) <
                          const Duration(seconds: 3)) {
                        await closeApp();
                      }
                    }
                  },
                );
                await flushbar.show(context);
              } else {
                return closeApp();
              }

              return false;
            }
            ref.read(uiStateArgsProvider).walletMainArguments =
                walletMainArguments.fromIndex(0);
            return false;
          },
          body: const SafeArea(
            child: WalletMainChildPage(),
          ),
          bottomNavigationBar: MainBottomNavigationBar(
            currentIndex: currentPageIndex,
            onTap: (index) {
              ref.read(swapProvider).swapReset();

              final newWalletMainArguments =
                  walletMainArguments.fromIndex(index);
              ref.read(uiStateArgsProvider).walletMainArguments =
                  newWalletMainArguments;

              final navigationItem = newWalletMainArguments.navigationItem;
              switch (navigationItem) {
                case WalletMainNavigationItem.pegs:
                  ref.read(swapProvider).switchToPegs();
                  break;
                case WalletMainNavigationItem.swap:
                  ref.read(swapProvider).switchToSwaps();
                  break;
                case WalletMainNavigationItem.markets:
                  ref.read(selectedMarketTypeProvider.notifier).state =
                      MarketSelectedType.swap;
                  break;
                case _:
                  break;
              }
            },
          ),
        );
      },
    );
  }
}

class WalletMainChildPage extends ConsumerWidget {
  const WalletMainChildPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletMainArguments =
        ref.watch(uiStateArgsProvider.select((p) => p.walletMainArguments));
    final navigationItem = walletMainArguments.navigationItem;

    final selectedMarketType = ref.watch(selectedMarketTypeProvider);

    return switch (navigationItem) {
      WalletMainNavigationItem.home => const Home(),
      WalletMainNavigationItem.accounts => const Accounts(),
      WalletMainNavigationItem.assetSelect => const AssetSelectList(),
      WalletMainNavigationItem.assetDetails => const AssetDetails(),
      WalletMainNavigationItem.markets => Markets(
          selectedMarketType: selectedMarketType,
          onOrdersPressed: () {
            ref.read(selectedMarketTypeProvider.notifier).state =
                MarketSelectedType.orders;
            ref.read(marketsProvider).unsubscribeMarket();
            ref.read(marketsProvider).unsubscribeIndexPrice();
          },
          onSwapPressed: () {
            ref.read(selectedMarketTypeProvider.notifier).state =
                MarketSelectedType.swap;
          },
        ),
      WalletMainNavigationItem.swap => const SwapMain(key: ValueKey(false)),
      WalletMainNavigationItem.pegs => const SwapMain(key: ValueKey(true)),
      _ => Container(),
    };
  }
}
