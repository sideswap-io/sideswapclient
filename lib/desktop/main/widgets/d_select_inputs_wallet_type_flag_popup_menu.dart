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
import 'package:sideswap/providers/inputs_providers.dart';

class DSelectInputsWalletTypeFlagPopupMenu extends HookConsumerWidget {
  const DSelectInputsWalletTypeFlagPopupMenu({super.key});

  Future<InputsWalletTypeFlag?> showFilterMenu(
    BuildContext context,
    GlobalKey buttonKey,
    InputsWalletTypeFlag walletTypeFlag,
  ) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonOffset = box.localToGlobal(Offset.zero);

    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromLTRB(
      buttonOffset.dx,
      buttonOffset.dy + box.size.height,
      overlay.size.width, // same as MediaQuery.of(context).size.width,
      overlay.size.height, // same as MediaQuery.of(context).size.height,
    );

    final result = await showMenu<InputsWalletTypeFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          height: 32,
          value: const InputsWalletTypeFlagRegular(),
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
                        color:
                            walletTypeFlag ==
                                    const InputsWalletTypeFlagRegular()
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
          value: const InputsWalletTypeFlagAmp(),
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
                        color:
                            walletTypeFlag == const InputsWalletTypeFlagAmp()
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

    final walletTypeFlag = ref.watch(inputsWalletTypeFlagNotifierProvider);

    return SizedBox(
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
          final result = await showFilterMenu(
            context,
            buttonKey,
            walletTypeFlag,
          );
          (switch (result) {
            InputsWalletTypeFlag result => ref
                .read(inputsWalletTypeFlagNotifierProvider.notifier)
                .setInputsWalletTypeFlag(result),
            _ => ref
                .read(inputsWalletTypeFlagNotifierProvider.notifier)
                .setInputsWalletTypeFlag(const InputsWalletTypeFlagRegular()),
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
                  InputsWalletTypeFlagRegular() => 'Regular'.tr(),
                  InputsWalletTypeFlagAmp() => 'AMP'.tr(),
                },
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 13),
              ),
              const SizedBox(width: 6),
              AnimatedDropdownArrow(target: clicked.value ? 1 : 0),
            ],
          ),
        ),
      ),
    );
  }
}
