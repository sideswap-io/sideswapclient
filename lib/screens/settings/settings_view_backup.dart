import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';

class SettingsViewBackup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Recovery phrase'.tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Text(
                  'Your 12 word recovery phrase is your wallets backup. Write it down and store it somewhere safe, preferably offline.'
                      .tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Column(
                  children: List<Widget>.generate(
                    4,
                    (rowIndex) => Consumer(
                      builder: (context, watch, child) {
                        final _words = watch(walletProvider).getMnemonicWords();

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MnemonicWord.disabled(
                                index: rowIndex * 3 + 0,
                                initialValue: _words == null
                                    ? ''
                                    : _words[rowIndex * 3 + 0],
                              ),
                              MnemonicWord.disabled(
                                index: rowIndex * 3 + 1,
                                initialValue: _words == null
                                    ? ''
                                    : _words[rowIndex * 3 + 1],
                              ),
                              MnemonicWord.disabled(
                                index: rowIndex * 3 + 2,
                                initialValue: _words == null
                                    ? ''
                                    : _words[rowIndex * 3 + 2],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
