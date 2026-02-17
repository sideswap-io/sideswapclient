import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/screens/pay/widgets/deduct_fee_asset_dialog.dart';

class DeductFeeFromOutput extends HookConsumerWidget {
  const DeductFeeFromOutput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clicked = useState(false);

    final payjoinFeeAsset = ref.watch(payjoinFeeAssetProvider);
    final deductFeeFromOutput = ref.watch(deductFeeFromOutputProvider);
    final isDeductFeeEnabled = ref.watch(deductFeeFromOutputEnabledProvider);
    final payjoinFeeAssetIcon = ref
        .watch(assetImageRepositoryProvider)
        .getVerySmallImage(payjoinFeeAsset?.assetId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isDeductFeeEnabled
              ? () {
                  ref
                      .read(deductFeeFromOutputProvider.notifier)
                      .setState(!deductFeeFromOutput);
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox.adaptive(
                value: deductFeeFromOutput,
                onChanged: (value) {
                  isDeductFeeEnabled
                      ? ref
                            .read(deductFeeFromOutputProvider.notifier)
                            .setState(!deductFeeFromOutput)
                      : null;
                },
                checkColor: isDeductFeeEnabled
                    ? Colors.white
                    : SideSwapColors.cornFlower,
                fillColor: WidgetStatePropertyAll(
                  isDeductFeeEnabled
                      ? deductFeeFromOutput
                            ? SideSwapColors.brightTurquoise
                            : Colors.transparent
                      : Colors.transparent,
                ),
                overlayColor: WidgetStatePropertyAll(
                  isDeductFeeEnabled
                      ? deductFeeFromOutput
                            ? SideSwapColors.brightTurquoise
                            : Colors.transparent
                      : Colors.transparent,
                ),
              ),
              Text(
                'Deduct fee from output'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: isDeductFeeEnabled
                      ? Colors.white
                      : SideSwapColors.airSuperiorityBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('Fee asset'.tr()),
        const SizedBox(height: 8),
        CustomBigButton(
          width: double.infinity,
          height: 44,
          backgroundColor: SideSwapColors.blueSapphire,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return DeductFeeAssetDialog();
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                payjoinFeeAssetIcon,
                const SizedBox(width: 8),
                Text(
                  payjoinFeeAsset?.ticker ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                const Spacer(),
                AnimatedDropdownArrow(
                  target: clicked.value ? 0 : 1,
                  initFrom: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
