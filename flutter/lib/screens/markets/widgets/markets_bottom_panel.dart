import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/swap_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

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
    final swapMarket = ref.watch(swapMarketProvider);
    final asset = ref.watch(assetsStateProvider
        .select((value) => value[swapMarket.currentProduct.assetId]));
    final isToken = !(asset?.swapMarket == true) && !(asset?.ampMarket == true);

    return Container(
      width: double.maxFinite,
      height: 70,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: SideSwapColors.chathamsBlueDark,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            ...!isToken
                ? [
                    const BuySellButton(isSell: false),
                    const SizedBox(width: 16)
                  ]
                : [],
            const BuySellButton(isSell: true),
          ],
        ),
      ),
    );
  }
}

class BuySellButton extends ConsumerWidget {
  const BuySellButton({
    Key? key,
    required this.isSell,
  }) : super(key: key);

  final bool isSell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestOrder = ref.watch(requestOrderProvider);
    final swapMarket = ref.watch(swapMarketProvider);
    final wallet = ref.watch(walletProvider);
    final liquidAssetId = ref.watch(liquidAssetIdProvider);
    final bitcoinAccount = AccountAsset(AccountType.reg, liquidAssetId);
    final asset = ref.watch(assetsStateProvider
        .select((value) => value[swapMarket.currentProduct.assetId]));
    final assetAccount = AccountAsset(
        asset?.ampMarket == true ? AccountType.amp : AccountType.reg,
        asset?.assetId ?? '');
    final sendBitcoin = isSell == asset?.swapMarket;
    final deliverAsset = sendBitcoin ? bitcoinAccount : assetAccount;
    final receiveAsset = sendBitcoin ? assetAccount : bitcoinAccount;
    final deliverBalance =
        ref.watch(balancesProvider).balances[deliverAsset] ?? 0;
    final isTokenMarket =
        !(asset?.ampMarket == true) && !(asset?.swapMarket == true);
    final enabled = deliverBalance > 0 && (!isTokenMarket || isSell);
    return Expanded(
      child: CustomBigButton(
        height: 40,
        text: isSell ? 'SELL'.tr() : 'BUY'.tr(),
        backgroundColor:
            enabled ? (isSell ? sellColor : buyColor) : const Color(0xFF0E4D72),
        onPressed: enabled
            ? () {
                requestOrder.deliverAssetId = deliverAsset;
                requestOrder.receiveAssetId = receiveAsset;
                wallet.setCreateOrderEntry();
              }
            : null,
      ),
    );
  }
}
