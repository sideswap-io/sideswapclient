import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/common/screen_utils.dart';

class AccountItem extends ConsumerWidget {
  final Asset asset;
  final int balance;
  AccountItem({this.asset, this.balance});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        height: 80.h,
        child: FlatButton(
          color: Color(0xFF135579),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () {
            final uiStateArgs = context.read(uiStateArgsProvider);
            uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments
                .copyWith(
                    navigationItem: WalletMainNavigationItem.assetDetails);
            context.read(walletProvider).selectAssetDetails(asset.ticker);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  child: watch(walletProvider).assetImagesBig[asset.ticker],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 14.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                asset.name,
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                amountStr(balance ?? 0),
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              asset.ticker,
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF6B91A8),
                              ),
                            ),
                          ],
                        )
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
