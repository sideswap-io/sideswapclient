import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

void showWalletBackupDialog(WidgetRef ref, BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), //this right here
        child: Container(
          width: 343,
          height: 478,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: Color(0xFF1C6086),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF135579),
                    border: Border.all(
                      color: const Color(0xFFFF7878),
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/exclamationMark.svg',
                      width: 20,
                      height: 22,
                      color: const Color(0xFFFF7878),
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
                  backgroundColor: const Color(0xFF00C5FF),
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
}
