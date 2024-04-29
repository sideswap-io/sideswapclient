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

class DAddressesAddressTypePopupMenu extends HookConsumerWidget {
  const DAddressesAddressTypePopupMenu({super.key});

  Future<AddressesAddressTypeFlag?> showSortMenu(
    BuildContext context,
    GlobalKey buttonKey,
    AddressesAddressTypeFlag addressTypeFlag,
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

    final result = await showMenu<AddressesAddressTypeFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          height: 32,
          value: const AddressesAddressTypeFlagAll(),
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
                            color: addressTypeFlag ==
                                    const AddressesAddressTypeFlagAll()
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
          value: const AddressesAddressTypeFlagInternal(),
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
                      'Internal'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: addressTypeFlag ==
                                    const AddressesAddressTypeFlagInternal()
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
          value: const AddressesAddressTypeFlagExternal(),
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
                      'External'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: addressTypeFlag ==
                                    const AddressesAddressTypeFlagExternal()
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

    final addressTypeFlag = ref.watch(addressesAddressTypeFlagNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Address'.tr(),
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
                  await showSortMenu(context, buttonKey, addressTypeFlag);
              (switch (result) {
                AddressesAddressTypeFlag result => ref
                    .read(addressesAddressTypeFlagNotifierProvider.notifier)
                    .setFlag(result),
                _ => ref
                    .read(addressesAddressTypeFlagNotifierProvider.notifier)
                    .setFlag(const AddressesAddressTypeFlagAll()),
              });

              clicked.value = false;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    switch (addressTypeFlag) {
                      AddressesAddressTypeFlagInternal() => 'Internal'.tr(),
                      AddressesAddressTypeFlagExternal() => 'External'.tr(),
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
