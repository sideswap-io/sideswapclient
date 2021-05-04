import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class WalletBackupCheckSucceed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Success!'.tr(),
        description:
            'Store your 12 words in a safe place and do not show anyone'.tr(),
        button: 'CONTINUE'.tr(),
        onPressed: () async {
          if (FlavorConfig.isProduction() &&
              FlavorConfig.instance.values.enableOnboardingUserFeatures) {
            await context.read(walletProvider).setImportAvatar();
          } else {
            await context.read(walletProvider).loginAndLoadMainPage();
          }
        },
      ),
    );
  }
}
