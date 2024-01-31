import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class InsufficientFunds extends ConsumerWidget {
  const InsufficientFunds({
    super.key,
    required this.msg,
  });

  final From_ShowInsufficientFunds msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[msg.assetId]));
    final icon =
        ref.watch(assetImageProvider).getVerySmallImage(asset?.assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);

    final availableStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: msg.available.toInt(),
            ticker: asset?.ticker ?? '',
            precision: assetPrecision));
    final requiredStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: msg.required.toInt(),
            ticker: asset?.ticker ?? '',
            precision: assetPrecision));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 343,
        height: 378,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: SideSwapColors.blumine,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: SideSwapColors.bitterSweet,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/error.svg',
                    width: 23,
                    height: 23,
                    colorFilter: const ColorFilter.mode(
                        SideSwapColors.bitterSweet, BlendMode.srcIn),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Text(
                        'Insufficient funds'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Available'.tr(),
                            style: const TextStyle(
                              color: SideSwapColors.hippieBlue,
                            ),
                          ),
                          const Spacer(),
                          icon,
                          const SizedBox(width: 12),
                          Text(availableStr),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Required'.tr(),
                            style: const TextStyle(
                              color: SideSwapColors.hippieBlue,
                            ),
                          ),
                          const Spacer(),
                          icon,
                          const SizedBox(width: 12),
                          Text(requiredStr),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomBigButton(
                    width: 279,
                    height: 54,
                    text: 'OK'.tr(),
                    backgroundColor: SideSwapColors.brightTurquoise,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
