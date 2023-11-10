import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class WalletBackupCheckSucceed extends ConsumerWidget {
  const WalletBackupCheckSucceed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        buttonText: 'CONTINUE'.tr(),
        onPressed: () {
          if (FlavorConfig.isProduction &&
              FlavorConfig.enableOnboardingUserFeatures) {
            ref.read(walletProvider).setImportAvatar();
          } else {
            ref.read(walletProvider).loginAndLoadMainPage();
          }
        },
      ),
    );
  }
}
