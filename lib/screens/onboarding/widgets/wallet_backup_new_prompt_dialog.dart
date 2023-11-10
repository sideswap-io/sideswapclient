import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/new_wallet_backup_skip_prompt_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

void showWalletBackupDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, _) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 343,
              height: 485,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: SideSwapColors.blumine,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 30, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
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
                          width: 20,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                              SideSwapColors.bitterSweet, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        'Are you sure you wish to continue without first making a backup?'
                            .tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomBigButton(
                      width: 279,
                      height: 54,
                      text: 'BACKUP MY WALLET'.tr(),
                      backgroundColor: SideSwapColors.brightTurquoise,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();

                        ref.read(walletProvider).backupNewWalletEnable();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 14),
                      child: CustomBigButton(
                        width: 279,
                        height: 54,
                        text: 'SKIP FOR NOW'.tr(),
                        backgroundColor: Colors.transparent,
                        onPressed: () {
                          ref
                              .read(skipForNowNotifierProvider.notifier)
                              .setSkipState(const SkipForNowStateSkipped());

                          Navigator.of(context, rootNavigator: true).pop();

                          if (FlavorConfig.isProduction &&
                              FlavorConfig.enableOnboardingUserFeatures) {
                            ref.read(walletProvider).setImportAvatar();
                          } else {
                            ref.read(walletProvider).loginAndLoadMainPage();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
