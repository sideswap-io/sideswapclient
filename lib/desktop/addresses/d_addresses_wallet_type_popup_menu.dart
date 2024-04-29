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

class DAddressesWalletTypePopupMenu extends HookConsumerWidget {
  const DAddressesWalletTypePopupMenu({super.key});

  Future<AddressesWalletTypeFlag?> showSortMenu(
    BuildContext context,
    GlobalKey buttonKey,
    AddressesWalletTypeFlag walletTypeFlag,
  ) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;

    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(const Offset(0, -114), ancestor: overlay),
        box.localToGlobal(const Offset(0, 0), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<AddressesWalletTypeFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          height: 32,
          value: const AddressesWalletTypeFlagAll(),
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
                      'All'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: walletTypeFlag ==
                                    const AddressesWalletTypeFlagAll()
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
          value: const AddressesWalletTypeFlagRegular(),
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
                      'Regular'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: walletTypeFlag ==
                                    const AddressesWalletTypeFlagRegular()
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
          value: const AddressesWalletTypeFlagAmp(),
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
                      'AMP'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: walletTypeFlag ==
                                    const AddressesWalletTypeFlagAmp()
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

    final buttonStyle =
        ref.watch(desktopAppThemeNotifierProvider).addressesButtonStyle(false);

    final walletTypeFlag = ref.watch(addressesWalletTypeFlagNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Wallet'.tr(),
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: SideSwapColors.cornFlower, fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          height: 32,
          child: DButton(
            key: buttonKey,
            style: clicked.value
                ? buttonStyle?.merge(DButtonStyle(
                    backgroundColor:
                        ButtonState.all(SideSwapColors.prussianBlue)))
                : buttonStyle,
            onPressed: () async {
              clicked.value = true;
              final result =
                  await showSortMenu(context, buttonKey, walletTypeFlag);
              (switch (result) {
                AddressesWalletTypeFlag result => ref
                    .read(addressesWalletTypeFlagNotifierProvider.notifier)
                    .setFlag(result),
                _ => ref
                    .read(addressesWalletTypeFlagNotifierProvider.notifier)
                    .setFlag(const AddressesWalletTypeFlagAll()),
              });

              clicked.value = false;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    switch (walletTypeFlag) {
                      AddressesWalletTypeFlagRegular() => 'Regular'.tr(),
                      AddressesWalletTypeFlagAmp() => 'AMP'.tr(),
                      _ => 'All'.tr(),
                    },
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 13),
                  ),
                  const SizedBox(width: 6),
                  AnimatedDropdownArrow(
                      target: clicked.value ? 0 : 1, initFrom: 1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
