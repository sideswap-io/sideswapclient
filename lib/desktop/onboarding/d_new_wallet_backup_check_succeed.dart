import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo_background.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_success_icon.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/models/wallet.dart';

class DNewWalletBackupCheckSucceed extends ConsumerWidget {
  const DNewWalletBackupCheckSucceed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).loginAndLoadMainPage();
      },
      constraints: const BoxConstraints(
        maxWidth: 628,
        maxHeight: 437,
      ),
      backgroundContent: const DNewWalletBackupLogoBackground(),
      content: Center(
        child: Column(
          children: [
            const DSuccessIcon(),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                'Success!'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 36, right: 36),
              child: Text(
                'Please take every caution to protect and maintain your wallet seed. Your seed will enable you to restore your wallet in case your PIN is forgotten or your device is lost. Do not share it with anyone.'
                    .tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 95,
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: DCustomFilledBigButton(
            onPressed: () {
              ref.read(walletProvider).loginAndLoadMainPage();
            },
            child: Text(
              'CONTINUE'.tr(),
            ),
          ),
        ),
      ],
    );
  }
}
