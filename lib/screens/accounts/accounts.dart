import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';
import 'package:sideswap/screens/accounts/widgets/csv_export_button.dart';
import 'package:sideswap/screens/accounts/widgets/providers/accounts_providers.dart';

class Accounts extends HookConsumerWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Assets'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const CsvExportButton(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final walletMainArguments =
                        ref.read(uiStateArgsNotifierProvider);
                    ref
                        .read(uiStateArgsNotifierProvider.notifier)
                        .setWalletMainArguments(
                          walletMainArguments.copyWith(
                            navigationItemEnum:
                                WalletMainNavigationItemEnum.assetSelect,
                          ),
                        );
                    ref.read(walletProvider).selectAvailableAssets();
                  },
                  borderRadius: BorderRadius.circular(21),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: SvgPicture.asset(
                            'assets/filter.svg',
                            width: 22,
                            height: 21,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Consumer(
                  builder: (context, ref, child) {
                    final availableAssets =
                        ref.watch(mobileAvailableAssetsProvider);

                    return ListView.builder(
                      itemCount: availableAssets.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AccountItem(
                            accountAsset: availableAssets[index],
                            onSelected: (AccountAsset value) {
                              final walletMainArguments =
                                  ref.read(uiStateArgsNotifierProvider);
                              ref
                                  .read(uiStateArgsNotifierProvider.notifier)
                                  .setWalletMainArguments(
                                    walletMainArguments.copyWith(
                                      navigationItemEnum:
                                          WalletMainNavigationItemEnum
                                              .assetDetails,
                                    ),
                                  );
                              ref
                                  .read(walletProvider)
                                  .selectAssetDetails(availableAssets[index]);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final syncComplete = ref.watch(syncCompleteStateProvider);
                  return switch (syncComplete) {
                    false => const Center(
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    _ => const SizedBox(),
                  };
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
