import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/new_wallet_backup_skip_prompt_providers.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/wallet.dart';

class DNewWalletBackupSkipPrompt extends ConsumerWidget {
  const DNewWalletBackupSkipPrompt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skipForNow = ref.watch(skipForNowNotifierProvider);

    return SideSwapPopupPage(
      onClose: () {
        Navigator.of(context).pop();
      },
      backgroundContent: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(height: 640, child: DNewWalletBackupLogo()),
          Container(color: Colors.black.withValues(alpha: 0.5)),
        ],
      ),
      foregroundContent:
          skipForNow == const SkipForNowStateSkipped()
              ? Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              )
              : null,
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 401),
      content: Center(
        child: SizedBox(
          width: 484,
          height: 232,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SideSwapColors.chathamsBlue,
                      border: Border.all(
                        color: SideSwapColors.bitterSweet,
                        style: BorderStyle.solid,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/exclamationMark.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          SideSwapColors.bitterSweet,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: SizedBox(
                      width: 484,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Are you sure you wish to continue without first making a backup?'
                                  .tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                'SideSwap strongly recommends that you backup your wallet prior to holding any balances or your funds may be irretrievably lost forever'
                                    .tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        DCustomTextBigButton(
          width: 266,
          height: 49,
          onPressed:
              skipForNow == const SkipForNowStateEmpty()
                  ? () {
                    ref
                        .read(skipForNowNotifierProvider.notifier)
                        .setSkipState(const SkipForNowStateSkipped());
                    ref.read(walletProvider).loginAndLoadMainPage();
                  }
                  : null,
          child: const Text('SKIP FOR NOW').tr(),
        ),
        DCustomFilledBigButton(
          width: 266,
          height: 49,
          onPressed:
              skipForNow == const SkipForNowStateEmpty()
                  ? () {
                    ref.read(walletProvider).backupNewWalletEnable();
                  }
                  : null,
          child: const Text('BACKUP MY WALLET').tr(),
        ),
      ],
    );
  }
}
