import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/asset_search_text_field.dart';
import 'package:sideswap/screens/accounts/widgets/asset_select_item.dart';

class AssetSelectList extends ConsumerWidget {
  const AssetSelectList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Asset list'.tr(),
        onPressed: () {
          final uiStateArgs = ref.read(uiStateArgsProvider);
          uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
              .copyWith(navigationItem: WalletMainNavigationItem.accounts);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18, bottom: 29),
                child: AssetSearchTextField(),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final filteredToggleAccounts =
                        ref.watch(walletProvider).filteredToggleAccounts;
                    return ListView(
                      shrinkWrap: true,
                      children: List<Widget>.generate(
                        filteredToggleAccounts.length,
                        (index) {
                          final account = filteredToggleAccounts[index];
                          return AssetSelectItem(account: account);
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
    );
  }
}
