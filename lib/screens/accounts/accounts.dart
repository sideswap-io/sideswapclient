import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/desktop/home/listeners/portfolio_prices_listener.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/selected_account_provider.dart';

import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/wallet_assets.dart';
import 'package:sideswap/screens/accounts/widgets/wallet_type_buttons.dart';

class Accounts extends HookConsumerWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tetherAssetId = ref.watch(tetherAssetIdStateProvider);

    useAsyncEffect(() async {
      ref
          .read(indexPriceSubscriberNotifierProvider.notifier)
          .subscribeOne(tetherAssetId);

      return;
    }, [tetherAssetId]);

    return Column(
      children: [
        const PortfolioPricesListener(),
        const ColoredBox(
          color: SideSwapColors.chathamsBlue,
          child: Padding(
            padding: EdgeInsets.only(top: 18, left: 16, right: 16),
            child: WalletTypeButtons(),
          ),
        ),
        Flexible(
          child: Stack(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final selectedAccountType =
                      ref.watch(selectedAccountTypeNotifierProvider);

                  final regularAssets =
                      ref.watch(regularVisibleAccountAssetsProvider);
                  final ampAssets = ref.watch(ampVisibleAccountAssetsProvider);

                  return switch (selectedAccountType) {
                    AccountType accountType when accountType.isRegular =>
                      WalletAssets(
                        accountAssets: regularAssets,
                      ),
                    _ => WalletAssets(accountAssets: ampAssets)
                  };
                },
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
