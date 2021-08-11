import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class AssetDetailsHeader extends ConsumerWidget {
  const AssetDetailsHeader({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var _dollarConversion = '0.0';

    return Opacity(
      opacity: percent,
      child: Column(
        children: [
          Consumer(
            builder: (context, watch, child) {
              final wallet = watch(walletProvider);
              final asset = wallet.assets[wallet.selectedWalletAsset.isNotEmpty
                  ? wallet.selectedWalletAsset
                  : wallet.liquidAssetId()];
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
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Consumer(
              builder: (context, watch, child) {
                final wallet = watch(walletProvider);
                final balance = watch(balancesProvider).balances[
                    wallet.selectedWalletAsset.isNotEmpty
                        ? wallet.selectedWalletAsset
                        : wallet.liquidAssetId()];
                final asset = wallet.assets[
                    wallet.selectedWalletAsset.isNotEmpty
                        ? wallet.selectedWalletAsset
                        : wallet.liquidAssetId()];

                final ticker = asset?.ticker ?? kLiquidBitcoinTicker;
                final precision = context
                    .read(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
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
              builder: (context, watch, child) {
                final wallet = watch(walletProvider);
                final asset = wallet.assets[
                    wallet.selectedWalletAsset.isNotEmpty
                        ? wallet.selectedWalletAsset
                        : wallet.liquidAssetId()];
                final precision = context
                    .read(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final balance = double.tryParse(amountStr(
                      context.read(balancesProvider).balances[
                              wallet.selectedWalletAsset.isNotEmpty
                                  ? wallet.selectedWalletAsset
                                  : wallet.liquidAssetId()] ??
                          0,
                      precision: precision,
                    )) ??
                    .0;
                final amountUsd = wallet.getAmountUsd(asset?.assetId, balance);
                _dollarConversion = amountUsd.toStringAsFixed(2);
                _dollarConversion = replaceCharacterOnPosition(
                    input: _dollarConversion, currencyChar: '\$');
                final visibleConversion = context
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedButtonWithLabel(
                  onTap: () {
                    context.read(walletProvider).selectAssetReceive();
                  },
                  label: 'Receive'.tr(),
                  buttonBackground: Colors.white,
                  child: SvgPicture.asset(
                    'assets/bottom_left_arrow.svg',
                    width: 28.w,
                    height: 28.w,
                  ),
                ),
                Container(
                  width: 32.w,
                ),
                RoundedButtonWithLabel(
                  onTap: () {
                    context.read(walletProvider).selectPaymentPage();
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
            ),
          ),
        ],
      ),
    );
  }
}
