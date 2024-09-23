import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class AssetDetailsHeader extends ConsumerWidget {
  const AssetDetailsHeader({
    super.key,
    required this.percent,
  });

  final double percent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Opacity(
      opacity: percent,
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final selectedWalletAccountAsset =
                  ref.watch(selectedWalletAccountAssetNotifierProvider);
              final asset = ref.watch(assetsStateProvider.select(
                  (value) => value[selectedWalletAccountAsset?.assetId]));
              return Text(
                asset?.name ?? '',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Consumer(
            builder: (context, ref, child) {
              final isAmp = ref
                      .watch(selectedWalletAccountAssetNotifierProvider)
                      ?.account
                      .isAmp ??
                  false;

              if (isAmp) {
                return Container(
                  height: 20,
                  decoration: ShapeDecoration(
                    color: SideSwapColors.blumine,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'AMP wallet'.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.12,
                            color: SideSwapColors.brightTurquoise),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Consumer(
              builder: (context, ref, child) {
                final selectedWalletAccountAsset =
                    ref.watch(selectedWalletAccountAssetNotifierProvider);
                final assetBalance = ref.watch(
                    accountAssetBalanceStringProvider(
                        selectedWalletAccountAsset!));

                return Text(
                  assetBalance,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Consumer(
              builder: (context, ref, child) {
                final selectedWalletAccountAsset =
                    ref.watch(selectedWalletAccountAssetNotifierProvider);
                final defaultCurrencyAssetBalance = ref.watch(
                    accountAssetBalanceInDefaultCurrencyStringProvider(
                        selectedWalletAccountAsset!));
                final defaultCurrencyTicker =
                    ref.watch(defaultCurrencyTickerProvider);

                return Text(
                  '$defaultCurrencyTicker $defaultCurrencyAssetBalance',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B91A8),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Consumer(builder: (context, ref, child) {
              final wallet = ref.read(walletProvider);
              final selectedWalletAccountAsset =
                  ref.watch(selectedWalletAccountAssetNotifierProvider);

              final asset = ref.watch(assetsStateProvider.select(
                  (value) => value[selectedWalletAccountAsset?.assetId]));
              final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
              final instantSwapVisible = (asset?.swapMarket == true ||
                      asset?.assetId == liquidAssetId) &&
                  selectedWalletAccountAsset?.account == AccountType.reg;
              final isAmpAsset = ref
                  .watch(assetUtilsProvider)
                  .isAmpMarket(assetId: selectedWalletAccountAsset?.assetId);
              final isAmpAccount =
                  selectedWalletAccountAsset?.account == AccountType.amp;
              final balance = ref.read(
                      balancesNotifierProvider)[selectedWalletAccountAsset] ??
                  0;
              final p2pSwapVisible = !(asset?.unregistered == true) &&
                  (isAmpAsset == isAmpAccount) &&
                  // Token market swaps only allowed when balance is positive
                  (isAmpAsset || balance > 0);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButtonWithLabel(
                    onTap: () {
                      if (selectedWalletAccountAsset?.account == null) {
                        return;
                      }
                      wallet.selectAssetReceive(
                          selectedWalletAccountAsset!.account);
                      ref
                          .read(pageStatusNotifierProvider.notifier)
                          .setStatus(Status.generateWalletAddress);
                    },
                    label: 'Receive'.tr(),
                    buttonBackground: Colors.white,
                    child: SvgPicture.asset(
                      'assets/bottom_left_arrow.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  if (instantSwapVisible || p2pSwapVisible) ...[
                    Container(width: 32),
                    RoundedButtonWithLabel(
                      onTap: () {
                        if (selectedWalletAccountAsset == null) {
                          return;
                        }

                        if (instantSwapVisible) {
                          ref
                              .read(swapHelperProvider)
                              .setSelectedLeftAsset(selectedWalletAccountAsset);
                          ref.read(swapHelperProvider).selectSwap();
                        } else {
                          if (selectedWalletAccountAsset.account.isAmp) {
                            ref
                                .read(makeOrderSideStateProvider.notifier)
                                .setSide(MakeOrderSide.sell);
                            ref
                                .read(marketSelectedAccountAssetStateProvider
                                    .notifier)
                                .setSelectedAccountAsset(
                                    selectedWalletAccountAsset);
                          } else {
                            ref
                                .read(makeOrderSideStateProvider.notifier)
                                .setSide(MakeOrderSide.buy);
                            ref
                                .read(marketSelectedAccountAssetStateProvider
                                    .notifier)
                                .setSelectedAccountAsset(
                                    selectedWalletAccountAsset);
                          }
                          ref.read(walletProvider).setCreateOrderEntry();
                        }
                      },
                      label: 'Swap'.tr(),
                      buttonBackground: Colors.white,
                      child: SvgPicture.asset(
                        'assets/asset_swap_arrows.svg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                  Container(width: 32),
                  RoundedButtonWithLabel(
                    onTap: () {
                      ref.read(walletProvider).selectPaymentPage();
                    },
                    label: 'Send'.tr(),
                    buttonBackground: Colors.white,
                    child: SvgPicture.asset(
                      'assets/top_right_arrow.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
