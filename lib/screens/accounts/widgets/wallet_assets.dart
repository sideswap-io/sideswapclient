import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';
import 'package:sideswap/screens/accounts/widgets/assets_header.dart';

class WalletAssets extends ConsumerWidget {
  const WalletAssets({super.key, required this.accountAssets});

  final List<AccountAsset> accountAssets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AssetsHeader(accountAssets: accountAssets),
        const SizedBox(height: 16),
        Flexible(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountItem(
                      accountAsset: accountAssets[index],
                      onSelected: (AccountAsset value) {
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
                            .read(walletProvider)
                            .selectAssetDetails(accountAssets[index]);
                      },
                    ),
                  );
                }, childCount: accountAssets.length),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
