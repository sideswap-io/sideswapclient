import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
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
      selectedLabelStyle: GoogleFonts.roboto(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.roboto(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      ),
      items: [
        BottomNavigationBarItem(
          label: 'Home'.tr(),
          icon: widget.currentIndex == 0
              ? SideSwapNavigationItemIcon('assets/home_active.svg',
                  height: 24.h)
              : SideSwapNavigationItemIcon('assets/home.svg', height: 24.h),
        ),
        BottomNavigationBarItem(
          label: 'Assets'.tr(),
          icon: widget.currentIndex == 1
              ? SideSwapNavigationItemIcon('assets/accounts_active.svg',
                  height: 24.h)
              : SideSwapNavigationItemIcon('assets/accounts.svg', height: 24.h),
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
                  )
            // SvgPicture.asset('assets/requests.svg', height: 24.h),
            ),
        BottomNavigationBarItem(
          label: 'Swap'.tr(),
          icon: widget.currentIndex == 3
              ? SideSwapNavigationItemIcon('assets/swap_active.svg',
                  height: 24.h)
              : SideSwapNavigationItemIcon('assets/swap.svg', height: 24.h),
        ),
      ],
      onTap: widget.onTap,
    );
  }
}
