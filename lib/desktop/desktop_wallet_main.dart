import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/addresses/d_addresses.dart';
import 'package:sideswap/desktop/common/button/d_toolbar_button.dart';

import 'package:sideswap/desktop/d_main_bottom_navigation_bar.dart';
import 'package:sideswap/desktop/d_tx_history.dart';
import 'package:sideswap/desktop/home/d_home.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';
import 'package:sideswap/desktop/instant_swap/d_instant_swap.dart';
import 'package:sideswap/desktop/widgets/d_notifications.dart';
import 'package:sideswap/desktop/widgets/d_swaption_connections_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/pegs/d_peg_in_out.dart';

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
      WalletMainNavigationItemEnum.pegs => const DPegInOut(),
      WalletMainNavigationItemEnum.addresses => const DAddresses(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletMainArguments = ref.watch(uiStateArgsProvider);

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
              .read(uiStateArgsProvider.notifier)
              .setWalletMainArguments(newWalletMainArguments);
          if (newWalletMainArguments.navigationItemEnum ==
              WalletMainNavigationItemEnum.pegs) {
            ref.read(swapHelperProvider).switchToPegs();
          }

          if (newWalletMainArguments.navigationItemEnum ==
              WalletMainNavigationItemEnum.swap) {
            ref.read(swapHelperProvider).switchToSwaps();
          }

          if (newWalletMainArguments.navigationItemEnum ==
              WalletMainNavigationItemEnum.transactions) {
            final allTxs = ref.read(allTxsProvider);

            // force reload transactions if no transactions are loaded (fix case when previous call failed)
            if (allTxs.isEmpty) {
              ref.invalidate(allTxsProvider);
              ref.invalidate(txHistoryStateProvider);
            }
          }
        },
      ),
    );
  }
}

class TopToolbar extends HookConsumerWidget {
  const TopToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localesProvider);

    return Container(
      key: ValueKey(locale),
      color: SideSwapColors.maastrichtBlue,
      height: 34,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DTopToolbarButton(
            name: 'Send'.tr(),
            icon: SvgPicture.asset(
              'assets/toolbar/send.svg',
              width: 18,
              height: 18,
            ),
            onPressed: () {
              ref.invalidate(createTxStateProvider);
              ref.invalidate(outputsReaderProvider);
              ref.invalidate(outputsCreatorProvider);

              ref.read(desktopDialogProvider).showSendTx();
            },
          ),
          DTopToolbarButton(
            name: 'Receive'.tr(),
            icon: SvgPicture.asset(
              'assets/toolbar/recv.svg',
              width: 18,
              height: 18,
            ),
            onPressed: () {
              ref.read(desktopDialogProvider).showGenerateAddress();
            },
          ),
          DTopToolbarButton(
            name: 'Import'.tr(),
            icon: SvgPicture.asset(
              'assets/toolbar/import.svg',
              width: 18,
              height: 18,
            ),
            onPressed: () {
              ref.read(desktopDialogProvider).openTxImport();
            },
          ),
          DNotificationToolbarButton(),
          DSwaptionConnectionsButton(),
          DTopToolbarButton(
            name: '',
            icon: SvgPicture.asset(
              'assets/toolbar/settings.svg',
              width: 18,
              height: 18,
            ),
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
