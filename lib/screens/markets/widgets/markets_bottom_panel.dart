import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/swap_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class MarketsBottomPanel extends ConsumerWidget {
  const MarketsBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.maxFinite,
      height: 102,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: SideSwapColors.chathamsBlueDark,
      ),
      child: Center(
        child: CustomBigButton(
          width: 343,
          height: 54,
          text: 'CREATE ORDER'.tr(),
          backgroundColor: SideSwapColors.brightTurquoise,
          onPressed: () {
            ref.read(walletProvider).setCreateOrderEntry();
          },
        ),
      ),
    );
  }
}

class MarketsBottomBuySellPanel extends ConsumerWidget {
  const MarketsBottomBuySellPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox(
      width: double.maxFinite,
      height: 59,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            BuySellButton(isSell: false),
            SizedBox(width: 16),
            BuySellButton(isSell: true),
          ],
        ),
      ),
    );
  }
}

class BuySellButton extends ConsumerWidget {
  const BuySellButton({
    super.key,
    required this.isSell,
  });

  final bool isSell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapMarketCurrentProduct =
        ref.watch(swapMarketCurrentProductProvider);
    final asset = ref.watch(assetsStateProvider.select(
        (value) => value[swapMarketCurrentProduct.accountAsset.assetId]));
    final accountAsset = AccountAsset(
        asset?.ampMarket == true ? AccountType.amp : AccountType.reg,
        asset?.assetId ?? '');

    return Expanded(
      child: CustomBigButton(
        height: 39,
        text: isSell ? 'SELL'.tr() : 'BUY'.tr(),
        textStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.32),
        backgroundColor: isSell ? sellColor : buyColor,
        onPressed: () {
          ref
              .read(makeOrderSideStateProvider.notifier)
              .setSide(isSell ? MakeOrderSide.sell : MakeOrderSide.buy);
          ref
              .read(marketSelectedAccountAssetStateProvider.notifier)
              .setSelectedAccountAsset(accountAsset);
          ref.read(walletProvider).setCreateOrderEntry();
        },
      ),
    );
  }
}
