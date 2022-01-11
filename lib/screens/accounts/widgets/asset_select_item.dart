import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class AssetSelectItem extends StatelessWidget {
  final AccountAsset account;
  const AssetSelectItem({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wallet = context.read(walletProvider);
    final assetImage = wallet.assetImagesBig[account.asset];
    final asset = wallet.assets[account.asset]!;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SizedBox(
        height: 71.h,
        child: Material(
          color: const Color(0xFF135579),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              await context.read(walletProvider).toggleAssetVisibility(account);
            },
            child: AbsorbPointer(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 45.w,
                      height: 45.w,
                      child: assetImage,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                asset.name,
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
                            Row(
                              children: [
                                Text(
                                  asset.ticker,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.roboto(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF6B91A8),
                                  ),
                                ),
                                if (account.account.isAmp()) const AmpFlag()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final wallet = context.read(walletProvider);
                        final _selected = !wallet.disabledAssetAccount(account);
                        return FlutterSwitch(
                          value: _selected,
                          disabled: false,
                          onToggle: (val) {},
                          width: 51.h,
                          height: 31.h,
                          toggleSize: 27.h,
                          padding: 2.h,
                          activeColor: const Color(0xFF00C5FF),
                          inactiveColor: const Color(0xFF164D6A),
                          toggleColor: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
