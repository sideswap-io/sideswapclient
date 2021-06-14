import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_check_row.dart';

class WalletBackupCheck extends StatefulWidget {
  @override
  _WalletBackupCheckState createState() => _WalletBackupCheckState();
}

class _WalletBackupCheckState extends State<WalletBackupCheck> {
  bool _canContinue = false;

  void validate(BuildContext context) {
    final selectedWords = context.read(walletProvider).backupCheckSelectedWords;

    setState(() {
      _canContinue = selectedWords.length == 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      enableInsideTopPadding: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 38.h),
            child: Container(
              width: 303.w,
              height: 29.h,
              child: Text(
                'Select the correct word'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Consumer(
              builder: (context, watch, child) {
                final wordIndices =
                    watch(walletProvider).backupCheckAllWords.keys.toList();

                return Column(
                  children: List<Widget>.generate(
                    wordIndices.length,
                    (int index) {
                      final wordIndex = wordIndices[index];
                      final words = context
                              .read(walletProvider)
                              .backupCheckAllWords[wordIndex] ??
                          [];
                      return Padding(
                        padding: EdgeInsets.only(top: 32.h),
                        child: MnemonicCheckRow(
                          wordIndex: wordIndex,
                          words: words,
                          onTap: (index) {
                            context
                                .read(walletProvider)
                                .backupNewWalletSelect(wordIndex, index);
                            validate(context);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: CustomBigButton(
              height: 54.h,
              width: double.maxFinite,
              text: 'CONFIRM'.tr(),
              backgroundColor: Color(0xFF00C5FF),
              onPressed: _canContinue
                  ? () {
                      context.read(walletProvider).backupNewWalletVerify();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
