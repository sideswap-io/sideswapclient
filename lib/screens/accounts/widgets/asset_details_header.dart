import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class AssetDetailsHeader extends HookConsumerWidget {
  const AssetDetailsHeader({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(marketSubscribedAssetPairNotifierProvider, (_, _) {});
    ref.listen(marketPublicOrdersNotifierProvider, (_, _) {});

    final optionSelectedAsset = ref.watch(selectedWalletAssetNotifierProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final marketsInfo = ref.watch(marketsNotifierProvider);
    final assetsState = ref.watch(assetsStateProvider);
    final walletMainArguments = ref.watch(uiStateArgsNotifierProvider);

    final swapButtonCallback = useCallback(
      () {
        optionSelectedAsset.match(() {}, (asset) {
          if (asset.assetId != liquidAssetId) {
            if (asset.swapMarket == true) {
              final marketInfo = marketsInfo.firstWhereOrNull(
                (e) => e.assetPair.quote == asset.assetId,
              );
              if (marketInfo != null) {
                final quoteAsset = assetsState[marketInfo.assetPair.quote];
                if (quoteAsset != null) {
                  ref
                      .read(marketSubscribedAssetPairNotifierProvider.notifier)
                      .setState(marketInfo.assetPair);
                }
              }
            }

            if (asset.ampMarket == true ||
                (asset.ampMarket == false && asset.swapMarket == false)) {
              final marketInfo = marketsInfo.firstWhereOrNull(
                (e) => e.assetPair.base == asset.assetId,
              );
              if (marketInfo != null) {
                final baseAsset = assetsState[marketInfo.assetPair.base];
                if (baseAsset != null) {
                  ref
                      .read(marketSubscribedAssetPairNotifierProvider.notifier)
                      .setState(marketInfo.assetPair);
                }
              }
            }
          }

          ref
              .read(selectedMarketTypeButtonNotifierProvider.notifier)
              .setSelectedMarketType(SelectedMarketTypeButtonEnum.swap);
          final newWalletMainArguments = walletMainArguments.copyWith(
            currentIndex: 2,
            navigationItemEnum: WalletMainNavigationItemEnum.markets,
          );
          ref
              .read(uiStateArgsNotifierProvider.notifier)
              .setWalletMainArguments(newWalletMainArguments);
        });
      },
      [
        optionSelectedAsset,
        liquidAssetId,
        marketsInfo,
        assetsState,
        walletMainArguments,
      ],
    );

    return optionSelectedAsset.match(
      () => const SizedBox(),
      (asset) => Opacity(
        opacity: percent,
        child: Column(
          children: [
            Text(
              asset.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Consumer(
                builder: (context, ref, child) {
                  final assetBalance = ref.watch(
                    assetBalanceStringProvider(asset),
                  );

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
                  final defaultCurrencyAssetBalance = ref.watch(
                    assetBalanceInDefaultCurrencyStringProvider(asset),
                  );
                  final defaultCurrencyTicker = ref.watch(
                    defaultCurrencyTickerProvider,
                  );

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
              child: Consumer(
                builder: (context, ref, child) {
                  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
                  final instantSwapVisible =
                      (asset.swapMarket == true ||
                          asset.assetId == liquidAssetId) &&
                      !asset.ampMarket;
                  final balance = ref.read(
                    availableBalanceForAssetIdProvider(asset.assetId),
                  );
                  final p2pSwapVisible =
                      !(asset.unregistered == true) &&
                      // Token market swaps only allowed when balance is positive
                      (asset.ampMarket || balance > 0);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedButtonWithLabel(
                        onTap: () {
                          ref
                              .read(walletProvider)
                              .selectAssetReceive(
                                asset.ampMarket ? Account.AMP_ : Account.REG,
                              );
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
                            swapButtonCallback();
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
