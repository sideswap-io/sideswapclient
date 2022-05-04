import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_error_icon.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo_background.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/models/wallet.dart';

class DNewWalletBackupCheckFailed extends ConsumerWidget {
  const DNewWalletBackupCheckFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).newWalletBackupPrompt();
      },
      backgroundContent: const DNewWalletBackupLogoBackground(),
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 418),
      content: Center(
        child: Column(
          children: [
            const DErrorIcon(),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                'Oops!'.tr(),
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
                'Your wallet could not be re-created. Please ensure the words exactly matches your recovery seed.'
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DCustomTextBigButton(
              width: 266,
              onPressed: () {
                ref.read(walletProvider).backupNewWalletEnable();
              },
              child: Text(
                'SEE MY 12 WORDS AGAIN'.tr(),
              ),
            ),
            DCustomFilledBigButton(
              width: 266,
              onPressed: () {
                ref.read(walletProvider).backupNewWalletCheck();
              },
              child: Text(
                'RETRY'.tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
