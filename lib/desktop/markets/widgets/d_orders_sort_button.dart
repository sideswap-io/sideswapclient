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
import 'package:sideswap/providers/orders_panel_provider.dart';

class DOrdersSortButton extends HookConsumerWidget {
  const DOrdersSortButton({super.key});

  Future<RequestOrderSortFlag?> showSortMenu(
    BuildContext context,
    GlobalKey buttonKey,
    RequestOrderSortFlag requestOrderSortFlag,
  ) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonOffset = box.localToGlobal(Offset.zero);

    // overlay is a full screen transparent widget (probably?)
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    // (malcolmpl) don't delete this comment
    // topright of menu is a button bottomright + 4
    // final RelativeRect position = RelativeRect.fromRect(
    //   Rect.fromPoints(
    //     box.localToGlobal(Offset(0, buttonOffset.dy + 4), ancestor: overlay),
    //     box.localToGlobal(
    //         box.size.bottomRight(Offset.zero) + const Offset(0, 4),
    //         ancestor: overlay),
    //   ),
    //   Offset.zero & overlay.size,
    // );

    // topleft of menu is a button bottomleft + 4
    final position = RelativeRect.fromLTRB(
      buttonOffset.dx,
      buttonOffset.dy + box.size.height + 4,
      overlay.size.width, // same as MediaQuery.of(context).size.width,
      overlay.size.height, // same as MediaQuery.of(context).size.height,
    );

    final result = await showMenu<RequestOrderSortFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          height: 32,
          value: const RequestOrderSortFlagAll(),
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
                      'All orders'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: requestOrderSortFlag ==
                                    const RequestOrderSortFlagAll()
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
          value: const RequestOrderSortFlagOnline(),
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
                      'Online'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: requestOrderSortFlag ==
                                    const RequestOrderSortFlagOnline()
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
          value: const RequestOrderSortFlagOffline(),
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
                      'Offline'.tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 13,
                            color: requestOrderSortFlag ==
                                    const RequestOrderSortFlagOffline()
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

    final buttonThemes =
        ref.watch(desktopAppThemeNotifierProvider).buttonThemeData;
    final requestOrderSortFlag =
        ref.watch(requestOrderSortFlagNotifierProvider);

    return DButton(
      key: buttonKey,
      style: clicked.value
          ? buttonThemes.filledButtonStyle?.merge(DButtonStyle(
              backgroundColor: ButtonState.all(SideSwapColors.prussianBlue)))
          : buttonThemes.defaultButtonStyle,
      onPressed: () async {
        clicked.value = true;
        final result =
            await showSortMenu(context, buttonKey, requestOrderSortFlag);
        (switch (result) {
          RequestOrderSortFlag result => ref
              .read(requestOrderSortFlagNotifierProvider.notifier)
              .setSortFlag(result),
          _ => ref
              .read(requestOrderSortFlagNotifierProvider.notifier)
              .setSortFlag(const RequestOrderSortFlagAll()),
        });

        clicked.value = false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              switch (requestOrderSortFlag) {
                RequestOrderSortFlagOnline() => 'Online'.tr(),
                RequestOrderSortFlagOffline() => 'Offline'.tr(),
                _ => 'All orders'.tr(),
              },
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 13),
            ),
            const SizedBox(width: 6),
            AnimatedDropdownArrow(target: clicked.value ? 1 : 0),
          ],
        ),
      ),
    );
  }
}
