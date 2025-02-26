import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/addresses_providers.dart';

class DAddressesBalanceTypePopupMenu extends HookConsumerWidget {
  const DAddressesBalanceTypePopupMenu({super.key});

  Future<AddressesBalanceFlag?> showSortMenu(
    BuildContext context,
    GlobalKey buttonKey,
    AddressesBalanceFlag balanceTypeFlag,
  ) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;

    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(const Offset(0, -82), ancestor: overlay),
        box.localToGlobal(const Offset(0, 0), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<AddressesBalanceFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          height: 32,
          value: const AddressesBalanceFlagShowAll(),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: HookBuilder(
            builder: (context) {
              final over = useState(false);
              return MouseRegion(
                onEnter: (event) {
                  over.value = true;
                },
                onExit: (event) {
                  over.value = false;
                },
                child: SizedBox(
                  height: 32,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Show all'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 13,
                        color:
                            balanceTypeFlag ==
                                    const AddressesBalanceFlagShowAll()
                                ? SideSwapColors.airSuperiorityBlue
                                : over.value
                                ? SideSwapColors.brightTurquoise
                                : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        PopupMenuItem(
          height: 32,
          value: const AddressesBalanceFlagHideEmpty(),
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: HookBuilder(
            builder: (context) {
              final over = useState(false);

              return MouseRegion(
                onEnter: (event) {
                  over.value = true;
                },
                onExit: (event) {
                  over.value = false;
                },
                child: SizedBox(
                  height: 32,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hide empty'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 13,
                        color:
                            balanceTypeFlag ==
                                    const AddressesBalanceFlagHideEmpty()
                                ? SideSwapColors.airSuperiorityBlue
                                : over.value
                                ? SideSwapColors.brightTurquoise
                                : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonKey = useMemoized(() => GlobalKey());
    final clicked = useState(false);

    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .addressesButtonStyle(false);

    final balanceTypeFlag = ref.watch(addressesBalanceTypeFlagNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance'.tr(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: SideSwapColors.cornFlower,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 32,
          child: DButton(
            key: buttonKey,
            style:
                clicked.value
                    ? buttonStyle?.merge(
                      DButtonStyle(
                        backgroundColor: ButtonState.all(
                          SideSwapColors.prussianBlue,
                        ),
                      ),
                    )
                    : buttonStyle,
            onPressed: () async {
              clicked.value = true;
              final result = await showSortMenu(
                context,
                buttonKey,
                balanceTypeFlag,
              );
              (switch (result) {
                AddressesBalanceFlagHideEmpty result => ref
                    .read(addressesBalanceTypeFlagNotifierProvider.notifier)
                    .setFlag(result),
                _ => ref
                    .read(addressesBalanceTypeFlagNotifierProvider.notifier)
                    .setFlag(const AddressesBalanceFlagShowAll()),
              });

              clicked.value = false;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    switch (balanceTypeFlag) {
                      AddressesBalanceFlagHideEmpty() => 'Hide empty'.tr(),
                      _ => 'Show all'.tr(),
                    },
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  AnimatedDropdownArrow(
                    target: clicked.value ? 0 : 1,
                    initFrom: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
