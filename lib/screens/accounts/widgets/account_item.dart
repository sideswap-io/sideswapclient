import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class AccountItem extends ConsumerWidget {
  final Asset? asset;
  final int balance;
  AccountItem({this.asset, this.balance = 0});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final assetImage = watch(walletProvider).assetImagesBig[asset?.assetId];
    final precision = context
        .read(walletProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);
    final amountString = amountStr(
      context.read(balancesProvider).balances[asset?.assetId] ?? 0,
      precision: precision,
    );
    final amount = precision == 0
        ? int.tryParse(amountString) ?? 0
        : double.tryParse(amountString) ?? .0;
    final amountUsd =
        context.read(walletProvider).getAmountUsd(asset?.assetId, amount);
    var _dollarConversion = '0.0';
    _dollarConversion = amountUsd.toStringAsFixed(2);
    _dollarConversion = replaceCharacterOnPosition(
        input: _dollarConversion, currencyChar: '\$');

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        height: 80.h,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF135579),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            final uiStateArgs = context.read(uiStateArgsProvider);
            uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
                .copyWith(
                    navigationItem: WalletMainNavigationItem.assetDetails);
            if (asset?.assetId != null) {
              context.read(walletProvider).selectAssetDetails(asset!.assetId);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  child: assetImage,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Container(
                    width: 257.w,
                    height: 48.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                asset?.name ?? '',
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Text(
                                amountString,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              asset?.ticker ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF6B91A8),
                              ),
                            ),
                            if (amountUsd != 0) ...[
                              Text(
                                '≈ $_dollarConversion',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6B91A8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
