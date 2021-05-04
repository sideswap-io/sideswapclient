import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/accounts/widgets/asset_search_text_field.dart';
import 'package:sideswap/screens/accounts/widgets/asset_select_item.dart';

class AssetSelectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Asset list'.tr(),
        onPressed: () {
          final uiStateArgs = context.read(uiStateArgsProvider);
          uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
              .copyWith(navigationItem: WalletMainNavigationItem.accounts);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 18.h, bottom: 29.h),
                      child: AssetSearchTextField(),
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (context, watch, child) {
                          final _filteredToggleAssetIds =
                              watch(walletProvider).filteredToggleAssetIds;
                          final _assets = watch(walletProvider).assets;
                          return ListView(
                            children: List<Widget>.generate(
                              _filteredToggleAssetIds.length,
                              (index) {
                                final assetId = _filteredToggleAssetIds[index];
                                final asset = _assets[assetId];
                                return AssetSelectItem(asset: asset);
                              },
                            ),
                          );
                        },
                      ),
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
