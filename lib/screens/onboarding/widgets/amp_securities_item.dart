import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';

class AmpSecuritiesItem extends HookConsumerWidget {
  const AmpSecuritiesItem({super.key, required this.securitiesItem});

  final SecuritiesItem securitiesItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetImages = ref.watch(assetImageRepositoryProvider);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                assetImages.getCustomImageOrNull(
                      securitiesItem.assetId,
                      width: 24,
                      height: 24,
                      filterQuality: FilterQuality.medium,
                    ) ??
                    assetImages.getCustomImageFromAsset(
                      securitiesItem.icon,
                      width: 24,
                      height: 24,
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    securitiesItem.token,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Divider(color: SideSwapColors.jellyBean, height: 2),
            ),
          ],
        ),
      ),
    );
  }
}
