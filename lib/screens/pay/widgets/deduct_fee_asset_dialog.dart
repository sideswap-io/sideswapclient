import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';

class DeductFeeAssetDialog extends HookConsumerWidget {
  const DeductFeeAssetDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payjoinFeeAssets = ref.watch(payjoinFeeAssetsProvider);

    return SideSwapPopup(
      onClose: () {
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Fee asset'.tr(), style: Theme.of(context).textTheme.titleLarge),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'.tr()),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select the asset you want to use to pay the transaction fee.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Flexible(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Consumer(
                      builder: (context, ref, child) {
                        final payjoinFeeAssetIcon = ref
                            .watch(assetImageRepositoryProvider)
                            .getVerySmallImage(payjoinFeeAssets[index].assetId);

                        return SizedBox(
                          height: 54,
                          child: Column(
                            children: [
                              CustomBigButton(
                                width: double.infinity,
                                height: 44,
                                onPressed: () {
                                  ref
                                      .read(payjoinFeeAssetProvider.notifier)
                                      .setState(payjoinFeeAssets[index]);
                                  Navigator.of(context).pop();
                                },
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      payjoinFeeAssetIcon,
                                      const SizedBox(width: 8),
                                      Text(payjoinFeeAssets[index].ticker),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    );
                  }, childCount: payjoinFeeAssets.length),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
