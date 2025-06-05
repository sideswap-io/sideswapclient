import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/asset_item.dart';
import 'package:sideswap/screens/accounts/widgets/assets_header.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class WalletAssets extends ConsumerWidget {
  const WalletAssets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allVisibleAssets = ref.watch(allVisibleAssetsProvider).toList();

    return Column(
      children: [
        AssetsHeader(),
        const SizedBox(height: 16),
        Flexible(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AssetItem(
                      asset: allVisibleAssets[index],
                      onSelected: (Asset asset) {
                        final walletMainArguments = ref.read(
                          uiStateArgsNotifierProvider,
                        );
                        ref
                            .read(uiStateArgsNotifierProvider.notifier)
                            .setWalletMainArguments(
                              walletMainArguments.copyWith(
                                navigationItemEnum:
                                    WalletMainNavigationItemEnum.assetDetails,
                              ),
                            );
                        ref
                            .read(selectedWalletAssetNotifierProvider.notifier)
                            .setState(asset);
                      },
                    ),
                  );
                }, childCount: allVisibleAssets.length),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
