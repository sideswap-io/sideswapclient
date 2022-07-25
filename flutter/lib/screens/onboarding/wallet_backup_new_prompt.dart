import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';
import 'package:sideswap/screens/onboarding/widgets/wallet_backup_new_prompt_dialog.dart';

class WalletBackupNewPrompt extends ConsumerWidget {
  const WalletBackupNewPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // clear pin new wallet state
    ref.read(pinSetupProvider).isNewWallet = false;

    return SideSwapScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 56),
                    child: SvgPicture.asset(
                      'assets/shield_big.svg',
                      width: 182,
                      height: 202,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 113),
                    child: SvgPicture.asset(
                      'assets/locker.svg',
                      width: 54,
                      height: 73,
                    ),
                  ),
                ),
              ],
            ),
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
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: PageDots(
                maxSelectedDots:
                    FlavorConfig.enableOnboardingUserFeatures ? 1 : 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                text: 'YES'.tr(),
                backgroundColor: const Color(0xFF00C5FF),
                onPressed: () {
                  ref.read(walletProvider).backupNewWalletEnable();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54,
                  text: 'NOT NOW'.tr(),
                  textColor: const Color(0xFF00C5FF),
                  backgroundColor: Colors.transparent,
                  onPressed: () async {
                    showWalletBackupDialog(ref, context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
