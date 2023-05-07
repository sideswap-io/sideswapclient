import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:sideswap/screens/receive/asset_receive_popup.dart';
import 'package:sideswap/screens/markets/markets.dart';
import 'package:sideswap/screens/swap/swap.dart';
import 'package:sideswap/screens/wallet_main/widgets/main_bottom_navigation_bar.dart';

class WalletMain extends ConsumerStatefulWidget {
  const WalletMain({super.key});

  @override
  WalletMainState createState() => WalletMainState();
}

class WalletMainState extends ConsumerState<WalletMain> {
  DateTime currentBackPressTime = DateTime.now();
  MarketSelectedType selectedMarketType = MarketSelectedType.swap;

  Widget getChild(WalletMainNavigationItem navigationItem) {
    switch (navigationItem) {
      case WalletMainNavigationItem.home:
        return const Home();
      case WalletMainNavigationItem.homeAssetReceive:
      case WalletMainNavigationItem.assetReceive:
        return const AssetReceivePopup();
      case WalletMainNavigationItem.accounts:
        return const Accounts();
      case WalletMainNavigationItem.assetSelect:
        return const AssetSelectList();
      case WalletMainNavigationItem.assetDetails:
        return const AssetDetails();
      case WalletMainNavigationItem.transactions:
        return Container();
      case WalletMainNavigationItem.markets:
        return Markets(
          selectedMarketType: selectedMarketType,
          onOrdersPressed: () {
            setState(() {
              selectedMarketType = MarketSelectedType.orders;
            });
            ref.read(marketsProvider).unsubscribeMarket();
            ref.read(marketsProvider).unsubscribeIndexPrice();
          },
          onSwapPressed: () {
            setState(() {
              selectedMarketType = MarketSelectedType.swap;
            });
          },
        );
      case WalletMainNavigationItem.swap:
        return const SwapMain(key: ValueKey(false));
      case WalletMainNavigationItem.pegs:
        return const SwapMain(key: ValueKey(true));
    }
  }

  Future<bool> closeApp() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
              if (now.difference(currentBackPressTime) >
                  const Duration(seconds: 2, milliseconds: 700)) {
                currentBackPressTime = now;
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
                      if (now.difference(currentBackPressTime) <
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
          body: SafeArea(
            child: getChild(navigationItem),
          ),
          bottomNavigationBar: MainBottomNavigationBar(
            currentIndex: currentPageIndex,
            onTap: (index) {
              ref.read(swapProvider).swapReset();
              ref.read(uiStateArgsProvider).walletMainArguments =
                  walletMainArguments.fromIndex(index);
              if (ref
                      .read(uiStateArgsProvider)
                      .walletMainArguments
                      .navigationItem ==
                  WalletMainNavigationItem.pegs) {
                ref.read(swapProvider).switchToPegs();
              }
              if (ref
                      .read(uiStateArgsProvider)
                      .walletMainArguments
                      .navigationItem ==
                  WalletMainNavigationItem.swap) {
                ref.read(swapProvider).switchToSwaps();
              }
            },
          ),
        );
      },
    );
  }
}
