import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/common/screen_utils.dart';

class AssetSelectItem extends StatelessWidget {
  final Asset asset;
  AssetSelectItem({this.asset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        height: 71.h,
        child: Material(
          color: Color(0xFF135579),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              await context
                  .read(walletProvider)
                  .toggleAssetVisibility(asset.assetId);
            },
            child: AbsorbPointer(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Container(
                  child: Row(
                    children: [
                      Consumer(
                        builder: (context, watch, child) {
                          final _assetImagesBig =
                              watch(walletProvider).assetImagesBig;
                          return Container(
                            width: 45.w,
                            height: 45.w,
                            child: _assetImagesBig[asset.assetId],
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                asset.name,
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              asset.ticker,
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF6B91A8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Consumer(
                        builder: (context, watch, child) {
                          final _selected = watch(configProvider)
                              .disabledAssetIds
                              .contains(asset.assetId);
                          return FlutterSwitch(
                            value: !_selected,
                            onToggle: (val) {},
                            width: 51.h,
                            height: 31.h,
                            toggleSize: 27.h,
                            padding: 2.h,
                            activeColor: Color(0xFF00C5FF),
                            inactiveColor: Color(0xFF164D6A),
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
      ),
    );
  }
}
