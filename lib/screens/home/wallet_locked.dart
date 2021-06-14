import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';

class WalletLocked extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            context.read(walletProvider).unlockWallet();
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 92.h),
                    child: Container(
                      width: 158.w,
                      height: 158.w,
                      child: SvgPicture.asset('assets/logo.svg'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 236.h),
                    child: Icon(
                      Icons.fingerprint,
                      size: 46.h,
                      color: Color(0xFFC6E8FD),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text(
                      'Touch to unlock'.tr(),
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFC6E8FD),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
