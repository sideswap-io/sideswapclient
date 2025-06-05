import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/home/widgets/d_asset_list_tile_amount.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DAssetListTile extends ConsumerWidget {
  const DAssetListTile({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .buttonWithoutBorderStyle;

    return DButton(
      style: buttonStyle?.merge(
        DButtonStyle(
          shape: ButtonState.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
        ),
      ),
      onPressed: () {
        ref.read(desktopDialogProvider).showAssetInfoDialog(asset);
      },
      child: SizedBox(
        height: 53,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 20),
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final icon = ref
                          .watch(assetImageRepositoryProvider)
                          .getCustomImage(
                            asset.assetId,
                            width: 24,
                            height: 24,
                            filterQuality: FilterQuality.medium,
                          );

                      return icon;
                    },
                  ),
                  const SizedBox(width: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.ticker,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          asset.name,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: SideSwapColors.airSuperiorityBlue,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  switch (asset.ampMarket) {
                    true => const AmpFlag(margin: EdgeInsets.zero),
                    _ => const SizedBox(),
                  },
                  DAssetListTileAmount(asset: asset),
                ],
              ),
              const Spacer(),
              const Divider(
                height: 1,
                thickness: 0,
                color: SideSwapColors.jellyBean,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
