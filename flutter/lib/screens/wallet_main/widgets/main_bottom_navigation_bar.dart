import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:sideswap/screens/wallet_main/widgets/requests_navigation_item_badge.dart';
import 'package:sideswap/screens/wallet_main/widgets/sideswap_navigation_item.dart';

class MainBottomNavigationBar extends StatefulWidget {
  const MainBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  final ValueChanged<int> onTap;
  final int currentIndex;

  @override
  MainBottomNavigationBarState createState() => MainBottomNavigationBarState();
}

class MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  Color backgroundColor = const Color(0xFF021C36);
  Color selectedItemColor = const Color(0xFF00C5FF);
  Color unselectedItemColor = const Color(0xFF68839E);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
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
          icon: widget.currentIndex == 0
              ? const SideSwapNavigationItemIcon('assets/home_active.svg')
              : const SideSwapNavigationItemIcon('assets/home.svg'),
        ),
        BottomNavigationBarItem(
          label: 'Assets'.tr(),
          icon: widget.currentIndex == 1
              ? const SideSwapNavigationItemIcon('assets/accounts_active.svg')
              : const SideSwapNavigationItemIcon('assets/accounts.svg'),
        ),
        BottomNavigationBarItem(
            label: 'Markets'.tr(),
            icon: widget.currentIndex == 2
                ? RequestsNavigationItemBadge(
                    assetName: 'assets/requests_active.svg',
                    backgroundColor: backgroundColor,
                    itemColor: selectedItemColor,
                  )
                : RequestsNavigationItemBadge(
                    assetName: 'assets/requests.svg',
                    backgroundColor: backgroundColor,
                    itemColor: unselectedItemColor,
                  )),
        BottomNavigationBarItem(
          label: 'Instant Swap'.tr(),
          icon: widget.currentIndex == 3
              ? const SideSwapNavigationItemIcon('assets/swap_active.svg')
              : const SideSwapNavigationItemIcon('assets/swap.svg'),
        ),
        BottomNavigationBarItem(
          label: 'Peg-In/Out'.tr(),
          icon: widget.currentIndex == 4
              ? const SideSwapNavigationItemIcon('assets/peg-in-out_active.svg')
              : const SideSwapNavigationItemIcon('assets/peg-in-out.svg'),
        ),
      ],
      onTap: widget.onTap,
    );
  }
}
