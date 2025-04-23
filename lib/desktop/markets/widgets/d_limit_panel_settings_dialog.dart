import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

const limitPanelSettingsDialogRouteName = '/desktopLimitPanelSettings';

class DLimitPanelSettingsDialog extends HookConsumerWidget {
  const DLimitPanelSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != limitPanelSettingsDialogRouteName;
      });
    });

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 360),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Order settings'.tr()),
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 450,
        height: 260,
        child: Column(
          children: [
            DLimitPanelSettingsOfflineSwap(),
            const SizedBox(height: 8),
            DLimitPanelSettingsOrderType(),
            const SizedBox(height: 8),
            DLimitPanelSettingsTTL(),
            Spacer(),
            DCustomFilledBigButton(
              onPressed: () {
                closeCallback();
              },
              child: Text('Close'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

// Sign type
class DLimitPanelSettingsOfflineSwap extends ConsumerWidget {
  const DLimitPanelSettingsOfflineSwap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineSwapType = ref.watch(marketLimitOfflineSwapProvider);
    final isJadeWallet = ref.watch(isJadeWalletProvider);

    return DLimitPanelSettingsContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Sign type'.tr()),
            Spacer(),
            Tooltip(
              message:
                  "Online orders (recommended):\n- Are not tied to specific UTXOs (spending UTXOs won't cancel online orders).\n- Can be partially matched, making them more flexible.\n- Order amount can be more than the available wallet balance.\n- Allow price editing.\n- Requires the application to be open and your computer to be running.\n\nOffline orders:\n- Are tied to specific UTXOs (spending UTXOs can cancel one or more orders).\n- Requires exact UTXO amount and therefore may require a funding transaction and payment of network fee.\n- Order amount cannot exceed available wallet balance.\n- Does not allow price editing.\n- Allows the application to be offline."
                      .tr(),
              child: Icon(
                Icons.help_outlined,
                size: 20,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            SizedBox(width: 12),
            SwitchButton(
              width: 142,
              height: 34,
              borderRadius: 6,
              borderWidth: 2,
              fontSize: 13,
              activeText: 'Online'.tr(),
              inactiveText: 'Offline'.tr(),
              value: offlineSwapType == OfflineSwapType.empty(),
              onToggle:
                  isJadeWallet
                      ? null
                      : (value) {
                        if (value) {
                          ref.invalidate(marketLimitOfflineSwapProvider);
                          return;
                        }

                        ref
                            .read(marketLimitOfflineSwapProvider.notifier)
                            .setState(OfflineSwapType.twoStep());
                      },
            ),
          ],
        ),
      ),
    );
  }
}

class DLimitPanelSettingsOrderType extends ConsumerWidget {
  const DLimitPanelSettingsOrderType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderType = ref.watch(marketLimitOrderTypeNotifierProvider);

    return DLimitPanelSettingsContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Order type'.tr()),
            Spacer(),
            SwitchButton(
              width: 142,
              height: 34,
              borderRadius: 6,
              borderWidth: 2,
              fontSize: 13,
              activeText: 'Public'.tr(),
              inactiveText: 'Private'.tr(),
              value: orderType == OrderType.public(),
              onToggle: (value) {
                if (value) {
                  ref.invalidate(marketLimitOrderTypeNotifierProvider);
                  return;
                }

                ref
                    .read(marketLimitOrderTypeNotifierProvider.notifier)
                    .setState(OrderType.private());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DLimitPanelSettingsTTL extends HookConsumerWidget {
  const DLimitPanelSettingsTTL({super.key});

  PopupMenuItem<T> popupMenuItem<T>(
    T value,
    String description,
    bool selected,
  ) {
    return PopupMenuItem<T>(
      height: 30,
      value: value,
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
                  description,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 13,
                    color:
                        selected
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
    );
  }

  List<PopupMenuEntry<LimitTtlFlag>> popupMenuItems(LimitTtlFlag limitTtlFlag) {
    return [
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagUnlimited(),
        LimitTtlFlagUnlimited().description(),
        limitTtlFlag == LimitTtlFlagUnlimited(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagOneHour(),
        LimitTtlFlagOneHour().description(),
        limitTtlFlag == LimitTtlFlagOneHour(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagSixHours(),
        LimitTtlFlagSixHours().description(),
        limitTtlFlag == LimitTtlFlagSixHours(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagTwelveHours(),
        LimitTtlFlagTwelveHours().description(),
        limitTtlFlag == LimitTtlFlagTwelveHours(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagTwentyFourHours(),
        LimitTtlFlagTwentyFourHours().description(),
        limitTtlFlag == LimitTtlFlagTwentyFourHours(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagThreeDays(),
        LimitTtlFlagThreeDays().description(),
        limitTtlFlag == LimitTtlFlagThreeDays(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagOneWeek(),
        LimitTtlFlagOneWeek().description(),
        limitTtlFlag == LimitTtlFlagOneWeek(),
      ),
      popupMenuItem<LimitTtlFlag>(
        LimitTtlFlagOneMonth(),
        LimitTtlFlagOneMonth().description(),
        limitTtlFlag == LimitTtlFlagOneMonth(),
      ),
    ];
  }

  Future<LimitTtlFlag?> showTtlMenu(
    BuildContext context,
    GlobalKey buttonKey,
    LimitTtlFlag limitTtlFlag,
  ) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonOffset = box.localToGlobal(Offset.zero);

    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final position = RelativeRect.fromLTRB(
      buttonOffset.dx + box.size.width - 112,
      buttonOffset.dy + box.size.height + 4,
      overlay.size.width, // same as MediaQuery.of(context).size.width,
      overlay.size.height, // same as MediaQuery.of(context).size.height,
    );

    final result = await showMenu<LimitTtlFlag>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: popupMenuItems(limitTtlFlag),
    );

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonKey = useMemoized(() => GlobalKey());
    final clicked = useState(false);
    final buttonThemes =
        ref.watch(desktopAppThemeNotifierProvider).buttonThemeData;
    final limitTtlFlag = ref.watch(limitTtlFlagNotifierProvider);

    return DLimitPanelSettingsContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text('Time-to-live'.tr()),
            Spacer(),
            DButton(
              key: buttonKey,
              style:
                  clicked.value
                      ? buttonThemes.filledButtonStyle?.merge(
                        DButtonStyle(
                          backgroundColor: ButtonState.all(
                            SideSwapColors.prussianBlue,
                          ),
                        ),
                      )
                      : buttonThemes.filledButtonStyle?.merge(
                        DButtonStyle(
                          backgroundColor: ButtonState.all(
                            SideSwapColors.blueSapphire,
                          ),
                        ),
                      ),
              onPressed: () async {
                clicked.value = true;
                final result = await showTtlMenu(
                  context,
                  buttonKey,
                  limitTtlFlag,
                );
                (switch (result) {
                  LimitTtlFlag result => ref
                      .read(limitTtlFlagNotifierProvider.notifier)
                      .setState(result),
                  _ => ref.invalidate(limitTtlFlagNotifierProvider),
                });

                clicked.value = false;
              },
              child: SizedBox(
                width: 110,
                height: 34,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      limitTtlFlag.description(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    AnimatedDropdownArrow(
                      target: clicked.value ? 1 : 0,
                      iconColor: SideSwapColors.brightTurquoise,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DLimitPanelSettingsContainer extends ConsumerWidget {
  const DLimitPanelSettingsContainer({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: SideSwapColors.chathamsBlue,
      ),
      child: child,
    );
  }
}
