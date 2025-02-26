import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';

import 'package:sideswap/screens/wallet_main/widgets/sideswap_navigation_item.dart';

class MainBottomNavigationBar extends ConsumerWidget {
  const MainBottomNavigationBar({super.key, this.onTap});

  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);
    final currentIndex = walletMainArguments.currentIndex;

    Color backgroundColor = const Color(0xFF021C36);
    Color selectedItemColor = SideSwapColors.brightTurquoise;
    Color unselectedItemColor = const Color(0xFF68839E);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      items: [
        BottomNavigationBarItem(
          label: 'Home'.tr(),
          icon:
              currentIndex == 0
                  ? const SideSwapNavigationItemIcon('assets/home_active.svg')
                  : const SideSwapNavigationItemIcon('assets/home.svg'),
        ),
        BottomNavigationBarItem(
          label: 'Assets'.tr(),
          icon:
              currentIndex == 1
                  ? const SideSwapNavigationItemIcon(
                    'assets/accounts_active.svg',
                  )
                  : const SideSwapNavigationItemIcon('assets/accounts.svg'),
        ),
        BottomNavigationBarItem(
          label: 'Markets'.tr(),
          icon:
              currentIndex == 2
                  ? const SideSwapNavigationItemIcon(
                    'assets/requests_active.svg',
                  )
                  : const SideSwapNavigationItemIcon('assets/requests.svg'),
        ),
        BottomNavigationBarItem(
          label: 'Instant Swap'.tr(),
          icon:
              currentIndex == 3
                  ? const SideSwapNavigationItemIcon('assets/swap_active.svg')
                  : const SideSwapNavigationItemIcon('assets/swap.svg'),
        ),
        BottomNavigationBarItem(
          label: 'Peg-In/Out'.tr(),
          icon:
              currentIndex == 4
                  ? const SideSwapNavigationItemIcon(
                    'assets/peg-in-out_active.svg',
                  )
                  : const SideSwapNavigationItemIcon('assets/peg-in-out.svg'),
        ),
      ],
      onTap: onTap,
    );
  }
}
