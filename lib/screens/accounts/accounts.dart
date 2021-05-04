import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';

class Accounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Accounts',
                  style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ).tr(),
                Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      final uiStateArgs = context.read(uiStateArgsProvider);
                      uiStateArgs.walletMainArguments =
                          uiStateArgs.walletMainArguments.copyWith(
                              navigationItem:
                                  WalletMainNavigationItem.assetSelect);

                      context.read(walletProvider).selectAvailableAssets();
                    },
                    borderRadius: BorderRadius.circular(21.w),
                    child: Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: SvgPicture.asset(
                              'assets/filter.svg',
                              width: 22.w,
                              height: 21.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Consumer(
                builder: (context, watch, child) {
                  final length = watch(walletProvider).enabledAssetIds.length;
                  return ListView(
                    children: List<Widget>.generate(
                      length,
                      (index) {
                        final assetId =
                            watch(walletProvider).enabledAssetIds[index];
                        final asset = watch(walletProvider).assets[assetId];
                        final balance = watch(walletProvider).balances[assetId];
                        return AccountItem(
                          asset: asset,
                          balance: balance,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
