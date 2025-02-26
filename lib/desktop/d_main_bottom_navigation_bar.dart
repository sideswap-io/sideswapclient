import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/locales_provider.dart';

class DesktopMainBottomNavigationBar extends ConsumerWidget {
  const DesktopMainBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  final ValueChanged<int> onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localesNotifierProvider);

    return Container(
      key: ValueKey(locale),
      height: 56,
      color: const Color(0xFF021C36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ToolbarButton(
            name: 'Home'.tr(),
            selectedIcon: 'assets/home_active.svg',
            unselectedIcon: 'assets/home.svg',
            index: 0,
            selectedIndex: currentIndex,
            onSelected: onTap,
          ),
          const SizedBox(width: 24),
          ToolbarButton(
            name: 'Swap Markets'.tr(),
            selectedIcon: 'assets/requests_active.svg',
            unselectedIcon: 'assets/requests.svg',
            index: 1,
            selectedIndex: currentIndex,
            onSelected: onTap,
          ),
          const SizedBox(width: 24),
          ToolbarButton(
            name: 'Instant Swap'.tr(),
            selectedIcon: 'assets/swap_active.svg',
            unselectedIcon: 'assets/swap.svg',
            index: 2,
            selectedIndex: currentIndex,
            onSelected: onTap,
          ),
          const SizedBox(width: 24),
          ToolbarButton(
            name: 'Peg-In/Out'.tr(),
            selectedIcon: 'assets/peg-in-out_active.svg',
            unselectedIcon: 'assets/peg-in-out.svg',
            index: 4,
            selectedIndex: currentIndex,
            onSelected: onTap,
          ),
          const SizedBox(width: 24),
          ToolbarButton(
            name: 'Transactions'.tr(),
            selectedIcon: 'assets/transactions_active.svg',
            unselectedIcon: 'assets/transactions.svg',
            index: 3,
            selectedIndex: currentIndex,
            onSelected: onTap,
          ),
          const SizedBox(width: 24),
          ToolbarButton(
            name: 'Addresses'.tr(),
            selectedIcon: 'assets/addresses_active.svg',
            unselectedIcon: 'assets/addresses.svg',
            index: 5,
            selectedIndex: currentIndex,
            onSelected: onTap,
          ),
        ],
      ),
    );
  }
}

class ToolbarButton extends ConsumerWidget {
  const ToolbarButton({
    super.key,
    required this.name,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.index,
    required this.selectedIndex,
    required this.onSelected,
  });

  final String name;
  final int index;
  final String selectedIcon;
  final String unselectedIcon;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selectedIndex == index;
    final buttonStyle =
        ref
            .watch(desktopAppThemeNotifierProvider)
            .mainBottomNavigationBarButtonStyle;

    return DButton(
      style: buttonStyle,
      onPressed: () => onSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          SizedBox(
            width: 29,
            height: 27,
            child: Center(
              child: SvgPicture.asset(
                isSelected ? selectedIcon : unselectedIcon,
                width: 24,
              ),
            ),
          ),
          const Spacer(),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color:
                  isSelected
                      ? SideSwapColors.brightTurquoise
                      : const Color(0xFF68839E),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
