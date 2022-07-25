import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';

import 'package:sideswap/desktop/d_home.dart';
import 'package:sideswap/desktop/d_main_bottom_navigation_bar.dart';
import 'package:sideswap/desktop/d_tx_history.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/locales_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/accounts/assets_list.dart';
import 'package:sideswap/screens/swap/swap.dart';

class DesktopWalletMain extends ConsumerStatefulWidget {
  const DesktopWalletMain({super.key});

  @override
  WalletMainState createState() => WalletMainState();
}

class WalletMainState extends ConsumerState<DesktopWalletMain> {
  Widget getChild(WalletMainNavigationItem navigationItem) {
    switch (navigationItem) {
      case WalletMainNavigationItem.home:
        return const DesktopHome();
      case WalletMainNavigationItem.homeAssetReceive:
      case WalletMainNavigationItem.assetReceive:
        return Container();
      case WalletMainNavigationItem.accounts:
        return Container();
      case WalletMainNavigationItem.assetSelect:
        return const AssetSelectList();
      case WalletMainNavigationItem.assetDetails:
        return const AssetDetails();
      case WalletMainNavigationItem.transactions:
        return const DesktopTxHistory();
      case WalletMainNavigationItem.markets:
        return const DMarkets();
      case WalletMainNavigationItem.swap:
        return const DSwapMain(key: ValueKey(false));
      case WalletMainNavigationItem.pegs:
        return const DSwapMain(key: ValueKey(true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final walletMainArguments =
            ref.watch(uiStateArgsProvider.select((p) => p.walletMainArguments));
        final currentPageIndex = walletMainArguments.currentIndex;
        final navigationItem = walletMainArguments.navigationItem;

        return SideSwapScaffoldPage(
          header: const TopToolbar(),
          content: Column(
            children: [
              Expanded(child: getChild(navigationItem)),
            ],
          ),
          bottomBar: DesktopMainBottomNavigationBar(
            currentIndex: currentPageIndex,
            onTap: (index) {
              ref.read(swapProvider).swapReset();
              ref.read(uiStateArgsProvider).walletMainArguments =
                  walletMainArguments.fromIndexDesktop(index);
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

class DSwapMain extends StatelessWidget {
  const DSwapMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Column(
          children: [
            const SizedBox(height: 28),
            Container(
              width: 570,
              height: 551,
              color: const Color(0xFF043857),
              child: const SwapMain(),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class TopToolbar extends ConsumerWidget {
  const TopToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localesProvider).selectedLang(context);
    return Container(
      key: ValueKey(lang),
      color: const Color(0xFF021C36),
      height: 34,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DTopToolbarButton(
            name: 'Send'.tr(),
            icon: 'assets/toolbar/send.svg',
            onPressed: () {
              desktopShowSendTx(context, ref);
            },
          ),
          DTopToolbarButton(
            name: 'Receive'.tr(),
            icon: 'assets/toolbar/recv.svg',
            onPressed: () {
              desktopShowRecvAddress(context, ref);
            },
          ),
          DTopToolbarButton(
            name: 'URL'.tr(),
            icon: 'assets/toolbar/open_url.svg',
            onPressed: () {
              desktopOpenUrl(context);
            },
          ),
          DTopToolbarButton(
            name: '',
            icon: 'assets/toolbar/settings.svg',
            onPressed: () {
              ref.read(walletProvider).settingsViewPage();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
