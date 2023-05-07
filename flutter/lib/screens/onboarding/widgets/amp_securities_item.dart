import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class AmpSecuritiesItem extends HookConsumerWidget {
  const AmpSecuritiesItem({Key? key, required this.securitiesItem})
      : super(key: key);

  final SecuritiesItem securitiesItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetImages = ref.watch(assetImageProvider);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (securitiesItem.assetId != null) ...[
                  assetImages.getCustomImage(
                    securitiesItem.assetId,
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.medium,
                  )
                ] else ...[
                  SvgPicture.asset(
                    securitiesItem.icon,
                    width: 24,
                    height: 24,
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    securitiesItem.token,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Divider(
                color: SideSwapColors.jellyBean,
                height: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
