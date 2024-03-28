import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class DNewWalletBackupPrompt extends HookConsumerWidget {
  const DNewWalletBackupPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    style: const TextStyle(
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
                  height: 60,
                  child: Text(
                    'Protect your assets by ensuring you save the 12 word recovery phrase which can restore your wallet'
                        .tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                  width: 266,
                  height: 49,
                  onPressed: () {
                    ref.read(walletProvider).backupNewWalletEnable();
                  },
                  child: Text('YES'.tr()),
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
