import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';
import 'package:sideswap/desktop/d_home.dart';

import 'package:sideswap/desktop/home/d_home_new.dart';
import 'package:sideswap/desktop/d_main_bottom_navigation_bar.dart';
import 'package:sideswap/desktop/d_tx_history.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/markets_page_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/accounts/assets_list.dart';
import 'package:sideswap/screens/swap/swap.dart';

class DesktopWalletMain extends ConsumerStatefulWidget {
  const DesktopWalletMain({super.key});

  @override
  WalletMainState createState() => WalletMainState();
}

class WalletMainState extends ConsumerState<DesktopWalletMain> {
  Widget getChild(WalletMainArguments walletMainArguments) {
    switch (walletMainArguments.navigationItemEnum) {
      case WalletMainNavigationItemEnum.home:
        return const DesktopHome();
      case WalletMainNavigationItemEnum.accounts:
        return const SizedBox();
      case WalletMainNavigationItemEnum.assetSelect:
        return const AssetSelectList();
      case WalletMainNavigationItemEnum.assetDetails:
        return const AssetDetails();
      case WalletMainNavigationItemEnum.transactions:
        return const DTxHistory();
      case WalletMainNavigationItemEnum.markets:
        return const DMarkets();
      case WalletMainNavigationItemEnum.swap:
        return const DSwapMain(key: ValueKey(false));
      case WalletMainNavigationItemEnum.pegs:
        return const DSwapMain(key: ValueKey(true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);

        return SideSwapScaffoldPage(
          header: const TopToolbar(),
          content: Column(
            children: [
              Expanded(child: getChild(walletMainArguments)),
            ],
          ),
          bottomBar: DesktopMainBottomNavigationBar(
            currentIndex: walletMainArguments.currentIndex,
            onTap: (index) {
              ref.read(swapProvider).swapReset();
              final newWalletMainArguments =
                  walletMainArguments.fromIndexDesktop(index);
              ref
                  .read(uiStateArgsNotifierProvider.notifier)
                  .setWalletMainArguments(newWalletMainArguments);
              if (newWalletMainArguments.navigationItemEnum ==
                  WalletMainNavigationItemEnum.pegs) {
                ref.read(swapProvider).switchToPegs();
              }

              if (newWalletMainArguments.navigationItemEnum ==
                  WalletMainNavigationItemEnum.swap) {
                ref.read(swapProvider).switchToSwaps();
              }

              ref.invalidate(marketsPageListenerProvider);
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF043857),
              ),
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
              ref.read(paymentProvider).createdTx = null;
              ref.read(desktopDialogProvider).showSendTx();
            },
          ),
          DTopToolbarButton(
            name: 'Receive'.tr(),
            icon: 'assets/toolbar/recv.svg',
            onPressed: () {
              ref.read(desktopDialogProvider).showGenerateAddress();
            },
          ),
          DTopToolbarButtonOld(
            name: 'URL'.tr(),
            icon: 'assets/toolbar/open_url.svg',
            onPressed: () {
              ref.read(desktopDialogProvider).openUrl();
            },
          ),
          // TODO (malcolmpl): replace when new import will be ready
          // DTopToolbarButton(
          //   name: 'Import'.tr(),
          //   icon: 'assets/toolbar/import.svg',
          //   onPressed: () {
          //     ref.read(desktopDialogProvider).openTxImport();
          //   },
          // ),
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
