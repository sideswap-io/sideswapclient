import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/locales_provider.dart';

class DesktopMainBottomNavigationBar extends ConsumerStatefulWidget {
  const DesktopMainBottomNavigationBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  final ValueChanged<int> onTap;
  final int currentIndex;

  @override
  DesktopMainBottomNavigationBarState createState() =>
      DesktopMainBottomNavigationBarState();
}

class DesktopMainBottomNavigationBarState
    extends ConsumerState<DesktopMainBottomNavigationBar> {
  void selected(int index) {
    setState(() {
      widget.onTap(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localesProvider).selectedLang(context);
    return Container(
      key: ValueKey(lang),
      height: 56,
      color: const Color(0xFF021C36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ToolbarButton(
            name: 'Home'.tr(),
            selectedIcon: 'assets/home_active.svg',
            unselectedIcon: 'assets/home.svg',
            index: 0,
            selectedIndex: widget.currentIndex,
            onSelected: selected,
          ),
          _ToolbarButton(
            name: 'Swap Markets'.tr(),
            selectedIcon: 'assets/requests_active.svg',
            unselectedIcon: 'assets/requests.svg',
            index: 1,
            selectedIndex: widget.currentIndex,
            onSelected: selected,
          ),
          _ToolbarButton(
            name: 'Instant Swap'.tr(),
            selectedIcon: 'assets/swap_active.svg',
            unselectedIcon: 'assets/swap.svg',
            index: 2,
            selectedIndex: widget.currentIndex,
            onSelected: selected,
          ),
          _ToolbarButton(
            name: 'Peg-In/Out'.tr(),
            selectedIcon: 'assets/swap_active.svg',
            unselectedIcon: 'assets/swap.svg',
            index: 4,
            selectedIndex: widget.currentIndex,
            onSelected: selected,
          ),
          _ToolbarButton(
            name: 'Transactions'.tr(),
            selectedIcon: 'assets/transactions_active.svg',
            unselectedIcon: 'assets/transactions.svg',
            index: 3,
            selectedIndex: widget.currentIndex,
            onSelected: selected,
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
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
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return SizedBox(
      width: 94,
      child: IconButton(
          padding: EdgeInsets.zero,
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isSelected ? selectedIcon : unselectedIcon,
                width: 24,
              ),
              const SizedBox(height: 3),
              Text(
                name,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF00C5FF)
                      : const Color(0xFF68839E),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          onPressed: () => onSelected(index)),
    );
  }
}
