import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class DNewWalletBackupPrompt extends ConsumerWidget {
  const DNewWalletBackupPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // clear pin new wallet state
    ref.read(pinSetupProvider).isNewWallet = false;

    return SideSwapScaffoldPage(
      content: Center(
        child: SizedBox(
          height: 640,
          child: Column(
            children: [
              const DNewWalletBackupLogo(),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Do you wish to backup your wallet?'.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: 428,
                  height: 44,
                  child: Text(
                    'Protect your assets by ensuring you save the 12 work recovery phrase which can restore your wallet'
                        .tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: PageDots(
                  maxSelectedDots: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: DCustomFilledBigButton(
                  child: Text('YES'.tr()),
                  width: 266,
                  height: 49,
                  onPressed: () {
                    ref.read(walletProvider).backupNewWalletEnable();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DCustomTextBigButton(
                  width: 266,
                  height: 49,
                  child: Text('NOT NOW'.tr()),
                  onPressed: () async {
                    Navigator.of(context)
                        .pushNamed('/newWalletBackupSkipPrompt');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
