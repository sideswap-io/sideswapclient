import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/custom_hint_border_container.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DSendPopupDeductFee extends HookConsumerWidget {
  const DSendPopupDeductFee({
    super.key,
  });

  Future<Asset?> showAssetMenu(
    BuildContext context,
    GlobalKey buttonKey,
    List<Asset> payjoinFeeAssets,
    Asset asset,
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

    final result = await showMenu<Asset>(
      context: context,
      position: position,
      color: SideSwapColors.prussianBlue,
      constraints: const BoxConstraints(maxWidth: 140),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: List.generate(payjoinFeeAssets.length, (index) {
        return PopupMenuItem(
          height: 32,
          value: payjoinFeeAssets[index],
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
                  width: 70,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final payjoinFeeAssetIcon = ref
                              .watch(assetImageProvider)
                              .getVerySmallImage(
                                  payjoinFeeAssets[index].assetId);

                          return Row(
                            children: [
                              payjoinFeeAssetIcon,
                              const SizedBox(width: 8),
                              Text(
                                payjoinFeeAssets[index].ticker,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 13,
                                      color: asset.ticker ==
                                              payjoinFeeAssets[index].ticker
                                          ? SideSwapColors.airSuperiorityBlue
                                          : over.value
                                              ? SideSwapColors.brightTurquoise
                                              : Colors.white,
                                    ),
                              ),
                            ],
                          );
                        },
                      )),
                ),
              );
            },
          ),
        );
      }),
    );

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonKey = useMemoized(() => GlobalKey());
    final clicked = useState(false);

    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .payjoinFeeAssetButtonStyle(false);

    final payjoinFeeAssets = ref.watch(payjoinFeeAssetsProvider);
    final payjoinFeeAsset = ref.watch(payjoinFeeAssetNotifierProvider);
    final deductFeeFromOutput = ref.watch(deductFeeFromOutputNotifierProvider);
    final isDeductFeeEnabled =
        ref.watch(deductFeeFromOutputEnabledNotifierProvider);
    final payjoinFeeAssetIcon = ref
        .watch(assetImageProvider)
        .getVerySmallImage(payjoinFeeAsset?.assetId);

    return SizedBox(
      height: 84,
      child: Column(
        children: [
          Row(
            children: [
              CustomCheckBox(
                enabled: isDeductFeeEnabled,
                value: deductFeeFromOutput,
                onChecked: (value) {
                  ref
                      .read(deductFeeFromOutputNotifierProvider.notifier)
                      .setState(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Deduct fee from output'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: isDeductFeeEnabled
                        ? Colors.white
                        : SideSwapColors.airSuperiorityBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomHintBorderContainer(
            width: double.maxFinite,
            height: 48,
            radius: 8,
            title: 'Fee asset'.tr(),
            textStyle:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
            strokeWidth: 2,
            left: 10,
            color: SideSwapColors.jellyBean,
            child: DButton(
              key: buttonKey,
              style: clicked.value
                  ? buttonStyle?.merge(DButtonStyle(
                      backgroundColor:
                          ButtonState.all(SideSwapColors.prussianBlue)))
                  : buttonStyle,
              onPressed: () async {
                if (payjoinFeeAsset == null) {
                  return;
                }

                clicked.value = true;
                final result = await showAssetMenu(
                    context, buttonKey, payjoinFeeAssets, payjoinFeeAsset);
                (switch (result) {
                  final result? => ref
                      .read(payjoinFeeAssetNotifierProvider.notifier)
                      .setState(result),
                  _ => ref.invalidate(payjoinFeeAssetNotifierProvider),
                });

                clicked.value = false;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    payjoinFeeAssetIcon,
                    const SizedBox(width: 8),
                    Text(
                      payjoinFeeAsset?.ticker ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontSize: 13),
                    ),
                    const Spacer(),
                    AnimatedDropdownArrow(
                        target: clicked.value ? 0 : 1, initFrom: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
