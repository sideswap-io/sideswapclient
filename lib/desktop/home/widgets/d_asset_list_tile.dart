import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/home/widgets/d_asset_list_tile_amount.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class DAssetListTile extends ConsumerWidget {
  const DAssetListTile({
    super.key,
    required this.accountAsset,
  });

  final AccountAsset accountAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(desktopAppThemeProvider).buttonWithoutBorderStyle;
    return DButton(
      style: buttonStyle?.merge(
        DButtonStyle(
          shape: ButtonState.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
        ),
      ),
      onPressed: () {
        ref.read(desktopDialogProvider).openAccount(accountAsset);
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
                      final icon = ref.watch(assetImageProvider).getCustomImage(
                          accountAsset.assetId,
                          width: 24,
                          height: 24,
                          filterQuality: FilterQuality.medium);

                      return icon;
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 72,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final asset = ref.watch(assetsStateProvider
                            .select((value) => value[accountAsset.assetId]));

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            asset?.ticker ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ),
                  switch (accountAsset.account.isAmp) {
                    true => const AmpFlag(
                        margin: EdgeInsets.zero,
                      ),
                    false => const SizedBox(),
                  },
                  const Spacer(),
                  DAssetListTileAmount(accountAsset: accountAsset),
                ],
              ),
              const Spacer(),
              const Divider(
                height: 1,
                thickness: 0,
                color: SideSwapColors.jellyBean,
              )
            ],
          ),
        ),
      ),
    );
  }
}
