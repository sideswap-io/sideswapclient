import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class AssetDetailsHeader extends ConsumerWidget {
  const AssetDetailsHeader({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _dollarConversion = '0.0';
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
                style: GoogleFonts.roboto(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            },
          ),
          if (isAmp)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.w),
                ),
                color: const Color(0xFF1C6086),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 6.w,
                horizontal: 8.w,
              ),
              margin: const EdgeInsets.all(8.0),
              child: Text('AMP wallet',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  )),
            ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
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
                  style: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
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
                _dollarConversion = amountUsd.toStringAsFixed(2);
                _dollarConversion = replaceCharacterOnPosition(
                    input: _dollarConversion, currencyChar: '\$');
                final visibleConversion = ref
                    .read(walletProvider)
                    .isAmountUsdAvailable(asset?.assetId);

                return Text(
                  visibleConversion ? '≈ $_dollarConversion' : '',
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6B91A8),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: Consumer(builder: (context, ref, child) {
              final wallet = ref.read(walletProvider);
              final account = wallet.selectedWalletAsset!;
              final asset = wallet.assets[account.asset]!;
              final instantSwapVisible = (asset.swapMarket ||
                      asset.assetId == wallet.liquidAssetId()) &&
                  account.account == AccountType.regular;
              final isAmpAsset = wallet.ampAssets.contains(account.asset);
              final isAmpAccount = account.account == AccountType.amp;
              final p2pSwapVisible =
                  !asset.unregistered && (isAmpAsset == isAmpAccount);
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
                      width: 28.w,
                      height: 28.w,
                    ),
                  ),
                  if (instantSwapVisible || p2pSwapVisible) ...[
                    Container(
                      width: 32.w,
                    ),
                    RoundedButtonWithLabel(
                      onTap: () {
                        if (instantSwapVisible) {
                          ref.read(swapProvider).setSelectedLeftAsset(account);
                          ref.read(swapProvider).selectSwap();
                        } else {
                          ref.read(requestOrderProvider).deliverAssetId =
                              account;
                          ref.read(walletProvider).setCreateOrderEntry();
                        }
                      },
                      label: 'Swap'.tr(),
                      buttonBackground: Colors.white,
                      child: SvgPicture.asset(
                        'assets/asset_swap_arrows.svg',
                        width: 28.w,
                        height: 28.w,
                      ),
                    ),
                  ],
                  Container(
                    width: 32.w,
                  ),
                  RoundedButtonWithLabel(
                    onTap: () {
                      ref.read(walletProvider).selectPaymentPage();
                    },
                    label: 'Send'.tr(),
                    buttonBackground: Colors.white,
                    child: SvgPicture.asset(
                      'assets/top_right_arrow.svg',
                      width: 28.w,
                      height: 28.w,
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
