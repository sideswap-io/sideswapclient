import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/addresses/d_addresses.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';

import 'package:sideswap/desktop/d_main_bottom_navigation_bar.dart';
import 'package:sideswap/desktop/d_tx_history.dart';
import 'package:sideswap/desktop/home/d_home.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';
import 'package:sideswap/desktop/instant_swap/d_instant_swap.dart';
import 'package:sideswap/desktop/swap/d_swap_main.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';

final pageStorageBucket = PageStorageBucket();

class DesktopWalletMain extends HookConsumerWidget {
  const DesktopWalletMain({super.key});

  Widget getChild(WalletMainArguments walletMainArguments) {
    return switch (walletMainArguments.navigationItemEnum) {
      WalletMainNavigationItemEnum.home => const DHome(),
      WalletMainNavigationItemEnum.accounts => const SizedBox(),
      WalletMainNavigationItemEnum.assetDetails => const AssetDetails(),
      WalletMainNavigationItemEnum.transactions => const DTxHistory(),
      WalletMainNavigationItemEnum.markets => const DMarkets(),
      WalletMainNavigationItemEnum.swap => DInstantSwap(),
      WalletMainNavigationItemEnum.pegs => const DSwapMain(key: ValueKey(true)),
      WalletMainNavigationItemEnum.addresses => const DAddresses(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);

    return SideSwapScaffoldPage(
      header: const TopToolbar(),
      content: PageStorage(
        bucket: pageStorageBucket,
        child: Column(
          children: [Expanded(child: getChild(walletMainArguments))],
        ),
      ),
      bottomBar: DesktopMainBottomNavigationBar(
        currentIndex: walletMainArguments.currentIndex,
        onTap: (index) {
          ref.read(swapHelperProvider).swapReset();
          final newWalletMainArguments = walletMainArguments.fromIndexDesktop(
            index,
          );
          ref
              .read(uiStateArgsNotifierProvider.notifier)
              .setWalletMainArguments(newWalletMainArguments);
          if (newWalletMainArguments.navigationItemEnum ==
              WalletMainNavigationItemEnum.pegs) {
            ref.read(swapHelperProvider).switchToPegs();
          }

          if (newWalletMainArguments.navigationItemEnum ==
              WalletMainNavigationItemEnum.swap) {
            ref.read(swapHelperProvider).switchToSwaps();
          }
        },
      ),
    );
  }
}

class TopToolbar extends ConsumerWidget {
  const TopToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localesNotifierProvider);
    return Container(
      key: ValueKey(locale),
      color: const Color(0xFF021C36),
      height: 34,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DTopToolbarButton(
            name: 'Send'.tr(),
            icon: 'assets/toolbar/send.svg',
            onPressed: () {
              ref.invalidate(createTxStateNotifierProvider);
              ref.invalidate(outputsReaderNotifierProvider);
              ref.invalidate(outputsCreatorProvider);

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
          DTopToolbarButton(
            name: 'Import'.tr(),
            icon: 'assets/toolbar/import.svg',
            onPressed: () {
              ref.read(desktopDialogProvider).openTxImport();
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
