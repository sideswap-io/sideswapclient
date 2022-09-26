import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class AssetDetailsHeader extends ConsumerWidget {
  const AssetDetailsHeader({
    super.key,
    required this.percent,
  });

  final double percent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dollarConversion = '0.0';
    final isAmp = ref.read(walletProvider).selectedWalletAsset!.account.isAmp();

    return Opacity(
      opacity: percent,
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final wallet = ref.watch(walletProvider);
              final account = wallet.selectedWalletAsset!;
              final asset = wallet.assets[account.asset];
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
          if (isAmp)
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Color(0xFF1C6086),
              ),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              margin: const EdgeInsets.all(8.0),
              child: const Text('AMP wallet',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  )),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Consumer(
              builder: (context, ref, child) {
                final wallet = ref.watch(walletProvider);
                final account = wallet.selectedWalletAsset!;
                final asset = wallet.assets[account.asset];
                final balance = ref.watch(balancesProvider).balances[account];

                final ticker = asset!.ticker;
                final precision = ref
                    .read(walletProvider)
                    .getPrecisionForAssetId(assetId: asset.assetId);
                final balanceStr =
                    '${amountStr(balance ?? 0, precision: precision)} $ticker';
                return Text(
                  balanceStr,
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
                final wallet = ref.watch(walletProvider);
                final account = wallet.selectedWalletAsset!;
                final asset = wallet.assets[account.asset];
                final precision = ref
                    .read(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final balance = double.tryParse(amountStr(
                      ref.read(balancesProvider).balances[account] ?? 0,
                      precision: precision,
                    )) ??
                    .0;
                final amountUsd = wallet.getAmountUsd(asset?.assetId, balance);
                dollarConversion = amountUsd.toStringAsFixed(2);
                dollarConversion = replaceCharacterOnPosition(
                    input: dollarConversion, currencyChar: '\$');
                final visibleConversion = ref
                    .read(walletProvider)
                    .isAmountUsdAvailable(asset?.assetId);

                return Text(
                  visibleConversion ? '≈ $dollarConversion' : '',
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
              final account = wallet.selectedWalletAsset!;
              final asset = wallet.assets[account.asset]!;
              final instantSwapVisible = (asset.swapMarket ||
                      asset.assetId == wallet.liquidAssetId()) &&
                  account.account == AccountType.reg;
              final isAmpAsset = wallet.ampAssets.contains(account.asset);
              final isAmpAccount = account.account == AccountType.amp;
              final balance = ref.read(balancesProvider).balances[account] ?? 0;
              final p2pSwapVisible = !asset.unregistered &&
                  (isAmpAsset == isAmpAccount) &&
                  // Token market swaps only allowed when balance is positive
                  (isAmpAsset || balance > 0);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButtonWithLabel(
                    onTap: () {
                      wallet.selectAssetReceive(account.account);
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
                        if (instantSwapVisible) {
                          ref.read(swapProvider).setSelectedLeftAsset(account);
                          ref.read(swapProvider).selectSwap();
                        } else {
                          if (balance > 0 || !account.account.isAmp()) {
                            ref.read(requestOrderProvider).receiveAssetId =
                                AccountAsset(
                                    AccountType.reg, wallet.liquidAssetId());
                            ref.read(requestOrderProvider).deliverAssetId =
                                account;
                          } else {
                            ref.read(requestOrderProvider).deliverAssetId =
                                AccountAsset(
                                    AccountType.reg, wallet.liquidAssetId());
                            ref.read(requestOrderProvider).receiveAssetId =
                                account;
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
