import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/screens/accounts/accounts.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/home/home.dart';
import 'package:sideswap/screens/markets/markets.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/swap/swap.dart';
import 'package:sideswap/screens/wallet_main/widgets/main_bottom_navigation_bar.dart';

class WalletMain extends HookConsumerWidget {
  const WalletMain({super.key});

  Future<bool> closeApp() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBackPressTime = useState(DateTime.now());

    return Consumer(
      builder: (context, ref, _) {
        final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);
        final currentPageIndex = walletMainArguments.currentIndex;
        final navigationItemEnum = walletMainArguments.navigationItemEnum;

        return SideSwapScaffold(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) {
              return;
            }
            if (currentPageIndex == 0 &&
                navigationItemEnum == WalletMainNavigationItemEnum.home) {
              final now = DateTime.now();
              if (now.difference(currentBackPressTime.value) >
                  const Duration(seconds: 2, milliseconds: 700)) {
                currentBackPressTime.value = now;
                Flushbar(
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
                  backgroundColor: SideSwapColors.chathamsBlueDark,
                  onTap: (flushbar) async {
                    await flushbar.dismiss();
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
                ).show(context);
              } else {
                await closeApp();
              }
            }
          },
          body: const SafeArea(
            child: WalletMainChildPage(),
          ),
          bottomNavigationBar: MainBottomNavigationBar(
            onTap: (index) {
              ref.read(swapHelperProvider).swapReset();

              final newWalletMainArguments =
                  walletMainArguments.fromIndex(index);
              ref
                  .read(uiStateArgsNotifierProvider.notifier)
                  .setWalletMainArguments(newWalletMainArguments);

              final navigationItemEnum =
                  newWalletMainArguments.navigationItemEnum;
              (switch (navigationItemEnum) {
                WalletMainNavigationItemEnum.pegs =>
                  ref.read(swapHelperProvider).switchToPegs(),
                WalletMainNavigationItemEnum.swap =>
                  ref.read(swapHelperProvider).switchToSwaps(),
                WalletMainNavigationItemEnum.markets => ref
                    .read(selectedMarketTypeButtonNotifierProvider.notifier)
                    .setSelectedMarketType(SelectedMarketTypeButtonEnum.swap),
                _ => () {}(),
              });
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
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);
    final navigationItemEnum = walletMainArguments.navigationItemEnum;

    return switch (navigationItemEnum) {
      WalletMainNavigationItemEnum.home => const Home(),
      WalletMainNavigationItemEnum.accounts => const Accounts(),
      WalletMainNavigationItemEnum.assetDetails => const AssetDetails(),
      WalletMainNavigationItemEnum.markets => const Markets(),
      WalletMainNavigationItemEnum.swap => const SwapMain(key: ValueKey(false)),
      WalletMainNavigationItemEnum.pegs => const SwapMain(key: ValueKey(true)),
      _ => const SizedBox(),
    };
  }
}
